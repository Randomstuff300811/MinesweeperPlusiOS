extends Node

@export var bg_tile: PackedScene
var row = 18
var col = 16

var show_custom_tiles = true

var move_vector = Vector2(0, 0)
var left_to_move = Vector2(0, 0)
var move_mode = 0
var shifts = 0
var shift_array = []


var adventure_difficulty = 0
var customizer_visible = false
var custom_game_length: int
var custom_game_width: int
var custom_game_mines: int
var custom_game_tiles: int
var custom_double_mines: int = 0
var custom_anti_mines: int = 0
var mine_percent: float
var custom_game_style
var custom_style_string
var custom_game_bgm
var custom_bgm_string
var bgm_string
var custom_nine
var custom_ten
var custom_eleven
var last_bgm

var endless_diff_temp
var endless_mod_temp

var unlock_accepted
var unlock_code
var unlock_coins
var unlock_node_number

var master_on = "Master Mode: On"
var master_off = "Master Mode: Off"
var accept = "OK"
var cancel = "Cancel"

var episode = "EPISODE "
var casual = "CASUAL"
var normal = "NORMAL"
var pursuit = "PURSUIT"
var boss_pursuit = "BOSS PURSUIT"
var mines = " MINES"
var best = "BEST: "

var beginner = "BEGINNER "
var novice = "NOVICE "
var veteran = "VETERAN "
var expert = "EXPERT "

var beginner_desc = "Smooth sailing! Perfect difficulty for those who are new to the job of Minesweeping. Mines are sparse, so the challenge is minimal."
var novice_desc = "Steady as she goes! The perfect difficulty for players familiar with minesweeping who don't want the work to be too easy."
var veteran_desc = "Tread carefully! This difficulty is for those who know a thing or two about minesweeping who want somewhat of a challenge."
var expert_desc = "Batten down the hatches! This difficulty mode is only for the most battle-hardened minesweeping warriors. Can you survive these mine-riddled waters?"

var double = "DOUBLE"
var anti = "ANTI"

var flag_handicap = "Flag Handicap"
var diff_array = ["Easy", "Medium", "Hard", "Extreme"]
var diff_array2 = ["EASY", "MEDIUM", "HARD", "EXTREME"]
var mod_array = ["Normal", "Double", "Anti", "Both"]
var stage = "STAGE"
var episode1_stages = ["KIDDIE POOL", "RAINY PUDDLE", "SMALL POND", "BLUE LAGOON", "LAZY RIVER", "GREAT LAKE", "OPEN OCEAN", "DEAD SEA", "THE DEVIL'S TRIANGLE"]
var episode2_stages = ["THE SHALLOW END", "FOUNTAIN FLOWS", "SILENT MARSH", "MURKY SWAMP", "CRAZY COVE", "RAGING RAPIDS", "GULF OF MISERY", "BLACK WATER", "THE DEEP END", "THE DEVIL'S PASSAGE"]






func _ready() -> void :

	get_node("Settings/Popup").language_changed.connect(translate)
	translate(Main.db["language"])

	await Main.save_game()

	if FileAccess.file_exists("user://Faces_0.png"):
		var png = Image.load_from_file("user://Faces_0.png")
		var texture = ImageTexture.create_from_image(png)
		$LoadOutScreen / Background / Face2.texture = texture
		var face_size = texture.get_size()
		$LoadOutScreen / Background / Face2.scale = Vector2(640.0 / face_size[0], 640 / face_size[1])
		$LoadOutScreen / Background / Face2.frame = 4

	fade_in()


	Main.adjust_volume()


	var bg
	for i in range(col):
		for j in range(row):
			bg = bg_tile.instantiate()
			bg.row_col = Vector2i(i, j)
			$Camera / BackGround.add_child(bg)
	get_tree().call_group("tiles", "play_anim", Main.db["custom_style"])

	if (Main.weather == 1): $Camera / Rain.set_visible(true)
	elif (Main.weather == 2): $Camera / Snow.set_visible(true)
	elif (Main.weather == 3): $Camera / Fog.set_visible(true)
	$FreePlayScreen / WeatherButton / Weather.frame = Main.weather


	Main.challenge = false
	Main.endless = false
	custom_game_length = Main.db["custom_length"]
	custom_game_width = Main.db["custom_width"]
	custom_game_mines = Main.db["custom_mines"]
	custom_game_tiles = custom_game_length * custom_game_width
	mine_percent = float((custom_game_mines) / (float(custom_game_tiles))) * 100
	$FreePlayScreen / LengthEditor.text = var_to_str(custom_game_length)
	$FreePlayScreen / WidthEditor.text = var_to_str(custom_game_width)
	$FreePlayScreen / MineEditor.text = var_to_str(custom_game_mines)
	$FreePlayScreen / TileIndicator.text = var_to_str(custom_game_tiles)
	$FreePlayScreen / MinePercent.text = var_to_str(mine_percent).left(5) + "%"
	$FreePlayScreen / LengthSlider.set_value_no_signal(custom_game_length)
	$FreePlayScreen / WidthSlider.set_value_no_signal(custom_game_width)
	$FreePlayScreen / MineSlider.set_max(custom_game_tiles - 1)
	$FreePlayScreen / MineSlider.set_value_no_signal(custom_game_mines)


	custom_game_style = Main.db["custom_style"]
	custom_style_string = var_to_str(custom_game_style)
	get_node("StyleContainer/Style" + custom_style_string + "Box").set_pressed_no_signal(true)
	get_node("StyleContainer/Style" + custom_style_string + "Box/StyleSquare" + custom_style_string + "/Background1").visible = false
	for i in range(11):
		get_node("StyleContainer/Style" + var_to_str(i + 1) + "Box/StyleSquare" + var_to_str(i + 1)).play_anim(i + 1)
		get_node("StyleContainer/Style" + var_to_str(i + 1) + "Box/StyleSquare" + var_to_str(i + 1)).remove_from_group("tiles")
	for i in range(101, 104):
		get_node("StyleContainer/Style" + var_to_str(i) + "Box/StyleSquare" + var_to_str(i)).play_anim(i)
		get_node("StyleContainer/Style" + var_to_str(i) + "Box/StyleSquare" + var_to_str(i)).remove_from_group("tiles")


	if (Main.db["face_unlock_array"][0] == 1): $FaceContainer / Face5Box / Face5Lock.visible = false
	if (Main.db["face_unlock_array"][1] == 1): $FaceContainer / Face6Box / Face6Lock.visible = false
	if (Main.db["face_unlock_array"][2] == 1): $FaceContainer / Face7Box / Face7Lock.visible = false
	if (Main.db["face_unlock_array"][3] == 1): $FaceContainer / Face8Box / Face8Lock.visible = false
	if (Main.db["costume_unlock_array"][0] == 1): $CostumeContainer / Costume2Box / Costume2Lock.visible = false
	if (Main.db["costume_unlock_array"][1] == 1): $CostumeContainer / Costume3Box / Costume3Lock.visible = false
	if (Main.db["costume_unlock_array"][2] == 1): $CostumeContainer / Costume4Box / Costume4Lock.visible = false
	if (Main.db["costume_unlock_array"][3] == 1): $CostumeContainer / Costume5Box / Costume5Lock.visible = false
	if (Main.db["costume_unlock_array"][4] == 1): $CostumeContainer / Costume6Box / Costume6Lock.visible = false
	if (Main.db["costume_unlock_array"][5] == 1): $CostumeContainer / Costume7Box / Costume7Lock.visible = false
	if (Main.db["costume_unlock_array"][6] == 1): $CostumeContainer / Costume8Box / Costume8Lock.visible = false
	if (Main.db["boss_unlock_array"][9] == 1 || Main.db["adventure_ranks"][0][1] > -1
	|| Main.db["adventure_ranks"][0][2] > -1 || Main.db["adventure_ranks"][0][3] > -1): $FreePlayScreen / Challenge9 / Challenge9Lock.visible = false
	if (Main.db["boss_unlock_array"][10] == 1 || Main.db["adventure_ranks"][1][1] > -1
	|| Main.db["adventure_ranks"][1][2] > -1 || Main.db["adventure_ranks"][1][3] > -1): $FreePlayScreen / Challenge10 / Challenge10Lock.visible = false
	if (Main.db["boss_unlock_array"][11] == 1 || Main.db["adventure_ranks"][2][1] > -1
	|| Main.db["adventure_ranks"][2][2] > -1 || Main.db["adventure_ranks"][2][3] > -1): $FreePlayScreen / Challenge11 / Challenge11Lock.visible = false














	get_node("CostumeContainer/Costume" + var_to_str(Main.db["costume"]) + "Box").set_pressed(true)
	get_node("CostumeContainer/Costume" + var_to_str(Main.db["costume"]) + "Box/CostumeSquare" + var_to_str(Main.db["costume"]) + "/Flag").visible = true
	change_costume(Main.db["costume"])
	if (Main.db["costume"] == 5):
		$LoadOutScreen / Background / Face.position[1] = 16

	if (Main.db["face"] > 0):
		get_node("FaceContainer/Face" + var_to_str(Main.db["face"]) + "Box").set_pressed(true)
		get_node("FaceContainer/Face" + var_to_str(Main.db["face"]) + "Box/FaceSquare" + var_to_str(Main.db["face"]) + "/Flag").visible = true
	else:
		$LoadOutScreen / CustomFaceBox.set_pressed(true)
		$LoadOutScreen / CustomFaceBox / FaceSquare / Flag.visible = true
		$LoadOutScreen / Background / Hat.visible = false
	change_face(Main.db["face"])






	big_one_difficulty_change(Main.db["challenge_difficulty"], Main.db["challenge_modifier"])
	long_haul_difficulty_change(Main.db["endless_difficulty"], Main.db["endless_modifier"])

	if (Main.db["endless_last"] > 0):
		$BonusGamesScreen / EndlessButton / ContinueButton.set_visible(true)
		$BonusGamesScreen / EndlessButton / ContinueButton / ProgressControl / DifficultyLabel.text = diff_array2[Main.db["endless_difficulty"]]
		$BonusGamesScreen / EndlessButton / ContinueButton / ProgressControl / StageLabel.text = stage + " " + var_to_str(Main.db["endless_last"])
		if (Main.db["endless_modifier"] == 0): $BonusGamesScreen / EndlessButton / ContinueButton / Mine.frame = 0
		if (Main.db["endless_modifier"] == 1): $BonusGamesScreen / EndlessButton / ContinueButton / Mine.frame = 2
		if (Main.db["endless_modifier"] == 2): $BonusGamesScreen / EndlessButton / ContinueButton / Mine.frame = 6
		if (Main.db["endless_modifier"] == 3): $BonusGamesScreen / EndlessButton / ContinueButton / Mine.frame = 8
		$BonusGamesScreen / EndlessButton / ContinueButton / Health.frame = abs(Main.db["endless_health"] - 3)
		$BonusGamesScreen / EndlessButton / ContinueButton / Health / Shield.frame = Main.db["endless_shield"]



	get_node("FreePlayScreen/Challenge9/TimeSlider").set_value(Main.db["nine_custom_seconds"])
	get_node("FreePlayScreen/Challenge9/DifficultySelection9").select(Main.db["nine_custom_difficulty"])
	get_node("FreePlayScreen/Challenge9/TimeSlider/TimeLabel").text = var_to_str(get_node("FreePlayScreen/Challenge9/TimeSlider").value)
	get_node("FreePlayScreen/Challenge9/NumberEditor").text = var_to_str(Main.nine_count)

	get_node("FreePlayScreen/Challenge10/DifficultySelection10").select(Main.db["ten_custom_difficulty"])
	get_node("FreePlayScreen/Challenge10/NumberEditor").text = var_to_str(Main.ten_count)

	get_node("FreePlayScreen/Challenge11/DifficultySelection11").select(Main.db["eleven_custom_difficulty"])
	get_node("FreePlayScreen/Challenge11/FlagSlider/FlagLabel").text = var_to_str(int(get_node("FreePlayScreen/Challenge11/FlagSlider").value)) + " " + flag_handicap
	get_node("FreePlayScreen/Challenge11/FlagSlider").min_value = - (custom_game_mines) + 1
	get_node("FreePlayScreen/Challenge11/FlagSlider").max_value = custom_game_tiles - custom_game_mines
	get_node("FreePlayScreen/Challenge11/FlagSlider").value = Main.db["flag_handicap"]
	get_node("FreePlayScreen/Challenge11/FlagSlider/FlagLabel").text = var_to_str(int(Main.db["flag_handicap"])) + " " + flag_handicap
	get_node("FreePlayScreen/Challenge11/NumberEditor").text = var_to_str(Main.eleven_count)


	get_tree().call_group("game_tiles", "deactivate")


	adventure_difficulty = Main.db["difficulty"]
	if (adventure_difficulty == 0): _on_easy_button_toggled(true)
	elif (adventure_difficulty == 1): _on_novice_button_toggled(true)
	elif (adventure_difficulty == 2): _on_normal_button_toggled(true)
	else: _on_hard_button_toggled(true)

	$AdventureModeScreen / EpisodeLabel.text = episode + var_to_str(Main.db["episode"])
	if (Main.db["episode"] == 2 && Main.db["episode_unlock_array"][0] == 0 && Main.db["adventure_wins"] == 0):
		$AdventureModeScreen / StartAdventure / StartLock.visible = true
	elif (Main.db["episode"] == 3 && Main.db["episode_unlock_array"][1] == 0 && Main.db["adventure_wins2"] == 0):
		$AdventureModeScreen / StartAdventure / StartLock.visible = true
	else:
		$AdventureModeScreen / StartAdventure / StartLock.visible = false
	if (Main.db["pursuit"] == 0): $AdventureModeScreen / GameplayLabel.text = casual
	elif (Main.db["pursuit"] == 1): $AdventureModeScreen / GameplayLabel.text = normal
	elif (Main.db["pursuit"] == 2): $AdventureModeScreen / GameplayLabel.text = boss_pursuit

	record_set()


	if (Main.db["difficulty_save"] > -1 && (Main.db["pursuit"] == 2 || Main.db["adventure_health"] > 0)):
		$AdventureMode / ContinueButton.visible = true
		if (Main.db["difficulty_save"] == 0): $AdventureMode / ContinueButton / ProgressControl / DifficultyLabel.text = beginner
		elif (Main.db["difficulty_save"] == 1): $AdventureMode / ContinueButton / ProgressControl / DifficultyLabel.text = novice
		elif (Main.db["difficulty_save"] == 2): $AdventureMode / ContinueButton / ProgressControl / DifficultyLabel.text = veteran
		elif (Main.db["difficulty_save"] == 3): $AdventureMode / ContinueButton / ProgressControl / DifficultyLabel.text = expert
		if (Main.db["pursuit_save"] == 0): $AdventureMode / ContinueButton / ProgressControl / DifficultyLabel.text += " " + casual
		elif (Main.db["pursuit_save"] == 1): $AdventureMode / ContinueButton / ProgressControl / DifficultyLabel.text += " " + normal
		elif (Main.db["pursuit_save"] == 2): $AdventureMode / ContinueButton / ProgressControl / DifficultyLabel.text += " " + pursuit

		if (Main.db["episode_save"] >= 0): $AdventureMode / ContinueButton / ProgressControl / EpisodeLabel.text = episode + var_to_str(Main.db["episode"])
		$AdventureMode / ContinueButton / ProgressControl / Number.frame = Main.db["adventure_levels_complete"]
		if (Main.db["adventure_master"] == true):
			$AdventureMode / ContinueButton / Face.visible = true
			$AdventureMode / ContinueButton / Health.visible = false
		else:
			$AdventureMode / ContinueButton / Health.visible = true
			$AdventureMode / ContinueButton / Health.frame = abs(Main.db["adventure_health"] - 3)
			$AdventureMode / ContinueButton / Health / Shield.frame = Main.db["adventure_shield"]


	if (Main.db["master"]):
		$Camera / MasterButton.set_pressed(true)


	$Camera / CoinContainer / Coins.text = var_to_str(Main.db["total_coin"])

	Main.practice = false
	custom_nine = false
	custom_ten = false
	custom_eleven = false


	$GridCustomizationScreen / Container / Viewport / GridCustomizer.rows = $FreePlayScreen / WidthSlider.value
	$GridCustomizationScreen / Container / Viewport / GridCustomizer.columns = $FreePlayScreen / LengthSlider.value
	$GridCustomizationScreen / Container / Viewport / GridCustomizer.build_board()

	if (FileAccess.file_exists("user://temp_img.png")): setup_grid_customizer("user://temp_img.png")


	if (Main.double):
		$FreePlayScreen / DoubleMineButton.set_pressed_no_signal(true)
		$FreePlayScreen / DoubleMineButton / OffOn.frame = true
		get_tree().call_group("double_controls", "set_visible", true)
	if (Main.anti):
		$FreePlayScreen / AntiMineButton.set_pressed_no_signal(true)
		$FreePlayScreen / AntiMineButton / OffOn.frame = true
		get_tree().call_group("anti_controls", "set_visible", true)

	if (Main.double_method):
		$FreePlayScreen / DoubleMineButton / DoubleProbabilitySlider.max_value = custom_game_mines
		if (Main.anti_method): $FreePlayScreen / DoubleMineButton / DoubleProbabilitySlider.max_value -= Main.anti_number
		$FreePlayScreen / DoubleMineButton / DoubleSetButton.set_disabled(true)
		$FreePlayScreen / DoubleMineButton / DoubleMineIndicator / TileLabel.text = double + " #"
	else:
		$FreePlayScreen / DoubleMineButton / DoubleProbabilitySlider.max_value = 100
		$FreePlayScreen / DoubleMineButton / DoubleProbabilityButton.set_disabled(true)
	if (Main.anti_method):
		$FreePlayScreen / AntiMineButton / AntiProbabilitySlider.max_value = custom_game_mines
		if (Main.double_method): $FreePlayScreen / AntiMineButton / AntiProbabilitySlider.max_value -= Main.double_number
		$FreePlayScreen / AntiMineButton / AntiSetButton.set_disabled(true)
		$FreePlayScreen / AntiMineButton / AntiMineIndicator / TileLabel.text = anti + " #"
	else:
		$FreePlayScreen / AntiMineButton / AntiProbabilitySlider.max_value = 100
		$FreePlayScreen / AntiMineButton / AntiProbabilityButton.set_disabled(true)

	$FreePlayScreen / DoubleMineButton / DoubleProbabilitySlider.value = Main.double_number
	$FreePlayScreen / AntiMineButton / AntiProbabilitySlider.value = Main.anti_number
	$FreePlayScreen / DoubleMineButton / DoubleMineIndicator.text = var_to_str(int($FreePlayScreen / DoubleMineButton / DoubleProbabilitySlider.value))
	$FreePlayScreen / AntiMineButton / AntiMineIndicator.text = var_to_str(int($FreePlayScreen / AntiMineButton / AntiProbabilitySlider.value))

	custom_double_mines = Main.double_number
	custom_anti_mines = Main.anti_number

	if (Main.db["adventure_wins"] <= 0):
		get_tree().call_group("level_select", "set_visible", false)
		$LevelSelectScreen / NoticeLabel.set_visible(true)
	if (Main.db["adventure_wins3"] <= 0):
		$LevelSelectScreen / LevelSelectLabel / EpisodeSelection.remove_item(2)
	if (Main.db["adventure_wins2"] <= 0):
		$LevelSelectScreen / LevelSelectLabel / EpisodeSelection.remove_item(1)


	$LevelSelectScreen / LevelSelectLabel / EpisodeSelection.select(Main.level_select_episode)
	$LevelSelectScreen / LevelSelectLabel / DifficultySelection.select(Main.level_select_difficulty)
	get_node("LevelContainer/Level" + var_to_str(Main.level_select_level) + "Box").set_pressed(true)
	get_node("LevelContainer/Level" + var_to_str(Main.level_select_level) + "Box/LevelSquare" + var_to_str(Main.level_select_level) + "/Background1").visible = false

	var file
	var next
	for i in range(3):
		next = var_to_str(i + 1)
		file = FileAccess.open("user://" + next + ".txt", FileAccess.READ)

		get_node("FreePlayScreen/CustomPresets/Preset" + next + "Button/Preset" + next + "Label").text = file.get_line()
		file.close()

	$GridCustomizationScreen / Container / Viewport / GridCustomizer.update_tiles.connect(_update_grid_tiles)

	for i in range(12):
		get_node("LevelContainer/Level" + var_to_str(i + 1) + "Box/LevelSquare" + var_to_str(i + 1) + "/Icon").play(var_to_str(i + 1))
		get_node("LevelContainer/Level" + var_to_str(i + 1) + "Box/LevelSquare" + var_to_str(i + 1) + "/Icon").visible = true

	_on_episode_selection_item_selected(Main.level_select_episode)
	Main.level_select = false


	custom_game_bgm = Main.db["custom_bgm"]
	custom_bgm_string = var_to_str(custom_game_bgm)
	last_bgm = custom_game_bgm
	if (custom_game_bgm == 9 || custom_game_bgm == 10 || custom_game_bgm == 11):
		get_node("FreePlayScreen/Challenge" + custom_bgm_string + "/MusicBoss" + custom_bgm_string).set_pressed_no_signal(true)
	else:
		get_node("MusicContainer/Music" + custom_bgm_string + "Box").set_pressed_no_signal(true)
	if (custom_game_bgm < 9 || custom_game_bgm > 11):
		get_node("MusicContainer/Music" + custom_bgm_string + "Box/MusicSquare" + custom_bgm_string + "/Background1").set_visible(false)
	else:
		get_node("FreePlayScreen/Challenge" + custom_bgm_string + "/MusicBoss" + custom_bgm_string + "/MusicSquare" + custom_bgm_string + "/Background1").set_visible(false)

	if (custom_game_bgm < 13 || custom_game_bgm > 13):
		get_node("Music" + custom_bgm_string).play()
	for i in range(8):
		get_node("MusicContainer/Music" + var_to_str(i + 1) + "Box/MusicSquare" + var_to_str(i + 1) + "/Icon").visible = true
		get_node("MusicContainer/Music" + var_to_str(i + 1) + "Box/MusicSquare" + var_to_str(i + 1) + "/Icon").play(var_to_str(i + 1))
	for i in range(9, 12):
		get_node("FreePlayScreen/Challenge" + var_to_str(i) + "/MusicBoss" + var_to_str(i) + "/MusicSquare" + var_to_str(i) + "/Icon").visible = true
		get_node("FreePlayScreen/Challenge" + var_to_str(i) + "/MusicBoss" + var_to_str(i) + "/MusicSquare" + var_to_str(i) + "/Icon").play(var_to_str(i))
	get_node("MusicContainer/Music12Box/MusicSquare12/Icon").visible = true
	get_node("MusicContainer/Music12Box/MusicSquare12/Icon").play("-0")
	get_node("MusicContainer/Music14Box/MusicSquare14/Icon").visible = true
	get_node("MusicContainer/Music14Box/MusicSquare14/Icon").play("?")

	$Records / Popup.translate(Main.db["language"])
	$Settings / Popup.translate(Main.db["language"])


