/*
 * ------------------------------------------------------------------
 *  Arquivo   : circuito_exp5.v
 *  Projeto   : Experiencia 5 - Projeto de um Jogo de Sequências de Jogadas
 * ------------------------------------------------------------------
 *  Descricao : Este arquivo contém a descrição do circuito que implementa
 * 
 *     1) Projeto FPGA
 * ------------------------------------------------------------------
 */

module circuito_exp5 (
    input clock,
    input reset,
    input jogar,
    input [3:0] botoes,
    output ganhou,
    output perdeu,
    output pronto,
    output [3:0] leds,
    output db_igual,
    output [6:0] db_contagem,
    output [6:0] db_memoria,
    output [6:0] db_estado,
    output [6:0] db_jogadafeita,
    output db_clock,
    output db_iniciar,
    output db_tem_jogada,
    output db_timeout
);

    // Sinais internos para interligação dos componentes
    wire s_contaC;  
    wire s_registraR; 
    wire s_zeraC; 
    wire s_zeraR;
    wire s_igual;
    wire s_fimC;
    wire s_jogada_feita;
    wire s_timeout;
	 wire s_pronto;
    wire [3:0] s_chaves;  
    wire [3:0] s_dado;
    wire [3:0] s_contagem;
    wire [3:0] s_memoria;
    wire [3:0] s_jogada;
    wire [3:0] s_estado;
    
    // Instância do fluxo de dados
    fluxo_dados fluxo_dados (
        .clock(clock),
        .chaves(chaves),
        .zeraR(s_zeraR),
        .registraR(s_registraR),
        .contaC(s_contaC),
        .zeraC(s_zeraC),
        .igual(s_igual),
        .fimC(s_fimC),
		  .pronto( s_pronto ),
        .db_tem_jogada(db_tem_jogada),
        .jogada_feita(s_jogada_feita),
        .db_contagem(s_contagem),
        .db_jogada(s_jogada),
        .db_memoria(s_memoria),
        .timeout(s_timeout)
    );

    // Instância da unidade de controle
    unidade_controle unidade_controle (
        .clock(clock),
        .reset(reset),
        .iniciar(iniciar),
        .fim(s_fimC),
        .jogada(s_jogada_feita),
        .timeout(s_timeout), 
        .igual(s_igual),
        .zeraC(s_zeraC),
        .contaC(s_contaC),
        .zeraR(s_zeraR),
        .registraR(s_registraR),
        .acertou(acertou),
        .errou(errou),
        .pronto(s_pronto),
        .db_estado(s_estado)
    );

    // Instâncias dos displays
    hexa7seg disp2 (
        .hexa(s_jogada), 
        .display(db_jogadafeita)
    ); 

    hexa7seg disp0 (
        .hexa(s_contagem),
        .display(db_contagem)
    ); 

    hexa7seg disp1 (
        .hexa(s_memoria),   
        .display(db_memoria)
    ); 

    hexa7seg disp5 (
        .hexa(s_estado), 
        .display(db_estado)
    ); 

    // Conexão adicional
	assign pronto = s_pronto;
   assign db_iniciar = iniciar;
   assign db_timeout = s_timeout;
   
   
endmodule
