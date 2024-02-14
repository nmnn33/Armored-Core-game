extends Node

#Warps to next scene when player enters
func _on_warp_body_entered(_body):
	get_tree().change_scene_to_file("res://scenes/stages/stage.tscn")
	
