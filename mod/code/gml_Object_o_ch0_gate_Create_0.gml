event_inherited();
image_speed = 0;
unlock_animation = 0;
unlocked = false;
ini_open(global.profile_file);

// todo: move to the json file so it can stay in sync with the .apworld better
gate_ap_id = struct_get({
	archives: 2001,
	temple: 2002,
	grotto: 2003,
	final: 2004
}, gate_name);

if(!variable_global_exists("ap_self")) {
	exit; // uh oh
}

var _item = global.ap_self.get_item(gate_ap_id);

if (_item.collected()) {
    instance_destroy(self);
}

true_req = gate_req;

function interact()
{
	play_se(buzzer);
}

enum UnknownEnum
{
    Value_0,
    Value_1,
    Value_2
}
