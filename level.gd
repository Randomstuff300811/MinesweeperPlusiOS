extends Control


@export var bg_tile: PackedScene
@export var game: PackedScene
@export var ten_explosion: PackedScene
@export var nine: PackedScene
@export var ten: PackedScene
@export var eleven: PackedScene
var max_columns = 18
var max_rows = 12
var game_col
var game_row
var expression = false
var area = 0
var paused = false
var game_over = false
var winner = false
var face_type = "1"
var hat_type = "1"
var pause_mover
var face_on = true
var shrink_quotient
var shrink_max = 1.0
var shrink_base
var scroller = false
var skip_intro = false
var game_board
var camera
var camera_pos
var face
var face2
var hat
var nine_mine
var nine_mine2
var ten_mine
var ten_mine2
var eleven_mine
var eleven_mine2
var boss_battle = false
var quick_set_9
var fake_end
var ten_position_save
var ten_position_save2
var bg
var save_score = 0
var save_time = 0
var nine_mine_array = []
var nine_mine_temp_array = []
var ten_mine_array = []
var eleven_mine_array = []
var boss_mine_array = []
var dual_boss = false
var anim_frames = 0
var now_ready = false

var nine_count = 0
var nine_movement_array = []
var ten_count = 0
var eleven_count = 0

var clear_text
var pause_text
var miss_text
var ready_text
var reset_text
var exit_text
var save_exit_text
var continue_text
var one_up
var game_over_text
var yes_text
var no_text
var skipping
var stage_text = "STAGE"

var wait_for_nine = false

var lowq = false
var randbgm = 0


func _ready() -> void :
	translate(Main.db["language"])


	if (Main.adventure_mode && !Main.level_select):
		if (Main.db["episode"] == 1):
			if (Main.nine):
				if (Main.db["pursuit"] == 2):
					nine_count = 2
					dual_boss = true
				else: nine_count = 1
			else:
				if (Main.db["pursuit"] == 2): nine_count = 1
				else: nine_count = 0
		elif (Main.db["episode"] == 2):
			if (Main.ten):
				if (Main.db["pursuit"] == 2):
					ten_count = 2
					dual_boss = true
				else: ten_count = 1
			else:
				if (Main.db["pursuit"] == 2): ten_count = 1
				else: ten_count = 0
				if (Main.db["adventure_levels_complete"] == 8):
					nine_count = 1
		if (Main.db["episode"] == 3):
			if (Main.eleven):
				if (Main.db["pursuit"] == 2):
					eleven_count = 2
					dual_boss = true
				else: eleven_count = 1
			else:
				if (Main.db["pursuit"] == 2): eleven_count = 1
				else: eleven_count = 0
				if (Main.db["adventure_levels_complete"] == 8):
					nine_count = 1
				if (Main.db["adventure_levels_complete"] == 9):
					ten_count = 1
		Main.nine_count = nine_count
		Main.ten_count = ten_count
		Main.eleven_count = eleven_count
	else:
		nine_count = Main.nine_count
		ten_count = Main.ten_count
		eleven_count = Main.eleven_count

	game_board = $SVC / SV / Game
	camera = $SVC / SV / Game / Camera
	camera_pos = $CameraFollow
	face = $HUD / FacePanel / FaceButton / Face
	face2 = $HUD / FacePanel / FaceButton / Face2
	hat = $HUD / FacePanel / FaceButton / Hat


	nine_mine_temp_array.append("NineMineTemp")




	Main.db["games_started"] += 1
	if (Main.db["master"]): Main.db["games_started_in_master_mode"] += 1
	if ( !Main.practice): $HUD / FacePanel / PracticeLabel.queue_free()
	fade_in()

	if (Main.adventure_mode || Main.level_select):
		$PauseMenu / PauseBackGround / Buttons / ResetButton.visible = false
		$HUD / FacePanel / Radar / CoinLabel.text = var_to_str(Main.db["current_coin"])
		$HUD / FacePanel / HealthGauge.frame = abs(Main.db["adventure_health"] - 3)
		$HUD / FacePanel / HealthGauge / ShieldGauge.frame = Main.db["adventure_shield"]

		if (Main.adventure_mode):
			if (Main.db["adventure_levels_complete"] >= 8):
				face_type = "5"
			elif (Main.db["adventure_levels_complete"] >= 6):
				face_type = "4"
			elif (Main.db["adventure_levels_complete"] >= 4):
				face_type = "3"
			elif (Main.db["adventure_levels_complete"] >= 2):
				face_type = "2"

			if (Main.db["adventure_levels_complete"] == 1):
				if (Main.db["episode"] == 1): $SVC / Rain.set_visible(true)
				elif (Main.db["episode"] == 2): $SVC / Snow.set_visible(true)
				elif (Main.db["episode"] == 3): $SVC / Fog.set_visible(true)
		elif (Main.level_select):
			if (Main.level_select_level == 2):
				if (Main.level_select_episode == 0): $SVC / Rain.set_visible(true)
				elif (Main.level_select_episode == 1): $SVC / Snow.set_visible(true)
				elif (Main.level_select_episode == 2): $SVC / Fog.set_visible(true)
			if (Main.level_select_episode == 0):
				if (Main.level_select_level <= 2):
					face_type = "1"
					Main.game_bgm = 1
					Main.game_style = 1
				elif (Main.level_select_level <= 4):
					face_type = "2"
					Main.game_bgm = 2
					Main.game_style = 2
				elif (Main.level_select_level <= 6):
					face_type = "3"
					Main.game_bgm = 3
					Main.game_style = 3
				elif (Main.level_select_level <= 8):
					face_type = "4"
					Main.game_bgm = 4
					Main.game_style = 4
				elif (Main.level_select_level <= 9):
					face_type = "5"
					Main.game_bgm = 12
					Main.game_style = 1
			elif (Main.level_select_episode == 1):
				if (Main.level_select_level <= 2):
					face_type = "1"
					Main.game_bgm = 5
					Main.game_style = 5
				elif (Main.level_select_level <= 4):
					face_type = "2"
					Main.game_bgm = 6
					Main.game_style = 6
				elif (Main.level_select_level <= 6):
					face_type = "3"
					Main.game_bgm = 7
					Main.game_style = 7
				elif (Main.level_select_level <= 8):
					face_type = "4"
					Main.game_bgm = 8
					Main.game_style = 8
				elif (Main.level_select_level <= 9):
					face_type = "5"
					Main.game_bgm = 12
					Main.game_style = 1
				elif (Main.level_select_level <= 10):
					face_type = "6"
					Main.game_bgm = 12
					Main.game_style = 5
			elif (Main.level_select_episode == 2):
				if (Main.level_select_level <= 1):
					face_type = "1"
					Main.game_bgm = 1
					Main.game_style = 1
				elif (Main.level_select_level <= 2):
					face_type = "1"
					Main.game_bgm = 5
					Main.game_style = 5
				elif (Main.level_select_level <= 3):
					face_type = "2"
					Main.game_bgm = 2
					Main.game_style = 2
				elif (Main.level_select_level <= 4):
					face_type = "2"
					Main.game_bgm = 6
					Main.game_style = 6
				elif (Main.level_select_level <= 5):
					face_type = "3"
					Main.game_bgm = 3
					Main.game_style = 3
				elif (Main.level_select_level <= 6):
					face_type = "3"
					Main.game_bgm = 7
					Main.game_style = 7
				elif (Main.level_select_level <= 7):
					face_type = "4"
					Main.game_bgm = 4
					Main.game_style = 4
				elif (Main.level_select_level <= 8):
					face_type = "4"
					Main.game_bgm = 8
					Main.game_style = 8
				elif (Main.level_select_level <= 9):
					face_type = "5"
					Main.game_bgm = 12
					Main.game_style = 1
				elif (Main.level_select_level <= 10):
					face_type = "6"
					Main.game_bgm = 12
					Main.game_style = 5
				elif (Main.level_select_level <= 11):
					face_type = "7"
					Main.game_bgm = 12
					Main.game_style = 1

		$HUD / FacePanel / FaceButton / Face.play("face" + face_type + "_:)f")
	elif (Main.challenge):
		face_type = var_to_str(Main.db["face"])
		Main.challenge_coin = 0
		$HUD / FacePanel / Radar / CoinLabel.text = "0"
	elif (Main.endless):
		$PauseMenu / PauseBackGround / Buttons / ResetButton.visible = false
		$HUD / FacePanel / Radar / CoinLabel.text = var_to_str(Main.db["endless_last_coins"])
		$HUD / FacePanel / HealthGauge.frame = abs(Main.db["endless_health"] - 3)
		$HUD / FacePanel / HealthGauge / ShieldGauge.frame = Main.db["endless_shield"]

		$HUD / FacePanel / Radar / CoinLabel.text = var_to_str(Main.db["endless_last_coins"])
	else:
		face_type = var_to_str(Main.db["face"])
		if (Main.db["total_coin"] < 9999):
			$HUD / FacePanel / Radar / CoinLabel.text = var_to_str(Main.db["total_coin"])
		else:
			$HUD / FacePanel / Radar / CoinLabel.text = "9999"

		if (Main.weather == 1): $SVC / Rain.set_visible(true)
		elif (Main.weather == 2): $SVC / Snow.set_visible(true)
		elif (Main.weather == 3): $SVC / Fog.set_visible(true)

	if (Main.db["face"] > 0 || Main.adventure_mode || Main.level_select):
		hat_type = var_to_str(Main.db["costume"])

	else:
		hat_type = "5"
		face_type = "0"
		$HUD / FacePanel / FaceButton / Face.visible = false
		$HUD / FacePanel / FaceButton / Face2.visible = true
		var png = Image.load_from_file("user://Faces_0.png")
		var texture = ImageTexture.create_from_image(png)
		$HUD / FacePanel / FaceButton / Face2.texture = texture
		var face_size = texture.get_size()
		$HUD / FacePanel / FaceButton / Face2.scale = Vector2(640.0 / face_size[0], 640 / face_size[1])

	if (hat_type != "5" && face_type != "0"):
		$HUD / FacePanel / FaceButton / Face.position += Vector2(0, 8)

	if ( !Main.challenge && !Main.endless):
		game_col = Main.game_length
		game_row = Main.game_width
	elif (Main.endless):
		game_col = Main.db["endless_last_length"]
		game_row = Main.db["endless_last_width"]
	else:
		game_col = 72
		game_row = 48



	if (eleven_count <= 0):
		pass

	elif (eleven_count > 0):
		boss_battle = true


		var e
		for i in range(eleven_count):
			e = eleven.instantiate()
			e.number = i
			e.next_move.connect(_move_eleven)
			e.flag.connect(_eleven_flag)
			e.zap.connect(_eleven_zap)
			e.barrage.connect(_eleven_barrage)

			eleven_mine_array.append(e)
			$SVC / SV.add_child(e)
			if ( !Main.eleven):
				if (i > 0): game_board.eleven_position.append(Vector2(0, 0))
				game_board.eleven_position[i] = Vector2i(randi() % game_row, randi() % game_col)
				e.position = game_board.position + game_board.get_eleven_position(i)
				if (randi() % 2 == 1): e.ro = 1
				else: e.ro = -1
				e.tesla_on()

		if (Main.eleven):
			eleven_mine = eleven_mine_array[0]
			eleven_mine.set_visible(false)
			face_on = false
			face_type = "7"
			eleven_mine.get_node("Button1").set_disabled(true)
			eleven_mine.get_node("Button2").set_disabled(true)
			face.play("faceN_1")
			hat.play("hat" + hat_type + "_f")
			$HUD / FacePanel / FaceButton.set_disabled(true)


			if (dual_boss):
				eleven_mine2 = eleven_mine_array[1]
				eleven_mine2.set_visible(false)
				dual_boss = true
				game_board.eleven_position.append(Vector2i(0, 0))

				eleven_mine2.get_node("Button1").set_disabled(true)
				eleven_mine2.get_node("Button2").set_disabled(true)
		else:
			$NineQuickSetTimer.start()
			$HUD / MineCounter.set_modulate(Color(1, 0.5, 0.5, 1))
			$HUD / FacePanel / TimerGauge.start()
	if (Main.eleven && (Main.adventure_mode && Main.db["episode"] == 3 && Main.db["difficulty"] > 0) || 
	(Main.level_select && Main.level_select_episode == 2 && Main.level_select_difficulty > 0)):
		fake_end = true

	if (ten_count <= 0):
		pass



	elif (ten_count > 0):
		boss_battle = true
		var t
		for i in range(ten_count):
			t = ten.instantiate()
			t.ran_out_of_time.connect(_end_battle2)
			t.bounced.connect(shake_screen)
			add_child(t)
			if ( !Main.ten):
				t.set_position(Vector2i(randi_range(64, 1088), randi_range(64, 896)))
				t.visible = true
				t.go = true
			t.get_node("Button/Light").range_z_min = 100 + i
			t.get_node("Button/Light").range_z_max = 100 + i
			t.z_index = 100 + i
			ten_mine_array.append(t)































		if (Main.ten):
			face_on = false
			face_type = "6"
			ten_mine = ten_mine_array[0]
			ten_mine.set_visible(false)
			ten_mine.get_node("Button").set_disabled(true)
			face.play("faceT_1")
			hat.play("hat" + hat_type + "_f")
			$HUD / FacePanel / FaceButton.set_disabled(true)


			if (dual_boss):
				ten_mine2 = ten_mine_array[1]
				ten_mine2.set_visible(false)




			if ( !Main.level_select && Main.db["pursuit"] == 2 && Main.db["episode"] == 3):
				eleven_mine_array[0].visible = false
		else:
			$HUD / FacePanel / TimerGauge.start()

	if (Main.ten && (Main.db["episode"] == 2 || Main.level_select_episode == 1) && (Main.db["difficulty"] > 0 || Main.level_select_difficulty > 0)):
		fake_end = true

	if (nine_count <= 0):
		if ( !fake_end):
			pass






	elif (nine_count > 0):
		boss_battle = true
		var n
		var attempts = 0
		for i in range(nine_count):
			n = nine.instantiate()
			n.movement_decision.connect(_load_nine_movement_array)
			n.nine_pressed.connect(_end_battle)
			if (i != 0): game_board.nine_position.append(Vector2(0, 0))
			if ( !Main.nine):
				if (attempts >= 999): break
				var good_placement = false
				while ( !good_placement):
					quick_set_9 = Vector2i(randi_range(1, game_row - 2), randi_range(1, game_col - 2))
					if (game_board.check_for_good_placement(quick_set_9)):
						$SVC / SV.add_child(n)
						game_board.nine_position[i] = quick_set_9
						game_board.preset_mines(game_board.nine_position[i])
						game_board.open_nine_tile(i)
						n.delta_multiplier = (randf() * 2) - 1
						n.get_node("Body").frame = 0
						n.get_node("Body/Spikes").scale = Vector2(1, 1)
						n.get_node("Body/Spikes").visible = true
						good_placement = true
						n.mine_number = i
						nine_mine_array.append(n)
					else:
						attempts += 1
						if (attempts >= 999):
							n.queue_free()
							break
			else:
				n.mine_number = i
				nine_mine_array.append(n)
				$SVC / SV.add_child(n)









		if ( !Main.nine):
			$NineQuickSetTimer.start()
			$HUD / MineCounter / Timer.start()
			$HUD / FacePanel / Radar / RadarButton.set_modulate(Color(1, 1, 1, 0.5))
			$HUD / GameTimer.set_modulate(Color(1, 0.5, 0.5, 1))
			$HUD / FacePanel / TimerGauge.start()
		else:
			for nine in nine_mine_array:
				nine.get_node("Body").frame = 4
				nine.get_node("Body").visible = false
				nine.get_node("Body/Spikes").scale = Vector2(0.5, 0.5)
				nine.get_node("Body/Spikes").visible = false
				nine.delta_multiplier = 0
			nine_mine = nine_mine_array[0]
			if (dual_boss):
				nine_mine2 = nine_mine_array[1]
				nine_mine_temp_array.append("NineMineTemp2")
			face_on = false
			nine_mine.set_disabled(true)
			face.play("faceE_1")
			hat.play("hat" + hat_type + "_f")
			$HUD / FacePanel / FaceButton.set_disabled(true)

			if ( !Main.level_select && Main.db["pursuit"] == 2 && Main.db["episode"] == 3):
				eleven_mine_array[0].visible = false





























































	if (boss_battle):
		$PauseMenu / PauseBackGround / Buttons / ExitButton.visible = true
		$PauseMenu / PauseBackGround / Buttons / ResetButton.visible = false
		$HUD / FacePanel / FaceButton.set_disabled(true)
	else:
		pass



	game_board.pass_flag.connect(_flag_update)
	game_board.pass_face.connect(_face_update)
	game_board.pass_radar.connect(_radar_deac)
	game_board.game_time.connect(_timer_start)
	game_board.mistake.connect(_mistake_update)
	game_board.game_over.connect(_game_over)
	game_board.pass_percent.connect(_percent_update)
	game_board.pass_mine_click.connect(_mistake_face)
	game_board.pass_challenge.connect(_challenge_coin_update)
	$HUD / FacePanel.face_press.connect(_face_press)
	$HUD / FacePanel.reset.connect(_pause_game)
	$HUD / FacePanel.radar.connect(_toggle_radar)
	$HUD / MineCounter.set_flags(game_board.mines - game_board.flags)
	$HUD / MineCounter.flagged_out.connect(_end_battle3)
	game_board.nine_intro.connect(_nine_intro)
	$HUD / GameTimer.nine_timeout.connect(_end_battle)
	game_board.ten_intro.connect(_ten_intro)
	game_board.ten_end.connect(_end_battle2)
	game_board.eleven_intro.connect(_eleven_intro)
	game_board.eleven_end.connect(_end_battle3)














































	build_level()

	Main.adjust_volume()

	if (Main.game_bgm == 9):
		get_node("9/9Intro").play()
	elif (Main.game_bgm == 10):
		get_node("10/10Intro").play()
	elif (Main.game_bgm == 11):
		get_node("11/11Intro").play()
	elif (Main.game_bgm == 14):
		randbgm = (randi()) % 8 + 1
		get_node("BGM" + var_to_str(randbgm)).play()
	elif (Main.game_bgm < 13):
		get_node("BGM" + var_to_str(Main.game_bgm)).play()

	if (game_board.win_tiles == 0):
		game_board.end_game(true)


