extends SceneTree

const CardStateScript = preload("res://scripts/card_state.gd")
const PrototypeDeckFactoryScript = preload("res://scripts/prototype_deck_factory.gd")
const TurnControllerScript = preload("res://scripts/turn_controller.gd")

class FixedRandom:
	extends RefCounted
	var wheel_roll: int

	func _init(value: int = 1) -> void:
		wheel_roll = value

	func randi_range(from: int, to: int) -> int:
		if from == 1 and to == 6:
			return wheel_roll
		return from


var failures: Array[String] = []


func _init() -> void:
	_test_energy_and_risk_effects()
	_test_targeted_common_effects()
	_test_combat_passives_and_protection()
	_test_death_both_orientations()
	_test_devil_sun_moon_and_wheel()
	_test_deck_choices_and_theft()
	if failures.is_empty():
		print("OK: todos os testes dos efeitos da Spec 007 passaram.")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _new_game(roll: int = 1):
	var game := TurnControllerScript.new()
	game.start_match(_filler_deck("a"), _filler_deck("b"), 0, FixedRandom.new(roll))
	return game


func _test_energy_and_risk_effects() -> void:
	var game = _new_game()
	var player = game.players[0]
	var ace = _prototype("ace_of_wands", CardStateScript.Orientation.UPRIGHT)
	player.hand = [ace]
	player.energy = 2
	_expect(game.play_common_from_hand(ace) and player.energy == 2,
		"Chama da Inspiração deve pagar 2 e devolver 2 energias.")

	game = _new_game()
	player = game.players[0]
	ace = _prototype("ace_of_wands", CardStateScript.Orientation.REVERSED)
	player.hand = [ace]
	player.energy = 2
	player.health = 2
	_expect(not game.play_common_from_hand(ace),
		"Chama Instável letal deve exigir confirmação.")
	_expect(player.energy == 2 and player.hand.has(ace),
		"Recusar o risco não deve gastar energia nem mover a carta.")
	_expect(game.play_common_from_hand(ace, true) and game.is_match_over,
		"Confirmar Chama Instável deve conceder energia e permitir a derrota do dono.")

	game = _new_game()
	player = game.players[0]
	var inheritance = _prototype("ten_of_pentacles", CardStateScript.Orientation.REVERSED)
	player.hand = [inheritance]
	player.energy = 3
	game.play_common_from_hand(inheritance)
	var blocked_energy: int = player.energy
	_expect(not game.effects.grant_card_energy(0, 2, "teste") and player.energy == blocked_energy,
		"Herança Perdida deve bloquear ganhos adicionais de cartas.")


func _test_targeted_common_effects() -> void:
	var game = _new_game()
	var player = game.players[0]
	var enemy = game.players[1]
	var ally = _plain("ally", 2, 2)
	var target = _plain("target", 5, 5)
	var six = _prototype("six_of_pentacles", CardStateScript.Orientation.UPRIGHT)
	player.attack_field = [ally]
	player.rest_field = [six]
	enemy.attack_field = [target]
	six.entered_rest_turn = game.turn_serial - 1
	_expect(game.move_rest_to_attack(six), "Generosidade deve aceitar outra carta própria como alvo.")
	game.effects.choose_effect_option(ally)
	_expect(ally.attack == 5 and ally.current_health == 5,
		"Generosidade deve aplicar +3/+3.")
	game.end_turn()
	game.end_turn()
	_expect(ally.attack == 2 and ally.max_health == 2,
		"Generosidade deve expirar no início do próximo turno do dono.")

	game = _new_game()
	player = game.players[0]
	enemy = game.players[1]
	var cups = _prototype("two_of_cups", CardStateScript.Orientation.UPRIGHT)
	ally = _plain("union_ally", 3, 3)
	player.attack_field = [ally, cups]
	game.effects.resolve_entry(0, cups)
	game.effects.choose_effect_option(ally)
	_expect(cups.attack == 5 and ally.attack == 5, "União deve fortalecer as duas cartas.")
	game.destroy_card(0, ally, "teste")
	_expect(cups.attack == 3 and cups.max_health == 3,
		"União deve terminar nas duas cartas quando uma deixa o ataque.")

	game = _new_game()
	player = game.players[0]
	enemy = game.players[1]
	var swords = _prototype("three_of_swords", CardStateScript.Orientation.REVERSED)
	var weak = _plain("weak", 2, 2)
	var sturdy = _plain("sturdy", 5, 5)
	player.attack_field = [swords]
	enemy.attack_field = [weak, sturdy]
	game.effects.resolve_entry(0, swords)
	_expect(not enemy.attack_field.has(weak) and sturdy.current_health == 3,
		"Ferida Profunda deve causar 2 simultaneamente a todo o ataque inimigo.")


