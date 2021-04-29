//--------------------------------------------------------------------------------
// Project:       fpga-drivers
// Author:        Shustov Aleksey ( SemperAnte ), semte@semte.ru
// History:
//    20.04.2021 - created
//--------------------------------------------------------------------------------
// driver DAC ad5623/ad5643/ad5663, 12/14/16 bits, dual channel
// see datasheet
//--------------------------------------------------------------------------------
module drvAd56x3    
   #( parameter SIGN_A = "UNSIGNED",          // 0 for UNSIGNED, 1 for SIGNED data format
                SIGN_B = "UNSIGNED",                
                DATA_WIDTH = 14,        // width of data                
                SCLK_DIVIDER = 2,       // divide master clk frequency for dacSclk
                SYNC_DURATION = 5)      // dacSync is high between channels in cycles of dacSclk  
    (input logic clk,                       // 25MHz on SOM-CV-SE-A6D-C3C-7I 
     input logic reset,
     input logic ce,                        // latch input data, sampling frequency of dac output
     
     input logic [DATA_WIDTH-1 : 0] dataA,  // data 14 bit, channel A
     input logic [DATA_WIDTH-1 : 0] dataB,  // data 14 bit, channel B
     
     output logic dacSync,                  // when sync is low begins write sequence
                                            // sync must be high for min 15 ns between transactions
     output logic dacSclk,                  // dac receives di on falling edge of sclk                                            
                                            // max 50 MHz
     output logic dacDin);                  // 24 bits
    
    localparam logic [2 : 0] COMMAND_WORD_A = 3'b000; // datasheet table 8-9
    localparam logic [2 : 0] COMMAND_WORD_B = 3'b010;
    localparam logic [2 : 0] ADDRESS_WORD_A = 3'b000;
    localparam logic [2 : 0] ADDRESS_WORD_B = 3'b001;
    
    localparam XOR_A = (SIGN_A == "SIGNED") ? 1'b1 : 1'b0;
    localparam XOR_B = (SIGN_B == "SIGNED") ? 1'b1 : 1'b0;
    
    localparam SHIFT_WIDTH = 24;      
    logic [SHIFT_WIDTH-1 : 0] shiftReg, shiftAReg, shiftBReg; // shift = {2'bxx, commandWord, addressWord, data, '0}    
    logic [$clog2(SHIFT_WIDTH)-1 : 0] shiftCnt; // counter 0-24
    
    logic [$clog2(SYNC_DURATION)-1 : 0] syncCnt; // count sync high duration
    
    logic startData;
    logic channel;  // A = 0, B = 1     
    logic [DATA_WIDTH-1 : 0] dataAReg, dataBReg; // latch data on ce   
    
    // sclk
    logic sclkSync;
    generate    
        if (SCLK_DIVIDER == 1) begin
            assign sclkSync = 1'b1;
            assign dacSclk = clk;
            
        end else if (SCLK_DIVIDER == 2) begin
            always_ff @(posedge clk, posedge reset)
            if (reset)
                sclkSync <= 1'b0;
            else 
                sclkSync <= ~sclkSync;            
            assign dacSclk = ~sclkSync;
            
        end else begin // > 2
            initial begin
                if ((SCLK_DIVIDER % 2) != 0) begin // must be even         
                    $error("SCLK_DIVIDER must be even.");
                    $stop;
                end
            end
        
            logic [$clog2(SCLK_DIVIDER)-1 : 0] sclkCnt;
            always_ff @(posedge clk, posedge reset)
            if (reset) begin
                sclkCnt <= '0;
            end else begin
                if (sclkCnt == SCLK_DIVIDER-1)
                    sclkCnt <= '0;                    
                else
                    sclkCnt <= sclkCnt + 1;                                                        
            end
            assign sclkSync = (sclkCnt == SCLK_DIVIDER - 1) ? 1'b1 : 1'b0; 
            assign dacSclk = (sclkCnt <= SCLK_DIVIDER/2 - 1) ? 1'b1 : 1'b0;
            
        end
    endgenerate       
    
    // latch inputs on ce
    always_ff @(posedge clk, posedge reset)
    if (reset) begin
        dataAReg <= '0;
        dataBReg <= '0;
        startData <= 1'b0;
    end else begin
        if (ce) begin
            dataAReg <= dataA;
            dataBReg <= dataB;
            startData <= 1'b1;
        end else if (sclkSync) begin
            startData <= 1'b0;
        end
    end
    
    always_comb
    begin
        shiftAReg <= {2'b00, // don't care
                      COMMAND_WORD_A,
                      ADDRESS_WORD_A,
                      XOR_A ^ dataAReg[$left(dataAReg)],
                      dataAReg[$left(dataAReg)-1 : 0],
                      {16 - DATA_WIDTH{1'b0}}};
        shiftBReg <= {2'b00,
                      COMMAND_WORD_B,
                      ADDRESS_WORD_B,
                      XOR_B ^ dataBReg[$left(dataBReg)],
                      dataBReg[$left(dataBReg)-1 : 0],
                      {16 - DATA_WIDTH{1'b0}}};
    end       
    
    always_ff @(posedge clk, posedge reset)
    if (reset) begin
        shiftCnt <= '0;
        dacSync <= 1'b1;
        syncCnt <= '0;
        channel <= 1'b0;
        shiftReg <= '0;        
    end else begin        
        if (sclkSync) begin
            if (dacSync) begin // sync      
                shiftCnt <= '0;
                if (~channel) begin // wait startData
                    shiftReg <= shiftAReg;
                    if (startData)
                        dacSync <= 1'b0;
                end else begin // second channel
                    shiftReg <= shiftBReg;
                    syncCnt <= syncCnt + 1'd1;
                    if (syncCnt === SYNC_DURATION-1)                        
                        dacSync <= 1'b0;                    
                end
            end else begin // data     
                syncCnt <= '0;
                shiftReg <= shiftReg << 1;
                shiftCnt <= shiftCnt + 1'd1;
                if (shiftCnt == SHIFT_WIDTH-1) begin                    
                    channel <= ~channel;   
                    dacSync <= 1'b1;
                end
            end            
        end
    end
    
    assign dacDin = shiftReg[$left(shiftReg)];  
        
endmodule