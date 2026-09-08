# Vanilla+

**Version:** Beta v1.2.3  
**Developer:** GiveScottPot  
**For:** Pokémon Red, Blue and Yellow on Gen1Recomp++  
**Tested baseline:** Gen1Recomp++ 0.2.56

Vanilla+ expands Gen I without trying to replace what makes Red, Blue, and Yellow feel like Gen I. The focus is quality-of-life improvements, broader encounter options, useful world interactions, and additional content that stays close to the original games.

Some discoveries are intentionally left out of the documentation. Kanto is more fun when every surprise is not itemized in a README like tax deductions.

## Beta v1.2.3

- Running Shoes integrated into normal early-game progression
- Hidden Stats / DV and Stat Experience information
- Battle EXP progress display
- Caught-species indicator
- Optional Red/Blue counterpart exclusives
- Optional ALL-CART ENCOUNTERS combining Red, Blue, and Yellow availability
- Persistent Cut trees
- Additional field-action and travel conveniences
- Bill Trade Evolution machine
- Fighting Dojo trade addition
- Expanded Professor Oak interactions
- Additional NPC and world interactions
- Individual settings for many Vanilla+ features

### Expanded Adventurer's Toolkit

The Toolkit now serves as a larger utility inventory and can automatically migrate supported items for players who already received it on an older Vanilla+ save.

Toolkit sections:

1. **Field Tools** - Axe, Surfboard, Hot Air Balloon, Flashlight, Crowbar, and related field-use tools
2. **Laptop**
3. **Fishing** - Old Rod, Good Rod, Super Rod
4. **TM/HM Bag** - stores owned TMs/HMs and can sort with SELECT by number, move name, or attack type
5. **Equipment** - Bicycle, Itemfinder, Poké Flute, Coin Case, Silph Scope, and supported equipment
6. **Keys & Tickets** - S.S. Ticket, Secret Key, Card Key, Lift Key, and supported access items
7. **Register** - register Toolkit-compatible shortcuts, including direct TM/HM Bag access

Toolkit-managed items are removed from normal Bag/PC clutter while preserving the underlying ownership/progression state used by the game.

### Reusable TMs

A separate **Reusable TMs** setting is available and defaults to **OFF**. When enabled, successfully taught TMs are retained instead of consumed. HMs remain reusable as normal. The TM/HM Bag itself does not grant or duplicate machines; it only shows what the player actually owns.

## Installation

Import the Vanilla+ ZIP through the Gen1Recomp++ Mods screen and enable the mod.

Vanilla+ does **not** contain a Pokémon ROM. You must provide your own compatible game through the normal Gen1Recomp++ setup.

Some settings require a full application restart before their change can safely take effect. When a Vanilla+ setting requires this, its description says **Restart required**.

Back up important saves before updating or significantly changing your mod stack.

## Compatibility

Known tested/working combinations include:

- **Wilds of Kanto:** core Vanilla+ compatibility remains usable on the current Recomp baseline, but Wilds currently suppresses Vanilla+ WILD FOSSILS encounter injection while enabled. Disable Wilds if you want Vanilla+ fossil encounters until this compatibility issue is resolved.
- **DRAMALESS SHAPE:** tested in prior known-good stacks; exact current-version compatibility remains stack-dependent.
- **Dramatic Shape Voxel 1.9.0:** previously tested compatible in known-good stacks.
- **Potato Voxel:** tested compatible in prior known-good stacks. Current compatibility should still be reported if anything behaves differently.
- **Anime Realism:** tested compatible in prior known-good stacks. Current-version compatibility testing is welcome.

Do not stack multiple voxel renderers unless their authors explicitly support doing so. Compatibility is tested, not guaranteed across every platform, version, save, or mod combination. See `docs/COMPATIBILITY.md` for details.

## Save transfer / Toolkit

Before exporting or transferring a raw `.sav`, reinstalling Recomp, or moving the save to another platform, talk to Mom and use **PACK TOOLKIT**. Raw Gen I `.sav` files do not carry Vanilla+ modData, so packing the Toolkit first returns managed physical items to vanilla Bag/PC storage for safer transfer. Mom can rebuild the Toolkit afterward.

## Beta testing / support

Reports are most useful when they include:

- Red, Blue, or Yellow
- Gen1Recomp++ version
- Platform/device
- Other enabled mods and versions
- What happened and what you expected
- Whether the issue survives a full app restart
- Screenshot or recording when possible

Existing saves are supported where practical. The Toolkit system includes automatic migration for supported Toolkit-owned items so players who already received the Toolkit do not have to reacquire it.

## Contributing

Vanilla+ has been designed, implemented, tested, and iterated through an AI-assisted workflow performed entirely from an iPhone. GiveScottPot directs the project and performs the on-device design/QA loop, with OpenAI ChatGPT assisting with implementation and code analysis.

Help is still very welcome, particularly with:

- Gen1Recomp / Lua development
- Gen I map and event work
- Pixel art and sprite work
- Red / Blue / Yellow testing
- Android / Windows / iOS compatibility testing
- Testing alongside other Recomp mods
- Bug reports, recordings, and reproduction steps

## Credits

**Project developer:** GiveScottPot  
**Implementation and code-analysis assistance:** OpenAI ChatGPT  
**Platform:** Gen1Recomp / Gen1Recomp++ and their contributors

Vanilla+ is an independent community project and is not affiliated with Nintendo, Game Freak, Creatures, or The Pokémon Company.

## Update support

GitHub release tracking is configured for launcher update/version-history support.
