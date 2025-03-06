extends Mob

class_name Enemy

signal HURT_FINISHED

var tween: Tween


func hurt():
	tween = get_tree().create_tween()
	tween.tween_property(self, "position:y", 350, 2)
	
	await tween.finished
	
	HURT_FINISHED.emit()
