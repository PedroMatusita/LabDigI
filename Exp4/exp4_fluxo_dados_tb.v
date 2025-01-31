/* --------------------------------------------------------------------
 * Arquivo   : exp4_fluxo_dados_tb.v
 * Projeto   : Experiencia 4 - Desenvolvimento de Projeto de 
 *             Circuitos Digitais em FPGA
 * --------------------------------------------------------------------
 * Descricao : Testbench Verilog do modulo exp4_fluxo_dados
 *
 *             1) Plano de teste abrangendo os estados principais
 *
 * --------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     24/01/2025  1.0     Usuario           versao inicial
 * --------------------------------------------------------------------
 */

`timescale 1ns/1ns

module exp4_fluxo_dados_tb;

  // Sinais de entrada
  reg         clock;
  reg [3:0]   chaves;
  reg         zeraR;
  reg         registraR;
  reg         contaC;
  reg         zeraC;

  // Sinais de saída
  wire        igual;
  wire        fimC;
  wire        db_tem_jogada;
  wire        jogada_feita;
  wire [3:0]  db_contagem;
  wire [3:0]  db_jogada;
  wire [3:0]  db_memoria;

  // Componente a ser testado (Device Under Test -- DUT)
  exp4_fluxo_dados dut (
    .clock        ( clock ),
    .chaves       ( chaves ),
    .zeraR        ( zeraR ),
    .registraR    ( registraR ),
    .contaC       ( contaC ),
    .zeraC        ( zeraC ),
    .igual        ( igual ),
    .fimC         ( fimC ),
    .db_tem_jogada( db_tem_jogada ),
    .jogada_feita ( jogada_feita ),
    .db_contagem  ( db_contagem ),
    .db_jogada    ( db_jogada ),
    .db_memoria   ( db_memoria )
  );

  // Configuração do clock
  parameter clockPeriod = 20; // in ns, f=50MHz

  // Gerador de clock
  always #(clockPeriod / 2) clock = ~clock;

  // Variável para controle do caso de teste
  integer caso;

  // Gera estímulos para a simulação
  initial begin
    $display("Inicio da simulacao");

    // Valores iniciais
    clock = 1'b0;
    chaves = 4'b0000;
    zeraR = 1'b0;
    registraR = 1'b0;
    contaC = 1'b0;
    zeraC = 1'b0;
    caso = 0;
    @(negedge clock); // espera borda de descida

    // Teste 1: Reset geral do circuito
    caso = 1;
    zeraC = 1'b1;
    #(clockPeriod) zeraC = 1'b0;

    // Teste 2: Registra uma jogada
    caso = 2;
    chaves = 4'b1010;
    registraR = 1'b1;
    #(clockPeriod) registraR = 1'b0;

    // Teste 3: Incrementa o contador
    caso = 3;
    contaC = 1'b1;
    #(5 * clockPeriod) contaC = 1'b0;

    // Teste 4: Verifica comparador com memória
    caso = 4;
    chaves = 4'b1010;
    registraR = 1'b1;
    #(clockPeriod) registraR = 1'b0;
    #(2 * clockPeriod);

    // Teste 5: Finaliza contagem
    caso = 5;
    contaC = 1'b1;
    #(20 * clockPeriod) contaC = 1'b0;

    // Final do testbench
    caso = 99;
    $display("Fim da simulacao");
    $stop;
  end

endmodule
