# ADR 005 — Estado do jogador como autoridade da energia

- **Status:** Aceita
- **Data:** 2026-10-02

## Contexto

Energia já era armazenada em `PlayerState`, mas o controlador alterava o inteiro diretamente em vários pontos. A Spec 004 adiciona uma garantia global de piso zero e prepara efeitos capazes de conceder ou remover energia. Espalhar operações aritméticas tornaria fácil esquecer o limite inferior ou cobrar uma ação antes de validar todas as suas condições.

## Decisão

`PlayerState` mantém o saldo e oferece `gain_energy`, `can_pay_energy`, `spend_energy` e `lose_energy`. A propriedade também protege o limite inferior contra atribuições diretas. Não existe limite superior.

`TurnController` continua responsável pela ordem das regras: concede recursos no início do turno, valida uma ação antes de pagar seu custo e expõe operações registradas para efeitos futuros alterarem o saldo de qualquer jogador.

## Consequências

- Toda perda termina em zero ou mais, independentemente da origem.
- Ações recusadas preservam integralmente o saldo.
- Novos efeitos de energia não precisam repetir regras de acúmulo ou limite inferior.
- O estado continua simples e local a cada jogador, sem um gerenciador global adicional.
