extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const MINION = preload("res://Minions.tscn")
const SPECIAL_MINION = preload("res://Special_Minion.tscn")
const SCYTHE = preload("res://Scythe.tscn")
export var minions_spawning:bool
# Called when the node enters the scene tree for the first time.
var health = 30
var normalScale
var timer:Timer
var bossFightRunning = false 
func _ready():
	
	setRageState(false)
	minions_spawning = false
	normalScale = scale
	timer = $Timer
	set_physics_process(false)
	
func spawnScythe():
	var scythe = SCYTHE.instance()
	scythe.position = Vector2(position.x - 75, position.y)
	get_parent().add_child(scythe)
	
	
func rageCycle():
		setRageState(true)
		yield(get_tree().create_timer(1.0), 'timeout') 
		setRageState(false)
		
		
func setRageState(state:bool):
	$Reaper_Rage.visible = state
	$Reaper_Normal.visible = !state
	$AnimationPlayer.play("Rage" if state else "Idle")

func spawn_minions(minionBatchSize:int,phase:int,health:int):
	spawnScythe()
	rageCycle()
	yield(get_tree().create_timer(1),"timeout")
	for n in range(minionBatchSize):
		var angle = n * PI/(minionBatchSize-1)
		var at = Vector2(position.x-150*sin(angle), position.y-150*cos(angle))
		spawn_minion_at(at,phase,health)
	
	minions_spawning = false

#spawn behavior : spawn at center of reaper and spread to destination
func spawn_minion_at(at:Vector2,phase:int,health:int):
	var minion =  MINION.instance()
	get_parent().get_node("Enemies").add_child(minion)
	minion.init(health,phase,position,at)
	
func startWave(stage:int,wave:int):
	minions_spawning = true
	yield(get_tree().create_timer(3.0), 'timeout') 
	$Laugh.play()	
	if(stage == 1):
		if(wave == 1):
			spawn_minions(3,1,3)
		elif(wave ==2):
			spawn_minions(3,2,3)
		elif(wave ==3):
			spawn_minions(5,2,3)
	elif(stage == 2):
		if(wave == 1):
			spawn_minions(5,3,5)
		elif(wave ==2):
			spawn_minions(5,2,5)
		elif(wave ==3):
			spawn_minions(7,4,5)
	elif(stage == 3):
		if(wave == 1):
			spawn_minions(5,3,7)
		elif(wave ==2):
			spawn_minions(7,2,7)
		elif(wave ==3):
			spawn_minions(9,4,7)
	elif(stage==4):
		bossfight()
		print("DONE")
func bossfight():
	set_collision_mask_bit(5,true)
	set_physics_process(true)
	spawnScythe()
	setRageState(true)
	bossFightRunning = true
	for n in range(2):
		var angle = n * PI
		var at = Vector2(position.x-150*sin(angle), position.y-150*cos(angle))
		spawn_special_minion(at)
	minions_spawning = false
	
func hurt():
	$Hurt.play()
	if(health>0):
		get_node("../").addTrauma(0.2)
		blinkRed()
		health-=1
		if(health==0): 
			die()

func _physics_process(delta: float) -> void:
	if(bossFightRunning):
		var specialMinionCount = get_parent().get_node("Enemies").get_child_count()
		if (specialMinionCount < 2):
			var angle = PI * randf()
			var at = Vector2(position.x-150*sin(angle), position.y-150*cos(angle))
		
			spawn_special_minion(at)

func spawn_special_minion(at:Vector2):
	var minion =  SPECIAL_MINION.instance()
	minion.position = at
	get_parent().get_node("Enemies").add_child(minion)

func blinkRed():
	modulate = Color(1,0,0)
	scale = Vector2(0.7,0.7) 
	yield(get_tree().create_timer(0.1), 'timeout') 
	modulate = Color(1,1,1)
	scale = normalScale

func die():
	$Die.play()
	for node in get_parent().get_node("Enemies").get_children():
		node.die()
	setRageState(false)
	set_physics_process(false)
	minions_spawning = false
	bossFightRunning = false
	set_physics_process(false)
	queue_free()
	get_parent().win()
	print("WIN")
	
	
