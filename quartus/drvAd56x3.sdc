## Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, the Altera Quartus Prime License Agreement,
## the Altera MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Altera and sold by Altera or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 15.1.0 Build 185 10/21/2015 SJ Standard Edition"

## DATE    "Fri May 20 17:18:08 2016"

##
## DEVICE  "5CSXFC6D6F31C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3


#**************************************************************
# Create Clock
#**************************************************************
derive_clock_uncertainty
create_clock -name clk -period 10.000 -waveform {0.000 5.000} [get_ports csi_clk]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************


#**************************************************************
# Set Input Delay
#**************************************************************
set_input_delay -add_delay  -clock [get_clocks clk]  1.500 [get_ports rsi_reset]
set_input_delay -add_delay  -clock [get_clocks clk]  1.500 [get_ports {avs_dac_address[*]}]
set_input_delay -add_delay  -clock [get_clocks clk]  1.500 [get_ports avs_dac_write]
set_input_delay -add_delay  -clock [get_clocks clk]  1.500 [get_ports {avs_dac_writedata[*]}]
set_input_delay -add_delay  -clock [get_clocks clk]  1.500 [get_ports avs_dac_read]
set_input_delay -add_delay  -clock [get_clocks clk]  1.500 [get_ports asi_dac_ch0_valid]
set_input_delay -add_delay  -clock [get_clocks clk]  1.500 [get_ports {asi_dac_ch0_data[*]}]
set_input_delay -add_delay  -clock [get_clocks clk]  1.500 [get_ports asi_dac_ch1_valid]
set_input_delay -add_delay  -clock [get_clocks clk]  1.500 [get_ports {asi_dac_ch1_data[*]}]

#**************************************************************
# Set Output Delay
#**************************************************************


#**************************************************************
# Set Clock Groups
#**************************************************************


#**************************************************************
# Set False Path
#**************************************************************
set_false_path -from [get_clocks clk] -to [get_ports {avs_dac_readdata[*]}]
set_false_path -from [get_clocks clk] -to [get_ports asi_dac_ch0_ready]
set_false_path -from [get_clocks clk] -to [get_ports asi_dac_ch1_ready]
set_false_path -from [get_clocks clk] -to [get_ports coe_dacSync]
set_false_path -from [get_clocks clk] -to [get_ports coe_dacSclk]
set_false_path -from [get_clocks clk] -to [get_ports coe_dacDin]

#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

