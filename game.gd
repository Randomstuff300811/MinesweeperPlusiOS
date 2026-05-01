extends Node


signal pass_flag
signal pass_face
signal pass_radar
signal pass_percent
signal pass_challenge
signal pass_mine_click
signal game_time
signal game_over
signal mistake
signal nine_intro
signal ten_intro
signal eleven_intro
signal ten_end
signal eleven_end
signal quick_set_9


@export var grid_tile: PackedScene
@export var bg_tile: PackedScene
@export var game_columns: int
@export var game_rows: int


var game_squares
var tile_array = []
var mines
var flags = 0
@export var tiles_opened = 0
var win_tiles
var flagged_tiles = 0
@export var nine_win_flag = false
var health = 3
@export var radar_price = 50
var nine_position = [Vector2i(1, 1)]
var eleven_position = [Vector2i(0, 0)]
var already_setup = false

var skip = false
var phase2 = false
var chording = true
var no_more_opening = false
var pressure_mines = false

var antimines = false
var doublemines = false



func _ready() -> void :

	chording = Main.db["chording"]
	pressure_mines = Main.pressure_mines
	if (pressure_mines): flags = Main.game_flags


	if (Main.db["master"] == true):
		health = 1
	elif (Main.adventure_mode):
		health = Main.db["adventure_health"]
		if (Main.db["episode"] == 1): radar_price = 50
		elif (Main.db["episode"] == 2): radar_price = 40
		elif (Main.db["episode"] == 3): radar_price = 35
	elif (Main.endless):
		health = Main.db["endless_health"]


	if (Main.practice || (Main.db["pursuit"] == 0 && Main.adventure_mode)):
		radar_price = 0


	if ( !Main.challenge):
		if ( !Main.endless):
			game_columns = Main.game_length
			game_rows = Main.game_width
			mines = Main.game_mines
			if (pressure_mines): flags = Main.game_flags
			if (Main.adventure_mode && Main.db["episode"] == 1 && Main.db["pursuit"] == 2):
				mines += 8
		else:

			game_columns = Main.db["endless_last_length"]
			game_rows = Main.db["endless_last_width"]
			mines = Main.db["endless_last_mines"]

	else:
		game_columns = 72
		game_rows = 48
		mines = (Main.db["challenge_difficulty"]) * 111

		if (Main.db["challenge_modifier"] == 1):
			doublemines = true
			Main.double_method = false
			Main.double_number = 10 + ((Main.db["challenge_difficulty"] - 1) * 5)
		elif (Main.db["challenge_modifier"] == 2):
			antimines = true
			Main.anti_method = false
			Main.anti_number = 10 + ((Main.db["challenge_difficulty"] - 1) * 5)
		elif (Main.db["challenge_modifier"] == 3):
			doublemines = true
			Main.double_method = false
			Main.double_number = 10 + ((Main.db["challenge_difficulty"] - 1) * 5)
			antimines = true
			Main.anti_method = false
			Main.anti_number = 10 + ((Main.db["challenge_difficulty"] - 1) * 5)





	if (Main.anti): antimines = true
	if (Main.double): doublemines = true

	build_grid()


	cut_grid()

	create_borders()


	pass_percent.emit(game_squares, mines)


	if (Main.nine || Main.ten || Main.eleven):
		tiles_opened = -1
		health = 99
		get_tree().call_group("tiles", "set_disabled", true)
		if (Main.eleven):
			tile_array[game_rows / 2][game_columns / 2].value = 11
			tile_array[game_rows / 2][game_columns / 2].set_icon("11")
		if (Main.ten):
			tile_array[game_rows / 2][game_columns / 2].value = 10
			tile_array[game_rows / 2][game_columns / 2].set_icon("10")
		elif (Main.nine):
			tile_array[game_rows / 2][game_columns / 2].value = 9
			tile_array[game_rows / 2][game_columns / 2].set_icon("9")
		tile_array[game_rows / 2][game_columns / 2].blink()
		tile_array[game_rows / 2][game_columns / 2].set_disabled(false)
		if (Main.eleven):
			eleven_position[0] = Vector2i(game_rows / 2, game_columns / 2)
		if (Main.nine):
			nine_position[0] = Vector2i(game_rows / 2, game_columns / 2)
			preset_mines(nine_position[0])

	if (Main.nine_count > 0 || Main.ten_count > 0 || Main.eleven_count > 0):
		health = 999






func _process(_delta: float) -> void :
	pass

func build_grid() -> void :
	game_squares = game_columns * game_rows


	if mines >= game_squares:
		mines = game_squares - 1

	$MineGrid.set_columns(game_columns)
	tiles_opened = 0

	win_tiles = game_squares - mines


	var tile
	for i in range(game_rows):
		var row_array = []
		for j in range(game_columns):
			tile = grid_tile.instantiate()
			tile.row_col = Vector2i(i, j)
			tile.opened.connect(_on_grid_square_opened)
			tile.flag_toggle.connect(_flag_pass)
			tile.face_toggle.connect(_face_pass)
			tile.deac_radar.connect(_radar_pass)
			tile.chord.connect(_tile_chorder)
			if (Main.eleven_count > 0): tile.pressure_mine = true
			else: tile.pressure_mine = pressure_mines

			tile.style = Main.game_style

			if (doublemines): tile.flag_order.append(2)
			if (antimines): tile.flag_order.append(-1)
			if (antimines && doublemines): tile.flag_order.append(-2)

			$MineGrid.add_child(tile)
			row_array.append(tile)
		tile_array.append(row_array)

	if (pressure_mines):
		pre_flag_tiles()

