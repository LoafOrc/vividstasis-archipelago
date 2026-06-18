from dataclasses import dataclass

from Options import Choice, OptionGroup, PerGameCommonOptions, Range, Toggle, DeathLink

# In this file, we define the options the player can pick.
# The most common types of options are Toggle, Range and Choice.

# Options will be in the game's template yaml.
# They will be represented by checkboxes, sliders etc. on the game's options page on the website.
# (Note: Options can also be made invisible from either of these places by overriding Option.visibility.
#  APQuest doesn't have an example of this, but this can be used for secret / hidden / advanced options.)

# For further reading on options, you can also read the Options API Document:
# https://github.com/ArchipelagoMW/Archipelago/blob/main/docs/options%20api.md

class StartingSongs(Range):
    """
    How many songs to start with.
    """
    display_name = "Starting Songs"
    range_start = 3
    range_end = 10
    default = 5


# We must now define a dataclass inheriting from PerGameCommonOptions that we put all our options in.
# This is in the format "option_name_in_snake_case: OptionClassName".
@dataclass
class VSOptions(PerGameCommonOptions):
    death_link: DeathLink

    starting_songs: StartingSongs


# If we want to group our options by similar type, we can do so as well. This looks nice on the website.
option_groups = [

]

# Finally, we can define some option presets if we want the player to be able to quickly choose a specific "mode".
option_presets = {

}
