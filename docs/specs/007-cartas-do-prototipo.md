# Spec 007 — Cartas do Protótipo

## Objetivo

Definir os efeitos individuais das cinco cartas de suporte, cinco cartas de ataque e cinco cartas especiais do primeiro incremento.

## Fora do escopo

- As outras 63 cartas do futuro baralho completo.
- Balanceamento final dos valores antes do playtest.

### RF-AGE-027 — Evasão reta do 7 de Espadas

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-018, RF-AGE-022

Quando o 7 de Espadas reto entra no campo de ataque, ele não pode ser escolhido como alvo durante o próximo turno do adversário.

**Critérios de aceitação**

- Dado que o 7 de Espadas reto entrou no ataque, quando o adversário realiza seu próximo turno, então não pode escolhê-lo como alvo de ataque ou efeito que exija escolha de alvo.
- Dado que o próximo turno do adversário terminou, quando um turno posterior começa, então a proteção deixa de existir.

**Origem:** a duração foi ajustada para o próximo turno adversário porque a proteção restrita ao turno de entrada terminaria antes que o adversário pudesse atacar.

### RF-AGE-028 — Ilusão reta de A Lua

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-011, RF-AGE-022

A Lua reta escolhe uma carta do próprio jogador e impede que ela seja escolhida como alvo durante uma rodada completa.

**Critérios de aceitação**

- Dado que A Lua reta foi jogada e uma carta própria foi escolhida, quando qualquer efeito ou ataque tenta escolhê-la como alvo durante a rodada de proteção, então a escolha não é permitida.
- Dado que ambos os jogadores concluíram um turno após a ativação, quando a rodada termina, então a proteção é removida.

**Origem:** o grupo substituiu a proteção de uma carta inimiga e a referência a ataque direto por proteção a uma carta própria. A duração de uma rodada oferece proteção relevante sem deixar o efeito poderoso demais.

### RF-AGE-029 — Transformação reta de A Morte

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-DES-007, RF-DES-008, RF-AGE-018, RF-AGE-022

A Morte reta destrói uma carta comum do próprio jogador e uma carta comum inimiga, ambas no campo de ataque, aplicando a elas as consequências normais de derrota. Depois, cria uma ficha com 4 de ataque e 4 de vida no campo de descanso do jogador que lançou o feitiço.

**Critérios de aceitação**

- Dado que A Morte reta possui dois alvos válidos nos campos de ataque, quando seu efeito resolve, então uma carta comum de cada jogador é derrotada normalmente, seus donos perdem vida igual à vida máxima delas e elas retornam ao fundo dos respectivos baralhos.
- Dado que uma carta comum está no descanso, quando os alvos de A Morte reta são determinados, então ela não pode ser escolhida.
- Dado que as derrotas foram resolvidas e há espaço no descanso do lançador, quando o efeito continua, então uma ficha 4/4 é criada nesse campo.
- Dado que a ficha 4/4 é derrotada ou deixa o campo, quando sua saída é resolvida, então desaparece da partida e não entra no baralho nem no cemitério.

**Origem:** a ficha entra no descanso porque é uma nova carta em preparação e desaparece ao sair por não pertencer ao baralho. As destruições mantêm as consequências normais para que o efeito não fique poderoso demais e ficam restritas ao ataque para preservar a proteção do descanso.

### RF-AGE-032 — Descarte com mão insuficiente

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-024

Quando um efeito exige descartar uma quantidade de cartas maior que a mão do jogador, ele descarta somente as cartas disponíveis e não sofre penalidade adicional.

**Critérios de aceitação**

- Dado que um efeito exige descartar duas cartas e o jogador possui uma, quando o efeito resolve, então essa única carta vai ao fundo do baralho e a mão fica vazia.
- Dado que um efeito exige descartar duas cartas e a mão está vazia, quando o efeito resolve, então nenhuma carta é descartada e nenhuma penalidade adicional ocorre.

**Origem:** o grupo decidiu que o descarte esgota apenas o que estiver disponível na mão, sem criar outra punição quando faltarem cartas.

### RF-AGE-033 — Alvos obrigatórios de A Morte reta

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-029

A Morte reta só pode ser jogada quando existe ao menos uma carta comum própria e uma carta comum inimiga nos campos de ataque que possam ser escolhidas para destruição.

**Critérios de aceitação**

- Dado que ambos os jogadores possuem ao menos um alvo comum válido no ataque, quando o jogador usa A Morte reta, então escolhe uma carta de cada lado e resolve RF-AGE-029.
- Dado que qualquer um dos lados não possui alvo comum válido, quando o jogador tenta usar A Morte reta, então a jogada não é permitida, nenhuma energia é gasta e a carta permanece na mão.

**Origem:** o grupo exige os dois alvos porque, sem eles, o efeito não seria executado corretamente.

### RF-AGE-034 — Encerramento de bônus temporário de Vida

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** nenhuma

Quando um bônus temporário de Vida termina, a Vida máxima retorna ao valor sem o bônus e a Vida atual é limitada a esse máximo, sem subtrair automaticamente o valor que havia sido concedido.

**Critérios de aceitação**

- Dado que uma carta 3/3 recebeu +2/+2 e permaneceu sem dano como 5/5, quando o bônus termina, então ela volta a 3/3.
- Dado que a mesma carta está com 2/5, quando o bônus termina, então ela fica com 2/3.
- Dado que a mesma carta está com 4/5, quando o bônus termina, então ela fica com 3/3.

