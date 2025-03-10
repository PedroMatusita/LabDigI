`timescale 1ns/1ps

module tb_gerador_indices;
  // Inputs
  reg         clock;
  reg         reset;
  reg [15:0]  entrada;
  
  // Outputs
  wire [7:0]  perm;
  wire        ready;
  
  // Instantiate the device under test (DUT)
  gerador_indices uut (
    .clock(clock),
    .reset(reset),
    .entrada(entrada),
    .perm(perm),
    .ready(ready)
  );
  
  // Clock generation: 10 ns period (5 ns high, 5 ns low)
  initial begin
    clock = 0;
    forever #5 clock = ~clock;
  end
  
  // Test stimulus
  initial begin
    // Initialize inputs and apply reset
    reset = 1;
    entrada = 16'd0;
    #20;          // Wait for 10 ns
    reset = 0;   // Deassert reset
    #20;
    
    // Test case 1: entrada[4:0] > 24 (should force outputs to 0)
    entrada = 16'd31; // 31 > 24
    #20;
    
    // Test case 2: entrada[4:0] = 0 (should generate permutation {0,1,2,3})
    entrada = 16'd0;
    #20;
    
    // Test case 3: entrada[4:0] = 1 (should generate permutation {0,1,3,2})
    entrada = 16'd1;
    #20;
    
    // Test case 4: entrada[4:0] = 3 (should generate permutation {0,2,3,1})
    entrada = 16'd3;
    #20;
    
    // Test case 5: entrada[4:0] = 23 (should generate permutation {3,2,1,0})
    entrada = 16'd23;
    #20;
    
    // Test case 6: entrada[4:0] = 24 
    // (since the condition is > 24, 24 is valid but not explicitly defined in the case, so it falls to default)
    entrada = 16'd24;
    #20;
    
    // Test case 7: entrada[4:0] = 12 (should generate permutation {2,0,1,3})
    entrada = 16'd12;
    #20;
    
    // End simulation
    $finish;
  end
  
  // Optional: Monitor signals
  initial begin
    $monitor("Time = %0t | reset = %b | entrada = %d | perm = %b | ready = %b",
             $time, reset, entrada, perm, ready);
  end

endmodule
