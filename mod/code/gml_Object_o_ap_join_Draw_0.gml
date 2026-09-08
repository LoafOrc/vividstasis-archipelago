draw_set_color(c_white);
draw_set_font(global.default_font);
draw_set_alpha(1);
draw_set_halign(fa_left);

if (selected == 1)
    draw_set_color(c_red);

draw_text_o(10, 10, "Host:" + settings.address);
draw_set_color(c_white);

if (selected == 2)
    draw_set_color(c_red);

draw_text_o(10, 20, "Port:" + string(settings.port));
draw_set_color(c_white);

if (selected == 3)
    draw_set_color(c_red);

draw_text_o(10, 30, "Name:" + settings.name);
draw_set_color(c_white);

if (selected == 4)
    draw_set_color(c_red);

draw_text_o(10, 40, "Password:" + string_repeat("*", string_length(settings.password)));
draw_set_color(c_white);
draw_text_o(10, 60, result);
