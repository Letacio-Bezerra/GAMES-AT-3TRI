class_name CardEffectResolver
extends RefCounted

const CardStateScript = preload("res://scripts/card_state.gd")

var _game_ref: WeakRef
var game:
	get:
		return _game_ref.get_ref()
var pending: Dictionary = {}
var validation_error: String = ""
var modifiers: Array[Dictionary] = []
var restrictions: Array[Dictionary] = []
var special_expiries: Array[Dictionary] = []
var links: Array[Dictionary] = []
var player_end_counts := [0, 0]
var player_start_counts := [0, 0]
var global_end_count: int = 0
var energy_blocks_until_end := [-1, -1]


func setup(turn_controller) -> void:
	_game_ref = weakref(turn_controller)


func can_play_common(card, owner_index: int, destination: String) -> bool:
	validation_error = ""
	var effect: String = card.current_effect_id()
	var owner = game.players[owner_index]
	var enemy = game.players[1 - owner_index]
	if destination == "rest":
		if effect in ["sete_possibilidades", "ilusao_revelada"] and owner.deck.is_empty():
			return _invalid("O efeito exige ao menos uma carta no próprio baralho.")
		if effect == "roubo" and enemy.hand.is_empty():
			return _invalid("Roubo exige ao menos uma carta na mão adversária.")
	else:
		var own_others := _targetable(owner_index, owner.attack_field.filter(func(c): return c != card))
		var enemies := _targetable(owner_index, enemy.attack_field)
		match effect:
			"generosidade", "uniao":
				if own_others.is_empty(): return _invalid("O efeito exige outra carta própria no ataque.")
			"divida", "relacao_rompida", "confronto", "coracao_partido", "ferida_profunda":
				if enemies.is_empty(): return _invalid("O efeito exige uma carta inimiga no ataque.")
			"caos":
				if enemies.size() < 2: return _invalid("Caos exige duas cartas inimigas no ataque.")
	return true


func can_play_special(card, owner_index: int) -> bool:
	validation_error = ""
	var effect: String = card.current_effect_id()
	var owner = game.players[owner_index]
	var enemy = game.players[1 - owner_index]
	match effect:
		"transformacao":
			if _targetable(owner_index, owner.attack_field).is_empty() or _targetable(owner_index, enemy.attack_field).is_empty():
				return _invalid("Transformação exige uma carta comum em cada campo de ataque.")
		"resistencia_a_morte":
			if _targetable(owner_index, owner.attack_field.filter(func(c): return c.current_health <= 5)).is_empty():
				return _invalid("Resistência à Morte exige uma carta própria com até 5 de Vida.")
		"pacto", "quebrar_as_correntes":
			if _targetable(owner_index, owner.attack_field).is_empty(): return _invalid("O efeito exige uma carta própria no ataque.")
		"ilusao":
			if _targetable(owner_index, owner.rest_field + owner.attack_field).is_empty(): return _invalid("Ilusão exige uma carta própria em campo.")
		"revelacao":
			if enemy.deck.is_empty(): return _invalid("Revelação exige cartas no baralho adversário.")
	return true


func resolve_entry(owner_index: int, card) -> void:
	var effect: String = card.current_effect_id()
	match effect:
		"chama_da_inspiracao": grant_card_energy(owner_index, 2, card.display_name)
		"chama_instavel":
			grant_card_energy(owner_index, 4, card.display_name)
			_damage_player(owner_index, 2, card.display_name)
		"heranca_perdida":
			grant_card_energy(owner_index, 6, card.display_name)
			energy_blocks_until_end[owner_index] = player_end_counts[owner_index] + 2
		"sete_possibilidades": _choose_from_own_top(owner_index, 3, true)
		"ilusao_revelada": _choose_from_own_top(owner_index, 5, false)
		"roubo": _request_single("Escolha uma carta da mão adversária para descartar.", game.players[1-owner_index].hand, func(chosen): _discard_from_hand(1-owner_index, chosen))
		"evasao": _add_restriction(card, "evasao", "end", 1-owner_index, player_end_counts[1-owner_index] + 1)
		"generosidade": _request_single("Escolha outra carta própria para receber +3/+3.", game.players[owner_index].attack_field.filter(func(c): return c != card), func(chosen): _apply_modifier(chosen, "generosidade", 3, 3, "start", owner_index, player_start_counts[owner_index] + 1))
		"divida": _request_single("Escolha uma carta inimiga para receber +3 de Ataque.", game.players[1-owner_index].attack_field, func(chosen): _resolve_debt(owner_index, chosen))
		"uniao": _request_single("Escolha outra carta própria para formar União.", game.players[owner_index].attack_field.filter(func(c): return c != card), func(chosen): _create_union(card, chosen))
		"relacao_rompida": _request_single("Escolha uma carta inimiga; depois escolha a carta própria que sofrerá 3 de dano.", game.players[1-owner_index].attack_field, func(enemy): _request_single("Escolha a carta própria que sofrerá 3 de dano.", game.players[owner_index].attack_field, func(own): _simultaneous_damage([[owner_index, own, 3], [1-owner_index, enemy, 3]])))
		"confronto": _request_single("Escolha a carta inimiga provocada.", game.players[1-owner_index].attack_field, func(enemy): _create_provoke(card, enemy, 1-owner_index))
		"caos": _request_multi("Escolha duas cartas inimigas para Caos.", game.players[1-owner_index].attack_field, 2, 2, func(chosen): _resolve_chaos(1-owner_index, chosen))
		"coracao_partido": _request_single("Escolha uma carta inimiga para receber 4 de dano.", game.players[1-owner_index].attack_field, func(chosen): game.damage_card(1-owner_index, chosen, 4, card.display_name))
		"ferida_profunda": _simultaneous_damage(game.players[1-owner_index].attack_field.map(func(c): return [1-owner_index, c, 2]))
	_cleanup_links()
	game.state_changed.emit()


