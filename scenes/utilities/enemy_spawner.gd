extends Node2D


@export var spawns: Array[Spawn_info] = [] #Spawn_info comes from spawn_info.gd which has multiple variables

@onready var player = get_tree().get_first_node_in_group("player") #Player scene

@export var time = 0

#Timer-node always keeps resetting at 1 sec interval and starts immediately (Autostart)
func _on_timer_timeout():
	time += 1		# 1 time is 1 second
	var enemy_spawns = spawns
	for i in enemy_spawns:		#i is iteraton number of the enemy
		if time >= i.time_start and time <= i.time_end:		#Checks if time is within start and end
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter += 1
			else:							#Happens if there are enemies left to spawn
				i.spawn_delay_counter = 0
				var new_enemy = i.enemy		#Selects the current enemy in iteration
				var counter = 0
				while  counter < i.enemy_num:		#Spawns multiple enemies by enemy_num amount
					var enemy_spawn = new_enemy.instantiate()
					enemy_spawn.global_position = get_random_position()		#enemy spawn position from function
					add_child(enemy_spawn)		#puts enemy into the world
					counter += 1		#increases counter untill all enemies are spawned on one batch as dictated by enemy_num

#This function is for determining a random vector coordinate, which is outside the players view.
func get_random_position():
	var vpr = get_viewport_rect().size * randf_range(1.1,1.4)
	var top_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y - vpr.y/2)
	var top_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y - vpr.y/2)
	var bottom_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y + vpr.y/2)
	var bottom_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y + vpr.y/2)
	var pos_side = ["up","down","right","left"].pick_random()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	match pos_side:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
	
	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y,spawn_pos2.y)
	return Vector2(x_spawn,y_spawn) #The vector coordinate where enemy will spawn
