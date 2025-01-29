/*
 * ------------------------------------------------------------------
 *  Arquivo   : exp4_fluxo_dados.v
 *  Projeto   : Experiencia 5 - Projeto Lógico de Várias Jogadas
 * ------------------------------------------------------------------
 *  Descricao : Circuito do fluxo de dados da Atividade 5
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
 *      21/01/2025  1.4     Pedro Matusita    experiencia 5
 * ------------------------------------------------------------------
 */

module fluxo_dados (
    input clock,
    input [3:0] botoes,
    input zeraR,
    input registraR,
    input contaE,
    input zeraE,
    input contaL,
    input zeraL,
    output chavesIgualMemoria,
    output enderecoIgualLimite,
    output enderecoMenorouIgualLimite,
    output fimL,
    output fimE,
    output jogada_feita,
    output [3:0] db_contagem,
    output [3:0] db_jogada,
    output [3:0] db_memoria,
    output [3:0] db_limite,
    output  timeout
);

    // Sinais internos
    wire [3:0] s_limite;
    wire [3:0] s_jogada;
    wire [3:0] s_dado;
    wire [3:0] s_endereco;
    

    // contador_163
    contador_163 ContLmt (
      .clock( clock ),
      .clr  ( ~zeraL ),
      .ld   ( 1'h1),
      .ent  ( 1'h1 ),
      .enp  ( contaL ),
      .D    ( 4'h0 ),
      .Q    ( s_limite ),
      .rco  ( fimL )
    );

    contador_163 ContEnd (
      .clock( clock ),
      .clr  ( ~zeraE ),
      .ld   ( 1'h1),
      .ent  ( 1'h1 ),
      .enp  ( contaE ),
      .D    ( 4'h0 ),
      .Q    ( s_endereco ),
      .rco  ( fimE )
    );

    // comparador_85
    comparador_85 CompJog (
      .A   ( s_dado ),
      .B   ( s_jogada ),
      .AEBi( 1'h1 ),
      .AGBi( 1'h0 ),
      .ALBi( 1'h0 ),
      .ALBo(  ),
      .AGBo(  ),
      .AEBo( chavesIgualMemoria )
    );

    comparador_85 CompLmt (
      .A   ( s_limite ),
      .B   ( s_endereco ),
      .AEBi( 1'h1 ),
      .AGBi( 1'h0 ),
      .ALBi( 1'h0 ),
      .ALBo(  ),
      .AGBo( enderecoMenorouIgualLimite ),
      .AEBo( enderecoIgualLimite )
    );

    // sync_rom_16x4
    sync_rom_16x4 MemJog (
      .clock( clock ),
      .address ( s_endereco ),
      .data_out   ( s_dado )
    );

    // registrador_4

    registrador_4 RegBotoes (
      .clock( clock ),
      .clear  ( zeraR ),
      .enable   ( registraR ),
      .D    ( botoes ),
      .Q    ( s_jogada )
    );

    edge_detector detector (
      .clock( clock ),
      .reset  ( zeraC ), // Apenas na inicialização
      .sinal   ( s_tem_jogada ),
      .pulso    ( jogada_feita )
    );

   contador_m #(.M(3000), .N(12)) contador_timeout (
      .clock( clock ), 
      .zera_s(),
      .zera_as( contaE || zeraE ),
      .conta( !s_tem_jogada && !timeout && !pronto ),             
      .Q(),
      .fim(timeout),
      .meio()
   );
   
    assign s_tem_jogada = |botoes;  // se saida do contador for exatamente igual 
	 
    // saida de depuracao
    assign db_memoria = s_dado;
    assign db_jogada = s_jogada;
    assign db_contagem = s_endereco;
    assign db_limite = s_limite;
    assign db_tem_jogada = s_tem_jogada; // Exemplo: verifica se alguma chave está ativa.
	  
	 
 endmodule
