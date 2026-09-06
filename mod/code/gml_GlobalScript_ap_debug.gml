function _apdbg_debug_save_json(data, file_name) {
	var _buffer_size = string_byte_length(json_stringify(data, true)) + 1;
	var _save_buffer = buffer_create(_buffer_size, buffer_fixed, 1);

	buffer_write(_save_buffer, buffer_string, json_stringify(data, true));

	buffer_save(_save_buffer, file_name + ".json");

	buffer_delete(_save_buffer);
}

function APDebugNetworkLogger() constructor {
	counter = 0
	static log_sent = function(cmd) {
		_apdbg_debug_save_json(cmd, string("{1}_sent_{0}", cmd.cmd, counter));
		counter += 1;
	}
	static log_recieved = function(cmd) {
		_apdbg_debug_save_json(cmd, string("{1}_recv_{0}", cmd.cmd, counter));
		counter += 1;
	}
}

global.ap_debug = {
	use_debug_conn: false,
	show_console: false,
	enable_netlogger: false,
	conn_settings: new APConnectionSettings("localhost", 38282, "bongo", "")
}

// check for command line flags
var _num = parameter_count();
if (_num > 1) {
    for (var i = 1; i < _num; i++) {
        var _param = parameter_string(i);

        if (_param == "-ap_dev") {
            global.ap_debug.use_debug_conn = true;
			global.ap_debug.show_console = true;
			global.ap_debug.enable_netlogger = true;
        }
		if(_param == "-show_console") {
			global.ap_debug.show_console = true;
		}
		if(_param == "-ap_log_network") {
			global.enable_netlogger = true;
		}
    }
}