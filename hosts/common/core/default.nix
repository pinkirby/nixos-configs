{ pkgs, ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  programs.zsh.enable = true;
  services.openssh.enable = true;

  programs.bat = {
    enable = true;
    settings = {
      paging = "always";
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    neovim
    less
    bat
    man-db
    man-pages
    git
    zip
    unzip
    fzf
    ffmpeg
    zsh
  ];
}
