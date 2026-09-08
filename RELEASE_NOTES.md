# Vanilla+ v1.2.3

Small corrective hotfix for the public v1.2.2 compatibility release.

## Fix

- Removes an unfinished visible multi-item pickup modernization system that was accidentally left enabled in v1.2.2.
- Removes the associated QA-only pickup re-arm logic.
- Restores affected visible Poké Ball pickups to normal native Gen I behavior, fixing a possible `talkTo` / nil `gameRef` crash when collecting certain items such as an S.S. Anne pickup.
- Corrects the GitHub repository reference in the mod manifest.

All intended v1.2.2 compatibility repairs and released Vanilla+ features are otherwise preserved.

## Save transfers

Before exporting/transferring a raw `.sav`, reinstalling Recomp, or moving platforms, talk to Mom and use **PACK TOOLKIT**. Raw `.sav` files do not contain Vanilla+ modData.

## Known compatibility issue

With Wilds of Kanto enabled on the current tested stack, Vanilla+ WILD FOSSILS are suppressed from both Wilds overworld spawning and ordinary random encounters. Fossils work normally with Wilds disabled.
