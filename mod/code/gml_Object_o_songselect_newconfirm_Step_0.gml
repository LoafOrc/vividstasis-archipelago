if (!loaded_options)
{
    event_user(0);
    loaded_options = true;
}
options_panel_cam_y = lerp(options_panel_cam_y, options_panel_target_cam_y, 0.2);
if (!is_active)
{
    exit;
}
var cursor_change = 0;
if (input_check_pressed(UnknownEnum.Value_13))
{
    cursor_change--;
}
if (input_check_pressed(UnknownEnum.Value_14))
{
    cursor_change++;
}
if (cursor_change != 0)
{
    if (options_cursor < array_length(options) && struct_exists(options[options_cursor], "on_unselect"))
    {
        options[options_cursor].on_unselect();
    }
    options_cursor = (options_cursor + cursor_change + array_length(options) + 1) % (array_length(options) + 1);
    options_panel_target_cam_y = clamp(22 * (options_cursor - 2), 0, ((array_length(options) * 22) + 13) - options_panel_height);
    if (options_cursor < array_length(options) && struct_exists(options[options_cursor], "on_select"))
    {
        options[options_cursor].on_select();
    }
}
var value_change = 0;
if (input_check_pressed(UnknownEnum.Value_11))
{
    value_change--;
}
if (input_check_pressed(UnknownEnum.Value_12))
{
    value_change++;
}
if (value_change != 0)
{
    play_se(sfx_songsel_diff);
    if (options_cursor < array_length(options))
    {
        var option = options[options_cursor];
        var value = option_values[options_cursor];
        if (option.type == 0)
        {
            value = (value + value_change + array_length(option.choices)) % array_length(option.choices);
        }
        else
        {
            if (input_check(UnknownEnum.Value_10))
            {
                value_change /= 10;
            }
            value = clamp(value + value_change, option.range[0], option.range[1]);
        }
        option_values[options_cursor] = value;
        if (struct_exists(option, "prop"))
        {
            struct_set(option.prop[0], option.prop[1], value);
        }
        if (struct_exists(option, "key"))
        {
            ini_open(option.key[0]);
            ini_write_real(option.key[1], option.key[2], value);
            ini_close();
        }
        if (struct_exists(option, "on_change"))
        {
            option.on_change(value);
        }
    }
}
illustrator = song_get_info(song, "jacket_artist", selected_difficulty);
if (input_check_pressed(UnknownEnum.Value_5))
{
    play_se(sfx_songsel_diff);
    if (instance_exists(o_heightpreview))
    {
        instance_destroy(o_heightpreview);
    }
    on_cancel();
}
if (input_check_pressed(UnknownEnum.Value_4) && !global.ap_doing_queue)
{
    if (bypass_unlocks || global.unlocked_songs[song.song_id][selected_difficulty])
    {
        for (var i = 0; i < array_length(options); i++)
        {
            var option = options[i];
            var value = option_values[i];
            if (struct_exists(option, "prop"))
            {
                struct_set(option.prop[0], option.prop[1], value);
            }
            if (struct_exists(option, "key"))
            {
                ini_open(option.key[0]);
                ini_write_real(option.key[1], option.key[2], value);
                ini_close();
            }
            if (struct_exists(option, "on_change"))
            {
                option.on_change(value);
            }
        }
        on_confirm();
    }
    else
    {
        play_se(sfx_songsel_select);
    }
}

enum UnknownEnum
{
    Value_4 = 4,
    Value_5,
    Value_10 = 10,
    Value_11,
    Value_12,
    Value_13,
    Value_14
}
