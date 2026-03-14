extends VBoxContainer
class_name SoundOptions

func _ready() -> void:
	$MasterSlider.set_value_no_signal(AudioManager.get_master_volume())
	$SFXSlider.set_value_no_signal(AudioManager.get_sfx_volume())
	$MusicSlider.set_value_no_signal(AudioManager.get_music_volume())

func _on_master_slider_value_changed(value: float) -> void:
	AudioManager.set_master_volume(value)

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioManager.set_sfx_volume(value)

func _on_music_slider_value_changed(value: float) -> void:
	AudioManager.set_music_volume(value)