func cut_grid() -> void :
	if (Main.challenge || Main.endless):
		return

	var png_id = ""

	if (Main.level_select):
		if (Main.level_select_episode == 0): return
		png_id += var_to_str(Main.level_select_episode + 1) + "_"
		png_id += var_to_str(Main.level_select_level) + "_"
		png_id += var_to_str(Main.level_select_difficulty)
		if (phase2): png_id += "_2"
	elif (Main.adventure_mode):
		if (Main.db["episode"] == 1): return
		png_id += var_to_str(Main.db["episode"]) + "_"
		png_id += var_to_str(Main.db["adventure_levels_complete"] + 1) + "_"
		png_id += var_to_str(Main.db["difficulty"])
		if (phase2): png_id += "_2"
	else:
		png_id += "temp_img"

	var png_map
	if (png_id == "temp_img"): png_map = Image.load_from_file("user://" + png_id + ".png")
	else:
		var file = load("res://bitmap/" + png_id + ".png")
		png_map = file.get_image()
	var pixel
	var range = png_map.get_size()
	var edge_finder

	for i in range(game_rows):
		for j in range(game_columns):
			if (i < range[1] && j < range[0]):
				pixel = png_map.get_pixel(j, i)
				if (pixel[2] != 0):
					if (tile_array[i][j].enabled == true):
						tile_array[i][j].deactivate()
						tile_array[i][j].icon_only()
						win_tiles -= 1
						game_squares -= 1



				edge_finder = Main.get_green_array(pixel[1])
				if (edge_finder[0] == true): tile_array[i][j].outline_array[0] = 1
				if (edge_finder[1] == true): tile_array[i][j].outline_array[1] = 1
				if (edge_finder[2] == true): tile_array[i][j].outline_array[2] = 1
				if (edge_finder[3] == true): tile_array[i][j].outline_array[3] = 1


func create_borders() -> void :
	for i in range(game_rows):
		for j in range(game_columns):
			if ((i == 0 || tile_array[i - 1][j].enabled == false) && tile_array[i][j].outline_array[0] != 1):
				tile_array[i][j].outline_array[0] = 2
			if ((j >= game_columns - 1 || tile_array[i][j + 1].enabled == false) && tile_array[i][j].outline_array[1] != 1):
				tile_array[i][j].outline_array[1] = 2
			if ((i >= game_rows - 1 || tile_array[i + 1][j].enabled == false) && tile_array[i][j].outline_array[2] != 1):
				tile_array[i][j].outline_array[2] = 2
			if ((j == 0 || tile_array[i][j - 1].enabled == false) && tile_array[i][j].outline_array[3] != 1):
				tile_array[i][j].outline_array[3] = 2















































































































func pre_flag_tiles():
	var row
	var col
	if (flags > game_rows * game_columns): flags = game_rows * game_columns
	var flags_placed = 0
	while flags_placed < flags:
		row = randi_range(0, game_rows - 1)
		col = randi_range(0, game_columns - 1)
		if (tile_array[row][col].flagged != true):
			tile_array[row][col].pre_flag()
			flags_placed += 1

func flag_tile(pos):
	tile_array[pos[0]][pos[1]].get_node("Flag").set_visible(true)
	tile_array[pos[0]][pos[1]].flagged = true
	tile_array[pos[0]][pos[1]].flag_number = 1
	flagged_tiles += 1
	pass_flag.emit(true)


func get_nine_position(index) -> Vector2:
	return $MineGrid.position + tile_array[nine_position[index][0]][nine_position[index][1]].position

func get_eleven_position(index) -> Vector2:
	var t = tile_array[eleven_position[index][0]][eleven_position[index][1]]
	return $MineGrid.position + t.position + Vector2((t.size[0] / 2), (t.size[1] / 2))

func get_nine_coordinates(index) -> Vector2i:
	return nine_position[index]

func get_eleven_coordinates(index) -> Vector2i:
	return eleven_position[index]

func cool_theme_change(theme, seconds, skip) -> void :
	if (Main.game_style != theme):
		Main.game_style = theme

		var frame_progress
		var random_tile
		var tiles_to_go = win_tiles - 1

		while tiles_to_go > 0:
			random_tile = tile_array[randi() % game_rows][randi() % game_columns]
			if (random_tile.style != theme && random_tile.enabled == true):
				frame_progress = random_tile.get_frame_progress()
				random_tile.play_anim(theme)
				random_tile.set_frame_progress(frame_progress)
				random_tile.style = theme
				if ( !skip): $Tick.play()
				if ( !skip): await get_tree().create_timer((float(seconds) / float(game_rows * game_columns)) * (get_process_delta_time())).timeout
				tiles_to_go -= 1

		get_tree().call_group("anim", "play_anim", theme)
	else:
		pass

func fancy_theme_change(theme, seconds, skip) -> void :
	Main.game_style = theme
	var frame_progress
	var rng

	if (game_columns <= game_rows): rng = game_columns
	else: rng = game_rows

	var i = game_rows / 2
	var j = game_columns / 2
	var diff = 0
	var new_diff = 1
	var dir = 0
	var switch = true

	for x in range(rng * rng):
		frame_progress = tile_array[i][j].get_frame_progress()
		tile_array[i][j].play_anim(theme)
		tile_array[i][j].set_frame_progress(frame_progress)

		if ( !skip): $Tick.play()
		if ( !skip): await get_tree().create_timer((float(seconds) / float(rng * rng) * get_process_delta_time())).timeout

		if (dir == 0): j -= 1
		elif (dir == 1): i -= 1
		elif (dir == 2): j += 1
		elif (dir == 3): i += 1

		if (diff == 0):
			dir += 1
			dir = dir % 4
			switch = !switch
			if (switch == true):
				new_diff += 1
			diff = new_diff

		diff -= 1

	get_tree().call_group("anim", "play_anim", theme)


func _on_grid_square_opened(coords: Vector2i) -> void :
	if tiles_opened == 0 && !already_setup:
		setup(coords)
		no_more_opening = false
		pass_percent.emit(game_squares, mines)
		game_time.emit(true)
		already_setup = true
	elif (tiles_opened == -1):
		tile_array[game_rows / 2][game_columns / 2].set_disabled(true)
		tile_array[game_rows / 2][game_columns / 2].blink_trigger = false
		win_tiles -= 1
		if (Main.eleven): eleven_intro.emit()
		elif (Main.ten): ten_intro.emit()
		elif (Main.nine): nine_intro.emit()

	if (tile_array[coords[0]][coords[1]].open == true && tile_array[coords[0]][coords[1]].chord_flag == true):
		quick_open(coords)
	else:
		open_tile(coords)


