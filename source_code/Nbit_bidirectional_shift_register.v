module Nbit_bidirectional_shift_register #(parameter MSB=8) (
    input indata, // input for data to the first flop in the shift register
    input clk, // input for clock to all flops in the shift register
    input enable, // input for enable to switch the shift register on/off
    input direction, // input to shift in either left or right direction
    input resetn, // input to reset the register to a default value
    output reg [MSB-1:0] outdata // output to read out the current value of all flops in the register
);

// triggered on the rising edge of clock
always @(posedge clk) begin
    // first check to see if reset is 0 then reset the register
    if (!resetn)
       outdata <= 0;
    else begin
       // if reset is not 0 then check to see if the shidt register is enabled
       // if enabled then shift based on the required direction
       if (enable) begin
          case (direction)
            0 : outdata <= {outdata[MSB-2:0],indata}; // Shift left
            1 : outdata <= {indata,outdata[MSB-1:1]}; // Shift right
          endcase
       end
       // if unenabled then maintain previous output 
       else
          outdata <= outdata;
    end
end

endmodule