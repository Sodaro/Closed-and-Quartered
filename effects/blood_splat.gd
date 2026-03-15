extends Sprite2D

var move_dir: Vector2
var speed: float
var _velocity: Vector2

func _ready() -> void:
	speed *= 0.5
	_velocity = move_dir * speed

func _process(delta: float) -> void:
	rotation = _velocity.angle()
	var move_delta = _velocity * delta
	global_position += move_delta
	
	_velocity = lerp(_velocity, Vector2.ZERO, 10 * delta)
	if _velocity.is_zero_approx():
		process_mode = Node.PROCESS_MODE_DISABLED
	
