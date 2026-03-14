extends CharacterBody2D

var shoot_range: float = 1000.0
var max_angle: float = 75

var range_squared: float

func _ready() -> void:
	range_squared = shoot_range * shoot_range

func handle_hit(hit_position: Vector2, direction: Vector2, damage: float) -> void:
	$Handgun.drop_weapon()
	queue_free()
	
func _physics_process(_delta: float) -> void:
	var player_pos: Vector2 = Globals.player.global_position
	var to_player: Vector2 = player_pos - global_position
	if to_player.length_squared() > range_squared:
		return
		
	var angle_to_player: float = transform.x.angle_to(to_player)
	if angle_to_player > max_angle || angle_to_player < -max_angle:
		return
		
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters2D.create(global_position, player_pos)
	var result = space_state.intersect_ray(query)
	if result:
		print(result.collider)
	
