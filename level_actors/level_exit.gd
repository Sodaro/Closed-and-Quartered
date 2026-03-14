extends Area2D
class_name LevelExit

signal player_reached_level_exit(player: PlayerCharacter, level_exit: LevelExit)


func _on_body_entered(body: Node2D) -> void:
	var player: PlayerCharacter = body as PlayerCharacter
	if player != null && player.has_collected_collectible:
		player_reached_level_exit.emit(player, self)
