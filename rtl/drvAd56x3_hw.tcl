# TCL File Generated by Component Editor 18.1
# Wed Sep 08 14:59:55 GMT+03:00 2021
# DO NOT MODIFY


# 
# drvAd56x3 "Driver for DACs ad56x3 series" v1.0
# Shustov Aleksey (SemperAnte), semte@semte.ru 2021.09.08.14:59:55
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module drvAd56x3
# 
set_module_property DESCRIPTION ""
set_module_property NAME drvAd56x3
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Shustov Aleksey (SemperAnte), semte@semte.ru"
set_module_property DISPLAY_NAME "Driver for DACs ad56x3 series"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property ELABORATION_CALLBACK Elaborate


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL drvAd56x3_hw
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file drvAd56x3_parm.sv SYSTEM_VERILOG PATH drvAd56x3_parm.sv
add_fileset_file drvAd56x3_core.sv SYSTEM_VERILOG PATH drvAd56x3_core.sv
add_fileset_file drvAd56x3_gen.sv SYSTEM_VERILOG PATH drvAd56x3_gen.sv
add_fileset_file drvAd56x3.sv SYSTEM_VERILOG PATH drvAd56x3.sv
add_fileset_file drvAd56x3_hw.sv SYSTEM_VERILOG PATH drvAd56x3_hw.sv TOP_LEVEL_FILE


# 
# parameters
# 
add_parameter SIGN_A STRING UNSIGNED
set_parameter_property SIGN_A DEFAULT_VALUE UNSIGNED
set_parameter_property SIGN_A DISPLAY_NAME SIGN_A
set_parameter_property SIGN_A TYPE STRING
set_parameter_property SIGN_A UNITS None
set_parameter_property SIGN_A HDL_PARAMETER true
set_parameter_property SIGN_A ALLOWED_RANGES {SIGNED UNSIGNED}
add_parameter SIGN_B STRING UNSIGNED
set_parameter_property SIGN_B DEFAULT_VALUE UNSIGNED
set_parameter_property SIGN_B DISPLAY_NAME SIGN_B
set_parameter_property SIGN_B TYPE STRING
set_parameter_property SIGN_B UNITS None
set_parameter_property SIGN_B HDL_PARAMETER true
set_parameter_property SIGN_B ALLOWED_RANGES {SIGNED UNSIGNED}
add_parameter DATA_WIDTH INTEGER 14
set_parameter_property DATA_WIDTH DEFAULT_VALUE 14
set_parameter_property DATA_WIDTH DISPLAY_NAME DATA_WIDTH
set_parameter_property DATA_WIDTH TYPE INTEGER
set_parameter_property DATA_WIDTH UNITS None
set_parameter_property DATA_WIDTH HDL_PARAMETER true
set_parameter_property DATA_WIDTH ALLOWED_RANGES {12 14 16}

add_parameter SCLK_DIVIDER INTEGER 2
set_parameter_property SCLK_DIVIDER DEFAULT_VALUE 2
set_parameter_property SCLK_DIVIDER DISPLAY_NAME SCLK_DIVIDER
set_parameter_property SCLK_DIVIDER TYPE INTEGER
set_parameter_property SCLK_DIVIDER UNITS None
set_parameter_property SCLK_DIVIDER HDL_PARAMETER true
add_parameter SYNC_DURATION INTEGER 5
set_parameter_property SYNC_DURATION DEFAULT_VALUE 5
set_parameter_property SYNC_DURATION DISPLAY_NAME SYNC_DURATION
set_parameter_property SYNC_DURATION TYPE INTEGER
set_parameter_property SYNC_DURATION UNITS None
set_parameter_property SYNC_DURATION HDL_PARAMETER true


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock csi_clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset rsi_reset reset Input 1


