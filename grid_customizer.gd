extends CenterContainer

signal update_tiles
@export var tile: PackedScene
@export var point: PackedScene
var tile_array = []
var edge_array = []
var rows: int
var columns: int
var held_down
var mirror_mode = 0

func _ready() -> void :
    pass

func _process(delta: float) -> void :
    pass

func build_board():
    $TileGrid.columns = columns
    var t
    var size_c = ((size.x - (columns)) / columns)
    var size_r = ((size.y - (rows)) / rows)

    var tile_length
    if size_c < size_r:
        tile_length = size_c - 1
    else:
        tile_length = size_r - 1
    var final_edges = []

    for i in range(rows):
        var row_array = []
        var edges_1 = []
        var edges_2 = []
        for j in range(columns):
            t = tile.instantiate()
            t.rc = Vector2i(i, j)
            t.held_down.connect(_draw_freely)
            t.coordinates.connect(_mirror_tile)
            t.more_or_less.connect(_update_tiles)
            t.hold_edge.connect(_draw_edge_freely)
            t.mirror_edge.connect(_mirror_edge)
            t.switch_edge.connect(_switch_edge)
            $TileGrid.add_child(t)
            t.expand(tile_length)
            row_array.append(t)

            t.get_node("ColorRect/u").rce = Vector3i(i, j, 0)
            t.get_node("ColorRect/u").edge_rc = Vector2i(i * 2, j)
            edges_1.append(t.get_node("ColorRect/u"))
            t.get_node("ColorRect/u").add_to_group("good_edges")
            t.get_node("ColorRect/r").rce = Vector3i(i, j, 1)
            t.get_node("ColorRect/d").rce = Vector3i(i, j, 2)
            t.get_node("ColorRect/l").rce = Vector3i(i, j, 3)
            t.get_node("ColorRect/l").edge_rc = Vector2i((i * 2) + 1, j)
            edges_2.append(t.get_node("ColorRect/l"))
            t.get_node("ColorRect/l").add_to_group("good_edges")
            if (t.rc[1] < columns - 1):
                t.get_node("ColorRect/r").set_visible(false)
            else:
                t.get_node("ColorRect/r").edge_rc = Vector2i((i * 2) + 1, j + 1)
                edges_2.append(t.get_node("ColorRect/r"))
                t.get_node("ColorRect/r").add_to_group("good_edges")

            if (t.rc[0] < rows - 1):
                t.get_node("ColorRect/d").set_visible(false)
            else:
                t.get_node("ColorRect/d").edge_rc = Vector2i((i * 2) + 2, j)
                final_edges.append(t.get_node("ColorRect/d"))
                t.get_node("ColorRect/d").add_to_group("good_edges")











        tile_array.append(row_array)
        edge_array.append(edges_1)
        edge_array.append(edges_2)

    edge_array.append(final_edges)



func _update_tiles(more_or_less) -> void :
    update_tiles.emit(more_or_less)

func get_grid_size() -> Vector2i:
    return Vector2(columns, rows)

func _draw_freely(yes_or_no: bool) -> void :
    get_tree().call_group("custom_tiles", "drawing", yes_or_no)

func _draw_edge_freely(yes_or_no: bool) -> void :
    get_tree().call_group("edge", "drawing", yes_or_no)

func _switch_edge(rce, on) -> void :
    if (rce[2] == 0):
        if (rce[0] != 0):
            tile_array[rce[0] - 1][rce[1]].get_node("ColorRect/d").on = on
    elif (rce[2] == 1):
        pass
    elif (rce[2] == 2):
        pass
    elif (rce[2] == 3):
        if (rce[1] != 0):
            tile_array[rce[0]][rce[1] - 1].get_node("ColorRect/r").on = on
    else:
        pass

func set_mirror_mode(mode_code) -> void :



    if mode_code == 0:
        if (mirror_mode == 0):
            mirror_mode = 1
        elif (mirror_mode == 3):
            mirror_mode = 2
        elif (mirror_mode == 2):
            mirror_mode = 3
        else:
            mirror_mode = 0
    if mode_code == 1:
        if (mirror_mode == 0):
            mirror_mode = 2
        elif (mirror_mode == 3):
            mirror_mode = 1
        elif (mirror_mode == 1):
            mirror_mode = 3
        else:
            mirror_mode = 0

    if (mirror_mode != 0): get_tree().call_group("custom_tiles", "set_mirror", true)
    else: get_tree().call_group("custom_tiles", "set_mirror", false)

