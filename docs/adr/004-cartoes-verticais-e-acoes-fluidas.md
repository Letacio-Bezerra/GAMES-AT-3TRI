# ADR 004 — Cartões verticais e ações fluidas

- **Status:** Aceita
- **Data:** 2026-10-02

## Contexto

As quatro colunas da partida dividem a largura da janela. Quando o resumo e todos os controles de uma carta ocupavam o mesmo contêiner horizontal, os botões comprimiam o texto até uma palavra por linha. Controles mais largos, como a substituição de especiais, e a barra de fim de turno podiam ultrapassar a área visível.

## Decisão

Cada carta é apresentada em um painel vertical com o resumo na primeira linha e um `HFlowContainer` exclusivo para suas ações. A barra de ações globais usa o mesmo comportamento fluido. As quatro zonas mantêm rolagem vertical independente, e o histórico recebe uma altura reservada em vez de disputar expansão vertical com o tabuleiro.

A janela-base do protótipo passa a 1600×900. O rótulo da retirada voluntária de carta comum explicita **Fundo do baralho**, preservando a distinção de domínio entre esse destino e o cemitério de especiais.

Cartas especiais exibem também a permanência do efeito. O texto de uma especial imediata avisa que ela segue para o cemitério depois da resolução, e o cemitério lista as identidades das cartas em vez de mostrar apenas uma contagem.

## Consequências

- O texto das cartas deixa de competir horizontalmente com seus controles.
- Botões podem quebrar para uma linha adicional quando necessário sem ampliar a coluna.
- Mãos e campos extensos continuam acessíveis por rolagem.
- A substituição deixa visível a diferença entre uma nova especial ativa e uma nova especial que já resolveu.
- O protótipo exige uma área-base maior, mas continua redimensionável pelo sistema de janelas.
