# Arquitetura do Jogo

Este documento resume responsabilidades e conexões entre os sistemas, sem determinar detalhes de implementação.

## Preparação da partida

Responsável por atribuir orientações aos jogadores, conduzir as revelações do turno zero, escolher quem começa, devolver e embaralhar as cartas e entregar mãos e energias iniciais.

Conecta-se ao **sistema de baralhos**, ao **sistema de energia** e ao **fluxo de turnos**.

## Baralhos e cartas

Responsável pelos baralhos idênticos dos jogadores, pelas categorias ataque, suporte e especial, pelos atributos das cartas, pela compra e pelas pilhas de descarte.

Conecta-se à **preparação da partida**, aos **campos**, à **energia**, aos **efeitos especiais** e ao **combate**.

## Fluxo de turnos

Responsável por iniciar o turno com recursos automáticos a partir da segunda rodada, permitir as ações de preparação e encerrar o turno após um ataque ou por decisão do jogador.

Coordena **energia**, **baralhos e cartas**, **campos**, **efeitos especiais** e **combate**.

## Sistema de energia

Responsável por armazenar a energia de cada jogador, conceder energia por turno e validar ou pagar os custos das cartas e descartes voluntários.

É consultado por **baralhos e cartas**, **campos**, **efeitos especiais** e pela correção automática do **combate**.

## Campos

Responsável pelos espaços de descanso e ataque, seus limites e a passagem das cartas de ataque e suporte entre essas áreas.

Fornece ao **combate** as cartas atacantes e os alvos válidos e informa quando a correção contra inatividade deve ser avaliada.

## Efeitos especiais

Responsável pelos três espaços de cartas especiais de cada jogador, pelo acúmulo de efeitos, pela distinção entre efeitos contínuos e instantâneos e pela substituição de cartas ativas.

Pode alterar estados administrados por **energia**, **baralhos e cartas**, **campos** e **combate**. Os efeitos individuais estão formalizados na Spec 007, restando apenas três ambiguidades cruzadas registradas nela.

## Combate e condição de vitória

Responsável por somar o ataque do campo, distribuir dano entre alvos, persistir dano nas cartas, derrotar e descartar cartas, causar dano ao dono e encerrar a partida quando a vida de um jogador chega a zero.

Também impede inatividade prolongada por meio de aviso, movimentação automática e penalidade quando o campo de ataque permanece vazio.

## Interface da partida

Responsável por apresentar os dois jogadores em uma mesa espelhada, renderizar os espaços dos campos, preservar a privacidade das mãos, exibir atributos e efeitos e devolver ao controlador as seleções e ações do jogador.

Observa **fluxo de turnos**, **baralhos e cartas**, **campos**, **efeitos especiais** e **combate**, mas não altera diretamente seus estados. Um catálogo de apresentação fornece o texto legível dos efeitos sem executar suas regras.

