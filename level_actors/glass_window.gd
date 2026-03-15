extends StaticBody2D

var break_sound: Resource = load("res://assets/audio/window_break.wav")

func _ready() -> void:
	$HitResponseComponent.hit_event.connect(_handle_hit)
	
func _handle_hit(position: Vector2, direction: Vector2, damage: float):
	AudioOneShot.play_sound(break_sound, global_position, Helpers.LEVEL_ROOT_NODE)
	queue_free()
