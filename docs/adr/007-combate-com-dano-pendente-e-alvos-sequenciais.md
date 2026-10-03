# ADR 007 — Combate com dano pendente e alvos sequenciais

- **Status:** Aceita
- **Data:** 2026-10-02

## Contexto

O ataque soma todo o campo ofensivo, mas a Spec 006 exige que o atacante escolha um alvo por vez e escolha novamente quando uma derrota deixar dano excedente. Resolver tudo num callback de botão impediria escolhas humanas intermediárias; deixar a interface alterar Vida diretamente duplicaria regras de derrota e vitória.

## Decisão

`TurnController` possui uma fase `RESOLVING_ATTACK` e conserva o atacante e o dano ainda não distribuído. `attack()` calcula a soma e abre a primeira escolha. `select_attack_target()` aceita somente cartas do ataque adversário, aplica dano, resolve eventual derrota e encerra ou solicita o alvo seguinte.

Durante a resolução, outras ações do turno ficam bloqueadas. A interface apenas apresenta os alvos retornados pelo estado e envia a carta escolhida ao controlador.

Vida e cura pertencem a `PlayerState`. Derrota, destruição, vitória e correção por inatividade permanecem coordenadas pelo controlador para compartilhar as mesmas consequências.

## Consequências

- Escolhas sequenciais podem atravessar frames sem perder o total de dano.
- Dano restante sem alvo é descartado em um único ponto da regra.
- Interface e futuros efeitos reutilizam a mesma derrota normal.
- Modificadores da Spec 007 poderão interceptar ou preparar estados antes dessas operações sem transferir autoridade para a UI.
