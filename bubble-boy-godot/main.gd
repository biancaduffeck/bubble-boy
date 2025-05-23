extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()

func putEnemiesOnScene():
	for i in range(10):
		var mob = mob_scene.instantiate()
		mob.name="Enemy1_"+str(i)
		# Spawn the mob by adding it to the Main scene.
		add_child(mob)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Player/Camera2D/RichTextLabel.text="vidas:"+str($Player.life)
	if($Player.life==0):
		get_tree().paused = true
		$Player/Camera2D/ColorRect.visible=true
	
func game_over():
	$ScoreTimer.stop()

func new_game():
	score = 0
	putEnemiesOnScene()
	$Player.start($StartPosition.position)
	$StartTimer.start()

func _on_score_timer_timeout() -> void:
	score += 1

func _on_start_timer_timeout() -> void:
	$ScoreTimer.start()
