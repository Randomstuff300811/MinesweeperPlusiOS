extends Control

@export var bg_tile: PackedScene
@export var rect: PackedScene
@export var circ: PackedScene
var rand
var col = 37
var row = 31
var levels_complete = 0
var back_style
var next_position: Vector2
var move_vector = 0.1
var rotate1 = 1.0
var rotate2 = 2.0
var rotate3 = 3.0
var episode
var boss9_shortcut = 0.0
var boss10_shortcut = 0.0
var boss11_shortcut = 0.0
var rect_spawn = 0.0
var base_levels


func _ready() -> void :
    translate(Main.db["language"])






    if (Main.db["pursuit"] == 0): Main.db["adventure_health"] = 3

    if (Main.db["master"]):
        get_tree().call_group("shield", "queue_free")
    fade_in()


    Main.adjust_volume()


    episode = Main.db["episode"]
    get_node("Markers" + var_to_str(episode)).visible = true
    base_levels = 8 + (episode - 1)

    levels_complete = Main.db["adventure_levels_complete"]
    if (episode == 1):
        if (levels_complete < 8):
            back_style = get_node("Markers1/AM" + var_to_str(levels_complete + 1)).level_style
        else:
            back_style = 1
    elif (episode == 2):
        if (levels_complete < 9):
            back_style = get_node("Markers2/AM" + var_to_str(levels_complete + 1)).level_style
        else:
            back_style = 5
    else:
        if (levels_complete < 10):
            back_style = get_node("Markers3/AM" + var_to_str(levels_complete + 1)).level_style
        else:
            back_style = 1


    if (levels_complete < base_levels):
        get_node("Markers" + var_to_str(episode) + "/AM" + var_to_str(levels_complete + 1)).begin.connect(_start_level)
        get_node("LevelSelect" + var_to_str(back_style)).play()


    for i in range(col * row):
        var bg = bg_tile.instantiate()
        $BackGround.add_child(bg)
    get_tree().call_group("tiles", "shrink", 0.5)
    get_tree().call_group("tiles", "play_anim", back_style)



    if (episode == 1):

        if (levels_complete == 0 && Main.db["adventure_position"] == 0 && !Main.db["instant_boat_travel"]):
            $Boat.position = get_node("Markers1/AM1").start_position
            next_position = get_node("Markers1/AM1").next_position
        elif (levels_complete == Main.db["adventure_position"] && !Main.db["instant_boat_travel"]):
            if (levels_complete == 8):
                $Boat.position = get_node("Markers1/AM8").next_position
                next_position = Vector2(1728, 456)
            else:
                $Boat.position = get_node("Markers1/AM" + var_to_str(levels_complete + 1)).start_position
                next_position = get_node("Markers1/AM" + var_to_str(levels_complete + 1)).next_position
        else:
            if (levels_complete == 8 && (Main.db["adventure_position"] == 9 || Main.db["instant_boat_travel"])):
                $Boat.position = Vector2(1728, 456)
                $Camera.offset = Vector2(1152, 0)
                $BackButton0.position[0] += 1152
                $CoinContainer.position[0] += 1152
            else:
                $Boat.position = get_node("Markers1/AM" + var_to_str(levels_complete + 1)).next_position
            next_position = $Boat.position
    elif (episode == 2):
        if (levels_complete == 0 && Main.db["adventure_position"] == 0 && !Main.db["instant_boat_travel"]):
            $Boat.position = get_node("Markers2/AM1").start_position
            next_position = get_node("Markers2/AM1").next_position
        elif (levels_complete == Main.db["adventure_position"] && !Main.db["instant_boat_travel"]):
            if (levels_complete == 9): $Boat.position = Vector2(568, 512)
            else: $Boat.position = get_node("Markers2/AM" + var_to_str(levels_complete + 1)).start_position
            if (levels_complete == 9): next_position = $Boat.position
            else: next_position = get_node("Markers2/AM" + var_to_str(levels_complete + 1)).next_position
        else:
            if ((levels_complete == 8 && (Main.db["adventure_position"] == 9 || Main.db["instant_boat_travel"]))
            || (levels_complete == 9 && (Main.db["adventure_position"] == 10 || Main.db["instant_boat_travel"]))):
                $Boat.position = Vector2(568, 512)
                $BackButton0.visible = true
                $CoinContainer.visible = true
            else:
                $Boat.position = get_node("Markers2/AM" + var_to_str(levels_complete + 1)).next_position
            next_position = $Boat.position
    elif (episode == 3):
        if (levels_complete == 0 && Main.db["adventure_position"] == 0 && !Main.db["instant_boat_travel"]):
            $Boat.position = get_node("Markers3/AM1").start_position
            next_position = get_node("Markers3/AM1").next_position
        elif (levels_complete == Main.db["adventure_position"] && !Main.db["instant_boat_travel"]):
            if (levels_complete == 10): $Boat.position = Vector2(576, 480)
            else: $Boat.position = get_node("Markers3/AM" + var_to_str(levels_complete + 1)).start_position
            if (levels_complete == 10): next_position = $Boat.position
            else: next_position = get_node("Markers3/AM" + var_to_str(levels_complete + 1)).next_position
        else:
            if (levels_complete == 10 && (Main.db["adventure_position"] == 11 || Main.db["instant_boat_travel"])):
                $Boat.position = Vector2(576, 480)
                $BackButton0.visible = true
                $CoinContainer.visible = true
            else:
                $Boat.position = get_node("Markers3/AM" + var_to_str(levels_complete + 1)).next_position
            next_position = $Boat.position

    $CoinContainer / Coins.text = var_to_str(Main.db["current_coin"])

    $Boat / BoatTimer.start()


    if (Main.db["adventure_levels_complete"] >= base_levels && Main.db["adventure_position"] >= base_levels):
        if (episode == 1):
            if ( !Main.db["instant_boat_travel"]): await get_tree().create_timer(3).timeout
            $LevelSelect9.play()
            $Camera / CameraMoveTimer.start()
        elif (episode == 2):
            if (Main.db["adventure_position"] != 10 && !Main.db["instant_boat_travel"]): await get_tree().create_timer(3).timeout
            $BackGround.visible = false
            $Markers2.visible = false
            if (Main.db["adventure_position"] != 10 && !Main.db["instant_boat_travel"]):
                $BackButton0.visible = false
                $CoinContainer.visible = false
                $Blackout.play()
                await get_tree().create_timer(2).timeout
            $LevelSelect10.play()
            if (Main.db["adventure_position"] != 10 && !Main.db["instant_boat_travel"]): reveal_10(false)
            else: reveal_10(true)
        elif (episode == 3):
            $Boat.position = Vector2(576, 480)
            if (Main.db["adventure_position"] != 11 && !Main.db["instant_boat_travel"]):
                await get_tree().create_timer(3).timeout
                $BackButton0.visible = false
                $CoinContainer.visible = false
            $LevelSelect11.play()
            if (Main.db["adventure_position"] != 11 && !Main.db["instant_boat_travel"]): reveal_11(false)
            else: reveal_11(true)


