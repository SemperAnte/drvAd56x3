//--------------------------------------------------------------------------------
// Project:       rtllib
// Author:        Shustov Aleksey (SemperAnte), semte@semte.ru
//--------------------------------------------------------------------------------
// testbench for DAC generator and DAC driver connected with Avalon interface
//--------------------------------------------------------------------------------
`timescale 1 ns / 100 ps

module tb_gen();
     
    localparam SIGN_A = "UNSIGNED";
    localparam SIGN_B = "SIGNED";
    localparam DATA_WIDTH = 14;
    
    localparam SCLK_DIVIDER = 2;
    localparam SYNC_DURATION = 5;
    localparam SHIFT_WIDTH = 24;   
    
    // for 25 MHz clk
    localparam time T_CLK = 1s / 25.0e6; 
    
    logic clk;
    logic reset;
    
    // avalon MM slave
    logic  [2 : 0] avsAdr = '0;
    logic          avsWr = 1'b0;
    logic [15 : 0] avsWrData = '0;
    logic          avsRd = 1'b0;
    logic [15 : 0] avsRdData;
   
    logic                    asiValid0;
    logic [DATA_WIDTH-1 : 0] asiData0;
    logic                    asiRdy0;
    
    logic                    asiValid1;
    logic [DATA_WIDTH-1 : 0] asiData1;
    logic                    asiRdy1;
    
    logic dacSync;
    logic dacSclk;
    logic dacDin;
   
    drvAd56x3
    #(.SIGN_A(SIGN_A),
      .SIGN_B(SIGN_B),
      .DATA_WIDTH(DATA_WIDTH),
      .SCLK_DIVIDER(SCLK_DIVIDER),
      .SYNC_DURATION(SYNC_DURATION))
    uut
      (.clk      (clk      ),
       .reset    (reset    ),
       .avsAdr   (avsAdr   ),
       .avsWr    (avsWr    ),
       .avsWrData(avsWrData),
       .avsRd    (avsRd    ),
       .avsRdData(avsRdData),
       .asiValid0(asiValid0),
       .asiData0 (asiData0 ),
       .asiRdy0  (asiRdy0  ),
       .asiValid1(asiValid1),
       .asiData1 (asiData1 ),
       .asiRdy1  (asiRdy1  ),
       .dacSync  (dacSync  ),
       .dacSclk  (dacSclk  ),
       .dacDin   (dacDin   ));
    
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
    
    // write via avalon ST
    task avsWrite(input int adr,
                  input int val);
        avsWr = 1'b1;
        avsAdr = adr;
        avsWrData = val;
        #(T_CLK);
        avsWr = 1'b0;
        avsAdr = '0;
        avsWrData = '0;
    endtask
    
    // read from avalon ST
    task avsRead(input  int adr,
                 output int val);
        avsRd = 1'b1;
        avsAdr = adr;
        #(T_CLK);
        avsRd = 1'b0;
        avsAdr = '0;
        val = avsRdData;
    endtask
    
    initial begin
        static int adr = 0;
        logic signed [15 : 0] tbRdData;
    
        @(negedge reset);
        #(10 * T_CLK);        
        avsWrite(0, 1'b1);
        avsWrite(1, 1'b1);
        avsWrite(2, 1'b1);        
        avsWrite(3, 200);
        avsWrite(4, 2);
        avsWrite(5, -2);
        avsRead(3, tbRdData);
        assert (tbRdData == 200) else $error("Not correct read data.");
        avsRead(4, tbRdData);
        assert (tbRdData == 2) else $error("Not correct read data.");
        avsRead(5, tbRdData);
        assert (tbRdData == -2) else $error("Not correct read data.");
        
    end
   
endmodule