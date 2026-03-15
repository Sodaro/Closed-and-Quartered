extends Control

signal start_game_pressed

func _on_start_game_button_pressed() -> void:
	$Credits.visible = false
	start_game_pressed.emit()


func _on_credits_back_button_pressed() -> void:
	$Credits.visible = false
	pass # Replace with function body.


func _on_credits_button_pressed() -> void:
	$Credits.visible = true
	pass # Replace with function body.
