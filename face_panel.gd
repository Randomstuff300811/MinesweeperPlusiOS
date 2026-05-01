extends Sprite2D

signal face_press
signal reset
signal radar


func _ready() -> void :






    if (Main.db["master"]):
        $Radar.visible = false
        $HealthGauge.visible = false



    if (Main.adventure_mode):
        $Radar / CoinLabel.text = var_to_str(Main.db["current_coin"])
    else:
        if (str_to_var($Radar / CoinLabel.text) > 9999):
            $Radar / CoinLabel.text = "9999"
        else:
            $Radar / CoinLabel.text = var_to_str(Main.db["total_coin"])


func set_percentage(game_squares, mines):
    $HealthGauge / MinePercentLabel.text += var_to_str((float(mines) / float(game_squares)) * 100)



func _process(_delta: float) -> void :
    if (Input.is_action_just_pressed("sonar") && !Main.db["master"]):
        if ($Radar / RadarButton.disabled == false):
            _on_radar_button_toggled( !$Radar / RadarButton.button_pressed)


func _on_face_button_down() -> void :
    face_press.emit(true)


func _on_face_button_up() -> void :
    face_press.emit(false)




func _on_face_button_toggled(_toggled_on: bool) -> void :
    reset.emit()


func _on_radar_button_toggled(_toggled_on: bool) -> void :
    $Click.play()
    $Radar / RadarButton / OffOn.frame = ($Radar / RadarButton / OffOn.frame + 1) % 2
    if ($Radar / RadarButton / OffOn.frame == 0):
        $Radar.play("off")
        radar.emit(0)
    else:
        $Radar.play("on")
        radar.emit(2)


func _on_timer_radar_timeout() -> void :
    $Radar.frame = randi() % 8

func _on_timer_gauge_timeout() -> void :
    $HealthGauge.frame = randi() % 4
