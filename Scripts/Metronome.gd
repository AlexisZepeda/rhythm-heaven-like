extends AudioStreamPlayer


class_name Metronome

@onready var start_timer = $Timer


# Tracking the beat and song position
var song_position = 0.0
var song_position_in_beats = 0
var sec_per_beat = 60.0 / JsonParser.midi_bpm
var sec_per_bar = 60.0 / JsonParser.midi_bpm
var beats_per_bar = 16
var last_reported_beat = 0
var beats_before_start = 0


func _ready():
	sec_per_beat = (60.0 / JsonParser.midi_bpm) * 4.0 / beats_per_bar


func _physics_process(_delta):
	if playing:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		song_position_in_beats = int(floor((song_position / sec_per_beat))) + beats_before_start
		_report_beat()


func _report_beat():
	if last_reported_beat < song_position_in_beats:
		GameManager.BEAT_EMITTED.emit(song_position_in_beats, song_position)
		if song_position_in_beats % 16 == 0:
			GameManager.WHOLE_NOTE_EMITTED.emit()
		if song_position_in_beats % 8 == 1:
			GameManager.HALF_NOTE_EMITTED.emit()
		if song_position_in_beats % 4 == 1:
			GameManager.QUARTER_NOTE_EMITTED.emit()
		last_reported_beat = song_position_in_beats


func play_with_beat_offset(num):
	beats_before_start = num
	start_timer.wait_time = sec_per_beat
	start_timer.start()


func play_from_beat(beat, offset):
	play()
	seek(beat * sec_per_beat)
	beats_before_start = offset


func _on_start_timer_timeout():
	song_position_in_beats += 1
	if song_position_in_beats < beats_before_start - 1:
		start_timer.start()
	elif song_position_in_beats == beats_before_start - 1:
		start_timer.wait_time = start_timer.wait_time - (AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency())
		start_timer.start()
	else:
		play()
		start_timer.stop()
	_report_beat()
