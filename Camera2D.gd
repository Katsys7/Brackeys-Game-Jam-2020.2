extends Camera2D


export var decay = 0.9  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(10, 10)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.05  # Maximum rotation in radians (use sparingly).
onready var noise = OpenSimplexNoise.new()
var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].
var noise_y = 0
func _ready() -> void:
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2
	randomize()

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)
	
func _process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
		
func shake():
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)