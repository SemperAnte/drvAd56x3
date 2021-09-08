if {[file exists rtl_work]} {
   vdel -lib rtl_work -all
}

vlib rtl_work
vmap work rtl_work

vlog     -work work {../rtl/drvAd56x3_parm.sv}
vlog     -work work {../rtl/drvAd56x3_core.sv}
vlog     -work work {../rtl/drvAd56x3_gen.sv}
vlog     -work work {../rtl/drvAd56x3.sv}
vlog     -work work {tb_gen.sv}

vsim -t 1ns -L work -voptargs="+acc" tb_gen

add wave *

view structure
view signals
run 100 us
wave zoomfull