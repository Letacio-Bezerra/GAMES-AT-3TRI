extends Control

const DemoDeckFactoryScript = preload("res://scripts/demo_deck_factory.gd")
const MatchSetupControllerScript = preload("res://scripts/match_setup_controller.gd")
const PrototypeDeckFactoryScript = preload("res://scripts/prototype_deck_factory.gd")
const TurnControllerScript = preload("res://scripts/turn_controller.gd")
const CardStateScript = preload("res://scripts/card_state.gd")
const PlayerStateScript = preload("res://scripts/player_state.gd")

var setup := MatchSetupControllerScript.new()
var game := TurnControllerScript.new()
var setup_screen: VBoxContainer
var game_screen: VBoxContainer
var setup_status_label: Label
var setup_orientations_label: Label
var setup_reveals_box: VBoxContainer
var setup_button: Button
var status_label: Label
var active_player_label: Label
var hand_box: VBoxContainer
var rest_box: VBoxContainer
var attack_box: VBoxContainer
var opponent_box: VBoxContainer
var rest_heading_label: Label
var attack_heading_label: Label
var log_label: RichTextLabel
var attack_button: Button
var end_turn_button: Button
var refresh_pending: bool = false
var setup_refresh_pending: bool = false


func _ready() -> void:
	_build_interface()
	setup.event_logged.connect(_append_setup_log)
	setup.action_rejected.connect(_on_setup_action_rejected)
	setup.state_changed.connect(_request_setup_refresh)
	setup.setup_completed.connect(_on_setup_completed)
	game.event_logged.connect(_append_log)
	game.action_rejected.connect(_on_action_rejected)
	game.state_changed.connect(_request_refresh)
	game.attack_resolved.connect(_on_attack_resolved)
	game.match_ended.connect(_on_match_ended)
	setup.start_setup(
		PrototypeDeckFactoryScript.create_deck(),
		PrototypeDeckFactoryScript.create_deck(),
		DemoDeckFactoryScript.create_external_deck()
	)


func _build_interface() -> void:
	var background := ColorRect.new()
	background.color = Color("171321")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_top", 18)
	margin.add_theme_constant_override("margin_right", 24)
	margin.add_theme_constant_override("margin_bottom", 18)
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(margin)

	var root_box := VBoxContainer.new()
	root_box.add_theme_constant_override("separation", 10)
	root_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(root_box)

	var title := Label.new()
	title.text = "Cartomência — Núcleo Jogável"
	title.add_theme_font_size_override("font_size", 24)
	root_box.add_child(title)

	setup_screen = VBoxContainer.new()
	setup_screen.size_flags_vertical = Control.SIZE_EXPAND_FILL
	setup_screen.add_theme_constant_override("separation", 10)
	root_box.add_child(setup_screen)
	_build_setup_interface()

	game_screen = VBoxContainer.new()
	game_screen.visible = false
	game_screen.size_flags_vertical = Control.SIZE_EXPAND_FILL
	game_screen.add_theme_constant_override("separation", 10)
	root_box.add_child(game_screen)

	status_label = Label.new()
	status_label.add_theme_color_override("font_color", Color("d6b8ff"))
	game_screen.add_child(status_label)

	active_player_label = Label.new()
	active_player_label.add_theme_font_size_override("font_size", 18)
	game_screen.add_child(active_player_label)

	var columns := HBoxContainer.new()
	columns.size_flags_vertical = Control.SIZE_EXPAND_FILL
	columns.add_theme_constant_override("separation", 14)
	game_screen.add_child(columns)

	var hand_zone := _create_zone(columns, "Mão — clique em Jogar", 2.0)
	hand_box = hand_zone["content"]
	var rest_zone := _create_zone(columns, "Descanso", 2.0)
	rest_box = rest_zone["content"]
	rest_heading_label = rest_zone["heading"]
	var attack_zone := _create_zone(columns, "Ataque", 2.0)
	attack_box = attack_zone["content"]
	attack_heading_label = attack_zone["heading"]
	var opponent_zone := _create_zone(columns, "Especiais / adversário", 1.6)
	opponent_box = opponent_zone["content"]

	var actions := HFlowContainer.new()
	actions.add_theme_constant_override("separation", 10)
	game_screen.add_child(actions)

	attack_button = Button.new()
	attack_button.text = "Atacar e encerrar turno"
	attack_button.pressed.connect(_on_attack_pressed)
	actions.add_child(attack_button)

	end_turn_button = Button.new()
	end_turn_button.text = "Encerrar sem atacar"
	end_turn_button.pressed.connect(_on_end_turn_pressed)
	actions.add_child(end_turn_button)

	var hint := Label.new()
	hint.text = "Cartas novas aguardam até o próximo turno do dono antes de avançar. Cartas comuns retiradas do descanso custam 1 energia e voltam ao fundo do baralho; cartas especiais resolvidas ou substituídas vão ao cemitério."
	hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	game_screen.add_child(hint)

	log_label = RichTextLabel.new()
	log_label.bbcode_enabled = true
	log_label.fit_content = false
	log_label.custom_minimum_size.y = 110
	log_label.size_flags_vertical = Control.SIZE_FILL
	game_screen.add_child(log_label)


