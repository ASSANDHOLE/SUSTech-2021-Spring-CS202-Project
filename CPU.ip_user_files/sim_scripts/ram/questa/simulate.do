onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib ram_opt

do {wave.do}

view wave
view structure
view signals

do {ram.udo}

run -all

quit -force
