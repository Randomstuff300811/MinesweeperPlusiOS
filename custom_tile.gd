extends Button

signal held_down
signal coordinates
signal more_or_less
signal hold_edge
signal mirror_edge
signal switch_edge

var on_color = Color(255, 255, 255, 255)
var off_color = Color(240, 0, 0, 255)
var on = true
var rc = Vector2(0, 0)
var mirror = false

var hold

func _ready() -> void :
    var array = ["u", "r", "d", "l"]
    var one = 1
    for i in range(array.size()):

        get_node("ColorRect/" + array[i]).size[one] = 8
        get_node("ColorRect/" + array[i]).position[one] -= 4

        one += 1
        one %= 2
        get_node("ColorRect/" + array[i]).held_down.connect(_hold_edge)
        get_node("ColorRect/" + array[i]).mirror_coords.connect(_mirror_edge)
        get_node("ColorRect/" + array[i]).switch_correspondent.connect(_switch_correspondent)

func _process(_delta: float) -> void :
    pass

func switch() -> void :
    if (on):
        on = false
        more_or_less.emit(-1)
        $ColorRect.color = off_color
    else:
        on = true
        more_or_less.emit(1)
        $ColorRect.color = on_color

func _on_toggled(_toggled_on: bool) -> void :
    switch()

    if mirror:
        coordinates.emit(rc)

func _on_mouse_entered() -> void :
    if ( !disabled):
        $Outline.visible = true
        if (hold):
            _on_toggled( !on)

func _on_mouse_exited() -> void :
    $Outline.visible = false

func expand(length: int) -> void :
    set_custom_minimum_size(Vector2(length, length))
    size = Vector2(length, length)
    $ColorRect.size = size
    $Outline.size = size
    var point_length = length / 4
    if (point_length > 8.0):
        get_tree().call_group("point", "expand", point_length)
    else:
        get_tree().call_group("point", "expand", 8.0)


func _on_button_down() -> void :
    held_down.emit(true)

func _on_button_up() -> void :
    held_down.emit(false)

func drawing(yes_or_no) -> void :
    hold = yes_or_no

func set_mirror(yes_or_no) -> void :
    mirror = yes_or_no
    $ColorRect / u.set_mirror(yes_or_no)
    $ColorRect / r.set_mirror(yes_or_no)
    $ColorRect / d.set_mirror(yes_or_no)
    $ColorRect / l.set_mirror(yes_or_no)

func reset() -> void :
    on = true
    $ColorRect.color = on_color


func _hold_edge(yes_or_no) -> void :
    hold_edge.emit(yes_or_no)

func _mirror_edge(yes_or_no) -> void :
    mirror_edge.emit(yes_or_no)

func turn_off(true_or_false) -> void :
    if (true_or_false):
        $ColorRect.self_modulate[3] = 0
    else:
        $ColorRect.self_modulate[3] = 255
    set_disabled(true_or_false)

func _switch_correspondent(rce, onoff) -> void :
    switch_edge.emit(rce, onoff)
