//--------------------------------------------------------------------------------
// Project:       rtllib
// Author:        Shustov Aleksey (SemperAnte), semte@semte.ru
//--------------------------------------------------------------------------------
// set parameters via avalon MM interface
// adr  0 - bit 0   - w   - soft reset to default
// adr  1 - bit 0   - w/r - 0 - for asi interface to dac, 1 - for generator to dac
// adr  2 - all     - w/r - generator, divider for clk frequency
// adr  3 - all     - w/r - generator, incrementation step for channel 0 (signed)
// adr  4 - all     - w/r - generator, incrementation step for channel 1 (signed)
//--------------------------------------------------------------------------------
module drvAd56x3_parm
    (input  logic                 clk,
     input  logic                 reset,
                         
     // avalon MM slave  
     input  logic         [2 : 0] avsAdr,
     input  logic                 avsWr,
     input  logic        [15 : 0] avsWrData,
     input  logic                 avsRd,
     output logic        [15 : 0] avsRdData,
                         
     // parameter        
     output logic                 genSel,
     output logic        [15 : 0] ceDivider,
     output logic signed [15 : 0] incrRate0,
     output logic signed [15 : 0] incrRate1);
     
    localparam logic DEFAULT_GEN_SEL = 1'b0;
    localparam int DEFAULT_CE_DIVIDER = 125;
    localparam int DEFAULT_INCR_RATE0 = +1;
    localparam int DEFAULT_INCR_RATE1 = -1;
     
    // avalon MM interface
    always_ff @(posedge clk, posedge reset)
    if (reset) begin
        avsRdData <= '0;
        genSel    <= DEFAULT_GEN_SEL;
        ceDivider <= (16)'(DEFAULT_CE_DIVIDER);
        incrRate0 <= (16)'(DEFAULT_INCR_RATE0);
        incrRate1 <= (16)'(DEFAULT_INCR_RATE1);
    end else begin
        if (avsWr) begin
            case (avsAdr)
                4'd0: begin
                    if (avsWrData[0]) begin
                        genSel    <= DEFAULT_GEN_SEL;
                        ceDivider <= (16)'(DEFAULT_CE_DIVIDER);
                        incrRate0 <= (16)'(DEFAULT_INCR_RATE0);
                        incrRate1 <= (16)'(DEFAULT_INCR_RATE1);
                    end
                end
                4'd1: genSel <= avsWrData[0];
                4'd2: ceDivider <= avsWrData;
                4'd3: incrRate0 <= avsWrData;
                4'd4: incrRate1 <= avsWrData;
                default: ;
            endcase            
        end
        if (avsRd) begin
            case (avsAdr)
                4'd1: avsRdData <= genSel;
                4'd2: avsRdData <= ceDivider;
                4'd3: avsRdData <= incrRate0;
                4'd4: avsRdData <= incrRate1;
                default: avsRdData <= '0;
            endcase        
        end
    end

endmodule