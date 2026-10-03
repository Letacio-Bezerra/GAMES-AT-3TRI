class_name TurnController
extends RefCounted

const PlayerStateScript = preload("res://scripts/player_state.gd")
const CardStateScript = preload("res://scripts/card_state.gd")
const CardEffectResolverScript = preload("res://scripts/card_effect_resolver.gd")

signal state_changed
signal event_logged(message: String)
signal action_rejected(reason: String)
signal attack_resolved(player_index: int, total_attack: int)
signal attack_target_requested(defender_index: int, remaining_damage: int)
signal match_ended(winner_index: int, reason: String)
signal card_effect_requested(player_index: int, card, trigger: int)
signal special_effect_requested(player_index: int, card, lifecycle: int)
signal special_effect_removed(player_index: int, card)

enum Phase {
	PREPARATION,
	RESOLVING_EFFECT,
	RESOLVING_ATTACK,
	ENDED,
}

var players: Array = []
var current_player_index: int = 0
var round_number: int = 1
var turn_serial: int = 0
var turns_completed_in_round: int = 0
var phase: Phase = Phase.ENDED
var is_match_over: bool = false
var special_played_this_turn: bool = false
var random_source
var pending_attack_damage: int = 0
var attacking_player_index: int = -1
var attack_target_count: int = 0
var attacked_this_turn: bool = false
var advance_after_effect: bool = false
var effects


func start_match(
	first_deck: Array,
	second_deck: Array,
	first_player_index: int = 0,
	provided_random_source = null
) -> void:
	random_source = provided_random_source
	if random_source == null:
		random_source = RandomNumberGenerator.new()
		random_source.randomize()
	players = [
		PlayerStateScript.new("Jogador 1", first_deck),
		PlayerStateScript.new("Jogador 2", second_deck),
	]
	current_player_index = clampi(first_player_index, 0, 1)
	players[current_player_index].gain_energy(2)
	players[1 - current_player_index].gain_energy(3)
	for player in players:
		player.draw_cards(3, random_source)
	round_number = 1
	turn_serial = 0
	turns_completed_in_round = 0
	is_match_over = false
	special_played_this_turn = false
	pending_attack_damage = 0
	attacking_player_index = -1
	attack_target_count = 0
	attacked_this_turn = false
	advance_after_effect = false
	effects = CardEffectResolverScript.new()
	effects.setup(self)
	_begin_turn(false)


func active_player():
	return players[current_player_index]


func play_common_from_hand(card, confirm_lethal_risk: bool = false) -> bool:
	if not _can_prepare():
		return _reject("Ações de preparação não estão disponíveis agora.")
	var player = active_player()
	if not player.hand.has(card):
		return _reject("A carta escolhida não está na mão do jogador ativo.")
	if not card.is_common():
		return _reject("Esta unidade valida somente cartas comuns no fluxo do turno.")
	if not player.has_rest_space():
		return _reject("O campo de descanso está cheio.")
	if not player.can_pay_energy(card.energy_cost):
		return _reject("Energia insuficiente para jogar esta carta.")
	if not effects.can_play_common(card, current_player_index, "rest"):
		return _reject(effects.validation_error)
	if card.current_effect_id() == "chama_instavel" and player.health <= 2 and not confirm_lethal_risk:
		return _reject("Confirme a Chama Instável: ela pode encerrar a partida ao causar 2 de dano.")

	player.spend_energy(card.energy_cost)
	player.hand.erase(card)
	card.reveal()
	card.entered_rest_turn = turn_serial
	player.rest_field.append(card)
	event_logged.emit("%s colocou %s no descanso." % [player.display_name, card.display_name])
	if card.current_effect_trigger() == CardStateScript.EffectTrigger.ON_REST_ENTRY:
		card_effect_requested.emit(current_player_index, card, CardStateScript.EffectTrigger.ON_REST_ENTRY)
		effects.resolve_entry(current_player_index, card)
	state_changed.emit()
	return true


