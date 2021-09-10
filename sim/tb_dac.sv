//--------------------------------------------------------------------------------
// Project:       rtllib
// Author:        Shustov Aleksey (SemperAnte), semte@semte.ru
//--------------------------------------------------------------------------------
// testbench driver DAC ad56x3
// with auto resul checking
//--------------------------------------------------------------------------------
`timescale 1 ns / 100 ps

module tb_dac();
     
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

    localparam XOR_A = (SIGN_A == "SIGNED") ? 1'b1 : 1'b0;
    localparam XOR_B = (SIGN_B == "SIGNED") ? 1'b1 : 1'b0;
   
    logic actualRdy;
    logic [SHIFT_WIDTH-1 : 0] actualA, actualB;
    logic [SHIFT_WIDTH-1 : 0] expectedA, expectedB;   
    
    enum int unsigned {ST_RDY, ST_WAIT} state;
    
    // input random data
    always_ff @(posedge clk, posedge reset) begin
        logic [DATA_WIDTH-1 : 0] dataA, dataB;
        
        if (reset) begin
            asiValid0 <= 1'b0;
            asiData0  <= 'x;
            asiValid1 <= 1'b0;
            asiData1  <= 'x;
            state     <= ST_RDY;
        end else begin
            // default
            asiValid0 <= 1'b0;        
            asiData0  <= 'x;
            asiValid1 <= 1'b0;        
            asiData1  <= 'x;       
            case (state)
                ST_RDY: begin                
                    if (asiRdy0 & asiRdy1) begin
                        asiValid0 <= 1'b1;    
                        dataA     = $urandom();
                        asiData0  <= dataA;
                        expectedA <= {2'b00,
                                      uut.drvAd56x3_coreInst.COMMAND_WORD_A,
                                      uut.drvAd56x3_coreInst.ADDRESS_WORD_A,
                                      XOR_A ^ dataA[$left(dataA)],
                                      dataA[$left(dataA)-1 : 0],
                                      {16 - DATA_WIDTH{1'b0}}}; 
                        
                        asiValid1 <= 1'b1;
                        dataB      = $urandom();
                        asiData1  <= dataB;
                        expectedB <= {2'b00,
                                     uut.drvAd56x3_coreInst.COMMAND_WORD_B,
                                     uut.drvAd56x3_coreInst.ADDRESS_WORD_B,
                                     XOR_B ^ dataB[$left(dataB)],
                                     dataB[$left(dataB)-1 : 0],
                                     {16 - DATA_WIDTH{1'b0}}};  
                        state     <= ST_WAIT;
                    end                    
                end
                ST_WAIT: begin                
                    if (asiRdy0) begin
                        state <= ST_RDY;
                    end
                end
            endcase        
        end
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