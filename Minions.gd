extends KinematicBody2D

const PROJECTILE = preload("res://Minion Projectile.tscn")


export var nextPosition: Vector2
var timer: Timer
var health:int
var should_spawn_projectiles : bool = false

#variables related to pattern
var patternPhase: int
var projectileBatchSize : int = 3
var bulletSpread = PI*0.33
var bulletOffset = PI*0.33
var shootCount = 0 
var normalScale: Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Spawn").play()
	health = 7
	timer = Timer.new()
	add_child(timer)
	timer.set("wait_time", 1.0)
	timer.connect("timeout",self,"_on_Timer_timeout")
	timer.start()
	setPhase(1)
	normalScale = scale

func init(newHealth:int,phase:int, spawnLocation:Vector2, travelTo:Vector2) -> void:
	health = newHealth
	scale = Vector2(0.5 + newHealth/7.0,0.5+newHealth/7.0)
	print(scale)
	normalScale = scale
	setPhase(phase)
	position = spawnLocation
	nextPosition = travelTo
	
	
func _physics_process(delta: float) -> void:
	if(!position.is_equal_approx(nextPosition)):
		position.x+=0.1*(nextPosition.x - position.x)
		position.y+=0.1*(nextPosition.y - position.y)
	

func moveTo(to:Vector2):
	position.x += (nextPosition.x - position.x)*0.1
	position.y += (nextPosition.y - position.y)*0.1
	
func shoot(angle:float):
	var minion_projectile = PROJECTILE.instance()
	minion_projectile.position = position
	minion_projectile.angle = angle
	get_node("../../").add_child(minion_projectile)
	
func _on_Timer_timeout():
	spawn_projectiles()
	
func spawn_pattern(phase:int):
	$Shoot.play()
	if(phase == 1):
		for n in range(projectileBatchSize):
			var angle = bulletOffset +  (n * bulletSpread/(projectileBatchSize-1)) + PI
			shoot(angle)
	elif(phase==2):
		for n in range(projectileBatchSize):
			var angle = bulletOffset +  (n * bulletSpread/(projectileBatchSize-1)) + PI + 0.16*PI*sin(shootCount*0.5)
			shoot(angle) 
	elif(phase == 3):
		var angle = PI+ shootCount*PI*0.1
		shoot(angle) 
	elif(phase == 4):
		for n in range(projectileBatchSize):
			var angle = bulletOffset +  (n * bulletSpread/(projectileBatchSize)) + PI + shootCount*PI*0.1
			shoot(angle) 
	position.x += 10
	shootCount+=1
	
func spawn_projectiles():	
	spawn_pattern(patternPhase)
	
func hurt():
	if(health>0):
		$Shriek.play()
		$Splat.play()
		get_node("../../").addTrauma(0.2)
		blinkRed()
		health-=1
		if(health==0): 
			die()
		
func die():
	$Dead.play()
	collision_layer = 20
	timer.stop()
	modulate = Color(1,0,0)
	scale = Vector2(1.2,1.2) 
	get_tree().paused = true ;
	yield(get_tree().create_timer(0.1), 'timeout') 
	get_tree().paused = false ;
	$AnimatedSprite.hide()
	$Smoke.hide()
	$Blast.emitting = true
	get_node("../../").addTrauma(0.7)
	yield(get_tree().create_timer(3), 'timeout') 
	queue_free()
	
func setPhase(newPhase:int):
	patternPhase = newPhase
	if(newPhase == 1):
		timer.set("wait_time", 0.25)
		projectileBatchSize = 3
		bulletSpread = PI*0.33
		bulletOffset = PI*0.33
	elif(newPhase == 2):
		timer.set("wait_time", 0.75)
		projectileBatchSize = 3
		bulletSpread = PI*0.5
		bulletOffset = PI*0.25
	elif(newPhase == 3):
		timer.set("wait_time", 0.2)
		projectileBatchSize = 0
		bulletSpread = 0
		bulletOffset = 0
	elif(newPhase == 4):
		timer.set("wait_time", 0.3)
		projectileBatchSize = 4
		bulletSpread = 2*PI
		bulletOffset = 0

func blinkRed():
		modulate = Color(1,0,0)
		scale = Vector2(1,1) 
		yield(get_tree().create_timer(0.1), 'timeout') 
		modulate = Color(1,1,1)
		scale = normalScale
