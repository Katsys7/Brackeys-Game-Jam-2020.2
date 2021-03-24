extends PanelContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var dialogues = self.get_children()
# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = true
	dialogues[0].visible = true
func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		dialogues.pop_front().queue_free()
		if dialogues.size():
			dialogues[0].visible = true
		else:
			get_parent().start()
			get_tree().paused = false
			queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
