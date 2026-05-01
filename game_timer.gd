extends Sprite2D

signal nine_timeout

var seconds = 0
var nine_seconds
var milliseconds = 0.0
var time_decrease = 0.2


func _ready() -> void :
    if (Main.nine):
        if (Main.db["episode"] == 1 || (Main.level_select && Main.level_select_episode == 0)):
            if (Main.db["legacy_time"]):
                seconds = 99
            else:
                if (Main.db["difficulty"] == 0):
                    seconds = 199
                elif (Main.db["difficulty"] == 1):
                    seconds = 179
                elif (Main.db["difficulty"] == 2):
                    seconds = 149
                elif (Main.db["difficulty"] == 3):
                    seconds = 119
        elif (Main.db["episode"] == 2 || (Main.level_select && Main.level_select_episode == 1)):
            if (Main.db["difficulty"] == 0):
                    seconds = 249
            elif (Main.db["difficulty"] == 1):
                    seconds = 219
            elif (Main.db["difficulty"] == 2):
                    seconds = 189
            elif (Main.db["difficulty"] == 3):
                    seconds = 149
        elif (Main.db["episode"] == 3 || (Main.level_select && Main.level_select_episode == 2)):
            if (Main.db["difficulty"] == 0):
                    seconds = 189
            elif (Main.db["difficulty"] == 1):
                    seconds = 169
            elif (Main.db["difficulty"] == 2):
                    seconds = 139
            elif (Main.db["difficulty"] == 3):
                    seconds = 109
        nine_seconds = seconds
    elif (Main.nine_count > 0):
        if (Main.adventure_mode && Main.db["pursuit"] == 2):
            seconds = int(Main.db["nine_time"])
            for i in range(Main.db["nine_strikes"]):
                decrease_time()
        else:
            seconds = int(Main.db["nine_custom_seconds"])
        nine_seconds = seconds
        update_time()
    if (Main.db["pursuit"] == 0):
        time_decrease = 0.1


func _process(_delta: float) -> void :
    pass


func play_anim(_style) -> void :
    $ClockAnimation.play("clock")
    $ClockAnimation.set_frame_and_progress(0, 0)


func _start_timer(time) -> void :
    if (time == true):
        $Timer.start()
    if (time == false):
        if ( !Main.nine && !Main.nine_count > 0): milliseconds = 1 - $Timer.get_time_left()
        elif (milliseconds == 0.0): milliseconds = $Timer.get_time_left()
        $Timer.stop()


func _on_timer_timeout() -> void :
    if ( !Main.nine && !Main.nine_count > 0): seconds += 1
    else: seconds -= 1
    if ((Main.nine || Main.nine_count > 0) && seconds <= 0):
        nine_timeout.emit(false, 0.001)
    update_time()


func update_time() -> void :
    if seconds > 999:
        $Label.text = "999"
    elif seconds > 99:
        $Label.text = var_to_str(seconds)
    elif seconds > 9:
        $Label.text = "0" + var_to_str(seconds)
    else:
        $Label.text = "00" + var_to_str(seconds)


func get_time() -> float:
    if (Main.nine || Main.nine_count > 0): seconds = nine_seconds - seconds
    if (Main.adventure_mode):
        Main.db["adventure_times"][Main.db["adventure_levels_complete"]] = seconds + milliseconds
        if (Main.nine_count > 0): Main.db["nine_time"] = nine_seconds - seconds
    Main.db["total_time"] += seconds + milliseconds

    return seconds + milliseconds


func reset_timer() -> void :
    $Timer.stop()
    seconds = 0

func decrease_time() -> void :
    if ( !Main.db["master"]):
        if ($Timer.wait_time > time_decrease && Main.db["adventure_shield"] <= 0):
            if ((Main.db["pursuit"] != 0 && Main.adventure_mode) || !Main.practice):
                $Timer.set_wait_time($Timer.wait_time - time_decrease)
            else:
                $Timer.set_wait_time($Timer.wait_time - (time_decrease / 2))
    else:
        $Timer.set_wait_time(0.01)