**Origem:** o grupo considera que um bônus temporário não deve prejudicar o jogador ao terminar, mesmo que isso preserve parte da Vida obtida durante sua duração.

### RF-AGE-035 — Aplicação de redução temporária de Vida

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-DES-007, RF-DES-008

Uma redução temporária de Vida diminui imediatamente tanto a Vida máxima quanto a Vida atual. Se a Vida atual chegar a zero ou menos, a carta é derrotada normalmente. Quando a redução termina, a Vida máxima retorna, mas a Vida atual perdida não é recuperada.

**Critérios de aceitação**

- Dado que uma carta está em 5/5, quando recebe −2 de Vida temporária, então passa a 3/3.
- Dado que uma carta possui 2 de Vida atual, quando recebe −2 de Vida, então é derrotada normalmente.
- Dado que uma carta 5/5 ficou 3/3 por um debuff e sobreviveu, quando o efeito termina, então fica com 3 de Vida atual e 5 de Vida máxima.

**Origem:** o grupo definiu que o debuff retira Vida de fato e pode derrotar; seu encerramento remove a limitação máxima, mas não cura o dano causado.

### RF-AGE-036 — Limite de repetição de redução temporária

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-035

Cada carta pode ser afetada apenas uma vez, durante cada permanência fora do baralho, por efeitos temporários que reduzam Ataque e/ou Vida. Ao retornar ao fundo, a renovação reinicia essa imunidade. Dano direto não está sujeito ao limite.

**Critérios de aceitação**

- Dado que uma carta ainda não recebeu uma redução temporária de Ataque/Vida, quando um efeito como Eclipse resolve, então a redução é aplicada e a carta fica marcada como já afetada por esse tipo de debuff.
- Dado que a carta já recebeu uma redução temporária de Ataque/Vida durante sua permanência atual, quando outro efeito dessa categoria tenta afetá-la, então a redução não é aplicada a ela.
- Dado que a carta retorna ao fundo e é comprada novamente, quando um efeito dessa categoria tenta afetá-la, então a redução pode ser aplicada novamente.
- Dado que a carta já recebeu esse tipo de debuff, quando sofre dano direto, então o dano é aplicado normalmente.

**Origem:** o grupo limita esse tipo de redução a uma aplicação por permanência para impedir acúmulo abusivo, mas reinicia a marca quando a carta passa pela renovação completa do baralho.

### RF-AGE-037 — Legado reto do 10 de Ouros

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-012, RF-AGE-018, RF-AGE-022

Enquanto o 10 de Ouros reto estiver no campo, no início de cada turno de seu dono ele concede 2 energias adicionais se o jogador controlar ao menos três cartas entre ataque, suporte e fichas nos campos de descanso e ataque. Cartas especiais não entram na contagem.

**Critérios de aceitação**

- Dado que o 10 de Ouros reto está no campo e seu dono possui ao menos três cartas ou fichas somadas entre descanso e ataque, quando o turno começa, então recebe 2 energias adicionais além do ganho automático.
- Dado que o jogador possui menos de três cartas ou fichas nesses campos, quando o turno começa, então o efeito não concede energia.
- Dado que o jogador possui cartas especiais ativas, quando a quantidade controlada é calculada, então elas não entram na contagem.

**Origem:** o grupo conta as cartas e fichas que o jogador efetivamente controla nos campos; especiais ficam fora porque não podem ser controladas depois de colocadas. O efeito representa prosperidade construída pelo campo acumulado.

### RF-AGE-038 — Herança Perdida invertida do 10 de Ouros

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-012, RF-AGE-022, RF-AGE-026

Quando o 10 de Ouros invertido entra no descanso, seu dono recebe 6 energias. Depois disso, ganhos adicionais vindos de cartas ficam bloqueados durante o restante do turno atual e todo o próximo turno próprio. O ganho automático de 2 energias no início do turno não é bloqueado.

**Critérios de aceitação**

- Dado que o 10 de Ouros invertido entra no descanso, quando seu efeito ativa, então o jogador recebe 6 energias.
- Dado que a restrição está ativa, quando outra carta tentaria conceder energia, então nenhuma energia adicional é recebida.
- Dado que começa o próximo turno do jogador, quando os recursos automáticos são concedidos, então ele recebe normalmente as 2 energias de turno.
- Dado que o próximo turno próprio termina, quando um turno posterior começa, então ganhos adicionais de cartas voltam a funcionar.

**Origem:** o grupo diferencia o ganho automático dos ganhos adicionais e mantém a restrição durante o próximo turno para impedir que a penalidade seja evitada jogando o 10 de Ouros somente no fim do turno atual.

### RF-AGE-039 — Bloqueio por ausência de alvo obrigatório

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-022

Uma carta cujo efeito conhecido exige um ou mais alvos obrigatórios só pode ser jogada quando todos esses alvos válidos existem.

**Critérios de aceitação**

- Dado que todos os alvos obrigatórios do efeito existem, quando o jogador usa a carta, então paga o custo e escolhe os alvos para resolver o efeito.
- Dado que falta qualquer alvo obrigatório, quando o jogador tenta usar a carta, então a jogada é bloqueada, nenhuma energia é gasta e a carta permanece na mão.

**Origem:** como a orientação e o efeito já são conhecidos na mão, o grupo bloqueia a jogada quando o efeito não poderia ser aplicado corretamente.

### RF-AGE-041 — Generosidade reta do 6 de Ouros

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-022, RF-AGE-026, RF-AGE-034, RF-AGE-039

