# Vanilla+ Beta v1.2.0

Beta v1.2.0 expands the Adventurer's Toolkit into a broader inventory/utility system while preserving the existing public Beta feature set.

## New / Expanded

- Expanded Toolkit main menu with **Field Tools, Laptop, Fishing, TM/HM Bag, Equipment, Keys & Tickets, Register, and Cancel**.
- Added a dedicated **TM/HM Bag** that contains only machines the player actually owns.
- Press **SELECT** inside the TM/HM Bag to cycle sorting by **number, move name, or attack type**.
- Added **Reusable TMs** as a separate toggle, default OFF. HMs remain reusable normally.
- Added dedicated **Fishing** storage for Old Rod, Good Rod, and Super Rod.
- Expanded **Equipment** storage to include supported utility items such as Coin Case and Silph Scope.
- Added **Keys & Tickets** storage for supported access/progression items including S.S. Ticket, Secret Key, Card Key, and Lift Key.
- Added **TM/HM Bag** to the Toolkit Register pool for direct SELECT access when registered.
- Existing Toolkit owners are automatically migrated to the expanded Toolkit system without needing to reacquire it.

## Compatibility note

Wilds of Kanto 2.1.8 works well with Vanilla+ in current gameplay testing, but Wilds currently captures **SELECT**, which conflicts with Vanilla+'s SELECT-based Toolkit and registered shortcuts. See `docs/COMPATIBILITY.md`.

## Previous v1.1.0 fixes retained

- CUT interactions distinguish grass from trees with the correct dialogue.
- Indoor furniture and other reused tile IDs no longer incorrectly trigger Surf/Fishing-style field interactions.
- CUT interaction dialogue uses Vanilla+'s shared dialogue formatter for cleaner textbox wrapping/pagination.

## Notes

- No ROM is included.
- Back up your save before updating.
- Existing saves are supported where practical.
- Some settings may require a full app restart before behavior changes safely.
- Vanilla+ remains a beta. Compatibility is tested, not guaranteed with every mod combination.
