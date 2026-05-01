extends Control

@export var icon: PackedScene
signal zap
signal flag
signal next_move
signal barrage

var shrink_save
var number = 0
var electricity = false
var okay_to_click = false
var tread_timer = 0
var open_close = true
var ro: float = 0
var current_ro: float
var ac = 0
var vis = -1
var slowing_down = false
var decision = false
var good_click = false

var start = false

var barrage_flags = 1
var flags_left = 0
var barrage_time = false
var barrage_now = false
var flag_or_zap
var hidden_teslas = true
var speed
var zap_likelihood = 3

func _ready() -> void :
	if (Main.adventure_mode):
		if (Main.db["difficulty"] == 0):
			speed = 0.75
		elif (Main.db["difficulty"] == 1):
			speed = 1
		elif (Main.db["difficulty"] == 2):
			speed = 1.25
		else:
			speed = 1.5
	else:
		if (Main.db["eleven_custom_difficulty"] == 0):
			speed = 0.75
		elif (Main.db["eleven_custom_difficulty"] == 1):
			speed = 1
		elif (Main.db["eleven_custom_difficulty"] == 2):
			speed = 1.25
		else:
			speed = 1.5

	if (Main.practice || (Main.db["pursuit"] == 0 && Main.adventure_mode)):
		zap_likelihood = 2


	if ( !Main.eleven && Main.adventure_mode):
		for i in range(Main.db["nine_strikes"]):
			barrage_flags += 2



























func _process(delta: float) -> void :
	ro += ac
	rotation_degrees += ro

	if ( !barrage_now):
		if (start):
			if (vis == 0):
				modulate[3] -= (delta * speed)
				if (modulate[3] <= 0):
					modulate[3] = 0
					vis = -1
			elif (vis == 1):
				if (modulate[3] == 0):
					set_visible(true)
				modulate[3] += (delta * speed)
				if (modulate[3] >= 1):
					modulate[3] = 1
					vis = -1

			if (vis == -1):
				if (modulate[3] <= 0):
					ac = 0
					set_visible(false)
					$WaitTimer.start()
				else:
					decision = true
				vis = -2

			if (slowing_down):
				if (ro > 0):
					ro = float(current_ro * (1 - modulate[3]))
					if (ro <= 0):
						slowing_down = false
						ro = 0
				elif (ro < 0):
					ro = float(current_ro * (1 - modulate[3]))
					if (ro >= 0):
						slowing_down = false
						ro = 0

			if (decision):
				decision = false
				slowing_down = false
				vis = -2
				$Button1.set_disabled(true)
				$Button2.set_disabled(true)
				if (good_click == true):
					ro = 0
					modulate[3] = 1
					if (okay_to_click && start):
						spin_out()
					else:
						zap.emit(number)
				elif (good_click == false):
					if (okay_to_click):
						flag.emit(number)
					else:
						modulate[3] = 1
						ro = 0
						if (start): spin_out()
				okay_to_click = false
				good_click = false

			if (barrage_time && visible == false):
					barrage_now = true
					$WaitTimer.paused = true
					barrage.emit(number)


	tread_timer += 1
	if (tread_timer == 10):
		$Button1 / ElevenLeft / TreadsLeft.frame = 1
		$Button2 / ElevenRight / TreadsRight.frame = 3
	if (tread_timer == 20):
		$Button1 / ElevenLeft / TreadsLeft.frame = 0
		$Button2 / ElevenRight / TreadsRight.frame = 2
		tread_timer = 0


func open(quick) -> void :
	if ( !quick):
		if (start): $Open.play()
		$Button1.position[0] = -48
		$Button2.position[0] = 0
		var goal = 48
		var distance = 5
		while ($Button2.position[0] < goal && start):
			$Button1.position[0] -= distance
			$Button2.position[0] += distance
			distance *= 0.9
			await get_tree().create_timer(0.01).timeout
	$Button1.position[0] = -96
	$Button2.position[0] = 48