func _process(_delta: float) -> void :
	if ($Camera.position[0] >= -1200 && show_custom_tiles == true):
		get_tree().call_group("custom_tiles", "set_visible", false)
		show_custom_tiles = false
	elif ($Camera.position[0] < -1200 && show_custom_tiles == false):
		get_tree().call_group("custom_tiles", "set_visible", true)
		show_custom_tiles = true


func _on_free_play_mouse_entered() -> void :
	$FreePlay / FreePlayPanel.visible = true
func _on_free_play_mouse_exited() -> void :
	$FreePlay / FreePlayPanel.visible = false
func _on_load_out_mouse_entered() -> void :
	$LoadOut / LoadOutPanel.visible = true
func _on_load_out_mouse_exited() -> void :
	$LoadOut / LoadOutPanel.visible = false
func _on_adventure_mode_mouse_entered() -> void :
	$AdventureMode / AdventurePanel.visible = true
func _on_adventure_mode_mouse_exited() -> void :
	$AdventureMode / AdventurePanel.visible = false
func _on_bonus_games_mouse_entered() -> void :
	$BonusGames / BonusPanel.visible = true
func _on_bonus_games_mouse_exited() -> void :
	$BonusGames / BonusPanel.visible = false


func _on_adventure_mode_pressed() -> void :
	get_tree().call_group("main_buttons", "set_disabled", true)
	$CameraMoveTimer.stop()
	$Camera.position[0] = shifts * 1152
	left_to_move[0] = 1152
	shift_array.append(0)
	shifts += 1
	$CameraMoveTimer.start()
	customizer_reset()

func _on_bonus_games_pressed() -> void :
	get_tree().call_group("main_buttons", "set_disabled", true)
	$CameraMoveTimer.stop()
	$Camera.position[1] = shifts * 960
	left_to_move[1] = 960
	shift_array.append(1)
	shifts += 1
	$CameraMoveTimer.start()
	customizer_reset()


func _on_free_play_pressed() -> void :
	get_tree().call_group("main_buttons", "set_disabled", true)
	$CameraMoveTimer.stop()
	$Camera.position[0] = - (shifts * 1152)
	left_to_move[0] = -1152
	shift_array.append(2)
	shifts += 1
	$CameraMoveTimer.start()
	customizer_reset()

func _on_load_out_pressed() -> void :
	get_tree().call_group("main_buttons", "set_disabled", true)
	$CameraMoveTimer.stop()
	$Camera.position[1] = - (shifts * 960)
	left_to_move[1] = -960
	shift_array.append(3)
	shifts += 1
	$CameraMoveTimer.start()
	customizer_reset()


func _on_back_button_pressed() -> void :
	if (shifts > 0):
		get_tree().call_group("main_buttons", "set_disabled", false)
		$CameraMoveTimer.stop()
		var m = shift_array.pop_back()
		if (m == 0):
			$Camera.position[0] = 1152 * shifts
			left_to_move[0] = -1152
			$CameraMoveTimer.start()
		elif (m == 2):
			$Camera.position[0] = -1152 * shifts
			left_to_move[0] = 1152
			$CameraMoveTimer.start()
		elif (m == 1):
			$Camera.position[1] = 960 * shifts
			left_to_move[1] = -960
			$CameraMoveTimer.start()
		elif (m == 3):
			$Camera.position[1] = -960 * shifts
			left_to_move[1] = 960
			$CameraMoveTimer.start()
		shifts -= 1
	else:
		if (custom_game_bgm < 13):
			get_node("Music" + custom_bgm_string).stop()
		$Start.play()
		get_tree().call_group("buttons", "set_disabled", true)
		await get_tree().create_timer(0.5).timeout
		await fade_out()
		get_tree().change_scene_to_file("res://main.tscn")



func move_camera() -> void :
	$Camera.position += move_vector
	if ($Camera.position[0] < -1200 && customizer_visible == false):
		$GridCustomizationScreen.set_visible(true)
		customizer_visible = true
	elif ($Camera.position[0] >= -1200):
		$GridCustomizationScreen.set_visible(false)
		customizer_visible = false


func _on_camera_move_timer_timeout() -> void :
	move_vector = left_to_move * (5 * get_process_delta_time())
	move_camera()
	left_to_move -= move_vector
	if (left_to_move[0] <= 0.01 && left_to_move[0] >= -0.01
	&& left_to_move[1] <= 0.01 && left_to_move[1] >= -0.01):
		$CameraMoveTimer.stop()
		left_to_move = Vector2(0, 0)

