function process_song_unlocks()
{
    create_song_unlock_times();
    if (get_story_progress() > 33)
    {
        ini_open(global.profile_file);
        ini_write_real("chapter5", "isthisit", 1);
        ini_close();
    }
    var song_count = array_length(global.song_list);
    var unlocks = [];
    for (var i = 0; i < song_count; i++)
    {
        var su = [false, false, false, false];
        var u = global.song_list[i].unlock;
        if (!struct_get_fallback(u, "locked", false))
        {
            switch (u.type)
            {
                case UnknownEnum.Value_0:
                    su[0] = true;
                    break;
                case UnknownEnum.Value_1:
                    ini_open(global.profile_file);
                    var u_value = ini_read_real(u.section, u.key, 0);
                    ini_close();
                    if (u.per_difficulty)
                    {
                        for (var d = 0; d < u_value; d++)
                        {
                            su[d] = true;
                        }
                        if (!global.song_list[i].has_encore)
                        {
                            su[3] = su[2];
                        }
                    }
                    else if (u_value > 0)
                    {
                        su[0] = true;
                    }
                    break;
                case UnknownEnum.Value_2:
                    var u_value = global.unlocked_event_nodes[u.node_id];
                    if (u_value > 0)
                    {
                        su[0] = true;
                    }
                    break;
                case UnknownEnum.Value_3:
                    ini_open(global.profile_file);
                    if (ini_read_real("ssv2", $"map{u.map_id}progress", 0) >= u.ep_req || (u.has_legacy_unlock && ini_read_real("soundscan", $"map{u.legacy_map_id}progress", 0) >= u.legacy_ep_req))
                    {
                        su[0] = true;
                    }
                    ini_close();
                    break;
                case UnknownEnum.Value_6:
                    if (unix_timestamp() >= u.time)
                    {
                        su[0] = true;
                    }
                    break;
            }
            // AP MOD
            su[1] = su[0]
            su[2] = su[0]
            su[3] = su[0]
            // AP MOD END
        }
        unlocks[i] = su;
        var timegate_pass = true;
        if (struct_get_fallback(u, "is_timegate", false))
        {
            timegate_pass = unix_timestamp() >= u.time;
        }
        if (global.op_access_unlockallsongs && timegate_pass)
        {
            if (unlocks[i][0] < 3)
            {
                unlocks[i][0] = 3;
            }
            if (unlocks[i][1] < 3)
            {
                unlocks[i][1] = 3;
            }
            if (unlocks[i][2] < 3)
            {
                unlocks[i][2] = 3;
            }
            if (unlocks[i][3] < 3)
            {
                unlocks[i][3] = 3;
            }
        }
    }
    ini_open(global.profile_file);
    global.song_list[106].show_encore = ini_read_real("profile", "highest_class_v3", 0) >= 13;
    ini_close();
    global.unlocked_songs = unlocks;
    var alp = get_alpha_story_progress();
    if (alp >= 3 && alp <= 4)
    {
        global.unlocked_songs[177][0] = true;
        global.unlocked_songs[177][1] = true;
        global.unlocked_songs[177][2] = true;
    }
    process_soundscan_unlocks();
}

enum UnknownEnum
{
    Value_0,
    Value_1,
    Value_2,
    Value_3,
    Value_4,
    Value_5,
    Value_6
}
