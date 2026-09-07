function load_json_from_file(_filename) {
    var _buffer = buffer_load(_filename);

    var _json_string = buffer_read(_buffer, buffer_string);
    buffer_delete(_buffer);
    return json_parse(_json_string)
}
global.ap_data = load_json_from_file("ap.json");
global.ap_bsdata = load_json_from_file("ap_bs_flat.json");

function connection_callback(result) {
	global.ap_logger.debug("connection callback, success = {0}", result.success);
	if(result.success == false) {
		play_se(buzzer);
		return;
	}

	ini_open(global.profile_file);
	if(global.ap_room.seed_name != ini_read_string("ap", "last_seed_name", global.ap_room.seed_name)) {
		global.ap_logger.info("seed name doesn't match, clearing local save info and resyncing");
		ini_section_delete("ap");
		ini_close();
		ap_sync();
	}
	ini_open(global.profile_file);
	ini_write_string("ap", "last_seed_name", global.ap_room.seed_name);
	ini_close();

	var _locations_to_scout = [];
	for (var i = 0; i < array_length(global.song_list); i++) {
		var _song = global.song_list[i];
		var _ap_data = struct_get(global.ap_data, _song.chart_id);

		if(is_undefined(_ap_data)) {
			global.ap_logger.warn("no ap data for song: {0}", _song.chart_id);
			continue;
		}

		_song.ap = { }
		if(_song.chart_id != "plaudite") {
			_song.ap.rank_clear_loc = struct_get(global.ap_self.locations, _ap_data.ss_rank_location_id);
			global.ap_logger.debug("{0} -> {1} ({2})", _song.chart_id, _song.ap.rank_clear_loc, _ap_data.ss_rank_location_id);
			array_push(_locations_to_scout, _song.ap.rank_clear_loc);
		}

		if(struct_exists(_ap_data, "song_item_id")) {
			_song.ap.item = global.ap_self.get_item(_ap_data.song_item_id);
			_song.unlock = { // todo: i'd like this to be a function instead so it can use APItem.collected()
				type: 1,
				section: "ap",
				key: "item_" + string(_ap_data.song_item_id),
				hint: "Unlock from Archipelago",
				per_difficulty: false,
				hidden: false,
				enc_type: 0,
				enc_hint: "Unlock from Archipelago"
			};
		}
	}

	ap_scout(_locations_to_scout);
}

if(global.ap_debug.use_debug_conn) {
	ap_connect(global.ap_debug.conn_settings, connection_callback);
}

if(global.ap_debug.show_console) {
	global.ap_logger.debug("console is enabled");
	show_debug_log(true);
}

if(global.ap_debug.enable_netlogger) {
	global.ap_netlogger = new APDebugNetworkLogger();
}