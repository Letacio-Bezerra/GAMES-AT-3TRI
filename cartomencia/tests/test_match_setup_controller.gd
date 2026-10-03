extends SceneTree

const CardStateScript = preload("res://scripts/card_state.gd")
const MatchSetupControllerScript = preload("res://scripts/match_setup_controller.gd")
const TurnControllerScript = preload("res://scripts/turn_controller.gd")

class ScriptedRandom:
	extends RefCounted
	var values: Array[int]
	var calls: int = 0

	func _init(sequence: Array[int]) -> void:
		values = sequence.duplicate()

	func randi_range(from: int, to: int) -> int:
		calls += 1
		if values.is_empty():
			return from
		return clampi(values.pop_front(), from, to)


var failures: Array[String] = []


func _init() -> void:
	_test_complete_turn_zero_sequence()
	_test_orientation_assignment_can_select_second_player()
	if failures.is_empty():
		print("OK: todos os testes do turno zero passaram.")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _test_complete_turn_zero_sequence() -> void:
	# Primeiro valor: Jogador 1 recebe retas. Os cinco seguintes definem
	# reta, invertida, invertida, reta, reta: placar final 3 × 2.
	var scripted_random := ScriptedRandom.new([0, 0, 1, 1, 0, 0])
	var setup := MatchSetupControllerScript.new()
	var first_deck := _make_deck("a", 6)
	var second_deck := _make_deck("b", 6)
	var external_deck := _make_deck("x", 3)

	_expect(setup.start_setup(first_deck, second_deck, external_deck, scripted_random),
		"O turno zero deve iniciar com baralhos válidos.")
	_expect(setup.player_orientations == [
		MatchSetupControllerScript.Orientation.UPRIGHT,
		MatchSetupControllerScript.Orientation.REVERSED,
	], "As orientações devem ser atribuídas antes das revelações.")
	_expect(setup.revealed_cards.is_empty(),
		"Nenhuma carta pode ser revelada antes da atribuição das orientações.")

	for _index in range(4):
		_expect(setup.reveal_next(), "Cada uma das quatro revelações dos jogadores deve ocorrer.")
	var sources: Array = setup.revealed_cards.map(func(reveal): return reveal["source_index"])
	_expect(sources == [0, 1, 0, 1],
		"O jogador das retas deve revelar primeiro e as revelações devem alternar.")
	_expect(setup.phase == MatchSetupControllerScript.Phase.EXTERNAL_REVEAL,
		"A carta externa só deve ser liberada depois das quatro cartas dos jogadores.")

	_expect(setup.reveal_next(), "A quinta revelação deve vir do baralho externo.")
	_expect(setup.revealed_cards.size() == 5, "O centro deve terminar com exatamente cinco cartas.")
	_expect(setup.revealed_cards[4]["source_index"] == -1,
		"A quinta carta deve pertencer ao baralho externo.")
	_expect(setup.upright_count == 3 and setup.reversed_count == 2,
		"As orientações independentes devem produzir o placar programado de 3 × 2.")
	_expect(setup.first_player_index == 0,
		"O jogador associado à orientação majoritária deve começar.")

	var calls_before_shuffle: int = scripted_random.calls
	_expect(setup.complete_setup(), "O resultado deve permitir concluir o turno zero.")
	_expect(setup.player_decks[0].size() == 6 and setup.player_decks[1].size() == 6,
		"As duas cartas reveladas por jogador devem retornar ao baralho correto.")
	_expect(setup.external_deck.size() == 3,
		"A carta externa deve retornar ao baralho externo.")
	_expect(scripted_random.calls > calls_before_shuffle,
		"Os três baralhos devem ser embaralhados novamente depois dos retornos.")

	var game := TurnControllerScript.new()
	game.start_match(setup.player_decks[0], setup.player_decks[1], setup.first_player_index)
	_expect(game.players[0].hand.size() == 3 and game.players[1].hand.size() == 3,
		"As mãos iniciais devem ser formadas somente após o novo embaralhamento.")
	_expect(game.players[0].energy == 2 and game.players[1].energy == 3,
		"Quem começa deve receber 2 energias e o segundo jogador deve receber 3.")


func _test_orientation_assignment_can_select_second_player() -> void:
	# Jogador 2 recebe retas; quatro das cinco cartas também ficam retas.
	var scripted_random := ScriptedRandom.new([1, 0, 0, 1, 0, 0])
	var setup := MatchSetupControllerScript.new()
	setup.start_setup(_make_deck("a", 4), _make_deck("b", 4), _make_deck("x", 2), scripted_random)
	_expect(setup.player_orientations[1] == MatchSetupControllerScript.Orientation.UPRIGHT,
		"A atribuição aleatória também deve permitir que o Jogador 2 represente as retas.")
	for _index in range(5):
		setup.reveal_next()
	_expect(setup.upright_count == 4 and setup.reversed_count == 1,
		"A segunda sequência controlada deve produzir maioria reta.")
	_expect(setup.first_player_index == 1,
		"A maioria reta deve escolher o Jogador 2 quando ele estiver associado às retas.")


func _make_deck(prefix: String, amount: int) -> Array:
	var deck: Array = []
	for index in range(amount):
		deck.append(CardStateScript.new(
			"%s_%d" % [prefix, index],
			"Carta %s %d" % [prefix, index],
			CardStateScript.Category.ATTACK,
			2
		))
	return deck


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
