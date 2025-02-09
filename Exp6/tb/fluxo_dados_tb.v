`timescale 1ns/1ns

module fluxo_dados_tb;

    // Declaração dos sinais
    reg        clock = 0;
    reg [3:0]  botoes = 4'b0000;
    reg        zeraR = 0, zeraE = 0, zeraL = 0, zeraM = 0, zeraTMR = 0;
    reg        registraR = 0, registraM = 0;
    reg        contaE = 0, contaL = 0, contaTMR = 0;

    wire       fimL, fimE, fimTMR;
    wire       jogada_feita, chavesIgualMemoria, enderecoIgualLimite, enderecoMenorOuIgualLimite, timeout;
    wire       db_tem_jogada;
    wire [3:0] db_contagem, db_jogada, db_memoria, db_limite;

    // Instância do DUT (Device Under Test)
    fluxo_dados dut (
        .clock(clock),
        .botoes(botoes),
        .zeraR(zeraR), .zeraE(zeraE), .zeraL(zeraL), .zeraM(zeraM), .zeraTMR(zeraTMR),
        .registraR(registraR), .registraM(registraM),
        .contaE(contaE), .contaL(contaL), .contaTMR(contaTMR),
        .fimL(fimL), .fimE(fimE), .fimTMR(fimTMR),
        .jogada_feita(jogada_feita), .chavesIgualMemoria(chavesIgualMemoria), 
        .enderecoIgualLimite(enderecoIgualLimite), .enderecoMenorOuIgualLimite(enderecoMenorOuIgualLimite), .timeout(timeout),
        .db_tem_jogada(db_tem_jogada),
        .db_contagem(db_contagem), .db_jogada(db_jogada), .db_memoria(db_memoria), .db_limite(db_limite)
    );

    parameter clockPeriod = 1_000_000;

    // Geração de clock (1 kHz)
    always #((clockPeriod / 2)) clock = ~clock;

    initial begin
        // Inicializa sinais
        botoes = 4'b0000;
        zeraR = 0; zeraE = 0; zeraL = 0; zeraM = 0; zeraTMR = 0;
        registraR = 0; registraM = 0;
        contaE = 0; contaL = 0; contaTMR = 0;

        // Aguarda para garantir reset inicial
        #(10*clockPeriod);

        // Teste 1: Reset dos contadores
        zeraE = 1; zeraL = 1;
        #(10*clockPeriod);
        zeraE = 0; zeraL = 0;

        // Teste 2: Contagem do contador de endereço
        contaE = 1;
        #(10*clockPeriod);
        contaE = 0;

        // Teste 3: Contagem do contador de limite
        contaL = 1;
        #(10*clockPeriod);
        contaL = 0;

        // Teste 4: Reset e carga de registradores
        zeraM = 1;
        #(10*clockPeriod);
        zeraM = 0;
        registraM = 1;
        botoes = 4'b1010;
        #(10*clockPeriod);
        registraM = 0;

        // Teste 5: Reset do temporizador
        zeraTMR = 1;
        #(10*clockPeriod);
        zeraTMR = 0;

        // Teste 6: Iniciar contagem do temporizador
        contaTMR = 1;
        #(5000*clockPeriod);
        contaTMR = 0;

        // Finaliza o testbench
        $stop;
    end

endmodule