func slow_open() -> void :
	$Button1.position[0] = -48
	$Button2.position[0] = 0
	var goal = 8
	var distance = 1
	$Pressure.play()
	while ($Button2.position[0] < goal):
		$Button1.position[0] -= distance
		$Button2.position[0] += distance
		await get_tree().create_timer(0.02).timeout
	await get_tree().create_timer(1).timeout

	goal = 48
	distance = 1
	$Open.play()
	while ($Button2.position[0] < goal):
		$Button1.position[0] -= distance
		$Button2.position[0] += distance
		await get_tree().create_timer(0.01).timeout
	$Button1.position[0] = -96
	$Button2.position[0] = 48

func close(quick) -> void :
	if ( !quick):
		$Button1.position[0] = -96
		$Button2.position[0] = 48
		var goal = 0
		var distance = 1
		while ($Button2.position[0] > goal && start):
			$Button1.position[0] += distance
			$Button2.position[0] -= distance
			distance /= 0.9
			await get_tree().create_timer(0.01).timeout
	$Open.stop()
	if ( !quick && start): $Close.play()
	$Button1.position[0] = -48
	$Button2.position[0] = 0

func tesla_on() -> void :
	hidden_teslas = false
	$Button1 / ElevenLeft / LaserControl / HalfLaser.position[1] = -48
	$Button1 / ElevenLeft / LaserControl2 / Laser.position[1] = -48
	$Button1 / ElevenLeft / LaserControl3 / Laser.position[1] = -48
	$Button1 / ElevenLeft / LaserControl4 / Laser.position[1] = -48
	$Button1 / ElevenLeft / LaserControl5 / Laser.position[1] = -48
	$Button1 / ElevenLeft / LaserControl6 / Laser.position[1] = -48
	$Button2 / ElevenRight / LaserControl / HalfLaser.position[1] = -48
	$Button2 / ElevenRight / LaserControl2 / Laser.position[1] = -48
	$Button2 / ElevenRight / LaserControl3 / Laser.position[1] = -48
	$Button2 / ElevenRight / LaserControl4 / Laser.position[1] = -48
	$Button2 / ElevenRight / LaserControl5 / Laser.position[1] = -48
	$Button2 / ElevenRight / LaserControl6 / Laser.position[1] = -48

func tesla_off() -> void :
	hidden_teslas = true
	$Button1 / ElevenLeft / LaserControl / HalfLaser.position[1] = 0
	$Button1 / ElevenLeft / LaserControl2 / Laser.position[1] = 0
	$Button1 / ElevenLeft / LaserControl3 / Laser.position[1] = 0
	$Button1 / ElevenLeft / LaserControl4 / Laser.position[1] = 0
	$Button1 / ElevenLeft / LaserControl5 / Laser.position[1] = 0
	$Button1 / ElevenLeft / LaserControl6 / Laser.position[1] = 0
	$Button2 / ElevenRight / LaserControl / HalfLaser.position[1] = 0
	$Button2 / ElevenRight / LaserControl2 / Laser.position[1] = 0
	$Button2 / ElevenRight / LaserControl3 / Laser.position[1] = 0
	$Button2 / ElevenRight / LaserControl4 / Laser.position[1] = 0
	$Button2 / ElevenRight / LaserControl5 / Laser.position[1] = 0
	$Button2 / ElevenRight / LaserControl6 / Laser.position[1] = 0

