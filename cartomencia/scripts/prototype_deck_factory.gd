class_name PrototypeDeckFactory
extends RefCounted

const CardStateScript = preload("res://scripts/card_state.gd")

const C := CardStateScript.Category
const T := CardStateScript.EffectTrigger
const L := CardStateScript.EffectLifecycle


static func create_deck() -> Array:
	return [
		_common("ace_of_wands", "Ás de Paus", C.SUPPORT, 2, 2, T.ON_REST_ENTRY, T.ON_REST_ENTRY,
			"chama_da_inspiracao", "chama_instavel"),
		_common("two_of_cups", "2 de Copas", C.SUPPORT, 2, 3, T.ON_ATTACK_ENTRY, T.ON_ATTACK_ENTRY,
			"uniao", "relacao_rompida"),
		_common("six_of_pentacles", "6 de Ouros", C.SUPPORT, 2, 2, T.ON_ATTACK_ENTRY, T.ON_ATTACK_ENTRY,
			"generosidade", "divida"),
		_common("seven_of_cups", "7 de Copas", C.SUPPORT, 2, 2, T.ON_REST_ENTRY, T.ON_REST_ENTRY,
			"sete_possibilidades", "ilusao_revelada"),
		_common("ten_of_pentacles", "10 de Ouros", C.SUPPORT, 3, 5, T.PASSIVE, T.ON_REST_ENTRY,
			"legado", "heranca_perdida"),
		_common("five_of_wands", "5 de Paus", C.ATTACK, 2, 4, T.ON_ATTACK_ENTRY, T.ON_ATTACK_ENTRY,
			"confronto", "caos"),
		_common("three_of_swords", "3 de Espadas", C.ATTACK, 2, 3, T.ON_ATTACK_ENTRY, T.ON_ATTACK_ENTRY,
			"coracao_partido", "ferida_profunda"),
		_common("seven_of_swords", "7 de Espadas", C.ATTACK, 2, 3, T.ON_ATTACK_ENTRY, T.ON_REST_ENTRY,
			"evasao", "roubo"),
		_common("nine_of_wands", "9 de Paus", C.ATTACK, 2, 5, T.PASSIVE, T.PASSIVE,
			"ultima_resistencia", "exaustao"),
		_common("eight_of_pentacles", "8 de Ouros", C.ATTACK, 2, 3, T.PASSIVE, T.PASSIVE,
			"aperfeicoamento", "trabalho_excessivo"),
		_special("death", "XIII — A Morte", 6, L.IMMEDIATE, L.TEMPORARY,
			"transformacao", "resistencia_a_morte"),
		_special("wheel_of_fortune", "X — Roda da Fortuna", 5, L.RESOLVER_DECIDES, L.RESOLVER_DECIDES,
			"virada_do_destino", "ma_fortuna"),
		_special("devil", "XV — O Diabo", 5, L.TEMPORARY, L.TEMPORARY,
			"pacto", "quebrar_as_correntes"),
		_special("sun", "XIX — O Sol", 5, L.TEMPORARY, L.TEMPORARY,
			"plenitude", "eclipse"),
		_special("moon", "XVIII — A Lua", 5, L.TEMPORARY, L.IMMEDIATE,
			"ilusao", "revelacao"),
	]


static func _common(
	id: String,
	card_name: String,
	category: int,
	cost: int,
	base_value: int,
	upright_trigger: int,
	reversed_trigger: int,
	upright_effect: String,
	reversed_effect: String
):
	return CardStateScript.new(
		id,
		card_name,
		category,
		cost,
		base_value,
		base_value,
		[upright_trigger, reversed_trigger],
		[L.NONE, L.NONE],
		[upright_effect, reversed_effect]
	)


static func _special(
	id: String,
	card_name: String,
	cost: int,
	upright_lifecycle: int,
	reversed_lifecycle: int,
	upright_effect: String,
	reversed_effect: String
):
	return CardStateScript.new(
		id,
		card_name,
		C.SPECIAL,
		cost,
		0,
		0,
		[T.NONE, T.NONE],
		[upright_lifecycle, reversed_lifecycle],
		[upright_effect, reversed_effect]
	)
