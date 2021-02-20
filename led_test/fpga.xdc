#leds
set_property -dict {LOC W13 IOSTANDARD LVCMOS33} [get_ports r_led];
set_property -dict {LOC W14 IOSTANDARD LVCMOS33} [get_ports g_led];

#eth0 clk
set_property -dict {LOC U18 IOSTANDARD LVCMOS33} [get_ports eth0_clk];

#found this constraints in https://github.com/alexlargacha/ebaz4205_fpga
#they seem to be to make an fsbl

#set_property IOSTANDARD LVCMOS33 [get_ports UART_0_0_rxd]
#set_property IOSTANDARD LVCMOS33 [get_ports UART_0_0_txd]
#set_property PACKAGE_PIN F19 [get_ports UART_0_0_rxd]
#set_property PACKAGE_PIN F20 [get_ports UART_0_0_txd]

#set_property IOSTANDARD LVCMOS33 [get_ports ENET0_GMII_RX_CLK_0]
#set_property IOSTANDARD LVCMOS33 [get_ports ENET0_GMII_TX_CLK_0]
#set_property PACKAGE_PIN U14 [get_ports ENET0_GMII_RX_CLK_0]
#set_property PACKAGE_PIN U15 [get_ports ENET0_GMII_TX_CLK_0]

#set_property IOSTANDARD LVCMOS33 [get_ports {ENET0_GMII_RXD_0[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {ENET0_GMII_RXD_0[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {ENET0_GMII_RXD_0[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {ENET0_GMII_RXD_0[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {ENET0_GMII_TX_EN_0[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {ENET0_GMII_TXD_0[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {ENET0_GMII_TXD_0[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {ENET0_GMII_TXD_0[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {ENET0_GMII_TXD_0[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports ENET0_GMII_RX_DV_0]
#set_property IOSTANDARD LVCMOS33 [get_ports MDIO_ETHERNET_0_0_mdc]
#set_property IOSTANDARD LVCMOS33 [get_ports MDIO_ETHERNET_0_0_mdio_io]
#set_property PACKAGE_PIN Y17 [get_ports {ENET0_GMII_RXD_0[3]}]
#set_property PACKAGE_PIN V17 [get_ports {ENET0_GMII_RXD_0[2]}]
#set_property PACKAGE_PIN V16 [get_ports {ENET0_GMII_RXD_0[1]}]
#set_property PACKAGE_PIN Y16 [get_ports {ENET0_GMII_RXD_0[0]}]
#set_property PACKAGE_PIN W19 [get_ports {ENET0_GMII_TX_EN_0[0]}]
#set_property PACKAGE_PIN W18 [get_ports {ENET0_GMII_TXD_0[0]}]
#set_property PACKAGE_PIN Y18 [get_ports {ENET0_GMII_TXD_0[1]}]
#set_property PACKAGE_PIN V18 [get_ports {ENET0_GMII_TXD_0[2]}]
#set_property PACKAGE_PIN Y19 [get_ports {ENET0_GMII_TXD_0[3]}]
#set_property PACKAGE_PIN W15 [get_ports MDIO_ETHERNET_0_0_mdc]
#set_property PACKAGE_PIN Y14 [get_ports MDIO_ETHERNET_0_0_mdio_io]
#set_property PACKAGE_PIN W16 [get_ports ENET0_GMII_RX_DV_0]
