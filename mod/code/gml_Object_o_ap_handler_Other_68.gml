if(!variable_global_exists("_ap_socket")) {
	exit;
}

var socket_id = ds_map_find_value(async_load, "id");
if (socket_id != global._ap_socket.socket) {
	global._ap_socket.debug(string("ignoring network event, socket_id = {0}, _ap_socket.socket = {1}", socket_id, global._ap_socket.socket))
	exit;
}

var type = ds_map_find_value(async_load, "type")
if(type == network_type_non_blocking_connect) {
	var success = ds_map_find_value(async_load, "succeeded")

	if(success <= 0) {
		global.ap_logger.error("failed to connect! success = " + string(success));
		global._ap_connection_callback({
			success: false,
			errors: ["ConnectFailed"]
		});
		ap_disconnect();
	}

	exit;
}

var buffer = ds_map_find_value(async_load, "buffer");
var size = ds_map_find_value(async_load, "size");
buffer_seek(buffer, buffer_seek_start, 0);
var response = buffer_read(buffer, buffer_string);

var data = json_parse(response);

for (var i = 0; i < array_length(data); ++i) {
	var packet = data[i];

	if(!struct_exists(packet, "cmd")) {
		global.ap_logger.error("object in array doesn't have 'cmd'!");
		continue;
	}

	if(global.ap_netlogger != pointer_null) {
		global.ap_netlogger.log_recieved(packet);
	}

	global.ap_logger.debug("handling command: {0}", packet.cmd);

	switch(packet.cmd) {
		case "Connected":
			global.ap_logger.debug(string(packet));
			global.ap_slots = {}
			struct_foreach(packet.slot_info, method({p: packet}, function(key, value) {
				global.ap_logger.debug("{0} is {1}", key, value);
				if(key == self.p.slot) {
					struct_set(global.ap_slots, key, new APLocalSlot(key, value.name, struct_get(global._ap_gamedata, value.game)));
				} else {
					struct_set(global.ap_slots, key, new APSlot(key, value.name, struct_get(global._ap_gamedata, value.game)));
				}
			}));
			global.ap_self = struct_get(global.ap_slots, packet.slot);
			global.ap_logger.debug(string(global.ap_self));
			
			global._ap_connection_callback({
				success: true
			});
		break;
		case "ConnectionRefused":
			global.ap_logger.error("Connection refused: " + string_join_ext(", ", packet.errors));
			global._ap_connection_callback({
				success: false,
				errors: packet.errors
			});
			ap_disconnect();
		break;
		case "RoomInfo":
			global.ap_room = new APRoom(packet.seed_name, packet.games);
			
			// todo: data package caching
			global._ap_socket.send({
				cmd: "GetDataPackage",
				games: packet.games
			})

			global._ap_socket._set_connected();
		break;
		case "DataPackage":
			var _keys = variable_struct_get_names(packet.data.games);
			var _size = array_length(_keys);

			for (var i = 0; i < _size; ++i) {
				var _key = _keys[i];
				var _value = struct_get(packet.data.games, _key);
			
				struct_set(global._ap_gamedata, _key, new APGameData(_key, _value));
			}

			global._ap_socket._send_connect(); // finally we can ask to connect, now that we have the data package.
		break;
		case "ReceivedItems":
			var _cur_index = packet.index;
			var _collected_items = global.ap_self.all_collected_items();

			var _items_to_add = [];
			if(_cur_index == 0) { // this is the worst fucking behaviour i have ever seen.
				var _size = array_length(packet.items);
				var _item_counts = {};
				for(var i = 0; i < _size; i++) {
					var _value = packet.items[i];
					var _item = global.ap_self.get_item(_value.item);
					var _current_count = 0;
					if(struct_exists(_item_counts, _item.name)) {
						_current_count = struct_get(_item_counts, _item.name);
					}
					_current_count++;
					struct_set(_item_counts, _item.name, _current_count);
					if(_current_count > _item.collected()) {
						array_push(_items_to_add, _value);
					}
				}
			} else if(array_length(_collected_items) != _cur_index) {
				global.ap_logger.error("DESYNC!! our items = {0}, archipealgo.index = {1}, triggering an ap_sync()", array_length(_collected_items), _cur_index);
				ap_sync();
				return;
			} else {
				_items_to_add = packet.items;
			}

			array_foreach(_items_to_add, function(item) {
				global.ap_logger.debug("RecievedItems.item = {0}", item);
				var _item = global.ap_self.get_item(item.item);
				_item._on_recieved();
				ap_msg_recieved(item.player, _item);
			});

			var current_room_name = room_get_name(room);
			global.ap_logger.debug("recieved items. current_room = {0}", current_room_name);
			if(array_contains(["scene_results_2023"], current_room_name)) {
				ap_run_through_queue();
			}
		break;
		case "LocationInfo": // todo: this should be cached as well
			array_foreach(packet.locations, function(loc) {
				var _slot = struct_get(global.ap_slots, loc.player);
				var _item = _slot.get_item(loc.item);
				
				var _location = struct_get(global.ap_self.locations, loc.location);
				_location.item = _item;
				global.ap_logger.debug("{0} is at {1}", _item.full_name(), _location.name);
			});
		break;
		case "Bounced":
			if(!struct_exists(packet, "tags")) {
				return;
			}
			if(array_contains(packet.tags, "DeathLink") && packet.data.source != global.ap_self.name && instance_exists(o_challengeguage)) {
				global.ap_deathlink.primed = false;
				o_challengeguage.gauge = 0;
				ap_msg_deathlink(packet.data.cause);
			}
		break;
		default:
			global.ap_logger.debug("unknown command: {0}", packet.cmd);
		break;
	}
}