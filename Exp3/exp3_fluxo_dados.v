/*
 * ------------------------------------------------------------------
 *  Arquivo   : exp3_fluxo_dados.v
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

module exp3_fluxo_dados (
    input clock,
    input [3:0] chaves,
    input zeraR,
    input registraR,
    input contaC,
    input zeraC,
    output chavesIgualMemoria,
    output fimC,
    output [3:0] db_contagem,
    output [3:0] db_chaves,
    output [3:0] db_memoria
);

    wire [3:0] s_endereco;  // sinal interno para interligacao dos componentes
    wire [3:0] s_chaves;  
    wire [3:0] s_dado;  


    

    // contador_163
    contador_163 contador (
      .clock( clock ),
      .clr  ( ~zeraC ),
      .ld   ( 1'b1),
      .ent  ( 1'b1 ),
      .enp  ( contaC ),
      .D    ( 1'b0 ),
      .Q    ( s_endereco ),
      .rco  ( fimC )
    );

    // comparador_85
    comparador_85 comparador (
      .A   ( s_dado ),
      .B   ( s_chaves ),
      .AEBi( 1'b1 ),
      .AEBo( chavesIgualMemoria )
    );

    // sync_rom_16x4
    sync_rom_16x4 memoria (
      .clock( clock ),
      .address ( s_endereco ),
      .data_out   ( s_dado )
    );

    // registrador_4

    registrador_4 registrador (
      .clock( clock ),
      .clear  ( zeraR ),
      .enable   ( registraR ),
      .D    ( chaves ),
      .Q    ( s_chaves )
    );

    // saida de depuracao
    assign db_memoria = s_dado;
    assign db_chaves = s_chaves;
    assign db_contagem = s_endereco;

 endmodule
