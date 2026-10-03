# Spec 006 — Sistema de Combate

## Objetivo

Definir como o campo de ataque causa dano, como cartas são derrotadas e como o jogo impede que um jogador mantenha o campo de ataque vazio indefinidamente.

## Fora do escopo

- Ataques diretos ao campo de descanso — não existem no primeiro incremento.
- Efeitos especiais que modificam a resolução do combate — serão definidos nas cartas individuais.

### RF-DES-001 — Vida inicial do jogador

**Prioridade:** DEVE
**Status:** PROVISÓRIO
**Depende de:** nenhuma

Cada jogador começa a partida com 50 pontos de vida e é derrotado quando sua vida chega a zero.

**Critérios de aceitação**

- Dado que a partida jogável começa, quando a vida dos jogadores é inicializada, então cada um possui 50 pontos.
- Dado que a vida de um jogador chega a zero, quando o dano é resolvido, então esse jogador perde a partida.

**Origem:** o grupo escolheu 50 como valor inicial para testar uma partida que dê tempo de planejar e tentar uma virada sem durar demais.

**Hipótese de protótipo**

- **Valor inicial:** 50 pontos de vida.
- **Pergunta do protótipo:** a partida dura pelo menos três rodadas, mas menos de dez, permitindo planejamento e virada sem se prolongar demais?
- **Teto ou limite de exploração:** aumentar a vida, se necessário, até no máximo 100 pontos; valores maiores dariam vida excessiva ao jogador.

### RF-DES-002 — Ataque conjunto do campo

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-014, RF-AGE-015, RF-AGE-005

Na única ação de ataque do turno, todas as cartas de ataque e suporte do jogador no campo de ataque somam seus valores de ataque para formar um total de dano.

**Critérios de aceitação**

- Dado que o jogador possui cartas de ataque com valores A, B e C no campo de ataque, quando inicia seu ataque, então o dano disponível é A + B + C.
- Dado que também existem cartas de suporte no campo de ataque, quando o dano é somado, então os valores de ataque delas também são acrescentados ao total.

**Origem:** o grupo quer que o ataque represente a ação do campo ofensivo inteiro, em vez de combates isolados por carta; suportes agora funcionam em combate como cartas de ataque.

### RF-DES-003 — Distribuição sequencial do dano

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-DES-002

O atacante escolhe uma carta adversária no campo de ataque para receber o dano total. Se ela for derrotada e restar dano, o atacante escolhe outro alvo no mesmo campo; o processo continua até acabar o dano ou não existirem alvos.

**Critérios de aceitação**

- Dado que há 15 de dano e o primeiro alvo possui 10 de vida atual, quando o dano é aplicado, então o alvo é derrotado e restam 5 de dano para um novo alvo escolhido pelo atacante.
- Dado que ainda resta dano e existem alvos no campo de ataque adversário, quando um alvo é derrotado, então o atacante escolhe a próxima carta que receberá o restante.
- Dado que não restam cartas no campo de ataque adversário, quando ainda existe dano, então o dano restante é perdido e não atinge descanso nem jogador diretamente.

**Origem:** o grupo distribui o dano entre alvos sucessivos para que as cartas não sejam derrotadas todas ao mesmo tempo e para que o atacante decida a ordem dos alvos.

### RF-DES-004 — Prazo para ocupar o campo de ataque

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-016

Quando um jogador encerra um turno com o próprio campo de ataque vazio, o jogo o avisa. Se ele também encerrar seu próximo turno próprio sem colocar uma carta no ataque, o sistema inicia uma movimentação automática.

**Critérios de aceitação**

- Dado que o jogador encerrou seu turno com o campo de ataque vazio pela primeira vez consecutiva, quando o turno termina, então ele recebe um aviso e nenhuma carta é movida automaticamente.
- Dado que o jogador havia sido avisado, quando encerra seu próximo turno próprio ainda sem carta no campo de ataque, então a movimentação automática é iniciada.
- Dado que o jogador havia sido avisado, quando coloca uma carta no campo de ataque antes de encerrar seu próximo turno, então a movimentação automática não ocorre e a contagem é reiniciada.

**Origem:** o grupo quer impedir que alguém se recuse a participar do combate, mas concede um turno de prazo para que o jogador possa escolher qual carta avançar.

### RF-DES-005 — Movimentação automática para o ataque

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-DES-004, RF-AGE-018

Quando a movimentação automática é acionada e há cartas no descanso, o sistema escolhe aleatoriamente uma delas e a move gratuitamente para o campo de ataque.

**Critérios de aceitação**

