extends Button

@export var number = 0
@export var level_style = 1
@export var stage_name = ""
@export var start_position = Vector2(0, 0)
@export var next_position = Vector2(0, 0)

signal begin


func _ready() -> void :
    $ThreeByThree / GridSquare00.outline_array = [2, 0, 0, 2]
    $ThreeByThree / GridSquare10.outline_array = [2, 0, 0, 0]
    $ThreeByThree / GridSquare20.outline_array = [2, 2, 0, 0]
    $ThreeByThree / GridSquare01.outline_array = [0, 0, 0, 2]
    $ThreeByThree / GridSquare11.outline_array = [0, 0, 0, 0]
    $ThreeByThree / GridSquare21.outline_array = [0, 2, 0, 0]
    $ThreeByThree / GridSquare02.outline_array = [0, 0, 2, 2]
    $ThreeByThree / GridSquare12.outline_array = [0, 0, 2, 0]
    $ThreeByThree / GridSquare22.outline_array = [0, 2, 2, 0]

    for i in range(2):
        for j in range(2):
            get_node("ThreeByThree/GridSquare" + var_to_str(j) + var_to_str(i)).set_outline(level_style)

    if (number < 9 && number <= Main.db["adventure_levels_complete"]):
        var mines_placed = number
        var randx
        var randy
        var coord
        while (mines_placed != 0):
            randx = randi_range(0, 2)
            randy = randi_range(0, 2)
            coord = var_to_str(randx) + var_to_str(randy)
            if (coord == "11"):
                pass
            elif (get_node("ThreeByThree/GridSquare" + coord).value != -1):
                get_node("ThreeByThree/GridSquare" + coord).value = -1
                get_node("ThreeByThree/GridSquare" + coord + "/Flag").visible = true
                var left
                if (randy == 0): left = 0
                else: left = randy - 1
                var up
                if (randx == 0): up = 0
                else: up = randx - 1
                var right
                if (randy == 2): right = 2
                else: right = randy + 1
                var down
                if (randx == 2): down = 2
                else: down = randx + 1

                for i in range(up, down + 1):
                    for j in range(left, right + 1):
                        coord = var_to_str(i) + var_to_str(j)
                        if (get_node("ThreeByThree/GridSquare" + coord).value > -1):
                            get_node("ThreeByThree/GridSquare" + coord).value += 1
                mines_placed -= 1

        for i in range(3):
            for j in range(3):
                coord = var_to_str(i) + var_to_str(j)
                if (get_node("ThreeByThree/GridSquare" + coord).value > -1):
                    get_node("ThreeByThree/GridSquare" + coord).set_icon(var_to_str(get_node("ThreeByThree/GridSquare" + coord).value))
                    get_node("ThreeByThree/GridSquare" + coord + "/Background1").visible = false
                    get_node("ThreeByThree/GridSquare" + coord + "/Background1Low").visible = false

    elif (number == 9 && number <= Main.db["adventure_levels_complete"]):
        var coord
        for i in range(3):
            for j in range(3):
                coord = var_to_str(i) + var_to_str(j)
                get_node("ThreeByThree/GridSquare" + coord + "/Flag").visible = true
                if (coord == "11"):
                    if (Main.db["graphics_quality"]): get_node("ThreeByThree/GridSquare" + coord + "/Background1").visible = true
                    else: get_node("ThreeByThree/GridSquare" + coord + "/Background1Low").visible = true
                    get_node("ThreeByThree/GridSquare" + coord + "/Flag").call_deferred("play", "flag_gold")
    elif (number == 10 && number <= Main.db["adventure_levels_complete"]):
        var coord
        for i in range(3):
            for j in range(3):
                coord = var_to_str(i) + var_to_str(j)
                get_node("ThreeByThree/GridSquare" + coord + "/Flag").visible = true
                if (coord == "11"):
                    if (Main.db["graphics_quality"]): get_node("ThreeByThree/GridSquare" + coord + "/Background1").visible = true
                    else: get_node("ThreeByThree/GridSquare" + coord + "/Background1Low").visible = true
                    get_node("ThreeByThree/GridSquare" + coord + "/Flag").call_deferred("play", "flag2")

    else:
        $ThreeByThree / GridSquare11 / Icon.play(var_to_str(number))
        $ThreeByThree / GridSquare11 / Background1.visible = false
        $ThreeByThree / GridSquare11 / Background1Low.visible = false


func _process(_delta: float) -> void :
    pass

func _on_pressed() -> void :
    play_level()


func play_level() -> void :
    set_disabled(true)
    var x = number - 1
    Main.game_length = Main.adventure_length[Main.db["episode"] - 1][x][Main.db["difficulty"]]
    Main.game_width = Main.adventure_width[Main.db["episode"] - 1][x][Main.db["difficulty"]]
    Main.game_mines = Main.adventure_mines[Main.db["episode"] - 1][x][Main.db["difficulty"]]
    if (level_style == 9): Main.game_style = 1
    elif (level_style == 10): Main.game_style = 5
    elif (level_style == 11): Main.game_style = 1
    else: Main.game_style = level_style
    if (level_style > 8): Main.game_bgm = 12
    else: Main.game_bgm = level_style
    if (Main.db["pursuit"] == 2):
        if (Main.db["episode"] == 1): Main.nine_count = 1
        elif (Main.db["episode"] == 2): Main.ten_count = 1
        elif (Main.db["episode"] == 3): Main.eleven_count = 1
    if (level_style == 9):
        Main.nine = true
        Main.nine_count = 1
    elif (level_style == 10):
        Main.ten = true
        Main.ten_count = 1
    elif (level_style == 11):
        Main.eleven = true
        Main.eleven_count = 1
    begin.emit()


func blink() -> void :
    while (true):
        await get_tree().create_timer(0.25).timeout
        modulate = Color(1.2, 1.2, 1.2, 1)
        await get_tree().create_timer(0.25).timeout
        modulate = Color(1, 1, 1, 1)
