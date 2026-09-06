var asc = showing_song_results ? acc_score : (acc_score / array_length(global.current_course.songs));
gnum = get_score_grade(asc);
if (gnum == UnknownEnum.Value_13)
{
    gnum = UnknownEnum.Value_12;
}
if (enabled)
{
    // AP MOD
    if (input_check_pressed(UnknownEnum.Value_4) && !global.ap_doing_queue)
    {
        enabled = false;
        call_cancel(music_callback);
        audio_stop_all();
        if (!global.course_mode)
        {
            play_se(sfx_songsel_beginsong);
            var transition = instance_create_depth(room_width / 2, room_height / 2, -1000, o_transition_diamond);
            with (transition)
            {
                TweenEasyScale(1, 1, 320, 320, 0, 60, EaseOutQuad);
                next_room = (global.decrypt_mode.gauge && global.failed) ? global.room_after_song.fail : global.room_after_song.clear;
                alarm[0] = 60;
            }
        }
        else
        {
            global.current_course_score = course_results.acc_score;
            global.current_course_index++;
            if (global.current_course_state == 0 && global.current_course_index == array_length(global.current_course.songs))
            {
                global.current_course_state = 2;
            }
            if (global.current_course_state == 0)
            {
                var dec = 5;
                if (variable_global_exists("is_apocalypse_course") && global.is_apocalypse_course)
                {
                    dec = 10;
                }
                var next_song = global.current_course.songs[global.current_course_index];
                if (variable_global_exists("is_apocalypse_course") && global.is_apocalypse_course && global.current_course_index == (array_length(global.current_course.songs) - 1))
                {
                    ini_open(global.profile_file);
                    var dif = ini_read_real("chapter5", "bacu", 0);
                    if ((next_song[1] + 1) > dif)
                    {
                        ini_write_real("chapter5", "bacu", next_song[1] + 1);
                    }
                    ini_close();
                    unlock_achievement("game_apoc");
                    dec = 0;
                }
                start_song(next_song[0], next_song[1], 
                {
                    course: true,
                    decrypt_style: global.decrypt_styles[dec],
                    clear_room: global.room_after_song.clear,
                    fail_room: global.room_after_song.fail,
                    quit_room: global.room_after_song.quit
                });
            }
            else
            {
                if (global.failed && global.current_course.name == "Blood Trial")
                {
                    ini_open(global.profile_file);
                    var deaths = ini_read_real("profile", "scarlet_deaths", 0);
                    deaths++;
                    ini_write_real("profile", "scarlet_deaths", deaths);
                    ini_close();
                }
                if (!global.op_autoplay && global.current_course_state == 2 && !global.is_apocalypse_course)
                {
                    var hs_id = global.current_course.course_id;
                    unlock_achievement("game_courseclear");
                    upload_score(hs_id, round(global.current_course_score));
                    unlock_profile_title("classified");
                    if (global.current_course.class == 8)
                    {
                        unlock_profile_title("course8");
                    }
                    if (global.current_course.name == "Blood Gate")
                    {
                        unlock_profile_title("scarletdeath");
                    }
                    if (global.current_course.name == "Blood Trial")
                    {
                        ini_open(global.profile_file);
                        ini_write_real("profile", "scarlet_quest", 4);
                        ini_close();
                    }
                    if (global.current_course.class == 9)
                    {
                        unlock_profile_title("course9");
                        unlock_achievement("game_course9");
                    }
                    if (global.current_course_score >= 3000000 && global.current_course_score < 4000000)
                    {
                        unlock_profile_title("colonthree");
                    }
                    if (global.current_course_score > variable_struct_get(global.highscores.courses, hs_id))
                    {
                        variable_struct_set(global.highscores.courses, hs_id, global.current_course_score);
                        save_highscores();
                    }
                    if (global.current_course.class > global.highest_class)
                    {
                        global.highest_class = global.current_course.class;
                        ini_open(global.profile_file);
                        ini_write_real("profile", "highest_class_v3", global.highest_class);
                        ini_close();
                    }
                }
                global.next_room = scene_courseselect;
                if (variable_global_exists("is_apocalypse_course") && global.is_apocalypse_course)
                {
                    global.next_room = scene_ac_challenge;
                }
                play_se(sfx_songsel_beginsong);
                var transition = instance_create_depth(room_width / 2, room_height / 2, -1000, o_transition_diamond);
                with (transition)
                {
                    TweenEasyScale(1, 1, 320, 320, 0, 60, EaseOutQuad);
                    next_room = (global.decrypt_mode.gauge && global.failed) ? global.room_after_song.fail : global.room_after_song.clear;
                    alarm[0] = 60;
                }
            }
        }
    }
    if (global.course_mode && !global.obscure_info)
    {
        var prev_resultsindex = resultsindex;
        resultsindex += (input_check_pressed(UnknownEnum.Value_12) - input_check_pressed(UnknownEnum.Value_11));
        resultsindex = clamp(resultsindex, 0, global.current_course_index + 1);
        if (resultsindex != prev_resultsindex)
        {
            event_user(1);
        }
    }
}

enum UnknownEnum
{
    Value_4 = 4,
    Value_11 = 11,
    Value_12,
    Value_13
}
