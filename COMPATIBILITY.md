# Vanilla+ Compatibility

Vanilla+ Beta v1.2.3 targets Gen1Recomp++ 0.2.56+ and supports Pokémon Red, Blue, and Yellow.

Compatibility can vary by platform, exact Gen1Recomp++ version, load order, and other enabled mods. Test Vanilla+ by itself first when diagnosing a problem.

## Current Recomp baseline

Vanilla+ v1.2.3 includes compatibility repairs for the menu, summary, text-box, party, bag, battle HUD/state, and related lifecycle changes introduced in recent Gen1Recomp++ builds.

## Wilds of Kanto

**Status: Partial compatibility on the current Recomp baseline**

Vanilla+ and Wilds can run together for many features, including the fixed-step SELECT/Register behavior previously tested with Wilds. However, current QA confirms a specific encounter conflict:

- With Wilds disabled, Vanilla+ WILD FOSSILS spawn normally.
- With Wilds enabled, Vanilla+ injected fossil species do not appear as Wilds overworld spawns.
- With Wilds enabled, those injected fossils also do not appear through ordinary random encounters.

Until this is resolved, disable Wilds when using Vanilla+ WILD FOSSILS. This is tracked as a compatibility issue rather than a failure of Vanilla+'s fossil encounter table itself.

## Voxel / presentation mods

DRAMALESS SHAPE, Dramatic Shape Voxel, and Potato Voxel have worked in prior known-good Vanilla+ stacks. Use only one voxel renderer at a time unless the mod authors explicitly support stacking them.

Anime Realism has also worked in prior stacks, but dialogue/render injection mods are higher-risk compatibility targets when Recomp internals change.

## Save transfer / Toolkit

Raw 32 KB Gen I `.sav` exports do not carry Recomp/Vanilla+ modData. Before exporting/transferring a save, deleting or reinstalling Recomp, or moving platforms, talk to Mom and use **PACK TOOLKIT**.

Packing returns Toolkit-managed physical items to vanilla PC + Bag storage where possible. After import/reinstall, Mom can rebuild the Toolkit.

## Game testing

- **Pokémon Red:** primary development/regression baseline.
- **Pokémon Blue:** supported; full start-to-finish regression testing is still useful.
- **Pokémon Yellow:** supported; full start-to-finish regression testing is still useful.

## Reporting compatibility problems

Please include:
- Game: Red, Blue, or Yellow
- Platform/device
- Exact Gen1Recomp++ version
- Vanilla+ version
- Other enabled mods and exact versions
- Whether the issue occurs with Vanilla+ by itself
- Reproduction steps
- Screenshot or video when possible

Back up important saves before changing Gen1Recomp++ versions or significantly changing your mod stack.
