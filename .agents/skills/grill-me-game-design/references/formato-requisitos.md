# Formato de Requisitos

Toda decisão de comportamento implementável fechada em uma sessão de grill vira um requisito escrito neste formato. Decisões conceituais ou arquiteturais são registradas nos documentos de contexto correspondentes.

## Identificador

`RF-<AREA>-<NNN>` para requisitos funcionais, `RNF-<AREA>-<NNN>` para não funcionais.

Áreas por sessão:

| Sessão | Área | Exemplo |
|---|---|---|
| S0 | FUN | RF-FUN-001 |
| S1 | AGE | RF-AGE-001 |
| S2 | DES | RF-DES-001 |
| S3 | EST | RF-EST-001 |
| S4 | INT | RF-INT-001 |
| S5 | ART | RF-ART-001 |

A numeração é sequencial dentro da área e nunca é reaproveitada. Requisito removido vira status `CANCELADO` e mantém o número.

## Prioridade

- `DEVE` — sem isso o jogo não existe, entra na versão mínima
- `DEVERIA` — melhora o jogo de forma relevante, entra se houver tempo
- `PODERIA` — desejável, primeiro item a ser cortado
- `NÃO AGORA` — decidido explicitamente que fica fora desta entrega

Todo requisito com prioridade `DEVE` precisa caber no escopo mínimo definido na S0. Se o aluno marcar tudo como `DEVE`, questione.

## Status

- `CONFIRMADO` — decidido em conversa, pronto para implementar
- `PROVISÓRIO` — hipótese testável com valor inicial concreto, pergunta do protótipo e teto ou limite de exploração definidos
- `BLOQUEADO` — depende de outro requisito ainda em aberto
- `CANCELADO` — foi decidido e depois descartado, mantido para histórico

## Estrutura de cada requisito

```markdown
### RF-AGE-003 — Salto do jogador

**Prioridade:** DEVE
**Status:** PROVISÓRIO
**Depende de:** RF-AGE-001

O jogador pode saltar quando estiver em contato com o chão, alcançando
altura suficiente para atravessar um vão de duas unidades.

**Critérios de aceitação**

- Dado que o jogador está em contato com o chão, quando o comando de salto
  é acionado, então o jogador atinge no mínimo 2 unidades de altura.
- Dado que o jogador está no ar, quando o comando de salto é acionado,
  então nada acontece.

**Origem:** o grupo escolheu salto de altura fixa porque o desafio principal
está no ritmo, não na precisão do controle.

**Hipótese de protótipo**
- **Valor inicial:** 2 unidades de altura
- **Pergunta do protótipo:** 2 unidades permitem atravessar os vãos sem tornar o salto trivial?
- **Teto ou limite de exploração:** até 3 unidades nesta rodada
```

## Regras de escrita

**Um requisito, uma capacidade.** Se a frase tem "e" ligando duas capacidades diferentes, são dois requisitos.

**Descreva o que o jogo faz, não como implementar.** "O jogador perde uma vida ao encostar em um obstáculo" é requisito. "Usar um detector de colisão que emite um sinal" é implementação e não entra aqui.

**Todo critério de aceitação precisa ser verificável por observação.** Se ninguém consegue olhar o jogo rodando e dizer se passou ou não, o critério está mal escrito.

**Valores explícitos.** "Rápido", "muitos" e "difícil" não entram em critério de aceitação. Se o valor depender de protótipo, use `PROVISÓRIO` com os três campos da hipótese.

## Requisitos não funcionais

Use `RNF` para restrições que não são capacidades do jogo: desempenho, plataforma alvo, tempo de carregamento, acessibilidade, resolução mínima. Eles seguem o mesmo formato, mas o critério de aceitação costuma ser um limite numérico.

## Seções da spec

Além dos requisitos, toda spec tem quatro seções fixas. `Fora do escopo` vem antes dos requisitos, as outras três no rodapé.

```markdown
## Fora do escopo

- <comportamento ou sistema excluído> — <motivo>

## Alternativas descartadas

- Salto de altura variável por tempo de pressão. Descartado porque o grupo
  quer que o desafio venha do ritmo e não da precisão do comando.

## Perguntas em aberto

- Quantas unidades de altura o vão máximo terá. Depende do teste de protótipo.

## Não aplicável a este jogo

- Tempo até derrotar um oponente. O jogo não tem combate.
```

`Fora do escopo` existe para impedir que a implementação extrapole o que foi decidido na entrevista.
