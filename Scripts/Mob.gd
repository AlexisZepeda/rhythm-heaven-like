extends Node2D

class_name Mob

@export var animation_sprite: AnimatedSprite2D

func _ready():
	GameManager.WHOLE_NOTE_EMITTED.connect(_on_whole_note_emitted)
	animation_sprite.play("Idle")
	animation_sprite.speed_scale = JsonParser.midi_bpm / 60 * 2


func attack(_note_type: GameManager.NOTE_TYPES):
	pass


func hurt():
	pass


func _on_whole_note_emitted():
	if not animation_sprite.is_playing():
		animation_sprite.play("Idle")