func open_nine_tile(number) -> void :
	tile_array[nine_position[number][0]][nine_position[number][1]].open = true
	tile_array[nine_position[number][0]][nine_position[number][1]].value = 9
	tile_array[nine_position[number][0]][nine_position[number][1]].processed = true
	tile_array[nine_position[number][0]][nine_position[number][1]].get_node("Background1").visible = false
	tile_array[nine_position[number][0]][nine_position[number][1]].get_node("Background1Low").visible = false
	win_tiles -= 1

func cover_tile(pos) -> void :
	tile_array[pos[0]][pos[1]].open = false
	tile_array[pos[0]][pos[1]].value = 0
	tile_array[pos[0]][pos[1]].processed = false
	if (Main.db["graphics_quality"]): tile_array[pos[0]][pos[1]].get_node("Background1").visible = true
	else: tile_array[pos[0]][pos[1]].get_node("Background1").visible = true
	win_tiles += 1


func setup(start) -> void :
	var num_mines = mines

	var adv_row = -1
	var adv_col = -1
	var row
	var col
	var f = 1

	var lurd: Array

	if (Main.db["safe_first_click"] == 2 || (game_squares - mines <= 1 || (Main.nine_count > 0 && game_squares - (mines + (8 * Main.nine_count)) <= 1))):
		f = -1
	elif (Main.db["safe_first_click"] == 1 || (game_squares - mines <= 9 || (Main.nine_count > 0 && game_squares - (mines + (8 * Main.nine_count)) <= 9))):
		f = 0



	if (Main.adventure_mode && Main.db["adventure_levels_complete"] < 8 && Main.db["adventure_levels_complete"] >= 1):
		var lurd_temp: Array
		var adventure_mines = Main.db["adventure_levels_complete"] + 1
		while (adventure_mines > 0):
			adv_row = randi_range(0, game_rows - 1)
			adv_col = randi_range(0, game_columns - 1)
			if ((adv_row < start[0] - 2) || (adv_row > start[0] + 2)
			|| (adv_col < start[1] - 2) || (adv_col > start[1] + 2)):

				lurd = get_adjacent_bounds(Vector2(adv_row, adv_col), false)

				var good_tiles = 0
				if (tile_array[adv_row][adv_col].enabled == true):
					for i in range(lurd[1], lurd[3] + 1):
						for j in range(lurd[0], lurd[2] + 1):
							if (tile_array[i][j].enabled == true
							&& tile_array[i][j].mine != true && 
							Vector2i(i, j) != Vector2i(adv_row, adv_col)):
								good_tiles += 1
				while (adventure_mines > 0 && good_tiles >= adventure_mines):
					var temp_row = randi_range(lurd[1], lurd[3])
					var temp_col = randi_range(lurd[0], lurd[2])
					if (tile_array[temp_row][temp_col].enabled == true && 
					tile_array[temp_row][temp_col].mine != true && 
					Vector2i(temp_row, temp_col) != Vector2i(adv_row, adv_col)):
						tile_array[temp_row][temp_col].mine = true
						tile_array[temp_row][temp_col].mine_value = 1
						tile_array[temp_row][temp_col].mine_type = 1
						tile_array[temp_row][temp_col].set_icon("mine1")
						num_mines -= 1
						adventure_mines -= 1

						lurd_temp = get_adjacent_bounds(Vector2(temp_row, temp_col), false)

						for i in range(lurd_temp[1], lurd_temp[3] + 1):
							for j in range(lurd_temp[0], lurd_temp[2] + 1):
								if (tile_array[i][j].value != -1):
									tile_array[i][j].value += 1
									tile_array[i][j].mine_value += 1



	var mine_value
	var antirand
	var doublerand
	var antinum = Main.anti_number
	var doublenum = Main.double_number

	while num_mines > 0:
		mine_value = 1
		row = randi_range(0, game_rows - 1)
		col = randi_range(0, game_columns - 1)
		if (((row < start[0] - f) || (row > start[0] + f)
		|| (col < start[1] - f) || (col > start[1] + f))
		&& ((row < adv_row - f) || (row > adv_row + f)
		|| (col < adv_col - f) || (col > adv_col + f))):
			if (tile_array[row][col].enabled == true && tile_array[row][col].mine != true && tile_array[row][col].value != 9):
				tile_array[row][col].mine = true

				if (antimines && !Main.adventure_mode):

					if (Main.anti_method):
						if (antinum > 0 && ( !Main.double_method || mine_value == 1)):
							antinum -= 1
							mine_value *= -1
							tile_array[row][col].antimine = true

					else:
						antirand = randi() % 100
						if (antirand < antinum):
							mine_value *= -1
							tile_array[row][col].antimine = true

				if (doublemines && !Main.adventure_mode):
					if (Main.double_method):

						if (doublenum > 0 && ( !Main.anti_method || mine_value == 1)):
							doublenum -= 1
							mine_value *= 2
							tile_array[row][col].doublemine = true

					else:
						doublerand = randi() % 100
						if (doublerand < doublenum):
							mine_value *= 2
							tile_array[row][col].doublemine = true

				tile_array[row][col].mine_type = mine_value
				tile_array[row][col].set_icon("mine" + var_to_str(mine_value))

				num_mines -= 1





				lurd = get_adjacent_bounds(Vector2(row, col), false)

				for i in range(lurd[1], lurd[3] + 1):
					for j in range(lurd[0], lurd[2] + 1):
						if (tile_array[i][j].mine != true):
							tile_array[i][j].value += mine_value
							tile_array[i][j].mine_value += 1


	for i in range(tile_array.size()):
		for j in range(tile_array[i].size()):
			if (tile_array[i][j].mine != true):
				tile_array[i][j].set_icon(var_to_str(tile_array[i][j].value))


