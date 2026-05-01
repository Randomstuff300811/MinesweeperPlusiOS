extends Control

var rank = 5

var new_record = " (NEW RECORD!)"
var nice_sweeping = "NICE SWEEPING!"


func _ready() -> void :

    translate(Main.db["language"])

    Main.adjust_volume()

    if (Main.db["episode"] == 2): $EndScreenAnimation.play("end_screen2")
    elif (Main.db["episode"] == 3): $EndScreenAnimation.play("end_screen3")


    if (Main.db["episode"] == 1):
        Main.db["adventure_wins"] += 1
        Main.db["face_unlock_array"][0] = 1
        Main.db["episode_unlock_array"][0] = 1
        if (Main.db["difficulty"] > 0): Main.db["boss_unlock_array"][9] = 1
    elif (Main.db["episode"] == 2):
        Main.db["adventure_wins2"] += 1
        Main.db["face_unlock_array"][1] = 1
        Main.db["episode_unlock_array"][1] = 1
        if (Main.db["difficulty"] > 0): Main.db["boss_unlock_array"][10] = 1
    elif (Main.db["episode"] == 3):
        Main.db["adventure_wins3"] += 1
        Main.db["face_unlock_array"][2] = 1
        Main.db["episode_unlock_array"][2] = 1
        if (Main.db["difficulty"] > 0): Main.db["boss_unlock_array"][11] = 1
    Main.db["total_coin"] += Main.db["current_coin"]
    var ep = Main.db["episode"] - 1

    var time = 0

    for x in range(8 + Main.db["episode"]):
        get_node("TimeContainer/Label" + var_to_str(x + 1)).text = Main.convert_time(Main.db["adventure_times"][x])
        time += Main.db["adventure_times"][x]
    get_node("TimeContainer/Label" + var_to_str(8 + Main.db["episode"] + 1)).text = Main.convert_time(time)
    get_node("TimeContainer/Label" + var_to_str(8 + Main.db["episode"] + 2)).text = var_to_str(Main.db["current_coin"])
    get_node("TimeContainer/Label" + var_to_str(8 + Main.db["episode"] + 3)).text = var_to_str(Main.db["mistakes"])


    if (Main.db["pursuit"] != 0):
        var m = ""
        if (Main.db["pursuit"] == 2): m = "pursuit"
        else: m = "adventure"
        if (Main.db["master"]): m += "_master"
        if (Main.db[m + "_records"][ep][Main.db["difficulty"]] == 0.0 || Main.db[m + "_records"][ep][Main.db["difficulty"]] > time):
            if (ep == 0): $TimeContainer / Label10.text += new_record
            elif (ep == 1): $TimeContainer / Label11.text += new_record
            elif (ep == 2): $TimeContainer / Label12.text += new_record
            Main.db[m + "_records"][ep][Main.db["difficulty"]] = time

        calculate_rank(time)
        $FinalRank / Rank.frame = 5 - rank
        if (Main.db[m + "_ranks"][ep][Main.db["difficulty"]] < rank):
            Main.db[m + "_ranks"][ep][Main.db["difficulty"]] = rank
        $Face.play(var_to_str(rank))
        if (rank == 0 || rank == 5): $Face / Hat.play("hat" + var_to_str(Main.db["costume"]) + "_l")
        else:
            $Face / Hat.play("hat" + var_to_str(Main.db["costume"]) + "_nod")
            if (Main.db["costume"] == 7):
                $Face / Hat2.play("hat1_nod")
                $Face / Hat2.set_visible(true)
    else:
        $FinalRank.text = nice_sweeping
        $FinalRank / Rank.visible = false
        $Face / Hat.play("hat" + var_to_str(Main.db["costume"]) + "_l")
        if (Main.db["costume"] == 7):
            $Face / Hat2.play("hat1_l")
            $Face / Hat2.set_visible(true)


    Main.db["adventure_levels_complete"] = 0
    Main.db["adventure_position"] = 0
    Main.db["current_coin"] = 0
    Main.db["adventure_mode"] = false
    Main.db["adventure_health"] = 3
    Main.db["adventure_shield"] = 0
    Main.db["difficulty_save"] = -1
    Main.db["mistakes"] = 0
    Main.db["game_overs"] = 0

    await Main.save_game()

    $EndTheme.play()

    await get_tree().create_timer(1.6).timeout
    set_visible(true)

    await get_tree().create_timer(4.8).timeout

    move_button($ColorRect, -256)
    move_button($ColorRect2, 960)


    await get_tree().create_timer(1.6).timeout
    var range = 8 + Main.db["episode"] + 3
    var play_from_here

    for x in range(range):
        if x >= 12: $EndTheme.play(play_from_here)
        if (x < range - 3):
            get_node("LabelContainer/Label" + var_to_str(x + 1)).visible = true
        elif (x == range - 3):
            get_node("LabelContainer/TimeLabel").visible = true
        elif (x == range - 2):
            get_node("LabelContainer/CoinLabel").visible = true
        elif (x == range - 1):
            get_node("LabelContainer/MistakesLabel").visible = true

        get_node("TimeContainer/Label" + var_to_str(x + 1)).visible = true
        get_node("TimeContainer").set_position(Vector2($LabelContainer.size.x + 64, $TimeContainer.position.y))
        if x >= 11: play_from_here = $EndTheme.get_playback_position()
        await get_tree().create_timer(0.8).timeout
    get_node("TimeContainer").set_position(Vector2($LabelContainer.size.x + 64, $TimeContainer.position.y))






























    $FinalRank.visible = true
    $Face.visible = true
    $FinalRank / Rank.set_position(Vector2($FinalRank.size.x, $FinalRank / Rank.position.y))

    await get_tree().create_timer(3.2).timeout
    move_button($EndAdventure, 640)


