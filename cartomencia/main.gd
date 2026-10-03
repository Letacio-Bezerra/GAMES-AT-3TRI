extends Control

const DemoDeckFactoryScript = preload("res://scripts/demo_deck_factory.gd")
const MatchSetupControllerScript = preload("res://scripts/match_setup_controller.gd")
const PrototypeDeckFactoryScript = preload("res://scripts/prototype_deck_factory.gd")
const TurnControllerScript = preload("res://scripts/turn_controller.gd")
const CardStateScript = preload("res://scripts/card_state.gd")
const PlayerStateScript = preload("res://scripts/player_state.gd")
const CardPresentationScript = preload("res://scripts/card_presentation.gd")

const CARD_SIZE := Vector2(78, 92)
const HAND_CARD_SIZE := Vector2(100, 96)
const CHOICE_CARD_SIZE := Vector2(104, 58)

const COLOR_BACKGROUND := Color("120e1c")
const COLOR_TABLE := Color("281d38")
const COLOR_PANEL := Color("21182e")
const COLOR_EMPTY := Color("30263d")
const COLOR_ATTACK := Color("542934")
const COLOR_SUPPORT := Color("253f4b")
const COLOR_SPECIAL := Color("49325c")
const COLOR_SELECTED := Color("f2c96d")
const COLOR_TARGET := Color("65d6d0")
const COLOR_CHOSEN := Color("7fe39b")
const COLOR_MUTED := Color("786d83")

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
var opponent_hud_label: Label
var player_hud_label: Label
var turn_prompt_label: Label
var hand_box: HBoxContainer
var rest_box: HBoxContainer
var attack_box: HBoxContainer
var opponent_box: VBoxContainer
var player_special_box: HBoxContainer
var opponent_hand_box: HBoxContainer
var opponent_rest_box: HBoxContainer
var opponent_attack_box: HBoxContainer
var opponent_special_box: HBoxContainer
var player_reserve_box: VBoxContainer
var opponent_reserve_box: VBoxContainer
var choice_box: HBoxContainer
var rest_heading_label: Label
var attack_heading_label: Label
var player_special_heading_label: Label
var opponent_rest_heading_label: Label
var opponent_attack_heading_label: Label
var opponent_special_heading_label: Label
var detail_label: RichTextLabel
var context_actions: VBoxContainer
var resolution_actions: HFlowContainer
var log_label: RichTextLabel
var attack_button: Button
var end_turn_button: Button

var selected_card = null
var selected_owner_index: int = -1
var selected_zone: String = ""
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
	background.color = COLOR_BACKGROUND
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_bottom", 10)
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(margin)

	var root_box := VBoxContainer.new()
	root_box.add_theme_constant_override("separation", 6)
	root_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(root_box)

	var title := Label.new()
	title.text = "CARTOMÊNCIA  •  duelo de tarólogos"
	title.add_theme_font_size_override("font_size", 21)
	title.add_theme_color_override("font_color", Color("eadcf5"))
	root_box.add_child(title)

	setup_screen = VBoxContainer.new()
	setup_screen.size_flags_vertical = Control.SIZE_EXPAND_FILL
	setup_screen.add_theme_constant_override("separation", 10)
	root_box.add_child(setup_screen)
	_build_setup_interface()

	game_screen = VBoxContainer.new()
	game_screen.visible = false
	game_screen.size_flags_vertical = Control.SIZE_EXPAND_FILL
	game_screen.add_theme_constant_override("separation", 5)
	root_box.add_child(game_screen)
	_build_game_interface()


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

	var reveal_panel := _panel(COLOR_PANEL)
	reveal_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	setup_screen.add_child(reveal_panel)
	var reveal_margin := _margin(12, 10)
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


