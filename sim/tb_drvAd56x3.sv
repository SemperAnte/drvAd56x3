//--------------------------------------------------------------------------------
// Project:       fpga-drivers
// Author:        Shustov Aleksey ( SemperAnte ), semte@semte.ru
// History:
//    20.04.2021 - created
//--------------------------------------------------------------------------------
// testbench driver DAC ad56x3
//--------------------------------------------------------------------------------
`timescale 1 ns / 100 ps

module tb_drvAd56x3();
     
    localparam SIGN_A = "UNSIGNED";
    localparam SIGN_B = "SIGNED";
    localparam DATA_WIDTH = 14;
    
    localparam SCLK_DIVIDER = 2;
    localparam SYNC_DURATION = 5;
    localparam SHIFT_WIDTH = 24;   
    
    // for 25 MHz clk
    localparam time T_CLK = 1s / 25.0e6; 
    // ce minimum period to complete conversion in time
    localparam time T_CE_MIN = SCLK_DIVIDER * (SHIFT_WIDTH * 2 + SYNC_DURATION + 1) * T_CLK;
    // for 200 kHz
    localparam time T_CE = 1s / 200.0e3;
    
    logic clk;
    logic reset;
    logic ce;
   
    logic [DATA_WIDTH-1 : 0] dataA;
    logic [DATA_WIDTH-1 : 0] dataB;
    
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
      (.clk     (clk),
       .reset   (reset),
       .ce      (ce),
       .dataA   (dataA),
       .dataB   (dataB),
       .dacSync (dacSync),
       .dacSclk (dacSclk),
       .dacDin  (dacDin)); 
    
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

    localparam XOR_A = (SIGN_A == "SIGNED") ? 1'b1 : 1'b0;
    localparam XOR_B = (SIGN_B == "SIGNED") ? 1'b1 : 1'b0;
   
    logic actualRdy;
    logic [SHIFT_WIDTH-1 : 0] actualA, actualB;
    logic [SHIFT_WIDTH-1 : 0] expectedA, expectedB;   
    
    // input random data
    always begin    
        ce = 1'b0;        
        #(T_CE - T_CLK);
        dataA = $urandom();
        dataB = $urandom();
        expectedA = {2'b00,
                     uut.COMMAND_WORD_A,
                     uut.ADDRESS_WORD_A,
                     XOR_A ^ dataA[$left(dataA)],
                     dataA[$left(dataA)-1 : 0],
                     {16 - DATA_WIDTH{1'b0}}};                        
        expectedB = {2'b00,
                     uut.COMMAND_WORD_B,
                     uut.ADDRESS_WORD_B,
                     XOR_B ^ dataB[$left(dataB)],
                     dataB[$left(dataB)-1 : 0],
                     {16 - DATA_WIDTH{1'b0}}};                              
        ce = 1'b1;
        #(T_CLK);
        ce = 1'b0;
        dataA = 'x;
        dataB = 'x;                
    end    
    
    // extract data from dacDin
    logic [SHIFT_WIDTH-1 : 0] shiftReg, shiftComb;
    assign shiftComb = {shiftReg[$left(shiftReg)-1: 0], dacDin};    
    
    always_ff @(posedge reset, negedge dacSclk) begin          
        logic [$clog2(SHIFT_WIDTH)-1 : 0] shiftCnt;
        logic dataChannel;
        
        if (reset) begin
            actualRdy <= 1'b0;
            shiftReg <= '0;
            shiftCnt <= '0;
            dataChannel <= 1'b0;
        end else begin 
            actualRdy <= 1'b0;
            if (~dacSync) begin
                shiftReg <= shiftComb;                        
                if (shiftCnt == SHIFT_WIDTH-1) begin
                    shiftCnt <= '0;      
                    dataChannel <= ~dataChannel;
                    if (~dataChannel) begin
                        actualA <= shiftComb;
                    end else begin                                    
                        actualB <= shiftComb;
                        actualRdy <= 1'b1;                        
                    end
                end else begin
                    shiftCnt <= shiftCnt + 1;
                end
            end
        end
    end
    
    // compare
    always_ff @(posedge actualRdy)
    begin            
        if (expectedA == actualA) begin
            $display("Data on channel A is correct.");
        end else begin                
            $error("Data on channel A isn't correct.");
            $stop;
        end
        if (expectedB == actualB) begin
            $display("Data on channel B is correct.");
        end else begin
            $error("Data on channel B isn't correct.");
            $stop;
        end
    end
   
endmodule