extends Node2D

# To-Do : 
# TUTORIAL -> Familiarize with control scheme
# Rope pull on defib ()
# Sound : Complete
# Minion 1. Spawn Logic DONE 2. Attack Patterns DONE 3. Multiple enemy types 4. Minion death NEED ANIMS
# Player : Misc logic -> QA kaam.
# Reaper special animation and boss fight -> Reaper's attack patterns. : boss fight -> then different requirements
# Playtesting
# Misc visual FX -> shit like Screen shake when player is hit etc. (DONE)
# Player firing (DONE)
# Sounds -> general -> Reaper laugh when generating minions, projectile sounds
# Car sounds -> engines, tyres, defib, 
# Enemy -> chipmunky laughs of minions
# 
# when player is closest to the van => think think

const Tutorial = preload("res://Tutorial.tscn")


var scytheTimer 
var adjustMusic = false
onready var clear = $UI/Clear
# Called when the node enters the scene tree for the first time.


var stage:int
var wave: int

func _ready() -> void:	
	get_tree().paused = true 
	tutorial_engage()
	
func tutorial_engage():
	var tut = Tutorial.instance()
	add_child(tut)
	
func start():
	$Music.play()
	wave = 1 
	stage = 1
	pull_rope(stage)
	startWave(stage,wave)
	
func _process(delta: float) -> void:
	if has_node("Reaper"):
		if(!$Reaper.minions_spawning && $Enemies.get_child_count() == 0):
			next_wave()
			startWave(stage,wave)

func addTrauma(trauma:float):
	$Camera2D.add_trauma(trauma)

func next_wave():
	if(wave==3):
		wave = 1
		stage += 1
		pull_rope(stage)
		$Defib.play()
		$Music.volume_db -= 10
		adjustMusic = true
		clear.visible = true
		yield(get_tree().create_timer(1), 'timeout') 
		clear.visible = false
	else:
		wave += 1
	
	

func startWave(stage:int, wave:int):

	if(stage==4):
		$Player.isBound = false 
		$Ambulance/MoveZone.hide()
		$Rope.hide()
		
	$Reaper.startWave(stage,wave)
	
	if(stage==4):
		$UI/StageDisplay.set_text("BOSSFIGHT !")
		$UI/FlavorText.set_text("Defeat him")
		yield(get_tree().create_timer(1), 'timeout') 
		$UI/StageDisplay.set_text("")
		$UI/FlavorText.set_text("")
		if adjustMusic:
			$Music.volume_db += 10
			adjustMusic = false
		
	else:
		$UI/StageDisplay.set_text("Stage "+str(stage)+" Wave "+str(wave))
		$UI/FlavorText.set_text("Get Ready !")
		yield(get_tree().create_timer(1), 'timeout') 
		$UI/StageDisplay.set_text("")
		$UI/FlavorText.set_text("")
		if adjustMusic:
			$Music.volume_db += 10
			adjustMusic = false			

func pull_rope(stage:int):
	var radius = 300 - 75*(stage-1)
	$Player.ropeLength = radius
	var currentSize =$Ambulance/MoveZone.get_texture().get_size()
	var requiredScale = Vector2(3*radius/currentSize.x , 3*radius/currentSize.y)
	$Ambulance/MoveZone.set_scale(requiredScale)
	
func win():
	$UI/FlavorText.set_text("The paramedics saved you!.")
	yield(get_tree().create_timer(3),"timeout")
	get_tree().change_scene("MainMenu.tscn")