func check_for_good_placement(pos_9) -> bool:
	var lurd = get_adjacent_bounds(pos_9, false)
	for i in range(lurd[1], lurd[3] + 1):
		for j in range(lurd[0], lurd[2] + 1):
			if (tile_array[i][j].nine_perimeter_mine || !tile_array[i][j].enabled):
				return false
	return true


func preset_mines(pos_9) -> void :


	var adv_row = pos_9[0]
	var adv_col = pos_9[1]
	tile_array[adv_row][adv_col].mine_value = 9
	tile_array[adv_row][adv_col].value = 9
	tile_array[adv_row][adv_col].nine_perimeter_mine = true


	var nine_lurd: Array = get_adjacent_bounds(Vector2(adv_row, adv_col), false)
	var lurd

	for temp_row in range(nine_lurd[1], nine_lurd[3] + 1):
		for temp_col in range(nine_lurd[0], nine_lurd[2] + 1):



			if (tile_array[temp_row][temp_col].mine != true && Vector2i(temp_row, temp_col) != Vector2i(adv_row, adv_col)):
				tile_array[temp_row][temp_col].mine = true
				tile_array[temp_row][temp_col].mine_type = 1
				tile_array[temp_row][temp_col].nine_perimeter_mine = true
				tile_array[temp_row][temp_col].set_icon("mine1")
				mines -= 1


				lurd = get_adjacent_bounds(Vector2(temp_row, temp_col), false)

				for i in range(lurd[1], lurd[3] + 1):
					for j in range(lurd[0], lurd[2] + 1):
						if (tile_array[i][j].mine != true && tile_array[i][j].value != 9):
							tile_array[i][j].value += 1
							tile_array[i][j].mine_value += 1


func un_preset_mines(pos_9) -> void :
	var lurd = get_adjacent_bounds(pos_9, false)
	var lurd2

	for i in range(lurd[1], lurd[3] + 1):
		for j in range(lurd[0], lurd[2] + 1):
			tile_array[i][j].value = 0
			tile_array[i][j].mine = false
			tile_array[i][j].mine_value = -99
			tile_array[i][j].processed = false
			tile_array[i][j].nine_perimeter_mine = false
			tile_array[i][j].set_icon("0")
			mines += 1

			lurd2 = get_adjacent_bounds(Vector2i(i, j), false)

			for k in range(lurd2[1], lurd2[3] + 1):
				for l in range(lurd2[0], lurd2[2] + 1):
					tile_array[k][l].value = 0
					tile_array[k][l].mine_value = 0


func shuffle_board() -> void :

	get_tree().call_group("game_tiles", "set_disabled", true)

	var open_tiles = 0
	var flagged_mines = 0
	var flag_mistakes = 0


	for i in range(game_rows):
		for j in range(game_columns):
			if ((i < nine_position[0]) || (i > nine_position[0])
			|| (j < nine_position[1]) || (j > nine_position[1])):
				if (tile_array[i][j].open == true):
					open_tiles += 1
				if (tile_array[i][j].value == -1 && tile_array[i][j].flagged == true):
					flagged_mines += 1
				if (tile_array[i][j].value != -1 && tile_array[i][j].flagged == true):
					flag_mistakes += 1
				tile_array[i][j].value = 0
				tile_array[i][j].open = false
				tile_array[i][j].flagged = false


	var num_mines = mines
	var row
	var col
	var lurd
	var lurd2


	lurd = get_adjacent_bounds(nine_position, false)
	for i in range(lurd[1], lurd[3] + 1):
		for j in range(lurd[0], lurd[2] + 1):
			if (tile_array[i][j].value != 9):
				tile_array[i][j].value = -1
				tile_array[i][j].set_icon("mine1")

				lurd2 = get_adjacent_bounds(Vector2(i, j), false)
				for k in range(lurd2[1], lurd2[3] + 1):
					for l in range(lurd2[0], lurd2[2] + 1):
						if (tile_array[k][l].value != -1 && tile_array[k][l].value != 9):
							tile_array[k][l].value += 1

	while num_mines > 0:
		row = randi_range(0, game_rows - 1)
		col = randi_range(0, game_columns - 1)
		if ((row < nine_position[0] - 1) || (row > nine_position[0] + 1)
		|| (col < nine_position[1] - 1) || (col > nine_position[1] + 1)):
			if (tile_array[row][col].value != -1 && tile_array[row][col].value != 9):
				tile_array[row][col].value = -1
				tile_array[row][col].set_icon("mine1")
				num_mines -= 1

				lurd = get_adjacent_bounds(Vector2(row, col), false)

				for i in range(lurd[1], lurd[3] + 1):
					for j in range(lurd[0], lurd[2] + 1):
						if (tile_array[i][j].value != -1):
							tile_array[i][j].value += 1

	for i in range(tile_array.size()):
		for j in range(tile_array[i].size()):
			if (tile_array[i][j].value != -1):
				tile_array[i][j].set_icon(var_to_str(tile_array[i][j].value))


	while (flag_mistakes > 0):
		row = randi_range(0, game_rows - 1)
		col = randi_range(0, game_columns - 1)
		if (tile_array[row][col].value != -1 && tile_array[row][col].value != 9 && tile_array[row][col].flagged == false):
			tile_array[row][col].flagged = true
			flag_mistakes -= 1


	while (open_tiles > 0 || flagged_mines > 0):
		row = randi_range(0, game_rows - 1)
		col = randi_range(0, game_columns - 1)
		if (tile_array[row][col].value == -1 && tile_array[row][col].value != 9 && tile_array[row][col].flagged == false && flagged_mines > 0):
			tile_array[row][col].flagged = true
			flagged_mines -= 1
		elif (tile_array[row][col].value != -1 && tile_array[row][col].value != 9 && tile_array[row][col].open == false && open_tiles > 0):
			tile_array[row][col].open = true
			open_tiles -= 1


	for i in range(tile_array.size()):
		for j in range(tile_array[i].size()):
			if (tile_array[i][j].value != 9):
				tile_array[i][j].set_opened()
				tile_array[i][j].set_flagged()

	get_tree().call_group("game_tiles", "set_disabled", false)


