{
  pkgs,
  vars,
  pkgs-unstable,
  ...
}:

{

  imports = [
    ./../../modules/home-manager/default.nix
  ];

  feature = {
    desktop.hyprland.enable = false;
    desktop.river.enable = true;
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = vars.username;
    homeDirectory = "/home/${vars.username}";
    stateVersion = "24.11"; # Please read the comment before changing.
  };
  systemd.user.startServices = "sd-switch";

  home.packages = [
    pkgs.hello
    pkgs.fastfetch
    pkgs.git-crypt
    pkgs.keepassxc
    pkgs.nextcloud-client
    pkgs.notify

    (pkgs.nerdfonts.override {
      fonts = [
        "Iosevka"
        "FantasqueSansMono"
        "Mononoki"
        "Meslo"
      ];
    })

  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mads/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  #programs.home-manager.enable = true;

  # Enable direnv for nix
  # For more information see: https://github.com/nix-community/nix-direnv
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };

    bash.enable = true; # see note on other shells below
  };

  programs.tmux = {
    enable = true;
  };

  programs.ssh = {
    # all my ssh private key are generated by `ssh-keygen -t ed25519 -C "name@example.com"`
    # the config's format:
    #   Host —  given the pattern used to match against the host name given on the command line.
    #   HostName — specify nickname or abbreviation for host
    #   IdentityFile — the location of your SSH key authentication file for the account.
    # format in details:
    #   https://www.ssh.com/academy/ssh/config
    enable = true;
    addKeysToAgent = "1d";
    extraConfig = ''
      # a private key that is used during authentication will be added to ssh-agent if it is running
      AddKeysToAgent yes

      Host 192.168.*
        # allow to securely use local SSH agent to authenticate on the remote machine.
        # It has the same effect as adding cli option `ssh -A user@host`
        ForwardAgent yes
        # romantic holds my homelab~
        # IdentityFile /etc/agenix/ssh-key-romantic
        # Specifies that ssh should only use the identity file explicitly configured above
        # required to prevent sending default identity files first.
        #IdentitiesOnly yes

      Host Docker
        HostName 192.168.60.5
        Port 2345
        ForwardAgent yes
    '';
  };
  services.ssh-agent.enable = true;

  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscode-fhs;
    mutableExtensionsDir = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    extensions = with pkgs; [

      # General plugins
      open-vsx.mikestead.dotenv
      open-vsx.pflannery.vscode-versionlens

      # Nix related
      # vscode-marketplace.github.copilot
      # vscode-marketplace.github.copilot-chat
      open-vsx.jnoortheen.nix-ide
      #alvarosannas.nix

      # Bash
      open-vsx.timonwong.shellcheck
      open-vsx.mads-hartmann.bash-ide-vscode
      open-vsx.mkhl.shfmt

      # Python
      open-vsx.ms-python.python

      # Formatting
      open-vsx.esbenp.prettier-vscode

      # YAML
      open-vsx.redhat.vscode-yaml

      # Markdown
      open-vsx.yzhang.markdown-all-in-one
      open-vsx.davidanson.vscode-markdownlint
    ];
  };
}