func _mirror_tile(tile_coords: Vector2i) -> void :
    if (mirror_mode == 1):
        if (tile_coords[0] != ((rows - 1) - tile_coords[0])):
            tile_array[(rows - 1) - tile_coords[0]][tile_coords[1]].switch()
    if (mirror_mode == 2):
        if (tile_coords[1] != (columns - 1) - tile_coords[1]):
            tile_array[tile_coords[0]][(columns - 1) - tile_coords[1]].switch()
    if (mirror_mode == 3):
        if (tile_coords[0] != ((rows - 1) - tile_coords[0])):
            tile_array[(rows - 1) - tile_coords[0]][tile_coords[1]].switch()
        if (tile_coords[1] != (columns - 1) - tile_coords[1]):
            tile_array[tile_coords[0]][(columns - 1) - tile_coords[1]].switch()
        if (tile_coords[0] != (rows - 1) - tile_coords[0] && tile_coords[1] != (columns - 1) - tile_coords[1]):
            tile_array[(rows - 1) - tile_coords[0]][(columns - 1) - tile_coords[1]].switch()

func _mirror_edge(edge_coords: Vector2i) -> void :
    var edge_rows = (rows * 2) + 1
    var edge_columns = columns
    if ((edge_coords[0] %2) == 1):
        edge_columns += 1


    if (mirror_mode == 1):
        if (edge_coords[0] != ((edge_rows - 1) - edge_coords[0])):
            edge_array[(edge_rows - 1) - edge_coords[0]][edge_coords[1]].switch()

    if (mirror_mode == 2):
        if (edge_coords[1] != (edge_columns - 1) - edge_coords[1]):
            edge_array[edge_coords[0]][(edge_columns - 1) - edge_coords[1]].switch()

    if (mirror_mode == 3):
        if (edge_coords[0] != ((edge_rows - 1) - edge_coords[0])):
            edge_array[(edge_rows - 1) - edge_coords[0]][edge_coords[1]].switch()
        if (edge_coords[1] != (edge_columns - 1) - edge_coords[1]):
            edge_array[edge_coords[0]][(edge_columns - 1) - edge_coords[1]].switch()
        if (edge_coords[0] != (edge_rows - 1) - edge_coords[0] && edge_coords[1] != (edge_columns - 1) - edge_coords[1]):
            edge_array[(edge_rows - 1) - edge_coords[0]][(edge_columns - 1) - edge_coords[1]].switch()

func reset_tiles() -> void :
    get_tree().call_group("custom_tiles", "reset")

func reset_edges() -> void :
    get_tree().call_group("edge", "reset")

func hide_tiles(true_or_false) -> void :
    get_tree().call_group("custom_tiles", "turn_off", true_or_false)

func hide_edges(true_or_false) -> void :
    get_tree().call_group("good_edges", "turn_off", true_or_false)

func reverse_tiles() -> void :
    get_tree().call_group("custom_tiles", "switch")

func reverse_edges() -> void :
    get_tree().call_group("edge", "switch")

func reset_board(length, width) -> void :
    get_tree().call_group("custom_tiles", "queue_free")
    columns = length
    rows = width
    tile_array.clear()
    edge_array.clear()
    build_board()

func get_edge_values(row, col) -> Array:
    var zero = tile_array[row][col].get_node("ColorRect/u").on
    var one = tile_array[row][col].get_node("ColorRect/r").on
    var two = tile_array[row][col].get_node("ColorRect/d").on
    var three = tile_array[row][col].get_node("ColorRect/l").on

    return [zero, one, two, three]

func import_edge_switch(row, col, new_edge_array) -> void :
    if (new_edge_array[0] == true): tile_array[row][col].get_node("ColorRect/u").switch()
    if (new_edge_array[1] == true): tile_array[row][col].get_node("ColorRect/r").switch()
    if (new_edge_array[2] == true): tile_array[row][col].get_node("ColorRect/d").switch()
    if (new_edge_array[3] == true): tile_array[row][col].get_node("ColorRect/l").switch()
