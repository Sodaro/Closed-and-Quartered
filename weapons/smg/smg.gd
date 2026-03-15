extends RangedWeapon
class_name SMG

func use_weapon() -> void:
	super.use_weapon()
	var instance: Projectile = projectile_class.instantiate()
	instance.damage = base_damage
	Helpers.LEVEL_ROOT_NODE.add_child(instance)
	instance.global_rotation_degrees = global_rotation_degrees + randf_range(rand_bullet_rotation_min, rand_bullet_rotation_max)
	instance.global_position = projectile_spawn.global_position
