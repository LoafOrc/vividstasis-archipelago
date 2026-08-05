if (!no_fail)
{
    if (gauge <= 0)
    {
        instance_create_depth(0, 0, -10000, o_lifedepleted_tint);
        
        if (!global.paused)
        {
            audio_pause_all();
            play_se(sfx_failsong);
            ap_send_deathlink("<player> couldn't keep up");
            
            
            if (global.decrypt_mode.bossfx && global.song_id_last == 132)
                unlock_profile_title("libertiafail");
            
            unlock_achievement("game_challengefail");
            global.paused = true;
            global.temporary_boss_gauge = false;
            
            if (global.course_mode)
                global.current_course_state = 1;
            
            cc.mod_video = -1;
            instance_create_depth(160, 90, -10000, o_lifedepleted);
            gauge = 0;
        }
    }
}

if (global.is_apocalypse_course)
{
    loss_amt = global.ac_loss;
    gain_amt = 0;
}

if (variable_global_exists("is_horizon_course"))
{
    if (global.is_horizon_course)
        gain_amt = 0;
}

global.gauge_hp = gauge;
