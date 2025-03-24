
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

    output [6:0] db_contagem, db_estado, db_jogadafeita, db_acertos, db_indice0, db_indice1, db_indice2, db_indice3
);
    /* Sinais internos */
    //Sinais de Controle
    wire s_zeraA, s_zeraRod, s_zeraR, s_zeraM, s_zeraI;
    wire s_registraR, s_registraM;
    wire s_contaRod, s_contaA, s_contaI;
	 wire s_indiceReady;
    //Sinais de depuração
    wire s_botaoIgual, s_rodadaIgual, s_jogada_feita;
    wire [3:0]  s_sequencia, s_contagem, s_memoria, s_jogada, s_estado, s_acertos, indice0, indice1, indice2, indice3 ;  
    wire [7:0] index;
    
    fluxo_dados fluxo_dados (
        .clock(clock),
                             
        .botoes(botoes),
                             
        .zeraA(s_zeraA), .zeraRod(s_zeraRod),.zeraR(s_zeraR), .zeraM(s_zeraM), .zeraI(s_zeraI),                     
        .registraR(s_registraR), .registraM(s_registraM),
        .contaRod(s_contaRod), .contaA(s_contaA), .contaI(s_contaI),
        
        .jogada_feita(s_jogada_feita), .botaoIgualMemoria(s_botaoIgual),
        .rodadaIgualFinal(s_rodadaIgual), .indiceReady(s_indiceReady),

        .acertos(acertos),

        .db_tem_jogada(db_tem_jogada), 
        .db_indices(index),
        .db_contagem(s_contagem), .db_jogada(s_jogada), .db_memoria(s_memoria)
    );

    unidade_controle unidade_controle (
        .clock(clock), .reset(reset), .iniciar(iniciar),
        
        .jogada_feita(s_jogada_feita), .botaoIgualMemoria(s_botaoIgual), .rodadaIgualFinal(s_rodadaIgual), .indiceReady(s_indiceReady),
              
        .zeraR(s_zeraR), .zeraRod(s_zeraRod), .zeraA(s_zeraA), .zeraM(s_zeraM), .zeraI(s_zeraI),        
        .registraR(s_registraR), .registraM(s_registraM),
        .contaRod(s_contaRod), .contaA(s_contaA), .contaI(s_contaI),
                                      
        .pronto(pronto),
        
        .db_estado(s_estado)
    );

    assign indice0 = {2'b00, index[1:0]};
    assign indice1 = {2'b00, index[3:2]};
    assign indice2 = {2'b00, index[5:4]};
    assign indice3 = {2'b00, index[7:6]};
   
   hexa7seg display_indice0 ( //D0
        .hexa(indice0),
        .display(db_indice0)
    );

    hexa7seg display_indice1 ( //D1
        .hexa(indice1),
        .display(db_indice1)
    );

    hexa7seg display_indice2 ( //D2
        .hexa(indice2),
        .display(db_indice2)
    );

    hexa7seg display_indice3 ( //D3
        .hexa(indice3),
        .display(db_indice3)
    );
    

//    hexa7seg display_acertos ( //D4
//        .hexa(s_acertos),   
//        .display(db_acertos)
//    ); 
	 
    hexa7seg display_acertos ( //D4
        .hexa(s_contagem),   
        .display(db_acertos)
    ); 

    hexa7seg display_estado ( // D5
        .hexa(s_estado), 
        .display(db_estado)
    ); 

	assign db_igualjogada = s_botaoIgual;
	assign db_clock = clock;
	assign s_acertos = acertos;
	assign db_igual = s_rodadaIgual;
   
   
endmodule
