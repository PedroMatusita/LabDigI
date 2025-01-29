`timescale 1ns/1ps

module tb_fluxo_dados;

    // Sinais de entrada
    reg clock;
    reg [3:0] botoes;
    reg zeraR;
    reg registraR;
    reg contaE;
    reg zeraE;
    reg contaL;
    reg zeraL;

    // Sinais de saída
    wire chavesIgualMemoria;
    wire enderecoIgualLimite;
    wire enderecoMenorouIgualLimite;
    wire fimL;
    wire fimE;
    wire jogada_feita;
    wire [3:0] db_contagem;
    wire [3:0] db_jogada;
    wire [3:0] db_memoria;
    wire [3:0] db_limite;
    wire timeout;

    // Instância do módulo fluxo_dados
    fluxo_dados dut (
        .clock(clock),
        .botoes(botoes),
        .zeraR(zeraR),
        .registraR(registraR),
        .contaE(contaE),
        .zeraE(zeraE),
        .contaL(contaL),
        .zeraL(zeraL),
        .chavesIgualMemoria(chavesIgualMemoria),
        .enderecoIgualLimite(enderecoIgualLimite),
        .enderecoMenorouIgualLimite(enderecoMenorouIgualLimite),
        .fimL(fimL),
        .fimE(fimE),
        .jogada_feita(jogada_feita),
        .db_contagem(db_contagem),
        .db_jogada(db_jogada),
        .db_memoria(db_memoria),
        .db_limite(db_limite),
        .timeout(timeout)
    );

    // Geração do clock
    always #5 clock = ~clock; // Clock com período de 10 ns

    // Inicialização
    initial begin
        // Inicializa sinais
        clock = 0;
        botoes = 4'b0000;
        zeraR = 0;
        registraR = 0;
        contaE = 0;
        zeraE = 0;
        contaL = 0;
        zeraL = 0;

        // Reset inicial
        #10 zeraR = 1; zeraE = 1; zeraL = 1;
        #10 zeraR = 0; zeraE = 0; zeraL = 0;

        // Teste 1: Registra uma jogada e verifica a comparação
        #10 botoes = 4'b1010; // Jogada = 1010
        #10 registraR = 1;    // Registra a jogada
        #10 registraR = 0;

        // Avança o endereço da memória
        #10 contaE = 1;
        #10 contaE = 0;

        // Teste 2: Verifica se a jogada é igual ao dado da memória
        #10 botoes = 4'b0010; // Jogada = 0010 (igual ao dado da memória)
        #10 registraR = 1;    // Registra a jogada
        #10 registraR = 0;

        // Avança o endereço da memória
        #10 contaE = 1;
        #10 contaE = 0;

        // Teste 3: Verifica se a jogada é diferente do dado da memória
        #10 botoes = 4'b0100; // Jogada = 0101
        #10 registraR = 1;    // Registra a jogada
        #10 registraR = 0;

        // Avança o endereço da memória
        #10 contaE = 1;
        #10 contaE = 0;

        // Teste 4: Verifica o limite do contador
        #10 contaL = 1;       // Incrementa o limite
        #10 contaL = 0;

        // Finaliza a simulação
        #100 $finish;
    end

    // Monitoramento das saídas
    initial begin
        $monitor("Time: %0t | botoes: %b | jogada: %b | dado_memoria: %b | igual: %b | endereco: %b | limite: %b | timeout: %b",
                 $time, botoes, db_jogada, db_memoria, chavesIgualMemoria, db_contagem, db_limite, timeout);
    end

endmodule