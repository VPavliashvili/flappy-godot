extends Node

enum Placement { TOP = 1, BOTTOM = -1}

@export var pillars_starting_pos: Node2D
@export_range(10, 50) var pillars_count: int
@export_range(10, 100) var distance_beetween_pillar_x: float

var pillar_prefab = preload("res://scenes/pillar.tscn")
var start_pos_x: float

# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos_x = pillars_starting_pos.position.x

	var top_counter: int = 0
	print(pillars_count)
	while top_counter < pillars_count:
		instantiate_pillar(Placement.TOP, top_counter)
		top_counter += 1

	instantiate_pillar(Placement.BOTTOM, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func get_screen_width_height() -> Vector2i:
	return DisplayServer.window_get_size()

func instantiate_pillar(placement: Placement, line_number: int) -> void:
	var pillar: Node2D = pillar_prefab.instantiate() as Node2D
	add_child(pillar)
	if placement == Placement.TOP:
		set_top_pillar_position(pillar, line_number)
	else:
		set_bottom_pillar_position(pillar)

func set_top_pillar_position(pillar: Node2D, line_number: int) -> void:
	var sprite: Sprite2D = pillar.get_node("visual")
	var size: Vector2i = sprite.texture.get_size()
	# var screen: Vector2i = get_screen_width_height()
	var screen_y : int = 0
	var scale: Vector2 = pillar.scale

	# 2.0 since I need half of the size of whole sprite to make it touch the upper end of the screen
	var pos_y : float = float(screen_y) + float(size.y) / 2.0 * pillar.scale.y
	
	var pos_x: float = start_pos_x + line_number * (size.x + distance_beetween_pillar_x)

	pillar.position = Vector2(pos_x, pos_y)

func set_bottom_pillar_position(_pillar: Node2D) -> void:
	pass

# regarding path between top and down pillars
# it should be implemented like I have whole X size in Y 
# and A size path between the two pillars
# and distance between A size path center point of pillar_pair[i], [i-1] and [i+1]
# should not be greater than B
#	X	Y	A and B are variables for sure
