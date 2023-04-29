{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.surround;
in
{
  options.surround.enable = mkEnableOption "Enables surround";

  config = mkIf (cfg.enable) {
    nvim.luaConfigRC = ''
      require("mini.surround").setup({})
    '';
  };
}