func move_rest_to_attack(card) -> bool:
	if not _can_prepare():
		return _reject("Ações de preparação não estão disponíveis agora.")
	var player = active_player()
	if not player.rest_field.has(card):
		return _reject("A carta escolhida não está no descanso do jogador ativo.")
	if card.entered_rest_turn >= turn_serial:
		return _reject("A carta precisa permanecer no descanso até um turno posterior.")
	if not player.has_attack_space():
		return _reject("O campo de ataque está cheio.")
	if not effects.can_play_common(card, current_player_index, "attack"):
		return _reject(effects.validation_error)

	player.rest_field.erase(card)
	player.attack_field.append(card)
	event_logged.emit("%s avançou %s para o ataque." % [player.display_name, card.display_name])
	if card.current_effect_trigger() == CardStateScript.EffectTrigger.ON_ATTACK_ENTRY:
		card_effect_requested.emit(current_player_index, card, CardStateScript.EffectTrigger.ON_ATTACK_ENTRY)
		effects.resolve_entry(current_player_index, card)
	state_changed.emit()
	return true


func play_special_from_hand(card, replacement_index: int = -1) -> bool:
	if not _can_prepare():
		return _reject("Cartas especiais só podem ser usadas durante a preparação.")
	var player = active_player()
	if not player.hand.has(card) or card.category != CardStateScript.Category.SPECIAL:
		return _reject("A carta escolhida não é uma especial válida da mão.")
	if special_played_this_turn:
		return _reject("Apenas uma carta especial pode ser usada por turno.")
	if not player.can_pay_energy(card.energy_cost):
		return _reject("Energia insuficiente para usar esta carta especial.")
	if not effects.can_play_special(card, current_player_index):
		return _reject(effects.validation_error)
	var insertion_index := -1
	if player.special_field.size() >= PlayerStateScript.SPECIAL_CAPACITY:
		if replacement_index < 0 or replacement_index >= player.special_field.size():
			return _reject("Escolha uma carta especial ativa para substituir.")
		var replaced = player.special_field[replacement_index]
		player.special_field.remove_at(replacement_index)
		insertion_index = replacement_index
		player.graveyard.append(replaced)
		special_effect_removed.emit(current_player_index, replaced)
		effects.on_card_left_field(replaced)
		event_logged.emit("%s substituiu %s." % [player.display_name, replaced.display_name])

	player.spend_energy(card.energy_cost)
	player.hand.erase(card)
	card.reveal()
	if insertion_index >= 0:
		player.special_field.insert(insertion_index, card)
	else:
		player.special_field.append(card)
	special_played_this_turn = true
	var lifecycle: int = card.current_effect_lifecycle()
	event_logged.emit("%s usou %s (%s)." % [
		player.display_name,
		card.display_name,
		card.orientation_label(),
	])
	special_effect_requested.emit(current_player_index, card, lifecycle)
	effects.resolve_special(current_player_index, card)
	state_changed.emit()
	return true


func finish_special_resolution(card) -> bool:
	var player = active_player()
	if not player.special_field.has(card):
		return _reject("A carta especial não está ativa.")
	player.special_field.erase(card)
	effects.on_card_left_field(card)
	player.graveyard.append(card)
	special_effect_removed.emit(current_player_index, card)
	event_logged.emit("%s foi para o cemitério após resolver." % card.display_name)
	state_changed.emit()
	return true


func expire_special(card, owner_index: int) -> bool:
	if owner_index < 0 or owner_index >= players.size():
		return _reject("Dono da carta especial inválido.")
	var owner = players[owner_index]
	if not owner.special_field.has(card):
		return _reject("A carta especial não está ativa.")
	owner.special_field.erase(card)
	effects.on_card_left_field(card)
	owner.graveyard.append(card)
	special_effect_removed.emit(owner_index, card)
	event_logged.emit("O efeito de %s terminou; a carta foi ao cemitério." % card.display_name)
	state_changed.emit()
	return true


func active_effect_ids(player_index: int) -> Array[String]:
	var effect_ids: Array[String] = []
	if player_index < 0 or player_index >= players.size():
		return effect_ids
	for card in players[player_index].special_field:
		var effect_id: String = card.current_effect_id()
		if not effect_id.is_empty():
			effect_ids.append(effect_id)
	return effect_ids


