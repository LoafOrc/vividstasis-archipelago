#macro CO_BEGIN                ((function(){__CoroutineBegin(function(){
#macro CO_ON_COMPLETE          });__CoroutineOnComplete(function(){
#macro CO_END                  });return __CoroutineEnd();})());
#macro CO_PARAMS               global.__coroutineNext
#macro CO_SCOPE                global.__coroutineScope
#macro CO_LOCAL                global.__coroutineRootStruct
#macro THEN                    });__CoroutineThen(function(){
#macro YIELD                   });__CoroutineEscape(__COROUTINE_ESCAPE_STATE.__YIELD,function(){return 
#macro PAUSE                   });__CoroutineEscape(__COROUTINE_ESCAPE_STATE.__PAUSE,function(){return 
#macro RETURN                  });__CoroutineEscape(__COROUTINE_ESCAPE_STATE.__RETURN,function(){return 
#macro RESTART                 });__CoroutineEscape(__COROUTINE_ESCAPE_STATE.__RESTART,undefined);__CoroutineThen(function(){
#macro BREAK                   });__CoroutineBreak(function(){
#macro CONTINUE                });__CoroutineContinue(function(){
#macro REPEAT                  });__CoroutineRepeat(function(){return 
#macro WHILE                   });__CoroutineWhile(function(){return 
#macro FOREACH                 });__CoroutineForEach(function(_value){
#macro IN                      =_value;});__CoroutineForEachIn(function(){return 
#macro END                     });__CoroutineEndLoop(function(){
#macro IF                      });__CoroutineIf(function(){return 
#macro ELSE                    });__CoroutineElse(function(){
#macro ELSE_IF                 });__CoroutineElseIf(function(){return 
#macro END_IF                  });__CoroutineEndIf(function(){
#macro AWAIT                   });__CoroutineAwait(function(){return 
#macro DELAY                   });__CoroutineDelay(function(){return 
#macro AWAIT_BROADCAST         });__CoroutineAwaitBroadcast(function(){return 
#macro AWAIT_FIRST             });__CoroutineAwaitFirst(function(){
#macro AWAIT_ALL               });__CoroutineAwaitAll(function(){
#macro AWAIT_ASYNC_HTTP        });__CoroutineAwaitAsync("http",function(){
#macro AWAIT_ASYNC_NETWORKING  });__CoroutineAwaitAsync("networking",function(){
#macro AWAIT_ASYNC_SOCIAL      });__CoroutineAwaitAsync("social",function(){
#macro AWAIT_ASYNC_SAVE_LOAD   });__CoroutineAwaitAsync("save_load",function(){
#macro AWAIT_ASYNC_DIALOG      });__CoroutineAwaitAsync("dialog",function(){
#macro AWAIT_ASYNC_SYSTEM      });__CoroutineAwaitAsync("system",function(){
#macro AWAIT_ASYNC_STEAM       });__CoroutineAwaitAsync("steam",function(){
#macro AWAIT_ASYNC_BROADCAST   });__CoroutineAwaitAsync("broadcast",function(){
#macro ASYNC_TIMEOUT           });__CoroutineAsyncTimeout(function(){return 
#macro ASYNC_COMPLETE          return true;

#macro AWAIT_CHECKBOX          });__CoroutineAwait(check_textbox_done);__CoroutineThen(function(){

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
	var current_room_name = room_get_name(room);
	global.ap_logger.debug("trying to run through queue, current_room = {0}", current_room_name);
	if(!array_contains(["scene_results_2023", "scene_songselect_old", "scene_mainmenu"], current_room_name) && !string_starts_with(current_room_name, "rpg_")) {
		return;
	}

	return CO_BEGIN
		global.skip = false;
		global.story_paused = false;
		global.canInteract = false;
		global.ap_doing_queue = true;
		instance_create_depth(0, 180, -100, o_textbox);
		
		with (o_textbox)
			TweenEasyMove(0, 180, 0, 132, 0, 60, EaseOutExpo);
		
		name_set("");

		WHILE array_length(global.ap_msg_queue) != 0 THEN
			var _msg = array_shift(global.ap_msg_queue).get_message();
            global.ap_logger.debug("showing queued message: {0}", _msg);
			text(_msg);
			AWAIT_CHECKBOX
		END
		AWAIT_CHECKBOX

		text_clear();
            
		with (o_textbox)
			TweenEasyMove(0, 132, 0, 180, 0, global.gamefps, EaseOutExpo);

		global.ap_doing_queue = false;
		global.canInteract = true;
	CO_END
}