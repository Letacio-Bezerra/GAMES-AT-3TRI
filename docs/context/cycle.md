# Estado do Ciclo

- **Ciclo atual:** Ciclo 2 — Diversão
- **Objetivo:** validar se o núcleo produz estratégia e adaptação, começando por tornar o estado completo da partida legível em um tabuleiro visual.
- **Specs selecionadas:** `008-layout-do-tabuleiro.md`.
- **Status:** EM VALIDAÇÃO
- **Evidências de playtest:** os testes e relatos do Ciclo 1 mostraram textos e botões espremidos, barra inferior cortada e dificuldade para perceber a mesa como um duelo. A solução em quatro colunas corrigiu os cortes, mas ainda apresentava cartas como listas. Em 2026-10-03, a interface foi reconstruída como mesa espelhada. A regressão automatizada confirmou os 22 espaços, campos lotados em 1600×900, rolagem independente da mão, privacidade adversária, detalhes completos, ações contextuais e seleção de alvos. Uma captura com ocupação 5/3/3 dos dois lados confirmou visualmente a hierarquia. Falta playtest manual para validar conforto de leitura e descoberta das ações.
- **Motivo para avanço:** o Ciclo 1 foi concluído com uma partida funcional e as 15 cartas implementadas. Antes de avaliar profundamente a qualidade das escolhas, o grupo precisa conseguir ler cartas, atributos, efeitos e relações entre os campos durante uma partida completa.

## Lacunas bloqueantes para implementação

- Nenhuma para implementação. O ciclo aguarda somente validação manual das duas hipóteses provisórias.

## Sugestão de divisão do trabalho

- **Game Designer / PO:** conduzir o teste de legibilidade em 1600×900 e registrar se os jogadores identificam zonas, atributos, efeitos e ações sem explicação adicional. Dependência: layout funcional. Esforço: baixo.
- **Gameplay Programmer:** garantir que a interface continue recebendo os estados atuais de turno, campos, efeitos e combate sem alterar regras. Dependência: controladores existentes. Esforço: baixo.
- **UI Programmer:** construir a mesa espelhada, os cartões, o painel de detalhes, as ações contextuais e a navegação da mão. Dependência: Spec 008. Esforço: alto.
- **Artist / Animator:** definir cores e sinais provisórios para categorias, orientação, seleção, alvo e estados bloqueados. Dependência: estrutura dos cartões. Esforço: baixo.
- **Level Designer:** montar estados extremos de ocupação 5/3/3 nos dois lados para validar o layout. Dependência: mesa funcional. Esforço: baixo.
- **Marketing / Communication:** registrar uma captura comparativa entre o layout em colunas e o novo tabuleiro. Dependência: protótipo visual. Esforço: baixo.

Estimativa sugerida: uma a duas aulas para prototipagem e validação, ajustável pelo Game Designer / PO.

## Fora do escopo do ciclo

- Arte final, animações e áudio.
- Redesenho do turno zero.
- Efeitos de terreno.
- Partidas com mais de dois jogadores.
- Interface para celular.