func _process(delta: float) -> void :
    pass


func calculate_rank(time) -> void :
    if (Main.db["episode"] == 1):
        if (Main.db["difficulty"] == 0):
            if (time > 180): rank -= 1
            if (time > 360): rank -= 1
            if (Main.db["current_coin"] < 1000): rank -= 1
            if (Main.db["current_coin"] < 2000): rank -= 1
            if (Main.db["mistakes"] >= 1): rank -= 1
            if (Main.db["mistakes"] >= 3): rank -= 1
        if (Main.db["difficulty"] == 1):
            if (time > 300): rank -= 1
            if (time > 600): rank -= 1
            if (Main.db["current_coin"] < 1500): rank -= 1
            if (Main.db["current_coin"] < 2500): rank -= 1
            if (Main.db["mistakes"] >= 1): rank -= 1
            if (Main.db["mistakes"] >= 4): rank -= 1
        elif (Main.db["difficulty"] == 2):
            if (time > 540): rank -= 1
            if (time > 1080): rank -= 1
            if (Main.db["current_coin"] < 2000): rank -= 1
            if (Main.db["current_coin"] < 3000): rank -= 1
            if (Main.db["mistakes"] >= 2): rank -= 1
            if (Main.db["mistakes"] >= 5): rank -= 1
        elif (Main.db["difficulty"] == 3):
            if (time > 840): rank -= 1
            if (time > 1680): rank -= 1
            if (Main.db["current_coin"] < 3000): rank -= 1
            if (Main.db["current_coin"] < 4000): rank -= 1
            if (Main.db["mistakes"] >= 3): rank -= 1
            if (Main.db["mistakes"] >= 6): rank -= 1
    elif (Main.db["episode"] == 2):
        if (Main.db["difficulty"] == 0):
            if (time > 360): rank -= 1
            if (time > 720): rank -= 1
            if (Main.db["current_coin"] < 4000): rank -= 1
            if (Main.db["current_coin"] < 2500): rank -= 1
            if (Main.db["mistakes"] >= 1): rank -= 1
            if (Main.db["mistakes"] >= 4): rank -= 1
        if (Main.db["difficulty"] == 1):
            if (time > 660): rank -= 1
            if (time > 1320): rank -= 1
            if (Main.db["current_coin"] < 5500): rank -= 1
            if (Main.db["current_coin"] < 3500): rank -= 1
            if (Main.db["mistakes"] >= 3): rank -= 1
            if (Main.db["mistakes"] >= 6): rank -= 1
        elif (Main.db["difficulty"] == 2):
            if (time > 1080): rank -= 1
            if (time > 2160): rank -= 1
            if (Main.db["current_coin"] < 6500): rank -= 1
            if (Main.db["current_coin"] < 4500): rank -= 1
            if (Main.db["mistakes"] >= 4): rank -= 1
            if (Main.db["mistakes"] >= 9): rank -= 1
        elif (Main.db["difficulty"] == 3):
            if (time > 1620): rank -= 1
            if (time > 3240): rank -= 1
            if (Main.db["current_coin"] < 7500): rank -= 1
            if (Main.db["current_coin"] < 5000): rank -= 1
            if (Main.db["mistakes"] >= 5): rank -= 1
            if (Main.db["mistakes"] >= 12): rank -= 1
    elif (Main.db["episode"] == 3):
        if (Main.db["difficulty"] == 0):
            if (time > 660): rank -= 1
            if (time > 1320): rank -= 1
            if (Main.db["current_coin"] < 7000): rank -= 1
            if (Main.db["current_coin"] < 5000): rank -= 1
            if (Main.db["mistakes"] >= 2): rank -= 1
            if (Main.db["mistakes"] >= 5): rank -= 1
        if (Main.db["difficulty"] == 1):
            if (time > 960): rank -= 1
            if (time > 1920): rank -= 1
            if (Main.db["current_coin"] < 8000): rank -= 1
            if (Main.db["current_coin"] < 6000): rank -= 1
            if (Main.db["mistakes"] >= 4): rank -= 1
            if (Main.db["mistakes"] >= 7): rank -= 1
        elif (Main.db["difficulty"] == 2):
            if (time > 1200): rank -= 1
            if (time > 2400): rank -= 1
            if (Main.db["current_coin"] < 9000): rank -= 1
            if (Main.db["current_coin"] < 7000): rank -= 1
            if (Main.db["mistakes"] >= 5): rank -= 1
            if (Main.db["mistakes"] >= 9): rank -= 1
        elif (Main.db["difficulty"] == 3):
            if (time > 1500): rank -= 1
            if (time > 3000): rank -= 1
            if (Main.db["current_coin"] < 10000): rank -= 1
            if (Main.db["current_coin"] < 8000): rank -= 1
            if (Main.db["mistakes"] >= 6): rank -= 1
            if (Main.db["mistakes"] >= 11): rank -= 1

    if (rank < 0):
        rank = 0