func _build_setup_interface() -> void:
	var heading := Label.new()
	heading.text = "Turno Zero — Leitura inicial"
	heading.add_theme_font_size_override("font_size", 20)
	setup_screen.add_child(heading)

	setup_status_label = Label.new()
	setup_status_label.add_theme_color_override("font_color", Color("d6b8ff"))
	setup_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	setup_screen.add_child(setup_status_label)

	setup_orientations_label = Label.new()
	setup_orientations_label.add_theme_font_size_override("font_size", 17)
	setup_orientations_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	setup_screen.add_child(setup_orientations_label)

	var reveal_panel := PanelContainer.new()
	reveal_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	setup_screen.add_child(reveal_panel)
	var reveal_margin := MarginContainer.new()
	reveal_margin.add_theme_constant_override("margin_left", 12)
	reveal_margin.add_theme_constant_override("margin_top", 10)
	reveal_margin.add_theme_constant_override("margin_right", 12)
	reveal_margin.add_theme_constant_override("margin_bottom", 10)
	reveal_panel.add_child(reveal_margin)
	var reveal_column := VBoxContainer.new()
	reveal_column.add_theme_constant_override("separation", 8)
	reveal_margin.add_child(reveal_column)
	var reveal_title := Label.new()
	reveal_title.text = "Cartas no centro da mesa"
	reveal_title.add_theme_font_size_override("font_size", 17)
	reveal_column.add_child(reveal_title)
	var reveal_scroll := ScrollContainer.new()
	reveal_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	reveal_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	reveal_column.add_child(reveal_scroll)
	setup_reveals_box = VBoxContainer.new()
	setup_reveals_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	setup_reveals_box.add_theme_constant_override("separation", 6)
	reveal_scroll.add_child(setup_reveals_box)

	setup_button = Button.new()
	setup_button.pressed.connect(_on_setup_button_pressed)
	setup_screen.add_child(setup_button)


func _create_zone(parent: HBoxContainer, title: String, stretch: float) -> Dictionary:
	var panel := PanelContainer.new()
	panel.custom_minimum_size.x = 260
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.size_flags_stretch_ratio = stretch
	parent.add_child(panel)
	var margin := MarginContainer.new()
	margin.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_bottom", 8)
	panel.add_child(margin)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(box)
	var heading := Label.new()
	heading.text = title
	heading.add_theme_font_size_override("font_size", 16)
	box.add_child(heading)
	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	box.add_child(scroll)
	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(content)
	return {"content": content, "heading": heading}


func _request_setup_refresh() -> void:
	if setup_refresh_pending:
		return
	setup_refresh_pending = true
	call_deferred("_apply_pending_setup_refresh")


func _apply_pending_setup_refresh() -> void:
	setup_refresh_pending = false
	_refresh_setup()


