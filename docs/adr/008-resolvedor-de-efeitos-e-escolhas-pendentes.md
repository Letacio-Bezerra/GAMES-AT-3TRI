# ADR 008 — Resolvedor de efeitos e escolhas pendentes

- **Status:** Aceita
- **Data:** 2026-10-03

## Contexto

A Spec 007 acrescenta 30 lados de efeito com alvos, durações, modificadores, proteções e escolhas encadeadas. Colocar essas regras diretamente na interface duplicaria validação e permitiria que animações ou botões alterassem o estado da partida. Concentrá-las no controlador também aumentaria muito uma classe que já coordena turno e combate.

## Decisão

Um `CardEffectResolver` separado mantém o estado transitório dos efeitos: modificadores, restrições, vínculos, expirações e escolhas pendentes. Ele valida alvos obrigatórios antes do pagamento e solicita ao `TurnController` as operações autoritativas de dano, destruição, cura, cemitério e avanço do turno.

O controlador possui a fase `RESOLVING_EFFECT`. A interface apenas apresenta as opções do estado pendente e devolve a seleção. Continuações permitem reutilizar o fluxo para uma escolha, várias escolhas e etapas consecutivas.

O resolvedor conserva uma referência fraca ao controlador. Modificadores temporários registram também sua especial de origem para que substituição ou expiração encerrem efeitos dependentes da permanência.

## Consequências

- Pagamento e movimentação de cartas continuam transacionais.
- Combate e efeitos usam o mesmo caminho de dano, sobrevivência e derrota.
- Novas cartas podem reutilizar os mecanismos de escolha e duração sem adicionar telas exclusivas.
- O resolvedor precisa receber ganchos de início e fim de turno e ser avisado quando uma carta deixa o campo.
- A interface permanece bloqueada durante escolhas obrigatórias, evitando a troca de turno com efeito incompleto.