func _process(delta: float) -> void :



	if scroller:
		camera.position = camera.position - (camera.position - camera_pos.position) / 10

	if scroller && (Input.is_action_pressed("scrub")):
		camera_pos.position = get_local_mouse_position()

	if (camera.zoom.x < shrink_max): camera.zoom = Vector2(shrink_max, shrink_max)
	if scroller && camera.zoom.x != shrink_base && (Input.is_action_just_pressed("zoom_in")):
		if (camera.zoom.x <= shrink_base):
			camera.zoom -= Vector2((shrink_max - shrink_base) * delta * 3, (shrink_max - shrink_base) * delta * 3)
		else:
			camera.zoom = Vector2(shrink_base, shrink_base)
	if scroller && camera.zoom.x != shrink_max && Input.is_action_just_pressed("zoom_out"):
		if (camera.zoom.x >= shrink_max):
			camera.zoom += Vector2((shrink_max - shrink_base) * delta * 3, (shrink_max - shrink_base) * delta * 3)
			camera_pos.position = camera.get_screen_center_position()
		else:
			camera.zoom = Vector2(shrink_max, shrink_max)








	if scroller && Input.is_action_pressed("camera_up"):
		camera_pos.position = camera.get_screen_center_position()
		if Input.is_action_pressed("camera_left"): camera_pos.position += Vector2(-64, -64)
		elif Input.is_action_pressed("camera_right"): camera_pos.position += Vector2(64, -64)
		else: camera_pos.position += Vector2(0, -64)
	if scroller && Input.is_action_pressed("camera_down"):
		camera_pos.position = camera.get_screen_center_position()
		if Input.is_action_pressed("camera_left"): camera_pos.position += Vector2(-64, 64)
		elif Input.is_action_pressed("camera_right"): camera_pos.position += Vector2(64, 64)
		else: camera_pos.position += Vector2(0, 64)
	if scroller && Input.is_action_pressed("camera_left"):
		camera_pos.position = camera.get_screen_center_position()
		if Input.is_action_pressed("camera_up"): camera_pos.position += Vector2(-64, -64)
		elif Input.is_action_pressed("camera_down"): camera_pos.position += Vector2(-64, 64)
		else: camera_pos.position += Vector2(-64, 0)
	if scroller && Input.is_action_pressed("camera_right"):
		camera_pos.position = camera.get_screen_center_position()
		if Input.is_action_pressed("camera_up"): camera_pos.position += Vector2(64, -64)
		elif Input.is_action_pressed("camera_down"): camera_pos.position += Vector2(64, 64)
		else: camera_pos.position += Vector2(64, 0)

	if face_on:
		if (face_type != "0"):
			if expression:
				if area == 0:
					face.play("face" + face_type + "_:0f")
					hat.play("hat" + hat_type + "_f")
				if game_over == false:
					if area == 1:
						face.play("face" + face_type + "_:0l")
						if (face_type != "5"): hat.play("hat" + hat_type + "_l")
						else: hat.play("hat" + hat_type + "_r")
					elif area == 2:
						face.play("face" + face_type + "_:0d")
						hat.play("hat" + hat_type + "_d")
					elif area == 3:
						face.play("face" + face_type + "_:0r")
						if (face_type != "5"): hat.play("hat" + hat_type + "_r")
						else: hat.play("hat" + hat_type + "_l")
			else:
				if game_over == false:
					if area == 0:
						face.play("face" + face_type + "_:)f")
						hat.play("hat" + hat_type + "_f")
					elif area == 1:
						face.play("face" + face_type + "_:)l")
						if (face_type != "5"): hat.play("hat" + hat_type + "_l")
						else: hat.play("hat" + hat_type + "_r")
					elif area == 2:
						face.play("face" + face_type + "_:)d")
						hat.play("hat" + hat_type + "_d")
					elif area == 3:
						face.play("face" + face_type + "_:)r")
						if (face_type != "5"): hat.play("hat" + hat_type + "_r")
						else: hat.play("hat" + hat_type + "_l")
				else:
					if winner:
						face.play("face" + face_type + "_B)")
						if (face_type != "4"): hat.play("hat" + hat_type + "_nod")
						else: hat.play("hat" + hat_type + "_nodv2")
					else:
						face.play("face" + face_type + "_X(")
						hat.play("hat" + hat_type + "_dead")
		else:
			if expression:
				if area == 0:
					face2.frame = 8
				if game_over == false:
					if area == 1:
						face2.frame = 9
					elif area == 2:
						face2.frame = 10
					elif area == 3:
						face2.frame = 11
			else:
				if game_over == false:
					if area == 0:
						face2.frame = 4
					elif area == 1:
						face2.frame = 5
					elif area == 2:
						face2.frame = 6
					elif area == 3:
						face2.frame = 7
				else:
					if winner:
						if (anim_frames % 30 < 15):
							face2.frame = 0
						else:
							face2.frame = 1
						anim_frames += 1
						anim_frames %= 30
					else:
						face2.frame = 14

	if (nine_count > 0 && !game_over && !game_board.no_more_opening):
		if ( !wait_for_nine):
			if ( !nine_movement_array.is_empty()):
				if (nine_mine_array[nine_movement_array[0][0]].get_node("WaitTimer").time_left <= 0):
					_move_nine()

				else:
					nine_movement_array.append(nine_movement_array.pop_front())
		else: wait_for_nine = false

func build_level() -> void :

	shrink_quotient = 1.0
	var numerator_sq1
	var numerator_sq2
	var tile_size





















	if (game_col >= max_columns || game_row >= max_rows):
		var sq1 = 18.0 / float(game_col)
		var sq2 = 12.0 / float(game_row)
		if (sq1 < sq2): shrink_quotient = sq1
		else: shrink_quotient = sq2


		shrink_base = shrink_max / shrink_quotient
		max_columns = int($SVC / SV / BGContainer.size.x / (shrink_quotient * 64)) + 2
		max_rows = int($SVC / SV / BGContainer.size.y / (shrink_quotient * 64)) + 2



	if ((game_col % 2) != (max_columns % 2)):
		max_columns += 1
	if ((game_row % 2) != (max_rows % 2)):
		max_rows += 1
	$SVC / SV / BGContainer / BackGround.set_columns(max_columns)

	if ( !Main.challenge):
		for i in range(max_columns):
			for j in range(max_rows):
				bg = bg_tile.instantiate()
				bg.row_col = Vector2i(j, i)
				$SVC / SV / BGContainer / BackGround.add_child(bg)
	else:
		$SVC / SV / BGContainer / BackGround.queue_free()

	if (game_col > 18 || game_row > 12):
		scroller = true
		get_tree().call_group("tiles", "shrink", shrink_quotient)
		if ((Main.nine || nine_count > 0) && tile_size == 32.0):
			for nine in nine_mine_array:
				nine.shrink(0.5)

	else:
		scroller = false
		get_tree().call_group("touch_screen_buttons", "set_visible", false)
		camera.zoom = Vector2(1.0, 1.0)


	get_tree().call_group("anim", "play_anim", Main.game_style)

func blow_up_intro_mine(mine_number, speed) -> void :
	var node_pos = get_node("HUD/IntroMineControl/IntroMine" + mine_number).get_position()[0]
	while ($NineMineTemp.position[0] < node_pos):
		await get_tree().create_timer(0.001).timeout
		$NineMineTemp.position[0] += speed
		if (dual_boss):
			$NineMineTemp2.position[0] -= speed

	get_node("HUD/IntroMineControl/IntroMine" + mine_number).play("explosion")
	game_board.get_node("ExplosionSound").play()
	shake_screen(4, 0.64)


