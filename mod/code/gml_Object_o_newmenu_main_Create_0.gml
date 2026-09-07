event_inherited();

if (variable_global_exists("main_menu_last_selected"))
{
    currentsel = global.main_menu_last_selected;
    hovered = global.main_menu_last_selected;
}

global.in_soundscan = false;
global.boundary_shatter = false;
global.alpha_story_progress = get_alpha_story_progress();

if (global.do_shatter_menu)
{
    instance_create_depth(x, y, depth, o_newmenu_shatter);
    instance_destroy();
}

ini_open(global.profile_file);
fin = ini_read_real("profile", "finished_game", 0);
ini_close();
alarm[0] = 55;

createButton(
{
    icon_sprite: sp_icon_rhythm_play,
    button_text: "Rhythm Play",
	requires_ap_connection: true,
    
    activate: function()
    {
		if(!is_ap_connected()) {
			play_se(buzzer);
			return;
		}

        if (input_check(UnknownEnum.Value_10))
        {
            global.last_freeplay_difficulty = 0;
            global.last_freeplay_difficulty2 = 0;
            global.last_freeplay_song = 0;
            global.last_freeplay_song_diff = 0;
            global.last_freeplay_pack = 0;
            global.sort_type = 0;
            global.sort_reverse = false;
        }
        
        create_song_packs();
        global.force_song_select = -1;
        transitionToScene(scene_songselect_old, true, 0);
    }
});

/*
createButton(
{
    icon_sprite: sp_icon_course_mode,
    button_text: "Course Mode",
    alpha_obfuscate: 1,
    
    activate: function()
    {
        if (get_story_progress() >= 9 || global.op_access_unlockallmodes)
            transitionToScene(scene_courseselect, true, 2);
        else
            play_se(buzzer);
    },
    
    unlock_text: "Complete Chapter 2",
    unlock_check: 9
});
createButton(
{
    icon_sprite: sp_icon_song_shop,
    button_text: "Song Shop",
    alpha_obfuscate: 1,
    
    activate: function()
    {
        if (get_story_progress() >= 3 || global.op_access_unlockallmodes)
            transitionToScene(scene_newstore, true, 3);
        else
            play_se(buzzer);
    },
    
    unlock_text: "Complete Chapter 1",
    unlock_check: 3
});
createButton(
{
    icon_sprite: sp_icon_ch0story,
    button_text: "Node Flowchart",
    alpha_obfuscate: 1,
    
    activate: function()
    {
        if (input_check(UnknownEnum.Value_10))
            global.last_eventline_node = 0;
        
        transitionToScene(scene_eventline, true, 4);
    }
});


createButton(
{
    icon_sprite: sp_icon_soundscan,
    button_text: "Soundscan",
    alpha_obfuscate: 1,
    
    activate: function()
    {
        if (get_story_progress() >= 16 || global.op_access_unlockallmodes)
        {
            global.last_soundscan_map = -1;
            transitionToScene(scene_soundscan, true, 5);
        }
        else
        {
            play_se(buzzer);
        }
    },
    
    unlock_text: "Complete Chapter 4",
    unlock_check: 16
});
*/

createButton(
{
    icon_sprite: sp_icon_node_flowchart,
    button_text: "Betweenspace",
    alpha_obfuscate: 1,
	requires_ap_connection: true,
    
    activate: function()
    {
		if(!is_ap_connected()) {
			play_se(buzzer);
            exit;
		}

        ini_open(global.profile_file);
        
        if (!ini_read_real("ap", "item_2000", false))
        {
            play_se(buzzer);
            exit;
        }
        
        ini_close();
        global.scape_crystals_earned = 0;
        global.seperate_betweenspace = false;
        load_rpg_progress();
        ini_open(global.profile_file);
        seen_intro = ini_read_real("betweenspace", "seen_intro", false);
        ini_close();
        
        if (false && input_check(UnknownEnum.Value_10))
            reset_rpg_room();
        
        transitionToCallback(function()
        {
            if (!seen_intro)
                instance_create_depth(0, 0, -1000, o_bsintro);
            
            goto_rpg_room(!input_check(UnknownEnum.Value_10));
        }, !seen_intro, true, 6);
    },
    
    unlock_text: "Unlock from Archipelago",
    unlock_check: 100
});

