if (is_active)
{
    if (input_check_pressed(UnknownEnum.Value_14) || mouse_wheel_down())
    {
        if (currentsel < (array_length(menu_objs) - 1))
        {
            currentsel++;
        }
        else if (input_check_pressed(UnknownEnum.Value_14))
        {
            currentsel = 0;
        }
        hovered = currentsel;
        refreshButtons();
        play_se(sfx_songsel_cursor);
    }
    if (input_check_pressed(UnknownEnum.Value_13) || mouse_wheel_up())
    {
        if (currentsel > 0)
        {
            currentsel--;
        }
        else if (input_check_pressed(UnknownEnum.Value_13))
        {
            currentsel = array_length(menu_objs) - 1;
        }
        hovered = currentsel;
        refreshButtons();
        play_se(sfx_songsel_cursor);
    }
    if (input_check_pressed(UnknownEnum.Value_5) && !global.ap_doing_queue)
    {
        audio_stop_all();
        debug(video_get_status());
        if (video_get_status() == 3)
        {
            video_close();
            debug("CLOSE THE FUCKING VIDEO PLEASE I SWEAR TO GOD");
        }
        ini_open(global.profile_file);
        var p = ini_read_real("profile", "story_progress", 0);
        var fin = ini_read_real("profile", "finished_game", false);
        ini_close();
        play_se(sfx_songsel_beginsong);
        var transition = instance_create_depth(room_width / 2, room_height / 2, -10000, o_transition_diamond);
        with (transition)
        {
            TweenEasyScale(1, 1, 320, 320, 0, 60, EaseOutQuad);
            if (p >= 14 && p < 34)
            {
                next_room = scene_2024boot;
            }
            else
            {
                next_room = scene_2023boot;
            }
            if (fin)
            {
                next_room = postgame_titlescreen_go();
            }
            alarm[0] = 60;
        }
        is_active = false;
        exit;
    }
    if (input_check_pressed(UnknownEnum.Value_4) && !global.ap_doing_queue)
    {
        global.main_menu_last_selected = currentsel;
        var button = menu_objs[currentsel];
        if (is_method(button.activate))
        {
            if (!button.obfuscate)
            {
                var func = method(self, button.activate);
                func();
            }
        }
    }
    var mouseButton = instance_position(mouse_x, mouse_y, o_newmainbutton);
    if (mouse_x != mouseX || mouse_y != mouseY)
    {
        mouseX = mouse_x;
        mouseY = mouse_y;
        if (mouseButton != -4)
        {
            var changed = false;
            for (var i = 0; i < array_length(menu_objs); i++)
            {
                if (mouseButton.id == menu_objs[i].id)
                {
                    if (hovered != i)
                    {
                        hovered = i;
                        play_se(sfx_songsel_cursor);
                        refreshButtons();
                    }
                    break;
                }
            }
        }
    }
    if (mouseButton != -4)
    {
        if (mouse_check_button_pressed(mb_left))
        {
            global.main_menu_last_selected = hovered;
            if (is_method(mouseButton.activate))
            {
                if (!mouseButton.obfuscate)
                {
                    var func = method(self, mouseButton.activate);
                    func();
                }
            }
        }
    }
}

enum UnknownEnum
{
    Value_4 = 4,
    Value_5,
    Value_13 = 13,
    Value_14
}
