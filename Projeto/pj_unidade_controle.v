module unidade_controle (
    input            clock, reset, iniciar, voltar, 
    //Controle                     
    input            jogada_feita, botaoIgualMemoria, rodadaIgualFinal, indiceReady, timeout_img,

    // input            fimE,

    output reg       zeraR, zeraRod, zeraA, zeraM, zeraI, zeraContImg, 

    output reg       registraR, registraM,
    output reg       contaRod, contaA, contaI, contaimg,
    //Saida                         
    output reg       pronto,
    //Depuracao                     
    output reg [3:0] db_estado
);


    parameter INICIAL = 0;
    parameter INICIO_JOGO = 1;
    //Preparação
    parameter PROXIMA_RODADA = 3;
	 parameter GERA_INDICE = 6;
    //Jogadas
    parameter ESPERA_JOGADA = 7;   
    parameter COMPARA_JOGADA = 8;
    parameter REGISTRA_JOGADA = 9;
    parameter ACERTO = 10; //A
	 parameter MOSTRA_IMAGEM = 11; //B
	 parameter ERRO = 13;//D
    //Fim de Jogo
    parameter FIM_JOGO = 15; // F    


    reg [3:0] Eatual, Eprox;

    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= INICIAL;
        else
            Eatual <= Eprox;
    end


    // Correção dos estados
    always @* begin
        case (Eatual)
            INICIAL:            Eprox = iniciar ? INICIO_JOGO : INICIAL;
            INICIO_JOGO:        Eprox = PROXIMA_RODADA;

            PROXIMA_RODADA:     Eprox = GERA_INDICE;
            // MOSTRA_PERGUNTA:    Eprox =  ? ZERA_TIMER : MOSTRA_PERGUNTA;   implementar a troca de imagem de pergunta
				MOSTRA_IMAGEM:      Eprox = timeout_img ?  ESPERA_JOGADA: MOSTRA_IMAGEM;
				
				GERA_INDICE:		  Eprox = indiceReady ? MOSTRA_IMAGEM : GERA_INDICE;
          
            // ESPERA_JOGADA:      Eprox = volta ? MOSTRA_PERGUNTA : (jogada ? REGISTRA_JOGADA : ESPERA_JOGADA);
            ESPERA_JOGADA:      Eprox = voltar ? MOSTRA_IMAGEM : (jogada_feita ? REGISTRA_JOGADA : ESPERA_JOGADA);
            REGISTRA_JOGADA:    Eprox = COMPARA_JOGADA;
            COMPARA_JOGADA:     Eprox = botaoIgualMemoria ? ACERTO : ERRO;
				ERRO: 				  Eprox = rodadaIgualFinal ? FIM_JOGO : PROXIMA_RODADA;
            ACERTO:             Eprox = rodadaIgualFinal ? FIM_JOGO : PROXIMA_RODADA;

            FIM_JOGO:           Eprox = INICIAL; // fim do jogo
            default:            Eprox = INICIAL; 
        endcase
        db_estado = Eatual;
    end

    // Logica de Saida
    always @* begin
        // Zera todos valores 
        zeraR      = 1'b0;
        zeraRod    = 1'b0;
        zeraA      = 1'b0;
        zeraM      = 1'b0;
        zeraI      = 1'b0;
        zeraContImg = 1'b0;


        contaRod   = 1'b0;
        contaA     = 1'b0;
        contaI     = 1'b1;


        registraR  = 1'b0;
        registraM  = 1'b0;


        pronto     = 1'b0;
        

        // Seta valores dependendo do Estado
        case (Eatual)
            INICIAL:             begin  zeraI = 1'b1; zeraR = 1'b1; zeraRod = 1'b1; zeraM = 1'b1; zeraA = 1'b1; contaI = 1'b0; end
            INICIO_JOGO:         begin  end
            PROXIMA_RODADA:      begin registraM = 1'b1; contaRod = 1'b1; zeraContImg= 1'b1; end
				MOSTRA_IMAGEM:       begin contaimg = 1'b1; end
            ESPERA_JOGADA:       begin end 
				GERA_INDICE:         begin end
            REGISTRA_JOGADA:     begin registraR = 1'b1; end            
            COMPARA_JOGADA:      begin end // Estado vazio
            ACERTO:              begin contaA = 1'b1; end 
				ERRO: 					begin end
            FIM_JOGO:            begin zeraI = 1'b1; pronto = 1'b1; end
        endcase  
     
    end

endmodule
