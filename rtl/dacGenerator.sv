//--------------------------------------------------------------------------------
// Project:       fpga-drivers
// Author:        Shustov Aleksey (SemperAnte), semte@semte.ru
// History:
//    25.05.2021 - created
//--------------------------------------------------------------------------------
// Simple saw generator for DAC AD56x3
// with Avalon ST interface for testing purpose
//--------------------------------------------------------------------------------
module dacGenerator
   #( parameter SIGN_A = "UNSIGNED",
                SIGN_B = "UNSIGNED",
                DATA_WIDTH = 14,
                INCREASE_RATE = 1)    
    (input  logic csi_clk,
     input  logic rsi_reset,
     
     // avalon ST source
     input logic                    aso_gen_valid,
     input logic                    asi_gen_channel,
     input logic [DATA_WIDTH-1 : 0] asi_gen_data,
     output logic                   asi_gen_ready);
     
     // conduit to DAC
     output logic coe_dacSync,                                           
     output logic coe_dacSclk,              
     output logic coe_dacDin);
     
    drvAd56x3        
        #(  .SIGN_A(SIGN_A),          
            .SIGN_B(SIGN_B),                
            .DATA_WIDTH(DATA_WIDTH),                  
            .SCLK_DIVIDER(SCLK_DIVIDER), 
            .SYNC_DURATION(SYNC_DURATION))
    drvAd56x3_inst
         (.clk       (csi_clk),
          .reset     (rsi_reset),
          .asiValid  (asi_dac_valid),
          .asiChannel(asi_dac_channel),
          .asiData   (asi_dac_data),
          .asiRdy    (asi_dac_ready),
          .dacSync   (coe_dacSync),
          .dacSclk   (coe_dacSclk),
          .dacDin    (coe_dacDin));
         
endmodule