func _refresh_setup() -> void:
	if setup.player_orientations.size() != 2:
		return
	setup_orientations_label.text = "Jogador 1: %s  •  Jogador 2: %s" % [
		setup.orientation_name(setup.player_orientations[0]),
		setup.orientation_name(setup.player_orientations[1]),
	]
	_clear(setup_reveals_box)
	if setup.revealed_cards.is_empty():
		_add_text(setup_reveals_box, "Nenhuma carta revelada.")
	for index in range(setup.revealed_cards.size()):
		var reveal = setup.revealed_cards[index]
		var source := "Baralho externo" if reveal["source_index"] == -1 else "Jogador %d" % (reveal["source_index"] + 1)
		_add_text(setup_reveals_box, "%d. %s — %s — %s" % [
			index + 1,
			source,
			reveal["card"].display_name,
			setup.orientation_name(reveal["orientation"]),
		])

	match setup.phase:
		MatchSetupControllerScript.Phase.PLAYER_REVEALS:
			setup_status_label.text = "Revelação %d de 4 dos jogadores. O jogador associado às cartas retas revela primeiro." % (setup.revealed_cards.size() + 1)
			setup_button.text = "Revelar próxima carta"
			setup_button.disabled = false
		MatchSetupControllerScript.Phase.EXTERNAL_REVEAL:
			setup_status_label.text = "As quatro cartas dos jogadores foram reveladas. Falta a quinta carta, do baralho externo."
			setup_button.text = "Revelar carta externa"
			setup_button.disabled = false
		MatchSetupControllerScript.Phase.RESULT:
			setup_status_label.text = "%d retas × %d invertidas. Jogador %d começa a partida." % [
				setup.upright_count,
				setup.reversed_count,
				setup.first_player_index + 1,
			]
			setup_button.text = "Devolver cartas e iniciar partida"
			setup_button.disabled = false
		MatchSetupControllerScript.Phase.COMPLETE:
			setup_status_label.text = "Turno zero concluído."
			setup_button.disabled = true


func _on_setup_button_pressed() -> void:
	if setup.phase == MatchSetupControllerScript.Phase.RESULT:
		setup.complete_setup()
	else:
		setup.reveal_next()


func _on_setup_completed(first_player_index: int, first_deck: Array, second_deck: Array, _external_deck: Array) -> void:
	setup_screen.visible = false
	game_screen.visible = true
	game.start_match(first_deck, second_deck, first_player_index)


func _append_setup_log(_message: String) -> void:
	# O histórico visual do turno zero é representado diretamente pelas cartas
	# reveladas; o sinal permanece disponível para telemetria e testes futuros.
	pass


func _on_setup_action_rejected(reason: String) -> void:
	setup_status_label.text = "Ação recusada: %s" % reason


func _request_refresh() -> void:
	if refresh_pending:
		return
	refresh_pending = true
	call_deferred("_apply_pending_refresh")


func _apply_pending_refresh() -> void:
	refresh_pending = false
	_refresh()


