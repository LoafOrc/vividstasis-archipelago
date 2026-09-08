function refresh_song_objects(arg0, arg1 = false)
{
    if (!variable_instance_exists(id, "song_objects"))
    {
        song_objects = [];
    }
    song_list = global.song_list;
    songs = [];
    if (arg1)
    {
        song_list = global.shatter_list;
        for (i = 0; i < array_length(global.shatter_order); i++)
        {
            var s = global.shatter_order[i];
            if (global.shatter_list[s].unlock())
            {
                array_push(songs, [s]);
            }
        }
    }
    else
    {
        global.selected_pack += arg0;
        global.selected_pack = (global.selected_pack + array_length(global.song_packs)) % array_length(global.song_packs);
        var low_diff = min(primary_difficulty, secondary_difficulty);
        var high_diff = max(primary_difficulty, secondary_difficulty);
        var low_range = min(level_range_start, level_range_end);
        var high_range = max(level_range_start, level_range_end);
        
        var add_song_after_range_check = function(arg0, arg1, arg2)
        {
            var chk = floor(struct_get(song_list[arg2[0]], $"difficulty_constant_{arg2[1] + 1}"));
            if (chk >= 12)
            {
                chk += (chk - 11);
            }
            if ((struct_get(song_list[arg2[0]], $"difficulty_constant_{arg2[1] + 1}") % 1) >= 0.5)
            {
                chk++;
            }
            chk--;
            if ((chk >= arg0 && chk <= arg1) || chk == -1)
            {
                array_push(songs, arg2);
            }
        };
        
        for (i = 0; i < array_length(global.song_packs[global.selected_pack].songs); i++)
        {
            var song = global.song_packs[global.selected_pack].songs[i];
            debug(song);
			// AP MOD
            var add_song = true;
            var add_encore = true;
			// AP MOD
            if (add_song || (false && input_check(UnknownEnum.Value_10)))
            {
                for (var d = low_diff; d <= high_diff; d++)
                {
                    if (d < 3 || add_encore)
                    {
                        var artists = song_get_info(song_list[song], "sort_artists", d);
                        if (global.sort_type == UnknownEnum.Value_4)
                        {
                            for (var a = 0; a < array_length(artists); a++)
                            {
                                add_song_after_range_check(low_range, high_range, [song, d, array_length(songs), artists[a]]);
                            }
                        }
                        else
                        {
                            add_song_after_range_check(low_range, high_range, [song, d, array_length(songs)]);
                        }
                    }
                    else if (d == 3 && !add_encore && low_diff == high_diff)
                    {
                        var artists = song_get_info(song_list[song], "sort_artists", d);
                        if (global.sort_type == UnknownEnum.Value_4)
                        {
                            for (var a = 0; a < array_length(artists); a++)
                            {
                                add_song_after_range_check(low_range, high_range, [song, 2, array_length(songs), artists[a]]);
                            }
                        }
                        else
                        {
                            add_song_after_range_check(low_range, high_range, [song, 2, array_length(songs)]);
                        }
                    }
                }
            }
        }
        switch (global.sort_type)
        {
            case UnknownEnum.Value_1:
                array_sort(songs, function(arg0, arg1)
                {
                    var a_title = string_lower(romaji(song_list[arg0[0]].name));
                    var b_title = string_lower(romaji(song_list[arg1[0]].name));
                    if (a_title > b_title)
                    {
                        return 1;
                    }
                    if (a_title < b_title)
                    {
                        return -1;
                    }
                    return sign(arg0[2] - arg1[2]);
                });
                break;
            case UnknownEnum.Value_2:
                array_sort(songs, function(arg0, arg1)
                {
                    var a_diff = struct_get(song_list[arg0[0]], $"difficulty_constant_{arg0[1] + 1}");
                    var b_diff = struct_get(song_list[arg1[0]], $"difficulty_constant_{arg1[1] + 1}");
                    if (a_diff != b_diff)
                    {
                        return sign(a_diff - b_diff);
                    }
                    return sign(arg0[2] - arg1[2]);
                });
                break;
            case UnknownEnum.Value_3:
                array_sort(songs, function(arg0, arg1)
                {
                    var a_score = global.highscores.normal[arg0[0]][arg0[1]].score;
                    var b_score = global.highscores.normal[arg1[0]][arg1[1]].score;
                    if (a_score != b_score)
                    {
                        return sign(b_score - a_score);
                    }
                    return sign(arg0[2] - arg1[2]);
                });
                break;
            case UnknownEnum.Value_4:
                array_sort(songs, function(arg0, arg1)
                {
                    var a_artist = string_lower(romaji(arg0[3]));
                    var b_artist = string_lower(romaji(arg1[3]));
                    if (a_artist > b_artist)
                    {
                        return 1;
                    }
                    if (a_artist < b_artist)
                    {
                        return -1;
                    }
                    return sign(arg0[2] - arg1[2]);
                });
                break;
            case UnknownEnum.Value_5:
                array_sort(songs, function(arg0, arg1)
                {
                    var a_ver = string_split(song_list[arg0[0]].version, ".");
                    var b_ver = string_split(song_list[arg1[0]].version, ".");
                    for (var i = 0; i < array_length(a_ver) || i < array_length(b_ver); i++)
                    {
                        if (i >= array_length(a_ver))
                        {
                            return -1;
                        }
                        if (i >= array_length(b_ver))
                        {
                            return 1;
                        }
                        if (a_ver[i] != b_ver[i])
                        {
                            return sign(real(a_ver[i]) - real(b_ver[i]));
                        }
                    }
                    return sign(arg0[2] - arg1[2]);
                });
                break;
            case UnknownEnum.Value_6:
                array_sort(songs, function(arg0, arg1)
                {
                    return random(3) - 1;
                });
                break;
        }
        if (global.sort_reverse)
        {
            var sort_cutoff = floor(array_length(songs) / 2);
            for (i = 0; i < sort_cutoff; i++)
            {
                var back_i = array_length(songs) - i - 1;
                var holding = songs[i];
                songs[i] = songs[back_i];
                songs[back_i] = holding;
            }
        }
    }
    var obj_count = array_length(song_objects);
    for (i = 0; i < array_length(songs); i++)
    {
        var obj = 0;
        if (i >= obj_count)
        {
            obj = instance_create_depth(4, (i * 26) + 90, 85, arg1 ? o_songobject_shatter : o_songobject_main);
            obj.controller = id;
        }
        else
        {
            obj = song_objects[i];
            obj.enabled = true;
            obj.redraw = true;
        }
        obj.show_detail_toggle = true;
        var song = song_list[songs[i][0]];
        obj.song_id = songs[i][0];
        if (variable_instance_exists(obj, "update_show_detail"))
        {
            obj.update_show_detail();
        }
        obj.position = i;
        if (arg1)
        {
            obj.diff_name = song.difficulty_name;
            obj.diff_value = song.difficulty_number;
            obj.boosted = false;
        }
        else
        {
            var diff = songs[i][1];
            if (diff == 3 && song.has_encore != "1.0")
            {
                diff = 2;
            }
            obj.diff = diff;
            var diff_names = ["OPENING", "MIDDLE", "FINALE", "ENCORE"];
            obj.diff_name = diff_names[diff];
            obj.diff_value = struct_get(song, $"difficulty_display_{diff + 1}");
            obj.unlock_hint = (diff == 3 && !song.unlock.per_difficulty) ? song.unlock.enc_hint : song.unlock.hint;
            obj.boosted = array_contains(global.daily_boost_songs, obj.song_id);
            obj.favourite = array_contains(global.favourite_songs, obj.song_id);
        }
        song_objects[i] = obj;
        if (global.force_song_select == songs[i])
        {
            cursor_pos = i;
        }
    }
    var i = array_length(songs);
    while (i < obj_count)
    {
        song_objects[i].enabled = false;
        i++;
    }
}

enum UnknownEnum
{
    Value_1 = 1,
    Value_2,
    Value_3,
    Value_4,
    Value_5,
    Value_6,
    Value_10 = 10
}
