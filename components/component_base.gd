extends Node2D
class_name ComponentBase
	
func _ready() -> void:
	ComponentManager.register_component(get_parent(), self)