func customizer_reset() -> void :
	$Camera / LoadingLabel.set_visible(true)
	if ($GridCustomizationScreen / Container / Viewport / GridCustomizer.rows != int($FreePlayScreen / WidthSlider.value) || 
	$GridCustomizationScreen / Container / Viewport / GridCustomizer.columns != int($FreePlayScreen / LengthSlider.value)):
		$GridCustomizationScreen / Container / Viewport / GridCustomizer.reset_board($FreePlayScreen / LengthSlider.value, $FreePlayScreen / WidthSlider.value)
	$Camera / LoadingLabel.set_visible(false)

func _on_easy_button_toggled(_toggled_on: bool) -> void :
	adventure_difficulty = 0
	$AdventureModeScreen / StartAdventure / Lock.visible = false
	Main.db["difficulty"] = adventure_difficulty
	$AdventureModeScreen / ModePanel / ModeDescription.text = beginner_desc
	$AdventureModeScreen / EasyButton.modulate = Color(1, 1, 1, 1)
	$AdventureModeScreen / NoviceButton.set_pressed_no_signal(false)
	$AdventureModeScreen / NoviceButton.modulate = Color(0.5, 0.5, 0.5, 1)
	$AdventureModeScreen / NormalButton.set_pressed_no_signal(false)
	$AdventureModeScreen / NormalButton.modulate = Color(0.5, 0.5, 0.5, 1)
	$AdventureModeScreen / HardButton.set_pressed_no_signal(false)
	$AdventureModeScreen / HardButton.modulate = Color(0.5, 0.5, 0.5, 1)

func _on_novice_button_toggled(_toggled_on: bool) -> void :
	adventure_difficulty = 1
	$AdventureModeScreen / StartAdventure / Lock.visible = false
	Main.db["difficulty"] = adventure_difficulty
	$AdventureModeScreen / ModePanel / ModeDescription.text = novice_desc
	$AdventureModeScreen / NoviceButton.modulate = Color(1, 1, 1, 1)
	$AdventureModeScreen / EasyButton.set_pressed_no_signal(false)
	$AdventureModeScreen / EasyButton.modulate = Color(0.5, 0.5, 0.5, 1)
	$AdventureModeScreen / NormalButton.set_pressed_no_signal(false)
	$AdventureModeScreen / NormalButton.modulate = Color(0.5, 0.5, 0.5, 1)
	$AdventureModeScreen / HardButton.set_pressed_no_signal(false)
	$AdventureModeScreen / HardButton.modulate = Color(0.5, 0.5, 0.5, 1)


func _on_normal_button_toggled(_toggled_on: bool) -> void :
	adventure_difficulty = 2
	$AdventureModeScreen / StartAdventure / Lock.visible = false
	Main.db["difficulty"] = adventure_difficulty
	$AdventureModeScreen / ModePanel / ModeDescription.text = veteran_desc
	$AdventureModeScreen / NormalButton.modulate = Color(1, 1, 1, 1)
	$AdventureModeScreen / EasyButton.set_pressed_no_signal(false)
	$AdventureModeScreen / EasyButton.modulate = Color(0.5, 0.5, 0.5, 1)
	$AdventureModeScreen / NoviceButton.set_pressed_no_signal(false)
	$AdventureModeScreen / NoviceButton.modulate = Color(0.5, 0.5, 0.5, 1)
	$AdventureModeScreen / HardButton.set_pressed_no_signal(false)
	$AdventureModeScreen / HardButton.modulate = Color(0.5, 0.5, 0.5, 1)


func _on_hard_button_toggled(_toggled_on: bool) -> void :
	adventure_difficulty = 3
	$AdventureModeScreen / StartAdventure / Lock.visible = false
	Main.db["difficulty"] = adventure_difficulty
	$AdventureModeScreen / ModePanel / ModeDescription.text = expert_desc
	$AdventureModeScreen / HardButton.modulate = Color(1, 1, 1, 1)
	$AdventureModeScreen / EasyButton.set_pressed_no_signal(false)
	$AdventureModeScreen / EasyButton.modulate = Color(0.5, 0.5, 0.5, 1)
	$AdventureModeScreen / NoviceButton.set_pressed_no_signal(false)
	$AdventureModeScreen / NoviceButton.modulate = Color(0.5, 0.5, 0.5, 1)
	$AdventureModeScreen / NormalButton.set_pressed_no_signal(false)
	$AdventureModeScreen / NormalButton.modulate = Color(0.5, 0.5, 0.5, 1)


func _on_start_adventure_pressed() -> void :
	Main.db["adventures_started"] += 1

	if (Main.db["episode"] == 1 && Main.db["pursuit"] == 2):
		custom_nine = true
		Main.db["nine_time"] = 999
		Main.db["nine_strikes"] = 0
		Main.db["nine_custom_difficulty"] = adventure_difficulty
	else: custom_nine = false
	if (Main.db["episode"] == 2 && Main.db["pursuit"] == 2):
		custom_ten = true
		Main.db["nine_time"] = 0
		Main.db["nine_strikes"] = 0
		Main.db["ten_custom_difficulty"] = adventure_difficulty
	else: custom_ten = false
	if (Main.db["episode"] == 3 && Main.db["pursuit"] == 2):
		custom_eleven = true
		Main.db["nine_strikes"] = 0
		Main.db["eleven_custom_difficulty"] = adventure_difficulty
	else: custom_eleven = false

	if (custom_game_bgm < 13):
		get_node("Music" + var_to_str(custom_game_bgm)).stop()
	$Start.play()
	get_tree().call_group("buttons", "set_disabled", true)
	get_tree().call_group("other_controls", "set_editable", false)
	Main.db["adventure_levels_complete"] = 0
	Main.db["adventure_position"] = 0
	Main.db["current_coin"] = 100 * Main.db["episode"]
	Main.adventure_mode = true
	Main.db["adventure_health"] = 3
	Main.db["adventure_shield"] = 0
	Main.db["difficulty_save"] = adventure_difficulty
	Main.db["pursuit_save"] = Main.db["pursuit"]
	Main.db["episode_save"] = Main.db["episode"]
	Main.db["mistakes"] = 0
	Main.db["game_overs"] = 0
	if (Main.db["master"] == true): Main.db["adventure_master"] = true
	else: Main.db["adventure_master"] = false
	Main.practice = false
	await get_tree().create_timer(0.5).timeout
	await fade_out()
	get_tree().change_scene_to_file("res://adventure_map.tscn")


func _on_continue_button_pressed() -> void :
	if (custom_game_bgm < 13):
		get_node("Music" + custom_bgm_string).stop()

	Main.db["episode"] = Main.db["episode_save"]
	if (Main.db["episode"] == 1 && Main.db["pursuit"] == 2): custom_nine = true
	else: custom_nine = false
	if (Main.db["episode"] == 2 && Main.db["pursuit"] == 2): custom_ten = true
	else: custom_ten = false
	if (Main.db["episode"] == 3 && Main.db["pursuit"] == 2): custom_eleven = true
	else: custom_eleven = false

	$Start.play()
	get_tree().call_group("buttons", "set_disabled", true)
	get_tree().call_group("other_controls", "set_editable", false)
	Main.adventure_mode = true
	Main.db["difficulty"] = Main.db["difficulty_save"]
	Main.db["pursuit"] = Main.db["pursuit_save"]
	if (Main.db["adventure_master"] == true): Main.db["master"] = true
	else: Main.db["master"] = false
	Main.practice = false
	await get_tree().create_timer(0.5).timeout
	await fade_out()
	get_tree().change_scene_to_file("res://adventure_map.tscn")

func _on_challenge_button_pressed() -> void :
	Main.challenge = true
	Main.practice = false
	custom_nine = false
	custom_ten = false
	custom_eleven = false


	_on_start_custom_game_pressed()

func _on_endless_button_pressed() -> void :
	Main.endless = true
	Main.practice = false
	custom_nine = false
	Main.nine_count = 0
	custom_ten = false
	Main.ten_count = 0
	custom_eleven = false
	Main.eleven_count = 0
	Main.db["endless_last"] = 0
	Main.db["total_coin"] += Main.db["endless_last_coins"]
	Main.db["endless_last_coins"] = 0
	Main.db["endless_health"] = 3
	Main.db["endless_shield"] = 0
	Main.db["endless_last_length"] = 10;
	Main.db["endless_last_width"] = 10;
	Main.db["endless_difficulty"] = endless_diff_temp
	Main.db["endless_modifier"] = endless_mod_temp
	if (Main.db["endless_difficulty"] == 0): Main.db["endless_last_mines"] = 8;
	elif (Main.db["endless_difficulty"] == 1): Main.db["endless_last_mines"] = 10;
	elif (Main.db["endless_difficulty"] == 2): Main.db["endless_last_mines"] = 12;
	elif (Main.db["endless_difficulty"] == 3): Main.db["endless_last_mines"] = 15;
	Main.double_method = false
	Main.anti_method = false
	if (Main.db["endless_modifier"] == 0):
		Main.double = false
		Main.anti = false
	if (Main.db["endless_modifier"] == 1):
		Main.double = true
		Main.anti = false
		custom_double_mines = 10;
	if (Main.db["endless_modifier"] == 2):
		Main.double = false
		Main.anti = true
		custom_anti_mines = 10;
	if (Main.db["endless_modifier"] == 3):
		Main.double = true
		custom_double_mines = 10;
		Main.anti = true
		custom_anti_mines = 10;
	Main.game_style = custom_game_style;Main.db["custom_style"] = custom_game_style
	Main.game_bgm = custom_game_bgm;Main.db["custom_bgm"] = custom_game_bgm
	Main.adventure_mode = false



	_on_start_custom_game_pressed()

func _on_continue_endless_button_pressed() -> void :
	Main.endless = true
	Main.practice = false
	custom_nine = false
	Main.nine_count = 0
	custom_ten = false
	Main.ten_count = 0
	custom_eleven = false
	Main.eleven_count = 0
	Main.double_method = false
	Main.anti_method = false
	Main.double = false
	Main.anti = false
	if (Main.db["endless_modifier"] == 1 || Main.db["endless_modifier"] == 3):
		Main.double = true
		Main.double_number = 10 + (Main.db["endless_difficulty"] + 1) * Main.db["endless_last"]
		if (Main.double_number > 50): Main.double_number = 50
	if (Main.db["endless_modifier"] == 2 || Main.db["endless_modifier"] == 3):
		Main.anti = true
		Main.anti_number = 10 + (Main.db["endless_difficulty"] + 1) * Main.db["endless_last"]
		if (Main.anti_number > 50): Main.anti_number = 50
	Main.game_style = custom_game_style;Main.db["custom_style"] = custom_game_style
	Main.game_bgm = custom_game_bgm;Main.db["custom_bgm"] = custom_game_bgm
	Main.adventure_mode = false
	_on_start_custom_game_pressed()

func _on_challenge_button_mouse_entered() -> void :
	$BonusGamesScreen / ChallengeDescription.visible = true

func _on_challenge_button_mouse_exited() -> void :
	$BonusGamesScreen / ChallengeDescription.visible = false

func _on_endless_button_mouse_entered() -> void :
	$BonusGamesScreen / EndlessDescription.visible = true

func _on_endless_button_mouse_exited() -> void :
	$BonusGamesScreen / EndlessDescription.visible = false


func _on_length_slider_value_changed(value: float) -> void :
	custom_game_length = value
	Main.db["custom_length"] = custom_game_length
	$FreePlayScreen / LengthEditor.text = var_to_str(custom_game_length)
	custom_game_tiles = custom_game_length * custom_game_width
	$FreePlayScreen / TileIndicator.text = var_to_str(custom_game_tiles)
	$FreePlayScreen / MineSlider.set_max(custom_game_tiles - 1)
	mine_percent = (float(custom_game_mines) / (float(custom_game_tiles)) * 100.0)
	$FreePlayScreen / MinePercent.text = var_to_str(mine_percent).left(5) + "%"
	$FreePlayScreen / Challenge11 / FlagSlider.max_value = custom_game_tiles - custom_game_mines


func _on_width_slider_value_changed(value: float) -> void :
	custom_game_width = value
	Main.db["custom_width"] = custom_game_width
	$FreePlayScreen / WidthEditor.text = var_to_str(custom_game_width)
	custom_game_tiles = custom_game_length * custom_game_width
	$FreePlayScreen / TileIndicator.text = var_to_str(custom_game_tiles)
	$FreePlayScreen / MineSlider.set_max(custom_game_tiles - 1)
	mine_percent = (float(custom_game_mines) / (float(custom_game_tiles)) * 100.0)
	$FreePlayScreen / MinePercent.text = var_to_str(mine_percent).left(5) + "%"
	$FreePlayScreen / Challenge11 / FlagSlider.max_value = custom_game_tiles - custom_game_mines


