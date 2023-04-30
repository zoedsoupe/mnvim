{
  description = "A minimal nvim config, modular with nix, based on copper";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.11;
    flake-utils.url = github:numtide/flake-utils;

    # Plugins
    mini-nvim = {
      url = github:echasnovski/mini.nvim;
      flake = false;
    };

    plenary-nvim = {
      url = github:nvim-lua/plenary.nvim;
      flake = false;
    };

    nvim-lspconfig = {
      url = github:neovim/nvim-lspconfig;
      flake = false;
    };

    direnv-vim = {
      url = github:direnv/direnv.vim;
      flake = false;
    };

    vim-elixir = {
      url = github:elixir-editors/vim-elixir;
      flake = false;
    };

    conjure = {
      url = github:Olical/conjure;
      flake = false;
    };

    vim-sexp = {
      url = github:guns/vim-sexp;
      flake = false;
    };

    vim-sexp-mappings = {
      url = github:tpope/vim-sexp-mappings-for-regular-people;
      flake = false;
    };

    catppuccin = {
      url = github:catppuccin/nvim;
      flake = false;
    };

    telescope = {
      url = github:nvim-telescope/telescope.nvim;
      flake = false;
    };

    nvim-tree-lua = {
      url = github:nvim-tree/nvim-tree.lua;
      flake = false;
    };

    nvim-web-devicons = {
      url = github:nvim-tree/nvim-web-devicons;
      flake = false;
    };

    nvim-treesitter = {
      url = github:nvim-treesitter/nvim-treesitter;
      flake = false;
    };

    nvim-ts-rainbow = {
      url = github:p00f/nvim-ts-rainbow;
      flake = false;
    };

    nvim-ts-autotag = {
      url = github:windwp/nvim-ts-autotag;
      flake = false;
    };

    nvim-treesitter-context = {
      url = github:lewis6991/nvim-treesitter-context;
      flake = false;
    };
  };

  outputs = { nixpkgs, flake-utils, self, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        lib = import ./lib.nix { inherit pkgs inputs; };

        inherit (import ./overlays.nix { inherit lib; }) overlays;

        config = {
          cursorword.enable = true;
          indentscope.enable = true;
          lsp = {
            enable = true;
            clojure = true;
            elixir = true;
            rust = true;
            nix = true;
          };
          pairs.enable = true;
          startup.enable = true;
          statusline.enable = true;
          surround.enable = true;
          telescope.enable = true;
          theme.enable = true;
          treefile.enable = true;
          treesitter.enable = true;
        };
      in
      rec {
        apps = rec {
          neovim = {
            type = "app";
            program = "${self.packages.default}/bin/nvim";
          };
          default = neovim;
        };

        packages = rec {
          default = mnvim;
          mnvim = lib.mkNeovim { inherit config; };
        };

        overlays.default = super: self: {
          inherit (lib) mkNeovim;
          inherit (pkgs) neovimPlugins;
          inherit (packages) mnvim;
        };
      });
}
