vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/xil_defaultlib

vmap xpm modelsim_lib/msim/xpm
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xpm  -incr -sv \
"D:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm  -93 \
"D:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr \
"../../../../CPU.gen/sources_1/ip/uart_bmpg_0/uart_bmpg.v" \
"../../../../CPU.gen/sources_1/ip/uart_bmpg_0/upg.v" \
"../../../../CPU.gen/sources_1/ip/uart_bmpg_0/sim/uart_bmpg_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

