extends CharacterBody2D

var speed = 400
var screen_size

#This always activates first
func _ready():
	screen_size = get_viewport_rect().size
	# Set the remote path to the direct child Camera2D node in the main scene
	$RemoteTransform2D.remote_path = get_parent().get_node("Camera2D").get_path()

func get_input():
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * speed
	if velocity.length() > 0:
		#plays the idle animation as default
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.play("idle")
	#Checks if you run left or right and flips horizontally accordingly
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.flip_h = velocity.x < 0

func _physics_process(delta):
	get_input()
	move_and_collide(velocity * delta)
