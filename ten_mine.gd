extends RigidBody2D

signal ran_out_of_time
signal bounced

var v = Vector2(0, 0)
var direction = randf_range( - PI / 4, PI / 4)
var time = 1.0
var piston_time = 0
var piston_frequency = 0.25
var piston_goal = 0
var beep = false
var go = false
var dial = false
var dial_time = 1.0
var acceleration
var ten_strikes = 0


func _ready() -> void :
	if (Main.ten_count > 0 && Main.adventure_mode && !Main.ten):
		v.x += Main.db["nine_time"]
		ten_strikes = Main.db["nine_strikes"]
		for i in range(ten_strikes):
			reduce_time()
			ten_strikes -= 1
	set_linear_velocity(v.rotated(direction))

	if (Main.ten_count > 0 && !Main.adventure_mode):
		if (Main.db["ten_custom_difficulty"] == 0): acceleration = 10
		elif (Main.db["ten_custom_difficulty"] == 1): acceleration = 20
		elif (Main.db["ten_custom_difficulty"] == 2): acceleration = 30
		else: acceleration = 40
	else:
		if (Main.db["difficulty"] == 0): acceleration = 10
		elif (Main.db["difficulty"] == 1): acceleration = 20
		elif (Main.db["difficulty"] == 2): acceleration = 30
		else: acceleration = 40

	if (Main.db["legacy_10_speed"]):
		acceleration += 20


func _process(delta: float) -> void :
	if go:
		piston_time += delta
		if (dial): $Button / MineBody / Dial.rotation += ((delta * 2 * PI) / dial_time)
		if (position.x - $Button.size.x / 2 < 0):
			bounce_pi()
			position.x = $Button.size.x / 2
		if (position.y - $Button.size.y / 2 < 0):
			bounce()
			position.y = $Button.size.y / 2
		if (position.x + $Button.size.x / 2 > 1152):
			bounce_pi()
			position.x = 1152 - $Button.size.x / 2
		if (position.y + $Button.size.y / 2 > 960):
			bounce()
			position.y = 960 - $Button.size.y / 2

	if (piston_time > piston_frequency && piston_goal == 0):
		if (beep): $Beep.play()
		piston_time = 0
		piston_goal = 1
		piston1()
	elif (piston_time > piston_frequency && piston_goal == 1):
		piston_time = 0
		piston_goal = 2
		piston2()
	elif (piston_time > piston_frequency && piston_goal == 2):
		piston_time = 0
		piston_goal = 3
		piston3()
	elif (piston_time > piston_frequency && piston_goal == 3):
		piston_time = 0
		piston_goal = 0
		piston2()

func piston1() -> void :
	$Button / Piston1.scale[1] = 0.55
	$Button / Piston2.scale[1] = 0.45
	$Button / Piston3.scale[1] = 0.55
	$Button / Piston4.scale[1] = 0.45
	$Button / Piston5.scale[1] = 0.55
func piston2() -> void :
	$Button / Piston1.scale[1] = 0.5
	$Button / Piston2.scale[1] = 0.5
	$Button / Piston3.scale[1] = 0.5
	$Button / Piston4.scale[1] = 0.5
	$Button / Piston5.scale[1] = 0.5
func piston3() -> void :
	$Button / Piston1.scale[1] = 0.45
	$Button / Piston2.scale[1] = 0.55
	$Button / Piston3.scale[1] = 0.45
	$Button / Piston4.scale[1] = 0.55
	$Button / Piston5.scale[1] = 0.45

func get_direction() -> float:
	return direction

func _on_button_pressed() -> void :
	$Reset.play()
	v.x += acceleration
	$Button / MineBody / Dial.rotation = 0
	$Button / Light.color = Color(1, 1, 1, 1)
	direction = randf_range(0, 2 * PI)
	set_linear_velocity(v.rotated(direction))
	$Button / MineBody / Number.frame = 10
	piston_frequency = 0.25
	beep = false
	$Timer.stop()
	$Timer.start()


func _on_timer_timeout() -> void :
	$Button / MineBody / Number.frame -= 1
	$Button / Light.color -= Color(0, 0.1, 0.1, 0)
	if ($Button / MineBody / Number.frame <= 4):
		piston_frequency /= 2
		beep = true
	if ($Button / MineBody / Number.frame == 0):
		beep = false
		ran_out_of_time.emit(false)

func reduce_time() -> void :
	if ( !Main.db["master"]):
		if (Main.db["adventure_shield"] <= 0 || ten_strikes > 0):
			if (Main.db["pursuit"] != 0):
				if ($Timer.wait_time > 0.1): $Timer.wait_time -= 0.1
				if (dial_time > 0.1): dial_time -= 0.1
			else:
				if ($Timer.wait_time > 0.1): $Timer.wait_time -= 0.05
				if (dial_time > 0.1): dial_time -= 0.05
	else:
		$Timer.wait_time = 0.1
		dial_time = 0.1

func reset_pistons() -> void :
	$Button / MineBody.rotation = 0
	$Button / Piston1.position = Vector2(48, 48)
	$Button / Piston2.position = Vector2(48, 48)
	$Button / Piston3.position = Vector2(48, 48)
	$Button / Piston4.position = Vector2(48, 48)
	$Button / Piston5.position = Vector2(48, 48)
	$Button / Piston1.rotation_degrees = 0.0
	$Button / Piston2.rotation_degrees = 36.0
	$Button / Piston3.rotation_degrees = 72.0
	$Button / Piston4.rotation_degrees = 108.0
	$Button / Piston5.rotation_degrees = 144.0

func stop() -> void :
	dial = false
	go = false
	get_node("Timer").stop()
	set_linear_velocity(Vector2(0, 0))
	get_node("Button").set_disabled(true)
	beep = false

func bounce() -> void :
	$Bounce.play()
	bounced.emit(3, 0.1)
	direction = - direction
	set_linear_velocity(v.rotated(direction))

func bounce_pi() -> void :
	$Bounce.play()
	bounced.emit(3, 0.1)
	direction = - (PI + direction)
	set_linear_velocity(v.rotated(direction))

func _on_body_shape_entered(_body_rid: RID, body: Node, body_shape_index: int, _local_shape_index: int) -> void :
	if go:


		set_linear_velocity(v.rotated(body.get_direction()))
		$Bounce.play()
