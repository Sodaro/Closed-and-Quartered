extends CharacterBody2D

@export var movement_speed: float = 100.0

func _ready() -> void:
	$NavigationAgent2D.velocity_computed.connect(Callable(_on_velocity_computed))

func set_movement_target(movement_target: Vector2):
		$NavigationAgent2D.set_target_position(movement_target)

func _physics_process(delta):
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer2D.map_get_iteration_id(	$NavigationAgent2D.get_navigation_map()) == 0:
		return
	if 	$NavigationAgent2D.is_navigation_finished():
		return

	var next_path_position: Vector2 = 	$NavigationAgent2D.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to(next_path_position) * movement_speed
	if 	$NavigationAgent2D.avoidance_enabled:
			$NavigationAgent2D.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	move_and_slide()


func _process(delta: float) -> void:
