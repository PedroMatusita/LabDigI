module unidade_controle (
    input            clock, reset, iniciar,
    //Controle                     
    input            jogada, igual, timeout, enderecoIgualSequencia, 
    input            fimE, fimS, fimTMR,
    output reg       zeraR, zeraE, zeraS, zeraM, zeraTMR, zeraL,
    output reg       registraR, registraM,
    output reg       contaE, contaS, contaTMR,
    //Saida                         
    output reg       acertou, errou, pronto,
    //Depuracao                     
    output reg [3:0] db_estado
);


    parameter INICIAL = 0;
    //Preparação
    parameter PROXIMA_RODADA = 3;
    parameter MOSTRA_PERGUNTA = 4;
    parameter ZERA_TIMER = 5;
    //Jogadas
    parameter ESPERA_JOGADA = 7;   
    parameter COMPARA_JOGADA = 8;
    parameter REGISTRA_JOGADA = 9;
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
            INICIAL:            Eprox = iniciar ? PROXIMA_RODADA : INICIAL;

            PROXIMA_RODADA:     Eprox = CARREGA_DADOS;
            MOSTRA_PERGUNTA:    Eprox = fimTMR ? ZERA_TIMER : MOSTRA_PERGUNTA;          
            ZERA_TIMER:         Eprox = ESPERA_JOGADA;          
          
            ESPERA_JOGADA:      Eprox = volta ? MOSTRA_PERGUNTA : (jogada ? REGISTRA_JOGADA : ESPERA_JOGADA);
            REGISTRA_JOGADA:    Eprox = COMPARA_JOGADA;
            COMPARA_JOGADA:     Eprox = fim ? FIM_JOGO : PROXIMA_RODADA;

            FIM_JOGO:           Eprox = iniciar ? INICIAL : FIM_JOGO; // fim do jogo
            default:            Eprox = INICIAL; 
        endcase
        db_estado = Eatual;
    end

    // Logica de Saida
    always @* begin
        // Zera todos valores 
        zeraE      = 1'b0;
        contaE     = 1'b0;
        contaS     = 1'b0;
        zeraS      = 1'b0;
        registraR  = 1'b0;
        zeraR      = 1'b0;
        acertou    = 1'b0;
        errou      = 1'b0;
        pronto     = 1'b0;
        registraM  = 1'b0;
        zeraM      = 1'b0;
        contaTMR   = 1'b0;
        zeraTMR    = 1'b0;
        

        // Seta valores dependendo do Estado
        case (Eatual)
            INICIAL:             begin zeraR = 1'b1; zeraS = 1'b1; zeraM = 1'b1; zeraE = 1'b1; end
            PROXIMA_RODADA:      begin contaS = 1'b1; zeraE = 1'b1; end
            MOSTRA_PERGUNTA:     begin end // Estado vazio, mas precisa estar definido

            ZERA_TIMER:          begin zeraTMR = 1'b1; end

            ESPERA_JOGADA:       begin end // Estado vazio

            REGISTRA_JOGADA:     begin registraR = 1'b1; end            
            COMPARA_JOGADA:      begin end // Estado vazio
            PROXIMA_JOGADA:      begin contaE = 1'b1; end

            FIM_JOGO:            begin errou = 1'b1; pronto = 1'b1; end
        endcase  
     
    end

endmodule
