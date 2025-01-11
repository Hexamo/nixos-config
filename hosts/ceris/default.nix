{
  vars,
  ...
}:

{

  imports = [
    ./hardware-configuration.nix # Handles Hardware configurations for this machine
    ./../../modules/nixos
  ];
  networking.hostName = vars.hostname;

  feature = {
    networking.enable = true;
    networking.firewall.enable = true;
    work-pkgs.enable = true;
  };

  # nos = {
  #   system = {
  #     networking.enable = true;
  #   };
  #   work-pkgs.enable = true;
  #   #desktop.gnome.enable = true;
  #
  # };

}
