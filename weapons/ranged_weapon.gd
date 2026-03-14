extends WeaponBase
class_name RangedWeapon

@export var projectile_class: PackedScene
#var projectile_class: Resource = load(projectile_class_path)

func use_weapon():
	var instance = projectile_class.instantiate()
	Helpers.LEVEL_ROOT_NODE.add_child(instance)
	instance.global_rotation = global_rotation
	instance.global_position = global_position
	pass