func check_tile(movement_pattern, mine_index) -> bool:

	if (nine_position[mine_index][0] <= 0 || nine_position[mine_index][0] >= game_rows - 1
	|| nine_position[mine_index][1] <= 0 || nine_position[mine_index][1] >= game_columns - 1):
		return false

	if (movement_pattern == 1):
		for i in range(nine_position[mine_index][0] - 1, nine_position[mine_index][0] + 2):
			if (nine_position[mine_index][1] - 2 >= 0 && (tile_array[i][nine_position[mine_index][1] - 2].enabled == false
			|| tile_array[i][nine_position[mine_index][1] - 2].nine_perimeter_mine == true)):
				return false

	elif (movement_pattern == 2):
		for i in range(nine_position[mine_index][1] - 1, nine_position[mine_index][1] + 2):
			if (nine_position[mine_index][0] - 2 >= 0 && (tile_array[nine_position[mine_index][0] - 2][i].enabled == false)
			|| tile_array[nine_position[mine_index][0] - 2][i].nine_perimeter_mine == true):
				return false

	elif (movement_pattern == 3):
		for i in range(nine_position[mine_index][0] - 1, nine_position[mine_index][0] + 2):
			if (nine_position[mine_index][1] + 2 <= game_columns - 1 && (tile_array[i][nine_position[mine_index][1] + 2].enabled == false
			|| tile_array[i][nine_position[mine_index][1] + 2].nine_perimeter_mine == true)):
				return false

	elif (movement_pattern == 4):
		for i in range(nine_position[mine_index][1] - 1, nine_position[mine_index][1] + 2):
			if (nine_position[mine_index][0] + 2 <= game_rows - 1 && (tile_array[nine_position[mine_index][0] + 2][i].enabled == false
			|| tile_array[nine_position[mine_index][0] + 2][i].nine_perimeter_mine == true)):
				return false

	return true


func shift_tile(position, next_position) -> void :
	var temp_tile: Array
	var tile_start = tile_array[position[0]][position[1]]
	var tile_next = tile_array[next_position[0]][next_position[1]]
	temp_tile = [tile_start.mine, 
				tile_start.mine_type, 
				tile_start.open, 
				tile_start.flagged, 
				tile_start.flag_number]


	tile_start.mine = tile_next.mine
	tile_start.mine_type = tile_next.mine_type
	tile_start.open = tile_next.open
	if (Main.eleven_count > 0):
		tile_start.flagged = tile_next.flagged
		tile_start.flag_number = tile_next.flag_number
		tile_start.get_node("Flag").play("flag" + var_to_str(tile_start.flag_order[tile_start.flag_number]))
	else:
		tile_start.flagged = false
		tile_start.flag_number = 0
	tile_start.nine_perimeter_mine = false
	if (tile_start.mine == true):
		tile_start.set_icon("mine" + var_to_str(tile_start.mine_type))
		tile_start.open = false
		if (tile_start.mine_type < 0 && tile_start.mine_type != -99): tile_start.antimine = true
		else: tile_start.antimine = false
		if (tile_start.mine_type > 1): tile_start.doublemine = true
		else: tile_start.doublemine = false
		tile_start.set_z_index(0)
	tile_start.set_opened()
	tile_start.set_flagged()

	tile_next.mine = temp_tile[0]
	tile_next.mine_type = temp_tile[1]
	tile_next.open = temp_tile[2]
	tile_next.flagged = temp_tile[3]
	tile_next.flag_number = temp_tile[4]
	tile_next.nine_perimeter_mine = true
	if (tile_next.mine == true):
		tile_next.set_icon("mine" + var_to_str(tile_next.mine_type))
		tile_next.open = false
		if (tile_next.mine_type < 0 && tile_next.mine_type != -99): tile_next.antimine = true
		else: tile_next.antimine = false
		if (tile_next.mine_type > 1): tile_next.doublemine = true
		else: tile_next.doublemine = false
		tile_next.set_z_index(0)
	tile_next.set_opened()
	tile_next.set_flagged()


func move_nine(pattern, mine_index) -> void :
	var nine_move_vector


	if (pattern == 1): nine_move_vector = Vector2i(0, -1)

	elif (pattern == 2): nine_move_vector = Vector2i(-1, 0)

	elif (pattern == 3): nine_move_vector = Vector2i(0, 1)

	elif (pattern == 4): nine_move_vector = Vector2i(1, 0)


	var lurd = get_adjacent_bounds(nine_position[mine_index], false)

	if (pattern == 1):
		for i in range(lurd[0], lurd[2] + 1, 1):
			for j in range(lurd[1], lurd[3] + 1, 1):
				await shift_tile(Vector2i(j, i), Vector2i(j, i) + nine_move_vector)

	elif (pattern == 2):
		for i in range(lurd[1], lurd[3] + 1, 1):
			for j in range(lurd[0], lurd[2] + 1, 1):
				await shift_tile(Vector2i(i, j), Vector2i(i, j) + nine_move_vector)

	elif (pattern == 3):
		for i in range(lurd[2], lurd[0] - 1, -1):
			for j in range(lurd[3], lurd[1] - 1, -1):
				await shift_tile(Vector2i(j, i), Vector2i(j, i) + nine_move_vector)

	elif (pattern == 4):
		for i in range(lurd[3], lurd[1] - 1, -1):
			for j in range(lurd[2], lurd[0] - 1, -1):
				await shift_tile(Vector2i(i, j), Vector2i(i, j) + nine_move_vector)


	nine_position[mine_index] += nine_move_vector

	var big_lurd = get_large_adjacent_bounds(nine_position[mine_index])

	for i in range(big_lurd[1], big_lurd[3] + 1):
		for j in range(big_lurd[0], big_lurd[2] + 1):

			if (tile_array[i][j].mine != true):
				tile_array[i][j].get_node("Background2").play("waves" + var_to_str(Main.game_style) + "2")
				tile_array[i][j].get_node("Background2Low").play("waves" + var_to_str(Main.game_style) + "2")
				tile_array[i][j].get_node("Icon").set_z_index(0)
				tile_array[i][j].value = 0
				tile_array[i][j].mine_value = 0
				tile_array[i][j].set_icon(var_to_str(tile_array[i][j].value))

				lurd = get_adjacent_bounds(Vector2i(i, j), false)

				for x in range(lurd[1], lurd[3] + 1):
					for y in range(lurd[0], lurd[2] + 1):
						if (tile_array[x][y].mine == true):
							tile_array[i][j].value += tile_array[x][y].mine_type
							tile_array[i][j].mine_value += 1
							tile_array[i][j].set_icon(var_to_str(tile_array[i][j].value))


