extends ColorRect

@onready var itemName = $ItemName
@onready var itemDescription = $ItemDescription
@onready var itemLevel = $ItemLevel
@onready var itemIcon = $ColorRect/ItemIcon

var mouse_over = false
var item = null
@onready var player = get_tree().get_first_node_in_group("player")

signal selected_upgrade(upgrade)

#Creates a signal connection "selected_upgrade" on player-scene which's func is "upgrade_character"
func _ready():
	connect("selected_upgrade",Callable(player,"upgrade_character"))
	if item == null:
		item = "repair"
	itemName.text = UpgradeDb.UPGRADES[item]["displayname"]
	itemDescription.text = UpgradeDb.UPGRADES[item]["details"]
	itemLevel.text = UpgradeDb.UPGRADES[item]["level"]
	itemIcon.texture = load(UpgradeDb.UPGRADES[item]["icon"])

#Triggers when something is inputted, in this case left_click	
func _input(event):
	if event.is_action("left_click"):
		if mouse_over:
			emit_signal("selected_upgrade",item)	#Emits signal to player-scene

#Detect if mouse is on itemOption
func _on_mouse_entered():
	mouse_over = true

#Detect if mouse is not on itemOption
func _on_mouse_exited():
	mouse_over = false
