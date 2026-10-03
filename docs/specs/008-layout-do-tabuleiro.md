# Spec 008 — Layout do Tabuleiro

## Objetivo

Substituir a organização atual em colunas de texto por um tabuleiro visual, vertical e espelhado, no qual o adversário ocupa a metade superior e o jogador local ocupa a metade inferior. O layout deve permitir reconhecer as cartas, seus atributos, seus efeitos e o estado da partida sem exigir a abertura de listas separadas.

## Referência de interface

A referência fornecida pelo grupo é uma mesa digital do Pokémon TCG vista de cima. Dela, esta Spec aproveita somente:

- a organização espelhada entre adversário e jogador;
- a mão do jogador junto à borda inferior e a mão adversária junto à borda superior;
- as cartas em jogo distribuídas em fileiras pertencentes a cada dono;
- os montes e zonas auxiliares posicionados nas laterais;
- o combate concentrado no centro da mesa.

A aparência, as cores, os símbolos e a estrutura das cartas de Pokémon não devem ser copiados.

## Esquema funcional

```text
┌──────────────────────────────────────────────────────────────────────────┐
│ HUD ADVERSÁRIO       MÃO ADVERSÁRIA (versos + quantidade)              │
│ Baralho / Cemitério  Especiais (3)  Descanso (3)                      │
│                      Ataque adversário (5)                            │
│                                                                          │
│               ESTADO DO TURNO / RESOLUÇÃO DO COMBATE                  │
│                                                                          │
│                      Ataque do jogador (5)                              │
│ Baralho / Cemitério  Especiais (3)  Descanso (3)                      │
│ HUD JOGADOR          MÃO DO JOGADOR (faces)        AÇÕES CONTEXTUAIS │
│                      DETALHES DA CARTA SELECIONADA                      │
└──────────────────────────────────────────────────────────────────────────┘
```

O esquema determina hierarquia e proximidade entre as zonas, não posições em pixels.

## Fora do escopo

- Ilustrações elaboradas, molduras finais, animações e efeitos sonoros — a primeira versão usará retângulos, cores e texto.
- Redesenho do turno zero — seu fluxo e sua tela atuais permanecem funcionais até receberem uma Spec própria.
- Alteração das regras, capacidades dos campos ou efeitos das cartas — esta Spec muda a apresentação, não o jogo.
- Interface para celular — a plataforma inicial continua sendo PC.
- Criação de terreno — o sistema continua fora do primeiro incremento.

### RF-INT-001 — Tabuleiro espelhado

**Prioridade:** DEVE  
**Status:** CONFIRMADO  
**Depende de:** RF-AGE-016

Durante a partida, o jogo apresenta o adversário na metade superior da tela e o jogador local na metade inferior. Os campos de ataque ficam mais próximos do centro; descanso, especiais, mão e reservas ficam progressivamente mais próximos do respectivo dono.

**Critérios de aceitação**

- Dado que uma partida foi iniciada, quando o tabuleiro aparece, então é possível distinguir as metades do jogador e do adversário sem consultar rótulos de lista.
- Dado que ambos possuem cartas no campo de ataque, quando o tabuleiro é observado, então as duas fileiras de ataque ficam frente a frente e mais próximas do centro que as fileiras de descanso.
- Dado que uma carta muda de descanso para ataque, quando a interface atualiza, então o mesmo cartão visual muda para a fileira de ataque do seu dono.

**Origem:** o grupo quer um layout semelhante à referência fornecida, cuja organização de mesa vista de cima torna clara a relação entre os dois lados e concentra o confronto no centro.

### RF-INT-002 — Zonas e capacidades visíveis

**Prioridade:** DEVE  
**Status:** CONFIRMADO  
**Depende de:** RF-INT-001, RF-AGE-016, RF-AGE-008

O tabuleiro representa permanentemente, para cada jogador, cinco espaços de ataque, três de descanso e três de cartas especiais. Espaços ocupados mostram a carta; espaços vazios continuam reconhecíveis como destinos possíveis.

**Critérios de aceitação**

- Dado que os dois jogadores estão com todos os campos vazios, quando o tabuleiro aparece, então cada lado ainda comunica cinco espaços de ataque, três de descanso e três de especiais.
- Dado que um campo atinge sua capacidade, quando o tabuleiro é observado, então todas as cartas desse campo permanecem visíveis ao mesmo tempo.
- Dado que uma jogada tenta usar uma zona sem espaço, quando a carta é selecionada, então a interface comunica que a zona está cheia antes de qualquer custo ser pago.

**Origem:** mostrar os espaços como partes da mesa aproxima a interface da referência e permite que o jogador planeje ocupação e movimentação sem alternar entre listas.

### RF-INT-003 — Representação básica das cartas

**Prioridade:** DEVE  
**Status:** CONFIRMADO  
**Depende de:** RF-INT-002, RF-AGE-014, RF-AGE-015, RF-AGE-022, RF-AGE-023

Cada carta é representada por um retângulo vertical simples. Sem depender de ilustração, sua face mostra nome, categoria, orientação atual, custo de energia e um resumo do efeito ativo. Cartas de ataque e suporte mostram também Ataque e Vida atual/máxima; cartas especiais mostram a permanência do efeito.

