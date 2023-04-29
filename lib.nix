{ pkgs, inputs }:

let
  inherit (pkgs.lib) evalModules;
in
{
  withPlugins = cond: plugins: if cond then plugins else [ ];
  writeIf = cond: msg: if cond then msg else "";

  mkNeovim = { config }:
    let
      inherit (nvimOpts.config) nvim;
      nvimOpts = evalModules {
        modules = [{ imports = [ ./modules ]; } config];
        specialArgs = { inherit pkgs; };
      };
    in
    pkgs.wrapNeovim pkgs.neovim-unwrapped {
      withNodeJs = true;
      withPython3 = true;
      configure = {
        customRC = nvim.configRC;
        packages.myVimPackage = {
          start = builtins.filter (f: f != null) nvim.startPlugins;
          opt = nvim.optPlugins;
        };
      };
    };

  buildPluginOverlay = super: self:
    let
      inherit (builtins) attrNames filter listToAttrs getAttr;
      inherit (self.vimUtils) buildVimPluginFrom2Nix;

      treesitterGrammars = self.tree-sitter.withPlugins (p: with p; [
        tree-sitter-bash
        tree-sitter-css
        tree-sitter-dockerfile
        tree-sitter-elixir
        tree-sitter-html
        tree-sitter-json
        tree-sitter-lua
        tree-sitter-nix
        tree-sitter-rust
        tree-sitter-toml
        tree-sitter-typescript
        tree-sitter-yaml
      ]);

      buildPlugin = name: buildVimPluginFrom2Nix {
        pname = name;
        version = "HEAD";
        src = getAttr name inputs;
        postPatch =
          if (name == "nvim-treesitter")
          then ''
            rm -r parser
            ln -s ${treesitterGrammars} parser
          ''
          else "";
      };

      isPlugin = n: n != "neovim" && n != "nixpkgs" && n != "flake-utils";
      plugins = filter isPlugin (attrNames inputs);
    in
    {
      neovimPlugins = listToAttrs
        (map
          (name: {
            inherit name;
            value = buildPlugin name;
          })
          plugins);
    };
}
