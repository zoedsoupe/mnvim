{ lib, config, pkgs, ... }:

let
  inherit (lib) types mkOption writeIf;
  inherit (types) bool str int enum listOf;

  cfg = config.nvim;
in
{
  options.nvim = {
    colourTerm = mkOption {
      default = true;
      description = "Set terminal up for 256 colours";
      type = bool;
    };

    concealLevel = mkOption {
      default = 0;
      description = "Show up `` on markdown and ** in org";
      type = int;
    };

    colorColumn = mkOption {
      default = "";
      description = "Comma separated list of screen columns that are highlighted with ColorColumn";
      type = str;
    };

    completeOpt = mkOption {
      default = [ ];
      description = "Completions options";
      type = listOf str;
    };

    foldMethod = mkOption {
      default = "syntax";
      description = "How to fold text blocks";
      type = str;
    };

    hlSearch = mkOption {
      default = false;
      description = "Highlight all matches of a previous search pattern";
      type = bool;
    };

    background = mkOption {
      default = "light";
      description = "Sets background color";
      type = str;
    };

    mapLeaderSpace = mkOption {
      default = true;
      description = "Map the space key to leader key";
      type = bool;
    };

    lineNumberMode = mkOption {
      default = "relNumber";
      description = "How line numbers are displayed. none relative number relNumber";
      type = enum [ "relative" "number" "relNumber" "none" ];
    };

    preventJunkFiles = mkOption {
      default = true;
      description = "Prevent swapfile backupfile from being created";
      type = bool;
    };

    tabWidth = mkOption {
      default = 2;
      description = "Set the width of tabs to 2";
      type = int;
    };

    autoIndent = mkOption {
      default = true;
      description = "Enable auto indent";
      type = bool;
    };

    cmdHeight = mkOption {
      default = 2;
      description = "Hight of the command pane";
      type = int;
    };

    showSignColumn = mkOption {
      default = true;
      description = "Show the sign column";
      type = bool;
    };

    bell = mkOption {
      default = "none";
      description = "Set how bells are handled. Options on visual or none";
      type = enum [ "none" "visual" "on" ];
    };

    mapTimeout = mkOption {
      default = 500;
      description = "Timeout microseconds that neovim will wait for mapped action to complete";
      type = int;
    };

    splitBelow = mkOption {
      default = true;
      description = "New splits will open below instead of on top";
      type = bool;
    };

    splitRight = mkOption {
      default = true;
      description = "New splits will open to the right";
      type = bool;
    };

    mouseSupport = mkOption {
      default = "a";
      description = "Set modes for mouse support. a - all n - normal v - visual i - insert c - command";
      type = types.str;
    };

    syntaxHighlighting = mkOption {
      default = true;
      description = "Enable syntax highlighting";
      type = bool;
    };
  };

  config = {
    nvim.startPlugins = with pkgs.neovimPlugins; [
      plenary-nvim
      mini-nvim
      direnv-vim
      nvim-web-devicons
    ];
    nvim.luaConfigRC = ''
      require("mini.tabline").setup({})
      -- disable netrw
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    '';
    nvim.configRC = ''
      set encoding=utf-8
      set fileencoding=utf-8
      set cursorline
      set autoread
      set so=999
      set noshowmode
      set timeoutlen=1000
      set incsearch
      set wildmenu
      set wildignore=+=**/node_modules/**,**/deps/**,**/_build/**
      set smartindent
      set laststatus=2
      set showtabline=0
      set ruler
      set pumheight=10
      set ignorecase
      set smartcase
      set mouse=${cfg.mouseSupport}
      set conceallevel=${toString cfg.concealLevel}
      set tabstop=${toString cfg.tabWidth}
      set shiftwidth=${toString cfg.tabWidth}
      set softtabstop=${toString cfg.tabWidth}
      set expandtab
      set cmdheight=${toString cfg.cmdHeight}
      set shortmess+=c
      set tm=${toString cfg.mapTimeout}
      set hidden
      ${writeIf cfg.splitBelow ''
      set splitbelow
      ''}
      ${writeIf cfg.splitRight ''
      set splitright
      ''}
      ${writeIf cfg.showSignColumn ''
      set signcolumn=yes
      ''}
      ${writeIf cfg.autoIndent ''
      set ai
      ''}
      ${writeIf cfg.preventJunkFiles ''
      set noswapfile
      set nobackup
      set nowritebackup
      ''}
      ${writeIf (cfg.bell == "none") ''
      set noerrorbells
      set novisualbell
      ''}
      ${writeIf (cfg.bell == "on") ''
      set novisualbell
      ''}
      ${writeIf (cfg.bell == "visual") ''
      set noerrorbells
      ''}
      ${writeIf (cfg.lineNumberMode == "relative") ''
      set relativenumber
      ''}
      ${writeIf (cfg.lineNumberMode == "number") ''
      set number
      ''}
      ${writeIf (cfg.lineNumberMode == "relNumber") ''
      set number relativenumber
      ''}
      ${writeIf cfg.mapLeaderSpace ''
      let mapleader=" "
      let maplocalleader=","
      ''}
      ${writeIf cfg.syntaxHighlighting ''
      syntax enable
      ''}
      ${writeIf cfg.hlSearch ''
      set hlsearch
      ''}
      ${writeIf cfg.colourTerm ''
      set termguicolors
      set t_Co=256
      ''}

      filetype plugin on
      filetype plugin indent on

      au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal
    '';
  };
}
