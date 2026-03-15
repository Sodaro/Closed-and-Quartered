extends AudioStreamPlayer2D
class_name AudioOneShot

static var audio_one_shot_scene: PackedScene = load("res://audio/audio_one_shot.tscn")

var lifetime: float

func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0:
		queue_free()

static func play_sound(audio_stream: AudioStream, location: Vector2, attach_node: Node) -> void:
	var instance: AudioOneShot = audio_one_shot_scene.instantiate()
	attach_node.add_child(instance)
	instance.global_position = location
	instance.stream = audio_stream
	instance.lifetime = instance.stream.get_length()
	instance.play()