Quando o 6 de Ouros reto entra no campo de ataque, seu dono escolhe outra carta comum própria no mesmo campo. Ela recebe +3 de Ataque e +3 de Vida até o início do próximo turno do dono do 6 de Ouros.

**Critérios de aceitação**

- Dado que existe outra carta própria válida no ataque, quando o 6 de Ouros reto entra nesse campo, então o jogador escolhe essa carta e aplica +3/+3.
- Dado que só existem cartas próprias no descanso, quando o jogador tenta avançar o 6 de Ouros reto, então a ação é bloqueada por falta de alvo válido.
- Dado que começa o próximo turno do dono do 6 de Ouros, quando o bônus termina, então Ataque e Vida máxima retornam e a Vida atual segue RF-AGE-034.

**Origem:** o efeito representa generosidade como fortalecimento temporário de outra carta e usa a regra definida para bônus que não prejudicam ao terminar. O alvo fica restrito ao ataque porque o efeito modifica Ataque e Vida e o descanso permanece protegido.

### RF-AGE-042 — Dívida invertida do 6 de Ouros

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-013, RF-AGE-022, RF-AGE-026, RF-AGE-039

Quando o 6 de Ouros invertido entra no campo de ataque, seu dono escolhe uma carta inimiga no campo de ataque. Ela recebe +3 de Ataque até o fim do próximo turno de seu dono, enquanto o dono do 6 de Ouros recebe 3 energias normais e acumuláveis.

**Critérios de aceitação**

- Dado que existe uma carta inimiga válida no ataque, quando o 6 de Ouros invertido entra nesse campo, então ela recebe +3 de Ataque e o lançador recebe 3 energias.
- Dado que só existem cartas inimigas no descanso, quando o jogador tenta avançar o 6 de Ouros invertido, então a ação é bloqueada por falta de alvo válido.
- Dado que a carta inimiga realiza seu próximo turno, quando esse turno termina, então o bônus de +3 de Ataque é removido.
- Dado que o lançador não gasta toda a energia recebida, quando seu turno termina, então a energia restante continua acumulada normalmente.

**Origem:** o grupo quer uma troca em que o adversário possa gastar o poder extra em seu próximo ataque, enquanto o lançador recebe energia para usar em suas próprias cartas; ambos os benefícios são consumidos pela dinâmica normal do jogo. O alvo fica restrito ao ataque para preservar o descanso.

### RF-AGE-043 — União reta do 2 de Copas

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-022, RF-AGE-026, RF-AGE-034, RF-AGE-039

Quando o 2 de Copas reto entra no campo de ataque, seu dono escolhe outra carta própria no mesmo campo. Enquanto ambas permanecerem no campo de ataque, cada uma recebe +2 de Ataque e +2 de Vida.

**Critérios de aceitação**

- Dado que existe outra carta própria no ataque, quando o 2 de Copas reto entra nesse campo, então o jogador a escolhe e ambas recebem +2/+2.
- Dado que uma das duas cartas deixa o campo de ataque, quando o vínculo é atualizado, então o bônus termina para ambas e a Vida atual segue RF-AGE-034.
- Dado que só existem cartas próprias no descanso, quando o 2 de Copas reto tenta avançar, então a jogada é bloqueada por falta de alvo válido.

**Origem:** o grupo restringe a ligação ao campo de ataque porque o efeito modifica Vida e dano de combate; a forma reta representa união entre duas cartas ofensivas.

### RF-AGE-044 — Relação Rompida invertida do 2 de Copas

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-022, RF-AGE-026, RF-AGE-039, RF-DES-007, RF-DES-008

Quando o 2 de Copas invertido entra no campo de ataque, seu dono escolhe uma carta própria no ataque — podendo escolher o próprio 2 de Copas — e uma carta inimiga no ataque. Ambas sofrem 3 de dano.

**Critérios de aceitação**

- Dado que existe ao menos uma carta inimiga no ataque, quando o efeito resolve, então o jogador escolhe uma carta de cada lado e aplica 3 de dano a ambas.
- Dado que o jogador escolhe o próprio 2 de Copas, quando o dano resolve, então ele recebe os 3 de dano normalmente.
- Dado que qualquer carta chega a zero de Vida, quando o dano termina, então ela é derrotada e sofre todas as consequências normais.

**Origem:** os alvos ficam no campo de ataque porque o efeito envolve dano. O próprio 2 de Copas pode ser escolhido para permitir uma troca estratégica em que o jogador o sacrifica para ferir ou derrotar uma carta inimiga.

### RF-AGE-045 — Sete Possibilidades reta do 7 de Copas

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-022

Quando o efeito reto do 7 de Copas ativa, seu dono olha as três primeiras cartas do próprio baralho, escolhe uma para comprar e devolve as outras duas ao topo na ordem que desejar. Apenas a carta comprada recebe um sorteio de orientação nesse momento.

**Critérios de aceitação**

- Dado que existem ao menos três cartas no baralho, quando o efeito resolve, então o jogador vê essas três sem misturá-las à mão, escolhe uma e organiza as outras duas no topo.
- Dado que existe uma ou duas cartas no baralho, quando o efeito resolve, então o jogador olha todas as disponíveis, escolhe uma para comprar e reorganiza no topo somente as que restarem.
- Dado que uma carta foi escolhida, quando entra na mão, então sua orientação é sorteada com 50% de chance para cada lado.
- Dado que duas cartas foram devolvidas ao topo, quando o efeito termina, então elas ainda não receberam orientação e serão compradas na ordem escolhida.
- Dado que o baralho está vazio, quando o jogador tenta colocar o 7 de Copas reto no descanso, então a jogada é bloqueada, nenhuma energia é gasta e a carta permanece na mão.

