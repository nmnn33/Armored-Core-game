extends CharacterBody2D

var movement_speed = 100
var hp = 100
var maxhp = 100
var last_movement = Vector2.UP

var experience = 0
var experience_level = 1
var collected_experience = 0
var pass_time = 0
#Attacks
var rocket = preload("res://scenes/attack/rocket.tscn")
var plasma = preload("res://scenes/attack/plasma.tscn")

#AttackNodes
@onready var rocketTimer = get_node("Attack/RocketTimer")
@onready var rocketAttackTimer = get_node("Attack/RocketTimer/RocketAttackTimer")
@onready var plasmaTimer = get_node("Attack/PlasmaTimer")
@onready var plasmaAttackTimer = get_node("Attack/PlasmaTimer/PlasmaAttackTimer")

#UPGRADES
var collected_upgrades = []
var upgrade_options = []
var armor = 0
var speed = 0
var attack_cooldown = 0
var attack_size = 0
var additional_attacks = 0

#Rocket
var rocket_ammo = 0
var rocket_baseammo = 0
var rocket_attackspeed = 1.5
var rocket_level = 0

#Plasma
var plasma_ammo = 0
var plasma_baseammo = 0
var plasma_attackspeed = 1.5
var plasma_level = 0

#GUI
@onready var expBar = get_node("GUILayer/GUI/ExperienceBar")
@onready var labelLevel = get_node("GUILayer/GUI/ExperienceBar/LabelLevel")
@onready var levelPanel = get_node("GUILayer/GUI/LevelUpPanel")
@onready var upgradeOptions = get_node("GUILayer/GUI/LevelUpPanel/UpgradeOptions")
@onready var itemOptions = preload("res://scenes/utilities/item_option.tscn")
@onready var LevelUpSound = get_node("GUILayer/GUI/LevelUpPanel/LevelUpSound")
@onready var healthBar = get_node("GUILayer/GUI/HealthBar")
@onready var collectedWeapons = get_node("GUILayer/GUI/CollectedWeapons")
@onready var collectedUpgrades = get_node("GUILayer/GUI/CollectedUpgrades")
@onready var itemContainer = preload("res://scenes/player/gui/item_container.tscn")
@onready var gameTimer = get_node("GUILayer/GameTimer")

@onready var deathPanel = get_node("GUILayer/GUI/DeathPanel")
@onready var labelDeath = get_node("GUILayer/GUI/DeathPanel/LabelDeath")
@onready var gameOverSound = get_node("GUILayer/GUI/DeathPanel/GameOverSound")
@onready var winSound = get_node("GUILayer/GUI/DeathPanel/WinSound")

#Enemy Related
var enemy_close = []

#Signal
signal playerdeath

#This always activates first
func _ready():
	# Set the remote path to the direct child Camera2D node in the main scene
	$RemoteTransform2D.remote_path = get_parent().get_node("Camera2D").get_path()
	upgrade_character("rocket1")
	attack()
	set_expbar(experience, calculate_experiencecap())
	_on_hurt_box_hurt(0,0,0)

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
	pass_time += delta
	change_time()
	
#When player's hurtbox is collided with hitbox
func _on_hurt_box_hurt(damage, _angle, _knockback):
	hp -= clamp(damage-armor, 1.0, 999.0)	#min dmg is 1, max 999.
	healthBar.max_value = maxhp
	healthBar.value = hp
	if hp <= 0:
		death()
	else:
		pass