func _eleven_intro() -> void :
	if (Main.db["eleven_seen"]):
		$SkipButton.visible = true
	Main.db["eleven_seen"] = true
	get_tree().call_group("music", "stop")
	Main.game_bgm = 11
	get_node("11/11Intro").play()
	face.play("faceN_2")
	if ( !skip_intro): await get_tree().create_timer(3).timeout
	face.play("faceN_3")
	hat.play("hat" + hat_type + "_nod")

	var delta
	while ($HUDArea.modulate[3] < 1):
		delta = get_process_delta_time()
		$HUDArea.modulate[3] += delta / 3
		get_tree().call_group("mouse_areas", "set_modulate", $HUDArea.modulate)
		if ( !skip_intro): await get_tree().create_timer(delta * 2).timeout
	if ( !skip_intro): await get_tree().create_timer(3).timeout
	game_board.cover_tile(Vector2i(game_row / 2, game_col / 2))
	eleven_mine.visible = true
	eleven_mine.scale = Vector2(3, 3)
	eleven_mine.ac = get_process_delta_time()

	if (dual_boss):
		eleven_mine2.visible = true
		eleven_mine2.scale = Vector2(3, 3)
		eleven_mine2.ac = - get_process_delta_time()
		game_board.eleven_position[0] = Vector2i((game_col / 2), game_row / 2 - 5)
		game_board.eleven_position[1] = Vector2i((game_col / 2), game_row / 2 + 5)
		eleven_mine.position = game_board.position + game_board.get_eleven_position(0)
		eleven_mine2.position = game_board.position + game_board.get_eleven_position(1)
	else:
		eleven_mine.position = game_board.position + game_board.get_eleven_position(0)

	game_board.fancy_theme_change(11, 3, true)
	get_tree().call_group("mouse_areas", "set_modulate", Color(0, 0, 0, 0))
	face.play("faceN_4_1")
	hat.play("hat" + hat_type + "_l")
	if ( !skip_intro): await get_tree().create_timer(2).timeout
	face.play("faceN_4_2")
	hat.play("hat" + hat_type + "_r")

	while ($HUDArea.modulate[3] < 1):
		delta = get_process_delta_time()
		$HUDArea.modulate[3] += delta / 3
		get_tree().call_group("mouse_areas", "set_modulate", $HUDArea.modulate)
		if ( !skip_intro): await get_tree().create_timer(delta * 2).timeout
	if ( !skip_intro): await get_tree().create_timer(2.4).timeout
	$HUD / FacePanel / TimerGauge.start()

	eleven_mine.set_scale(Vector2(eleven_mine.shrink_save, eleven_mine.shrink_save))
	eleven_mine.ac = 0
	eleven_mine.ro = 0
	eleven_mine.rotation = 0

	if (dual_boss):
		eleven_mine2.set_scale(Vector2(eleven_mine.shrink_save, eleven_mine.shrink_save))
		eleven_mine2.ac = 0
		eleven_mine2.ro = 0
		eleven_mine2.rotation = 0

	get_tree().call_group("mouse_areas", "set_modulate", Color(0, 0, 0, 0))
	face.play("faceN_5")
	hat.play("hat" + hat_type + "_f")

	if ( !skip_intro): await get_tree().create_timer(1).timeout

	face.play("faceN_6")
	game_board.flag_tile(game_board.get_eleven_coordinates(0))
	if (dual_boss): game_board.flag_tile(game_board.get_eleven_coordinates(1))
	if ( !skip_intro):
		eleven_mine.slow_open()
		if (dual_boss): eleven_mine2.slow_open()

	if ( !skip_intro): await get_tree().create_timer(3).timeout
	face.play("faceN_7")

	var good
	var randx
	var randy
	if ( !skip_intro):
		if (dual_boss): eleven_mine2.vanish()
		await eleven_mine.vanish()
	face.play("faceN_8")
	hat.set_animation("hat" + hat_type + "_popeyes")
	hat.set_frame(0)
	hat.flip_h = true
	if (dual_boss): eleven_mine2.barrage_now = true
	eleven_mine.barrage_now = true
	for i in range(10):
		if (i % 2 == 0): $HUD / MineCounter.set_modulate(Color(1, 0.5, 0.5, 1))
		else: $HUD / MineCounter.set_modulate(Color(1, 1, 1, 1))

		if (dual_boss):
			if ( !skip_intro): eleven_mine2.ro *= -1
			good = false
			while ( !good):
				randx = randi() % game_row
				randy = randi() % game_col
				if (game_board.tile_array[randx][randy].enabled && !game_board.tile_array[randx][randy].flagged):
					good = true
			game_board.eleven_position[1] = Vector2i(randx, randy)
			eleven_mine2.position = game_board.get_eleven_position(1)
			eleven_mine2.close(true)
			game_board.flag_tile(game_board.get_eleven_coordinates(1))
			if ( !skip_intro): eleven_mine2.barrage_open()

		if ( !skip_intro): eleven_mine.ro *= -1
		good = false
		while ( !good):
			randx = randi() % game_row
			randy = randi() % game_col
			if (game_board.tile_array[randx][randy].enabled && !game_board.tile_array[randx][randy].flagged):
				good = true
		game_board.eleven_position[0] = Vector2i(randx, randy)
		eleven_mine.position = game_board.get_eleven_position(0)
		eleven_mine.close(true)
		game_board.flag_tile(game_board.get_eleven_coordinates(0))
		if ( !skip_intro): await eleven_mine.barrage_open()




	$HUD / MineCounter.set_modulate(Color(1, 0.5, 0.5, 1))
	if (dual_boss): eleven_mine2.barrage_now = false
	eleven_mine.barrage_now = false

	if (dual_boss):
		game_board.eleven_position[0] = Vector2i((game_col / 2), (game_row / 2) - 5)
		game_board.eleven_position[1] = Vector2i((game_col / 2), (game_row / 2) + 5)
		eleven_mine2.position = game_board.position + game_board.get_eleven_position(1)
		eleven_mine2.close(true)
		eleven_mine2.ro = 0
		eleven_mine2.rotation = 0
	else:
		game_board.eleven_position[0] = Vector2i((game_row / 2), (game_col / 2))
	eleven_mine.position = game_board.get_eleven_position(0)
	eleven_mine.close(true)
	eleven_mine.ro = 0
	eleven_mine.rotation = 0
	if ( !skip_intro):
		if (dual_boss): eleven_mine2.appear()
		await eleven_mine.appear()
	if ( !skip_intro):
		if (dual_boss): eleven_mine2.reveal_teslas(false)
		await eleven_mine.reveal_teslas(false)
	if ( !skip_intro):
		if (dual_boss): eleven_mine2.electricity_on()
		eleven_mine.electricity_on()
	hat.flip_h = false
	face.play("face7_X0")
	hat.play("hat" + hat_type + "_hit")

	if ( !skip_intro): await get_tree().create_timer(1).timeout

	if ( !skip_intro):
		if (dual_boss): eleven_mine2.electricity_off()
		eleven_mine.electricity_off()
	hat.play("hat" + hat_type + "_f")
	face.play("faceN_9")
	if ( !skip_intro): await get_tree().create_timer(1).timeout
	if ( !skip_intro):
		if (dual_boss): eleven_mine2.hide_teslas(false)
		await eleven_mine.hide_teslas(false)
	if ( !skip_intro): await get_tree().create_timer(0.5).timeout
	face.play("faceN_10")
	hat.play("hat" + hat_type + "T_9")
	if ( !skip_intro): await get_tree().create_timer(1).timeout
	face.play("faceN_11")
	hat.play("hat" + hat_type + "_nod")
	eleven_mine.ro = 1
	if (dual_boss): eleven_mine2.ro = -1

	now_ready = true
	$SkipButton.visible = false
	$MessageLabel.visible = true
	$MessageLabel.text = "READY..."
	eleven_mine.reveal_teslas(false)
	if (dual_boss): eleven_mine2.reveal_teslas(false)
	await get_tree().create_timer(3).timeout
	$MessageLabel.visible = false
	eleven_mine.get_node("Button1").set_disabled(false)
	eleven_mine.get_node("Button2").set_disabled(false)

	face_on = true

	get_tree().call_group("tiles", "set_disabled", false)

	if ( !Main.db["stop_showing2"]):
		var warning = load("res://9_warning.tscn")
		var popup = warning.instantiate()
		add_child(popup)




func _ten_intro() -> void :
	if (Main.db["ten_seen"] == true):
		$SkipButton.visible = true
	Main.db["ten_seen"] = true
	get_tree().call_group("music", "stop")
	Main.game_bgm = 10
	get_node("10/10Intro").play()
	if ( !skip_intro): await get_tree().create_timer(1).timeout
	face.play("faceE_2")
	face.set_frame(3)
	hat.play("hat" + hat_type + "_f")

	if ( !skip_intro): await get_tree().create_timer(2).timeout


	if ( !dual_boss):
		ten_mine.position = Vector2($SVC.size.x / 2, $SVC.size.y / 2 + 192)
	else:
		ten_mine.position = Vector2(($SVC.size.x / 2) - 192, $SVC.size.y / 2 + 192)
		ten_mine2.position = Vector2(($SVC.size.x / 2) + 192, $SVC.size.y / 2 + 192)

	for ten in ten_mine_array:
		ten.get_node("Button").scale = Vector2(11.0, 11.0)
		ten.modulate = Color(1, 1, 1, 0)
		ten.visible = true
	var d
	while ten_mine.get_node("Button").scale.x > 1.0:
		d = get_process_delta_time()
		ten_mine.modulate[3] += d
		ten_mine.get_node("Button").scale -= Vector2(d * 6, d * 6)
		if (dual_boss):
			ten_mine2.modulate[3] = ten_mine.modulate[3]
			ten_mine2.get_node("Button").scale = ten_mine.get_node("Button").scale
		if ( !skip_intro): await get_tree().create_timer(0.005).timeout
	for ten in ten_mine_array:
		ten.modulate[3] = 1
		ten.get_node("Button").scale = Vector2(1.0, 1.0)

	game_board.cover_tile(Vector2i(game_row / 2, game_col / 2))
	face.play("faceT_2")
	if ( !skip_intro): await get_tree().create_timer(2).timeout
	face.play("faceT_3")

	for ten in ten_mine_array:
		ten.go = true
		ten.piston_frequency = 0.01
		ten.beep = true
	if ( !skip_intro): await get_tree().create_timer(1).timeout

	for ten in ten_mine_array:
		ten.direction = randf_range( - PI / 4, PI / 4)
		ten.v = Vector2(3000, 0)
		ten.set_linear_velocity(ten.v.rotated(ten.direction))

	if ( !skip_intro): shake_screen(8, 3)
	var faceT4 = 0
	var intro_mines = 10
	game_board.cool_theme_change(10, 5, skip_intro)
	while (intro_mines > 0 && !skip_intro):
		var ten_ex = ten_explosion.instantiate()
		add_child(ten_ex)
		ten_ex.position = ten_mine.position
		ten_ex.scale = Vector2(8, 8)
		ten_ex.play("explosion")
		$SVC / SV / Game / ExplosionSound.play()
		face.play("faceT_4_" + var_to_str(faceT4 + 1))
		hat.play("hat" + hat_type + "T_4_" + var_to_str(faceT4 + 1))
		faceT4 = (faceT4 + 1) % 2
		intro_mines -= 1
		if ( !skip_intro): await get_tree().create_timer(0.25).timeout
		if (dual_boss):
			ten_ex = ten_explosion.instantiate()
			add_child(ten_ex)
			ten_ex.position = ten_mine2.position
			ten_ex.scale = Vector2(8, 8)
			ten_ex.play("explosion")
			$SVC / SV / Game / ExplosionSound.play()
			face.play("faceT_4_" + var_to_str(faceT4 + 1))
			hat.play("hat" + hat_type + "T_4_" + var_to_str(faceT4 + 1))
			faceT4 = (faceT4 + 1) % 2
		if ( !skip_intro): await get_tree().create_timer(0.25).timeout


	$HUD / MineCounter / Timer.start()
	$HUD / FacePanel / TimerGauge.start()

	for ten in ten_mine_array:
		ten.beep = false
		ten.piston_frequency = 0.25
		ten.v = Vector2(0, 0)
		ten.set_linear_velocity(Vector2(0, 0))
	face.play("faceT_5")
	hat.play("hat" + hat_type + "T_5")

	var goal_pos
	var goal_pos2
	if !dual_boss: goal_pos = Vector2($SVC.size.x / 2, $SVC.size.y / 2 + 192)
	else:
		goal_pos = Vector2($SVC.size.x / 2 - 192, $SVC.size.y / 2 + 192)
		goal_pos2 = Vector2($SVC.size.x / 2 + 192, $SVC.size.y / 2 + 192)

	while (ten_mine.position.x > goal_pos.x + 0.1 || ten_mine.position.y > goal_pos.y + 0.1 || 
	ten_mine.position.x < goal_pos.x - 0.1 || ten_mine.position.y < goal_pos.y - 0.1):
		ten_mine.position += - (ten_mine.position - goal_pos) / 10
		if dual_boss:
			ten_mine2.position += - (ten_mine2.position - goal_pos2) / 10
		if ( !skip_intro): await get_tree().create_timer(0.01).timeout

	if !dual_boss: ten_mine.position = Vector2($SVC.size.x / 2, $SVC.size.y / 2 + 192)
	else:
		ten_mine.position = Vector2($SVC.size.x / 2 - 192, $SVC.size.y / 2 + 192)
		ten_mine2.position = Vector2($SVC.size.x / 2 + 192, $SVC.size.y / 2 + 192)

	if ( !skip_intro): await get_tree().create_timer(1).timeout
	face.play("faceT_6")
	hat.play("hat" + hat_type + "T_6")
	if ( !skip_intro): await get_tree().create_timer(2).timeout
	face.play("faceT_7_1")
	hat.play("hat" + hat_type + "T_7_1")
	if ( !skip_intro): await get_tree().create_timer(0.3).timeout
	face.play("faceT_7_2")
	hat.play("hat" + hat_type + "T_7_2")


	$SkipButton.visible = false
	$MessageLabel.visible = true
	$MessageLabel.text = "READY..."
	await get_tree().create_timer(3).timeout
	$MessageLabel.visible = false
	ten_mine.get_node("Button").set_disabled(false)
	if (dual_boss): ten_mine2.get_node("Button").set_disabled(false)
	face_on = true



	get_tree().call_group("tiles", "set_disabled", false)

	if ( !Main.db["stop_showing2"]):
		var warning = load("res://9_warning.tscn")
		var popup = warning.instantiate()
		add_child(popup)


func _nine_intro() -> void :
	if (Main.db["nine_seen"] == true):
		$SkipButton.visible = true
	Main.db["nine_seen"] = true
	get_tree().call_group("music", "stop")
	Main.game_bgm = 9
	get_node("9/9Intro").play()


	$NineMineTemp.shrink(1 / shrink_quotient)
	if ( !skip_intro): await get_tree().create_timer(1).timeout
	face.play("faceE_2")
	hat.play("hat" + hat_type + "_fv2")
	if ( !skip_intro): await get_tree().create_timer(3).timeout
	var frame = 4

	nine_mine.get_node("Body").set_visible(true)
	if (dual_boss):
		game_board.nine_position[0] = Vector2i(game_row / 2, game_col / 2)
		nine_mine2.get_node("Body").frame = 4
		nine_mine2.get_node("Body/Spikes").visible = false
		nine_mine2.get_node("Body/Spikes").scale = Vector2(0.5, 0.5)
		nine_mine2.get_node("MoveTimer").wait_time = 0.55
		nine_mine2.visible = true
	nine_mine.position = game_board.position + game_board.get_nine_position(0)


	if ( !skip_intro): get_node("9/Emerge").play()
	while frame != 0:
		if ( !skip_intro): await get_tree().create_timer(0.5).timeout
		frame -= 1
		nine_mine.get_node("Body").frame = frame

	if ( !skip_intro): await get_tree().create_timer(1).timeout
	nine_mine.get_node("Body/Spikes").set_visible(true)
	face.play("faceE_3")


	if ( !skip_intro): get_node("9/Spikes").play()
	while (nine_mine.get_node("Body/Spikes").scale[0] < 1.0):
		if ( !skip_intro): await get_tree().create_timer(0.01).timeout
		nine_mine.get_node("Body/Spikes").scale += Vector2(5 * get_process_delta_time(), 5 * get_process_delta_time())
	nine_mine.get_node("Body/Spikes").scale = Vector2(1.0, 1.0)

	if ( !skip_intro): await get_tree().create_timer(1).timeout
	game_board.fancy_theme_change(9, 3, skip_intro)

	if (dual_boss):
		game_board.cover_tile(Vector2i(game_row / 2, game_col / 2))


	nine_mine.delta_multiplier = 0.1
	if ( !skip_intro): get_node("9/Spin").play()
	for i in range(int(1.6 / get_process_delta_time())):
		if ( !skip_intro): await get_tree().create_timer(0.01).timeout
		nine_mine.delta_multiplier *= 1.1 + get_process_delta_time()

	for n in nine_mine_temp_array:
		get_node(n + "/Body").frame = nine_mine.get_node("Body").frame
		get_node(n + "/Body/Spikes").visible = true
		get_node(n + "/Body/Spikes").scale = Vector2(1.0, 1.0)
		get_node(n).delta_multiplier = nine_mine.delta_multiplier

	var speed = 60 * get_process_delta_time()

	if ( !skip_intro): get_node("9/Saw").play()
	while (nine_mine.position[0] < 1200):
		if ( !skip_intro): await get_tree().create_timer(0.01).timeout
		nine_mine.position[0] += speed
		speed += 60 * get_process_delta_time()

	var out = nine_mine.position[0]
	out = ( - (out - 1152))





	face.play("face5_X0")
	hat.play("hat" + hat_type + "_hit")
	if ( !skip_intro): await blow_up_intro_mine("1", speed)
	$HUD / MineCounter / Timer.start()

	if ( !skip_intro): await blow_up_intro_mine("2", speed)
	$HUD / FacePanel / Radar.play("on")
	$HUD / FacePanel / Radar / RadarButton.set_modulate(Color(0.5, 0.5, 0.5, 0.5))

	if ( !skip_intro): await blow_up_intro_mine("3", speed)
	$HUD / FacePanel / TimerGauge.start()

	if ( !skip_intro): await blow_up_intro_mine("4", speed)
	$HUD / GameTimer.update_time()

	while ($NineMineTemp.position[0] < 1200):
		if ( !skip_intro): await get_tree().create_timer(0.01).timeout
		$NineMineTemp.position[0] += speed

	$NineMineTemp.set_visible(false)
	if (dual_boss):
		$NineMineTemp2.set_visible(false)
		game_board.nine_position[0] = Vector2i(1, 1)
		game_board.nine_position[1] = Vector2i(game_row - 2, game_col - 2)
		nine_mine.set_position(Vector2(out, game_board.position[1] + game_board.get_nine_position(0)[1]))
		nine_mine2.set_position(Vector2( - out + 1152, game_board.position[1] + game_board.get_nine_position(1)[1]))
		nine_mine2.get_node("Body").frame = 0
		nine_mine2.get_node("Body/Spikes").scale = Vector2(1.0, 1.0)
		nine_mine2.get_node("Body").visible = true
		nine_mine2.get_node("Body/Spikes").visible = true
		game_board.un_preset_mines(Vector2i(game_row / 2, game_col / 2))
		game_board.preset_mines(game_board.nine_position[0])
		game_board.preset_mines(game_board.nine_position[1])
		nine_mine2.mine_number = 1
		nine_mine2.delta_multiplier = nine_mine.delta_multiplier
	else:
		nine_mine.set_position(Vector2(out, game_board.position[1] + game_board.get_nine_position(0)[1]))

	while (nine_mine.position[0] < game_board.get_nine_position(0)[0]):
		if ( !skip_intro): await get_tree().create_timer(0.01).timeout
		nine_mine.position[0] += speed
		if (dual_boss): nine_mine2.position[0] -= speed
		speed -= 10 * get_process_delta_time()

	nine_mine.position = game_board.position + game_board.get_nine_position(0)
	if (dual_boss):
		nine_mine2.position = game_board.position + game_board.get_nine_position(1)
		game_board.open_nine_tile(0)
		game_board.open_nine_tile(1)
		game_board.win_tiles -= 1

	for i in range(int(1.6 / get_process_delta_time())):
		if ( !skip_intro): await get_tree().create_timer(0.01).timeout
		nine_mine.delta_multiplier /= (1.1 + get_process_delta_time())
		if (dual_boss): nine_mine2.delta_multiplier /= (1.1 + get_process_delta_time())

	face.play("faceE_4")
	hat.play("hat" + hat_type + "_popeyes")

	for i in range(3):
		$HUD / GameTimer.set_modulate(Color(1, 0.5, 0.5, 1))
		if ( !skip_intro): await get_tree().create_timer(0.5).timeout
		$HUD / GameTimer.set_modulate(Color(1, 1, 1, 1))
		if ( !skip_intro): await get_tree().create_timer(0.5).timeout

	$HUD / GameTimer.set_modulate(Color(1, 0.5, 0.5, 1))

	face.play("faceE_5")
	hat.play("hat" + hat_type + "_f")

	get_tree().call_group("nine_intro_mines", "queue_free")

	$SkipButton.visible = false
	$MessageLabel.visible = true
	$MessageLabel.text = "READY..."
	await get_tree().create_timer(3).timeout
	$MessageLabel.visible = false
	face_on = true

	$HUD / IntroMineControl.queue_free()
	get_tree().call_group("tiles", "set_disabled", false)

	if ( !Main.db["stop_showing"]):
		var warning = load("res://9_warning.tscn")
		var popup = warning.instantiate()
		add_child(popup)

