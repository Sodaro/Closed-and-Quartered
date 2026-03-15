extends CharacterBody2D
class_name WeaponBase

enum WeaponEquipSlot
{
	FRONT,
	RIGHT,
	LEFT
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
@export var throw_damage: float = 10.0
@export var base_damage: float = 1.0
@export var use_sound: AudioStream
@export var sound_pitch_min: float = 1.0
@export var sound_pitch_max: float = 1.0

var weapon_owner: Node = null
var previous_owner: Node

var left_attach: Node
var right_attach: Node
var front_attach: Node
var current_attach: Node

var initial_layer: int
var last_time_used: float
var is_thrown: bool
var time_thrown: float

func _ready() -> void:
	initial_layer = collision_layer

func can_use_weapon() -> bool:
	if Helpers.get_time_since(last_time_used) < cooldown:
		return false
	return true

func pick_up_weapon(new_owner: Node, front: Node, left: Node, right: Node) -> void:
	front_attach = front
	left_attach = left
	right_attach = right
	collision_layer = 0
	weapon_owner = new_owner
	match equip_slot:
		WeaponEquipSlot.FRONT:
			current_attach = front
		WeaponEquipSlot.RIGHT:
			current_attach = right
		WeaponEquipSlot.LEFT:
			current_attach = left
	reparent(current_attach, false)
	position = Vector2.ZERO
	rotation = 0

func use_weapon() -> void:
	AudioOneShot.play_sound(use_sound, global_position, Helpers.LEVEL_ROOT_NODE)
	last_time_used = Helpers.get_time_seconds()

func throw_weapon() -> void:
	velocity = global_transform.x * throw_speed
	is_thrown = true
	drop_weapon()
	
func drop_weapon() -> void:
	reparent(Helpers.LEVEL_ROOT_NODE)
	global_position = front_attach.global_position
	collision_layer = initial_layer
	previous_owner = weapon_owner
	weapon_owner = null
	$PickupComponent.handle_dropped()

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
		var response = ComponentManager.get_component(collider, HitResponseComponent)
		if (-result.get_normal()).dot(velocity.normalized()) < 0.25:
			return
		if response:
			if velocity.length() > 100:
				response.handle_hit(result.get_position(), -result.get_normal(), throw_damage)
			match (response.surface_type):
				HitResponseComponent.HitSurfaceType.Absorb:
					pass
				HitResponseComponent.HitSurfaceType.Reflective:
					pass
					#velocity = velocity.bounce(result.get_normal())
					#global_rotation = velocity.angle()
					#return
				HitResponseComponent.HitSurfaceType.Fragile:
					return
		velocity = Vector2.ZERO
		is_thrown = false
