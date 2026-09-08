TextDrawerColors = {
    "red": 255,
    "white": 16777215,
    "aqua": 16776960,
    "think": 16764160,
    "black": 0,
    "dawn": 16724071,
    "wkeeper": 11960319,
    "sat": 15564799,
    "alli": 8978303,
    "tsuki": 11960319,
    "setsuki": 5898192,
    "kisho": 10073599,
    "chiyo": 39423,
    "kot": 16749568,
    "eri": 16744353,
    "miri": 5197823
}

for key, value in TextDrawerColors.items():
	bgr_hex_code = f"{value:06X}"
	rgb_hex_code = bgr_hex_code[4:6] + bgr_hex_code[2:4] + bgr_hex_code[0:2]
	print(f"{key} = #{rgb_hex_code}")