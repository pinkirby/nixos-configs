{ config, pkgs, ... }: {
  imports = [
    ../common/core/default.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "dellg3";
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
        FastConnectable = true;
      };
    };
  };

  boot.kernelModules = ["uinput"];
  hardware.uinput.enable = true;

  services.kanata = {
    enable = true;
    keyboards = {
      hyperx = {
        devices = [
          "/dev/input/by-id/usb-Kingston_HyperX_Alloy_FPS_Pro_Mechanical_Gaming_Keyboard-event-kbd"
        ];
        config = ''
          (defsrc
            esc        f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12        prnt slck brk
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc       ins  home pgup
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \          del  end  pgdn
            caps a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    rsft                    up
            lctl lmet lalt           spc              ralt comp rctl              left down rght
          )

          (defvar
            tap-time 175
            hold-time 175
          )

          (defalias
            l_fun (layer-while-held fun)
            l_num (layer-while-held num)
            l_sym (layer-while-held sym)

            main1 (tap-hold $tap-time $hold-time o rsft) 
            main2 (tap-hold $tap-time $hold-time i rmet) 
            main3 (tap-hold $tap-time $hold-time e lalt) 
            main4 (tap-hold $tap-time $hold-time n lctl) 
            main5 (tap-hold $tap-time $hold-time t lctl) 
            main6 (tap-hold $tap-time $hold-time s lalt) 
            main7 (tap-hold $tap-time $hold-time r lmet) 
            main8 (tap-hold $tap-time $hold-time a lsft) 
            main9 (tap-hold $tap-time $hold-time , ralt) 
            main0 (tap-hold $tap-time $hold-time m rctl) 

            fun1 (tap-hold $tap-time $hold-time f8 lctl) 
            fun2 (tap-hold $tap-time $hold-time f7 lalt) 
            fun3 (tap-hold $tap-time $hold-time f6 lmet) 
            fun4 (tap-hold $tap-time $hold-time f5 lsft) 

            tmb1 (tap-hold $tap-time $hold-time bspc @l_fun)
            tmb2 (tap-hold $tap-time $hold-time esc @l_num)
            tmb3 (tap-hold $tap-time $hold-time tab @l_sym)

            und S-min
            plus S-eql
            lcbr S-lbrc
            rcbr S-rbrc
            dblq S-apo
            pipe S-\
            tild S-grv

            bang S-1
            com S-2
            pnd S-3
            doll S-4
            perc S-5
            cret S-6
            espr S-7
            star S-8
            lpar S-9
            rpar S-0
          )

          (deflayer main
            XX XX ret spc @tmb1 XX @tmb2 lmet @tmb3 XX XX XX XX XX XX XX
            XX / . @main9 @main0 k XX XX b v c x z XX XX XX XX
            XX @main1 @main2 @main3 @main4 h XX d @main5 @main6 @main7 @main8 XX XX XX XX XX
            XX ; y u l j XX g p f w q XX
            XX XX XX XX XX XX XX XX XX XX XX XX XX
            XX XX XX XX XX XX XX XX XX XX
          )

          (deflayer num
            XX XX XX XX XX XX _ XX XX XX XX XX XX XX XX XX
            XX kp4 kp3 kp2 kp1 kp0 XX kp9 kp5 kp6 kp7 kp8 XX XX XX XX XX
            XX 4 3 2 1 0 XX 9 5 6 7 8 XX XX XX XX XX
            XX nlk XX XX XX XX XX XX XX XX XX XX XX
            XX XX XX XX XX XX XX XX XX XX XX XX XX
            XX XX XX XX XX XX XX XX XX XX
          )

          (deflayer fun
            XX XX XX XX _ XX XX XX XX XX XX XX XX XX XX XX
            XX del XX XX tab ins XX XX XX f12 f11 f10 f9 XX XX XX XX
            XX bspc rght down left pgdn XX XX @fun1 @fun2 @fun3 @fun4 XX XX XX XX XX
            XX esc end up home pgup XX XX f4 f3 f2 f1 XX
            XX XX XX XX XX XX XX XX XX XX XX XX XX
            XX XX XX XX XX XX XX XX XX XX
          )

          (deflayer sym
            XX XX XX XX XX XX XX XX _ XX XX XX XX XX XX XX
            XX @dblq @rcbr @lcbr @plus k XX XX b v c x z XX XX XX XX
            XX apo rbrc lbrc eql min XX d \ @pipe grv @tild XX XX XX XX XX
            XX @rpar @lpar @star @espr @cret XX @perc @doll @pnd @com @bang XX
            XX XX XX XX XX XX XX XX XX XX XX XX XX
            XX XX XX XX XX XX XX XX XX XX
          )
        '';
      };
    };
  };

  services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
    prime = {
      sync.enable = true;
      offload.enable = false;
      offload.enableOffloadCmd = false;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  services.xserver = {
    enable = true;
    windowManager.bspwm.enable = true;
    displayManager.lightdm.enable = true;
    dpi = 96;
    xkb.layout = "us";
    xkb.options = "caps:escape";
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    audio.enable = true;
    wireplumber.extraConfig = {
      "10-bluez" = {
        "monitor.bluez.properties" = {
          "bluez5.roles" = [ "a2dp_sink" "a2dp_source" "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
          "bluez5.headset-roles" = [ "hsp_hs" "hfp_hf" ];
          "bluez5.codecs" = [ "ldac" "aptx_hd" "aptx" "aac" "sbc_xq" "sbc" ];
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.default-profile" = "a2dp-sink";
        };
      }; 
    };
  };

  services.libinput.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  security.polkit.enable = true;

  users.users.jff = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
      alacritty
      pcmanfm
      sxhkd
      picom
      tmux
      playerctl
      dunst
      xsel
      slock
      qmk
    ];
  };

  programs.slock.enable = true;

  system.stateVersion = "26.05";
}
