extends RangedWeapon
class_name Shotgun

var num_pellets: int = 12

func use_weapon():
	super.use_weapon()
	for i in range(num_pellets):
		var instance: Projectile = projectile_class.instantiate()
		instance.damage = base_damage
		Helpers.LEVEL_ROOT_NODE.add_child(instance)
		instance.global_rotation_degrees = global_rotation_degrees + randf_range(rand_bullet_rotation_min, rand_bullet_rotation_max)
		instance.global_position = projectile_spawn.global_position + Vector2(randf_range(-4, 4), randf_range(-4, 4))
