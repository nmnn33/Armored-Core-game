extends AudioStreamPlayer

#Happens when player dies, stops the music from playing on deathPanel
func _on_player_playerdeath():
	playing = false
