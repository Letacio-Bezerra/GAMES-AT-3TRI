extends SceneTree

const CardStateScript = preload("res://scripts/card_state.gd")
const PlayerStateScript = preload("res://scripts/player_state.gd")
const PrototypeDeckFactoryScript = preload("res://scripts/prototype_deck_factory.gd")
const TurnControllerScript = preload("res://scripts/turn_controller.gd")

class ScriptedRandom:
	extends RefCounted
	var values: Array[int]

	func _init(sequence: Array[int]) -> void:
		values = sequence.duplicate()

	func randi_range(from: int, to: int) -> int:
		if values.is_empty():
			return from
		return clampi(values.pop_front(), from, to)


var failures: Array[String] = []


func _init() -> void:
	_test_catalog_composition_costs_and_values()
	_test_orientation_visibility_and_renewal()
	_test_entry_effect_hooks()
	_test_special_slots_accumulation_replacement_and_lifecycle()
	if failures.is_empty():
		print("OK: todos os testes do baralho do protótipo passaram.")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _test_catalog_composition_costs_and_values() -> void:
	var first := PrototypeDeckFactoryScript.create_deck()
	var second := PrototypeDeckFactoryScript.create_deck()
	_expect(first.size() == 15, "O baralho deve conter exatamente 15 cartas.")
	var category_counts := [0, 0, 0]
	var ids: Array[String] = []
	for card in first:
		category_counts[card.category] += 1
		ids.append(card.id)
	_expect(category_counts == [5, 5, 5], "O baralho deve conter 5 ataques, 5 suportes e 5 especiais.")
	var unique_ids := ids.duplicate()
	unique_ids.sort()
	for index in range(unique_ids.size() - 1, 0, -1):
		if unique_ids[index] == unique_ids[index - 1]:
			unique_ids.remove_at(index)
	_expect(unique_ids.size() == 15, "As 15 identidades do baralho devem ser únicas.")
	var second_ids: Array[String] = []
	for card in second:
		second_ids.append(card.id)
	ids.sort()
	second_ids.sort()
	_expect(ids == second_ids, "Os dois jogadores devem receber o mesmo conjunto de identidades.")
	_expect(first[0] != second[0], "Os baralhos devem possuir instâncias separadas das mesmas cartas.")

	var expected := {
		"ace_of_wands": [2, 2], "two_of_cups": [2, 3], "six_of_pentacles": [2, 2],
		"seven_of_cups": [2, 2], "ten_of_pentacles": [3, 5], "five_of_wands": [2, 4],
		"three_of_swords": [2, 3], "seven_of_swords": [2, 3], "nine_of_wands": [2, 5],
		"eight_of_pentacles": [2, 3], "death": [6, 0], "wheel_of_fortune": [5, 0],
		"devil": [5, 0], "sun": [5, 0], "moon": [5, 0],
	}
	for card in first:
		_expect(card.energy_cost == expected[card.id][0], "Custo incorreto para %s." % card.display_name)
		if card.is_common():
			_expect(card.base_attack == expected[card.id][1] and card.base_health == expected[card.id][1],
				"Ataque e Vida base incorretos para %s." % card.display_name)


func _test_orientation_visibility_and_renewal() -> void:
	var card = PrototypeDeckFactoryScript.create_deck()[0]
	var player := PlayerStateScript.new("Teste", [card])
	var random := ScriptedRandom.new([0, 1])
	player.draw_cards(1, random)
	_expect(card.orientation == CardStateScript.Orientation.UPRIGHT,
		"A primeira compra controlada deve sortear orientação reta.")
	_expect(not card.is_public and card.summary(false).contains("Oculta"),
		"A orientação na mão deve permanecer privada para o adversário.")
	card.current_health = 1
	card.attack += 4
	card.runtime_marks["used"] = true
	player.hand.erase(card)
	player.send_to_deck_bottom(card)
	_expect(card.current_health == card.base_health and card.attack == card.base_attack,
		"Retornar ao baralho deve renovar dano e modificadores.")
	_expect(card.orientation == CardStateScript.Orientation.UNKNOWN and card.runtime_marks.is_empty(),
		"A renovação deve apagar orientação e marcas de uso.")
	player.draw_cards(1, random)
	_expect(card.orientation == CardStateScript.Orientation.REVERSED,
		"Uma nova compra deve realizar um novo sorteio independente.")


