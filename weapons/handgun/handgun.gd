extends RangedWeapon
class_name Handgun

func use_weapon():
	super.use_weapon()
	var instance = projectile_class.instantiate()
	Helpers.LEVEL_ROOT_NODE.add_child(instance)
	instance.global_rotation = global_rotation
	instance.global_position = projectile_spawn.global_position
	
