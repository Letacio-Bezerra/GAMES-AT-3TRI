# S2 — Desafio e Balanceamento

O que se opõe ao jogador e como a dificuldade é calibrada.

## Arquivos desta sessão

Cria ou atualiza a spec do sistema de desafio em `docs/specs/`. Área de requisito: `DES`.

Alimenta `docs/context/glossary.md` com os nomes dos tipos de oposição.

## Contexto necessário

Leia `docs/context/game-overview.md` e a spec da S1. O balanceamento depende dos verbos e dos custos já definidos.

## Escopo

Decidir: fontes de desafio, valores de dificuldade, aviso prévio, feedback e curva.

## Fora do escopo

Onde o desafio aparece na estrutura do jogo, aparência, som.

## Perguntas obrigatórias

1. O que se opõe ao jogador, e cada oposição é um oponente, uma escassez, o tempo ou a própria complexidade
2. Quais tipos de oposição existem e qual pergunta cada um faz ao jogador
3. Quanto esforço custa superar cada tipo, medido em número concreto
4. Qual o recurso mais escasso do jogador e o que o repõe
5. Como o jogador percebe uma ameaça antes de sofrer a consequência
6. Qual o feedback imediato no sucesso e na falha
7. Qual oposição aparece primeiro e por que ela é a mais fácil
8. O que fica mais difícil ao longo do jogo: os valores, a combinação ou o ritmo

## Referências

Peça referências para as perguntas 2, 5 e 6. Se o grupo só conseguir descrever oposição como oponente que causa dano, ofereça possibilidades de escassez, tempo e complexidade.

Formato e validação em `referencias.md`. Expansão de repertório em `repertorio.md`.

## Calibragem

Traduza as perguntas a partir dos eixos registrados na S0.

O eixo de ritmo define como medir a pergunta 3. Em tempo real, em unidades de tempo ou número de acertos. Por turnos, em número de turnos. Quando a oposição é a própria complexidade, em número de passos até a solução.

O mesmo eixo muda a pergunta 5. Em tempo real, o aviso é perceptivo e acontece durante a ação. Fora dele, o aviso é informacional e acontece antes de decidir.

O eixo de fim muda o peso da pergunta 8. Quando o jogo é infinito, a curva é o jogo inteiro e essa vira a pergunta central da sessão.

Se o jogo não tiver oposição mecânica de nenhum dos quatro tipos da pergunta 1, registre como não aplicável e concentre a sessão nas perguntas 4, 5 e 8.

## Escrita

Os valores da pergunta 3 são o coração desta spec. Cada tipo de oposição vira um requisito com número explícito no critério de aceitação.

A pergunta 8 vira requisito de curva, com os valores de cada estágio declarados em tabela dentro do requisito.

## Provisórios

As perguntas 3, 5 e 6 costumam gerar provisórios, porque esforço e antecedência só se validam jogando.

Os três campos obrigatórios do status estão no SKILL.md. Não use provisório para adiar decisão que já pode fechar.

