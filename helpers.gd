class_name Helpers

const MAX_FLT:float = 1.79769e308
static var LEVEL_ROOT_NODE: Node2D
static var PLAYER: PlayerCharacter

static func get_time_seconds() -> float:
	return Time.get_ticks_msec() * 0.001

static func get_time_since(time_seconds: float) -> float:
	return get_time_seconds() - time_seconds

static func clamp01(value: float) -> float:
	return clampf(value, 0.0, 1.0)

static func get_global_mouse_position(viewport: Viewport) -> Vector2:
	if (viewport.get_camera_2d() == null):
		return Vector2.ZERO
	return viewport.get_camera_2d().get_global_mouse_position()
