# Vanilla+ Beta v1.2.1 Hotfix

Beta v1.2.1 is a compatibility and UI hotfix for Beta v1.2.0.

## Fixed

- Reworked Vanilla+'s **SELECT/Register input handling** to use Gen1Recomp++'s fixed-step input pathway.
- **Wilds of Kanto 2.1.9:** Vanilla+'s SELECT-based Toolkit and registered shortcuts are now confirmed working alongside Wilds in current testing.
- Restored the intended **full-height Bag and TM/HM Bag list boxes** after the v1.2.0 UI regression compressed them to a short list.
- Added **Toolkit ownership self-healing**. Players who already possess the Toolkit through a nonstandard acquisition path can have the required Vanilla+ Toolkit state initialized automatically instead of depending solely on the original Mom handoff event.

## Retained from v1.2.0

- Expanded Adventurer's Toolkit
- Field Tools, Laptop, Fishing, TM/HM Bag, Equipment, Keys & Tickets, and Register
- TM/HM Bag sorting by number, move name, or attack type
- TM/HM Bag registration for direct SELECT access
- Toggleable Reusable TMs
- Existing-save Toolkit migration

## Testing note

The new SELECT architecture is confirmed working on the primary iOS test setup alongside Wilds of Kanto 2.1.9. Additional Windows, Android, Linux, macOS, and controller testing remains valuable.

## Notes

- No ROM is included.
- Back up your save before updating.
- Existing saves are supported where practical.
- Vanilla+ remains a beta.