func _build_game_interface() -> void:
	status_label = Label.new()
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.add_theme_color_override("font_color", Color("d9c5ef"))
	status_label.add_theme_font_size_override("font_size", 15)
	game_screen.add_child(status_label)

	var workspace := HBoxContainer.new()
	workspace.size_flags_vertical = Control.SIZE_EXPAND_FILL
	workspace.add_theme_constant_override("separation", 8)
	game_screen.add_child(workspace)

	var table_panel := _panel(COLOR_TABLE, Color("58456c"), 2)
	table_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	table_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	workspace.add_child(table_panel)
	var table_margin := _margin(8, 6)
	table_panel.add_child(table_margin)
	var table := VBoxContainer.new()
	table.add_theme_constant_override("separation", 3)
	table.size_flags_vertical = Control.SIZE_EXPAND_FILL
	table_margin.add_child(table)

	var opponent_header := HBoxContainer.new()
	opponent_header.custom_minimum_size.y = 34
	table.add_child(opponent_header)
	opponent_hud_label = Label.new()
	opponent_hud_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	opponent_hud_label.add_theme_font_size_override("font_size", 15)
	opponent_header.add_child(opponent_hud_label)
	var opponent_hand_title := Label.new()
	opponent_hand_title.text = "MÃO ADVERSÁRIA"
	opponent_hand_title.add_theme_color_override("font_color", Color("a899b7"))
	opponent_header.add_child(opponent_hand_title)
	var opponent_hand_scroll := ScrollContainer.new()
	opponent_hand_scroll.custom_minimum_size = Vector2(380, 34)
	opponent_hand_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	opponent_hand_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	opponent_header.add_child(opponent_hand_scroll)
	opponent_hand_box = HBoxContainer.new()
	opponent_hand_box.add_theme_constant_override("separation", 4)
	opponent_hand_scroll.add_child(opponent_hand_box)

	var opponent_utility := HBoxContainer.new()
	opponent_utility.custom_minimum_size.y = 108
	opponent_utility.add_theme_constant_override("separation", 5)
	table.add_child(opponent_utility)
	opponent_reserve_box = _create_reserve_zone(opponent_utility, "RESERVAS ADVERSÁRIAS")
	opponent_box = opponent_reserve_box
	var opponent_special_zone := _create_field_zone(opponent_utility, "ESPECIAIS  0/3", 3.0)
	opponent_special_box = opponent_special_zone["content"]
	opponent_special_heading_label = opponent_special_zone["heading"]
	var opponent_rest_zone := _create_field_zone(opponent_utility, "DESCANSO  0/3", 3.0)
	opponent_rest_box = opponent_rest_zone["content"]
	opponent_rest_heading_label = opponent_rest_zone["heading"]

	var opponent_attack_zone := _create_field_zone(table, "ATAQUE ADVERSÁRIO  0/5", 1.0)
	opponent_attack_zone["panel"].custom_minimum_size.y = 110
	opponent_attack_box = opponent_attack_zone["content"]
	opponent_attack_heading_label = opponent_attack_zone["heading"]

	var center_panel := _panel(Color("352542"), Color("8b6ca5"), 1)
	center_panel.custom_minimum_size.y = 78
	table.add_child(center_panel)
	var center_margin := _margin(8, 5)
	center_panel.add_child(center_margin)
	var center := VBoxContainer.new()
	center.add_theme_constant_override("separation", 4)
	center_margin.add_child(center)
	turn_prompt_label = Label.new()
	turn_prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	turn_prompt_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	turn_prompt_label.add_theme_color_override("font_color", Color("f1dca1"))
	center.add_child(turn_prompt_label)
	var center_bottom := HBoxContainer.new()
	center_bottom.size_flags_vertical = Control.SIZE_EXPAND_FILL
	center_bottom.add_theme_constant_override("separation", 8)
	center.add_child(center_bottom)
	var choice_scroll := ScrollContainer.new()
	choice_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	choice_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	choice_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	center_bottom.add_child(choice_scroll)
	choice_box = HBoxContainer.new()
	choice_box.add_theme_constant_override("separation", 5)
	choice_scroll.add_child(choice_box)
	resolution_actions = HFlowContainer.new()
	resolution_actions.custom_minimum_size.x = 180
	center_bottom.add_child(resolution_actions)

	var player_attack_zone := _create_field_zone(table, "SEU ATAQUE  0/5", 1.0)
	player_attack_zone["panel"].custom_minimum_size.y = 110
	attack_box = player_attack_zone["content"]
	attack_heading_label = player_attack_zone["heading"]

	var player_utility := HBoxContainer.new()
	player_utility.custom_minimum_size.y = 108
	player_utility.add_theme_constant_override("separation", 5)
	table.add_child(player_utility)
	player_reserve_box = _create_reserve_zone(player_utility, "SUAS RESERVAS")
	var player_special_zone := _create_field_zone(player_utility, "ESPECIAIS  0/3", 3.0)
	player_special_box = player_special_zone["content"]
	player_special_heading_label = player_special_zone["heading"]
	var player_rest_zone := _create_field_zone(player_utility, "DESCANSO  0/3", 3.0)
	rest_box = player_rest_zone["content"]
	rest_heading_label = player_rest_zone["heading"]

	player_hud_label = Label.new()
	player_hud_label.custom_minimum_size.y = 26
	player_hud_label.add_theme_font_size_override("font_size", 15)
	table.add_child(player_hud_label)
	active_player_label = player_hud_label

	var hand_zone := _panel(Color("1d1728"), Color("59456d"), 1)
	hand_zone.custom_minimum_size.y = 106
	table.add_child(hand_zone)
	var hand_margin := _margin(6, 4)
	hand_zone.add_child(hand_margin)
	var hand_column := VBoxContainer.new()
	hand_column.add_theme_constant_override("separation", 3)
	hand_margin.add_child(hand_column)
	var hand_title := Label.new()
	hand_title.text = "SUA MÃO — selecione uma carta para ver o efeito e as ações"
	hand_title.add_theme_color_override("font_color", Color("b9a6c8"))
	hand_column.add_child(hand_title)
	var hand_scroll := ScrollContainer.new()
	hand_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	hand_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	hand_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	hand_column.add_child(hand_scroll)
	hand_box = HBoxContainer.new()
	hand_box.add_theme_constant_override("separation", 6)
	hand_scroll.add_child(hand_box)

	var inspector_panel := _panel(COLOR_PANEL, Color("5d496e"), 2)
	inspector_panel.custom_minimum_size.x = 330
	inspector_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	workspace.add_child(inspector_panel)
	var inspector_margin := _margin(10, 8)
	inspector_panel.add_child(inspector_margin)
	var inspector := VBoxContainer.new()
	inspector.add_theme_constant_override("separation", 7)
	inspector_margin.add_child(inspector)
	var detail_title := Label.new()
	detail_title.text = "CARTA SELECIONADA"
	detail_title.add_theme_font_size_override("font_size", 17)
	detail_title.add_theme_color_override("font_color", Color("e6c979"))
	inspector.add_child(detail_title)
	detail_label = RichTextLabel.new()
	detail_label.bbcode_enabled = true
	detail_label.fit_content = false
	detail_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	detail_label.custom_minimum_size.y = 240
	inspector.add_child(detail_label)
	var action_title := Label.new()
	action_title.text = "AÇÕES CONTEXTUAIS"
	action_title.add_theme_color_override("font_color", Color("bba6ce"))
	inspector.add_child(action_title)
	context_actions = VBoxContainer.new()
	context_actions.custom_minimum_size.y = 108
	context_actions.add_theme_constant_override("separation", 5)
	inspector.add_child(context_actions)
	var global_title := Label.new()
	global_title.text = "AÇÕES DO TURNO"
	global_title.add_theme_color_override("font_color", Color("bba6ce"))
	inspector.add_child(global_title)
	var global_actions := HFlowContainer.new()
	global_actions.add_theme_constant_override("h_separation", 6)
	global_actions.add_theme_constant_override("v_separation", 6)
	inspector.add_child(global_actions)
	attack_button = Button.new()
	attack_button.text = "Atacar e encerrar turno"
	attack_button.pressed.connect(_on_attack_pressed)
	global_actions.add_child(attack_button)
	end_turn_button = Button.new()
	end_turn_button.text = "Encerrar sem atacar"
	end_turn_button.pressed.connect(_on_end_turn_pressed)
	global_actions.add_child(end_turn_button)
	var history_title := Label.new()
	history_title.text = "HISTÓRICO"
	history_title.add_theme_color_override("font_color", Color("bba6ce"))
	inspector.add_child(history_title)
	log_label = RichTextLabel.new()
	log_label.bbcode_enabled = true
	log_label.fit_content = false
	log_label.custom_minimum_size.y = 145
	inspector.add_child(log_label)


