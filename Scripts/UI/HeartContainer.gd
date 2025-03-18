extends HBoxContainer


class_name HeartContainer

var heart_prefab = preload("res://Scenes/UI/Heart.tscn")
var health: int:
	set(value):
		health = value
		GameManager.CREATE_HEALTH.emit(health)


func _ready():
	GameManager.LOST_HEALTH.connect(_on_lost_health)
	GameManager.CREATE_HEALTH.connect(_on_create_health)
	#health = 6
	#GameManager.LOST_HEALTH.emit()


func _on_create_health(max_health):
	for child in range(0, max_health):
		var instance = heart_prefab.instantiate()
		add_child(instance)


func _on_lost_health():
	var child_count = get_child_count()
	
	if child_count == 0:
		GameManager.GAME_OVER.emit()
		return
	
	var heart = get_child(child_count - 1)
	heart.queue_free()
