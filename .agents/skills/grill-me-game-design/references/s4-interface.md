# S4 — Câmera, Interface e Experiência

## Arquivos desta sessão

Cria ou atualiza a spec de interface em `docs/specs/`. Área de requisito: `INT`.

Alimenta o glossário com os nomes das telas e dos indicadores.

## Contexto necessário

Leia `game-overview.md` e as specs da S1 e da S2. A interface depende do que o jogador controla e do que pode perder.

## Escopo

Decidir: o que o jogador enxerga do mundo, telas existentes, fluxo entre elas, informação permanente, feedback de estado e acessibilidade básica.

## Fora do escopo

Paleta, tipografia e atmosfera visual, que ficam na S5. Aqui decide-se o que o jogador vê e quando, não com qual aparência.

Iluminação como estética também fica na S5. Se a luz servir para esconder ou revelar informação, ela é regra de jogo e entra aqui.

## Perguntas obrigatórias

1. Quais telas existem e como o jogador transita entre elas
2. Qual informação precisa estar visível o tempo todo durante o jogo
3. Qual informação pode ficar escondida até ser relevante
4. Como o jogador percebe uma mudança de estado importante sem procurar na tela
5. O que acontece quando o jogador interrompe o jogo
6. Qual a primeira coisa que o jogador vê ao abrir o jogo e o que ele faz em seguida
7. Como o jogo comunica que a unidade de jogo terminou, no sucesso e na falha
8. Existe alguma informação exibida que poderia ser cortada sem prejuízo

## Perguntas de câmera

Rode este bloco antes das perguntas de tela. O que a câmera mostra define o que a interface ainda precisa comunicar.

9. O que precisa estar sempre visível para o jogador agir sem ser surpreendido
10. Como a câmera se comporta quando o alvo se move: presa a ele, com atraso, por regiões, ou fixa
11. O que faz o enquadramento mudar e qual evento dispara essa mudança
12. Quanto do espaço à frente o jogador precisa ver para tomar a decisão a tempo
13. O que o jogo faz quando algo importante está fora do campo de visão

## Referências

Peça referências visuais para as perguntas 2, 4, 7, 10 e 13, sempre com o elemento identificado. Ofereça possibilidades vindas de fora dos jogos quando o grupo só souber copiar interfaces parecidas.

Formato e validação em `referencias.md`. Expansão de repertório em `repertorio.md`.

## Calibragem

Traduza as perguntas a partir dos eixos registrados na S0.

O eixo de ritmo define quanta informação cabe na tela. Em tempo real, a resposta da pergunta 2 precisa ser curta, porque o jogador não tem tempo de ler. Fora dele, a resposta pode ser generosa, e a pergunta 3 vira o que aparece ao selecionar ou consultar.

Quando o volume de informação do jogo é grande, a pergunta 3 vira a central da sessão, porque a solução passa a ser camadas de exibição em vez de escolha do que mostrar.

O eixo de unidade de jogo define a pergunta 7. O que é comunicado ao fim de uma unidade depende de o jogo ter fim definido ou continuar.

Se o jogo tiver espaços de informação que a lista de perguntas não cobre, acrescente uma pergunta sobre como o jogador enxerga cada um deles.

O bloco de câmera muda de forma conforme o controle. Sobre um avatar, trata de enquadramento e acompanhamento. Sobre recursos ou unidades, trata de quanto do espaço fica visível de uma vez e como o jogador navega o que não cabe na tela. Em seleção de opções, as perguntas 10 e 12 costumam não se aplicar; registre e siga.

O eixo de ritmo define a pergunta 12. Em tempo real, a antecipação é medida em espaço ou tempo à frente do alvo. Fora dele, vira quanta informação o jogador precisa ter à vista antes de decidir.

## Escrita

A pergunta 1 vira um requisito por transição, não um requisito por tela. Transições são o que se testa.

A pergunta 2 vira uma lista de indicadores, cada um com um requisito declarando o que ele mostra e quando atualiza.

As perguntas 9 a 13 viram requisitos de câmera com valores observáveis: quanto do espaço fica visível, com quanto atraso ela acompanha, o que dispara cada mudança de enquadramento. "A câmera segue o jogador" não fecha nada.

## Provisórios

As perguntas 2, 4, 7, 10 e 12 costumam gerar provisórios, porque leitura de tela e conforto de câmera só se validam em uso.

Os três campos obrigatórios do status estão no SKILL.md. Não use provisório para adiar decisão que já pode fechar.

