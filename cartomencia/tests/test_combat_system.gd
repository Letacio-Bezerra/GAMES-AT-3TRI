extends SceneTree

const CardStateScript = preload("res://scripts/card_state.gd")
const TurnControllerScript = preload("res://scripts/turn_controller.gd")

class ScriptedRandom:
	extends RefCounted

	func randi_range(from: int, _to: int) -> int:
		return from


var failures: Array[String] = []


func _init() -> void:
	_test_initial_and_maximum_player_health()
	_test_combined_attack_and_sequential_targets()
	_test_excess_damage_is_lost_without_direct_hit()
	_test_damage_persistence_effect_scope_and_destruction()
	_test_health_and_total_exhaustion_victories()
	_test_empty_attack_warning_and_automatic_move()
	_test_automatic_hand_placement_and_failure_penalty()
	if failures.is_empty():
		print("OK: todos os testes do sistema de combate passaram.")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _new_game():
	var game := TurnControllerScript.new()
	game.start_match(_deck("a"), _deck("b"), 0, ScriptedRandom.new())
	return game


func _deck(prefix: String) -> Array:
	var cards: Array = []
	for index in range(12):
		cards.append(_card("%s_%d" % [prefix, index], 2, 2,
			CardStateScript.Category.ATTACK))
	return cards


func _card(card_id: String, attack: int, health: int, category: int = CardStateScript.Category.ATTACK):
	return CardStateScript.new(card_id, card_id, category, 2, attack, health)


func _prevent_empty_attack_correction(game) -> void:
	for index in range(2):
		if game.players[index].attack_field.is_empty():
			game.players[index].attack_field.append(_card("guard_%d" % index, 0, 99))


func _test_initial_and_maximum_player_health() -> void:
	var game = _new_game()
	_expect(game.players[0].health == 50 and game.players[1].health == 50,
		"Os dois jogadores devem iniciar com 50 de Vida.")
	game.players[0].health = 49
	_expect(game.heal_player(0, 3, "teste"), "Uma cura válida deve ser aplicada.")
	_expect(game.players[0].health == 50,
		"Cura excedente deve ser limitada à Vida máxima configurada.")
	game.heal_player(0, 10, "teste")
	_expect(game.players[0].health == 50,
		"Curar um jogador na Vida máxima não pode ultrapassar 50.")


func _test_combined_attack_and_sequential_targets() -> void:
	var game = _new_game()
	var attacker = game.players[0]
	var defender = game.players[1]
	attacker.attack_field = [
		_card("ataque_7", 7, 7),
		_card("suporte_8", 8, 8, CardStateScript.Category.SUPPORT),
	]
	var first_target = _card("alvo_10a", 10, 10)
	var second_target = _card("alvo_10b", 10, 10)
	defender.attack_field = [first_target, second_target]
	_expect(game.attack(), "Ataques e suportes no campo devem iniciar um ataque conjunto.")
	_expect(game.phase == TurnControllerScript.Phase.RESOLVING_ATTACK and game.pending_attack_damage == 15,
		"O ataque conjunto deve somar 7 + 8 e aguardar a escolha de alvo.")
	_expect(game.select_attack_target(first_target), "O primeiro alvo adversário deve aceitar o dano total.")
	_expect(game.pending_attack_damage == 5 and game.phase == TurnControllerScript.Phase.RESOLVING_ATTACK,
		"Derrotar o primeiro alvo deve deixar 5 de dano para uma nova escolha.")
	_expect(defender.health == 40 and defender.deck.back() == first_target,
		"A derrota deve causar a Vida impressa ao dono e devolver a carta ao fundo.")
	_expect(game.select_attack_target(second_target), "O dano restante deve poder escolher um segundo alvo.")
	_expect(second_target.current_health == 5 and second_target.attack == 10,
		"Dano não letal deve persistir sem reduzir o Ataque da carta.")
	_expect(game.current_player_index == 1 and game.phase == TurnControllerScript.Phase.PREPARATION,
		"Depois de consumir todo o dano, o ataque deve encerrar o turno.")


func _test_excess_damage_is_lost_without_direct_hit() -> void:
	var game = _new_game()
	var attacker = game.players[0]
	var defender = game.players[1]
	attacker.attack_field = [_card("forca_15", 15, 15)]
	var only_target = _card("alvo_4", 4, 4)
	defender.attack_field = [only_target]
	game.attack()
	game.select_attack_target(only_target)
	_expect(defender.health == 46,
		"Sem outro alvo, somente a Vida impressa da carta derrotada deve atingir o dono.")
	_expect(game.pending_attack_damage == 0 and game.current_player_index == 1,
		"Os 11 pontos excedentes devem ser perdidos e o turno deve terminar.")


