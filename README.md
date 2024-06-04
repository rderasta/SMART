# NPC Scaling
This script changes NPC levels by adjusting the level multiplier (based on NPC stats and RACE stats and size).

## Description

For each NPC:

* Checks if it already has a level multiplier and adjusts min/max levels if necessary.
* Calculates new level based on race, class, and stats.
* Caps new level if it exceeds the maximum allowed multiplier.
* Applies new level multiplier and updates min/max.


# Boost RACE's Starting Values by Size

This script modifies the races size and the starting values of races (based on their size). 

## Description

* Processes each race to determine its size based on a list of keyword/value.

* Boosts the starting health, stamina, and magicka based on the size.

# Uncap Encounter Zones
This script removes level caps from encounter zones.

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