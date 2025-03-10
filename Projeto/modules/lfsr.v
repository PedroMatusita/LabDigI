// Isso será um modulo que vai receber um valor e "Randomizar" ele usando um algoritmo de LFSR
// O modulo funciona sincronamente

module lfsr (
            input         clock, reset,
            input  [15:0] entrada,

            output reg [15:0] saida
);

   wire [15:0] s_bit;
   
   always @(posedge clock or posedge reset) begin
      if (reset) begin
         saida <= 16'b0;
     end else begin
        saida <= {s_bit[0], entrada[15:1]};
     end
   end

   assign s_bit = (entrada >> 0) ^ (entrada >> 2) ^ (entrada >> 3) ^ (entrada >> 5) & 1;

endmodule
