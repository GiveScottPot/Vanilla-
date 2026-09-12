# Vanilla+ v1.3.0

Vanilla+ v1.3.0 is both a compatibility/stability release for the current Gen1Recomp++ environment and a feature update. It replaces the older v1.2.x public hotfix line.

## New and updated

### Expanded Storage

- Added the optional **EXPANDED STORAGE** setting, enabled by default.
- Gives the normal Bag and Player PC additional storage headroom.
- Mom's **PACK TOOLKIT** capacity checks respect the selected storage mode.
- Mom's returned-item count is dynamic; newly acquired Toolkit-managed items increase the number she reports.

**Normal Gen I limits to return to before disabling Expanded Storage:**

- **Bag: 20 distinct item slots**
- **Player PC: 50 distinct item slots**

If your save is above those limits, reduce it before disabling Expanded Storage, removing Vanilla+, transferring the save to an environment without the feature, or otherwise loading it without expanded storage active. Over-capacity items may become inaccessible or be lost.

Recommended transfer/downgrade process: leave Expanded Storage on, use **Mom → PACK TOOLKIT**, note the number of Toolkit-managed items being returned, then use/sell/discard ordinary consumables until the packed save is within the 20-Bag / 50-PC stock limits.

### Hot Air Balloon

- Replaced the earlier Balloon art with the approved native **40×40** production sprite.
- Balloon travel uses its own straight vertical takeoff/landing sequence rather than globally replacing the normal Fly bird.
- Finalized compatibility corrections for **Potato Voxel** and **DRAMALESS SHAPE**, including sprite orientation, vertical travel direction and the true Fly-tile pickup/landing anchor.
- Verified Balloon travel with **Wilds of Kanto**.
- Verified ordinary Pokémon Fly still uses its normal bird animation after Balloon travel.

### ALL-CART ENCOUNTERS

- Expanded ALL-CART ENCOUNTERS beyond selected land additions.
- Red/Blue/Yellow availability now includes the audited Yellow-only land/cave, Surf and Super Rod additions while preserving the active cartridge as the base encounter ecology.
- Added a runtime encounter-table bridge so **Wilds of Kanto** can see Vanilla+ merged encounter data and render those additions as visible overworld Pokémon.
- Live QA confirmed Yellow-only visible additions including Pidgey/Pidgeotto in Viridian Forest, Ponyta on Cycling Road and Gloom/Weepinbell in Cerulean Cave.
- Turning ALL-CART ENCOUNTERS off correctly removes the added availability.

### Wilds compatibility

- Restored Vanilla+ fossil overworld visualization under Wilds.
- Routed postgame Mr. Mime through the same Wilds species-skin/refresh path used by compatible Pokémon NPCs.
- Hardened Toolkit TM/HM recognition so machine ownership remains visible across the current mod-stack/reload path.

### Dialogue and UI stability

- Hardened the shared Vanilla+ dialogue helper against stale/nil game-stack state.
- Custom dialogue now uses explicit Gen I-style page progression while retaining width-aware wrapping.
- Repeated interaction QA passed for Mom, Bill, Oak and Mr. Mime.
- Battle/custom text formatting remains shared rather than relying on fragile NPC-by-NPC manual line shaving.

### Cleanup

- Removed the retired experimental visible-pickup modernization/re-arm subsystem from the active branch.
- Verified the stale Viridian Forest `x5 POKE BALL` bundle no longer returns.
- Preserved the current TM Mart renderer and existing post-Champion TM inventories.

## Save compatibility

Existing saves remain supported where practical.

For raw `.sav` transfer or moving away from Vanilla+, use **Mom → PACK TOOLKIT** first. Raw SRAM does not preserve every piece of Vanilla+ mod data, so packing the Toolkit returns supported physical items to ordinary Bag/PC storage before transfer.

If **EXPANDED STORAGE** has been used, also return the save to the normal **20 Bag / 50 PC** item-slot limits before loading it without the feature.

## Installation

Import `VanillaPlus-v1.3.0.zip` through the Gen1Recomp++ Mods screen and enable Vanilla+.

Target baseline: **Gen1Recomp++ 0.2.56+**.

Back up important saves before major updates or mod-stack changes.