func resolve_special(owner_index: int, card) -> void:
	var effect: String = card.current_effect_id()
	match effect:
		"transformacao": _request_single("Escolha uma carta própria para destruir.", game.players[owner_index].attack_field, func(own): _request_single("Escolha uma carta inimiga para destruir.", game.players[1-owner_index].attack_field, func(enemy): _resolve_transformation(owner_index, card, own, enemy)))
		"resistencia_a_morte": _request_multi("Escolha uma ou duas cartas próprias com até 5 de Vida.", game.players[owner_index].attack_field.filter(func(c): return c.current_health <= 5), 1, 2, func(chosen): _resolve_death_resistance(owner_index, card, chosen))
		"virada_do_destino": _resolve_wheel(owner_index, card, false)
		"ma_fortuna": _resolve_wheel(owner_index, card, true)
		"pacto": _request_single("Escolha uma carta própria para o Pacto +6/+6.", game.players[owner_index].attack_field, func(chosen): _resolve_devil(owner_index, card, chosen, 6, false))
		"quebrar_as_correntes": _request_single("Escolha uma carta própria para libertar e fortalecer.", game.players[owner_index].attack_field, func(chosen): _resolve_devil(owner_index, card, chosen, 3, true))
		"plenitude":
			for target in game.players[owner_index].attack_field.duplicate(): _apply_modifier(target, "plenitude", 3, 3, "end", owner_index, player_end_counts[owner_index] + 1, card)
			game.heal_player(owner_index, 3, card.display_name)
			_schedule_special(card, owner_index, "end", owner_index, player_end_counts[owner_index] + 1)
		"eclipse":
			for index in range(2):
				for target in game.players[index].attack_field.duplicate():
					if _apply_debuff(target, "eclipse", -2, -2, "end", owner_index, player_end_counts[owner_index] + 1, card) and index == owner_index:
						target.runtime_marks["eclipse_owner_bonus"] = true
			_schedule_special(card, owner_index, "end", owner_index, player_end_counts[owner_index] + 1)
		"ilusao": _request_single("Escolha uma carta própria para proteger por uma rodada.", game.players[owner_index].rest_field + game.players[owner_index].attack_field, func(chosen): _resolve_moon(owner_index, card, chosen))
		"revelacao": _resolve_revelation(owner_index, card)
		_:
			if card.current_effect_lifecycle() == CardStateScript.EffectLifecycle.IMMEDIATE:
				_finish_special(card)
	game.state_changed.emit()


func on_turn_started(player_index: int) -> void:
	player_start_counts[player_index] += 1
	_expire("start", player_index, player_start_counts[player_index])
	for card in game.players[player_index].rest_field + game.players[player_index].attack_field:
		if card.current_effect_id() == "trabalho_excessivo" and card.current_health >= 2:
			card.attack += 2
			card.current_health -= 1
		if card.current_effect_id() == "legado" and game.players[player_index].rest_field.size() + game.players[player_index].attack_field.size() >= 3:
			grant_card_energy(player_index, 2, card.display_name)
	_update_exhaustion_all()


