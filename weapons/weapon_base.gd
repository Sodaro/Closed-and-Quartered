extends CharacterBody2D
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
@export var throw_speed: float = 1000
@export var sprite_node: Sprite2D
@export var throw_damage: float = 10.0
@export var base_damage: float = 1.0

var weapon_owner: Node = null
var previous_owner: Node

var initial_layer: int
var last_time_used: float
var is_thrown: bool

func can_use_weapon() -> bool:
	if Helpers.get_time_since(last_time_used) < cooldown:
		return false
	return true

func pick_up_weapon(new_owner: Node) -> void:
	initial_layer = collision_layer
	collision_layer = 0
	weapon_owner = new_owner

func use_weapon() -> void:
	last_time_used = Helpers.get_time_seconds()

func throw_weapon() -> void:
	velocity = global_transform.x * throw_speed
	is_thrown = true
	drop_weapon()

func drop_weapon() -> void:
	reparent(Helpers.LEVEL_ROOT_NODE)
	collision_layer = initial_layer
	previous_owner = weapon_owner
	weapon_owner = null
	

func _process(delta: float) -> void:
	if weapon_owner != null:
		return
		
	if !is_thrown:
		return
	
	rotate(velocity.length() * 0.0005)
	velocity = lerp(velocity, Vector2.ZERO, 1 * delta)
	var result = move_and_collide(velocity * delta)
	if result:
		var collider: Object = result.get_collider()
		if collider == previous_owner:
			return
		if collider.has_method("handle_hit"):
			collider.handle_hit(result.get_position(), -result.get_normal(), throw_damage)
			if collider.is_fragile:
				return
		velocity = Vector2.ZERO
		is_thrown = false
