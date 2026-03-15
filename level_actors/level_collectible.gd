extends Node2D
class_name LevelCollectible

signal level_collectible_picked_up(collectible: LevelCollectible)

func _ready() -> void:
	$PickupComponent.picked_up.connect(_on_pickup_component_picked_up)

func _on_pickup_component_picked_up(component: PickupComponent) -> void:
	level_collectible_picked_up.emit(self)
	queue_free()

func _process(delta: float) -> void:
	$Sprite2D.position = Vector2(0.0, sin(Helpers.get_time_seconds()) * 4)