func on_turn_ending(player_index: int, attacked: bool) -> void:
	for card in game.players[player_index].rest_field + game.players[player_index].attack_field:
		if card.current_effect_id() == "aperfeicoamento" and (not attacked or not game.players[player_index].attack_field.has(card)):
			var attack_gain := mini(1, 7 - card.attack)
			var health_gain := mini(1, 7 - card.max_health)
			card.attack += attack_gain
			card.max_health += health_gain
			card.current_health += health_gain
	player_end_counts[player_index] += 1
	global_end_count += 1
	_expire("end", player_index, player_end_counts[player_index])
	_expire_global()
	_cleanup_links()
	_update_exhaustion_all()


func attack_value(card, owner_index: int) -> int:
	var value: int = card.attack
	if owner_index == game.current_player_index and card.runtime_marks.get("eclipse_owner_bonus", false): value += 1
	return maxi(0, value)


func is_targetable(requester_index: int, card) -> bool:
	for restriction in restrictions:
		if restriction["card"] == card and restriction.get("untargetable", false): return false
	return true


func forced_attack_target(player_index: int):
	for link in links:
		if link["type"] == "provoke" and link["forced_player"] == player_index and _in_attack(link["source"]) and _in_attack(link["enemy"]) and is_targetable(player_index, link["source"]): return link["source"]
	return null


func must_attack(player_index: int) -> bool:
	return forced_attack_target(player_index) != null


func receive_damage(owner_index: int, card, amount: int) -> Dictionary:
	var health_before: int = card.current_health
	if amount >= health_before:
		if card.current_effect_id() == "ultima_resistencia" and not card.runtime_marks.get("last_stand_used", false):
			card.runtime_marks["last_stand_used"] = true
			card.current_health = 1
			_update_exhaustion(card)
			return {"remaining": 0, "defeated": false, "applied": health_before - 1}
		if _has_restriction(card, "death_resistance"):
			card.current_health = 1
			_update_exhaustion(card)
			return {"remaining": 0, "defeated": false, "applied": health_before - 1}
	var applied := mini(amount, health_before)
	card.current_health -= applied
	_update_exhaustion(card)
	return {"remaining": amount - applied, "defeated": card.current_health <= 0, "applied": applied}


func choose_effect_option(value) -> bool:
	if pending.is_empty() or not pending["options"].has(value): return false
	var selected: Array = pending["selected"]
	if selected.has(value): selected.erase(value)
	elif selected.size() < pending["max"]: selected.append(value)
	pending["selected"] = selected
	if pending["max"] == 1: return confirm_effect_choice()
	game.state_changed.emit()
	return true


func confirm_effect_choice() -> bool:
	if pending.is_empty() or pending["selected"].size() < pending["min"]: return false
	var chosen: Array = pending["selected"].duplicate()
	var continuation: Callable = pending["continuation"]
	var return_single: bool = pending.get("return_single", false)
	pending.clear()
	continuation.call(chosen[0] if return_single else chosen)
	if pending.is_empty() and game.phase == game.Phase.RESOLVING_EFFECT:
		game.finish_effect_resolution()
	game.state_changed.emit()
	return true


func grant_card_energy(owner_index: int, amount: int, source: String, ignore_block: bool = false) -> bool:
	if not ignore_block and energy_blocks_until_end[owner_index] > player_end_counts[owner_index]:
		game.event_logged.emit("%s bloqueou o ganho de energia de %s." % [game.players[owner_index].display_name, source])
		return false
	game.players[owner_index].gain_energy(amount)
	game.event_logged.emit("%s recebeu %d energia(s) por %s." % [game.players[owner_index].display_name, amount, source])
	return true


func on_card_left_field(card) -> void:
	for link in links.duplicate():
		if link.get("first") == card or link.get("second") == card or link.get("source") == card or link.get("enemy") == card: _remove_link(link)
	for modifier in modifiers.duplicate():
		if modifier["card"] == card or modifier.get("source") == card: _remove_modifier(modifier)
	for restriction in restrictions.duplicate():
		if restriction["card"] == card or restriction.get("source") == card: restrictions.erase(restriction)
	for expiry in special_expiries.duplicate():
		if expiry["card"] == card: special_expiries.erase(expiry)


func _invalid(message: String) -> bool:
	validation_error = message
	return false


func _targetable(requester: int, cards: Array) -> Array:
	return cards.filter(func(card): return is_targetable(requester, card))


func _request_single(prompt: String, options: Array, continuation: Callable) -> void:
	_request_multi(prompt, _targetable(game.current_player_index, options), 1, 1, continuation)
	pending["return_single"] = true


