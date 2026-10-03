# Learning Journal

## 2026-09-23 — Spec 001: Fluxo do Turno

### O que foi implementado

- Um controlador de domínio separado da interface, capaz de alternar dois jogadores e contar rodadas.
- Compra e energia automáticas no início do turno a partir da segunda rodada.
- Ações repetíveis de jogar, avançar e descartar cartas durante a preparação.
- Encerramento voluntário e encerramento obrigatório depois de um ataque.

### Decisões e aprendizados

- `round_number` representa uma passagem completa pelos dois jogadores; `turn_serial` identifica cada turno individual e permite verificar se uma carta já permaneceu no descanso pelo tempo exigido.
- A interface não contém regras: ela solicita ações ao controlador e reage aos sinais. Isso permitirá trocar o protótipo visual sem reescrever o fluxo.
- O ponto de integração `attack_resolved` encerra o turno e entrega o ataque total, deixando alvos e dano para a Spec 006.

### Playtest

- **Testado automaticamente:** primeira e segunda rodadas, compra completa e parcial, acúmulo de energia, colocações repetidas, limite do descanso, descarte ao fundo, mão sem limite, alternância iniciada por qualquer jogador, atraso no descanso e ataque encerrando o turno.
- **Resultado:** todos os testes passaram em Godot 4.6.2; a cena principal também carregou em modo headless sem erros.
- **Problemas observados:** a primeira execução revelou dependência implícita do cache de classes globais do editor; os scripts passaram a declarar `preload` das dependências e agora funcionam também em execução limpa/headless.
- **Avaliações positivas:** a separação entre regras e interface tornou os critérios diretamente testáveis.
- **Ideias:** exibir a pilha e animações de compra somente após validar o fluxo básico.

### Pendências

- Realizar um playtest manual da interface e registrar clareza, ritmo e eventuais problemas de interação.

## 2026-09-30 — Correção do playtest da Spec 001

### Evidências recebidas

- O jogo fechava ao jogar a carta 1 ou 2.
- O jogo fechava ao avançar uma carta em um turno posterior.
- Com muitas cartas, o conteúdo ultrapassava a janela e não havia como acessar as informações abaixo.

### Diagnóstico

- Tanto **Jogar** quanto **Avançar** alteravam o estado com sucesso e emitiam `state_changed` durante o sinal `pressed`.
- A atualização sincronizada reconstruía a interface com `free()`, destruindo o botão que ainda processava o próprio clique. As ações recusadas não fechavam porque não emitiam a reconstrução.
- As listas de cartas estavam diretamente nos painéis e, por isso, seu tamanho mínimo expandia o layout para fora da janela.

### Correção

- Atualizações visuais agora são agrupadas e executadas de forma adiada no fim do frame.
- Nós antigos são removidos da árvore e liberados com `queue_free()`.
- Os callbacks dos botões agora são métodos nomeados com a carta vinculada, evitando capturas ambíguas do laço.
- Mão, descanso, ataque e resumo do adversário receberam `ScrollContainer` com rolagem vertical independente.

### Validação

- A suíte de regras anterior continuou passando.
- O novo teste de regressão clicou em **Jogar**, encerrou os dois turnos, clicou em **Avançar** e confirmou a mudança de estado sem encerramento da cena.
- O teste adicionou 24 cartas à mão e confirmou que a barra de rolagem vertical ficou visível.

### Pendência

- Confirmar visualmente no próximo playtest que a velocidade da rolagem e a distribuição das quatro áreas estão confortáveis.

## 2026-09-30 — Spec 002: Turno Zero

### O que foi implementado

- Atribuição aleatória das orientações reta e invertida aos dois jogadores antes das revelações.
- Revelação manual e alternada de duas cartas por jogador, começando pelo jogador associado às retas.
- Quinta revelação proveniente de um baralho externo separado.
- Contagem das orientações e escolha do jogador associado à maioria.
- Retorno de cada carta ao baralho de origem, novo embaralhamento e transição para a partida com mãos e energias iniciais.

### Decisões e aprendizados

- A preparação ficou em um `MatchSetupController` separado do `TurnController`: o primeiro possui as cartas antes da partida e só entrega os baralhos depois de concluir todos os critérios da leitura.
- A fonte de aleatoriedade pode ser injetada. O jogo usa `RandomNumberGenerator`, enquanto os testes fornecem sequências conhecidas para verificar resultados retos e invertidos sem depender de sorte.
- A quinta carta é suficiente para impedir empate; portanto, o controlador não precisa de regra adicional de desempate.
- A interface mantém o resultado visível e exige confirmação antes de devolver as cartas, para que o jogador consiga entender por que alguém começa.

