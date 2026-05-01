extends PopupPanel


func _ready() -> void :
	translate(Main.db["language"])



func _process(_delta: float) -> void :
	pass


func print_data() -> void :
	$ScrollContainer / VBox / GamesStarted.text += var_to_str(Main.db["games_started"])
	$ScrollContainer / VBox / GamesWon.text += var_to_str(Main.db["games_won"])
	$ScrollContainer / VBox / GamesLost.text += var_to_str(Main.db["games_lost"])
	$ScrollContainer / VBox / GamesStartedInMasterMode.text += var_to_str(Main.db["games_started_in_master_mode"])
	$ScrollContainer / VBox / GamesWonInMasterMode.text += var_to_str(Main.db["games_won_in_master_mode"])
	$ScrollContainer / VBox / GamesLostInMasterMode.text += var_to_str(Main.db["games_lost_in_master_mode"])
	$ScrollContainer / VBox / TilesOpened.text += var_to_str(Main.db["total_tiles_opened"])
	$ScrollContainer / VBox / TilesFlagged.text += var_to_str(Main.db["total_tiles_flagged"])
	$ScrollContainer / VBox / TilesUnflagged.text += var_to_str(Main.db["total_tiles_unflagged"])
	$ScrollContainer / VBox / MinesRevealed.text += var_to_str(Main.db["total_mines_revealed"])
	$ScrollContainer / VBox / TotalTimeElapsed.text += Main.convert_time(Main.db["total_time"])
	$ScrollContainer / VBox / TotalCoinsCollected.text += var_to_str(Main.db["total_coins_collected"])
	$ScrollContainer / VBox / TimesUsedSonar.text += var_to_str(Main.db["times_used_sonar"])
	$ScrollContainer / VBox / CoinsSpentOnSonar.text += var_to_str(Main.db["coins_spent_on_sonar"])
	$ScrollContainer / VBox / AdventuresStarted.text += var_to_str(Main.db["adventures_started"])
	$ScrollContainer / VBox / AdventureGameOvers.text += var_to_str(Main.db["adventure_game_overs"])
	$ScrollContainer / VBox / Episode1Completed.text += var_to_str(Main.db["adventure_wins"])
	$ScrollContainer / VBox / Episode2Completed.text += var_to_str(Main.db["adventure_wins2"])
	$ScrollContainer / VBox / Episode3Completed.text += var_to_str(Main.db["adventure_wins3"])
	$ScrollContainer / VBox / Revealed1.text += var_to_str(Main.db["revealed_numbers"][1])
	$ScrollContainer / VBox / Revealed2.text += var_to_str(Main.db["revealed_numbers"][2])
	$ScrollContainer / VBox / Revealed3.text += var_to_str(Main.db["revealed_numbers"][3])
	$ScrollContainer / VBox / Revealed4.text += var_to_str(Main.db["revealed_numbers"][4])
	$ScrollContainer / VBox / Revealed5.text += var_to_str(Main.db["revealed_numbers"][5])
	$ScrollContainer / VBox / Revealed6.text += var_to_str(Main.db["revealed_numbers"][6])
	$ScrollContainer / VBox / Revealed7.text += var_to_str(Main.db["revealed_numbers"][7])
	$ScrollContainer / VBox / Revealed8.text += var_to_str(Main.db["revealed_numbers"][8])
	$ScrollContainer / VBox / Revealed9.text += var_to_str(Main.db["revealed_numbers"][9])
	$ScrollContainer / VBox / Revealed10.text += var_to_str(Main.db["revealed_numbers"][10])
	$ScrollContainer / VBox / Revealed11.text += var_to_str(Main.db["revealed_numbers"][11])
	$ScrollContainer / VBox / Revealed12.text += var_to_str(Main.db["revealed_numbers"][12])
	$ScrollContainer / VBox / Revealed13.text += var_to_str(Main.db["revealed_numbers"][13])
	$ScrollContainer / VBox / Revealed14.text += var_to_str(Main.db["revealed_numbers"][14])
	$ScrollContainer / VBox / Revealed15.text += var_to_str(Main.db["revealed_numbers"][15])
	$ScrollContainer / VBox / Revealed16.text += var_to_str(Main.db["revealed_numbers"][16])
	$ScrollContainer / VBox / Revealed0.text += var_to_str(Main.db["revealed_negative_numbers"][0])
	$ScrollContainer / VBox / Revealed_1.text += var_to_str(Main.db["revealed_negative_numbers"][1])
	$ScrollContainer / VBox / Revealed_2.text += var_to_str(Main.db["revealed_negative_numbers"][2])
	$ScrollContainer / VBox / Revealed_3.text += var_to_str(Main.db["revealed_negative_numbers"][3])
	$ScrollContainer / VBox / Revealed_4.text += var_to_str(Main.db["revealed_negative_numbers"][4])
	$ScrollContainer / VBox / Revealed_5.text += var_to_str(Main.db["revealed_negative_numbers"][5])
	$ScrollContainer / VBox / Revealed_6.text += var_to_str(Main.db["revealed_negative_numbers"][6])
	$ScrollContainer / VBox / Revealed_7.text += var_to_str(Main.db["revealed_negative_numbers"][7])
	$ScrollContainer / VBox / Revealed_8.text += var_to_str(Main.db["revealed_negative_numbers"][8])
	$ScrollContainer / VBox / Revealed_9.text += var_to_str(Main.db["revealed_negative_numbers"][9])
	$ScrollContainer / VBox / Revealed_10.text += var_to_str(Main.db["revealed_negative_numbers"][10])
	$ScrollContainer / VBox / Revealed_11.text += var_to_str(Main.db["revealed_negative_numbers"][11])
	$ScrollContainer / VBox / Revealed_12.text += var_to_str(Main.db["revealed_negative_numbers"][12])
	$ScrollContainer / VBox / Revealed_13.text += var_to_str(Main.db["revealed_negative_numbers"][13])
	$ScrollContainer / VBox / Revealed_14.text += var_to_str(Main.db["revealed_negative_numbers"][14])
	$ScrollContainer / VBox / Revealed_15.text += var_to_str(Main.db["revealed_negative_numbers"][15])
	$ScrollContainer / VBox / Revealed_16.text += var_to_str(Main.db["revealed_negative_numbers"][16])
	if (Main.db["nine_seen"]):
		$ScrollContainer / VBox / Defeated9.text += var_to_str(Main.db["defeated_9"])
	else:
		$ScrollContainer / VBox / Defeated9.text = "???"
	if (Main.db["ten_seen"]):
		$ScrollContainer / VBox / Defeated10.text += var_to_str(Main.db["defeated_10"])
	else:
		$ScrollContainer / VBox / Defeated10.text = "???"
	if (Main.db["eleven_seen"]):
		$ScrollContainer / VBox / Defeated11.text += var_to_str(Main.db["defeated_11"])
	else:
		$ScrollContainer / VBox / Defeated11.text = "???"