func _panel(color: Color, border_color: Color = Color.TRANSPARENT, border_width: int = 0) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _style_box(color, border_color, border_width, 7))
	return panel


func _margin(horizontal: int, vertical: int) -> MarginContainer:
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", horizontal)
	margin.add_theme_constant_override("margin_right", horizontal)
	margin.add_theme_constant_override("margin_top", vertical)
	margin.add_theme_constant_override("margin_bottom", vertical)
	return margin


func _style_box(color: Color, border_color: Color, border_width: int, radius: int = 5) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = border_color
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(radius)
	style.content_margin_left = 5
	style.content_margin_right = 5
	style.content_margin_top = 4
	style.content_margin_bottom = 4
	return style


func _create_field_zone(parent: Container, title: String, stretch: float) -> Dictionary:
	var panel := _panel(Color("20182a"), Color("493b57"), 1)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_stretch_ratio = stretch
	parent.add_child(panel)
	var margin := _margin(5, 3)
	panel.add_child(margin)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 2)
	margin.add_child(column)
	var heading := Label.new()
	heading.text = title
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.add_theme_font_size_override("font_size", 12)
	heading.add_theme_color_override("font_color", Color("ac9cba"))
	column.add_child(heading)
	var content := HBoxContainer.new()
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	content.add_theme_constant_override("separation", 5)
	content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.add_child(content)
	return {"panel": panel, "heading": heading, "content": content}