func _on_mine_slider_value_changed(value: float) -> void :
	custom_game_mines = value
	Main.db["custom_mines"] = custom_game_mines
	$FreePlayScreen / MineEditor.text = var_to_str(custom_game_mines)
	mine_percent = (float(custom_game_mines) / (float(custom_game_tiles)) * 100.0)
	$FreePlayScreen / MinePercent.text = var_to_str(mine_percent).left(5) + "%"
	$FreePlayScreen / Challenge11 / FlagSlider.max_value = custom_game_tiles - custom_game_mines
	$FreePlayScreen / Challenge11 / FlagSlider.min_value = - custom_game_mines + 1

	if (Main.anti_method && Main.double_method):
		if ($FreePlayScreen / DoubleMineButton / DoubleProbabilitySlider.value + 
		$FreePlayScreen / AntiMineButton / AntiProbabilitySlider.value > custom_game_mines):
			if ($FreePlayScreen / DoubleMineButton / DoubleProbabilitySlider.max_value > $FreePlayScreen / AntiMineButton / AntiProbabilitySlider.max_value):
				$FreePlayScreen / DoubleMineButton / DoubleProbabilitySlider.max_value = custom_game_mines - $FreePlayScreen / AntiMineButton / AntiProbabilitySlider.value
			else: $FreePlayScreen / AntiMineButton / AntiProbabilitySlider.max_value = custom_game_mines - $FreePlayScreen / DoubleMineButton / DoubleProbabilitySlider.value
		else:
			$FreePlayScreen / DoubleMineButton / DoubleProbabilitySlider.max_value = custom_game_mines - $FreePlayScreen / AntiMineButton / AntiProbabilitySlider.value
			$FreePlayScreen / AntiMineButton / AntiProbabilitySlider.max_value = custom_game_mines - $FreePlayScreen / DoubleMineButton / DoubleProbabilitySlider.value
	elif (Main.double_method):
		$FreePlayScreen / DoubleMineButton / DoubleProbabilitySlider.max_value = custom_game_mines
	elif (Main.anti_method):
		$FreePlayScreen / AntiMineButton / AntiProbabilitySlider.max_value = custom_game_mines
	else: pass


func _on_length_editor_text_changed(new_text: String) -> void :
	if ( !new_text.is_valid_int()):
		$FreePlayScreen / LengthEditor.text = var_to_str(custom_game_length)
	elif (str_to_var(new_text) <= $FreePlayScreen / LengthSlider.min_value):
		$FreePlayScreen / LengthSlider.value = $FreePlayScreen / LengthSlider.min_value
	elif (str_to_var(new_text) >= $FreePlayScreen / LengthSlider.max_value):
		$FreePlayScreen / LengthSlider.value = $FreePlayScreen / LengthSlider.max_value
	else:
		$FreePlayScreen / LengthSlider.value = str_to_var(new_text)


func _on_width_editor_text_changed(new_text: String) -> void :
	if ( !new_text.is_valid_int()):
		$FreePlayScreen / WidthEditor.text = var_to_str(custom_game_width)
	elif (str_to_var(new_text) <= $FreePlayScreen / WidthSlider.min_value):
		$FreePlayScreen / WidthSlider.value = $FreePlayScreen / WidthSlider.min_value
	elif (str_to_var(new_text) >= $FreePlayScreen / WidthSlider.max_value):
		$FreePlayScreen / WidthSlider.value = $FreePlayScreen / WidthSlider.max_value
	else:
		$FreePlayScreen / WidthSlider.value = str_to_var(new_text)


func _on_mine_editor_text_changed(new_text: String) -> void :
	if ( !new_text.is_valid_int()):
		$FreePlayScreen / MineEditor.text = var_to_str(custom_game_mines)
	elif (str_to_var(new_text) <= 0):
		$FreePlayScreen / MineSlider.value = 0
	elif (str_to_var(new_text) >= (custom_game_tiles)):
		$FreePlayScreen / MineSlider.value = (custom_game_tiles) - 1
	else:
		$FreePlayScreen / MineSlider.value = str_to_var(new_text)


func _on_mine_percent_text_changed(new_text: String) -> void :
	new_text = new_text.trim_suffix("%")
	if ( !new_text.is_valid_float()):
		$FreePlayScreen / MineSlider.value = mine_percent
	elif (str_to_var(new_text) <= 0):
		$FreePlayScreen / MineSlider.value = 0
	elif (str_to_var(new_text) >= 100):
		$FreePlayScreen / MineSlider.value = $FreePlayScreen / MineSlider.max_value
	else:
		$FreePlayScreen / MineSlider.value = roundi((float(custom_game_tiles)) * (str_to_var(new_text)) / 100.0)

func _on_length_editor_focus_exited() -> void :
	_on_length_editor_text_changed($FreePlayScreen / LengthEditor.text)
func _on_width_editor_focus_exited() -> void :
	_on_width_editor_text_changed($FreePlayScreen / WidthEditor.text)
func _on_mine_editor_focus_exited() -> void :
	_on_mine_editor_text_changed($FreePlayScreen / MineEditor.text)
func _on_mine_percent_focus_exited() -> void :
	_on_mine_percent_text_changed($FreePlayScreen / MinePercent.text)


func _on_start_custom_game_pressed() -> void :
	if (custom_game_bgm < 13):
		get_node("Music" + custom_bgm_string).stop()
	$Start.play()
	get_tree().call_group("buttons", "set_disabled", true)
	get_tree().call_group("other_controls", "set_editable", false)
	Main.game_length = custom_game_length;Main.db["custom_length"] = custom_game_length
	Main.game_width = custom_game_width;Main.db["custom_width"] = custom_game_width
	Main.game_mines = custom_game_mines;Main.db["custom_mines"] = custom_game_mines
	Main.double_number = custom_double_mines
	Main.anti_number = custom_anti_mines
	Main.game_style = custom_game_style;Main.db["custom_style"] = custom_game_style
	Main.game_bgm = custom_game_bgm;Main.db["custom_bgm"] = custom_game_bgm
	Main.adventure_mode = false
	create_png("user://temp_img.png")
	await get_tree().create_timer(0.5).timeout
	await fade_out()
	get_tree().change_scene_to_file("res://level.tscn")



func _on_style_1_box_pressed() -> void :
	change_style(1)
func _on_style_2_box_pressed() -> void :
	change_style(2)
func _on_style_3_box_pressed() -> void :
	change_style(3)
func _on_style_4_box_pressed() -> void :
	change_style(4)
func _on_style_5_box_pressed() -> void :
	change_style(5)
func _on_style_6_box_pressed() -> void :
	change_style(6)
func _on_style_7_box_pressed() -> void :
	change_style(7)
func _on_style_8_box_pressed() -> void :
	change_style(8)
func _on_style_9_box_pressed() -> void :
	change_style(9)
func _on_style_10_box_pressed() -> void :
	change_style(10)
func _on_style_11_box_pressed() -> void :
	change_style(11)
func _on_style_101_box_pressed() -> void :
	change_style(101)
func _on_style_102_box_pressed() -> void :
	change_style(102)
func _on_style_103_box_pressed() -> void :
	change_style(103)

func change_style(style) -> void :
	custom_game_style = style
	custom_style_string = var_to_str(style)
	get_tree().call_group("style_box", "reset_style_tile")
	get_node("StyleContainer/Style" + custom_style_string + "Box/StyleSquare" + custom_style_string + "/Background1").visible = false
	get_node("StyleContainer/Style" + custom_style_string + "Box/StyleSquare" + custom_style_string + "/Background1Low").visible = false
	get_tree().call_group("style_box", "set_pressed_no_signal", false)
	get_node("StyleContainer/Style" + custom_style_string + "Box").set_pressed_no_signal(true)
	get_tree().call_group("tiles", "play_anim", custom_game_style)


func _on_music_1_box_pressed() -> void :
	change_music(1)
func _on_music_2_box_pressed() -> void :
	change_music(2)
func _on_music_3_box_pressed() -> void :
	change_music(3)
func _on_music_4_box_pressed() -> void :
	change_music(4)
func _on_music_5_box_pressed() -> void :
	change_music(5)
func _on_music_6_box_pressed() -> void :
	change_music(6)
func _on_music_7_box_pressed() -> void :
	change_music(7)
func _on_music_8_box_pressed() -> void :
	change_music(8)
func _on_music_boss_9_pressed() -> void :
	change_music(9)
func _on_music_boss_10_pressed() -> void :
	change_music(10)
func _on_music_boss_11_pressed() -> void :
	change_music(11)
func _on_music_12_box_pressed() -> void :
	change_music(12)
func _on_music_13_box_pressed() -> void :
	change_music(13)
func _on_music_14_box_pressed() -> void :
	change_music(14)

func change_music(music) -> void :
	var position = 0.0
	if (custom_game_bgm != 13): position = get_node("Music" + custom_bgm_string).get_playback_position()
	custom_game_bgm = music
	custom_bgm_string = var_to_str(music)
	get_tree().call_group("music", "stop")
	if (custom_game_bgm != 13): get_node("Music" + custom_bgm_string).play(position)
	get_tree().call_group("music_box", "reset_music_tile")
	if (music != 9 && music != 10 && music != 11):
		get_node("MusicContainer/Music" + custom_bgm_string + "Box/MusicSquare" + custom_bgm_string + "/Background1").visible = false
		get_node("MusicContainer/Music" + custom_bgm_string + "Box/MusicSquare" + custom_bgm_string + "/Background1Low").visible = false
	else:
		get_node("FreePlayScreen/Challenge" + custom_bgm_string + "/MusicBoss" + custom_bgm_string + "/MusicSquare" + custom_bgm_string + "/Background1").visible = false
		get_node("FreePlayScreen/Challenge" + custom_bgm_string + "/MusicBoss" + custom_bgm_string + "/MusicSquare" + custom_bgm_string + "/Background1Low").visible = false
func _on_costume_1_box_pressed() -> void :
	change_costume(1)
func _on_costume_2_box_pressed() -> void :
	change_costume(2)
func _on_costume_3_box_pressed() -> void :
	change_costume(3)
func _on_costume_4_box_pressed() -> void :
	change_costume(4)
func _on_costume_5_box_pressed() -> void :
	change_costume(5)
func _on_costume_6_box_pressed() -> void :
	change_costume(6)
func _on_costume_7_box_pressed() -> void :
	change_costume(7)
func _on_costume_8_box_pressed() -> void :
	change_costume(8)

func change_costume(costume) -> void :
	if (costume == 5 && Main.db["costume"] != 5 && Main.db["face"] > 0):
		$LoadOutScreen / Background / Face.position[1] = 16
	elif (costume != 5 && Main.db["costume"] == 5 && Main.db["face"] > 0):
		$LoadOutScreen / Background / Face.position[1] = 24
	Main.db["costume"] = costume
	$LoadOutScreen / Background / Hat.play("hat" + var_to_str(costume) + "_f")
	get_tree().call_group("costume_box", "reset_face_tile")
	get_node("CostumeContainer/Costume" + var_to_str(costume) + "Box/CostumeSquare" + var_to_str(costume) + "/Flag").visible = true

func _on_face_1_box_pressed() -> void :
	change_face(1)
func _on_face_2_box_pressed() -> void :
	change_face(2)
func _on_face_3_box_pressed() -> void :
	change_face(3)
func _on_face_4_box_pressed() -> void :
	change_face(4)
func _on_face_5_box_pressed() -> void :
	change_face(5)
func _on_face_6_box_pressed() -> void :
	change_face(6)
func _on_face_7_box_pressed() -> void :
	change_face(7)
func _on_face_8_box_pressed() -> void :
	change_face(8)
func _on_custom_face_box_pressed() -> void :
	change_face(0)
	$LoadOutScreen / Background / Hat.visible = false

func change_face(face) -> void :
	Main.db["face"] = face
	$LoadOutScreen / Background / Face.play("face" + var_to_str(face) + "_:)f")
	get_tree().call_group("face_box", "reset_face_tile")

	if face > 0:
		get_node("FaceContainer/Face" + var_to_str(face) + "Box/FaceSquare" + var_to_str(face) + "/Flag").visible = true
		$LoadOutScreen / Background / Hat.visible = true
		change_costume(Main.db["costume"])
		$LoadOutScreen / Background / Face.visible = true
		$LoadOutScreen / Background / Face2.visible = false

	else:
		get_node("LoadOutScreen/CustomFaceBox/FaceSquare/Flag").visible = true
		$LoadOutScreen / Background / Face.visible = false
		$LoadOutScreen / Background / Face2.visible = true


func _on_level_1_box_pressed() -> void :
	level_choice(1)
func _on_level_2_box_pressed() -> void :
	level_choice(2)
func _on_level_3_box_pressed() -> void :
	level_choice(3)
func _on_level_4_box_pressed() -> void :
	level_choice(4)
func _on_level_5_box_pressed() -> void :
	level_choice(5)
func _on_level_6_box_pressed() -> void :
	level_choice(6)
func _on_level_7_box_pressed() -> void :
	level_choice(7)
func _on_level_8_box_pressed() -> void :
	level_choice(8)
func _on_level_9_box_pressed() -> void :
	level_choice(9)
func _on_level_10_box_pressed() -> void :
	level_choice(10)
func _on_level_11_box_pressed() -> void :
	level_choice(11)
func _on_level_12_box_pressed() -> void :
	level_choice(12)

func level_choice(choice) -> void :
	Main.level_select_level = choice
	$LevelSelectScreen / StageNameLabel.text = stage_name_getter(choice, Main.level_select_episode)
	get_tree().call_group("level_box", "reset_style_tile")
	get_node("LevelContainer/Level" + var_to_str(choice) + "Box/LevelSquare" + var_to_str(choice) + "/Background1").visible = false
	get_node("LevelContainer/Level" + var_to_str(choice) + "Box/LevelSquare" + var_to_str(choice) + "/Background1Low").visible = false


func _on_master_button_toggled(toggled_on: bool) -> void :
	if (toggled_on):
		Main.db["master"] = true
		$Camera / MasterButton.tooltip_text = master_on
		$Camera / MasterButton / Face.set_frame(0)
	else:
		Main.db["master"] = false
		$Camera / MasterButton.tooltip_text = master_off
		$Camera / MasterButton / Face.set_frame(4)

	record_set()


func _on_master_button_button_down() -> void :
	$Camera / MasterButton / Face.set_frame(8)


func _on_master_button_button_up() -> void :
	if (Main.db["master"]):
		$Camera / MasterButton / Face.set_frame(0)
	else:
		$Camera / MasterButton / Face.set_frame(4)

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

