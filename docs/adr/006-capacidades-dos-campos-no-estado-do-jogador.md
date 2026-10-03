# ADR 006 — Capacidades dos campos no estado do jogador

- **Status:** Aceita
- **Data:** 2026-10-02

## Contexto

Os limites de descanso e ataque afetam controlador, interface e, futuramente, a movimentação automática da Spec 006. Consultas separadas ou números literais poderiam permitir que um sistema exibisse espaço enquanto outro recusasse a mesma ação.

## Decisão

`PlayerState` mantém as capacidades constantes de três cartas no descanso e cinco no ataque e expõe `has_rest_space()` e `has_attack_space()`. O controlador usa essas consultas para validar transições, e a interface usa as mesmas capacidades para exibir ocupação e habilitar controles.

O momento de entrada continua registrado na própria carta por `entered_rest_turn`; o controlador é responsável por impedir avanço no mesmo turno e por executar a transição atômica entre as duas coleções.

## Consequências

- Regra e apresentação compartilham uma única definição de capacidade.
- Tentativas recusadas deixam carta e energia inalteradas.
- A movimentação automática futura poderá consultar os mesmos limites.
- Não existe API para retornar voluntariamente uma carta do ataque ao descanso.
