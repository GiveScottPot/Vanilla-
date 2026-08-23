# Vanilla+ Compatibility

Vanilla+ Beta v1.2.1 is developed for Gen1Recomp++ and supports Pokémon Red, Blue, and Yellow.

Compatibility can vary by platform, Gen1Recomp++ version, load order, and other enabled mods. Entries below distinguish confirmed current testing from older known-good combinations.

## Current Tested / Known Compatibility

### Wilds of Kanto 2.1.9
**Status: Confirmed working in current iOS testing**

Beta v1.2.1 replaces Vanilla+'s previous SELECT/Register handling with a fixed-step input implementation. Vanilla+'s SELECT-based Toolkit/Register shortcuts are confirmed working alongside Wilds of Kanto 2.1.9 on the primary iOS test setup.

This resolves the SELECT conflict documented for Beta v1.2.0 on that tested setup. Additional platform testing is still welcome.

### Dramaless Shape Voxel 2.0.2
**Status: Tested working**

Dramaless Shape Voxel 2.0.2 has been tested alongside Vanilla+ without the earlier SELECT conflict.

### Dramatic Shape Voxel 1.9.0
**Status: Tested compatible in a known-good stack**

Dramatic Shape Voxel 1.9.0 has previously worked alongside Vanilla+.

### Potato Voxel
**Status: Previously tested compatible**

Potato Voxel has worked alongside Vanilla+ in prior testing. Version 1.8.3 is the current file available for compatibility retesting; do not treat that specific version as confirmed until it has been exercised with this hotfix.

### Anime Realism
**Status: Previously tested compatible**

Anime Realism has worked alongside Vanilla+ in prior testing. Version 4.0.2 is available for current compatibility retesting; do not treat that specific version as confirmed until it has been exercised with this hotfix.

## Game / Platform Testing

### Pokémon Red
**Status: Primary QA baseline**

Red remains the primary Vanilla+ development and regression-testing baseline.

### Pokémon Yellow
**Status: Working in confirmed prior testing**

Independent Windows testing has confirmed Vanilla+ functioning with Pokémon Yellow. Continue reporting exact platform, Gen1Recomp++ version, and mod stack when testing.

### Pokémon Blue
**Status: Supported**

Vanilla+ is designed to support Blue alongside Red and Yellow. Additional Blue-specific regression testing remains welcome.

## Beta v1.2.1 SELECT Hotfix

Vanilla+ uses SELECT for:
- Adventurer's Toolkit quick access
- Registered Toolkit-compatible shortcuts
- Direct registered TM/HM Bag access
- TM/HM Bag sorting

Beta v1.2.1 moves this handling to Gen1Recomp++'s fixed-step input queue rather than relying on the older SELECT interception approach.

Wilds of Kanto 2.1.9 is confirmed working with this new implementation on the primary iOS test setup.

Cross-platform verification remains important, particularly on Windows, Android, Linux, macOS, handheld ports, and controller configurations.

## Toolkit Acquisition / Migration

Toolkit functionality no longer depends solely on the original acquisition event having run. If Vanilla+ detects that the player already owns the Toolkit, it can initialize the required Toolkit state automatically.

This makes the system more resilient to existing saves, migrations, cheats/save editors, and compatible external acquisition methods.

## Reporting Compatibility Problems

Please include:
- Game: Red, Blue, or Yellow
- Platform/device
- Exact Gen1Recomp++ version
- Vanilla+ version
- Other enabled mods and exact versions
- Input method when relevant: touchscreen, keyboard, or controller
- Whether the issue occurs with Vanilla+ by itself
- Reproduction steps
- Screenshot or video when possible

Back up important saves before changing Gen1Recomp++ versions or significantly changing your mod stack.

## Help Wanted

Compatibility testing is especially useful for Pokémon Blue/Yellow, Windows, Android, Linux, macOS, handheld ports, controller configurations, Wilds combinations, battle-overhaul mods, and voxel/rendering combinations.
