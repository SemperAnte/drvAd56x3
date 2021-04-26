if {[file exists rtl_work]} {
   vdel -lib rtl_work -all
}

vlib rtl_work
vmap work rtl_work

vlog     -work work {../rtl/drvAd56x3.sv}
vlog     -work work {tb_drvAd56x3.sv}

vsim -t 1ns -L work -voptargs="+acc" tb_drvAd56x3

add wave *

view structure
view signals
run 10 us
wave zoomfull