func _end_battle3(winner) -> void :
	if (game_board.no_more_opening == true): return
	game_board.no_more_opening = true
	for e in eleven_mine_array:
		e.call_deferred("stop")

	face_on = false

	if (nine_count > 0):
		get_node("9").stop()
		get_node("9/9Intro").stop()

	if (ten_count > 0):
		get_node("10").stop()
		get_node("10/10Intro").stop()

	get_node("HUD/GameTimer/Timer").paused = true
	get_tree().call_group("tiles", "set_disabled", true)
	get_node("11").stop()
	get_node("11/11Intro").stop()
	get_node("11/11_2").stop()
	get_node("9/Bell").play()

	if (winner):
		if (Main.eleven):
			face.play("faceN_12")
			hat.play("hat" + hat_type + "_nodv2")

		for eleven in eleven_mine_array:
			eleven.malfunction()
			Main.db["defeated_11"] += 1

		if (ten_count > 0):
			for ten in ten_mine_array:
				ten_fall(ten)
				if (nine_count == 0): Main.db["defeated_10"] += 1

		if (Main.eleven): await get_tree().create_timer(5).timeout
		game_board.end_game(winner)
	else:
		if (nine_count > 0):
			for nine in nine_mine_array:
				nine.get_node("WaitTimer").stop()
				nine.get_node("MoveTimer").stop()

		if (ten_count > 0):
			for ten in ten_mine_array:
				ten.stop()

		if (game_board.tiles_opened == 0):
			game_board.setup(Vector2i(game_row / 2, game_col / 2))
		game_board.get_node("MineSound").set_pitch_scale(2.0)
		game_board.get_node("MineSound").set_volume_db(10)

		if (Main.eleven || Main.adventure_mode):
			for x in range(int(0.5 / get_process_delta_time())):
				game_board.get_node("MineSound").play()
				for eleven in eleven_mine_array:
					eleven.modulate = Color(1, 0.5, 0.5, 1)
				await get_tree().create_timer(0.01).timeout
				for eleven in eleven_mine_array:
					eleven.modulate = Color(1, 1, 1, 1)
				await get_tree().create_timer(0.01).timeout

		game_board.get_node("MineSound").stop()
		game_board.get_node("MineSound").set_pitch_scale(1.0)

		get_tree().call_group("polygons", "set_color", Color(1, 1, 1, 1))
		$HUDArea / HUDRectangle5 / HUDPolygon5.set_color(Color(1, 1, 1, 1))

		get_node("9/Explosion").play()
		while ($HUDArea.modulate[3] < 1.0 && Main.db["flashing_lights"]):
			await get_tree().create_timer(0.01).timeout
			get_tree().call_group("mouse_areas", "set_modulate", $HUDArea.modulate + Color(get_process_delta_time() * 3, get_process_delta_time() * 3, get_process_delta_time() * 3, get_process_delta_time() * 3))

		for eleven in eleven_mine_array:
			if eleven.get_node("WaitTimer").is_stopped():
				eleven.visible = false
		if dual_boss: eleven_mine2.visible = false
		$BackDrop.frame = 11
		$BackDrop.visible = true
		if (Main.eleven): await get_tree().create_timer(1).timeout

		$MessageLabel.visible = false
		shake_screen(8, 3)

		game_board.highlight_missed_tiles()

		game_board.end_game(winner)
		if (Main.eleven):
			face.play("face7_X(2")
			hat.play("hat" + hat_type + "_deadfall2")
		while ($HUDArea.modulate[3] > 0.0):
			await get_tree().create_timer(0.01).timeout
			get_tree().call_group("mouse_areas", "set_modulate", $HUDArea.modulate - Color(get_process_delta_time(), get_process_delta_time(), get_process_delta_time(), get_process_delta_time()))

		get_tree().call_group("polygons", "set_color", Color(0, 0, 0, 1))
		if (Main.eleven):
			await get_tree().create_timer(1).timeout


func _end_battle2(winner) -> void :
	game_board.no_more_opening = true
	ten_position_save = ten_mine_array[0].position
	if (dual_boss): ten_position_save2 = ten_mine2.position

	for ten in ten_mine_array:
		ten.get_node("Button").set_disabled(true)
		ten.set_linear_velocity(Vector2(0, 0))
		ten.dial = false
		ten.stop()
	face_on = false
	get_node("HUD/GameTimer/Timer").paused = true
	get_tree().call_group("tiles", "set_disabled", true)
	get_node("10").stop()
	get_node("10/10Intro").stop()
	get_node("9/Bell").play()
	if (nine_count > 0):
		get_node("9").stop()
		get_node("9/9Intro").stop()

	if (eleven_count > 0):
		for eleven in eleven_mine_array:
			eleven.stop()


		get_node("11").stop()
		get_node("11/11Intro").stop()
		get_node("11/11_2").stop()

	if (winner):

		Main.db["defeated_10"] += 1

		for ten in ten_mine_array:
			ten.get_node("Button/Light").color = Color(1, 1, 1, 1)
			ten.get_node("Button/MineBody/Number").frame = 10
			ten.go = false
		if (Main.ten):
			face.play("faceT_8")
			hat.play("hat" + hat_type + "T_8")
			await get_tree().create_timer(3).timeout

		if (eleven_count > 0):
			for eleven in eleven_mine_array:
				eleven.malfunction()

		if (dual_boss):
			ten_fall(ten_mine)
			await ten_fall(ten_mine2)
		else:
			if (Main.ten):




				await (ten_fall(ten_mine))
			else:
				for t in ten_mine_array:
					ten_fall(t)

		if (Main.ten && !Main.nine):
			await get_tree().create_timer(1).timeout
			face.play("faceT_9")
			hat.play("hat" + hat_type + "T_9")
			await get_tree().create_timer(1).timeout
		if ( !nine_count > 0 && !Main.nine): game_board.end_game(winner)

	else:

		if (nine_count > 0):
			for nine in nine_mine_array:
				nine.get_node("WaitTimer").stop()
				nine.get_node("MoveTimer").stop()

		Main.db["mistakes"] += 1
		if (Main.ten):
			face.play("faceT_8")
			hat.play("hat" + hat_type + "T_8")

		if ( !game_board.already_setup):
			game_board.setup(Vector2i(game_row / 2, game_col / 2))
		game_board.get_node("MineSound").set_pitch_scale(2.0)
		game_board.get_node("MineSound").set_volume_db(10)

		if (Main.ten):
			for x in range(int(0.5 / get_process_delta_time())):
				game_board.get_node("MineSound").play()
				for ten in ten_mine_array:
					ten.modulate = Color(1, 0.5, 0.5, 1)
				await get_tree().create_timer(0.01).timeout
				for ten in ten_mine_array:
					ten.modulate = Color(1, 1, 1, 1)
				await get_tree().create_timer(0.01).timeout

		game_board.get_node("MineSound").stop()
		game_board.get_node("MineSound").set_pitch_scale(1.0)

		get_tree().call_group("polygons", "set_color", Color(1, 1, 1, 1))
		$HUDArea / HUDRectangle5 / HUDPolygon5.set_color(Color(1, 1, 1, 1))

		get_node("9/Explosion").play()
		while ($HUDArea.modulate[3] < 1.0 && Main.db["flashing_lights"]):
			await get_tree().create_timer(0.01).timeout
			get_tree().call_group("mouse_areas", "set_modulate", $HUDArea.modulate + Color(get_process_delta_time() * 3, get_process_delta_time() * 3, get_process_delta_time() * 3, get_process_delta_time() * 3))

		for ten in ten_mine_array:
			if ten.get_node("Timer").is_stopped():
				ten.visible = false

		$BackDrop.frame = 10
		$BackDrop.visible = true
		if (Main.ten): await get_tree().create_timer(1).timeout

		$MessageLabel.visible = false
		shake_screen(8, 3)

		game_board.highlight_missed_tiles()

		game_board.end_game(winner)
		if (Main.ten):
			face.play("face6_X(2")
			hat.play("hat" + hat_type + "_deadfall")
		while ($HUDArea.modulate[3] > 0.0):
			await get_tree().create_timer(0.01).timeout
			get_tree().call_group("mouse_areas", "set_modulate", $HUDArea.modulate - Color(get_process_delta_time(), get_process_delta_time(), get_process_delta_time(), get_process_delta_time()))

		get_tree().call_group("polygons", "set_color", Color(0, 0, 0, 1))
		if ( !Main.ten):
			await get_tree().create_timer(1).timeout


func _end_battle(pressed, wait_time) -> void :
	game_board.no_more_opening = true
	face_on = false
	get_node("HUD/GameTimer")._start_timer(false)
	get_tree().call_group("tiles", "set_disabled", true)
	for nine in nine_mine_array:
		nine.set_disabled(true)
		nine.get_node("MoveTimer").stop()
		nine.get_node("WaitTimer").stop()




	get_node("9").stop()
	get_node("9/9Intro").stop()
	get_node("9/Bell").play()

	if (ten_count > 0):
		for ten in ten_mine_array:
			ten.stop()


		get_node("10").stop()
		get_node("10/10Intro").stop()

	if (eleven_count > 0):
		for eleven in eleven_mine_array:
			eleven.stop()


		get_node("11").stop()
		get_node("11/11Intro").stop()
		get_node("11/11_2").stop()

	if (Main.nine):
		while (pressed && (nine_mine.delta_multiplier < - 0.01 || nine_mine.delta_multiplier > 0.01)):
			await get_tree().create_timer(0.01).timeout
			for nine in nine_mine_array:
				nine.delta_multiplier *= (0.9 - get_process_delta_time())
		for nine in nine_mine_array:
			nine.delta_multiplier = 0

	await get_tree().create_timer(wait_time).timeout
	if ( !pressed): game_board.nine_win_flag = false

	if (game_board.nine_win_flag || (game_board.win_tiles == game_board.tiles_opened && !game_board.already_setup)):

		for nine in nine_mine_array:
			Main.db["defeated_9"] += 1

		if (ten_count > 0):
			for ten in ten_mine_array:
				Main.db["defeated_10"] += 1
				ten.get_node("Button/Light").color = Color(1, 1, 1, 1)
				ten.get_node("Button/MineBody/Number").frame = 10
				ten_fall(ten)

		if (eleven_count > 0):
			for eleven in eleven_mine_array:
				Main.db["defeated_11"] += 1
				eleven.malfunction()




		if (Main.nine):
			face.play("faceE_2")
			face.set_frame(3)
			hat.play("hat" + hat_type + "_f")
		game_board.set_nine_icon("0")

		get_node("9/Spikes").play()
		while (nine_mine_array[0].get_node("Body/Spikes").scale[0] > 0.5):
			await get_tree().create_timer(0.01).timeout
			for nine in nine_mine_array:
				nine.get_node("Body/Spikes").scale -= Vector2(5 * get_process_delta_time(), 5 * get_process_delta_time())
		if (Main.nine):
			await get_tree().create_timer(1).timeout

		get_node("9/Defeat").play()
		while (nine_mine_array[0].get_node("Body").scale[0] > 0.15 * shrink_quotient):
			for nine in nine_mine_array:
				nine.get_node("Body").scale -= Vector2(get_process_delta_time(), get_process_delta_time())
			await get_tree().create_timer(0.01).timeout

		if (dual_boss && !Main.ten):
			game_board.victory_flag(0)
			await game_board.victory_flag(1)
		else:
			var last_one = 0
			for i in range(nine_mine_array.size() - 1):
				game_board.victory_flag(i)
				last_one += 1
			await game_board.victory_flag(last_one)

		for nine in nine_mine_array:
			nine.visible = false
		game_board.end_game(true)
	else:

		if (Main.nine && !Main.level_select):
			Main.db["mistakes"] += 1
			face.play("faceE_5")
			hat.play("hat" + hat_type + "_f")

		if (game_board.tiles_opened == 0):
			game_board.setup(Vector2i(game_row / 2, game_col / 2))
			game_board.get_node("MineSound").set_pitch_scale(2.0)
			game_board.get_node("MineSound").set_volume_db(10)

		for x in range(int(0.5 / get_process_delta_time())):
			game_board.get_node("MineSound").play()
			for nine in nine_mine_array:
				nine.modulate = Color(1, 0.5, 0.5, 1)
			await get_tree().create_timer(0.01).timeout
			for nine in nine_mine_array:
				nine.modulate = Color(1, 1, 1, 1)
			await get_tree().create_timer(0.01).timeout

		game_board.get_node("MineSound").stop()
		game_board.get_node("MineSound").set_pitch_scale(1.0)

		get_tree().call_group("polygons", "set_color", Color(1, 1, 1, 1))
		$HUDArea / HUDRectangle5 / HUDPolygon5.set_color(Color(1, 1, 1, 1))

		get_node("9/Explosion").play()
		while ($HUDArea.modulate[3] < 1.0 && Main.db["flashing_lights"]):
			await get_tree().create_timer(0.01).timeout
			get_tree().call_group("mouse_areas", "set_modulate", $HUDArea.modulate + Color(get_process_delta_time() * 3, get_process_delta_time() * 3, get_process_delta_time() * 3, get_process_delta_time() * 3))

		if (Main.nine):
			for nine in nine_mine_array:
				nine.queue_free()
		else:
			for nine in nine_mine_array:
				nine.visible = false
		$BackDrop.frame = 9
		$BackDrop.visible = true
		if ( !nine_count > 0): await get_tree().create_timer(1).timeout

		game_board.end_game(false)
		$MessageLabel.visible = false
		shake_screen(8, 3)

		game_board.highlight_missed_tiles()

		if (ten_count > 0):
			for ten in ten_mine_array:
				ten.set_visible(false)



		while ($HUDArea.modulate[3] > 0.0):
			await get_tree().create_timer(0.01).timeout
			get_tree().call_group("mouse_areas", "set_modulate", $HUDArea.modulate - Color(get_process_delta_time(), get_process_delta_time(), get_process_delta_time(), get_process_delta_time()))

		get_tree().call_group("polygons", "set_color", Color(0, 0, 0, 1))


