module SelectGameIndex (
    input wire [127:0] gameArray, // 128-bit input array
    input wire [6:0] randomNumber, // Random starting point (0–127)
    output reg [6:0] gameIndex,  // Selected index for a bit set to 0
    output reg valid             // Indicates if a valid index was found
);

    integer i; // Used for loops
    reg [6:0] currentIndex; // Current index to check

    always @(*) begin
        valid = 0;       // Default: No valid index found
        gameIndex = 7'b0; // Default index
        currentIndex = randomNumber; // Start from the random number

        // Search for the first bit set to 0, starting from the random number
        for (i = 0; i < 128; i = i + 1) begin
            if (gameArray[currentIndex] == 0 && !valid) begin
                gameIndex = currentIndex; // Capture the index
                valid = 1;                // Mark as valid
            end
            currentIndex = (currentIndex + 1) % 128; // Wrap around if needed
        end
    end

endmodule