### Validação

- Todos os requisitos RF-EST-001 a RF-EST-008 passaram em teste automatizado no Godot 4.6.2.
- As suítes do fluxo de turno e da interface continuaram passando.
- A interface automatizada percorreu as cinco revelações, iniciou a partida e confirmou três cartas por jogador e duas energias para o primeiro.

### Playtest

- **Testado automaticamente:** sequência completa do turno zero e sua integração com a partida.
- **Problemas observados:** nenhum erro de parser, execução ou regressão.
- **Avaliação positiva:** a apresentação passo a passo torna a ordem das revelações verificável.
- **Pendente:** avaliar manualmente se o ritmo de seis cliques e os textos comunicam a leitura com clareza.

## 2026-10-02 — Spec 003: Baralho de Cartas

### O que foi implementado

- Catálogo real das 15 cartas: cinco suportes, cinco ataques e cinco especiais, com custos e valores base da Spec 003.
- Dois baralhos com as mesmas identidades, mas instâncias independentes.
- Sorteio de orientação a cada compra, visibilidade privada na mão e revelação pública ao jogar.
- Renovação completa de cartas comuns ao retornar ao fundo do baralho.
- Três espaços especiais, uma especial por turno, substituição, cemitério e ciclos imediato, temporário, contínuo ou decidido pelo resolvedor.
- Ganchos de efeito no descanso e no ataque, preparados para a Spec 007.

### Decisões e aprendizados

- Identidade e valores base permanecem estáveis, enquanto orientação, dano, modificadores e marcas pertencem à instância em partida.
- A orientação é sorteada em `PlayerState.draw_cards`; assim, mãos iniciais, compras automáticas e compras futuras seguem a mesma regra.
- Efeitos individuais não foram colocados no controlador de turnos. Ele apenas emite o momento correto de ativação e mantém o ciclo de vida das especiais, evitando acoplamento com a futura resolução da Spec 007.
- Uma especial imediata ocupa o espaço durante o sinal síncrono de resolução e vai ao cemitério logo depois; uma temporária exige expiração explícita do motor de efeitos.

### Validação

- O catálogo foi verificado quanto a quantidade, unicidade, categorias, custos e valores base.
- Orientação privada, novo sorteio e renovação foram testados.
- Entrada no descanso e no ataque solicitaram os efeitos corretos.
- Três especiais acumularam efeitos; quarta sem substituição foi recusada; substituição e cemitério foram validados.
- Limite de uma especial por turno, resolução imediata e expiração temporária passaram nos testes.
- Todas as suítes anteriores continuaram passando no Godot 4.6.2.

### Playtest

- **Testado automaticamente:** estrutura completa da Spec 003 e integração com turno zero e fluxo de turno.
- **Problemas observados:** a primeira validação encontrou que a nova especial era anexada no fim, em vez de ocupar o índice substituído; o controlador foi corrigido para preservar o espaço escolhido.
- **Avaliação positiva:** o catálogo real pode substituir as cartas neutras sem alterar os controladores anteriores.
- **Pendente:** observar manualmente legibilidade das orientações e conforto dos controles de substituição.

## 2026-10-02 — Correção visual da Spec 003

### Evidências recebidas

- As informações das cartas quebravam em muitas linhas porque disputavam a mesma largura com os botões.
- Os controles de substituição de especiais e as ações de fim de turno apareciam cortados.
- O termo **Descartar** sugeria que uma carta comum deveria entrar no cemitério, contrariando as regras confirmadas.

### Correção e aprendizado

- A janela-base aumentou de 1152×648 para 1600×900.
- Cada carta passou a ser um bloco vertical: informações acima e controles em uma linha fluida abaixo. Assim, o texto não compete horizontalmente com **Avançar**, **Substituir** ou outros botões.
- A barra de ações também usa distribuição fluida, e o histórico possui altura fixa para não expulsar os controles da janela.
- O botão de descarte comum agora diz **Fundo do baralho (1)**. Conforme RF-AGE-004 e RF-AGE-024, ataque e suporte voltam ao fundo; somente especiais resolvidas ou substituídas entram no cemitério.

### Validação

- As quatro suítes passaram no Godot 4.6.2.
- A regressão visual confirma viewport de 1600×900, largura e altura mínimas dentro da janela, ações em linha separada e rolagem vertical para uma mão extensa.
- A regressão de regras confirma que o descarte comum aumenta o baralho e não altera o cemitério.

### Pendência

