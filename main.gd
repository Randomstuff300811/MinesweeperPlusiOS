extends Control

var adventure_length = [
	[
	[5, 6, 7, 8], [7, 8, 9, 10], [9, 10, 11, 12], 
	[11, 9, 7, 5], [18, 18, 18, 18], [13, 15, 16, 18], 
	[14, 18, 24, 30], [12, 16, 20, 24], [11, 13, 17, 19]
	], 
	[
	[9, 12, 15, 18], [11, 14, 18, 24], [15, 25, 27, 29], 
	[13, 17, 21, 23], [15, 18, 21, 20], [18, 30, 30, 30], 
	[20, 30, 30, 32], [30, 30, 36, 30], [13, 17, 23, 21], 
	[19, 21, 23, 25]
	], 
	[
	[8, 9, 10, 12], [10, 12, 14, 16], [12, 13, 14, 16], 
	[12, 19, 17, 25], [17, 15, 21, 17], [16, 18, 21, 24], 
	[19, 20, 30, 39], [27, 30, 29, 32], [11, 15, 19, 17], 
	[24, 26, 28, 29], [17, 21, 23, 25]
	]
]
var adventure_width = [
	[
	[5, 6, 7, 8], [7, 8, 9, 10], [9, 10, 11, 12], 
	[12, 12, 12, 12], [11, 9, 7, 5], [13, 15, 16, 18], 
	[10, 12, 16, 20], [12, 16, 20, 24], [11, 13, 13, 13]
	], 
	[
	[9, 12, 15, 18], [11, 14, 18, 24], [15, 13, 15, 29], 
	[13, 15, 17, 15], [15, 18, 21, 20], [18, 18, 24, 30], 
	[20, 20, 30, 32], [20, 30, 24, 36], [13, 17, 23, 21], 
	[19, 21, 23, 25]
	], 
	[
	[8, 9, 10, 12], [10, 12, 14, 16], [12, 13, 14, 16], 
	[16, 12, 21, 15], [13, 18, 15, 23], [16, 18, 20, 24], 
	[22, 30, 30, 30], [27, 24, 29, 36], [11, 15, 13, 17], 
	[24, 26, 28, 29], [17, 21, 23, 25]
	]
]
var adventure_mines = [
	[
	[1, 3, 5, 8], [4, 6, 9, 13], [7, 10, 15, 20], 
	[12, 12, 12, 12], [20, 20, 20, 20], [20, 30, 40, 50], 
	[23, 33, 66, 111], [25, 42, 77, 136], [19, 29, 38, 47]
	], 
	[
	[4, 9, 16, 25], [10, 17, 26, 42], [13, 23, 33, 46], 
	[20, 28, 40, 35], [20, 28, 35, 40], [24, 45, 55, 72], 
	[40, 48, 67, 100], [55, 64, 92, 142], [29, 47, 51, 55], 
	[40, 60, 80, 100]
	], 
	[
	[8, 10, 15, 24], [11, 22, 33, 44], [18, 21, 29, 37], 
	[20, 25, 41, 54], [28, 40, 47, 63], [34, 47, 68, 99], 
	[62, 80, 104, 133], [77, 99, 131, 177], [25, 42, 55, 62], 
	[34, 53, 72, 91], [33, 55, 77, 99]
	]
]
var adventure_cuts = [

	[], 

	[

	[

	[[0, 0, 2, 2], [6, 0, 8, 2], [0, 6, 2, 8], [6, 6, 8, 8]], 
	[[0, 0, 3, 3], [8, 0, 11, 3], [0, 8, 3, 11], [8, 8, 11, 11]], 
	[[0, 0, 4, 4], [10, 0, 14, 4], [0, 10, 4, 14], [10, 10, 14, 14]], 
	[[0, 0, 5, 5], [12, 0, 17, 5], [0, 12, 5, 17], [12, 12, 17, 17]]
	], 

	[

	[[4, 4, 6, 6]], 
	[[4, 4, 6, 6], [7, 7, 9, 9, ], [0, 11, 2, 13], [11, 0, 13, 2]], 
	[[0, 13, 4, 17], [13, 0, 17, 4], [3, 3, 6, 6], [11, 11, 14, 14], [6, 9, 8, 11], [9, 6, 11, 8]], 
	[[6, 0, 17, 2], [6, 21, 17, 23], [0, 6, 2, 17], [21, 6, 23, 17], [6, 6, 8, 8], [15, 6, 17, 8], [6, 15, 8, 17], [15, 15, 17, 17], [9, 9, 14, 14], [0, 0, 2, 2], [0, 21, 2, 23], [21, 0, 23, 2], [21, 21, 23, 23]]
	], 

	[

	[[0, 1, 0, 14, 13, 14]], 
	[[0, 11, 0, 0, 11, 0], [24, 11, 24, 0, 13, 0]], 
	[[0, 13, 0, 0, 13, 0], [26, 1, 26, 14, 13, 14]], 
	[[0, 25, 0, 0, 13, 0], [28, 25, 28, 0, 15, 0], [14, 25, 14, 14, 8, 14], [14, 25, 14, 14, 20, 14]]
	], 

	[

	[[7, 1]], 
	[[9, 1], [11, 1]], 
	[[9, 1], [7, 1], [5, 1]], 
	[[1, 1]], 
	], 

	[

	[[5, 0, 9, 2], [0, 5, 2, 9], [5, 12, 9, 14], [12, 5, 14, 9]], 
	[[6, 0, 11, 4], [0, 6, 4, 11], [6, 13, 11, 17], [13, 6, 17, 11]], 
	[[7, 0, 13, 6], [0, 7, 6, 13], [7, 14, 13, 20], [14, 7, 20, 13]], 
	[[9, 0, 10, 8], [0, 9, 8, 10], [9, 11, 10, 19], [11, 9, 19, 10]]
	], 

	[

	[[0, 7, 0, 0, 7, 0], [17, 7, 17, 0, 10, 0], [17, 10, 17, 17, 10, 17], [0, 10, 0, 17, 7, 17]], 
	[[0, 7, 0, 0, 7, 0], [29, 7, 29, 0, 22, 0], [29, 10, 29, 17, 22, 17], [0, 10, 0, 17, 7, 17], [14, 4, 14, 0, 10, 0], [15, 4, 15, 0, 19, 0], [14, 13, 14, 17, 10, 17], [15, 13, 15, 17, 19, 17]], 
	[[0, 13, 0, 0, 13, 0], [29, 13, 29, 0, 16, 0], [29, 16, 29, 23, 22, 23], [0, 16, 0, 23, 7, 23], [14, 19, 14, 23, 10, 23], [14, 19, 14, 23, 10, 23], [15, 19, 15, 23, 19, 23], [7, 13, 10, 16], [13, 7, 16, 10], [19, 13, 22, 16]], 
	[[0, 13, 0, 0, 13, 0], [29, 13, 29, 0, 16, 0], [0, 16, 0, 29, 13, 29], [29, 16, 29, 29, 16, 29], [13, 13, 16, 16], [5, 13, 8, 16], [21, 13, 24, 16], [13, 5, 16, 8], [13, 21, 16, 24]]
	], 

	[

	[[4, 4, 7, 7], [12, 4, 15, 7], [4, 12, 15, 15], [3, 15, 3, 10, 1, 10], [16, 15, 16, 10, 18, 10]], 
	[[0, 12, 0, 19, 7, 19], [29, 12, 29, 19, 22, 19], [0, 0, 5, 9], [6, 0, 8, 2], [12, 0, 14, 2], [15, 0, 20, 9], [21, 0, 23, 6], [24, 0, 29, 9]], 
	[[24, 0, 29, 23], [18, 0, 23, 20], [0, 0, 11, 2], [0, 3, 5, 5], [0, 9, 5, 11], [0, 12, 11, 14], [0, 15, 14, 20], [0, 21, 5, 23]], 
	[[0, 7, 0, 0, 7, 0], [31, 24, 31, 31, 24, 31], [0, 24, 0, 31, 7, 31], [31, 7, 31, 0, 24, 0], [9, 0, 13, 5], [18, 0, 22, 5], [0, 9, 5, 13], [0, 18, 5, 22], [9, 26, 13, 31], [18, 26, 22, 31], [26, 9, 31, 13], [26, 18, 31, 22], [2, 25, 2, 23, 0, 23], [3, 24, 3, 23, 4, 23], [8, 31, 8, 29, 6, 29], [8, 27, 8, 28, 7, 28], [8, 0, 8, 2, 6, 2], [8, 4, 8, 3, 7, 3], [2, 6, 2, 8, 0, 8], [3, 7, 3, 8, 4, 8], [29, 6, 29, 8, 31, 8], [28, 7, 28, 8, 27, 8], [23, 0, 23, 2, 25, 2], [23, 4, 23, 3, 24, 3], [23, 31, 23, 29, 25, 29], [23, 27, 23, 28, 24, 28], [29, 25, 29, 23, 31, 23], [28, 24, 28, 23, 27, 23]]
	], 

	[

	[[0, 0, 5, 6], [6, 13, 11, 19], [12, 0, 17, 6], [18, 13, 23, 19], [24, 0, 29, 6]], 
	[[0, 0, 9, 9], [20, 0, 29, 9], [10, 8, 10, 0, 14, 0], [20, 8, 20, 0, 16, 0], [0, 11, 0, 18, 7, 18], [4, 29, 4, 18, 7, 18], [0, 18, 3, 29], [29, 11, 29, 18, 22, 18], [25, 29, 25, 18, 22, 18], [26, 18, 29, 29], [14, 23, 14, 29, 6, 29], [15, 23, 15, 29, 23, 29]], 
	[[17, 2, 17, 5, 11, 5], [18, 2, 18, 5, 24, 5], [9, 7, 9, 11, 2, 11], [9, 16, 9, 12, 2, 12], [17, 21, 17, 18, 11, 18], [18, 21, 18, 18, 24, 18], [26, 7, 26, 11, 33, 11], [26, 16, 26, 12, 33, 12], [0, 4, 0, 0, 6, 0], [0, 20, 0, 23, 5, 23], [35, 3, 35, 0, 30, 0], [35, 20, 35, 23, 30, 23], [16, 10, 19, 13]], 
	[[0, 5, 0, 0, 5, 0], [29, 5, 29, 0, 24, 0], [0, 24, 0, 29, 5, 29], [29, 24, 29, 29, 24, 29], [0, 30, 6, 35], [23, 30, 29, 35], [11, 30, 12, 35], [17, 30, 18, 35], [6, 12, 11, 17], [18, 12, 23, 17], [15, 18, 15, 23, 17, 23], [14, 18, 14, 23, 12, 23]]
	], 

	[

	[[4, 4, 8, 4], [4, 4, 4, 8], [4, 8, 8, 8], [8, 4, 8, 8]], 
	[[5, 4, 5, 6], [4, 5, 6, 5], [11, 4, 11, 6], [10, 5, 12, 5], [5, 10, 5, 12], [4, 11, 6, 11], [11, 10, 11, 12], [10, 11, 12, 11]], 
	[[0, 10, 0, 0, 10, 0], [22, 10, 22, 0, 12, 0], [0, 12, 0, 22, 10, 22], [22, 12, 22, 22, 12, 22]], 
	[[3, 3, 5, 5], [9, 3, 11, 5], [15, 3, 17, 5], [3, 9, 5, 11], [15, 9, 17, 11], [3, 15, 5, 17], [9, 15, 11, 17], [15, 15, 17, 17]]
	], 

	[

	[[0, 3, 0, 0, 3, 0], [18, 3, 18, 0, 15, 0], [0, 15, 0, 18, 3, 18], [18, 15, 18, 18, 15, 18]], 
	[[0, 4, 0, 0, 4, 0], [20, 4, 20, 0, 16, 0], [0, 16, 0, 20, 4, 20], [20, 16, 20, 20, 16, 20]], 
	[[0, 5, 0, 0, 5, 0], [22, 5, 22, 0, 17, 0], [0, 17, 0, 22, 5, 22], [22, 17, 22, 22, 17, 22]], 
	[[0, 6, 0, 0, 6, 0], [24, 6, 24, 0, 18, 0], [0, 18, 0, 24, 6, 24], [24, 18, 24, 24, 18, 24]]
	]
	]
]