func _create_reserve_zone(parent: Container, title: String) -> VBoxContainer:
	var panel := _panel(Color("1b1525"), Color("493b57"), 1)
	panel.custom_minimum_size.x = 174
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	parent.add_child(panel)
	var margin := _margin(6, 4)
	panel.add_child(margin)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 2)
	margin.add_child(box)
	var heading := Label.new()
	heading.text = title
	heading.add_theme_font_size_override("font_size", 11)
	heading.add_theme_color_override("font_color", Color("ac9cba"))
	box.add_child(heading)
	return box


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
	setup_orientations_label.text = "Jogador 1: %s  •  Jogador 2: %s" % [setup.orientation_name(setup.player_orientations[0]), setup.orientation_name(setup.player_orientations[1])]
	_clear(setup_reveals_box)
	if setup.revealed_cards.is_empty():
		_add_text(setup_reveals_box, "Nenhuma carta revelada.")
	for index in range(setup.revealed_cards.size()):
		var reveal = setup.revealed_cards[index]
		var source := "Baralho externo" if reveal["source_index"] == -1 else "Jogador %d" % (reveal["source_index"] + 1)
		_add_text(setup_reveals_box, "%d. %s — %s — %s" % [index + 1, source, reveal["card"].display_name, setup.orientation_name(reveal["orientation"])])

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
			setup_status_label.text = "%d retas × %d invertidas. Jogador %d começa a partida." % [setup.upright_count, setup.reversed_count, setup.first_player_index + 1]
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
	_validate_selection()
	var player_index: int = game.current_player_index
	var opponent_index: int = 1 - player_index
	var player = game.players[player_index]
	var opponent = game.players[opponent_index]

	status_label.text = "RODADA %d  •  TURNO %d  •  %s" % [game.round_number, game.turn_serial, _phase_label().to_upper()]
	opponent_hud_label.text = "%s  •  VIDA %d/%d  •  ENERGIA %d  •  MÃO %d" % [opponent.display_name, opponent.health, opponent.max_health, opponent.energy, opponent.hand.size()]
	player_hud_label.text = "%s  •  VIDA %d/%d  •  ENERGIA %d  •  BARALHO %d  •  MÃO %d%s" % [player.display_name, player.health, player.max_health, player.energy, player.deck.size(), player.hand.size(), "  •  AVISO: OCUPE O ATAQUE" if player.empty_attack_warning else ""]
	rest_heading_label.text = "SEU DESCANSO  %d/%d" % [player.rest_field.size(), PlayerStateScript.REST_CAPACITY]
	attack_heading_label.text = "SEU ATAQUE  %d/%d" % [player.attack_field.size(), PlayerStateScript.ATTACK_CAPACITY]
	player_special_heading_label.text = "SUAS ESPECIAIS  %d/%d" % [player.special_field.size(), PlayerStateScript.SPECIAL_CAPACITY]
	opponent_rest_heading_label.text = "DESCANSO ADVERSÁRIO  %d/%d" % [opponent.rest_field.size(), PlayerStateScript.REST_CAPACITY]
	opponent_attack_heading_label.text = "ATAQUE ADVERSÁRIO  %d/%d" % [opponent.attack_field.size(), PlayerStateScript.ATTACK_CAPACITY]
	opponent_special_heading_label.text = "ESPECIAIS ADVERSÁRIAS  %d/%d" % [opponent.special_field.size(), PlayerStateScript.SPECIAL_CAPACITY]
	turn_prompt_label.text = _turn_prompt(player)

	for box in [opponent_hand_box, opponent_reserve_box, opponent_special_box, opponent_rest_box, opponent_attack_box, choice_box, attack_box, player_reserve_box, player_special_box, rest_box, hand_box, context_actions, resolution_actions]:
		_clear(box)

	_render_opponent_hand(opponent, opponent_index)
	_render_reserves(opponent_reserve_box, opponent, opponent_index)
	_render_field(opponent_special_box, opponent.special_field, PlayerStateScript.SPECIAL_CAPACITY, opponent_index, "special")
	_render_field(opponent_rest_box, opponent.rest_field, PlayerStateScript.REST_CAPACITY, opponent_index, "rest")
	_render_field(opponent_attack_box, opponent.attack_field, PlayerStateScript.ATTACK_CAPACITY, opponent_index, "attack")
	_render_pending_choices()
	_render_field(attack_box, player.attack_field, PlayerStateScript.ATTACK_CAPACITY, player_index, "attack")
	_render_reserves(player_reserve_box, player, player_index)
	_render_field(player_special_box, player.special_field, PlayerStateScript.SPECIAL_CAPACITY, player_index, "special")
	_render_field(rest_box, player.rest_field, PlayerStateScript.REST_CAPACITY, player_index, "rest")
	_render_player_hand(player, player_index)
	_render_inspector(player)
	_render_resolution_actions()

	attack_button.disabled = game.phase != TurnControllerScript.Phase.PREPARATION or player.attack_field.is_empty()
	end_turn_button.disabled = game.phase != TurnControllerScript.Phase.PREPARATION


