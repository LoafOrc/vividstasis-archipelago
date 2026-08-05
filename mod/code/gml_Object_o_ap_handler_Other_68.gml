var type = ds_map_find_value(async_load, "type")
if(type == network_type_non_blocking_connect) {
	var success = ds_map_find_value(async_load, "succeeded")

	if(success > 0) {
		ap_debug("connection established!")
		global.ap_connected = true
		_ap_send_arr(global.ap_message_preconnect_queue)
		global.ap_message_preconnect_queue = []
	} else {
		ap_debug("failed to connect! success = " + string(success), "error")
		global._ap_connection_callback({
			success: false,
			errors: ["ConnectFailed"]
		})
	}

	exit;
}


function debug_save_json(data, file_name) {
	/*
	var _buffer_size = string_byte_length(json_stringify(data, true)) + 1;
	var _save_buffer = buffer_create(_buffer_size, buffer_fixed, 1);

	buffer_write(_save_buffer, buffer_string, json_stringify(data, true));

	buffer_save(_save_buffer, file_name + ".json");

	buffer_delete(_save_buffer);
	*/
}

var socket_id = ds_map_find_value(async_load, "id");
if (socket_id != global.ap_socket) {
	exit;
}

var buffer = ds_map_find_value(async_load, "buffer");
var size = ds_map_find_value(async_load, "size");
buffer_seek(buffer, buffer_seek_start, 0);
var response = buffer_read(buffer, buffer_string);
ap_debug("data from server: " + response, "debug")

var data = json_parse(response)

for (var i = 0; i < array_length(data); ++i) {
	var packet = data[i];

	if(!struct_exists(packet, "cmd")) {
		ap_debug("object in array doesn't have 'cmd'!", "warn")
		continue
	}

	// i'd much rather have some sort of map structure that conatins cmd -> callback
	switch(packet.cmd) {
		case "Connected":
			global.ap_self = packet.slot_data
			global.ap_slot = packet.slot
			global.ap_deathlink = packet.slot_data.death_link
			
			ini_open(global.profile_file)
			var last_seed_name = ini_read_string("ap", "last_seed_name", "");
			ap_debug("last_seed_name: " + last_seed_name, "debug")
            if(last_seed_name != global.ap_roominfo.seed_name) {
                 ap_debug("seed name doesn't match! clearing local ap save info and resyncing")
                 ini_section_delete("ap");
                 _ap_send({
                     cmd: "Sync"
                 });
                 global.ap_location_checks = packet.checked_locations;
            }
            ini_write_string("ap", "last_seed_name", global.ap_roominfo.seed_name);
			
			ap_debug("Connection success!")
			ap_debug("deathlink? " + string(global.ap_deathlink), "debug")
			global.ap_slotinfo = packet.slot_info
			debug_save_json(global.ap_slotinfo, "ap_slotinfo")
			global._ap_connection_callback({
				success: true
			})
			if(global.ap_deathlink) {
			    ap_debug("adding deathlink tag", "debug")
				_ap_send({
					cmd: "ConnectUpdate",
					tags: ["DeathLink"]
				})
			}
		break;
		case "ConnectionRefused":
			ap_debug("Connection refused: " + string_join_ext(", ", packet.errors))
			global._ap_connection_callback({
				success: false,
				errors: packet.errors
			})
			
			// this should be handled more gracefully as archipelago lets you retry Connect commands
			ap_disconnect()
		break;
		case "RoomInfo":
			// global._ap_roominfo_callback();
			global.ap_roominfo = packet;
			
			global._ap_send({
				cmd: "GetDataPackage",
				games: packet.games
			})
		break;
		case "ReceivedItems":
			array_foreach(packet.items, function(item) {
			    ap_debug("recieved item: " + string(item.item), "debug")
				ini_open(global.profile_file)
				ini_write_real("ap", "item_" + string(item.item), true)
				ini_close()
			})
		break;
		case "LocationInfo":
			debug_save_json(packet, "locationinfo")
			array_foreach(packet.locations, function(loc) {
				var _slot_info = struct_get(global.ap_slotinfo, string(loc.player))
				var _item_name = struct_get(struct_get(global.ap_gamedata, _slot_info.game).item_id_to_name, string(loc.item))
				var scout = {
					item_id: loc.item,
					player: loc.player,
					name: _slot_info.name + "'s " + _item_name
				}
				struct_set(global.ap_location_scouts, string(loc.location), scout)
				ap_debug("got scout info for: " + string(loc.player) + " " + string(loc.item) + " " + string(loc.location) + " " + scout.name, "debug")
				debug_save_json(scout, "locationinfo_" + string(loc.location))
			})
			
		break;
		case "DataPackage":
			var _keys = variable_struct_get_names(packet.data.games);
			var _size = array_length(_keys);

			for (var i = 0; i < _size; ++i) {
				var _key = _keys[i];
				var _value = struct_get(packet.data.games, _key);
				var gamedata = {
					item_id_to_name: { }
				}
				
				
				ap_debug("Game: " + _key + "");
				var item_name_to_id = struct_get(_value, "item_name_to_id");
				var item_names = variable_struct_get_names(item_name_to_id);
				var item_count = array_length(item_names)
				for(var j = 0; j < item_count; ++j) {
					var item_name = item_names[j]
					var item_id = struct_get(item_name_to_id, item_name)
					ap_debug(string(item_id) + " = " + item_name);
					struct_set(gamedata.item_id_to_name, string(item_id), item_name)
				}

				struct_set(global.ap_gamedata, _key, gamedata)
			}

			debug_save_json(global.ap_gamedata, "ap_gamedata")
			ap_debug("data package")
		break;
		case "Bounced":
			var _player_name = struct_get(global.ap_slotinfo, string(global.ap_slot)).name
			if(array_contains(packet.tags, "DeathLink") && packet.data.source != _player_name && instance_exists(o_challengegauge)) {
				global.ap_deathlink_primed = false
				o_challengegauge.gauge = 0;
			}
		break;
		default:
			ap_debug("unknown command: " + json_stringify(packet), "warn");
			debug_save_json(packet, "unknown_" + packet.cmd)
	}
}