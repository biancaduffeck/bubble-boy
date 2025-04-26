extends RigidBody2D
@export var speedBase = 30
var speed=speedBase
var mob_spawn_location
var enemyPath
var player
var stateList=[
	"walking",
	"following",
	"goingBack"
]
var currentState=stateList[0]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.animation = "walk"
	mob_spawn_location = get_node("/root/Main/EnemyandPath/Path2D/PathFollow2D")#$Path2D/PathFollow2D
	enemyPath=get_node("/root/Main/EnemyandPath/Path2D")
	mob_spawn_location.progress_ratio = randf()
	# Set the mob's position to the random location.
	position = mob_spawn_location.position
	player=get_node("/root/Main/Player")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var countstate=0
	if(currentState=="walking"):
		mob_spawn_location.progress_ratio+=0.003*delta*speed
		position = mob_spawn_location.position
	if(global_position.distance_to(player.global_position)<200):
		currentState="following"
		
	if(currentState=="following" and global_position.distance_to(player.global_position)>=400):
		currentState="goingBack"
	
	if(currentState=="goingBack"):
		get_parent().global_position=global_position
		print(get_parent().global_position)
		currentState="walking"
		mob_spawn_location.progress_ratio+=0.003*delta*speed
		position = mob_spawn_location.position
		#currentState="walking"
		#path.curve.get_closest_offset(path.to_local(targetGlobalPosition))
	if(currentState=="following"):
		position+=(player.global_position-global_position).normalized()*delta*speed*5
		
		#position = mob_spawn_location.position
		
		
		#var velocity = Vector2.ZERO
		#velocity.x=1
		#velocity = velocity.normalized() * speed
		#position += velocity * delta
