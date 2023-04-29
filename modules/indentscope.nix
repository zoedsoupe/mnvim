{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.indentscope;
in
{
  options.indentscope.enable = mkEnableOption "Enables indentscope";

  config = mkIf (cfg.enable) {
    nvim.luaConfigRC = ''
      require("mini.indentscope").setup({})
    '';
  };
}
