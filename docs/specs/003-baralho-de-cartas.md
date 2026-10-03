# Spec 003 — Baralho de Cartas

## Objetivo

Definir o conjunto mínimo de cartas necessário para testar uma partida funcional e a variedade estratégica pretendida.

## Fora do escopo

- Baralho completo de 78 cartas — pertence a uma versão futura após a validação do protótipo.
- Implementar os 22 Arcanos Maiores como cartas especiais — o protótipo utilizará somente cinco cartas especiais.

### RF-AGE-006 — Composição do baralho do protótipo

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** nenhuma

O baralho de cada jogador no primeiro incremento contém exatamente 15 cartas únicas: cinco cartas de ataque, cinco cartas de suporte e cinco cartas especiais.

**Critérios de aceitação**

- Dado que o baralho do protótipo está completo, quando suas cartas são contadas, então há exatamente 15 cartas.
- Dado que as cartas são agrupadas por categoria, quando a composição é verificada, então existem cinco de ataque, cinco de suporte e cinco especiais.
- Dado que duas cartas do mesmo baralho são comparadas, quando suas identidades são verificadas, então elas não são cópias uma da outra.

**Origem:** o grupo reduziu o baralho para cinco cartas de cada categoria para viabilizar o protótipo e manteve todas diferentes para testar a dinâmica pretendida para o futuro baralho completo de 78 cartas. A composição foi revisada para ataque, suporte e cartas especiais.

### RF-AGE-007 — Baralhos idênticos

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-006

Os dois jogadores usam baralhos separados com as mesmas 15 cartas, diferenciando-se pela ordem produzida pelo embaralhamento.

**Critérios de aceitação**

- Dado que os dois baralhos estão preparados, quando suas identidades de carta são comparadas, então ambos contêm o mesmo conjunto de 15 cartas únicas.
- Dado que os baralhos são embaralhados, quando a partida começa, então a ordem das cartas pode ser diferente para cada jogador.

**Origem:** o grupo quer que ambos tenham acesso às mesmas cartas e que a variação entre suas mãos venha da ordem de embaralhamento, inclusive na futura versão de 78 cartas.

### RF-AGE-008 — Espaços de cartas especiais

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-006

Cada jogador possui uma área própria com exatamente três espaços para manter cartas especiais ativas.

**Critérios de aceitação**

- Dado que o jogador possui menos de três cartas especiais ativas, quando joga uma nova carta especial validamente, então ela ocupa um espaço livre em sua própria área.
- Dado que o jogador possui três cartas especiais ativas, quando tenta adicionar uma quarta sem escolher uma substituição, então a nova carta não entra na área.

**Origem:** o grupo separou os efeitos por jogador para que cada um combine os que melhor se encaixem em sua estratégia e limitou a área a três espaços para evitar efeitos demais simultaneamente.

### RF-AGE-009 — Acúmulo de efeitos especiais

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-008

Os efeitos contínuos das cartas especiais presentes nos três espaços de um jogador permanecem ativos simultaneamente e se acumulam quando forem compatíveis.

**Critérios de aceitação**

- Dado que um jogador possui duas ou três cartas especiais com efeitos contínuos compatíveis, quando o estado afetado é calculado, então todos esses efeitos ativos são considerados.

**Origem:** o grupo quer permitir que cada jogador construa uma combinação de efeitos adequada à própria estratégia.

### RF-AGE-010 — Substituição de carta especial

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-008

Quando os três espaços estiverem ocupados, o jogador precisa escolher uma carta especial ativa para descartar antes de colocar outra. O efeito contínuo da carta substituída termina; um efeito instantâneo já resolvido não é desfeito.

**Critérios de aceitação**

- Dado que os três espaços do jogador estão ocupados, quando ele escolhe uma carta contínua ativa e joga uma nova carta especial, então a escolhida vai para o cemitério e a nova ocupa seu espaço.
- Dado que a carta descartada concedia um efeito contínuo, quando ela deixa a área, então esse efeito deixa de ser aplicado.
- Dado que a carta descartada já resolveu um efeito instantâneo, quando ela deixa a área, então o resultado já produzido não é revertido.

**Origem:** o limite evita excesso de efeitos simultâneos; a substituição permite ajustar a combinação estratégica, distinguindo efeitos que dependem da permanência da carta de efeitos já concluídos.

### RF-AGE-011 — Uso de carta especial

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-008

Durante sua preparação, o jogador pode pagar o custo de uma carta especial para colocá-la diretamente da mão em sua área de cartas especiais, respeitando o limite máximo de uma carta especial jogada por turno. Cada carta especial custa cinco ou seis energias, conforme sua força.

**Critérios de aceitação**

