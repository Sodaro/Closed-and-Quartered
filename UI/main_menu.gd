extends Control

signal start_game_pressed


func _on_start_game_button_pressed() -> void:
	start_game_pressed.emit()
