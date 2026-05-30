from __future__ import annotations

from typing import TYPE_CHECKING

from BaseClasses import CollectionState
from worlds.generic.Rules import add_rule, set_rule
from .Songs import SONGS

if TYPE_CHECKING:
    from .world import VSWorld


def set_all_rules(world: VSWorld) -> None:
    # In order for AP to generate an item layout that is actually possible for the player to complete,
    # we need to define rules for our Entrances and Locations.
    # Note: Regions do not have rules, the Entrances connecting them do!
    # We'll do entrances first, then locations, and then finally we set our victory condition.

    set_all_entrance_rules(world)
    set_all_location_rules(world)
    set_completion_condition(world)


def set_all_entrance_rules(world: VSWorld) -> None:
    pass


def set_all_location_rules(world: VSWorld) -> None:
    for chart_id, song in SONGS.items():
        songName = f"Song - {song['song_name']}"
        if "song_item_id" in song:
            set_rule(
                world.get_location(f"Song SS Rank Reward - {song['song_name']}"),
                lambda state: state.has(songName, world.player)
            )


def set_completion_condition(world: VSWorld) -> None:
    world.multiworld.completion_condition[world.player] = lambda state: state.has("Victory", world.player)
