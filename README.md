# DAC driver ad5623/ad5643/ad5663

It's a module of DAC driver for specified family with built-in saw-signal generator for hardware testing.  
The module has 2 independent data channels with Avalon Streaming interface.  
The module is controlled via Avalon MM interface:  
- channel swapping
- turn on/off built-in generator
- set parameters for generator

Also this repository has Qsys component and testbench for Modelsim.

Interface Avalon MM with address width 3 bits and data width 16 bits is used for writing and reading to controlling registers.

### Control registers table
|Address|Bits    |Write/read   |Description                                                            |
|-------|--------|-------------|-----------------------------------------------------------------------|
|0      |0       |w            |Reset all registers to default state                                   |
|1      |0       |w/r          |0 - DAC data from external interface, 1 - DAC data from  generator     |
|2      |0       |w/r          |0 - standart channel position, 1 - channel swapping                    |
|3      |[15:0]  |w/r          |Set clock divider for generator (for sampling frequency setting)       |                                                                                           
|4      |[15:0]  |w/r          |Increasing rate for generator (signed number), channel 0               |
|5      |[15:0]  |w/r          |Increasing rate for generator (signed number), channel 1               |