**Origem:** o grupo separa as cartas consultadas da mão para evitar confusão; a orientação só é sorteada para a carta efetivamente comprada. O efeito usa as cartas disponíveis para continuar funcional perto do fim do baralho, mas exige ao menos uma para poder concluir a escolha.

### RF-AGE-046 — Ilusão Revelada invertida do 7 de Copas

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-022, RF-AGE-024, RF-AGE-026

Quando o 7 de Copas invertido entra no campo de descanso, seu dono olha até cinco cartas do topo do próprio baralho, escolhe uma para comprar e envia todas as outras ao fundo mantendo a ordem relativa original. A orientação é sorteada somente para a carta comprada.

**Critérios de aceitação**

- Dado que existem cinco ou mais cartas no baralho, quando o efeito resolve, então o jogador olha as cinco primeiras, escolhe uma para a mão e envia as outras quatro ao fundo na ordem relativa em que estavam.
- Dado que existem de uma a quatro cartas, quando o efeito resolve, então o jogador olha todas, escolhe uma para a mão e envia as demais ao fundo na ordem relativa original.
- Dado que uma carta escolhida entra na mão, quando a compra termina, então sua orientação é sorteada com 50% de chance para cada lado.
- Dado que o baralho está vazio, quando o jogador tenta colocar o 7 de Copas invertido no descanso, então a jogada é bloqueada, nenhuma energia é gasta e a carta permanece na mão.

**Origem:** o grupo quer concluir o efeito com qualquer quantidade disponível, mas exige ao menos uma carta que possa ser escolhida. Manter a ordem original das demais equivale ao descarte comum para o fundo do baralho.

### RF-AGE-047 — Chama da Inspiração reta do Ás de Paus

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-013, RF-AGE-022, RF-AGE-026

Quando o Ás de Paus reto entra no campo de descanso, seu dono recebe imediatamente 2 energias normais e acumuláveis.

**Critérios de aceitação**

- Dado que o Ás de Paus reto entra validamente no descanso, quando seu efeito resolve, então seu dono recebe 2 energias.
- Dado que parte dessa energia não é gasta, quando o turno termina, então ela permanece na reserva normalmente.

**Origem:** a forma reta representa uma aceleração controlada de energia que pode ser incorporada ao planejamento do jogador.

### RF-AGE-048 — Chama Instável invertida do Ás de Paus

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-013, RF-AGE-022, RF-AGE-026, RF-DES-001

Quando o Ás de Paus invertido entra no campo de descanso, seu dono recebe imediatamente 4 energias normais e perde 2 pontos de Vida. Essa perda pode causar sua derrota.

**Critérios de aceitação**

- Dado que o Ás de Paus invertido entra validamente no descanso, quando seu efeito resolve, então seu dono recebe 4 energias e perde 2 de Vida.
- Dado que o jogador possui 2 ou menos de Vida ao tentar jogar a carta, quando confirma a jogada após um aviso de risco, então o efeito resolve e ele perde a partida ao chegar a zero.
- Dado que o jogador possui 2 ou menos de Vida, quando tenta jogar a carta, então o jogo informa claramente que a ação causará sua derrota antes da confirmação final.

**Origem:** o grupo quer uma troca arriscada de Vida por energia; a derrota continua possível para preservar o sacrifício, mas o aviso impede uma jogada fatal despercebida.

### RF-AGE-049 — Confronto reto do 5 de Paus

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-022, RF-AGE-026, RF-AGE-039, RF-DES-002, RF-DES-003

Quando o 5 de Paus reto entra no campo de ataque, seu dono escolhe uma carta inimiga no ataque. No próximo turno do adversário, se ambas ainda estiverem no ataque, o adversário é obrigado a realizar seu ataque conjunto e escolher o 5 de Paus como primeiro alvo.

**Critérios de aceitação**

- Dado que ambas as cartas vinculadas continuam no ataque, quando chega a ação de ataque do próximo turno adversário, então o ataque não pode ser omitido e o 5 de Paus é o primeiro alvo.
- Dado que o 5 de Paus é derrotado e sobra dano, quando o ataque continua, então o adversário escolhe os alvos seguintes pelas regras normais.
- Dado que o 5 de Paus ou a carta inimiga escolhida deixa o campo antes do ataque obrigatório, quando o efeito é atualizado, então a obrigação termina.

**Origem:** o grupo traduz a provocação para o combate conjunto tornando o 5 de Paus o primeiro alvo obrigatório. O ataque também é obrigatório porque a carta inimiga foi provocada; o vínculo termina se uma das duas sair e o efeito deixar de estar ativo.

### RF-AGE-050 — Caos invertido do 5 de Paus

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-022, RF-AGE-026, RF-AGE-039, RF-DES-015

Quando o 5 de Paus invertido entra no campo de ataque, seu dono escolhe duas cartas inimigas no ataque. Cada uma causa simultaneamente à outra dano igual ao próprio Ataque atual.

**Critérios de aceitação**

- Dado que existem ao menos duas cartas inimigas no ataque, quando o efeito resolve, então ambas calculam seu Ataque antes do dano e o aplicam uma à outra simultaneamente.
- Dado que uma ou ambas chegam a zero de Vida, quando os dois danos já foram aplicados, então as derrotas são resolvidas normalmente.
- Dado que existem menos de duas cartas inimigas no ataque, quando o jogador tenta avançar o 5 de Paus invertido, então a ação é bloqueada sem custo adicional.

