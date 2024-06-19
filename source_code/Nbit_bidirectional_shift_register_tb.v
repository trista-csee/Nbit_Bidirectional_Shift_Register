module Nbit_bidirectional_shift_register_tb;
   parameter MSB = 16; // parameter overriding number of bits in shift register 

   reg indata; // a variable to drive input data of the design
   reg clk; // a variable to drive input clock of the design
   reg enable; // a variable to drive input enable of the design
   reg direction; // a variable to drive input shift direction of the design
   reg resetn; // a variable to drive input reset of the design
   wire [MSB-1:0] outdata; // a wire to capture the output of the design

   // instantiate the design (16-bits shift register) by passing MSB and connect with tb signals
   Nbit_bidirectional_shift_register #(MSB) inst(
    .indata(indata),
    .clk(clk),
    .enable(enable),
    .direction(direction),
    .resetn(resetn),
    .outdata(outdata));
   
   // generate clock time period = 20ns (frequency = 50MHz)
   always #10 clk = ~clk;

   // initialize variable th default values at time 0 
   initial begin
    clk <= 0;
    resetn <= 0;
    enable <= 0;
    direction <= 0;
    indata <= 'h1;
   end

   // drive main stimulus to the design
   initial begin
    // apply reset and deassert reset after some time
    resetn <= 0;
    #20 
    resetn <= 1;
    enable <= 1;

    // for 7 clocks, drive alternate values to indata pin
    repeat(7) @(posedge clk)
    indata <= ~indata;

    // shift direction and drive alternate values to indata pin for another 7 clocks
    #10 direction <= 1;
    repeat(7) @(posedge clk)
    indata <= ~indata;

    // deive nothing for next 7 clocks and allow shift register to simply shift based on direction
    repeat(7) @(posedge clk);

    // finish the simulation
    $finish;
   end
   
   // monitor values of these variables
   initial
   $monitor("resetn=%0b enable=%0b direction=%0b indata=%b outdata=%b", resetn,enable,direction,indata,outdata);
endmodule