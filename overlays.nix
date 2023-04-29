{ lib }:

let
  libOverlay = f: p: {
    lib = p.lib.extend (_: _: {
      inherit (lib) withPlugins writeIf;
    });
  };
in
{
  overlays = [ lib.buildPluginOverlay libOverlay ];
}
