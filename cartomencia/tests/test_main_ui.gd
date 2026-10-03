extends SceneTree

const DemoDeckFactoryScript = preload("res://scripts/demo_deck_factory.gd")
const MainScene = preload("res://main.tscn")
const CardStateScript = preload("res://scripts/card_state.gd")
const PrototypeDeckFactoryScript = preload("res://scripts/prototype_deck_factory.gd")
const TurnControllerScript = preload("res://scripts/turn_controller.gd")

var failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var configured_size := Vector2i(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
	)
	root.size = configured_size
	var screen = MainScene.instantiate()
	root.add_child(screen)
	await process_frame
	await process_frame

	_expect(screen.find_children("*", "ScrollContainer", true, false).size() >= 4,
		"O turno zero, as duas mãos e as escolhas pendentes devem possuir rolagem própria.")
	_expect(configured_size == Vector2i(1600, 900),
		"A janela do jogo deve estar configurada com a área-base de 1600 por 900.")

	for _reveal_or_completion in range(6):
		screen.setup_button.pressed.emit()
		await process_frame
		await process_frame
	_expect(screen.game_screen.visible and not screen.setup_screen.visible,
		"Depois das cinco revelações e da devolução, a interface deve abrir a partida.")
	_expect(screen.game.players[0].hand.size() == 3 and screen.game.players[1].hand.size() == 3,
		"A interface deve iniciar a partida com três cartas para cada jogador.")
	_expect(screen.game.active_player().energy == 2,
		"O jogador escolhido para começar deve possuir duas energias.")
	_expect(screen.get_tree().get_nodes_in_group("board_slot").size() == 22,
		"O tabuleiro vazio deve mostrar os 22 espaços de campo dos dois jogadores.")

	var player = screen.game.active_player()
	player.hand.clear()
	var neutral_common = CardStateScript.new(
		"ui_neutral", "Carta neutra", CardStateScript.Category.ATTACK, 2, 3, 3
	)
	neutral_common.orientation = CardStateScript.Orientation.UPRIGHT
	player.hand.append(neutral_common)
	screen._request_refresh()
	await process_frame
	await process_frame
	await _select_card(screen, neutral_common)
	_expect("Carta neutra" in screen.detail_label.get_parsed_text(),
		"Selecionar uma carta deve abrir seus detalhes persistentes.")
	_expect("ATQ 3" in _button_text_for_card(screen, neutral_common),
		"O cartão deve mostrar Ataque e Vida sem depender do painel de detalhes.")
	var hand_before: int = player.hand.size()
	var play_button: Button = _find_button(screen, "Jogar no descanso")
	_expect(play_button != null, "A carta selecionada deve exibir a ação Jogar no descanso.")
	if play_button != null:
		play_button.pressed.emit()
		await process_frame
		await process_frame
		_expect(player.hand.size() == hand_before - 1,
			"Clicar em Jogar deve atualizar o estado sem fechar a cena.")
		_expect(_has_visible_text(screen, "SEU DESCANSO  1/3"),
			"O cabeçalho do descanso deve comunicar sua ocupação atual.")
		var discard_button: Button = _find_button(screen, "Fundo do baralho (1)")
		_expect(discard_button != null,
			"A interface deve informar que o descarte comum volta ao fundo do baralho.")
		_expect(discard_button != null and discard_button.get_parent() == screen.context_actions,
			"As ações da carta devem ocupar o painel contextual separado de seus atributos.")
	_expect(screen.game_screen.get_combined_minimum_size().x <= screen.size.x,
		"O conteúdo da partida não pode exigir largura maior que a janela.")
	_expect(screen.game_screen.get_combined_minimum_size().y <= screen.size.y,
		"O conteúdo da partida não pode empurrar as ações para fora da janela.")

	await _press_and_settle(screen, "Encerrar sem atacar")
	await _press_and_settle(screen, "Encerrar sem atacar")
	player = screen.game.active_player()
	var advance_button: Button = _find_button(screen, "Avançar")
	_expect(advance_button != null and not advance_button.disabled,
		"No turno seguinte, a carta deve oferecer o botão Avançar habilitado.")
	if advance_button != null and not advance_button.disabled:
		advance_button.pressed.emit()
		await process_frame
		await process_frame
		_expect(player.attack_field.size() == 1,
			"Clicar em Avançar deve atualizar o campo sem fechar a cena.")
		_expect(_has_visible_text(screen, "SEU ATAQUE  1/5"),
			"O cabeçalho do ataque deve comunicar sua ocupação atual.")

	var special = CardStateScript.new(
		"ui_special", "Especial imediata neutra", CardStateScript.Category.SPECIAL, 1, 0, 0,
		[CardStateScript.EffectTrigger.NONE, CardStateScript.EffectTrigger.NONE],
		[CardStateScript.EffectLifecycle.IMMEDIATE, CardStateScript.EffectLifecycle.IMMEDIATE],
		["ui_immediate", "ui_immediate"]
	)
	special.orientation = CardStateScript.Orientation.UPRIGHT
	for drawn_card in player.hand.duplicate():
		if not drawn_card.is_common():
			player.hand.erase(drawn_card)
	player.hand.append(special)
	if special != null:
		player.energy = 10
		if not player.hand.has(special):
			player.deck.erase(special)
			special.assign_orientation(screen.game.random_source)
			player.hand.append(special)
		screen._request_refresh()
		await process_frame
		await process_frame
		await _select_card(screen, special)
		var use_button: Button = _find_button(screen, "Usar especial")
		_expect(use_button != null, "Uma carta especial selecionada deve oferecer o botão Usar especial.")
		if use_button != null:
			use_button.pressed.emit()
			await process_frame
			await process_frame
			_expect(not player.hand.has(special) and (
				player.special_field.has(special) or player.graveyard.has(special)
			), "Usar uma especial deve movê-la para a área ativa ou para o cemitério.")

	await _test_special_replacement_feedback(screen, player)

	for card in DemoDeckFactoryScript.create_turn_flow_deck("scroll_a"):
		player.hand.append(card)
	for card in DemoDeckFactoryScript.create_turn_flow_deck("scroll_b"):
		player.hand.append(card)
	screen._request_refresh()
	await process_frame
	await process_frame
	var scrolls := screen.find_children("*", "ScrollContainer", true, false)
	var visible_scroll_bar := false
	for scroll in scrolls:
		if scroll.is_visible_in_tree() and scroll.get_h_scroll_bar().visible:
			visible_scroll_bar = true
	_expect(visible_scroll_bar,
		"Uma mão extensa deve ativar a barra de rolagem horizontal sem deslocar o tabuleiro.")

	await _test_combat_target_selection(screen)
	await _test_full_board_layout(screen)
	await process_frame
	await process_frame

	var exit_code := 0 if failures.is_empty() else 1
	if failures.is_empty():
		print("OK: testes de regressão da interface passaram.")
	else:
		for failure in failures:
			push_error(failure)
	screen.game.effects.pending.clear()
	screen.game.effects.modifiers.clear()
	screen.game.effects.restrictions.clear()
	screen.game.effects.special_expiries.clear()
	screen.game.effects.links.clear()
	screen.free()
	call_deferred("_finish", exit_code)


