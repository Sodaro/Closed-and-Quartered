extends Node2D
class_name ComponentBase

func _ready() -> void:
	ComponentManager.register_component(get_parent(), self)

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			ComponentManager.deregister_component(get_parent(), self)