func _turn_prompt(player) -> String:
	if game.phase == TurnControllerScript.Phase.RESOLVING_EFFECT and not game.effects.pending.is_empty():
		return "EFEITO PENDENTE  •  %s" % game.effects.pending["prompt"]
	if game.phase == TurnControllerScript.Phase.RESOLVING_ATTACK:
		return "COMBATE  •  escolha o próximo alvo  •  dano restante: %d" % game.pending_attack_damage
	if game.is_match_over:
		return "PARTIDA ENCERRADA"
	if player.empty_attack_warning:
		return "PREPARAÇÃO  •  coloque uma carta no ataque antes de encerrar este turno"
	return "PREPARAÇÃO  •  organize sua mesa antes de atacar ou encerrar"


func _render_opponent_hand(opponent, owner_index: int) -> void:
	var reveal_options: Array = []
	if game.phase == TurnControllerScript.Phase.RESOLVING_EFFECT and not game.effects.pending.is_empty():
		for option in game.effects.pending["options"]:
			if opponent.hand.has(option):
				reveal_options.append(option)
	if not reveal_options.is_empty():
		for card in opponent.hand:
			_add_card_button(opponent_hand_box, card, owner_index, "hand", CHOICE_CARD_SIZE, false)
		return
	for index in range(opponent.hand.size()):
		var back := Button.new()
		back.text = "✦\nCARTA"
		back.disabled = true
		back.custom_minimum_size = Vector2(46, 30)
		back.tooltip_text = "Carta oculta %d de %d" % [index + 1, opponent.hand.size()]
		back.add_theme_stylebox_override("disabled", _style_box(Color("34234a"), Color("765aa0"), 1, 4))
		opponent_hand_box.add_child(back)
	if opponent.hand.is_empty():
		_add_text(opponent_hand_box, "Mão vazia")


func _render_player_hand(player, owner_index: int) -> void:
	if player.hand.is_empty():
		_add_text(hand_box, "Mão vazia")
	for card in player.hand:
		_add_card_button(hand_box, card, owner_index, "hand", HAND_CARD_SIZE, false)


func _render_field(container: HBoxContainer, cards: Array, capacity: int, owner_index: int, zone: String) -> void:
	for index in range(capacity):
		if index < cards.size():
			_add_card_button(container, cards[index], owner_index, zone, CARD_SIZE, false)
		else:
			_add_empty_slot(container, zone, index)


func _render_reserves(container: VBoxContainer, player, owner_index: int) -> void:
	_add_text(container, "Baralho: %d cartas" % player.deck.size())
	_add_text(container, "Cemitério: %d" % player.graveyard.size())
	if player.graveyard.is_empty():
		_add_muted_text(container, "Nenhuma especial")
	else:
		for card in player.graveyard:
			var button := Button.new()
			button.text = card.display_name
			button.alignment = HORIZONTAL_ALIGNMENT_LEFT
			button.custom_minimum_size.y = 22
			button.pressed.connect(_on_card_selected.bind(card, owner_index, "graveyard"))
			container.add_child(button)


func _render_pending_choices() -> void:
	if game.phase != TurnControllerScript.Phase.RESOLVING_EFFECT or game.effects.pending.is_empty():
		_add_muted_text(choice_box, "Nenhuma escolha pendente")
		return
	for option in game.effects.pending["options"]:
		_add_card_button(choice_box, option, _owner_index_of(option), "choice", CHOICE_CARD_SIZE, false)


