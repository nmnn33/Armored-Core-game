extends Area2D

signal hit

@export var speed = 400
var screen_size

#This always activates first
func _ready():
	screen_size = get_viewport_rect().size
	# Set the remote path to the direct child Camera2D node in the main scene
	$RemoteTransform2D.remote_path = get_parent().get_node("Camera2D").get_path()

#Constant things
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		#plays the idle animation as default
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.play("idle")
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	#Checks if you run left or right and flips horizontally accordingly
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.flip_h = velocity.x < 0

#When you touch other objects, you take damage and become invincible for 2 sec (later)
func _on_body_entered(body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	