func reveal_teslas(skip) -> void :
	var okay_to_click = false
	var goal = 48
	var distance = 0
	var step = 2
	tesla_off()
	while (distance < goal):
		$Button1 / ElevenLeft / LaserControl / HalfLaser.position[1] -= step
		$Button1 / ElevenLeft / LaserControl2 / Laser.position[1] -= step
		$Button1 / ElevenLeft / LaserControl3 / Laser.position[1] -= step
		$Button1 / ElevenLeft / LaserControl4 / Laser.position[1] -= step
		$Button1 / ElevenLeft / LaserControl5 / Laser.position[1] -= step
		$Button1 / ElevenLeft / LaserControl6 / Laser.position[1] -= step
		$Button2 / ElevenRight / LaserControl / HalfLaser.position[1] -= step
		$Button2 / ElevenRight / LaserControl2 / Laser.position[1] -= step
		$Button2 / ElevenRight / LaserControl3 / Laser.position[1] -= step
		$Button2 / ElevenRight / LaserControl4 / Laser.position[1] -= step
		$Button2 / ElevenRight / LaserControl5 / Laser.position[1] -= step
		$Button2 / ElevenRight / LaserControl6 / Laser.position[1] -= step
		distance += step
		if ( !skip): await get_tree().create_timer(get_process_delta_time()).timeout
	tesla_on()

func hide_teslas(skip) -> void :
	var okay_to_click = true
	var goal = 48
	var distance = 0
	var step = 2
	tesla_on()
	while (distance < goal):
		$Button1 / ElevenLeft / LaserControl / HalfLaser.position[1] += step
		$Button1 / ElevenLeft / LaserControl2 / Laser.position[1] += step
		$Button1 / ElevenLeft / LaserControl3 / Laser.position[1] += step
		$Button1 / ElevenLeft / LaserControl4 / Laser.position[1] += step
		$Button1 / ElevenLeft / LaserControl5 / Laser.position[1] += step
		$Button1 / ElevenLeft / LaserControl6 / Laser.position[1] += step
		$Button2 / ElevenRight / LaserControl / HalfLaser.position[1] += step
		$Button2 / ElevenRight / LaserControl2 / Laser.position[1] += step
		$Button2 / ElevenRight / LaserControl3 / Laser.position[1] += step
		$Button2 / ElevenRight / LaserControl4 / Laser.position[1] += step
		$Button2 / ElevenRight / LaserControl5 / Laser.position[1] += step
		$Button2 / ElevenRight / LaserControl6 / Laser.position[1] += step
		distance += step
		if ( !skip): await get_tree().create_timer(get_process_delta_time()).timeout
	tesla_off()

func electricity_on() -> void :
	$Zap.play()
	electricity = true
	$Electricity.set_visible(true)

func electricity_off() -> void :
	$Zap.stop()
	electricity = false
	$Electricity.set_visible(false)

func turn_invisible(quick_factor) -> void :
	vis = 0







func turn_visible(quick_factor) -> void :
	vis = 1







func start_spinning(quick_factor) -> void :
	ac = ((randf() * 4) - 2) * speed
	slowing_down = false






func stop_spinning(quick_factor) -> void :
	current_ro = ro
	ac = 0
	slowing_down = true










func _on_button_down() -> void :
	if (start):
		if (okay_to_click):
			$Bonk.play()
		good_click = true
		decision = true
	else:

		zap.emit(number)


func spin_out() -> void :
	$Button1.set_disabled(true)
	$Button2.set_disabled(true)
	if ( !hidden_teslas):
		hide_teslas(false)
	start_spinning(speed)
	turn_invisible(speed)
	$WaitTimer.wait_time = randf_range(1.0 / speed, 2.0 / speed)
	good_click = false


func barrage_open():
	$Teleport.play()
	ro = 0
	rotation_degrees = randi() % 360
	close(true)
	set_visible(true)
	modulate[3] = 1
	var mod = 200
	while ($Button2.position[0] < 100 && barrage_now):
		modulate[3] -= get_process_delta_time() * 2
		$Button1.position[0] -= get_process_delta_time() * mod
		$Button2.position[0] += get_process_delta_time() * mod
		mod -= 2
		await get_tree().create_timer(get_process_delta_time()).timeout
	close(true)
	if (barrage_now):
		modulate[3] = 0
		set_visible(false)

func vanish():
	modulate[3] = 1
	while (modulate[3] > 0):
		modulate[3] -= get_process_delta_time()
		await get_tree().create_timer(get_process_delta_time()).timeout
	modulate[3] = 0
	set_visible(false)