func _render_resolution_actions() -> void:
	if game.phase == TurnControllerScript.Phase.RESOLVING_EFFECT and not game.effects.pending.is_empty() and game.effects.pending["max"] != 1:
		var count := Label.new()
		count.text = "Selecionadas: %d/%d" % [game.effects.pending["selected"].size(), game.effects.pending["max"]]
		resolution_actions.add_child(count)
		var confirm := Button.new()
		confirm.text = "Confirmar efeito"
		confirm.disabled = game.effects.pending["selected"].size() < game.effects.pending["min"]
		confirm.pressed.connect(_on_confirm_effect_pressed)
		resolution_actions.add_child(confirm)


func _add_empty_slot(container: HBoxContainer, zone: String, index: int) -> void:
	var slot := Button.new()
	slot.name = "Empty_%s_%d" % [zone, index]
	slot.add_to_group("board_slot")
	slot.text = "%s\nVAZIO" % zone.to_upper()
	slot.disabled = true
	slot.custom_minimum_size = CARD_SIZE
	slot.add_theme_color_override("font_disabled_color", COLOR_MUTED)
	slot.add_theme_stylebox_override("disabled", _style_box(COLOR_EMPTY, Color("5a4b66"), 1, 5))
	container.add_child(slot)


func _add_card_button(container: Container, card, owner_index: int, zone: String, card_size: Vector2, hidden: bool) -> Button:
	var button := Button.new()
	button.name = "Card_%s_%s" % [zone, card.id]
	button.add_to_group("board_card" if zone != "hand" else "hand_card")
	button.set_meta("card", card)
	button.set_meta("owner_index", owner_index)
	button.set_meta("zone", zone)
	button.custom_minimum_size = card_size
	button.text = "✦\nCARTA OCULTA" if hidden else _compact_card_text(card)
	button.clip_text = true
	button.autowrap_mode = TextServer.AUTOWRAP_OFF
	button.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	button.add_theme_font_size_override("font_size", 9 if card_size == CARD_SIZE else 10)
	button.tooltip_text = "Carta oculta" if hidden else "%s\n%s" % [_card_summary(card), CardPresentationScript.effect_text(card)]
	button.disabled = hidden
	var border := Color("6c5a79")
	var width := 1
	if card == selected_card:
		border = COLOR_SELECTED
		width = 3
	elif _is_pending_selected(card):
		border = COLOR_CHOSEN
		width = 3
	elif _is_valid_target(card):
		border = COLOR_TARGET
		width = 3
		button.add_to_group("valid_target")
	var base_color := _category_color(card.category)
	button.add_theme_stylebox_override("normal", _style_box(base_color, border, width, 6))
	button.add_theme_stylebox_override("hover", _style_box(base_color.lightened(0.10), COLOR_SELECTED, 2, 6))
	button.add_theme_stylebox_override("pressed", _style_box(base_color.darkened(0.10), COLOR_SELECTED, 3, 6))
	button.add_theme_stylebox_override("disabled", _style_box(base_color.darkened(0.15), border, width, 6))
	button.pressed.connect(_on_card_selected.bind(card, owner_index, zone))
	container.add_child(button)
	return button


func _compact_card_text(card) -> String:
	var effect_name := CardPresentationScript.effect_title(card)
	if card.is_common():
		return "%s\n%s • %s • E%d\nATQ %d  •  VIDA %d/%d\n%s" % [card.display_name, card.category_label(), card.orientation_label(), card.energy_cost, card.attack, card.current_health, card.max_health, effect_name]
	return "%s\nESPECIAL • %s • E%d\n%s\n%s" % [card.display_name, card.orientation_label(), card.energy_cost, effect_name, _special_lifecycle_label(card.current_effect_lifecycle())]


