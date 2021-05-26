//--------------------------------------------------------------------------------
// Project:       fpga-drivers
// Author:        Shustov Aleksey (SemperAnte), semte@semte.ru
// History:
//    25.05.2021 - created
//--------------------------------------------------------------------------------
// top-level wrapper for qsys automatic signal recognition
//--------------------------------------------------------------------------------
module dacGenerator_hw
   #( parameter CE_DIVIDER = 125,
                DATA_WIDTH = 14,
                INCREASE_RATE = 1)    
    (input  logic csi_clk,
     input  logic rsi_reset,
     
     // avalon ST source
     output logic                    aso_gen_valid,
     output logic                    aso_gen_channel,
     output logic [DATA_WIDTH-1 : 0] aso_gen_data,
     input  logic                    aso_gen_ready);
     
    dacGenerator        
        #(.CE_DIVIDER(CE_DIVIDER),                
          .DATA_WIDTH(DATA_WIDTH),
          .INCREASE_RATE(INCREASE_RATE))
    dacGenerator_inst
         (.clk       (csi_clk),
          .reset     (rsi_reset),
          .asoValid  (aso_gen_valid),
          .asoChannel(aso_gen_channel),
          .asoData   (aso_gen_data),
          .asoRdy    (aso_gen_ready));
         
endmodule