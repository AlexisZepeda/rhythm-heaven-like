extends Node

var inputs = ["Attack", "Attack2", "Attack3"]
enum NOTE_TYPES { TYPE_A, TYPE_B, TYPE_C }


# Metronome signals
signal BEAT_EMITTED(beat, song_position)
signal QUARTER_NOTE_EMITTED
signal HALF_NOTE_EMITTED
signal WHOLE_NOTE_EMITTED

# Health signals
signal LOST_HEALTH
signal CREATE_HEALTH(max_health)

signal GAME_OVER
