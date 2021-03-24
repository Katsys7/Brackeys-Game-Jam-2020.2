extends Area2D

var speed = 500.0
var velocity = Vector2()
var angle: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	velocity.x = speed*delta*cos(angle)
	velocity.y = speed*delta*sin(angle)
	translate(velocity)
#	print(velocity.angle())
	rotation = velocity.angle() - 0.5*PI

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_Soul_Projectile_body_entered(body: Node) -> void:
	body.hurt()
	if(body.collision_layer == 4):
		queue_free()
