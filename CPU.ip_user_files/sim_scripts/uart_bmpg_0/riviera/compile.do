vlib work
vlib riviera

vlib riviera/xpm
vlib riviera/xil_defaultlib

vmap xpm riviera/xpm
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xpm  -sv2k12 \
"D:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"D:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 \
"../../../../CPU.gen/sources_1/ip/uart_bmpg_0/uart_bmpg.v" \
"../../../../CPU.gen/sources_1/ip/uart_bmpg_0/upg.v" \
"../../../../CPU.gen/sources_1/ip/uart_bmpg_0/sim/uart_bmpg_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

