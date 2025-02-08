extends Panel

var record_bus_index: int

@onready var volume_bar: ProgressBar = $VolumeBar
@onready var gain_slider: HSlider = $GainSlider
@onready var mic_input: AudioStreamPlayer = %MicInput
@onready var gain_label: Label = $GainLabel

@export var min_db := -60.0   # Minimum gain at 0% slider
@export var max_db := 24.0    # Maximum gain at 100% slider

var slope: float

func _ready() -> void:
	record_bus_index = AudioServer.get_bus_index("Record")
	slope = (max_db - min_db) / 100
	_on_gain_slider_drag_ended(false)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var sample = AudioServer.get_bus_peak_volume_left_db(record_bus_index, 0)
	var linear_sample = db_to_linear(sample) * 100
	
	volume_bar.value = linear_sample

func _on_gain_slider_drag_ended(value_changed: bool) -> void:
	var gain_db = (linear_to_db(gain_slider.value/100)+5)*6
	mic_input.volume_db = gain_db
	gain_label.text = "Gain (%d db)" % gain_db
