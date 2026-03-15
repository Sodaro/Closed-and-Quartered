extends WeaponBase
class_name MeleeWeapon

@export var hit_radius: float = 80
@export var swing_effect_scene: PackedScene

var swing_direction: Vector2
var default_flip_h: bool
var default_flip_v: bool

func _ready() -> void:
	default_flip_h = $Sprite2D.flip_h
	default_flip_v = $Sprite2D.flip_v
# add swing effect
# check for hits in front and inside of radius

func pick_up_weapon(new_owner: Node, front: Node, left: Node, right: Node) -> void:
	super.pick_up_weapon(new_owner, front, left, right)
	$Sprite2D.flip_h = default_flip_h
	$Sprite2D.flip_v = default_flip_v


func _process(delta: float) -> void:
	if Helpers.get_time_since(last_time_used) < 0.15:
		_handle_swing()
	super._process(delta)
		
func _handle_swing() -> void:
	var forward: Vector2 = weapon_owner.global_transform.x
	var hit_origin: Vector2 = weapon_owner.global_position
	var responses: Array = ComponentManager.get_all_components_of_type(HitResponseComponent)
	var sq_hit_radius: float = hit_radius * hit_radius
	
	for response in responses:
		if response.is_queued_for_deletion():
			continue
			
		var response_position: Vector2 = response.global_position
		if response.get_parent() == weapon_owner:
			continue
		if response_position.distance_squared_to(hit_origin) > sq_hit_radius:
			continue
		
		var dist: float = response_position.distance_to(hit_origin)
		var to_response: Vector2 = (response_position - hit_origin).normalized()
		if dist < hit_radius * 0.25 || to_response.dot(forward) > 0.0:
			response.handle_hit(response_position, to_response, base_damage)

func use_weapon() -> void:
	super.use_weapon()
	swing_direction = weapon_owner.global_transform.x
	var effect_instance = swing_effect_scene.instantiate()
	var hit_origin: Vector2 = weapon_owner.global_position
	effect_instance.global_position = hit_origin + swing_direction * hit_radius * 0.5
	effect_instance.global_rotation = weapon_owner.global_rotation
	effect_instance.global_scale = Vector2.ONE * (hit_radius / 32)
	Helpers.LEVEL_ROOT_NODE.add_child(effect_instance)
	_handle_swing()
	
	if (current_attach == right_attach):
		current_attach = left_attach
		reparent(current_attach, true)
		$Sprite2D.flip_h = true if equip_slot == WeaponEquipSlot.RIGHT else false
	elif (current_attach == left_attach):
		current_attach = right_attach
		reparent(current_attach, true)
		$Sprite2D.flip_h = true if equip_slot == WeaponEquipSlot.LEFT else false
		
	position = Vector2.ZERO
	rotation = 0