func _finish(exit_code: int) -> void:
	quit(exit_code)


func _press_and_settle(screen, button_text: String) -> void:
	var button: Button = _find_button(screen, button_text)
	_expect(button != null, "Botão '%s' não encontrado." % button_text)
	if button != null:
		button.pressed.emit()
		await process_frame
		await process_frame


func _select_card(screen, card) -> void:
	for button in screen.find_children("*", "Button", true, false):
		if button.has_meta("card") and button.get_meta("card") == card:
			button.pressed.emit()
			await process_frame
			await process_frame
			return
	_expect(false, "Cartão visual não encontrado para seleção.")


func _button_text_for_card(screen, card) -> String:
	for button in screen.find_children("*", "Button", true, false):
		if button.has_meta("card") and button.get_meta("card") == card:
			return button.text
	return ""


func _find_button(node: Node, button_text: String) -> Button:
	var disabled_match: Button = null
	for child in node.find_children("*", "Button", true, false):
		if child.text == button_text:
			if not child.disabled:
				return child as Button
			disabled_match = child as Button
	return disabled_match


func _has_playable_common(cards: Array, energy: int) -> bool:
	for card in cards:
		if card.is_common() and card.energy_cost <= energy:
			return true
	return false


func _find_special_card(player):
	for collection in [player.hand, player.deck]:
		for card in collection:
			if not card.is_common():
				return card
	return null