func _refresh() -> void:
	if game.players.is_empty():
		return
	var player = game.active_player()
	var opponent = game.players[1 - game.current_player_index]
	status_label.text = "Rodada %d  •  Turno global %d  •  Fase: %s" % [
		game.round_number,
		game.turn_serial,
		_phase_label(),
	]
	active_player_label.text = "%s  •  Vida: %d/%d  •  Energia: %d  •  Baralho: %d  •  Mão: %d%s" % [
		player.display_name,
		player.health,
		player.max_health,
		player.energy,
		player.deck.size(),
		player.hand.size(),
		"  •  AVISO: ocupe o ataque neste turno" if player.empty_attack_warning else "",
	]
	rest_heading_label.text = "Descanso — %d/%d espaços" % [
		player.rest_field.size(),
		PlayerStateScript.REST_CAPACITY,
	]
	attack_heading_label.text = "Ataque — %d/%d espaços" % [
		player.attack_field.size(),
		PlayerStateScript.ATTACK_CAPACITY,
	]
	_clear(hand_box)
	_clear(rest_box)
	_clear(attack_box)
	_clear(opponent_box)

	if player.hand.is_empty():
		_add_text(hand_box, "Mão vazia")
	for card in player.hand:
		var row := _card_row(hand_box, _card_summary(card))
		if card.is_common():
			var button := Button.new()
			var lethal_risk: bool = card.current_effect_id() == "chama_instavel" and player.health <= 2
			button.text = "Confirmar: perder 2 de Vida" if lethal_risk else "Jogar"
			button.disabled = game.phase != TurnControllerScript.Phase.PREPARATION or player.energy < card.energy_cost or not player.has_rest_space()
			button.pressed.connect(_on_play_card_pressed.bind(card, lethal_risk))
			row.add_child(button)
		else:
			_add_special_hand_controls(row, card, player)

	if player.rest_field.is_empty():
		_add_text(rest_box, "Nenhuma carta")
	for card in player.rest_field:
		var row := _card_row(rest_box, _card_summary(card))
		var advance := Button.new()
		advance.text = "Avançar"
		advance.disabled = game.phase != TurnControllerScript.Phase.PREPARATION or card.entered_rest_turn >= game.turn_serial or not player.has_attack_space()
		advance.pressed.connect(_on_advance_card_pressed.bind(card))
		row.add_child(advance)
		var discard := Button.new()
		discard.text = "Fundo do baralho (1)"
		discard.disabled = game.phase != TurnControllerScript.Phase.PREPARATION or player.energy < 1
		discard.pressed.connect(_on_discard_card_pressed.bind(card))
		row.add_child(discard)

	if player.attack_field.is_empty():
		_add_text(attack_box, "Nenhuma carta")
	for card in player.attack_field:
		_card_row(attack_box, _card_summary(card))

	_add_text(opponent_box, "Suas especiais: %d/%d  •  Cemitério: %d" % [
		player.special_field.size(),
		PlayerStateScript.SPECIAL_CAPACITY,
		player.graveyard.size(),
	])
	for special in player.special_field:
		_card_row(opponent_box, _card_summary(special))
	if player.graveyard.is_empty():
		_add_text(opponent_box, "Cemitério vazio")
	else:
		_add_text(opponent_box, "Cemitério:")
		for discarded_special in player.graveyard:
			_add_text(opponent_box, "• %s" % discarded_special.display_name)
	_add_text(opponent_box, "\n%s\nVida: %d/%d\nEnergia: %d\nBaralho: %d\nMão: %d\nDescanso: %d/%d\nAtaque: %d/%d\nEspeciais: %d/%d\nCemitério: %d" % [
		opponent.display_name,
		opponent.health,
		opponent.max_health,
		opponent.energy,
		opponent.deck.size(),
		opponent.hand.size(),
		opponent.rest_field.size(),
		PlayerStateScript.REST_CAPACITY,
		opponent.attack_field.size(),
		PlayerStateScript.ATTACK_CAPACITY,
		opponent.special_field.size(),
		PlayerStateScript.SPECIAL_CAPACITY,
		opponent.graveyard.size(),
	])
	if game.phase == TurnControllerScript.Phase.RESOLVING_EFFECT and not game.effects.pending.is_empty():
		_add_text(opponent_box, "\n%s" % game.effects.pending["prompt"])
		for option in game.effects.pending["options"]:
			var option_actions := _card_row(opponent_box, _card_summary(option))
			var option_button := Button.new()
			var selected: bool = game.effects.pending["selected"].has(option)
			option_button.text = "Remover seleção" if selected else "Escolher para o efeito"
			option_button.pressed.connect(_on_effect_option_pressed.bind(option))
			option_actions.add_child(option_button)
		if game.effects.pending["max"] != 1:
			var confirm_actions := _card_row(opponent_box, "Selecionadas: %d de %d" % [game.effects.pending["selected"].size(), game.effects.pending["max"]])
			var confirm_button := Button.new()
			confirm_button.text = "Confirmar efeito"
			confirm_button.disabled = game.effects.pending["selected"].size() < game.effects.pending["min"]
			confirm_button.pressed.connect(_on_confirm_effect_pressed)
			confirm_actions.add_child(confirm_button)
	elif game.phase == TurnControllerScript.Phase.RESOLVING_ATTACK:
		_add_text(opponent_box, "\nEscolha o alvo • Dano restante: %d" % game.pending_attack_damage)
		for target in opponent.attack_field:
			var target_actions := _card_row(opponent_box, _card_summary(target))
			var target_button := Button.new()
			target_button.text = "Receber dano"
			var forced_target = game.effects.forced_attack_target(game.attacking_player_index)
			target_button.disabled = not game.effects.is_targetable(game.attacking_player_index, target) or (game.attack_target_count == 0 and forced_target != null and forced_target != target)
			target_button.pressed.connect(_on_attack_target_pressed.bind(target))
			target_actions.add_child(target_button)
	attack_button.disabled = game.phase != TurnControllerScript.Phase.PREPARATION or player.attack_field.is_empty()
	end_turn_button.disabled = game.phase != TurnControllerScript.Phase.PREPARATION


