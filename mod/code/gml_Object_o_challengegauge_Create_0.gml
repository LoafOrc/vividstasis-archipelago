loss_amt = global.decrypt_mode.loss;
gain_amt = global.decrypt_mode.gain;
gauge = 100;
max_gauge = 100;
no_fail = false;
miss_chain = 0;
global.failed = false;
global.ap_deathlink.primed = true;
image_speed = 0;
if (variable_global_exists("is_horizon_course"))
{
    if (global.is_horizon_course)
    {
        max_gauge = global.current_course.life;
    }
}
if (global.decrypt_mode.name == "HEXIMA")
{
    loss_amt = global.hexima_gauge_specs.failed;
    gain_amt = 0;
    no_fail = false;
    if (global.song_id_last == 201)
    {
        instance_create_depth(115, -999, -360, obj_noteNHHeal).actualms = 50800 + global.op_timing_offset;
        instance_create_depth(115, -999, -360, obj_noteNHHeal).actualms = 89200 + global.op_timing_offset;
        instance_create_depth(115, -999, -360, obj_noteNHHeal).actualms = 126400 + global.op_timing_offset;
    }
    if (global.song_id_last == 203)
    {
        instance_create_depth(115, -999, -360, obj_noteNHHeal).actualms = 37200 + global.op_timing_offset;
        instance_create_depth(115, -999, -360, obj_noteNHHeal).actualms = 75600 + global.op_timing_offset;
        instance_create_depth(115, -999, -360, obj_noteNHHeal).actualms = 123000 + global.op_timing_offset;
    }
    if (global.song_id_last == 202)
    {
        instance_create_depth(115, -999, -360, obj_noteNHHeal).actualms = 50460 + global.op_timing_offset;
        instance_create_depth(115, -999, -360, obj_noteNHHeal).actualms = 110700 + global.op_timing_offset;
        instance_create_depth(115, -999, -360, obj_noteNHHeal).actualms = 147670 + global.op_timing_offset;
    }
    if (global.song_id_last == 204)
    {
        instance_create_depth(115, -999, -360, obj_noteNHHeal).actualms = 53600 + global.op_timing_offset;
        instance_create_depth(115, -999, -360, obj_noteNHHeal).actualms = 100390 + global.op_timing_offset;
        instance_create_depth(115, -999, -360, obj_noteNHHeal).actualms = 153170 + global.op_timing_offset;
    }
}

process_judgement = function(arg0, arg1 = false)
{
    var horiz = false;
    if (variable_global_exists("is_horizon_course"))
    {
        if (global.is_horizon_course)
        {
            horiz = true;
        }
    }
    var gauge_change;
    if (horiz)
    {
        gauge_change = 0;
        switch (arg0)
        {
            case UnknownEnum.Value_1:
                gauge_change = -global.current_course.gauge_amts[0];
                break;
            case UnknownEnum.Value_2:
                gauge_change = -global.current_course.gauge_amts[1];
                break;
            case UnknownEnum.Value_3:
                gauge_change = -global.current_course.gauge_amts[2];
                break;
            case UnknownEnum.Value_4:
                gauge_change = -global.current_course.gauge_amts[3];
                break;
        }
    }
    else if (global.decrypt_mode.name == "HEXIMA")
    {
        gauge_change = 0;
        switch (arg0)
        {
            case UnknownEnum.Value_2:
                gauge_change = -global.hexima_gauge_specs.great;
                break;
            case UnknownEnum.Value_3:
                gauge_change = -global.hexima_gauge_specs.good;
                break;
            case UnknownEnum.Value_4:
                gauge_change = -global.hexima_gauge_specs.failed;
                break;
            case UnknownEnum.Value_5:
                gauge_change = global.hexima_gauge_specs.heal;
                break;
        }
    }
    else
    {
        var gain_mults = [1, 1, 0.7, 0.4];
        gauge_change = 0;
        if (arg0 == UnknownEnum.Value_4)
        {
            miss_multiplier = [1, 0.9, 0.8, 0.7, 0.65, 0.6, 0.55, 0.5, 0.5];
            gauge_change = -(loss_amt * miss_multiplier[clamp(miss_chain, 0, 7)]);
            miss_chain++;
        }
        else
        {
            gauge_change = gain_amt * gain_mults[arg0];
            miss_chain = 0;
        }
        if (variable_global_exists("soundscan_challenge"))
        {
            if (global.soundscan_challenge == UnknownEnum.Value_9)
            {
                if (arg0 != UnknownEnum.Value_0)
                {
                    gauge_change = -loss_amt / 3;
                }
            }
            if (global.soundscan_challenge == UnknownEnum.Value_10)
            {
                if (arg0 == UnknownEnum.Value_4)
                {
                    if (irandom(100) < 27)
                    {
                        gauge_change = -200;
                    }
                }
            }
            if (global.soundscan_challenge == UnknownEnum.Value_2)
            {
                if (gauge_change > 0)
                {
                    gauge_change /= 2;
                }
            }
            if (global.soundscan_challenge == UnknownEnum.Value_5)
            {
                if (gauge_change > 0)
                {
                    gauge_change /= 2;
                }
                if (gauge_change < 0)
                {
                    gauge_change *= 2;
                }
            }
            if (global.soundscan_challenge == UnknownEnum.Value_1)
            {
                if (gauge_change < 0)
                {
                    gauge_change *= 2;
                }
            }
        }
        if (global.soundscan_arcade_vice_level >= 2)
        {
            if (gauge_change < 0)
            {
                gauge_change *= 1.5;
            }
        }
        if (arg1 && !global.is_apocalypse_course)
        {
            gauge_change *= 0.5;
        }
    }
    gauge += gauge_change;
};

enum UnknownEnum
{
    Value_0,
    Value_1,
    Value_2,
    Value_3,
    Value_4,
    Value_5,
    Value_9 = 9,
    Value_10
}
