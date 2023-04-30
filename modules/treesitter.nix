{ pkgs, lib, config, ... }:

let
  inherit (pkgs) neovimPlugins;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.treesitter;
in
{
  options.treesitter.enable = mkEnableOption "Enables nvim-treesitter";

  config = mkIf cfg.enable {
    nvim.startPlugins = with neovimPlugins; [
      nvim-treesitter
      nvim-ts-rainbow
      nvim-ts-autotag
      nvim-treesitter-context
    ];
    nvim.luaConfigRC = ''
      vim.g.foldmethod = "expr"
      vim.g.foldexpr = "nvim_treesitter#foldexpr()"
      vim.g.nofoldenable = 1

      require('nvim-treesitter.configs').setup({
        highlight = {
          enable = true,
          use_languagetree = true,
        },
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil
        },
        autotag = {
          enable = true,
        },
      })

      require'treesitter-context'.setup {
        enable = true,
        throttle = true,
        max_lines = 0
      }
    '';
  };
}
