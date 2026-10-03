class_name CardState
extends RefCounted

enum Category {
	ATTACK,
	SUPPORT,
	SPECIAL,
}

enum Orientation {
	UNKNOWN,
	UPRIGHT,
	REVERSED,
}

enum EffectTrigger {
	NONE,
	ON_REST_ENTRY,
	ON_ATTACK_ENTRY,
	PASSIVE,
}

enum EffectLifecycle {
	NONE,
	IMMEDIATE,
	TEMPORARY,
	CONTINUOUS,
	RESOLVER_DECIDES,
}

var id: String
var display_name: String
var category: Category
var energy_cost: int
var base_attack: int
var base_health: int
var attack: int
var max_health: int
var current_health: int
var entered_rest_turn: int = -1
var orientation: int = Orientation.UNKNOWN
var is_public: bool = false
var upright_trigger: int = EffectTrigger.NONE
var reversed_trigger: int = EffectTrigger.NONE
var upright_lifecycle: int = EffectLifecycle.NONE
var reversed_lifecycle: int = EffectLifecycle.NONE
var upright_effect_id: String = ""
var reversed_effect_id: String = ""
var runtime_marks: Dictionary = {}


func _init(
	card_id: String,
	card_name: String,
	card_category: Category,
	cost: int,
	base_attack: int = 1,
	health: int = 1,
	effect_triggers: Array = [EffectTrigger.NONE, EffectTrigger.NONE],
	effect_lifecycles: Array = [EffectLifecycle.NONE, EffectLifecycle.NONE],
	effect_ids: Array = ["", ""]
) -> void:
	id = card_id
	display_name = card_name
	category = card_category
	energy_cost = cost
	self.base_attack = base_attack
	base_health = health
	attack = base_attack
	max_health = health
	current_health = health
	upright_trigger = effect_triggers[0]
	reversed_trigger = effect_triggers[1]
	upright_lifecycle = effect_lifecycles[0]
	reversed_lifecycle = effect_lifecycles[1]
	upright_effect_id = effect_ids[0]
	reversed_effect_id = effect_ids[1]


func is_common() -> bool:
	return category == Category.ATTACK or category == Category.SUPPORT


func assign_orientation(random_source) -> void:
	orientation = Orientation.UPRIGHT if random_source.randi_range(0, 1) == 0 else Orientation.REVERSED
	is_public = false


func reveal() -> void:
	is_public = true


func renew() -> void:
	attack = base_attack
	max_health = base_health
	current_health = base_health
	entered_rest_turn = -1
	orientation = Orientation.UNKNOWN
	is_public = false
	runtime_marks.clear()


func current_effect_trigger() -> int:
	if orientation == Orientation.UNKNOWN:
		return EffectTrigger.NONE
	return upright_trigger if orientation == Orientation.UPRIGHT else reversed_trigger


func current_effect_lifecycle() -> int:
	if orientation == Orientation.UNKNOWN:
		return EffectLifecycle.NONE
	return upright_lifecycle if orientation == Orientation.UPRIGHT else reversed_lifecycle


func current_effect_id() -> String:
	if orientation == Orientation.UNKNOWN:
		return ""
	return upright_effect_id if orientation == Orientation.UPRIGHT else reversed_effect_id


func orientation_label() -> String:
	match orientation:
		Orientation.UPRIGHT:
			return "Reta"
		Orientation.REVERSED:
			return "Invertida"
		_:
			return "Não sorteada"


func category_label() -> String:
	match category:
		Category.ATTACK:
			return "Ataque"
		Category.SUPPORT:
			return "Suporte"
		_:
			return "Especial"


func summary(include_private_orientation: bool = true) -> String:
	var visible_orientation := orientation_label() if include_private_orientation or is_public else "Oculta"
	if category == Category.SPECIAL:
		return "%s | %s | custo %d | %s" % [display_name, category_label(), energy_cost, visible_orientation]
	return "%s | %s | custo %d | %s | ATQ %d | VIDA %d/%d" % [
		display_name,
		category_label(),
		energy_cost,
		visible_orientation,
		attack,
		current_health,
		max_health,
	]
