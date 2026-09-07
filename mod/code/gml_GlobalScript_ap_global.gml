// one slot per player, although technically it can be a type == group? idk what that is
function APSlot(_id, _name, _game) constructor {
	id = _id // int, this is also known as 'slot' in the packets
	name = _name // string, player name
	game = _game // APGameData
	status = 0

	static get_item = function(id) {
		var _item_name = struct_get(game.item_names, id);
		if(is_undefined(_item_name)) {
			show_error(string(id) + " is not a valid archipelago item for " + name, true);
		}
		return new APItem(int64(id), self, _item_name);
	}

	static all_collected_items = function() {
		var _items = [];
		var _keys = variable_struct_get_names(game.item_names);
		var _size = array_length(_keys);

		for(var i = 0; i < _size; i++) {
			var _key = _keys[i];
			var _item = get_item(_key);
			if(!_item.collected()) {
				continue;
			}
			array_push(_items, _item);
		}

		return _items;
	}

	static has_completed = function() {
		return status == 30;
	}
}

function APLocalSlot(id, name, game) : APSlot(id, name, game) constructor {
	locations = {} // int -> APLocation

	var _keys = variable_struct_get_names(game.location_names);
	var _size = array_length(_keys);
	for (var i = 0; i < _size; ++i) {
		var _key = _keys[i];
		var _value = struct_get(game.location_names, _key);

		struct_set(locations, _key, new APLocation(int64(_key), _value, pointer_null));
	}

	static all_checked_locations = function() {
		var _result = []

		var _keys = variable_struct_get_names(locations);
		var _size = array_length(_keys);

		for (var i = 0; i < _size; ++i) {
			var _key = _keys[i];
			var _value = struct_get(locations, _key);
			if(!_value.is_checked()) {
				continue;
			}
			
			array_push(_result, _value);
		}

		return _result;
	}
}

function APGameData(_name, _package) constructor {
	name = _name
	location_names = {} // int -> string
	item_names = {} // int -> string

	// todo: clean up
	var item_name_to_id = struct_get(_package, "item_name_to_id");
	var _item_names = variable_struct_get_names(item_name_to_id);
	var item_count = array_length(_item_names)
	for(var j = 0; j < item_count; ++j) {
		var item_name = _item_names[j]
		var item_id = struct_get(item_name_to_id, item_name)

		struct_set(item_names, item_id, item_name)
	}

	var loc_name_to_id = struct_get(_package, "location_name_to_id");
	var loc_names = variable_struct_get_names(loc_name_to_id);
	var loc_count = array_length(loc_names)
	for(var j = 0; j < loc_count; ++j) {
		var loc_name = loc_names[j]
		var loc_id = struct_get(loc_name_to_id, loc_name)

		struct_set(location_names, loc_id, loc_name)
	}
}

function APLocation(_id, _name, _item) constructor {
	id = _id // int
	name = _name // string
	item = _item // APItem | pointer_null (if not scouted)

	static is_checked = function() {
		ini_open(global.profile_file);
		var _result = ini_read_real("ap", "loc_" + string(id), false);
		ini_close();
		return _result;
	}
}

function APItem(_id, _player, _name) constructor {
	id = _id // int
	name = _name // string
	player = _player // APSlot

	ini_key = "item_" + string(id);

	// e.g bongo's Song - SELF, bongo's Temple Key
	static full_name = function() {
		return string_ext("{0}'s {1}", [player.name, name])
	}

	static full_name_formatted = function() {
		return string_ext("`c{tsuki}{0}`r's `c{dawn}{1}`r", [player.name, name])
	}

	// returns a real, for most items a value of 1 just means collected, 
	// but for items which can be collected multiple times (e.g filler), this will return the number collected
	static collected = function() {
		if(player != global.ap_self) {
			global.ap_logger.error("collected() was called on {0}", full_name());
			return false;
		}

		ini_open(global.profile_file);
		var _result = ini_read_real("ap", ini_key, false);
		ini_close();
		return _result;
	}

	static _on_recieved = function(_file_already_open = false) {
		if(player != global.ap_self) {
			global.ap_logger.error("_on_recieved() was called on {0}", full_name());
			return false;
		}

		global.ap_logger.debug("recieved {0}", name);

		ini_open(global.profile_file);
		ini_write_real("ap", ini_key, ini_read_real("ap", ini_key, 0) + 1);
		ini_close();
	}

	static _abandon = function() {
		ini_open(global.profile_file);
		ini_key_delete("ap", ini_key);
		ini_close();
	}
}

function APConsoleLogger() constructor {
	static create_log = function(_level) {
		var _bwa = { level: _level }
		return method(_bwa, function(_format) {
			var _args = array_create(argument_count - 1);
			for (var i = 1; i < argument_count; i++) {
				_args[i - 1] = argument[i];
			}

			show_debug_message("ap " + self.level + ": " + string_ext(_format, _args));
		})
	}

	static debug = create_log("debug");
	static info = create_log("info");
	static warn = create_log("warn");
	static error = create_log("error");
}

