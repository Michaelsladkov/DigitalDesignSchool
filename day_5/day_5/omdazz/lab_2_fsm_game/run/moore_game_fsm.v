module moore_game_fsm 
(
    input        clk,
    input        reset,
    input [3:0]  keys,
    input        en,
	 output reg [3:0] y
);

    parameter [2:0] S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5;
	 reg [2:0] state, next_state;
	 
	 always @ (posedge clk or posedge reset)
        if (reset)
            state <= S0;
        else if (en)
            state <= next_state;
	
    always @*
        case (state)
        
        S0:
            if (keys[0])
                next_state = S1;
            else
				    if (keys[3:1] == 0)
                    next_state = S0;
				    else
					     next_state = S4;

        S1:
            if (keys[1])
                next_state = S2;
            else
				    if (keys[3:2] == 0)
                    next_state = S1;
				    else
					     next_state = S4;
		  S2:
		      if (keys[2])
				    next_state = S3;
				else
				    if (keys[3] == 0)
                    next_state = S2;
				    else
					     next_state = S4;
		  S3:
		      if (keys[3])
				    next_state = S4;
				else
					 next_state = S3;
		  S4:
		      if (keys != 4'b0)
				    next_state = S0;
				else
				    next_state = S4;

        default:

            next_state = S0;

        endcase
		  
    always @*
        case (state)
		      S0: y = 4'b1111;
				S1: y = 4'b1110;
				S2: y = 4'b1100;
				S3: y = 4'b1000;
				S4: y = 4'b0000;
				default: y = 4'b1111;
		  endcase

endmodule