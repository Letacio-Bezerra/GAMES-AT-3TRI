class_name MatchSetupController
extends RefCounted

signal state_changed
signal event_logged(message: String)
signal action_rejected(reason: String)
signal setup_completed(first_player_index: int, first_deck: Array, second_deck: Array, external_deck: Array)

enum Orientation {
	UPRIGHT,
	REVERSED,
}

enum Phase {
	NOT_STARTED,
	PLAYER_REVEALS,
	EXTERNAL_REVEAL,
	RESULT,
	COMPLETE,
}

var phase: Phase = Phase.NOT_STARTED
var player_decks: Array = [[], []]
var external_deck: Array = []
var player_orientations: Array[int] = []
var revealed_cards: Array = []
var player_reveal_counts: Array[int] = [0, 0]
var next_player_index: int = -1
var first_player_index: int = -1
var upright_count: int = 0
var reversed_count: int = 0
var random_source


func start_setup(
	first_deck: Array,
	second_deck: Array,
	provided_external_deck: Array,
	provided_random_source = null
) -> bool:
	if first_deck.size() < 2 or second_deck.size() < 2:
		return _reject("Cada jogador precisa ter ao menos duas cartas para o turno zero.")
	if provided_external_deck.is_empty():
		return _reject("O baralho externo precisa ter ao menos uma carta.")

	player_decks = [first_deck.duplicate(), second_deck.duplicate()]
	external_deck = provided_external_deck.duplicate()
	revealed_cards.clear()
	player_reveal_counts = [0, 0]
	upright_count = 0
	reversed_count = 0
	first_player_index = -1
	random_source = provided_random_source
	if random_source == null:
		random_source = RandomNumberGenerator.new()
		random_source.randomize()

	if random_source.randi_range(0, 1) == 0:
		player_orientations = [Orientation.UPRIGHT, Orientation.REVERSED]
	else:
		player_orientations = [Orientation.REVERSED, Orientation.UPRIGHT]
	next_player_index = player_orientations.find(Orientation.UPRIGHT)
	phase = Phase.PLAYER_REVEALS
	event_logged.emit("Orientações atribuídas antes da primeira revelação.")
	state_changed.emit()
	return true


func reveal_next() -> bool:
	match phase:
		Phase.PLAYER_REVEALS:
			return _reveal_player_card()
		Phase.EXTERNAL_REVEAL:
			return _reveal_external_card()
		_:
			return _reject("Nenhuma carta pode ser revelada nesta etapa.")


func complete_setup() -> bool:
	if phase != Phase.RESULT:
		return _reject("As cinco cartas precisam ser reveladas antes de iniciar a partida.")

	for reveal in revealed_cards:
		var source_index: int = reveal["source_index"]
		if source_index == -1:
			external_deck.append(reveal["card"])
		else:
			player_decks[source_index].append(reveal["card"])

	for deck in player_decks:
		_shuffle(deck)
	_shuffle(external_deck)
	phase = Phase.COMPLETE
	event_logged.emit("Cartas devolvidas e baralhos embaralhados novamente.")
	state_changed.emit()
	setup_completed.emit(first_player_index, player_decks[0], player_decks[1], external_deck)
	return true


func orientation_name(orientation: int) -> String:
	return "Reta" if orientation == Orientation.UPRIGHT else "Invertida"


func _reveal_player_card() -> bool:
	var source_index := next_player_index
	if player_reveal_counts[source_index] >= 2 or player_decks[source_index].is_empty():
		return _reject("O jogador selecionado não possui uma revelação válida.")

	var card = player_decks[source_index].pop_front()
	var orientation := _roll_orientation()
	_record_reveal(card, source_index, orientation)
	player_reveal_counts[source_index] += 1
	event_logged.emit("Jogador %d revelou %s (%s)." % [
		source_index + 1,
		card.display_name,
		orientation_name(orientation),
	])

	if player_reveal_counts[0] == 2 and player_reveal_counts[1] == 2:
		phase = Phase.EXTERNAL_REVEAL
	else:
		next_player_index = 1 - source_index
	state_changed.emit()
	return true


func _reveal_external_card() -> bool:
	if external_deck.is_empty():
		return _reject("O baralho externo está vazio.")
	var card = external_deck.pop_front()
	var orientation := _roll_orientation()
	_record_reveal(card, -1, orientation)
	event_logged.emit("O baralho externo revelou %s (%s)." % [
		card.display_name,
		orientation_name(orientation),
	])
	first_player_index = player_orientations.find(
		Orientation.UPRIGHT if upright_count > reversed_count else Orientation.REVERSED
	)
	phase = Phase.RESULT
	event_logged.emit("Jogador %d venceu a leitura e começará a partida." % (first_player_index + 1))
	state_changed.emit()
	return true


func _record_reveal(card, source_index: int, orientation: int) -> void:
	revealed_cards.append({
		"card": card,
		"source_index": source_index,
		"orientation": orientation,
	})
	if orientation == Orientation.UPRIGHT:
		upright_count += 1
	else:
		reversed_count += 1


func _roll_orientation() -> int:
	return Orientation.UPRIGHT if random_source.randi_range(0, 1) == 0 else Orientation.REVERSED


func _shuffle(deck: Array) -> void:
	for index in range(deck.size() - 1, 0, -1):
		var swap_index: int = random_source.randi_range(0, index)
		var temporary = deck[index]
		deck[index] = deck[swap_index]
		deck[swap_index] = temporary


func _reject(reason: String) -> bool:
	action_rejected.emit(reason)
	return false
