extends Node

class_name GameScreen

@export var metronome: AudioStreamPlayer
@export var player: Mob

var notes_json: Dictionary

@onready var tap_note_queue := []


func _ready():
	if notes_json != null:
		notes_json = JsonParser.notes
	GameManager.BEAT_EMITTED.connect(_on_beat_emitted)
	metronome.play_with_beat_offset(16)


func _input(event):
	if event is InputEventKey and event.pressed:
		if not tap_note_queue.is_empty():
			tap_note_hit_input()


func tap_note_hit_input():
	if Input.is_action_just_pressed("ui_select"):
		test_hit_timing(tap_note_queue)


func test_hit_timing(queue):
	var front_note = queue.front()
	
	# Good Timing
	if front_note.test_good_hit(metronome.song_position):
		queue.pop_front().hit(player.position)
		player.attack()
		return

	# Great Timing
	elif front_note.test_great_hit(metronome.song_position):
		queue.pop_front().hit(player.position)
		player.attack()
		return

	# Critical 
	elif front_note.test_critical_hit(metronome.song_position):
		queue.pop_front().hit(player.position)
		player.attack()
		return

	# Bad Timing
	elif front_note.test_bad_hit(metronome.song_position):
		queue.pop_front().bad()
		return


func _on_beat_emitted(beat, song_position):
	play_notes(notes_json, beat, song_position)


func play_notes(notes, beat, song_position):
	if notes.has(float(beat)):
		for note in notes[float(beat)]:
			var note_type = "tap"
			
			var instance = create_note(float(note[3]), song_position, beat, "tap")
			print(instance)
			tap_note_queue.push_back(instance)


func create_note(expected_time, created_time, beat_of_note, note_type) -> BaseNote:
	var instance = null
	if note_type == "tap":
		instance = preload("res://Scenes/Tap_Note.tscn").instantiate()
		add_child(instance)
		
		_add_info_notes(instance, expected_time, created_time, beat_of_note, note_type)
		
	return instance


func _add_info_notes(instance, expected_time, created_time, beat_of_note, note_type):
	instance.expected_time = expected_time
	instance.created_time = created_time
	instance.beat_of_note = beat_of_note
	instance.note_type = note_type
	instance.metronome = metronome
	instance.initialize()
