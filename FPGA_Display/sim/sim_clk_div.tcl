# Check and create work library if needed
if {![file exists "work"]} {
    vlib work
}

# copied files are located in same directory as work folder
# root directory is fpga-mcu-architecture/VGA-FPGA/ModelSim_Project

file copy -force ../src/clk_div.vhd ./clk_div.vhd
file copy -force ../tb/clk_div_tb.vhd ./clk_div_tb.vhd

vcom clk_div.vhd
vcom clk_div_tb.vhd

if {$now == 0 } {
    vsim work.clk_div_tb
} else {
    restart -force
}

set wavewin [view wave]
set wave_count [$wavewin.tree.tree1 size]

if {$wave_count == 0} {
    add wave *
}

run 1000 ns

WaveRestoreZoom {0 ns} {1000 ns}