- Confirmar em playtest manual a legibilidade e o conforto da nova distribuição na resolução usada pelo grupo.

## 2026-10-02 — Feedback da substituição de especiais

### Evidência recebida

- Ao substituir uma especial, a antiga seguia para o cemitério, mas a nova não parecia ocupar o espaço.

### Diagnóstico e correção

- O controlador já inseria especiais temporárias e contínuas no mesmo índice liberado.
- Especiais imediatas, como A Morte reta ou A Lua invertida, não permanecem ativas pela RF-AGE-020: elas resolvem e seguem também para o cemitério.
- A interface ocultava essa diferença porque mostrava somente a quantidade no cemitério. Agora cada especial informa seu tipo de permanência; efeitos imediatos avisam explicitamente seu destino, e o cemitério lista os nomes das cartas.

### Validação

- Uma substituição por A Lua reta confirmou que a nova carta temporária ocupa exatamente o espaço escolhido e a antiga aparece no cemitério.
- Uma substituição por A Morte reta confirmou o aviso de efeito imediato, sua saída da área ativa e sua exibição nominal no cemitério.

## 2026-10-02 — Spec 004: Sistema de Energia

### O que foi implementado

- Saldo de energia protegido no estado de cada jogador, sempre com limite inferior zero.
- Operações únicas para ganhar, verificar, pagar e perder energia.
- Ganho automático de duas energias no início do turno a partir da segunda rodada.
- Acúmulo sem teto e preservação do saldo entre turnos.
- Pontos de integração no controlador para efeitos futuros concederem ou removerem energia com registro no histórico.

### Decisões e aprendizados

- `PlayerState` é a autoridade do saldo e protege seu invariante; `TurnController` decide quando a mudança ocorre. Isso impede que cartas, descartes e efeitos implementem regras de saldo diferentes.
- Pagamentos acontecem somente depois que todas as outras condições da ação foram validadas. Portanto, campo cheio, carta inválida ou energia insuficiente não produzem gasto parcial.
- Uma perda informa quanto foi realmente removido. Por exemplo, pedir a perda de quatro com saldo dois remove somente dois e termina em zero.

### Validação

- `test_energy_system.gd` cobriu RF-AGE-012, RF-AGE-013 e RF-AGE-031, além da assimetria inicial de RF-EST-008.
- Saldos de 1000 e 2000 foram usados para confirmar que não existe teto implícito.
- Custos de carta e descarte foram exercitados com saldo suficiente e insuficiente.
- As quatro suítes anteriores continuaram passando no Godot 4.6.2.

### Playtest

- **Testado automaticamente:** entrada, permanência, pagamento e perda de energia.
- **Avaliação positiva:** o saldo exibido pela interface continua sendo atualizado pelo mesmo `state_changed` das demais ações.
- **Pendente:** observar manualmente se +2 por turno permite economizar para especiais sem tornar os primeiros turnos lentos.

## 2026-10-02 — Spec 005: Campos de Jogo

### O que foi implementado

- Consultas centralizadas de espaço livre para descanso e ataque.
- Limite de três cartas no descanso e cinco no ataque aplicado pelo mesmo estado consultado pela interface.
- Colocação transacional de ataques e suportes no descanso, com cobrança somente depois de validar espaço, categoria e energia.
- Avanço gratuito somente em turno posterior, preservando a ordem de entrada no ataque.
- Cabeçalhos dinâmicos com ocupação atual e botão **Avançar** desabilitado quando o ataque está cheio.

### Decisões e aprendizados

- As capacidades permanecem constantes de `PlayerState`, e os demais sistemas perguntam `has_rest_space()` ou `has_attack_space()`. Isso evita divergência entre regra, interface e futuros movimentos automáticos.
- `turn_serial` continua sendo o marcador de entrada no descanso. Como apenas o jogador ativo movimenta suas cartas, exigir um serial posterior garante na prática que ela aguardou até o próximo turno do dono.
- Não foi criada uma operação inversa: a ausência de retorno ao descanso continua uma regra estrutural, não apenas uma restrição visual.

### Validação

- O descanso aceitou exatamente três cartas e recusou a quarta sem gastar energia.
- Três cartas preparadas avançaram gratuitamente no turno seguinte do dono.
- O ataque aceitou cinco cartas e recusou a sexta, preservando-a no descanso.
- A interface atualizou os contadores para `Descanso — 1/3 espaços` e `Ataque — 1/5 espaços` durante a regressão jogável.

### Playtest

