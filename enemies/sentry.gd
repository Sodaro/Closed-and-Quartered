extends CharacterBody2D
class_name Sentry
@export var weapon: RangedWeapon

var blood_scene: PackedScene = load("res://effects/blood_splat.tscn")

var _reaction_time: float = 0.2
var _rotation_speed: float = 360

var health: float = 1.0
var is_fragile: bool = false

var _hit_response_component: HitResponseComponent

func _ready() -> void:	
	$HealthComponent.health_depleted.connect(_handle_health_depleted)
	
	_hit_response_component = HitResponseComponent.new()
	add_child(_hit_response_component)
	
	_hit_response_component.hit_event.connect(_handle_hit)
	weapon.pick_up_weapon(self, $FrontAttach, $LeftAttach, $RightAttach)

func _handle_hit(hit_position: Vector2, direction: Vector2, damage: float) -> void:
	for i in range(randi_range(3, 6)):
		var instance = blood_scene.instantiate()
		instance.move_dir = direction
		instance.speed = randf_range(1000, 2000)
		instance.global_position = hit_position
		Helpers.LEVEL_ROOT_NODE.add_child(instance)
	$HealthComponent.damage_health(damage)

func _handle_health_depleted() -> void:
	weapon.drop_weapon()
	queue_free()
		
func _process(delta: float) -> void:
	if !$PlayerDetectionComponent.has_detected_player || Helpers.get_time_since($PlayerDetectionComponent.time_spotted_player) < _reaction_time:
		return
	
	var player_pos: Vector2 = Helpers.PLAYER.global_position
	var to_player: Vector2 = player_pos - global_position
	var angle_to_player: float = rad_to_deg(global_transform.x.angle_to(to_player))
	rotate(sign(angle_to_player) * deg_to_rad(_rotation_speed) * delta)
	if abs(angle_to_player) < 15:
		if !weapon.can_use_weapon():
			return
		weapon.use_weapon()
