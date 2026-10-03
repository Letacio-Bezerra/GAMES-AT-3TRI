# grill-game-design

Skill de entrevista estruturada que transforma uma ideia de jogo em requisitos rastreáveis, escritos direto na documentação do projeto.

Funciona para jogos de qualquer gênero, formato ou plataforma. As perguntas são escritas em vocabulário neutro e cada sessão traz um bloco de calibragem que as traduz a partir dos quatro eixos estruturais definidos na primeira sessão.

## Instalação

### Claude Code

```bash
npx skills@latest add caiooliveira-tech/grill-me-game-design
```

Instalação a partir de pasta local, útil em ambientes sem acesso ao GitHub:

```bash
npx skills@latest add ./skills/grill-me-game-design --copy --yes
```

Alternativa manual: copie a pasta `grill-me-game-design` para `~/.claude/skills/` ou para `.claude/skills/` do projeto.

### Outros agentes

O formato segue o padrão aberto de Agent Skills, então a mesma pasta funciona em ferramentas que adotam o padrão. Copie para o diretório de skills do agente.

### Sem instalação

Cole o `SKILL.md`, o `references/formato-requisitos.md` e o arquivo da sessão desejada como primeira mensagem.

## Uso

```
/grill-me-game-design            escolhe a sessão
/grill-me-game-design s0         abre a fundação
/grill-me-game-design desafio    abre a sessão pelo escopo
/grill-me-game-design continuar  retoma de onde parou
```

A skill roda apenas pelo comando. O agente não a carrega sozinho a partir do assunto da conversa.

## Como funciona

A entrevista escreve enquanto acontece. A cada três ou quatro decisões fechadas, a skill grava o que foi decidido no artefato correspondente, registra termos novos no glossário e volta a perguntar. Decisões de comportamento viram requisitos; decisões conceituais ficam no contexto; decisões arquiteturais difíceis podem entrar em `technical-decisions.md`.

Sessões e ordem de dependência:

```
S0 Fundação
 ├── S1 Agência ──── S2 Desafio ──── S3 Estrutura
 ├── S4 Câmera e Interface
 └── S5 Arte e Áudio
```

A S0 é obrigatória. Ela não gera spec, gera o contexto que todas as specs referenciam, incluindo os quatro eixos estruturais que calibram as perguntas das sessões seguintes.

## Referências

A skill pede referência sempre que uma decisão envolve forma, sensação ou aparência, e só aceita quando o aluno indica o jogo ou obra, o elemento específico e o que pega dali. Referência visual precisa do elemento identificado, não basta a imagem.

Quando o grupo tem pouco repertório, a skill oferece três ou quatro possibilidades referenciadas para a decisão em questão, e pede que o aluno escolha e justifique. Ela não escolhe pelo aluno.

## Saída

```
docs/
├── context/
│   ├── game-overview.md
│   ├── gameplay-pillars.md
│   ├── glossary.md
│   ├── art-direction.md
│   ├── technical-decisions.md
│   └── implementation-roadmap.md
└── specs/
    ├── README.md
    └── <NNN>-<sistema>.md
```

Cada requisito tem identificador, prioridade, status, dependências, justificativa e critérios de aceitação no formato Dado, Quando, Então. Um valor que ainda depende de protótipo entra como `PROVISÓRIO`, sempre com valor inicial, pergunta do protótipo e teto de exploração.

## Estrutura

```
skills/grill-me-game-design/
├── SKILL.md
├── README.md
├── assets/
│   ├── spec-template.md
│   └── context-template.md
└── references/
    ├── formato-requisitos.md
    ├── mapa-de-arquivos.md
    ├── referencias.md
    ├── repertorio.md
    ├── s0-fundacao.md
    ├── s1-agencia.md
    ├── s2-desafio.md
    ├── s3-estrutura.md
    ├── s4-interface.md
    └── s5-arte-audio.md
```

## Licença e crédito

MIT. Copyright (c) 2026 Caio Oliveira.

Método adaptado das skills `grill-me` e `grill-with-docs` de Matt Pocock (github.com/mattpocock/skills), também sob MIT, para o domínio de desenvolvimento de jogos.

## Ciclos de desenvolvimento

O Grill não exige que todas as sessões S0–S5 sejam concluídas antes da implementação.

O projeto trabalha em quatro ciclos:

1. **Core** — S0 + partes essenciais de S1
2. **Fun** — S1 + S2
3. **Game** — S3 + S4
4. **Polish** — S5 + revisão

Cada ciclo segue: **Decidir → Especificar → Construir → Playtest → Aprender → Decidir novamente**.

Use `/grill-me-game-design` para conduzir as decisões e specs do ciclo atual.
Use `/grill-me-game-dev` para implementar o próximo incremento.