- Dado que a movimentação automática foi acionada e o descanso contém ao menos uma carta, quando o sistema resolve a regra, então uma carta do descanso é escolhida aleatoriamente e movida ao ataque sem custo de energia.

**Origem:** a seleção automática evita a recusa em jogar; o prazo anterior preserva a oportunidade de o próprio jogador escolher antes de perder esse controle.

### RF-DES-006 — Colocação automática a partir da mão

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-DES-004, RF-AGE-017

Se a movimentação automática for acionada com o descanso vazio, o sistema tenta escolher aleatoriamente uma carta comum da mão, cobrar seu custo e colocá-la no descanso.

**Critérios de aceitação**

- Dado que a movimentação automática foi acionada, o descanso está vazio e há carta comum e energia suficientes, quando o sistema resolve a regra, então escolhe aleatoriamente uma carta comum pagável, cobra seu custo e a coloca no descanso.
- Dado que não existe carta comum pagável na mão, quando o sistema tenta resolver a colocação automática, então nenhuma carta é colocada e a penalidade de RF-DES-009 é aplicada.

**Origem:** o grupo quer continuar a correção mesmo com o descanso vazio, cobrando o custo da carta para impedir que o jogador abuse da regra para jogar gratuitamente.

### RF-DES-007 — Dano ao dono por carta derrotada

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-DES-003

Sempre que uma carta de ataque ou suporte é derrotada, seu dono perde pontos de vida iguais à vida máxima impressa da carta, independentemente da vida atual que ela possuía antes do golpe.

**Critérios de aceitação**

- Dado que uma carta com vida máxima 10 e vida atual 4 é derrotada, quando a derrota é resolvida, então seu dono perde 10 pontos de vida.
- Dado que mais de uma carta é derrotada pelo mesmo ataque, quando o dano ao dono é resolvido, então ele perde separadamente o valor de vida máxima de cada carta derrotada.

**Origem:** o grupo quer equilibrar cartas fortes criando risco proporcional: uma carta com mais vida oferece mais resistência, mas causa dano maior ao dono caso seja derrotada.

### RF-DES-008 — Retorno da carta derrotada ao baralho

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-DES-007

Após a resolução de sua derrota, uma carta de ataque ou suporte retorna diretamente ao fundo do baralho de seu dono, sem que o baralho seja embaralhado.

**Critérios de aceitação**

- Dado que uma carta de ataque ou suporte foi derrotada e suas consequências foram resolvidas, quando ela deixa o campo de ataque, então é colocada como a última carta no fundo do baralho de seu dono.
- Dado que a carta derrotada retornou ao fundo do baralho, quando o retorno termina, então a ordem das demais cartas não foi alterada por um novo embaralhamento.

**Origem:** o grupo quer que cartas comuns possam reaparecer e que o jogador consiga se organizar considerando que a carta derrotada foi para o fundo, sem tornar sua posição novamente desconhecida por embaralhamento.

### RF-DES-009 — Penalidade por falha da colocação automática

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-DES-006, RF-DES-001

Se o sistema não puder colocar uma carta comum da mão no descanso por falta de carta pagável, o jogador perde 5% de sua vida atual, arredondado para cima. Depois da penalidade, a contagem de turnos com o ataque vazio é reiniciada.

**Critérios de aceitação**

- Dado que o jogador possui 50 pontos de vida e a colocação automática falha, quando a penalidade é calculada, então ele perde 3 pontos de vida.
- Dado que o cálculo de 5% resulta em uma fração, quando a penalidade é aplicada, então o valor é arredondado para o próximo inteiro.
- Dado que a penalidade foi aplicada e o jogador continua sem cartas no ataque, quando seu próximo turno termina, então ele recebe novamente o aviso e não sofre uma segunda penalidade imediata.

**Origem:** o grupo quer que a recusa ou incapacidade de ocupar o ataque tenha uma consequência moderada; reiniciar a contagem devolve ao jogador tempo para corrigir a situação.

### RF-DES-010 — Persistência do dano nas cartas

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-DES-003, RF-AGE-014

O dano que não derrota uma carta reduz sua vida atual, e essa redução permanece entre os turnos. O dano não reduz o ataque da carta.

**Critérios de aceitação**

- Dado que uma carta com 10 de vida atual recebe 6 de dano, quando sobrevive ao ataque, então permanece com 4 de vida nos turnos seguintes.
- Dado que uma carta de ataque sobrevive com vida reduzida, quando participa de um ataque posterior, então contribui com seu valor de ataque base completo.

**Origem:** o grupo quer permitir tanto que o atacante concentre dano em uma carta forte ao longo de vários turnos quanto que o defensor precise considerar como proteger suas cartas feridas.