func ten_fall(ten_node) -> void :
	var fall_distance = get_process_delta_time() * 6
	while (ten_node.position.y < 1200):
		ten_node.position.y += fall_distance
		fall_distance += (get_process_delta_time() * 6)
		await get_tree().create_timer(get_process_delta_time()).timeout
		ten_node.get_node("Button/MineBody").rotation += 0.01
		ten_node.get_node("Button/Piston1").rotation -= 0.01
		ten_node.get_node("Button/Piston1").position.y += fall_distance
		ten_node.get_node("Button/Piston2").rotation -= 0.01
		ten_node.get_node("Button/Piston2").position.y += fall_distance * 2
		ten_node.get_node("Button/Piston3").rotation -= 0.01
		ten_node.get_node("Button/Piston3").position.y += fall_distance * 3
		ten_node.get_node("Button/Piston4").rotation -= 0.01
		ten_node.get_node("Button/Piston4").position.y += fall_distance * 4
		ten_node.get_node("Button/Piston5").rotation -= 0.01
		ten_node.get_node("Button/Piston5").position.y += fall_distance * 5

func _load_nine_movement_array(mine_id, direction, distance) -> void :
	nine_movement_array.append(Vector4i(mine_id, direction, distance, 0))

func _move_eleven(id, move) -> void :
	var good = false
	var randx
	var randy
	while ( !good):
		randx = randi() % game_row
		randy = randi() % game_col
		if (game_board.tile_array[randx][randy].enabled
		&& !game_board.tile_array[randx][randy].open
		&& !game_board.tile_array[randx][randy].flagged):
			good = true
	game_board.eleven_position[id] = Vector2i(randx, randy)
	eleven_mine_array[id].position = game_board.get_eleven_position(id)
	eleven_mine_array[id].set_visible(true)

	if (move == 0):
		eleven_mine_array[id].okay_to_click = false
		eleven_mine_array[id].reveal_teslas(false)
	else:
		eleven_mine_array[id].okay_to_click = true

	eleven_mine_array[id].stop_spinning(eleven_mine_array[id].speed)
	eleven_mine_array[id].turn_visible(eleven_mine_array[id].speed)
	eleven_mine_array[id].get_node("Button1").set_disabled(false)
	eleven_mine_array[id].get_node("Button2").set_disabled(false)

func _eleven_flag(id):
	var e_pos = game_board.get_eleven_coordinates(id)
	if ( !game_board.tile_array[e_pos[0]][e_pos[1]].open && !game_board.tile_array[e_pos[0]][e_pos[1]].flagged):
		game_board.flag_tile(e_pos)
	await eleven_mine_array[id].open(false)
	await eleven_mine_array[id].close(false)
	if (eleven_mine_array[id].start): eleven_mine_array[id].spin_out()

func _eleven_zap(id):
	eleven_mine_array[id].electricity_on()
	shake_screen(2, 1)
	face_on = false
	face.play("face" + face_type + "_X0")
	hat.play("hat" + hat_type + "_hit")
	game_board._flag_pass(true)
	await get_tree().create_timer(1).timeout
	face_on = true
	eleven_mine_array[id].electricity_off()
	if (eleven_mine_array[id].start): eleven_mine_array[id].spin_out()

func _eleven_barrage(id):
	var good
	var randx
	var randy
	var attempts
	while (eleven_mine_array[id].flags_left > 0 && eleven_mine_array[id].barrage_time == true):
		attempts = 0
		good = false
		while ( !good && attempts < 1000):
			randx = randi() % game_row
			randy = randi() % game_col
			if (game_board.tile_array[randx][randy].enabled
			&& !game_board.tile_array[randx][randy].open
			&& !game_board.tile_array[randx][randy].flagged):
				good = true
			else:
				attempts += 1
				if (attempts >= 1000):
					good = true
					eleven_mine_array[id].flags_left = 0
		if (eleven_mine_array[id].flags_left > 0):
			game_board.eleven_position[id] = Vector2i(randx, randy)
			eleven_mine_array[id].position = game_board.get_eleven_position(id)
			game_board.flag_tile(game_board.get_eleven_coordinates(id))
			await eleven_mine_array[id].barrage_open()
			eleven_mine_array[id].flags_left -= 1
	if ( !eleven_mine_array[id].barrage_time): eleven_mine_array[id].ro = 0
	else: eleven_mine_array[id].ro = (randi() % 50) - 25
	eleven_mine_array[id].barrage_time = false
	eleven_mine_array[id].barrage_now = false
	eleven_mine_array[id].get_node("WaitTimer").paused = false


func _move_nine() -> void :
	var nine_process = nine_movement_array[0]
	var pos_9 = game_board.get_nine_coordinates(nine_process[0])
	var pair
	var new_pos_9
	var did_not_move = false
	if (nine_process[2] < 0):
		if (nine_process[1] == 0):
			var go = randi() % 10
			if (go == 9):
				nine_mine.delta_multiplier = 5
				await get_tree().create_timer(1).timeout
				game_board.shuffle_board()
				nine_mine.delta_multiplier = 1
				nine_mine.set_wait_time(1)
			else:
				nine_mine.set_wait_time(0.01)

		else:

			if (nine_process[1] == 1):
				pair = 1
				if (pos_9[pair] != 1): new_pos_9 = (randi() % (pos_9[pair] - 1)) + 1
				else: new_pos_9 = 1

			elif (nine_process[1] == 2):
				pair = 0
				if (pos_9[pair] != 1): new_pos_9 = (randi() % (pos_9[pair] - 1)) + 1
				else: new_pos_9 = 1

			elif (nine_process[1] == 3):
				pair = 1
				if (pos_9[pair] != game_col - 2): new_pos_9 = (pos_9[pair] + 1) + (randi() % ((game_col - 2) - pos_9[pair]))
				else: new_pos_9 = game_col - 2

			elif (nine_process[1] == 4):
				pair = 0
				if (pos_9[pair] != game_row - 2): new_pos_9 = (pos_9[pair] + 1) + (randi() % ((game_row - 2) - pos_9[pair]))
				else: new_pos_9 = game_row - 2

			nine_process[2] = new_pos_9
	else:
		if (nine_process[1] == 1 || nine_process[1] == 3):
			pair = 1
		if (nine_process[1] == 2 || nine_process[1] == 4):
			pair = 0

	var check = abs(pos_9[pair] - nine_process[2])
	var stopped = false
	if ( !game_board.check_tile(nine_process[1], nine_process[0]) && nine_process[3] == 0):
		did_not_move = true


	if (check != 0 && !did_not_move):
		if (game_board.check_tile(nine_process[1], nine_process[0])):
			get_node("9/Move").play()
			shake_screen(1, 0.1)
			game_board.move_nine(nine_process[1], nine_process[0])
			nine_mine_array[nine_process[0]].position = game_board.position + game_board.get_nine_position(nine_process[0])
			nine_process[3] += 1
			nine_mine_array[nine_process[0]].get_node("WaitTimer").start()

		else:
			stopped = true

	if ( !did_not_move):
		if (check == 0 || stopped):
			if (nine_mine_array[nine_process[0]].delta_multiplier > 0): nine_mine_array[nine_process[0]].delta_multiplier += 0.1
			else: nine_mine_array[nine_process[0]].delta_multiplier -= 0.1

			nine_mine_array[nine_process[0]].set_wait_time(nine_process[3])

			if (nine_process[3] != 0):
				get_node("9/Stop").play()
				nine_mine_array[nine_process[0]].delta_multiplier *= -1
			nine_movement_array.pop_front()
			nine_mine_array[nine_process[0]].get_node("MoveTimer").start()
			nine_process[3] = 0.1
		else:
			nine_mine_array[nine_process[0]].get_node("WaitTimer").start()
			nine_movement_array.pop_front()
			nine_movement_array.append(nine_process)
	else:
		nine_movement_array.pop_front()
		nine_mine_array[nine_process[0]].set_wait_time(0.01)
		nine_mine_array[nine_process[0]].get_node("MoveTimer").start()




func _timer_start(time) -> void :
	get_node("HUD/GameTimer")._start_timer(time)
	if ( !Main.nine && !nine_count > 0):
		$HUD / FacePanel / Radar / RadarButton.set_disabled(false)

	if (time):
		if (Main.game_bgm == 9):
			get_node("9/9Intro").stop()
			get_node("9").play()
		for n in nine_mine_array:
			n.get_node("MoveTimer").start()


		if (Main.game_bgm == 10):
			get_node("10/10Intro").stop()
			if (get_node("10").playing == false): get_node("10").play()
		for t in ten_mine_array:
			t.dial = true
			t.get_node("Timer").start()

		if (Main.game_bgm == 11 && !get_node("11/11_2").playing):
			get_node("11/11Intro").stop()
			if (get_node("11").playing == false): get_node("11").play()
		for e in eleven_mine_array:
			e.spin_out()
			e.start = true


func _flag_update(flagged) -> void :
	get_node("HUD/MineCounter").on_tile_flagged(flagged)
	if (now_ready && !flagged && eleven_count > 0 && game_board.already_setup == false):
		for e in eleven_mine_array:
			_eleven_zap(e.number)
	if (eleven_count > 0 && game_board.flagged_tiles == (game_board.win_tiles - game_board.tiles_opened + game_board.mines) && !winner):
		_end_battle3(false)


func _face_update(face) -> void :
	expression = face

func _mistake_face() -> void :
	if (Main.nine || nine_count > 0):
		for nine in nine_mine_array:
			if (nine.get_node("WaitTimer").time_left > 0): nine.get_node("WaitTimer").paused = true
			if (nine.get_node("MoveTimer").time_left > 0): nine.get_node("MoveTimer").paused = true
	face_on = false
	$HUD / FacePanel / FaceButton.disabled = true
	get_tree().call_group("mouse_areas", "set_visible", false)

	if (face_type != "5" && face_type != "0"):
		if (area == 1):
			$HUD / FacePanel / FaceButton / Face.play("face" + face_type + "_:(l")
		elif (area == 2):
			$HUD / FacePanel / FaceButton / Face.play("face" + face_type + "_:(d")
		elif (area == 3):
			$HUD / FacePanel / FaceButton / Face.play("face" + face_type + "_:(r")
	elif (face_type == "0"):
		if (area == 1):
			face2.frame = 2
		elif (area == 2):
			face2.frame = 15
		elif (area == 3):
			face2.frame = 3

func _percent_update(g, m) -> void :
	$HUD / FacePanel.set_percentage(g, m)


func _face_press(face) -> void :
	_face_update(face)
	_on_hud_area_mouse_entered()




func _on_left_area_mouse_entered() -> void :
	area = 1
func _on_center_area_mouse_entered() -> void :
	area = 2
func _on_right_area_mouse_entered() -> void :
	area = 3
func _on_hud_area_mouse_entered() -> void :
	area = 0


func _mistake_update() -> void :
	if ( !nine_count > 0 && !ten_count > 0 && !eleven_count > 0):
		$HUD / FacePanel / FaceButton.disabled = false

	if (Main.eleven || eleven_count > 0):
		for eleven in eleven_mine_array:
			if (Main.db["adventure_shield"] <= 0):
				if ( !Main.db["master"]):
					if (Main.db["pursuit"] == 0): eleven.barrage_flags += 1
					else: eleven.barrage_flags += 2
				else:
					eleven.barrage_flags += 9999
			eleven.flags_left += eleven.barrage_flags
			eleven.barrage_time = true

	if (Main.ten || ten_count > 0):
		for ten in ten_mine_array:
			ten.reduce_time()

	if (Main.nine || nine_count > 0):
		for nine in nine_mine_array:
			if (nine.get_node("WaitTimer").time_left > 0): nine.get_node("WaitTimer").paused = false
			if (nine.get_node("MoveTimer").time_left > 0): nine.get_node("MoveTimer").paused = false

	if (Main.adventure_mode):
		if ($HUD / FacePanel / HealthGauge / ShieldGauge.frame > 0): $HUD / FacePanel / HealthGauge / ShieldGauge.frame -= 1
		Main.db["mistakes"] += 1
		if (nine_count > 0 || ten_count > 0 || eleven_count > 0):
			Main.db["nine_strikes"] += 1

	if ( !Main.nine && !nine_count > 0):
		if ( !Main.practice):
			if (Main.db["adventure_shield"] > 0 && Main.adventure_mode):
				Main.db["adventure_shield"] -= 1
			elif (Main.db["endless_shield"] > 0 && Main.endless):
				if ($HUD / FacePanel / HealthGauge / ShieldGauge.frame > 0): $HUD / FacePanel / HealthGauge / ShieldGauge.frame -= 1
				Main.db["endless_shield"] -= 1
			else:
				$HUD / FacePanel / HealthGauge.frame += 1
	else:
		$HUD / GameTimer.decrease_time()
		if (get_node("9").playing): get_node("9").pitch_scale += 1.0 / 12.0
		if (get_node("10").playing): get_node("10").pitch_scale += 1.0 / 12.0
		for n in nine_mine_array: n.delta_multiplier *= 2
		if (Main.db["adventure_shield"] > 0 && Main.adventure_mode):
			Main.db["adventure_shield"] -= 1

	shake_screen(4, 0.64)
	area = -1

	if (face_type != "0"):

		face.play("face" + face_type + "_X0")
		hat.play("hat" + hat_type + "_hit")
		await get_tree().create_timer(1).timeout
	else:
		face2.frame = 12
		await get_tree().create_timer(0.25).timeout
		face2.frame = 13
		await get_tree().create_timer(0.25).timeout
		face2.frame = 12
		await get_tree().create_timer(0.25).timeout
		face2.frame = 13
		await get_tree().create_timer(0.25).timeout
	face_on = true
	get_tree().call_group("mouse_areas", "set_visible", true)
	area = 0



