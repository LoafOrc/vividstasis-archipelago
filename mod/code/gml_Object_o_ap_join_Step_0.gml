var fields = ["address", "port", "name", "password"];

if (keyboard_check_pressed(vk_escape))
{
    audio_stop_all();
    play_se(sfx_songsel_beginsong);
    
	transition_to(scene_options);
}

selected = clamp(selected, 1, array_length(fields));
var move = keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up);

if (move != 0)
{
    selected = clamp(selected + move, 1, array_length(fields));
    keyboard_string = string(variable_instance_get(settings, fields[selected - 1]));
}

if (keyboard_check_pressed(vk_anykey) && move == 0) && (!keyboard_check_pressed(vk_enter)) && (!keyboard_check_pressed(vk_escape))
    variable_instance_set(settings, fields[selected - 1], keyboard_string);

if (keyboard_check_pressed(vk_enter))
{
    audio_stop_all();
    
    if (is_ap_connected()) {
        ap_disconnect();
        play_se(sfx_solve_puzzle);
		transition_to(scene_init);
    } else {
		if (settings.port == "")
            settings.port = 0;
		settings.port = int64(settings.port);
		
		ap_connect(settings, method(self, function(result) {
			if(result.success) {
				self.transition_to(scene_init);
			} else {
				self.result = "Failed to connect! Reason: " + string_join_ext(", ", result.errors);
			}

			o_ap_handler.connection_callback(result);
		}));
    }
    
    
}
