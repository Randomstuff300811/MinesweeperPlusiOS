extends ColorRect



func _ready() -> void :
	pass



func _process(delta: float) -> void :
	position -= Vector2(300 * delta, 300 * delta)
	size += Vector2(600 * delta, 600 * delta)
	modulate -= Color(0, 0, 0, delta)
	if (modulate[3] <= 0):
		queue_free()
