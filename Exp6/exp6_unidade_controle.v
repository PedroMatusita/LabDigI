module unidade_controle (
    input            clock,
    input            reset,
    input            iniciar,
                         
    input            jogada,
    input            igual,
    input            timeout,
    input            enderecoIgualLimite,
                         
    input            fimL, 
    input            fimTMR,
    input            fimE,
                         
    output reg       zeraL,
    output reg       contaL,
    output reg       zeraE,
    output reg       contaE,
    output reg       zeraR,
    output reg       registraR,
    output reg       registraM,
    output reg       zeraM,
    output reg       contaTMR,
    output reg       zeraTMR,
                         
    output reg       acertou,
    output reg       errou,
    output reg       pronto,
                         
    output reg [3:0] db_estado
);


   parameter INICIAL = 0;
   parameter INICIALIZA = 1;
   parameter INICIA_SEQUENCIA = 2;

   parameter ESPERA = 4;
   parameter REGISTRA = 5;
   parameter COMPARA = 6;   
   parameter PASSA = 7;
   parameter ULTIMA_SEQUENCIA = 8;
   
   parameter ATIVA_LED = 9; 
   parameter PROXIMO_LED = 10; 

   parameter COMECO_JOGADA = 11;
   parameter ERR0 = 14;
   parameter ACERTO = 15; 


   reg [3:0] Eatual, Eprox;

   always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= INICIAL;
        else
            Eatual <= Eprox;
    end


   //Logica de próximo estado
   always @* begin
       case (Eatual)
           INICIAL:          Eprox = iniciar ? INICIALIZA : INICIAL;
           INICIALIZA:       Eprox = INICIA_SEQUENCIA;
           INICIA_SEQUENCIA: Eprox = ESPERA;
           ATIVA_LED:        Eprox = fimTMR ? PROXIMO_LED : ATIVA_LED;
           PROXIMO_LED:      Eprox = enderecoIgualLimite ? COMECO_JOGADA : ATIVA_LED;
           COMECO_JOGADA:    Eprox = ESPERA;
           ESPERA:           Eprox = jogada ? REGISTRA : (timeout ? ERRO : ESPERA);
           REGISTRA:         Eprox = COMPARA;
           COMPARA:          Eprox = igual ? (enderecoIgualLimite ? ULTIMA_SEQUENCIA : PASSA) : ERRO; 
           PASSA:            Eprox = ESPERA; 
           ULTIMA_SEQUENCIA: Eprox = fimL ? ACERTO : INICIA_SEQUENCIA;
           ACERTO:           Eprox = iniciar ? INICIALIZA : ACERTO;
           ERRO:             Eprox = iniciar ? INICIALIZA : ERRO;
           default:          Eprox = INICIAL; 
       endcase

      db_estado = Eatual;
   end

   // Logica de Saida
   always @* begin
       // Zera todos valores 
       zeraE      = 1'b0;
       contaE     = 1'b0;
       contaL     = 1'b0;
       zeraL      = 1'b0;
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
           INICIA_SEQUENCIA, COMECO_JOGADA: zeraE = 1'b1;
           PASSA:                           contaE = 1'b1;
           ULTIMA_SEQUENCIA:                contaL = 1'b1;
           INICIAL, INICIALIZA:             begin zeraR = 1'b1; zeraL = 1'b1; zeraM = 1'b1; end
           REGISTRA:                        registraR = 1'b1;
           ACERTO:                          begin acertou = 1'b1; pronto = 1'b1; end
           ERRO:                            begin errou = 1'b1; pronto = 1'b1; end
           PROXIMO_LED, INICIA_SEQUENCIA:   registraM = 1'b1;
           ATIVA_LED:                       contaTMR = 1'b1;
           PROXIMO_LED:                     zeraTMR = 1'b1;
       endcase      
   end
   
endmodule
