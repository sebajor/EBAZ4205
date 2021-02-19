create_project -force -part xc7z010clg400-1  fpga
add_files -fileset sources_1 defines.v
add_files -fileset sources_1 ../rtl/fpga.v
add_files -fileset constrs_1 ../fpga.xdc
source ../ip/bd_design.tcl
exit
