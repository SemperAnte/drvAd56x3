//--------------------------------------------------------------------------------
// Project:       rtllib
// Author:        Shustov Aleksey (SemperAnte), semte@semte.ru
//--------------------------------------------------------------------------------
// driver DAC ad5623/ad5643/ad5663, 12/14/16 bits, dual channel
// see datasheet
//--------------------------------------------------------------------------------
module drvAd56x3    
   #( parameter SIGN_A = "UNSIGNED", // "UNSIGNED" or "SIGNED" data format
                SIGN_B = "UNSIGNED",         
                DATA_WIDTH    = 14,  // width of data                
                SCLK_DIVIDER  = 2,   // divide master clk frequency for dacSclk
                SYNC_DURATION = 5)   // dacSync is high between channels in cycles of dacSclk  
    (input logic                     clk,   // 25MHz on SOM-CV-SE-A6D-C3C-7I 
     input logic                     reset,
     
     // avalon MM slave
     input  logic            [2 : 0] avsAdr,
     input  logic                    avsWr,
     input  logic           [15 : 0] avsWrData,
     input  logic                    avsRd,
     output logic           [15 : 0] avsRdData,
     
     // avalon ST sink - channel 0, must be sync to channel 1
     input  logic                    asiValid0,      // sampling frequency of dac output
     input  logic [DATA_WIDTH-1 : 0] asiData0,
     output logic                    asiRdy0,    
     
     // avalon ST sink - channel 1
     input  logic                    asiValid1,
     input  logic [DATA_WIDTH-1 : 0] asiData1,
     output logic                    asiRdy1, 
     
     // conduit to DAC
     output logic                    dacSync,        // when sync is low begins write sequence
                                                     // sync must be high for min 15 ns between transactions
     output logic                    dacSclk,        // dac receives di on falling edge of sclk                                            
                                                     // max 50 MHz
     output logic                    dacDin);        // 24 bits     
    
    // for generator control
    logic          genSel;
    logic          chSwap; // swap channels
    logic [15 : 0] ceDivider;
    logic [15 : 0] incrRate0;
    logic [15 : 0] incrRate1;    
    // generator interconnection
    logic                           genValid0, genValid1;
    logic signed [DATA_WIDTH-1 : 0] genData0, genData1;
    logic                           genRdy0, genRdy1;
    // channelc interconnection
    logic                           chValid0, chValid1;
    logic signed [DATA_WIDTH-1 : 0] chData0, chData1;
    logic                           chRdy0, chRdy1;    
    // core interconnection
    logic                           coreValid0, coreValid1;
    logic signed [DATA_WIDTH-1 : 0] coreData0, coreData1;
    logic                           coreRdy0, coreRdy1;
    
    drvAd56x3_parm
    drvAd56x3_parmInst
         (.clk      (clk      ),
          .reset    (reset    ),
          .avsAdr   (avsAdr   ),
          .avsWr    (avsWr    ),
          .avsWrData(avsWrData),
          .avsRd    (avsRd    ),
          .avsRdData(avsRdData),
          .genSel   (genSel   ),
          .chSwap   (chSwap   ),
          .ceDivider(ceDivider),
          .incrRate0(incrRate0),
          .incrRate1(incrRate1));
    
    drvAd56x3_gen
        #(.DATA_WIDTH(DATA_WIDTH))
    drvAd56x3_genInst
         (.clk      (clk      ),
          .reset    (reset    ),
          .ceDivider(ceDivider),
          .incrRate0(incrRate0),
          .incrRate1(incrRate1),
          .genValid0(genValid0),
          .genData0 (genData0 ),
          .genRdy0  (genRdy0  ),
          .genValid1(genValid1),
          .genData1 (genData1 ),
          .genRdy1  (genRdy1  ));
    
    drvAd56x3_core
       #(.SIGN_A       (SIGN_A       ),          
         .SIGN_B       (SIGN_B       ),                
         .DATA_WIDTH   (DATA_WIDTH   ),                  
         .SCLK_DIVIDER (SCLK_DIVIDER ), 
         .SYNC_DURATION(SYNC_DURATION))
    drvAd56x3_coreInst
        (.clk       (clk       ),
         .reset     (reset     ),
         .coreValid0(coreValid0),
         .coreData0 (coreData0 ),
         .coreRdy0  (coreRdy0  ),
         .coreValid1(coreValid1),
         .coreData1 (coreData1 ),
         .coreRdy1  (coreRdy1  ),
         .dacSync   (dacSync   ),
         .dacSclk   (dacSclk   ),
         .dacDin    (dacDin    ));
    
    // select asi or generator
    assign chValid0 = (genSel) ? genValid0 : asiValid0;
    assign chData0  = (genSel) ? genData0  : asiData0;
    assign chValid1 = (genSel) ? genValid1 : asiValid1;
    assign chData1  = (genSel) ? genData1  : asiData1;    
    // swap channels - asi or generator
    assign coreValid0 = (chSwap) ? chValid1 : chValid0;
    assign coreData0  = (chSwap) ? chData1  : chData0;
    assign coreValid1 = (chSwap) ? chValid0 : chValid1;
    assign coreData1  = (chSwap) ? chData0  : chData1;
    
    // swap channels - rdy signals
    assign chRdy0 = (chSwap) ? coreRdy1 : coreRdy0;    
    assign chRdy1 = (chSwap) ? coreRdy0 : coreRdy1;
    // select asi or generator, set null to non-active
    assign genRdy0 = genSel & chRdy0;
    assign genRdy1 = genSel & chRdy1;    
    assign asiRdy0 = ~genSel & chRdy0;
    assign asiRdy1 = ~genSel & chRdy1;

endmodule