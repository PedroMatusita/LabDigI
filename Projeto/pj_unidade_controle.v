module unidade_controle (
    input            clock, reset, iniciar,
    //Controle                     
    input            jogada_feita, botaoIgualMemoria, rodadaIgualFinal,

    // input            fimE,

    output reg       zeraR, zeraRod, zeraA, zeraM, zeraI,

    output reg       registraR, registraM,
    output reg       contaRod, contaA, contaI,
    //Saida                         
    output reg       pronto,
    //Depuracao                     
    output reg [3:0] db_estado
);


    parameter INICIAL = 0;
    parameter INICIO_JOGO = 1;
    //Preparação
    parameter PROXIMA_RODADA = 3;
    parameter MOSTRA_PERGUNTA = 4;
    parameter ZERA_TIMER = 5;
    //Jogadas
    parameter ESPERA_JOGADA = 7;   
    parameter COMPARA_JOGADA = 8;
    parameter REGISTRA_JOGADA = 9;
    parameter ACERTO = 10;
    //Fim de Jogo
    parameter FIM_JOGO = 15;    


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

            PROXIMA_RODADA:     Eprox = MOSTRA_PERGUNTA;
            // MOSTRA_PERGUNTA:    Eprox =  ? ZERA_TIMER : MOSTRA_PERGUNTA;   implementar a troca de imagem de pergunta
            MOSTRA_PERGUNTA:    Eprox = ESPERA_JOGADA;       
           //ZERA_TIMER:         Eprox = ESPERA_JOGADA;          
          
            // ESPERA_JOGADA:      Eprox = volta ? MOSTRA_PERGUNTA : (jogada ? REGISTRA_JOGADA : ESPERA_JOGADA);
            ESPERA_JOGADA:      Eprox = jogada_feita ? REGISTRA_JOGADA : ESPERA_JOGADA;
            REGISTRA_JOGADA:    Eprox = COMPARA_JOGADA;
            COMPARA_JOGADA:     Eprox = botaoIgualMemoria ? ACERTO : PROXIMA_RODADA; // (rodadaIgualFinal ? FIM_JOGO : PROXIMA_RODADA);
            ACERTO:             Eprox = rodadaIgualFinal ? FIM_JOGO : PROXIMA_RODADA;

            FIM_JOGO:           Eprox = iniciar ? INICIAL : FIM_JOGO; // fim do jogo
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


        contaRod   = 1'b0;
        contaA     = 1'b0;
        contaI     = 1'b1;


        registraR  = 1'b0;
        registraM  = 1'b0;


        pronto     = 1'b0;
        

        // Seta valores dependendo do Estado
        case (Eatual)
            INICIAL:             begin zeraI= 1'b1; zeraR = 1'b1; zeraRod = 1'b1; zeraM = 1'b1; zeraA = 1'b1; contaI = 1'b0; end
            INICIO_JOGO:         begin  end
            PROXIMA_RODADA:      begin registraM = 1'b1; contaRod = 1'b1; end
            MOSTRA_PERGUNTA:     begin end // Estado vazio, mas precisa estar definido

            ZERA_TIMER:          begin  end

            ESPERA_JOGADA:       begin end 
            REGISTRA_JOGADA:     begin registraR = 1'b1; end            
            COMPARA_JOGADA:      begin end // Estado vazio
            ACERTO:              begin contaA = 1'b1; end 

            FIM_JOGO:            begin zeraI = 1'b1; pronto = 1'b1; end
        endcase  
     
    end

endmodule