func _request_multi(prompt: String, options: Array, minimum: int, maximum: int, continuation: Callable) -> void:
	var valid_options := _targetable(game.current_player_index, options)
	pending = {"prompt": prompt, "options": valid_options, "selected": [], "min": mini(minimum, valid_options.size()), "max": mini(maximum, valid_options.size()), "continuation": continuation, "return_single": false}
	game.phase = game.Phase.RESOLVING_EFFECT


func _finish_special(card) -> void:
	if game.active_player().special_field.has(card): game.finish_special_resolution(card)


func _resolve_debt(owner_index: int, chosen) -> void:
	_apply_modifier(chosen, "divida", 3, 0, "end", 1-owner_index, player_end_counts[1-owner_index] + 1)
	grant_card_energy(owner_index, 3, "Dívida")


func _create_union(first, second) -> void:
	_apply_modifier(first, "uniao", 2, 2, "link", -1, -1)
	_apply_modifier(second, "uniao", 2, 2, "link", -1, -1)
	links.append({"type": "union", "first": first, "second": second})


func _create_provoke(source, enemy, forced_player: int) -> void:
	links.append({"type": "provoke", "source": source, "enemy": enemy, "forced_player": forced_player})


func _resolve_chaos(owner_index: int, chosen: Array) -> void:
	var first_attack: int = chosen[0].attack
	var second_attack: int = chosen[1].attack
	_simultaneous_damage([[owner_index, chosen[0], second_attack], [owner_index, chosen[1], first_attack]])


func _simultaneous_damage(entries: Array) -> void:
	var defeated: Array = []
	for entry in entries:
		var result := receive_damage(entry[0], entry[1], entry[2])
		if result["defeated"]: defeated.append([entry[0], entry[1]])
	for item in defeated:
		if game.players[item[0]].attack_field.has(item[1]): game._defeat_common_card(item[0], item[1], "efeito simultâneo")


func _choose_from_own_top(owner_index: int, amount: int, reorder_top: bool) -> void:
	var player = game.players[owner_index]
	var viewed: Array = player.deck.slice(0, mini(amount, player.deck.size()))
	_request_single("Escolha uma carta consultada para comprar.", viewed, func(chosen): _resolve_top_choice(owner_index, viewed, chosen, reorder_top))


func _resolve_top_choice(owner_index: int, viewed: Array, chosen, reorder_top: bool) -> void:
	var player = game.players[owner_index]
	for card in viewed: player.deck.erase(card)
	chosen.assign_orientation(game.random_source)
	player.hand.append(chosen)
	var remaining: Array = viewed.filter(func(c): return c != chosen)
	if reorder_top and remaining.size() > 1:
		_request_single("Escolha qual carta permanecerá primeiro no topo.", remaining, func(first): _restore_top_order(player, remaining, first))
	elif reorder_top:
		for card in remaining: player.deck.push_front(card)
	else:
		for card in remaining: player.deck.append(card)


func _restore_top_order(player, remaining: Array, first) -> void:
	var ordered: Array = [first]
	for card in remaining:
		if card != first: ordered.append(card)
	for index in range(ordered.size() - 1, -1, -1): player.deck.push_front(ordered[index])


func _discard_from_hand(owner_index: int, card) -> void:
	var owner = game.players[owner_index]
	owner.hand.erase(card)
	if card.is_common(): owner.send_to_deck_bottom(card)
	else: owner.graveyard.append(card)


func _resolve_transformation(owner_index: int, special, own, enemy) -> void:
	game.destroy_card(owner_index, own, "Transformação")
	if not game.is_match_over: game.destroy_card(1-owner_index, enemy, "Transformação")
	if not game.is_match_over and game.players[owner_index].has_rest_space():
		var token = CardStateScript.new("death_token_%d" % game.turn_serial, "Ficha da Morte", CardStateScript.Category.ATTACK, 0, 4, 4)
		token.runtime_marks["token"] = true
		token.entered_rest_turn = game.turn_serial
		token.reveal()
		game.players[owner_index].rest_field.append(token)
	_finish_special(special)


func _resolve_death_resistance(owner_index: int, special, chosen: Array) -> void:
	for target in chosen: _add_restriction(target, "death_resistance", "start", owner_index, player_start_counts[owner_index] + 1, "death_penalty", special)
	_schedule_special(special, owner_index, "start", owner_index, player_start_counts[owner_index] + 1)


