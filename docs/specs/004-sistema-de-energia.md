# Spec 004 — Sistema de Energia

## Objetivo

Definir como a energia entra, permanece e é gasta durante a partida.

## Fora do escopo

- Valores finais de balanceamento dos custos de todas as cartas — serão definidos e testados por carta.

### RF-AGE-012 — Ganho de energia por turno

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-EST-008

A partir da segunda rodada, no início de cada turno, o jogador do turno recebe automaticamente duas energias.

**Critérios de aceitação**

- Dado que a partida está na segunda rodada ou em uma posterior, quando o turno de um jogador começa, então sua energia aumenta automaticamente em exatamente duas unidades antes das ações do jogador.
- Dado que a partida está na primeira rodada, quando o turno de um jogador começa, então ele não recebe duas energias adicionais e utiliza apenas sua energia inicial.
- Dado que não é o turno do jogador, quando o adversário recebe seus recursos, então a energia desse jogador não aumenta por essa regra.

**Origem:** o grupo escolheu duas energias por turno para evitar que o jogador acumule recursos rápido demais. O ganho começa na segunda rodada porque a energia inicial já corresponde ao recurso do primeiro turno.

### RF-AGE-013 — Acúmulo de energia

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-012

A energia que não for gasta permanece disponível nos turnos seguintes e não possui limite máximo de acúmulo.

**Critérios de aceitação**

- Dado que um jogador encerra o turno com energia restante, quando seu próximo turno começa, então a energia restante continua disponível e recebe o novo ganho de duas energias.
- Dado que a energia acumulada aumenta, quando qualquer quantidade é alcançada legitimamente, então o jogo não reduz nem limita esse total por um teto de armazenamento.

**Origem:** o grupo quer que o jogador possa decidir como e quando gastar, planejando entre usar energia com cartas comuns agora ou economizar para cartas especiais mais caras.

### RF-AGE-031 — Limite inferior da energia

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** nenhuma

Quando um efeito reduz a energia de um jogador, o total mínimo resultante é zero; energia nunca assume valor negativo.

**Critérios de aceitação**

- Dado que o jogador possui 2 energias, quando um efeito manda perder 4, então ele termina com 0 energia.
- Dado que o jogador possui 0 energia, quando um efeito manda perder energia, então seu total permanece em 0.

**Origem:** o grupo estabeleceu zero como piso porque não é possível possuir energia negativa.

## Alternativas descartadas

- Remover toda energia não gasta ao fim do turno. Descartado porque impediria o planejamento para cartas especiais.

## Perguntas em aberto

- Compra e ganho de energia são automáticos no começo do turno; uma ordem interna só precisará ser definida se algum efeito futuro reagir a esses eventos.

## Não aplicável a este jogo

- Nenhum item identificado até o momento.
