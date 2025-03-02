// Asynchronous reset here is needed for the FPGA board we use

module top
(
    input        clk,
    input        reset_n,
    
    input  [3:0] key_sw,
    output [3:0] led,

    output [7:0] abcdefgh,
    output [3:0] digit,

    output       buzzer,

    output       hsync,
    output       vsync,
    output [2:0] rgb
);

    wire reset = ~ reset_n;

    //assign abcdefgh  = 8'hff;
    //assign digit     = 4'hf;
    assign buzzer    = 1'b0;
    assign hsync     = 1'b1;
    assign vsync     = 1'b1;
    assign rgb       = 3'b0;
    
    //------------------------------------------------------------------------

    logic [31:0] cnt;
    
    always_ff @ (posedge clk or posedge reset)
      if (reset)
        cnt <= 32'b0;
      else
        cnt <= cnt + 32'b1;
        
    wire enable = (cnt [24:0] == 25'b0);

    //------------------------------------------------------------------------
    /*
    wire button_on = ~ key_sw [0];
	 
	 wire drop = ~ key_sw[3];

    logic [3:0] shift_reg;
    
    always_ff @ (posedge clk or posedge reset)
      if (reset)
        shift_reg <= 4'b0;
		else if (drop)
		  shift_reg <= 4'b0;
      else if (enable)
        shift_reg <= { button_on | shift_reg[0], shift_reg [3:1] };

    assign led = ~ shift_reg;
	 
	 */

    // Exercise 1: Make the light move in the opposite direction.

    // Exercise 2: Make the light moving in a loop.
    // Use another key to reset the moving lights back to no lights.

    // Exercise 3: Display the state of the shift register
    // on a seven-segment display, moving the light in a circle.
	 wire button_on = ~ key_sw [0];
	 
	 wire drop = ~ key_sw[3];

    logic [5:0] shift_reg;
    
    always_ff @ (posedge clk or posedge reset)
      if (reset)
        shift_reg <= 6'b0;
		else if (drop)
		  shift_reg <= 6'b0;
      else if (enable)
        shift_reg <= { button_on | shift_reg[0], shift_reg [5:1] };
    
	 assign digit = 4'b1110;
	 assign abcdefgh = {~shift_reg[5:0], 2'b11};
	 assign led = ~ shift_reg[3:0];

endmodule