func shake_screen(amount, time) -> void :
	if (Main.db["screen_shake"]):
		for i in range(time / 0.04):
			$Camera.set_position(Vector2(576 + amount, 480))
			await get_tree().create_timer(0.02).timeout
			$Camera.set_position(Vector2(576 - amount, 480))
			await get_tree().create_timer(0.02).timeout
		$Camera.set_position(Vector2(576, 480))


func _toggle_radar(op) -> void :
	var reward_node = $HUD / FacePanel / Radar / CoinLabel / CoinChange
	var coin
	if ( !Main.practice): reward_node.text = "-" + var_to_str(game_board.radar_price)

	if (Main.adventure_mode): coin = Main.db["current_coin"]
	elif (Main.challenge): coin = Main.challenge_coin
	elif (Main.endless): coin = Main.db["endless_last_coins"]
	else: coin = Main.db["total_coin"]



	if (coin > game_board.radar_price):
		get_tree().call_group("game_tiles", "activate_radar", op)
		if (reward_node.visible == false):
			reward_node.visible = true
		else:
			reward_node.visible = false
	else:
		$HUD / FacePanel / Radar.play("off")
		$HUD / FacePanel / Radar / RadarButton / OffOn.frame = ($HUD / FacePanel / Radar / RadarButton / OffOn.frame + 1) % 2
		var vis = false
		for i in range(9):
			vis = !vis
			reward_node.visible = vis
			await get_tree().create_timer(0.1).timeout
		await get_tree().create_timer(3).timeout
		reward_node.visible = false


func _radar_deac() -> void :
	$HUD / FacePanel._on_radar_button_toggled(true)

	if (Main.adventure_mode):
		Main.db["current_coin"] -= game_board.radar_price
		$HUD / FacePanel / Radar / CoinLabel.text = var_to_str(Main.db["current_coin"])
	elif (Main.challenge):
		Main.challenge_coin -= game_board.radar_price
		if (Main.challenge_coin < 9999):
			$HUD / FacePanel / Radar / CoinLabel.text = var_to_str(Main.challenge_coin)
		else:
			$HUD / FacePanel / Radar / CoinLabel.text = "9999"
	elif (Main.endless):
		Main.db["endless_last_coins"] -= game_board.radar_price
		if (Main.db["endless_last_coins"] < 9999):
			$HUD / FacePanel / Radar / CoinLabel.text = var_to_str(Main.db["endless_last_coins"])
		else:
			$HUD / FacePanel / Radar / CoinLabel.text = "9999"
	else:
		Main.db["total_coin"] -= game_board.radar_price
		if (Main.db["total_coin"] < 9999):
			$HUD / FacePanel / Radar / CoinLabel.text = var_to_str(Main.db["total_coin"])
		else:
			$HUD / FacePanel / Radar / CoinLabel.text = "9999"
	$HUD / FacePanel / Radar / CoinLabel / CoinChange.visible = false

func _challenge_coin_update() -> void :
	if (Main.challenge_coin < 9999):
		$HUD / FacePanel / Radar / CoinLabel.text = var_to_str(Main.challenge_coin)
	else:
		$HUD / FacePanel / Radar / CoinLabel.text = "9999"


func _game_over(win) -> void :
	game_over = true
	$HUD / MineCounter.game_over = true
	$HUD / MineCounter.flag_handicap = 0
	$HUD / MineCounter.flag_multiplier = 1
	$HUD / MineCounter.set_flags(0)
	winner = win
	game_board.reveal_board(win)
	get_tree().call_group("tiles", "set_disabled", true)
	get_tree().call_group("game_tiles", "set_mouse_filter", MOUSE_FILTER_IGNORE)
	$SVC.set_mouse_filter(MOUSE_FILTER_IGNORE)
	$HUD / FacePanel / Radar / RadarButton.set_disabled(true)
	$HUD / FacePanel / FaceButton.set_disabled(true)

	if win:

		Main.db["games_won"] += 1
		if (Main.db["master"]): Main.db["games_won_in_master_mode"] += 1

		get_tree().call_group("music", "stop")


		if (Main.game_bgm == 12):
			get_node("BGM12").play()
			get_node("Win12").play()
		if (Main.game_bgm == 11):

			get_node("11/Win11").play()
		elif (Main.game_bgm == 10):

			get_node("10/Win10").play()
		elif (Main.game_bgm == 9):

			get_node("9/Win9").play()
		elif (Main.game_bgm == 14):
			get_node("Win" + var_to_str(randbgm)).play()
		elif (Main.game_bgm < 13): get_node("Win" + var_to_str(Main.game_bgm)).play()

		game_board.get_node("Camera").set_zoom(Vector2(1.0, 1.0))
		face.play("face" + face_type + "_B)")
		if (face_type == "4"): hat.play("hat" + hat_type + "_nodv2")
		else: hat.play("hat" + hat_type + "_nod")
		if (Main.endless):
			Main.db["endless_last"] += 1
			$MessageLabel.text = stage_text + " " + var_to_str(Main.db["endless_last"]) + " " + clear_text
			$PauseMenu / PauseBackGround / Buttons / ResetButton / ResetLabel.text = continue_text
		else:
			$MessageLabel.text = clear_text
		$MessageLabel.visible = true

		var time = $HUD / GameTimer.get_time()
		if (Main.adventure_mode && save_time > 0.0):
			time += save_time
			if (Main.ten): Main.db["adventure_times"][9] = time
		save_time = time
		$MessageLabel / MessageBox / TimeLabel.text = Main.convert_time(time)
		if (Main.challenge):
			if ((time < Main.db["challenge_best"][Main.db["challenge_modifier"]][Main.db["challenge_difficulty"] - 1]) || (Main.db["challenge_best"][Main.db["challenge_modifier"]][Main.db["challenge_difficulty"] - 1] < 1)):
				Main.db["challenge_best"][Main.db["challenge_modifier"]][Main.db["challenge_difficulty"] - 1] = time
		if (Main.endless):
			if (Main.db["endless_last"] > Main.db["endless_best"][Main.db["endless_modifier"]][Main.db["endless_difficulty"]]):
				Main.db["endless_best"][Main.db["endless_modifier"]][Main.db["endless_difficulty"]] = Main.db["endless_last"]
			Main.build_next_endless_grid()
		$HUD / GameTimer.reset_timer()
		$MessageLabel / MessageBox / TimeLabel.visible = true

		var score = game_board.calculate_score()
		save_score = score
		Main.db["total_coins_collected"] += score

		if (Main.adventure_mode):
			Main.db["current_coin"] += score
			$HUD / FacePanel / Radar / CoinLabel.text = var_to_str(Main.db["current_coin"])
		elif (Main.endless):
			$PauseMenu / PauseBackGround / Buttons / ResetButton.visible = true
			Main.db["endless_last_coins"] += score
			$HUD / FacePanel / Radar / CoinLabel.text = var_to_str(Main.db["endless_last_coins"])
		else:
			Main.db["total_coin"] += score
			if (Main.db["total_coin"] < 9999):
				$HUD / FacePanel / Radar / CoinLabel.text = var_to_str(Main.db["total_coin"])
			else:
				$HUD / FacePanel / Radar / CoinLabel.text = "9999"

		$MessageLabel / MessageBox / RewardLabel.text = "+" + var_to_str(score)
		$MessageLabel / MessageBox / RewardLabel.visible = true
		$HUD / FacePanel / Radar / CoinLabel / CoinChange.visible = true
		$HUD / FacePanel / Radar / CoinLabel / CoinChange.text = "+" + var_to_str(score)
		$HUD / FacePanel / Radar / CoinLabel / CoinChange.modulate = Color(0, 1, 0, 1)

		if (Main.adventure_mode):
			if (Main.db["episode"] == 1):
				if (Main.db["adventure_levels_complete"] < 8):
					Main.db["adventure_levels_complete"] += 1
					$PauseMenu / PauseBackGround / Buttons / ResetButton.visible = true
				else:
					$PauseMenu / PauseBackGround / Buttons / ResetButton.visible = true
					$PauseMenu / PauseBackGround / Buttons / ExitButton.visible = false
			elif (Main.db["episode"] == 2):
				if (Main.db["adventure_levels_complete"] < 9):
					Main.db["adventure_levels_complete"] += 1
					$PauseMenu / PauseBackGround / Buttons / ResetButton.visible = true
				else:
					$PauseMenu / PauseBackGround / Buttons / ResetButton.visible = true
					$PauseMenu / PauseBackGround / Buttons / ExitButton.visible = false
			elif (Main.db["episode"] == 3):
				if (Main.db["adventure_levels_complete"] < 10):
					Main.db["adventure_levels_complete"] += 1
					$PauseMenu / PauseBackGround / Buttons / ResetButton.visible = true
				else:
					$PauseMenu / PauseBackGround / Buttons / ResetButton.visible = true
					$PauseMenu / PauseBackGround / Buttons / ExitButton.visible = false
			$PauseMenu / PauseBackGround / Buttons / ResetButton / ResetLabel.text = continue_text
			$PauseMenu / PauseBackGround / Buttons / ExitButton / ExitLabel.text = save_exit_text


		if (ten_count > 0 && Main.adventure_mode): Main.db["nine_time"] = ($TenMine.v.x) / 2
	else:
		Main.db["games_lost"] += 1
		if (Main.db["master"]): Main.db["games_lost_in_master_mode"] += 1

		$HUD / GameTimer.get_time()
		$HUD / GameTimer.reset_timer()

		music_fade_out()
		face.play("face" + face_type + "_X(")
		hat.play("hat" + hat_type + "_dead")
		$MessageLabel.text = miss_text
		$MessageLabel.visible = true

		if (Main.challenge):
			var percent = game_board.calculate_percent()
			if (Main.db["challenge_best"][Main.db["challenge_modifier"]][Main.db["challenge_difficulty"] - 1] < 1.0 && Main.db["challenge_best"][Main.db["challenge_modifier"]][Main.db["challenge_difficulty"] - 1] < percent):
				Main.db["challenge_best"][Main.db["challenge_modifier"]][Main.db["challenge_difficulty"] - 1] = percent
			Main.challenge_coin = int(Main.challenge_coin / (10 - Main.db["challenge_difficulty"]))
			$MessageLabel / MessageBox / TimeLabel.text = var_to_str(percent * 100) + "%"
			$MessageLabel / MessageBox / RewardLabel.text = "+" + var_to_str(Main.challenge_coin)
			$MessageLabel / MessageBox / TimeLabel.visible = true
			$MessageLabel / MessageBox / RewardLabel.visible = true
			Main.db["total_coin"] += Main.challenge_coin
		elif (Main.endless):
			Main.db["total_coin"] += Main.db["endless_last_coins"]
			Main.db["endless_last_coins"] = 0
			Main.db["endless_last"] = 0

	await Main.save_game()

	if (Main.db["episode"] == 3 && fake_end && win && !Main.level_select):
		phase_2()
	else:
		if (Main.nine || Main.ten || Main.eleven): await get_tree().create_timer(5).timeout
		else: await get_tree().create_timer(3).timeout

		if (win || ( !win && !Main.adventure_mode) || Main.challenge || Main.endless):
			paused = true
			move_pause_menu()
			$HUD / FacePanel / FaceButton.set_disabled(false)
		else:
			$MessageLabel.text = ""
			$MessageLabel.visible = false
			try_again_sequence()





func try_again_sequence() -> void :
	if is_instance_valid($HUDArea / HUDRectangle5 / HUDPolygon5): $HUDArea / HUDRectangle5 / HUDPolygon5.queue_free()
	if (Main.ten): ten_mine.visible = false
	Main.db["game_overs"] += 1

	while ($HUDArea.modulate[3] < 1.0):
		await get_tree().create_timer(0.01).timeout
		get_tree().call_group("mouse_areas", "set_modulate", Color(1, 1, 1, $HUDArea.get_modulate()[3] + 0.1))

	$MessageLabel.position[1] = 192
	$MessageLabel.text = continue_text + "?"
	$MessageLabel.visible = true
	$MessageLabel / MessageBox / TimeLabel / Coin.visible = true
	$MessageLabel / MessageBox / TimeLabel.text = var_to_str(Main.db["current_coin"])
	$MessageLabel / MessageBox / TimeLabel.visible = true
	var try_again_coins
	if (Main.db["pursuit"] == 0): try_again_coins = 0
	else: try_again_coins = int(pow(2, Main.db["game_overs"] - 1) * 100)
	if ((Main.nine || Main.ten || Main.eleven || Main.db["pursuit"] == 0) && !Main.db["master"]): try_again_coins /= 10
	$MessageLabel / MessageBox / RewardLabel.text = "-" + var_to_str(try_again_coins)
	$MessageLabel / MessageBox / RewardLabel.self_modulate = Color(1, 0, 0, 1)
	$MessageLabel / MessageBox / RewardLabel.visible = true
	$MessageLabel / MessageBox / YesButton.visible = true
	$MessageLabel / MessageBox / NoButton.visible = true