func _process(delta: float) -> void :


    if (Input.is_action_pressed("9Shortcut") && Main.db["adventure_levels_complete"] < 8):
        boss9_shortcut += delta
        if (boss9_shortcut >= 9.0):
            Main.db["adventure_position"] = 8
            Main.db["adventure_levels_complete"] = 8
            for i in range(Main.db["adventure_times"].size()):
                Main.db["adventure_times"][i] = 999.0
            get_tree().change_scene_to_file("res://adventure_map.tscn")
    if (Input.is_action_pressed("10Shortcut") && Main.db["adventure_levels_complete"] < 9 && episode >= 2):
        boss10_shortcut += delta
        if (boss10_shortcut >= 10.0):
            Main.db["adventure_position"] = 9
            Main.db["adventure_levels_complete"] = 9
            for i in range(Main.db["adventure_times"].size()):
                Main.db["adventure_times"][i] = 999.0
            get_tree().change_scene_to_file("res://adventure_map.tscn")
    if (Input.is_action_pressed("11Shortcut") && Main.db["adventure_levels_complete"] < 10 && episode >= 3):
        boss11_shortcut += delta
        if (boss11_shortcut >= 11.0):
            Main.db["adventure_position"] = 10
            Main.db["adventure_levels_complete"] = 10
            for i in range(Main.db["adventure_times"].size()):
                Main.db["adventure_times"][i] = 999.0
            get_tree().change_scene_to_file("res://adventure_map.tscn")


    if (Main.db["adventure_levels_complete"] >= 10 && episode == 3):
        rect_spawn += delta
        if (rect_spawn >= 0.1):
            rect_spawn = 0
            var circle = circ.instantiate()
            $AM11.add_child(circle)
    if (Main.db["adventure_levels_complete"] >= 9 && episode == 2):
        rect_spawn += delta
        if (rect_spawn >= 0.33):
            rect_spawn = 0
            var square = rect.instantiate()
            $AM10.add_child(square)

    elif (Main.db["adventure_levels_complete"] >= 8 && episode == 1):
        rotate1 = 1.0
        rotate2 = 2.0
        rotate3 = 3.0

        rand = randi()
        if (rand % 23 == 0):
            $Screen2 / Triangle1.rotation_degrees = fmod(($Screen2 / Triangle1.rotation_degrees + 180.0), 360.0)
            rotate1 *= -1.0
        if (rand % 29 == 0):
            $Screen2 / Triangle2.rotation_degrees = fmod(($Screen2 / Triangle2.rotation_degrees + 180.0), 360.0)
            rotate2 *= -1.0
        if (rand % 37 == 0):
            $Screen2 / Triangle3.rotation_degrees = fmod(($Screen2 / Triangle3.rotation_degrees + 180.0), 360.0)
            rotate3 *= -1.0

        rand = randf_range(0.0, 3.0)
        $Screen2 / Triangle1.rotation_degrees = fmod(($Screen2 / Triangle1.rotation_degrees + (rotate1 * rand)), 360.0)
        rand = randf_range(0.0, 3.0)
        $Screen2 / Triangle2.rotation_degrees = fmod(($Screen2 / Triangle2.rotation_degrees - (rotate2 * rand)), 360.0)
        rand = randf_range(0.0, 3.0)
        $Screen2 / Triangle3.rotation_degrees = fmod(($Screen2 / Triangle3.rotation_degrees + (rotate3 * rand)), 360.0)


