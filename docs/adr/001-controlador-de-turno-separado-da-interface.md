# ADR 001 — Separar o controlador de turno da interface

- **Status:** Aceita
- **Data:** 2026-09-23

## Contexto

A Spec 001 define regras de sequenciamento que precisam ser verificadas sem depender de cliques, animações ou da apresentação final das cartas. Specs futuras conectarão energia, campos, combate e efeitos ao mesmo fluxo.

## Decisão

Manter o estado e as transições em `TurnController`, com objetos `PlayerState` e `CardState`. A cena principal observa sinais e envia comandos, mas não altera coleções ou energia diretamente.

O controlador expõe `attack_resolved` como porta de integração. Nesta unidade ele calcula apenas o total ofensivo e encerra o turno; a futura implementação da Spec 006 resolverá alvos e dano antes da troca de jogador.

A interface reage a mudanças do controlador de forma adiada e agrupa múltiplos sinais no mesmo frame. Elementos dinâmicos são removidos da árvore e liberados com `queue_free()`, evitando destruir o controle que ainda está emitindo um clique.

## Consequências

- Regras podem ser testadas em modo headless.
- A interface pode evoluir sem duplicar validações.
- Existe uma latência visual de no máximo um frame entre a alteração do estado e a reconstrução dos controles.
- A integração do combate precisará transformar a resolução atualmente imediata em uma etapa aguardável quando houver escolha de alvos.
