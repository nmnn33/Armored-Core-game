extends Control

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/mainScene/main_scene.tscn")

func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://scenes/optionsMenu/optionsMenu.tscn")
	
func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://scenes/creditsScene/creditsMenu.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
