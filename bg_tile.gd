extends Panel

var r
var max_size
var max_scale
var style_string
var variant = "1"
var row_col = Vector2i(0, 0)
var every_other


func _ready() -> void :
    max_size = size
    max_scale = $decor.scale

    if ((row_col[0] %2) == (row_col[1] %2)): every_other = "2"
    else: every_other = "1"

    if ( !Main.db["graphics_quality"]):
        $waterlow.set_visible(true)
        $water.set_visible(false)


func _process(_delta: float) -> void :
    pass


func play_anim(style) -> void :
    style_string = var_to_str(style)
    if (style >= 11 || Main.db["classic"] != 0): variant = "2"
    else: variant = "1"
    if (style != 103):
        $water.play("waves" + style_string + variant)
        $waterlow.play("waves" + style_string + variant)
    else:
        $water.play("waves" + style_string + "3" + every_other)
        $waterlow.play("waves" + style_string + "3" + every_other)
    if (Main.db["decor_density"] > 0):
        var div
        if (Main.db["decor_density"] == 1): div = 1000
        if (Main.db["decor_density"] == 2): div = 100
        if (Main.db["decor_density"] == 3): div = 10

        r = randi() % div
        if (r == 0 && (style < 100)):
            $decor.play("decor" + style_string)
        else:
            $decor.play("decor0")
    $water.set_frame_and_progress(0, 0)
    $decor.set_frame_and_progress(0, 0)



func shrink(x) -> void :
    set_custom_minimum_size(Vector2(x * max_size.x, x * max_size.y))
    $water.set_scale($water.get_scale() * x)
    $decor.set_scale($decor.get_scale() * x)

func high_to_low(switch) -> void :
    $water.set_visible( !switch)
    $waterlow.set_visible(switch)
