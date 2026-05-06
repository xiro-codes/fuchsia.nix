{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkOption types mkIf mkMerge;
  cfg = config.programs.fuchsia-nix;

  fuchsiaPkg = pkgs.callPackage ./package.nix {
    name = cfg.name;
    baseColor = cfg.colors.base;
    outlineColor = cfg.colors.outline;
  };

  defaultIndexTheme = pkgs.writeTextDir "share/icons/default/index.theme" ''
    [Icon Theme]
    Name=Default
    Comment=Default Cursor Theme
    Inherits=${cfg.name}
  '';

in {
  options.programs.fuchsia-nix = {
    enable = mkEnableOption "fuchsia-nix custom color build";

    name = mkOption {
      type = types.str;
      default = "Fuchsia";
      description = "The name of the generated cursor theme.";
    };

    size = mkOption {
      type = types.int;
      default = 24;
      description = "The size of the cursor.";
    };

    colors = {
      base = mkOption {
        type = types.str;
        default = "#E11C79";
        description = "Base/Accent color of the cursor.";
      };
      outline = mkOption {
        type = types.str;
        default = "#FFFFFF";
        description = "Outline color of the cursor.";
      };
    };

    stylixIntegration = {
      enable = mkEnableOption "Integration with Stylix to dynamically set colors";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [ fuchsiaPkg defaultIndexTheme ];
      
      environment.variables = {
        XCURSOR_THEME = cfg.name;
        XCURSOR_SIZE = toString cfg.size;
      };
    }
    (mkIf cfg.stylixIntegration.enable {
      programs.fuchsia-nix.colors.base = "#${config.lib.stylix.colors.base0D}";
      programs.fuchsia-nix.colors.outline = "#${config.lib.stylix.colors.base00}";
      
      stylix.cursor.package = fuchsiaPkg;
      stylix.cursor.name = cfg.name;
      stylix.cursor.size = cfg.size;
    })
  ]);
}
