extends Area2D

var speed = 100.0
var velocity = Vector2()
var angle: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	velocity.x = speed*delta*sin(angle)
	velocity.y = speed*delta*cos(angle)
	translate(velocity)
#	print(velocity.angle())
	rotation = velocity.angle() +0.5*PI

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_Minion_Projectile_body_entered(body):
	body.hurt()
	queue_free()
