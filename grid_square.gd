extends Button

signal opened
signal flag_toggle
signal face_toggle
signal deac_radar
signal chord

var open_button
var flag_button
var flag_release = false
var b_down = false
var open = false
var flagged = false
var flag_order = [0, 1]
var flag_number = 0

var hold_flag = false
var hold_time = 0.5
var held = 0
var after_hold = false

var mine = false
var mistake = false
var nine = false
var value = 0
var mine_type = -99
var mine_value = 0
var operation = 0
var style = 1
var enabled = true
var blink_trigger = true
var outline_frame
var highlight_frame
@export var row_col = Vector2i(0, 0)
var max_size
var max_scale
var processed = false
var chording = true
var chord_flag = false
var nine_perimeter_mine = false
var pressure_mine = false
var doublemine = false
var antimine = false
var zero = false
var every_other = "1"

@export var outline_array = [0, 0, 0, 0]


func _ready() -> void :
    max_size = size
    max_scale = $Icon.scale
    chording = Main.db["chording"]

    if (Main.db["play_style"] == 0):
        open_button = "open"
        flag_button = "flag"
    else:
        open_button = "flag"
        flag_button = "open"

    if (Main.db["hold_to_flag"] == true):
        hold_flag = true
    hold_time = Main.db["hold_time"]

    flag_release = !Main.db["flag_click"]
    if ((row_col[0] %2) == (row_col[1] %2)): every_other = "2"
    else: every_other = "1"

    if ( !Main.db["graphics_quality"]):
        $Background1Low.set_visible(true)
        $Background1.set_visible(false)
        $Background2Low.set_visible(true)
        $Background2.set_visible(false)




func _process(_delta: float) -> void :
    if ( !open && hold_flag && b_down && enabled && operation != 2):
        held += _delta
        if held >= hold_time:
            held = 0
            b_down = false
            operation = 1
            button_pressed = !button_pressed
            _on_button_up()
            if (Main.db["mouse_drag"]): flag()
            after_hold = true

    if (enabled && b_down && operation != 2):
        if (Input.is_action_just_released(open_button) == true || Input.is_action_just_released(flag_button)):
            _on_toggled(true)
            _on_button_up()


func play_anim(chosen_style) -> void :
    style = chosen_style
    var style_string = var_to_str(chosen_style)
    if (style != 103):
        $Background1.play("waves" + style_string + "1")
        $Background2.play("waves" + style_string + "2")
        $Background1Low.play("waves" + style_string + "1")
        $Background2Low.play("waves" + style_string + "2")
    else:
        $Background1.play("waves" + style_string + "1" + every_other)
        $Background2.play("waves" + style_string + "2" + every_other)
        $Background1Low.play("waves" + style_string + "1" + every_other)
        $Background2Low.play("waves" + style_string + "2" + every_other)
    $Flag.play("flag1")
    $Background1.set_frame_and_progress(0, 0)
    $Background2.set_frame_and_progress(0, 0)
    $Icon.set_frame_and_progress(0, 0)
    $Flag.set_frame_and_progress(0, 0)

    if (chosen_style > 100):
        outline_frame = 0
        highlight_frame = style + 1
    else:
        outline_frame = style
        highlight_frame = 31;

    set_outline(outline_frame)

func set_outline(frame) -> void :
    if (style > 100):
        $outline / u.frame = 0
        $outline / r.frame = 0
        $outline / d.frame = 0
        $outline / l.frame = 0
        if (style != 103):
            if (frame == 0):
                $Background1.play("waves" + var_to_str(style) + "1")
                $Background1Low.play("waves" + var_to_str(style) + "1")
            else:
                $Background1.play("waves" + var_to_str(style) + "2")
                $Background1Low.play("waves" + var_to_str(style) + "2")
        else:
            if (frame == 0): $outline_full.set_visible(false)
            else: $outline_full.set_visible(true)
    elif (Main.db["classic"] != 0):
        if (outline_array[0] == 1 || frame == highlight_frame):
            $outline / u.frame = (frame * 2) + outline_array[0]
        elif (outline_array[0] == 2):
            $outline / u.frame = (frame * 2)
        else:
            $outline / u.frame = 0

        if (outline_array[1] == 1 || frame == highlight_frame):
            $outline / r.frame = (frame * 2) + outline_array[1]
        elif (outline_array[1] == 2):
            $outline / r.frame = (frame * 2)
        else:
            $outline / r.frame = 0

        if (outline_array[2] == 1 || frame == highlight_frame):
            $outline / d.frame = (frame * 2) + outline_array[2]
        elif (outline_array[2] == 2):
            $outline / d.frame = (frame * 2)
        else:
            $outline / d.frame = 0

        if (outline_array[3] == 1 || frame == highlight_frame):
            $outline / l.frame = (frame * 2) + outline_array[3]
        elif (outline_array[3] == 2):
            $outline / l.frame = (frame * 2)
        else:
            $outline / l.frame = 0
    else:
        $outline / u.frame = (frame * 2) + (outline_array[0] %2)
        $outline / r.frame = (frame * 2) + (outline_array[1] %2)
        $outline / d.frame = (frame * 2) + (outline_array[2] %2)
        $outline / l.frame = (frame * 2) + (outline_array[3] %2)