function APConnectionSettings(_address, _port, _name, _password) constructor {
	address = _address
	port = _port
	name = _name
	password = _password
	
	static is_secure = function() {
		if(address == "localhost" || address == "127.0.0.1") {
			return false;
		}
		return true;
	}

	static to_ap_command = function() {
		return {
			cmd: "Connect",
			password: password,
			game: "vivid/stasis",
			name: name,
			uuid: int64(69420),
			items_handling: int64(4 + 2 + 1), // 0b111, https://github.com/ArchipelagoMW/Archipelago/blob/main/docs/network%20protocol.md#items_handling-flags
			tags: [],
			version: { // archipelago version
				class: "Version",
				major: int64(0),
				minor: int64(5),
				build : int64(1)
			},
			slot_data: true
		}
	}
}

function APConnection(_socket, _conn_settings) constructor {
	connection_settings = _conn_settings;
	queue = [];
	is_connected = false;
	socket = _socket;

	static send = function(command) {
		if(global.ap_netlogger != pointer_null) {
			global.ap_netlogger.log_sent(command);
		}
		if(!is_connected) {
			global.ap_logger.debug("queued command: " + command.cmd);
			array_push(queue, command);
			return;
		}

		global.ap_logger.debug("sending command: " + command.cmd);
		_send_arr([command])
	}

	// todo: this will be used for reconnect logic as well
	static _send_connect = function() {
		send(connection_settings.to_ap_command());
	}

	static _set_connected = function() {
		is_connected = true;
		global.ap_logger.debug("connection established, sending out queue");
		_send_arr(queue);
		queue = [];
	}

	static _send_arr = function(arr) {
		aa = json_stringify(arr)

		buffer = buffer_create(string_byte_length(aa), buffer_fixed,1)
		buffer_seek(buffer, buffer_seek_start, 0)
		buffer_write(buffer,buffer_text,aa)

		network_send_raw(socket, buffer, buffer_tell(buffer), 2)
	}
}

function APRoom(_seed_name, _games) constructor {
	seed_name = _seed_name // string
	games = _games // list[str]
}

global._ap_gamedata = {};
global.ap_logger = new APConsoleLogger();
global.ap_netlogger = pointer_null;
global.ap_slots = undefined;
global.ap_self = undefined;
global.ap_room = undefined;
global._ap_socket = undefined;

global.ap_deathlink = {
	enabled: false,
	primed: false
}

// address in most cases is archipelago.gg and uses secure websockets (with exception of localhost/loopback, which uses insecure websockets
// password is usually empty
// returns a async request id
// callback is a function that takes in one argument: results
//  if results.success is true, everything is good!
//  if results.success is false, results.errors will be populated:
//   one or more of the archipelago error codes: "InvalidSlot", "InvalidGame", "IncompatibleVersion", "InvalidPassword", or "InvalidItemsHandling"
//   or "ConnectFailed"
function ap_connect(conn, callback) {
	global.ap_logger.debug("attempting to connect to {0}:{1}", conn.address, conn.port)
	global._ap_connection_callback = callback;

	var socket_id = 0;
	if(conn.is_secure()) {
		socket_id = network_create_socket(network_socket_wss);
	} else {
		socket_id = network_create_socket(network_socket_ws);
	}

	var success = network_connect_raw_async(socket_id, conn.address, conn.port);
	if(success < 0) {
		global.ap_logger.error(string("establishing connection failed! success = {0}", success));
		callback({ success: false, errors: ["ConnectFailed"] });
		return;
	}

	global._ap_socket = new APConnection(socket_id, conn);
}

function ap_disconnect() {
	global.ap_logger.info("disconnecting!");
	if(is_ap_connected()) {
		network_destroy(global._ap_socket.socket);
	}
	global._ap_socket = undefined;
	global._ap_gamedata = {};
	global.ap_room = undefined;
	global.ap_slots = undefined;
	global.ap_self = undefined;
}

function is_ap_connected() {
	return variable_global_exists("_ap_socket") && !is_undefined(global._ap_socket);
}

function ap_sync() {
	global._ap_socket.send({
		cmd: "Sync"
	});

	// resend checked locations. if the seed name is different, the save section will have already been cleared
	var _locations = global.ap_self.all_checked_locations();
	global._ap_socket.send({
		cmd: "LocationChecks",
		locations: _location_ids(_locations)
	})
}

function ap_check(location) {
	ini_open(global.profile_file);
	var _result = ini_read_real("ap", "loc_" + string(location.id), false);
	ini_close();

	global._ap_socket.send({
		cmd: "LocationChecks",
		locations: [int64(location.id)]
	})
	ap_msg_check(location);
}

function _location_ids(locations) { 
	var _size = array_length(locations);
	var _ids = []; // todo: optimise with array_create(_size)
	for(var i = 0; i < _size; i++) {
		var _loc = array_get(locations, i);
		if(is_undefined(_loc)) {
			global.ap_logger.warn("ap_scout was called with an undefined entry. i = {0}", i);
			continue;
		}
		array_push(_ids, int64(_loc.id));
	}
	return _ids;
}

function ap_scout(locations) {
	global._ap_socket.send({
		cmd: "LocationScouts",
		locations: _location_ids(locations)
	});
}

function ap_create_hints(locations) {
	global._ap_socket.send({
		cmd: "CreateHints",
		locations: _location_ids(locations)
	});
}

function ap_goal() {
	global._ap_socket.send({
		cmd: "StatusUpdate",
		status: 30 // 30 is GOAL
	});
	global.ap_self.status = 30;
	ap_msg_goal();
}