`timescale 1ns/1ns

module fluxo_dados_tb;

    // Declaração dos sinais
    reg        clock = 0;
    reg [3:0]  botoes = 4'b0000;
    reg        zeraR = 0, zeraM = 0, zeraTMR = 0;
    reg        registraR = 0, registraM = 0;
    reg        contaTMR = 0;

    wire       fimTMR;
    wire [3:0] db_memoria;

    // Instância do DUT (Device Under Test)
    fluxo_dados dut (
        .clock(clock),
        .botoes(botoes),
        .zeraR(zeraR),
        .zeraM(zeraM),
        .zeraTMR(zeraTMR),
        .registraR(registraR),
        .registraM(registraM),
        .contaTMR(contaTMR),
        .fimTMR(fimTMR),
        .db_memoria(db_memoria)
    );

    // Geração de clock
    always #5 clock = ~clock; // Clock com período de 10ns

    initial begin

        // Inicialização
        botoes = 4'b0000;
        zeraR = 0; zeraM = 0; zeraTMR = 0;
        registraR = 0; registraM = 0;
        contaTMR = 0;

        // Aguarda para garantir reset inicial
        #10;

        // Teste 1: Reset do contador TMR
        zeraTMR = 1;
        #10;
        zeraTMR = 0;

        // Inicia a contagem do contador TMR
        contaTMR = 1;
        #5000; // Aguarda o tempo para atingir o fim
        contaTMR = 0;

        // Teste 3: Registrador RegM
        zeraM = 1;
        #10;
        zeraM = 0;

        // Carrega um valor no registrador
        registraM = 1;
        botoes = 4'b1000;
        #10;
        registraM = 0;
        #10;


        // Teste 4: Sobrescreve valor no registrador RegM
        registraM = 1;
        botoes = 4'b0100;
        #10;
        registraM = 0;
        #10;

        // Finalização do testbench
        $stop;
    end

endmodule
