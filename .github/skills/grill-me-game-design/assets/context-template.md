# Modelos dos documentos de contexto

## game-overview.md

```markdown
# Visão Geral

## Pitch
Uma frase.

## Público
Quem é e o que essa pessoa não encontra hoje.

## Gênero e promessa
Gênero, e o que o jogador espera ao ouvir esse gênero.

## Eixos estruturais
| Eixo | Valor |
|---|---|
| Ritmo | |
| Unidade de jogo | |
| Controle | |
| Fim | |

## Loop principal
Sequência de ações repetidas, em uma frase com verbos.

## Vitória e derrota
Condições verificáveis. Em jogos infinitos, o que mede sucesso.

## Escopo mínimo
Lista do que precisa existir para a ideia estar provada.

## Fora do escopo
Lista do que foi excluído, com motivo.
```

## gameplay-pillars.md

```markdown
# Pilares

## <Pilar 1>
O que é, e o que quebra no jogo se ele for removido.
```

Máximo de três pilares. Se o grupo listar mais, force a escolha.

## glossary.md

```markdown
# Glossário

## <Termo>
Definição em uma ou duas frases. Onde aparece no jogo.
```

Um termo por conceito. Se o grupo usar duas palavras para a mesma coisa, escolha uma e registre a outra como sinônimo descartado.

## game-architecture.md

```markdown
# Arquitetura do Jogo

## Sistemas principais

| Sistema | Responsabilidade | Spec relacionada |
|---|---|---|
| <sistema> | <o que faz> | <NNN-nome.md> |

## Relações

- <Sistema A> depende de <Sistema B> porque <motivo>.
- <Sistema B> comunica <evento/dado> para <Sistema C>.

## Fora da arquitetura atual

- <sistema ou responsabilidade explicitamente adiado> — <motivo>
```

## technical-decisions.md

```markdown
# Decisões

## <NNN> — <Título>

**Data:**
**Contexto:** o que motivou a decisão.
**Decisão:** o que foi escolhido.
**Alternativas:** o que foi considerado e por que não foi escolhido.
**Consequências:** o que fica mais fácil e o que fica mais difícil por causa disso.
```

Só entra aqui decisão que custa caro reverter, tinha alternativa razoável e geraria pergunta de alguém de fora.