**Origem:** o grupo usa resolução simultânea para impedir que a primeira carta derrotada deixe de causar seu dano de volta.

### RF-AGE-051 — Coração Partido reto do 3 de Espadas

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-022, RF-AGE-026, RF-AGE-039, RF-DES-015

Quando o 3 de Espadas reto entra no campo de ataque, seu dono escolhe uma carta inimiga no ataque e causa 4 de dano a ela.

**Critérios de aceitação**

- Dado que existe uma carta inimiga no ataque, quando o efeito resolve, então o jogador escolhe uma e ela sofre 4 de dano.
- Dado que o ataque inimigo está vazio, quando o jogador tenta avançar o 3 de Espadas reto, então a ação é bloqueada até existir alvo válido.

**Origem:** a forma reta concentra o sofrimento em uma única carta inimiga e segue a regra global de dano restrito ao campo de ataque.

### RF-AGE-052 — Ferida Profunda invertida do 3 de Espadas

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-022, RF-AGE-026, RF-AGE-039, RF-DES-015

Quando o 3 de Espadas invertido entra no campo de ataque, causa simultaneamente 2 de dano a todas as cartas inimigas no campo de ataque.

**Critérios de aceitação**

- Dado que existe ao menos uma carta inimiga no ataque, quando o efeito resolve, então todas as cartas desse campo sofrem 2 de dano simultaneamente.
- Dado que uma ou mais cartas chegam a zero de Vida, quando todo o dano foi aplicado, então suas derrotas são resolvidas normalmente.
- Dado que o ataque inimigo está vazio, quando o jogador tenta avançar o 3 de Espadas invertido, então a ação é bloqueada e ele precisa esperar por alvos válidos.

**Origem:** o grupo aplica dano apenas ao campo de ataque e bloqueia o avanço sem alvos para que o efeito não seja desperdiçado sem poder cumprir sua função.

### RF-AGE-053 — Roubo invertido do 7 de Espadas

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-022, RF-AGE-024, RF-AGE-026, RF-AGE-039

Quando o 7 de Espadas invertido entra no campo de descanso, seu dono vê a mão adversária completa, incluindo identidade, orientação e efeito atual de cada carta, e escolhe uma para descarte. Ataque ou suporte vai ao fundo do baralho adversário; carta especial vai ao cemitério adversário.

**Critérios de aceitação**

- Dado que a mão adversária contém cartas, quando o 7 de Espadas invertido entra no descanso, então seu dono vê todas as informações dessas cartas e escolhe exatamente uma.
- Dado que a escolhida é de ataque ou suporte, quando o descarte resolve, então ela vai ao fundo do baralho adversário sem embaralhamento.
- Dado que a escolhida é especial, quando o descarte resolve, então ela vai ao cemitério adversário.
- Dado que a mão adversária está vazia, quando o jogador tenta colocar o 7 de Espadas invertido no descanso, então a jogada é bloqueada, nenhuma energia é gasta e ele permanece na mão.

**Origem:** o grupo permite ver a mão inteira para que a escolha represente roubo de informação e usa o destino normal de descarte de cada categoria.

### RF-AGE-055 — Última Resistência reta do 9 de Paus

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-054, RF-DES-003

Uma vez durante cada permanência do 9 de Paus reto fora do baralho, quando um dano o deixaria com zero ou menos Vida, ele permanece com 1 de Vida. Como não foi derrotado, todo o dano destinado a ele é consumido e não passa ao próximo alvo. O uso é renovado se a carta retornar ao baralho e for comprada novamente.

**Critérios de aceitação**

- Dado que a resistência ainda não foi usada, quando o 9 de Paus reto receber dano letal, então permanece com 1 de Vida e marca o efeito como usado.
- Dado que havia dano maior que sua Vida, quando a resistência o salva, então nenhum excesso é distribuído a outra carta.
- Dado que a resistência já foi usada nessa permanência, quando recebe novo dano letal, então é derrotado normalmente.
- Dado que o 9 de Paus voltou ao fundo e foi comprado novamente, quando entra em jogo reto, então a resistência está disponível outra vez.

**Origem:** o grupo preserva todo o golpe no 9 de Paus porque ele não foi derrotado e renova a habilidade quando a carta passa pela renovação completa do baralho.

### RF-AGE-056 — Exaustão invertida do 9 de Paus

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** nenhuma

Enquanto o 9 de Paus invertido possuir exatamente 1 ou 2 pontos de Vida atual, recebe +4 de Ataque. Fora dessa faixa, o bônus não se aplica.

**Critérios de aceitação**

- Dado que sua Vida atual cai para 2 ou 1, quando os atributos são atualizados, então seu Ataque aumenta em 4.
- Dado que sua Vida atual sobe acima de 2, quando os atributos são atualizados, então o bônus de 4 é removido.
- Dado que sua Vida volta posteriormente a 2 ou 1, quando os atributos são atualizados, então o bônus volta a ser aplicado.
- Dado que sua Vida chega a zero, quando a derrota é resolvida, então ele é derrotado normalmente antes de poder usar o bônus.

**Origem:** o grupo vincula o efeito estritamente ao estado de exaustão representado por 1 ou 2 de Vida.

### RF-AGE-057 — Aperfeiçoamento reto do 8 de Ouros

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-054

