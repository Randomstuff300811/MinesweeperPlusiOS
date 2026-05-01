extends AcceptDialog



func _ready() -> void :
	translate(Main.db["language"])

	if Main.nine:
		$Control.visible = true
	elif Main.ten:
		$Control2.visible = true
	elif Main.eleven:
		$Control3.visible = true


func _process(delta: float) -> void :
	pass


func _on_check_box_toggled(toggled_on: bool) -> void :
	if Main.nine:
		Main.db["stop_showing"] = $Control / CheckBox.is_pressed()
	elif Main.ten:
		Main.db["stop_showing2"] = $Control2 / CheckBox.is_pressed()
	elif (Main.eleven):
		Main.db["stop_showing3"] = $Control3 / CheckBox.is_pressed()


func translate(language) -> void :
	var code = Main.get_language_code(language)

	var file = FileAccess.open("res://text/translate_warning.txt", FileAccess.READ)
	var r = file.get_csv_line(",")
	var c = r.find(code)

	$Control / Label.text = file.get_csv_line(",")[c]
	$Control2 / Label.text = file.get_csv_line(",")[c]
	file.get_csv_line(",")
	ok_button_text = file.get_csv_line(",")[c]
	var s = file.get_csv_line(",")[c]
	$Control / CheckBox.text = s
	$Control2 / CheckBox.text = s
	file.close()
