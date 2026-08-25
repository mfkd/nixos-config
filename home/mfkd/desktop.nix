{ config, lib, pkgs, ... }:

let
  canSuspend = pkgs.writeShellScript "hypridle-can-suspend" ''
    if ${pkgs.iproute2}/bin/ss -Htn state established '( sport = :ssh )' | ${pkgs.gnugrep}/bin/grep -q .; then
      exit 1
    fi

    exit 0
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

  uwsm = lib.getExe pkgs.uwsm;
  ghostty = lib.getExe pkgs.ghostty;
  chrome = lib.getExe config.programs.google-chrome.finalPackage;
  walker = lib.getExe pkgs.walker;
  yazi = lib.getExe pkgs.yazi;
  hyprlock = lib.getExe pkgs.hyprlock;
  playerctl = lib.getExe pkgs.playerctl;
  brightnessctl = lib.getExe pkgs.brightnessctl;
  wpctl = "${pkgs.wireplumber}/bin/wpctl";

  terminalCommand = "${uwsm} app -- ${ghostty}";
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
      if status is-login; and status is-interactive; and test (tty) = /dev/tty1; and ${uwsm} check may-start >/dev/null
        exec ${uwsm} start hyprland.desktop
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

    hyprlock = {
      enable = true;
      settings = {
        general = {
          hide_cursor = true;
          immediate_render = true;
        };

        background = [
          {
            monitor = "";
            color = "rgb(1e1e2e)";
          }
        ];

        label = [
          {
            monitor = "";
            text = "$TIME";
            color = "rgb(cdd6f4)";
            font_family = "JetBrainsMono Nerd Font";
            font_size = 64;
            position = "0, 120";
            halign = "center";
            valign = "center";
          }
        ];

        input-field = [
          {
            monitor = "";
            size = "320, 56";
            position = "0, -20";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(cdd6f4)";
            inner_color = "rgb(313244)";
            outer_color = "rgb(cba6f7)";
            check_color = "rgb(89b4fa)";
            fail_color = "rgb(f38ba8)";
            outline_thickness = 2;
            placeholder_text = "Password";
            shadow_passes = 0;
          }
        ];
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

        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "network"
          "bluetooth"
          "wireplumber"
          "battery"
          "clock"
        ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          format = "{name}";
          persistent-workspaces."*" = [ 1 2 3 4 5 ];
        };

        "hyprland/window" = {
          format = "{}";
          max-length = 80;
          separate-outputs = true;
        };

        network = {
          interval = 5;
          format-wifi = "{essid} {signalStrength}%";
          format-ethernet = "{ifname}";
          format-disconnected = "offline";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
          on-click = "${terminalCommand} -e ${pkgs.networkmanager}/bin/nmtui";
        };

        bluetooth = {
          format = "bt";
          format-connected = "bt {num_connections}";
          format-disabled = "";
          tooltip-format-connected = "{device_enumerate}";
          on-click = "${terminalCommand} -e ${pkgs.bluez}/bin/bluetoothctl";
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

    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || ${hyprlock}";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          inhibit_sleep = 2;
        };

        listener = [
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 600;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 1800;
            on-timeout = "systemctl suspend";
            condition_cmd = "${canSuspend}";
            condition_retry = 60;
          }
        ];
      };
    };

    hyprpolkitagent.enable = true;

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

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    configType = "lua";
    systemd.enable = false;

    settings = {
      monitor = [
        {
          output = "eDP-1";
          mode = "preferred";
          position = "auto";
          scale = 1.5;
        }
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = 1;
        }
      ];

      env = [
        { _args = [ "XCURSOR_SIZE" "24" ]; }
        { _args = [ "HYPRCURSOR_SIZE" "24" ]; }
      ];

      config = {
        general = {
          gaps_in = 6;
          gaps_out = 10;
          border_size = 2;
          col = {
            active_border = "rgba(cba6f7ff)";
            inactive_border = "rgba(45475aaa)";
          };
          resize_on_border = true;
          allow_tearing = false;
          layout = "scrolling";
        };

        decoration = {
          rounding = 4;
          rounding_power = 2;
          active_opacity = 1.0;
          inactive_opacity = 1.0;
          shadow.enabled = false;
          blur.enabled = false;
        };

        animations.enabled = true;

        scrolling = {
          column_width = 1.0;
          direction = "right";
          explicit_column_widths = "0.333, 0.5, 0.667, 1.0";
          focus_fit_method = 1;
          follow_focus = true;
          fullscreen_on_one_column = true;
          wrap_focus = true;
          wrap_swapcol = true;
        };

        input = {
          kb_layout = "us";
          follow_mouse = 1;
          sensitivity = 0;
          touchpad.natural_scroll = false;
        };

        misc = {
          background_color = "rgb(1e1e2e)";
          disable_hyprland_logo = true;
          force_default_wallpaper = 0;
        };
      };

      animation = [
        { leaf = "windows"; enabled = true; speed = 8; bezier = "default"; style = "popin 96%"; }
        { leaf = "fade"; enabled = true; speed = 8; bezier = "default"; }
        { leaf = "workspaces"; enabled = true; speed = 8; bezier = "default"; style = "slide"; }
      ];

      window_rule = [
        {
          name = "suppress-maximize-events";
          match.class = ".*";
          suppress_event = "maximize";
        }
        {
          name = "fix-xwayland-drags";
          match = {
            class = "^$";
            title = "^$";
            xwayland = true;
            float = true;
            fullscreen = false;
            pin = false;
          };
          no_focus = true;
        }
      ];
    };

    extraConfig = ''
      local mainMod = "SUPER"

      hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("${terminalCommand}"))
      hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("${uwsm} app -- ${walker}"))
      hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("${terminalCommand} -e ${yazi}"))
      hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("${uwsm} app -- ${chrome}"))
      hl.bind(mainMod .. " + Q", hl.dsp.window.close())
      hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle", layout_aware = true }))
      hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd("${hyprlock}"))
      hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("${uwsm} stop"))

      hl.bind(mainMod .. " + H", hl.dsp.layout("focus l"))
      hl.bind(mainMod .. " + L", hl.dsp.layout("focus r"))
      hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
      hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
      hl.bind(mainMod .. " + SHIFT + H", hl.dsp.layout("swapcol l"))
      hl.bind(mainMod .. " + SHIFT + L", hl.dsp.layout("swapcol r"))
      hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "down" }))
      hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "up" }))
      hl.bind(mainMod .. " + R", hl.dsp.layout("colresize +conf"))
      hl.bind(mainMod .. " + SHIFT + R", hl.dsp.layout("fit visible"))
      hl.bind(mainMod .. " + P", hl.dsp.layout("promote"))
      hl.bind(mainMod .. " + C", hl.dsp.layout("consume_or_expel prev"))

      for i = 1, 9 do
        hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
        hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
      end

      hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("${wpctl} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
      hl.bind("XF86AudioMute", hl.dsp.exec_cmd("${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
      hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
      hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("${brightnessctl} -e4 -n2 set 5%+"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("${brightnessctl} -e4 -n2 set 5%-"), { locked = true, repeating = true })
      hl.bind("XF86AudioNext", hl.dsp.exec_cmd("${playerctl} next"), { locked = true })
      hl.bind("XF86AudioPause", hl.dsp.exec_cmd("${playerctl} play-pause"), { locked = true })
      hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("${playerctl} play-pause"), { locked = true })
      hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("${playerctl} previous"), { locked = true })
    '';
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