# 
# connection point dac
# 
add_interface dac avalon end
set_interface_property dac addressUnits WORDS
set_interface_property dac associatedClock clock
set_interface_property dac associatedReset reset
set_interface_property dac bitsPerSymbol 8
set_interface_property dac burstOnBurstBoundariesOnly false
set_interface_property dac burstcountUnits WORDS
set_interface_property dac explicitAddressSpan 0
set_interface_property dac holdTime 0
set_interface_property dac linewrapBursts false
set_interface_property dac maximumPendingReadTransactions 0
set_interface_property dac maximumPendingWriteTransactions 0
set_interface_property dac readLatency 1
set_interface_property dac readWaitTime 0
set_interface_property dac setupTime 0
set_interface_property dac timingUnits Cycles
set_interface_property dac writeWaitTime 0
set_interface_property dac ENABLED true
set_interface_property dac EXPORT_OF ""
set_interface_property dac PORT_NAME_MAP ""
set_interface_property dac CMSIS_SVD_VARIABLES ""
set_interface_property dac SVD_ADDRESS_GROUP ""

add_interface_port dac avs_dac_address address Input 3
add_interface_port dac avs_dac_write write Input 1
add_interface_port dac avs_dac_writedata writedata Input 16
add_interface_port dac avs_dac_read read Input 1
add_interface_port dac avs_dac_readdata readdata Output 16
set_interface_assignment dac embeddedsw.configuration.isFlash 0
set_interface_assignment dac embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment dac embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment dac embeddedsw.configuration.isPrintableDevice 0


# 
# connection point dac_ch0
# 
add_interface dac_ch0 avalon_streaming end
set_interface_property dac_ch0 associatedClock clock
set_interface_property dac_ch0 associatedReset reset
set_interface_property dac_ch0 errorDescriptor ""
set_interface_property dac_ch0 firstSymbolInHighOrderBits true
set_interface_property dac_ch0 maxChannel 0
set_interface_property dac_ch0 readyLatency 0
set_interface_property dac_ch0 ENABLED true
set_interface_property dac_ch0 EXPORT_OF ""
set_interface_property dac_ch0 PORT_NAME_MAP ""
set_interface_property dac_ch0 CMSIS_SVD_VARIABLES ""
set_interface_property dac_ch0 SVD_ADDRESS_GROUP ""

add_interface_port dac_ch0 asi_dac_ch0_valid valid Input 1
add_interface_port dac_ch0 asi_dac_ch0_data data Input DATA_WIDTH
add_interface_port dac_ch0 asi_dac_ch0_ready ready Output 1


# 
# connection point dac_ch1
# 
add_interface dac_ch1 avalon_streaming end
set_interface_property dac_ch1 associatedClock clock
set_interface_property dac_ch1 associatedReset reset
set_interface_property dac_ch1 errorDescriptor ""
set_interface_property dac_ch1 firstSymbolInHighOrderBits true
set_interface_property dac_ch1 maxChannel 0
set_interface_property dac_ch1 readyLatency 0
set_interface_property dac_ch1 ENABLED true
set_interface_property dac_ch1 EXPORT_OF ""
set_interface_property dac_ch1 PORT_NAME_MAP ""
set_interface_property dac_ch1 CMSIS_SVD_VARIABLES ""
set_interface_property dac_ch1 SVD_ADDRESS_GROUP ""

add_interface_port dac_ch1 asi_dac_ch1_valid valid Input 1
add_interface_port dac_ch1 asi_dac_ch1_data data Input DATA_WIDTH
add_interface_port dac_ch1 asi_dac_ch1_ready ready Output 1


# 
# connection point dacInterface
# 
add_interface dacInterface conduit end
set_interface_property dacInterface associatedClock clock
set_interface_property dacInterface associatedReset reset
set_interface_property dacInterface ENABLED true
set_interface_property dacInterface EXPORT_OF ""
set_interface_property dacInterface PORT_NAME_MAP ""
set_interface_property dacInterface CMSIS_SVD_VARIABLES ""
set_interface_property dacInterface SVD_ADDRESS_GROUP ""

add_interface_port dacInterface coe_dacSync dacSync Output 1
add_interface_port dacInterface coe_dacSclk dacSclk Output 1
add_interface_port dacInterface coe_dacDin dacDin Output 1

# +----------------------------------------------------------------
# | Elaborate callback
# +----------------------------------------------------------------
proc Elaborate {} {
    set In_d_width [ get_parameter_value DATA_WIDTH ]
    set_interface_property dac_ch0 dataBitsPerSymbol $In_d_width
    set_interface_property dac_ch1 dataBitsPerSymbol $In_d_width
}