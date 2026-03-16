extends Control

signal continue_pressed

func _on_credits_back_button_pressed() -> void:
	$Credits.visible = false


func _on_credits_button_pressed() -> void:
	$Credits.visible = true


func _on_continue_game_button_pressed() -> void:
	continue_pressed.emit()


func _on_exit_game_button_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
