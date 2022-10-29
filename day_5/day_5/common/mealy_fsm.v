`include "config.vh"

module mealy_fsm
(
    input  clk,
    input  reset,
    input  en,
    input  a,
    output y
);

    parameter [2:0] S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4;

    reg [2:0] state, next_state;

    // State register

    always @ (posedge clk or posedge reset)
        if (reset)
            state <= S0;
        else if (en)
            state <= next_state;

    // Next state logic

    always @*
        case (state)
        
        S0:
            if (a)
                next_state = S1;
            else
                next_state = S0;

        S1:
            if (a)
                next_state = S1;
            else
                next_state = S2;
		  S2:
		      if (a)
				    next_state = S3;
				else
				    next_state = S0;
		  S3:
		      if (a)
				    next_state = S4;
				else
				    next_state = S2;
		  S4:
		      if (a)
				    next_state = S1;
				else
				    next_state = S0;

        default:

            next_state = S0;

        endcase

    // Output logic based on current state and inputs

    assign y = (~a & state == S4);

endmodule
