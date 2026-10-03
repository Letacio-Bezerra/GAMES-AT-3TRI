# ADR 003 — Definição estável e estado renovável das cartas

- **Status:** Aceita
- **Data:** 2026-10-02

## Contexto

Os dois jogadores precisam possuir o mesmo conjunto de 15 cartas, mas cada cópia acumula orientação, dano, modificadores e marcas próprias durante a partida. Quando uma carta comum retorna ao baralho, todo esse estado transitório precisa ser removido sem perder sua identidade, custo ou valores base.

## Decisão

Cada `CardState` guarda uma definição estável — identidade, categoria, custo, valores base e metadados dos dois efeitos — junto de um estado transitório renovável. `renew()` restaura atributos, remove orientação e limpa marcas antes de devolver a carta ao fundo.

O catálogo cria novas instâncias das mesmas 15 identidades para cada jogador. O fluxo de turno emite ganchos de ativação em vez de implementar efeitos individuais: entrada no descanso, entrada no ataque e uso de especial. Especiais também declaram seu ciclo de vida por orientação.

## Consequências

- Baralhos podem ser comparados por identidade sem compartilhar dano ou modificadores.
- Toda compra utiliza a mesma operação de sorteio de orientação.
- A Spec 007 poderá conectar resolvedores aos sinais existentes sem alterar compra, campos ou custos.
- Efeitos cujo ciclo depende de um resultado aleatório, como a Roda da Fortuna, permanecem ativos até que o resolvedor informe seu destino.
