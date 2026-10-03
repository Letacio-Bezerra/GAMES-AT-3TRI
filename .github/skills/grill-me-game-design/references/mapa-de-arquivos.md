# Mapa de Arquivos

Estrutura de documentação que a skill lê e escreve.

```
docs/
├── context/
│   ├── game-overview.md        visão geral, gênero, público, eixos estruturais
│   ├── gameplay-pillars.md     pilares que definem a experiência
│   ├── glossary.md             termos, siglas e conceitos do projeto
│   ├── art-direction.md        direção visual, referências, paleta, atmosfera
│   ├── game-architecture.md    sistemas principais e como se conectam
│   ├── technical-decisions.md  decisões difíceis e suas justificativas
│   ├── implementation-roadmap.md
│   ├── progress-tracker.md
│   └── learning-journal.md
└── specs/
    ├── README.md               índice das specs e padrão de documentação
    ├── 001-<sistema>.md
    ├── 002-<sistema>.md
    └── ...
```

## O que cada sessão escreve

| Sessão | Escreve em context | Escreve em specs |
|---|---|---|
| S0 | `game-overview.md`, `gameplay-pillars.md`, `glossary.md` | nenhuma |
| S1 | `glossary.md` | spec do controle do jogador |
| S2 | `glossary.md` | spec do sistema de desafio |
| S3 | `glossary.md`, `implementation-roadmap.md` | spec da estrutura e progressão |
| S4 | `glossary.md` | spec da interface |
| S5 | `art-direction.md`, `glossary.md` | spec do sistema de áudio |
| Consolidação | `game-architecture.md` | nenhuma; documento de síntese das specs existentes |

A S0 não gera spec. Ela produz o contexto que todas as specs referenciam.

Toda sessão pode escrever em `technical-decisions.md`, quando a decisão atender às três condições descritas no SKILL.md.

## Nomeação das specs

Prefixo numérico de três dígitos na ordem de criação, seguido do nome do sistema em minúsculas com hífen. Exemplos: `001-controle-jogador.md`, `002-sistema-de-desafio.md`, `003-progressao.md`.

O número nunca é reaproveitado. Se uma spec for abandonada, mantenha o arquivo com aviso no topo.

Se o aluno rodar uma sessão que gera uma spec já existente, não crie um arquivo novo. Abra o existente e acrescente ou revise requisitos, mantendo os identificadores antigos.

## Quando os arquivos não existem

Se o repositório ainda não tem essa estrutura, crie apenas o que a sessão atual precisa. Não crie arquivos vazios de sessões que ainda não rodaram.

Comece sempre por `docs/specs/README.md`, que serve de índice, e mantenha esse índice atualizado a cada spec nova.

## Consolidação de arquitetura

`game-architecture.md` não pertence a uma sessão isolada. Ele é atualizado conforme as specs amadurecem, registrando os sistemas principais e as relações entre eles. Quando houver material suficiente após as sessões, a skill pode consolidá-lo ou revisá-lo.

Não transforme o documento em uma descrição de implementação. A arquitetura deve permanecer no nível de responsabilidades e conexões entre sistemas.

## Antes de escrever

Leia `docs/context/glossary.md` e `docs/context/game-overview.md` se existirem. Use o vocabulário que já está lá em vez de inventar termos novos. Se o aluno usar uma palavra diferente para um conceito já registrado, aponte a diferença e pergunte qual termo fica.
