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
    //Controla Sequencia
    parameter INICIA_SEQUENCIA = 1;
    parameter PROXIMA_SEQUENCIA = 2;
    parameter ULTIMA_SEQUENCIA = 3;   
    //Mostra Leds
    parameter CARREGA_DADOS = 4;
    parameter MOSTRA_DADOS = 5; 
    parameter ZERA_LEDS = 6; 
    parameter MOSTRA_APAGADO = 7;
    parameter PROXIMA_POSICAO = 8;   
    //Processamento jogada
    parameter COMECO_JOGADA = 9;
    parameter ESPERA_JOGADA = 10;
    parameter REGISTRA_JOGADA = 11;
    parameter COMPARA_JOGADA = 12;   
    parameter PROXIMA_JOGADA = 13;
   
    parameter ERRO = 14;
    parameter ACERTO = 15; 


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
            INICIAL:          Eprox = iniciar ? INICIA_SEQUENCIA : INICIAL;

            INICIA_SEQUENCIA: Eprox = CARREGA_DADOS;
            PROXIMA_SEQUENCIA:Eprox = CARREGA_DADOS;          
            ULTIMA_SEQUENCIA: Eprox = fimS ? ACERTO : PROXIMA_SEQUENCIA;
          
            CARREGA_DADOS:    Eprox = MOSTRA_DADOS;
            MOSTRA_DADOS:     Eprox = fimTMR ? ZERA_LEDS : MOSTRA_DADOS;
            ZERA_LEDS:        Eprox = MOSTRA_APAGADO;
            MOSTRA_APAGADO:   Eprox = fimTMR ? (enderecoIgualSequencia ? COMECO_JOGADA : PROXIMA_POSICAO) : MOSTRA_APAGADO;
            PROXIMA_POSICAO:  Eprox = CARREGA_DADOS;
          
            COMECO_JOGADA:    Eprox = ESPERA_JOGADA; // Corrigido de "ESPERA"
            ESPERA_JOGADA:    Eprox = jogada ? REGISTRA_JOGADA : (timeout ? ERRO : ESPERA_JOGADA);
            REGISTRA_JOGADA:  Eprox = COMPARA_JOGADA; // Corrigido de "COMPARA"
            COMPARA_JOGADA:   Eprox = igual ? (enderecoIgualSequencia ? ULTIMA_SEQUENCIA : PROXIMA_JOGADA) : ERRO; 
            PROXIMA_JOGADA:   Eprox = ESPERA_JOGADA; // Corrigido de "PASSA"

            ACERTO:           Eprox = iniciar ? INICIAL : ACERTO; // Corrigido de "INICIALIZA"
            ERRO:             Eprox = iniciar ? INICIAL : ERRO;
            default:          Eprox = INICIAL; 
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
            INICIAL:          begin zeraR = 1'b1; zeraS = 1'b1; zeraM = 1'b1; zeraE = 1'b1; end
            INICIA_SEQUENCIA: begin zeraS = 1'b1; zeraE = 1'b1; end
            PROXIMA_SEQUENCIA:begin contaS = 1'b1; zeraE = 1'b1; end
            ULTIMA_SEQUENCIA: begin end // Estado vazio, mas precisa estar definido

            CARREGA_DADOS:    begin zeraTMR = 1'b1; end
            MOSTRA_DADOS:     begin contaTMR = 1'b1; registraM = 1'b1; end
            ZERA_LEDS:        begin zeraTMR = 1'b1; zeraM = 1'b1; end
            MOSTRA_APAGADO:   begin contaTMR = 1'b1; end
            PROXIMA_POSICAO:  begin contaE = 1'b1; end

            COMECO_JOGADA:    begin zeraE = 1'b1; end
            ESPERA_JOGADA:    begin end // Estado vazio

            REGISTRA_JOGADA:  begin registraR = 1'b1; end            
            COMPARA_JOGADA:   begin end // Estado vazio
            PROXIMA_JOGADA:     begin contaE = 1'b1; end

            ACERTO:           begin acertou = 1'b1; pronto = 1'b1; end
            ERRO:             begin errou = 1'b1; pronto = 1'b1; end
        endcase  
     
    end

endmodule
