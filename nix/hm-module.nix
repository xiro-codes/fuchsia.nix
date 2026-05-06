{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkOption types mkIf mkMerge;
  cfg = config.programs.fuchsia-cursor;

  fuchsiaPkg = pkgs.callPackage ./package.nix {
    name = cfg.name;
    baseColor = cfg.colors.base;
    outlineColor = cfg.colors.outline;
  };

in {
  options.programs.fuchsia-cursor = {
    enable = mkEnableOption "fuchsia-cursor custom color build";

    name = mkOption {
      type = types.str;
      default = "Fuchsia";
      description = "The name of the generated cursor theme.";
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
      home.packages = [ fuchsiaPkg ];
    }
    (mkIf cfg.stylixIntegration.enable {
      programs.fuchsia-cursor.colors.base = "#${config.lib.stylix.colors.base0D}";
      programs.fuchsia-cursor.colors.outline = "#${config.lib.stylix.colors.base00}";
      
      stylix.cursor.package = fuchsiaPkg;
      stylix.cursor.name = cfg.name;
    })
  ]);
}
