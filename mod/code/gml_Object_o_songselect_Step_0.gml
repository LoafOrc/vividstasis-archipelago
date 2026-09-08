jacket_frame += 0.5;
if (!is_selecting)
{
    exit;
}
if (false && keyboard_check_pressed(vk_f9))
{
    top_y = (((top_y * -1) + 10) % 50) * -1;
    song_info_x = ((song_info_x - 178) % 150) + 208;
}
if (input_check_pressed(UnknownEnum.Value_5) && !global.ap_doing_queue)
{
    on_song_cancel();
    is_selecting = false;
    exit;
}
if (array_length(songs) > 0)
{
    var song_change = 0;
    var wrap = true;
    if (input_check_pressed(UnknownEnum.Value_13) || mouse_wheel_up())
    {
        song_change--;
        if (mouse_wheel_up())
        {
            wrap = false;
        }
        global.random_selection = false;
        timer_checking = 1;
        hold_down_timer = 30;
    }
    if (input_check_pressed(UnknownEnum.Value_14) || mouse_wheel_down())
    {
        song_change++;
        if (mouse_wheel_down())
        {
            wrap = false;
        }
        global.random_selection = false;
        timer_checking = 2;
        hold_down_timer = 30;
    }
    if (timer_checking > 0)
    {
        if (input_check_released(UnknownEnum.Value_14) || input_check_released(UnknownEnum.Value_13))
        {
            timer_checking = false;
        }
        else
        {
            hold_down_timer--;
            if (hold_down_timer < 0)
            {
                if (input_check(UnknownEnum.Value_13))
                {
                    hold_down_scrolling = 1;
                    alarm[0] = 4;
                }
                if (input_check(UnknownEnum.Value_14))
                {
                    hold_down_scrolling = 2;
                    alarm[0] = 4;
                }
                timer_checking = false;
            }
        }
    }
    if (keyboard_check_pressed(vk_pageup))
    {
        global.random_selection = false;
        if ((cursor_pos + song_change) > (page_distance - 1))
        {
            song_change -= page_distance;
        }
        else
        {
            song_change = cursor_pos * -1;
        }
    }
    if (keyboard_check_pressed(vk_pagedown))
    {
        global.random_selection = false;
        var pack_end = array_length(songs) - 1;
        if ((cursor_pos + song_change + page_distance) <= pack_end)
        {
            song_change += page_distance;
        }
        else
        {
            song_change = pack_end - cursor_pos;
        }
    }
    if (keyboard_check_pressed(vk_home))
    {
        song_change = cursor_pos * -1;
        global.random_selection = false;
    }
    if (keyboard_check_pressed(vk_end))
    {
        song_change = array_length(songs) - 1 - cursor_pos;
        global.random_selection = false;
    }
    if (song_change != 0)
    {
        random_list = [];
        random_index = -1;
    }
    if (keyboard_check_pressed(ord("R")))
    {
        if (!input_check(UnknownEnum.Value_10))
        {
            random_index++;
            if (random_index == array_length(random_list))
            {
                array_push(random_list, round(random(array_length(songs))));
            }
            song_change = random_list[random_index];
        }
        else if (random_index >= 0)
        {
            song_change = random_list[random_index] * -1;
            random_index--;
        }
        global.random_selection = true;
    }
    if (song_change != 0 && array_length(songs) > 0)
    {
        if (wrap || ((cursor_pos + song_change) >= 0 && (cursor_pos + song_change) < array_length(songs)))
        {
            change_song(song_change);
            play_se(sfx_songsel_cursor);
            go_to_origin = false;
        }
    }
    if (input_check_pressed(UnknownEnum.Value_4) && !global.ap_doing_queue)
    {
        if (song_objects[cursor_pos].show_detail)
        {
            on_song_select();
        }
        else
        {
            play_se(buzzer);
        }
        go_to_origin = false;
    }
}
if (input_check_pressed(UnknownEnum.Value_10))
{
    go_to_origin = true;
}
if (input_check_released(UnknownEnum.Value_10))
{
    if (variable_struct_exists(selected_song, "origin") && go_to_origin)
    {
        url_open(selected_song.origin.url);
    }
}
event_user(15);

enum UnknownEnum
{
    Value_4 = 4,
    Value_5,
    Value_10 = 10,
    Value_13 = 13,
    Value_14
}
