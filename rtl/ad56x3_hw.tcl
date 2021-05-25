# TCL File Generated by Component Editor 18.1
# Wed May 19 17:04:24 MSK 2021
# DO NOT MODIFY


# 
# ad56x3 "Driver for DACs ad56x3 series" v1.0
#  2021.05.19.17:04:24
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module ad56x3
# 
set_module_property DESCRIPTION ""
set_module_property NAME ad56x3
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

add_interface dac avalon_streaming end
set_interface_property dac associatedClock clock
set_interface_property dac associatedReset reset
set_interface_property dac errorDescriptor ""
set_interface_property dac firstSymbolInHighOrderBits true
set_interface_property dac maxChannel 1
set_interface_property dac readyLatency 0
set_interface_property dac ENABLED true
set_interface_property dac EXPORT_OF ""
set_interface_property dac PORT_NAME_MAP ""
set_interface_property dac CMSIS_SVD_VARIABLES ""
set_interface_property dac SVD_ADDRESS_GROUP ""

add_interface_port dac asi_dac_valid valid Input 1
add_interface_port dac asi_dac_channel channel Input 1
add_interface_port dac asi_dac_data data Input DATA_WIDTH
add_interface_port dac asi_dac_ready ready Output 1


# 
# connection point conduit_end_0
# 
add_interface conduit_end_0 conduit end
set_interface_property conduit_end_0 associatedClock clock
set_interface_property conduit_end_0 associatedReset reset
set_interface_property conduit_end_0 ENABLED true
set_interface_property conduit_end_0 EXPORT_OF ""
set_interface_property conduit_end_0 PORT_NAME_MAP ""
set_interface_property conduit_end_0 CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_0 SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_0 coe_dacSync out1 Output 1
add_interface_port conduit_end_0 coe_dacSclk out2 Output 1
add_interface_port conduit_end_0 coe_dacDin out3 Output 1


# +----------------------------------------------------------------
# | Elaborate callback
# +----------------------------------------------------------------
proc Elaborate {} {
    set In_d_width [ get_parameter_value DATA_WIDTH ]
    set_interface_property dac dataBitsPerSymbol $In_d_width
}