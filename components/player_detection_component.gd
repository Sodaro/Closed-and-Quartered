extends ComponentBase
class_name PlayerDetectionComponent

@export var max_angle: float = 75
@export var sight_detection_range: float = 400
@export var proximity_detection_range: float = 64
var sight_range_squared: float
var proximity_range_squared: float
var time_spotted_player: float
var has_detected_player: bool
var can_see_player: bool
var can_hear_player: bool

func _ready() -> void:
	super._ready()
	proximity_range_squared = proximity_detection_range * proximity_detection_range
	sight_range_squared = sight_detection_range * sight_detection_range
	
func _can_see_player() -> bool:
	var player_pos: Vector2 = Helpers.PLAYER.global_position
	var to_player: Vector2 = player_pos - global_position
	var dist: float = to_player.length_squared()
	if dist > sight_range_squared:
		return false
	var angle_to_player: float = rad_to_deg(global_transform.x.angle_to(to_player))
	if angle_to_player > max_angle || angle_to_player < -max_angle:
		return false
		
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, player_pos)
	query.collision_mask = 1
	var result = space_state.intersect_ray(query)
	if !result:
		return false
		
	return result.collider is PlayerCharacter
	
func _can_hear_player() -> bool:
	var player_pos: Vector2 = Helpers.PLAYER.global_position
	var to_player: Vector2 = player_pos - global_position
	if to_player.length_squared() > proximity_range_squared:
		return false
	return true
	
func _physics_process(_delta: float) -> void:
	can_see_player = _can_see_player()
	can_hear_player = _can_hear_player()
	var had_detected_player: bool = has_detected_player
	has_detected_player = can_see_player || can_hear_player
	if has_detected_player && !had_detected_player:
		time_spotted_player = Helpers.get_time_seconds()
