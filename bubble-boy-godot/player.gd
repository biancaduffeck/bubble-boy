extends CharacterBody2D
signal hit
@export var gameAreaColision: CollisionShape2D
var countAttack=0
var isAttacking=false
var wasHit=false
var invencibleTime=0
@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var life=6
var originalModulation

func start(pos):
	show()
	originalModulation=$AnimatedSprite2D.modulate
	$AnimatedSprite2D/attackArea.position=Vector2(0,1)*300

func _ready() -> void:
	screen_size = get_viewport_rect().size
	#hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if velocity.x!=0 or velocity.y!=0:
		$AnimatedSprite2D/attackArea.position=velocity.normalized()*300
	
	if velocity.x != 0:
		pass
		#$AnimatedSprite2D.animation = "walk"
		#$AnimatedSprite2D.flip_v = false
		#$AnimatedSprite2D.flip_h = velocity.x < 0
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	move_and_slide()
	

	if Input.is_action_pressed("attack"):
		if(!isAttacking):
			isAttacking=true
			countAttack=0
			$AnimatedSprite2D/attackArea/CollisionShape2D.disabled=false
			$AnimatedSprite2D/attackArea/CollisionShape2D/ColorRect.color=Color(0.867, 0.0, 0.125, 0.835)
	if(isAttacking):
		countAttack+=delta
		if(countAttack>.1):
			isAttacking=false
			$AnimatedSprite2D/attackArea/CollisionShape2D.disabled=true
			$AnimatedSprite2D/attackArea/CollisionShape2D/ColorRect.color=Color(0.973, 0.463, 0.514, 0.29)

	for obj in $AnimatedSprite2D/attackArea.get_overlapping_bodies():
		if(obj.get_name().contains("Enemy1")):
			obj.markToDie()
	for obj in $hitBox.get_overlapping_bodies():
		if(obj.get_name().contains("Enemy1") and not wasHit):
			wasHit=true
			life-=1
			invencibleTime=0
			$AnimatedSprite2D.modulate=Color.RED
	if(wasHit):
		invencibleTime+=delta
		if(invencibleTime>.1):
			wasHit=false
			$AnimatedSprite2D.modulate=originalModulation
		#if(get_slide_collision(i).get_collider().name=="paredes"):