func _on_practice_button_toggled(_toggled_on: bool) -> void :
	Main.practice = !Main.practice
	$FreePlayScreen / PracticeButton / OffOn.frame = ($FreePlayScreen / PracticeButton / OffOn.frame + 1) % 2
	if (Main.nine):
		_on_challenge_9_button_toggled(true)
	if (Main.ten):
		_on_challenge_10_button_toggled(true)

func _on_challenge_9_button_toggled(_toggled_on: bool) -> void :
	custom_nine = !custom_nine
	if (custom_nine):
		if ($FreePlayScreen / Challenge9 / NumberEditor.text == "0"):
			Main.nine_count = 1
			$FreePlayScreen / Challenge9 / NumberEditor.text = "1"
		else:
			Main.nine_count = str_to_var($FreePlayScreen / Challenge9 / NumberEditor.text)
	else:
		Main.nine_count = 0
	$FreePlayScreen / Challenge9 / Challenge9Button / OffOn.frame = ($FreePlayScreen / Challenge9 / Challenge9Button / OffOn.frame + 1) % 2
	get_tree().call_group("nine_controls", "set_visible", custom_nine)
	if (custom_nine):
		if (custom_game_bgm != 10 && custom_game_bgm != 11):
			last_bgm = custom_game_bgm
		_on_music_boss_9_pressed()
		$FreePlayScreen / MineSlider.min_value = 8 * Main.nine_count
	else:
		if (custom_eleven):
			_on_music_boss_11_pressed()
		elif (custom_ten):
			_on_music_boss_10_pressed()
		elif (custom_game_bgm == 9 || custom_game_bgm == 10 || custom_game_bgm == 11):
			change_music(last_bgm)
		$FreePlayScreen / MineSlider.min_value = 0

func _on_challenge_10_button_toggled(_toggled_on: bool) -> void :
	custom_ten = !custom_ten
	if (custom_ten):
		if ($FreePlayScreen / Challenge10 / NumberEditor.text == "0"):
			Main.ten_count = 1
			$FreePlayScreen / Challenge10 / NumberEditor.text = "1"
		else:
			Main.ten_count = str_to_var($FreePlayScreen / Challenge10 / NumberEditor.text)
	else:
		Main.ten_count = 0
	$FreePlayScreen / Challenge10 / Challenge10Button / OffOn.frame = ($FreePlayScreen / Challenge10 / Challenge10Button / OffOn.frame + 1) % 2
	get_tree().call_group("ten_controls", "set_visible", custom_ten)
	if (custom_ten):
		if (custom_game_bgm != 9 && custom_game_bgm != 11):
			last_bgm = custom_game_bgm
		_on_music_boss_10_pressed()
	else:
		if (custom_eleven):
			_on_music_boss_11_pressed()
		elif (custom_nine):
			_on_music_boss_9_pressed()
		elif (custom_game_bgm == 10 || custom_game_bgm == 9 || custom_game_bgm == 11):
			change_music(last_bgm)

func _on_challenge_11_button_toggled(_toggled_on: bool) -> void :
	custom_eleven = !custom_eleven
	if (custom_eleven):
		if ($FreePlayScreen / Challenge11 / NumberEditor.text == "0"):
			Main.eleven_count = 1
			$FreePlayScreen / Challenge11 / NumberEditor.text = "1"
		else:
			Main.eleven_count = str_to_var($FreePlayScreen / Challenge11 / NumberEditor.text)
	else:
		Main.eleven_count = 0
	$FreePlayScreen / Challenge11 / Challenge11Button / OffOn.frame = ($FreePlayScreen / Challenge11 / Challenge11Button / OffOn.frame + 1) % 2
	get_tree().call_group("eleven_controls", "set_visible", custom_eleven)
	if (custom_eleven):
		if (custom_game_bgm != 9 && custom_game_bgm != 10):
			last_bgm = custom_game_bgm
		_on_music_boss_11_pressed()
	else:
		if (custom_ten):
			_on_music_boss_10_pressed()
		elif (custom_nine):
			_on_music_boss_9_pressed()
		elif (custom_game_bgm == 11 || custom_game_bgm == 9 || custom_game_bgm == 10):
			change_music(last_bgm)

func _on_difficulty_selection_9_item_selected(index: int) -> void :
	Main.db["nine_custom_difficulty"] = index

func _on_difficulty_selection_10_item_selected(index: int) -> void :
	Main.db["ten_custom_difficulty"] = index

func _on_difficulty_selection_11_item_selected(index: int) -> void :
	Main.db["eleven_custom_difficulty"] = index

func _on_time_slider_value_changed(value: float) -> void :
	$FreePlayScreen / Challenge9 / TimeSlider / TimeLabel.text = var_to_str(int($FreePlayScreen / Challenge9 / TimeSlider.value)) + "s"
	Main.db["nine_custom_seconds"] = value

func _on_flag_slider_value_changed(value: float) -> void :
	$FreePlayScreen / Challenge11 / FlagSlider / FlagLabel.text = var_to_str(int($FreePlayScreen / Challenge11 / FlagSlider.value)) + " " + flag_handicap
	Main.db["flag_handicap"] = value

func _on_increment_9_button_pressed() -> void :
	var current = str_to_var($FreePlayScreen / Challenge9 / NumberEditor.get_text())
	current += 1
	if (current > 9): current = 9
	Main.nine_count = current
	$FreePlayScreen / Challenge9 / NumberEditor.set_text(var_to_str(current))
	$FreePlayScreen / MineSlider.min_value = 8 * Main.nine_count

func _on_increment_10_button_pressed() -> void :
	var current = str_to_var($FreePlayScreen / Challenge10 / NumberEditor.get_text())
	current += 1
	if (current > 10): current = 10
	Main.ten_count = current
	$FreePlayScreen / Challenge10 / NumberEditor.set_text(var_to_str(current))

func _on_increment_11_button_pressed() -> void :
	var current = str_to_var($FreePlayScreen / Challenge11 / NumberEditor.get_text())
	current += 1
	if (current > 11): current = 11
	Main.eleven_count = current
	$FreePlayScreen / Challenge11 / NumberEditor.set_text(var_to_str(current))

func _on_decrement_9_button_pressed() -> void :
	var current = str_to_var($FreePlayScreen / Challenge9 / NumberEditor.get_text())
	current -= 1
	if (current < 0): current = 0
	Main.nine_count = current
	$FreePlayScreen / Challenge9 / NumberEditor.set_text(var_to_str(current))
	$FreePlayScreen / MineSlider.min_value = 8 * Main.nine_count

func _on_decrement_10_button_pressed() -> void :
	var current = str_to_var($FreePlayScreen / Challenge10 / NumberEditor.get_text())
	current -= 1
	if (current < 0): current = 0
	Main.ten_count = current
	$FreePlayScreen / Challenge10 / NumberEditor.set_text(var_to_str(current))

func _on_decrement_11_button_pressed() -> void :
	var current = str_to_var($FreePlayScreen / Challenge11 / NumberEditor.get_text())
	current -= 1
	if (current < 0): current = 0
	Main.eleven_count = current
	$FreePlayScreen / Challenge11 / NumberEditor.set_text(var_to_str(current))


func stage_name_getter(frame: int, ep: int) -> String:
	var string
	if (ep == 0):
		if frame == 0: string = "--m --s"
		elif frame == 1: string = episode1_stages[0]
		elif frame == 2: string = episode1_stages[1]
		elif frame == 3: string = episode1_stages[2]
		elif frame == 4: string = episode1_stages[3]
		elif frame == 5: string = episode1_stages[4]
		elif frame == 6: string = episode1_stages[5]
		elif frame == 7: string = episode1_stages[6]
		elif frame == 8: string = episode1_stages[7]
		elif frame == 9: string = episode1_stages[8]
	elif (ep == 1):
		if frame == 0: string = "--m --s"
		elif frame == 1: string = episode2_stages[0]
		elif frame == 2: string = episode2_stages[1]
		elif frame == 3: string = episode2_stages[2]
		elif frame == 4: string = episode2_stages[3]
		elif frame == 5: string = episode2_stages[4]
		elif frame == 6: string = episode2_stages[5]
		elif frame == 7: string = episode2_stages[6]
		elif frame == 8: string = episode2_stages[7]
		elif frame == 9: string = episode2_stages[8]
		elif frame == 10: string = episode2_stages[9]
	elif (ep == 2):
		if frame == 0: string = "--m --s"
		elif frame == 1: string = "BUBBLY TUB"
		elif frame == 2: string = "STEAMY JACUZZI"
		elif frame == 3: string = "DANGER CREEK"
		elif frame == 4: string = "HAZARD CANAL"
		elif frame == 5: string = "FLOODED FJORD"
		elif frame == 6: string = "WACKY WHIRLPOOL"
		elif frame == 7: string = "BOMB BAY"
		elif frame == 8: string = "SHIP'S GRAVEYARD"
		elif frame == 9: string = "DELTA P"
		elif frame == 10: string = "HYDRAULIC SHOCK"
		elif frame == 11: string = "THE DEVIL'S LOCKER"
	else: string = "--m --s"
	return string

func record_set() -> void :
	var ep = Main.db["episode"] - 1
	var records_array = ["EasyButton/BeginnerRecordLabel", "NoviceButton/NoviceRecordLabel", "NormalButton/NormalRecordLabel", "HardButton/ExpertRecordLabel"]
	if (Main.db["pursuit"] != 0):
		var m
		if (Main.db["pursuit"] == 2): m = "pursuit"
		else: m = "adventure"
		if (Main.db["master"]): m += "_master"
		for i in range(4):
			if (Main.db[m + "_records"][ep][i] != 0.0):
				get_node("AdventureModeScreen/" + records_array[i]).text = Main.convert_time(Main.db[m + "_records"][ep][i])
	else:
		for i in range(4):
			get_node("AdventureModeScreen/" + records_array[i]).text = ""

	var buttons = ["Easy", "Novice", "Normal", "Hard"]
	var mode_array = ["nothing", "adventure", "pursuit"]

	$AdventureModeScreen / StartAdventure / Lock.visible = false
	if (Main.db["pursuit"] != 0):
		var mode = mode_array[Main.db["pursuit"]]
		var no_count = 0

		for i in range(4):
			get_node("AdventureModeScreen/" + buttons[i] + "Button/Lock").visible = false
			if (Main.db[mode + "_ranks"][ep][i] > -1):
				get_node("AdventureModeScreen/" + buttons[i] + "Button/Rank").frame = 5 - Main.db[mode + "_ranks"][ep][i]
				get_node("AdventureModeScreen/" + buttons[i] + "Button/Best").frame = 0
				get_node("AdventureModeScreen/" + buttons[i] + "Button/Rank").visible = true
			else:
				get_node("AdventureModeScreen/" + buttons[i] + "Button/Rank").visible = false
				get_node("AdventureModeScreen/" + buttons[i] + "Button/Best").frame = abs(Main.db[mode + "_ranks"][ep][i]) - 1
				if ( !Main.db["master"]): get_node("AdventureModeScreen/" + records_array[i]).text = stage_name_getter(get_node("AdventureModeScreen/" + buttons[i] + "Button/Best").frame, ep)

			if (Main.db[mode + "_master_ranks"][ep][i] > -1):
				get_node("AdventureModeScreen/" + buttons[i] + "Button/MasterRank").frame = 5 - Main.db[mode + "_master_ranks"][ep][i]
				get_node("AdventureModeScreen/" + buttons[i] + "Button/MasterBest").frame = 0
				get_node("AdventureModeScreen/" + buttons[i] + "Button/MasterRank").visible = true
			else:
				get_node("AdventureModeScreen/" + buttons[i] + "Button/MasterRank").visible = false
				get_node("AdventureModeScreen/" + buttons[i] + "Button/MasterBest").frame = abs(Main.db[mode + "_master_ranks"][ep][i]) - 1
				if (Main.db["master"]): get_node("AdventureModeScreen/" + records_array[i]).text = stage_name_getter(get_node("AdventureModeScreen/" + buttons[i] + "Button/MasterBest").frame, ep)
				if (get_node("AdventureModeScreen/" + buttons[i] + "Button/MasterBest").frame != 0):
					get_node("AdventureModeScreen/" + buttons[i] + "Button/MasterBest/Face").visible = true
				else: get_node("AdventureModeScreen/" + buttons[i] + "Button/MasterBest/Face").visible = false

			if (Main.db["pursuit"] == 2):
				if (Main.db["adventure_ranks"][ep][i] == -1):
					get_node("AdventureModeScreen/" + buttons[i] + "Button/Lock").visible = true
					no_count += 1
					if no_count == 4 || i == adventure_difficulty:
						$AdventureModeScreen / StartAdventure / Lock.visible = true
	else:
		for i in range(4):
			get_node("AdventureModeScreen/" + buttons[i] + "Button/Rank").visible = false
			get_node("AdventureModeScreen/" + buttons[i] + "Button/Best").frame = 0
			get_node("AdventureModeScreen/" + buttons[i] + "Button/MasterRank").visible = false
			get_node("AdventureModeScreen/" + buttons[i] + "Button/MasterBest").frame = 0
			get_node("AdventureModeScreen/" + buttons[i] + "Button/MasterBest/Face").visible = false
			get_node("AdventureModeScreen/" + buttons[i] + "Button/Lock").visible = false


