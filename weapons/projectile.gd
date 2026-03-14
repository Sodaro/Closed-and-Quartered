extends CharacterBody2D
class_name Projectile

var hit_radius: float = 4.0
var speed: float = 1000.0
var damage: float = 1.0

func _ready() -> void:
	$CollisionShape2D.shape.set_radius(hit_radius)

func _process(delta: float) -> void:
	var move_dir: Vector2 = transform.x
	var hit = move_and_collide(move_dir * speed * delta)
	if (hit):
		queue_free()
		
