extends CharacterBody2D

var movement_speed = 400
var hp = 100
var last_movement = Vector2.UP

#Attacks
var rocket = preload("res://scenes/attack/rocket.tscn")
var plasma = preload("res://scenes/attack/plasma.tscn")

#AttackNodes
@onready var rocketTimer = get_node("Attack/RocketTimer")
@onready var rocketAttackTimer = get_node("Attack/RocketTimer/RocketAttackTimer")
@onready var plasmaTimer = get_node("Attack/PlasmaTimer")
@onready var plasmaAttackTimer = get_node("Attack/PlasmaTimer/PlasmaAttackTimer")

#Rocket
var rocket_ammo = 0
var rocket_baseammo = 1
var rocket_attackspeed = 1.5
var rocket_level = 1

#Plasma
var plasma_ammo = 0
var plasma_baseammo = 1
var plasma_attackspeed = 1.5
var plasma_level = 1

#Enemy Related
var enemy_close = []

#This always activates first
func _ready():
	# Set the remote path to the direct child Camera2D node in the main scene
	$RemoteTransform2D.remote_path = get_parent().get_node("Camera2D").get_path()
	attack()

func get_input():
	#Movement keys for movement
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir.normalized() * movement_speed #input_dir.normalized() makes you be at the same speed diagonally too
	if velocity.length() > 0:
		#plays the idle animation as default, otherwise run if "if" condition satisfied
		$AnimatedSprite2D.play()
		last_movement = input_dir		#For Plasma attack
	else:
		$AnimatedSprite2D.play("idle")
	#Checks if you run left or right and flips horizontally accordingly
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.flip_h = velocity.x < 0

#Plays every frame
func _physics_process(delta):
	get_input()
	move_and_collide(velocity * delta)

#When player's hurtbox is collided with hitbox
func _on_hurt_box_hurt(damage, _angle, _knockback):
	hp -= damage
	print(hp)

func attack():
	if rocket_level > 0:
		rocketTimer.wait_time = rocket_attackspeed
		if rocketTimer.is_stopped():
			rocketTimer.start()
	if plasma_level > 0:
		plasmaTimer.wait_time = plasma_attackspeed
		if plasmaTimer.is_stopped():
			plasmaTimer.start()

#Reload kind of function.
func _on_rocket_timer_timeout():
	rocket_ammo += rocket_baseammo
	rocketAttackTimer.start()

#Rockets get spawned and go towards enemies
func _on_rocket_attack_timer_timeout():
	if rocket_ammo > 0:
		var rocket_attack = rocket.instantiate()
		rocket_attack.position = position
		rocket_attack.target = get_random_target()
		rocket_attack.level = rocket_level
		add_child(rocket_attack)
		rocket_ammo -= 1
		if rocket_ammo > 0:			#Restocks ammo
			rocketAttackTimer.start()
		else:
			rocketAttackTimer.stop()

#Reload kind of function.
func _on_plasma_timer_timeout():
	plasma_ammo += plasma_baseammo
	plasmaAttackTimer.start()

#Plasma get spawned and they move towards last_movement; left, right, up, down
func _on_plasma_attack_timer_timeout():
	if plasma_ammo > 0:
		var plasma_attack = plasma.instantiate()
		plasma_attack.position = position
		plasma_attack.last_movement = last_movement
		plasma_attack.level = plasma_level
		add_child(plasma_attack)
		plasma_ammo -= 1
		if plasma_ammo > 0:			#Restocks ammo
			plasmaAttackTimer.start()
		else:
			plasmaAttackTimer.stop()

#function where if there is enemy in the range, it will return it's global position, otherwise it returns an "up" so the attacks attack by default up
func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP

#When enemy enters detection area
func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)

#When enemy leaves detection area
func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)


