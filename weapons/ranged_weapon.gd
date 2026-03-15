extends WeaponBase
class_name RangedWeapon

@export var projectile_class: PackedScene
@export var projectile_spawn: Node
@export var ammo_count: int = 8
@export var rand_bullet_rotation_min: float = 0
@export var rand_bullet_rotation_max: float = 0

func can_use_weapon() -> bool:
	if !super.can_use_weapon():
		return false
	if ammo_count <= 0:
		return false
	return true
	
func use_weapon() -> void:
	super.use_weapon()
	ammo_count -= 1