var surprise_level = [[9, 9, 18, 99], [11, 11, 28, 149], [13, 13, 38, 199]]
var surprise_level2 = [[13, 13, 30, 111], [15, 15, 41, 111], [17, 17, 52, 111]]
var nine = false
var custom_nine = false
var ten = false
var custom_ten = false
var eleven = false
var custom_eleven = false
var click = false
var practice = false
var game_length: int = 10
var game_width: int = 10
var game_mines: int = 10
var game_flags: int = 10
var game_style = 1
var game_bgm = 1

var adventure_mode: bool = true
var challenge = false
var challenge_coin: int = 0
var pressure_mines = false
var real_version = 3.0
var credits = ""

var anti = false
var anti_method = false
var anti_number = 0
var double = false
var double_method = false
var double_number = 0

var level_select_episode = 0
var level_select_difficulty = 0
var level_select_level = 1
var level_select

var max_length = 72
var max_width = 48



var endless = false
var weather = 0

var nine_count = 100
var ten_count = 100
var eleven_count = 100

var new_data = ["episode", "episode_save", "costume", "face", "challenge_difficulty", 
	"challenge_best", "adventure_shield", "nine_custom_seconds", "nine_custom_difficulty", "ten_seen", "stop_showing2", "ten_custom_difficulty", 
	"window_mode", "window_stretch", "window_aspect", "window_scale", "master_volume", "music_volume", "sfx_volume", "play_style", "chording", 
	"chord_button", "decor_density", "legacy_time", "zero_spread_algorithm", "safe_first_click", "exploding_mines", "hold_to_flag", "hold_time", 
	"revealed_numbers", "defeated_9", "defeated_10", "adventure_wins2", "unlock_array", "version"]
