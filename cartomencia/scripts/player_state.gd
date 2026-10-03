class_name PlayerState
extends RefCounted

const CardStateScript = preload("res://scripts/card_state.gd")

const REST_CAPACITY := 3
const ATTACK_CAPACITY := 5
const SPECIAL_CAPACITY := 3
const DEFAULT_MAX_HEALTH := 50

var display_name: String
var max_health: int = DEFAULT_MAX_HEALTH
var health: int = DEFAULT_MAX_HEALTH:
	set(value):
		health = clampi(value, 0, max_health)
var energy: int = 0:
	set(value):
		energy = maxi(0, value)
var deck: Array = []
var hand: Array = []
var rest_field: Array = []
var attack_field: Array = []
var special_field: Array = []
var graveyard: Array = []
var empty_attack_warning: bool = false


func _init(player_name: String, starting_deck: Array, starting_max_health: int = DEFAULT_MAX_HEALTH) -> void:
	display_name = player_name
	deck = starting_deck.duplicate()
	max_health = maxi(1, starting_max_health)
	health = max_health


func draw_cards(amount: int, random_source = null) -> Array:
	var drawn: Array = []
	for _index in range(amount):
		if deck.is_empty():
			break
		var card = deck.pop_front()
		if random_source != null:
			card.assign_orientation(random_source)
		hand.append(card)
		drawn.append(card)
	return drawn


func gain_energy(amount: int) -> int:
	var gained := maxi(0, amount)
	energy += gained
	return gained


func can_pay_energy(amount: int) -> bool:
	return amount >= 0 and energy >= amount


func spend_energy(amount: int) -> bool:
	if not can_pay_energy(amount):
		return false
	energy -= amount
	return true


func lose_energy(amount: int) -> int:
	var previous_energy := energy
	energy -= maxi(0, amount)
	return previous_energy - energy


func take_damage(amount: int) -> int:
	var previous_health := health
	health -= maxi(0, amount)
	return previous_health - health


func heal(amount: int) -> int:
	var previous_health := health
	health += maxi(0, amount)
	return health - previous_health


func has_rest_space() -> bool:
	return rest_field.size() < REST_CAPACITY


func has_attack_space() -> bool:
	return attack_field.size() < ATTACK_CAPACITY


func send_to_deck_bottom(card) -> void:
	card.renew()
	deck.append(card)


func has_any_card() -> bool:
	return not deck.is_empty() \
		or not hand.is_empty() \
		or not rest_field.is_empty() \
		or not attack_field.is_empty() \
		or not special_field.is_empty()
