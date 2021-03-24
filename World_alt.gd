extends Node2D

const Tutorial = preload("res://Tutorial.tscn")
# To-Do : 
# TUTORIAL -> Familiarize with control scheme
# Rope pull on defib ()
# Sound : Complete
# Minion 1. Spawn Logic DONE 2. Attack Patterns DONE 3. Multiple enemy types 4. Minion death NEED ANIMS
# Player : Misc logic -> QA kaam. 1. Player health-bar logic (DONE) 2. Player Defib logic (To-Do)
# Reaper special animation and boss fight -> Reaper's attack patterns. : boss fight -> then different requirements
# Playtesting
# Misc visual FX -> shit like Screen shake when player is hit etc. (DONE)
# Player firing (DONE)
# Sounds -> general -> Reaper laugh when generating minions, projectile sounds
# Car sounds -> engines, tyres, defib, 
# Enemy -> chipmunky laughs of minions
# 
# when player is closest to the van => think think

var poleEndPoint : Vector2
var deadBodyTetherPoint : Vector2
var scytheTimer 

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	poleEndPoint = $Player.position
	deadBodyTetherPoint = $Ambulance.position
	get_tree().paused = true
	tutorial_engage()
	
func tutorial_engage():
	var tut = Tutorial.instance()
	add_child(tut)
	
func _physics_process(_delta: float) -> void:
	poleEndPoint = $Player.position
	deadBodyTetherPoint = $Ambulance.position

func middle(a:Vector2, b: Vector2) -> Vector2:
	return Vector2 ((b.x + a.x)*0.5 , (b.y + a.y)*0.5)

func addTrauma(trauma:float):
	get_tree().paused = true ;
	yield(get_tree().create_timer(trauma*0.4), 'timeout')
	get_tree().paused = false ;
	$Camera2D.add_trauma(trauma)
	 
func pull_rope():
	pass
