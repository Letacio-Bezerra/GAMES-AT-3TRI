# Spec 005 — Campos de Jogo

## Objetivo

Definir a capacidade dos campos e o caminho das cartas de ataque e suporte entre mão, descanso e ataque.

## Fora do escopo

- Área de cartas especiais — definida na Spec 003.
- Escolha de alvos e resolução de dano — pertencem à Spec de combate.

### RF-AGE-016 — Capacidade dos campos

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** nenhuma

Cada jogador possui um campo de descanso com três espaços e um campo de ataque com cinco espaços. Cartas de ataque e suporte ocupam esses espaços.

**Critérios de aceitação**

- Dado que o campo de descanso contém três cartas, quando o jogador tenta adicionar outra sem liberar espaço, então a colocação não é permitida.
- Dado que o campo de ataque contém cinco cartas, quando o jogador tenta mover outra carta para ele, então o movimento não é permitido.

**Origem:** o grupo limitou o descanso a três cartas e o ataque a cinco para pressionar o jogador a avançar suas cartas em vez de mantê-las indefinidamente em preparação.

### RF-AGE-017 — Entrada de carta comum no descanso

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-016

Uma carta de ataque ou suporte do protótipo possui custo de duas ou três energias. Para jogá-la da mão, o jogador paga o custo impresso e a coloca em um espaço livre do próprio campo de descanso.

**Critérios de aceitação**

- Dado que há espaço no descanso e energia suficiente, quando o jogador joga uma carta de ataque ou suporte, então o custo impresso de duas ou três energias é consumido e a carta ocupa um espaço livre.
- Dado que não há espaço livre ou energia suficiente, quando o jogador tenta jogar a carta, então a colocação não ocorre e a energia não é consumida.

**Origem:** o grupo normalizou as cartas comuns do protótipo em dois ou três pontos de energia para evitar custos muito altos e variabilidade excessiva.

### RF-AGE-018 — Avanço ao campo de ataque

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-016, RF-AGE-017, RF-AGE-003

A partir de um turno posterior ao da colocação, uma carta no campo de descanso pode ser movida gratuitamente para um espaço livre do campo de ataque. Ela não pode retornar ao descanso.

**Critérios de aceitação**

- Dado que uma carta foi colocada no descanso no turno atual, quando o jogador tenta movê-la ao campo de ataque nesse mesmo turno, então o movimento não é permitido.
- Dado que uma carta já estava no descanso desde um turno anterior e há espaço no ataque, quando o jogador a move, então nenhuma energia é consumida e ela passa ao campo de ataque.
- Dado que não há espaço livre no ataque, quando o jogador tenta avançar uma carta, então o movimento não ocorre.

**Origem:** permanecer no descanso por pelo menos um turno já é o custo de preparação da carta; por isso, o avanço posterior não consome energia.

## Alternativas descartadas

- Cobrar energia para mover uma carta ao ataque. Descartado porque o tempo obrigatório no descanso já representa seu custo de preparação.
- Permitir avanço no mesmo turno da colocação. Descartado para preservar a passagem obrigatória pelo descanso.

## Perguntas em aberto

- Nenhuma pergunta bloqueante identificada para capacidade e movimentação dos campos.

## Não aplicável a este jogo

- Retornar voluntariamente uma carta do ataque ao descanso.
