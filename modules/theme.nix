{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.theme;
in
{
  options.theme.enable = mkEnableOption "Enables theme";

  config = mkIf (cfg.enable) {
    nvim.startPlugins = with pkgs.neovimPlugins; [ catppuccin ];
    nvim.configRC = ''
      if $TERMCS ==# "light"
        set background=light
      else
        set background=dark
      endif
    '';
    nvim.luaConfigRC = ''
      require("catppuccin").setup({
        flavour = "macchiato",
        background = {
          light = "latte",
          dark = "macchiato"
        },
        transparent_background = false,
      })
      vim.cmd("colo catppuccin")
    '';
  };
}