func _render_inspector(player) -> void:
	if selected_card == null:
		detail_label.text = "[color=#9b8ba8]Selecione uma carta da sua mão ou uma carta pública da mesa. Aqui aparecem o efeito completo, os atributos e os modificadores ativos.[/color]"
		_add_muted_text(context_actions, "Nenhuma carta selecionada")
		return

	var card = selected_card
	var owner_name: String = game.players[selected_owner_index].display_name if selected_owner_index >= 0 else "Carta consultada"
	var details := "[font_size=20][b]%s[/b][/font_size]\n[color=#b8a6c8]%s • %s • %s[/color]\n" % [card.display_name, owner_name, card.category_label(), card.orientation_label()]
	details += "[b]Custo:[/b] %d Energia\n" % card.energy_cost
	if card.is_common():
		details += "[b]Ataque:[/b] %d (base %d)\n[b]Vida:[/b] %d/%d (base %d)\n" % [card.attack, card.base_attack, card.current_health, card.max_health, card.base_health]
	else:
		details += "[b]Permanência:[/b] %s\n" % _special_lifecycle_label(card.current_effect_lifecycle())
	details += "\n[color=#e6c979][b]%s[/b][/color]\n%s" % [CardPresentationScript.effect_title(card), CardPresentationScript.effect_text(card)]
	var active_states := _active_state_lines(card)
	if not active_states.is_empty():
		details += "\n\n[color=#8ee6cf][b]Estados ativos[/b][/color]\n%s" % "\n".join(active_states)
	detail_label.text = details

	if game.phase == TurnControllerScript.Phase.RESOLVING_EFFECT and _is_effect_option(card):
		var choose := Button.new()
		choose.text = "Remover seleção" if _is_pending_selected(card) else "Escolher para o efeito"
		choose.pressed.connect(_on_effect_option_pressed.bind(card))
		context_actions.add_child(choose)
		return
	if game.phase == TurnControllerScript.Phase.RESOLVING_ATTACK and _is_attack_target(card):
		var target := Button.new()
		target.text = "Receber dano"
		target.pressed.connect(_on_attack_target_pressed.bind(card))
		context_actions.add_child(target)
		return
	if game.phase != TurnControllerScript.Phase.PREPARATION or selected_owner_index != game.current_player_index:
		_add_muted_text(context_actions, "Carta apenas para consulta neste momento")
		return
	match selected_zone:
		"hand":
			if card.is_common():
				var lethal_risk: bool = card.current_effect_id() == "chama_instavel" and player.health <= 2
				var effect_valid: bool = game.effects.can_play_common(card, game.current_player_index, "rest")
				var play := Button.new()
				play.text = "Confirmar: perder 2 de Vida" if lethal_risk else "Jogar no descanso"
				play.disabled = player.energy < card.energy_cost or not player.has_rest_space() or not effect_valid
				play.pressed.connect(_on_play_card_pressed.bind(card, lethal_risk))
				context_actions.add_child(play)
				if play.disabled:
					_add_muted_text(context_actions, _common_play_block_reason(player, card, effect_valid))
			else:
				_add_special_hand_controls(context_actions, card, player)
		"rest":
			var advance_effect_valid: bool = game.effects.can_play_common(card, game.current_player_index, "attack")
			var advance := Button.new()
			advance.text = "Avançar"
			advance.disabled = card.entered_rest_turn >= game.turn_serial or not player.has_attack_space() or not advance_effect_valid
			advance.pressed.connect(_on_advance_card_pressed.bind(card))
			context_actions.add_child(advance)
			var discard := Button.new()
			discard.text = "Fundo do baralho (1)"
			discard.disabled = player.energy < 1
			discard.pressed.connect(_on_discard_card_pressed.bind(card))
			context_actions.add_child(discard)
		_:
			_add_muted_text(context_actions, "Esta carta não possui ação voluntária nesta zona")


func _common_play_block_reason(player, card, effect_valid: bool) -> String:
	if player.energy < card.energy_cost:
		return "Energia insuficiente: precisa de %d." % card.energy_cost
	if not player.has_rest_space():
		return "O campo de descanso está cheio."
	if not effect_valid:
		return game.effects.validation_error
	return "A carta não pode ser jogada agora."


func _active_state_lines(card) -> Array[String]:
	var lines: Array[String] = []
	for modifier in game.effects.modifiers:
		if modifier.get("card") == card:
			lines.append("• %s: Ataque %+d, Vida %+d" % [str(modifier.get("id", "modificador")).replace("_", " ").capitalize(), modifier.get("attack", 0), modifier.get("health", 0)])
	for restriction in game.effects.restrictions:
		if restriction.get("card") == card:
			lines.append("• %s" % str(restriction.get("id", "restrição")).replace("_", " ").capitalize())
	for mark in card.runtime_marks:
		if card.runtime_marks[mark] is bool and card.runtime_marks[mark]:
			lines.append("• %s" % str(mark).replace("_", " ").capitalize())
	return lines


