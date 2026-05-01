extends Sprite2D

var fade = false
var pos
var s = 0.05

func _ready() -> void :
	pos = position

func _process(delta: float) -> void :
	$Wheel.rotation += 0.01
	if fade:
		z_index -= 1
		modulate -= Color(0.01, 0.01, 0.01, 0.01)
		position[0] += 1
		if (modulate[3] <= 0):
			queue_free()
	else:
		position[1] = pos[1] + (sin(s) * 9)
		s += 0.05
