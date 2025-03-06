extends Sprite2D


class_name Portal

var tween: Tween


func _ready():
	GameManager.QUARTER_NOTE_EMITTED.connect(_on_half_note_emitted)


func _on_half_note_emitted():
	if tween and tween.is_running():
		tween.kill()
	
	tween = get_tree().create_tween()
	var initial_scale: Vector2 = self.scale
	
	tween.tween_property(self, "scale", self.scale - Vector2(0.15, 0.15), JsonParser.shortest_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", initial_scale, JsonParser.shortest_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
