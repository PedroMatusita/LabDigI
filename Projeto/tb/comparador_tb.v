`timescale 1ns/1ns

module comparador_jog_tb;

    // Sinais para conectar com o DUT
    reg  [7:0] A_in;
    reg  [3:0] B_in;
    wire       acerto_out;
    
    // Identificação do caso de teste
    reg [31:0] caso = 0;

    // Instanciação do DUT (Device Under Test)
    comparador_jog dut (
        .A      ( A_in      ),
        .B      ( B_in      ),
        .acerto ( acerto_out )
    );

    initial begin
        // Condições iniciais
        caso = 0;
        A_in = 8'b00000000;
        B_in = 4'b0000;
        #10;
        
        // Teste 1: Nenhum bit de A é "00", então acerto deve ser 0
        caso = 1;
        A_in = 8'b11111111;
        B_in = 4'b1111;
        #10;

        // Teste 2: Primeiro grupo de bits de A é "00" e B[3] é 1
        caso = 2;
        A_in = 8'b00111111;
        B_in = 4'b1000;
        #10;

        // Teste 3: Último grupo de bits de A é "00" e B[0] é 1
        caso = 3;
        A_in = 8'b11100100;
        B_in = 4'b0001;
        #10;
        
        // Teste 4: Vários grupos de A são "00" e bits correspondentes de B são 1
        caso = 4;
        A_in = 8'b00000000;
        B_in = 4'b1111;
        #10;

        // Teste 5: Nenhum bit de B ativo, acerto deve ser 0
        caso = 5;
        A_in = 8'b00000000;
        B_in = 4'b0000;
        #10;
        
        // Final dos testes
        caso = 99;
        #10;
        $display("Fim da simulação");
        $stop;
    end

endmodule