**Critérios de aceitação**

- Dado que uma carta comum está visível na mão ou no campo, quando sua face é observada, então nome, categoria, orientação, custo, Ataque e Vida atual/máxima podem ser identificados.
- Dado que uma carta especial está visível na mão ou em sua área, quando sua face é observada, então nome, orientação, custo, resumo do efeito e permanência podem ser identificados.
- Dado que a carta recebe dano ou modificador, quando o estado muda, então os valores atuais mudam sem apagar a informação de valor máximo ou base necessária para compreender a alteração.

**Origem:** o grupo quer iniciar sem artes elaboradas, usando retângulos normais, mas considera indispensável enxergar cartas, atributos e efeitos.

### RF-INT-004 — Detalhes da carta selecionada

**Prioridade:** DEVE  
**Status:** CONFIRMADO  
**Depende de:** RF-INT-003

Selecionar uma carta pública ou uma carta da própria mão abre uma área persistente de detalhes com o texto completo do efeito correspondente à orientação atual, todos os atributos e modificadores ativos. Essa área não cobre as fileiras de ataque e descanso.

**Critérios de aceitação**

- Dado que o resumo do efeito não cabe inteiro no retângulo, quando a carta é selecionada, então o texto completo pode ser lido sem ocultar o campo de combate.
- Dado que uma carta possui dano, bônus, penalidade, proteção ou duração ativa, quando ela é selecionada, então esses estados aparecem nos detalhes.
- Dado que outra carta é selecionada, quando os detalhes atualizam, então somente a nova carta fica marcada como selecionada e suas informações substituem as anteriores.

**Origem:** o grupo exige que os efeitos sejam legíveis; separar resumo e leitura completa permite manter todas as cartas visíveis sem comprimir o texto dentro delas.

### RF-INT-005 — Mãos e informação privada

**Prioridade:** DEVE  
**Status:** CONFIRMADO  
**Depende de:** RF-INT-001, RF-INT-003, RF-AGE-040, RF-AGE-019

A mão do jogador local aparece junto à borda inferior com as faces acessíveis. A mão adversária aparece junto à borda superior apenas como versos e quantidade, exceto durante um efeito que autorize sua revelação. Como não existe limite de mão, a região permite percorrer cartas excedentes sem aumentar o tamanho total do tabuleiro.

**Critérios de aceitação**

- Dado que o jogador possui cartas na mão, quando observa a parte inferior, então consegue percorrer, selecionar e ler todas elas.
- Dado que o adversário possui cartas e nenhum efeito de revelação está ativo, quando sua mão é observada, então identidades, orientações e efeitos permanecem ocultos, mas a quantidade é visível.
- Dado que a quantidade de cartas ultrapassa a largura reservada, quando o jogador navega pela mão, então alcança todas as cartas sem deslocar as zonas do tabuleiro.

**Origem:** a referência posiciona as mãos nas bordas da mesa; o projeto preserva também a decisão anterior de manter a orientação da mão privada e não limitar sua quantidade.

### RF-INT-006 — Reservas e estado dos jogadores

**Prioridade:** DEVE  
**Status:** CONFIRMADO  
**Depende de:** RF-INT-001, RF-DES-001, RF-DES-016, RF-AGE-013, RF-AGE-020, RF-AGE-024

Cada lado do tabuleiro possui indicadores permanentes de Vida, Energia, quantidade no baralho e quantidade no cemitério. Baralho e cemitério aparecem como zonas laterais distintas; o cemitério permite consultar quais cartas especiais estão nele.

**Critérios de aceitação**

- Dado que a partida está em andamento, quando qualquer lado é observado, então Vida atual/máxima, Energia e quantidades de baralho, mão e cemitério estão visíveis.
- Dado que uma carta comum volta ao fundo do baralho, quando a interface atualiza, então a quantidade do baralho aumenta e o cemitério não muda.
- Dado que uma carta especial vai ao cemitério, quando sua zona é consultada, então a identidade da carta pode ser vista.

**Origem:** a referência coloca montes auxiliares nas laterais; o projeto precisa manter clara sua distinção própria entre fundo do baralho e cemitério.

### RF-INT-007 — Ações contextuais e feedback de seleção

**Prioridade:** DEVE  
**Status:** PROVISÓRIO  
**Depende de:** RF-INT-004, RF-AGE-002, RF-AGE-003, RF-AGE-005

Selecionar uma carta mostra somente as ações válidas para ela no estado atual da partida. A carta selecionada, os destinos permitidos e os alvos permitidos recebem estados visuais distintos. Ações contextuais ficam junto à área de detalhes, e as ações globais de atacar ou encerrar turno permanecem em uma barra fixa.

**Critérios de aceitação**