No fim de cada turno de seu dono em que o 8 de Ouros reto não participou do ataque, ele recebe permanentemente +1 de Ataque, +1 de Vida máxima e recupera 1 de Vida atual, até alcançar no máximo 7 de Ataque e 7 de Vida máxima. O efeito funciona tanto no descanso quanto no ataque e é removido pela renovação no baralho.

**Critérios de aceitação**

- Dado que o 8 de Ouros reto está no descanso ao fim do turno, quando o efeito ativa, então seus valores aumentam em +1/+1 e sua Vida atual aumenta em 1, respeitando o máximo.
- Dado que está no ataque e o jogador encerrou o turno sem atacar, quando o efeito ativa, então recebe o mesmo crescimento.
- Dado que participou do ataque conjunto naquele turno, quando o turno termina, então não cresce.
- Dado que já possui 7 de Ataque e 7 de Vida máxima, quando termina um turno sem atacar, então seus valores não ultrapassam 7/7.

**Origem:** o grupo permite crescimento no descanso para que o jogador controle quando preparar e quando expor a carta; cada +1 de Vida também recupera um ponto porque a carta efetivamente recebe o atributo adicional.

### RF-AGE-058 — Trabalho Excessivo invertido do 8 de Ouros

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-054

No início de cada turno de seu dono, enquanto o 8 de Ouros invertido possuir 2 ou mais de Vida atual, ele recebe permanentemente +2 de Ataque sem limite máximo e perde 1 de Vida. Ao chegar a 1 de Vida, deixa de ativar. O Ataque acumulado é removido pela renovação no baralho.

**Critérios de aceitação**

- Dado que possui ao menos 2 de Vida no início do turno, quando o efeito ativa, então ganha +2 de Ataque e perde 1 de Vida.
- Dado que o 8 de Ouros invertido está no campo de descanso, quando o turno de seu dono começa e ele possui Vida suficiente, então o efeito ativa normalmente.
- Dado que começa o turno com 2 de Vida, quando o efeito ativa, então fica com 1 de Vida e recebe o último +2 de Ataque.
- Dado que começa o turno com 1 de Vida, quando o efeito é verificado, então não ganha Ataque nem perde Vida.
- Dado que permanece em campo por vários turnos com Vida suficiente, quando o efeito ativa repetidamente, então os bônus de Ataque se acumulam sem teto.

**Origem:** o grupo quer crescimento ofensivo ilimitado em troca de Vida, inclusive no descanso para que o jogador escolha quando avançar com o bônus desejado, mas interrompe o custo em 1 para não destruir automaticamente a carta antes que ela possa usar o Ataque acumulado.

### RF-AGE-059 — Resistência à Morte invertida

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-021, RF-AGE-035, RF-AGE-039

A Morte invertida escolhe uma ou duas cartas próprias no campo de ataque que possuam no máximo 5 de Vida atual. Até o início do próximo turno do lançador, elas não podem ser derrotadas e todo dano letal as mantém com 1 de Vida. Nesse início de turno, a proteção termina e cada carta perde 3 de Vida, podendo ser derrotada normalmente.

**Critérios de aceitação**

- Dado que existe ao menos uma carta própria elegível no ataque, quando A Morte invertida é usada, então o jogador escolhe uma ou duas com até 5 de Vida atual.
- Dado que uma carta protegida recebe dano letal uma ou mais vezes, quando cada dano resolve, então ela permanece com 1 de Vida enquanto durar a proteção.
- Dado que começa o próximo turno do lançador, quando o efeito expira, então a proteção é removida antes de cada carta perder 3 de Vida.
- Dado que a perda de 3 reduz uma carta a zero ou menos, quando ela resolve, então a carta é derrotada normalmente.
- Dado que não existe carta própria elegível, quando o jogador tenta usar A Morte invertida, então a jogada é bloqueada e nenhuma energia é gasta.

**Origem:** o grupo restringe o efeito às próprias cartas porque não faria sentido proteger o campo adversário. A duração atravessa o turno inimigo para cumprir a função defensiva, mas a perda posterior preserva a decisão estratégica e pode cobrar a derrota adiada.

### RF-AGE-060 — Resultado aleatório sem alvo ou recurso disponível

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** nenhuma

Quando uma carta já paga e jogada produz aleatoriamente um resultado que não pode ser aplicado por falta de alvo ou recurso disponível, esse resultado não produz efeito, não é sorteado novamente e não devolve o custo.

**Critérios de aceitação**

- Dado que o resultado aleatório exige um alvo inexistente, quando ele é resolvido, então nada acontece e a carta continua considerada usada.
- Dado que o resultado não pode ser aplicado, quando a resolução termina, então nenhuma energia é devolvida e não ocorre novo sorteio.

**Origem:** o grupo mantém o resultado sem efeito porque não existe como aplicá-lo depois que a carta aleatória já foi usada.

### RF-AGE-061 — Virada do Destino reta da Roda da Fortuna

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-020, RF-AGE-021, RF-AGE-022, RF-AGE-034, RF-AGE-060, RF-DES-013

Ao usar a Roda da Fortuna reta, o jogo sorteia um número de 1 a 6 com probabilidades iguais e resolve um único resultado:

- 1–2: o jogador recebe 4 energias normais;
- 3–4: compra até três cartas disponíveis, cada uma com nova orientação;
- 5: todas as cartas próprias no campo de ataque recebem +3/+3 até o fim do turno atual;
- 6: o jogador escolhe uma carta inimiga no campo de ataque e a destrói normalmente.

**Critérios de aceitação**

