extends KinematicBody2D

export var velocity : Vector2
export var accel = 0.2 #lerp weight
export var maxvel = 400
export var health : int = 10
export var ropeLength:int = 300
export var isBound:bool = true
export var paused: bool
var canMove = true
var normalScale: Vector2
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
#onready var rope = get_node("../RopeRigidBody")
onready var animation_tree = get_node("AnimationTree").get("parameters/playback")
const PROJECTILE = preload("res://Soul Projectile.tscn")
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.
func _ready() -> void:
	var UI = get_node("../UI")
	UI.init(health)
	
	normalScale = scale
	paused = false 

func _physics_process(delta: float) -> void:
	if(health>0 && !paused):
		attack()
		movement()
		velocity = move_and_slide(velocity,Vector2.UP)

func attack():
	if Input.is_action_just_pressed("shoot"):
		$Shoot.play()
		animation_tree.travel("Attack")
		var cursor = get_global_mouse_position()
		cursor = Vector2(cursor.x, cursor.y + 16)
		shoot(Vector2(position.x + 17, position.y + 10.25),cursor)
		
	elif Input.is_action_just_pressed("alt_fire"):
		pulledIn()
#	else:
#		animation_tree.travel("Idle")		

func movement():
	var xStr = Input.get_action_strength("move_right")-Input.get_action_strength("move_left")
	var yStr = Input.get_action_strength("move_down")-Input.get_action_strength("move_up")
	if(isBound && position.distance_to(get_node("../Ambulance").position) > ropeLength):
		var theta = (position.angle_to_point(get_node("../Ambulance").position))
		xStr = -cos(theta)
		yStr = -sin(theta)
		if xStr > 0:
			animation_tree.travel("Right")
		elif xStr < 0:
			animation_tree.travel("Left")
	var dir = Vector2(xStr,yStr);
	var new_velocity = dir*maxvel
	velocity =  lerp(velocity,new_velocity,accel)

func hurt():
	if(health >0):
		$Hurt.play()
		get_parent().addTrauma(0.7)
		health -= 1
		animation_tree.travel("Hurt")
		blinkRed()
		get_node("../UI").destory_heart()
		if health <= 0:
			die()
		
func die():
	print("dying")
	
	animation_tree.travel("Death")
	yield(get_tree().create_timer(0.5),"timeout")
	modulate = Color(1,0,0)
	scale = Vector2(1.5,1.5) 
	get_parent().addTrauma(1.0)
	get_node("../UI/FlavorText").set_text("You Died")
	yield(get_tree().create_timer(1.5), 'timeout') 
	queue_free()
	get_tree().change_scene("res://MainMenu.tscn")
	
func shoot(projectileSpawnAt:Vector2, aimingAt:Vector2):
	var player_projectile = PROJECTILE.instance()
	player_projectile.position = projectileSpawnAt
	player_projectile.angle = PI+position.angle_to_point(aimingAt)
	get_parent().add_child(player_projectile)

#func pulledInUtil():
#	# To-Do : Find ideal time to pull in player
#	canMove = false
	
func pulledIn():		
	var playerPosition = position
	var ambulancePosition = get_node("../Ambulance").position
	var difference = diff(playerPosition, ambulancePosition)
	position = difference * 0.3 + position
#	get_node('../').get_tree().paused = true
#	rope.visible = false
	yield(get_tree().create_timer(1), 'timeout')
#	get_node('../').get_tree().paused = false
#	rope.visible = true
	
	
	
func diff(body_from : Vector2, body_to : Vector2): 
	return Vector2(body_to.x - body_from.x, body_to.y - body_from.y)


func blinkRed():
		modulate = Color(1,0.5,0.5)
		scale = Vector2(1.0,1.0) 
		get_tree().paused = true ;
		yield(get_tree().create_timer(0.2), 'timeout') 
		get_tree().paused = false ;
		modulate = Color(1,1,1)
		scale = normalScale
