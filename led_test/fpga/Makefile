
#FPGA settings
FPGA_PART = xc7z010clg400-1 
FPGA_TOP = fpga
FPGA_ARCH = zynq7

#files for synthesis
SYN_FILES = rtl/fpga.v


#XDC files
XDC_FILES = fpga.xdc

#IP
IP_TCL_FILES = ip/bd_design.tcl


include ../common/vivado.mk

##program the fpga after the compilation 

program: $(FPGA_TOP).bit
	echo "open_hw" > program.tcl
	echo "connect_hw_server" >> program.tcl
	echo "open_hw_target" >> program.tcl
	echo "current_hw_device [lindex [get_hw_devices] 0]" >> program.tcl
	echo "refresh_hw_device -update_hw_probes false [current_hw_device]" >> program.tcl
	echo "set_property PROGRAM.FILE {$(FPGA_TOP).bit} [current_hw_device]" >> program.tcl
	echo "program_hw_devices [current_hw_device]" >> program.tcl
	echo "exit" >> program.tcl
	vivado -nojournal -nolog -mode batch -source program.tcl

%.mcs %.prm: %.bit
	echo "write_cfgmem -force -format mcs -size 16 -interface SPIx4 -loadbit {up 0x0000000 $*.bit} -checksum -file $*.mcs" > generate_mcs.tcl
	echo "exit" >> generate_mcs.tcl
	vivado -nojournal -nolog -mode batch -source generate_mcs.tcl
	mkdir -p rev
	COUNT=100; \
	while [ -e rev/$*_rev$$COUNT.bit ]; \
	do COUNT=$$((COUNT+1)); done; \
	COUNT=$$((COUNT-1)); \
	for x in .mcs .prm; \
	do cp $*$$x rev/$*_rev$$COUNT$$x; \
	echo "Output: rev/$*_rev$$COUNT$$x"; done;

flash: $(FPGA_TOP).mcs $(FPGA_TOP).prm
	echo "open_hw" > flash.tcl
	echo "connect_hw_server" >> flash.tcl
	echo "open_hw_target" >> flash.tcl
	echo "current_hw_device [lindex [get_hw_devices] 0]" >> flash.tcl
	echo "refresh_hw_device -update_hw_probes false [current_hw_device]" >> flash.tcl
	echo "create_hw_cfgmem -hw_device [current_hw_device] [lindex [get_cfgmem_parts {mt25ql128-spi-x1_x2_x4}] 0]" >> flash.tcl
	echo "current_hw_cfgmem -hw_device [current_hw_device] [get_property PROGRAM.HW_CFGMEM [current_hw_device]]" >> flash.tcl
	echo "set_property PROGRAM.FILES [list \"$(FPGA_TOP).mcs\"] [current_hw_cfgmem]" >> flash.tcl
	echo "set_property PROGRAM.PRM_FILES [list \"$(FPGA_TOP).prm\"] [current_hw_cfgmem]" >> flash.tcl
	echo "set_property PROGRAM.ERASE 1 [current_hw_cfgmem]" >> flash.tcl
	echo "set_property PROGRAM.CFG_PROGRAM 1 [current_hw_cfgmem]" >> flash.tcl
	echo "set_property PROGRAM.VERIFY 1 [current_hw_cfgmem]" >> flash.tcl
	echo "set_property PROGRAM.CHECKSUM 0 [current_hw_cfgmem]" >> flash.tcl
	echo "set_property PROGRAM.ADDRESS_RANGE {use_file} [current_hw_cfgmem]" >> flash.tcl
	echo "set_property PROGRAM.UNUSED_PIN_TERMINATION {pull-none} [current_hw_cfgmem]" >> flash.tcl
	echo "create_hw_bitstream -hw_device [current_hw_device] [get_property PROGRAM.HW_CFGMEM_BITFILE [current_hw_device]]" >> flash.tcl
	echo "program_hw_devices [current_hw_device]" >> flash.tcl
	echo "refresh_hw_device [current_hw_device]" >> flash.tcl
	echo "program_hw_cfgmem -hw_cfgmem [current_hw_cfgmem]" >> flash.tcl
	echo "boot_hw_device [current_hw_device]" >> flash.tcl
	echo "exit" >> flash.tcl
	vivado -nojournal -nolog -mode batch -source flash.tcl