- Dado que sai 1 ou 2, quando o resultado resolve, então o jogador recebe 4 energias acumuláveis.
- Dado que sai 3 ou 4, quando existem menos de três cartas no baralho, então compra somente as disponíveis; cada comprada recebe orientação.
- Dado que sai 5, quando o bônus é aplicado, então somente cartas próprias no ataque recebem +3/+3 e seguem RF-AGE-034 ao fim do turno.
- Dado que sai 6 e existe carta inimiga no ataque, quando o jogador a escolhe, então a destruição aplica todas as consequências normais.
- Dado que sai 6 sem alvo no ataque, quando o resultado resolve, então nada acontece conforme RF-AGE-060.

**Origem:** a carta representa uma virada de destino com alta variabilidade. O descanso é preservado para não tornar o fortalecimento ou a destruição fortes demais, e compras insuficientes usam o que existe para permitir a resolução possível.

### RF-AGE-062 — Má Fortuna invertida da Roda da Fortuna

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-020, RF-AGE-021, RF-AGE-031, RF-AGE-032, RF-AGE-035, RF-AGE-036, RF-AGE-060, RF-DES-013

Ao usar a Roda da Fortuna invertida, o jogo sorteia um número de 1 a 6 com probabilidades iguais e resolve um único resultado:

- 1–2: o jogador perde 4 energias, sem ficar abaixo de zero;
- 3–4: o jogador escolhe até duas cartas disponíveis em sua mão e as descarta pelo destino normal da categoria;
- 5: todas as cartas próprias elegíveis no campo de ataque recebem −3/−3 até o fim do turno atual;
- 6: o jogador escolhe uma carta própria no campo de ataque e a destrói normalmente.

**Critérios de aceitação**

- Dado que sai 1 ou 2, quando o jogador possui menos de 4 energias, então seu total passa a zero.
- Dado que sai 3 ou 4, quando existem duas ou mais cartas na mão, então o próprio jogador escolhe duas; se houver menos, descarta somente as disponíveis.
- Dado que sai 5, quando o resultado resolve, então somente cartas próprias no ataque que ainda possam receber esse tipo de debuff sofrem −3/−3 pelas regras RF-AGE-035 e RF-AGE-036.
- Dado que sai 6 e existe carta própria no ataque, quando o resultado resolve, então o dono escolhe uma e aplica a derrota normal.
- Dado que sai 6 sem carta própria no ataque, quando o resultado resolve, então nada acontece conforme RF-AGE-060.

**Origem:** a forma invertida preserva o risco da aleatoriedade, mas permite que o dono escolha seus descartes e sua carta sacrificada para não destruir sua estratégia sem qualquer agência. Assim como a forma reta, seus efeitos de campo alcançam somente o ataque.

### RF-AGE-063 — Pacto reto de O Diabo

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-021, RF-AGE-034, RF-AGE-039

O Diabo reto escolhe uma carta própria no campo de ataque e concede +6 de Ataque e +6 de Vida durante o turno atual do lançador e seu próximo turno próprio. Ao fim desse próximo turno, o bônus termina; o −6/−6 descrito pelo efeito representa apenas a remoção dos valores concedidos, não uma penalidade adicional.

**Critérios de aceitação**

- Dado que existe uma carta própria no ataque, quando O Diabo reto é usado, então ela recebe +6/+6 imediatamente.
- Dado que o turno atual termina e começa o próximo turno próprio, quando o estado é verificado, então o bônus continua ativo.
- Dado que o próximo turno próprio termina, quando o efeito expira, então Ataque e Vida máxima perdem somente os 6 pontos concedidos e a Vida atual segue RF-AGE-034.
- Dado que não existe carta própria no ataque, quando o jogador tenta usar O Diabo reto, então a jogada é bloqueada e nenhuma energia é gasta.

**Origem:** o grupo limita o Pacto ao campo de ataque e conta o turno de lançamento como o primeiro dos dois. A redução final apenas encerra o bônus temporário, sem criar uma segunda penalidade abaixo dos valores originais.

### RF-AGE-064 — Quebrar as Correntes invertido de O Diabo

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-021, RF-AGE-034, RF-AGE-039

O Diabo invertido escolhe uma carta própria no campo de ataque, remove todos os debuffs e restrições negativos atualmente ativos nela e concede +3 de Ataque e +3 de Vida durante o turno atual e até o fim do próximo turno próprio do lançador. A remoção não recupera dano nem apaga marcas históricas; o bônus de +3 de Vida aumenta a Vida atual normalmente.

**Critérios de aceitação**

- Dado que a carta alvo possui redução de atributos, provocação ou outra restrição negativa ativa, quando o efeito resolve, então esses estados ativos são removidos.
- Dado que a carta alvo sofreu dano, quando os efeitos negativos são removidos, então a Vida perdida não é recuperada por essa remoção.
- Dado que a carta já foi marcada como afetada por redução temporária, quando o efeito resolve, então essa marca histórica permanece.
- Dado que o +3/+3 é aplicado, quando os atributos são atualizados, então a Vida atual também aumenta em 3 pelas regras de bônus.
- Dado que termina o próximo turno próprio do lançador, quando o bônus expira, então os valores retornam seguindo RF-AGE-034.
- Dado que não existe carta própria no ataque, quando o jogador tenta usar O Diabo invertido, então a jogada é bloqueada e nenhuma energia é gasta.

**Origem:** o grupo limita o efeito ao ataque e o mantém até o fim do próximo turno próprio. Ele liberta a carta de estados negativos ativos, mas não cura o dano nem reescreve o histórico; a recuperação temporária vem somente do bônus separado de Vida.

