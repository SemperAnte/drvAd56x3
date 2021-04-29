// Author:        Kuznetsov Andrey, andky@inbox.ru

module test_ad56x3
    #(  parameter SIGN_A = "UNSIGNED",          // 0 for UNSIGNED, 1 for SIGNED data format
        SIGN_B = "UNSIGNED",                
        DATA_WIDTH = 14,        // width of data                
        SCLK_DIVIDER = 2,       // divide master clk frequency for dacSclk
        SYNC_DURATION = 5)      // dacSync is high between channels in cycles of dacSclk  
     (  input logic clk,                       // 25MHz on SOM-CV-SE-A6D-C3C-7I 
        input logic reset,
        input logic ce,                        // latch input data, sampling frequency of dac output
         
        input logic [DATA_WIDTH-1 : 0] dataA,  // data 14 bit, channel A
        input logic [DATA_WIDTH-1 : 0] dataB,  // data 14 bit, channel B
         
        output logic dacSync,                  // when sync is low begins write sequence
                                               // sync must be high for min 15 ns between transactions
        output logic dacSclk,                  // dac receives di on falling edge of sclk                                            
                                               // max 50 MHz
        output logic dacDin);                  // 24 bits;
    

    drvAd56x3        
        #(  .SIGN_A(SIGN_A),          
            .SIGN_B(SIGN_B),                
            .DATA_WIDTH(DATA_WIDTH),                  
            .SCLK_DIVIDER(SCLK_DIVIDER), 
            .SYNC_DURATION(SYNC_DURATION))
    adc
        (   .clk(clk),
            .reset(reset),
            .ce(ce),
            .dataA(dataA),
            .dataB(dataB),
            .dacSync(dacSync),
            .dacSclk(dacSclk),
            .dacDin(dacDin));
        
endmodule