/*
ini_open(global.profile_file);
tama_unlock = ini_read_real("profile", "tama_unlock", false);
ac_unlock = ini_read_real("profile", "apocalypse_unlock", false);
cs_unlock = ini_read_real("profile", "unlock_characters", false);
ini_close();

if (tama_unlock)
{
    createButton(
    {
        icon_sprite: sp_icon_tama,
        button_text: "Tamasatchi",
        alpha_obfuscate: 1,
        
        activate: function()
        {
            global.chrono_play = false;
            transitionToScene(scene_tamasatchi, true, 7);
        }
    });
}
*/

createButton(
{
    icon_sprite: sp_icon_profile,
    button_text: "Profile",
    alpha_obfuscate: 2,
    
    activate: function()
    {
        play_se(select);
        is_active = false;
        
        for (var i = 0; i < array_length(menu_objs); i++)
        {
            with (menu_objs[i])
            {
                TweenEasyMove(x, y, x - 40, y, i * 3, 40, EaseInQuint);
                TweenEasyFade(1, 0, i * 3, 40, EaseInExpo);
                alarm[0] = (i * 3) + 40;
            }
        }
        
        with (r_box)
        {
            TweenEasyMove(7, 7, 7, -30, 15, 40, EaseInExpo);
            alarm[0] = 65;
        }
        
        instance_create_depth(-280, 35, depth - 500, o_statprofile);
        
        with (obj_mainmenuCharacter)
            TweenEasyFade(1, 0, 0, 60, EaseOutExpo);
        
        with (obj_mainmenuCharacterDiamond)
            TweenEasyFade(1, 0, 0, 60, EaseOutExpo);
        
        with (obj_mainmenuCharacterDiamond2)
            TweenEasyFade(0.5, 0, 0, 60, EaseOutExpo);
        
        with (obj_mainmenuHandler.d3)
            TweenEasyFade(0.5, 0, 0, 60, EaseOutExpo);
        
        alarm[2] = max(60, ((array_length(menu_objs) - 1) * 3) + 40);
    }
});
createButton(
{
    icon_sprite: sp_icon_rating_list,
    button_text: "Rating List",
    alpha_obfuscate: 1,
    
    activate: function()
    {
        play_se(select);
        is_active = false;
        instance_create_depth(4, 183, depth - 2600, obj_ratingWindow);
        TweenEasyMove(x, 0, x, -320, 0, 60, EaseInExpo);
    }
});
createButton(
{
    icon_sprite: sp_icon_character,
    button_text: "Character Change",
    alpha_obfuscate: 1,
    
    activate: function()
    {
        play_se(select);
        is_active = false;
        
        for (var i = 0; i < array_length(menu_objs); i++)
        {
            with (menu_objs[i])
            {
                TweenEasyMove(x, y, x - 40, y, i * 3, 40, EaseInQuint);
                TweenEasyFade(1, 0, i * 3, 40, EaseInExpo);
                alarm[0] = (i * 3) + 40;
            }
        }
        
        with (r_box)
        {
            TweenEasyMove(7, 7, 7, -30, 15, 40, EaseInExpo);
            alarm[0] = 65;
        }
        
        instance_create_depth(0, 0, -100, o_cs);
        alarm[2] = ((array_length(menu_objs) - 1) * 3) + 40;
    }
});

createButton(
{
    icon_sprite: sp_icon_credits,
    button_text: "Credits",
    alpha_obfuscate: 1,
    
    activate: function()
    {
        transitionToScene(scene_credits, true, 8);
    }
});
createButton(
{
    icon_sprite: sp_icon_system_options,
    button_text: "System Options",
    
    activate: function()
    {
        transitionToScene(scene_options, true, 8);
    }
});
instance_create_depth(0, 0, -2000, o_newbanner);
r_box = instance_create_depth(7, -26, -3000, o_ratingBox);

with (r_box)
    TweenEasyMove(7, y, 7, 7, 0, 40, EaseOutExpo);

obfuscated_surface = -1;

enum UnknownEnum
{
    Value_10 = 10
}
