{ config, lib, pkgs, ... }:

let
  lanInterface = "wlp2s0";
  protonInterface = "proton";
  protonConfigFile = "/etc/wireguard/proton.conf";
  protonGateway = "10.2.0.1";
  protonRoutingTable = "24680";
  qbServiceName = config.services.qbittorrent.user;

  protonConfigCheck = pkgs.writeShellScript "proton-config-check" ''
    set -eu

    if ! grep -Eq '^[[:space:]]*Table[[:space:]]*=[[:space:]]*off([[:space:]]*|#.*)$' ${lib.escapeShellArg protonConfigFile}; then
      echo "Expected ${protonConfigFile} to contain 'Table = off' so Proton does not replace the host default route." >&2
      exit 1
    fi
  '';

  protonPolicyRouting = pkgs.writeShellScript "proton-policy-routing" ''
    set -eu

    qb_uid="$(${pkgs.coreutils}/bin/id -u ${lib.escapeShellArg qbServiceName})"

    ${pkgs.iproute2}/bin/ip -4 route replace default dev ${protonInterface} table ${protonRoutingTable}
    ${pkgs.iproute2}/bin/ip -4 rule add uidrange "$qb_uid-$qb_uid" table ${protonRoutingTable} priority 10000 2>/dev/null || true

    if ${pkgs.iproute2}/bin/ip -6 addr show dev ${protonInterface} scope global | ${pkgs.gnugrep}/bin/grep -q 'inet6 '; then
      ${pkgs.iproute2}/bin/ip -6 route replace default dev ${protonInterface} table ${protonRoutingTable}
      ${pkgs.iproute2}/bin/ip -6 rule add uidrange "$qb_uid-$qb_uid" table ${protonRoutingTable} priority 10000 2>/dev/null || true
    fi
  '';

  protonPolicyRoutingStop = pkgs.writeShellScript "proton-policy-routing-stop" ''
    set -eu

    qb_uid="$(${pkgs.coreutils}/bin/id -u ${lib.escapeShellArg qbServiceName})"

    ${pkgs.iproute2}/bin/ip -4 rule del uidrange "$qb_uid-$qb_uid" table ${protonRoutingTable} priority 10000 2>/dev/null || true
    ${pkgs.iproute2}/bin/ip -4 route flush table ${protonRoutingTable} 2>/dev/null || true

    ${pkgs.iproute2}/bin/ip -6 rule del uidrange "$qb_uid-$qb_uid" table ${protonRoutingTable} priority 10000 2>/dev/null || true
    ${pkgs.iproute2}/bin/ip -6 route flush table ${protonRoutingTable} 2>/dev/null || true
  '';

  protonNatpmp = pkgs.writeShellScript "proton-natpmp" ''
    set -eu

    runtime_dir="/run/proton-natpmp"
    port_file="$runtime_dir/forwarded-port"
    last_port=""
    applied_port=""

    api_ready() {
      ${pkgs.curl}/bin/curl --silent --show-error --fail --max-time 5 \
        http://127.0.0.1:${toString config.services.qbittorrent.webuiPort}/api/v2/app/version >/dev/null
    }

    update_qbittorrent_port() {
      port="$1"
      json='{"listen_port":'"$port"',"upnp":false,"web_ui_upnp":false}'

      ${pkgs.curl}/bin/curl --silent --show-error --fail --max-time 5 \
        --data-urlencode "json=$json" \
        http://127.0.0.1:${toString config.services.qbittorrent.webuiPort}/api/v2/app/setPreferences >/dev/null
    }

    allow_port() {
      port="$1"
      ${pkgs.iptables}/bin/iptables -C INPUT -i ${protonInterface} -p tcp --dport "$port" -j ACCEPT 2>/dev/null || \
        ${pkgs.iptables}/bin/iptables -I INPUT 1 -i ${protonInterface} -p tcp --dport "$port" -j ACCEPT
      ${pkgs.iptables}/bin/iptables -C INPUT -i ${protonInterface} -p udp --dport "$port" -j ACCEPT 2>/dev/null || \
        ${pkgs.iptables}/bin/iptables -I INPUT 1 -i ${protonInterface} -p udp --dport "$port" -j ACCEPT
    }

    drop_port() {
      port="$1"
      ${pkgs.iptables}/bin/iptables -D INPUT -i ${protonInterface} -p tcp --dport "$port" -j ACCEPT 2>/dev/null || true
      ${pkgs.iptables}/bin/iptables -D INPUT -i ${protonInterface} -p udp --dport "$port" -j ACCEPT 2>/dev/null || true
    }

    while true; do
      tcp_output="$(${pkgs.util-linux}/bin/runuser -u ${lib.escapeShellArg qbServiceName} -- \
        ${pkgs.libnatpmp}/bin/natpmpc -a 1 0 tcp 60 -g ${protonGateway})"
      udp_output="$(${pkgs.util-linux}/bin/runuser -u ${lib.escapeShellArg qbServiceName} -- \
        ${pkgs.libnatpmp}/bin/natpmpc -a 1 0 udp 60 -g ${protonGateway})"

      port="$(
        printf '%s\n%s\n' "$tcp_output" "$udp_output" | \
          ${pkgs.gnused}/bin/sed -n 's/.*Mapped public port \([0-9][0-9]*\).*/\1/p' | \
          ${pkgs.coreutils}/bin/head -n 1
      )"

      if [ -z "$port" ]; then
        echo "Unable to parse Proton forwarded port from natpmpc output" >&2
        echo "$tcp_output" >&2
        echo "$udp_output" >&2
        exit 1
      fi

      if [ "$port" != "$last_port" ]; then
        if [ -n "$last_port" ]; then
          drop_port "$last_port"
        fi

        allow_port "$port"
        printf '%s\n' "$port" > "$port_file"

        last_port="$port"
      elif [ ! -f "$port_file" ]; then
        printf '%s\n' "$port" > "$port_file"
      fi

      if [ "$port" != "$applied_port" ] && api_ready; then
        update_qbittorrent_port "$port"
        applied_port="$port"
      fi

      sleep 45
    done
  '';

  protonNatpmpStop = pkgs.writeShellScript "proton-natpmp-stop" ''
    set -eu

    port_file="/run/proton-natpmp/forwarded-port"
    if [ -f "$port_file" ]; then
      port="$(${pkgs.coreutils}/bin/cat "$port_file")"
      ${pkgs.iptables}/bin/iptables -D INPUT -i ${protonInterface} -p tcp --dport "$port" -j ACCEPT 2>/dev/null || true
      ${pkgs.iptables}/bin/iptables -D INPUT -i ${protonInterface} -p udp --dport "$port" -j ACCEPT 2>/dev/null || true
    fi
  '';
