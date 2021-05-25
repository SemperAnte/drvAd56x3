if {[file exists rtl_work]} {
   vdel -lib rtl_work -all
}

vlib rtl_work
vmap work rtl_work

vlog     -work work {../rtl/drvAd56x3.sv}
vlog     -work work {../rtl/dacGenerator.sv}
vlog     -work work {tb_dacGenerator.sv}

vsim -t 1ns -L work -voptargs="+acc" tb_dacGenerator

add wave *

view structure
view signals
run 100 us
wave zoomfull