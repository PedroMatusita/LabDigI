
module registrador_m #(
    parameter BITS = 4 
) (
    input        clock,
    input        clear,
    input        enable,
    input  [BITS-1:0] D,
    output [BITS-1:0] Q
);

    reg [BITS-1:0] IQ;

    always @(posedge clock or posedge clear) begin
        if (clear)
            IQ <= 0;
        else if (enable)
            IQ <= D;
    end

    assign Q = IQ;

endmodule