func _on_left_button_pressed() -> void :
	Main.db["episode"] -= 1
	if (Main.db["episode"] == 0):
		Main.db["episode"] = 3

	$AdventureModeScreen / EpisodeLabel.text = episode + var_to_str(Main.db["episode"])
	if (Main.db["episode"] == 1):
		$AdventureModeScreen / StartAdventure / StartLock.visible = false
	elif (Main.db["episode"] == 2):
		if (Main.db["episode_unlock_array"][0] == 0 && Main.db["adventure_wins"] == 0):
			$AdventureModeScreen / StartAdventure / StartLock.visible = true
		else:
			$AdventureModeScreen / StartAdventure / StartLock.visible = false
	elif (Main.db["episode"] == 3):
		if (Main.db["episode_unlock_array"][1] == 0):
			$AdventureModeScreen / StartAdventure / StartLock.visible = true
		else:
			$AdventureModeScreen / StartAdventure / StartLock.visible = false
	else: $AdventureModeScreen / StartAdventure / StartLock.visible = true
	record_set()

func _on_left_gameplay_button_pressed() -> void :
	Main.db["pursuit"] -= 1
	if (Main.db["pursuit"] < 0): Main.db["pursuit"] = 2

	if (Main.db["pursuit"] == 0): $AdventureModeScreen / GameplayLabel.text = casual
	elif (Main.db["pursuit"] == 1): $AdventureModeScreen / GameplayLabel.text = normal
	elif (Main.db["pursuit"] == 2): $AdventureModeScreen / GameplayLabel.text = boss_pursuit
	record_set()

func _on_right_button_pressed() -> void :
	Main.db["episode"] += 1
	if (Main.db["episode"] == 4):
		Main.db["episode"] = 1

	$AdventureModeScreen / EpisodeLabel.text = episode + var_to_str(Main.db["episode"])
	if (Main.db["episode"] == 1):
		$AdventureModeScreen / StartAdventure / StartLock.visible = false
	elif (Main.db["episode"] == 2):
		if (Main.db["episode_unlock_array"][0] == 0 && Main.db["adventure_wins"] == 0):
			$AdventureModeScreen / StartAdventure / StartLock.visible = true
		else:
			$AdventureModeScreen / StartAdventure / StartLock.visible = false
	elif (Main.db["episode"] == 3):
		if (Main.db["episode_unlock_array"][1] == 0):
			$AdventureModeScreen / StartAdventure / StartLock.visible = true
		else:
			$AdventureModeScreen / StartAdventure / StartLock.visible = false
	else: $AdventureModeScreen / StartAdventure / StartLock.visible = true
	record_set()

func _on_right_gameplay_button_pressed() -> void :
	Main.db["pursuit"] = (Main.db["pursuit"] + 1) % 3

	if (Main.db["pursuit"] == 0): $AdventureModeScreen / GameplayLabel.text = casual
	elif (Main.db["pursuit"] == 1): $AdventureModeScreen / GameplayLabel.text = normal
	elif (Main.db["pursuit"] == 2): $AdventureModeScreen / GameplayLabel.text = boss_pursuit
	record_set()


func _on_beginner_button_pressed() -> void :
	$FreePlayScreen / LengthSlider.set_value(9)
	$FreePlayScreen / WidthSlider.set_value(9)
	$FreePlayScreen / MineSlider.set_value(10)


func _on_intermediate_button_pressed() -> void :
	$FreePlayScreen / LengthSlider.set_value(16)
	$FreePlayScreen / WidthSlider.set_value(16)
	$FreePlayScreen / MineSlider.set_value(40)


func _on_expert_button_pressed() -> void :
	$FreePlayScreen / LengthSlider.set_value(30)
	$FreePlayScreen / WidthSlider.set_value(16)
	$FreePlayScreen / MineSlider.set_value(99)

func _on_1_pressed() -> void :
	big_one_difficulty_change(1, Main.db["challenge_modifier"])
func _on_2_pressed() -> void :
	big_one_difficulty_change(2, Main.db["challenge_modifier"])
func _on_3_pressed() -> void :
	big_one_difficulty_change(3, Main.db["challenge_modifier"])
func _on_4_pressed() -> void :
	big_one_difficulty_change(4, Main.db["challenge_modifier"])
func _on_5_pressed() -> void :
	big_one_difficulty_change(5, Main.db["challenge_modifier"])
func _on_6_pressed() -> void :
	big_one_difficulty_change(6, Main.db["challenge_modifier"])
func _on_7_pressed() -> void :
	big_one_difficulty_change(7, Main.db["challenge_modifier"])
func _on_8_pressed() -> void :
	big_one_difficulty_change(8, Main.db["challenge_modifier"])
func _on_9_pressed() -> void :
	big_one_difficulty_change(9, Main.db["challenge_modifier"])

func _on_normal_challenge_pressed() -> void :
	big_one_difficulty_change(Main.db["challenge_difficulty"], 0)
func _on_double_challenge_pressed() -> void :
	big_one_difficulty_change(Main.db["challenge_difficulty"], 1)
func _on_anti_challenge_pressed() -> void :
	big_one_difficulty_change(Main.db["challenge_difficulty"], 2)
func _on_both_challenge_pressed() -> void :
	big_one_difficulty_change(Main.db["challenge_difficulty"], 3)

func big_one_difficulty_change(diff, mod) -> void :
	var best_time = Main.db["challenge_best"][mod][diff - 1]
	get_tree().call_group("challenge_difficulty_buttons", "set_pressed_no_signal", false)
	get_tree().call_group("challenge_modifier_buttons", "set_pressed_no_signal", false)
	$BonusGamesScreen / ChallengeButton / MinesLabel.text = var_to_str(diff * 111) + mines

	Main.db["challenge_difficulty"] = diff
	Main.db["challenge_modifier"] = mod
	modify_big_one(diff, mod)

	if (best_time < 1): $BonusGamesScreen / ChallengeButton / CompletionLabel.text = best + var_to_str(best_time * 100) + "%"
	else: $BonusGamesScreen / ChallengeButton / CompletionLabel.text = best + Main.convert_time(best_time)
	get_node("BonusGamesScreen/ChallengeButton/ButtonContainer/" + var_to_str(diff)).set_pressed_no_signal(true)
	get_node("BonusGamesScreen/ChallengeButton/ModifierContainer/" + mod_array[mod]).set_pressed_no_signal(true)

func modify_big_one(diff, mod) -> void :
	if (mod == 1):
		$BonusGamesScreen / ChallengeButton / MinesLabel.text += ": \n" + var_to_str(10 + ((diff - 1) * 5)) + "% DUO"

	elif (mod == 2):
		$BonusGamesScreen / ChallengeButton / MinesLabel.text += ": \n" + var_to_str(10 + ((diff - 1) * 5)) + "% ANTI"

	elif (mod == 3):
		$BonusGamesScreen / ChallengeButton / MinesLabel.text += ": \n" + var_to_str(10 + ((diff - 1) * 5)) + "% DUO & ANTI"

	else:
		pass

func _on_easy_pressed() -> void :
	long_haul_difficulty_change(0, endless_mod_temp)
func _on_medium_pressed() -> void :
	long_haul_difficulty_change(1, endless_mod_temp)
func _on_hard_pressed() -> void :
	long_haul_difficulty_change(2, endless_mod_temp)
func _on_extreme_pressed() -> void :
	long_haul_difficulty_change(3, endless_mod_temp)

func _on_normal_endless_pressed() -> void :
	long_haul_difficulty_change(endless_diff_temp, 0)
func _on_double_endless_pressed() -> void :
	long_haul_difficulty_change(endless_diff_temp, 1)
func _on_anti_endless_pressed() -> void :
	long_haul_difficulty_change(endless_diff_temp, 2)
func _on_both_endless_pressed() -> void :
	long_haul_difficulty_change(endless_diff_temp, 3)

func long_haul_difficulty_change(diff, mod) -> void :
	var best_stages = Main.db["endless_best"][mod][diff]
	get_tree().call_group("endless_difficulty_buttons", "set_pressed_no_signal", false)
	get_tree().call_group("endless_modifier_buttons", "set_pressed_no_signal", false)
	$BonusGamesScreen / EndlessButton / BestStages.text = "BEST: " + var_to_str(best_stages) + " STAGES"

	endless_diff_temp = diff
	endless_mod_temp = mod
	modify_endless(diff, mod)

	get_node("BonusGamesScreen/EndlessButton/DifficultyContainer/" + diff_array[diff]).set_pressed_no_signal(true)
	get_node("BonusGamesScreen/EndlessButton/ModifierContainer/" + mod_array[mod]).set_pressed_no_signal(true)

func modify_endless(diff, mod) -> void :
	if (diff == 0): $BonusGamesScreen / EndlessButton / CompletionLabel.text = "EASY DIFFICULTY"
	elif (diff == 1): $BonusGamesScreen / EndlessButton / CompletionLabel.text = "MEDIUM DIFFICULTY"
	elif (diff == 2): $BonusGamesScreen / EndlessButton / CompletionLabel.text = "HARD DIFFICULTY"
	elif (diff == 3): $BonusGamesScreen / EndlessButton / CompletionLabel.text = "EXTREME DIFFICULTY"
	if (mod == 1): $BonusGamesScreen / EndlessButton / CompletionLabel.text += "\nDUO MINES ACTIVE"
	elif (mod == 2): $BonusGamesScreen / EndlessButton / CompletionLabel.text += "\nANTI MINES ACTIVE"
	elif (mod == 3): $BonusGamesScreen / EndlessButton / CompletionLabel.text += "\nDUO & ANTI MINES ACTIVE"



func _on_exit_button_pressed() -> void :
	get_tree().quit()


func _on_costume_2_lock_pressed() -> void :
	var hat = "navy hat"
	if (Main.db["total_coin"] >= 500): costume_unlock_dialog(true, 0, 2, 500, hat)
	else: costume_unlock_dialog(false, 0, 2, 500, hat)

func _on_costume_3_lock_pressed() -> void :
	var hat = "camo hat"
	if (Main.db["total_coin"] >= 2000): costume_unlock_dialog(true, 1, 3, 2000, hat)
	else: costume_unlock_dialog(false, 1, 3, 2000, hat)

func _on_costume_4_lock_pressed() -> void :
	var hat = "gold hat"
	if (Main.db["total_coin"] >= 5000): costume_unlock_dialog(true, 2, 4, 5000, hat)
	else: costume_unlock_dialog(false, 2, 4, 5000, hat)

func _on_costume_5_lock_pressed() -> void :
	var hat = "bald hat"
	if (Main.db["total_coin"] >= 9999): costume_unlock_dialog(true, 3, 5, 9999, hat)
	else: costume_unlock_dialog(false, 3, 5, 9999, hat)

func _on_costume_6_lock_pressed() -> void :
	var hat = "anti hat"
	if (Main.db["total_coin"] >= 15000): costume_unlock_dialog(true, 4, 6, 15000, hat)
	else: costume_unlock_dialog(false, 4, 6, 15000, hat)

func _on_costume_7_lock_pressed() -> void :
	var hat = "double hat"
	if (Main.db["total_coin"] >= 20000): costume_unlock_dialog(true, 5, 7, 20000, hat)
	else: costume_unlock_dialog(false, 5, 7, 20000, hat)

func _on_costume_8_lock_pressed() -> void :
	var hat = "pirate hat"
	if (Main.db["total_coin"] >= 31415): costume_unlock_dialog(true, 6, 8, 31415, hat)
	else: costume_unlock_dialog(false, 6, 8, 31415, hat)

func costume_unlock_dialog(accepted, code, node, coins, text) -> void :
	if (accepted): $Camera / CostumeConfirmation.dialog_text = "Spend " + var_to_str(coins) + " Minecoins to unlock the " + text
	else: $Camera / CostumeConfirmation.dialog_text = "You need " + var_to_str(coins) + " Minecoins to unlock the " + text
	unlock_accepted = accepted
	unlock_code = code
	unlock_node_number = node
	unlock_coins = coins
	$Camera / CostumeConfirmation.visible = true

func face_unlock_dialog(accepted, code, node, coins, text) -> void :
	if (accepted): $Camera / FaceConfirmation.dialog_text = "Spend " + var_to_str(coins) + " Minecoins to unlock the " + text
	else: $Camera / FaceConfirmation.dialog_text = "You need " + var_to_str(coins) + " Minecoins to unlock the " + text
	unlock_accepted = accepted
	unlock_code = code
	unlock_node_number = node
	unlock_coins = coins
	$Camera / FaceConfirmation.visible = true

func _on_costume_confirmation_confirmed() -> void :
	if (unlock_accepted):
		Main.db["total_coin"] -= unlock_coins
		$Camera / CoinContainer / Coins.text = var_to_str(Main.db["total_coin"])

		Main.db["costume_unlock_array"][unlock_code] = 1
		await Main.save_game()

		get_node("CostumeContainer/Costume" + var_to_str(unlock_node_number) + "Box/Costume" + var_to_str(unlock_node_number) + "Lock").visible = false

func _on_face_confirmation_confirmed() -> void :
	if (unlock_accepted):
		Main.db["total_coin"] -= unlock_coins
		$Camera / CoinContainer / Coins.text = var_to_str(Main.db["total_coin"])

		Main.db["face_unlock_array"][unlock_code] = 1
		await Main.save_game()

		get_node("FaceContainer/Face" + var_to_str(unlock_node_number) + "Box/Face" + var_to_str(unlock_node_number) + "Lock").visible = false


func _on_face_5_lock_pressed() -> void :
	$Camera / Notice.dialog_text = "Complete Minesweeper Adventure Episode 1 to unlock this look"
	$Camera / Notice.visible = true

func _on_face_6_lock_pressed() -> void :
	$Camera / Notice.dialog_text = "Complete Minesweeper Adventure Episode 2 to unlock this look"
	$Camera / Notice.visible = true

func _on_face_7_lock_pressed() -> void :
	$Camera / Notice.dialog_text = "Complete Minesweeper Adventure Episode 3 to unlock this look"
	$Camera / Notice.visible = true

