extends BaseNote

class_name GreenNote

@onready var test_attack_input = GameManager.inputs[2]


func test_critical_hit(time: float, input: String) -> bool:
	if test_attack_input == input:
		if abs(expected_time - time) < critical_timing_window:
			return true
	return false


func test_great_hit(time: float, input: String) -> bool:
	if test_attack_input == input:
		if abs(expected_time - time) > critical_timing_window and abs(expected_time - time) < great_timing_window:
			return true
	return false


func test_good_hit(time: float, input: String) -> bool:
	if test_attack_input == input:
		if abs(expected_time - time) > great_timing_window and abs(expected_time - time) < good_timing_window:
			return true
	return false


func test_bad_hit(time: float, input: String) -> bool:
	if test_attack_input == input:
		if abs(expected_time - time) > bad_timing_window:
			return false
		if abs(expected_time - time) > good_timing_window and abs(expected_time - time) < bad_timing_window:
			return true
	return false


func _process(_delta):
	match note_state:
		STATE.HIT:
			delete()
		STATE.BAD:
			delete()
		STATE.MISS:
			if self.global_position.x < 30.0:
				delete()
	
	if is_instance_valid(metronome):
		var t = ((1.0 - (expected_time - metronome.song_position)) / 1.0)
		self.position.x = lerp(SPAWN_X, TARGET_X, t)
