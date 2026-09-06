function APCheckMessage(_location) constructor {
	location = _location;

	static get_message = function() {
		return string("Sent {0} (`{chiyo}{1}`r)", location.item.full_name_formatted(), location.name);
	}
}

function APRecievedMessage(_sender, _item) constructor {
	sender = _sender
	item = _item

	static get_message = function() {
		var _player = struct_get(global.ap_slots, sender);
		if(sender == 0) {
			_player = {
				name: "`c{alli}Archipelago"
			};
		}

		// last failsafe
		if(is_undefined(_player)) {
			_player = {
				name: "`c{red}undefined"
			};
			global.ap_logger.error("recieved message but sender was null. sender = {0}", sender);
		}

		if(_player == global.ap_self) {
			return string("Collected `c{dawn}{0}", item.name);
		}
		return string("`c{dawn}{0}`r from `c{chiyo}{1}", item.name, _player.name);
	}
}

function APDeathlinkMessage(_reason) constructor {
	reason = _reason;

	static get_message = function() {
		return "`c{red}" + _reason;
	}
}

global.ap_msg_queue = [];
global.ap_doing_queue = false;

function ap_msg_check(location) {
	if(location.item == pointer_null) {
		return;
	}
	if(location.item.player == global.ap_self) {
		return; // is part of the APRecievedMessage
	}

	array_insert(global.ap_msg_queue, 0, new APCheckMessage(location));
}

function ap_msg_recieved(sender, item) {
	array_push(global.ap_msg_queue, new APRecievedMessage(sender, item));
}

function ap_msg_deathlink(reason) {
	array_insert(global.ap_msg_queue, 0, new APDeathlinkMessage(reason));
}

function ap_run_through_queue() {
	if(array_length(global.ap_msg_queue) == 0 || global.ap_doing_queue) {
		return;
	}

	return (function() {
        __CoroutineBegin(function()
        {
			global.skip = false;
            global.story_paused = false;
			global.ap_doing_queue = true;
        });
		__CoroutineDelay(function()
        {
            return 500;
        });
		__CoroutineThen(function() {
			instance_create_depth(0, 180, -100, o_textbox);
            
            with (o_textbox)
                TweenEasyMove(0, 180, 0, 132, 0, 60, EaseOutExpo);
            
            name_set("");
		});
		__CoroutineWhile(function() {
			return array_length(global.ap_msg_queue) != 0;
		});
        __CoroutineThen(function()
        {
			var _msg = array_shift(global.ap_msg_queue).get_message();
            global.ap_logger.debug("showing queued message: {0}", _msg);
			text(_msg);
        });
        __CoroutineAwait(check_textbox_done);
        __CoroutineThen(function()
        {
        });
        __CoroutineEndLoop(function()
        {
        });
		__CoroutineAwait(check_textbox_done);
        __CoroutineThen(function()
        {
			text_clear();
            
            with (o_textbox)
                TweenEasyMove(0, 132, 0, 180, 0, global.gamefps, EaseOutExpo);

			global.ap_doing_queue = false;
        });
        return __CoroutineEnd();
    })();
    return (function()
    {
        __CoroutineBegin(function()
        {
            global.skip = false;
            global.story_paused = false;
        });
        __CoroutineDelay(function()
        {
            return 500;
        });
        __CoroutineThen(function()
        {
            instance_create_depth(0, 180, -100, o_textbox);
            
            with (o_textbox)
                TweenEasyMove(0, 180, 0, 132, 0, 60, EaseOutExpo);
            
            name_set("");
            text("Collected " + global.ap_last_scoutinfo.name);
        });
        __CoroutineAwait(check_textbox_done);
        __CoroutineThen(function()
        {
            text_clear();
            
            with (o_textbox)
                TweenEasyMove(0, 132, 0, 180, 0, global.gamefps, EaseOutExpo);
        });
        return __CoroutineEnd();
    })();
}