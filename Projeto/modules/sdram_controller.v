module sdram_controller (
    input wire clk,               // System Clock
    input wire reset_n,           // Active-low reset
    input wire [24:0] addr,       // Address (Row, Column, Bank)
    input wire [15:0] data_in,    // Data input
    output reg [15:0] data_out,   // Data output
    input wire rd,                // Read enable
    input wire wr,                // Write enable
    output reg ready,             // Ready signal
    inout wire [15:0] sdram_dq,   // Data bus
    output reg [12:0] sdram_addr, // Address bus
    output reg [1:0] sdram_ba,    // Bank address
    output reg sdram_cs_n,        // Chip select
    output reg sdram_ras_n,       // Row address strobe
    output reg sdram_cas_n,       // Column address strobe
    output reg sdram_we_n,        // Write enable
    output reg [1:0] sdram_dqm    // Data mask
);

    // SDRAM Command Definitions
    localparam CMD_NOP     = 4'b0111;
    localparam CMD_ACTIVE  = 4'b0011;
    localparam CMD_READ    = 4'b0101;
    localparam CMD_WRITE   = 4'b0100;
    localparam CMD_PRECH   = 4'b0010;
    localparam CMD_REFRESH = 4'b0001;
    localparam CMD_LOAD    = 4'b0000;

    // State Machine Definitions
    typedef enum reg [3:0] {
        INIT,
        IDLE,
        ACTIVATE,
        READ,
        WRITE,
        PRECHARGE,
        REFRESH
    } state_t;

    state_t state;

    reg [15:0] data_buffer;
    reg [3:0] refresh_counter;

    assign sdram_dq = (state == WRITE) ? data_buffer : 16'bz; // Tri-state buffer for data

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= INIT;
            ready <= 0;
            refresh_counter <= 0;
        end else begin
            case (state)
                INIT: begin
                    sdram_cs_n <= 0;
                    sdram_ras_n <= 1;
                    sdram_cas_n <= 1;
                    sdram_we_n <= 1;
                    refresh_counter <= 0;
                    state <= IDLE;
                end

                IDLE: begin
                    ready <= 1;
                    if (rd) begin
                        state <= ACTIVATE;
                    end else if (wr) begin
                        state <= ACTIVATE;
                    end
                end

                ACTIVATE: begin
                    sdram_addr <= addr[24:12]; // Row Address
                    sdram_ba <= addr[11:10]; // Bank Address
                    sdram_ras_n <= 0;
                    sdram_cas_n <= 1;
                    sdram_we_n <= 1;
                    state <= rd ? READ : WRITE;
                end

                READ: begin
                    sdram_addr <= {4'b0000, addr[9:0]}; // Column Address
                    sdram_ras_n <= 1;
                    sdram_cas_n <= 0;
                    sdram_we_n <= 1;
                    #2 data_out <= sdram_dq;
                    state <= IDLE;
                end

                WRITE: begin
                    sdram_addr <= {4'b0000, addr[9:0]};
                    sdram_ras_n <= 1;
                    sdram_cas_n <= 0;
                    sdram_we_n <= 0;
                    data_buffer <= data_in;
                    state <= IDLE;
                end

                PRECHARGE: begin
                    sdram_ras_n <= 0;
                    sdram_cas_n <= 1;
                    sdram_we_n <= 0;
                    state <= IDLE;
                end

                REFRESH: begin
                    sdram_ras_n <= 0;
                    sdram_cas_n <= 0;
                    sdram_we_n <= 1;
                    refresh_counter <= refresh_counter + 1;
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule
