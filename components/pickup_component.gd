extends ComponentBase
class_name PickupComponent

@export var pickup_radius: float = 64

var is_picked_up: bool

signal picked_up(component: PickupComponent)
signal dropped(component: PickupComponent)

var text_scene: PackedScene = load("res://UI/world_text.tscn")
var text_instance: Label 

func squared_pickup_radius() -> float:
	return pickup_radius * pickup_radius

func _ready() -> void:
	super._ready()

func show_pickup_text() -> void:
	if text_instance == null:
		text_instance = text_scene.instantiate()
		Helpers.LEVEL_ROOT_NODE.add_child(text_instance)
		
	text_instance.visible = true
	text_instance.text = "[E] Pick Up"
	
func hide_pickup_text() -> void:
	if text_instance == null:
		return
	text_instance.visible = false

func handle_dropped() -> void:
	if is_picked_up:
		dropped.emit(self)
	is_picked_up = false

func handle_picked_up() -> void:
	if !is_picked_up:
		picked_up.emit(self)
	is_picked_up = true
	hide_pickup_text()

func _process(delta: float) -> void:
	if text_instance == null:
		return
	text_instance.global_position = global_position
