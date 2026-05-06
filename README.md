![Fuchsia](https://github.com/ful1e5/fuchsia-cursor/assets/24286590/68223b08-7020-4cb6-8d97-090bacef62d6)

First open source port of [FuchsiaOS](https://fuchsia.dev/)'s cursors for **Linux** and **Windows**.

> **Note**: This is a fork of the original `fuchsia-cursor` project. It specifically aims to add NixOS support, Home Manager modules, and Stylix integration.

[![build](https://github.com/ful1e5/fuchsia-cursor/actions/workflows/build.yml/badge.svg)](https://github.com/ful1e5/fuchsia-cursor/actions)

## Notes

-   All cursor's SVG files are found in [svg](./svg) directory or you can also find them on [Figma](https://www.figma.com/design/jPmS71GFhBN4NUTZx4VHbg/Fuchsia-Cursor?node-id=0-1&t=QIgHaHw4N75yeUkU-1).

<!-- If you're interested, you can learn more about "sponsor-spotlight" on
 https://dev.to/ful1e5/lets-give-recognition-to-those-supporting-our-work-on-github-sponsors-b00 -->

![shoutout-sponsors](https://sponsor-spotlight.vercel.app/sponsor?login=ful1e5)

-   **2024-06-24**: [f3ca511](https://github.com/ful1e5/fuchsia-cursor/commit/f3ca5116adc9c428e56e248758d11d8d8cfaf682) Partitioned cursor build configuration into multiple files according to platform:
    `build.toml` -> `configs/win_lg.build.toml`, `configs/win_rg.build.toml`, `configs/win_xl.build.toml`, `configs/x.build.toml`.

---

![Fuchsia](https://github.com/ful1e5/fuchsia-cursor/assets/24286590/11dc68d3-fc78-4481-a829-2d05add9833a)
![Fuchsia-Amber](https://github.com/ful1e5/fuchsia-cursor/assets/24286590/49213cb0-be9d-4159-8929-0fd5fcd8aee4)
![Fuchsia-Red](https://github.com/ful1e5/fuchsia-cursor/assets/24286590/9d0b8668-6a0d-4176-a64c-1f7982926425)
![Fuchsia-Pop!](https://github.com/ful1e5/fuchsia-cursor/assets/24286590/f53f5edd-67f3-4d56-97f3-bb80677a277a)

## Cursor Sizes

### Xcursor Sizes:

<kbd>16</kbd>
<kbd>20</kbd>
<kbd>22</kbd>
<kbd>24</kbd>
<kbd>28</kbd>
<kbd>32</kbd>
<kbd>40</kbd>
<kbd>48</kbd>
<kbd>56</kbd>
<kbd>64</kbd>
<kbd>72</kbd>
<kbd>80</kbd>
<kbd>88</kbd>
<kbd>96</kbd>

### Windows Cursor Size:

| size | Regular (× ²⁄₃) | Large (× ⁴⁄₅) | Extra-Large (× 1) |
| ---: | --------------: | ------------: | ----------------: |
|   32 |     21.333 → 22 |     25.6 → 26 |                32 |
|   48 |              32 |     38.4 → 39 |                48 |
|   64 |     42.666 → 43 |     51.2 → 52 |                64 |
|   96 |              64 |     76.8 → 77 |                96 |
|  128 |     85.333 → 86 |   102.4 → 103 |               128 |

## Colors

### Fuchsia

-   Outline Color - `#FFFFFF` (White)
-   Base Color - `#E11C79` (Fuchsia)

### Fuchsia Amber

-   Outline Color - `#FFFFFF` (White)
-   Base Color - `#FFA400` (Amber)

### Fuchsia Red

-   Outline Color - `#FFFFFF` (White)
-   Base Color - `#FF0000` (Red)

### Fuchsia Pop!

-   Outline Color - `#FFFFFF` (White)
-   Base Color - `#F8B572` (PopOS Orange)

## Usage (Nix & Home Manager)

This repository provides a Nix flake with a package and a Home Manager module to easily generate and install your customized cursor.

### Flake Setup

Add the repository to your `flake.nix` inputs:

```nix
inputs = {
  # ...
  fuchsia-nix.url = "github:tod/fuchsia-nix"; # Replace with the actual URL if different
};
```

### Home Manager Module Example

To use the module via Home Manager, import it in your flake and configure your colors:

```nix
outputs = { self, nixpkgs, home-manager, fuchsia-nix, ... }: {
  nixosConfigurations."your-hostname" = nixpkgs.lib.nixosSystem {
    modules = [
      home-manager.nixosModules.home-manager
      {
        home-manager.users.your-username = {
          imports = [ fuchsia-nix.homeModules.default ];
          
          programs.fuchsia-nix = {
            enable = true;
            name = "Fuchsia-Custom"; # Name of the generated theme
            colors = {
              base = "#00FE00";    # Base/Accent color
              outline = "#000000"; # Outline color
            };
          };
        };
      }
    ];
  };
};
```

### NixOS System-Wide Module Example

If you want to apply the cursor system-wide (for all users, Display Managers like SDDM/GDM, etc.) regardless of whether you are using GNOME, KDE, or window managers, you can import the NixOS module. It sets the `XCURSOR_THEME` globally and provides a fallback `index.theme`.

```nix
outputs = { self, nixpkgs, fuchsia-nix, ... }: {
  nixosConfigurations."your-hostname" = nixpkgs.lib.nixosSystem {
    modules = [
      ./configuration.nix
      fuchsia-nix.nixosModules.default
      {
        programs.fuchsia-nix = {
          enable = true;
          name = "Fuchsia-System";
          size = 24; # Global cursor size
          colors = {
            base = "#E11C79";
            outline = "#FFFFFF";
          };
        };
      }
    ];
  };
};
```

### Stylix Integration

If you use [Stylix](https://github.com/danth/stylix) for system-wide theming, this module can automatically grab the appropriate colors from your Stylix palette:

```nix
programs.fuchsia-nix = {
  enable = true;
  name = "Fuchsia-Stylix";
  stylixIntegration.enable = true;
};
```

When `stylixIntegration.enable` is true, it will automatically set `stylix.cursor.package` and `stylix.cursor.name` to use your customized Fuchsia cursor.

## Testing Cursor

There are several websites that allow you to test your cursor states by hovering over buttons. This can be very useful when developing or verifying the behavior of a cursor. The following websites cover many of the most commonly used cursors, although they may not include all available options.

-   [Cursor-Test](https://vibhorjaiswal.github.io/Cursor-Test/)
-   [Mozilla CSS Cursor](https://developer.mozilla.org/en-US/docs/Web/CSS/cursor)

For a blueprint for creating XCursors, you may also want to refer to [Cursor-demo](https://wiki.tcl-lang.org/page/Cursor+demo).

## Bugs

Bugs should be reported [here](https://github.com/ful1e5/Fuchsia/issues) on the Github issues page.

## Getting Help

You can create a **issue**, I will help you.

## Contributing

Check [CONTRIBUTING.md](CONTRIBUTING.md), any suggestions for features and contributions to the continuing code masterelopment can be made via the issue tracker or code contributions via a `Fork` & `Pull requests`.
