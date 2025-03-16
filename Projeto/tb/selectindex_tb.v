`timescale 1ns / 1ps

module tb_SelectGameIndex;
    // Sinais de entrada
    reg [127:0] gameArray;
    reg [6:0] randomNumber;
    
    // Sinais de saída
    wire [6:0] gameIndex;
    wire valid;
    
    // Instancia o módulo a ser testado
    SelectGameIndex uut (
        .gameArray(gameArray),
        .randomNumber(randomNumber),
        .gameIndex(gameIndex),
        .valid(valid)
    );
    
    initial begin
        // Inicializa sinais
        gameArray = 128'b1111111111111111111111111111111111111111111111111111111111111111_1111111111111111111111111111111111111111111111111111111111111111; // Todos os bits em 1 (sem zeros)
        randomNumber = 7'd50;
        #10;
        
        // Caso 1: Nenhum bit 0 disponível
        $display("Caso 1 - Nenhum bit 0 disponível");
        if (!valid) $display("OK: Nenhum índice válido encontrado");
        else $display("ERRO: Índice encontrado %d", gameIndex);
        
        // Caso 2: Um bit 0 na posição 60
        gameArray = 128'b1111111111111111111111111111111111111111111111111111111111101111_1111111111111111111111111111111111111111111111111111111111111111; // Apenas o bit 60 está em 0
        randomNumber = 7'd50;
        #10;
        
        $display("Caso 2 - Bit 60 em 0");
        if (valid && gameIndex == 7'd60) $display("OK: Índice encontrado corretamente: %d", gameIndex);
        else $display("ERRO: Índice incorreto %d", gameIndex);
        
        // Caso 3: Primeiro bit 0 na posição 10, começando do 5
        gameArray = 128'b1111111111111111111111111111111111111111111111111111101111111111_1111111111111111111111111111111111111111111111111111111111111111; // Bit 10 está em 0
        randomNumber = 7'd5;
        #10;
        
        $display("Caso 3 - Primeiro bit 0 na posição 10");
        if (valid && gameIndex == 7'd10) $display("OK: Índice correto %d", gameIndex);
        else $display("ERRO: Índice incorreto %d", gameIndex);
        
        // Caso 4: Bit 0 na posição 3, começando do 120
        gameArray = 128'b0111111111111111111111111111111111111111111111111111111111111111_1111111111111111111111111111111111111111111111111111111111111111; // Bit 3 está em 0
        randomNumber = 7'd120;
        #10;
        
        $display("Caso 4 - Bit 0 na posição 3");
        if (valid && gameIndex == 7'd3) $display("OK: Índice correto %d", gameIndex);
        else $display("ERRO: Índice incorreto %d", gameIndex);
        
        // Finaliza a simulação
        $finish;
    end
endmodule
