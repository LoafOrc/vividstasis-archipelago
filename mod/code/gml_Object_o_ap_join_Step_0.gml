var fields = ["host", "port", "name", "pass"];

if (keyboard_check_pressed(vk_escape))
{
    audio_stop_all();
    play_se(sfx_songsel_beginsong);
    
    with (instance_create_depth(160, 90, -1000, o_transition_diamond))
    {
        TweenEasyFade(0, 1, 0, 60, EaseOutQuint);
        TweenEasyRotate(-45, 315, 0, 60, EaseOutExpo);
        TweenEasyScale(1, 1, 320, 180, 0, 60, EaseOutQuad);
        color = 16777215;
        next_room = scene_options;
        alarm[0] = 60;
    }
}

selected = clamp(selected, 1, array_length(fields));
var move = keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up);

if (move != 0)
{
    selected = clamp(selected + move, 1, array_length(fields));
    keyboard_string = string(variable_instance_get(id, fields[selected - 1]));
}

if (keyboard_check_pressed(vk_anykey) && move == 0) && (!keyboard_check_pressed(vk_enter)) && (!keyboard_check_pressed(vk_escape))
    variable_instance_set(id, fields[selected - 1], keyboard_string);

if (keyboard_check_pressed(vk_enter))
{
    audio_stop_all();
    
    if (global.ap_connected)
    {
        ap_disconnect();
        play_se(sfx_solve_puzzle);
    }
    else
    {
        if (host == "")
            host = "None";
        
        if (port == "")
            port = 0;
        
        if (name == "")
            name = "None";
        
        global.aphost = host;
        global.apport = port;
        global.apname = name;
        global.appass = pass;
        global.ap_attemptconnect = true;
    }
    
    instance_destroy(o_ap_handler);
    room_goto(scene_init);
}