func _phase_label() -> String:
	match game.phase:
		TurnControllerScript.Phase.PREPARATION:
			return "Preparação"
		TurnControllerScript.Phase.RESOLVING_ATTACK:
			return "Escolha de alvo (%d de dano)" % game.pending_attack_damage
		TurnControllerScript.Phase.RESOLVING_EFFECT:
			return "Resolução de efeito"
		_:
			return "Encerrado"


func _card_summary(card) -> String:
	if card.is_common():
		return card.summary()
	return "%s | efeito %s" % [card.summary(), _special_lifecycle_label(card.current_effect_lifecycle())]


func _special_lifecycle_label(lifecycle: int) -> String:
	match lifecycle:
		CardStateScript.EffectLifecycle.IMMEDIATE:
			return "imediato (vai ao cemitério após resolver)"
		CardStateScript.EffectLifecycle.TEMPORARY:
			return "temporário"
		CardStateScript.EffectLifecycle.CONTINUOUS:
			return "contínuo"
		CardStateScript.EffectLifecycle.RESOLVER_DECIDES:
			return "definido pela resolução"
		_:
			return "sem permanência"


func _card_row(parent: VBoxContainer, text: String) -> HFlowContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(panel)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_top", 6)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_bottom", 6)
	panel.add_child(margin)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 6)
	margin.add_child(content)
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_child(label)
	var actions := HFlowContainer.new()
	actions.add_theme_constant_override("h_separation", 6)
	actions.add_theme_constant_override("v_separation", 6)
	content.add_child(actions)
	return actions


func _add_special_hand_controls(row: HFlowContainer, card, player) -> void:
	if player.special_field.size() < 3:
		var use_button := Button.new()
		use_button.text = "Usar"
		use_button.disabled = game.phase != TurnControllerScript.Phase.PREPARATION or player.energy < card.energy_cost or game.special_played_this_turn
		use_button.pressed.connect(_on_play_special_pressed.bind(card))
		row.add_child(use_button)
		return
	var selector := OptionButton.new()
	for index in range(player.special_field.size()):
		selector.add_item("Trocar %d" % (index + 1), index)
	row.add_child(selector)
	var replace_button := Button.new()
	replace_button.text = "Substituir"
	replace_button.disabled = game.phase != TurnControllerScript.Phase.PREPARATION or player.energy < card.energy_cost or game.special_played_this_turn
	replace_button.pressed.connect(_on_replace_special_pressed.bind(card, selector))
	row.add_child(replace_button)


func _add_text(parent: VBoxContainer, text: String) -> void:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	parent.add_child(label)


func _clear(container: VBoxContainer) -> void:
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()


func _on_play_card_pressed(card, confirm_lethal_risk: bool = false) -> void:
	game.play_common_from_hand(card, confirm_lethal_risk)


func _on_advance_card_pressed(card) -> void:
	game.move_rest_to_attack(card)


func _on_discard_card_pressed(card) -> void:
	game.discard_rest_card(card)


func _on_play_special_pressed(card) -> void:
	game.play_special_from_hand(card)


func _on_replace_special_pressed(card, selector: OptionButton) -> void:
	game.play_special_from_hand(card, selector.get_selected_id())


func _on_attack_pressed() -> void:
	game.attack()


func _on_attack_target_pressed(card) -> void:
	game.select_attack_target(card)


func _on_effect_option_pressed(card) -> void:
	game.effects.choose_effect_option(card)


func _on_confirm_effect_pressed() -> void:
	game.effects.confirm_effect_choice()


func _on_end_turn_pressed() -> void:
	game.end_turn()


func _append_log(message: String) -> void:
	log_label.append_text("• %s\n" % message)


func _on_action_rejected(reason: String) -> void:
	log_label.append_text("[color=#ff8f8f]• Ação recusada: %s[/color]\n" % reason)


func _on_attack_resolved(_player_index: int, total_attack: int) -> void:
	log_label.append_text("[color=#ffcf70]• Ataque conjunto preparado com %d de dano.[/color]\n" % total_attack)


func _on_match_ended(winner_index: int, reason: String) -> void:
	log_label.append_text("[color=#9dffad]• Vitória de %s: %s[/color]\n" % [
		game.players[winner_index].display_name,
		reason,
	])
