extends Control

var fadeout = false
var skewer = 0
var skewing = 0
var pos

func _ready() -> void :
    rotation_degrees = randi() % 360
    var scaler = randf()
    scale = Vector2(scaler, scaler)
    pos = ((randi() % 200) + 50) / scaler



func _process(delta: float) -> void :
    $Circle.position += Vector2(pos * delta, pos * delta)

    if (skewing == skewer):
        if skewing >= 0: skewer = - skewing - 1
        else: skewer = - skewing + 1
    else:
        if skewer >= 0:
            $Circle.skew += delta
            skewing += 1
        else:
            $Circle.skew -= delta
            skewing -= 1

    if ( !fadeout):
        modulate[3] += delta
        if (modulate[3] >= 1):
            fadeout = true
    else:
        modulate[3] -= delta
        if (modulate[3] <= 0):
            queue_free()
