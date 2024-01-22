extends TextureRect

var upgrade = null

func _ready():
	if upgrade != null:
		$ItemTexture.texture = load(UpgradeDb.UPGRADES[upgrade]["icon"])	#icon gets used in player-scene
