extends Node2D
class_name WeaponBase

enum WeaponEquipSlot
{
	FRONT,
	RIGHT
}

enum WeaponRepeatType
{
	AUTO,
	SEMIAUTO
}

@export var repeat_type: WeaponRepeatType
@export var equip_slot: WeaponEquipSlot
@export var cooldown: float

func use_weapon():
	pass

func throw_weapon():
	pass

func drop_weapon():
	reparent(get_parent().get_parent())
	pass