func translate(language) -> void :
	var code = Main.get_language_code(language)

	var file = FileAccess.open("res://text/translate_statistics.txt", FileAccess.READ)
	var r = file.get_csv_line(",")
	var c = r.find(code)
	var postfix = ": "

	$ScrollContainer / VBox / GamesStarted.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / GamesWon.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / GamesLost.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / GamesStartedInMasterMode.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / GamesWonInMasterMode.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / GamesLostInMasterMode.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / TilesOpened.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / TilesFlagged.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / TilesUnflagged.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / MinesRevealed.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / TotalTimeElapsed.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / TotalCoinsCollected.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / TimesUsedSonar.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / CoinsSpentOnSonar.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / AdventuresStarted.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / AdventureGameOvers.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Episode1Completed.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Episode2Completed.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Episode3Completed.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed1.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed2.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed3.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed4.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed5.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed6.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed7.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed8.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed9.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed10.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed11.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed12.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed13.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed14.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed15.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed16.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed0.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed_1.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed_2.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed_3.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed_4.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed_5.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed_6.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed_7.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed_8.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed_9.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed_10.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed_11.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed_12.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed_13.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed_14.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed_15.text = file.get_csv_line()[c] + postfix
	$ScrollContainer / VBox / Revealed_16.text = file.get_csv_line()[c] + postfix
	if (Main.db["nine_seen"]):
		$ScrollContainer / VBox / Defeated9.text = file.get_csv_line()[c] + postfix
	if (Main.db["ten_seen"]):
		$ScrollContainer / VBox / Defeated10.text = file.get_csv_line()[c] + postfix
	if (Main.db["eleven_seen"]):
		$ScrollContainer / VBox / Defeated11.text = file.get_csv_line()[c] + postfix

	file.close()

	print_data()
