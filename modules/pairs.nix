{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.pairs;
in
{
  options.pairs.enable = mkEnableOption "Enables pairs";

  config = mkIf (cfg.enable) {
    nvim.luaConfigRC = ''
      require("mini.pairs").setup({})
    '';
  };
}
