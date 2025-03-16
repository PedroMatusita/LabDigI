`timescale 1ns / 1ps

module GameRam_tb;

    reg clock;
    reg [6:0] gameIndex;
    reg updateRam;
    reg loadRAM;
    reg [7:0] extTotalGames;
    reg [7:0] extGamesPlayed;
    reg [127:0] extGameArray;
    wire played;
    wire [6:0] gameLocation;

    // Instanciando o módulo GameRam
    GameRam uut (
        .clock(clock),
        .gameIndex(gameIndex),
        .updateRam(updateRam),
        .loadRAM(loadRAM),
        .extTotalGames(extTotalGames),
        .extGamesPlayed(extGamesPlayed),
        .extGameArray(extGameArray),
        .played(played),
        .gameLocation(gameLocation)
    );

    // Gerador de clock
    always #5 clock = ~clock;

    initial begin
        // Inicialização
        clock = 0;
        loadRAM = 1;
        updateRam = 0;
        gameIndex = 7'd10;
        extTotalGames = 8'd100;
        extGamesPlayed = 8'd90;
        extGameArray = 128'b111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;

        #20; // Aguarda um ciclo de clock
        loadRAM = 0; // Desativando loadRAM após a carga inicial

        // Teste 1: Atualização da RAM (flip no índice 10)
        #10;
        updateRam = 1;
        #10;
        updateRam = 0;

        // Teste 2: Verificar se o bit foi alterado
        #10;
        gameIndex = 7'd10;
        #10;

        // Teste 3: Simular jogos jogados até passar de 80% de totalGames
        repeat (35) begin
            #10;
            updateRam = 1;
            #10;
            updateRam = 0;
        end

        // Teste 4: Verificar se a memória foi zerada após ultrapassar 80%
        #10;
        gameIndex = 7'd10;
        #10;

        // Finaliza a simulação
        $stop;
    end
endmodule
