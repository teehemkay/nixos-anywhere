{ modulesPath, lib, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];

  # makes the network interfaces use more familiar names (eth0)
  # https://joinemm.dev/blog/nixos-hetzner-cloud#system-configuration
  boot.kernelParams = [ "net.ifnames=0" ];

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "prohibit-password";

  # Enable the user to use sudo without a password.
  # It makes it easier to update the server remotely.
  # https://joinemm.dev/blog/nixos-hetzner-cloud#system-configuration
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  environment.systemPackages =
    map lib.lowPrio [ pkgs.vim pkgs.curl pkgs.gitMinimal ];

  programs.fish.enable = true;
  programs.fish.useBabelfish = true;

  users.users.root.initialHashedPassword = "";
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKILtMsWYC08UX9hLc5OZaq14vXEn6dImCQH+exaptNw tmk@ext"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrAOmkF4mkiP1DL25fkvCl+UbLtjgiyUL6cuitIsFPlumVE+CRpOOiM6ylmSWFmwa9RTQ+b+SVpwqOp7QYJgzHHRJqa1e9CJt1eE28ZvOr8cLHAc5kmTgZFvTidPUOlXPwjd3g3wmp4iAK3/x5I7g8vVy9k6rlrUZ3GM+Jtq19GH3D6JfAYwz8GbEn6VUuBQqwlOQet3NkvcnalgB0Ndib0gkBI9kBEuS8r4mdsY/k2xvRBalUDRvgfzdUKwJp59FPnOLStrCz7mkzU6gEbUykF21vIlUMgOaVlPH/ZoXbKb6dRE7/SHLbn8uwBGHyPTecfaVr8qn8EU4K8paN/RITnJoL9gm9gs1BsUe+KNNnggMDGLs//+fWUreJ6GrUTBEoB4m1WZPnlO2pgKE+Xnp2I+YLkSxspj8yZKLB3tzAx7LJlhXMG1WAhryr3t9OfRMs+L+cp+OA7D3d8HvzmPvdVH8ycn8+Sj2K1j+ThEOPFSKXOdksIGd1LisNS1/TPI0jHv8O6MDUI38cAwq1Xqrk9mxH5j0pr0VpEbB9aQ7vLNvJUzAoh4opZ4U/7eX1rIgVjUlLADlBn+C34HXP7sl381rCfJn4SvXACc7vlP6rXdNVzeIMi0MW7uqecMrBnEISYEwi6uQnfz4bqQ/zGxZMTYAX4xysZr4onrG3bvcH3Q== tmk@ext"
  ];
  users.users.tmk = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKILtMsWYC08UX9hLc5OZaq14vXEn6dImCQH+exaptNw tmk@ext"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrAOmkF4mkiP1DL25fkvCl+UbLtjgiyUL6cuitIsFPlumVE+CRpOOiM6ylmSWFmwa9RTQ+b+SVpwqOp7QYJgzHHRJqa1e9CJt1eE28ZvOr8cLHAc5kmTgZFvTidPUOlXPwjd3g3wmp4iAK3/x5I7g8vVy9k6rlrUZ3GM+Jtq19GH3D6JfAYwz8GbEn6VUuBQqwlOQet3NkvcnalgB0Ndib0gkBI9kBEuS8r4mdsY/k2xvRBalUDRvgfzdUKwJp59FPnOLStrCz7mkzU6gEbUykF21vIlUMgOaVlPH/ZoXbKb6dRE7/SHLbn8uwBGHyPTecfaVr8qn8EU4K8paN/RITnJoL9gm9gs1BsUe+KNNnggMDGLs//+fWUreJ6GrUTBEoB4m1WZPnlO2pgKE+Xnp2I+YLkSxspj8yZKLB3tzAx7LJlhXMG1WAhryr3t9OfRMs+L+cp+OA7D3d8HvzmPvdVH8ycn8+Sj2K1j+ThEOPFSKXOdksIGd1LisNS1/TPI0jHv8O6MDUI38cAwq1Xqrk9mxH5j0pr0VpEbB9aQ7vLNvJUzAoh4opZ4U/7eX1rIgVjUlLADlBn+C34HXP7sl381rCfJn4SvXACc7vlP6rXdNVzeIMi0MW7uqecMrBnEISYEwi6uQnfz4bqQ/zGxZMTYAX4xysZr4onrG3bvcH3Q== tmk@ext"
    ];
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "24.11";
}