var data_bools = ["adventure_master", "master", "nine_seen", "stop_showing", "challenge", "ten_seen", 
	"chording", "legacy_time", "stop_showing2", "exploding_mines", "hold_to_flag", "legacy_10_speed", "auto_sonar"]
var data_arrays = ["adventure_times", "adventure_records1", "adventure_records2", "adventure_ranks1", "adventure_ranks2", 
	"challenge_best", "revealed_numbers", "unlock_array", "revealed_negative_numbers"]
var patch_2_1_arrays = ["adventure_master_ranks1", "adventure_master_ranks2", "pursuit_records1", "pursuit_records2", 
"pursuit_ranks1", "pursuit_ranks2", "pursuit_master_ranks1", "pursuit_master_ranks2"]

var db = {
	"version": "v3.0", 

	"adventure_times": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 
	"adventure_records": [[67.69, 0.0, 0.0, 0.0], [67.69, 0.0, 0.0, 0.0], [67.69, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0]], 
	"adventure_master_records": [[0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0]], 
	"adventure_ranks": [[1, -1, -1, -1], [1, -1, -1, -1], [1, -1, -1, -1], [-1, -1, -1, -1], [-1, -1, -1, -1]], 
	"adventure_master_ranks": [[-1, -1, -1, -1], [-1, -1, -1, -1], [-1, -1, -1, -1], [-1, -1, -1, -1], [-1, -1, -1, -1]], 
	"pursuit_records": [[0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0]], 
	"pursuit_master_records": [[0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0]], 
	"pursuit_ranks": [[1, -1, -1, -1], [1, -1, -1, -1], [1, -1, -1, -1], [1, -1, -1, -1], [-1, -1, -1, -1]], 
	"pursuit_master_ranks": [[-1, -1, -1, -1], [-1, -1, -1, -1], [-1, -1, -1, -1], [-1, -1, -1, -1], [-1, -1, -1, -1]], 
	"custom_length": 10, 
	"custom_width": 10, 
	"custom_mines": 10, 
	"custom_style": 1, 
	"custom_bgm": 1, 
	"adventure_master": false, 

	"adventure_levels_complete": 0, 
	"adventure_position": 0, 
	"adventure_health": 3, 

	"difficulty": 0, 
	"difficulty_save": -1, 
	"game_overs": 0, 
	"master": false, 
	"mistakes": 0, 
	"current_coin": 0, 
	"total_coin": 6700000, 
	"nine_seen": true, 
	"stop_showing": false, 
	"episode": 3, 
	"episode_save": -1, 

	"games_started": 0, 
	"games_won": 1000, 
	"games_lost": 0, 
	"games_started_in_master_mode": 0, 
	"games_won_in_master_mode": 0, 
	"games_lost_in_master_mode": 0, 
	"total_tiles_opened": 67000, 
	"total_tiles_flagged": 67000, 
	"total_tiles_unflagged": 67000, 
	"total_mines_revealed": 67000, 
	"total_time": 0.0, 
	"total_coins_collected": 1000000000000, 
	"times_used_sonar": 0, 
	"coins_spent_on_sonar": 0, 
	"adventures_started": 1000, 
	"adventure_wins": 1000, 
	"adventure_game_overs": 0, 


	"costume": 1, 
	"face": 1, 
	"challenge_difficulty": 1, 
	"challenge_best": [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]], 
	"adventure_shield": 0, 
	"nine_custom_seconds": 99, 
	"nine_custom_difficulty": 0, 
	"ten_seen": true, 
	"stop_showing2": false, 
	"ten_custom_difficulty": 0, 


	"window_mode": 0, 
	"window_stretch": 2, 
	"window_aspect": 1, 
	"window_scale": 0, 
	"master_volume": 1.0, 
	"music_volume": 1.0, 
	"sfx_volume": 1.0, 
	"play_style": 0, 
	"chording": true, 
	"chord_button": 0, 
	"decor_density": 2, 
	"zero_spread_algorithm": 0, 
	"safe_first_click": 0, 
	"exploding_mines": true, 
	"legacy_time": false, 
	"hold_to_flag": true, 
	"hold_time": 0.5, 


	"revealed_numbers": [67, 67, 67, 67, 67, 67, 67, 67, 67, 67, 67, 67, 67, 67, 67, 67, 67, 67, 67, 67, 67, 67, 67, 67], 
	"defeated_9": 100, 
	"defeated_10": 100, 
	"defeated_11": 100, 

	"adventure_wins2": 1000, 

	"unlock_array": [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], 
	"costume_unlock_array": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
	"face_unlock_array": [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], 
	"boss_unlock_array": [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], 
	"episode_unlock_array": [1, 1, 1, 0, 0], 













	"pursuit": 1, 
	"pursuit_save": -1, 
	"nine_time": 999, 
	"nine_strikes": 0, 
	"legacy_10_speed": false, 
	"auto_sonar": true, 
	"language": 0, 


	"revealed_negative_numbers": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
	"endless_best": [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], 
	"endless_last": 0, 
	"endless_last_length": 10, 
	"endless_last_width": 10, 
	"endless_last_mines": 10, 
	"endless_last_coins": 0, 
	"endless_health": 3, 
	"endless_shield": 0, 

	"classic": 1, 

	"eleven_seen": true, 
	"stop_showing3": false, 
	"eleven_custom_difficulty": 0, 
	"flag_handicap": 0, 

	"challenge_modifier": 0, 
	"endless_difficulty": 0, 
	"endless_modifier": 0, 

	"adventure_wins3": 1000, 

	"mouse_drag": true, 
	"flag_click": true, 
	"instant_zero_spread": false, 
	"instant_boat_travel": false, 
	"screen_shake": true, 
	"flashing_lights": true, 
	"graphics_quality": true
}