func _test_damage_persistence_effect_scope_and_destruction() -> void:
	var game = _new_game()
	var defender = game.players[1]
	var target = _card("persistente", 10, 10)
	var safe_rest = _card("descanso_seguro", 6, 6)
	defender.attack_field = [target]
	defender.rest_field = [safe_rest]
	_expect(game.damage_card(1, target, 6, "teste"),
		"Um efeito deve poder causar dano a uma carta no ataque.")
	_expect(target.current_health == 4 and target.attack == 10,
		"O dano deve persistir na Vida atual sem alterar o Ataque.")
	_expect(not game.damage_card(1, safe_rest, 3, "teste"),
		"Um efeito de dano não pode atingir o campo de descanso.")
	_expect(safe_rest.current_health == 6,
		"Uma carta no descanso deve permanecer sem dano.")
	var health_before: int = defender.health
	_expect(game.destroy_card(1, target, "destruição de teste"),
		"Destruir uma carta no ataque deve contar como derrota normal.")
	_expect(defender.health == health_before - 10 and defender.deck.back() == target,
		"A destruição deve causar dano impresso ao dono e devolver a carta ao fundo renovada.")
	_expect(target.current_health == target.base_health,
		"A carta destruída deve ser renovada ao retornar ao baralho.")


func _test_health_and_total_exhaustion_victories() -> void:
	var game = _new_game()
	var defender = game.players[1]
	defender.health = 4
	var lethal_target = _card("letal", 4, 5)
	defender.attack_field = [lethal_target]
	game.players[0].attack_field = [_card("finalizador", 5, 5)]
	game.attack()
	game.select_attack_target(lethal_target)
	_expect(game.is_match_over and defender.health == 0,
		"A derrota de uma carta deve encerrar a partida quando a Vida do dono chega a zero.")

	game = _new_game()
	var exhausted = game.players[0]
	exhausted.deck.clear()
	exhausted.rest_field.clear()
	exhausted.attack_field.clear()
	exhausted.special_field.clear()
	_expect(not exhausted.hand.is_empty(),
		"O cenário deve manter uma carta na mão antes de verificar esgotamento parcial.")
	game._check_total_exhaustion()
	_expect(not game.is_match_over,
		"Baralho vazio isoladamente não pode causar derrota por esgotamento.")
	exhausted.hand.clear()
	game._check_total_exhaustion()
	_expect(game.is_match_over,
		"Sem cartas em nenhuma das cinco áreas, o jogador deve perder por esgotamento.")


func _test_empty_attack_warning_and_automatic_move() -> void:
	var game = _new_game()
	var player = game.players[0]
	var opponent = game.players[1]
	player.attack_field.clear()
	var waiting = _card("espera", 3, 3)
	player.rest_field = [waiting]
	opponent.attack_field = [_card("guarda", 1, 20)]
	var energy_before: int = player.energy
	game.end_turn()
	_expect(player.empty_attack_warning and player.rest_field.has(waiting),
		"O primeiro fim de turno vazio deve apenas registrar o aviso.")
	game.end_turn()
	game.end_turn()
	_expect(not player.empty_attack_warning and player.attack_field.has(waiting),
		"O segundo fim de turno próprio vazio deve mover aleatoriamente uma carta do descanso.")
	_expect(player.energy == energy_before + 2,
		"A movimentação automática do descanso deve ser gratuita.")

	game = _new_game()
	player = game.players[0]
	opponent = game.players[1]
	player.empty_attack_warning = true
	player.attack_field = [_card("ocupante", 2, 2)]
	opponent.attack_field = [_card("guarda_2", 1, 20)]
	game.end_turn()
	_expect(not player.empty_attack_warning,
		"Ocupar o ataque antes de encerrar deve reiniciar a contagem de inatividade.")


func _test_automatic_hand_placement_and_failure_penalty() -> void:
	var game = _new_game()
	var player = game.players[0]
	var opponent = game.players[1]
	var payable = _card("pagavel", 2, 2)
	payable.assign_orientation(game.random_source)
	player.hand = [payable]
	player.deck.clear()
	player.rest_field.clear()
	player.attack_field.clear()
	player.energy = 2
	opponent.attack_field = [_card("guarda", 1, 20)]
	game.end_turn()
	game.end_turn()
	player.energy = 2
	game.end_turn()
	_expect(player.rest_field.has(payable) and not player.hand.has(payable),
		"Sem descanso, a correção deve escolher uma carta comum pagável da mão.")
	_expect(player.energy == 0,
		"A colocação automática da mão deve cobrar o custo impresso.")

	game = _new_game()
	player = game.players[0]
	opponent = game.players[1]
	var special = CardStateScript.new(
		"especial", "Especial", CardStateScript.Category.SPECIAL, 5, 0, 0
	)
	player.hand = [special]
	player.deck.clear()
	player.rest_field.clear()
	player.attack_field.clear()
	opponent.attack_field = [_card("guarda_penalidade", 1, 20)]
	game.end_turn()
	game.end_turn()
	game.end_turn()
	_expect(player.health == 47 and not player.empty_attack_warning,
		"Falhar com 50 de Vida deve causar teto de 5% = 3 e reiniciar a contagem.")
	game.end_turn()
	game.end_turn()
	_expect(player.health == 47 and player.empty_attack_warning,
		"No turno próprio seguinte, o jogador deve receber novo aviso sem penalidade imediata.")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