func _on_yes_button_pressed() -> void :
	var try_again_coins
	if (Main.db["pursuit"] == 0):
		try_again_coins = 0
		Main.db["adventure_shield"] += Main.db["game_overs"]
		if (Main.db["adventure_shield"] > 3): Main.db["adventure_shield"] = 3
	else: try_again_coins = int(pow(2, Main.db["game_overs"] - 1) * 100)
	if ((Main.nine || Main.ten || Main.eleven || Main.db["pursuit"] == 0) && !Main.db["master"]): try_again_coins /= 10
	Main.nine = false
	Main.nine_count = 0
	Main.ten = false
	Main.ten_count = 0
	Main.eleven = false
	Main.eleven_count = 0

	if (Main.db["pursuit"] == 2):
		if (Main.db["episode"] == 1): nine_count = 1
		if (Main.db["episode"] == 2): ten_count = 1
		if (Main.db["episode"] == 3): eleven_count = 1
	if (Main.db["current_coin"] >= try_again_coins):
		get_tree().call_group("music", "stop")
		if (nine_count > 0):
			Main.db["nine_time"] = 999
			Main.db["nine_strikes"] = 0
		if (ten_count > 0):
			Main.db["nine_time"] = 0
			Main.db["nine_strikes"] = 0
		if (eleven_count > 0):
			Main.db["nine_strikes"] = 0

		$OneUp.play()
		Main.db["current_coin"] -= try_again_coins
		Main.db["adventure_health"] = 3
		$MessageLabel.text = one_up
		$MessageLabel / MessageBox / RewardLabel.visible = false
		$MessageLabel / MessageBox / TimeLabel.text = var_to_str(Main.db["current_coin"])
		$MessageLabel / MessageBox / YesButton.visible = false
		$MessageLabel / MessageBox / NoButton.visible = false
		face_on = true
		winner = true
		await get_tree().create_timer(3).timeout
		await fade_out()
		get_tree().change_scene_to_file("res://adventure_map.tscn")
	else:
		var vis = false
		for i in range(9):
			vis = !vis
			$MessageLabel / MessageBox / RewardLabel.visible = vis
			await get_tree().create_timer(0.1).timeout
		await get_tree().create_timer(3).timeout
		$MessageLabel / MessageBox / RewardLabel.visible = true


func _on_no_button_pressed() -> void :
	get_tree().call_group("music", "stop")
	Main.db["adventure_game_overs"] += 1
	$GameOver.play()
	$MessageLabel.text = game_over_text
	$MessageLabel / MessageBox.visible = false
	Main.db["total_coin"] += Main.db["current_coin"]
	var ep = Main.db["episode"]

	if (Main.db["pursuit"] == 1):
		if (Main.db["master"]):
			if (Main.db["adventure_master_ranks"][ep][Main.db["difficulty"]] <= -1 && abs(Main.db["adventure_master_ranks"][ep][Main.db["difficulty"]] + 1) < Main.db["adventure_levels_complete"]):
				Main.db["adventure_master_ranks"][ep][Main.db["difficulty"]] = - (Main.db["adventure_levels_complete"]) - 1
		else:
			if (Main.db["adventure_ranks"][ep][Main.db["difficulty"]] <= -1 && abs(Main.db["adventure_ranks"][ep][Main.db["difficulty"]] + 1) < Main.db["adventure_levels_complete"]):
				Main.db["adventure_ranks"][ep][Main.db["difficulty"]] = - (Main.db["adventure_levels_complete"]) - 1

	elif (Main.db["pursuit"] == 2):
		if (Main.db["master"]):
			if (Main.db["pursuit_master_ranks"][ep][Main.db["difficulty"]] <= -1 && abs(Main.db["pursuit_master_ranks"][ep][Main.db["difficulty"]] + 1) < Main.db["adventure_levels_complete"]):
				Main.db["pursuit_master_ranks"][ep][Main.db["difficulty"]] = - (Main.db["adventure_levels_complete"]) - 1
		else:
			if (Main.db["pursuit_ranks"][ep][Main.db["difficulty"]] <= -1 && abs(Main.db["pursuit_ranks"][ep][Main.db["difficulty"]] + 1) < Main.db["adventure_levels_complete"]):
				Main.db["pursuit_ranks"][ep][Main.db["difficulty"]] = - (Main.db["adventure_levels_complete"]) - 1

	Main.db["adventure_levels_complete"] = 0
	Main.db["game_overs"] = 0
	Main.db["difficulty_save"] = -1
	Main.db["adventure_position"] = 0
	Main.db["mistakes"] = 0
	Main.nine = false
	Main.nine_count = 0
	Main.ten = false
	Main.ten_count = 0
	Main.eleven = false
	Main.eleven_count = 0
	await get_tree().create_timer(3).timeout
	await fade_out()
	get_tree().change_scene_to_file("res://game_select_screen.tscn")



func _pause_game() -> void :
	paused = !paused
	if ( !game_over):
		if (Main.game_bgm == 9): get_node("9").set_stream_paused(paused)
		elif (Main.game_bgm == 10): get_node("10").set_stream_paused(paused)
		elif (Main.game_bgm == 11): get_node("11").set_stream_paused(paused)
		elif (Main.game_bgm == 14): get_node("BGM" + var_to_str(randbgm)).set_stream_paused(paused)
		elif (Main.game_bgm < 13): get_node("BGM" + var_to_str(Main.game_bgm)).set_stream_paused(paused)
		game_board.pause_tiles(paused)

	$MessageLabel.visible = paused
	move_pause_menu()
	if ( !game_over):
		if ( !winner):
			get_tree().call_group("game_tiles", "set_disabled", paused)
		get_node("HUD/GameTimer/Timer").set_paused(paused)
		if (paused):
			get_tree().call_group("game_tiles", "set_mouse_filter", MOUSE_FILTER_IGNORE)
			$SVC.set_mouse_filter(MOUSE_FILTER_IGNORE)
		else:
			get_tree().call_group("game_tiles", "set_mouse_filter", MOUSE_FILTER_PASS)
			$SVC.set_mouse_filter(MOUSE_FILTER_PASS)



func move_pause_menu():
	var timer = $PauseMenu / PauseTimer
	var node = $PauseMenu / PauseBackGround
	timer.stop()
	if (paused):
		$PauseMenu.visible = true
		node.position = Vector2(384, -192)
		pause_mover = 192
	else:
		node.position = Vector2(384, 0)
		pause_mover = -192
	timer.start()


func _on_pause_timer_timeout() -> void :
	var node = $PauseMenu / PauseBackGround
	node.position[1] += pause_mover * (5 * get_process_delta_time())
	if (paused): pause_mover = - node.position[1]
	else: pause_mover = - (node.position[1]) - 192
	if (node.position[1] > -0.01 || node.position[1] < -191.99):
		$PauseMenu / PauseTimer.stop()
		$PauseMenu.visible = paused



func _reset_game() -> void :
	if ( !Main.adventure_mode && !Main.endless):
		Main.db["games_started"] += 1
		if (Main.db["master"]): Main.db["games_started_in_master_mode"] += 1
		if (Main.game_bgm == 9):
			get_node("9/Win9").stop()
			get_node("9").stop()
		elif (Main.game_bgm == 10):
			get_node("10/Win10").stop()
			get_node("10").stop()
		elif (Main.game_bgm == 11):
			get_node("11/Win11").stop()
			get_node("11").stop()
		elif (Main.game_bgm == 14):
			get_node("Win" + var_to_str(randbgm)).stop()
		elif (Main.game_bgm < 9): get_node("Win" + var_to_str(Main.game_bgm)).stop()
		get_tree().call_group("music", "set_pitch_scale", 1)
		if (Main.game_bgm == 9): get_node("9/9Intro").play()
		elif (Main.game_bgm == 10): get_node("10/10Intro").play()
		elif (Main.game_bgm == 11): get_node("11/11Intro").play()
		elif (Main.game_bgm == 14 && !get_node("BGM" + var_to_str(randbgm)).playing):
			get_node("BGM" + var_to_str(randbgm)).play()
		elif (Main.game_bgm < 9 && !get_node("BGM" + var_to_str(Main.game_bgm)).playing):
			get_node("BGM" + var_to_str(Main.game_bgm)).play()
		game_board.reset_board()
		game_board.get_node("Camera").set_zoom(Vector2(1.0, 1.0))
		$HUD / MineCounter.game_over = false
		$HUD / MineCounter.set_flags(game_board.mines)
		$HUD / GameTimer.get_time()
		$HUD / GameTimer.reset_timer()
		$HUD / GameTimer.update_time()
		$HUD / FacePanel / HealthGauge.frame = 0
		$MessageLabel.text = pause_text
		$MessageLabel / MessageBox / TimeLabel.visible = false
		$MessageLabel / MessageBox / RewardLabel.visible = false
		$HUD / FacePanel / Radar / CoinLabel / CoinChange.text = ""
		$HUD / FacePanel / Radar / CoinLabel / CoinChange.visible = false
		$HUD / FacePanel / Radar / CoinLabel / CoinChange.modulate = Color(1, 0, 0, 1)

		if (Main.challenge):
			Main.challenge_coin = 0
			$HUD / FacePanel / Radar / CoinLabel.text = "0"

		game_over = false
		winner = false
		get_tree().call_group("anim", "play_anim", Main.db["custom_style"])
		_pause_game()

		if (game_board.win_tiles == 0):
			game_board.end_game(true)
	else:
		$PauseMenu / PauseBackGround / Buttons / ResetButton.set_disabled(true)
		await fade_out()
		if (Main.endless):
			get_tree().change_scene_to_file("res://level.tscn")
			return
		if ( !Main.nine && !Main.ten && !Main.eleven):
			get_tree().change_scene_to_file("res://adventure_map.tscn")
		else:
			if (Main.db["episode"] == 1 && Main.nine):
				Main.nine = false
				Main.nine_count = 0
				get_tree().change_scene_to_file("res://end_screen.tscn")
			elif (Main.db["episode"] == 2 && Main.ten):
				if (fake_end):
					round_2()
				else:
					Main.nine = false
					Main.nine_count = 0
					Main.ten = false
					Main.ten_count = 0
					get_tree().change_scene_to_file("res://end_screen.tscn")
			else:
				if ((Main.db["episode"] == 2 || Main.db["episode"] == 3) && Main.nine && !Main.eleven):
					Main.nine = false
					Main.nine_count = 0
					get_tree().change_scene_to_file("res://adventure_map.tscn")
				elif (Main.db["episode"] == 3 && Main.ten && !Main.eleven):
					Main.ten = false
					Main.ten_count = 0
					get_tree().change_scene_to_file("res://adventure_map.tscn")
				else:
					Main.nine = false
					Main.nine_count = 0
					Main.ten = false
					Main.ten_count = 0
					Main.eleven = false
					Main.eleven_count = 0
					get_tree().change_scene_to_file("res://end_screen.tscn")

func fade_in() -> void :
	while ($Fade.color[0] < 1):
		await get_tree().create_timer(get_process_delta_time()).timeout
		$Fade.color += Color(1, 1, 1, 0) * (5 * get_process_delta_time())
	$Fade.color = Color(1, 1, 1, 1)

func fade_out() -> void :
	while ($Fade.color[0] > 0):
		await get_tree().create_timer(get_process_delta_time()).timeout
		$Fade.color -= Color(1, 1, 1, 0) * (5 * get_process_delta_time())
	$Fade.color = Color(0, 0, 0, 0)

func music_fade_out():
	if (Main.game_bgm != 12):
		var music_string
		if (Main.game_bgm < 9): music_string = "BGM" + var_to_str(Main.game_bgm)
		elif (Main.game_bgm >= 9 && Main.game_bgm <= 11): music_string = var_to_str(Main.game_bgm)
		elif (Main.game_bgm == 14): music_string = "BGM" + var_to_str(randbgm)
		else: music_string = var_to_str(Main.game_bgm)
		while (get_node(music_string).pitch_scale > 0.2):
			await get_tree().create_timer(0.01).timeout
			get_node(music_string).pitch_scale -= (0.5 * get_process_delta_time())
			if (get_node(music_string).pitch_scale < (0.5 * get_process_delta_time())):
				break
		get_node(music_string).pitch_scale = 0.2


func _exit_game() -> void :
	$PauseMenu / PauseBackGround / Buttons / ExitButton.set_disabled(true)
	$PauseMenu / PauseBackGround / Buttons / ResetButton.set_disabled(true)
	$HUD / FacePanel / FaceButton.set_disabled(true)
	$Exit.play()
	if ( !Main.nine && !nine_count > 0): $HUD / GameTimer.get_time()
	Main.nine = false
	Main.nine_count = 0
	Main.ten = false
	Main.ten_count = 0
	Main.eleven = false
	Main.eleven_count = 0
	await get_tree().create_timer(0.5).timeout
	await fade_out()
	get_tree().change_scene_to_file("res://game_select_screen.tscn")


func _on_skip_button_pressed() -> void :
	skip_intro = true
	$SkipButton / Label.text = skipping
	$SkipButton.set_disabled(true)


func _on_nine_quick_set_timer_timeout() -> void :
	if ( !Main.nine):
		for n in range(nine_mine_array.size()):
			nine_mine_array[n].position = game_board.position + game_board.get_nine_position(n)
	if ( !Main.eleven):
		for e in range(eleven_mine_array.size()):
			eleven_mine_array[e].position = game_board.position + game_board.get_eleven_position(e)

func reset_nine() -> void :
	$BackDrop.visible = false
	nine_mine.get_node("Body").frame = 0
	nine_mine.get_node("Body/Spikes").scale = Vector2(1, 1)
	quick_set_9 = Vector2i(randi_range(1, game_row - 1), randi_range(1, game_col - 1))
	game_board.nine_position = quick_set_9
	game_board.preset_mines()
	game_board.open_nine_tile()
	$HUD / MineCounter / Timer.start()
	_on_nine_quick_set_timer_timeout()
	$HUD / FacePanel / TimerGauge.start()


