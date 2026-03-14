extends CharacterBody2D
class_name Sentry
@export var weapon: RangedWeapon

var _shoot_range: float = 400.0
var _max_angle: float = 75

var _range_squared: float

var _can_see_player: bool
var _time_spotted_player: float

var _reaction_time: float = 0.5
var _rotation_speed: float = 90

var health: float = 1.0
var is_fragile: bool = false

var _health_component: HealthComponent
var _hit_response_component: HitResponseComponent

func _ready() -> void:
	_health_component = HealthComponent.new()
	add_child(_health_component)
	_health_component.health_depleted.connect(_handle_health_depleted)
	_hit_response_component = HitResponseComponent.new()
	add_child(_hit_response_component)
	_hit_response_component.hit_event.connect(_handle_hit)
	weapon.pick_up_weapon(self)
	_range_squared = _shoot_range * _shoot_range

func _handle_hit(hit_position: Vector2, direction: Vector2, damage: float) -> void:
	_health_component.damage_health(damage)

func _handle_health_depleted() -> void:
	$Handgun.drop_weapon()
	queue_free()

func _physics_process(_delta: float) -> void:
	var player_pos: Vector2 = Helpers.PLAYER.global_position
	var to_player: Vector2 = player_pos - global_position
	if to_player.length_squared() > _range_squared:
		_can_see_player = false
		return
		
	var angle_to_player: float = rad_to_deg(transform.x.angle_to(to_player))
	if angle_to_player > _max_angle || angle_to_player < -_max_angle:
		_can_see_player = false
		return
		
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, player_pos)
	query.collision_mask = 1
	var result = space_state.intersect_ray(query)
	if result:
		var could_see_player: bool = _can_see_player
		_can_see_player = result.collider is PlayerCharacter
		if _can_see_player && !could_see_player:
			_time_spotted_player = Helpers.get_time_seconds()
		
func _process(delta: float) -> void:
	if !_can_see_player || Helpers.get_time_since(_time_spotted_player) < _reaction_time:
		return
	
	var player_pos: Vector2 = Helpers.PLAYER.global_position
	var to_player: Vector2 = player_pos - global_position
	var angle_to_player: float = rad_to_deg(transform.x.angle_to(to_player))
	rotate(sign(angle_to_player) * deg_to_rad(_rotation_speed) * delta)
	if angle_to_player < rad_to_deg(15):
		if !weapon.can_use_weapon():
			return
		weapon.use_weapon()
