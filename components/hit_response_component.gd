extends ComponentBase
class_name HitResponseComponent

enum HitSurfaceType
{
	Absorb,
	Reflective,
	Fragile
}

@export var surface_type: HitSurfaceType

signal hit_event(hit_position: Vector2, direction: Vector2, damage: float)

func handle_hit(hit_position: Vector2, direction: Vector2, damage: float) -> void:
	hit_event.emit(hit_position, direction, damage)
