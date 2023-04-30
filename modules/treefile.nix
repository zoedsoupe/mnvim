{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.treefile;
in
{
  options.treefile.enable = mkEnableOption "Enables treefile";

  config = mkIf (cfg.enable) {
    nvim.startPlugins = with pkgs.neovimPlugins; [ nvim-tree-lua ];
    nvim.configRC = ''
      highlight! NvimTreeBg guibg=None cterm=None
      highlight! NvimTreeFolderIcon guibg=None ctermbg=None
    '';
    nvim.luaConfigRC = ''
      require'nvim-tree'.setup({
        disable_netrw = true,
        hijack_netrw = true,
        open_on_tab = true,
        diagnostics = {
          enable = true,
        },
        view  = {
          width = "40",
          side = "left",
        },
        renderer = {
          add_trailing = false,
          group_empty = true,
          indent_markers = {
            enable = true,
          },
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = false,
            },

            glyphs = {
              default = "",
              symlink = "",
              folder = {
                default = "",
                empty = "",
                empty_open = "",
                open = "",
                symlink = "",
                symlink_open = "",
                arrow_open = "",
                arrow_closed = "",
              },
              git = {
                unstaged = "✗",
                staged = "✓",
                unmerged = "",
                renamed = "➜",
                untracked = "★",
                deleted = "",
                ignored = "◌",
              },
            },
          },
        },
        actions = {
          open_file = {
            quit_on_open = false,
            resize_window = true,
          },
        },
        git = {
          enable = true,
          ignore = true,
        },
        filters = {
          dotfiles = false,
          custom = {".git", "node_modules", ".cache", "_build", "deps"},
        },
      })

      vim.api.nvim_set_keymap("n", "<C-F>", ":NvimTreeToggle<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<C-s>", ":NvimTreeFindFile<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>tr", ":NvimTreeRefresh<CR>", { noremap = true })
    '';
  };
}
