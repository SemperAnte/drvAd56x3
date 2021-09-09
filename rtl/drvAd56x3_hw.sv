//--------------------------------------------------------------------------------
// Project:       rtllib
// Author:        Shustov Aleksey (SemperAnte), semte@semte.ru
//--------------------------------------------------------------------------------
// top-level wrapper for qsys automatic signal recognition
// for detailed signal description see comments in bottom module
//--------------------------------------------------------------------------------
module drvAd56x3_hw
   #( parameter SIGN_A = "UNSIGNED",
                SIGN_B = "UNSIGNED",
                DATA_WIDTH    = 14,    
                SCLK_DIVIDER  = 2,   
                SYNC_DURATION = 5)    
    (input  logic                   csi_clk,
     input  logic                   rsi_reset,
     
     // avalon MM slave
     input  logic           [2 : 0] avs_dac_address,
     input  logic                   avs_dac_write,
     input  logic          [15 : 0] avs_dac_writedata,
     input  logic                   avs_dac_read,
     output logic          [15 : 0] avs_dac_readdata,
     
     // avalon ST sink - channel 0
     input logic                    asi_dac_ch0_valid,
     input logic [DATA_WIDTH-1 : 0] asi_dac_ch0_data,
     output logic                   asi_dac_ch0_ready,
     
     // avalon ST sink - channel 1
     input logic                    asi_dac_ch1_valid,
     input logic [DATA_WIDTH-1 : 0] asi_dac_ch1_data,
     output logic                   asi_dac_ch1_ready,
     
     // conduit to DAC
     output logic                   coe_dacSync,                                           
     output logic                   coe_dacSclk,              
     output logic                   coe_dacDin);
     
    drvAd56x3        
       #(.SIGN_A       (SIGN_A       ),          
         .SIGN_B       (SIGN_B       ),                
         .DATA_WIDTH   (DATA_WIDTH   ),                  
         .SCLK_DIVIDER (SCLK_DIVIDER ), 
         .SYNC_DURATION(SYNC_DURATION))
    drvAd56x3_inst
         (.clk      (csi_clk          ),
          .reset    (rsi_reset        ),
          .avsAdr   (avs_dac_address  ),
          .avsWr    (avs_dac_write    ),
          .avsWrData(avs_dac_writedata),
          .avsRd    (avs_dac_read     ),
          .avsRdData(avs_dac_readdata ),          
          .asiValid0(asi_dac_ch0_valid),          
          .asiData0 (asi_dac_ch0_data ), 
          .asiRdy0  (asi_dac_ch0_ready),
          .asiValid1(asi_dac_ch1_valid),
          .asiData1 (asi_dac_ch1_data ),
          .asiRdy1  (asi_dac_ch1_ready),
          .dacSync  (coe_dacSync      ),
          .dacSclk  (coe_dacSclk      ),
          .dacDin   (coe_dacDin       ));    
         
endmodule