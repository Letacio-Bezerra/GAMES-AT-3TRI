# Spec 001 — Fluxo do Turno

## Objetivo

Definir a sequência de ações disponível ao jogador em um turno comum da partida.

## Fora do escopo

- Escolha de alvos e cálculo de dano — pertencem à resolução do combate.

### RF-AGE-001 — Compra automática no início do turno

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** nenhuma

A partir da segunda rodada, o jogador compra automaticamente duas cartas do próprio baralho no início de seu turno, antes de realizar qualquer ação.

**Critérios de aceitação**

- Dado que a partida está na segunda rodada ou em uma rodada posterior, quando o turno do jogador começa, então ele compra automaticamente exatamente duas cartas antes de poder realizar outra ação.
- Dado que a partida está na primeira rodada, quando o turno do jogador começa, então essa compra obrigatória não ocorre.

**Origem:** o grupo definiu a compra automática como abertura do turno e revisou sua quantidade de uma para duas cartas, para ampliar as possibilidades do que o jogador consegue usar. A compra começa na segunda rodada porque cada jogador já recebe três cartas para seu primeiro turno.

### RF-AGE-002 — Colocação no campo de descanso

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-001

Durante a preparação, o jogador pode colocar no campo de descanso quantas cartas conseguir, sem um limite adicional de colocações por turno.

**Critérios de aceitação**

- Dado que o jogador ainda não atacou e pode colocar uma carta validamente no campo de descanso, quando escolhe colocá-la, então pode repetir a ação enquanto ainda possuir colocações válidas.

**Origem:** o grupo quer permitir que o jogador monte sua estratégia e prepare turnos futuros antes de atacar.

### RF-AGE-003 — Movimento para o campo de ataque

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-001

Durante a preparação, o jogador pode mover para o campo de ataque quantas cartas elegíveis do campo de descanso conseguir, sem um limite adicional de movimentos por turno. Uma carta movida ao campo de ataque não pode retornar ao campo de descanso.

**Critérios de aceitação**

- Dado que o jogador ainda não atacou e possui uma carta elegível no campo de descanso, quando a move para o campo de ataque, então pode repetir a ação com outras cartas elegíveis.
- Dado que uma carta está no campo de ataque, quando o jogador tenta retorná-la ao campo de descanso, então o movimento não é permitido.

**Origem:** o grupo quer permitir a montagem livre da estratégia antes do ataque e estabeleceu que a decisão de avançar uma carta não pode ser desfeita.

### RF-AGE-004 — Descarte durante a preparação

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-001

Durante a preparação, o jogador pode pagar uma energia para enviar uma carta do próprio campo de descanso ao fundo do baralho e pode repetir essa ação enquanto tiver cartas e energia suficientes.

**Critérios de aceitação**

- Dado que o jogador ainda não atacou, possui ao menos uma energia e uma carta no campo de descanso, quando paga uma energia e escolhe a carta, então a carta vai ao fundo de seu baralho sem embaralhamento e uma energia é consumida.
- Dado que o jogador não possui energia suficiente ou carta no campo de descanso, quando tenta realizar o descarte, então a ação não ocorre.

**Origem:** o grupo quer permitir que o jogador reorganize sua estratégia e prepare turnos futuros, usando energia como custo para retirar cartas do descanso.

### RF-AGE-005 — Ataque encerra o turno

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-001

O jogador pode atacar no máximo uma vez por turno. O ataque é necessariamente sua última ação e encerra o turno imediatamente após sua resolução.

**Critérios de aceitação**

- Dado que o jogador ainda não atacou no turno, quando inicia um ataque válido, então o ataque é resolvido e o turno termina.
- Dado que o ataque foi iniciado, quando ele termina de ser resolvido, então o jogador não pode colocar, mover, descartar nem atacar novamente naquele turno.

**Origem:** o grupo limitou o ataque para preservar parte da estratégia do adversário e o tornou a última ação para exigir planejamento prévio e deixar claro quando o turno termina.

### RF-AGE-019 — Mão sem limite

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-001

A mão do jogador não possui limite máximo de cartas. Comprar ou devolver cartas à mão nunca obriga o jogador a descartá-las apenas por causa da quantidade acumulada.

**Critérios de aceitação**

- Dado que o jogador possui qualquer quantidade de cartas na mão, quando compra novas cartas, então todas são adicionadas à mão sem descarte por excesso.
- Dado que o turno termina com qualquer quantidade de cartas na mão, quando o próximo turno começa, então nenhuma carta é removida apenas por ultrapassar um limite de mão.

**Origem:** o grupo quer permitir que o jogador guarde opções e planeje em torno da carta que deseja, equilibrando a decisão entre esperar por uma combinação e gastar recursos jogando uma carta disponível.

### RF-AGE-030 — Compra com baralho insuficiente

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-001

Quando a compra automática exige duas cartas, o jogador compra somente a quantidade disponível no baralho, sem criar cartas nem sofrer penalidade imediata pela diferença.

**Critérios de aceitação**

- Dado que há pelo menos duas cartas no baralho, quando a compra automática ocorre, então o jogador compra duas.
- Dado que resta exatamente uma carta no baralho, quando a compra automática ocorre, então o jogador compra essa única carta.
- Dado que o baralho está vazio, quando a compra automática ocorre, então nenhuma carta é comprada e a partida verifica a condição de esgotamento total.

**Origem:** o grupo quer que o jogador use as cartas que ainda possui; a falta parcial de cartas no baralho não encerra a partida enquanto ainda houver opções disponíveis em outras áreas.

## Alternativas descartadas

- Limitar cada ação de preparação a uma utilização por turno. Descartado porque reduziria a possibilidade de montar uma estratégia e preparar o turno seguinte.
- Permitir ações após o ataque. Descartado porque o grupo quer que o ataque exija planejamento e comunique claramente o fim do turno.
- Comprar somente uma carta por turno. Decisão revisada para duas cartas automáticas a partir da segunda rodada, aumentando as opções disponíveis.

## Perguntas em aberto

- Nenhuma pergunta bloqueante identificada para o fluxo básico do turno.

## Não aplicável a este jogo

- Nenhum item identificado até o momento.
