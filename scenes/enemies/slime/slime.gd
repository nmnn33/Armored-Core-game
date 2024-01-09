extends CharacterBody2D

@export var movement_speed = 50
@export var hp = 10
@export var knockback_recovery = 3.5
var knockback = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $AnimatedSprite2D
@onready var hit_sound = $HitSound

var death_anim = preload("res://scenes/enemies/death/death_explosion.tscn")

signal remove_from_array(object)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	sprite.play("run")
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	#below three line are for enemy to chase player based on player position, no need to normalize, it's already in effect with direction_to
	var direction = global_position.direction_to(player.global_position)
	velocity = direction*movement_speed
	velocity += knockback
	move_and_slide()
	
	#Below code to change facing direction
	if direction.x > 0.1:
		sprite.flip_h = false
	elif direction.x < -0.1:
		sprite.flip_h = true

#gets called in _on_hurt_box_hurt which happens when this dies. 
func death():
	emit_signal("remove_from_array",self)
	var enemy_death = death_anim.instantiate()		#instantiate death_explosion.tscn where are audio and sprite for death animation
	enemy_death.scale = sprite.scale		#same explosion scale as this sprite
	enemy_death.global_position = global_position		#explosion spawns on the position where death occurred.
	get_parent().call_deferred("add_child",enemy_death)
	queue_free()

func _on_hurt_box_hurt(damage, angle, knockback_amount):
	hp -= damage
	knockback = angle * knockback_amount
	if hp <= 0:
		death()
	else:
		hit_sound.play()
