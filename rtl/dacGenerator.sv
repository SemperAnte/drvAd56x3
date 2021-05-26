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
   #(parameter CE_DIVIDER = 125, // divider for generator sampling frequency (for clk = 25e6 and ce = 200e3 CE_DIVIDER = 125)
               DATA_WIDTH = 14,
               INCREASE_RATE = 1)    
    (input  logic clk,
     input  logic reset,
     
    // avalon ST source
    output logic                    asoValid,
    output logic                    asoChannel,
    output logic [DATA_WIDTH-1 : 0] asoData,
    input  logic                    asoRdy);   
    
    logic unsigned [DATA_WIDTH-1 : 0] cntA;
    logic unsigned [DATA_WIDTH-1 : 0] cntB;
    logic channel;
    
    logic [$clog2(CE_DIVIDER)-1 : 0] cnt; 
    
    always_ff @(posedge clk, posedge reset)
    if (reset) begin        
        cntA    <= '0;
        cntB    <= '0;
        channel <= 1'b0;
        cnt     <= '0;
    end else begin
        if (cnt < CE_DIVIDER - 1) begin
            cnt <= cnt + 1'd1;
        end else begin
            if (asoRdy) begin
                channel <= ~channel;
                if (channel) begin
                    cnt <= 1'd1;
                    cntA <= cntA + (DATA_WIDTH)'(INCREASE_RATE);
                    cntB <= cntB - (DATA_WIDTH)'(INCREASE_RATE);
                end
            end
        end
    end
        
    assign asoValid = asoRdy & (cnt == CE_DIVIDER - 1);
    assign asoChannel = channel;
    assign asoData = channel ? cntB : cntA;
    
endmodule