- **Testado automaticamente:** percurso completo da carta comum e situações-limite dos dois campos.
- **Avaliação positiva:** a ocupação visível elimina a necessidade de contar manualmente os cartões.
- **Pendente:** observar se os limites realmente incentivam o avanço e se cinco cartas no ataque continuam legíveis na janela.

## 2026-10-02 — Spec 006: Sistema de Combate

### O que foi implementado

- Vida atual e máxima de 50 para cada jogador, com dano, cura limitada e derrota.
- Ataque conjunto de todas as cartas ofensivas e uma fase pendente para distribuir dano por escolhas sucessivas.
- Persistência de dano nas cartas sobreviventes sem perda de Ataque.
- Derrota e destruição com dano ao dono baseado na Vida impressa e retorno renovado ao fundo do baralho.
- Aviso por ataque vazio, movimentação aleatória do descanso, colocação paga da mão e penalidade de 5% quando nenhuma correção é possível.
- Interface para escolher alvos, acompanhar dano restante e visualizar a Vida dos dois jogadores.

### Decisões e aprendizados

- O ataque não resolve inteiro em um único clique. `TurnController` conserva `pending_attack_damage` e `attacking_player_index`; durante essa fase, preparação e encerramento manual ficam bloqueados até o jogador escolher os alvos necessários.
- A derrota usa `base_health`, que representa a Vida máxima impressa, e não a Vida atual nem um modificador temporário.
- O retorno ao fundo chama a renovação existente da Spec 003, eliminando dano e marcas sem embaralhar.
- A correção de inatividade ocorre antes da troca de jogador. Uma carta do descanso avança gratuitamente; com descanso vazio, somente uma comum pagável pode ser colocada.

### Validação

- Um ataque 7 + 8 derrotou um alvo 10 e distribuiu os 5 restantes a um segundo alvo escolhido.
- Dano excedente sem alvo foi perdido; o dono recebeu somente a Vida impressa da carta derrotada.
- Dano não letal persistiu, efeitos de dano recusaram o descanso e destruição aplicou a derrota normal.
- Vida zero e esgotamento total encerraram a partida nos cenários corretos.
- Aviso, movimentação do descanso, colocação da mão e penalidade arredondada passaram em testes determinísticos.
- As sete suítes passaram no Godot 4.6.2.

### Playtest

- **Testado automaticamente:** todos os RF-DES-001–016 e a seleção de alvo pela interface.
- **Avaliação positiva:** o dano restante fica explícito e impede que o turno avance sem resolver a escolha obrigatória.
- **Pendente:** jogar uma partida completa para avaliar se 50 de Vida produz duração entre três e dez rodadas.

## 2026-10-03 — Spec 007: Cartas do Protótipo

### O que foi implementado

- Resolvedor central para os efeitos retos e invertidos das 15 cartas do protótipo.
- Fase genérica de resolução com escolhas simples, múltiplas e encadeadas.
- Modificadores e restrições com expiração por início de turno, fim de turno ou rodada completa.
- Integração de proteções, provocação, sobrevivência e Eclipse com o combate existente.
- Interface rolável para escolher alvos e confirmar conjuntos, além do aviso explícito de risco da Chama Instável.

### Decisões e aprendizados

- `TurnController` continua sendo a autoridade de movimento, dano, derrota e troca de turno; `CardEffectResolver` descreve efeitos e pede essas operações ao controlador.
- A jogada inteira é validada antes de pagar energia. Isso evita estados parciais quando falta um alvo obrigatório.
- Uma escolha pendente bloqueia preparação e conserva uma continuação. Escolhas encadeadas, como A Morte e Relação Rompida, reutilizam o mesmo mecanismo.
- A referência do resolvedor ao controlador é fraca para evitar um ciclo entre dois `RefCounted` e vazamentos ao encerrar a partida ou os testes.
- Modificadores temporários registram sua carta especial de origem; substituir essa especial encerra corretamente o efeito que dependia de sua permanência.

### Validação

- Duas novas suítes exercitaram efeitos de energia, baralho, alvos, dano simultâneo, passivos, proteções, transformação, ficha, modificadores coletivos e resultados aleatórios.
- A regressão da interface resolveu uma especial com duas escolhas sucessivas e confirmou o cemitério e a nova ficha.
- Todas as nove suítes passaram no Godot 4.6.2 e o projeto iniciou em modo headless sem erros.

### Playtest

- **Testado automaticamente:** regras e integrações determinísticas da Spec 007.
- **Avaliação positiva:** uma única interface de escolhas atende efeitos simples e encadeados sem multiplicar telas específicas.
- **Pendente:** partida manual completa para avaliar clareza, ritmo e balanceamento dos 30 efeitos.
