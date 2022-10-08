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

    assign buzzer = 1'b0;
    assign hsync  = 1'b1;
    assign vsync  = 1'b1;
    assign rgb    = 3'b0;
    
    //------------------------------------------------------------------------

    logic [31:0] cnt;
    
    always_ff @ (posedge clk or posedge reset)
      if (reset)
        cnt <= 32'b0;
      else
        cnt <= cnt + 32'b1;

    wire enable = (cnt [23:0] == 24'b0);

    //------------------------------------------------------------------------

    logic [15:0] shift_reg;
    
    always_ff @ (posedge clk or posedge reset)
      if (reset)
        shift_reg <= 16'b0000000000001111;
      else if (enable)
        shift_reg <= { shift_reg [0], shift_reg [15:1] };

    assign led = ~ shift_reg[3:0];

    //------------------------------------------------------------------------

    //   --a--
    //  |     |
    //  f     b
    //  |     |
    //   --g--
    //  |     |
    //  e     c
    //  |     |
    //   --d--  h
    //
    //  0 means light

    typedef enum bit [7:0]
    {
        A = 8'b00010001,
        B = 8'b11000001,
        C = 8'b01100011,
	     H = 8'b10010001,
        I = 8'b10011111,
        K = 8'b01010001,
        L = 8'b11100011,
		  O = 8'b00000011,
        P = 8'b00110001,
        S = 8'b01001001,
        U = 8'b10000011,
        EMPTY = 8'b11111111
    }
    letters;
	 
	 letters letter;
	 letter [15:0] line;
	 assign line[0] = C;
	 assign line[1] = O;
	 assign line[2] = O;
	 assign line[3] = L;
    
    always_comb
    begin
      case (shift_reg)
      16'b0000000000001000: letter = C;
      16'b0000000000000100: letter = O;
      16'b0000000000000010: letter = O;
      16'b0000000000000001: letter = L;
      default: letter = EMPTY;
      endcase
    end

    assign abcdefgh = letter;
    assign digit    = ~ shift_reg[3:0];

    // Exercise 1: Increase the frequency of enable signal
    // to the level your eyes see the letters as a solid word
    // without any blinking. What is the threshold of such frequency?

    // Exercise 2: Put your name or another word to the display.

    // Exercise 3: Comment out the "default" clause from the "case" statement
    // in the "always" block,and re-synthesize the example.
    // Are you getting any warnings or errors? Try to explain why.

endmodule
