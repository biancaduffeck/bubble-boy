extends Node2D
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func choseAplace(map):
	var mob_spawn_location = map
	position.x=rng.randi_range(map.position.x, map.size.x+map.position.x)
	position.y=rng.randi_range(map.position.y, map.size.y+map.position.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#$CollisionShape2D.position=$RigidBody2D.position
