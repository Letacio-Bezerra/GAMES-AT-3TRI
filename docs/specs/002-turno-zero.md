# Spec 002 — Turno Zero

## Objetivo

Definir a preparação inicial da partida e o procedimento que escolhe o primeiro jogador.

## Fora do escopo

- Aplicar efeitos de terreno às cartas reveladas — adiado para depois do primeiro incremento jogável.

### RF-EST-001 — Atribuição das orientações aos jogadores

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** nenhuma

Antes que qualquer carta do turno zero seja revelada, o jogo atribui aleatoriamente a um jogador a orientação reta e ao outro a orientação invertida.

**Critérios de aceitação**

- Dado que uma partida para dois jogadores está começando, quando o turno zero é iniciado, então um jogador recebe a orientação reta e o outro recebe a orientação invertida por seleção aleatória.
- Dado que as orientações ainda não foram atribuídas, quando o jogo prepara as cartas do turno zero, então nenhuma dessas cartas é revelada antes da atribuição.

**Origem:** o grupo escolheu a atribuição aleatória antes da revelação para que nenhum jogador possa escolher uma orientação depois de conhecer o resultado e, assim, manter a disputa justa.

### RF-EST-002 — Revelação alternada dos jogadores

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-EST-001

O jogador associado às cartas retas revela primeiro uma carta do próprio baralho. Em seguida, os jogadores alternam revelações até que cada um tenha revelado exatamente duas cartas, colocando cada carta no centro da mesa assim que for revelada.

**Critérios de aceitação**

- Dado que as orientações dos jogadores foram atribuídas, quando começa a revelação, então o jogador das cartas retas revela a primeira carta.
- Dado que um jogador revelou uma carta e ambos ainda não revelaram duas, quando a próxima revelação ocorre, então ela pertence ao outro jogador.
- Dado que cada jogador revelou duas cartas, quando termina essa etapa, então quatro cartas dos baralhos dos jogadores estão visíveis no centro da mesa.

**Origem:** o grupo escolheu alternar as revelações para transmitir a sensação de que as cartas foram bem embaralhadas. O jogador das retas começa pela ideia temática de que "primeiro está reto para ficar invertido".

### RF-EST-003 — Carta do baralho externo

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-EST-002

Depois que os jogadores revelarem suas quatro cartas, o jogo revela exatamente uma carta de um baralho externo e a coloca no centro da mesa, totalizando cinco cartas no turno zero.

**Critérios de aceitação**

- Dado que ainda não foram reveladas duas cartas de cada jogador, quando o turno zero está em andamento, então a carta externa não é revelada.
- Dado que as quatro cartas dos jogadores estão no centro, quando essa etapa termina, então exatamente uma carta do baralho externo é revelada e colocada junto delas.
- Dado que a revelação externa terminou, quando as orientações são contadas, então há cinco cartas e não pode ocorrer empate entre as quantidades de cartas retas e invertidas.

**Origem:** o grupo adicionou a quinta carta externa para impedir empate na contagem de orientações.

### RF-EST-004 — Sorteio da orientação das cartas

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-EST-001

Cada carta revelada no turno zero recebe aleatoriamente orientação reta ou invertida, com 50% de probabilidade para cada orientação.

**Critérios de aceitação**

- Dado que uma carta será revelada no turno zero, quando sua orientação é definida, então o sorteio oferece a mesma probabilidade para reta e invertida.
- Dado que a orientação de uma carta já foi sorteada, quando outra carta é revelada, então ela recebe seu próprio sorteio de orientação.

**Origem:** o grupo escolheu probabilidades iguais para manter justa a disputa entre o jogador das retas e o jogador das invertidas.

### RF-EST-005 — Definição do primeiro jogador

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-EST-003, RF-EST-004

Depois das cinco revelações, o jogo conta as cartas retas e invertidas. O jogador associado à orientação majoritária realiza o primeiro turno da partida.

**Critérios de aceitação**

- Dado que as cinco cartas foram reveladas, quando há mais cartas retas, então o jogador associado às retas é definido como primeiro jogador.
- Dado que as cinco cartas foram reveladas, quando há mais cartas invertidas, então o jogador associado às invertidas é definido como primeiro jogador.

**Origem:** o grupo vinculou a escolha do primeiro jogador à leitura das cartas para produzir uma sensação de leitura de tarô, em vez de usar um sorteio direto sem relação temática.

### RF-EST-006 — Retorno e novo embaralhamento

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-EST-005

Depois da definição do primeiro jogador, cada carta usada no turno zero retorna ao baralho do qual saiu e os baralhos envolvidos são embaralhados novamente antes da formação das mãos iniciais.

**Critérios de aceitação**

- Dado que o primeiro jogador foi definido, quando o turno zero termina, então as duas cartas de cada jogador retornam ao respectivo baralho e a carta externa retorna ao baralho externo.
- Dado que as cartas retornaram aos seus baralhos, quando as mãos iniciais serão formadas, então os baralhos foram embaralhados novamente e a posição das cartas devolvidas não é conhecida pelos jogadores.

**Origem:** o grupo devolve as cartas para que um jogador não perca uma carta que poderia usar e embaralha novamente para impedir que sua posição fique conhecida.

### RF-EST-007 — Mãos iniciais

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-EST-006

Depois do novo embaralhamento, cada jogador compra exatamente três cartas do próprio baralho para formar sua mão inicial.

**Critérios de aceitação**

- Dado que o turno zero terminou e os baralhos foram embaralhados novamente, quando as mãos iniciais são formadas, então cada jogador recebe exatamente três cartas do próprio baralho.

**Origem:** o grupo escolheu três cartas para que a mão inicial possa oferecer cartas de diferentes propósitos, definidos como ataque, defesa e suporte.

### RF-EST-008 — Energia inicial assimétrica

**Prioridade:** DEVE
**Status:** PROVISÓRIO
**Depende de:** RF-EST-005

O jogador definido para começar inicia a partida com duas energias, enquanto o segundo jogador inicia com três energias.

**Critérios de aceitação**

- Dado que o primeiro jogador foi definido, quando a partida jogável começa, então ele possui duas energias e o segundo jogador possui três.

**Origem:** o grupo quer testar uma energia adicional para compensar a vantagem de agir primeiro, sem fornecer recursos iniciais em excesso ao segundo jogador.

**Hipótese de protótipo**

- **Valor inicial:** 2 energias para o primeiro jogador e 3 para o segundo.
- **Pergunta do protótipo:** uma energia adicional compensa a iniciativa sem dar vantagem excessiva ao segundo jogador?
- **Teto ou limite de exploração:** comparar apenas 2–3 com 2–2; não testar 4 ou mais energias iniciais nesta rodada.

## Alternativas descartadas

- Escolha das orientações pelos jogadores. Descartada porque o grupo quer uma definição imparcial antes da revelação das cartas.

## Perguntas em aberto

- Nenhuma pergunta bloqueante identificada para o turno zero.

## Não aplicável a este jogo

- Efeitos de terreno no primeiro incremento jogável.
