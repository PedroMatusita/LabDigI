/*
 * ------------------------------------------------------------------
 *  Arquivo   : circuito_exp6.v
 *  Projeto   : Experiencia 6 
 * ------------------------------------------------------------------
 *  Descricao : Este arquivo contém a descrição do circuito que implementa
 * 
 *     1) Projeto FPGA
 * ------------------------------------------------------------------
 */

module circuito_exp6 (
    input        clock,
    input        reset,
                      
    input        jogar,
    input [3:0]  botoes,
                      
    output       ganhou,
    output       perdeu,
    output       pronto,
    output [3:0] leds,
                      
    output       db_igual,
    output [6:0] db_contagem,
    output [6:0] db_memoria,
    output [6:0] db_estado,
    output [6:0] db_jogadafeita,
    output [6:0] db_sequencia,
    output       db_clock,
    output       db_iniciar,
    output       db_fimseq,
    output       db_igualseq,
    output       db_igualjogada,
    output       db_tem_jogada,
    output       db_timeout
);

    //Sinais de Controle
    wire s_contaE, s_zeraE, s_fimE, s_contaL, s_zeraL, s_fimL, s_registraR, s_zeraR, s_registraM, s_zeraM, s_contaTMR, s_zeraTMR, s_fimTMR; 
    //Sinais de saída
    wire [3:0] s_leds;
    //Sinais de depuração
    wire s_igual,s_igualseq, s_igualjogada, s_jogada_feita, s_timeout;
    wire [3:0]  s_limite, s_contagem, s_memoria, s_jogada, s_estado;  
    
    fluxo_dados fluxo_dados (
        .clock(clock),
                             
        .botoes(botoes),
        .zeraR(s_zeraR),
        .registraR(s_registraR),
        .contaE(s_contaE),
        .zeraE(s_zeraE),
        .contaL(s_contaL),
        .zeraL(s_zeraL),
        .registraM(s_registraM),
        .zeraM(s_zeraM),
        .contaTMR(s_contaTMR),
        .zeraTMR(s_zeraTMR),
        .chavesIgualMemoria(s_igualjogada),
        .enderecoIgualLimite(s_igualseq),
        .enderecoMenorouIgualLimite(),
        .fimE(s_fimE),
        .fimL(s_fimL),
        .fimTMR(s_fimTMR),
        .db_tem_jogada(db_tem_jogada),
        .jogada_feita(s_jogada_feita),
        .db_contagem(s_contagem),
        .db_jogada(s_jogada),
        .db_memoria(s_memoria),
        .db_limite(s_limite),
        .timeout(s_timeout)
    );

    unidade_controle unidade_controle (
        .clock(clock),
        .reset(reset),
        .iniciar(jogar),
        .fimE(s_fimE),
        .jogada(s_jogada_feita),
        .timeout(s_timeout), 
        .igual(s_igualjogada),
        .enderecoIgualLimite(s_igualseq),
        .fimL(s_fimL),
        .fimTMR(s_fimTMR),
        .zeraL(s_zeraL),
        .contaL(s_contaL),
        .zeraE(s_zeraE),
        .contaE(s_contaE),
        .zeraR(s_zeraR),
        .registraR(s_registraR),
        .registraM(s_registraM),
        .zeraM(s_zeraM),
        .contaTMR(s_contaTMR),
        .zeraTMR(s_zeraTMR),
        .acertou(ganhou),
        .errou(perdeu),
        .pronto(pronto),
        .db_estado(s_estado)
    );




   
    hexa7seg display_contagem ( //D0
        .hexa(s_contagem),
        .display(db_contagem)
    );
   
    hexa7seg display_memoria ( //D1
        .hexa(s_memoria),   
        .display(db_memoria)
    );
   
   hexa7seg display_jogada ( //D2
        .hexa(s_jogada), 
        .display(db_jogadafeita)
    ); 

    hexa7seg display_sequencia ( //D3
        .hexa(s_limite),   
        .display(db_sequencia)
    ); 

   hexa7seg display_estado ( // D5
        .hexa(s_estado), 
        .display(db_estado)
    ); 

    assign db_iniciar = jogar;
    assign db_timeout = s_timeouts;
    assign db_igualjogada = s_igualjogada;
    assign db_igualseq = s_igualseq;
   
   
endmodule