func _on_face_8_lock_pressed() -> void :
	var hat = "spooky look"
	if (Main.db["total_coin"] >= 12345): face_unlock_dialog(true, 3, 8, 12345, hat)
	else: face_unlock_dialog(false, 3, 8, 12345, hat)

func _on_challenge_9_lock_pressed() -> void :
	$Camera / Notice.dialog_text = "Complete Minesweeper Adventure Episode 1 on Novice difficulty or higher to unlock this boss"
	$Camera / Notice.visible = true

func _on_challenge_10_lock_pressed() -> void :
	$Camera / Notice.dialog_text = "Complete Minesweeper Adventure Episode 2 on Novice difficulty or higher to unlock this boss"
	$Camera / Notice.visible = true

func _on_challenge_11_lock_pressed() -> void :
	$Camera / Notice.dialog_text = "Complete Minesweeper Adventure Episode 3 on Novice difficulty or higher to unlock this boss"
	$Camera / Notice.visible = true

func _on_start_lock_pressed() -> void :
	if (Main.db["episode"] == 2):
		$Camera / Notice.dialog_text = "Complete Minesweeper Adventure Episode 1 to unlock Episode 2"
		$Camera / Notice.visible = true
	elif (Main.db["episode"] == 3):
		$Camera / Notice.dialog_text = "Complete Minesweeper Adventure Episode 2 to unlock Episode 3"
		$Camera / Notice.visible = true

func _on_difficulty_lock_pressed() -> void :
	$Camera / Notice.dialog_text = "Complete Normal mode on this difficulty first to unlock Boss Pursuit mode for this difficulty"
	$Camera / Notice.visible = true

func _on_help_button_pressed() -> void :
	$AdventureModeScreen / HelpButton / Help.visible = true

func _on_import_sprite_help_button_pressed() -> void :
	$LoadOutScreen / CustomFaceBox / HelpButton / Help.visible = true

func _on_customizer_help_button_pressed() -> void :
	$GridCustomizationScreen / HelpButton / Help.visible = true


func _on_reset_grid_button_pressed() -> void :
	$GridCustomizationScreen / Container / Viewport / GridCustomizer.reset_tiles()
func _on_reset_edges_button_pressed() -> void :
	$GridCustomizationScreen / Container / Viewport / GridCustomizer.reset_edges()
func _on_hide_grid_button_toggled(toggled_on: bool) -> void :
	$GridCustomizationScreen / Container / Viewport / GridCustomizer.hide_tiles(toggled_on)
	if (toggled_on): $GridCustomizationScreen / HideGridButton / Icon.frame = 5
	else: $GridCustomizationScreen / HideGridButton / Icon.frame = 4
func _on_hide_edges_button_toggled(toggled_on: bool) -> void :
	$GridCustomizationScreen / Container / Viewport / GridCustomizer.hide_edges(toggled_on)
	if (toggled_on): $GridCustomizationScreen / HideEdgesButton / Icon.frame = 7
	else: $GridCustomizationScreen / HideEdgesButton / Icon.frame = 6
func _on_horizontal_mirror_toggled(toggled_on: bool) -> void :
	$GridCustomizationScreen / Container / Viewport / GridCustomizer.set_mirror_mode(0)
	if (toggled_on): $GridCustomizationScreen / HorizontalMirror / Icon.frame = 1
	else: $GridCustomizationScreen / HorizontalMirror / Icon.frame = 0
func _on_vertical_mirror_toggled(toggled_on: bool) -> void :
	$GridCustomizationScreen / Container / Viewport / GridCustomizer.set_mirror_mode(1)
	if (toggled_on): $GridCustomizationScreen / VerticalMirror / Icon.frame = 3
	else: $GridCustomizationScreen / VerticalMirror / Icon.frame = 2
func _on_reverse_grid_button_pressed() -> void :
	$GridCustomizationScreen / Container / Viewport / GridCustomizer.reverse_tiles()
func _on_reverse_edges_button_pressed() -> void :
	$GridCustomizationScreen / Container / Viewport / GridCustomizer.reverse_edges()

func translate(language) -> void :
	Main.db["language"] = language
	var code = Main.get_language_code(language)

	var file = FileAccess.open("res://text/translate_game_select.txt", FileAccess.READ)
	var r = file.get_csv_line(",")
	var c = r.find(code)

	$Settings / Label.text = file.get_csv_line()[c]
	$Records / Label.text = file.get_csv_line()[c]
	master_on = file.get_csv_line()[c]
	master_off = file.get_csv_line()[c]
	accept = file.get_csv_line()[c]
	cancel = file.get_csv_line()[c]
	$BackButton0 / TSLabel.text = file.get_csv_line()[c]
	$ExitButton / ExitLabel.text = file.get_csv_line()[c]
	$AdventureModeScreen / EasyButton / EasyTexture / EasyLabel.text = file.get_csv_line()[c]
	$AdventureModeScreen / NoviceButton / NoviceTexture / NoviceLabel.text = file.get_csv_line()[c]
	$AdventureModeScreen / NormalButton / NormalTexture / NormalLabel.text = file.get_csv_line()[c]
	$AdventureModeScreen / HardButton / HardTexture / HardLabel.text = file.get_csv_line()[c]
	beginner = file.get_csv_line()[c]
	novice = file.get_csv_line()[c]
	veteran = file.get_csv_line()[c]
	expert = file.get_csv_line()[c]
	episode = file.get_csv_line()[c] + " "
	$LevelSelectScreen / LevelSelectLabel / EpisodeSelection.set_item_text(0, episode + " 1")
	$LevelSelectScreen / LevelSelectLabel / EpisodeSelection.set_item_text(1, episode + " 2")
	$LevelSelectScreen / LevelSelectLabel / EpisodeSelection.set_item_text(2, episode + " 3")
	casual = file.get_csv_line()[c]
	normal = file.get_csv_line()[c]
	boss_pursuit = file.get_csv_line()[c]
	beginner_desc = file.get_csv_line()[c]
	novice_desc = file.get_csv_line()[c]
	veteran_desc = file.get_csv_line()[c]
	expert_desc = file.get_csv_line()[c]
	$AdventureModeScreen / StartAdventure / StartLabel.text = file.get_csv_line()[c]
	$FreePlayScreen / ThemeLabel.text = file.get_csv_line()[c]
	$FreePlayScreen / MusicLabel.text = file.get_csv_line()[c]
	$FreePlayScreen / LengthEditor / LengthLabel.text = file.get_csv_line()[c]
	$FreePlayScreen / WidthEditor / WidthLabel.text = file.get_csv_line()[c]
	mines = file.get_csv_line()[c]
	$FreePlayScreen / MineEditor / MineLabel.text = mines
	$FreePlayScreen / MinePercent / PercentLabel.text = file.get_csv_line()[c]
	$FreePlayScreen / StartCustomGame / StartLabel.text = file.get_csv_line()[c]
	$FreePlayScreen / TileIndicator / TileLabel.text = file.get_csv_line()[c]
	$FreePlayScreen / PracticeButton / PracticeLabel.text = file.get_csv_line()[c]
	$FreePlayScreen / ClassicPresets / ClassicLabel.text = file.get_csv_line()[c]
	$FreePlayScreen / ClassicPresets / BeginnerButton / BeginnerLabel.text = beginner
	$FreePlayScreen / ClassicPresets / IntermediateButton / IntermediateLabel.text = file.get_csv_line()[c]
	$FreePlayScreen / ClassicPresets / ExpertButton / ExpertLabel.text = expert
	var challenge = file.get_csv_line()[c]
	$FreePlayScreen / Challenge9.text = challenge
	$FreePlayScreen / Challenge10.text = challenge
	$AdventureMode / AdventureLabel.text = file.get_csv_line()[c]
	$AdventureMode / AdventurePanel / AdventureDescription.text = file.get_csv_line()[c]
	$AdventureMode / ContinueButton / ContinueLabel.text = file.get_csv_line()[c]
	pursuit = file.get_csv_line()[c]
	$FreePlay / LabelBackground / FreePlayLabel.text = file.get_csv_line()[c]
	$FreePlay / FreePlayPanel / FreePlayDescription.text = file.get_csv_line()[c]
	$BonusGamesScreen / ChallengeButton / ChallengeLabel.text = file.get_csv_line()[c]
	mines = " " + mines
	best = file.get_csv_line()[c] + ": "
	$BonusGamesScreen / ChallengeDescription.text = file.get_csv_line()[c]
	$FreePlayScreen / Challenge9 / DifficultySelection9.set_item_text(0, beginner)
	$FreePlayScreen / Challenge9 / DifficultySelection9.set_item_text(1, novice)
	$FreePlayScreen / Challenge9 / DifficultySelection9.set_item_text(2, veteran)
	$FreePlayScreen / Challenge9 / DifficultySelection9.set_item_text(3, expert)
	$FreePlayScreen / Challenge10 / DifficultySelection10.set_item_text(0, beginner)
	$FreePlayScreen / Challenge10 / DifficultySelection10.set_item_text(1, novice)
	$FreePlayScreen / Challenge10 / DifficultySelection10.set_item_text(2, veteran)
	$FreePlayScreen / Challenge10 / DifficultySelection10.set_item_text(3, expert)
	$FreePlayScreen / Challenge11 / DifficultySelection11.set_item_text(0, beginner)
	$FreePlayScreen / Challenge11 / DifficultySelection11.set_item_text(1, novice)
	$FreePlayScreen / Challenge11 / DifficultySelection11.set_item_text(2, veteran)
	$FreePlayScreen / Challenge11 / DifficultySelection11.set_item_text(3, expert)
	$LevelSelectScreen / LevelSelectLabel / DifficultySelection.set_item_text(0, beginner)
	$LevelSelectScreen / LevelSelectLabel / DifficultySelection.set_item_text(1, novice)
	$LevelSelectScreen / LevelSelectLabel / DifficultySelection.set_item_text(2, veteran)
	$LevelSelectScreen / LevelSelectLabel / DifficultySelection.set_item_text(3, expert)

	$AdventureModeScreen / HelpButton / Help / HelpLabel.text = file.get_csv_line()[c]

	file.close()

	file = FileAccess.open("res://text/translate_level_names1.txt", FileAccess.READ)
	r = file.get_csv_line(",")
	c = r.find(code)

	episode1_stages = [file.get_csv_line(",")[c], file.get_csv_line(",")[c], file.get_csv_line(",")[c], 
	file.get_csv_line(",")[c], file.get_csv_line(",")[c], file.get_csv_line(",")[c], 
	file.get_csv_line(",")[c], file.get_csv_line(",")[c], file.get_csv_line(",")[c], ]
	file.close()

	file = FileAccess.open("res://text/translate_level_names2.txt", FileAccess.READ)
	r = file.get_csv_line(",")
	c = r.find(code)

	episode2_stages = [file.get_csv_line(",")[c], file.get_csv_line(",")[c], file.get_csv_line(",")[c], 
	file.get_csv_line(",")[c], file.get_csv_line(",")[c], file.get_csv_line(",")[c], 
	file.get_csv_line(",")[c], file.get_csv_line(",")[c], file.get_csv_line(",")[c], 
	file.get_csv_line(",")[c]]
	file.close()

	$Settings / Popup.translate(language)
	$Records / Popup.translate(language)


func _on_double_mine_button_toggled(toggled_on: bool) -> void :
	Main.double = toggled_on
	$FreePlayScreen / DoubleMineButton / OffOn.frame = toggled_on
	get_tree().call_group("double_controls", "set_visible", toggled_on)

func _on_anti_mine_button_toggled(toggled_on: bool) -> void :
	Main.anti = toggled_on
	$FreePlayScreen / AntiMineButton / OffOn.frame = toggled_on
	get_tree().call_group("anti_controls", "set_visible", toggled_on)

func _on_double_probability_button_pressed() -> void :
	Main.double_method = false
	$FreePlayScreen / DoubleMineButton / DoubleProbabilitySlider.max_value = 100
	$FreePlayScreen / DoubleMineButton / DoubleProbabilityButton.set_disabled(true)
	$FreePlayScreen / DoubleMineButton / DoubleSetButton.set_disabled(false)
	$FreePlayScreen / DoubleMineButton / DoubleMineIndicator / TileLabel.text = double + " %"
func _on_double_set_button_pressed() -> void :
	Main.double_method = true
	if (Main.anti_method == true):
		$FreePlayScreen / DoubleMineButton / DoubleProbabilitySlider.max_value = custom_game_mines - custom_anti_mines
	else:
		$FreePlayScreen / DoubleMineButton / DoubleProbabilitySlider.max_value = custom_game_mines
	$FreePlayScreen / DoubleMineButton / DoubleProbabilityButton.set_disabled(false)
	$FreePlayScreen / DoubleMineButton / DoubleSetButton.set_disabled(true)
	$FreePlayScreen / DoubleMineButton / DoubleMineIndicator / TileLabel.text = double + " #"

func _on_anti_probability_button_pressed() -> void :
	Main.anti_method = false
	$FreePlayScreen / AntiMineButton / AntiProbabilitySlider.max_value = 100
	$FreePlayScreen / AntiMineButton / AntiProbabilityButton.set_disabled(true)
	$FreePlayScreen / AntiMineButton / AntiSetButton.set_disabled(false)
	$FreePlayScreen / AntiMineButton / AntiMineIndicator / TileLabel.text = anti + " %"
func _on_anti_set_button_pressed() -> void :
	Main.anti_method = true
	if (Main.double_method == true):
		$FreePlayScreen / AntiMineButton / AntiProbabilitySlider.max_value = custom_game_mines - custom_double_mines
	else:
		$FreePlayScreen / AntiMineButton / AntiProbabilitySlider.max_value = custom_game_mines
	$FreePlayScreen / AntiMineButton / AntiProbabilityButton.set_disabled(false)
	$FreePlayScreen / AntiMineButton / AntiSetButton.set_disabled(true)
	$FreePlayScreen / AntiMineButton / AntiMineIndicator / TileLabel.text = anti + " #"

