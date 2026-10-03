class_name DemoDeckFactory
extends RefCounted

const CardStateScript = preload("res://scripts/card_state.gd")


static func create_turn_flow_deck(player_prefix: String) -> Array:
	# Fixture deliberadamente neutra: valida o fluxo sem transformar valores ainda
	# indefinidos das cartas do protótipo em decisões de game design.
	var deck: Array = []
	for index in range(12):
		var category := CardStateScript.Category.ATTACK if index % 2 == 0 else CardStateScript.Category.SUPPORT
		var cost := 3 if index == 9 else 2
		var value := 1 + (index % 3)
		deck.append(CardStateScript.new(
			"%s_%02d" % [player_prefix, index + 1],
			"Carta de fluxo %02d" % (index + 1),
			category,
			cost,
			value,
			value
		))
	return deck


static func create_external_deck() -> Array:
	# O baralho externo ainda não possui conteúdo definido nas Specs. Estas cartas
	# neutras existem apenas para visualizar e testar o procedimento do turno zero.
	var deck: Array = []
	for index in range(5):
		deck.append(CardStateScript.new(
			"external_%02d" % (index + 1),
			"Arcano externo %02d" % (index + 1),
			CardStateScript.Category.SPECIAL,
			0
		))
	return deck
