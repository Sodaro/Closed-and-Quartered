extends VBoxContainer
class_name SoundOptions

func _ready() -> void:
	$MasterSlider.set_value_no_signal(AudioManager.get_master_volume())
	$SFXSlider.set_value_no_signal(AudioManager.get_sfx_volume())
	$MusicSlider.set_value_no_signal(AudioManager.get_music_volume())
	AudioManager.master_volume_changed.connect(_handle_master_volume_changed)
	AudioManager.music_volume_changed.connect(_handle_music_volume_changed)
	AudioManager.sfx_volume_changed.connect(_handle_sfx_volume_changed)

func _handle_master_volume_changed(normalized_value: float) -> void:
	$MasterSlider.set_value_no_signal(normalized_value)
	
func _handle_music_volume_changed(normalized_value: float) -> void:
	$MusicSlider.set_value_no_signal(normalized_value)
	
func _handle_sfx_volume_changed(normalized_value: float) -> void:
	$SFXSlider.set_value_no_signal(normalized_value)

func _on_master_slider_value_changed(value: float) -> void:
	AudioManager.set_master_volume(value)

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioManager.set_sfx_volume(value)
	$SFXTester.play()

func _on_music_slider_value_changed(value: float) -> void:
	AudioManager.set_music_volume(value)