func _on_button_down() -> void :
    if (enabled):
        b_down = true
        set_outline(highlight_frame);
        if (operation != 2 && enabled):
            if (Input.is_action_pressed(open_button)):
                if (open && chording && Main.db["chord_button"] == 0 || 
                (Main.db["chord_button"] == 2 && Input.is_action_pressed(flag_button))):
                    operation = 0
                    chord.emit(row_col, highlight_frame)
                    chord_flag = true
                else: operation = 0
            if (Input.is_action_pressed(flag_button)):
                if ((open && chording && Main.db["chord_button"] == 1) || 
                (Main.db["chord_button"] == 2 && Input.is_action_pressed(open_button))):
                    operation = 0
                    chord.emit(row_col, highlight_frame)
                    chord_flag = true
                else:
                    operation = 1

                    if (Main.db["flag_click"]):
                        if !flag_release && !open: flag()
                        b_down = false
                        _on_button_up()
        face_toggle.emit(b_down)



func _on_button_up() -> void :
    if (enabled):
        b_down = false
        set_outline(outline_frame)
        if (chording): chord.emit(row_col, outline_frame)
        chord_flag = false
        if ( !after_hold): face_toggle.emit(b_down)
        else: after_hold = false



func _on_toggled(_toggled_on: bool) -> void :
    if operation == 0 && !flagged:

        opened.emit(row_col)

    if operation == 1 && flag_release && !open:
        flag()

    if operation == 2 && !open && !flagged && enabled:
        Main.db["times_used_sonar"] += 1
        $Radar.play()
        deac_radar.emit()
        if (Main.db["auto_sonar"]):
            if (mine):




                flag_number = flag_order.find(mine_type) - 1
                $Flag.play("flag" + var_to_str(mine_type))
                flag()
            else: operation = 0
            _on_toggled(operation)
        else:
            $Background1.set_modulate(Color(1, 1, 1, 0.5))
            $Background1Low.set_modulate(Color(1, 1, 1, 0.5))
            await get_tree().create_timer(3).timeout
            $Background1.set_modulate(Color(1, 1, 1, 1))
            $Background1Low.set_modulate(Color(1, 1, 1, 1))


func flag() -> void :
    if ( !after_hold):
            if !flagged:
                flagged = true
                $Flag.visible = true
                $FlagSound.play()
                Main.db["total_tiles_flagged"] += 1
                flag_toggle.emit(flagged)
                flag_number += 1
            else:
                if (flag_number < flag_order.size() - 1):
                    flag_number += 1
                else:
                    flag_number = 0
                    flagged = false
                    $Flag.visible = false
                    $UnflagSound.play()
                    Main.db["total_tiles_unflagged"] += 1
                    flag_toggle.emit(flagged)
                var frame_progress = $Flag.get_frame_progress()
                if (flag_number != 0): $Flag.play("flag" + var_to_str(flag_order[flag_number]))
                else: $Flag.play("flag1")
                $Flag.set_frame_progress(frame_progress)


                if (pressure_mine && mine):
                    operation = 0
                    _on_toggled(true)

            held = 0



func set_icon(new_text: String) -> void :
    if (mine_value != 0 && !nine_perimeter_mine && new_text == "0"):
        $Icon.play("-0")
        zero = true
    else:
        $Icon.play(new_text)
        zero = false

func pre_flag() -> void :
    flagged = true
    $Flag.visible = true
    flag_toggle.emit(flagged)


func reveal_mines(win: bool) -> void :
    if (win):
        if (mine):
            if ( !flagged): flag_toggle.emit(true)
            flagged = true
            $Flag.visible = true
            var frame_progress = $Flag.get_frame_progress()
            $Flag.play("flag" + var_to_str(mine_type))
            $Flag.set_frame_progress(frame_progress)
    else:
        if (mine && !flagged):
            open = true
            $Background1.visible = false
            $Background1Low.visible = false
        if ( !mine && flagged):
            $X.visible = true
        if (mine && flagged):
            if (flag_order[flag_number] != mine_type):
                $X.frame = 1
                $X.visible = true

    set_disabled(true)



func reset_tile() -> void :
    if (enabled):
        if (Main.db["graphics_quality"]):
            $Background1.visible = true
            $Background1Low.visible = false
        else:
            $Background1.visible = false
            $Background1Low.visible = true
        $Flag.visible = false
        $Icon.visible = true
        $Icon.play("0")
        $Icon.set_z_index(0)
        $outline.visible = true
        $X.visible = false
        $X.frame = 0
        open = false
        flagged = false
        flag_number = 0
        value = 0
        mine_value = 0
        operation = 0
        processed = false
        mine = false
        mistake = false
        doublemine = false
        antimine = false
        zero = false
        set_disabled(false)


