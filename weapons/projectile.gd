extends CharacterBody2D
class_name Projectile

var hit_radius: float = 4.0
var speed: float = 1000.0
var damage: float = 0.0
var max_num_bounces: int = 1

var num_bounces: int = 0

func _ready() -> void:
	$HitResponseComponent.hit_event.connect(_handle_hit)
	$CollisionShape2D.shape.set_radius(hit_radius)
	
func _handle_hit(hit_position: Vector2, direction: Vector2, damage: float):
	transform.x = direction.normalized()
	transform.y = transform.x.orthogonal()
	speed *= 1.5

func _process(delta: float) -> void:
	var move_dir: Vector2 = transform.x
	var hit = move_and_collide(move_dir * speed * delta)
	if hit:
		var collider = hit.get_collider()
		if collider == null:
			return
		var response = ComponentManager.get_component(collider, HitResponseComponent)
		if response == null:
			queue_free()
			return
		response.handle_hit(hit.get_position(), -hit.get_normal(), damage)
		var name: String = response.get_parent().name
		match (response.surface_type):
			HitResponseComponent.HitSurfaceType.Absorb:
				queue_free()
				return
			HitResponseComponent.HitSurfaceType.Reflective:
				queue_free()
				return
				#if (num_bounces >= max_num_bounces):
					#queue_free()
					#return
				#transform.x = transform.x.bounce(hit.get_normal()).normalized()
				#transform.y	= transform.x.orthogonal()
				#num_bounces += 1
			HitResponseComponent.HitSurfaceType.Fragile:
				pass
		
