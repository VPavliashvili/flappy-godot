extends Node

@export var columns_starting_pos: Node2D
@export_range(10, 50) var column_count: int
@export_range(50, 300) var distance_beetween_pillar_x: int

var pool = []

var column_prefab = preload("res://scenes/column.tscn")
var rng: RandomNumberGenerator
var last_column: Node2D
var screen: Vector2
var respawn_point_x: float
var has_found_respawn_point_x: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	screen = DisplayServer.window_get_size()
	rng = RandomNumberGenerator.new()

	instantiate_columns()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	manage_pooling()


func manage_pooling():
	if last_column != null && not has_found_respawn_point_x:
		if is_close_to_screen_border():
			var size_x: float = last_column.get("size_x")
			respawn_point_x = last_column.position.x + distance_beetween_pillar_x + size_x
			has_found_respawn_point_x = true
	
	if has_found_respawn_point_x:
		if is_close_to_screen_border():
			var head: Node2D = pool.pop_front() as Node2D
			reset_column_pos_as_last(head, respawn_point_x)
			pool.push_back(head)
			last_column = head


func is_close_to_screen_border() -> bool:
	return last_column.position.x - distance_beetween_pillar_x < screen.x


func instantiate_columns() -> void:
	var start_pos_x: int = int(columns_starting_pos.position.x)
	var start_pos_y: int = int(columns_starting_pos.position.y)
	var prev_pos_y: int = start_pos_y

	var counter: int = 0
	while counter < column_count:
		var column: Node2D = column_prefab.instantiate() as Node2D
		add_child(column)
		pool.append(column)

		set_column_pos_upon_spawn(column, prev_pos_y, start_pos_x, counter)

		prev_pos_y = int(column.position.y)
		counter += 1
		if counter == column_count:
			last_column = column


func set_column_pos_upon_spawn(column: Node2D, prev_pos_y: int, start_pos_x: int, counter: int) -> void:
	var size_x: int = column.get("size_x")
	var pos_x: int = start_pos_x + counter * (size_x + distance_beetween_pillar_x)

	var path_heigh = column.get("path_heigh")
		
	var check_border = check_going_past_edge_and_get_value(path_heigh, prev_pos_y)
	if check_border.is_on_edge:
		column.position = Vector2(pos_x, check_border.pos_y)
		return

	var pos_y: float
	var should_add: bool = rng.randi_range(1, 100) > 50
	if should_add:
		pos_y = prev_pos_y + path_heigh / 2
	else:
		pos_y = prev_pos_y - path_heigh / 2

	column.position = Vector2(pos_x, pos_y)


func reset_column_pos_as_last(column: Node2D, pos_x: float) -> void:
	var path_heigh = column.get("path_heigh")
	var pos_y: float
		
	var check_border = check_going_past_edge_and_get_value(path_heigh, last_column.position.y)
	if check_border.is_on_edge:
		column.position = Vector2(pos_x, check_border.pos_y)
		return

	var should_add: bool = rng.randi_range(1, 100) > 50
	if should_add:
		pos_y = last_column.position.y + path_heigh / 2
	else:
		pos_y = last_column.position.y - path_heigh / 2

	column.position = Vector2(pos_x, pos_y)


func check_going_past_edge_and_get_value(path_heigh: float, prev_pos_y: float):
	var distance_from_border: float
	var offset_from_border: int = 50
	var pos_y: float

	if prev_pos_y > screen.y / 2:
		distance_from_border = screen.y - (prev_pos_y + path_heigh / 2)
		if distance_from_border <= offset_from_border:
			pos_y = prev_pos_y - path_heigh / 2
			return { "is_on_edge": true, "pos_y": pos_y }
	else:
		distance_from_border = prev_pos_y - path_heigh / 2
		if distance_from_border <= offset_from_border:
			pos_y = prev_pos_y + path_heigh / 2
			return { "is_on_edge": true, "pos_y": pos_y }
	
	return { "is_on_edge": false, "pos_y": 0 }

