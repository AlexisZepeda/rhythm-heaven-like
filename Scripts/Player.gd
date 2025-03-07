extends Mob

class_name Player

var tween: Tween


func attack(note_type: GameManager.NOTE_TYPES):
	match note_type:
		GameManager.NOTE_TYPES.TYPE_A:
			animation_sprite.play("Attack1")
		GameManager.NOTE_TYPES.TYPE_B:
			animation_sprite.play("Attack2")
		GameManager.NOTE_TYPES.TYPE_C:
			animation_sprite.play("Attack3")
	await animation_sprite.animation_finished
	animation_sprite.play("Idle")


func hurt():
	animation_sprite.play("Hurt")
	animation_player.play("Flash")
	await animation_sprite.animation_finished
	animation_sprite.play("Idle")


func animate_tween_on_beat():
	if tween and tween.is_running():
		tween.kill()
	
	tween = get_tree().create_tween()
	var initial_scale: Vector2 = self.scale
	tween.tween_property(self, "scale:y", self.scale.y - 0.20, JsonParser.shortest_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale:y", initial_scale.y, JsonParser.shortest_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)


func _on_whole_note_emitted():
	animate_tween_on_beat()
