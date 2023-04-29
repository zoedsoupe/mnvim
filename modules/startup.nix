{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.startup;
in
{
  options.startup.enable = mkEnableOption "Enables startup";

  config = mkIf (cfg.enable) {
    nvim.luaConfigRC = ''
      require("mini.sessions").setup({})

      local starter = require("mini.starter")
      starter.setup({
        evaluate_single = true,
        header = "",
        items = {
          starter.sections.builtin_actions(),
          starter.sections.recent_files(10, false),
          starter.sections.recent_files(10, true),
          starter.sections.sessions(5, true),
        },
        content_hooks = {
          starter.gen_hook.adding_bullet(),
          starter.gen_hook.indexing("all", { "Builtin actions" }),
          starter.gen_hook.padding(3, 2),
        },
      })
    '';
  };
}
