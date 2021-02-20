set cur_dir [pwd]
puts $cur_dir
set bd_dir $cur_dir/fpga.srcs/sources_1/bd/system 

#create_bd_design "design_1"
create_bd_design system


#instantite ps
startgroup
    create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
endgroup

##configurations dram and eth  
# https://programmersought.com/article/43024210515/
#https://github.com/Leungfung/ebaz4205_hw/blob/master/Doc/ebaz4205_introduce.md
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {16 Bit} CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J256M16 RE-125} \
                    CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
                    CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {100 Mbps}] [get_bd_cells processing_system7_0]
startgroup
    apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" Master "Disable" \
                                                                            Slave "Disable" }  [get_bd_cells processing_system7_0]
endgroup
##ethernet connections
startgroup
    create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
endgroup
set_property -dict [list CONFIG.IN0_WIDTH.VALUE_SRC USER] [get_bd_cells xlconcat_0]
set_property -dict [list CONFIG.NUM_PORTS {1} CONFIG.IN0_WIDTH {4}] [get_bd_cells xlconcat_0]


connect_bd_net [get_bd_pins processing_system7_0/ENET0_GMII_TXD] [get_bd_pins xlconcat_0/In0]
startgroup
    make_bd_pins_external  [get_bd_pins xlconcat_0/dout]
endgroup
set_property name ENET0_GMII_TXD_0 [get_bd_ports dout_0]
startgroup
    make_bd_pins_external  [get_bd_pins processing_system7_0/ENET0_GMII_TX_EN]
endgroup
startgroup
    make_bd_pins_external  [get_bd_pins processing_system7_0/ENET0_GMII_RX_CLK]
endgroup
startgroup
    make_bd_pins_external  [get_bd_pins processing_system7_0/ENET0_GMII_RX_DV]
endgroup
startgroup
    make_bd_pins_external  [get_bd_pins processing_system7_0/ENET0_GMII_TX_CLK]
endgroup


startgroup
    create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1
endgroup
set_property -dict [list CONFIG.IN1_WIDTH.VALUE_SRC USER] [get_bd_cells xlconcat_1]
set_property -dict [list CONFIG.IN0_WIDTH {4} CONFIG.IN1_WIDTH {4}] [get_bd_cells xlconcat_1]

connect_bd_net [get_bd_pins processing_system7_0/ENET0_GMII_RXD] [get_bd_pins xlconcat_1/dout]
startgroup
    make_bd_pins_external  [get_bd_pins xlconcat_1/In0]
endgroup
set_property name ENET0_GMII_RXD_0 [get_bd_ports In0_0]
startgroup
    make_bd_pins_external  [get_bd_pins processing_system7_0/ENET0_MDIO_MDC]
endgroup

#typical board configuration
#fclk0 by default is 50MHz
#apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]


#modify some dram parameters following https://programmersought.com/article/43024210515/
#also modify the clock of the ethernet
#startgroup
#    set_property -dict [list CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
#    CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {100 Mbps} \
#    CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {16 Bit} \
#    CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J256M16 RE-125}] [get_bd_cells processing_system7_0]
#endgroup


#instiate axi gpio
startgroup
    create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
endgroup
set_property -dict [list CONFIG.C_ALL_OUTPUTS {1}] [get_bd_cells axi_gpio_0]
#set_property offset 0x41C00000 [get_bd_addr_segs {processing_system7_0/Data/SEG_axi_gpio_0_Reg}]


#autoconnections
startgroup
    apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} Master {/processing_system7_0/M_AXI_GP0} Slave {/axi_gpio_0/S_AXI} intc_ip {New AXI Interconnect} master_apm {0}}  [get_bd_intf_pins axi_gpio_0/S_AXI]
    apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {Auto}}  [get_bd_intf_pins axi_gpio_0/GPIO]
endgroup

#create the hdl wrapper
make_wrapper -files [get_files $bd_dir/system.bd] -top
import_files -force -norecurse $bd_dir/hdl/system_wrapper.v

