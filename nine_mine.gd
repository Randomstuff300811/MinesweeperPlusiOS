extends Button

signal movement_decision
signal nine_pressed

@export var delta_multiplier = 0
var wait_time_multiplier
var mine_number = 0



func _ready() -> void :
	if (Main.nine_count > 0 && !Main.adventure_mode):
		if (Main.db["nine_custom_difficulty"] == 0): wait_time_multiplier = 0.4
		elif (Main.db["nine_custom_difficulty"] == 1): wait_time_multiplier = 0.3
		elif (Main.db["nine_custom_difficulty"] == 2): wait_time_multiplier = 0.2
		else: wait_time_multiplier = 0.1
		delta_multiplier = 1.1
	else:
		if (Main.db["difficulty"] == 0): wait_time_multiplier = 0.4
		elif (Main.db["difficulty"] == 1): wait_time_multiplier = 0.3
		elif (Main.db["difficulty"] == 2): wait_time_multiplier = 0.2
		else: wait_time_multiplier = 0.1


func _process(delta: float) -> void :
	$Body / Spikes.rotation += (delta * delta_multiplier)

func _on_pressed() -> void :
	if ( !Main.nine):
		nine_pressed.emit(true, 0.1)
	else:
		nine_pressed.emit(true, 3)

func shrink(x) -> void :
	set_custom_minimum_size(Vector2(x * size.x, x * size.y))
	set_size(Vector2(x * size.x, x * size.y))
	$Body.set_scale(Vector2(x * $Body.scale.x, x * $Body.scale.y))
	$Body.set_position(Vector2(x * $Body.position.x, x * $Body.position.y))


func _on_move_timer_timeout() -> void :
	movement_decision.emit(mine_number, (randi() % 4) + 1, -1)

func set_wait_time(units) -> void :
	$MoveTimer.set_wait_time(units * wait_time_multiplier)