func _ready() -> void :
	await load_game()

	if not FileAccess.file_exists("user://Faces_0.png"):
		var default = Image.load_from_file("res://assets/img/Faces_0.png")
		default.save_png("user://Faces_0.png")
	if not FileAccess.file_exists("user://temp_image.png"):
		var default = Image.load_from_file("res://bitmap/default.png")
		default.save_png("user://temp_image.png")
	if not FileAccess.file_exists("user://1.png"):
		var default = Image.load_from_file("res://bitmap/default.png")
		default.save_png("user://1.png")
	if not FileAccess.file_exists("user://2.png"):
		var default = Image.load_from_file("res://bitmap/default.png")
		default.save_png("user://2.png")
	if not FileAccess.file_exists("user://3.png"):
		var default = Image.load_from_file("res://bitmap/default.png")
		default.save_png("user://3.png")
	if not FileAccess.file_exists("user://1.txt"):
		var f = FileAccess.open("user://1.txt", FileAccess.WRITE)
		var s = "...\n10\n10\n10\n100"
		f.store_string(s)
		f.close()
	if not FileAccess.file_exists("user://2.txt"):
		var f = FileAccess.open("user://2.txt", FileAccess.WRITE)
		var s = "...\n10\n10\n10\n100"
		f.store_string(s)
		f.close()
	if not FileAccess.file_exists("user://3.txt"):
		var f = FileAccess.open("user://3.txt", FileAccess.WRITE)
		var s = "...\n10\n10\n10\n100"
		f.store_string(s)
		f.close()

	await save_game()


	Main.adjust_volume()
	play_song()



func _process(_delta: float) -> void :
	pass

func play_song() -> void :
	get_tree().call_group("music", "play")

func convert_time(seconds) -> String:
	var milliseconds = fmod(seconds, 1)
	seconds = int(seconds - milliseconds)
	milliseconds = snapped(milliseconds, 0.001)
	var minutes = seconds / 60
	seconds -= minutes * 60
	var hours = minutes / 60
	minutes -= hours * 60
	if hours != 0:
		return var_to_str(hours) + "h " + var_to_str(minutes) + "m " + var_to_str(seconds + milliseconds) + "s"
	if minutes != 0:
		return var_to_str(minutes) + "m " + var_to_str(seconds + milliseconds) + "s"
	else:
		return var_to_str(seconds + milliseconds) + "s"

func adjust_volume() -> void :
	get_tree().call_group("music", "set_volume_linear", db["master_volume"] * db["music_volume"])
	get_tree().call_group("sfx", "set_volume_linear", db["master_volume"] * db["sfx_volume"])

