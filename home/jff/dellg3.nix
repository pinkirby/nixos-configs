{ config, pkgs, ... }: {
  imports = [
    ../common/core/default.nix
    ../../neovim.nix
  ];

  home.username = "jff";
  home.homeDirectory = "/home/jff";

  xsession.windowManager.bspwm = {
    enable = true;
    settings = {
      window_gap = 0;
      border_width = 2;
    };
    monitors = {
      "eDP-1-1" = [ "L1" "L2" "L3" "L4" "L5" "L6" "L7" "L8" "L9" ];
      "HDMI-0" = [ "R1" "R2" "R3" "R4" "R5" "R6" "R7" "R8" "R9" ];
    };
    extraConfigEarly = ''
      xrandr --output eDP-1-1 --auto --primary --output HDMI-0 --auto --right-of eDP-1-1
      feh --bg-fill ${../../monitor_1.png} ${../../monitor_0.png} &
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
      "super + shift + m" = "xrandr --output eDP-1-1 --auto --primary --output HDMI-0 --auto --above eDP-1-1 ; feh --bg-fill ${../../monitor_1.png} ${../../monitor_0.png} &";
      "super + shift + k" = "xrandr --output HDMI-0 --mode 1920x1080 --rate 255 --right-of eDP-1-1 ; feh --bg-fill ${../../monitor_1.png} ${../../monitor_0.png} &";
    };
  };

  services.dunst = {
    enable = true;
    settings.global = {
      font = "Monospace 20";
      follow = "mouse";
      origin = "bottom-right";
      offset = "(20, 20)";
      width = "(0, 700)";
      height = "(0, 500)";
      corner_radius = 8;
    };
  };

  services.picom.enable = true;
  programs.firefox.enable = true;
}
