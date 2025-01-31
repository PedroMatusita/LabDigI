/*
 * ------------------------------------------------------------------
 *  Arquivo   : circuito_exp3.v
 *  Projeto   : Experiencia 3 - Projeto de uma Unidade de Controle
 * ------------------------------------------------------------------
 *  Descricao : Circuito do fluxo de dados da Atividade 3
 * 
 *     1) Projeto FPGA
 * 
 * ------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      11/01/2024  1.0     Edson Midorikawa  versao inicial
 *      13/01/2025  1.1     Thomaz Stecca     experiencia 2 
 *      18/01/2025  1.2     Pedro Matusita    experiencia 3 
 * ------------------------------------------------------------------
 */

module circuito_exp3 (
    clock,
    reset,
    iniciar,
    chaves,
    pronto,
    db_igual,
    db_iniciar,
    db_contagem,
    db_memoria,
    db_chaves,
    db_estado
);

 input clock;
 input reset;
 input iniciar;
 input [3:0] chaves;
 output pronto;
 output db_igual;
 output db_iniciar;
 output [6:0] db_contagem;
 output [6:0] db_memoria;
 output [6:0] db_chaves;
 output [6:0] db_estado;

 wire   s_contaC;  // sinal interno para interligacao dos componentes
 wire   s_registraR; 
 wire   s_zeraC; 
 wire   s_zeraR;
 wire   s_fimC;
 wire   [3:0] s_chaves;  
 wire   [3:0] s_dado;
 wire   [3:0] s_estado;
    

    // fluxo de dados
    exp3_fluxo_dados fluxo_dados (
      .clock( clock ),
      .chaves  ( chaves ),
      .contaC   ( s_contaC),
      .registraR  ( s_registraR ),
      .zeraR ( s_zeraR ),
      .zeraC    ( s_zeraC ),
      .db_contagem    ( s_contagem ),
      .db_chaves    ( s_chaves ),
      .db_memoria    ( s_endereco ),
      .fimC    ( s_fimC ),
      .chavesIgualMemoria  ( db_igual )
    );

    // unidade de controle
    exp3_unidade_controle unidade_controle (
      .clock( clock ),
      .reset( reset ),
      .iniciar( iniciar ),
      .fimC( s_fimC ),
      .zeraC( s_zeraC ),
      .contaC( s_contaC ),
      .zeraR( s_zeraR ),
      .registraR( s_registraR ),
      .pronto( pronto ),
      .db_estado( s_estado )
    );

    // Displays
    hexa7seg disp2 (
        .hexa(s_chaves), 
        .display(db_chaves)); 


    hexa7seg disp0 (
        .hexa(s_contagem),
        .display(db_contagem)); 


    hexa7seg disp1 (
        .hexa(s_endereco),   
        .display(db_memoria)); 


    hexa7seg disp5 (
        .hexa(s_estado), 
        .display(db_estado)); 


      
      assign db_iniciar = iniciar;

 endmodule