func _test_special_replacement_feedback(screen, player) -> void:
	var catalog := PrototypeDeckFactoryScript.create_deck()
	var first = _find_card_by_id(catalog, "death")
	var replaced = _find_card_by_id(catalog, "devil")
	var third = _find_card_by_id(catalog, "sun")
	var incoming = _find_card_by_id(catalog, "moon")
	first.orientation = CardStateScript.Orientation.REVERSED
	replaced.orientation = CardStateScript.Orientation.UPRIGHT
	third.orientation = CardStateScript.Orientation.UPRIGHT
	incoming.orientation = CardStateScript.Orientation.UPRIGHT
	for card in [first, replaced, third]:
		card.reveal()
	player.special_field = [first, replaced, third]
	player.graveyard.clear()
	for card in player.hand.duplicate():
		if not card.is_common():
			player.hand.erase(card)
	player.hand.append(incoming)
	player.energy = 100
	screen.game.special_played_this_turn = false
	screen._request_refresh()
	await process_frame
	await process_frame
	await _select_card(screen, incoming)
	var selectors: Array[Node] = screen.find_children("*", "OptionButton", true, false)
	var selector: OptionButton = selectors[0] as OptionButton if not selectors.is_empty() else null
	if selector != null:
		selector.select(1)
	var replace_button: Button = _find_button(screen, "Substituir")
	_expect(selector != null and replace_button != null,
		"A área cheia deve oferecer a escolha de substituição.")
	if replace_button != null:
		replace_button.pressed.emit()
		await process_frame
		await process_frame
		var moon_target_button: Button = _find_button(screen, "Escolher para o efeito")
		if moon_target_button != null:
			moon_target_button.pressed.emit()
			await process_frame
			await process_frame
		_expect(player.special_field[1] == incoming,
			"Uma especial temporária nova deve ocupar exatamente o espaço escolhido.")
		_expect(player.graveyard.has(replaced),
			"A especial antiga deve aparecer no cemitério após a substituição.")
		_expect(_has_visible_text(screen, incoming.display_name),
			"A nova especial ativa deve aparecer na interface.")
		_expect(_has_visible_text(screen, replaced.display_name),
			"O cemitério deve listar o nome da especial substituída.")

	var immediate_catalog := PrototypeDeckFactoryScript.create_deck()
	var immediate = _find_card_by_id(immediate_catalog, "death")
	immediate.orientation = CardStateScript.Orientation.UPRIGHT
	player.attack_field.append(CardStateScript.new(
		"death_own_target", "Sacrifício da Morte", CardStateScript.Category.ATTACK, 1, 4, 4
	))
	var enemy = screen.game.players[1 - screen.game.current_player_index]
	if enemy.attack_field.is_empty():
		enemy.attack_field.append(CardStateScript.new(
			"death_target", "Alvo da Morte", CardStateScript.Category.ATTACK, 1, 4, 4
		))
	player.hand.append(immediate)
	player.energy = 100
	screen.game.special_played_this_turn = false
	screen._request_refresh()
	await process_frame
	await process_frame
	await _select_card(screen, immediate)
	_expect(_has_visible_text(screen, "imediato (vai ao cemitério após resolver)"),
		"A interface deve avisar quando a nova especial não permanecerá ativa.")
	selectors = screen.find_children("*", "OptionButton", true, false)
	selector = selectors[0] as OptionButton if not selectors.is_empty() else null
	if selector != null:
		selector.select(0)
	replace_button = _find_button(screen, "Substituir")
	if replace_button != null:
		replace_button.pressed.emit()
		await process_frame
		await process_frame
		for _choice in range(2):
			var choose_button: Button = _find_button(screen, "Escolher para o efeito")
			if choose_button != null:
				choose_button.pressed.emit()
				await process_frame
				await process_frame
		_expect(not player.special_field.has(immediate) and player.graveyard.has(immediate),
			"Uma especial imediata deve aparecer no cemitério depois da resolução.")
		_expect(_has_visible_text(screen, immediate.display_name),
			"O cemitério visual deve mostrar a especial imediata que deixou o campo.")


func _find_card_by_id(cards: Array, card_id: String):
	for card in cards:
		if card.id == card_id:
			return card
	return null


