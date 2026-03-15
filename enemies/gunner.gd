extends CharacterBody2D

var blood_scene: PackedScene = load("res://effects/blood_splat.tscn")

@export var movement_speed: float = 300.0
@export var weapon: RangedWeapon
@export var attack_range: float = 400
var _reaction_time: float = 0.25
var _shoot_reaction_time: float = 0.1
var _time_in_range: float

var attack_range_sq: float

var chasing_player: bool

func _ready() -> void:
	attack_range_sq = attack_range * attack_range
	$NavigationAgent2D.max_speed = movement_speed
	$NavigationAgent2D.velocity_computed.connect(Callable(_on_velocity_computed))
	weapon.call_deferred("pick_up_weapon", self, $FrontAttach, $LeftAttach, $RightAttach)

func set_movement_target(movement_target: Vector2):
		$NavigationAgent2D.set_target_position(movement_target)

func _physics_process(delta):
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer2D.map_get_iteration_id(	$NavigationAgent2D.get_navigation_map()) == 0:
		return
	if 	$NavigationAgent2D.is_navigation_finished():
		return

	var next_path_position: Vector2 = $NavigationAgent2D.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to(next_path_position) * movement_speed
	if 	$NavigationAgent2D.avoidance_enabled:
			$NavigationAgent2D.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	if velocity.is_zero_approx():
		return
	rotation = velocity.angle()
	move_and_slide()


func _process(delta: float) -> void:
	if is_queued_for_deletion():
		return
	if !chasing_player:
		if !$PlayerDetectionComponent.has_detected_player || Helpers.get_time_since($PlayerDetectionComponent.time_spotted_player) < _reaction_time:
			return
		
	chasing_player = true
	set_movement_target(Helpers.PLAYER.global_position)
	if global_position.distance_squared_to(Helpers.PLAYER.global_position) < attack_range_sq && $PlayerDetectionComponent.can_see_player:
		_time_in_range += delta
		if _time_in_range >= _shoot_reaction_time && weapon.can_use_weapon():
			weapon.use_weapon()
	else:
		_time_in_range = 0

func _on_hit_response_component_hit_event(hit_position: Vector2, direction: Vector2, damage: float) -> void:
	for i in range(randi_range(3, 6)):
		var instance = blood_scene.instantiate()
		instance.move_dir = direction
		instance.speed = randf_range(1000, 2000)
		instance.global_position = hit_position
		Helpers.LEVEL_ROOT_NODE.add_child(instance)
	$HealthComponent.damage_health(damage)
	chasing_player = true


func _on_health_component_health_depleted() -> void:
	weapon.drop_weapon()
	queue_free()