func discard_rest_card(card) -> bool:
	if not _can_prepare():
		return _reject("Ações de preparação não estão disponíveis agora.")
	var player = active_player()
	if not player.rest_field.has(card):
		return _reject("A carta escolhida não está no descanso do jogador ativo.")
	if not player.can_pay_energy(1):
		return _reject("O descarte voluntário custa 1 energia.")

	player.spend_energy(1)
	player.rest_field.erase(card)
	player.send_to_deck_bottom(card)
	event_logged.emit("%s devolveu %s ao fundo do baralho por 1 energia." % [
		player.display_name,
		card.display_name,
	])
	state_changed.emit()
	return true


func attack() -> bool:
	if not _can_prepare():
		return _reject("O ataque não está disponível agora.")
	var player = active_player()
	if player.attack_field.is_empty():
		return _reject("O jogador ativo não possui cartas no campo de ataque.")

	phase = Phase.RESOLVING_ATTACK
	attacking_player_index = current_player_index
	attack_target_count = 0
	attacked_this_turn = true
	var total_attack := 0
	for card in player.attack_field:
		total_attack += effects.attack_value(card, current_player_index)
	pending_attack_damage = total_attack
	event_logged.emit("%s iniciou um ataque conjunto de %d." % [
		player.display_name,
		total_attack,
	])
	attack_resolved.emit(attacking_player_index, total_attack)
	var defender_index := 1 - attacking_player_index
	if _valid_attack_targets(defender_index).is_empty():
		event_logged.emit("Não há alvos no ataque adversário; o dano foi perdido.")
		_finish_attack()
	else:
		attack_target_requested.emit(defender_index, pending_attack_damage)
		state_changed.emit()
	return true


func select_attack_target(card) -> bool:
	if is_match_over or phase != Phase.RESOLVING_ATTACK or attacking_player_index < 0:
		return _reject("Não existe ataque aguardando um alvo.")
	var defender_index := 1 - attacking_player_index
	var defender = players[defender_index]
	if not defender.attack_field.has(card):
		return _reject("O alvo deve estar no campo de ataque adversário.")
	if not effects.is_targetable(attacking_player_index, card):
		return _reject("Esta carta está protegida e não pode ser escolhida como alvo.")
	var forced_target = effects.forced_attack_target(attacking_player_index)
	if attack_target_count == 0 and forced_target != null and card != forced_target:
		return _reject("O primeiro alvo deve ser a carta que provocou este ataque.")

	var result: Dictionary = effects.receive_damage(defender_index, card, pending_attack_damage)
	var applied_damage: int = result["applied"]
	pending_attack_damage = result["remaining"]
	attack_target_count += 1
	event_logged.emit("%s recebeu %d de dano e ficou com %d de Vida." % [
		card.display_name,
		applied_damage,
		maxi(card.current_health, 0),
	])
	if result["defeated"]:
		_defeat_common_card(defender_index, card, "combate")
		if is_match_over:
			state_changed.emit()
			return true

	if pending_attack_damage <= 0 or _valid_attack_targets(defender_index).is_empty():
		if pending_attack_damage > 0:
			event_logged.emit("Sem outros alvos, %d de dano restante foi perdido." % pending_attack_damage)
		_finish_attack()
	else:
		attack_target_requested.emit(defender_index, pending_attack_damage)
		state_changed.emit()
	return true


func damage_card(owner_index: int, card, amount: int, source: String = "efeito") -> bool:
	if not _is_valid_player_index(owner_index) or amount < 0:
		return _reject("Dano ou dono inválido para a carta.")
	var owner = players[owner_index]
	if not owner.attack_field.has(card):
		return _reject("Efeitos de dano só podem atingir cartas no campo de ataque.")
	var result: Dictionary = effects.receive_damage(owner_index, card, amount)
	event_logged.emit("%s recebeu %d de dano por %s." % [card.display_name, result["applied"], source])
	if result["defeated"]:
		_defeat_common_card(owner_index, card, source)
	state_changed.emit()
	return true


