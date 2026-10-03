# ADR 009 — Tabuleiro espelhado com inspetor contextual

- **Status:** Aceita
- **Data:** 2026-10-03

## Contexto

A interface anterior distribuía mão, descanso, ataque e adversário em quatro colunas de cartões textuais. Essa solução permitia operar as regras, mas não mostrava a partida como uma mesa de duelo e repetia botões dentro de cada carta. Exibir simultaneamente o texto completo dos efeitos nas 22 posições de campo também ultrapassaria a altura de 1600×900.

## Decisão

A cena principal passa a renderizar uma mesa espelhada: adversário acima, jogador ativo abaixo e campos de ataque frente a frente. Cada lado possui cinco espaços fixos de ataque, três de descanso e três de especiais, mesmo quando vazios.

Os cartões mostram identidade, categoria, orientação, custo, atributos e nome do efeito em formato compacto. Um inspetor persistente mostra o texto completo, valores base e atuais, estados ativos e as ações válidas da carta selecionada. Ações globais permanecem fixas. O texto dos 30 lados de efeito fica em um catálogo de apresentação separado do resolvedor de regras.

A interface continua observando `TurnController`, `PlayerState`, `CardState` e `CardEffectResolver`; ela não altera diretamente as coleções nem resolve efeitos.

## Consequências

- As 22 posições de campo cabem simultaneamente em 1600×900.
- A leitura completa depende de selecionar uma carta, enquanto o estado essencial permanece no cartão.
- Mãos e escolhas de tamanho variável usam rolagem horizontal sem deslocar a mesa.
- Alvos, seleções e cartas escolhidas recebem bordas diferentes.
- Alterar uma regra de efeito exige manter seu texto de apresentação sincronizado, mas não mistura essa descrição com a lógica de resolução.
