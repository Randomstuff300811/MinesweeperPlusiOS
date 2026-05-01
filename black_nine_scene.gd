extends Control

@export var after_image: PackedScene
var time = 0.2
var last_time = 0

func _ready() -> void :
	pass

func _process(delta: float) -> void :
	last_time += delta
	if (last_time >= time):
		last_time = 0
		var image = after_image.instantiate()
		image.position = $BlackNine.position
		image.fade = true
		image.get_node("Wheel").rotation = $BlackNine / Wheel.rotation
		add_child(image)
