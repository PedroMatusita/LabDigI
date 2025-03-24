module GameRam (
	input wire clock, 
    input wire [6:0] gameIndex,   // 7-bit signal to select one of the 128 bits
    input wire updateRam,        // Signal to toggle updates
    input wire loadRAM,          // Signal to load external values into RAM
    input wire [7:0] extTotalGames,  // External value for totalGames
    input wire [7:0] extGamesPlayed, // External value for gamesPlayed
    input wire [127:0] extGameArray, // External 128-bit array
    output reg played,           // MSB of the selected bit (same as bit value here)
    output reg [6:0] gameLocation // The selected bit's index
);

    // Registers and memory
    reg [7:0] totalGames;        // 8-byte register for totalGames
    reg [7:0] gamesPlayed;       // 8-byte register for gamesPlayed
    reg [127:0] gameArray;       // 128-bit array

    integer i; // Used for loops

reg temp;
always @(posedge clock) begin
    if (loadRAM) begin
        totalGames <= extTotalGames;
        gamesPlayed <= extGamesPlayed;
        gameArray <= extGameArray;
    end else if (updateRam) begin
        if ((gamesPlayed * 100) / totalGames > 80) begin
            gamesPlayed <= 0;
            gameArray <= 128'b0;
        end else begin
            gamesPlayed <= gamesPlayed + 1;
            temp = gameArray[gameIndex]; // Lê antes de escrever
            gameArray[gameIndex] <= ~temp; 
        end
    end
    played <= gameArray[gameIndex]; 
    gameLocation <= gameIndex;
end


endmodule
