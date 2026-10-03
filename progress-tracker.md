# Progress Tracker

## Ciclo 1 — Núcleo Jogável

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