- Dado que uma carta da mão pode ser jogada, quando ela é selecionada, então a ação correspondente e os destinos válidos ficam evidentes sem cobrir os atributos.
- Dado que uma carta não pode avançar, ser usada ou ser escolhida como alvo, quando o jogador tenta interagir com ela, então a interface não executa a ação e informa o motivo.
- Dado que o ataque entrou em resolução, quando restam alvos válidos, então esses alvos e o dano restante ficam visíveis e as outras ações do turno permanecem bloqueadas.
- Dado que não há seleção, quando a partida está na preparação, então as ações globais continuam acessíveis.

**Origem:** retirar os botões de dentro de cada carta libera espaço para atributos e efeitos, enquanto a seleção contextual mantém o controle por mouse definido para o projeto.

**Hipótese de protótipo**

- **Valor inicial:** um clique seleciona a carta; um segundo clique em uma ação contextual confirma a jogada. Ataque e encerramento usam botões globais fixos.
- **Pergunta do protótipo:** a seleção contextual deixa a jogada clara sem exigir botões repetidos em todos os cartões?
- **Teto ou limite de exploração:** nesta rodada, testar somente clique simples, destaque visual e botões contextuais; arrastar cartas, menus radiais e atalhos de teclado ficam fora do teste.

### RF-INT-008 — Estado do turno e avisos obrigatórios

**Prioridade:** DEVE  
**Status:** CONFIRMADO  
**Depende de:** RF-INT-001, RF-AGE-001, RF-AGE-010, RF-DES-004

O centro do tabuleiro comunica rodada, jogador ativo, fase atual e avisos que exigem resposta. Avisos de ataque vazio, efeitos pendentes, substituição de especial e jogadas com risco de derrota devem permanecer visíveis até serem resolvidos ou cancelados.

**Critérios de aceitação**

- Dado que um turno começa, quando o tabuleiro atualiza, então rodada, jogador ativo e fase podem ser identificados sem consultar o histórico.
- Dado que existe uma escolha obrigatória de efeito ou combate, quando o jogador observa o centro, então entende o que deve selecionar e não consegue encerrar o turno antes de concluir a escolha.
- Dado que o jogador recebe o aviso de campo de ataque vazio, quando seu turno começa, então o aviso permanece visível durante a preparação.

**Origem:** a organização visual da referência concentra a disputa no centro; o projeto usa esse espaço também para deixar explícita a última etapa do turno e impedir que o jogador perca uma exigência de resolução.

### RNF-INT-001 — Legibilidade na resolução-base

**Prioridade:** DEVE  
**Status:** PROVISÓRIO  
**Depende de:** RF-INT-002, RF-INT-003, RF-INT-004

Na resolução-base de 1600×900, as duas fileiras de ataque, as duas fileiras de descanso, as áreas de especiais, os indicadores dos jogadores e as ações globais permanecem visíveis sem rolagem da tela inteira. Somente coleções de tamanho variável, como mão, baralho consultado, cemitério e histórico, podem possuir rolagem própria.

**Critérios de aceitação**

- Dado que todos os onze espaços de campo de cada jogador estão ocupados, quando a partida é exibida em 1600×900, então nenhuma carta de ataque, descanso ou especial exige rolagem para ser localizada.
- Dado que a mão possui mais cartas do que a largura comporta, quando a coleção é percorrida, então o restante do tabuleiro não muda de posição.
- Dado que uma carta é selecionada, quando seus detalhes aparecem, então a barra de ataque e encerramento e os campos continuam acessíveis.

**Origem:** o grupo quer enxergar cartas, atributos e efeitos em uma mesa semelhante à referência, e o projeto já adota 1600×900 como resolução-base para evitar textos e controles espremidos.

**Hipótese de protótipo**

- **Valor inicial:** 1600×900, com todas as 22 posições de campo visíveis e rolagem limitada às coleções variáveis.
- **Pergunta do protótipo:** o texto essencial das cartas continua legível quando os dois lados atingem a capacidade máxima?
- **Teto ou limite de exploração:** ajustar escala, espaçamento e quantidade de linhas do resumo dentro de 1600×900; não aumentar a resolução-base nem esconder cartas dos campos nesta rodada.

## Alternativas descartadas

- Manter quatro colunas verticais com cartões e botões. Descartado porque não comunica uma mesa de duelo e divide a largura necessária para mostrar cartas.
- Colocar o texto completo de todos os efeitos permanentemente dentro de cada carta. Descartado porque tornaria impossível exibir simultaneamente os campos completos com legibilidade.
- Usar ilustrações elaboradas nesta etapa. Adiado porque o grupo quer validar primeiro a organização e a leitura das informações.
- Copiar a identidade visual das cartas de Pokémon. Descartado porque a referência serve para organização espacial, enquanto Cartomência precisa de identidade própria.

## Perguntas em aberto

- Qual paleta, tipografia, iconografia e acabamento representarão a atmosfera mística do tarô. Não bloqueia o protótipo retangular.
- Se o painel de detalhes funcionará melhor na lateral ou na faixa inferior. A implementação pode testar as duas posições sem alterar os requisitos.

## Não aplicável a este jogo

- Exibir a face da mão adversária permanentemente.
- Ocultar cartas de campo por informação imperfeita.
- Adaptar a interface para orientação retrato de celular nesta entrega.