func _on_double_probability_slider_value_changed(value: float) -> void :
	custom_double_mines = int(value)
	Main.db["double_number"] = custom_double_mines
	$FreePlayScreen / DoubleMineButton / DoubleMineIndicator.text = var_to_str(int(value))
	if (Main.double_method == true && Main.anti_method == true):
		$FreePlayScreen / AntiMineButton / AntiProbabilitySlider.max_value = custom_game_mines - custom_double_mines

func _on_anti_probability_slider_value_changed(value: float) -> void :
	custom_anti_mines = int(value)
	Main.db["anti_number"] = custom_anti_mines
	$FreePlayScreen / AntiMineButton / AntiMineIndicator.text = var_to_str(int(value))
	if (Main.double_method == true && Main.anti_method == true):
		$FreePlayScreen / DoubleMineButton / DoubleProbabilitySlider.max_value = custom_game_mines - custom_anti_mines


func _on_episode_selection_item_selected(index: int) -> void :
	Main.level_select_episode = index
	var begin
	var end
	var tf
	if (index == 0):
		begin = 10
		end = 13
		tf = true
	elif (index == 1):
		begin = 11
		end = 13
		tf = true
		get_node("LevelContainer/Level10Box").set_disabled(false)
		get_node("LevelContainer/Level10Box/LevelSquare10/X").set_visible(false)
	elif (index == 2):
		begin = 10
		end = 12
		tf = false
		get_node("LevelContainer/Level12Box").set_disabled(true)
		get_node("LevelContainer/Level12Box/LevelSquare12/X").set_visible(true)
	for i in range(begin, end):
		get_node("LevelContainer/Level" + var_to_str(i) + "Box").set_disabled(tf)
		get_node("LevelContainer/Level" + var_to_str(i) + "Box/LevelSquare" + var_to_str(i) + "/X").set_visible(tf)
	if (Main.level_select_level > index + 9): call("_on_level_" + var_to_str(index + 9) + "_box_pressed")
	else: call("_on_level_" + var_to_str(Main.level_select_level) + "_box_pressed")
	$LevelSelectScreen / StageNameLabel.text = stage_name_getter(Main.level_select_level, index)

func _on_difficulty_selection_item_selected(index: int) -> void :
	Main.level_select_difficulty = index

func _on_play_level_pressed() -> void :
	if (custom_game_bgm < 13 || custom_game_bgm > 13):
		get_node("Music" + custom_bgm_string).stop()
	$Start.play()
	get_tree().call_group("buttons", "set_disabled", true)
	get_tree().call_group("other_controls", "set_editable", false)
	Main.game_length = Main.adventure_length[Main.level_select_episode][Main.level_select_level - 1][Main.level_select_difficulty]
	Main.game_width = Main.adventure_width[Main.level_select_episode][Main.level_select_level - 1][Main.level_select_difficulty]
	Main.game_mines = Main.adventure_mines[Main.level_select_episode][Main.level_select_level - 1][Main.level_select_difficulty]


	Main.level_select = true
	Main.adventure_mode = false
	Main.double = false
	Main.anti = false
	Main.nine_count = 0
	Main.ten_count = 0
	Main.eleven_count = 0
	if (Main.level_select_level == 9):
		Main.nine = true
		Main.nine_count = 1
		Main.db["nine_custom_difficulty"] = Main.level_select_difficulty
	if (Main.level_select_level == 10):
		Main.ten = true
		Main.ten_count = 1
		Main.db["ten_custom_difficulty"] = Main.level_select_difficulty
	if (Main.level_select_level == 11):
		Main.eleven = true
		Main.eleven_count = 1
		Main.db["eleven_custom_difficulty"] = Main.level_select_difficulty
	await get_tree().create_timer(0.5).timeout
	await fade_out()
	get_tree().change_scene_to_file("res://level.tscn")


func _on_copy_to_free_play_pressed() -> void :
	$FreePlayScreen / LengthSlider.value = Main.adventure_length[Main.level_select_episode][Main.level_select_level - 1][Main.level_select_difficulty]
	$FreePlayScreen / WidthSlider.value = Main.adventure_width[Main.level_select_episode][Main.level_select_level - 1][Main.level_select_difficulty]
	$FreePlayScreen / MineSlider.value = Main.adventure_mines[Main.level_select_episode][Main.level_select_level - 1][Main.level_select_difficulty]
	$GridCustomizationScreen / NameEditor.text = stage_name_getter(Main.level_select_level, Main.level_select_episode)

	$GridCustomizationScreen / Container / Viewport / GridCustomizer.reset_board(custom_game_length, custom_game_width)

	if (Main.level_select_episode > 0):
		var png_id = "res://bitmap/"
		png_id += var_to_str(Main.level_select_episode + 1) + "_"
		png_id += var_to_str(Main.level_select_level) + "_"
		png_id += var_to_str(Main.level_select_difficulty)
		png_id += ".png"
		setup_grid_customizer(png_id)

func setup_grid_customizer(png_path: String):
	$Camera / LoadingLabel.set_visible(true)
	await get_tree().create_timer(get_process_delta_time()).timeout
	var png_map = Image.load_from_file(png_path)
	var pixel
	var png_range = png_map.get_size()

	for i in range(custom_game_width):
		for j in range(custom_game_length):
			if (i < png_range[1] && j < png_range[0]):
				pixel = png_map.get_pixel(j, i)
				if (pixel[2] != 0):
					$GridCustomizationScreen / Container / Viewport / GridCustomizer.tile_array[i][j].switch()

				$GridCustomizationScreen / Container / Viewport / GridCustomizer.import_edge_switch(i, j, Main.get_green_array(pixel[1]))
	$Camera / LoadingLabel.set_visible(false)

func create_png(identifier) -> void :
	$Camera / LoadingLabel.set_visible(true)
	await get_tree().create_timer(get_process_delta_time()).timeout
	var temp_image = Image.create_empty(custom_game_length, custom_game_width, false, 5)
	var png_range = temp_image.get_size()



	var red
	var green
	var blue
	var tile_grid = $GridCustomizationScreen / Container / Viewport / GridCustomizer
	var png_range_2 = tile_grid.get_grid_size()

	for i in range(custom_game_width):
		for j in range(custom_game_length):
			if ((i < png_range[1] && i < png_range_2[1])
			&& j < png_range[0] && j < png_range_2[0]):


				red = 0

				green = Main.get_green(tile_grid.get_edge_values(i, j))



				if (tile_grid.tile_array[i][j].on):
					blue = 0
				else:
					blue = 1

				temp_image.set_pixel(j, i, Color(red, green, blue, 255))

	temp_image.save_png(identifier)
	$Camera / LoadingLabel.set_visible(false)

func _on_preset_1_button_pressed() -> void :
	load_preset("1")
func _on_preset_2_button_pressed() -> void :
	load_preset("2")
func _on_preset_3_button_pressed() -> void :
	load_preset("3")

func load_preset(number) -> void :
	var custom_name = FileAccess.open("user://" + number + ".txt", FileAccess.READ)

	$GridCustomizationScreen / NameEditor.text = custom_name.get_line()
	$FreePlayScreen / LengthSlider.value = str_to_var(custom_name.get_line())
	$FreePlayScreen / WidthSlider.value = str_to_var(custom_name.get_line())
	$FreePlayScreen / MineSlider.value = str_to_var(custom_name.get_line())
	custom_game_tiles = str_to_var(custom_name.get_line())
	mine_percent = float((custom_game_mines) / float(custom_game_tiles)) * 100
	$FreePlayScreen / MinePercent.text = var_to_str(mine_percent).left(5) + "%"

	$GridCustomizationScreen / Container / Viewport / GridCustomizer.reset_board(custom_game_length, custom_game_width)
	setup_grid_customizer("user://" + number + ".png")

func _on_save_1_button_pressed() -> void :
	save_preset("1")
func _on_save_2_button_pressed() -> void :
	save_preset("2")
func _on_save_3_button_pressed() -> void :
	save_preset("3")

func save_preset(number) -> void :
	create_png("user://" + number + ".png")

	var custom_name = FileAccess.open("user://" + number + ".txt", FileAccess.WRITE)
	var new_name
	if ($GridCustomizationScreen / NameEditor.text != ""): new_name = $GridCustomizationScreen / NameEditor.text
	else: new_name = $GridCustomizationScreen / NameEditor.placeholder_text + " " + number


	custom_name.store_line(new_name)
	get_node("FreePlayScreen/CustomPresets/Preset" + number + "Button/Preset" + number + "Label").text = new_name

	custom_name.store_line(var_to_str(custom_game_length))
	custom_name.store_line(var_to_str(custom_game_width))
	custom_name.store_line(var_to_str(custom_game_mines))
	custom_name.store_line(var_to_str(custom_game_tiles))

	custom_name.close()

func _update_grid_tiles(add_sub) -> void :
	custom_game_tiles += add_sub
	$FreePlayScreen / TileIndicator.text = var_to_str(custom_game_tiles)
	$FreePlayScreen / MineSlider.max_value = custom_game_tiles - 1

	mine_percent = float((custom_game_mines) / float(custom_game_tiles)) * 100
	$FreePlayScreen / MinePercent.text = var_to_str(mine_percent).left(5) + "%"


func _on_import_button_pressed() -> void :
	$GridCustomizationScreen / ImportButton / ImportDialog.visible = true


func _on_import_dialog_file_selected(path: String) -> void :
	var file_name = path.split("/", false, 0)[-1]
	var level_name = file_name.get_slice(".", 0)
	var file_type = file_name.get_slice(".", 1)
	var png_import
	var size

	if (file_type == "png"):
		png_import = Image.load_from_file(path)
		size = png_import.get_size()

		var l = size[0]
		var w = size[1]

		if (l <= Main.max_length && w <= Main.max_width):
			$GridCustomizationScreen / Container / Viewport / GridCustomizer.reset_board(l, w)
			$FreePlayScreen / LengthSlider.value = l
			$FreePlayScreen / WidthSlider.value = w
			setup_grid_customizer(path)
			$GridCustomizationScreen / NameEditor.text = level_name
		else:
			$GridCustomizationScreen / ImportButton / Error2Dialog.show()
	else:
		$GridCustomizationScreen / ImportButton / Error1Dialog.show()

func _on_export_button_pressed() -> void :
	$GridCustomizationScreen / ExportButton / ExportDialog.visible = true
	if ($GridCustomizationScreen / NameEditor.text == ""):
		$GridCustomizationScreen / ExportButton / ExportDialog.set_current_file($GridCustomizationScreen / NameEditor.placeholder_text + ".png")
	else:
		$GridCustomizationScreen / ExportButton / ExportDialog.set_current_file($GridCustomizationScreen / NameEditor.text + ".png")

func _on_export_dialog_dir_selected(dir: String) -> void :
	var level_name
	if ($GridCustomizationScreen / NameEditor.text != ""): level_name = $GridCustomizationScreen / NameEditor.text
	else: level_name = $GridCustomizationScreen / NameEditor.placeholder_text

	create_png(dir + "/" + level_name + ".png")







func _on_import_custom_sprite_button_pressed() -> void :
	$LoadOutScreen / ImportCustomSpriteButton / ImportSpriteDialog.visible = true


func _on_import_sprite_dialog_file_selected(path: String) -> void :
	var file_name = path.split("/", false, 0)[-1]
	var file_type = file_name.get_slice(".", 1)
	var png_import
	var size

	if (file_type == "png"):
		png_import = Image.load_from_file(path)
		size = png_import.get_size()

		png_import.save_png("user://Faces_0.png")

		var png = Image.load_from_file("user://Faces_0.png")
		var texture = ImageTexture.create_from_image(png)
		$LoadOutScreen / Background / Face2.texture = texture
		var face_size = texture.get_size()
		$LoadOutScreen / Background / Face2.scale = Vector2(640.0 / face_size[0], 640 / face_size[1])
		$LoadOutScreen / Background / Face2.frame = 4


	else:
		$LoadOutScreen / ImportCustomSpriteButton / Error1Dialog.show()


func _on_reset_custom_sprite_button_2_pressed() -> void :
	var png = Image.load_from_file("res://assets/img/GBCaptain.png")
	png.save_png("user://Faces_0.png")
	var texture = ImageTexture.create_from_image(png)
	$LoadOutScreen / Background / Face2.texture = texture
	$LoadOutScreen / Background / Face2.frame = 4
	var face_size = texture.get_size()
	$LoadOutScreen / Background / Face2.scale = Vector2(640.0 / face_size[0], 640 / face_size[1])
	$LoadOutScreen / Background / Face2.frame = 4


func _on_weather_button_pressed() -> void :
	get_tree().call_group("weather", "set_visible", false)
	if Main.weather == 0:
		Main.weather = 1
		$FreePlayScreen / WeatherButton / Weather.frame = Main.weather
		$Camera / Rain.set_visible(true)
	elif Main.weather == 1:
		Main.weather = 2
		$FreePlayScreen / WeatherButton / Weather.frame = Main.weather
		$Camera / Snow.set_visible(true)
	elif Main.weather == 2:
		Main.weather = 3
		$FreePlayScreen / WeatherButton / Weather.frame = Main.weather
		$Camera / Fog.set_visible(true)
	elif Main.weather == 3:
		Main.weather = 0
		$FreePlayScreen / WeatherButton / Weather.frame = Main.weather


func _on_popup_popup_hide() -> void :
	Main.save_game()


func _on_settings_pressed() -> void :
	$Settings / Popup.set_visible(true)


func _on_records_pressed() -> void :
	$Records / Popup.set_visible(true)