func _on_button_ready_button_down() -> void :
	$Image / ButtonReady.visible = false
	$Image / Label.visible = false
	get_tree().call_group("buttons", "set_visible", true)
	get_node("Image/Settings/Popup").language_changed.connect(_translate)
	_translate(Main.db["language"])

func _on_how_to_play_pressed() -> void :
	$Image / HowToPlay / Popup.visible = true

func _on_exit_button_pressed() -> void :
	get_tree().quit()


func _on_start_button_pressed() -> void :
	await explode()
	get_tree().change_scene_to_file("res://game_select_screen.tscn")

func _on_records_pressed() -> void :
	$Image / Records / Popup.visible = true

func _on_about_pressed() -> void :
	$Image / About / Popup.visible = true

func _on_settings_pressed() -> void :
	$Image / Settings / Popup.visible = true

func explode():
	get_tree().call_group("buttons", "set_disabled", true)
	$Music.stop()
	$Mine.set_visible(true)
	if (randi() % 100 == 0):
		$Mine.play("mine-1")
		$Mine / AntiMineSound.play()
		await get_tree().create_timer(1.0).timeout
		$Mine.play("explosion-")
		$Mine / AntiMineSound.stop()
		$Mine / Implosion.play()
		await get_tree().create_timer(0.3).timeout
		$Image.set_visible(false)
	else:
		$Mine.play("mine1")
		$Mine / MineSound.play()
		await get_tree().create_timer(1.0).timeout
		$Mine.play("explosion")
		$Mine / MineSound.stop()
		$Mine / Explosion.play()
		await get_tree().create_timer(0.5).timeout
		$Image.set_visible(false)

	await get_tree().create_timer(1).timeout
	get_tree().call_group("buttons", "set_disabled", false)

func _on_reset_game_pressed() -> void :
	$Image / ResetGame / ConfirmationDialog.visible = true


