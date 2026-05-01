extends Sprite2D

signal flagged_out
var flags_left: int = 0
var flag_handicap: int = 0
var flag_multiplier = 1
var game_over = false


func _ready() -> void :
    if ( !Main.nine && !Main.ten && !Main.eleven):

        update_count()
    else:
        $MineCount.text = "???"

    if (Main.eleven_count > 0):
        if ((Main.adventure_mode || Main.level_select) && Main.eleven):
            if (Main.db["difficulty"] == 0): flag_handicap = 11
            elif (Main.db["difficulty"] == 1): flag_handicap = 0
            elif (Main.db["difficulty"] == 2): flag_handicap = -11
            elif (Main.db["difficulty"] == 3): flag_handicap = -22
        elif (Main.adventure_mode):
            if (Main.db["difficulty"] == 0): flag_multiplier = 1.4
            elif (Main.db["difficulty"] == 1): flag_multiplier = 1.2
            elif (Main.db["difficulty"] == 2): flag_multiplier = 1
            elif (Main.db["difficulty"] == 3): flag_multiplier = 0.8
            flag_handicap = - Main.db["nine_strikes"]
        else:
            flag_handicap = Main.db["flag_handicap"]
            update_count()


func _process(_delta: float) -> void :
    pass


func play_anim(_style) -> void :
    $MineAnimation.play("mine_anim")
    $MineAnimation.set_frame_and_progress(0, 0)


func set_flags(num: int) -> void :
    flags_left = (num + flag_handicap) * flag_multiplier
    if ( !Main.nine && !Main.ten && !Main.eleven):
        update_count()


func on_tile_flagged(flagged: bool) -> void :
    if ( !game_over):
        if flagged:
            flags_left -= 1
        else:
            flags_left += 1

    if (Main.nine_count == 0 || Main.eleven_count > 0):
        update_count()

    if (Main.eleven_count > 0 && flags_left <= 0 && !game_over):
        flagged_out.emit(false)


func update_count() -> void :
    var number
    if ( !Main.nine_count > 0 || Main.eleven_count > 0): number = flags_left
    else: number = (randi() % 1100 - 99)
    if number >= 999:
        $MineCount.text = "999"
    else:
        if number <= -99:
            $MineCount.text = "-99"
        else:
            var dig1: String
            var dig2: String
            var dig3: String

            if (number >= 0):
                dig1 = var_to_str(number / 100)
                dig2 = var_to_str((number - (str_to_var(dig1) * 100)) / 10)
                dig3 = var_to_str(number - (str_to_var(dig1) * 100) - (str_to_var(dig2) * 10))
            else:
                dig1 = "-"
                dig2 = var_to_str(number / -10)
                dig3 = var_to_str((number + (str_to_var(dig2) * 10)) / -1)

            $MineCount.text = dig1 + dig2 + dig3


func _on_timer_timeout() -> void :
    update_count()
