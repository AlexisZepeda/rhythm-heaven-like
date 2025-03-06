extends BaseNote

class_name RedNote


@onready var test_attack_input = GameManager.inputs[1]


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
