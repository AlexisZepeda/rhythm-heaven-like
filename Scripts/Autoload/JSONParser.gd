extends Node


var raw_data = {}
var notes = {}
var notes_array = []
var midi_bpm = 0
var time_accuracy = 0.00001
var data_file_path = ""
var size = 0
var shortest_duration: float = 0
var shortest_duration_array = []


func _ready():
	set_json_path("res://JSON/VisiPiano.json")


func set_json_path(filePath : String):
	if raw_data != null:
		raw_data = {}
		notes = {}
		size = 0
	
	data_file_path = filePath
	raw_data = load_json_file(data_file_path)
	shortest_duration = _find_shortest_duration(raw_data)
	load_note_on(raw_data)


func load_json_file(file_path : String):
	if FileAccess.file_exists(file_path):
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var parsed_result = JSON.parse_string(data_file.get_as_text())
		
		if parsed_result is Dictionary:
			return parsed_result
		else:
			print("Error loading file")
	
	else:
		print("File doesn't exist")


func load_note_on(json_file):
	for header in json_file["tempo"]:
		
		var temp = str(header["bpm"])
		var a = temp.substr(temp.find("."))
		if float(a) >= 0.5:
			midi_bpm = ceil(float(header["bpm"]))
		elif float(a) <= .5: 
			midi_bpm = floor(float(header["bpm"]))
		else:
			midi_bpm = int(header["bpm"])
	
	for track in json_file["tracks"]:
		for note in track["notes"]:
			add_note_to_main_array(note)


func _find_shortest_duration(json_file) -> float:
	for track in json_file["tracks"]:
		for note in track["notes"]:
			shortest_duration_array.append(float(snapped(note["duration"], time_accuracy)))
	
	return shortest_duration_array.min()


func add_note_to_main_array(note):
	var time = str(snapped(note["time"], time_accuracy))
	var is_long_note: int = 0
	
	# sec_per_beat must be the same as in Metronome.gd
	var sec_per_beat = (60.0 / midi_bpm) * 4.0 / 16
	var time_in_beats = ceil(float(note["time"]) / sec_per_beat + 0)
	
	var duration = str(snapped(note["duration"], time_accuracy))
	var duration_in_beats = snapped(float(note["duration"]) / sec_per_beat + 0, 1) # Original was ceiling
	var total_length = 0.0
	# If duration is equal to the shortest duration in the MIDI, then it is a Tap Note
	# Else it is a Long Note and add 1 to size for the back note
	if duration_in_beats == 1:
		total_length = str(float(time) + float(duration))
	else:
		total_length = str(float(time) + (float(duration) - sec_per_beat)) # shortest duration
		is_long_note = 1
		size += 1
	
	notes_array.append(time_in_beats)
	
	if !notes.has(time_in_beats):
		notes[time_in_beats] = []
	
	notes[time_in_beats].append([note["midi"], duration_in_beats, note["name"], time, total_length, duration, is_long_note])
	if is_long_note == 1:
		var long_note_end_time = time_in_beats + duration_in_beats
		notes[long_note_end_time-1] = [[note["midi"], 1, note["name"], total_length, shortest_duration, duration, 2]]
	
	size += 1
