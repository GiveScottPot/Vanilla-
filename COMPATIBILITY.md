# Vanilla+ Compatibility

Vanilla+ v1.3.0 is developed for **Gen1Recomp++ 0.2.56+** and supports Pokémon Red, Blue and Yellow.

Compatibility with other mods can vary by platform, Gen1Recomp++ version, load order and whether multiple mods hook the same controls, rendering systems, battle systems or overworld events. The notes below distinguish combinations actually tested during the v1.3.0 stabilization pass from current versions that were not part of this release QA.

## Tested during v1.3.0 QA

### Wilds of Kanto v2.1.9

**Status: Compatible in current v1.3.0 QA**

Current testing confirms:

- Toolkit Hot Air Balloon travel completes normally with Wilds enabled.
- Ordinary Pokémon Fly still works afterward.
- Vanilla+ fossil encounters can appear as Wilds overworld spawns.
- Mr. Mime is handed through the Wilds species-skin/refresh path correctly.
- ALL-CART merged encounter additions can appear as visible overworld spawns rather than only as random encounters.

The older public warning that Wilds suppressed Vanilla+ fossil encounters is no longer current for v1.3.0.

### DRAMALESS SHAPE v2.0.3

**Status: Compatible in current v1.3.0 QA**

The native 40×40 Balloon has been tested for correct orientation, vertical movement and takeoff/landing anchoring under the voxel renderer.

### PotatoVoxel v1.9.6

**Status: Compatible in current v1.3.0 QA**

The same Balloon compatibility path has been tested successfully. Ordinary player placement remains controlled by the normal Fly destination logic.

## Current versions not tested in this release QA

### Anime Realism v4.2.10

**Status: Not tested with v1.3.0**

Anime Realism was not included in the current v1.3.0 stabilization pass. Do not treat earlier compatibility results from older Anime Realism / Vanilla+ versions as confirmation for this exact combination.

### Weather FX v4.31.2

**Status: Not tested with v1.3.0**

Weather FX was not included in the current v1.3.0 stabilization pass. Compatibility with this exact version remains unverified for the release.

## Renderer / mod-stack note

Renderer and presentation mods can change internal draw paths between releases. If an issue appears, report the exact mod version and Gen1Recomp++ version used.

Do not stack multiple voxel/rendering mods unless their authors explicitly support that combination.

## Game / platform testing

### Pokémon Red

**Status: Primary QA baseline**

Red remains the main development and regression-testing cartridge.

### Pokémon Blue

**Status: Supported**

Vanilla+ is designed to support Blue alongside Red and Yellow. Continued cart-specific testing is welcome.

### Pokémon Yellow

**Status: Supported and actively tested**

v1.3.0's ALL-CART work specifically audits Yellow-only encounter availability and merges it without replacing the selected cartridge's base ecology.

## Save transfer / Expanded Storage

The normal Gen I player-facing storage limits are:

- **Bag: 20 distinct item slots**
- **Player PC: 50 distinct item slots**

Vanilla+'s optional **EXPANDED STORAGE** can exceed those limits. Before disabling the setting, removing Vanilla+, or moving a raw `.sav` to an environment without expanded storage:

1. Leave Expanded Storage enabled.
2. Use **Mom → PACK TOOLKIT** so supported Toolkit items are returned to ordinary storage.
3. Mom reports how many Toolkit-managed physical items are being returned; use that number as a practical guide while freeing normal storage space.
4. Reduce the packed save to no more than 20 Bag items and 50 Player PC items.
5. Only then disable/remove the feature or move the save.

Deleting ordinary consumables may free capacity without changing Mom's return count because her number reflects Toolkit-managed physical items being returned, not every item already in the Bag.

Items left beyond stock capacity may become inaccessible or be lost when the expanded-storage system is no longer active.

Raw `.sav` exports preserve normal SRAM but do not necessarily preserve Vanilla+/Recomp modData. PACK TOOLKIT exists specifically to make supported physical items portable through that limitation.

## Reporting compatibility problems

Include:

- Red, Blue or Yellow
- Exact Gen1Recomp++ version
- Platform/device
- Exact versions of other enabled mods
- Whether the issue occurs with Vanilla+ alone
- Whether a full app restart changes the behavior
- Screenshot/video and reproduction steps when possible