func move_button(node, end) -> void :
    var mover = node.position[1] - end

    while (mover >= 0.01 || mover <= -0.01):
        $MoveTimer.start()
        await $MoveTimer.timeout
        mover = node.position[1] - end
        node.position[1] -= mover * (5 * get_process_delta_time())
    node.position[1] = end

func fade_out() -> void :
    while ($Fade.color[0] > 0):
        await get_tree().create_timer(0.01).timeout
        $Fade.color -= Color(get_process_delta_time(), get_process_delta_time(), get_process_delta_time(), 0)


func _on_end_adventure_pressed() -> void :
    Main.save_game()

    $EndAdventure.set_disabled(true)
    $End.play()

    await get_tree().create_timer(0.5).timeout
    await fade_out()
    get_tree().change_scene_to_file("res://main.tscn")

func translate(language) -> void :
    var code = Main.get_language_code(language)

    if (Main.db["episode"] == 1):
        var file = FileAccess.open("res://text/translate_level_names1.txt", FileAccess.READ)
        var r = file.get_csv_line(",")
        var c = r.find(code)

        $LabelContainer / Label1.text = file.get_csv_line(",")[c] + ": "
        $LabelContainer / Label2.text = file.get_csv_line(",")[c] + ": "
        $LabelContainer / Label3.text = file.get_csv_line(",")[c] + ": "
        $LabelContainer / Label4.text = file.get_csv_line(",")[c] + ": "
        $LabelContainer / Label5.text = file.get_csv_line(",")[c] + ": "
        $LabelContainer / Label6.text = file.get_csv_line(",")[c] + ": "
        $LabelContainer / Label7.text = file.get_csv_line(",")[c] + ": "
        $LabelContainer / Label8.text = file.get_csv_line(",")[c] + ": "
        if (language == 0): $LabelContainer / Label9.text = "DEVIL'S TRIANGLE: "
        else: $LabelContainer / Label9.text = file.get_csv_line(",")[c] + ": "
        file.close()
    elif (Main.db["episode"] == 2):
        var file = FileAccess.open("res://text/translate_level_names2.txt", FileAccess.READ)
        var r = file.get_csv_line(",")
        var c = r.find(code)

        $LabelContainer / Label1.text = file.get_csv_line(",")[c] + ": "
        $LabelContainer / Label2.text = file.get_csv_line(",")[c] + ": "
        $LabelContainer / Label3.text = file.get_csv_line(",")[c] + ": "
        $LabelContainer / Label4.text = file.get_csv_line(",")[c] + ": "
        $LabelContainer / Label5.text = file.get_csv_line(",")[c] + ": "
        $LabelContainer / Label6.text = file.get_csv_line(",")[c] + ": "
        $LabelContainer / Label7.text = file.get_csv_line(",")[c] + ": "
        $LabelContainer / Label8.text = file.get_csv_line(",")[c] + ": "
        if (language == 0): $LabelContainer / Label9.text = "DEVIL'S TRIANGLE: "
        else: $LabelContainer / Label9.text = file.get_csv_line(",")[c] + ": "
        if (language == 0): $LabelContainer / Label10.text = "DEVIL'S PASSAGE: "
        else: $LabelContainer / Label10.text = file.get_csv_line(",")[c] + ": "
        file.close()

    else:
        $LabelContainer / Label1.text = "BUBBLY TUB: "
        $LabelContainer / Label2.text = "STEAMY JACUZZI: "
        $LabelContainer / Label3.text = "DANGER CREEK: "
        $LabelContainer / Label4.text = "HAZARD CANAL: "
        $LabelContainer / Label5.text = "FLOODED FJORD: "
        $LabelContainer / Label6.text = "WACKY WHIRLPOOL: "
        $LabelContainer / Label7.text = "BOMB BAY: "
        $LabelContainer / Label8.text = "SHIP'S GRAVEYARD: "
        $LabelContainer / Label9.text = "DELTA P: "
        $LabelContainer / Label10.text = "HYDRAULIC SHOCK: "
        $LabelContainer / Label11.text = "DEVIL'S LOCKER: "


    var file = FileAccess.open("res://text/translate_endscreen.txt", FileAccess.READ)
    var r = file.get_csv_line(",")
    var c = r.find(code)

    $ColorRect / Title.text = file.get_csv_line(",")[c]
    $ColorRect2 / Author.text = file.get_csv_line(",")[c]
    $FinalRank.text = file.get_csv_line(",")[c] + ": "
    $LabelContainer / TimeLabel.text = file.get_csv_line(",")[c] + ": "
    new_record = " (" + file.get_csv_line(",")[c] + ")"
    $LabelContainer / CoinLabel.text = file.get_csv_line(",")[c] + ": "
    $LabelContainer / MistakesLabel.text = file.get_csv_line(",")[c] + ": "
    $EndAdventure / EndLabel.text = file.get_csv_line(",")[c]
    nice_sweeping = file.get_csv_line(",")[c]