func _resolve_wheel(owner_index: int, special, reversed: bool) -> void:
	var roll: int = game.random_source.randi_range(1, 6)
	game.event_logged.emit("Roda da Fortuna sorteou %d." % roll)
	if not reversed:
		if roll <= 2: grant_card_energy(owner_index, 4, "Roda da Fortuna"); _finish_special(special)
		elif roll <= 4: game.players[owner_index].draw_cards(3, game.random_source); _finish_special(special)
		elif roll == 5:
			for target in game.players[owner_index].attack_field.duplicate(): _apply_modifier(target, "roda_fortuna", 3, 3, "end", owner_index, player_end_counts[owner_index] + 1, special)
			_schedule_special(special, owner_index, "end", owner_index, player_end_counts[owner_index] + 1)
		elif game.players[1-owner_index].attack_field.is_empty(): _finish_special(special)
		else: _request_single("Escolha uma carta inimiga para destruir.", game.players[1-owner_index].attack_field, func(chosen): game.destroy_card(1-owner_index, chosen, "Roda da Fortuna"); _finish_special(special))
	else:
		if roll <= 2: game.players[owner_index].lose_energy(4); _finish_special(special)
		elif roll <= 4:
			var amount := mini(2, game.players[owner_index].hand.size())
			if amount == 0: _finish_special(special)
			else: _request_multi("Escolha até duas cartas da mão para descartar.", game.players[owner_index].hand, amount, amount, func(chosen): _discard_many(owner_index, chosen); _finish_special(special))
		elif roll == 5:
			for target in game.players[owner_index].attack_field.duplicate(): _apply_debuff(target, "ma_fortuna", -3, -3, "end", owner_index, player_end_counts[owner_index] + 1, special)
			_schedule_special(special, owner_index, "end", owner_index, player_end_counts[owner_index] + 1)
		elif game.players[owner_index].attack_field.is_empty(): _finish_special(special)
		else: _request_single("Escolha uma carta própria para destruir.", game.players[owner_index].attack_field, func(chosen): game.destroy_card(owner_index, chosen, "Má Fortuna"); _finish_special(special))


func _discard_many(owner_index: int, cards: Array) -> void:
	for card in cards: _discard_from_hand(owner_index, card)


func _resolve_devil(owner_index: int, special, target, amount: int, cleanse: bool) -> void:
	if cleanse: _cleanse_negative(target)
	_apply_modifier(target, "diabo", amount, amount, "end", owner_index, player_end_counts[owner_index] + 2, special)
	_schedule_special(special, owner_index, "end", owner_index, player_end_counts[owner_index] + 2)


func _resolve_moon(owner_index: int, special, target) -> void:
	restrictions.append({"card": target, "id": "ilusao", "untargetable": true, "global_end": global_end_count + 2, "source": special})
	special_expiries.append({"card": special, "owner": owner_index, "hook": "global", "count": global_end_count + 2})


func _resolve_revelation(owner_index: int, special) -> void:
	var enemy = game.players[1-owner_index]
	var viewed: Array = enemy.deck.slice(0, mini(5, enemy.deck.size()))
	_request_multi("Escolha até duas cartas do topo inimigo para mover ao fundo.", viewed, 0, mini(2, viewed.size()), func(chosen): _finish_revelation(enemy, special, viewed, chosen))


func _finish_revelation(enemy, special, viewed: Array, chosen: Array) -> void:
	for card in viewed:
		if not chosen.has(card):
			continue
		enemy.deck.erase(card)
		enemy.deck.append(card)
	enemy.draw_cards(1, game.random_source)
	_finish_special(special)


func _apply_modifier(card, id: String, attack_delta: int, health_delta: int, hook: String, expire_player: int, expire_count: int, source = null) -> bool:
	card.attack += attack_delta
	card.max_health = maxi(1, card.max_health + health_delta)
	card.current_health += health_delta
	if health_delta > 0: card.current_health = mini(card.current_health, card.max_health)
	var modifier := {"card": card, "id": id, "attack": attack_delta, "health": health_delta, "hook": hook, "player": expire_player, "count": expire_count, "source": source}
	modifiers.append(modifier)
	return true


func _apply_debuff(card, id: String, attack_delta: int, health_delta: int, hook: String, expire_player: int, expire_count: int, source = null) -> bool:
	if card.runtime_marks.get("temporary_debuff_used", false): return false
	card.runtime_marks["temporary_debuff_used"] = true
	_apply_modifier(card, id, attack_delta, health_delta, hook, expire_player, expire_count, source)
	if card.current_health <= 0:
		var owner_index := 0 if game.players[0].attack_field.has(card) else 1
		game.destroy_card(owner_index, card, id)
	return true


