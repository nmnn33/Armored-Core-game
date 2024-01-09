extends Area2D

var level = 1
var hp = 1
var speed = 100
var damage = 5
var knockback_amount = 100
var attack_size = 1.0

var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
signal remove_from_array(object)

func _ready():
	angle = global_position.direction_to(target)	#Angle is to angle the sprite to point towards target
	rotation = angle.angle()
	match level:		#attacks can have different levels
		1:
			hp = 1
			speed = 100
			damage = 5
			knockback_amount = 100
			attack_size = 1.0
		2:
			hp = 1
			speed = 100
			damage = 5
			knockback_amount = 100
			attack_size = 1.0
		3:
			hp = 2
			speed = 100
			damage = 8
			knockback_amount = 100
			attack_size = 1.0
		4:
			hp = 2
			speed = 100
			damage = 8
			knockback_amount = 100
			attack_size = 1.0

	
	var tween = create_tween()	#tween is for changing the properties of the node, in this case "scale"
	tween.tween_property(self,"scale",Vector2(1,1)*attack_size,1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)		#Here we change the sprite from a dot to the desired size multiplied by attack_size with eases added.
	tween.play()

func _physics_process(delta):
	position += angle*speed*delta	#Movement must be done like this for non character-nodes

#The attack disappears after it hp reaches 0
func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		emit_signal("remove_from_array",self)
		queue_free()


func _on_timer_timeout():
	emit_signal("remove_from_array",self)
	queue_free()
