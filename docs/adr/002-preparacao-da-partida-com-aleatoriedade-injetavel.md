# ADR 002 — Preparação da partida com aleatoriedade injetável

- **Status:** Aceita
- **Data:** 2026-09-30

## Contexto

O turno zero precisa possuir sorteios reais para atribuir orientações e revelar cartas, mas seus critérios também precisam ser testáveis de forma determinística. A preparação ainda possui temporariamente cartas fora dos baralhos, enquanto o fluxo de turno deve receber somente baralhos completos e novamente embaralhados.

## Decisão

Usar um `MatchSetupController` separado do `TurnController`. Ele recebe os dois baralhos dos jogadores, o baralho externo e uma fonte de aleatoriedade opcional. Em jogo, cria um `RandomNumberGenerator`; em testes, aceita uma fonte com resultados programados.

O controlador mantém a origem de cada carta revelada. Depois da quinta revelação e da confirmação do resultado, devolve cada carta ao baralho correto, embaralha os três conjuntos com Fisher–Yates e emite os baralhos completos junto do índice do primeiro jogador.

## Consequências

- Nenhum estado parcialmente preparado chega ao fluxo de turnos.
- Todos os ramos do sorteio podem ser testados sem tornar a partida real previsível.
- A composição temática do baralho externo continua substituível sem alterar o procedimento.
- A interface controla apenas o ritmo visual das revelações; não decide resultados.
