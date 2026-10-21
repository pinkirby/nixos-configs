{ pkgs, ... }: {
  home.stateVersion = "26.05";

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";
  };

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

    initContent = ''
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

      NEWLINE=$'\n'
      PROMPT="%(?.%F{green}.%F{red})[%F{cyan}%m%F{white}@%F{cyan}%n%(?.%F{green}.%F{red})] %F{cyan}%~%f''${NEWLINE}%F{cyan}|%F{green}>%F{cyan}|%F{white} "

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
        tmux new-session -d -s nixos -c /home/jff/nixos -n config "nvim /home/jff/nixos -c \"cd /home/jff/nixos\""
      }

      tmux-create-nixvim () {
        tmux new-session -d -s nixvim -c /home/jff/Documents/repos/nixvim-config -n config "nvim /home/jff/Documents/repos/nixvim-config -c \"cd /home/jff/Documents/repos/nixvim-config\""
      }

      tmux-init() {
        tmux has-session -t "settings" 2>/dev/null || tmux-create-settings
        tmux has-session -t "pc" 2>/dev/null || tmux-create-main
        tmux has-session -t "nixos" 2>/dev/null || tmux-create-nixos
        tmux has-session -t "nixvim" 2>/dev/null || tmux-create-nixvim
      }

      tmux-init
    '';

    shellAliases = {
      snvim = "sudo nvim";
      nrs = "sudo nixos-rebuild switch";
      nrt = "sudo nixos-rebuild test";
      nrb = "sudo nixos-rebuild boot";
      nrbu = "sudo nixos-rebuild boot --upgrade";
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window.opacity = 0.70;
      cursor.style = {
        shape = "Block";
        blinking = "Never";
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

  programs.btop = {
    enable = true;
    settings.color_theme = "flat-remix";
  };

  programs.feh.enable = true;

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
    direnv
  ];
}