func round_2() -> void :
	$PauseMenu.visible = false
	$HUD / FacePanel / FaceButton.set_disabled(true)
	paused = false
	await move_pause_menu()
	$PauseMenu / PauseBackGround / Buttons / ResetButton.set_disabled(false)
	$MessageLabel.visible = false
	$MessageLabel / MessageBox / RewardLabel.visible = false
	$MessageLabel / MessageBox / TimeLabel.visible = false

	Main.nine = true
	Main.nine_count = 1
	nine_count = 1
	var n
	n = nine.instantiate()
	n.movement_decision.connect(_load_nine_movement_array)
	n.nine_pressed.connect(_end_battle)
	$SVC / SV.add_child(n)
	nine_mine_array.append(n)
	nine_mine = nine_mine_array[0]

	$HUD / FacePanel / Radar / CoinLabel / CoinChange.visible = false

	fake_end = false

	Main.db["total_coins_collected"] -= save_score

	Main.db["current_coin"] -= save_score
	$HUD / FacePanel / Radar / CoinLabel.text = var_to_str(Main.db["current_coin"])



	game_board.tile_array.clear()
	var mg_children = game_board.get_node("MineGrid").get_children()
	for i in range(mg_children.size()):
		mg_children[i].queue_free()
	var bg_children = $SVC / SV / BGContainer / BackGround.get_children()
	for i in range(bg_children.size()):
		bg_children[i].queue_free()
	game_col = Main.surprise_level[Main.db["difficulty"] - 1][0]
	game_row = Main.surprise_level[Main.db["difficulty"] - 1][1]
	max_columns = 18
	max_rows = 12
	game_board.game_columns = game_col
	game_board.game_rows = game_row
	game_board.mines = Main.surprise_level[Main.db["difficulty"] - 1][2]
	await game_board.build_grid()
	game_board.create_borders()
	$HUD / GameTimer.reset_timer()
	$HUD / GameTimer.seconds = Main.surprise_level[Main.db["difficulty"] - 1][3]
	$HUD / GameTimer.nine_seconds = $HUD / GameTimer.seconds

	game_board.nine_position[0] = Vector2i(game_col / 2, game_row / 2)
	game_board.open_nine_tile(0)
	$NineMineTemp.visible = true
	$NineMineTemp.shrink(1 / shrink_quotient)

	$NineMineTemp / Body.frame = 0
	nine_mine.get_node("Body").frame = 0
	$NineMineTemp / Body / Spikes.visible = true
	nine_mine.get_node("Body/Spikes").visible = true
	$NineMineTemp / Body / Spikes.scale = Vector2(1, 1)
	nine_mine.get_node("Body/Spikes").scale = Vector2(1, 1)

	build_level()
	game_board.preset_mines(Vector2i(game_row / 2, game_col / 2))
	face_type = "5"
	await get_tree().create_timer(1).timeout
	get_node("9/9Intro").play()
	await get_tree().create_timer(2).timeout
	get_node("9/9Intro").stop()


	nine_mine.delta_multiplier = 0.1
	for i in range(100):
		nine_mine.delta_multiplier *= 1.1

	$NineMineTemp.delta_multiplier = nine_mine.delta_multiplier
	var speed = 0.5

	get_node("9/Saw").play()
	while (nine_mine.position[0] < 1200):
		await get_tree().create_timer(0.01).timeout
		nine_mine.position[0] += speed
		speed += 0.5

	var out = nine_mine.position[0]
	out = ( - (out - 1152))
	winner = false





	fade_in()
	ten_mine.position = ten_position_save
	if (dual_boss): ten_mine2.position = ten_position_save2
	for ten in ten_mine_array:
		ten.reset_pistons()
	music_replay()
	face.play("face5_X0")
	hat.play("hat" + hat_type + "_hit")
	await blow_up_intro_mine("1", speed)
	$HUD / MineCounter / Timer.start()

	await blow_up_intro_mine("2", speed)
	$HUD / FacePanel / Radar.play("on")
	$HUD / FacePanel / Radar / RadarButton.set_modulate(Color(0.5, 0.5, 0.5, 0.5))

	await blow_up_intro_mine("3", speed)
	$HUD / FacePanel / TimerGauge.start()

	await blow_up_intro_mine("4", speed)
	$HUD / GameTimer.update_time()
	$HUD / GameTimer.set_modulate(Color(1, 0.5, 0.5, 1))

	while ($NineMineTemp.position[0] < 1200):
		await get_tree().create_timer(0.01).timeout
		$NineMineTemp.position[0] += speed

	$NineMineTemp.set_visible(false)
	nine_mine.set_position(Vector2(out, game_board.position[1] + game_board.get_nine_position(0)[1]))

	while (nine_mine.position[0] < game_board.get_nine_position(0)[0]):
		await get_tree().create_timer(0.01).timeout
		nine_mine.position[0] += speed
		speed -= 0.5

	nine_mine.position = game_board.position + game_board.get_nine_position(0)

	for i in range(100):
		await get_tree().create_timer(0.01).timeout
		nine_mine.delta_multiplier /= 1.1

	nine_mine.get_node("MoveTimer").start()



	for ten in ten_mine_array:
		ten.get_node("Timer").start()
		ten.go = true
		ten.dial = true
		ten.beep = false
		ten.piston_frequency = 0.25
		ten.dial_time = 1.0
		ten.get_node("Timer").wait_time = 1.0
		ten.v = ten_mine.v / 2
		ten.set_linear_velocity(ten.v.rotated(ten.direction))


	game_board.already_setup = false
	nine_mine.get_node("MoveTimer").start()
	ten_mine.get_node("Button").set_disabled(false)
	if dual_boss: ten_mine2.get_node("Button").set_disabled(false)
	get_tree().call_group("tiles", "set_disabled", false)
	get_tree().call_group("game_tiles", "set_mouse_filter", MOUSE_FILTER_PASS)
	$SVC.set_mouse_filter(MOUSE_FILTER_PASS)
	game_over = false
	face_on = true
	get_node("HUD/GameTimer/Timer").set_paused(false)
	get_node("HUD/GameTimer")._start_timer(true)
	Main.adjust_volume()

func phase_2() -> void :
	await get_tree().create_timer(3).timeout
	game_board.eleven_position[0] = Vector2(game_col / 2, game_row / 2)
	eleven_mine.position = game_board.get_eleven_position(0)
	await eleven_mine.unmalfunction()
	$MessageLabel.set_visible(false)
	$MessageLabel / MessageBox / RewardLabel.set_visible(false)
	$MessageLabel / MessageBox / TimeLabel.set_visible(false)
	get_tree().call_group("music", "stop")
	face_on = false
	face.play("faceN_13")
	hat.play("hat" + hat_type + "_f")

	$BGM12.play()
	await get_tree().create_timer(3).timeout

	face.play("faceN_14")
	for i in range(0, 360, 3):
		eleven_mine.scale += Vector2(0.03, 0.03)
		eleven_mine.rotation_degrees = i
		await get_tree().create_timer(get_process_delta_time()).timeout
	eleven_mine.rotation = 0
	eleven_mine.barrage_flags = 1

	eleven_mine.superbomb()

	await get_tree().create_timer(1).timeout

	Main.nine = true
	Main.nine_count = 1
	nine_count = 1
	var n
	n = nine.instantiate()
	n.movement_decision.connect(_load_nine_movement_array)
	n.nine_pressed.connect(_end_battle)
	$SVC / SV.add_child(n)
	nine_mine_array.append(n)
	nine_mine = nine_mine_array[0]


	Main.ten = true
	ten_count = 1
	var t = ten.instantiate()
	t.ran_out_of_time.connect(_end_battle2)
	t.bounced.connect(shake_screen)
	add_child(t)
	t.set_position(Vector2i(-48, -48))
	t.get_node("Button/Light").range_z_min = 100
	t.get_node("Button/Light").range_z_max = 100
	t.z_index = 100
	ten_mine_array.append(t)
	ten_mine = ten_mine_array[0]
	ten_mine.visible = true
	ten_mine.v = Vector2(22, 22)
	ten_mine.direction = 0
	ten_mine.set_linear_velocity(ten_mine.v.rotated(ten_mine.direction))

	$HUD / FacePanel / Radar / CoinLabel / CoinChange.visible = false

	fake_end = false

	Main.db["total_coins_collected"] -= save_score

	Main.db["current_coin"] -= save_score
	$HUD / FacePanel / Radar / CoinLabel.text = var_to_str(Main.db["current_coin"])


	game_board.phase2 = true
	game_board.tile_array.clear()
	var mg_children = game_board.get_node("MineGrid").get_children()
	for i in range(mg_children.size()):
		mg_children[i].queue_free()
	var bg_children = $SVC / SV / BGContainer / BackGround.get_children()
	for i in range(bg_children.size()):
		bg_children[i].queue_free()
	if (Main.adventure_mode):
		game_col = Main.surprise_level2[Main.db["difficulty"] - 1][0]
		game_row = Main.surprise_level2[Main.db["difficulty"] - 1][1]
	else:
		game_col = Main.surprise_level2[Main.level_select_difficulty - 1][0]
		game_row = Main.surprise_level2[Main.level_select_difficulty - 1][1]
	max_columns = 18
	max_rows = 12
	game_board.game_columns = game_col
	game_board.game_rows = game_row
	if (Main.adventure_mode): game_board.mines = Main.surprise_level2[Main.db["difficulty"] - 1][2]
	else: game_board.mines = Main.surprise_level2[Main.level_select_difficulty - 1][2]
	await game_board.build_grid()
	game_board.create_borders()
	game_board.cut_grid()
	game_board.create_borders()
	$HUD / GameTimer.reset_timer()
	$HUD / GameTimer.seconds = Main.surprise_level2[Main.db["difficulty"] - 1][3]
	$HUD / GameTimer.nine_seconds = $HUD / GameTimer.seconds
	$HUD / MineCounter.flags_left = game_board.mines
	$HUD / MineCounter.flag_handicap = 0
	$HUD / MineCounter.update_count()
	$HUD / MineCounter.game_over = false
	$HUD / GameTimer.set_modulate(Color(1, 0.5, 0.5, 1))

	nine_mine.visible = false
	nine_mine.get_node("Body").frame = 0
	nine_mine.get_node("Body/Spikes").visible = true
	nine_mine.get_node("Body/Spikes").scale = Vector2(0.5, 0.5)

	await build_level()

	face.play("face5_X0")
	hat.play("hat" + hat_type + "_hit")

	face_type = "5"
	await get_tree().create_timer(2).timeout

	face.play("faceE_3")
	hat.play("hat" + hat_type + "_f")

	game_board.nine_position[0] = Vector2i(game_col / 2, game_row / 2)
	game_board.open_nine_tile(0)
	game_board.preset_mines(Vector2i(game_col / 2, game_row / 2))
	nine_mine.position = game_board.position + game_board.get_nine_position(0)
	nine_mine.set_visible(true)

	await eleven_mine.slow_open()

	await get_tree().create_timer(1).timeout

	eleven_mine.ac = 1

	while eleven_mine.modulate[3] > 0:
		eleven_mine.modulate[3] -= 0.01
		await get_tree().create_timer(get_process_delta_time()).timeout

	eleven_mine.set_scale(Vector2(1 * shrink_quotient, 1 * shrink_quotient))
	eleven_mine.close(true)

	await get_tree().create_timer(1).timeout

	get_node("9/Spikes").play()
	while (nine_mine.get_node("Body/Spikes").scale[0] < 1.0):
		await get_tree().create_timer(0.01).timeout
		nine_mine.get_node("Body/Spikes").scale += Vector2(5 * get_process_delta_time(), 5 * get_process_delta_time())
	nine_mine.get_node("Body/Spikes").scale = Vector2(1.0, 1.0)

	await get_tree().create_timer(1).timeout

	nine_mine.delta_multiplier = 1.1

	game_board.already_setup = false
	nine_mine.get_node("MoveTimer").start()


	get_tree().call_group("tiles", "set_disabled", false)
	get_tree().call_group("game_tiles", "set_mouse_filter", MOUSE_FILTER_PASS)
	$SVC.set_mouse_filter(MOUSE_FILTER_PASS)
	game_over = false
	face_on = true
	get_node("HUD/GameTimer/Timer").set_paused(false)
	get_node("HUD/GameTimer")._start_timer(true)
	Main.adjust_volume()
	eleven_mine.start = true
	$BGM12.stop()
	get_node("11/11_2").play()


	ten_mine.dial = true
	ten_mine.go = true

	if (dual_boss):
		eleven_mine2.set_scale(Vector2(1 * shrink_quotient, 1 * shrink_quotient))
		eleven_mine2.close(true)
		eleven_mine2.hide_teslas(true)
		eleven_mine2.start = true


func music_replay() -> void :
	get_node("10").pitch_scale = 0.01
	get_node("10").play(77)
	while (get_node("10").pitch_scale < 1.0):
		get_node("10").pitch_scale += get_process_delta_time()
		await get_tree().create_timer(0.02).timeout

func translate(language) -> void :
	var code = Main.get_language_code(language)

	var file = FileAccess.open("res://text/translate_level.txt", FileAccess.READ)
	var r = file.get_csv_line(",")
	var c = r.find(code)

	clear_text = file.get_csv_line()[c]
	pause_text = file.get_csv_line()[c]
	miss_text = file.get_csv_line()[c]
	ready_text = file.get_csv_line()[c]
	reset_text = file.get_csv_line()[c]
	exit_text = file.get_csv_line()[c]
	save_exit_text = file.get_csv_line()[c]
	continue_text = file.get_csv_line()[c]
	one_up = file.get_csv_line()[c]
	game_over_text = file.get_csv_line()[c]
	yes_text = file.get_csv_line()[c]
	no_text = file.get_csv_line()[c]
	skipping = file.get_csv_line()[c]
	$SkipButton / Label.text = file.get_csv_line()[c]

	file.close()

	$MessageLabel / MessageBox / YesButton / YesLabel.text = yes_text
	$MessageLabel / MessageBox / NoButton / NoLabel.text = no_text
	$MessageLabel.text = pause_text
	$PauseMenu / PauseBackGround / Buttons / ResetButton / ResetLabel.text = reset_text
	$PauseMenu / PauseBackGround / Buttons / ExitButton / ExitLabel.text = exit_text


func _on_touch_screen_zoom_in_pressed() -> void :
	var zi = InputEventAction.new()
	zi.action = "zoom_in"
	zi.pressed = true
	Input.parse_input_event(zi)
func _on_touch_screen_zoom_in_released() -> void :
	var zi = InputEventAction.new()
	zi.action = "zoom_in"
	zi.pressed = false
	Input.parse_input_event(zi)

func _on_touch_screen_zoom_out_pressed() -> void :
	var zo = InputEventAction.new()
	zo.action = "zoom_out"
	zo.pressed = true
	Input.parse_input_event(zo)
func _on_touch_screen_zoom_out_released() -> void :
	var zo = InputEventAction.new()
	zo.action = "zoom_out"
	zo.pressed = false
	Input.parse_input_event(zo)

func _on_touch_screen_scrub_up_pressed() -> void :
	var cu = InputEventAction.new()
	cu.action = "camera_up"
	cu.pressed = true
	Input.parse_input_event(cu)
func _on_touch_screen_scrub_up_released() -> void :
	var cu = InputEventAction.new()
	cu.action = "camera_up"
	cu.pressed = false
	Input.parse_input_event(cu)

func _on_touch_screen_scrub_left_pressed() -> void :
	var cl = InputEventAction.new()
	cl.action = "camera_left"
	cl.pressed = true
	Input.parse_input_event(cl)
func _on_touch_screen_scrub_left_released() -> void :
	var cl = InputEventAction.new()
	cl.action = "camera_left"
	cl.pressed = false
	Input.parse_input_event(cl)

func _on_touch_screen_scrub_down_pressed() -> void :
	var cd = InputEventAction.new()
	cd.action = "camera_down"
	cd.pressed = true
	Input.parse_input_event(cd)
func _on_touch_screen_scrub_down_released() -> void :
	var cd = InputEventAction.new()
	cd.action = "camera_down"
	cd.pressed = false
	Input.parse_input_event(cd)

func _on_touch_screen_scrub_right_pressed() -> void :
	var cr = InputEventAction.new()
	cr.action = "camera_right"
	cr.pressed = true
	Input.parse_input_event(cr)
func _on_touch_screen_scrub_right_released() -> void :
	var cr = InputEventAction.new()
	cr.action = "camera_right"
	cr.pressed = false
	Input.parse_input_event(cr)

func _on_button_button_down() -> void :
	_on_touch_screen_zoom_in_pressed()

func _on_button_2_button_down() -> void :
	_on_touch_screen_scrub_right_pressed()


func _on_button_button_up() -> void :
	_on_touch_screen_zoom_in_released()


func _on_button_2_button_up() -> void :
	_on_touch_screen_scrub_right_released()
