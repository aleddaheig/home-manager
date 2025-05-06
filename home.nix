{ config, pkgs, ... }:

{
  imports = [
    ./nixvim
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "anon";
  home.homeDirectory = "/home/anon";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Any package available on Nixpkgs
    btop
    fd
    ripgrep
  ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;

    # Aliases
    shellAliases = {
      sail = "[ -f sail ] && sh sail || sh vendor/bin/sail";
      rails = "[ -f rails ] && rails || bin/rails";
      # Uncomment and add more if you wish
      # ll = "ls -l";
      # la = "ls -A";
      # l = "ls -CF";
    };

    # Extra bashrc content
    initExtra = ''
      # History settings
      HISTCONTROL=ignoreboth
      shopt -s histappend
      HISTSIZE=1000
      HISTFILESIZE=2000
      shopt -s checkwinsize

      # Color support for ls and grep
      if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        #alias dir='dir --color=auto'
        #alias vdir='vdir --color=auto'
        #alias grep='grep --color=auto'
        #alias fgrep='fgrep --color=auto'
        #alias egrep='egrep --color=auto'
      fi

      # Enable programmable completion if available
      if ! shopt -oq posix; then
        if [ -f /usr/share/bash-completion/bash_completion ]; then
          . /usr/share/bash-completion/bash_completion
        elif [ -f /etc/bash_completion ]; then
          . /etc/bash_completion
        fi
      fi

      . "${pkgs.git}/share/git/contrib/completion/git-prompt.sh"
      export PS1='\[\033[01;32m\]\u@\h \[\033[01;36m\]\w\[\033[01;34m\]$(__git_ps1 " (%s)")\[\033[00m\] \$ '
    '';
  };

  # Session variables (exported env vars)
  home.sessionVariables = {
    VSCODE_GALLERY_SERVICE_URL = "https://marketplace.visualstudio.com/_apis/public/gallery";
    VSCODE_GALLERY_ITEM_URL = "https://marketplace.visualstudio.com/items";
    EDITOR = "nvim";
  };

  home.sessionPath = [
    "$HOME/go/bin"
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  # Set environment variable as fallback
  home.sessionVariables = {
    GTK_THEME = "Adwaita:dark";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
