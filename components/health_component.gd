extends ComponentBase
class_name HealthComponent

signal health_depleted

@export var health: float = 1.0
@export var is_fragile: bool = false

func is_dead() -> bool:
	return health <= Helpers.MIN_FLT

func damage_health(damage_amount: float) -> void:
	var was_dead: bool = is_dead()
	health -= damage_amount
	if is_dead() && !was_dead:
		health_depleted.emit()
