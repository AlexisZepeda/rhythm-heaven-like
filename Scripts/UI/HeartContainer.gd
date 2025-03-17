extends HBoxContainer


class_name HeartContainer

var heart_prefab = preload("res://Scenes/UI/Heart.tscn")


func _ready():
	GameManager.LOST_HEALTH.connect(_on_lost_health)
	GameManager.CREATE_HEALTH.connect(_on_create_health)


func _on_create_health(max_health):
	pass


func _on_lost_health():
	pass
