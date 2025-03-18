extends PanelContainer

class_name Heart

@export var heart_sprite: Sprite2D

var tween: Tween


func _ready():
	GameManager.HALF_NOTE_EMITTED.connect(_on_half_note_emitted)


func _on_half_note_emitted():
	if tween and tween.is_running():
		tween.kill()
	
	tween = get_tree().create_tween()
	
	var initial_position = self.position
	tween.tween_property(heart_sprite, "position:y", heart_sprite.position.y - 5, JsonParser.shortest_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(heart_sprite, "position:y", initial_position.y, JsonParser.shortest_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.bind_node(self)
