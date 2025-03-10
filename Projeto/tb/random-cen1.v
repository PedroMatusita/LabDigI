`timescale 1ns/1ns

module random_tb;

    // Declaração dos sinais
    reg        clock_in;
    reg        reset_in;
    reg  [15:0] entrada_in;
    wire [15:0] saida_out;

    // Parâmetro para a frequência do clock
    parameter clockPeriod = 10; // 10ns -> 100MHz

    // Instanciação do DUT (Device Under Test)
    random dut (
        .clock   (clock_in),
        .reset   (reset_in),
        .entrada (entrada_in),
        .saida   (saida_out)
    );

    // Gerador de clock
    always #(clockPeriod / 2) clock_in = ~clock_in;

    // Processo de simulação
    initial begin
        // Inicialização dos sinais
        clock_in   = 0;
        reset_in   = 0;
        entrada_in = 16'b0000000000000000;

        // Espera um ciclo de clock antes de começar os testes
        #clockPeriod;
        
        // Teste 1: Reset do circuito
        reset_in = 1;
        #clockPeriod;
        reset_in = 0;
        #clockPeriod;
        
        // Teste 2: Aplicando um valor inicial e verificando saída
        entrada_in = 16'b0000000000001010;
        #clockPeriod;

        // Teste 3: Alterando a entrada para outro valor
        entrada_in = 16'b0000000000001101;
        #clockPeriod;

        // Teste 4: Verificando várias iterações do LFSR
        entrada_in = 16'b1010101010101010;
        repeat (10) begin
            #clockPeriod;
        end

        // Finaliza a simulação
        $stop;
    end

endmodule
