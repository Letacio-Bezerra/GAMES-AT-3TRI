class_name CardPresentation
extends RefCounted

const EFFECT_TITLES := {
	"chama_da_inspiracao": "Chama da Inspiração",
	"chama_instavel": "Chama Instável",
	"uniao": "União",
	"relacao_rompida": "Relação Rompida",
	"generosidade": "Generosidade",
	"divida": "Dívida",
	"sete_possibilidades": "Sete Possibilidades",
	"ilusao_revelada": "Ilusão Revelada",
	"legado": "Legado",
	"heranca_perdida": "Herança Perdida",
	"confronto": "Confronto",
	"caos": "Caos",
	"coracao_partido": "Coração Partido",
	"ferida_profunda": "Ferida Profunda",
	"evasao": "Evasão",
	"roubo": "Roubo",
	"ultima_resistencia": "Última Resistência",
	"exaustao": "Exaustão",
	"aperfeicoamento": "Aperfeiçoamento",
	"trabalho_excessivo": "Trabalho Excessivo",
	"transformacao": "Transformação",
	"resistencia_a_morte": "Resistência à Morte",
	"virada_do_destino": "Virada do Destino",
	"ma_fortuna": "Má Fortuna",
	"pacto": "Pacto",
	"quebrar_as_correntes": "Quebrar as Correntes",
	"plenitude": "Plenitude",
	"eclipse": "Eclipse",
	"ilusao": "Ilusão",
	"revelacao": "Revelação",
}

const EFFECT_TEXTS := {
	"chama_da_inspiracao": "Ao entrar no descanso, seu dono recebe 2 Energias.",
	"chama_instavel": "Ao entrar no descanso, seu dono recebe 4 Energias e perde 2 de Vida. Essa perda pode encerrar a partida.",
	"uniao": "Ao entrar no ataque, escolha outra carta própria no ataque. Enquanto ambas permanecerem ali, cada uma recebe +2 de Ataque e +2 de Vida.",
	"relacao_rompida": "Ao entrar no ataque, escolha uma carta própria e uma inimiga no ataque. Ambas sofrem 3 de dano.",
	"generosidade": "Ao entrar no ataque, escolha outra carta própria no ataque. Ela recebe +3 de Ataque e +3 de Vida até o início do seu próximo turno.",
	"divida": "Ao entrar no ataque, escolha uma carta inimiga no ataque. Ela recebe +3 de Ataque até o fim do próximo turno dela; você recebe 3 Energias.",
	"sete_possibilidades": "Ao entrar no descanso, olhe até 3 cartas do topo do seu baralho, compre uma e reorganize as demais no topo.",
	"ilusao_revelada": "Ao entrar no descanso, olhe até 5 cartas do topo do seu baralho, compre uma e envie as demais ao fundo na ordem original.",
	"legado": "No início do seu turno, se você controlar ao menos 3 cartas comuns ou fichas nos campos, receba 2 Energias adicionais.",
	"heranca_perdida": "Ao entrar no descanso, receba 6 Energias. Ganhos adicionais de Energia vindos de cartas ficam bloqueados até o fim do seu próximo turno.",
	"confronto": "Ao entrar no ataque, escolha uma carta inimiga no ataque. No próximo turno adversário, ela deve atacar e o 5 de Paus deve ser o primeiro alvo, se ambas permanecerem no campo.",
	"caos": "Ao entrar no ataque, escolha duas cartas inimigas no ataque. Cada uma causa à outra dano igual ao próprio Ataque atual.",
	"coracao_partido": "Ao entrar no ataque, escolha uma carta inimiga no ataque e cause 4 de dano a ela.",
	"ferida_profunda": "Ao entrar no ataque, cause simultaneamente 2 de dano a todas as cartas inimigas no ataque.",
	"evasao": "Ao entrar no ataque, esta carta não pode ser escolhida como alvo durante o próximo turno adversário.",
	"roubo": "Ao entrar no descanso, veja a mão adversária e descarte uma carta. Comuns vão ao fundo do baralho; especiais, ao cemitério.",
	"ultima_resistencia": "Uma vez por permanência fora do baralho, dano letal deixa esta carta com 1 de Vida e consome todo o dano restante.",
	"exaustao": "Enquanto esta carta tiver exatamente 1 ou 2 de Vida atual, recebe +4 de Ataque.",
	"aperfeicoamento": "No fim de um turno seu em que esta carta não participou do ataque, ela recebe permanentemente +1/+1 e recupera 1 de Vida, até 7/7.",
	"trabalho_excessivo": "No início do seu turno, se tiver ao menos 2 de Vida, esta carta recebe permanentemente +2 de Ataque e perde 1 de Vida. Para de ativar com 1 de Vida.",
	"transformacao": "Destrua uma carta própria e uma inimiga nos campos de ataque. Depois, crie uma ficha 4/4 no seu descanso, se houver espaço.",
	"resistencia_a_morte": "Escolha uma ou duas cartas próprias no ataque com até 5 de Vida. Até seu próximo turno, dano letal as deixa com 1; depois, cada uma perde 3 de Vida.",
	"virada_do_destino": "Role 1–6: ganhe 4 Energias; compre até 3 cartas; conceda +3/+3 ao seu ataque neste turno; ou destrua uma carta inimiga no ataque.",
	"ma_fortuna": "Role 1–6: perca 4 Energias; descarte até 2 cartas; aplique −3/−3 ao seu ataque neste turno; ou destrua uma carta própria no ataque.",
	"pacto": "Escolha uma carta própria no ataque. Ela recebe +6 de Ataque e +6 de Vida durante este turno e seu próximo turno.",
	"quebrar_as_correntes": "Escolha uma carta própria no ataque. Remova seus efeitos negativos ativos e conceda +3 de Ataque e +3 de Vida até o fim do seu próximo turno.",
	"plenitude": "As cartas próprias que já estão no ataque recebem +3/+3 até o fim deste turno. Seu jogador recupera até 3 de Vida.",
	"eclipse": "As cartas elegíveis que já estão nos dois campos de ataque recebem −2/−2 neste turno. Suas cartas afetadas recebem +1 de Ataque ao atacar.",
	"ilusao": "Escolha uma carta própria no descanso ou ataque. Ela não pode ser escolhida como alvo durante uma rodada completa.",
	"revelacao": "Olhe até 5 cartas do topo do baralho adversário, mova até 2 ao fundo e faça o adversário comprar a próxima carta restante.",
}


static func effect_title(card) -> String:
	var effect_id: String = card.current_effect_id()
	return EFFECT_TITLES.get(effect_id, effect_id.replace("_", " ").capitalize() if not effect_id.is_empty() else "Sem efeito")


static func effect_text(card) -> String:
	var effect_id: String = card.current_effect_id()
	return EFFECT_TEXTS.get(effect_id, "Esta carta não possui texto de efeito cadastrado.")
