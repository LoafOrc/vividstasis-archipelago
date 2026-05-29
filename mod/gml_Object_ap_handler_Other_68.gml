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
			// global.ap_deathlink = packet.slot_data.death_link
			ap_debug("Connection success!")
			ap_debug("deathlink? " + string(global.ap_deathlink), "debug")
			global._ap_connection_callback({
				success: true
			})
			
			
		break;
		case "ConnectionRefused":
			ap_debug("Connection failed: " + string_join_ext(", ", packet.errors))
			global._ap_connection_callback({
				success: false,
				errors: packet.errors
			})
			
			// this should be handled more gracefully as archipelago lets you retry Connect commands
			ap_disconnect()
		break;
		case "RoomInfo":
			// global._ap_roominfo_callback();
		break;
		case "ReceivedItems":
			array_foreach(packet.items, function(item) {
				ini_open(global.profile_file)
				ini_write_real("ap", "item_" + string(item.item), true)
			})
		break;
		default:
			ap_debug("unknown command: " + packet.cmd, "warn");
	}
}