func move_boat(move_vector) -> void :
    $Boat.position += move_vector




func _on_boat_timer_timeout() -> void :
    var x = 0
    var y = 0

    if (episode == 1):
        if ($Boat.position[0] < next_position[0]):
            move_boat(Vector2(50 * get_process_delta_time(), 0))
    else:

        if ($Boat.position[0] > next_position[0]):
            x = -50 * get_process_delta_time()
            $Boat.play("boatl")
        elif ($Boat.position[0] < next_position[0]):
            x = 50 * get_process_delta_time()
            $Boat.play("boatr")
        if ($Boat.position[1] < next_position[1]):
            y = 50 * get_process_delta_time()
            $Boat.play("boatd")
        elif ($Boat.position[1] > next_position[1]):
            y = -50 * get_process_delta_time()
            $Boat.play("boatu")
        move_boat(Vector2(x, y))
    if (Main.db["instant_boat_travel"] || (episode == 1 && $Boat.position >= next_position) || 
    ((($Boat.position[0] >= next_position[0] && x > 0) || 
    ($Boat.position[1] >= next_position[1] && y > 0) || 
    ($Boat.position[0] <= next_position[0] && x < 0) || 
    ($Boat.position[1] <= next_position[1] && y < 0) || 
    Main.db["adventure_position"] == Main.db["adventure_levels_complete"] + 1))):
        $Boat / BoatTimer.stop()
        if (Main.db["adventure_levels_complete"] < base_levels):
            $StageLabel.text = get_node("Markers" + var_to_str(episode) + "/AM" + var_to_str(levels_complete + 1)).stage_name

            get_node("Markers" + var_to_str(episode) + "/AM" + var_to_str(levels_complete + 1)).set_disabled(false)
            get_node("Markers" + var_to_str(episode) + "/AM" + var_to_str(levels_complete + 1)).blink()
            Main.db["adventure_position"] = levels_complete + 1
        if (Main.db["adventure_position"] == 9 && !$LevelSelect9.playing): $LevelSelect9.play()
        if (Main.db["adventure_levels_complete"] >= base_levels):
            if (Main.db["episode"] == 1): get_node("Screen2/Triangle1/AM9").set_disabled(false)
            elif (Main.db["episode"] == 2): $AM10.set_disabled(false)
            else: pass


func _on_back_button_0_pressed() -> void :
    $BackButton0.set_disabled(true)
    get_tree().call_group("marker", "set_disabled", true)
    get_tree().call_group("music", "stop")
    $Exit.play()
    await get_tree().create_timer(0.5).timeout
    await fade_out()
    get_tree().change_scene_to_file("res://game_select_screen.tscn")


