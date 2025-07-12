{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    fastfetch # system info
    zoxide # better cd
    bat # better cat
    eza # better ls
    fd # faster find
    fzf # fuzzy finder
    ripgrep # faster grep
    xdg-utils # commands such as xdg-open
    cmake # build tools
    gnumake # build tools
    uutils-coreutils-noprefix # ls,cp,mv
    uutils-findutils # find
    uutils-diffutils # diff
  ];
}
