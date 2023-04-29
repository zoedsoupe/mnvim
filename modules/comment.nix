{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.comment;
in
{
  options.comment.enable = mkEnableOption "Enables comment";

  config = mkIf (cfg.enable) {
    nvim.luaConfigRC = ''
      require("mini.comment").setup({})
    '';
  };
}