- Dado que o jogador ainda não jogou uma carta especial no turno, possui energia suficiente e há um espaço livre, quando joga a carta, então seu custo de cinco ou seis energias é consumido e ela ocupa o espaço.
- Dado que o jogador já jogou uma carta especial no turno, quando tenta jogar outra, então a ação não é permitida.
- Dado que os três espaços estão ocupados e o jogador cumpre os demais requisitos, quando joga uma carta especial, então precisa aplicar a substituição definida em RF-AGE-010.

**Origem:** o grupo limitou o uso a uma carta especial por turno para que seja difícil preencher rapidamente os espaços e definiu custo entre cinco e seis energias para torná-las mais caras que a maioria das cartas comuns, reservando seis para efeitos mais fortes.

### RF-AGE-020 — Destino da carta especial imediata

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-008, RF-AGE-011

Uma carta especial de efeito imediato ocupa um espaço durante sua resolução e vai para o cemitério do dono assim que o efeito termina. Ela não permanece ativa nem mantém o espaço ocupado.

**Critérios de aceitação**

- Dado que o jogador usa uma carta especial de efeito imediato validamente, quando seu efeito termina de ser resolvido, então a carta vai para o cemitério de seu dono.
- Dado que a carta especial imediata foi enviada ao cemitério, quando os espaços especiais são verificados, então ela não ocupa um deles e não mantém efeito ativo.

**Origem:** o grupo envia a carta imediata ao cemitério porque ela já cumpriu sua função ao resolver o efeito e não possui efeito constante para justificar sua permanência.

### RF-AGE-021 — Permanência da carta especial temporária

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-008, RF-AGE-011

Uma carta especial cujo efeito dura por um período determinado permanece ocupando um dos três espaços enquanto o efeito estiver ativo. Quando a duração termina, seu efeito deixa de ser aplicado e a carta vai para o cemitério do dono.

**Critérios de aceitação**

- Dado que uma carta especial temporária foi jogada, quando seu efeito ainda está dentro da duração definida, então a carta permanece no espaço e o efeito continua ativo.
- Dado que a duração do efeito terminou, quando o estado é atualizado, então o efeito deixa de ser aplicado, a carta sai do espaço e vai para o cemitério de seu dono.

**Origem:** o grupo mantém a carta no espaço durante sua duração porque ela ainda está ativa; sua ida ao cemitério representa o encerramento do efeito.

### RF-AGE-022 — Orientação da carta comprada

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-006

Sempre que uma carta entra na mão por compra, o jogo sorteia sua orientação com 50% de chance de ficar reta e 50% de chance de ficar invertida. O jogador conhece a orientação enquanto a carta está na mão, e ela aplica o efeito correspondente quando for jogada. Se a carta retornar ao baralho e for comprada novamente, recebe um novo sorteio independente.

**Critérios de aceitação**

- Dado que uma carta entra na mão por compra, quando sua orientação é definida, então o sorteio oferece probabilidade igual para reta e invertida e o dono consegue conhecê-la antes de jogar.
- Dado que a orientação foi sorteada e a carta permanece na mão ou entra em jogo, quando seu efeito é consultado, então utiliza a regra correspondente àquela orientação.
- Dado que uma carta comum voltou ao fundo do baralho e foi comprada novamente, quando entra na mão, então sua orientação anterior é descartada e um novo sorteio de 50% é realizado.

**Origem:** o grupo quer que o jogador conheça o efeito disponível antes de decidir sua jogada, mas dependa parcialmente da sorte para obter a orientação necessária à sua estratégia em cada nova compra.

### RF-AGE-023 — Custos das cartas do protótipo

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-006

As 15 cartas do protótipo utilizam os custos abaixo.

| Categoria | Carta | Custo de energia |
|---|---|---:|
| Suporte | Ás de Paus | 2 |
| Suporte | 2 de Copas | 2 |
| Suporte | 6 de Ouros | 2 |
| Suporte | 7 de Copas | 2 |
| Suporte | 10 de Ouros | 3 |
| Ataque | 5 de Paus | 2 |
| Ataque | 3 de Espadas | 2 |
| Ataque | 7 de Espadas | 2 |
| Ataque | 9 de Paus | 2 |
| Ataque | 8 de Ouros | 2 |
| Especial | XIII — A Morte | 6 |
| Especial | X — Roda da Fortuna | 5 |
| Especial | XV — O Diabo | 5 |
| Especial | XIX — O Sol | 5 |
| Especial | XVIII — A Lua | 5 |

**Critérios de aceitação**

- Dado que uma carta do protótipo é jogada, quando seu custo é cobrado, então o valor corresponde à tabela deste requisito.
- Dado que os custos das cartas comuns são comparados, quando a tabela é verificada, então nove custam 2 energias e somente o 10 de Ouros custa 3.
- Dado que os custos das especiais são comparados, quando a tabela é verificada, então quatro custam 5 energias e somente A Morte custa 6.