func destroy_card(owner_index: int, card, source: String = "efeito") -> bool:
	if not _is_valid_player_index(owner_index):
		return _reject("Dono inválido para a carta destruída.")
	if not players[owner_index].attack_field.has(card):
		return _reject("Somente uma carta no ataque pode ser destruída por este efeito.")
	_defeat_common_card(owner_index, card, source)
	state_changed.emit()
	return true


func heal_player(player_index: int, amount: int, source: String = "efeito") -> bool:
	if not _is_valid_player_index(player_index) or amount < 0:
		return _reject("Cura ou jogador inválido.")
	var player = players[player_index]
	var healed: int = player.heal(amount)
	event_logged.emit("%s recuperou %d de Vida por %s e ficou com %d/%d." % [
		player.display_name, healed, source, player.health, player.max_health,
	])
	state_changed.emit()
	return true


func end_turn() -> bool:
	if not _can_prepare():
		return _reject("O turno não pode ser encerrado novamente.")
	if effects.must_attack(current_player_index):
		return _reject("Este jogador foi provocado e precisa atacar antes de encerrar o turno.")
	event_logged.emit("%s encerrou o turno sem atacar." % active_player().display_name)
	_end_and_advance_turn()
	return true


func gain_energy(player_index: int, amount: int, source: String = "efeito") -> bool:
	if not _is_valid_energy_change(player_index, amount):
		return false
	var player = players[player_index]
	player.gain_energy(amount)
	event_logged.emit("%s recebeu %d energia(s) por %s." % [
		player.display_name,
		amount,
		source,
	])
	state_changed.emit()
	return true


func lose_energy(player_index: int, amount: int, source: String = "efeito") -> bool:
	if not _is_valid_energy_change(player_index, amount):
		return false
	var player = players[player_index]
	var lost: int = player.lose_energy(amount)
	event_logged.emit("%s perdeu %d energia(s) por %s e ficou com %d." % [
		player.display_name,
		lost,
		source,
		player.energy,
	])
	state_changed.emit()
	return true


func _begin_turn(grant_automatic_resources: bool = true) -> void:
	turn_serial += 1
	phase = Phase.PREPARATION
	special_played_this_turn = false
	attacked_this_turn = false
	var player = active_player()
	if grant_automatic_resources and round_number >= 2:
		var drawn = player.draw_cards(2, random_source)
		player.gain_energy(2)
		event_logged.emit("Início do turno de %s: %d carta(s) comprada(s) e +2 energias." % [
			player.display_name,
			drawn.size(),
		])
	else:
		event_logged.emit("Primeira rodada: %s inicia sem compra ou energia automática." % player.display_name)
	effects.on_turn_started(current_player_index)
	_check_total_exhaustion()
	state_changed.emit()


func _end_and_advance_turn() -> void:
	effects.on_turn_ending(current_player_index, attacked_this_turn)
	if is_match_over:
		state_changed.emit()
		return
	_resolve_empty_attack_rule(current_player_index)
	if is_match_over:
		state_changed.emit()
		return
	if phase == Phase.RESOLVING_EFFECT:
		advance_after_effect = true
		state_changed.emit()
		return
	_advance_turn_now()


func finish_effect_resolution() -> void:
	if is_match_over:
		phase = Phase.ENDED
		return
	if advance_after_effect:
		advance_after_effect = false
		_advance_turn_now()
	else:
		phase = Phase.PREPARATION


func _advance_turn_now() -> void:
	phase = Phase.ENDED
	state_changed.emit()
	if is_match_over:
		return
	current_player_index = 1 - current_player_index
	turns_completed_in_round += 1
	if turns_completed_in_round >= 2:
		round_number += 1
		turns_completed_in_round = 0
	_begin_turn()


func _finish_attack() -> void:
	pending_attack_damage = 0
	attacking_player_index = -1
	attack_target_count = 0
	_end_and_advance_turn()


