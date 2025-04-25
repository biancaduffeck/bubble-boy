extends Node

@export var mob_scene: PackedScene
var score
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()

func putEnemiesOnScene():
	for i in range(5):
		var mob = mob_scene.instantiate()

		# Choose a random location on Path2D.
		var mob_spawn_location = $Map
		mob.position.x=rng.randi_range($Map.position.x, $Map.size.x+$Map.position.x)
		mob.position.y=rng.randi_range($Map.position.y, $Map.size.y+$Map.position.y)
		mob.position.x=2000
		mob.position.y=1000
		print(mob.position)
		# Spawn the mob by adding it to the Main scene.
		add_child(mob)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func game_over():
	$ScoreTimer.stop()

func new_game():
	score = 0
	putEnemiesOnScene()
	$Player.start($StartPosition.position)
	$StartTimer.start()
	print("___________")
	print($Map.get_position())
	print($Map.get_size())
	print("___________")

func whatever():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_score_timer_timeout() -> void:
	score += 1

func _on_start_timer_timeout() -> void:
	$ScoreTimer.start()
