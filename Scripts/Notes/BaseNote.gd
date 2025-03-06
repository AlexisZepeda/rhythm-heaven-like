extends Node


class_name BaseNote

@export var enemy: Enemy

var SPAWN_X: float = 500 # Change to CONST
const TARGET_X: float = 150

enum STATE { NONE, HIT, MISS, BAD }

var expected_time: float
var created_time: float
var total_length: float = 0
var destroy_position_x: float = 30.0
var beat_of_note
var duration: float
var duration_in_beats
var lane: String
var note_type: GameManager.NOTE_TYPES

var note_state: STATE

var critical_timing_window: float = 3.0 / 60 # 3 frames measured in 60fps
var great_timing_window: float = 6.0 / 60 # 6 frames measured in 60fps
var good_timing_window: float = 7.0 / 60 # 7 frames measured in 60fps
var bad_timing_window: float = 8.0 / 60 # 8 frames measured in 60fps

var metronome: Metronome


func initialize():
	note_state = STATE.NONE
	self.global_position.x = SPAWN_X
	self.global_position.y = 300 - 32


func test_critical_hit(_time: float, _input: String) -> bool:
	return true


func test_great_hit(_time: float, _input: String) -> bool:
	return true


func test_good_hit(_time: float, _input: String) -> bool:
	return true


func test_bad_hit(_time: float, _input: String) -> bool:
	return true


func test_miss(time: float) -> bool:
	if time > expected_time + 0.2:
		return true
	return false


func hit(position_to_freeze: Vector2) -> void:
	note_state = STATE.HIT
	self.global_position = position_to_freeze


func bad() -> void:
	note_state = STATE.BAD


func miss() -> void:
	note_state = STATE.MISS


func get_state() -> STATE:
	return note_state


func delete():
	if note_state == STATE.HIT:
		enemy.hurt()
		await enemy.HURT_FINISHED
	
	self.queue_free()


func _process(_delta):
	match note_state:
		STATE.HIT:
			delete()
		STATE.BAD:
			delete()
		STATE.MISS:
			if self.global_position.x < destroy_position_x:
				delete()
	
	if is_instance_valid(metronome):
		var t = ((1.0 - (expected_time - metronome.song_position)) / 1.0)
		if t < 0:
			return
		if note_state == STATE.HIT:
			return
		self.position.x = lerp(SPAWN_X, TARGET_X, t)
