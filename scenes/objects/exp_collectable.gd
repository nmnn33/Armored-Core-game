extends Area2D

@export var experience = 1

var coin_regular = preload("res://assets/objects/bag_coins.png")
var coin_more= preload("res://assets/objects/more_bag_coins.png")
var coin_lots = preload("res://assets/objects/lots_bag_coins.png")

var target = null
var speed = -1

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var sound = $CollectSound

func _ready():		#Sprite of exp is determined by their experience amount
	if experience < 5:
		return
	elif experience < 30:
		sprite.texture = coin_more
	else:
		sprite.texture = coin_lots

#This has logic for exp going towards player=target
func _physics_process(delta):
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2*delta	#Original speed is negative, so it goes backwards first but then accelerates towards player

#Gets called in player-scene
func collect():
	sound.play()
	collision.call_deferred("set","disabled",true)
	sprite.visible = false
	return experience

#The expCollectable gets freed when the sound ends, because sound is most important
func _on_collect_sound_finished():
	queue_free()
