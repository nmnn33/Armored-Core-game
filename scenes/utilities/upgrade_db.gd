extends Node


const ICON_PATH = "res://assets/upgrades/"
const WEAPON_PATH = "res://assets/attacks/projectiles/"
const UPGRADES = {
	"rocket1": {
		"icon": WEAPON_PATH + "RPG-round.png",
		"displayname": "Rocket",
		"details": "Sends an rocket towards random nearby enemy",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"rocket2": {
		"icon": WEAPON_PATH + "RPG-round.png",
		"displayname": "Rocket",
		"details": "An addition rocket is sent",
		"level": "Level: 2",
		"prerequisite": ["rocket1"],
		"type": "weapon"
	},
	"rocket3": {
		"icon": WEAPON_PATH + "RPG-round.png",
		"displayname": "Rocket",
		"details": "Rockets knockback is increased by 30% and do + 3 damage",
		"level": "Level: 3",
		"prerequisite": ["rocket2"],
		"type": "weapon"
	},
	"rocket4": {
		"icon": WEAPON_PATH + "RPG-round.png",
		"displayname": "Rocket",
		"details": "2 more additional rockets are sent",
		"level": "Level: 4",
		"prerequisite": ["rocket3"],
		"type": "weapon"
	},
	"plasma1": {
		"icon": WEAPON_PATH + "bullets+plasma.png",
		"displayname": "Plasma",
		"details": "A plasma comes spawns from player and goes towards last moved postion on zig-zag pattern",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"plasma2": {
		"icon": WEAPON_PATH + "bullets+plasma.png",
		"displayname": "Plasma",
		"details": "An additional plasma is created",
		"level": "Level: 2",
		"prerequisite": ["plasma1"],
		"type": "weapon"
	},
	"plasma3": {
		"icon": WEAPON_PATH + "bullets+plasma.png",
		"displayname": "Plasma",
		"details": "The plasma cooldown is reduced by 0.5 seconds, knockback is increased by 20% and damage by 5",
		"level": "Level: 3",
		"prerequisite": ["plasma2"],
		"type": "weapon"
	},
	"plasma4": {
		"icon": WEAPON_PATH + "bullets+plasma.png",
		"displayname": "Plasma",
		"details": "An additional plasma is created, the knockback is increased by 30% and damage by 5",
		"level": "Level: 4",
		"prerequisite": ["plasma3"],
		"type": "weapon"
	},
	"armor1": {
		"icon": ICON_PATH + "Skillicon10_18.png",
		"displayname": "Armor",
		"details": "Reduces Damage By 1 point",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"armor2": {
		"icon": ICON_PATH + "Skillicon10_18.png",
		"displayname": "Armor",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Level: 2",
		"prerequisite": ["armor1"],
		"type": "upgrade"
	},
	"armor3": {
		"icon": ICON_PATH + "Skillicon10_18.png",
		"displayname": "Armor",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Level: 3",
		"prerequisite": ["armor2"],
		"type": "upgrade"
	},
	"armor4": {
		"icon": ICON_PATH + "Skillicon10_18.png",
		"displayname": "Armor",
		"details": "Reduces Damage By an additional 2 point",
		"level": "Level: 4",
		"prerequisite": ["armor3"],
		"type": "upgrade"
	},
	"accelerate1": {
		"icon": ICON_PATH + "Skillicon10_29.png",
		"displayname": "Accelerate",
		"details": "Movement Speed Increased by 20% of base speed",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"accelerate2": {
		"icon": ICON_PATH + "Skillicon10_29.png",
		"displayname": "Accelerate",
		"details": "Movement Speed Increased by an additional 20% of base speed",
		"level": "Level: 2",
		"prerequisite": ["accelerate1"],
		"type": "upgrade"
	},
	"accelerate3": {
		"icon": ICON_PATH + "Skillicon10_29.png",
		"displayname": "Accelerate",
		"details": "Movement Speed Increased by an additional 20% of base speed",
		"level": "Level: 3",
		"prerequisite": ["accelerate2"],
		"type": "upgrade"
	},
	"accelerate4": {
		"icon": ICON_PATH + "Skillicon10_29.png",
		"displayname": "Accelerate",
		"details": "Movement Speed Increased by an additional 20% of base speed",
		"level": "Level: 4",
		"prerequisite": ["accelerate3"],
		"type": "upgrade"
	},
	"bigger_load1": {
		"icon": ICON_PATH + "Skillicon10_37.png",
		"displayname": "Bigger load",
		"details": "Increases the size of attacks an additional 10% of their base size",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"bigger_load2": {
		"icon": ICON_PATH + "Skillicon10_37.png",
		"displayname": "Bigger load",
		"details": "Increases the size of attacks an additional 10% of their base size",
		"level": "Level: 2",
		"prerequisite": ["bigger_load1"],
		"type": "upgrade"
	},
	"bigger_load3": {
		"icon": ICON_PATH + "Skillicon10_37.pngg",
		"displayname": "Bigger load",
		"details": "Increases the size of attacks an additional 10% of their base size",
		"level": "Level: 3",
		"prerequisite": ["bigger_load2"],
		"type": "upgrade"
	},
	"bigger_load4": {
		"icon": ICON_PATH + "Skillicon10_37.png",
		"displayname": "Bigger load",
		"details": "Increases the size of attacks an additional 10% of their base size",
		"level": "Level: 4",
		"prerequisite": ["bigger_load3"],
		"type": "upgrade"
	},
	"optimize1": {
		"icon": ICON_PATH + "Skillicon10_17.png",
		"displayname": "Optimize",
		"details": "Decreases of the cooldown of attacks by an additional 5% of their base time",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"optimize2": {
		"icon": ICON_PATH + "optimize_old.png",
		"displayname": "Optimize",
		"details": "Decreases of the cooldown of attacks by an additional 5% of their base time",
		"level": "Level: 2",
		"prerequisite": ["optimize1"],
		"type": "upgrade"
	},
	"optimize3": {
		"icon": ICON_PATH + "optimize_old.png",
		"displayname": "Optimize",
		"details": "Decreases of the cooldown of attacks by an additional 5% of their base time",
		"level": "Level: 3",
		"prerequisite": ["optimize2"],
		"type": "upgrade"
	},
	"optimize4": {
		"icon": ICON_PATH + "optimize_old.png",
		"displayname": "Optimize",
		"details": "Decreases of the cooldown of attacks by an additional 5% of their base time",
		"level": "Level: 4",
		"prerequisite": ["optimize3"],
		"type": "upgrade"
	},
	"armada1": {
		"icon": ICON_PATH + "Skillicon10_22.png",
		"displayname": "Armada",
		"details": "Your attacks now spawn 1 more additional attack",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"armada2": {
		"icon": ICON_PATH + "Skillicon10_22.png",
		"displayname": "Armada",
		"details": "Your attacks now spawn an additional attack",
		"level": "Level: 2",
		"prerequisite": ["armada1"],
		"type": "upgrade"
	},
	"repair": {
		"icon": ICON_PATH + "Skillicon10_11.png",
		"displayname": "Repair",
		"details": "Heals you for 20 health, can select infinite times",
		"level": "N/A",
		"prerequisite": [],
		"type": "item"
	}
}

