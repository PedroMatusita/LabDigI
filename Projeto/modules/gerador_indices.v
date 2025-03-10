
module gerador_indices(
              input         clock, reset;
              input  [15:0] entrada;

              output reg [7:0] perm;
              output reg ready;
    );
   
    always @(posedge clock or posedge reset) begin
        if (reset || entrada[4:0] > 5'd24) begin
            indices <= 8'b0;
            ready   <= 1'b0; 
        end else begin
            case (entrada[4:0])
                5'd0:  perm <= {2'd0, 2'd1, 2'd2, 2'd3}; // permutation: 0,1,2,3
                5'd1:  perm <= {2'd0, 2'd1, 2'd3, 2'd2}; // permutation: 0,1,3,2
                5'd2:  perm <= {2'd0, 2'd2, 2'd1, 2'd3}; // permutation: 0,2,1,3
                5'd3:  perm <= {2'd0, 2'd2, 2'd3, 2'd1}; // permutation: 0,2,3,1
                5'd4:  perm <= {2'd0, 2'd3, 2'd1, 2'd2}; // permutation: 0,3,1,2
                5'd5:  perm <= {2'd0, 2'd3, 2'd2, 2'd1}; // permutation: 0,3,2,1
                5'd6:  perm <= {2'd1, 2'd0, 2'd2, 2'd3}; // permutation: 1,0,2,3
                5'd7:  perm <= {2'd1, 2'd0, 2'd3, 2'd2}; // permutation: 1,0,3,2
                5'd8:  perm <= {2'd1, 2'd2, 2'd0, 2'd3}; // permutation: 1,2,0,3
                5'd9:  perm <= {2'd1, 2'd2, 2'd3, 2'd0}; // permutation: 1,2,3,0
                5'd10: perm <= {2'd1, 2'd3, 2'd0, 2'd2}; // permutation: 1,3,0,2
                5'd11: perm <= {2'd1, 2'd3, 2'd2, 2'd0}; // permutation: 1,3,2,0
                5'd12: perm <= {2'd2, 2'd0, 2'd1, 2'd3}; // permutation: 2,0,1,3
                5'd13: perm <= {2'd2, 2'd0, 2'd3, 2'd1}; // permutation: 2,0,3,1
                5'd14: perm <= {2'd2, 2'd1, 2'd0, 2'd3}; // permutation: 2,1,0,3
                5'd15: perm <= {2'd2, 2'd1, 2'd3, 2'd0}; // permutation: 2,1,3,0
                5'd16: perm <= {2'd2, 2'd3, 2'd0, 2'd1}; // permutation: 2,3,0,1
                5'd17: perm <= {2'd2, 2'd3, 2'd1, 2'd0}; // permutation: 2,3,1,0
                5'd18: perm <= {2'd3, 2'd0, 2'd1, 2'd2}; // permutation: 3,0,1,2
                5'd19: perm <= {2'd3, 2'd0, 2'd2, 2'd1}; // permutation: 3,0,2,1
                5'd20: perm <= {2'd3, 2'd1, 2'd0, 2'd2}; // permutation: 3,1,0,2
                5'd21: perm <= {2'd3, 2'd1, 2'd2, 2'd0}; // permutation: 3,1,2,0
                5'd22: perm <= {2'd3, 2'd2, 2'd0, 2'd1}; // permutation: 3,2,0,1
                5'd23: perm <= {2'd3, 2'd2, 2'd1, 2'd0}; // permutation: 3,2,1,0
                default: perm <= 8'b0; // nao deveria ocorrer
            endcase
        end 
    end

end module 
