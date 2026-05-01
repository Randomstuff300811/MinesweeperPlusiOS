extends ColorRect

signal held_down
signal mirror_coords
signal switch_correspondent

var off_color = Color(0, 0, 0, 255)
var on_color = Color(0, 255, 0, 255)
var rce = Vector3i(0, 0, 0)
var edge_rc = Vector2i(0, 0)
var on = false
var hold = false
var mirror = false
var draw_me = true

func _ready() -> void :
	pass

func _process(_delta: float) -> void :
	pass

func switch() -> void :
	if (on):
		on = false
		color = off_color
	else:
		on = true
		color = on_color
	switch_correspondent.emit(rce, on)


func _on_button_button_down() -> void :
	switch()
	held_down.emit(true)

	if (mirror):
		mirror_coords.emit(edge_rc)

func _on_button_button_up() -> void :
	held_down.emit(false)

func drawing(yes_or_no) -> void :
	hold = yes_or_no

func set_mirror(yes_or_no) -> void :
	mirror = yes_or_no

func _on_button_mouse_entered() -> void :
	if (hold):
		switch()
		if (mirror):
			mirror_coords.emit(edge_rc)

func reset() -> void :
	on = false
	color = off_color

func turn_off(true_or_false) -> void :
	set_visible( !true_or_false)
	$Button.set_disabled(true_or_false)
