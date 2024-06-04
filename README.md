# NPC Scaling
This script changes NPC levels by adjusting the level multiplier.

## Description

For each NPC:

* Checks if it already has a level multiplier and adjusts min/max levels if necessary.
* Calculates new level based on race, class, and stats.
* Caps new level if it exceeds the maximum allowed multiplier.
* Applies new level multiplier and updates min/max.


# Boost RACE's Starting Values by Size

This script modifies the starting values of races in a game based on their size. Races are categorized into different sizes (Small, Medium, Large, Extra Large) and their starting health, stamina, and magicka values are boosted accordingly.

### Sizes:
- Small: 0
- Medium: 1
- Large: 2
- Extra Large: 3

## Description

Processes each race to determine its size based on a list of keyword/value.

Boosts the starting health, stamina, and magicka based on the size.

# Uncap Encounter Zones
This script removes level caps from encounter zones in a game.

For each encounter zone, it:

* Sets the minimum level to 1.

* Sets the maximum level to 0.

* Ensures the "Never Resets" flag is not set.


# Setup ESL
This script copies NPC, RACE, and ECZN records to a specified .esp file, auto add/accepts masters and sets ESL flag.

## Description
* Skips NPCs with excessively high stats.
* Ensures only winning overrides are processed.
* Copies the records to the target .esp file, adding required element masters silently.
* Cleans up masters and provides a summary of processed and skipped records.