func open_tile(tile: Vector2i):

	if Main.db["zero_spread_algorithm"] == 0:

		var process_array = []
		var lurd
		process_array.append(tile)
		tile_array[tile[0]][tile[1]].processed = true
		var tile_counter = 0
		var tile_goal = 1
		while (process_array.size() > 0):
			tile = process_array[0]
			if (tile_array[tile[0]][tile[1]].enabled == true && 
			tile_array[tile[0]][tile[1]].open == false && 
			tile_array[tile[0]][tile[1]].flagged == false):
				open_one(tile)
				tile_counter += 1
			if (tile_array[tile[0]][tile[1]].value == 0 && tile_array[tile[0]][tile[1]].mine_value == 0 && 
			!tile_array[tile[0]][tile[1]].mine && !tile_array[tile[0]][tile[1]].mistake):
				lurd = get_adjacent_bounds(tile, true)
				for i in range(lurd[1], lurd[3] + 1):
					for j in range(lurd[0], lurd[2] + 1):
						if (tile_array[i][j].enabled == true && 
						tile_array[i][j].open == false && 
						tile_array[i][j].flagged == false && 
						tile_array[i][j].processed == false):
							if (check_walls(i, j, tile[0], tile[1])):
								process_array.append(tile_array[i][j].row_col)
								tile_array[i][j].processed = true
			process_array.pop_front()

			if (tile_counter == tile_goal):
				if ( !Main.db["instant_zero_spread"]): await get_tree().process_frame
				tile_counter = 0
				tile_goal += 2
	else:


		if (tile_array[tile[0]][tile[1]].enabled == false || tile_array[tile[0]][tile[1]].open == true || tile_array[tile[0]][tile[1]].flagged == true):
			return
		else:


			open_one(tile)



			if (tile_array[tile[0]][tile[1]].value == 0):

				if (tile[0] != 0 && tile[1] != 0):
					open_tile(Vector2i(tile[0] - 1, tile[1] - 1))

				if (tile[0] != 0):
					open_tile(Vector2i(tile[0] - 1, tile[1]))

				if (tile[0] != 0 && tile[1] != game_columns - 1):
					open_tile(Vector2i(tile[0] - 1, tile[1] + 1))

				if (tile[1] != 0):
					open_tile(Vector2i(tile[0], tile[1] - 1))

				if (tile[1] != game_columns - 1):
					open_tile(Vector2i(tile[0], tile[1] + 1))

				if (tile[0] != game_rows - 1 && tile[1] != 0):
					open_tile(Vector2i(tile[0] + 1, tile[1] - 1))

				if (tile[0] != game_rows - 1):
					open_tile(Vector2i(tile[0] + 1, tile[1]))

				if (tile[0] != game_rows - 1 && tile[1] != game_columns - 1):
					open_tile(Vector2i(tile[0] + 1, tile[1] + 1))
			else:
				return



func open_one(coords: Vector2i) -> void :
	var opened = tile_array[coords[0]][coords[1]]
	if (opened.enabled == true):
		opened.open = true
		opened.get_node("Background1").visible = false
		opened.get_node("Background1Low").visible = false

		if (opened.style == 101 || opened.style == 102):
			opened.get_node("outline").visible = false
		if (opened.mine == true):
			mistake_catch(coords)
			Main.db["total_mines_revealed"] += 1
		else:
			tiles_opened += 1
			opened.fancy_icon_animation()

			if (opened.value > 0):
				Main.db["revealed_numbers"][opened.value] += 1
			elif (opened.value < 0):
				var index = absi(opened.value)
				Main.db["revealed_negative_numbers"][index] += 1
			elif (opened.value == 0 && opened.mine_value > 0):
				Main.db["revealed_negative_numbers"][0] += 1
			if (Main.challenge):
				Main.challenge_coin += pow(2, opened.mine_value - 1)
				pass_challenge.emit()
		Main.db["total_tiles_opened"] += 1

		if (tiles_opened == win_tiles):
			if ( !Main.nine && !Main.nine_count > 0):
				if ( !Main.ten && !Main.ten_count > 0):
					if ( !Main.eleven && !Main.eleven_count > 0): end_game(true)
					else: eleven_end.emit(true)
				else: ten_end.emit(true)
			else:
				nine_win_flag = true



