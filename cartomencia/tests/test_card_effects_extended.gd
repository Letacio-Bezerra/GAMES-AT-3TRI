extends SceneTree

const CardStateScript = preload("res://scripts/card_state.gd")
const PrototypeDeckFactoryScript = preload("res://scripts/prototype_deck_factory.gd")
const TurnControllerScript = preload("res://scripts/turn_controller.gd")

class FixedRandom:
	extends RefCounted
	var roll: int

	func _init(value: int) -> void:
		roll = value

	func randi_range(from: int, _to: int) -> int:
		return roll if from == 1 else from


var failures: Array[String] = []


func _init() -> void:
	_test_attack_entry_effects()
	_test_persistent_common_effects()
	_test_provoke_flow()
	_test_reversed_devil_and_eclipse()
	_test_moon_orientations()
	_test_remaining_wheel_results()
	if failures.is_empty():
		print("OK: testes estendidos da Spec 007 passaram.")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _test_attack_entry_effects() -> void:
	var game = _new_game(1)
	var player = game.players[0]
	var enemy = game.players[1]
	var debtor = _plain("debtor", 4, 4)
	var six = _prototype("six_of_pentacles", CardStateScript.Orientation.REVERSED)
	player.attack_field = [six]
	enemy.attack_field = [debtor]
	var energy_before: int = player.energy
	game.effects.resolve_entry(0, six)
	game.effects.choose_effect_option(debtor)
	_expect(debtor.attack == 7 and player.energy == energy_before + 3,
		"Dívida deve dar +3 de Ataque ao inimigo e +3 energias ao lançador.")

	game = _new_game(1)
	player = game.players[0]
	enemy = game.players[1]
	var cups = _prototype("two_of_cups", CardStateScript.Orientation.REVERSED)
	var victim = _plain("victim", 4, 4)
	player.attack_field = [cups]
	enemy.attack_field = [victim]
	game.effects.resolve_entry(0, cups)
	game.effects.choose_effect_option(victim)
	game.effects.choose_effect_option(cups)
	_expect(cups.current_health == 0 or not player.attack_field.has(cups),
		"Relação Rompida deve permitir escolher o próprio 2 de Copas.")
	_expect(victim.current_health == 1, "Relação Rompida deve causar 3 ao inimigo escolhido.")

	game = _new_game(1)
	enemy = game.players[1]
	var chaos = _prototype("five_of_wands", CardStateScript.Orientation.REVERSED)
	var first = _plain("chaos_a", 2, 5)
	var second = _plain("chaos_b", 3, 5)
	game.players[0].attack_field = [chaos]
	enemy.attack_field = [first, second]
	game.effects.resolve_entry(0, chaos)
	game.effects.choose_effect_option(first)
	game.effects.choose_effect_option(second)
	game.effects.confirm_effect_choice()
	_expect(first.current_health == 2 and second.current_health == 3,
		"Caos deve calcular os dois ataques antes de aplicar dano simultâneo.")

	var heart = _prototype("three_of_swords", CardStateScript.Orientation.UPRIGHT)
	game.players[0].attack_field.append(heart)
	game.effects.resolve_entry(0, heart)
	game.effects.choose_effect_option(first)
	_expect(not enemy.attack_field.has(first), "Coração Partido deve causar 4 de dano ao alvo.")


func _test_persistent_common_effects() -> void:
	var game = _new_game(1)
	var player = game.players[0]
	var legacy = _prototype("ten_of_pentacles", CardStateScript.Orientation.UPRIGHT)
	var improvement = _prototype("eight_of_pentacles", CardStateScript.Orientation.UPRIGHT)
	var overwork = _prototype("eight_of_pentacles", CardStateScript.Orientation.REVERSED)
	player.rest_field = [legacy, improvement, overwork]
	var energy_before: int = player.energy
	game.effects.on_turn_started(0)
	_expect(player.energy == energy_before + 2, "Legado deve contar três comuns nos campos e conceder 2 energias.")
	_expect(overwork.attack == overwork.base_attack + 2 and overwork.current_health == overwork.base_health - 1,
		"Trabalho Excessivo deve trocar 1 de Vida por +2 de Ataque no início do turno.")
	game.effects.on_turn_ending(0, false)
	_expect(improvement.attack == improvement.base_attack + 1 and improvement.max_health == improvement.base_health + 1,
		"Aperfeiçoamento deve crescer ao fim de um turno sem participação no ataque.")


func _test_provoke_flow() -> void:
	var game = _new_game(1)
	var player = game.players[0]
	var enemy = game.players[1]
	var provoker = _prototype("five_of_wands", CardStateScript.Orientation.UPRIGHT)
	var provoked = _plain("provoked", 8, 8)
	var other = _plain("other_target", 4, 4)
	player.attack_field = [provoker, other]
	enemy.attack_field = [provoked]
	game.effects.resolve_entry(0, provoker)
	game.effects.choose_effect_option(provoked)
	game.end_turn()
	_expect(not game.end_turn(), "Confronto deve impedir que o adversário encerre sem atacar.")
	game.attack()
	_expect(not game.select_attack_target(other), "Confronto deve exigir o 5 de Paus como primeiro alvo.")
	_expect(game.select_attack_target(provoker), "O alvo provocado deve aceitar o primeiro dano.")


