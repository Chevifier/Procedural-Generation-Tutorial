tool
extends Sprite
export var world_seed = "test"
export(NoiseTexture)var noise : NoiseTexture;

# Called when the node enters the scene tree for the first time.
func _ready():
	noise.noise.seed = world_seed.hash()


func _process(delta):
	noise.noise.seed = world_seed.hash()
	texture = noise
