from __future__ import annotations

from typing import TYPE_CHECKING, Callable

from worlds.generic.Rules import add_rule, set_rule
from .Songs import SONGS

if TYPE_CHECKING:
    from .world import VSWorld
    from worlds.generic.Rules import CollectionRule
else:
    CollectionRule = Callable[[object], bool]


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

def has_song_item_rule(world, song) -> CollectionRule:
    return lambda state: state.has(f"Song - {song['song_name']}", world.player)

def set_all_location_rules(world: VSWorld) -> None:
    for chart_id, song in SONGS.items():
        songName = f"Song - {song['song_name']}"

        if "song_item_id" in song:
            set_rule(
                world.get_location(f"Song SS Rank Reward - {song['song_name']}"),
                has_song_item_rule(world, song)
            )


def set_completion_condition(world: VSWorld) -> None:
    world.multiworld.completion_condition[world.player] = lambda state: state.has("Victory", world.player)
