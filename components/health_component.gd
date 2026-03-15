extends ComponentBase
class_name HealthComponent

signal health_depleted

@export var health: float = 1.0
@export var is_fragile: bool = false
@export var hurt_sounds: Array[AudioStream]

func is_dead() -> bool:
	return health <= Helpers.MIN_FLT

func damage_health(damage_amount: float) -> void:
	var was_dead: bool = is_dead()
	health -= damage_amount
	var sound = hurt_sounds.pick_random()
	AudioOneShot.play_sound(sound, global_position, Helpers.LEVEL_ROOT_NODE, 0.8, 1.2)
	if is_dead() && !was_dead:
		health_depleted.emit()
