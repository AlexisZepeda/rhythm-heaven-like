extends Mob

class_name Enemy

signal HURT_FINISHED

@export var animation_player: AnimationPlayer

var tween: Tween
var is_playing: bool = false


func _ready():
	animation_player.play("Idle")
	animation_player.speed_scale = float(JsonParser.midi_bpm) / 60.0 * 2.0


func hurt():
	if not is_playing:
		is_playing = true
		sfx.play()
		animation_player.pause()
	tween = get_tree().create_tween()
	tween.tween_property(self, "position:y", 350, 2)
	await tween.finished
	
	HURT_FINISHED.emit()
