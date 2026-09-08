function define_options()
{
    global.options_categories = [
    {
        title: "Video / Performance",
        options: [UnknownEnum.Value_0, UnknownEnum.Value_1, UnknownEnum.Value_52, UnknownEnum.Value_2, UnknownEnum.Value_54, UnknownEnum.Value_8, UnknownEnum.Value_9, UnknownEnum.Value_23, UnknownEnum.Value_49]
    }, 
    {
        title: "Audio",
        options: [UnknownEnum.Value_5, UnknownEnum.Value_6, UnknownEnum.Value_7, UnknownEnum.Value_18, UnknownEnum.Value_19, UnknownEnum.Value_20, UnknownEnum.Value_27]
    }, 
    {
        title: "Gameplay",
        options: [UnknownEnum.Value_4, UnknownEnum.Value_10, UnknownEnum.Value_11, UnknownEnum.Value_12, UnknownEnum.Value_13, UnknownEnum.Value_14, UnknownEnum.Value_15, UnknownEnum.Value_56, UnknownEnum.Value_55, UnknownEnum.Value_16, UnknownEnum.Value_21, UnknownEnum.Value_53, UnknownEnum.Value_24, UnknownEnum.Value_25, UnknownEnum.Value_26, UnknownEnum.Value_39, UnknownEnum.Value_22, UnknownEnum.Value_40, UnknownEnum.Value_28, UnknownEnum.Value_29]
    }, 
    {
        title: "Accessibility",
        options: [UnknownEnum.Value_31, UnknownEnum.Value_47, UnknownEnum.Value_35, UnknownEnum.Value_48, UnknownEnum.Value_36, UnknownEnum.Value_32, UnknownEnum.Value_33, UnknownEnum.Value_34, UnknownEnum.Value_37, UnknownEnum.Value_49]
    }, 
    {
        title: "Save Data / Other",
        options: [UnknownEnum.Value_41, UnknownEnum.Value_50, UnknownEnum.Value_51]
    },
    {
        title: "Archipelago Settings",
        options: [57, 58, 59]
    }];
    ini_open(global.profile_file);
    fin = ini_read_real("profile", "finished_game", 0);
    ini_close();
    
    if (fin)
        array_push(global.options_categories[0].options, UnknownEnum.Value_38);
    
    global.system_options = [
    {
        name: "Game Resolution",
        description: "Adjusts the window size of the game.",
        type: 0,
        values: ["320x180", "640x360", "960x540", "1280x720", "1600x900", "1920x1080", "2560x1440", "3840x2160"],
        default_value: 3,
        varname: "op_windowscale",
        key: "windowsize",
        
        on_change: function(arg0)
        {
            global.op_windowscale = arg0;
            update_window_size();
        }
    }, 
    {
        name: "Fullscreen Display",
        description: "Toggles fullscreen.",
        type: 0,
        values: ["Windowed", "Fullscreen"],
        default_value: 0,
        key: "fullscreen",
        
        on_change: function(arg0)
        {
            global.op_fullscreen = arg0;
            window_set_fullscreen(arg0);
            update_window_size();
        }
    }, 
    {
        name: "FPS Target",
        description: "Changes the target framerate in song gameplay.",
        type: 0,
        values: ["30", "60", "75", "90", "120", "144", "165", "240", "500", "1000"],
        default_value: 4,
        key: "fpscap"
    }, 
    {
        name: "Gameplay Scale Mode",
        description: "Toggles what scale the gameplay renders at. Resource intensive.",
        type: 0,
        values: ["Game Scale", "Double Game Scale", "Window Scale"],
        default_value: 0,
        key: "fullscale"
    }, 
    {
        name: "Note Scroll Speed",
        description: "Changes how fast notes move towards the judgement line.",
        slider_range: [1, 20],
        enforce_range: true,
        type: 1,
        default_value: 5,
        increments: [0.1, 1],
        decimals: 1,
        key: "note_speed"
    }, 
    {
        name: "Music Volume",
        description: "Adjust the volume for songs in gameplay.",
        slider_range: [0, 100],
        enforce_range: true,
        type: 1,
        default_value: 100,
        increments: [1, 5],
        decimals: 0,
        
        on_change: function(arg0)
        {
            global.op_music_volume = arg0 / 100;
        },
        
        read_value: function()
        {
            ini_open("system");
            var r = ini_read_real("config", "music_volume", 100);
            ini_close();
            global.op_music_volume = r / 100;
            return r;
        },
        
        get_value: function()
        {
            return global.op_music_volume * 100;
        },
        
        save: function()
        {
            ini_open("system");
            ini_write_real("config", "music_volume", global.op_music_volume * 100);
            ini_close();
        }
    }, 
    {
        name: "BGM Volume",
        description: "Adjust the volume for background music.",
        slider_range: [0, 100],
        enforce_range: true,
        type: 1,
        default_value: 100,
        increments: [1, 5],
        decimals: 0,
        
        on_change: function(arg0)
        {
            global.op_bgm_volume = arg0 / 100;
            audio_sound_gain(global.bgm, global.op_bgm_volume, 1);
        },
        
        read_value: function()
        {
            ini_open("system");
            var r = ini_read_real("config", "bgm_volume", 100);
            ini_close();
            global.op_bgm_volume = r / 100;
            return r;
        },
        
        get_value: function()
        {
            return global.op_bgm_volume * 100;
        },
        
        save: function()
        {
            ini_open("system");
            ini_write_real("config", "bgm_volume", global.op_bgm_volume * 100);
            ini_close();
        }
    }, 
    {
        name: "Sound Effect Volume",
        description: "Adjust the volume for sound effects.",
        slider_range: [0, 100],
        type: 1,
        default_value: 100,
        increments: [1, 5],
        decimals: 0,
        enforce_range: true,
        
        on_change: function(arg0)
        {
            global.op_se_volume = arg0 / 100;
        },
        
        read_value: function()
        {
            ini_open("system");
            var r = ini_read_real("config", "se_volume", 100);
            ini_close();
            global.op_se_volume = r / 100;
            return r;
        },
        
        get_value: function()
        {
            return global.op_se_volume * 100;
        },
        
        save: function()
        {
            ini_open("system");
            ini_write_real("config", "se_volume", global.op_se_volume * 100);
            ini_close();
        }
    }, 
    {
        name: "Background Particles",
        description: "Toggles the intensity of particles in different menus.",
        type: 0,
        values: ["None", "High (Default)", "Moderate", "Minimal"],
        default_value: 1,
        key: "bgparticles"
    }, 
    {
        name: "Gameplay Glow Effect",
        description: "During gameplay, particles in the background will have a glow.",
        type: 0,
        values: ["Disabled", "Enabled"],
        default_value: 1,
        key: "gameplay_glow"
    }, 
    {
        name: "Timing Calibration",
        description: "Calibrate timing offsets. Only recommended for low-end setups.",
        type: 2,
        scene: scene_calibration,
        
        read_value: function()
        {
        }
    }, 
    {
        name: "Timing Offset",
        description: "Turn down if you're hitting too early, and up if too late.",
        slider_range: [-300, 300],
        type: 1,
        default_value: 0,
        increments: [1, 5],
        decimals: 0,
        varname: "op_timing_offset",
        key: "judge_offset"
    }, 
    {
        name: "Visual Offset",
        description: "Adjusts the visual position of notes separate from their timing.",
        slider_range: [-300, 300],
        type: 1,
        default_value: 0,
        increments: [1, 5],
        decimals: 0,
        key: "visual_offset"
    }, 
    {
        name: "Gimmick Offset",
        description: "Adjusts the timing of modifiers/gimmicks that appear.",
        slider_range: [-300, 300],
        type: 1,
        default_value: 0,
        increments: [1, 5],
        decimals: 0,
        key: "gimmick_offset"
    }, 
    {
        name: "Quick Restart",
        
        get_description: function()
        {
            return @@string@@("When enabled, pressing {0} restarts the song immediately.", get_keycode_name(global.quick_restart_key));
        },
        
        type: 0,
        values: ["Disabled", "Enabled"],
        default_value: 0,
        key: "quick_restart"
    }, 
    {
        name: "Pause on Unfocus",
        description: "During gameplay, the game will pause if the window loses focus.",
        type: 0,
        values: ["Disabled", "Enabled"],
        default_value: 0,
        key: "pause_unfocus"
    }, 
    {
        name: "Lane Beam Opacity",
        description: "Changes the opacity of beams that appear in gameplay when pressing.",
        slider_range: [0, 100],
        enforce_range: true,
        type: 1,
        increments: [1, 25],
        default_value: 50,
        decimals: 0,
        
        on_change: function(arg0)
        {
            global.op_lanebeamopacity = arg0 / 100;
        },
        
        read_value: function()
        {
            ini_open("system");
            var r = ini_read_real("config", "lanebeamopacity", 0.5);
            ini_close();
            global.op_lanebeamopacity = r;
            return r * 100;
        },
        
        get_value: function()
        {
            return global.op_lanebeamopacity * 100;
        },
        
        save: function()
        {
            ini_open("system");
            ini_write_real("config", "lanebeamopacity", global.op_lanebeamopacity);
            ini_close();
        }
    }, 
    {
        name: "Rating Display Type",
        description: "Changes the way your rating number is displayed.",
        type: 0,
        values: ["Default", "Legacy"],
        default_value: 0,
        key: "ratingdisplaytype"
    }, 
    {
        name: "Note Sounds",
        description: "Toggle different types of note sounds.",
        type: 0,
        values: ["No Sound", "Type 1", "Type 2", "Type 3", "Type 4"],
        default_value: 1,
        varname: "op_note_hitsounds",
        key: "note_sounds",
        
        on_change: function(arg0)
        {
            global.op_note_hitsounds = arg0;
            var note_sounds = [notesnd_no, notesnd_1, notesnd_2, notesnd_3, sfx_note_hit];
            audio_play_sound(note_sounds[global.op_note_hitsounds], 1, false, global.op_hitsound_volume);
        }
    }, 
    {
        name: "Note Sound Volume",
        description: "Adjust the volume for note sounds.",
        slider_range: [0, 100],
        enforce_range: true,
        type: 1,
        default_value: 100,
        increments: [1, 5],
        decimals: 0,
        
        on_change: function(arg0)
        {
            global.op_hitsound_volume = arg0 / 100;
            var note_sounds = [notesnd_no, notesnd_1, notesnd_2, notesnd_3, sfx_note_hit];
            audio_play_sound(note_sounds[global.op_note_hitsounds], 1, false, global.op_hitsound_volume);
        },
        
        read_value: function()
        {
            ini_open("system");
            var r = ini_read_real("config", "hitsound_volume", 100);
            ini_close();
            global.op_hitsound_volume = r / 100;
            return r;
        },
        
        get_value: function()
        {
            return global.op_hitsound_volume * 100;
        },
        
        save: function()
        {
            ini_open("system");
            ini_write_real("config", "hitsound_volume", global.op_hitsound_volume * 100);
            ini_close();
        }
    }, 
    {
        name: "Note Sound on Hold Ticks",
        description: "Toggle if note sounds should play on mid-hold combo gain.",
        type: 0,
        values: ["Disabled", "Enabled"],
        default_value: 1,
        key: "hitsound_ticks"
    }, 
    {
        name: "Top Number Display",
        description: "Controls which value the combo counter displays.",
        type: 0,
        values: ["No Display", "Combo", "EX Score", "Acc. Score", "Max Score", "Accuracy", "X-Accuracy"],
        default_value: 1,
        key: "minusscore"
    }, 
    {
        name: "Judgement Counter",
        description: "Shows a count for each judgement during gameplay.",
        type: 0,
        values: ["Disabled", "Enabled"],
        default_value: 0,
        key: "judgement_counter"
    }, 
    {
        name: "Reduced Particles",
        description: "Reduces note particles to improve performance.",
        type: 0,
        values: ["Normal", "Reduced"],
        default_value: 0,
        key: "particles"
    }, 
    {
        name: "FC/AC Indicator",
        description: "Shows a symbol when a Full Combo or All Critical is being held.",
        type: 0,
        values: ["Disabled", "Enabled"],
        default_value: 0,
        key: "fcacindicator"
    }, 
    {
        name: "Early/Late Display",
        description: "Shows text indicated if notes were hit early or late.",
        type: 0,
        values: ["Disabled", "CRIT or Below", "GREAT or Below"],
        default_value: 2,
        key: "mod_earlyplus"
    }, 
    {
        name: "Judgement Display",
        description: "Shows text or a graph indicating the last note judgement hit.",
        type: 0,
        values: ["None", "Modern", "Classic", "Graph"],
        default_value: 1,
        key: "mod_judgement"
    }, 
    {
        name: "Text Sound",
        description: "Enables or disables the text sound in the story.",
        type: 0,
        values: ["Disabled", "Enabled"],
        default_value: 1,
        key: "textsfx"
    }, 
    {
        name: "Discord Rich Presence",
        description: "Enables detailed play info on Discord profiles.",
        type: 0,
        values: ["Disabled", "Enabled"],
        default_value: 1,
        key: "richpresence",
        
        on_change: function(arg0)
        {
            global.op_richpresence = arg0;
            
            if (arg0)
            {
                instance_create_depth(0, 0, 0, obj_presence);
            }
            else
            {
                with (obj_presence)
                    instance_destroy();
            }
        },
        
        read_value: function()
        {
            ini_open("system");
            var r = ini_read_real("config", "richpresence", 1);
            ini_close();
            global.op_richpresence = r;
            return r;
        },
        
        save: function()
        {
            ini_open("system");
            ini_write_real("config", "richpresence", global.op_richpresence);
            ini_close();
        }
    }, 
    {
        name: "Keyboard Configuration",
        description: "Select to rebind keyboard control settings.",
        type: 2,
        scene: scene_controlrebinding,
        
        read_value: function()
        {
            ini_open("system");
            global.l2in = ini_read_real("bindings", "lane1", 83);
            global.l3in = ini_read_real("bindings", "lane2", 68);
            global.l4in = ini_read_real("bindings", "lane3", 74);
            global.l5in = ini_read_real("bindings", "lane4", 75);
            global.l1in = ini_read_real("bindings", "lslide", 160);
            global.l6in = ini_read_real("bindings", "rslide", 161);
            global.menu_confirm = ini_read_real("bindings", "mconf", 13);
            global.menu_cancel = ini_read_real("bindings", "mcanc", 27);
            global.quick_restart_key = ini_read_real("bindings", "restart", 82);
            ini_close();
        }
    }, 
    {
        name: "User Manual",
        description: "Select to open the User Manual.",
        type: 3,
        
        read_value: function()
        {
        },
        
        do_function: function()
        {
            play_se(select);
            url_open_ext(working_directory + "vivid_stasis User Manual.pdf", "_self");
        }
    }, 
    {
        name: "Autoplay",
        description: "The song will play itself. Scores will not be saved.",
        type: 0,
        values: ["Disabled", "Enabled"],
        default_value: 0,
        key: "autoplay"
    }, 
    {
        name: "Content Warnings",
        description: "Content warnings will appear in the story for potentially sensitive scenes.",
        type: 0,
        values: ["Disabled", "Enabled"],
        default_value: 0,
        key: "access_contentwarnings"
    }, 
    {
        name: "Currency Multiplier",
        description: "Points/Battery gain will be increased to lower possible grinding.",
        type: 0,
        values: ["Disabled", "2x", "4x", "8x"],
        default_value: 0,
        key: "access_currencymultiplier"
    }, 
    {
        name: "Unlock All Modes",
        description: "Menu options locked behind story completion will be force-unlocked.",
        type: 0,
        values: ["Disabled", "Enabled"],
        default_value: 0,
        key: "access_unlockallmodes"
    }, 
    {
        name: "Unlock Conditions",
        description: "Unlock conditions for story progression will be reduced/disabled.",
        type: 0,
        values: ["Default", "Easier", "Bypass"],
        default_value: 0,
        key: "access_unlockconditions"
    }, 
    {
        name: "Puzzle Hints",
        description: "Enables the hint system for story puzzles.",
        type: 0,
        values: ["Disabled", "Enabled"],
        default_value: 0,
        key: "access_puzzlehints"
    }, 
    {
        name: "Unlock All Songs",
        description: "Songs that have been out for some time will be auto-unlocked.",
        type: 0,
        values: ["Disabled", "Enabled"],
        default_value: 0,
        key: "access_unlockallsongs"
    }, 
    {
        name: "Change Title Screen",
        description: "Changes the title screen.",
        type: 0,
        values: ["Chapter 1", "Chapter 2", "Chapter 3", "Chapter 4", "Chapter 5", "Chapter 6", "End", "Encore"],
        default_value: UnknownEnum.Value_6,
        key: "titlescreen",
        
        on_change: function(arg0)
        {
            ini_open(global.profile_file);
            ini_write_real("profile", "titlescreen", arg0);
            ini_close();
            global.op_titlescreen = arg0;
        },
        
        read_value: function()
        {
            ini_open(global.profile_file);
            var r = ini_read_real("profile", "titlescreen", UnknownEnum.Value_6);
            ini_close();
            global.op_titlescreen = r;
            return r;
        }
    }, 
    {
        name: "Legacy Judgements",
        description: "Shows text indicating the last judgement at the bottom of the screen.",
        type: 0,
        values: ["Disabled", "Enabled"],
        default_value: 0,
        key: "text_judgements"
    }, 
    {
        name: "Score Pace Display",
        description: "Shows text indicating the current accuracy rank.",
        type: 0,
        values: ["Disabled", "Enabled"],
        default_value: 0,
        key: "pacemaker"
    }, 
    {
        name: "Manage Save Backups",
        description: "Load from/delete backups of your save file. ONLY USE THIS IF YOU ARE STUCK!",
        type: 3,
        
        read_value: function()
        {
        },
        
        do_function: function()
        {
            is_active = false;
            audio_stop_all();
            room_persistent = false;
            play_se(sfx_songsel_beginsong);
            var transition = instance_create_depth(160, 90, -10000, o_transition_diamond);
            
            with (transition)
            {
                TweenEasyScale(1, 1, 320, 320, 0, 60, EaseOutQuad);
                next_room = scene_restore_menu;
                alarm[0] = 60;
            }
        }
    }, 
    {
        name: "Manage Achievements",
        description: "Restore local achievements or revoke them.",
        type: 3,
        
        read_value: function()
        {
        },
        
        do_function: function()
        {
            is_active = false;
            audio_stop_all();
            room_persistent = false;
            play_se(sfx_songsel_beginsong);
            var transition = instance_create_depth(160, 90, -10000, o_transition_diamond);
            
            with (transition)
            {
                TweenEasyScale(1, 1, 320, 320, 0, 60, EaseOutQuad);
                next_room = scene_manage_achievements;
                alarm[0] = 60;
            }
        }
    }, 
    {
        name: "Separate Dev Highscores",
        description: "Uses a separate highscore table.",
        type: 0,
        values: ["Disabled", "Enabled"],
        default_value: 1,
        
        on_change: function(arg0)
        {
            global.highscore_file = arg0 ? "highscore_table_dev" : "highscore_table";
            load_highscores();
        },
        
        read_value: function()
        {
            return false;
            ini_open("system");
            var r = ini_read_real("dev", "separate_highscores", 1);
            ini_close();
            global.highscore_file = r ? "highscore_table_dev" : "highscore_table";
            return r;
        },
        
        get_value: function()
        {
            return global.highscore_file == "highscore_table_dev";
        },
        
        save: function()
        {
            ini_open("system");
            ini_write_real("dev", "separate_highscores", (global.highscore_file == "highscore_table") ? 0 : 1);
            ini_close();
        }
    }, 
    {
        name: "Unlock Steam Achievements",
        description: "Enables achievements to be unlocked on debug builds",
        type: 0,
        values: ["Disabled", "Enabled"],
        default_value: 1,
        key: ["dev", "unlock_achievements"],
        
        read_value: function()
        {
            var r = true;
            ini_open("system");
            r = ini_read_real("dev", "unlock_achievements", 1);
            ini_close();
            global.op_unlock_achievements = r;
            return r;
        }
    }, 
    {
        name: "Steam Achievement Popup",
        description: "Shows any achievements that have had their unlocks recently triggered.",
        type: 0,
        values: ["Disabled", "Enabled"],
        default_value: 0,
        key: ["dev", "debug_achievements"],
        
        read_value: function()
        {
            var r = false;
            global.op_debug_achievements = r;
            return r;
        }
    }, 
    {
        name: "Note Spawning Threshold",
        description: "Changes note spawn method. Higher will affect performance.",
        type: 0,
        values: ["Default", "High", "Low"],
        default_value: 0,
        key: "legacy_pooling"
    }, 
    {
        name: "Flowchart Unlocks",
        description: "On Story Mode, story nodes don't cost any Batteries.",
        type: 0,
        values: ["Normal", "Story"],
        default_value: 0,
        key: "flowchart_unlocks"
    }, 
    {
        name: "Assist Mode",
        description: "Remove the challenge gauge from all boss song unlocks",
        type: 0,
        values: ["Disabled", "Enabled"],
        default_value: 0,
        key: "assist_mode"
    }, 
    {
        name: "Legacy Font",
        description: "Changes to the pre-5.0 font. May be harder to read.",
        type: 0,
        values: ["Disabled", "Enabled"],
        default_value: 0,
        key: "legacy_font",
        
        read_value: function()
        {
            ini_open("system");
            global.op_legacy_font = ini_read_real("config", "legacy_font", false);
            ini_close();
            set_default_fonts();
            return global.op_legacy_font;
        },
        
        on_change: function(arg0)
        {
            ini_open("system");
            ini_write_real("config", "legacy_font", arg0);
            global.op_legacy_font = arg0;
            set_default_fonts();
        }
    }, 
    {
        name: "Reset Story Progress",
        description: "Reset your save file. Highscores will not be reset.",
        type: 3,
        
        read_value: function()
        {
        },
        
        do_function: function()
        {
            is_active = false;
            audio_stop_all();
            room_persistent = false;
            play_se(sfx_songsel_beginsong);
            var transition = instance_create_depth(160, 90, -10000, o_transition_diamond);
            
            with (transition)
            {
                TweenEasyScale(1, 1, 320, 320, 0, 60, EaseOutQuad);
                next_room = scene_v5_savenotif_1;
                alarm[0] = 60;
            }
        }
    }, 
    {
        name: "Code Entry Screen",
        description: "Enter a code here if you come across one.",
        type: 3,
        
        read_value: function()
        {
        },
        
        do_function: function()
        {
            is_active = false;
            audio_stop_all();
            room_persistent = false;
            play_se(sfx_songsel_beginsong);
            var transition = instance_create_depth(160, 90, -10000, o_transition_diamond);
            
            with (transition)
            {
                TweenEasyScale(1, 1, 320, 320, 0, 60, EaseOutQuad);
                next_room = scene_codeentry;
                alarm[0] = 60;
            }
        }
    }, 
    {
        name: "Vertical Sync",
        description: "Enables v-sync. May fix screen tearing.",
        type: 0,
        values: ["Disabled", "Enabled"],
        default_value: 0,
        key: "vsync",
        
        on_change: function(arg0)
        {
            display_reset(0, arg0);
            global.op_vsync = arg0;
        }
    }, 
    {
        name: "Mirror Mode",
        description: "Flips every note to its opposite lane.",
        type: 0,
        values: ["Disabled", "Enabled"],
        default_value: 0,
        key: "mirror"
    }, 
    {
        name: "Lagback Threshold",
        description: "Adjusts how long a frame has to take for it to be considered a lagspike.",
        slider_range: [34, infinity],
        enforce_range: true,
        type: 1,
        default_value: 100,
        increments: [1, 5],
        key: "lagback_threshold",
        
        read_value: function()
        {
            ini_open("system");
            global.op_lagback_threshold = ini_read_real("config", "lagback_threshold", global.system_options[UnknownEnum.Value_54].default_value);
            ini_close();
            global.system_options[UnknownEnum.Value_54].increments[1] = (global.op_lagback_threshold >= 35) ? 5 : 1;
            return global.op_lagback_threshold;
        },
        
        on_change: function(arg0)
        {
            global.op_lagback_threshold = arg0;
            global.system_options[UnknownEnum.Value_54].increments[1] = (arg0 >= 35) ? 5 : 1;
        },
        
        to_string: function(arg0)
        {
            return (arg0 >= 35) ? string_format(arg0, 0, 0) : "Off";
        }
    }, 
    {
        name: "Note Alignment",
        description: "Changes which part of a note touches the judgement line on a perfect hit.",
        type: 0,
        values: ["Top", "Bottom"],
        default_value: 0,
        key: "note_alignment"
    }, 
    {
        name: "Hide Cursor",
        description: "Hides the cursor during gameplay.",
        type: 0,
        values: ["Disabled", "Enabled"],
        default_value: 1,
        key: "hide_cursor"
    },
    // AP MOD START
    {
        name: "Archipelago Join",
        description: "Join a multiworld!",
        type: 3,
        
        read_value: function() { },
        
        do_function: function() {
            is_active = false;
            audio_stop_all();
            room_persistent = false;
            play_se(sfx_songsel_beginsong);
            var transition = instance_create_depth(160, 90, -10000, o_transition_diamond);
            
            with (transition)
            {
                TweenEasyScale(1, 1, 320, 320, 0, 60, EaseOutQuad);
                next_room = scene_ap_join;
                alarm[0] = 60;
            }
        }
    },
    {
        name: "Deathlink Override",
        description: "Forcefully disable deathlink.",
        type: 0,
        values: ["Archipelago", "Force Disabled"],
        default_value: 0,
        key: "ap_deathlinkoverride"
    },
	{
		name: "Rank Requirement",
		description: "Minimum rank to complete a song's check.",
		type: 0,
		values: ["SS", "S+", "S", "AA", "A"],
		default_value: 0,
		key: "ap_rankreq"
	}
	// AP MOD END
];
    
    for (var i = 0; i < array_length(global.system_options); i++)
    {
        var option = global.system_options[i];
        
        if (variable_struct_exists(option, "key"))
        {
            var key = option.key;
            var val = key;
            
            if (typeof(key) == "array")
            {
                val = key[array_length(key) - 1];
                
                if (array_length(key) < 2)
                    array_insert(key, 0, "config");
                
                if (array_length(key) < 3)
                    array_insert(key, 0, "system");
            }
            else
            {
                key = ["system", "config", key];
            }
            
            option.key = key;
            
            if (!variable_struct_exists(option, "varname"))
                option.varname = @@string@@("op_{0}", val);
        }
        
        switch (option.type)
        {
            case 1:
                if (!variable_struct_exists(option, "enforce_range"))
                    option.enforce_range = false;
                
                break;
            
            case 0:
                option.max_value = array_length(option.values) - 1;
                break;
        }
        
        option_read_value(option);
        global.system_options[i] = option;
    }
}

enum UnknownEnum
{
    Value_0,
    Value_1,
    Value_2,
    Value_4 = 4,
    Value_5,
    Value_6,
    Value_7,
    Value_8,
    Value_9,
    Value_10,
    Value_11,
    Value_12,
    Value_13,
    Value_14,
    Value_15,
    Value_16,
    Value_18 = 18,
    Value_19,
    Value_20,
    Value_21,
    Value_22,
    Value_23,
    Value_24,
    Value_25,
    Value_26,
    Value_27,
    Value_28,
    Value_29,
    Value_31 = 31,
    Value_32,
    Value_33,
    Value_34,
    Value_35,
    Value_36,
    Value_37,
    Value_38,
    Value_39,
    Value_40,
    Value_41,
    Value_47 = 47,
    Value_48,
    Value_49,
    Value_50,
    Value_51,
    Value_52,
    Value_53,
    Value_54,
    Value_55,
    Value_56
}
