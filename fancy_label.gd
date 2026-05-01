extends Label

var font_color
var outline_color
var tick = 15.0 / 255.0


func _ready() -> void :
    font_color = get_label_settings().get_font_color()
    outline_color = get_label_settings().get_outline_color()



func _process(_delta: float) -> void :
    if (font_color[0] >= 1 && font_color[1] < 1 && font_color[2] <= 0): font_color[1] += tick
    elif (font_color[1] >= 1 && font_color[0] > 0 && font_color[2] <= 0): font_color[0] -= tick
    elif (font_color[1] >= 1 && font_color[2] < 1 && font_color[0] <= 0): font_color[2] += tick
    elif (font_color[2] >= 1 && font_color[1] > 0 && font_color[0] <= 0): font_color[1] -= tick
    elif (font_color[2] >= 1 && font_color[0] < 1 && font_color[1] <= 0): font_color[0] += tick
    elif (font_color[0] >= 1 && font_color[2] > 0 && font_color[1] <= 0): font_color[2] -= tick

    if (outline_color[0] >= 1 && outline_color[1] < 1 && outline_color[2] <= 0): outline_color[1] += tick
    elif (outline_color[1] >= 1 && outline_color[0] > 0 && outline_color[2] <= 0): outline_color[0] -= tick
    elif (outline_color[1] >= 1 && outline_color[2] < 1 && outline_color[0] <= 0): outline_color[2] += tick
    elif (outline_color[2] >= 1 && outline_color[1] > 0 && outline_color[0] <= 0): outline_color[1] -= tick
    elif (outline_color[2] >= 1 && outline_color[0] < 1 && outline_color[1] <= 0): outline_color[0] += tick
    elif (outline_color[0] >= 1 && outline_color[2] > 0 && outline_color[1] <= 0): outline_color[2] -= tick

    get_label_settings().set_font_color(font_color)
    get_label_settings().set_outline_color(outline_color)