### RF-AGE-065 — Conjunto afetado por modificadores coletivos

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** nenhuma

Um efeito coletivo temporário afeta somente as cartas que estavam na área indicada no momento de sua resolução. Cartas que entrarem nessa área depois não recebem retroativamente o modificador.

**Critérios de aceitação**

- Dado que um efeito coletivo resolve sobre o campo de ataque, quando os alvos são determinados, então somente as cartas presentes naquele instante são marcadas como afetadas.
- Dado que outra carta entra no ataque depois da resolução, quando seus atributos são calculados, então ela não recebe o modificador já aplicado.

**Origem:** o grupo considera que o efeito é ativado no momento em que a carta é lançada, portanto não alcança cartas que entram depois.

### RF-AGE-066 — Plenitude reta de O Sol

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-021, RF-AGE-034, RF-AGE-065, RF-DES-016

O Sol reto concede +3 de Ataque e +3 de Vida, até o fim do turno atual, a todas as cartas próprias que estiverem no campo de ataque no momento da resolução. Além disso, o jogador recupera 3 de Vida sem ultrapassar sua Vida máxima.

**Critérios de aceitação**

- Dado que existem cartas próprias no ataque, quando O Sol reto resolve, então todas as presentes recebem +3/+3 até o fim do turno.
- Dado que uma carta própria entra no ataque depois da resolução, quando seus atributos são verificados, então ela não recebe esse bônus.
- Dado que o jogador está abaixo da Vida máxima, quando a cura resolve, então recupera até 3 sem ultrapassar o limite.
- Dado que o turno termina, quando o bônus expira, então as cartas seguem RF-AGE-034.

**Origem:** o grupo limita o fortalecimento ao campo de ataque e às cartas presentes na ativação, preservando o descanso e impedindo que a especial beneficie cartas adicionadas posteriormente.

### RF-AGE-067 — Eclipse invertido de O Sol

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-021, RF-AGE-035, RF-AGE-036, RF-AGE-065

O Sol invertido aplica −2 de Ataque e −2 de Vida, até o fim do turno atual, a todas as cartas elegíveis de ambos os jogadores que estiverem nos campos de ataque no momento da resolução. Quando as cartas próprias afetadas participam do ataque conjunto nesse turno, recebem +1 de Ataque para esse ataque, resultando em redução líquida de 1 no Ataque original.

**Critérios de aceitação**

- Dado que existem cartas nos campos de ataque, quando Eclipse resolve, então somente as elegíveis e presentes recebem −2/−2.
- Dado que uma carta está no descanso ou entra no ataque depois, quando o efeito é verificado, então não recebe a redução.
- Dado que uma carta própria afetada participa do ataque naquele turno, quando o dano é calculado, então recebe +1 de Ataque temporário sobre o valor reduzido.
- Dado que a redução leva uma carta a zero de Vida, quando o efeito resolve, então ela é derrotada normalmente.
- Dado que o turno termina, quando o debuff expira, então a Vida máxima retorna, a Vida atual perdida não é curada e o +1 ofensivo termina.

**Origem:** o grupo concentra o Eclipse no campo de ataque porque ele modifica Ataque e Vida e concede +1 às cartas próprias afetadas para permitir recuperação ofensiva parcial sem anular o risco coletivo.

### RF-AGE-068 — Revelação invertida de A Lua

**Prioridade:** DEVE
**Status:** CONFIRMADO
**Depende de:** RF-AGE-020, RF-AGE-022, RF-AGE-039

A Lua invertida permite que seu jogador olhe até cinco cartas disponíveis do topo do baralho adversário, escolha até duas dentre elas para mover ao fundo mantendo a ordem relativa original e, depois, faça o adversário comprar uma carta restante, que recebe nova orientação.

**Critérios de aceitação**

- Dado que existem cinco ou mais cartas no baralho adversário, quando o efeito resolve, então o jogador vê as cinco primeiras, escolhe até duas e as envia ao fundo na ordem relativa original.
- Dado que existem de uma a quatro cartas, quando o efeito resolve, então olha todas as disponíveis e pode mover até duas seguindo a mesma regra.
- Dado que resta ao menos uma carta após a movimentação, quando a etapa final resolve, então o adversário compra a primeira e sua orientação é sorteada.
- Dado que nenhuma carta resta após a movimentação, quando a etapa de compra resolve, então o adversário compra zero cartas e não sofre penalidade adicional.
- Dado que o baralho adversário está vazio antes da jogada, quando o jogador tenta usar A Lua invertida, então a jogada é bloqueada, nenhuma energia é gasta e a carta permanece na mão.

**Origem:** o grupo permite resolução parcial para que a carta continue sendo usada estrategicamente perto do fim do baralho e mantém a ordem relativa das cartas movidas, seguindo o padrão anterior de descarte para o fundo. Sem qualquer carta disponível, o uso é bloqueado porque não produziria efeito.

## Alternativas descartadas

- Proteger uma carta inimiga com A Lua reta. Substituído por proteger uma carta própria.
- Fazer a ficha de A Morte entrar diretamente no ataque. Descartado porque uma carta nova deve começar no descanso.
- Colocar a ficha derrotada no baralho. Descartado porque ela não pertence ao conjunto original de cartas.

## Perguntas em aberto

- Nenhuma pergunta bloqueante identificada para as 15 cartas do protótipo.

## Não aplicável a este jogo

- Ataque direto ao jogador no efeito de A Lua.
