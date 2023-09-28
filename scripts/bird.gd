extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.body_entered.connect(_on_body_entered)
	self.area_entered.connect(_on_area_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(_delta):
# 	pass

func _on_body_entered(body):
	print("wu tang mazafaka")
	print(body.name)

func _on_area_entered(area):
	if area.is_in_group(game_data.node_group_obstacle):
		print("obstacle hit\ngame over")
	elif area.is_in_group(game_data.node_group_path):
		print("obstacle passed\nscore increased")