**Origem:** o grupo normalizou os custos para evitar variabilidade excessiva: cartas comuns originalmente entre dois e quatro passaram a custar dois, a comum de custo cinco passou a três e especiais abaixo de cinco passaram a cinco.

### RF-AGE-024 — Destino de carta comum descartada

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-006

Quando um efeito ou uma ação manda descartar uma carta de ataque ou suporte, ela vai diretamente para o fundo do baralho de seu dono, sem embaralhamento.

**Critérios de aceitação**

- Dado que uma carta de ataque ou suporte é descartada da mão, do campo ou do topo do baralho, quando o descarte é resolvido, então ela se torna a última carta do baralho de seu dono.
- Dado que uma ou mais cartas comuns foram enviadas ao fundo, quando a resolução termina, então o baralho não é embaralhado.

**Origem:** o grupo quer permitir que o jogador troque as opções atuais e planeje deixar essas cartas para depois, sem removê-las definitivamente da partida.

### RF-AGE-014 — Atributos da carta de ataque

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-006

Cada carta de ataque possui custo de energia e um valor base que define igualmente sua vida inicial e seu ataque. O dano reduz sua vida atual, mas não reduz seu valor de ataque.

**Critérios de aceitação**

- Dado que uma carta de ataque com valor base X entra em jogo, quando seus atributos iniciais são verificados, então ela possui X de vida e X de ataque.
- Dado que uma carta de ataque sofreu dano sem ser derrotada, quando seus atributos são verificados, então sua vida atual foi reduzida e seu ataque continua igual ao valor base.

**Origem:** o grupo igualou vida inicial e ataque para facilitar a leitura imediata da carta e preservou o ataque após dano para que ela não perca seu valor ofensivo por estar ferida.

### RF-AGE-015 — Comportamento da carta de suporte

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-006, RF-AGE-003

Cada carta de suporte possui ataque, vida, custo de energia e um efeito voltado a fortalecimento, geração de recursos ou manipulação do campo. Seu ataque e sua vida iniciais usam o mesmo valor. Ela segue as mesmas regras de entrada, movimentação, ataque, dano e derrota das cartas de ataque; a categoria serve para organizar a função de seus efeitos.

**Critérios de aceitação**

- Dado que uma carta de suporte está na mão, quando é colocada em jogo, então entra no campo de descanso.
- Dado que uma carta de suporte com valor base X entra em jogo, quando seus atributos iniciais são verificados, então ela possui X de ataque e X de vida.
- Dado que uma carta de suporte já estava no campo de descanso, quando é movida validamente, então entra no campo de ataque.
- Dado que uma carta de suporte está no campo de ataque, quando o jogador realiza o ataque conjunto, então seu valor de ataque contribui para o dano total.
- Dado que uma carta de suporte recebe dano sem ser derrotada, quando seus atributos são atualizados, então sua vida diminui e seu ataque não é reduzido pelo dano.

**Origem:** o grupo revisou suportes para funcionar em combate como cartas de ataque. As categorias continuam separadas para organizar seus efeitos: suportes fortalecem, geram recursos ou manipulam o campo, enquanto cartas de ataque exercem pressão e interação ofensiva direta.

### RF-AGE-025 — Normalização de ataque e vida

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-014, RF-AGE-015

Se o rascunho de uma carta comum trouxer ataque e vida iniciais diferentes, ambos são normalizados para o menor valor, exceto quando a carta for explicitamente classificada como tanque por ter a função de receber dano; nesse caso, ambos usam o maior valor.

**Critérios de aceitação**

- Dado que uma carta comum não tanque foi proposta como 2/4, quando seus valores base são normalizados, então ela se torna 2/2.
- Dado que uma carta comum explicitamente destinada a receber dano foi proposta como 2/4, quando seus valores base são normalizados, então ela se torna 4/4.
- Dado que o 7 de Copas tem função de escolha e manipulação e não de absorção de dano, quando seus valores são registrados, então possui 2 de ataque e 2 de vida.

**Origem:** o grupo quer manter a leitura simples de ataque e vida iguais. O maior valor fica reservado a cartas cuja função explícita seja receber dano; como o 7 de Copas manipula cartas, ele usa o menor valor.

### RF-AGE-026 — Momento de ativação dos efeitos de entrada

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-017, RF-AGE-018, RF-AGE-022

O momento de ativação de um efeito “ao entrar em campo” depende de sua função. Efeitos que causam ou modificam dano, ataque, vida, escolha de alvo ou destruição ativam quando a carta entra no campo de ataque. Efeitos que alteram apenas energia, mão ou baralho ativam quando a carta entra no campo de descanso.

**Critérios de aceitação**

