# S1 — Agência do Jogador

O que o jogador pode fazer, quando pode fazer e o que acontece quando erra.

## Arquivos desta sessão

Cria ou atualiza a spec do controle do jogador em `docs/specs/`. Área de requisito: `AGE`.

Alimenta `docs/context/glossary.md` com os nomes dos verbos e dos estados.

## Contexto necessário

Leia `docs/context/game-overview.md`. Sem os quatro eixos estruturais, não comece.

## Escopo

Decidir: verbos disponíveis, disponibilidade de cada um, custo, consequência do erro e recuperação.

## Fora do escopo

Oponentes, estrutura de fases, aparência, som.

## Perguntas obrigatórias

1. Quais verbos o jogador tem, em ordem de frequência de uso
2. Em que momento cada verbo está disponível e o que o bloqueia
3. Qual o custo de cada ação: tempo, recurso, risco ou nenhum
4. Qual a decisão mais interessante que o jogador toma, e quais as opções dela
5. Como o jogador percebe que agiu, imediatamente após a ação
6. O que acontece quando o jogador erra, passo a passo
7. Depois do erro, o que é perdido e o que é mantido
8. Existe algum verbo que só aparece depois, e o que o destrava

## Referências

Peça referências para as perguntas 4, 5 e 6, que tratam de sensação e consequência. Ofereça possibilidades quando o aluno reproduzir a solução mais óbvia sem ter considerado alternativa.

Formato e validação em `referencias.md`. Expansão de repertório em `repertorio.md`.

## Calibragem

Traduza as perguntas a partir dos eixos registrados na S0, e use as palavras que o próprio aluno usa para descrever o jogo dele.

O eixo de controle define o que conta como verbo nesta sessão. Pode ser um comando sobre um avatar, uma ação sobre recursos, uma jogada dentro de um turno ou uma escolha entre opções apresentadas.

O eixo de ritmo define a unidade da pergunta 3. Em tempo real o custo costuma ser medido em tempo ou risco. Fora dele, em turnos, rodadas ou recursos gastos.

A pergunta 4 ganha peso quando o controle é por seleção de opções, porque nesse caso a decisão é o jogo inteiro.

O eixo de fim muda a pergunta 7. Quando o jogo é infinito, a pergunta vira o que persiste de uma tentativa para a próxima.

Se uma pergunta não fizer sentido para este jogo, registre como não aplicável e siga. Não force.

## Escrita

Cada verbo da pergunta 1 vira ao menos um requisito. As respostas da 2 viram critérios de aceitação do tipo negativo, descrevendo quando a ação não acontece.

A pergunta 6 costuma render uma sequência. Escreva um requisito por etapa da sequência, com dependência declarada entre eles.

## Provisórios

As perguntas 3 e 5 costumam gerar provisórios em jogos de tempo real.

Os três campos obrigatórios do status estão no SKILL.md. Não use provisório para adiar decisão que já pode fechar.