func _test_combat_target_selection(screen) -> void:
	var attacker_index: int = screen.game.current_player_index
	var attacker = screen.game.players[attacker_index]
	var defender = screen.game.players[1 - attacker_index]
	var attacking_card = CardStateScript.new(
		"ui_attacker", "Atacante da interface", CardStateScript.Category.ATTACK, 2, 3, 3
	)
	var target = CardStateScript.new(
		"ui_target", "Alvo da interface", CardStateScript.Category.SUPPORT, 2, 5, 5
	)
	attacker.attack_field = [attacking_card]
	defender.attack_field = [target]
	screen.game.phase = TurnControllerScript.Phase.PREPARATION
	screen.game.is_match_over = false
	screen._request_refresh()
	await process_frame
	await process_frame
	var attack_action: Button = _find_button(screen, "Atacar e encerrar turno")
	_expect(attack_action != null and not attack_action.disabled,
		"Um campo ofensivo ocupado deve habilitar o ataque na interface.")
	if attack_action != null and not attack_action.disabled:
		attack_action.pressed.emit()
		await process_frame
		await process_frame
		_expect(screen.game.phase == TurnControllerScript.Phase.RESOLVING_ATTACK,
			"Clicar em atacar deve abrir a fase de escolha de alvo.")
		_expect(_has_visible_text(screen, "dano restante: 3"),
			"A interface deve comunicar o dano ainda não distribuído.")
		await _select_card(screen, target)
		var target_button: Button = _find_button(screen, "Receber dano")
		_expect(target_button != null, "Cada alvo adversário deve oferecer um botão de seleção.")
		if target_button != null:
			target_button.pressed.emit()
			await process_frame
			await process_frame
			_expect(target.current_health == 2,
				"Selecionar o alvo deve aplicar o dano e preservar a Vida restante.")
			_expect(screen.game.current_player_index == 1 - attacker_index,
				"Consumir o dano deve encerrar o turno e entregar a vez ao adversário.")


func _test_full_board_layout(screen) -> void:
	var active = screen.game.active_player()
	var opponent = screen.game.players[1 - screen.game.current_player_index]
	active.attack_field = _make_common_cards("active_attack", 5)
	active.rest_field = _make_common_cards("active_rest", 3)
	active.special_field = _make_special_cards("active_special", 3)
	opponent.attack_field = _make_common_cards("enemy_attack", 5)
	opponent.rest_field = _make_common_cards("enemy_rest", 3)
	opponent.special_field = _make_special_cards("enemy_special", 3)
	screen.game.phase = TurnControllerScript.Phase.PREPARATION
	screen._request_refresh()
	await process_frame
	await process_frame
	_expect(screen.get_tree().get_nodes_in_group("board_slot").is_empty(),
		"Com os campos lotados, nenhum espaço vazio deve permanecer.")
	_expect(screen.get_tree().get_nodes_in_group("board_card").size() == 22,
		"As 22 cartas dos campos lotados devem ficar simultaneamente na mesa.")
	_expect(_has_visible_text(screen, "SUAS ESPECIAIS  3/3") and _has_visible_text(screen, "ESPECIAIS ADVERSÁRIAS  3/3"),
		"As duas áreas de especiais devem comunicar sua ocupação real.")
	_expect(screen.game_screen.get_combined_minimum_size().x <= screen.size.x,
		"O tabuleiro lotado não pode ultrapassar a largura de 1600 pixels.")
	_expect(screen.game_screen.get_combined_minimum_size().y <= screen.size.y,
		"O tabuleiro lotado não pode ultrapassar a altura de 900 pixels.")


func _make_common_cards(prefix: String, amount: int) -> Array:
	var cards: Array = []
	for index in range(amount):
		var card = CardStateScript.new("%s_%d" % [prefix, index], "Carta %d" % (index + 1), CardStateScript.Category.ATTACK, 2, 3, 3)
		card.orientation = CardStateScript.Orientation.UPRIGHT
		card.reveal()
		cards.append(card)
	return cards


func _make_special_cards(prefix: String, amount: int) -> Array:
	var cards: Array = []
	for index in range(amount):
		var card = CardStateScript.new("%s_%d" % [prefix, index], "Especial %d" % (index + 1), CardStateScript.Category.SPECIAL, 5, 0, 0)
		card.orientation = CardStateScript.Orientation.UPRIGHT
		card.reveal()
		cards.append(card)
	return cards


func _has_visible_text(node: Node, expected_fragment: String) -> bool:
	for label in node.find_children("*", "Label", true, false):
		if label.is_visible_in_tree() and expected_fragment in label.text:
			return true
	for button in node.find_children("*", "Button", true, false):
		if button.is_visible_in_tree() and expected_fragment in button.text:
			return true
	for rich_text in node.find_children("*", "RichTextLabel", true, false):
		if rich_text.is_visible_in_tree() and expected_fragment in rich_text.get_parsed_text():
			return true
	return false


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