func _remove_modifier(modifier: Dictionary) -> void:
	var card = modifier["card"]
	if not modifiers.has(modifier): return
	card.attack -= modifier["attack"]
	card.max_health = maxi(1, card.max_health - modifier["health"])
	card.current_health = mini(card.current_health, card.max_health)
	if modifier["id"] == "eclipse": card.runtime_marks.erase("eclipse_owner_bonus")
	modifiers.erase(modifier)


func _add_restriction(card, id: String, hook: String, expire_player: int, expire_count: int, on_expire: String = "", source = null) -> void:
	restrictions.append({"card": card, "id": id, "untargetable": id == "evasao", "hook": hook, "player": expire_player, "count": expire_count, "on_expire": on_expire, "source": source})


func _has_restriction(card, id: String) -> bool:
	for restriction in restrictions:
		if restriction["card"] == card and restriction["id"] == id: return true
	return false


func _schedule_special(card, owner: int, hook: String, expire_player: int, count: int) -> void:
	special_expiries.append({"card": card, "owner": owner, "hook": hook, "player": expire_player, "count": count})


func _expire(hook: String, player: int, count: int) -> void:
	for modifier in modifiers.duplicate():
		if modifier["hook"] == hook and modifier["player"] == player and modifier["count"] <= count: _remove_modifier(modifier)
	for restriction in restrictions.duplicate():
		if restriction.get("hook") == hook and restriction.get("player") == player and restriction.get("count") <= count:
			restrictions.erase(restriction)
			if restriction.get("on_expire") == "death_penalty" and _in_attack(restriction["card"]): game.damage_card(player, restriction["card"], 3, "Resistência à Morte")
	for expiry in special_expiries.duplicate():
		if expiry["hook"] == hook and expiry.get("player") == player and expiry["count"] <= count:
			special_expiries.erase(expiry)
			game.expire_special(expiry["card"], expiry["owner"])


func _expire_global() -> void:
	for restriction in restrictions.duplicate():
		if restriction.has("global_end") and restriction["global_end"] <= global_end_count: restrictions.erase(restriction)
	for expiry in special_expiries.duplicate():
		if expiry["hook"] == "global" and expiry["count"] <= global_end_count:
			special_expiries.erase(expiry)
			game.expire_special(expiry["card"], expiry["owner"])


func _cleanse_negative(card) -> void:
	for modifier in modifiers.duplicate():
		if modifier["card"] == card and (modifier["attack"] < 0 or modifier["health"] < 0): _remove_modifier(modifier)
	for restriction in restrictions.duplicate():
		if restriction["card"] == card and restriction["id"] == "provoke": restrictions.erase(restriction)
	for link in links.duplicate():
		if link["type"] == "provoke" and link["enemy"] == card: links.erase(link)


func _cleanup_links() -> void:
	for link in links.duplicate():
		if link["type"] == "union" and (not _in_attack(link["first"]) or not _in_attack(link["second"])): _remove_link(link)
		elif link["type"] == "provoke" and (not _in_attack(link["source"]) or not _in_attack(link["enemy"])): links.erase(link)


func _remove_link(link: Dictionary) -> void:
	if link["type"] == "union":
		for modifier in modifiers.duplicate():
			if modifier["id"] == "uniao" and (modifier["card"] == link["first"] or modifier["card"] == link["second"]): _remove_modifier(modifier)
	links.erase(link)


func _in_attack(card) -> bool:
	return game.players[0].attack_field.has(card) or game.players[1].attack_field.has(card)


func _damage_player(owner_index: int, amount: int, source: String) -> void:
	game.players[owner_index].take_damage(amount)
	game.event_logged.emit("%s perdeu %d de Vida por %s." % [game.players[owner_index].display_name, amount, source])
	game._check_health_defeat(owner_index)


func _update_exhaustion_all() -> void:
	for player in game.players:
		for card in player.rest_field + player.attack_field: _update_exhaustion(card)


func _update_exhaustion(card) -> void:
	var should_apply: bool = card.current_effect_id() == "exaustao" and card.current_health in [1, 2]
	var applied: bool = card.runtime_marks.get("exhaustion_bonus", false)
	if should_apply and not applied: card.attack += 4; card.runtime_marks["exhaustion_bonus"] = true
	elif not should_apply and applied: card.attack -= 4; card.runtime_marks.erase("exhaustion_bonus")
