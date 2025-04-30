extends CharacterBody2D
@export var speedBase = 1000
var speed=speedBase
@export var player:Node2D
var gameAreaColision
var countstate=0
var currentDirection
var countstateLimit=5
var originalModulation

var stateList=[
	"walking",
	"following",
	"goingBack"
]
var currentState=stateList[0]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	originalModulation=$AnimatedSprite2D.modulate
	$AnimatedSprite2D.animation = "frontWalk"
	$AnimatedSprite2D.play("")
	# Set the mob's position to the random location.
	player=get_node("/root/Main/Player")
	gameAreaColision=get_node("/root/Main/AreaGame/CollisionShape2D")
	var gameAreaRect=gameAreaColision.shape.get_rect()
	var limitUpTop
	var limitBottomDown
	limitUpTop=gameAreaColision.position-gameAreaRect.size/2
	limitBottomDown=gameAreaColision.position+gameAreaRect.size/2
	position.x=randi_range(limitUpTop.x,limitBottomDown.x)
	position.y=randi_range(limitUpTop.y,limitBottomDown.y)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	stateMachineConditions()
	stateMachine(delta)
	ArrangeAnimation()
	
func ArrangeAnimation():
	if(velocity.y>0):
		$AnimatedSprite2D.animation = "frontWalk"
		if(velocity.x>0):
			$AnimatedSprite2D.flip_h=false
		else:
			$AnimatedSprite2D.flip_h=true
	else:
		$AnimatedSprite2D.animation = "backWalk"
		if(velocity.x>0):
			$AnimatedSprite2D.flip_h=true
		else:
			$AnimatedSprite2D.flip_h=false

func stateMachineConditions():
	if(global_position.distance_to(player.global_position)<300 and currentState=="walking"):
		currentState="following"
		
	if(currentState=="following" and global_position.distance_to(player.global_position)>=400):
		currentState="walking"
		
	for i in get_slide_collision_count():
		if(get_slide_collision(i).get_collider().name=="Player"):
			currentState="bounce"
			countstate=0
		else:
			print(get_slide_collision(i).get_collider().name)
		if(get_slide_collision(i).get_collider().name=="wall"):
			print("wall")
		
func stateMachine(delta: float):	
	if(currentState=="walking"):
		$AnimatedSprite2D.modulate = originalModulation
		countstate+=delta
		if(currentDirection==null or countstate>countstateLimit):
			countstateLimit=5
			countstate=1
			currentDirection=Vector2(randf_range(-10,10),randf_range(-10,10)).normalized()
		velocity=currentDirection*100
		
	if(currentState=="following"):
		$AnimatedSprite2D.modulate = Color.RED
		velocity=(player.global_position-global_position).normalized()*delta*speed*100

	if(currentState=="bounce"):
		$AnimatedSprite2D.modulate = Color.RED
		currentDirection=(player.global_position-global_position).normalized()*-1
		velocity=currentDirection*5*100
		countstate+=delta
		if(countstate>.3):
			currentState="walking"
	move_and_slide()
