from __future__ import annotations

from typing import TYPE_CHECKING

from BaseClasses import ItemClassification, Location

from . import items
from .Songs import SONGS

if TYPE_CHECKING:
    from .world import VSWorld

# Every location must have a unique integer ID associated with it.
# We will have a lookup from location name to ID here that, in world.py, we will import and bind to the world class.
# Even if a location doesn't exist on specific options, it must be present in this lookup.
LOCATION_NAME_TO_ID = { }
for chart_id, song in SONGS.items():
    songName = f"Song SS Rank Reward - {song['song_name']}"
    if "ss_rank_location_id" in song:
        LOCATION_NAME_TO_ID[songName] = song["ss_rank_location_id"]

# Each Location instance must correctly report the "game" it belongs to.
# To make this simple, it is common practice to subclass the basic Location class and override the "game" field.
class VSLocation(Location):
    game = "vivid/stasis"


# Let's make one more helper method before we begin actually creating locations.
# Later on in the code, we'll want specific subsections of LOCATION_NAME_TO_ID.
# To reduce the chance of copy-paste errors writing something like {"Chest": LOCATION_NAME_TO_ID["Chest"]},
# let's make a helper method that takes a list of location names and returns them as a dict with their IDs.
# Note: There is a minor typing quirk here. Some functions want location addresses to be an "int | None",
# so while our function here only ever returns dict[str, int], we annotate it as dict[str, int | None].
def get_location_names_with_ids(location_names: list[str]) -> dict[str, int | None]:
    return {location_name: LOCATION_NAME_TO_ID[location_name] for location_name in location_names}


def create_all_locations(world: VSWorld) -> None:
    create_regular_locations(world)
    create_events(world)


def create_regular_locations(world: VSWorld) -> None:
    # Finally, we need to put the Locations ("checks") into their regions.
    # Once again, before we do anything, we can grab our regions we created by using world.get_region()
    rhythm_play = world.get_region("Rhythm Play")

    rhythm_play.add_locations(LOCATION_NAME_TO_ID, VSLocation)


def create_events(world: VSWorld) -> None:
    # One way to create an event is simply to use one of the normal methods of creating a location.
    plaudite_clear = world.get_location("Song SS Rank Reward - acta est fabula, plaudite")
    plaudite_clear.address = None

    victory_item = items.VSItem("Victory", ItemClassification.progression, None, world.player)
    plaudite_clear.place_locked_item(victory_item)