func _test_reversed_devil_and_eclipse() -> void:
	var game = _new_game(1)
	var player = game.players[0]
	var enemy = game.players[1]
	var target = _plain("cleanse_target", 5, 5)
	player.attack_field = [target]
	enemy.attack_field = [_plain("enemy", 5, 5)]
	game.effects._apply_debuff(target, "teste", -2, -2, "end", 0, 10)
	target.current_health -= 1
	var devil = _prototype("devil", CardStateScript.Orientation.REVERSED)
	player.hand = [devil]
	player.energy = 10
	game.play_special_from_hand(devil)
	game.effects.choose_effect_option(target)
	_expect(target.attack == 8 and target.max_health == 8 and target.current_health == 5,
		"Quebrar as Correntes deve limpar o debuff sem curar o dano e depois aplicar +3/+3.")
	_expect(target.runtime_marks.get("temporary_debuff_used", false),
		"Quebrar as Correntes não deve apagar a marca histórica de debuff.")

	game = _new_game(1)
	player = game.players[0]
	enemy = game.players[1]
	var own = _plain("eclipse_own", 5, 5)
	var foe = _plain("eclipse_foe", 5, 5)
	var sun = _prototype("sun", CardStateScript.Orientation.REVERSED)
	player.attack_field = [own]
	enemy.attack_field = [foe]
	player.hand = [sun]
	player.energy = 10
	game.play_special_from_hand(sun)
	_expect(own.attack == 3 and foe.attack == 3 and own.current_health == 3 and foe.current_health == 3,
		"Eclipse deve aplicar −2/−2 aos dois campos elegíveis.")
	_expect(game.effects.attack_value(own, 0) == 4,
		"Uma carta própria afetada pelo Eclipse deve recuperar +1 somente no ataque conjunto.")


func _test_moon_orientations() -> void:
	var game = _new_game(1)
	var player = game.players[0]
	var target = _plain("moon_target", 3, 3)
	var moon = _prototype("moon", CardStateScript.Orientation.UPRIGHT)
	player.rest_field = [target]
	player.hand = [moon]
	player.energy = 10
	game.play_special_from_hand(moon)
	game.effects.choose_effect_option(target)
	_expect(not game.effects.is_targetable(1, target), "Ilusão deve proteger a carta escolhida.")
	game.effects.on_turn_ending(0, false)
	_expect(not game.effects.is_targetable(1, target), "Ilusão deve continuar após um dos dois turnos da rodada.")
	game.effects.on_turn_ending(1, false)
	_expect(game.effects.is_targetable(1, target) and player.graveyard.has(moon),
		"Ilusão deve expirar após os dois jogadores concluírem um turno.")

	game = _new_game(1)
	player = game.players[0]
	var enemy = game.players[1]
	var top := [_plain("reveal_a", 1, 1), _plain("reveal_b", 1, 1), _plain("reveal_c", 1, 1), _plain("reveal_d", 1, 1)]
	enemy.deck = top.duplicate()
	moon = _prototype("moon", CardStateScript.Orientation.REVERSED)
	player.hand = [moon]
	player.energy = 10
	game.play_special_from_hand(moon)
	game.effects.choose_effect_option(top[2])
	game.effects.choose_effect_option(top[0])
	game.effects.confirm_effect_choice()
	_expect(enemy.hand.has(top[1]) and enemy.deck == [top[3], top[0], top[2]],
		"Revelação deve preservar a ordem relativa das movidas e comprar a primeira restante.")


func _test_remaining_wheel_results() -> void:
	var game = _new_game(3)
	var player = game.players[0]
	var wheel = _prototype("wheel_of_fortune", CardStateScript.Orientation.UPRIGHT)
	player.deck = [_plain("draw1", 1, 1), _plain("draw2", 1, 1)]
	player.hand = [wheel]
	player.energy = 10
	game.play_special_from_hand(wheel)
	_expect(player.hand.size() == 2 and player.graveyard.has(wheel),
		"Roda 3–4 deve comprar somente as cartas disponíveis.")

	game = _new_game(5)
	player = game.players[0]
	var boosted = _plain("wheel_boost", 2, 2)
	wheel = _prototype("wheel_of_fortune", CardStateScript.Orientation.UPRIGHT)
	player.attack_field = [boosted]
	player.hand = [wheel]
	player.energy = 10
	game.play_special_from_hand(wheel)
	_expect(boosted.attack == 5 and player.special_field.has(wheel),
		"Roda 5 deve manter a especial ativa enquanto o +3/+3 durar.")

	game = _new_game(6)
	player = game.players[0]
	var enemy = game.players[1]
	var doomed = _plain("wheel_doomed", 3, 3)
	wheel = _prototype("wheel_of_fortune", CardStateScript.Orientation.UPRIGHT)
	enemy.attack_field = [doomed]
	player.hand = [wheel]
	player.energy = 10
	game.play_special_from_hand(wheel)
	game.effects.choose_effect_option(doomed)
	_expect(not enemy.attack_field.has(doomed) and player.graveyard.has(wheel),
		"Roda 6 deve destruir o alvo inimigo escolhido e concluir a especial.")

	game = _new_game(3)
	player = game.players[0]
	var discarded = _plain("discarded", 2, 2)
	wheel = _prototype("wheel_of_fortune", CardStateScript.Orientation.REVERSED)
	player.hand = [wheel, discarded]
	player.energy = 10
	game.play_special_from_hand(wheel)
	game.effects.choose_effect_option(discarded)
	game.effects.confirm_effect_choice()
	_expect(player.deck.has(discarded) and player.graveyard.has(wheel),
		"Má Fortuna 3–4 deve descartar somente as cartas disponíveis pelo destino normal.")


func _new_game(roll: int):
	var game := TurnControllerScript.new()
	game.start_match(_deck("a"), _deck("b"), 0, FixedRandom.new(roll))
	return game


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


func _deck(prefix: String) -> Array:
	var cards: Array = []
	for index in range(12):
		cards.append(_plain("%s_%d" % [prefix, index], 2, 2))
	return cards


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
