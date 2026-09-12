# Vanilla+

**Current Beta:** v1.3.0  
**Developer:** GiveScottPot  
**For:** Pokémon Red, Blue & Yellow on Gen1Recomp++  
**Target:** Gen1Recomp++ 0.2.56+

Vanilla+ is an additive expansion for Pokémon Red, Blue & Yellow built for Gen1Recomp++.

It preserves the feel and progression of Gen I while adding optional quality-of-life features, expanded encounters, new interactions, inventory tools and postgame content.

Most major additions can be toggled individually, so Vanilla+ can be used as a light QoL mod or a broader expansion of Kanto.

Some discoveries are intentionally left out of the documentation. Kanto is more fun when every surprise is not itemized in a README like tax deductions.

## Features

- Running Shoes
- TM/HM Bag with NUM / ALPHA / TYPE sorting
- Optional reusable TMs
- Hidden Stats with DVs + Stat Experience
- Battle EXP progress display
- Caught-species indicators
- Persistent Cut trees
- Expanded field/travel conveniences
- Post-Champion marts + TM availability
- New NPC interactions + rotating dialogue
- Expanded encounter options
- Wild fossil encounters
- Additional battles, exploration + postgame content
- Optional Expanded Storage for the Bag and Player PC

## v1.3.0 highlights

- Finalized the Toolkit **Hot Air Balloon** with the approved native 40×40 sprite and dedicated vertical takeoff/landing animation.
- Added compatibility handling for the Balloon under normal rendering, Wilds of Kanto, Potato Voxel and DRAMALESS SHAPE while leaving ordinary Pokémon Fly unchanged.
- Completed **ALL-CART ENCOUNTERS** support so Yellow-only land, Surf and Super Rod availability can be layered onto the active Red/Blue/Yellow encounter ecology.
- Added a Wilds runtime encounter bridge so Vanilla+ additions can appear as visible overworld spawns as well as ordinary random encounters.
- Fixed Wilds handling for Vanilla+ species such as Mr. Mime and fossil encounters.
- Hardened the shared custom-dialogue system and restored clean page-by-page Gen I text progression.
- Removed the retired experimental multi-item pickup subsystem that could leak stale bundle behavior into newer builds.
- Added **EXPANDED STORAGE**, including safe Toolkit packing support and explicit save-transfer warnings.

See `RELEASE_NOTES.md` for the full v1.3.0 release summary.

## Adventurer's Toolkit

After becoming Champion, Mom can provide the Toolkit, consolidating utility and key items into:

**Field Tools / Laptop / Fishing / TM-HM Bag / Equipment / Keys & Tickets / Register**

Field Tools include the **Axe, Surfboard, Hot Air Balloon, Flashlight and Crowbar**.

Mom also supports:

**TALK / HEAL / PACK TOOLKIT / CANCEL**

`PACK TOOLKIT` returns supported Toolkit-managed physical items to normal Bag/PC storage. This is the recommended preparation step before raw `.sav` transfers, removing Vanilla+, or moving a save to an environment that will not preserve Vanilla+ mod data.

### Expanded Storage and save safety

The optional **EXPANDED STORAGE** setting is enabled by default and gives the Bag and Player PC additional headroom.

The normal Gen I storage limits players should return to before disabling the option are:

- **Bag: 20 distinct item slots**
- **Player PC: 50 distinct item slots**

If you use Expanded Storage, **do not disable it, remove Vanilla+, or load the save without the expanded-storage system while your inventory is still above those normal limits.** Over-capacity items may become inaccessible or be lost.

A practical downgrade/transfer workflow is:

1. Leave **EXPANDED STORAGE ON**.
2. Talk to Mom and choose **PACK TOOLKIT**.
3. Mom reports how many Toolkit-managed physical items are being returned. That number is dynamic and can help you judge how much room you need.
4. Reduce the final stored inventory to no more than **20 distinct items in the Bag and 50 in the Player PC**. Use, sell, deposit or discard ordinary consumables as needed.
5. Only after the save is back within the normal limits should you disable Expanded Storage, remove Vanilla+, or move the save to an environment without the feature.

Deleting ordinary consumables does not necessarily change Mom's return count; her number reflects Toolkit-managed physical items being returned, not every item already in the Bag.

## Bill's Trade Evolution

Bill provides a single-player method for supported trade evolutions through his PC after the appropriate story/postgame conditions are met.

This system is controlled by the **TRADE EVOLUTION** setting and is separate from Bill's optional rotating dialogue.

## Encounter options

**RED/BLUE COUNTERPART EXCLUSIVES** adds opposite-version exclusives to fitting habitats.

**ALL-CART ENCOUNTERS** combines Red + Blue + Yellow species availability while preserving the selected/current cartridge as the base ecology. Yellow-only additions include appropriate land, Surf and Super Rod placements rather than replacing the whole game with Yellow's encounter tables.

## Post-Champion TM marts

Optional post-Champion marts expand TM availability without duplicating the nine TMs already sold infinitely in Celadon or the three Game Corner Prize Counter exclusives.

The TM/HM Bag only shows machines the player actually owns; it does not grant or duplicate them.

## Installation

Import `VanillaPlus-v1.3.0.zip` through the Gen1Recomp++ **Mods** screen and enable Vanilla+.

Vanilla+ does **not** contain a Pokémon ROM. You must provide your own compatible game through the normal Gen1Recomp++ setup.

Some encounter settings require a restart. Read each setting description before changing it during an active save.

Back up important saves before major updates or mod-stack changes.

## Compatibility

Current v1.3.0 QA includes:

- **Gen1Recomp++ 0.2.56+** as the current development baseline.
- **Wilds of Kanto:** Balloon travel, visible Vanilla+ encounter additions, ALL-CART visible spawns, Mr. Mime and fossil spawns have passed current testing.
- **DRAMALESS SHAPE:** the 40×40 Balloon now renders upright and uses the correct takeoff/landing anchor in current testing.
- **Potato Voxel:** the same Balloon compatibility path has passed current testing.
- **Ordinary Pokémon Fly:** remains vanilla and was verified after Balloon travel.

Do not stack multiple voxel renderers unless their authors explicitly support doing so. Compatibility is tested, not guaranteed across every platform, version, save or mod combination.

See `docs/COMPATIBILITY.md` for additional details.

## Beta testing / support

Reports are most useful when they include:

- Red, Blue or Yellow
- Gen1Recomp++ version
- Platform/device
- Other enabled mods and versions
- What happened and what you expected
- Whether the issue survives a full app restart
- Screenshot or recording when possible

Existing saves are supported where practical. Back up valuable saves before changing major inventory or mod-stack settings.

## Contributing

Vanilla+ has been designed, implemented, tested and iterated through an AI-assisted workflow performed entirely from an iPhone. GiveScottPot directs the project and performs the on-device design/QA loop, with OpenAI ChatGPT assisting with implementation and code analysis.

Help is welcome, particularly with:

- Gen1Recomp / Lua development
- Gen I map and event work
- Pixel art and sprite work
- Red / Blue / Yellow testing
- Android / Windows / iOS compatibility testing
- Testing alongside other Recomp mods
- Bug reports, recordings and reproduction steps

## Credits

**Project developer:** GiveScottPot  
**Implementation and code-analysis assistance:** OpenAI ChatGPT  
**Platform:** Gen1Recomp / Gen1Recomp++ and their contributors

Vanilla+ is an independent community project and is not affiliated with Nintendo, Game Freak, Creatures or The Pokémon Company.
