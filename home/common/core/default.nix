{ pkgs, ... }:

let
  helpFileName = ".tmux-custom-bindings-help";
  
  tmux-default-sessions = [

  ];

  customBindings = [
    { key = "M-p"; cmd = "command-prompt -I \"attach-session -c \" \"%%\""; desc = "Change default [P]ath of the current session"; }
    { key = "M-c"; cmd = "command-prompt -I \"new-window -n \" \"%%\""; desc = "[C]reate a named window"; }
    { key = "M-a"; cmd = "command-prompt -p \"Session/Chat Name: \" \"new-window -n '%1' 'aichat -s \\\"%1\\\"'\""; desc = "Create new [A]I chat"; }
    { key = "M-i"; cmd = "set-option -g status"; desc = "Toggle status bar [I]nformation"; }
    { key = "M-e"; cmd = "display-popup -d \"#{pane_current_path}\" -w 80% -h 80% -E lf"; desc = "Open file [E]xplorer"; }
    { key = "Enter"; cmd = "display-popup -d \"#{pane_current_path}\" -w 80% -h 80% -E zsh"; desc = "Open [S]hell"; }
    { key = "y"; cmd = "copy"; desc = "Enter tmux copy mode"; }
    { key = "\\;"; cmd = "command-prompt"; desc = "Open tmux command prompt"; }
    { key = "S-Right"; cmd = "split -h"; desc = "Split window vertically (Right)"; }
    { key = "S-Left"; cmd = "split -bh"; desc = "Split window vertically (Left)"; }
    { key = "S-Up"; cmd = "split -bv"; desc = "Split window horizontally (Up)"; }
    { key = "S-Down"; cmd = "split -v"; desc = "Split window horizontally (Down)"; }
    { key = "M-r"; cmd = "source-file ~/.config/tmux/tmux.conf \\; display-message \"Tmux config reloaded.\""; desc = "[R]eload config"; }
    { key = "M-h"; cmd = "display-popup -w 80% -h 80% -E \"bat ~/${helpFileName}\""; desc = "Display [H]elp for custom bindings"; }
    { key = "M-s"; cmd = "choose-tree -s -Z"; desc = "Choose a [S]ession"; }
    { key = "M-t"; cmd = "clock-mode"; desc = "Display [T]ime"; }
    { key = "M-f"; cmd = "display-message"; desc = "Display window in[F]ormation"; }
    { key = "k"; cmd = "next-layout"; desc = "Cycle through pane layouts"; }
    { key = "l"; cmd = "next"; desc = "Next window"; }
    { key = "h"; cmd = "previous-window"; desc = "Previous window"; }
  ];

  tmuxConfSnippet = builtins.concatStringsSep "\n"
    (map (b: "bind ${b.key} ${b.cmd} # ${b.desc}") customBindings);

  helpFileContent = builtins.concatStringsSep "\n"
    ([ "Custom Keybindings Cheat Sheet" ] ++ [ (pkgs.lib.strings.replicate 100 "-") ] ++ (map (b: "Prefix + ${b.key} : ${b.desc}") customBindings));
in
{
  home.stateVersion = "26.05";

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "bat";
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

      tmux-create-aichat () {
        tmux new-session -d -s aichat -c /home/jff/Documents/gemini -n aichat "aichat -s tmp"
      }

      tmux-create-emergent-mind () {
        tmux new-session -d -s emergent-mind -c /home/jff/Documents/repos/EmergentMind -n config "lf /home/jff/Documents/repos/EmergentMind"
      }

      tmux-create-rpg () {
        tmux new-session -d -s rpg -c /home/jff/Documents/repos/martin-rpg-player-rules -n rules "nvim /home/jff/Documents/repos/martin-rpg-player-rules/rules.md -c \"cd /home/jff/Documents/repos/martin-rpg-player-rules\""
        tmux new-window -d -t rpg -n md-cheat-sheet "bat /home/jff/Documents/repos/markdown-here.wiki/Markdown-Cheatsheet.md"
      }

      tmux-init() {
        tmux has-session -t "settings" 2>/dev/null || tmux-create-settings
        tmux has-session -t "pc" 2>/dev/null || tmux-create-main
        tmux has-session -t "nixos" 2>/dev/null || tmux-create-nixos
        tmux has-session -t "nixvim" 2>/dev/null || tmux-create-nixvim
        tmux has-session -t "aichat" 2>/dev/null || tmux-create-aichat
        tmux has-session -t "emergent-mind" 2>/dev/null || tmux-create-emergent-mind
        tmux has-session -t "rpg" 2>/dev/null || tmux-create-rpg
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

  home.file."${helpFileName}" = {
    enable = true;
    text = helpFileContent;
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

      ${tmuxConfSnippet}
    '';
  };

  programs.lf = {
    enable = true;
    commands = {
      mkdir = "%mkdir \"$@\"";
      touch = "%touch \"$@\"";
      extract = ''
        ''${{
          for f in $fx; do
              unzip -q "$f"
          done
        }}
      '';
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


  xdg.desktopEntries.nsxiv = {
    name = "nsxiv";
    exec = "nsxiv %f";
    mimeType = [
      "image/png"
      "image/jpeg"
      "image/gif"
      "image/webp"
    ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/png" = "nsxiv.desktop";
      "image/jpeg" = "nsxiv.desktop";
    };
  };

  home.packages = with pkgs; [
    fastfetch
    lf
    btop
    rofi
    nsxiv
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
    aichat
    glow
    gh
  ];
}