func zoom_camera() -> void :
    var goal_position
    var goal_zoom = Vector2(8.0, 8.0)
    var zoom_vector = Vector2(0.1, 0.1)
    if (levels_complete < base_levels):
        goal_position = get_node("Markers" + var_to_str(episode)).position + get_node("Markers" + var_to_str(episode) + "/AM" + var_to_str(levels_complete + 1)).position + Vector2(48, 48)
    else:
        if (Main.db["episode"] == 1): goal_position = get_node("Screen2/Triangle1").position
        elif (Main.db["episode"] == 2): goal_position = get_node("AM10").position + get_node("AM10").size / 2
        elif (Main.db["episode"] == 3): goal_position = get_node("AM11").position + get_node("AM11").size / 2
    while ($Camera.zoom < Vector2(7.95, 7.95)):
        zoom_vector = (goal_zoom - $Camera.zoom) * (5 * get_process_delta_time())
        $Camera.zoom += zoom_vector
        move_vector = (goal_position - $Camera.position) * (5 * get_process_delta_time())
        $Camera.position += move_vector
        await get_tree().create_timer(0.01).timeout

func slow_zoom(goal, zoom, fade):
    var goal_position
    var goal_zoom = Vector2(goal, goal)
    var zoom_vector = Vector2(zoom, zoom)
    var zoom_plus = 0.001
    while ($Camera.zoom[0] < goal):
        if ($Camera.zoom[0] + zoom_vector[0] > goal_zoom[0]):
            $Camera.zoom = goal_zoom
        else:
            $Camera.zoom += zoom_vector
        if (fade): modulate[3] -= zoom_plus
        else: modulate[3] += zoom_plus
        zoom *= (1 + zoom_plus)
        zoom_vector = Vector2(zoom, zoom)
        zoom_plus += 0.001
        await get_tree().create_timer(0.01).timeout
    $Camera.zoom = goal_zoom
    if (fade): modulate[3] = 0
    else: modulate[3] = 1



func move_camera() -> void :
    $Camera.offset[0] += move_vector


func _on_camera_move_timer_timeout() -> void :
    move_camera()
    if (1152 - $Camera.offset[0] <= 0.01):
        $Camera / CameraMoveTimer.stop()
        get_node("Screen2/Triangle1/AM9").set_disabled(false)

    if ($Camera.offset[0] < 1152 / 2 + 2):
        move_vector += (5 * get_process_delta_time())
    else:
        if (move_vector > (5 * get_process_delta_time())):
            move_vector -= (5 * get_process_delta_time())


func _start_level() -> void :
    if (Main.db["adventure_levels_complete"] == 8):
        $LevelSelect9.volume_linear = 0
    else:
        get_node("LevelSelect" + var_to_str(back_style)).stop()
    if (Main.db["adventure_levels_complete"] < 8): $LevelClick1.play()
    else: $LevelClick2.play()
    await (zoom_camera())
    await fade_out()
    get_tree().change_scene_to_file("res://level.tscn")


func fade_in() -> void :
    while ($Fade.color[0] < 1):
        await get_tree().create_timer(get_process_delta_time()).timeout
        $Fade.color += Color(1, 1, 1, 0) * (4 * get_process_delta_time())
    $Fade.color = Color(1, 1, 1, 1)
func fade_out() -> void :
    while ($Fade.color[0] > 0):
        await get_tree().create_timer(get_process_delta_time()).timeout
        $Fade.color -= Color(1, 1, 1, 0) * (4 * get_process_delta_time())
    $Fade.color = Color(0, 0, 0, 0)


func _on_am_9_pressed() -> void :
    get_node("Screen2/Triangle1/AM9").set_disabled(true)
    get_node("Screen2/Triangle1/AM9").set_visible(false)
    Main.game_length = Main.adventure_length[Main.db["episode"] - 1][8][Main.db["difficulty"]]
    Main.game_width = Main.adventure_width[Main.db["episode"] - 1][8][Main.db["difficulty"]]
    Main.game_mines = Main.adventure_mines[Main.db["episode"] - 1][8][Main.db["difficulty"]]
    Main.game_style = 1
    Main.game_bgm = 12
    Main.nine = true
    Main.nine_count = 1
    Main.db["adventure_position"] = 9
    $LevelSelect9.stop()
    _start_level()


func _on_am_10_pressed() -> void :
    $AM10.set_disabled(true)
    Main.game_length = Main.adventure_length[Main.db["episode"] - 1][9][Main.db["difficulty"]]
    Main.game_width = Main.adventure_width[Main.db["episode"] - 1][9][Main.db["difficulty"]]
    Main.game_mines = Main.adventure_mines[Main.db["episode"] - 1][9][Main.db["difficulty"]]
    Main.game_style = 5
    Main.game_bgm = 12
    Main.ten = true
    Main.ten_count = 1
    $LevelSelect10.stop()
    _start_level()

