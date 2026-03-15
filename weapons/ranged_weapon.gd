extends WeaponBase
class_name RangedWeapon

@export var projectile_class: PackedScene
@export var projectile_spawn: Node
@export var ammo_count: int = 8
@export var rand_bullet_rotation_min: float = 0
@export var rand_bullet_rotation_max: float = 0

var text_scene: PackedScene = load("res://UI/world_text.tscn")
var ammo_font_theme: Resource = load("res://UI/ammo_font_theme.tres")
var ammo_text: Label
var ammo_current: int

func _ready() -> void:
	super._ready()
	ammo_current = ammo_count

func can_use_weapon() -> bool:
	if !super.can_use_weapon():
		return false
	if ammo_current <= 0:
		return false
	return true
	
func use_weapon() -> void:
	super.use_weapon()
	ammo_current -= 1
	
func _process(delta: float) -> void:
	super._process(delta)
	if ammo_text == null:
		ammo_text = text_scene.instantiate()
		Helpers.LEVEL_ROOT_NODE.add_child(ammo_text)
		ammo_text.theme = ammo_font_theme
	
	ammo_text.global_position = global_position + Vector2.UP * 32

	if weapon_owner is PlayerCharacter:
		ammo_text.text = str(ammo_current) + "/" + str(ammo_count)
		ammo_text.visible = true
	else:
		ammo_text.visible = false