in
{
  systemd.tmpfiles.rules = [
    "d /etc/wireguard 0700 root root -"
  ];

  environment.systemPackages = with pkgs; [
    libnatpmp
  ];

  networking.firewall = {
    checkReversePath = "loose";
    extraCommands = ''
      ${pkgs.iptables}/bin/iptables -C OUTPUT -m owner --uid-owner ${qbServiceName} -o lo -j ACCEPT 2>/dev/null || \
        ${pkgs.iptables}/bin/iptables -I OUTPUT 1 -m owner --uid-owner ${qbServiceName} -o lo -j ACCEPT
      ${pkgs.iptables}/bin/iptables -C OUTPUT -m owner --uid-owner ${qbServiceName} -o ${protonInterface} -j ACCEPT 2>/dev/null || \
        ${pkgs.iptables}/bin/iptables -I OUTPUT 2 -m owner --uid-owner ${qbServiceName} -o ${protonInterface} -j ACCEPT
      ${pkgs.iptables}/bin/iptables -C OUTPUT -m owner --uid-owner ${qbServiceName} -j REJECT 2>/dev/null || \
        ${pkgs.iptables}/bin/iptables -A OUTPUT -m owner --uid-owner ${qbServiceName} -j REJECT

      ${pkgs.iptables}/bin/ip6tables -C OUTPUT -m owner --uid-owner ${qbServiceName} -o lo -j ACCEPT 2>/dev/null || \
        ${pkgs.iptables}/bin/ip6tables -I OUTPUT 1 -m owner --uid-owner ${qbServiceName} -o lo -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -C OUTPUT -m owner --uid-owner ${qbServiceName} -o ${protonInterface} -j ACCEPT 2>/dev/null || \
        ${pkgs.iptables}/bin/ip6tables -I OUTPUT 2 -m owner --uid-owner ${qbServiceName} -o ${protonInterface} -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -C OUTPUT -m owner --uid-owner ${qbServiceName} -j REJECT 2>/dev/null || \
        ${pkgs.iptables}/bin/ip6tables -A OUTPUT -m owner --uid-owner ${qbServiceName} -j REJECT
    '';
    extraStopCommands = ''
      ${pkgs.iptables}/bin/iptables -D OUTPUT -m owner --uid-owner ${qbServiceName} -o lo -j ACCEPT 2>/dev/null || true
      ${pkgs.iptables}/bin/iptables -D OUTPUT -m owner --uid-owner ${qbServiceName} -o ${protonInterface} -j ACCEPT 2>/dev/null || true
      ${pkgs.iptables}/bin/iptables -D OUTPUT -m owner --uid-owner ${qbServiceName} -j REJECT 2>/dev/null || true

      ${pkgs.iptables}/bin/ip6tables -D OUTPUT -m owner --uid-owner ${qbServiceName} -o lo -j ACCEPT 2>/dev/null || true
      ${pkgs.iptables}/bin/ip6tables -D OUTPUT -m owner --uid-owner ${qbServiceName} -o ${protonInterface} -j ACCEPT 2>/dev/null || true
      ${pkgs.iptables}/bin/ip6tables -D OUTPUT -m owner --uid-owner ${qbServiceName} -j REJECT 2>/dev/null || true
    '';
    interfaces.${lanInterface}.allowedTCPPorts = [ config.services.qbittorrent.webuiPort ];
  };

  networking.wg-quick.interfaces.${protonInterface} = {
    autostart = true;
    configFile = protonConfigFile;
  };

  services.qbittorrent = {
    enable = true;
    package = pkgs.qbittorrent-nox;
    webuiPort = 8080;
    extraArgs = [ "--confirm-legal-notice" ];
    serverConfig = {
      LegalNotice.Accepted = true;
      Preferences = {
        Connection = {
          Interface = protonInterface;
          InterfaceName = protonInterface;
          UPnP = false;
        };
        WebUI = {
          Address = "*";
          CSRFProtection = true;
          ClickjackingProtection = true;
          HostHeaderValidation = true;
          LocalHostAuth = false;
          SecureCookie = true;
          UseUPnP = false;
        };
      };
    };
  };

  systemd.services.proton-config-check = {
    description = "Validate the runtime Proton WireGuard config";
    before = [ "wg-quick-proton.service" ];
    requiredBy = [ "wg-quick-proton.service" ];
    unitConfig.ConditionPathExists = protonConfigFile;
    serviceConfig = {
      Type = "oneshot";
      ExecStart = protonConfigCheck;
    };
  };

  systemd.services.proton-policy-routing = {
    description = "Route qBittorrent traffic through Proton only";
    after = [ "wg-quick-proton.service" ];
    requires = [ "wg-quick-proton.service" ];
    wantedBy = [ "multi-user.target" ];
    unitConfig.ConditionPathExists = protonConfigFile;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = protonPolicyRouting;
      ExecStop = protonPolicyRoutingStop;
    };
  };

  systemd.services.proton-natpmp = {
    description = "Keep Proton NAT-PMP mappings alive and sync qBittorrent port";
    after = [
      "wg-quick-proton.service"
      "proton-policy-routing.service"
      "qbittorrent.service"
    ];
    requires = [
      "wg-quick-proton.service"
      "proton-policy-routing.service"
      "qbittorrent.service"
    ];
    bindsTo = [
      "wg-quick-proton.service"
      "qbittorrent.service"
    ];
    wantedBy = [ "multi-user.target" ];
    unitConfig.ConditionPathExists = protonConfigFile;
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = 5;
      RuntimeDirectory = "proton-natpmp";
      ExecStart = protonNatpmp;
      ExecStopPost = protonNatpmpStop;
    };
  };

  systemd.services."wg-quick-proton".unitConfig.ConditionPathExists = protonConfigFile;

  systemd.services.qbittorrent = {
    after = [
      "wg-quick-proton.service"
      "proton-policy-routing.service"
    ];
    requires = [
      "wg-quick-proton.service"
      "proton-policy-routing.service"
    ];
    bindsTo = [ "wg-quick-proton.service" ];
    partOf = [ "wg-quick-proton.service" ];
    unitConfig.ConditionPathExists = protonConfigFile;
  };
}
