extends CharacterBody2D
class_name Projectile

var hit_radius: float = 4.0
var speed: float = 1000.0
var damage: float = 1.0
var max_num_bounces: int = 1

var num_bounces: int = 0

func _ready() -> void:
	$CollisionShape2D.shape.set_radius(hit_radius)

func _process(delta: float) -> void:
	var move_dir: Vector2 = transform.x
	var hit = move_and_collide(move_dir * speed * delta)
	if hit:
		var collider = hit.get_collider()
		var response = ComponentManager.get_component(collider, HitResponseComponent)
		if response:
			response.handle_hit(hit.get_position(), -hit.get_normal(), damage)
			match (response.surface_type):
				HitResponseComponent.HitSurfaceType.Absorb:
					queue_free()
					return
				HitResponseComponent.HitSurfaceType.Reflective:
					if (num_bounces >= max_num_bounces):
						queue_free()
						return
					transform.x = transform.x.bounce(hit.get_normal()).normalized()
					transform.y	= transform.x.orthogonal()
					num_bounces += 1
				HitResponseComponent.HitSurfaceType.Fragile:
					pass
		else:
			queue_free()
		