func _add_special_hand_controls(parent: Container, card, player) -> void:
	var effect_valid: bool = game.effects.can_play_special(card, game.current_player_index)
	if player.special_field.size() < PlayerStateScript.SPECIAL_CAPACITY:
		var use_button := Button.new()
		use_button.text = "Usar especial"
		use_button.disabled = player.energy < card.energy_cost or game.special_played_this_turn or not effect_valid
		use_button.pressed.connect(_on_play_special_pressed.bind(card))
		parent.add_child(use_button)
		if use_button.disabled:
			_add_muted_text(parent, game.effects.validation_error if not effect_valid else "Energia insuficiente ou uma especial já foi usada neste turno.")
		return
	var selector := OptionButton.new()
	for index in range(player.special_field.size()):
		selector.add_item("Substituir: %s" % player.special_field[index].display_name, index)
	parent.add_child(selector)
	var replace_button := Button.new()
	replace_button.text = "Substituir"
	replace_button.disabled = player.energy < card.energy_cost or game.special_played_this_turn or not effect_valid
	replace_button.pressed.connect(_on_replace_special_pressed.bind(card, selector))
	parent.add_child(replace_button)


func _on_card_selected(card, owner_index: int, zone: String) -> void:
	selected_card = card
	selected_owner_index = owner_index
	selected_zone = zone
	_request_refresh()


func _validate_selection() -> void:
	if selected_card == null or game.players.is_empty():
		return
	var location := _locate_card(selected_card)
	if location.is_empty():
		if game.phase == TurnControllerScript.Phase.RESOLVING_EFFECT and not game.effects.pending.is_empty() and game.effects.pending["options"].has(selected_card):
			return
		selected_card = null
		selected_owner_index = -1
		selected_zone = ""
		return
	selected_owner_index = location["owner"]
	selected_zone = location["zone"]


func _locate_card(card) -> Dictionary:
	for owner_index in range(game.players.size()):
		var player = game.players[owner_index]
		for entry in [["hand", player.hand], ["rest", player.rest_field], ["attack", player.attack_field], ["special", player.special_field], ["graveyard", player.graveyard]]:
			if entry[1].has(card):
				return {"owner": owner_index, "zone": entry[0]}
	return {}


func _owner_index_of(card) -> int:
	var location := _locate_card(card)
	return location.get("owner", game.current_player_index)


func _is_effect_option(card) -> bool:
	return game.phase == TurnControllerScript.Phase.RESOLVING_EFFECT and not game.effects.pending.is_empty() and game.effects.pending["options"].has(card)


func _is_pending_selected(card) -> bool:
	return _is_effect_option(card) and game.effects.pending["selected"].has(card)


func _is_attack_target(card) -> bool:
	if game.phase != TurnControllerScript.Phase.RESOLVING_ATTACK:
		return false
	var defender_index: int = 1 - game.attacking_player_index
	if not game.players[defender_index].attack_field.has(card):
		return false
	var forced_target = game.effects.forced_attack_target(game.attacking_player_index)
	return game.effects.is_targetable(game.attacking_player_index, card) and (game.attack_target_count > 0 or forced_target == null or forced_target == card)


func _is_valid_target(card) -> bool:
	return _is_effect_option(card) or _is_attack_target(card)


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
		return "%s | %s" % [card.summary(), CardPresentationScript.effect_title(card)]
	return "%s | %s | efeito %s" % [card.summary(), CardPresentationScript.effect_title(card), _special_lifecycle_label(card.current_effect_lifecycle())]


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


func _category_color(category: int) -> Color:
	match category:
		CardStateScript.Category.ATTACK:
			return COLOR_ATTACK
		CardStateScript.Category.SUPPORT:
			return COLOR_SUPPORT
		_:
			return COLOR_SPECIAL


func _add_text(parent: Container, text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_OFF if parent is HBoxContainer else TextServer.AUTOWRAP_WORD_SMART
	parent.add_child(label)
	return label


func _add_muted_text(parent: Container, text: String) -> Label:
	var label := _add_text(parent, text)
	label.add_theme_color_override("font_color", Color("8f829b"))
	label.add_theme_font_size_override("font_size", 11)
	return label


func _clear(container: Container) -> void:
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
	turn_prompt_label.text = "AÇÃO RECUSADA  •  %s" % reason
	log_label.append_text("[color=#ff8f8f]• Ação recusada: %s[/color]\n" % reason)


func _on_attack_resolved(_player_index: int, total_attack: int) -> void:
	log_label.append_text("[color=#ffcf70]• Ataque conjunto preparado com %d de dano.[/color]\n" % total_attack)


func _on_match_ended(winner_index: int, reason: String) -> void:
	log_label.append_text("[color=#9dffad]• Vitória de %s: %s[/color]\n" % [game.players[winner_index].display_name, reason])
