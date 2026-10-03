# S5 — Arte e Áudio

## Arquivos desta sessão

Escreve `docs/context/art-direction.md` com a direção visual.

Cria ou atualiza a spec do sistema de áudio em `docs/specs/`. Área de requisito: `ART`.

## Contexto necessário

Leia `game-overview.md`, `gameplay-pillars.md` e a spec da S4.

## Escopo

Decidir: direção visual, legibilidade, organização do áudio, momentos sonoros e divisão de produção.

## Fora do escopo

Layout de telas, já decidido na S4. Valores de gameplay.

## Perguntas obrigatórias

1. Qual referência visual concreta guia o projeto e o que dela será usado
2. Qual o formato e o tamanho base dos elementos visuais, e por quê
3. Quantas cores a paleta tem e o que cada uma comunica no jogo
4. Como o jogador distingue o que é interativo do que é decorativo
5. Quais sons existem e qual evento dispara cada um
6. Como o áudio está organizado em canais e o que passa por cada um
7. O que muda na música quando o estado do jogo muda
8. O que o grupo produz e o que vem de biblioteca pronta

## Referências

Esta sessão é a que mais depende de referência. Toda resposta das perguntas 1 a 4 precisa de referência visual com elemento identificado, registrada em `art-direction.md`.

Formato e validação em `referencias.md`. Expansão de repertório em `repertorio.md`.

## Calibragem

Traduza as perguntas a partir dos eixos registrados na S0.

O eixo de ritmo define o peso da pergunta 4. Quando a leitura acontece em movimento, distinguir o interativo do decorativo é a pergunta central da sessão. Quando o jogador tem tempo de observar, o peso migra para a pergunta 1, porque a consistência entre muitos elementos passa a ser o problema.

A pergunta 2 pergunta pelo formato dos elementos que o jogo realmente usa. Descubra quais são antes de perguntar, em vez de assumir um formato.

Se a paleta da pergunta 3 carregar significado mecânico, e não apenas estético, ela deixa de ser direção de arte e vira regra de jogo. Nesse caso escreva também como requisito na spec.

## Escrita

As perguntas 1 a 4 são direção, não requisito. Vão para `art-direction.md` em prosa, com a paleta em tabela.

Se a paleta carregar significado mecânico, a resposta da pergunta 3 também vira requisito na spec, porque aí ela é regra de jogo e precisa de critério de aceitação.

As perguntas 5 a 7 viram requisitos de áudio. Cada som é um requisito com o evento que o dispara declarado no critério de aceitação.

A pergunta 8 vira uma tabela no rodapé de `art-direction.md`, com responsável nomeado em cada item.

## Provisórios

A direção visual das perguntas 1 a 4 pode ser refinada depois do protótipo sem virar requisito. Só use `PROVISÓRIO` quando a decisão for uma regra implementável; caso contrário registre como hipótese de design em `art-direction.md`.

Os três campos obrigatórios do status estão no SKILL.md. Não use provisório para adiar decisão que já pode fechar.

