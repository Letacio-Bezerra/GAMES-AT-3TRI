# Estado do Ciclo

- **Ciclo atual:** Ciclo 1 — Núcleo Jogável
- **Objetivo:** especificar uma partida funcional para dois jogadores com turno zero, energia, baralhos, campos de descanso e ataque e combate até a vida se esgotar.
- **Specs selecionadas:** `001-fluxo-do-turno.md`, `002-turno-zero.md`, `003-baralho-de-cartas.md`, `004-sistema-de-energia.md`, `005-campos-de-jogo.md`, `006-sistema-de-combate.md` e `007-cartas-do-prototipo.md`.
- **Status:** CONCLUÍDO
- **Evidências de playtest:** em 2026-09-30, a interface da Spec 001 fechava ao jogar ou avançar uma carta e não permitia rolar listas extensas. A reconstrução visual foi adiada com liberação segura dos nós, as quatro áreas receberam rolagem vertical e os cenários passaram em teste automatizado de regressão. Em 2026-10-02, o playtest identificou textos e botões espremidos, barra inferior cortada e ambiguidade entre descarte comum e cemitério. A janela passou a 1600×900, as cartas ganharam blocos com ações em linha separada, a barra inferior tornou-se fluida e o descarte comum passou a indicar explicitamente seu destino no fundo do baralho. Um segundo relato mostrou que uma especial nova parecia desaparecer durante a substituição; a interface passou a identificar efeitos imediatos antes do uso e a listar nominalmente o cemitério, enquanto a regressão confirmou que especiais temporárias ocupam corretamente o espaço liberado. As Specs 004 e 005 percorreram automaticamente energia e campos. A Spec 006 percorreu Vida, ataque conjunto, alvos sequenciais, dano persistente, derrota, destruição, esgotamento e correção de ataque vazio, inclusive pela interface. Falta uma partida manual completa para medir duração e pressão estratégica da versão integrada.
- **Motivo para avanço:** as sete Specs selecionadas definem uma partida completa para dois jogadores, incluindo preparação, turnos, energia, campos, combate, condição de vitória e as 15 cartas do protótipo. Não restam decisões bloqueantes; os três requisitos provisórios possuem valores, perguntas e limites de teste explícitos.

## Lacunas bloqueantes para implementação

- Nenhuma.

## Sugestão de divisão do trabalho

- **Game Designer / PO:** acompanhar os três requisitos provisórios, preparar os critérios do playtest e registrar duração, vantagem de iniciativa e equilíbrio das cartas. Dependência: protótipo integrado. Esforço: baixo.
- **Gameplay Programmer:** implementar ou integrar efeitos, modificadores, orientações, renovação de cartas e condições de alvo das Specs 003, 006 e 007. Dependência: fluxo, energia e campos existentes. Esforço: alto.
- **UI Programmer:** comunicar orientação, alvos válidos, efeitos ativos, duração, avisos de risco e destinos de descarte/cemitério. Dependência: estados expostos pelo gameplay. Esforço: médio.
- **Artist / Animator:** criar identificadores visuais provisórios legíveis para as 15 cartas, orientações e estados, sem antecipar a direção de arte final. Dependência: lista fechada da Spec 007. Esforço: médio.
- **Level Designer:** preparar cenários de teste do tabuleiro com os limites de descanso, ataque e espaços especiais, incluindo situações extremas de alvo e campo vazio. Dependência: Specs 005–007. Esforço: baixo.
- **Marketing / Communication:** produzir uma explicação curta do protótipo e registrar imagens ou vídeo da partida para apresentação do incremento. Dependência: build jogável. Esforço: baixo.

Estimativa sugerida: uma a duas aulas para integração e validação, ajustável pelo Game Designer / PO.

## Fora do escopo do ciclo

- Efeitos de terreno — adiados porque não são necessários para validar uma partida completa e funcional.
- Partidas com mais de dois jogadores — ainda não foram planejadas.
