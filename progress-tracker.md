# Progress Tracker

## Ciclo 2 — Diversão

### Unidade atual: Spec 008 — Layout do Tabuleiro

- **Status:** IMPLEMENTADA E VALIDADA AUTOMATICAMENTE; aguardando playtest manual.
- **Pergunta da unidade:** uma mesa espelhada com cartas retangulares e detalhes contextuais permite compreender o estado e planejar jogadas sem recorrer a listas de texto?
- **Entregáveis:** tabuleiro espelhado, onze espaços de campo por jogador, cartões legíveis, mãos nas bordas, painel de detalhes, reservas laterais, estado do turno e ações contextuais.

### Critérios a validar

- Todas as 22 posições de campo permanecem localizáveis em 1600×900 sem rolagem do tabuleiro.
- Nome, categoria, orientação, custo, atributos e resumo do efeito aparecem nas cartas aplicáveis.
- O efeito completo e os modificadores da carta selecionada podem ser lidos sem cobrir os campos.
- A mão sem limite pode ser percorrida sem deslocar o restante da mesa.
- Seleção, destinos, alvos e bloqueios ficam visualmente distintos.

### Validação realizada

- A interface criou onze espaços fixos por lado e manteve as 22 cartas simultaneamente visíveis com ocupação máxima.
- A área mínima combinada da partida permaneceu dentro de 1600×900.
- Cartões mostraram informação compacta e o inspetor exibiu texto completo, valores base/atuais e estados ativos.
- Mão extensa ativou rolagem horizontal; mão adversária permaneceu oculta fora de efeitos autorizados.
- A regressão percorreu jogar, avançar, descartar, usar e substituir especial, escolhas de efeito e distribuição de dano.
- As nove suítes do projeto passaram no Godot 4.6.2.

### Hipóteses do protótipo

- RF-INT-007: seleção por clique e ações contextuais substituem botões repetidos em cada carta.
- RNF-INT-001: a resolução-base de 1600×900 comporta os campos completos com informação essencial legível.

### Próxima unidade recomendada

- Fazer uma partida manual completa, observando se o jogador encontra as ações contextuais e lê as cartas confortavelmente sem explicação adicional.

## Histórico — Ciclo 1: Núcleo Jogável

### Unidade atual: Spec 007 — Cartas do Protótipo

- **Status:** IMPLEMENTADA E VALIDADA AUTOMATICAMENTE; aguardando playtest manual integrado.
- **Pergunta da unidade:** os efeitos retos e invertidos das 15 cartas criam escolhas compreensíveis e resolvem corretamente alvos, durações e destinos?
- **Entregáveis:** resolvedor de efeitos, fase de escolhas, modificadores temporários, proteções, passivos, efeitos aleatórios, interface de alvo e testes automatizados.

### Critérios cobertos

- RF-AGE-027–039: proteções, transformação, ficha descartável, regras globais de modificadores e bloqueio transacional sem alvo.
- RF-AGE-041–053: efeitos de entrada das cinco cartas de suporte e dos três primeiros ataques, incluindo escolhas encadeadas e dano simultâneo.
- RF-AGE-055–059: Última Resistência, Exaustão, Aperfeiçoamento, Trabalho Excessivo e Resistência à Morte.
- RF-AGE-060–068: resultados da Roda, Pacto, Quebrar as Correntes, Plenitude, Eclipse e Revelação.

### Validação

- `test_card_effects.gd` e `test_card_effects_extended.gd`: passaram no Godot 4.6.2 cobrindo efeitos de entrada, passivos, proteção, duração, transformação, energia, baralho e especiais.
- `test_main_ui.gd`: confirmou escolhas de efeito em sequência, substituição de especial e resolução de A Morte sem fechar a cena.
- As sete suítes anteriores continuaram passando; o projeto também inicia em modo headless sem erro de parse.
- Playtest manual de uma partida completa com os 30 lados de efeito ainda não realizado.

### Restrições preservadas

- Vida inicial 50 é hipótese provisória; o playtest deve confirmar partida entre três e dez rodadas antes de qualquer ajuste até o teto 100.
- Dano excedente sem alvo é perdido e nunca atinge descanso ou jogador diretamente.
- Balanceamento final continua fora do escopo e depende do playtest integrado.

### Unidades anteriores

- Spec 006 — Sistema de Combate: implementada e validada automaticamente; aguarda playtest de duração.
- Spec 005 — Campos de Jogo: implementada e validada automaticamente; aguarda playtest dos limites.
- Spec 004 — Sistema de Energia: implementada e validada automaticamente; aguarda playtest do ritmo.
- Specs 001–003: implementadas, cobertas por regressão e com correções de playtest integradas.

### Próxima unidade recomendada

- Fazer uma partida manual completa e registrar duração, clareza das escolhas, vantagem de iniciativa e efeitos que gerem dúvida ou desequilíbrio.