- Dado que uma carta possui efeito de entrada relacionado a dano, ataque, vida, alvo ou destruição, quando é colocada no descanso, então o efeito aguarda; quando a carta avança ao ataque, então o efeito é ativado.
- Dado que uma carta possui efeito de entrada que altera apenas energia, mão ou baralho, quando é colocada no descanso, então o efeito é ativado imediatamente e não é repetido ao avançar para o ataque.

**Origem:** o grupo usa momentos diferentes porque os efeitos cumprem funções diferentes: efeitos de combate dependem da entrada na área ofensiva, enquanto efeitos de recursos e manipulação já cumprem sua função durante a preparação.

### RF-AGE-040 — Visibilidade da orientação

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-022

Enquanto uma carta está na mão, somente seu dono vê sua orientação e efeito correspondente. Quando ela é jogada, a orientação e o efeito tornam-se públicos imediatamente.

**Critérios de aceitação**

- Dado que uma carta está na mão de um jogador, quando o adversário observa o estado da partida, então não consegue ver sua orientação nem seu efeito sorteado.
- Dado que a carta é jogada, quando entra em sua área ou começa a resolver, então ambos os jogadores conseguem ver sua orientação e efeito.

**Origem:** o grupo mantém a mão privada para que o adversário não conheça as opções ocultas, mas revela a carta jogada para que ele entenda a ação realizada.

### RF-AGE-054 — Renovação ao retornar ao baralho

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-024

Quando uma carta comum retorna ao fundo do baralho, ela perde todo dano, modificador, vínculo, proteção e marca de uso, retornando ao estado base. Ao ser comprada novamente, recebe uma nova orientação pelas regras normais.

**Critérios de aceitação**

- Dado que uma carta comum com Vida reduzida, modificadores ou efeitos usados volta ao fundo, quando o retorno termina, então esses estados deixam de existir.
- Dado que essa carta é comprada novamente, quando entra na mão, então apresenta seus atributos base e recebe novo sorteio de orientação.

**Origem:** o grupo trata o retorno ao baralho como uma renovação completa da carta, como se ela ainda não tivesse sido gasta naquela passagem pelo campo.

### RF-AGE-069 — Valores base das cartas comuns

**Prioridade:** DEVE
**Status:** PROVISÓRIO
**Depende de:** RF-AGE-006, RF-AGE-025

As dez cartas comuns usam os seguintes valores iniciais de Ataque e Vida:

| Categoria | Carta | Ataque/Vida base |
|---|---|---:|
| Suporte | Ás de Paus | 2/2 |
| Suporte | 2 de Copas | 3/3 |
| Suporte | 6 de Ouros | 2/2 |
| Suporte | 7 de Copas | 2/2 |
| Suporte | 10 de Ouros | 5/5 |
| Ataque | 5 de Paus | 4/4 |
| Ataque | 3 de Espadas | 3/3 |
| Ataque | 7 de Espadas | 3/3 |
| Ataque | 9 de Paus | 5/5 |
| Ataque | 8 de Ouros | 3/3 |

**Critérios de aceitação**

- Dado que o baralho do protótipo é preparado, quando os valores base são verificados, então correspondem à tabela.
- Dado que uma carta comum entra em jogo sem modificadores, quando seus atributos são exibidos, então Ataque e Vida inicial possuem o mesmo valor.

**Origem:** o grupo distribuiu cartas fracas, médias e fortes para testar se custo, efeito e risco de perder Vida ficam equilibrados.

**Hipótese de protótipo**

- **Valor inicial:** tabela acima, com valores entre 2/2 e 5/5.
- **Pergunta do protótipo:** essa distribuição equilibra custo, força dos efeitos e risco de dano ao dono quando uma carta é derrotada?
- **Teto ou limite de exploração:** cada carta pode variar no máximo 1 ponto por rodada de ajuste, sem sair da faixa absoluta de 1/1 a 6/6.

## Alternativas descartadas

- Implementar 78 cartas no primeiro incremento. Descartado para reduzir o escopo do protótipo.
- Usar cópias repetidas de poucos modelos. Descartado porque o grupo quer observar desde cedo a dinâmica de um baralho formado por cartas únicas.
- Dividir o protótipo entre ataque, defesa e suporte. Decisão substituída pelas categorias ataque, suporte e carta especial/feitiço.
- Usar um único efeito especial global. Descartado para que cada jogador possa montar sua própria combinação estratégica.
- Impedir cartas de suporte de atacar. Decisão substituída: suportes agora participam do combate como cartas de ataque e se diferenciam apenas pela função de seus efeitos.
- Sortear a orientação somente ao jogar a carta. Decisão substituída pelo sorteio ao entrar na mão, para que o jogador conheça o efeito antes de decidir.

## Perguntas em aberto

- Nenhuma pergunta bloqueante identificada para composição, custos e valores base; o balanceamento dos valores permanece provisório para playtest.

## Não aplicável a este jogo

- Nenhum item identificado até o momento.
