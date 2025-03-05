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


func _process(_delta):
	if not tap_note_queue.is_empty():
		if tap_note_queue.front().test_miss(metronome.song_position):
			miss_timing(tap_note_queue)


func _input(event):
	if event is InputEventKey and event.pressed:
		if not tap_note_queue.is_empty():
			tap_note_hit_input()


func tap_note_hit_input():
	if Input.is_action_just_pressed("Attack"):
		test_hit_timing(tap_note_queue, GameManager.inputs[0])
	elif Input.is_action_just_pressed("Attack2"):
		test_hit_timing(tap_note_queue, GameManager.inputs[1])
	elif Input.is_action_just_pressed("Attack3"):
		test_hit_timing(tap_note_queue, GameManager.inputs[2])


func test_hit_timing(queue, input):
	var front_note = queue.front()
	
	# Good Timing
	if front_note.test_good_hit(metronome.song_position, input):
		queue.pop_front().hit(player.position)
		player.attack(front_note.note_type)
		return

	# Great Timing
	elif front_note.test_great_hit(metronome.song_position, input):
		queue.pop_front().hit(player.position)
		player.attack(front_note.note_type)
		return

	# Critical 
	elif front_note.test_critical_hit(metronome.song_position, input):
		queue.pop_front().hit(player.position)
		player.attack(front_note.note_type)
		return

	# Bad Timing
	elif front_note.test_bad_hit(metronome.song_position, input):
		queue.pop_front().bad()
		player.hurt()
		return


func miss_timing(queue):
	queue.pop_front().miss()
	player.hurt()


func _on_beat_emitted(beat, song_position):
	play_notes(notes_json, beat, song_position)


func play_notes(notes, beat, song_position):
	if notes.has(float(beat)):
		for note in notes[float(beat)]:
			var note_type = GameManager.NOTE_TYPES.TYPE_A
			var lane = note[2]
			note_type = create_note_type(lane, note_type)
			
			var instance = create_note(float(note[3]), song_position, beat, note_type)
			tap_note_queue.push_back(instance)


func create_note_type(lane, note_type):
	if lane == "C3":
		note_type = GameManager.NOTE_TYPES.TYPE_A
	elif lane == "D3":
		note_type = GameManager.NOTE_TYPES.TYPE_B
	elif lane == "E3":
		note_type = GameManager.NOTE_TYPES.TYPE_C
	
	return note_type


func create_note(expected_time, created_time, beat_of_note, note_type) -> BaseNote:
	var instance = null
	if note_type == GameManager.NOTE_TYPES.TYPE_A:
		instance = preload("res://Scenes/Notes/Tap_Note.tscn").instantiate()
		add_child(instance)
		_add_info_notes(instance, expected_time, created_time, beat_of_note, note_type)
	
	if note_type == GameManager.NOTE_TYPES.TYPE_B:
		instance = preload("res://Scenes/Notes/Red_Note.tscn").instantiate()
		add_child(instance)
		
		_add_info_notes(instance, expected_time, created_time, beat_of_note, note_type)
	
	if note_type == GameManager.NOTE_TYPES.TYPE_C:
		instance = preload("res://Scenes/Notes/Green_Note.tscn").instantiate()
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
