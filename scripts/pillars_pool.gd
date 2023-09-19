extends Node

@export var resolution_text: Label
var pillar_prefab = preload("res://scenes/pillar.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	instantiate_pillar_on_top()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var res = get_screen_width_height()
	var format := "[W:%s;H:%s]"
	resolution_text.text = format % [str(res.x), str(res.y)]

func get_screen_width_height() -> Vector2i:
	return DisplayServer.window_get_size()

func instantiate_pillar_on_top() -> void:
	var pillar: Node2D = pillar_prefab.instantiate() as Node2D
	add_child(pillar)
	set_top_pillar_position(pillar)

func set_top_pillar_position(pillar: Node2D) -> void:
	var sprite: Sprite2D = pillar.get_node("visual")
	var size: Vector2i = sprite.texture.get_size()
	# var screen: Vector2i = get_screen_width_height()
	var screen_y : int = 0
	var scale: Vector2 = pillar.scale

	# 2.0 since I need half of the size of whole sprite to make it touch the upper end of the screen
	var pos_y : float = float(screen_y) + float(size.y) / 2.0 * pillar.scale.y
	var pos_x : int = 500
	
	pillar.position = Vector2(pos_x, pos_y)
