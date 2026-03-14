extends Area2D
class_name PickupComponent

@export var pickup_radius: float = 32

var player: PlayerCharacter

var is_added_to_list: bool

signal picked_up(component: PickupComponent)

func _ready() -> void:
	$CollisionShape2D.shape.set_radius(pickup_radius)

func _on_body_entered(body: Node2D) -> void:
	if (body is PlayerCharacter):
		is_added_to_list = true
		player = body
		player.nearby_pickups.push_back(self)

func _on_body_exited(body: Node2D) -> void:
	if (body is PlayerCharacter && is_added_to_list):
		player.nearby_pickups.erase(self)
		player = null
		is_added_to_list = false

func handle_picked_up() -> void:
	if (is_added_to_list):
		picked_up.emit(self)
		player.nearby_pickups.erase(self)
		player = null
		is_added_to_list = false
