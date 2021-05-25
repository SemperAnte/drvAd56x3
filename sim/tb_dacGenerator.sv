//--------------------------------------------------------------------------------
// Project:       fpga-drivers
// Author:        Shustov Aleksey ( SemperAnte ), semte@semte.ru
// History:
//    25.06.2021 - created
//--------------------------------------------------------------------------------
// testbench for DAC generator and DAC driver connected with Avalon interface
//--------------------------------------------------------------------------------
`timescale 1 ns / 100 ps

module tb_dacGenerator();
     
    localparam SIGN_A = "UNSIGNED";
    localparam SIGN_B = "UNSIGNED";
    localparam DATA_WIDTH = 14;
    localparam INCREASE_RATE = 1;
    
    // for 25 MHz clk
    localparam time T_CLK = 1s / 25.0e6;
    
    logic clk;
    logic reset;
   
    logic                    asiValid;
    logic                    asiChannel;
    logic [DATA_WIDTH-1 : 0] asiData;
    logic                    asiRdy;
    
    logic dacSync;
    logic dacSclk;
    logic dacDin;
    
    logic                    asoValid;
    logic                    asoChannel;
    logic [DATA_WIDTH-1 : 0] asoData;
    logic                    asoRdy;
   
    drvAd56x3
    #(.SIGN_A(SIGN_A),
      .SIGN_B(SIGN_B),
      .DATA_WIDTH(DATA_WIDTH))
    uutDac
      (.clk       (clk),
       .reset     (reset),
       .asiValid  (asiValid),
       .asiChannel(asiChannel),
       .asiData   (asiData),
       .asiRdy    (asiRdy),
       .dacSync   (dacSync),
       .dacSclk   (dacSclk),
       .dacDin    (dacDin));
       
    dacGenerator
    #(.DATA_WIDTH(DATA_WIDTH),
      .INCREASE_RATE(INCREASE_RATE))
    uutGen
      (.clk       (clk),
       .reset     (reset),
       .asoValid  (asoValid),
       .asoChannel(asoChannel),
       .asoData   (asoData),
       .asoRdy    (asoRdy));
   
    assign asiValid = asoValid;
    assign asiChannel = asoChannel;
    assign asiData = asoData;
    assign asoRdy = asiRdy;
    
    // clk
    always begin   
        clk = 1'b1;
        #(T_CLK/2);
        clk = 1'b0;
        #(T_CLK/2);
    end
   
    // reset
    initial begin   
        reset = 1'b1;
        #(10*T_CLK + T_CLK/2);
        reset = 1'b0;
    end
   
endmodule