func reset_style_tile() -> void :
    if (Main.db["graphics_quality"]): $Background1.visible = true
    else: $Background1Low.visible = true
func reset_face_tile() -> void :
    $Flag.visible = false
func reset_music_tile() -> void :
    if (Main.db["graphics_quality"]): $Background1.visible = true
    else: $Background1Low.visible = true
func deactivate() -> void :
    enabled = false
    operation = -1
    $Icon.visible = false


func activate_radar(op) -> void :
    operation = op


func shrink(x) -> void :
    set_custom_minimum_size(Vector2(x * max_size.x, x * max_size.y))
    set_size(get_minimum_size())

    $Background2.set_scale($Background2.get_scale() * x)
    $Background2Low.set_scale($Background2Low.get_scale() * x)
    $Background2.position = size / 2
    $Background2Low.position = size / 2
    $Icon.set_scale($Icon.get_scale() * x)
    $Icon.position = size / 2
    $Background1.set_scale($Background1.get_scale() * x)
    $Background1Low.set_scale($Background1Low.get_scale() * x)
    $Background1.position = size / 2
    $Background1Low.position = size / 2
    $Flag.set_scale($Flag.get_scale() * x)
    $Flag.position = size / 2
    $X.set_scale($X.get_scale() * x)
    $X.position = size / 2
    $outline.set_scale($outline.get_scale() * x)

    $decor.set_scale($decor.get_scale() * x)
    $decor.position = size / 2
    pivot_offset = size / 2

func blink() -> void :
    while (blink_trigger):
        $Background1.modulate = Color(100, 100, 100, 1)
        $Background1Low.modulate = Color(100, 100, 100, 1)
        await get_tree().create_timer(0.25).timeout
        $Background1.modulate = Color(1, 1, 1, 1)
        $Background1Low.modulate = Color(1, 1, 1, 1)
        await get_tree().create_timer(0.25).timeout

func blink2() -> void :
    while (blink_trigger):
        $Background1.visible = false
        $Background1Low.visible = false
        await get_tree().create_timer(0.25).timeout
        $Background1.visible = true
        $Background1Low.visible = true
        await get_tree().create_timer(0.25).timeout

func set_opened() -> void :
    if (Main.db["graphics_quality"]): $Background1.visible = !open
    else: $Background1Low.visible = !open

func set_flagged() -> void :
    $Flag.visible = flagged

func set_victory_flag() -> void :
    var frame = $Flag.get_frame()
    var prog = $Flag.get_frame_progress()
    $Flag.play("flag_gold")
    $Flag.set_frame_and_progress(frame, prog)

func icon_only() -> void :
    $Background1.visible = false
    $Background1Low.visible = false
    $Background2.visible = false
    $Background2Low.visible = false
    $Flag.visible = false
    $outline.visible = false
    $Icon.play("0")
    set_default_cursor_shape(0)

func get_frame_progress() -> float:
    return $Background1.get_frame_progress()

func set_frame_progress(fp) -> void :
    $Background1.set_frame_progress(fp)

func fancy_icon_animation() -> void :
    var number = 0
    if (value >= 0):
        while (number < value):
            number += 1
            $Icon.scale += Vector2(0.1, 0.1)
            await get_tree().process_frame
        while (number > 0):
            number -= 1
            $Icon.scale -= Vector2(0.1, 0.1)
            await get_tree().process_frame
    else:
        while (number > value):
            number -= 1
            $Icon.scale -= Vector2(0.1, 0.1)
            await get_tree().process_frame
        while (number < 0):
            number += 1
            $Icon.scale += Vector2(0.1, 0.1)
            await get_tree().process_frame

func high_to_low(switch) -> void :
    if ( !open):
        $Background1.set_visible( !switch)
        $Background1Low.set_visible(switch)
    $Background2.set_visible( !switch)
    $Background2Low.set_visible(switch)

func pause(paused) -> void :
    if (enabled):
        if (paused):
            if (Main.db["graphics_quality"]): $Background1.visible = true
            else: $Background1Low.visible = true
            $Flag.visible = false
        else:
            if (open):
                if (Main.db["graphics_quality"]): $Background1.visible = false
                else: $Background1Low.visible = false
            if (flagged):
                $Flag.visible = true


func _on_mouse_entered() -> void :
    if (Main.db["mouse_drag"]):
        if ( !disabled && !b_down):

            if (Input.is_action_pressed(open_button)):
                set_pressed_no_signal(true)
                button_down.emit()

func _on_mouse_exited() -> void :
    if (Main.db["mouse_drag"]):
        if ( !disabled && b_down):
            b_down = false
            set_pressed_no_signal(false)
            _on_button_up()
