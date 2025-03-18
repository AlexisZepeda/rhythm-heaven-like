extends Mob

class_name Player

var tween: Tween
var max_health: int = 1
var current_health: int:
	set(value):
		current_health = value
		if current_health == max_health:
			GameManager.CREATE_HEALTH.emit(current_health)
		elif current_health == 0:
			GameManager.LOST_HEALTH.emit()
			GameManager.GAME_OVER.emit()
		else:
			GameManager.LOST_HEALTH.emit()


func _ready():
	super._ready()
	current_health = max_health
	#GameManager.CREATE_HEALTH.emit(max_health)


func attack(note_type: GameManager.NOTE_TYPES):
	match note_type:
		GameManager.NOTE_TYPES.TYPE_A:
			animation_sprite.play("Attack1")
		GameManager.NOTE_TYPES.TYPE_B:
			animation_sprite.play("Attack2")
		GameManager.NOTE_TYPES.TYPE_C:
			animation_sprite.play("Attack3")
	#await animation_sprite.animation_finished
	#animation_sprite.play("Idle")


func hurt():
	current_health -= 1
	animation_sprite.play("Hurt")
	animation_player.play("Flash")
	#GameManager.LOST_HEALTH.emit()
	await animation_sprite.animation_finished
	animation_sprite.play("Idle")


func die():
	print("die")
	if animation_sprite.is_playing():
		print(animation_sprite.animation)
	animation_sprite.play("Die")
	await animation_sprite.animation_finished
	print("end")


func animate_tween_on_beat():
	if tween and tween.is_running():
		tween.kill()
	
	tween = get_tree().create_tween()
	var initial_scale: Vector2 = self.scale
	tween.tween_property(self, "scale:y", self.scale.y - 0.20, JsonParser.shortest_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale:y", initial_scale.y, JsonParser.shortest_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)


func _on_whole_note_emitted():
	animate_tween_on_beat()
