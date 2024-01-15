extends Area2D

var level = 1
var hp = 9999
var speed = 100.0
var damage = 5
var attack_size = 1.0
var knockback_amount = 100

var last_movement = Vector2.ZERO
var angle = Vector2.ZERO
var angle_less = Vector2.ZERO
var angle_more = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
signal remove_from_array(object)

func _ready():
	match level:
		1:
			hp = 9999
			speed = 250.0
			damage = 5
			knockback_amount = 100
			attack_size = 3.0
		2:
			hp = 9999
			speed = 250.0
			damage = 5
			knockback_amount = 100
			attack_size = 3.0
		3:
			hp = 9999
			speed = 250.0
			damage = 5
			knockback_amount = 100
			attack_size = 3.0
		4:
			hp = 9999
			speed = 250.0
			damage = 5
			knockback_amount = 125
			attack_size = 3.0
			
	var move_to_less = Vector2.ZERO			#move_to_less and move_to_more are for determining the position where the plasma spawns
	var move_to_more = Vector2.ZERO
	#Based on the last_movement which comes from player-scene it chooses 2 random Vector2's that are rougly 500 px away from player
	match last_movement:
		Vector2.UP, Vector2.DOWN:
			move_to_less = global_position + Vector2(randf_range(-1,-0.25), last_movement.y)*500
			move_to_more = global_position + Vector2(randf_range(0.25,1), last_movement.y)*500
		Vector2.RIGHT, Vector2.LEFT:
			move_to_less = global_position + Vector2(last_movement.x, randf_range(-1,-0.25))*500
			move_to_more = global_position + Vector2(last_movement.x, randf_range(0.25,1))*500
		Vector2(1,1), Vector2(-1,-1), Vector2(1,-1), Vector2(-1,1):
			move_to_less = global_position + Vector2(last_movement.x, last_movement.y * randf_range(0,0.75))*500
			move_to_more = global_position + Vector2(last_movement.x * randf_range(0,0.75), last_movement.y)*500
	
	angle_less = global_position.direction_to(move_to_less)		#angle_less and angle_more are for plasma swaying movement which is set by tween
	angle_more = global_position.direction_to(move_to_more)		#These are basically where the plasma's trajectory goes toward
	
	var initital_tween = create_tween().set_parallel(true)	#Tween that turns plasma to the original size after 3 sec
	initital_tween.tween_property(self,"scale",Vector2(1,1)*attack_size,3).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	var final_speed = speed
	speed = speed/5.0
	#Tween that makes plasma gain it's normal speed after 6 seconds
	initital_tween.tween_property(self,"speed",final_speed,6).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	initital_tween.play()
	
	var tween = create_tween()
	var set_angle = randi_range(0,1)	#This is to randomize whether plasma begins it movement from angle_less or angle_more
	if set_angle == 1:
		angle = angle_less
		tween.tween_property(self,"angle", angle_more,2)
		tween.tween_property(self,"angle", angle_less,2)

	else:
		angle = angle_more
		tween.tween_property(self,"angle", angle_less,2)
		tween.tween_property(self,"angle", angle_more,2)

	tween.set_loops()	#Same as play(), but it loop, so the plasma sways instead of changing angle twice. No need for limit, because queu_free() removes this.

func _physics_process(delta):
	position += angle*speed*delta

#Plasma lasts for 8 seconds
func _on_timer_timeout():
	emit_signal("remove_from_array",self)
	queue_free()
