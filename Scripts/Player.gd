extends Mob

class_name Player


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
	await animation_sprite.animation_finished
	animation_sprite.play("Idle")
