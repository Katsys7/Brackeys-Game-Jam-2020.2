extends Control

const HEART = preload("res://Heart.tscn")
var heart_containers = []
var size : int
var hearts = 0

func init(hearts : int):
	self.hearts = hearts
	self.size = hearts + 1
	
# Called when the node enters the scene tree for the first time.
func _ready():
	var origin_point = Vector2(8,32)
	for i in range(hearts):
		var heart_container = HEART.instance()
		instance_heart(origin_point, heart_container)
		origin_point.x += 40
	heart_containers = get_children()
	
	
func instance_heart(position : Vector2, heart_container):
	add_child(heart_container)
	get_children().back().rect_position = position

func destory_heart():
	if heart_containers.size():
		print(heart_containers)
		heart_containers.pop_back().queue_free()
	
