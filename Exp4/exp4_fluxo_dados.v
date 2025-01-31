/*
 * ------------------------------------------------------------------
 *  Arquivo   : exp4_fluxo_dados.v
 *  Projeto   : Experiencia 4 - Desenvolvimento de Projeto de
Circuitos Digitais em FPGA
 * ------------------------------------------------------------------
 *  Descricao : Circuito do fluxo de dados da Atividade 4
 * 
 *     1) Projeto FPGA
 * 
 * ------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      11/01/2024  1.0     Edson Midorikawa  versao inicial
 *      13/01/2025  1.1     Thomaz Stecca     experiencia 2 
 *      18/01/2025  1.2     Pedro Matusita    experiencia 3 
 *      21/01/2025  1.3     Pedro Matusita    experiencia 4 
 * ------------------------------------------------------------------
 */

module exp4_fluxo_dados (
    input clock,
    input [3:0] chaves,
    input zeraR,
    input registraR,
    input contaC,
    input zeraC,
    output igual,
    output fimC,
    output db_tem_jogada,
    output jogada_feita,
    output [3:0] db_contagem,
    output [3:0] db_jogada,
    output [3:0] db_memoria
);

    wire [3:0] s_endereco;  // sinal interno para interligacao dos componentes
    wire [3:0] s_chaves;  
    wire [3:0] s_dado;


    

    // contador_163
    contador_163 contadorJ (
      .clock( clock ),
      .clr  ( ~zeraC ),
      .ld   ( 1'h1),
      .ent  ( 1'h1 ),
      .enp  ( contaC ),
      .D    ( 4'h0 ),
      .Q    ( s_endereco ),
      .rco  ( fimC )
    );

    // comparador_85
    comparador_85 comparador (
      .A   ( s_dado ),
      .B   ( s_chaves ),
      .AEBi( 1'h1 ),
      .AEBo( igual )
    );

    // sync_rom_16x4
    sync_rom_16x4 memoria (
      .clock( clock ),
      .address ( s_endereco ),
      .data_out   ( s_dado )
    );

    // registrador_4

    registrador_4 registradorJ (
      .clock( clock ),
      .clear  ( zeraR ),
      .enable   ( registraR ),
      .D    ( chaves ),
      .Q    ( s_chaves )
    );

    edge_detector detector (
      .clock( clock ),
      .reset  ( zeraC ), // Apenas na inicialização???
      .sinal   ( |chaves ),
      .pulso    ( jogada_feita )
    );

    // saida de depuracao
    assign db_memoria = s_dado;
    assign db_jogada = s_chaves;
    assign db_contagem = s_endereco;
    assign db_tem_jogada = |chaves; // Exemplo: verifica se alguma chave está ativa.

 endmodule
