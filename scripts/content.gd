extends Panel

var record_effect: AudioEffectRecord
var recording: AudioStream

@onready var record_button: Button = $RecordButton
@onready var play_button: Button = $PlayButton
@onready var output: AudioStreamPlayer = $Output
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var music_button: Button = $MusicButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var record_bus_index: int = AudioServer.get_bus_index('Record')
	record_effect = AudioServer.get_bus_effect(record_bus_index, 0)

func start_recording() -> void:
	record_effect.set_recording_active(true)
	record_button.text = 'Stop'
	play_button.disabled = true
	
func stop_recording() -> void:
	record_effect.set_recording_active(false)
	record_button.text = 'Record'
	recording = record_effect.get_recording()
	play_button.disabled = false
	print('Recording saved.')
	print(recording.data.size())


func _on_record_button_pressed() -> void:
	if record_effect.is_recording_active():
		stop_recording()
	else:
		start_recording()

func _on_play_button_pressed() -> void:
	if not recording:
		return

	output.stream = recording
	output.play()
	play_button.disabled = true

func _on_music_button_pressed() -> void:
	if music_player.playing:
		music_player.stop()
		music_button.text = 'Play Music'
	else:
		music_player.play()
		music_button.text = 'Stop'

func _on_output_finished() -> void:
	play_button.disabled = false
