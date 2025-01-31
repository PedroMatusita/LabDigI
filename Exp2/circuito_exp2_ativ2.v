/*
 * ------------------------------------------------------------------
 *  Arquivo   : circuito_exp2_ativ2-PARCIAL.v
 *  Projeto   : Experiencia 2 - Um Fluxo de Dados Simples
 * ------------------------------------------------------------------
 *  Descricao : Circuito do fluxo de dados da Atividade 2
 * 
 *     Modulo FPGA Baseado no desgin do Prof. Edson Midorikawa
 * 
 * ------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      11/01/2024  1.0     Edson Midorikawa  versao inicial
 *      12/01/2025  1.1     Thomaz Stecca     versao atualizada       
 * ------------------------------------------------------------------
 */

module circuito_exp2_ativ2 (clock, zera, carrega, conta, chaves, 
                            menor, maior, igual, fim, db_contagem);
    input        clock;
    input        zera;
    input        carrega;
    input        conta;
    input  [3:0] chaves;
    output       menor;
    output       maior;
    output       igual;
    output       fim;
    output [3:0] db_contagem;

    wire   [3:0] s_contagem;  // sinal interno para interligacao dos componentes

    // contador_163
    contador_163 contador (
      .clock( clock ),
      .clr  ( ~zera ),
      .ld   ( ~carrega ),
      .ent  ( 1'b1 ),
      .enp  ( conta ),
      .D    ( chaves[3:0] ),
      .Q    ( s_contagem ),
      .rco  ( fim )
    );

    // comparador_85
    comparador_85 comparador (
      .A   ( s_contagem ),
      .B   ( chaves[3:0] ),
      .ALBi( 1'b0 ),
      .AGBi( 1'b0 ),
      .AEBi( 1'b1 ),
      .ALBo( menor ),
      .AGBo( maior ),
      .AEBo( igual )
    );

    // saida de depuracao
    assign db_contagem = s_contagem;

 endmodule
