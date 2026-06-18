from __future__ import annotations

from typing import TYPE_CHECKING

from BaseClasses import Item, ItemClassification
from .Songs import SONGS

if TYPE_CHECKING:
    from .world import VSWorld

# Every item must have a unique integer ID associated with it.
# We will have a lookup from item name to ID here that, in world.py, we will import and bind to the world class.
# Even if an item doesn't exist on specific options, it must be present in this lookup.
ITEM_NAME_TO_ID = {
    "Points": 1000,
    "Battery": 1001,
    "Betweenspace Key": 2000,
    "Archive Key": 2001,
    "Temple Key": 2002,
    "Grotto Key": 2003,
    "Proof Of Soul Key": 2004
}
DEFAULT_ITEM_CLASSIFICATIONS = {
    "Points": ItemClassification.filler,
    "Battery": ItemClassification.filler,
    "Betweenspace Key": ItemClassification.progression,
    "Archive Key": ItemClassification.progression,
    "Temple Key": ItemClassification.progression,
    "Grotto Key": ItemClassification.progression,
    "Proof Of Soul Key": ItemClassification.progression
}

for chart_id, song in SONGS.items():
    songName = f"Song - {song['song_name']}"
    if "song_item_id" in song:
        ITEM_NAME_TO_ID[songName] = song["song_item_id"]
        DEFAULT_ITEM_CLASSIFICATIONS[songName] = ItemClassification.progression_deprioritized_skip_balancing

# Each Item instance must correctly report the "game" it belongs to.
# To make this simple, it is common practice to subclass the basic Item class and override the "game" field.
class VSItem(Item):
    game = "vivid/stasis"


# Ontop of our regular itempool, our world must be able to create arbitrary amounts of filler as requested by core.
# To do this, it must define a function called world.get_filler_item_name(), which we will define in world.py later.
# For now, let's make a function that returns the name of a random filler item here in items.py.
def get_random_filler_item_name(world: VSWorld) -> str:
    # APQuest has an option called "trap_chance".
    # This is the percentage chance that each filler item is a Math Trap instead of a Confetti Cannon.
    # For this purpose, we need to use a random generator.

    # IMPORTANT: Whenever you need to use a random generator, you must use world.random.
    # This ensures that generating with the same generator seed twice yields the same output.
    # DO NOT use a bare random object from Python's built-in random module.
    # if world.random.randint(0, 99) < world.options.trap_chance:
    #     return "Math Trap"
    return "Points"


def create_item_with_correct_classification(world: VSWorld, name: str) -> VSItem:
    # Our world class must have a create_item() function that can create any of our items by name at any time.
    # So, we make this helper function that creates the item by name with the correct classification.
    # Note: This function's content could just be the contents of world.create_item in world.py directly,
    # but it seemed nicer to have it in its own function over here in items.py.
    classification = DEFAULT_ITEM_CLASSIFICATIONS[name]
    return VSItem(name, classification, ITEM_NAME_TO_ID[name], world.player)


# With those two helper functions defined, let's now get to actually creating and submitting our itempool.
def create_all_items(world: VSWorld) -> None:
    # This is the function in which we will create all the items that this world submits to the multiworld item pool.
    # There must be exactly as many items as there are locations.
    # In our case, there are either six or seven locations.
    # We must make sure that when there are six locations, there are six items,
    # and when there are seven locations, there are seven items.

    # Creating items should generally be done via the world's create_item method.
    # First, we create a list containing all the items that always exist.

    itempool: list[Item] = [ ]

    itempool.append(world.create_item("Betweenspace Key"))
    itempool.append(world.create_item("Proof Of Soul Key"))
    itempool.append(world.create_item("Archive Key"))
    itempool.append(world.create_item("Temple Key"))
    itempool.append(world.create_item("Grotto Key"))

    for chart_id, song in SONGS.items():
        songName = f"Song - {song['song_name']}"
        if "song_item_id" in song:
            itempool.append(world.create_item(songName))

    for i in range(world.options.starting_songs.value):
        starting_song = itempool[world.random.randint(0, len(itempool) - 1)]
        itempool.remove(starting_song)
        world.push_precollected(starting_song)

    # Create Filler
    number_of_items = len(itempool)
    number_of_unfilled_locations = len(world.multiworld.get_unfilled_locations(world.player))
    needed_number_of_filler_items = number_of_unfilled_locations - number_of_items
    itempool += [world.create_filler() for _ in range(needed_number_of_filler_items)]


    world.multiworld.itempool += itempool
