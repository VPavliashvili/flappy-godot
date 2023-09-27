extends Node

enum Placement { TOP = 1, BOTTOM = -1}

@export var columns_starting_pos: Node2D
@export_range(10, 50) var column_count: int
@export_range(50, 300) var distance_beetween_pillar_x: int
@export_range(50, 200) var next_path_diff: int

var column_prefab = preload("res://scenes/column.tscn")
var rng: RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()

	instantiate_columns()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func instantiate_columns() -> void:
	var start_pos_x: int = int(columns_starting_pos.position.x)
	var start_pos_y: int = int(columns_starting_pos.position.y)
	var prev_pos_y: int = start_pos_y

	var counter: int = 0
	while counter < column_count:
		var column: Node2D = column_prefab.instantiate() as Node2D
		add_child(column)

		set_column_pos_upon_spawn(column, prev_pos_y, start_pos_x, counter)

		prev_pos_y = int(column.position.y)
		counter += 1

func set_column_pos_upon_spawn(column: Node2D, prev_pos_y: int, start_pos_x: int, counter: int) -> void:
	var size_x: int = column.get("size_x")
	var pos_x: int = start_pos_x + counter * (size_x + distance_beetween_pillar_x)

	var path_heigh = column.get("path_heigh")
	var pos_y: float

	var should_add: bool = rng.randi_range(1, 100) > 50
	if should_add:
		pos_y = prev_pos_y + path_heigh / 2
	else:
		pos_y = prev_pos_y - path_heigh / 2

	column.position = Vector2(pos_x, pos_y)

# different approach of path differentiation positioning
# func set_column_pos_upon_spawn(column: Node2D, prev_pos_y: int, start_pos_x: int, counter: int) -> void:
# 	var size_x: int = column.get("size_x")
# 	var pos_x: int = start_pos_x + counter * (size_x + distance_beetween_pillar_x)
#
# 	var path_pos_y: int = rng.randi_range(prev_pos_y - next_path_diff, prev_pos_y + next_path_diff)
# 	var diff: int = path_pos_y - prev_pos_y
#
# 	column.position = Vector2i(pos_x, prev_pos_y + diff)

func reset_column_pos_as_last(_last_pos_x) -> void:
	pass