func _defeat_common_card(owner_index: int, card, source: String) -> void:
	var owner = players[owner_index]
	owner.attack_field.erase(card)
	effects.on_card_left_field(card)
	var printed_health: int = card.base_health
	var lost_health: int = owner.take_damage(printed_health)
	var is_token: bool = card.runtime_marks.get("token", false)
	if not is_token:
		owner.send_to_deck_bottom(card)
	event_logged.emit("%s foi derrotada por %s; %s perdeu %d de Vida e %s." % [
		card.display_name,
		source,
		owner.display_name,
		lost_health,
		"a ficha desapareceu" if is_token else "a carta voltou ao fundo do baralho",
	])
	_check_health_defeat(owner_index)


func _resolve_empty_attack_rule(player_index: int) -> void:
	var player = players[player_index]
	if not player.attack_field.is_empty():
		player.empty_attack_warning = false
		return
	if not player.empty_attack_warning:
		player.empty_attack_warning = true
		event_logged.emit("Aviso para %s: termine seu próximo turno com uma carta no ataque." % player.display_name)
		return

	player.empty_attack_warning = false
	if not player.rest_field.is_empty():
		var rest_index: int = random_source.randi_range(0, player.rest_field.size() - 1)
		var moved = player.rest_field[rest_index]
		player.rest_field.remove_at(rest_index)
		player.attack_field.append(moved)
		event_logged.emit("Correção automática: %s avançou %s ao ataque." % [
			player.display_name, moved.display_name,
		])
		if moved.current_effect_trigger() == CardStateScript.EffectTrigger.ON_ATTACK_ENTRY:
			card_effect_requested.emit(player_index, moved, CardStateScript.EffectTrigger.ON_ATTACK_ENTRY)
			effects.resolve_entry(player_index, moved)
		return

	var payable_cards: Array = []
	for card in player.hand:
		if card.is_common() and player.can_pay_energy(card.energy_cost):
			payable_cards.append(card)
	if not payable_cards.is_empty() and player.has_rest_space():
		var hand_index: int = random_source.randi_range(0, payable_cards.size() - 1)
		var placed = payable_cards[hand_index]
		player.spend_energy(placed.energy_cost)
		player.hand.erase(placed)
		placed.reveal()
		placed.entered_rest_turn = turn_serial
		player.rest_field.append(placed)
		event_logged.emit("Correção automática: %s pagou %d e colocou %s no descanso." % [
			player.display_name, placed.energy_cost, placed.display_name,
		])
		if placed.current_effect_trigger() == CardStateScript.EffectTrigger.ON_REST_ENTRY:
			card_effect_requested.emit(player_index, placed, CardStateScript.EffectTrigger.ON_REST_ENTRY)
			effects.resolve_entry(player_index, placed)
		return

	var penalty := ceili(float(player.health) * 0.05)
	var lost_health: int = player.take_damage(penalty)
	event_logged.emit("%s não possuía carta comum pagável e perdeu %d de Vida." % [
		player.display_name, lost_health,
	])
	_check_health_defeat(player_index)


func _check_health_defeat(player_index: int) -> void:
	if players[player_index].health > 0 or is_match_over:
		return
	is_match_over = true
	phase = Phase.ENDED
	var winner_index := 1 - player_index
	match_ended.emit(winner_index, "%s ficou sem Vida." % players[player_index].display_name)


func _check_total_exhaustion() -> void:
	for index in range(players.size()):
		if not players[index].has_any_card():
			is_match_over = true
			phase = Phase.ENDED
			var winner_index := 1 - index
			match_ended.emit(winner_index, "%s ficou sem cartas em todas as áreas." % players[index].display_name)
			return


func _can_prepare() -> bool:
	return not is_match_over and phase == Phase.PREPARATION


func _is_valid_energy_change(player_index: int, amount: int) -> bool:
	if player_index < 0 or player_index >= players.size():
		return _reject("Jogador inválido para alteração de energia.")
	if amount < 0:
		return _reject("A quantidade de energia não pode ser negativa.")
	return true


func _is_valid_player_index(player_index: int) -> bool:
	return player_index >= 0 and player_index < players.size()


func _valid_attack_targets(defender_index: int) -> Array:
	return players[defender_index].attack_field.filter(
		func(target): return effects.is_targetable(attacking_player_index, target)
	)


func _reject(reason: String) -> bool:
	action_rejected.emit(reason)
	return false