func mistake_catch(coords: Vector2i) -> void :
	get_tree().call_group("tiles", "set_disabled", true)
	tile_array[coords[0]][coords[1]].get_node("Background2").play("red_back")
	tile_array[coords[0]][coords[1]].get_node("Background2Low").play("red_back")
	tile_array[coords[0]][coords[1]].get_node("Icon").set_z_index(1)
	tile_array[coords[0]][coords[1]].mine = false
	tile_array[coords[0]][coords[1]].mistake = true
	pass_mine_click.emit()

	if (Main.db["exploding_mines"]):
		$MineSound.play()
		await get_tree().create_timer(1).timeout
		if (tile_array[coords[0]][coords[1]].antimine):
			tile_array[coords[0]][coords[1]].get_node("Icon").play("explosion-")
		else:
			tile_array[coords[0]][coords[1]].get_node("Icon").play("explosion")

		$ExplosionSound.play()

	tile_array[coords[0]][coords[1]].value -= 1
	if ( !Main.practice):
		if (Main.adventure_mode):
			if (Main.db["adventure_shield"] == 0):
				Main.db["adventure_health"] -= 1
				health -= 1
		elif (Main.endless):
			if (Main.db["endless_shield"] == 0):
				Main.db["endless_health"] -= 1
				health -= 1
		else:
			health -= 1

	mistake.emit()
	_flag_pass(true)

	var lurd: Array = get_adjacent_bounds(coords, false)

	var mine_value = 1
	if (tile_array[coords[0]][coords[1]].antimine == true): mine_value *= -1
	if (tile_array[coords[0]][coords[1]].doublemine == true): mine_value *= 2

	for i in range(lurd[1], lurd[3] + 1):
		for j in range(lurd[0], lurd[2] + 1):
			if (tile_array[i][j].mine != true && tile_array[i][j].mistake != true):
				tile_array[i][j].mine_value -= 1
				tile_array[i][j].value -= mine_value
				tile_array[i][j].set_icon(var_to_str(tile_array[i][j].value))

	if ( !no_more_opening): get_tree().call_group("tiles", "set_disabled", false)


	if (health <= 0):
		end_game(false)

func get_adjacent_bounds(coords, gameplay) -> Array:
	var tile = tile_array[coords[0]][coords[1]]
	var left
	if (coords[1] == 0): left = 0

	else: left = coords[1] - 1
	var up
	if (coords[0] == 0): up = 0

	else: up = coords[0] - 1
	var right
	if (coords[1] == game_columns - 1): right = game_columns - 1

	else: right = coords[1] + 1
	var down
	if (coords[0] == game_rows - 1): down = game_rows - 1

	else: down = coords[0] + 1

	return [left, up, right, down]

func get_large_adjacent_bounds(coords) -> Array:
	var left
	if (coords[1] <= 2): left = 0
	else: left = coords[1] - 3
	var up
	if (coords[0] <= 2): up = 0
	else: up = coords[0] - 3
	var right
	if (coords[1] >= game_columns - 3): right = game_columns - 1
	else: right = coords[1] + 3
	var down
	if (coords[0] >= game_rows - 3): down = game_rows - 1
	else: down = coords[0] + 3

	return [left, up, right, down]


func check_walls(row, col, tile_row, tile_col) -> bool:
	var t = tile_array[row][col]
	var T = tile_array[tile_row][tile_col]
	if (row < tile_row && col < tile_col):
		if ((t.outline_array[1] == 1 || T.outline_array[0] == 1) && (t.outline_array[2] == 1 || T.outline_array[3] == 1)):
			return false
	elif (row < tile_row && col > tile_col):
		if ((t.outline_array[3] == 1 || T.outline_array[0] == 1) && (t.outline_array[2] == 1 || T.outline_array[1] == 1)):
			return false
	elif (row > tile_row && col < tile_col):
		if ((t.outline_array[1] == 1 || T.outline_array[2] == 1) && (t.outline_array[0] == 1 || T.outline_array[3] == 1)):
			return false
	elif (row > tile_row && col > tile_col):
		if ((t.outline_array[3] == 1 || T.outline_array[2] == 1) && (t.outline_array[0] == 1 || T.outline_array[1] == 1)):
			return false
	elif (row < tile_row):
		if (t.outline_array[2] == 1):
			return false
	elif (col < tile_col):
		if (t.outline_array[1] == 1):
			return false
	elif (col > tile_col):
		if (t.outline_array[3] == 1):
			return false
	elif (row > tile_row):
		if (t.outline_array[0] == 1):
			return false


	return true


















func quick_open(coords: Vector2i) -> void :
	var flags = 0
	var tile = tile_array[coords[0]][coords[1]]

	var left
	if (coords[1] == 0): left = 0

	else: left = coords[1] - 1
	var up
	if (coords[0] == 0): up = 0

	else: up = coords[0] - 1
	var right
	if (coords[1] == game_columns - 1): right = game_columns - 1

	else: right = coords[1] + 1
	var down
	if (coords[0] == game_rows - 1): down = game_rows - 1

	else: down = coords[0] + 1


	for i in range(up, down + 1):
		for j in range(left, right + 1):
			if (tile_array[i][j].flagged == true && check_walls(i, j, coords[0], coords[1])):
				flags += tile_array[i][j].flag_order[tile_array[i][j].flag_number]



	if (tile_array[coords[0]][coords[1]].value == flags && chording):
		for i in range(up, down + 1):
			for j in range(left, right + 1):
				if (tile_array[i][j].enabled == true && check_walls(i, j, coords[0], coords[1])):
					open_tile(Vector2i(i, j))


func _flag_pass(flagged) -> void :
	if (flagged): flagged_tiles += 1
	else: flagged_tiles -= 1
	pass_flag.emit(flagged)



func _face_pass(face) -> void :
	pass_face.emit(face)



func _radar_pass() -> void :
	pass_radar.emit()
	if ( !Main.practice):
		Main.db["coins_spent_on_sonar"] += radar_price
		if (Main.adventure_mode):
			if (Main.db["episode"] == 3):
				if (Main.db["pursuit"] == 0): radar_price = 35
				else: radar_price += 35
			elif (Main.db["episode"] == 2):
				if (Main.db["pursuit"] == 0): radar_price = 40
				else: radar_price += 40
			else:
				if (Main.db["pursuit"] == 0): radar_price = 50
				else: radar_price += 50
		else: radar_price += 50


