{ config, lib, pkgs, ... }:

let
  canSuspend = pkgs.writeShellScript "idle-can-suspend" ''
    if ${pkgs.iproute2}/bin/ss -Htn state established '( sport = :ssh )' | ${pkgs.gnugrep}/bin/grep -q .; then
      exit 1
    fi

    exit 0
  '';

  idleSuspend = pkgs.writeShellScript "idle-suspend" ''
    if ${canSuspend}; then
      exec ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';

  # The pinned package emits an empty PATH wrapper argument when no selected
  # provider has runtime dependencies.
  elephant = (pkgs.elephant.override {
    enabledProviders = [ "desktopapplications" ];
  }).overrideAttrs {
    postInstall = ''
      wrapProgram $out/bin/elephant \
        --set ELEPHANT_PROVIDER_DIR "$out/lib/elephant/providers"
    '';
  };

  ghostty = lib.getExe pkgs.ghostty;
  chrome = lib.getExe config.programs.google-chrome.finalPackage;
  walker = lib.getExe pkgs.walker;
  yazi = lib.getExe pkgs.yazi;
  niri = lib.getExe pkgs.niri;
  niriSession = "${pkgs.niri}/bin/niri-session";
  swaylock = lib.getExe pkgs.swaylock;
  playerctl = lib.getExe pkgs.playerctl;
  brightnessctl = lib.getExe pkgs.brightnessctl;
  wpctl = "${pkgs.wireplumber}/bin/wpctl";

  workspaceBinds = lib.listToAttrs (
    lib.concatMap (
      workspace:
      let
        number = toString workspace;
      in
      [
        {
          name = "Mod+${number}";
          value."focus-workspace" = workspace;
        }
        {
          name = "Mod+Shift+${number}";
          value."move-window-to-workspace" = workspace;
        }
      ]
    ) (lib.range 1 9)
  );
