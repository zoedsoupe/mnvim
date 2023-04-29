{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cursorword;
in
{
  options.cursorword.enable = mkEnableOption "Enables cursorword";

  config = mkIf (cfg.enable) {
    nvim.luaConfigRC = ''
      require("mini.cursorword").setup({})
    '';
  };
}
