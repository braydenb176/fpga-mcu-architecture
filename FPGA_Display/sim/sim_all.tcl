# Check and create work library if needed
if {![file exists "work"]} {
    vlib work
}

# copied files are located in same directory as work folder
# root directory is fpga-mcu-architecture/VGA-FPGA/ModelSim_Project

# copy over all vhd src files
foreach f [glob -nocomplain ../src/*.vhd] {
    file copy -force $f ./[file tail $f]
}

# copy over all vhd tb files
foreach f [glob -nocomplain ../tb/*.vhd] {
    file copy -force $f ./[file tail $f]
}

# compile all vhd files
foreach f [glob -nocomplain *.vhd] {
    vcom -work work $f
}