//--------------------------------------------------------------------------------
// Project:       rtllib
// Author:        Shustov Aleksey (SemperAnte), semte@semte.ru
//--------------------------------------------------------------------------------
// Simple saw generator for testing DAC AD56x3 in hardware
//--------------------------------------------------------------------------------
module drvAd56x3_gen
   #(parameter DATA_WIDTH = 14)
    (input  logic                           clk,
     input  logic                           reset,
     
     // parameter
     input logic                   [15 : 0] ceDivider,
     input logic signed            [15 : 0] incrRate0,
     input logic signed            [15 : 0] incrRate1,
     
     // avalon ST source - channel 0
     output logic                           genValid0,
     output logic signed [DATA_WIDTH-1 : 0] genData0,
     input  logic                           genRdy0,
     
     // avalon ST source - channel 1
     output logic                           genValid1,
     output logic signed [DATA_WIDTH-1 : 0] genData1,
     input  logic                           genRdy1);
    
    logic genValid;
    logic [15 : 0] cnt; 
    
    always_ff @(posedge clk, posedge reset)
    if (reset) begin        
        genData0 <= '0;
        genData1 <= '0;
        cnt      <= '0;
    end else begin
        if (cnt == ceDivider - 1'd1) begin
            if (genRdy0 & genRdy1) begin
                cnt      <= '0;
                genData0 <= genData0 + incrRate0[DATA_WIDTH-1 : 0];
                genData1 <= genData1 + incrRate1[DATA_WIDTH-1 : 0];
            end
        end else begin
            cnt <= cnt + 1'd1;
        end
    end
        
    assign genValid = genRdy0 & genRdy1 & (cnt == ceDivider - 1'd1);
    assign genValid0 = genValid;
    assign genValid1 = genValid;

endmodule