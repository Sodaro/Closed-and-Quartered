extends CharacterBody2D
class_name Sentry
@export var weapon: RangedWeapon

var _reaction_time: float = 0.5
var _rotation_speed: float = 90

var health: float = 1.0
var is_fragile: bool = false

var _health_component: HealthComponent
var _hit_response_component: HitResponseComponent
var _detection_component: PlayerDetectionComponent

func _ready() -> void:
	_health_component = HealthComponent.new()
	_health_component.health_depleted.connect(_handle_health_depleted)
	add_child(_health_component)
	
	_hit_response_component = HitResponseComponent.new()
	add_child(_hit_response_component)
	
	_detection_component = PlayerDetectionComponent.new()
	add_child(_detection_component)
	
	_hit_response_component.hit_event.connect(_handle_hit)
	weapon.pick_up_weapon(self, $FrontAttach, $LeftAttach, $RightAttach)

func _handle_hit(hit_position: Vector2, direction: Vector2, damage: float) -> void:
	_health_component.damage_health(damage)

func _handle_health_depleted() -> void:
	weapon.drop_weapon()
	queue_free()
		
func _process(delta: float) -> void:
	if !_detection_component.has_detected_player || Helpers.get_time_since(_detection_component.time_spotted_player) < _reaction_time:
		return
	
	var player_pos: Vector2 = Helpers.PLAYER.global_position
	var to_player: Vector2 = player_pos - global_position
	var angle_to_player: float = rad_to_deg(transform.x.angle_to(to_player))
	rotate(sign(angle_to_player) * deg_to_rad(_rotation_speed) * delta)
	if angle_to_player < rad_to_deg(15):
		if !weapon.can_use_weapon():
			return
		weapon.use_weapon()
