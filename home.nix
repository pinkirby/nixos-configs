{ config, pkgs, ... }:

{

  imports = [
    ./neovim.nix
  ];

  home.username = "jff";
  home.homeDirectory = "/home/jff";
  home.stateVersion = "26.05";

  xsession.windowManager.bspwm = {
    enable = true;

    settings = {
      window_gap = 0;
      border_width = 2;
    };

    monitors = {
      "eDP-1-1" = [
        "L1"
        "L2"
        "L3"
        "L4"
        "L5"
        "L6"
        "L7"
        "L8"
        "L9"
      ];
      "HDMI-0" = [
        "R1"
        "R2"
        "R3"
        "R4"
        "R5"
        "R6"
        "R7"
        "R8"
        "R9"
      ];
    };

    extraConfigEarly = ''
      xrandr --output eDP-1-1 --auto --primary --output HDMI-0 --auto --right-of eDP-1-1
      feh --bg-fill ${./monitor_1.png} ${./monitor_0.png} &
      systemctl --user restart wireplumber pipewire
      pkill dunst
      dunst &
    '';

    extraConfig = ''
      bspc config pointer_follows_focus true
      bspc config pointer_follows_monitor true
      bspc config focus_follows_pointer true
    '';
  };

  services.sxhkd = {
    enable = true;

    keybindings = {
      "XF86AudioPlay" = "playerctl play-pause";
      "XF86AudioNext" = "playerctl next";
      "XF86AudioPrev" = "playerctl previous";
      "super + Return" = "alacritty";
      "super + shift + q" = "bspc node -c";
      "super + semicolon" = "rofi -show run -theme DarkBlue";
      "super + colon" = "rofi -show drun -theme DarkBlue";
      "super + {Up,Down,Left,Right}" = "bspc node -f {north,south,west,east}";
      "super + alt + {Up,Down,Left,Right}" = "bspc node -s {north,south,west,east}";
      "super + {k,j,h,l}" = "bspc node -f {north,south,west,east}";
      "super + {t,s,r,a,n,e,i,o}" = "bspc desktop -f {L1,L2,L3,L4,R1,R2,R3,R4}";
      "super + alt + {t,s,r,a,n,e,i,o}" = "bspc node -d {L1,L2,L3,L4,R1,R2,R3,R4}";
      "super + l" = "bspc node -t floating";
      "super + u" = "bspc node -t tiled";
      "super + shift + b" = "bspc wm -r";
      "super + shift + c" = "pkill -USR1 -x sxhkd";
      "super + shift + s" = "flameshot gui";
      "super + z" = "dunstify -t 20000 \"Info\" \"Workspace: $(bspc query -D -d focused --names)\\n$(date '+%A, %B %d %Y')\\n<b>$(date '+%H:%M')</b>\"";
      "super + x" = "dunstctl close-all";
      "super + f" = "alacritty -e lf";
      "super + shift + f" = "bspc node -t \\~fullscreen";
      "super + shift + Left" = "bspc node -s last";
      "super + shift + l" = "slock";
      "super + shift + m" = "xrandr --output eDP-1-1 --auto --primary --output HDMI-0 --auto --above eDP-1-1 ; feh --bg-fill ${./monitor_1.png} ${./monitor_0.png} &";
      "super + shift + k" = "xrandr --output HDMI-0 --mode 1920x1080 --rate 255 --right-of eDP-1-1 ; feh --bg-fill ${./monitor_1.png} ${./monitor_0.png} &";
    };
  };

  services.dunst = {
    enable = true;
      settings = {
        global = {
          font = "Monospace 20";
          follow = "mouse";
          origin = "bottom-right";
          offset = "(20, 20)";
          width = "(0, 700)";
          height = "(0, 500)";
          corner_radius = 8;
        };
      };
  };

  services.picom = {
    enable = true;
  };

  # programs.bash = {
    # enable = true;
    # shellAliases = {
      # nrs = "sudo nixos-rebuild switch";
      # nrt = "sudo nixos-rebuild test";
      # nrb = "sudo nixos-rebuild boot";
    # };
  # };

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.70;
      };

      cursor = {
        style = {
          shape = "Block";
          blinking = "Never";
	};
      };
    };
  };

  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    keyMode = "vi";
    escapeTime = 0;
    mouse = true;
    clock24 = true;

    extraConfig = ''
      set -g status off
      set -g display-time 2500
      set -g display-panes-time 5000

      unbind C-b
      set-option -g prefix M-b
      bind-key M-b send-prefix

      set-window-option -g mode-keys vi

      bind M-p command-prompt -I "attach-session -c " "%%"
      bind M-c command-prompt -I "new-window -n " "%%"
      bind M-i set-option -g status
      bind e display-popup -d "#{pane_current_path}" -w 80% -h 80% -E lf
      bind M-s display-popup -d "#{pane_current_path}" -w 80% -h 80% -E zsh
      bind y copy
      bind \; command-prompt


      bind S-Right split -h
      bind S-Left split -bh
      bind S-Up split -bv
      bind S-Down split -v

      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Tmux config reloaded."
    '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";
  };

