extends Button

signal edge_check
var off_color = Color(0, 0, 0, 255)
var on_color = Color(0, 255, 0, 255)
var rc = Vector2(0, 0)
var on = false


func _ready() -> void :
	pass

func _process(_delta: float) -> void :
	pass

func switch() -> void :
	if (on):
		on = false
		$ColorRect.color = off_color
	else:
		on = true
		$ColorRect.color = on_color

func _on_pressed() -> void :
	switch()
	edge_check.emit(rc)

func _on_mouse_entered() -> void :
	scale *= 2


func _on_mouse_exited() -> void :
	scale /= 2

func expand(length) -> void :
	var s = length / size[0]
	scale = Vector2(s, s)
