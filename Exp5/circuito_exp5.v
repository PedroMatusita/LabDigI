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
    output [6:0] db_sequencia,
    output db_clock,
    output db_iniciar,
    output db_fimseq,
    output db_igualseq,
    output db_igualjogada,
    output db_tem_jogada,
    output db_timeout
);

    // Sinais internos para interligação dos componentes
    wire s_contaE;  
    wire s_zeraE;  
    wire s_contaL;  
    wire s_zeraL;  
    wire s_registraR; 
    wire s_fimE; 
    wire s_fimL; 
    wire s_zeraR;
    wire s_igualjogada;
    wire s_igualseq;
    wire s_jogada_feita;
    wire s_timeout;
	 wire s_pronto;
     wire s_ganhou;
     wire s_perdeu;

    wire [3:0] s_chaves;  
    wire [3:0] s_dado;
    wire [3:0] s_limite;
    wire [3:0] s_contagem;
    wire [3:0] s_memoria;
    wire [3:0] s_jogada;
    wire [3:0] s_estado;

    wire iniciar = jogar;
    
    // Instância do fluxo de dados
    fluxo_dados fluxo_dados (
        .clock(clock),
        .botoes(botoes),
        .zeraR(s_zeraR),
        .registraR(s_registraR),
        .contaE(s_contaE),
        .zeraE(s_zeraE),
        .contaL(s_contaL),
        .zeraL(s_zeraL),
        .chavesIgualMemoria(s_igualjogada),
        .enderecoIgualLimite(s_igualseq),
        .enderecoMenorouIgualLimite(),
        .fimE(s_fimE),
        .fimL(s_fimL),
        .db_tem_jogada(db_tem_jogada),
        .jogada_feita(s_jogada_feita),
        .db_contagem(s_contagem),
        .db_jogada(s_jogada),
        .db_memoria(s_memoria),
        .db_limite(s_limite),
        .timeout(s_timeout)
    );

    // Instância da unidade de controle
    unidade_controle unidade_controle (
        .clock(clock),
        .reset(reset),
        .iniciar(iniciar),
        .fimE(s_fimE),
        .jogada(s_jogada_feita),
        .timeout(s_timeout), 
        .igual(s_igualjogada),
        .enderecoIgualLimite(s_igualseq),
        .fimL(s_fimL),
        .zeraL(s_zeraL),
        .contaL(s_contaL),
        .zeraE(s_zeraE),
        .contaE(s_contaE),
        .zeraR(s_zeraR),
        .registraR(s_registraR),
        .acertou(s_ganhou),
        .errou(s_perdeu),
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

    hexa7seg disp3 (
        .hexa(s_limite),   
        .display(db_limite)
    ); 

    hexa7seg disp5 (
        .hexa(s_estado), 
        .display(db_estado)
    ); 

    // Conexão adicional
	assign pronto = s_pronto;
    assign ganhou = s_ganhou;
    assign perdeu = s_perdeu;
    assign leds = s_jogada;
   assign db_iniciar = iniciar;
   assign db_timeout = s_timeout;
   assign db_igualjogada = s_igualjogada;
   assign db_igualseq = s_igualseq;
   
   
endmodule
