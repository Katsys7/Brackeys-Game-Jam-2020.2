extends KinematicBody2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var health = 15
var maxVel = 300.0
var accel = 0.1
export var velocity : Vector2
var normalScale
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Lunge.play()
	normalScale = scale
	
	

func _physics_process(delta: float) -> void:
	var destination = get_node("../../Player").position
	var angle = position.angle_to_point(destination)
	var new_velocity = Vector2(maxVel*-cos(angle),maxVel*-sin(angle))
	velocity =  lerp(velocity,new_velocity,accel)
	velocity = move_and_slide(velocity)
	for i in range(get_slide_count() - 1):
		var collision = get_slide_collision(i)
		if(collision.collider.collision_layer == 1):
			collision.collider.hurt()
			die()
	rotation = velocity.angle() + PI
func hurt():
	$Hurt.play()
	if(health>0):
		get_node("../../").addTrauma(0.2)
		blinkRed()
		health-=1
		if(health==0): 
			die()
			
func blinkRed():
		modulate = Color(1,0,0)
		scale = Vector2(1.2,1.2) 
		yield(get_tree().create_timer(0.1), 'timeout') 
		modulate = Color(1,1,1)
		scale = normalScale
		
func die():
	set_physics_process(false)
	collision_layer = 20
	modulate = Color(1,0,0)
	scale = Vector2(1.2,1.2) 
	get_tree().paused = true ;
	yield(get_tree().create_timer(0.1), 'timeout') 
	get_tree().paused = false ;
	$AnimatedSprite.hide()
	$Smoke.hide()
	$Blast.emitting = true
	get_node("../../").addTrauma(0.7)
	yield(get_tree().create_timer(1), 'timeout') 
	queue_free()
