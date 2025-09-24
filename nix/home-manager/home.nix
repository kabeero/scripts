{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "mkgz";
  home.homeDirectory = "/home/mkgz";

  home.packages = with pkgs; [
    git
    (import ../nixpkgs/hypr-i3-move/default.nix { inherit pkgs; })
  ];

  services.gpg-agent.enable = true;
  # services.redshift.enable = true;

  programs.git = {
    enable = true;
    userName = "M K Gharzai";
    userEmail = "kabeer@gharzai.net";
  };
}
