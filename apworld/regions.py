from __future__ import annotations

from typing import TYPE_CHECKING

from BaseClasses import Entrance, Region

if TYPE_CHECKING:
    from .world import VSWorld

# A region is a container for locations ("checks"), which connects to other regions via "Entrance" objects.
# Many games will model their Regions after physical in-game places, but you can also have more abstract regions.
# For a location to be in logic, its containing region must be reachable.
# The Entrances connecting regions can have rules - more on that in rules.py.
# This makes regions especially useful for traversal logic ("Can the player reach this part of the map?")

# Every location must be inside a region, and you must have at least one region.
# This is why we create regions first, and then later we create the locations (in locations.py).


def create_and_connect_regions(world: VSWorld) -> None:
    create_all_regions(world)
    connect_regions(world)


def create_all_regions(world: VSWorld) -> None:
    # Creating a region is as simple as calling the constructor of the Region class.
    menu = Region("Menu", world.player, world.multiworld)
    rhythm_play = Region("Rhythm Play", world.player, world.multiworld)

    betweenspace = Region("Betweenspace Hub", world.player, world.multiworld)
    proof_of_soul = Region("Proof Of Soul Room", world.player, world.multiworld)
    sewer = Region("Sewer", world.player, world.multiworld)
    archive = Region("Archive", world.player, world.multiworld)
    temple = Region("Temple", world.player, world.multiworld)
    grotto = Region("Grotto", world.player, world.multiworld)

    # Let's put all these regions in a list.
    regions = [menu, rhythm_play, betweenspace, proof_of_soul, sewer, archive, temple, grotto]

    # We now need to add these regions to multiworld.regions so that AP knows about their existence.
    world.multiworld.regions += regions


def connect_regions(world: VSWorld) -> None:
    menu = world.get_region("Menu")
    rhythm_play = world.get_region("Rhythm Play")
    betweenspace = world.get_region("Betweenspace Hub")
    proof_of_soul = world.get_region("Proof Of Soul Room")
    sewer = world.get_region("Sewer")
    archive = world.get_region("Archive")
    temple = world.get_region("Temple")
    grotto = world.get_region("Grotto")

    menu.connect(rhythm_play)
    menu.connect(betweenspace, "Betweenspace Entrance", lambda state: state.has("Betweenspace Key", world.player))
    betweenspace.connect(proof_of_soul, "Proof Of Soul Gate", lambda state: state.has("Proof Of Soul Key", world.player))
    betweenspace.connect(sewer) # no gate on sewer
    betweenspace.connect(archive, "Archive Gate", lambda state: state.has("Archive Key", world.player))
    betweenspace.connect(temple, "Temple Gate", lambda state: state.has("Temple Key", world.player))
    betweenspace.connect(grotto, "Grotto Gate", lambda state: state.has("Grotto Key", world.player))