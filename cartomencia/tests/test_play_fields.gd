extends SceneTree

const CardStateScript = preload("res://scripts/card_state.gd")
const PlayerStateScript = preload("res://scripts/player_state.gd")
const TurnControllerScript = preload("res://scripts/turn_controller.gd")

var failures: Array[String] = []


func _init() -> void:
	_test_field_capacities_and_common_card_entry()
	_test_rest_delay_free_advance_and_no_return()
	_test_full_attack_rejects_another_advance()
	if failures.is_empty():
		print("OK: todos os testes dos campos de jogo passaram.")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _new_game():
	var game := TurnControllerScript.new()
	game.start_match(_make_deck("a"), _make_deck("b"))
	return game


func _make_deck(prefix: String) -> Array:
	var deck: Array = []
	for index in range(12):
		deck.append(CardStateScript.new(
			"%s_%d" % [prefix, index],
			"Carta %d" % index,
			CardStateScript.Category.ATTACK if index % 2 == 0 else CardStateScript.Category.SUPPORT,
			2 if index != 11 else 3,
			2,
			2
		))
	return deck


func _test_field_capacities_and_common_card_entry() -> void:
	var game = _new_game()
	var player = game.active_player()
	player.energy = 20
	var initial_cards: Array = player.hand.duplicate()
	for card in initial_cards:
		_expect(game.play_common_from_hand(card),
			"Ataques e suportes pagáveis devem entrar no descanso enquanto houver espaço.")
	_expect(player.rest_field.size() == PlayerStateScript.REST_CAPACITY,
		"O descanso deve comportar exatamente três cartas.")
	var fourth = player.deck.pop_front()
	fourth.assign_orientation(game.random_source)
	player.hand.append(fourth)
	var energy_before: int = player.energy
	_expect(not game.play_common_from_hand(fourth),
		"Uma quarta carta comum deve ser recusada quando o descanso estiver cheio.")
	_expect(player.energy == energy_before and player.hand.has(fourth),
		"A colocação recusada deve preservar energia e carta na mão.")


func _test_rest_delay_free_advance_and_no_return() -> void:
	var game = _new_game()
	var player = game.active_player()
	player.energy = 20
	var cards: Array = player.hand.duplicate()
	for card in cards:
		game.play_common_from_hand(card)
	var energy_after_placement: int = player.energy
	_expect(not game.move_rest_to_attack(cards[0]),
		"Uma carta não pode avançar no turno em que entrou no descanso.")
	game.end_turn()
	game.end_turn()
	player = game.active_player()
	for card in cards:
		_expect(game.move_rest_to_attack(card),
			"Cada carta preparada deve poder avançar no próximo turno do dono.")
	_expect(player.energy == energy_after_placement + 2,
		"Avançar cartas deve ser gratuito; apenas o ganho automático da rodada pode alterar o saldo.")
	_expect(player.rest_field.is_empty() and player.attack_field == cards,
		"O avanço deve remover as cartas do descanso e preservar sua ordem no ataque.")
	_expect(not player.rest_field.has(cards[0]),
		"Uma carta avançada não pode permanecer nem retornar implicitamente ao descanso.")


func _test_full_attack_rejects_another_advance() -> void:
	var game = _new_game()
	var player = game.active_player()
	player.attack_field.clear()
	for index in range(PlayerStateScript.ATTACK_CAPACITY):
		player.attack_field.append(CardStateScript.new(
			"field_%d" % index,
			"Campo %d" % index,
			CardStateScript.Category.ATTACK,
			2,
			2,
			2
		))
	var waiting = player.hand[0]
	player.hand.erase(waiting)
	waiting.entered_rest_turn = game.turn_serial - 1
	player.rest_field.append(waiting)
	var energy_before: int = player.energy
	_expect(not game.move_rest_to_attack(waiting),
		"Uma sexta carta deve ser recusada quando o ataque estiver cheio.")
	_expect(player.rest_field.has(waiting) and not player.attack_field.has(waiting),
		"O avanço recusado deve preservar a carta no descanso.")
	_expect(player.energy == energy_before,
		"Uma tentativa de avanço, válida ou não, nunca deve consumir energia.")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