func reveal_10(skip: bool) -> void :
    $AM10.set_visible(true)
    while ($AM10.modulate[3] < 1):
        if ( !skip): await get_tree().create_timer(get_process_delta_time()).timeout
        $AM10.modulate[3] += (get_process_delta_time() / 3)
    Main.db["adventure_position"] = 10
    $AM10.set_disabled(false)

func reveal_11(skip: bool) -> void :
    $Screen2.set_visible(false)
    if ( !skip): await slow_zoom(20.0, 0.1, true)
    $BackGround.visible = false
    $Markers3.visible = false
    $AM11.set_visible(true)
    $Camera.limit_right = 1000000000
    $Camera.limit_bottom = 1000000000
    $Camera.limit_left = -1000000000
    $Camera.limit_top = -1000000000
    if ( !skip): $Camera.zoom = Vector2(0.001, 0.001)
    if ( !skip): await get_tree().create_timer(3).timeout

    if ( !skip): await slow_zoom(1.0, 0.001, false)
    $AM11.set_disabled(false)
    Main.db["adventure_position"] = 11


func _on_boat_area_area_entered(area: Area2D) -> void :
    if (Main.db["pursuit"] != 0):
        Main.db["adventure_shield"] += 1
    else:
        Main.db["adventure_shield"] += 3
        $Boat / ShieldLabel.text = "+3 Shield"
    if (Main.db["adventure_shield"] > 3): Main.db["adventure_shield"] = 3
    $LevelClick1.pitch_scale = 2.0
    $LevelClick1.play()
    $Boat / ShieldLabel.visible = true
    await get_tree().create_timer(1).timeout
    $LevelClick1.pitch_scale = 1.0
    $Boat / ShieldLabel.visible = false


func _on_am_11_pressed() -> void :
    $AM11.set_disabled(true)
    Main.game_length = Main.adventure_length[Main.db["episode"] - 1][10][Main.db["difficulty"]]
    Main.game_width = Main.adventure_width[Main.db["episode"] - 1][10][Main.db["difficulty"]]
    Main.game_mines = Main.adventure_mines[Main.db["episode"] - 1][10][Main.db["difficulty"]]
    Main.game_style = 1
    Main.game_bgm = 12
    Main.eleven = true
    Main.eleven_count = 1
    $LevelSelect11.stop()
    _start_level()

func translate(language) -> void :
    var code = Main.get_language_code(language)

    if (Main.db["episode"] == 1):
        var file = FileAccess.open("res://text/translate_level_names1.txt", FileAccess.READ)
        var r = file.get_csv_line(",")
        var c = r.find(code)
        $Markers1 / AM1.stage_name = file.get_csv_line(",")[c]
        $Markers1 / AM2.stage_name = file.get_csv_line(",")[c]
        $Markers1 / AM3.stage_name = file.get_csv_line(",")[c]
        $Markers1 / AM4.stage_name = file.get_csv_line(",")[c]
        $Markers1 / AM5.stage_name = file.get_csv_line(",")[c]
        $Markers1 / AM6.stage_name = file.get_csv_line(",")[c]
        $Markers1 / AM7.stage_name = file.get_csv_line(",")[c]
        $Markers1 / AM8.stage_name = file.get_csv_line(",")[c]
        $Screen2 / Level9Label.text = file.get_csv_line(",")[c]
        file.close()
    elif (Main.db["episode"] == 2):
        var file = FileAccess.open("res://text/translate_level_names2.txt", FileAccess.READ)
        var r = file.get_csv_line(",")
        var c = r.find(code)
        $Markers2 / AM1.stage_name = file.get_csv_line(",")[c]
        $Markers2 / AM2.stage_name = file.get_csv_line(",")[c]
        $Markers2 / AM3.stage_name = file.get_csv_line(",")[c]
        $Markers2 / AM4.stage_name = file.get_csv_line(",")[c]
        $Markers2 / AM5.stage_name = file.get_csv_line(",")[c]
        $Markers2 / AM6.stage_name = file.get_csv_line(",")[c]
        $Markers2 / AM7.stage_name = file.get_csv_line(",")[c]
        $Markers2 / AM8.stage_name = file.get_csv_line(",")[c]
        $Markers2 / AM9.stage_name = file.get_csv_line(",")[c]
        $AM10 / Stage10Label.text = file.get_csv_line(",")[c]
        file.close()