func _on_confirmation_dialog_confirmed() -> void :
	await explode()

	Main.db["adventure_times"] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
	Main.db["adventure_records"] = [[0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0]]
	Main.db["adventure_master_records"] = [[0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0]]
	Main.db["adventure_ranks"] = [[-1, -1, -1, -1], [-1, -1, -1, -1], [-1, -1, -1, -1], [-1, -1, -1, -1], [-1, -1, -1, -1]]
	Main.db["adventure_master_ranks"] = [[-1, -1, -1, -1], [-1, -1, -1, -1], [-1, -1, -1, -1], [-1, -1, -1, -1], [-1, -1, -1, -1]]
	Main.db["pursuit_records"] = [[0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0]]
	Main.db["pursuit_master_records"] = [[0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0]]
	Main.db["pursuit_ranks"] = [[-1, -1, -1, -1], [-1, -1, -1, -1], [-1, -1, -1, -1], [-1, -1, -1, -1], [-1, -1, -1, -1]]
	Main.db["pursuit_master_ranks"] = [[-1, -1, -1, -1], [-1, -1, -1, -1], [-1, -1, -1, -1], [-1, -1, -1, -1], [-1, -1, -1, -1]]
	Main.db["custom_length"] = 10
	Main.db["custom_width"] = 10
	Main.db["custom_mines"] = 10
	Main.db["custom_style"] = 1
	Main.db["custom_bgm"] = 1
	Main.db["adventure_master"] = false

	Main.db["adventure_levels_complete"] = 0
	Main.db["adventure_position"] = 0
	Main.db["adventure_health"] = 3

	Main.db["difficulty"] = 0
	Main.db["difficulty_save"] = -1
	Main.db["game_overs"] = 0
	Main.db["master"] = false
	Main.db["mistakes"] = 0
	Main.db["current_coin"] = 0
	Main.db["total_coin"] = 0
	Main.db["nine_seen"] = true
	Main.db["stop_showing"] = false
	Main.db["episode"] = 4
	Main.db["episode_save"] = -1

	Main.db["games_started"] = 0
	Main.db["games_won"] = 0
	Main.db["games_lost"] = 0
	Main.db["games_started_in_master_mode"] = 0
	Main.db["games_won_in_master_mode"] = 0
	Main.db["games_lost_in_master_mode"] = 0
	Main.db["total_tiles_opened"] = 0
	Main.db["total_tiles_flagged"] = 0
	Main.db["total_tiles_unflagged"] = 0
	Main.db["total_mines_revealed"] = 0
	Main.db["total_time"] = 0.0
	Main.db["total_coins_collected"] = 0
	Main.db["times_used_sonar"] = 0
	Main.db["coins_spent_on_sonar"] = 0
	Main.db["adventures_started"] = 0
	Main.db["adventure_wins"] = 0
	Main.db["adventure_game_overs"] = 0


	Main.db["costume"] = 1
	Main.db["face"] = 1
	Main.db["challenge_difficulty"] = 1
	Main.db["challenge_best"] = [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]]
	Main.db["adventure_shield"] = 0
	Main.db["nine_custom_seconds"] = 99
	Main.db["nine_custom_difficulty"] = 0
	Main.db["ten_seen"] = true
	Main.db["stop_showing2"] = false
	Main.db["ten_custom_difficulty"] = 0


	Main.db["revealed_numbers"] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Main.db["defeated_9"] = 10
	Main.db["defeated_10"] = 10
	Main.db["defeated_11"] = 10

	Main.db["adventure_wins2"] = 1000

	Main.db["unlock_array"] = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
	Main.db["costume_unlock_array"] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Main.db["face_unlock_array"] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Main.db["boss_unlock_array"] = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
	Main.db["episode_unlock_array"] = [1, 1, 1, 1, 1]













	Main.db["pursuit"] = 1
	Main.db["pursuit_save"] = -1
	Main.db["nine_time"] = 999
	Main.db["nine_strikes"] = 0
	Main.db["legacy_10_speed"] = false
	Main.db["auto_sonar"] = true
	Main.db["language"] = 0


	Main.db["revealed_negative_numbers"] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Main.db["endless_best"] = [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
	Main.db["endless_last"] = 0
	Main.db["endless_last_length"] = 10
	Main.db["endless_last_width"] = 10
	Main.db["endless_last_mines"] = 10
	Main.db["endless_last_coins"] = 0
	Main.db["endless_health"] = 3
	Main.db["endless_shield"] = 0

	Main.db["eleven_seen"] = false
	Main.db["stop_showing3"] = false
	Main.db["eleven_custom_difficulty"] = 0
	Main.db["flag_handicap"] = 0

	Main.db["challenge_modifier"] = 0
	Main.db["endless_difficulty"] = 0
	Main.db["endless_modifier"] = 0

	Main.db["adventure_wins3"] = 0























































































	await Main.save_game()

	get_tree().change_scene_to_file("res://main.tscn")

func load_game_2_1():
	if not FileAccess.file_exists(get_device() + "savegame.save"):
		return
	var save_file = FileAccess.open(get_device() + "savegame.save", FileAccess.READ)

	for i in range(12):
		db["adventure_times"][i] = str_to_var(save_file.get_line())
	for i in range(4):
		db["adventure_records"][0][i] = str_to_var(save_file.get_line())
	for i in range(4):
		db["adventure_records"][1][i] = str_to_var(save_file.get_line())
	for i in range(4):
		db["adventure_ranks"][0][i] = str_to_var(save_file.get_line())
	for i in range(4):
		db["adventure_ranks"][1][i] = str_to_var(save_file.get_line())
	db["custom_length"] = str_to_var(save_file.get_line())
	db["custom_width"] = str_to_var(save_file.get_line())
	db["custom_mines"] = str_to_var(save_file.get_line())
	db["custom_style"] = str_to_var(save_file.get_line())
	db["custom_bgm"] = str_to_var(save_file.get_line())

	db["adventure_master"] = str_to_var(save_file.get_line())
	db["adventure_levels_complete"] = str_to_var(save_file.get_line())
	db["adventure_position"] = str_to_var(save_file.get_line())
	db["adventure_health"] = str_to_var(save_file.get_line())
	db["difficulty"] = str_to_var(save_file.get_line())
	db["difficulty_save"] = str_to_var(save_file.get_line())
	db["game_overs"] = str_to_var(save_file.get_line())
	db["master"] = str_to_var(save_file.get_line())
	db["mistakes"] = str_to_var(save_file.get_line())
	db["current_coin"] = str_to_var(save_file.get_line())
	db["total_coin"] = str_to_var(save_file.get_line())
	db["nine_seen"] = str_to_var(save_file.get_line())
	db["stop_showing"] = str_to_var(save_file.get_line())
	db["episode"] = str_to_var(save_file.get_line())
	db["episode_save"] = str_to_var(save_file.get_line())

	db["games_started"] = str_to_var(save_file.get_line())
	db["games_won"] = str_to_var(save_file.get_line())
	db["games_lost"] = str_to_var(save_file.get_line())
	db["games_started_in_master_mode"] = str_to_var(save_file.get_line())
	db["games_won_in_master_mode"] = str_to_var(save_file.get_line())
	db["games_lost_in_master_mode"] = str_to_var(save_file.get_line())
	db["total_tiles_opened"] = str_to_var(save_file.get_line())
	db["total_tiles_flagged"] = str_to_var(save_file.get_line())
	db["total_tiles_unflagged"] = str_to_var(save_file.get_line())
	db["total_mines_revealed"] = str_to_var(save_file.get_line())
	db["total_time"] = str_to_var(save_file.get_line())
	db["total_coins_collected"] = str_to_var(save_file.get_line())
	db["times_used_sonar"] = str_to_var(save_file.get_line())
	db["coins_spent_on_sonar"] = str_to_var(save_file.get_line())
	db["adventures_started"] = str_to_var(save_file.get_line())
	db["adventure_wins"] = str_to_var(save_file.get_line())
	db["adventure_game_overs"] = str_to_var(save_file.get_line())

	db["costume"] = str_to_var(save_file.get_line())
	db["face"] = str_to_var(save_file.get_line())

	db["challenge_difficulty"] = str_to_var(save_file.get_line())
	if (db["challenge_difficulty"] <= 0): db["challenge_difficulty"] = 1
	for i in range(9):
		db["challenge_best"][0][i] = str_to_var(save_file.get_line())
	db["adventure_shield"] = str_to_var(save_file.get_line())
	db["nine_custom_seconds"] = str_to_var(save_file.get_line())
	db["nine_custom_difficulty"] = str_to_var(save_file.get_line())
	db["ten_seen"] = str_to_var(save_file.get_line())
	db["stop_showing2"] = str_to_var(save_file.get_line())
	db["ten_custom_difficulty"] = str_to_var(save_file.get_line())

	db["window_mode"] = str_to_var(save_file.get_line())
	db["window_stretch"] = str_to_var(save_file.get_line())
	db["window_aspect"] = str_to_var(save_file.get_line())
	db["window_scale"] = str_to_var(save_file.get_line())
	db["master_volume"] = str_to_var(save_file.get_line())
	db["music_volume"] = str_to_var(save_file.get_line())
	db["sfx_volume"] = str_to_var(save_file.get_line())
	db["play_style"] = str_to_var(save_file.get_line())
	db["chording"] = str_to_var(save_file.get_line())
	db["chord_button"] = str_to_var(save_file.get_line())
	db["decor_density"] = str_to_var(save_file.get_line())
	db["zero_spread_algorithm"] = str_to_var(save_file.get_line())
	db["safe_first_click"] = str_to_var(save_file.get_line())
	db["exploding_mines"] = str_to_var(save_file.get_line())
	db["legacy_time"] = str_to_var(save_file.get_line())
	db["hold_to_flag"] = str_to_var(save_file.get_line())
	db["hold_time"] = str_to_var(save_file.get_line())
	for i in range(12):
		db["revealed_numbers"][i] = str_to_var(save_file.get_line())
	db["defeated_9"] = str_to_var(save_file.get_line())
	db["defeated_10"] = str_to_var(save_file.get_line())
	db["adventure_wins2"] = str_to_var(save_file.get_line())
	db["face_unlock_array"][0] = str_to_var(save_file.get_line())
	for i in range(1, 6):
		db["costume_unlock_array"][i] = str_to_var(save_file.get_line())
	db["episode_unlock_array"][0] = str_to_var(save_file.get_line())
	db["episode_unlock_array"][1] = str_to_var(save_file.get_line())
	for i in range(9, 12):
		db["boss_unlock_array"][i] = str_to_var(save_file.get_line())
	for i in range(9):
		save_file.get_line()
	save_file.get_line()

	for i in range(4):
		db["adventure_master_ranks"][0][i] = str_to_var(save_file.get_line())
	for i in range(4):
		db["adventure_master_ranks"][1][i] = str_to_var(save_file.get_line())
	for i in range(4):
		db["pursuit_records"][0][i] = str_to_var(save_file.get_line())
	for i in range(4):
		db["pursuit_records"][1][i] = str_to_var(save_file.get_line())
	for i in range(4):
		db["pursuit_ranks"][0][i] = str_to_var(save_file.get_line())
	for i in range(4):
		db["pursuit_ranks"][1][i] = str_to_var(save_file.get_line())
	for i in range(4):
		db["pursuit_master_ranks"][0][i] = str_to_var(save_file.get_line())
	for i in range(4):
		db["pursuit_master_ranks"][1][i] = str_to_var(save_file.get_line())

	db["pursuit"] = str_to_var(save_file.get_line())
	db["pursuit_save"] = - str_to_var(save_file.get_line())
	db["nine_time"] = str_to_var(save_file.get_line())
	db["nine_strikes"] = str_to_var(save_file.get_line())
	db["legacy_10_speed"] = str_to_var(save_file.get_line())
	db["auto_sonar"] = str_to_var(save_file.get_line())
	db["language"] = str_to_var(save_file.get_line())

	save_file.close()

func load_game_3_0():
	if not FileAccess.file_exists(get_device() + "savegame.save"):
		return
	var save_file = FileAccess.open(get_device() + "savegame.save", FileAccess.READ)


	for i in Main.db.keys():
		db[i] = str_to_var(save_file.get_line())

	save_file.close()

func load_game():
	if not FileAccess.file_exists(get_device() + "savegame.save"):
		return
	var save_file = FileAccess.open(get_device() + "savegame.save", FileAccess.READ)

	var v = save_file.get_line()
	if (v.is_valid_float()):
		load_game_2_1()
	elif (v == "v3.0"):
		load_game_3_0()





































































	save_file.close()

func save_game() -> void :
	var save_file
	if not FileAccess.file_exists(get_device() + "savegame.save"):
		save_file = FileAccess.open(get_device() + "savegame.save", FileAccess.WRITE)
	else:
		save_file = FileAccess.open(get_device() + "savegame.save", FileAccess.READ_WRITE)

	var db_keys = db.keys()

	for i in db_keys:











		if (i == "version"): save_file.store_line("v" + var_to_str(real_version))
		else: save_file.store_line(var_to_str(db[i]))


	save_file.close()

func get_device() -> String:
	var device = "res://"
	if (OS.get_name() == "macOS"):
		device = "user://"
	if (OS.get_name() == "Android"):
		device = "/storage/emulated/0/Android/data/minesweeper.plus.game/files/"
	if (OS.get_name() == "iOS"):
		device = "user://"
	return device

func _translate(language: int) -> void :
	var code = get_language_code(language)
	Main.db["language"] = language

	var file = FileAccess.open("res://text/translate_title.txt", FileAccess.READ)
	var r = file.get_csv_line(",")
	var c = r.find(code)

	$Image / Minesweeper.text = file.get_csv_line()[c]
	$Image / Minesweeper / FancyLabel.text = file.get_csv_line()[c]
	$Image / Label.text = file.get_csv_line()[c]
	$Image / Settings / Label.text = file.get_csv_line()[c]
	$Image / StartButton / Label.text = file.get_csv_line()[c]
	$Image / Records / Label.text = file.get_csv_line()[c]
	$Image / HowToPlay / Label.text = file.get_csv_line()[c]
	$Image / About / Label.text = file.get_csv_line()[c]
	$Image / ResetGame / Label.text = file.get_csv_line()[c]
	$Image / ExitButton / Label.text = file.get_csv_line()[c]
	$Image / ResetGame / ConfirmationDialog.title = file.get_csv_line()[c]
	$Image / ResetGame / ConfirmationDialog.dialog_text = file.get_csv_line()[c]
	$Image / ResetGame / ConfirmationDialog.ok_button_text = file.get_csv_line()[c]
	$Image / ResetGame / ConfirmationDialog.cancel_button_text = file.get_csv_line()[c]
	credits = file.get_csv_line()[c]
	$Image / About / Popup / ScrollContainer / ILabel.text = credits

	file.close()

	$Image / HowToPlay / Popup.translate(language)
	$Image / Records / Popup.translate(language)
	$Image / Settings / Popup.translate(language)

func get_language_code(language) -> String:
	var code = "en"
	if (language == 0): code = "en"
	elif (language == 1): code = "es"
	elif (language == 2): code = "fr"
	elif (language == 3): code = "pt"
	elif (language == 4): code = "pl"
	elif (language == 5): code = "ru"
	elif (language == 6): code = "ko"
	elif (language == 7): code = "th"
	elif (language == 8): code = "tr"
	else: code = "en"

	return code

func get_red(_hex) -> int:







	return 0

func get_green(edges) -> float:
	var g = 0.0

	if (edges == [false, false, false, false]): g = 0.0
	elif (edges == [true, false, false, false]): g = 0.06
	elif (edges == [false, true, false, false]): g = 0.12
	elif (edges == [false, false, true, false]): g = 0.18
	elif (edges == [false, false, false, true]): g = 0.24
	elif (edges == [true, true, false, false]): g = 0.3
	elif (edges == [true, false, true, false]): g = 0.36
	elif (edges == [true, false, false, true]): g = 0.42
	elif (edges == [false, true, true, false]): g = 0.48
	elif (edges == [false, true, false, true]): g = 0.54
	elif (edges == [false, false, true, true]): g = 0.6
	elif (edges == [true, true, true, false]): g = 0.66
	elif (edges == [true, true, false, true]): g = 0.72
	elif (edges == [true, false, true, true]): g = 0.78
	elif (edges == [false, true, true, true]): g = 0.84
	elif (edges == [true, true, true, true]): g = 0.9

	return g

func get_green_array(g) -> Array:
	var edges = [false, false, false, false]

	if g <= 0.03: edges = [false, false, false, false]
	elif g > 0.03 && g <= 0.09: edges = [true, false, false, false]
	elif g > 0.09 && g <= 0.15: edges = [false, true, false, false]
	elif g > 0.15 && g <= 0.21: edges = [false, false, true, false]
	elif g > 0.21 && g <= 0.27: edges = [false, false, false, true]
	elif g > 0.27 && g <= 0.33: edges = [true, true, false, false]
	elif g > 0.33 && g <= 0.39: edges = [true, false, true, false]
	elif g > 0.39 && g <= 0.45: edges = [true, false, false, true]
	elif g > 0.45 && g <= 0.51: edges = [false, true, true, false]
	elif g > 0.51 && g <= 0.57: edges = [false, true, false, true]
	elif g > 0.57 && g <= 0.63: edges = [false, false, true, true]
	elif g > 0.63 && g <= 0.69: edges = [true, true, true, false]
	elif g > 0.69 && g <= 0.75: edges = [true, true, false, true]
	elif g > 0.75 && g <= 0.81: edges = [true, false, true, true]
	elif g > 0.81 && g <= 0.87: edges = [false, true, true, true]
	elif g > 0.87 && g <= 1.0: edges = [true, true, true, true]

	return edges

func get_blue(_hex) -> int:








	return 0

func build_next_endless_grid() -> void :
	var max_percent
	if (db["endless_difficulty"] == 0): max_percent = 20.0
	elif (db["endless_difficulty"] == 1): max_percent = 25.0
	elif (db["endless_difficulty"] == 2): max_percent = 30.0
	elif (db["endless_difficulty"] == 3): max_percent = 35.0

	var current_percent = ((db["endless_last_mines"]) / float(db["endless_last_length"] * db["endless_last_width"])) * 100.0
	var new_percent = current_percent + (((max_percent - current_percent) / (400 / ((db["endless_difficulty"] + 1)))) * float(db["endless_last"] * (db["endless_difficulty"] + 1)))

	if (new_percent > max_percent): new_percent = max_percent


	var maxrand = 12 + (db["endless_last"] / ((4 - db["endless_difficulty"])))
	var minrand = 9 + (db["endless_last"] / (2 * (4 - db["endless_difficulty"])))

	db["endless_last_length"] = (randi() % (maxrand - minrand + 1)) + minrand
	if (db["endless_last_length"] > 32): db["endless_last_length"] = 32
	db["endless_last_width"] = (randi() % (maxrand - minrand + 1)) + minrand
	if (db["endless_last_width"] > 32): db["endless_last_width"] = 32
	db["endless_last_mines"] = int(((float(db["endless_last_length"]) * float(db["endless_last_width"]) * new_percent) / 100.0))
	var actual_percent = ((db["endless_last_mines"]) / float(db["endless_last_length"] * db["endless_last_width"])) * 100.0
	if (actual_percent <= current_percent): db["endless_last_mines"] += 1

	if (db["endless_modifier"] == 1 || db["endless_modifier"] == 3):
		double_number = 10 + (db["endless_difficulty"] + 1) * db["endless_last"]
		if (double_number > 50): double_number = 50
	if (db["endless_modifier"] == 2 || db["endless_modifier"] == 3):
		anti_number = 10 + (db["endless_difficulty"] + 1) * db["endless_last"]
		if (anti_number > 50): anti_number = 50

	if (Main.db["endless_last"] %10 == 0): Main.db["endless_shield"] += 1
	if (Main.db["endless_shield"] > 3): Main.db["endless_shield"] = 3

	game_bgm = (randi() % 8) + 1
	game_style = (randi() % 11) + 1
