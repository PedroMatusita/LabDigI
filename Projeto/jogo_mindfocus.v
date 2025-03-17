
/*
 * ------------------------------------------------------------------
 *  Arquivo   : jogo_desafio_memoria.v
 *  Projeto   : P1
 * ------------------------------------------------------------------
 *  Descricao : Este arquivo contém a descrição do circuito que implementa
 * 
 *     1) Projeto FPGA
 * ------------------------------------------------------------------
 */

module jogo_mindfocus (
    input        clock, reset,
                      
    input        iniciar,
    input [3:0]  botoes,
                      
    output       pronto,
    output [3:0] acertos,
                      
    output       db_igual, db_clock, db_iniciar, db_igualjogada, db_tem_jogada,

    output [6:0] db_contagem, db_memoria, db_estado, db_jogadafeita, db_acertos
);
    /* Sinais internos */
    //Sinais de Controle
    wire s_zeraR, s_zeraE, s_zeraA;
    wire s_registraR, s_registraM;
    wire s_contaE, s_contaS, s_contaTMR;
    wire s_fimE, s_fimS, s_fimTMR; 
    //Sinais de depuração
    wire s_igual, s_igualseq, s_igualjogada, s_jogada_feita, s_timeout;
    wire [3:0]  s_sequencia, s_contagem, s_memoria, s_jogada, s_estado, s_acertos;  
    
    fluxo_dados fluxo_dados (
        .clock(clock),
                             
        .botoes(botoes),
                             
        .zeraA(), .zeraRod(),.zeraR(), .zeraM(), .zeraI(),                     
        .registraR(s_registraR), .registraM(),
        .contaRod(), .contaA(), .contaI(),
        
        .jogada_feita(s_jogada_feita), .botaoIgualMemoria(),
        rodadaIgualFinal(),

        .acertos(acertos),

        .db_tem_jogada(db_tem_jogada), 
        .db_indices(),
        .db_contagem(s_contagem), .db_jogada(s_jogada), .db_memoria(s_memoria)
    );

    unidade_controle unidade_controle (
        .clock(clock), .reset(reset), .iniciar(iniciar),
        
        .jogada_feita(s_jogada_feita), .botaoIgualMemoria(), .rodadaIgualFinal(), 
              
        .zeraR(), .zeraRod(), .zeraA(), .zeraM(), .zeraI(),        
        .registraR(), .registraM(),
        .contaRod(), .contaA(), .contaI(),
                                      
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

    hexa7seg display_acertos ( //D3
        .hexa(s_acertos),   
        .display(db_acertos)
    ); 

    hexa7seg display_estado ( // D5
        .hexa(s_estado), 
        .display(db_estado)
    ); 

    assign leds = s_memoria;
    assign db_iniciar = jogar;
    assign db_timeout = s_timeout;
    assign db_igualjogada = s_igualjogada;
   
   
endmodule
