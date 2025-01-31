module unidade_controle (
	 input            clock,
	 input            reset,
	 input            iniciar,
	 input            fim,
	 input            jogada,
	 input            igual,
     input            timeout,            
	 output reg       zeraC,
	 output reg       contaC,
	 output reg       zeraR,
	 output reg       registraR,
	 output reg       acertou,
	 output reg       errou,
	 output reg       pronto,
	 output reg [3:0] db_estado
);


   parameter inicial    = 4'b0000; //0
   parameter inicializa = 4'b0001; //1
   parameter espera     = 4'b0100; //4
   parameter registra   = 4'b0101; //5
   parameter compara    = 4'b0110; //6   
   parameter passa      = 4'b0111; //7
   parameter acerto     = 4'b1111; //15
   parameter erro       = 4'b1110; //14

   reg [3:0] Eatual, Eprox;

   always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox;
    end

   always @* begin
      case (Eatual)
			inicial:    Eprox = iniciar ? inicializa : inicial;
			inicializa: Eprox = espera;
			espera:     Eprox = jogada  ? registra : (timeout ? erro : espera);
			registra:   Eprox = compara;
			compara:    Eprox = igual  ? (fim ? acerto : passa) : erro; 
			passa:      Eprox = espera; 
			acerto:     Eprox = iniciar ? inicializa : acerto;
			erro:       Eprox = iniciar ? inicializa : erro;
      endcase

      db_estado = Eatual;
   end

   always @* begin
      zeraC = (Eatual == inicial || Eatual == inicializa) ? 1'b1 : 1'b0;
      contaC = (Eatual == passa) ? 1'b1 : 1'b0;
      zeraR = (Eatual == inicial) ? 1'b1 : 1'b0;
      registraR = (Eatual == registra) ? 1'b1 : 1'b0;
      acertou = (Eatual == acerto) ? 1'b1 : 1'b0;
      errou = (Eatual == erro) ? 1'b1 : 1'b0;
      pronto = (Eatual == acerto || Eatual == erro) ? 1'b1 : 1'b0;
     
      
   end
   
endmodule
