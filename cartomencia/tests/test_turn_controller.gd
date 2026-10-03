extends SceneTree

const CardStateScript = preload("res://scripts/card_state.gd")
const TurnControllerScript = preload("res://scripts/turn_controller.gd")

var failures: Array[String] = []


func _init() -> void:
	_test_first_round_has_no_automatic_draw()
	_test_second_round_draws_two_and_grants_energy()
	_test_insufficient_deck_draws_only_available_cards()
	_test_preparation_can_repeat_while_valid()
	_test_hand_has_no_limit()
	_test_round_count_when_second_player_starts()
	_test_preparation_actions_and_attack_end_turn()
	if failures.is_empty():
		print("OK: todos os testes do fluxo do turno passaram.")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _make_deck(prefix: String, amount: int = 10) -> Array:
	var deck: Array = []
	for index in range(amount):
		deck.append(CardStateScript.new(
			"%s_%d" % [prefix, index],
			"Carta %d" % index,
			CardStateScript.Category.ATTACK,
			2,
			2,
			2
		))
	return deck


func _new_game(deck_size: int = 10):
	var game := TurnControllerScript.new()
	game.start_match(_make_deck("a", deck_size), _make_deck("b", deck_size))
	return game


func _test_first_round_has_no_automatic_draw() -> void:
	var game = _new_game()
	_expect(game.round_number == 1, "A partida deve iniciar na rodada 1.")
	_expect(game.players[0].hand.size() == 3, "O primeiro jogador deve manter somente as 3 cartas iniciais.")
	game.end_turn()
	_expect(game.players[1].hand.size() == 3, "O segundo turno da rodada 1 não pode comprar cartas.")


func _test_second_round_draws_two_and_grants_energy() -> void:
	var game = _new_game()
	game.end_turn()
	game.end_turn()
	_expect(game.round_number == 2, "A rodada deve avançar depois que os dois jogadores atuarem.")
	_expect(game.current_player_index == 0, "O primeiro jogador deve abrir a rodada 2.")
	_expect(game.players[0].hand.size() == 5, "O jogador deve comprar exatamente 2 cartas na rodada 2.")
	_expect(game.players[0].energy == 4, "A energia inicial acumulada deve receber +2 na rodada 2.")


func _test_insufficient_deck_draws_only_available_cards() -> void:
	var game = _new_game(4)
	game.end_turn()
	game.end_turn()
	_expect(game.players[0].hand.size() == 4, "Com uma carta restante, a compra deve adicionar somente essa carta.")
	_expect(game.players[0].deck.is_empty(), "A compra parcial não deve criar cartas.")


func _test_preparation_can_repeat_while_valid() -> void:
	var game = _new_game()
	var player = game.active_player()
	player.energy = 10
	var first = player.hand[0]
	var second = player.hand[1]
	var third = player.hand[2]
	_expect(game.play_common_from_hand(first), "A primeira colocação válida deve ocorrer.")
	_expect(game.play_common_from_hand(second), "A colocação deve poder ser repetida no mesmo turno.")
	_expect(game.play_common_from_hand(third), "A terceira colocação deve preencher o descanso.")
	var energy_before_failed_action: int = player.energy
	player.draw_cards(1)
	_expect(not game.play_common_from_hand(player.hand[0]), "Uma quarta carta não pode exceder os 3 espaços de descanso.")
	_expect(player.energy == energy_before_failed_action, "Uma colocação inválida não pode consumir energia.")
	var deck_size_before_discard: int = player.deck.size()
	var energy_before_discard: int = player.energy
	_expect(game.discard_rest_card(first), "O descarte do descanso deve ocorrer com energia disponível.")
	_expect(player.energy == energy_before_discard - 1, "O descarte deve consumir exatamente 1 energia.")
	_expect(player.deck.size() == deck_size_before_discard + 1, "A carta descartada deve retornar ao baralho.")
	_expect(player.deck.back() == first, "A carta descartada deve ir ao fundo sem embaralhar o baralho.")
	_expect(player.graveyard.is_empty(), "Uma carta comum descartada não pode entrar no cemitério.")


func _test_hand_has_no_limit() -> void:
	var game = _new_game(12)
	var player = game.active_player()
	player.draw_cards(8)
	_expect(player.hand.size() == 11, "A mão deve aceitar todas as cartas compradas sem descarte por excesso.")


func _test_round_count_when_second_player_starts() -> void:
	var game := TurnControllerScript.new()
	game.start_match(_make_deck("a"), _make_deck("b"), 1)
	game.end_turn()
	_expect(game.round_number == 1, "A rodada não deve mudar depois de apenas um turno quando o Jogador 2 começa.")
	game.end_turn()
	_expect(game.round_number == 2, "A rodada deve mudar depois dos dois turnos, independentemente de quem começa.")
	_expect(game.current_player_index == 1, "O jogador inicial deve abrir também a rodada seguinte.")


func _test_preparation_actions_and_attack_end_turn() -> void:
	var game = _new_game()
	var card = game.active_player().hand[0]
	_expect(game.play_common_from_hand(card), "Uma carta pagável deve entrar no descanso.")
	_expect(not game.move_rest_to_attack(card), "Uma carta não pode avançar no turno em que entrou no descanso.")
	game.end_turn()
	game.end_turn()
	_expect(game.move_rest_to_attack(card), "A carta deve poder avançar no próximo turno do dono.")
	var previous_turn: int = game.turn_serial
	_expect(game.attack(), "Um campo de ataque ocupado deve permitir atacar.")
	_expect(game.turn_serial == previous_turn + 1, "Resolver o ataque deve encerrar o turno imediatamente.")
	_expect(game.current_player_index == 1, "Depois do ataque, o adversário deve se tornar o jogador ativo.")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
