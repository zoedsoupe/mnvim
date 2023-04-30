{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.telescope;
in
{
  options.telescope.enable = mkEnableOption "Enables telescope";

  config = mkIf (cfg.enable) {
    nvim.startPlugins = with pkgs.neovimPlugins; [ telescope ];
    nvim.luaConfigRC = ''
      require("telescope").setup({
        defaults = {
          vimgrep_arguments = {
            "${pkgs.ripgrep}/bin/rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case"
          },
          pickers = {
            find_command = {
              "${pkgs.fd}/bin/fd",
            },
          },
        }})

      function nmap(lhs, rhs, opts)
        local options = { noremap = true }
        if opts then
          options = vim.tbl_extend("force", options, opts)
        end
        vim.api.nvim_set_keymap("n", lhs, rhs, options)
      end

       nmap("<leader>ff", "<cmd>Telescope find_files<CR>")
       nmap("<leader>fg", "<cmd>Telescope live_grep<CR>")
       nmap("<leader>fb", "<cmd>Telescope buffers<CR>")
       nmap("<leader>fh", "<cmd>Telescope help_tags<CR>")
       nmap("<leader>ft", "<cmd>Telescope<CR>")
       nmap("<leader>fvcw", "<cmd>Telescope git_commits<CR>")
       nmap("<leader>fvcb", "<cmd>Telescope git_bcommits<CR>")
       nmap("<leader>fvb", "<cmd>Telescope git_branches<CR>")
       nmap("<leader>fvs", "<cmd>Telescope git_status<CR>")
       nmap("<leader>fvx", "<cmd>Telescope git_stash<CR>")

       -- treesitter
       nmap("<leader>fs", "<cmd>Telescope treesitter<CR>")

       -- LSP
      nmap("<leader>flsb", "<cmd> Telescope lsp_document_symbols<CR>")
      nmap("<leader>flsw", "<cmd> Telescope lsp_workspace_symbols<CR>")
      nmap("<leader>flr", "<cmd> Telescope lsp_references<CR>")
      nmap("<leader>fli", "<cmd> Telescope lsp_implementations<CR>")
      nmap("<leader>flD", "<cmd> Telescope lsp_definitions<CR>")
      nmap("<leader>flt", "<cmd> Telescope lsp_type_definitions<CR>")
      nmap("<leader>fld", "<cmd> Telescope diagnostics<CR>")
    '';
  };
}