func appear():
	set_visible(true)
	modulate[3] = 0
	while (modulate[3] < 1):
		modulate[3] += get_process_delta_time()
		await get_tree().create_timer(get_process_delta_time()).timeout
	modulate[3] = 1

func stop():
	start = false
	barrage_time = false
	barrage_now = false
	ro = 50
	ro = 0
	rotation = 0
	ac = 0
	tesla_off()
	tesla_on()
	$WaitTimer.stop()
	electricity_off()
	open(true)
	close(true)
	$Button1.set_disabled(true)
	$Button2.set_disabled(true)
	modulate = Color(0, 0, 0, 0)
	modulate = Color(1, 1, 1, 1)
	set_visible(true)

func _on_wait_timer_timeout() -> void :
	flag_or_zap = randi() % zap_likelihood
	next_move.emit(number, flag_or_zap)

func shrink(x) -> void :
	shrink_save = x * scale.x


	set_scale(Vector2(x * scale.x, x * scale.y))


func malfunction() -> void :
	$Malfunction.play()

	for i in range(100):
		if (randi() % 2 == 1): tesla_on()
		else: tesla_off()
		if (randi() % 2 == 1): rotation_degrees = randi() % 360
		await get_tree().create_timer(get_process_delta_time()).timeout

	$Malfunction.stop()
	$Break.play()
	rotation = 0
	$Button1.position[0] = -48
	$Button2.position[0] = 0
	var goal = 2000
	var distance = 20
	while ($Button2.position[0] < goal):
		$Button1.position[0] -= distance
		$Button2.position[0] += distance
		await get_tree().create_timer(get_process_delta_time()).timeout
	set_visible(false)

func unmalfunction() -> void :
	set_visible(true)
	rotation = 0
	$Button1.position[0] = -2048
	$Button2.position[0] = 2000
	var goal = 0
	var distance = 20
	while ($Button2.position[0] > goal):
		$Button1.position[0] += distance
		$Button2.position[0] -= distance
		await get_tree().create_timer(get_process_delta_time()).timeout
	$Close.play()

func superbomb() -> void :
	var mine
	for i in range(5):
		mine = icon.instantiate()
		get_node("Button1/ElevenLeft/LaserControl" + var_to_str(i + 2)).add_child(mine)
		mine.rotation_degrees = 360 - get_node("Button1/ElevenLeft/LaserControl" + var_to_str(i + 2)).rotation_degrees
		mine.add_to_group("eleven_mines")
		mine.play("mine1")
	for i in range(5):
		mine = icon.instantiate()
		get_node("Button2/ElevenRight/LaserControl" + var_to_str(i + 2)).add_child(mine)
		mine.rotation_degrees = 360 - get_node("Button2/ElevenRight/LaserControl" + var_to_str(i + 2)).rotation_degrees
		mine.add_to_group("eleven_mines")
		mine.play("mine1")
	mine = icon.instantiate()
	get_node("Button1/ElevenLeft/LaserControl").add_child(mine)
	mine.rotation_degrees = 360 - get_node("Button1/ElevenLeft/LaserControl").rotation_degrees
	mine.add_to_group("eleven_mines")
	mine.play("mine1")
	var mine_pos = 100
	$Pressure.play()
	for i in range(2, mine_pos, 2):
		get_tree().call_group("eleven_mines", "set_position", Vector2(0, i))
		get_tree().call_group("eleven_mines", "set_scale", Vector2(1.0 + i / 50.0, 1 + i / 50.0))
		await get_tree().create_timer(get_process_delta_time()).timeout
	get_tree().call_group("eleven_mines", "play", "explosion")
	$Explosion.play()
	for i in range(mine_pos, mine_pos * 2, 2):
		get_tree().call_group("eleven_mines", "set_position", Vector2(0, i))
		get_tree().call_group("eleven_mines", "set_scale", Vector2(1.0 + i / 50.0, 1.0 + i / 50.0))
		await get_tree().create_timer(get_process_delta_time()).timeout
	get_tree().call_group("eleven_mines", "queue_free")