func _test_entry_effect_hooks() -> void:
	var deck := PrototypeDeckFactoryScript.create_deck()
	var game := TurnControllerScript.new()
	game.start_match(deck, PrototypeDeckFactoryScript.create_deck(), 0, ScriptedRandom.new([0, 0, 0, 0, 0, 0]))
	var player = game.active_player()
	var ace = _find_card_anywhere(player, "ace_of_wands")
	_remove_card_everywhere(player, ace)
	player.hand.append(ace)
	ace.orientation = CardStateScript.Orientation.UPRIGHT
	player.energy = 20
	var requested: Array[String] = []
	game.card_effect_requested.connect(func(_owner, requested_card, _trigger): requested.append(requested_card.current_effect_id()))
	_expect(game.play_common_from_hand(ace), "O Ás de Paus deve poder entrar no descanso.")
	_expect(ace.is_public and requested == ["chama_da_inspiracao"],
		"Jogar a carta deve revelar sua orientação e solicitar o efeito de descanso correto.")

	var six = _find_card_anywhere(player, "six_of_pentacles")
	_remove_card_everywhere(player, six)
	var ally = CardStateScript.new("ally", "Aliada", CardStateScript.Category.ATTACK, 1, 2, 2)
	player.attack_field.append(ally)
	player.rest_field.append(six)
	six.orientation = CardStateScript.Orientation.UPRIGHT
	six.entered_rest_turn = game.turn_serial - 1
	_expect(game.move_rest_to_attack(six), "O 6 de Ouros elegível deve avançar ao ataque.")
	game.effects.choose_effect_option(ally)
	_expect(requested.has("generosidade"),
		"A entrada no ataque deve solicitar o efeito ofensivo correspondente.")


func _test_special_slots_accumulation_replacement_and_lifecycle() -> void:
	var game := TurnControllerScript.new()
	game.start_match(_filler_deck("a"), _filler_deck("b"), 0, ScriptedRandom.new([]))
	var player = game.active_player()
	player.energy = 100
	var first = _special("s1", CardStateScript.EffectLifecycle.TEMPORARY, "efeito_1")
	var second = _special("s2", CardStateScript.EffectLifecycle.TEMPORARY, "efeito_2")
	var third = _special("s3", CardStateScript.EffectLifecycle.CONTINUOUS, "efeito_3")
	var fourth = _special("s4", CardStateScript.EffectLifecycle.TEMPORARY, "efeito_4")
	var immediate = _special("s5", CardStateScript.EffectLifecycle.IMMEDIATE, "efeito_5")

	for card in [first, second, third]:
		card.orientation = CardStateScript.Orientation.UPRIGHT
		if not player.hand.has(card):
			player.hand.append(card)
		_expect(game.play_special_from_hand(card), "Cada especial deve ocupar um espaço em um turno distinto.")
		if card == first:
			second.orientation = CardStateScript.Orientation.UPRIGHT
			player.hand.append(second)
			_expect(not game.play_special_from_hand(second),
				"Uma segunda especial no mesmo turno deve ser recusada.")
		game.end_turn()
		game.end_turn()
		player = game.active_player()
		player.energy = 100
	_expect(player.special_field.size() == 3, "A área especial deve conter exatamente três espaços ativos.")
	_expect(game.active_effect_ids(0) == ["efeito_1", "efeito_2", "efeito_3"],
		"Efeitos especiais ativos compatíveis devem permanecer acumulados.")

	fourth.orientation = CardStateScript.Orientation.UPRIGHT
	player.hand.append(fourth)
	var energy_before_rejection: int = player.energy
	_expect(not game.play_special_from_hand(fourth),
		"Uma quarta especial sem substituição deve ser recusada.")
	_expect(player.energy == energy_before_rejection and player.hand.has(fourth),
		"Uma substituição inválida não deve gastar energia nem remover a carta da mão.")
	_expect(game.play_special_from_hand(fourth, 1), "A quarta especial deve entrar quando uma substituição é escolhida.")
	_expect(player.special_field[1] == fourth and player.graveyard.has(second),
		"A especial substituída deve ir ao cemitério e liberar seu espaço.")

	game.end_turn()
	game.end_turn()
	player = game.active_player()
	player.energy = 100
	immediate.orientation = CardStateScript.Orientation.UPRIGHT
	player.hand.append(immediate)
	_expect(game.play_special_from_hand(immediate, 0), "Uma especial imediata deve poder substituir uma ativa.")
	_expect(not player.special_field.has(immediate) and player.graveyard.has(immediate),
		"A especial imediata deve ir ao cemitério assim que a resolução termina.")
	_expect(player.special_field.size() == 2,
		"A especial imediata não deve manter o espaço ocupado após resolver.")
	_expect(game.expire_special(third, 0) and player.graveyard.has(third),
		"Uma especial temporária deve ir ao cemitério quando sua duração expira.")


func _special(card_id: String, lifecycle: int, effect_id: String):
	return CardStateScript.new(
		card_id, card_id, CardStateScript.Category.SPECIAL, 5, 0, 0,
		[CardStateScript.EffectTrigger.NONE, CardStateScript.EffectTrigger.NONE],
		[lifecycle, lifecycle], [effect_id, effect_id]
	)


func _filler_deck(prefix: String) -> Array:
	var deck: Array = []
	for index in range(12):
		deck.append(CardStateScript.new(
			"%s_%d" % [prefix, index], "Carta", CardStateScript.Category.ATTACK, 2, 2, 2
		))
	return deck


func _find_card_anywhere(player, card_id: String):
	for collection in [player.hand, player.deck, player.rest_field, player.attack_field]:
		for card in collection:
			if card.id == card_id:
				return card
	return null


func _remove_card_everywhere(player, card) -> void:
	for collection in [player.hand, player.deck, player.rest_field, player.attack_field]:
		collection.erase(card)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
