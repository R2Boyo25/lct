extends VBoxContainer

func _on_continue_pressed():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_switch_clan_pressed():
	pass # Replace with function body.

func _on_new_clan_pressed():
	pass # Replace with function body.

func _on_settings_pressed():
	pass # Replace with function body.
	
func _on_quit_pressed():
	get_tree().quit(0)