in
{
  home = {
    packages = [
      pkgs.brightnessctl
      pkgs.playerctl
      pkgs.wl-clipboard
    ];

    sessionVariables = {
      BROWSER = chrome;
      NIXOS_OZONE_WL = "1";
      TERMINAL = ghostty;
    };
  };

  programs = {
    fish.loginShellInit = ''
      if status is-login; and status is-interactive; and test (tty) = /dev/tty1
        exec ${niriSession}
      end
    '';

    ghostty = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        command = "${pkgs.fish}/bin/fish --login --interactive";
        font-family = "JetBrainsMono Nerd Font";
        "shell-integration" = "fish";
        theme = "dark:Catppuccin Mocha,light:Catppuccin Latte";
      };
    };

    google-chrome = {
      enable = true;
      commandLineArgs = [ "--ozone-platform=wayland" ];
    };

    swaylock = {
      enable = true;
      settings = {
        color = "1e1e2e";
        font = "JetBrainsMono Nerd Font";
        font-size = 24;
        indicator-radius = 70;
        indicator-thickness = 8;
        inside-color = "313244";
        inside-clear-color = "313244";
        inside-ver-color = "313244";
        inside-wrong-color = "313244";
        key-hl-color = "cba6f7";
        ring-color = "45475a";
        ring-clear-color = "f9e2af";
        ring-ver-color = "89b4fa";
        ring-wrong-color = "f38ba8";
        separator-color = "00000000";
        text-color = "cdd6f4";
        text-clear-color = "f9e2af";
        text-ver-color = "89b4fa";
        text-wrong-color = "f38ba8";
        show-failed-attempts = true;
      };
    };

    waybar = {
      enable = true;
      systemd.enable = true;
      settings.mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;

        modules-left = [ "niri/workspaces" ];
        modules-center = [ "niri/window" ];
        modules-right = [
          "network"
          "bluetooth"
          "wireplumber"
          "battery"
          "clock"
        ];

        "niri/workspaces" = {
          format = "{name}";
        };

        "niri/window" = {
          format = "{title}";
          max-length = 80;
        };

        network = {
          interval = 5;
          format-wifi = "{essid} {signalStrength}%";
          format-ethernet = "{ifname}";
          format-disconnected = "offline";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
          on-click = "${ghostty} -e ${pkgs.networkmanager}/bin/nmtui";
        };

        bluetooth = {
          format = "bt";
          format-connected = "bt {num_connections}";
          format-disabled = "";
          tooltip-format-connected = "{device_enumerate}";
          on-click = "${ghostty} -e ${pkgs.bluez}/bin/bluetoothctl";
        };

        wireplumber = {
          format = "vol {volume}%";
          format-muted = "muted";
          on-click = "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };

        battery = {
          bat = "BAT0";
          interval = 30;
          states.warning = 20;
          states.critical = 10;
          format = "bat {capacity}%";
          format-charging = "chg {capacity}%";
        };

        clock = {
          interval = 60;
          format = "{:%a %d %b  %H:%M}";
          tooltip-format = "<tt>{calendar}</tt>";
        };
      };

      style = ''
        @define-color base #1e1e2e;
        @define-color surface0 #313244;
        @define-color surface1 #45475a;
        @define-color overlay0 #6c7086;
        @define-color text #cdd6f4;
        @define-color subtext0 #a6adc8;
        @define-color mauve #cba6f7;
        @define-color blue #89b4fa;
        @define-color green #a6e3a1;
        @define-color yellow #f9e2af;
        @define-color red #f38ba8;

        * {
          border: none;
          border-radius: 0;
          font-family: "JetBrainsMono Nerd Font";
          font-size: 12px;
          letter-spacing: 0;
          min-height: 0;
        }

        window#waybar {
          background: alpha(@base, 0.96);
          color: @text;
          border-bottom: 1px solid @surface1;
        }

        #workspaces button {
          color: @subtext0;
          padding: 0 8px;
          background: transparent;
        }

        #workspaces button.active {
          color: @base;
          background: @mauve;
        }

        #workspaces button.urgent {
          color: @base;
          background: @red;
        }

        #window {
          color: @text;
          padding: 0 10px;
        }

        #network,
        #bluetooth,
        #wireplumber,
        #battery,
        #clock {
          padding: 0 8px;
          color: @text;
        }

        #network.disconnected,
        #wireplumber.muted {
          color: @overlay0;
        }

        #battery.charging {
          color: @green;
        }

        #battery.warning:not(.charging) {
          color: @yellow;
        }

        #battery.critical:not(.charging) {
          color: @red;
        }
      '';
    };
  };

  services = {
    elephant = {
      enable = true;
      package = elephant;
    };

    swayidle = {
      enable = true;
      events = {
        before-sleep = "${swaylock} -f";
        lock = "${swaylock} -f";
      };
      timeouts = [
        {
          timeout = 300;
          command = "${pkgs.systemd}/bin/loginctl lock-session";
        }
        {
          timeout = 600;
          command = "${niri} msg action power-off-monitors";
        }
        {
          timeout = 1800;
          command = "${idleSuspend}";
        }
      ];
    };

    polkit-gnome.enable = true;

    mako = {
      enable = true;
      settings = {
        anchor = "top-right";
        background-color = "#1e1e2e";
        border-color = "#cba6f7";
        border-radius = 4;
        border-size = 2;
        default-timeout = 5000;
        font = "JetBrainsMono Nerd Font 10";
        height = 120;
        icons = true;
        margin = "10,10,0";
        padding = "12";
        text-color = "#cdd6f4";
        width = 360;
      };
    };

    walker = {
      enable = true;
      enableElephantIntegration = true;
      systemd.enable = true;
      settings = {
        close_when_open = true;
        disable_mouse = true;
        force_keyboard_focus = true;
        hide_action_hints = true;
        hide_quick_activation = true;
        selection_wrap = true;
        placeholders.default = {
          input = "Applications";
          list = "No applications found";
        };
        providers = {
          default = [ "desktopapplications" ];
          empty = [ "desktopapplications" ];
          max_results = 20;
        };
      };
      theme = {
        name = "catppuccin-mocha";
        style = ''
          @define-color window_bg_color #1e1e2e;
          @define-color accent_bg_color #cba6f7;
          @define-color theme_fg_color #cdd6f4;
          @define-color error_bg_color #f38ba8;
          @define-color error_fg_color #1e1e2e;

          * {
            all: unset;
            font-family: "JetBrainsMono Nerd Font";
            letter-spacing: 0;
          }

          scrollbar {
            opacity: 0;
          }

          .box-wrapper {
            background: @window_bg_color;
            border: 2px solid @accent_bg_color;
            border-radius: 6px;
            padding: 16px;
          }

          .input {
            background: #313244;
            color: @theme_fg_color;
            caret-color: @accent_bg_color;
            border-radius: 4px;
            padding: 10px 12px;
          }

          .input placeholder,
          .item-subtext,
          .keybind-button {
            color: #a6adc8;
            opacity: 0.8;
          }

          .list,
          .placeholder,
          .elephant-hint {
            color: @theme_fg_color;
          }

          .item-box {
            border-radius: 4px;
            padding: 9px 10px;
          }

          child:selected .item-box,
          row:selected .item-box {
            background: #45475a;
          }

          .item-quick-activation,
          .keybinds {
            background: transparent;
            color: #a6adc8;
          }
        '';
      };
    };
  };

  systemd.user.services.walker.Unit.PartOf = [ "graphical-session.target" ];

  wayland.windowManager.niri = {
    enable = true;
    package = pkgs.niri;
    portalPackage = null;
    systemd.enable = false;
    xwaylandSatellitePackage = pkgs.xwayland-satellite;

    settings = {
      _children = [
        {
          output = {
            _args = [ "eDP-1" ];
            scale = 1.5;
          };
        }
      ];

      input.keyboard.xkb.layout = "us";

      layout = {
        gaps = 10;
        "center-focused-column" = "never";
        "default-column-width".proportion = 1.0;
        "preset-column-widths"._children = [
          { proportion = 0.33333; }
          { proportion = 0.5; }
          { proportion = 0.66667; }
          { proportion = 1.0; }
        ];
        "focus-ring" = {
          width = 2;
          "active-color" = "#cba6f7";
          "inactive-color" = "#45475a";
        };
        border.off = { };
        shadow.off = { };
        "background-color" = "#1e1e2e";
      };

      animations.slowdown = 0.8;
      cursor."hide-when-typing" = { };
      "hotkey-overlay"."skip-at-startup" = { };
      "prefer-no-csd" = { };
      "screenshot-path" = null;

      "window-rule" = {
        "geometry-corner-radius" = 4.0;
        "clip-to-geometry" = true;
      };

      binds = {
        "Mod+Return".spawn = [ ghostty ];
        "Mod+D".spawn = [ walker ];
        "Mod+E".spawn = [ ghostty "-e" yazi ];
        "Mod+B".spawn = [ chrome ];
        "Mod+Q" = {
          _props.repeat = false;
          "close-window" = { };
        };
        "Mod+Space"."toggle-window-floating" = { };
        "Mod+O" = {
          _props.repeat = false;
          "toggle-overview" = { };
        };
        "Mod+F"."fullscreen-window" = { };
        "Mod+Ctrl+L".spawn = [ "${pkgs.systemd}/bin/loginctl" "lock-session" ];
        "Mod+Shift+Q".quit._props."skip-confirmation" = true;
        "Mod+Escape" = {
          _props."allow-inhibiting" = false;
          "toggle-keyboard-shortcuts-inhibit" = { };
        };

        "Mod+H"."focus-column-left" = { };
        "Mod+L"."focus-column-right" = { };
        "Mod+J"."focus-window-down" = { };
        "Mod+K"."focus-window-up" = { };
        "Mod+Shift+H"."move-column-left" = { };
        "Mod+Shift+L"."move-column-right" = { };
        "Mod+Shift+J"."move-window-down" = { };
        "Mod+Shift+K"."move-window-up" = { };
        "Mod+R"."switch-preset-column-width" = { };
        "Mod+Shift+R"."center-visible-columns" = { };
        "Mod+P"."move-column-to-first" = { };
        "Mod+C"."consume-or-expel-window-right" = { };

        "XF86AudioRaiseVolume" = {
          _props."allow-when-locked" = true;
          spawn = [ wpctl "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "5%+" ];
        };
        "XF86AudioLowerVolume" = {
          _props."allow-when-locked" = true;
          spawn = [ wpctl "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-" ];
        };
        "XF86AudioMute" = {
          _props."allow-when-locked" = true;
          spawn = [ wpctl "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];
        };
        "XF86AudioMicMute" = {
          _props."allow-when-locked" = true;
          spawn = [ wpctl "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ];
        };
        "XF86MonBrightnessUp" = {
          _props."allow-when-locked" = true;
          spawn = [ brightnessctl "-e4" "-n2" "set" "5%+" ];
        };
        "XF86MonBrightnessDown" = {
          _props."allow-when-locked" = true;
          spawn = [ brightnessctl "-e4" "-n2" "set" "5%-" ];
        };
        "XF86AudioNext" = {
          _props."allow-when-locked" = true;
          spawn = [ playerctl "next" ];
        };
        "XF86AudioPause" = {
          _props."allow-when-locked" = true;
          spawn = [ playerctl "play-pause" ];
        };
        "XF86AudioPlay" = {
          _props."allow-when-locked" = true;
          spawn = [ playerctl "play-pause" ];
        };
        "XF86AudioPrev" = {
          _props."allow-when-locked" = true;
          spawn = [ playerctl "previous" ];
        };
      } // workspaceBinds;
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "google-chrome.desktop" ];
      "x-scheme-handler/http" = [ "google-chrome.desktop" ];
      "x-scheme-handler/https" = [ "google-chrome.desktop" ];
    };
  };
}