/*
  programs.neovim = {
    enable = true;

    initLua = ''
      local set_transparency = function()
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      end
  
      -- Apply transparency
      set_transparency()
  
      -- Re-apply on colorscheme changes
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = set_transparency,
      })

      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.softtabstop = 2
      vim.opt.expandtab = true
      vim.opt.smartindent = true

      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save file', silent = true })
      vim.keymap.set('n', '<leader>n', ':bn<CR>', { desc = 'Next buffer', silent = true })
      vim.keymap.set('n', '<leader>p', ':bn<CR>', { desc = 'Next buffer', silent = true })
      vim.keymap.set('n', '<leader>e', ':Ex<CR>', { desc = 'Open file explorer', silent = true })
      vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>', { desc = 'Clear search highlights', silent = true })
    '';

  };

*/

  programs.lf = {
    enable = true;

    commands = {
      mkdir = "%mkdir \"$@\"";
      touch = "%touch \"$@\"";
    };

    keybindings = {
      x = "cut";
      "<esc>" = "quit";
      "<space>" = "toggle";
    };
  };

  programs.feh.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      path = "$HOME/.zsh_history";
      share = true;
      ignoreDups = true;
    };

    # Replaced initExtra with initContent
    initContent = ''
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

      NEWLINE=$'\n'
      PROMPT="%(?.%F{green}.%F{red})[%F{cyan}%n%F{white}@%F{cyan}%m%(?.%F{green}.%F{red})] %F{cyan}%~%f''${NEWLINE}%F{cyan}|%F{green}>%F{cyan}|%F{white} "

      bindkey '^n' autosuggest-accept
      bindkey "\e[1;5D" backward-word
      bindkey "\e[1;5C" forward-word
      bindkey '^H' backward-kill-word

      lfcd() {
          local tmp="$(mktemp)"
          command lf -last-dir-path="$tmp" "$@"
          if [ -f "$tmp" ]; then
              local dir="$(cat "$tmp")"
              rm -f "$tmp"
              if [ -d "$dir" ] && [ "$dir" != "$(pwd)" ]; then
                  cd "$dir"
              fi
          fi
      }

      start-ssh-agent() {
        if [ -z "$SSH_AUTH_SOCK" ]; then
          eval "$(ssh-agent -s)" > /dev/null
          ssh-add ~/.ssh/id_ed25519 2>/dev/null
        fi
      }

      tmux-create-settings () {
        tmux new-session -d -s settings -n sound bluetoothctl
        tmux split-window -d -t settings pulsemixer
        tmux new-window -d -t settings -n btop "btop -p 0"
      }

      tmux-create-main () {
        tmux new-session -d -s pc -n main
      }

      tmux-create-nixos () {
        tmux new-session -d -s nixos -c /etc/nixos -n config "sudo nvim /etc/nixos"
      }

      tmux-init() {
        tmux has-session -t "settings" 2>/dev/null || tmux-create-settings
        tmux has-session -t "pc" 2>/dev/null || tmux-create-main
        tmux has-session -t "nixos" 2>/dev/null || tmux-create-nixos
      }

      tmux-init
      # [ -n "$TMUX" ] || tmux a -t pc
    '';

    shellAliases = {
      snvim = "sudo nvim";
      nrs = "sudo nixos-rebuild switch";
      nrt = "sudo nixos-rebuild test";
      nrb = "sudo nixos-rebuild boot";
      nrbu = "sudo nixos-rebuild boot --upgrade";
    };
  };

  programs.btop = {
    enable = true;

    settings = {
      color_theme = "flat-remix";
    };
  };

  home.packages = with pkgs; [
    fastfetch
    lf
    btop
    lazygit
    rofi
    sxiv
    pulsemixer
    microsoft-edge
    flameshot
    feh
    openssh
    tldr
    mpv
    yt-dlp
    ytfzf
  ];
}