func end_game(win: bool) -> void :
	game_time.emit(false)
	game_over.emit(win)

func reveal_board(win: bool) -> void :
	get_tree().call_group("tiles", "reveal_mines", win)
	if ((Main.nine || Main.ten || Main.eleven) && !win):
		explode_mines()

func get_mine_number() -> int:
	var num = 0
	for i in range(game_rows):
			for j in range(game_columns):
				if (tile_array[i][j].mine == true):
					num += 1
	return num

func explode_mines() -> void :
	if (Main.db["exploding_mines"]):
		var every = (randi() % 10) + 5
		var every_left = every
		var mines_left = get_mine_number()

		while (mines_left > 0):
			for i in range(game_rows):
				for j in range(game_columns):
					if (tile_array[i][j].mine == true && every_left == 0):
						await get_tree().create_timer(3.0 / mines).timeout
						tile_array[i][j].open = true
						tile_array[i][j].flagged = false
						tile_array[i][j].set_opened()
						tile_array[i][j].set_flagged()
						tile_array[i][j].get_node("Icon").set_z_index(1)
						tile_array[i][j].get_node("Icon").play("explosion")
						tile_array[i][j].value = 0
						$ExplosionSound.play()
						mines_left -= 1
						every_left = every
					elif (tile_array[i][j].mine == true):
						every_left -= 1


func calculate_score() -> int:
	if (win_tiles == 1): return 1
	if (Main.practice): return 0
	var double_multiplier = 1.0
	var anti_multiplier = 1.0
	var larger

	if (doublemines):
		if (Main.double_method):
			if (Main.double_number != 0 && mines != 0):
				if (Main.double_number >= mines - Main.double_number): larger = Main.double_number
				else: larger = mines - Main.double_number
				double_multiplier = 1.0 + (float(larger) / float(mines))
		else:
			double_multiplier = 1.0 + (0.5 - abs(0.5 - (float(Main.double_number) / 100)))
	if (antimines):
		if (Main.anti_method):
			if (Main.anti_number != 0 && mines != 0):
				if (Main.anti_number >= mines - Main.anti_number): larger = Main.anti_number
				else: larger = mines - Main.anti_number
				anti_multiplier = 1.0 + (float(larger) / float(mines))
		else:
			anti_multiplier = 1.0 + (0.5 - abs(0.5 - (float(Main.anti_number) / 100)))

	var score = 0
	for i in range(tile_array.size()):
		for j in range(tile_array[i].size()):
			if (tile_array[i][j].mine == false && tile_array[i][j].mine_value < 9 && tile_array[i][j].mine_value > 0):
				score += pow(2, tile_array[i][j].mine_value - 1)
			if (tile_array[i][j].antimine): score += 1
			if (tile_array[i][j].doublemine): score += 1
	if (Main.nine): score += 999
	if (Main.ten): score += 1000
	if (Main.eleven): score += 1111
	if (Main.nine_count > 0): score += 9
	if (Main.ten_count > 0): score += 10
	if (Main.eleven_count > 0): score += 11
	score += mines
	if (Main.db["master"]): score *= 1.5
	score *= double_multiplier
	score *= anti_multiplier
	return score

func calculate_percent() -> float:
	return snapped(((float(tiles_opened)) / (float(win_tiles))), 0.001)


func reset_board() -> void :
	for i in range(game_rows):
		for j in range(game_columns):
			tile_array[i][j].reset_tile()

	pre_flag_tiles()

	tiles_opened = 0
	already_setup = false
	if ( !Main.practice): radar_price = 50
	if (Main.db["master"] == true):
		health = 1
	else:
		health = 3

func set_nine_icon(text) -> void :
	for i in range(nine_position.size()):
		tile_array[nine_position[i][0]][nine_position[i][1]].set_icon(text)

func victory_flag(mine_index) -> void :
	tile_array[nine_position[mine_index][0]][nine_position[mine_index][1]].set_victory_flag()
	tile_array[nine_position[mine_index][0]][nine_position[mine_index][1]].modulate = Color(1, 1, 1, 0)
	tile_array[nine_position[mine_index][0]][nine_position[mine_index][1]].set_z_index(1)
	tile_array[nine_position[mine_index][0]][nine_position[mine_index][1]].open = false
	tile_array[nine_position[mine_index][0]][nine_position[mine_index][1]].set_opened()
	while (tile_array[nine_position[mine_index][0]][nine_position[mine_index][1]].modulate[3] < 1):
		await get_tree().create_timer(0.01).timeout
		tile_array[nine_position[mine_index][0]][nine_position[mine_index][1]].modulate[3] += get_process_delta_time()
	if (Main.nine):
		await get_tree().create_timer(2).timeout
	tile_array[nine_position[mine_index][0]][nine_position[mine_index][1]].flagged = true
	$Tick.set_pitch_scale(1)
	$Tick.play()
	tile_array[nine_position[mine_index][0]][nine_position[mine_index][1]].set_flagged()
	await get_tree().create_timer(1).timeout
	tile_array[nine_position[mine_index][0]][nine_position[mine_index][1]].set_z_index(0)

func _tile_chorder(coords, frame) -> void :
	var lurd: Array = get_adjacent_bounds(coords, true)

	for i in range(lurd[1], lurd[3] + 1):
		for j in range(lurd[0], lurd[2] + 1):
			if (tile_array[i][j].flagged == false && check_walls(i, j, coords[0], coords[1])):
				tile_array[i][j].set_outline(frame)

func highlight_missed_tiles() -> void :
	for i in range(tile_array.size()):
		for j in range(tile_array[i].size()):
			if (tile_array[i][j].open == false && tile_array[i][j].enabled == true && tile_array[i][j].mine != true && tile_array[i][j].value <= 9):
				tile_array[i][j].blink2()

func pause_tiles(paused) -> void :
	get_tree().call_group("game_tiles", "pause", paused)