func _test_combat_passives_and_protection() -> void:
	var game = _new_game()
	var player = game.players[0]
	var enemy = game.players[1]
	var survivor = _prototype("nine_of_wands", CardStateScript.Orientation.UPRIGHT)
	player.attack_field = [survivor]
	game.damage_card(0, survivor, 99, "teste")
	_expect(survivor.current_health == 1 and player.attack_field.has(survivor),
		"Última Resistência deve impedir a primeira derrota.")
	game.damage_card(0, survivor, 2, "teste")
	_expect(not player.attack_field.has(survivor),
		"Última Resistência deve permitir a derrota seguinte.")

	game = _new_game()
	player = game.players[0]
	enemy = game.players[1]
	var exhausted = _prototype("nine_of_wands", CardStateScript.Orientation.REVERSED)
	exhausted.current_health = 2
	player.attack_field = [exhausted]
	game.effects.on_turn_started(0)
	_expect(exhausted.attack == exhausted.base_attack + 4,
		"Exaustão deve conceder +4 com 1 ou 2 de Vida.")
	exhausted.current_health = 3
	game.effects.on_turn_started(0)
	_expect(exhausted.attack == exhausted.base_attack,
		"Exaustão deve remover o bônus fora da faixa.")

	game = _new_game()
	player = game.players[0]
	enemy = game.players[1]
	var evasive = _prototype("seven_of_swords", CardStateScript.Orientation.UPRIGHT)
	player.attack_field = [evasive]
	enemy.attack_field = [_plain("attacker", 8, 8)]
	game.effects.resolve_entry(0, evasive)
	game.end_turn()
	_expect(game.attack(), "O adversário ainda deve poder declarar ataque contra campo protegido.")
	_expect(game.current_player_index == 0 and evasive.current_health == evasive.base_health,
		"Sem alvo elegível, o dano deve ser perdido e a Evasão preservada.")
	_expect(game.effects.is_targetable(1, evasive),
		"Evasão deve terminar ao fim do próximo turno adversário.")


func _test_death_both_orientations() -> void:
	var game = _new_game()
	var player = game.players[0]
	var enemy = game.players[1]
	var own = _plain("own_sacrifice", 4, 4)
	var foe = _plain("enemy_sacrifice", 3, 3)
	var death = _prototype("death", CardStateScript.Orientation.UPRIGHT)
	player.attack_field = [own]
	enemy.attack_field = [foe]
	player.hand = [death]
	player.energy = 10
	_expect(game.play_special_from_hand(death), "Transformação deve iniciar com dois alvos válidos.")
	game.effects.choose_effect_option(own)
	game.effects.choose_effect_option(foe)
	_expect(player.deck.has(own) and enemy.deck.has(foe),
		"Transformação deve derrotar normalmente as duas cartas.")
	_expect(player.rest_field.size() == 1 and player.rest_field[0].runtime_marks.get("token", false),
		"Transformação deve criar a ficha 4/4 no descanso.")
	var token = player.rest_field.pop_front()
	player.attack_field.append(token)
	game.destroy_card(0, token, "teste da ficha")
	_expect(not player.deck.has(token) and not player.graveyard.has(token),
		"A ficha da Morte deve desaparecer quando deixa o campo.")

	game = _new_game()
	player = game.players[0]
	enemy = game.players[1]
	var protected = _plain("protected", 4, 4)
	death = _prototype("death", CardStateScript.Orientation.REVERSED)
	player.attack_field = [protected]
	enemy.attack_field = [_plain("guard", 1, 20)]
	player.hand = [death]
	player.energy = 10
	game.play_special_from_hand(death)
	game.effects.choose_effect_option(protected)
	game.damage_card(0, protected, 20, "teste")
	_expect(protected.current_health == 1, "Resistência à Morte deve segurar dano letal em 1.")
	game.end_turn()
	game.end_turn()
	_expect(not player.attack_field.has(protected),
		"No próximo início do dono, a proteção deve acabar e causar 3 de dano.")


