# S3 — Estrutura e Progressão

Como o jogo é dividido, em que ordem as coisas acontecem e o que muda ao longo do tempo.

## Arquivos desta sessão

Cria ou atualiza a spec de estrutura e progressão em `docs/specs/`. Área de requisito: `EST`.

Alimenta `docs/context/implementation-roadmap.md` com a ordem de produção, e o glossário com os nomes das unidades.

## Contexto necessário

Leia `game-overview.md` e as specs da S1 e da S2.

## Escopo

Decidir: unidade de jogo, duração, ordem de introdução dos elementos, gating, repetição e ritmo.

## Fora do escopo

Valores de balanceamento, arte, som.

## Perguntas obrigatórias

1. Qual é a unidade de jogo e quanto tempo dura uma delas
2. Quantas unidades existem, ou o que muda quando o jogo é contínuo
3. Qual verbo ou combinação cada unidade ensina ou cobra
4. Como o jogador aprende o primeiro verbo sem texto explicativo
5. Qual a sequência de intensidade dentro de uma unidade
6. O que impede o jogador de avançar antes de dominar algo
7. O que acontece quando o jogador falha e precisa repetir
8. Qual unidade seria cortada primeiro se faltar tempo de produção

## Referências

Peça referências para as perguntas 4, 6 e 7. Ensino sem texto e gating são os pontos onde o repertório costuma faltar mais.

Formato e validação em `referencias.md`. Expansão de repertório em `repertorio.md`.

## Calibragem

Esta sessão é a mais dependente do eixo de unidade de jogo. Todas as perguntas usam a palavra que o aluno registrou na S0, seja ela fase, partida, corrida, capítulo ou outra.

O eixo de fim muda a pergunta 2. Quando o jogo tem fim definido, a resposta é uma contagem. Quando é infinito, a resposta é o que muda conforme o jogo avança, e a pergunta 5 vira a central da sessão.

O eixo de controle muda a pergunta 3. Onde o jogador tem poucos verbos, a resposta é qual verbo cada unidade cobra. Onde o volume de conteúdo é grande, a resposta é o que cada unidade revela ou libera.

Quando o jogo permite ao jogador escolher a ordem em que avança, a pergunta 6 vira a central, porque sem gating a estrutura desaparece.

## Escrita

A resposta da pergunta 8 define a prioridade de todos os requisitos desta spec. O que seria cortado primeiro sai como `PODERIA`. O que sustenta o escopo mínimo da S0 sai como `DEVE`.

A ordem de produção derivada das perguntas 2 e 8 vai para `implementation-roadmap.md`, não para a spec.

## Provisórios

As perguntas 1 e 5 costumam gerar provisórios, porque duração e ritmo só se medem jogando.

Os três campos obrigatórios do status estão no SKILL.md. Não use provisório para adiar decisão que já pode fechar.

