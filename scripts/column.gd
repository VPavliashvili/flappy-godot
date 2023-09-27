extends Node2D

var bottom_pillar: Node2D
var top_pillar: Node2D
var path: Node2D

var size_x: float
var path_heigh: float

func _ready():
	bottom_pillar = get_node("bottom_pillar") as Node2D
	top_pillar = get_node("top_pillar") as Node2D
	path = get_node("path") as Node2D

	var sprite: Sprite2D = top_pillar.get_node("visual")
	size_x = sprite.texture.get_size().x
	
	var body: StaticBody2D = path.get_node("body") as StaticBody2D
	var collider: CollisionShape2D = body.get_node("collider") as CollisionShape2D

	path_heigh = collider.shape.get_rect().size.y * path.scale.y * collider.scale.y
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
