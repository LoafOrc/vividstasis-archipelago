i = 0;
image_speed = 0;
image_index = 1;
backing_obj = 0;
distance = 2;
is_sel = false;
width = 150;
height = 25;
force = global.op_access_unlockallmodes;
unlocked = true;

if (variable_instance_exists(self, "unlock_check"))
{
    unlocked = get_story_progress() >= unlock_check;
    
    // AP MOD START
    // todo: this is not good
    if (unlock_check == 100)
    {
        ini_open(global.profile_file);
        unlocked = ini_read_real("ap", "item_2000", false);
        ini_close();
    }
    // AP MOD END
    
    if (!unlocked)
        unlocked = global.op_access_unlockallmodes;
}

obfuscate = false;
uTime = shader_get_uniform(shader_marenol_main, "time");
uSTime = shader_get_uniform(shader_marenol_main, "stime");
uGlitchAmp = shader_get_uniform(shader_marenol_main, "glitchAmp");
uTwist1 = shader_get_uniform(shader_marenol_main, "twist1");
uTwist2 = shader_get_uniform(shader_marenol_main, "twist2");
uTwist3 = shader_get_uniform(shader_marenol_main, "twist3");
uTwist4 = shader_get_uniform(shader_marenol_main, "twist4");
uMove = shader_get_uniform(shader_marenol_main, "move");
uSinm = shader_get_uniform(shader_marenol_main, "sinm");
uCosm = shader_get_uniform(shader_marenol_main, "cosm");
uTanm = shader_get_uniform(shader_marenol_main, "tanm");
uFish = shader_get_uniform(shader_marenol_main, "fish");
noisesampler = shader_get_sampler_index(shader_marenol_main, "samplerRandom");
noisetex = sprite_get_texture(sp_noise2, 0);
randstring = [];
randstringoffx = [];
randstringoffy = [];

randomize_string = function()
{
    var nstr = base64_encode(string(irandom_range(1000, 99999)));
    nstr = string_replace_all(nstr, "=", "");
    randstring = [];
    randstringoffx = [];
    randstringoffy = [];
    
    for (var i = 0; i < string_length(nstr); i++)
    {
        array_push(randstring, string_copy(nstr, i + 1, 1));
        array_push(randstringoffx, irandom_range(-2, 2));
        array_push(randstringoffy, irandom_range(-2, 2));
    }
    
    alarm[1] = 30;
};

randomize_string();
