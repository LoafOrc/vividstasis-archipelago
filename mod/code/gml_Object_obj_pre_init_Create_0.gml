debug("Pre-Init");
gpu_set_tex_filter(false);
prof_exists = file_exists("profile");
window_set_caption("vivid/stasis");
global.profile_file = "profile";
global.highscore_file = "highscore_table";
define_options();
update_window_size();
window_set_fullscreen(global.op_fullscreen);
alarm[0] = 1;
global.ap_attemptconnect = false;
// AP MOD START
ini_open(global.profile_file);
global.aphost = ini_read_string("apglobal", "aphost", "archipelago.gg");
global.apport = ini_read_string("apglobal", "apport", "");
global.apname = ini_read_string("apglobal", "apname", "");
global.appass = ini_read_string("apglobal", "appass", "");
ini_close();
// AP MOD END