extends CharacterBody2D

@export var movement_speed = 50
@export var hp = 40

@onready var player = get_tree().get_first_node_in_group("player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	$AnimatedSprite2D.play("run")
	#below three line are for enemy to chase player based on player position, no need to normalize, it's already in effect with direction_to
	var direction = global_position.direction_to(player.global_position)
	velocity = direction*movement_speed
	move_and_slide()
	
	#Below code to change facing direction
	if direction.x > 0.1:
		$AnimatedSprite2D.flip_h = false
	elif direction.x < -0.1:
		$AnimatedSprite2D.flip_h = true


func _on_hurt_box_hurt(damage):
	hp -= damage
	if hp <= 0:
		queue_free()
