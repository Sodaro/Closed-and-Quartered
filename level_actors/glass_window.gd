extends StaticBody2D

func _ready() -> void:
	$HitResponseComponent.hit_event.connect(_handle_hit)
	
func _handle_hit(position: Vector2, direction: Vector2, damage: float):
	queue_free()
