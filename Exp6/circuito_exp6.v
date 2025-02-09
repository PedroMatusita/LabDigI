
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
    input        clock, reset,
                      
    input        jogar,
    input [3:0]  botoes,
                      
    output       ganhou, perdeu, pronto,
    output [3:0] leds,
                      
    output       db_igual, db_clock, db_iniciar, db_fimseq, db_igualseq, db_igualjogada, db_tem_jogada, db_timeout,
    output [6:0] db_contagem, db_memoria, db_estado, db_jogadafeita, db_sequencia
);
    /* Sinais internos */
    //Sinais de Controle
    wire s_zeraR, s_zeraE, s_zeraL, s_zeraM, s_zeraTMR;
    wire s_registraR, s_registraM;
    wire s_contaE, s_contaL, s_contaTMR;
    wire s_fimE, s_fimL, s_fimTMR; 
    //Sinais de depuração
    wire s_igual, s_igualseq, s_igualjogada, s_jogada_feita, s_timeout;
    wire [3:0]  s_sequencia, s_contagem, s_memoria, s_jogada, s_estado;  
    
    fluxo_dados fluxo_dados (
        .clock(clock),
                             
        .botoes(botoes),
                             
        .zeraR(s_zeraR), .zeraE(s_zeraE), .zeraL(s_zeraL), .zeraM(s_zeraM), .zeraTMR(s_zeraTMR),                     
        .registraR(s_registraR), .registraM(s_registraM),
        .contaE(s_contaE), .contaL(s_contaL), .contaTMR(s_contaTMR),
        .fimE(s_fimE), .fimL(s_fimL), .fimTMR(s_fimTMR),
        
        .jogada_feita(s_jogada_feita), .chavesIgualMemoria(s_igualjogada), .enderecoIgualSequencia(s_igualseq), .enderecoMenorOuIgualSequencia(), .timeout(s_timeout),
                
        .db_tem_jogada(db_tem_jogada), .db_contagem(s_contagem), .db_jogada(s_jogada), .db_memoria(s_memoria), .db_sequencia(s_sequencia)
    );

    unidade_controle unidade_controle (
        .clock(clock), .reset(reset), .iniciar(jogar),
        
        .jogada(s_jogada_feita), .igual(s_igualjogada), .timeout(s_timeout), .enderecoIgualSequencia(s_igualseq), 
        
        .fimE(s_fimE), .fimL(s_fimL), .fimTMR(s_fimTMR),        
        .zeraR(s_zeraR), .zeraE(s_zeraE), .zeraL(s_zeraL), .zeraM(s_zeraM), .zeraTMR(s_zeraTMR),        
        .registraR(s_registraR), .registraM(s_registraM),
        .contaE(s_contaE), .contaL(s_contaL), .contaTMR(s_contaTMR),
                                      
        .acertou(ganhou), .errou(perdeu), .pronto(pronto),
        
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
        .hexa(s_sequencia),   
        .display(db_sequencia)
    ); 

    hexa7seg display_estado ( // D5
        .hexa(s_estado), 
        .display(db_estado)
    ); 

    assign leds = s_memoria;
    assign db_iniciar = jogar;
    assign db_timeout = s_timeout;
    assign db_igualjogada = s_igualjogada;
    assign db_igualseq = s_igualseq;
   
   
endmodule
