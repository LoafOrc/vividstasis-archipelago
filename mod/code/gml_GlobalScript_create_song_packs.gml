function create_song_packs(arg0 = -1)
{
    global.song_packs = ["mainstory", "ch1"];
    // AP MOD
    var prog = 34;
    var alp_prog = 17;
    // AP MOD
    if (prog >= 4)
    {
        array_push(global.song_packs, "ch2");
    }
    if (prog >= 10)
    {
        array_push(global.song_packs, "ch3");
    }
    if (prog >= 14)
    {
        array_push(global.song_packs, "ch4");
    }
    if (prog >= 17)
    {
        array_push(global.song_packs, "ch5");
    }
    if (prog >= 24)
    {
        array_push(global.song_packs, "ch6");
    }
    if (prog >= 28)
    {
        array_push(global.song_packs, "ch7");
    }
    if (prog >= 33)
    {
        array_push(global.song_packs, "cha");
    }
    ini_open(global.profile_file);
    sscan = ini_read_real("ssv2", "map11progress", 0);
    ini_close();
    array_push(global.song_packs, "single", "collaboration");
    if (sscan > 0 || global.op_access_unlockallsongs)
    {
        array_push(global.song_packs, "srshowdown");
    }
    var packs = 
    {
        mainstory: 
        {
            name: "Main Story",
            songs: [],
            color1: 16776960,
            color2: 14418175,
            description: "Every song from the main story."
        },
        ch0: 
        {
            name: "Chapter 0",
            songs: [3, 26, 30, 31, 33, 34, 42, 66, 77, 83, 144, 86, 49, 72, 38, 75, 85, 97, 121, 101, 171, 106, 92],
            color1: 0,
            color2: 16711858,
            description: "Songs from the void in-between."
        },
        ch1: 
        {
            name: "Chapter 1",
            songs: [44, 52, 19, 13, 9, 14, 23, 24, 41, 45, 46, 22],
            color1: 14418175,
            color2: 2227968,
            description: "Songs from Chapter 1: missing/link."
        },
        ch2: 
        {
            name: "Chapter 2",
            songs: [59, 58, 47, 70, 56, 54, 80, 61, 68, 50, 57, 65, 60],
            color1: 16776960,
            color2: 27391,
            description: "Songs from Chapter 2: turning/point."
        },
        ch3: 
        {
            name: "Chapter 3",
            songs: [76, 69, 18, 40, 39, 55, 87, 51, 71, 63, 104, 66, 77, 42, 34, 83, 86, 128],
            color1: 7209215,
            color2: 16711752,
            description: "Songs from Chapter 3: frosted/memories."
        },
        ch4: 
        {
            name: "Chapter 4",
            songs: [26, 35, 103, 129, 49, 72, 38, 75, 85, 89, 106],
            color1: 9502464,
            color2: 16716219,
            description: "Songs from Chapter 4: hidden/boundary."
        },
        ch5: 
        {
            name: "Chapter 5",
            songs: [117, 139, 31, 91, 99, 90, 64, 132, 107, 180, 178],
            color1: 255,
            color2: 4210752,
            description: "Songs from Chapter 5: last/hours."
        },
        ch6: 
        {
            name: "Chapter 6",
            songs: [122, 153, 100, 118, 73, 124, 150, 154, 152, 169, 176, 177, 168, 126],
            color1: 8342016,
            color2: 9502464,
            description: "Songs from Chapter 6: terminal/journey."
        },
        ch7: 
        {
            name: "Final Chapter",
            songs: [167, 166, 93, 137, 125, 131, 127, 92, 97, 121, 101, 171, 105],
            color1: 11960319,
            color2: 16744353,
            description: "Songs from Final Chapter: plaudite."
        },
        cha: 
        {
            name: "Chapter Alpha",
            songs: [186, 188, 189, 149, 190, 173, 191, 192, 201, 204, 202, 203, 206, 200, 205],
            color1: 15139384,
            color2: 652505,
            description: "Songs from Chapter Alpha."
        },
        chb: 
        {
            name: "NEUTRON:HEXIMA",
            songs: [],
            color1: 652505,
            color2: 15139384,
            description: "Songs from NEUTRON:HEXIMA."
        },
        single: 
        {
            name: "Shop Collection",
            songs: [],
            color1: 16749568,
            color2: 16711752,
            description: "Songs purchased from Tori's song shop."
        },
        collaboration: 
        {
            name: "Collaborations",
            songs: [133, 29, 96, 81, 82, 182, 116, 115, 142, 143, 109, 110, 111, 113, 114, 112, 141, 140, 161, 160, 159, 163, 164, 165, 162, 136, 135, 187, 194, 195, 197, 198, 199],
            color1: 9502464,
            color2: 8342016,
            description: "Songs from other games."
        },
        srshowdown: 
        {
            name: "Sunrise Showdown",
            songs: [147, 155, 138, 134, 123, 148, 119],
            color1: 7209215,
            color2: 27391,
            description: "Songs from Sunrise Showdown tournament."
        },
        ungrouped: 
        {
            name: "Ungrouped",
            songs: [102, 150, 156, 184],
            color1: 16777215,
            color2: 16777215
        },
        ch5p1all: 
        {
            name: "Final Chapter",
            songs: [122, 139, 73, 100, 118, 124, 145, 153, 176, 152, 154, 168, 169, 177, 126, 105, 167, 166, 93, 137, 125, 131, 127],
            color1: 16711858,
            color2: 9502464,
            description: "Songs from Final Chapter: terminal/journey."
        },
        ch5p2all: 
        {
            name: "[DEBUG] Final Chapter 2",
            songs: [166, 167, 93, 137, 125, 131],
            color1: 16777215,
            color2: 16777215
        },
        singleall: 
        {
            name: "[ALL] Single Collection",
            songs: [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15, 16, 17, 18, 21, 25, 28, 36, 37, 20, 27, 32, 43, 48, 50, 53, 56, 67, 79, 84, 95, 55, 98, 35],
            color1: 16777215,
            color2: 16777215
        },
        grode: 
        {
            name: "grode",
            songs: [44, 44, 44, 44, 44, 44, 44, 44, 44, 44, 44, 44, 44, 44],
            color1: 16777215,
            color2: 16777215,
            description: "grode"
        },
        allcollab: 
        {
            name: "[DEBUG] Collaboration Chapter",
            songs: [183],
            color1: 16777215,
            color2: 16777215
        },
        gdq: 
        {
            name: "GDQ Showcase",
            songs: [44, 67, 9, 129, 55, 42, 57, 6, 60],
            color1: 16777215,
            color2: 16777215
        },
        magfest: 
        {
            name: "MAGFest Demo",
            songs: [97, 76, 118, 74, 69, 70, 39, 170, 99, 148, 152, 60, 82, 141, 161, 29, 164, 114, 135],
            color1: 16777215,
            color2: 16777215
        },
        fcp2boss1: 
        {
            name: "FCP2 Boss Playlist",
            color1: 16777215,
            color2: 16777215,
            songs: [144, 26, 46, 62, 23, 61, 88, 59, 51, 70, 99, 117, 73, 49, 72]
        },
        fcp2boss2: 
        {
            name: "FCP2 Boss Playlist",
            color1: 16777215,
            color2: 16777215,
            songs: [83, 77, 24, 41, 40, 104, 63, 39, 64, 91, 124, 169, 153, 38, 50]
        },
        fcp2boss3: 
        {
            name: "FCP2 Boss Playlist",
            color1: 16777215,
            color2: 16777215,
            songs: [34, 66, 57, 68, 71, 87, 69, 129, 90, 176, 152, 118, 53, 75]
        },
        fcp2boss4: 
        {
            name: "FCP2 Boss Playlist",
            color1: 16777215,
            color2: 16777215,
            songs: [106, 22, 65, 60, 85, 89, 128, 132, 107, 178, 126, 166, 167, 93]
        },
        EAerichiyo: 
        {
            name: "Echoed Ascensia - Eri & Chiyo",
            color1: 16777215,
            color2: 16777215,
            songs: [14, 45, 46, 47, 57, 80, 18, 34, 63, 66, 99, 139, 118, 152, 176, 92, 93, 167, 171, 16, 27, 36, 37, 67, 108, 181, 82, 112, 116, 123, 133, 147, 155, 162, 182]
        },
        EAkanshaoi: 
        {
            name: "Echoed Ascensia - Kanshi & Aoi",
            color1: 16777215,
            color2: 16777215,
            songs: [9, 23, 56, 61, 70, 51, 55, 87, 72, 75, 103, 180, 100, 145, 168, 101, 105, 121, 127, 12, 78, 84, 88, 95, 144, 151, 170, 96, 109, 113, 115, 136, 140, 142, 161]
        },
        EAsatalli: 
        {
            name: "Echoed Ascensia - Saturday & Allison",
            color1: 16777215,
            color2: 16777215,
            songs: [19, 41, 54, 59, 65, 69, 76, 35, 85, 106, 107, 117, 73, 122, 124, 126, 153, 169, 97, 137, 166, 3, 32, 62, 74, 79, 98, 179, 138, 141, 143, 148, 160, 163, 165]
        },
        EAtsukidawn: 
        {
            name: "Echoed Ascensia - Tsuki & Dawn",
            color1: 16777215,
            color2: 16777215,
            songs: [22, 24, 50, 58, 60, 68, 39, 40, 42, 71, 77, 83, 128, 38, 89, 31, 64, 90, 91, 132, 154, 177, 125, 6, 43, 158, 172, 110, 111, 114, 119, 134, 135, 159, 164]
        }
    };
    ini_open(global.profile_file);
    finale_mode = ini_read_real("profile", "finale_mode", false);
    story_progress = ini_read_real("profile", "story_progress", false);
    ini_close();
    global.bossindex = arg0;
    if (arg0 == 0)
    {
        global.song_packs = ["fcp2boss2"];
    }
    if (arg0 == 1)
    {
        global.song_packs = ["fcp2boss1"];
    }
    if (arg0 == 2)
    {
        global.song_packs = ["fcp2boss3"];
    }
    if (arg0 == 3)
    {
        global.song_packs = ["fcp2boss4"];
    }
    if (arg0 == -1)
    {
        global.bossbar_diff = -1;
    }
    create_store_objects();
    for (var i = 0; i < array_length(global.store_songs); i++)
    {
        array_push(packs.single.songs, global.store_songs[i].song_id);
    }
    for (var i = 0; i < array_length(packs.ch1.songs); i++)
    {
        array_push(packs.mainstory.songs, packs.ch1.songs[i]);
    }
    if (prog >= 4)
    {
        for (var i = 0; i < array_length(packs.ch2.songs); i++)
        {
            array_push(packs.mainstory.songs, packs.ch2.songs[i]);
        }
    }
    if (prog >= 10)
    {
        for (var i = 0; i < array_length(packs.ch3.songs); i++)
        {
            array_push(packs.mainstory.songs, packs.ch3.songs[i]);
        }
    }
    if (prog >= 14)
    {
        for (var i = 0; i < array_length(packs.ch4.songs); i++)
        {
            array_push(packs.mainstory.songs, packs.ch4.songs[i]);
        }
    }
    if (prog >= 17)
    {
        for (var i = 0; i < array_length(packs.ch5.songs); i++)
        {
            array_push(packs.mainstory.songs, packs.ch5.songs[i]);
        }
    }
    if (prog >= 24)
    {
        for (var i = 0; i < array_length(packs.ch6.songs); i++)
        {
            array_push(packs.mainstory.songs, packs.ch6.songs[i]);
        }
    }
    if (prog >= 28)
    {
        for (var i = 0; i < array_length(packs.ch7.songs); i++)
        {
            array_push(packs.mainstory.songs, packs.ch7.songs[i]);
        }
    }
    if (prog >= 11)
    {
        packs.ch0.name = "Betweenspace";
    }
    if (alp_prog >= 8)
    {
        packs.cha.name = "Chapter Alpha / NEUTRON:HEXIMA";
        packs.cha.description = "Songs from Ch. Alpha + N:H";
    }
    for (var i = 0; i < array_length(global.song_packs); i++)
    {
        global.song_packs[i] = variable_struct_get(packs, global.song_packs[i]);
    }
    var all_songs = [];
    var as_included = ds_map_create();
    for (var packi = 0; packi < array_length(global.song_packs); packi++)
    {
        var pack = global.song_packs[packi].songs;
        for (var i = 0; i < array_length(pack); i++)
        {
            var song = pack[i];
            if (!ds_map_exists(as_included, song))
            {
                ds_map_add(as_included, song, true);
                array_push(all_songs, song);
            }
        }
    }
    ds_map_destroy(as_included);
    array_push(global.song_packs, 
    {
        name: "All Songs",
        songs: all_songs,
        color1: 16777215,
        color2: 16777215,
        description: "Every song in the game."
    });
    if (!string_starts_with(global.song_packs[0].name, "FCP2"))
    {
        array_push(global.song_packs, 
        {
            name: "Favorites",
            songs: global.favourite_songs,
            color1: 16724480,
            color2: 16711935,
            description: "Songs marked as favorites."
        });
    }
    global.chapter_1_songs = packs.ch1.songs;
    global.chapter_2_songs = packs.ch2.songs;
    global.chapter_3_songs = packs.ch3.songs;
    global.chapter_4_songs = packs.ch4.songs;
    global.chapter_a_songs = packs.cha.songs;
}
