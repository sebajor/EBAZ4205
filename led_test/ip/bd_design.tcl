set cur_dir [pwd]
puts $cur_dir
set bd_dir $cur_dir/fpga.srcs/sources_1/bd/system 

#create_bd_design "design_1"
create_bd_design system


#instantite ps
startgroup
    create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
endgroup

#typical board configuration
#fclk0 by default is 50MHz
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]

#create the 25mhz clk for the ethernet
startgroup
    set_property -dict [list CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {25} \
                        CONFIG.PCW_EN_CLK1_PORT {1}] [get_bd_cells processing_system7_0]
endgroup
startgroup
    make_bd_pins_external  [get_bd_pins processing_system7_0/FCLK_CLK1]
endgroup
set_property name eth0_clk [get_bd_ports FCLK_CLK1_0]


#modify some dram parameters following https://programmersought.com/article/43024210515/
startgroup
    set_property -dict [list CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {16 Bit} CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J256M16 RE-125}] [get_bd_cells processing_system7_0]
endgroup


#instiate axi gpio
#by default its address is 0x4120_0000-0x4120_FFFF
startgroup
    create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
endgroup
set_property -dict [list CONFIG.C_ALL_OUTPUTS {1}] [get_bd_cells axi_gpio_0]

#autoconnections
startgroup
    apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} Master {/processing_system7_0/M_AXI_GP0} Slave {/axi_gpio_0/S_AXI} intc_ip {New AXI Interconnect} master_apm {0}}  [get_bd_intf_pins axi_gpio_0/S_AXI]
    apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {Auto}}  [get_bd_intf_pins axi_gpio_0/GPIO]
endgroup

#create the hdl wrapper
make_wrapper -files [get_files $bd_dir/system.bd] -top
import_files -force -norecurse $bd_dir/hdl/system_wrapper.v