#When hp is under or same as 0 the deathPanel popsup and you can click on button to get back to main menu from the func _on_btn_menu_click_end()
func death():
	deathPanel.visible = true
	emit_signal("playerdeath") #SoundStage stops playing
	get_tree().paused = true
	var tween = deathPanel.create_tween()
	tween.tween_property(deathPanel,"position",Vector2(-100,100),3.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	gameOverSound.play()

#unpauses the game and change scene to main menu
func _on_button_lose_menu_click_end():
	get_tree().paused = false
	var _level = get_tree().change_scene_to_file("res://scenes/mainMenu/main_menu.tscn")
	
#Win game after beating boss, signal comes from the boss
func win():
	labelDeath.text = "You win!"
	deathPanel.visible = true
	emit_signal("playerdeath") #SoundStage stops playing
	get_tree().paused = true
	var tween = deathPanel.create_tween()
	tween.tween_property(deathPanel,"position",Vector2(-100,100),3.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	winSound.play()

#Attacks start here
func attack():
	if rocket_level > 0:
		rocketTimer.wait_time = rocket_attackspeed * (1-attack_cooldown)
		if rocketTimer.is_stopped():
			rocketTimer.start()
	if plasma_level > 0:
		plasmaTimer.wait_time = plasma_attackspeed * (1-attack_cooldown)
		if plasmaTimer.is_stopped():
			plasmaTimer.start()

#Reload kind of function.
func _on_rocket_timer_timeout():
	rocket_ammo += rocket_baseammo + additional_attacks
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
	plasma_ammo += plasma_baseammo + additional_attacks
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

#This is for the exp_coins to move towards the player
func _on_grab_area_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self	#here the exp_coin gets targeted

#The exp_coin gets collected here
func _on_collect_area_area_entered(area):
	if area.is_in_group("loot"):
		var coin_exp = area.collect()
		calculate_experience(coin_exp)	#here the exp calculation begins
		
func calculate_experience(coin_exp):
	var exp_required = calculate_experiencecap()
	collected_experience += coin_exp	#the exp get added to temporary var collected_experience
	if experience + collected_experience >= exp_required: #level up
		collected_experience -= exp_required-experience	#Leftover of collected_experience
		experience_level += 1	#Raise level by 1
		experience = 0		#Reset player's exp to zero
		exp_required = calculate_experiencecap()	#Calculating again required exp for next lvl
		levelup()
	else:	#The collected_experience gets added to player's experience and then emptied
		experience += collected_experience
		collected_experience = 0
	
	set_expbar(experience, exp_required)

#Returns exp required to levelUp
func calculate_experiencecap():
	var exp_cap = experience_level
	if experience_level < 20:
		exp_cap = experience_level*5
	elif experience_level < 40:
		exp_cap + 95 * (experience_level-19)*8
	else:
		exp_cap = 255 + (experience_level-39)*12
		
	return exp_cap

#Updates the ExperienceBar with current exp
func set_expbar(set_value = 1, set_max_value = 100):
	expBar.value = set_value
	expBar.max_value = set_max_value

#Used in calculate_experience(). Brings the LevelUpPanel on screen
func levelup():
	LevelUpSound.play()
	labelLevel.text = str("Level: ",experience_level)	#Updates the displayed level
	var tween = levelPanel.create_tween()	#Tween for LevelUpPanel to go from right to screen center
	tween.tween_property(levelPanel,"position",Vector2(-50,50),0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	levelPanel.visible = true
	var options = 0
	var optionsmax = 3
	while options < optionsmax:	#3 options upon levelUp. This loop fills the LevelUpPanel with those options
		var option_choice = itemOptions.instantiate()
		option_choice.item = get_random_item()
		upgradeOptions.add_child(option_choice)
		options += 1
	get_tree().paused = true	#Pause everything else but LevelUpPanel

#Connection from item_option-scene. Happens when UpgradeOption has been selected
func upgrade_character(upgrade):
	match upgrade:		#These has to be done here, because attack-scenes themselves have no ammo variables
		"rocket1":
			rocket_level = 1
			rocket_baseammo += 1
		"rocket2":
			rocket_level = 2
			rocket_baseammo += 1
		"rocket3":
			rocket_level = 3
		"rocket4":
			rocket_level = 4
			rocket_baseammo += 2
		"plasma1":
			plasma_level = 1
			plasma_baseammo += 1
		"plasma2":
			plasma_level = 2
			plasma_baseammo += 1
		"plasma3":
			plasma_level = 3
			plasma_attackspeed -= 0.5
		"plasma4":
			plasma_level = 4
			plasma_baseammo += 1
		"armor1","armor2","armor3":
			armor += 1
		"armor4":
			armor += 2
		"accelerate1","accelerate2","accelerate3","accelerate4":
			movement_speed += 20.0
		"bigger_load1","bigger_load2","bigger_load3","bigger_load4":
			attack_size += 0.10
		"optimize1","optimize2","optimize3","optimize4":
			attack_cooldown += 0.05
		"armada1","armada2":
			additional_attacks += 1
		"repair":
			hp += 20
			hp = clamp(hp,0,maxhp)
	adjust_gui_collection(upgrade)
	attack()	#refresh attack() so attacks will have correct stats
	var option_children = upgradeOptions.get_children()	#childrens were added in levelup func
	for i in option_children:	#Frees the options
		i.queue_free()
	upgrade_options.clear()
	collected_upgrades.append(upgrade)
	levelPanel.visible = false	#Hides the LevelUpPanel
	levelPanel.position = Vector2(1200,200)	#Back to right side of the screen
	get_tree().paused = false	#Resumes the everything
	calculate_experience(0)	#Calculate remaining exp again
	
#Select random upgrade from upgradeDB
func get_random_item():
	var dblist = []	#Every available upgrade will be put in this array. Availability is checked from below loop
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades: #Find already collected upgrades
			pass
		elif i in upgrade_options: #If the upgrade is already an option
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item": #Don't pick repair
			pass
		elif UpgradeDb.UPGRADES[i]["prerequisite"].size() > 0: #Check for PreRequisites
			var to_add = true
			for n in UpgradeDb.UPGRADES[i]["prerequisite"]:
				if not n in collected_upgrades:
					to_add = false
			if to_add:
				dblist.append(i)
		else:
			dblist.append(i)
	if dblist.size() > 0:
		var randomitem = dblist.pick_random()
		upgrade_options.append(randomitem)
		return randomitem	
	else:
		return null

#Function to change GameTimer label to track the played time
func change_time():
	var time = int(pass_time) #Only int, because decimals are not needed
	var get_m = int(time/60.0)	#Minutes
	var get_s = time % 60
	if get_m < 10:	#If minutes are less than ten, put zero infront
		get_m = str(0,get_m)
	if get_s < 10:	#If seconds are less than ten, put zero infront
		get_s = str(0,get_s)
	gameTimer.text = str(get_m,":",get_s)	#In 00:00 format

#Updates the GUI CollectedWeapons and ColledtedUpgrades
func adjust_gui_collection(upgrade):
	var get_upgraded_displayname = UpgradeDb.UPGRADES[upgrade]["displayname"]	#Displayname is to identify the upgrade/weapon, so you don't get duplicates (example: rocket1 and rocket2)
	var get_type = UpgradeDb.UPGRADES[upgrade]["type"]
	if get_type != "item":	#Don't want repair to be added into GUI
		var get_collected_displaynames = []
		for i in collected_upgrades:	#Adds upgrades found in this only
			get_collected_displaynames.append(UpgradeDb.UPGRADES[i]["displayname"])
		if not get_upgraded_displayname in get_collected_displaynames:	#Here the upgrades get added if not had before
			var new_item = itemContainer.instantiate()
			new_item.upgrade = upgrade
			match get_type:	#either on ColledtedWeapons or CollectedUpgrades depending on type
				"weapon":
					collectedWeapons.add_child(new_item)
				"upgrade":
					collectedUpgrades.add_child(new_item)
