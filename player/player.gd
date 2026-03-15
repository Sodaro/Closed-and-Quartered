extends CharacterBody2D
class_name PlayerCharacter

var blood_scene: PackedScene = load("res://effects/blood_splat.tscn")

var speed: float = 500.0
var look_dir: Vector2

var weapon: WeaponBase

var has_collected_collectible: bool

var health: float = 1.0
var is_fragile: bool = false
var is_dead: bool = false

signal player_died

func _ready() -> void:
	look_dir = Vector2.RIGHT
	$HitResponseComponent.hit_event.connect(_handle_hit)
	$HealthComponent.health_depleted.connect(_handle_health_depleted)
	
func _handle_hit(hit_position: Vector2, direction: Vector2, damage: float):
	for i in range(randi_range(3, 6)):
		var instance = blood_scene.instantiate()
		instance.move_dir = direction
		instance.speed = randf_range(1000, 2000)
		instance.global_position = hit_position
		Helpers.LEVEL_ROOT_NODE.add_child(instance)
	$HealthComponent.damage_health(damage)
	
func _handle_health_depleted() -> void:
	player_died.emit()
	
func handle_pickups() -> void:
	var closest_pickup: PickupComponent
	var closest_dist: float = Helpers.MAX_FLT
	var all_pickups: Array = (ComponentManager.get_all_components_of_type(PickupComponent)) 
	for pickup in all_pickups:
		if pickup.get_parent() == weapon:
			continue
		var temp_weapon: WeaponBase = pickup.get_parent() as WeaponBase
		if temp_weapon != null && temp_weapon.weapon_owner != null:
			continue
			
		var dist: float = (pickup.global_position - global_position).length_squared()
		if dist >= closest_dist || dist >= pickup.squared_pickup_radius():
			pickup.hide_pickup_text()
			continue
		closest_pickup = pickup
		closest_dist = dist
	
	if closest_pickup == null:
		return
		
	closest_pickup.show_pickup_text()
	if (!Input.is_action_just_pressed("interact")):
		return
		
	closest_pickup.handle_picked_up()
	var new_weapon: WeaponBase = closest_pickup.get_parent() as WeaponBase
	if new_weapon != null:
		if weapon != null:
			weapon.drop_weapon()
		weapon = new_weapon
		weapon.pick_up_weapon(self, $FrontAttach, $LeftAttach, $RightAttach)
	
	var collectible: LevelCollectible = closest_pickup.get_parent() as LevelCollectible
	if collectible != null:
		has_collected_collectible = true
		
func handle_use_weapon() -> void:
	if weapon == null:
		return
		
	if !weapon.can_use_weapon():
		return
	
	var should_use: bool = false
	match (weapon.repeat_type):
		WeaponBase.WeaponRepeatType.AUTO:
			should_use = Input.is_action_pressed("use_weapon")
		WeaponBase.WeaponRepeatType.SEMIAUTO:
			should_use = Input.is_action_just_pressed("use_weapon")
	
	if !should_use:
		return
		
	weapon.use_weapon()
	
func handle_throw_weapon() -> void:
	if weapon == null:
		return
	
	if !Input.is_action_just_pressed("throw_weapon"):
		return
	
	weapon.throw_weapon()
	weapon = null

func _process(delta: float) -> void:
	if Helpers.PLAYER_CAMERA.has_look_position_override:
		return
	handle_pickups()
	handle_use_weapon()
	handle_throw_weapon()
	var up: float = Input.get_axis("down","up")
	var right: float = Input.get_axis("left","right")
	var move_dir: Vector2 = (Vector2.RIGHT * right + Vector2.UP * up).normalized()
	
	var mouse_pos: Vector2 = Helpers.get_global_mouse_position(get_viewport())
	var to_mouse: Vector2 = mouse_pos - global_position
	if !to_mouse.is_zero_approx():
		look_dir = (mouse_pos - global_position).normalized()
		
	global_rotation = Vector2.RIGHT.angle_to(look_dir)
	velocity = move_dir * speed
	move_and_slide()
