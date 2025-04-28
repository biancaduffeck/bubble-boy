extends RigidBody2D
@export var speedBase = 1000
var speed=speedBase
@export var player:Node2D
var gameAreaColision
var countstate=0
var currentDirection
var countstateLimit=randi_range(3,7)
var limitUpTop
var limitBottomDown
var stateList=[
	"walking",
	"following",
	"goingBack"
]
var currentState=stateList[0]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.animation = "walk"
	# Set the mob's position to the random location.
	player=get_node("/root/Main/Player")
	gameAreaColision=get_node("/root/Main/AreaGame/CollisionShape2D")
	var gameAreaRect=gameAreaColision.shape.get_rect()
	limitUpTop=gameAreaColision.position-gameAreaRect.size/2
	limitBottomDown=gameAreaColision.position+gameAreaRect.size/2
	position.x=randi_range(limitUpTop.x,limitBottomDown.x)
	position.y=randi_range(limitUpTop.y,limitBottomDown.y)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if(currentState=="walking"):
		countstate+=delta
		if(currentDirection==null or countstate>countstateLimit):
			countstateLimit=randi_range(3,7)
			countstate=1
			currentDirection=Vector2(randf_range(-10,10),randf_range(-10,10)).normalized()
		position+=currentDirection*delta*speed
	if(global_position.distance_to(player.global_position)<200):
		pass
		#currentState="following"
		
	if(currentState=="following" and global_position.distance_to(player.global_position)>=400):
		currentState="goingBack"
	
	if(currentState=="goingBack"):
		currentState="walking"
		
	if(currentState=="following"):
		currentState="walking"
		pass
		#position+=(player.global_position-global_position).normalized()*delta*speed*2
	position = position.clamp(limitUpTop, limitBottomDown)