### RF-DES-011 — Ataque opcional

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-DES-002

Mesmo que possua cartas capazes de atacar, o jogador pode encerrar o turno sem realizar sua ação de ataque.

**Critérios de aceitação**

- Dado que o jogador possui ao menos uma carta de ataque no campo de ataque, quando decide não atacar, então pode encerrar o turno sem iniciar combate.

**Origem:** o grupo quer que atacar ou aguardar seja uma escolha da estratégia do jogador.

### RF-DES-012 — Participação de carta recém-avançada

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-018, RF-DES-002

Uma carta de ataque movida do descanso para o campo de ataque pode contribuir para o ataque conjunto realizado nesse mesmo turno.

**Critérios de aceitação**

- Dado que uma carta de ataque cumpriu seu tempo no descanso e foi movida ao ataque no turno atual, quando o jogador inicia o ataque, então o valor de ataque dessa carta entra na soma de dano.

**Origem:** a carta já cumpriu o atraso obrigatório no campo de descanso; ao chegar ao campo de ataque, está pronta para participar do combate.

### RF-DES-013 — Destruição por efeito

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-DES-007, RF-DES-008

Quando um efeito destrói uma carta de ataque ou suporte, a destruição conta como derrota normal: o dono perde vida igual à vida máxima da carta e ela retorna ao fundo de seu baralho, salvo se o próprio efeito declarar explicitamente outra consequência.

**Critérios de aceitação**

- Dado que uma carta comum é destruída por um efeito sem exceção explícita, quando a destruição resolve, então seu dono perde vida igual à vida máxima impressa e a carta retorna ao fundo de seu baralho sem embaralhamento.

**Origem:** o grupo mantém as consequências normais para impedir que efeitos de destruição sejam poderosos demais.

### RF-DES-014 — Derrota por esgotamento total de cartas

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-030

Um jogador perde a partida por esgotamento somente quando não possui nenhuma carta no baralho, na mão, no campo de descanso, no campo de ataque nem na área de cartas especiais.

**Critérios de aceitação**

- Dado que o baralho está vazio, mas existe ao menos uma carta na mão ou em qualquer área do jogador, quando a condição é verificada, então ele não perde por esgotamento.
- Dado que baralho, mão, descanso, ataque e área especial estão todos sem cartas, quando a condição é verificada, então o jogador perde a partida.

**Origem:** o grupo considera derrota apenas quando o jogador realmente não possui carta alguma para continuar participando; um baralho vazio isoladamente não basta.

### RF-DES-015 — Alcance dos efeitos de dano

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-016

Todo efeito que causa dano a cartas pode afetar somente cartas localizadas no campo de ataque. Cartas no campo de descanso não são alvos válidos e não recebem dano desses efeitos.

**Critérios de aceitação**

- Dado que um efeito causa dano e existem cartas nos dois campos, quando seus alvos ou sua área são determinados, então somente cartas no ataque são consideradas.
- Dado que uma carta está no descanso, quando um efeito de dano é resolvido, então ela não perde Vida por esse efeito.

**Origem:** o grupo preserva o campo de descanso de todo dano e concentra as interações ofensivas no campo de ataque.

### RF-DES-016 — Vida máxima do jogador

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-DES-001

A Vida do jogador nunca pode ultrapassar o valor máximo configurado para a partida, inicialmente 50 no protótipo. Cura excedente é perdida.

**Critérios de aceitação**

- Dado que o máximo configurado é 50 e o jogador possui 49 de Vida, quando recupera 3, então termina com 50.
- Dado que o jogador já está com a Vida máxima, quando recebe cura, então sua Vida permanece no máximo.

**Origem:** o grupo limita a cura para impedir diferenças entre os valores máximos de Vida dos dois jogadores.

## Alternativas descartadas

- Atacar diretamente o campo de descanso quando o ataque adversário estiver vazio. Decisão substituída pela movimentação automática para evitar que um jogador se recuse a jogar.
- Aplicar dano restante diretamente ao jogador. Descartado; o dano sem alvo no campo de ataque é perdido.
- Resolver combates individuais entre pares de cartas. Descartado porque o campo ofensivo ataca como conjunto.
- Enviar cartas de ataque e suporte derrotadas para a pilha de descarte. Decisão substituída pelo retorno direto ao fundo do baralho, sem embaralhamento.

## Perguntas em aberto

- Nenhuma pergunta bloqueante identificada para a resolução básica do combate.

## Não aplicável a este jogo

- Ataque direto ao campo de descanso.
- Ataque direto à vida do jogador sem derrotar uma carta.
