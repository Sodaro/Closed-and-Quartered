extends ColorRect

var _start_time: float
var _wipe_active: bool
var _wipe_in: bool

var _wipe_start_position: Vector2
var _wipe_end_position: Vector2

var _wipe_duration: float = 0.5
var _wipe_finish_time: float

signal wipe_in_finished
signal wipe_out_finished

func start_wipe_in(duration: float, end_idle_duration: float) -> void:
	_wipe_active = true
	_start_time = Helpers.get_time_seconds()
	_wipe_in = true
	_wipe_start_position = Vector2(0, -360)
	_wipe_end_position = Vector2.ZERO
	_wipe_duration = duration
	_wipe_finish_time = _start_time + duration + end_idle_duration
	
func start_wipe_out(duration: float, end_idle_duration: float) -> void:
	_wipe_active = true
	_start_time = Helpers.get_time_seconds()
	_wipe_in = false
	_wipe_start_position = Vector2(0, 0)
	_wipe_end_position = Vector2(0, 360)
	_wipe_duration = duration
	_wipe_finish_time = _start_time + duration + end_idle_duration

func _wipe_in_finished() -> void:
	_wipe_in = false
	_wipe_active = false
	wipe_in_finished.emit()
	
func _wipe_out_finished() -> void:
	_wipe_active = false
	wipe_out_finished.emit()

func _process(_delta: float) -> void:
	if !_wipe_active:
		return
	
	var time: float = Helpers.get_time_seconds()
	var alpha: float = Helpers.clamp01((time - _start_time) / _wipe_duration)
	position = lerp(_wipe_start_position, _wipe_end_position, alpha)
	if time >= _wipe_finish_time:
		if _wipe_in:
			_wipe_in_finished()
		else:
			_wipe_out_finished()
			
