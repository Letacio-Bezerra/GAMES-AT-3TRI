extends SceneTree

const CardStateScript = preload("res://scripts/card_state.gd")
const TurnControllerScript = preload("res://scripts/turn_controller.gd")

var failures: Array[String] = []


func _init() -> void:
	_test_initial_energy_and_first_round()
	_test_turn_gain_is_personal_and_accumulates_without_cap()
	_test_card_and_discard_costs_are_transactional()
	_test_energy_loss_never_goes_below_zero()
	if failures.is_empty():
		print("OK: todos os testes do sistema de energia passaram.")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _new_game(first_player_index: int = 0):
	var game := TurnControllerScript.new()
	game.start_match(_make_deck("a"), _make_deck("b"), first_player_index)
	return game


func _make_deck(prefix: String) -> Array:
	var deck: Array = []
	for index in range(12):
		deck.append(CardStateScript.new(
			"%s_%d" % [prefix, index],
			"Carta %d" % index,
			CardStateScript.Category.ATTACK,
			2,
			2,
			2
		))
	return deck


func _test_initial_energy_and_first_round() -> void:
	var game = _new_game(1)
	_expect(game.players[1].energy == 2 and game.players[0].energy == 3,
		"Quem começa deve ter 2 energias e o segundo jogador deve ter 3.")
	game.end_turn()
	_expect(game.players[0].energy == 3,
		"O segundo jogador não pode ganhar energia automática na primeira rodada.")
	_expect(game.players[1].energy == 2,
		"A energia do jogador inativo não pode mudar no turno adversário.")


func _test_turn_gain_is_personal_and_accumulates_without_cap() -> void:
	var game = _new_game()
	game.players[0].energy = 1000
	game.players[1].energy = 2000
	game.end_turn()
	game.end_turn()
	_expect(game.players[0].energy == 1002,
		"O jogador deve conservar qualquer saldo e receber exatamente +2 na rodada 2.")
	_expect(game.players[1].energy == 2000,
		"Somente o jogador cujo turno começou deve receber energia.")
	game.end_turn()
	_expect(game.players[1].energy == 2002,
		"O segundo jogador também deve acumular +2 quando seu próprio turno começa.")


func _test_card_and_discard_costs_are_transactional() -> void:
	var game = _new_game()
	var player = game.active_player()
	var first = player.hand[0]
	var second = player.hand[1]
	_expect(game.play_common_from_hand(first),
		"Uma carta com custo 2 deve poder consumir as duas energias iniciais.")
	_expect(player.energy == 0, "O pagamento deve subtrair exatamente o custo da carta.")
	_expect(not game.play_common_from_hand(second),
		"Uma carta não pode ser jogada sem energia suficiente.")
	_expect(player.energy == 0 and player.hand.has(second),
		"Uma tentativa recusada não pode gastar energia nem remover a carta.")
	_expect(not game.discard_rest_card(first),
		"O descarte voluntário deve ser recusado sem a energia exigida.")
	_expect(player.rest_field.has(first) and player.energy == 0,
		"O descarte recusado deve preservar a carta e o saldo.")
	player.gain_energy(1)
	_expect(game.discard_rest_card(first),
		"Com uma energia, o descarte voluntário deve ser permitido.")
	_expect(player.energy == 0, "O descarte deve consumir exatamente uma energia.")


func _test_energy_loss_never_goes_below_zero() -> void:
	var game = _new_game()
	var player = game.players[0]
	player.energy = 2
	_expect(game.lose_energy(0, 4, "teste"),
		"Uma perda de energia válida deve ser aplicada.")
	_expect(player.energy == 0,
		"Perder mais energia do que o saldo deve resultar exatamente em zero.")
	_expect(game.lose_energy(0, 3, "teste"),
		"Perder energia com saldo zero deve continuar sendo uma operação válida.")
	_expect(player.energy == 0, "Energia em zero não pode ficar negativa.")
	player.energy = -50
	_expect(player.energy == 0,
		"O estado do jogador deve preservar zero como limite inferior mesmo em atribuição direta.")
	_expect(not game.lose_energy(0, -1, "teste"),
		"Uma quantidade negativa não pode inverter uma perda em ganho.")
	_expect(player.energy == 0, "Uma alteração inválida deve preservar o saldo.")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
