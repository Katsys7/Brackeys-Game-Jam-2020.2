extends Line2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	add_point(get_node("../Player").position,0)
	add_point(get_node("../Ambulance").position,1)

func _physics_process(delta: float) -> void:
	set_point_position(0,get_node("../Player").position)
	set_point_position(1,get_node("../Ambulance").position)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