func _test_devil_sun_moon_and_wheel() -> void:
	var game = _new_game(1)
	var player = game.players[0]
	var enemy = game.players[1]
	var target = _plain("buff_target", 3, 3)
	var devil = _prototype("devil", CardStateScript.Orientation.UPRIGHT)
	player.attack_field = [target]
	enemy.attack_field = [_plain("guard", 1, 20)]
	player.hand = [devil]
	player.energy = 20
	game.play_special_from_hand(devil)
	game.effects.choose_effect_option(target)
	_expect(target.attack == 9 and target.current_health == 9, "Pacto deve conceder +6/+6.")
	game.end_turn()
	game.end_turn()
	_expect(target.attack == 9, "Pacto deve persistir durante o próximo turno próprio.")
	game.end_turn()
	_expect(target.attack == 3 and target.max_health == 3,
		"Pacto deve expirar ao fim do próximo turno próprio.")

	game = _new_game()
	player = game.players[0]
	enemy = game.players[1]
	target = _plain("sun_target", 4, 4)
	var sun = _prototype("sun", CardStateScript.Orientation.UPRIGHT)
	player.attack_field = [target]
	enemy.attack_field = [_plain("guard2", 1, 20)]
	player.health = 45
	player.hand = [sun]
	player.energy = 10
	game.play_special_from_hand(sun)
	_expect(target.attack == 7 and player.health == 48, "Plenitude deve dar +3/+3 e curar 3.")
	game.end_turn()
	_expect(target.attack == 4 and target.max_health == 4, "Plenitude deve acabar no fim do turno.")

	game = _new_game(1)
	player = game.players[0]
	var wheel = _prototype("wheel_of_fortune", CardStateScript.Orientation.UPRIGHT)
	player.hand = [wheel]
	player.energy = 5
	game.play_special_from_hand(wheel)
	_expect(player.energy == 4 and player.graveyard.has(wheel),
		"Roda 1–2 deve conceder 4 energias e ir ao cemitério.")


func _test_deck_choices_and_theft() -> void:
	var game = _new_game()
	var player = game.players[0]
	var enemy = game.players[1]
	var choices := [_plain("top_a", 1, 1), _plain("top_b", 1, 1), _plain("top_c", 1, 1)]
	player.deck = choices.duplicate()
	var cups = _prototype("seven_of_cups", CardStateScript.Orientation.UPRIGHT)
	player.hand = [cups]
	player.energy = 10
	game.play_common_from_hand(cups)
	game.effects.choose_effect_option(choices[1])
	game.effects.choose_effect_option(choices[2])
	_expect(player.hand.has(choices[1]) and player.deck[0] == choices[2],
		"Sete Possibilidades deve comprar a escolhida e permitir ordenar o topo restante.")

	game = _new_game()
	player = game.players[0]
	enemy = game.players[1]
	var thief = _prototype("seven_of_swords", CardStateScript.Orientation.REVERSED)
	var stolen_special = _prototype("sun", CardStateScript.Orientation.UPRIGHT)
	player.hand = [thief]
	enemy.hand = [stolen_special]
	player.energy = 10
	game.play_common_from_hand(thief)
	game.effects.choose_effect_option(stolen_special)
	_expect(enemy.graveyard.has(stolen_special) and not enemy.hand.has(stolen_special),
		"Roubo deve enviar uma especial escolhida ao cemitério adversário.")


func _prototype(card_id: String, orientation: int):
	for card in PrototypeDeckFactoryScript.create_deck():
		if card.id == card_id:
			card.orientation = orientation
			card.reveal()
			return card
	return null


func _plain(card_id: String, attack: int, health: int):
	var card = CardStateScript.new(card_id, card_id, CardStateScript.Category.ATTACK, 1, attack, health)
	card.orientation = CardStateScript.Orientation.UPRIGHT
	card.reveal()
	return card


func _filler_deck(prefix: String) -> Array:
	var cards: Array = []
	for index in range(12):
		cards.append(_plain("%s_%d" % [prefix, index], 2, 2))
	return cards


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
