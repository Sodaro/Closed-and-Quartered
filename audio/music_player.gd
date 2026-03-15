extends AudioStreamPlayer
class_name MusicPlayer

func play_song(song: AudioStream) -> void:
	if stream == song:
		return
	stream = song
	play()
