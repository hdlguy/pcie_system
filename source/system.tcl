
################################################################
# This is a generated script based on design: system
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2014.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source system.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7k325tffg900-2


# CHANGE DESIGN NAME HERE
set design_name system

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}


# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: pcie_bridge
proc create_hier_cell_pcie_bridge { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_pcie_bridge() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_7x_mgt

  # Create pins
  create_bd_pin -dir I -from 0 -to 0 IBUF_DS_N
  create_bd_pin -dir I -from 0 -to 0 IBUF_DS_P
  create_bd_pin -dir O INTX_MSI_Grant
  create_bd_pin -dir O -from 2 -to 0 MSI_Vector_Width
  create_bd_pin -dir O MSI_enable
  create_bd_pin -dir I -type rst aux_reset_in
  create_bd_pin -dir O -type clk axi_aclk_out
  create_bd_pin -dir I -type rst ext_reset_in
  create_bd_pin -dir O -from 0 -to 0 -type rst interconnect_aresetn
  create_bd_pin -dir O -type intr interrupt_out
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn

  # Create instance: axi_pcie_0, and set properties
  set axi_pcie_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_pcie:2.5 axi_pcie_0 ]
  set_property -dict [ list CONFIG.BAR0_SCALE {Megabytes} CONFIG.BAR0_SIZE {16} CONFIG.BAR1_ENABLED {false} CONFIG.BAR2_ENABLED {false} CONFIG.BASE_CLASS_MENU {Memory_controller} CONFIG.DEVICE_ID {0x7011} CONFIG.INTERRUPT_PIN {true} CONFIG.MAX_LINK_SPEED {2.5_GT/s} CONFIG.SUB_CLASS_INTERFACE_MENU {RAM} CONFIG.XLNX_REF_BOARD {KC705_REVC}  ] $axi_pcie_0

  # Create instance: fit_timer_0, and set properties
  set fit_timer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fit_timer:2.0 fit_timer_0 ]
  set_property -dict [ list CONFIG.C_NO_CLOCKS {62500000}  ] $fit_timer_0

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]
  set_property -dict [ list CONFIG.C_AUX_RESET_HIGH {0} CONFIG.USE_BOARD_FLOW {true}  ] $proc_sys_reset_0

  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.0 util_ds_buf_0 ]
  set_property -dict [ list CONFIG.C_BUF_TYPE {IBUFDSGTE}  ] $util_ds_buf_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list CONFIG.CONST_VAL {19} CONFIG.CONST_WIDTH {5}  ] $xlconstant_0

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins M_AXI] [get_bd_intf_pins axi_pcie_0/M_AXI]
  connect_bd_intf_net -intf_net axi_pcie_0_pcie_7x_mgt [get_bd_intf_pins pcie_7x_mgt] [get_bd_intf_pins axi_pcie_0/pcie_7x_mgt]

  # Create port connections
  connect_bd_net -net IBUF_DS_N_1 [get_bd_pins IBUF_DS_N] [get_bd_pins util_ds_buf_0/IBUF_DS_N]
  connect_bd_net -net IBUF_DS_P_1 [get_bd_pins IBUF_DS_P] [get_bd_pins util_ds_buf_0/IBUF_DS_P]
  connect_bd_net -net INTX_MSI_Grant1 [get_bd_pins INTX_MSI_Grant] [get_bd_pins axi_pcie_0/INTX_MSI_Grant]
  connect_bd_net -net MSI_Vector_Width1 [get_bd_pins MSI_Vector_Width] [get_bd_pins axi_pcie_0/MSI_Vector_Width]
  connect_bd_net -net MSI_enable1 [get_bd_pins MSI_enable] [get_bd_pins axi_pcie_0/MSI_enable]
  connect_bd_net -net aux_reset_in_1 [get_bd_pins aux_reset_in] [get_bd_pins proc_sys_reset_0/aux_reset_in]
  connect_bd_net -net axi_pcie_0_axi_aclk_out [get_bd_pins axi_aclk_out] [get_bd_pins axi_pcie_0/axi_aclk_out] [get_bd_pins fit_timer_0/Clk]
  connect_bd_net -net axi_pcie_0_axi_ctl_aclk_out [get_bd_pins axi_pcie_0/axi_ctl_aclk_out] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
  connect_bd_net -net axi_pcie_0_mmcm_lock [get_bd_pins axi_pcie_0/mmcm_lock] [get_bd_pins proc_sys_reset_0/dcm_locked]
  connect_bd_net -net fit_timer_0_Interrupt [get_bd_pins axi_pcie_0/INTX_MSI_Request] [get_bd_pins fit_timer_0/Interrupt]
  connect_bd_net -net interrupt_out1 [get_bd_pins interrupt_out] [get_bd_pins axi_pcie_0/interrupt_out]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins interconnect_aresetn] [get_bd_pins axi_pcie_0/axi_aresetn] [get_bd_pins proc_sys_reset_0/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins fit_timer_0/Rst] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
  connect_bd_net -net reset_rtl_1 [get_bd_pins ext_reset_in] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net util_ds_buf_0_IBUF_OUT [get_bd_pins axi_pcie_0/REFCLK] [get_bd_pins util_ds_buf_0/IBUF_OUT]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins axi_pcie_0/MSI_Vector_Num] [get_bd_pins xlconstant_0/dout]
  
  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: axi_periphs
proc create_hier_cell_axi_periphs { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_axi_periphs() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  # Create pins
  create_bd_pin -dir I -from 0 -to 0 -type rst S00_ARESETN
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -from 0 -to 0 -type rst s_axi_aresetn
  create_bd_pin -dir I -from 31 -to 0 slv_read0
  create_bd_pin -dir I -from 31 -to 0 slv_read1
  create_bd_pin -dir I -from 31 -to 0 slv_read2
  create_bd_pin -dir I -from 31 -to 0 slv_read3
  create_bd_pin -dir I -from 31 -to 0 slv_read4
  create_bd_pin -dir I -from 31 -to 0 slv_read5
  create_bd_pin -dir I -from 31 -to 0 slv_read6
  create_bd_pin -dir I -from 31 -to 0 slv_read7
  create_bd_pin -dir I -from 31 -to 0 slv_read8
  create_bd_pin -dir I -from 31 -to 0 slv_read9
  create_bd_pin -dir I -from 31 -to 0 slv_read10
  create_bd_pin -dir I -from 31 -to 0 slv_read11
  create_bd_pin -dir I -from 31 -to 0 slv_read12
  create_bd_pin -dir I -from 31 -to 0 slv_read13
  create_bd_pin -dir I -from 31 -to 0 slv_read14
  create_bd_pin -dir I -from 31 -to 0 slv_read15
  create_bd_pin -dir O -from 31 -to 0 slv_reg0
  create_bd_pin -dir O -from 31 -to 0 slv_reg1
  create_bd_pin -dir O -from 31 -to 0 slv_reg2
  create_bd_pin -dir O -from 31 -to 0 slv_reg3
  create_bd_pin -dir O -from 31 -to 0 slv_reg4
  create_bd_pin -dir O -from 31 -to 0 slv_reg5
  create_bd_pin -dir O -from 31 -to 0 slv_reg6
  create_bd_pin -dir O -from 31 -to 0 slv_reg7
  create_bd_pin -dir O -from 31 -to 0 slv_reg8
  create_bd_pin -dir O -from 31 -to 0 slv_reg9
  create_bd_pin -dir O -from 31 -to 0 slv_reg10
  create_bd_pin -dir O -from 31 -to 0 slv_reg11
  create_bd_pin -dir O -from 31 -to 0 slv_reg12
  create_bd_pin -dir O -from 31 -to 0 slv_reg13
  create_bd_pin -dir O -from 31 -to 0 slv_reg14
  create_bd_pin -dir O -from 31 -to 0 slv_reg15

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_0 ]
  set_property -dict [ list CONFIG.SINGLE_PORT_BRAM {1}  ] $axi_bram_ctrl_0

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list CONFIG.NUM_MI {8}  ] $axi_interconnect_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 blk_mem_gen_0 ]
  set_property -dict [ list CONFIG.Enable_B {Always_Enabled} CONFIG.Memory_Type {Single_Port_RAM} CONFIG.Port_B_Clock {0} CONFIG.Port_B_Enable_Rate {0} CONFIG.Port_B_Write_Rate {0} CONFIG.Use_RSTB_Pin {false} CONFIG.Write_Depth_A {8192}  ] $blk_mem_gen_0

  # Create instance: regfilex16_v1_0_0, and set properties
  set regfilex16_v1_0_0 [ create_bd_cell -type ip -vlnv user.org:user:regfilex16_v1_0:1.0 regfilex16_v1_0_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins S00_AXI] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins axi_interconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins regfilex16_v1_0_0/s00_axi]

  # Create port connections
  connect_bd_net -net axi_pcie_0_axi_aclk_out [get_bd_pins s_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/M04_ACLK] [get_bd_pins axi_interconnect_0/M05_ACLK] [get_bd_pins axi_interconnect_0/M06_ACLK] [get_bd_pins axi_interconnect_0/M07_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins regfilex16_v1_0_0/s00_axi_aclk]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins S00_ARESETN] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/M04_ARESETN] [get_bd_pins axi_interconnect_0/M05_ARESETN] [get_bd_pins axi_interconnect_0/M06_ARESETN] [get_bd_pins axi_interconnect_0/M07_ARESETN] [get_bd_pins regfilex16_v1_0_0/s00_axi_aresetn]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg0 [get_bd_pins slv_reg0] [get_bd_pins regfilex16_v1_0_0/slv_reg0]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg1 [get_bd_pins slv_reg1] [get_bd_pins regfilex16_v1_0_0/slv_reg1]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg2 [get_bd_pins slv_reg2] [get_bd_pins regfilex16_v1_0_0/slv_reg2]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg3 [get_bd_pins slv_reg3] [get_bd_pins regfilex16_v1_0_0/slv_reg3]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg4 [get_bd_pins slv_reg4] [get_bd_pins regfilex16_v1_0_0/slv_reg4]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg5 [get_bd_pins slv_reg5] [get_bd_pins regfilex16_v1_0_0/slv_reg5]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg6 [get_bd_pins slv_reg6] [get_bd_pins regfilex16_v1_0_0/slv_reg6]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg7 [get_bd_pins slv_reg7] [get_bd_pins regfilex16_v1_0_0/slv_reg7]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg8 [get_bd_pins slv_reg8] [get_bd_pins regfilex16_v1_0_0/slv_reg8]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg9 [get_bd_pins slv_reg9] [get_bd_pins regfilex16_v1_0_0/slv_reg9]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg10 [get_bd_pins slv_reg10] [get_bd_pins regfilex16_v1_0_0/slv_reg10]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg11 [get_bd_pins slv_reg11] [get_bd_pins regfilex16_v1_0_0/slv_reg11]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg12 [get_bd_pins slv_reg12] [get_bd_pins regfilex16_v1_0_0/slv_reg12]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg13 [get_bd_pins slv_reg13] [get_bd_pins regfilex16_v1_0_0/slv_reg13]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg14 [get_bd_pins slv_reg14] [get_bd_pins regfilex16_v1_0_0/slv_reg14]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg15 [get_bd_pins slv_reg15] [get_bd_pins regfilex16_v1_0_0/slv_reg15]
  connect_bd_net -net slv_read0_1 [get_bd_pins slv_read0] [get_bd_pins regfilex16_v1_0_0/slv_read0]
  connect_bd_net -net slv_read10_1 [get_bd_pins slv_read10] [get_bd_pins regfilex16_v1_0_0/slv_read10]
  connect_bd_net -net slv_read11_1 [get_bd_pins slv_read11] [get_bd_pins regfilex16_v1_0_0/slv_read11]
  connect_bd_net -net slv_read12_1 [get_bd_pins slv_read12] [get_bd_pins regfilex16_v1_0_0/slv_read12]
  connect_bd_net -net slv_read13_1 [get_bd_pins slv_read13] [get_bd_pins regfilex16_v1_0_0/slv_read13]
  connect_bd_net -net slv_read14_1 [get_bd_pins slv_read14] [get_bd_pins regfilex16_v1_0_0/slv_read14]
  connect_bd_net -net slv_read15_1 [get_bd_pins slv_read15] [get_bd_pins regfilex16_v1_0_0/slv_read15]
  connect_bd_net -net slv_read1_1 [get_bd_pins slv_read1] [get_bd_pins regfilex16_v1_0_0/slv_read1]
  connect_bd_net -net slv_read2_1 [get_bd_pins slv_read2] [get_bd_pins regfilex16_v1_0_0/slv_read2]
  connect_bd_net -net slv_read3_1 [get_bd_pins slv_read3] [get_bd_pins regfilex16_v1_0_0/slv_read3]
  connect_bd_net -net slv_read4_1 [get_bd_pins slv_read4] [get_bd_pins regfilex16_v1_0_0/slv_read4]
  connect_bd_net -net slv_read5_1 [get_bd_pins slv_read5] [get_bd_pins regfilex16_v1_0_0/slv_read5]
  connect_bd_net -net slv_read6_1 [get_bd_pins slv_read6] [get_bd_pins regfilex16_v1_0_0/slv_read6]
  connect_bd_net -net slv_read7_1 [get_bd_pins slv_read7] [get_bd_pins regfilex16_v1_0_0/slv_read7]
  connect_bd_net -net slv_read8_1 [get_bd_pins slv_read8] [get_bd_pins regfilex16_v1_0_0/slv_read8]
  connect_bd_net -net slv_read9_1 [get_bd_pins slv_read9] [get_bd_pins regfilex16_v1_0_0/slv_read9]
  
  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set pcie_7x_mgt [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_7x_mgt ]

  # Create ports
  set axi_clk [ create_bd_port -dir O axi_clk ]
  set axi_reset_n [ create_bd_port -dir O -from 0 -to 0 axi_reset_n ]
  set cpu_reset [ create_bd_port -dir I -type rst cpu_reset ]
  set_property -dict [ list CONFIG.POLARITY {ACTIVE_HIGH}  ] $cpu_reset
  set pcie_perstn [ create_bd_port -dir I -type rst pcie_perstn ]
  set pcie_refclk_N [ create_bd_port -dir I pcie_refclk_N ]
  set pcie_refclk_P [ create_bd_port -dir I pcie_refclk_P ]
  set slv_read0 [ create_bd_port -dir I -from 31 -to 0 slv_read0 ]
  set slv_read1 [ create_bd_port -dir I -from 31 -to 0 slv_read1 ]
  set slv_read2 [ create_bd_port -dir I -from 31 -to 0 slv_read2 ]
  set slv_read3 [ create_bd_port -dir I -from 31 -to 0 slv_read3 ]
  set slv_read4 [ create_bd_port -dir I -from 31 -to 0 slv_read4 ]
  set slv_read5 [ create_bd_port -dir I -from 31 -to 0 slv_read5 ]
  set slv_read6 [ create_bd_port -dir I -from 31 -to 0 slv_read6 ]
  set slv_read7 [ create_bd_port -dir I -from 31 -to 0 slv_read7 ]
  set slv_read8 [ create_bd_port -dir I -from 31 -to 0 slv_read8 ]
  set slv_read9 [ create_bd_port -dir I -from 31 -to 0 slv_read9 ]
  set slv_read10 [ create_bd_port -dir I -from 31 -to 0 slv_read10 ]
  set slv_read11 [ create_bd_port -dir I -from 31 -to 0 slv_read11 ]
  set slv_read12 [ create_bd_port -dir I -from 31 -to 0 slv_read12 ]
  set slv_read13 [ create_bd_port -dir I -from 31 -to 0 slv_read13 ]
  set slv_read14 [ create_bd_port -dir I -from 31 -to 0 slv_read14 ]
  set slv_read15 [ create_bd_port -dir I -from 31 -to 0 slv_read15 ]
  set slv_reg0 [ create_bd_port -dir O -from 31 -to 0 slv_reg0 ]
  set slv_reg1 [ create_bd_port -dir O -from 31 -to 0 slv_reg1 ]
  set slv_reg2 [ create_bd_port -dir O -from 31 -to 0 slv_reg2 ]
  set slv_reg3 [ create_bd_port -dir O -from 31 -to 0 slv_reg3 ]
  set slv_reg4 [ create_bd_port -dir O -from 31 -to 0 slv_reg4 ]
  set slv_reg5 [ create_bd_port -dir O -from 31 -to 0 slv_reg5 ]
  set slv_reg6 [ create_bd_port -dir O -from 31 -to 0 slv_reg6 ]
  set slv_reg7 [ create_bd_port -dir O -from 31 -to 0 slv_reg7 ]
  set slv_reg8 [ create_bd_port -dir O -from 31 -to 0 slv_reg8 ]
  set slv_reg9 [ create_bd_port -dir O -from 31 -to 0 slv_reg9 ]
  set slv_reg10 [ create_bd_port -dir O -from 31 -to 0 slv_reg10 ]
  set slv_reg11 [ create_bd_port -dir O -from 31 -to 0 slv_reg11 ]
  set slv_reg12 [ create_bd_port -dir O -from 31 -to 0 slv_reg12 ]
  set slv_reg13 [ create_bd_port -dir O -from 31 -to 0 slv_reg13 ]
  set slv_reg14 [ create_bd_port -dir O -from 31 -to 0 slv_reg14 ]
  set slv_reg15 [ create_bd_port -dir O -from 31 -to 0 slv_reg15 ]

  # Create instance: axi_periphs
  create_hier_cell_axi_periphs [current_bd_instance .] axi_periphs

  # Create instance: pcie_bridge
  create_hier_cell_pcie_bridge [current_bd_instance .] pcie_bridge

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins axi_periphs/S00_AXI] [get_bd_intf_pins pcie_bridge/M_AXI]
  connect_bd_intf_net -intf_net axi_pcie_0_pcie_7x_mgt [get_bd_intf_ports pcie_7x_mgt] [get_bd_intf_pins pcie_bridge/pcie_7x_mgt]

  # Create port connections
  connect_bd_net -net IBUF_DS_N_1 [get_bd_ports pcie_refclk_N] [get_bd_pins pcie_bridge/IBUF_DS_N]
  connect_bd_net -net IBUF_DS_P_1 [get_bd_ports pcie_refclk_P] [get_bd_pins pcie_bridge/IBUF_DS_P]
  connect_bd_net -net INTX_MSI_Grant -boundary_type upper [get_bd_pins pcie_bridge/INTX_MSI_Grant]
  connect_bd_net -net MSI_Vector_Width -boundary_type upper [get_bd_pins pcie_bridge/MSI_Vector_Width]
  connect_bd_net -net MSI_enable -boundary_type upper [get_bd_pins pcie_bridge/MSI_enable]
  connect_bd_net -net aux_reset_in_1 [get_bd_ports pcie_perstn] [get_bd_pins pcie_bridge/aux_reset_in]
  connect_bd_net -net axi_pcie_0_axi_aclk_out [get_bd_ports axi_clk] [get_bd_pins axi_periphs/s_axi_aclk] [get_bd_pins pcie_bridge/axi_aclk_out]
  connect_bd_net -net interrupt_out -boundary_type upper [get_bd_pins pcie_bridge/interrupt_out]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins axi_periphs/S00_ARESETN] [get_bd_pins pcie_bridge/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_ports axi_reset_n] [get_bd_pins axi_periphs/s_axi_aresetn] [get_bd_pins pcie_bridge/peripheral_aresetn]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg0 [get_bd_ports slv_reg0] [get_bd_pins axi_periphs/slv_reg0]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg1 [get_bd_ports slv_reg1] [get_bd_pins axi_periphs/slv_reg1]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg2 [get_bd_ports slv_reg2] [get_bd_pins axi_periphs/slv_reg2]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg3 [get_bd_ports slv_reg3] [get_bd_pins axi_periphs/slv_reg3]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg4 [get_bd_ports slv_reg4] [get_bd_pins axi_periphs/slv_reg4]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg5 [get_bd_ports slv_reg5] [get_bd_pins axi_periphs/slv_reg5]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg6 [get_bd_ports slv_reg6] [get_bd_pins axi_periphs/slv_reg6]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg7 [get_bd_ports slv_reg7] [get_bd_pins axi_periphs/slv_reg7]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg8 [get_bd_ports slv_reg8] [get_bd_pins axi_periphs/slv_reg8]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg9 [get_bd_ports slv_reg9] [get_bd_pins axi_periphs/slv_reg9]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg10 [get_bd_ports slv_reg10] [get_bd_pins axi_periphs/slv_reg10]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg11 [get_bd_ports slv_reg11] [get_bd_pins axi_periphs/slv_reg11]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg12 [get_bd_ports slv_reg12] [get_bd_pins axi_periphs/slv_reg12]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg13 [get_bd_ports slv_reg13] [get_bd_pins axi_periphs/slv_reg13]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg14 [get_bd_ports slv_reg14] [get_bd_pins axi_periphs/slv_reg14]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg15 [get_bd_ports slv_reg15] [get_bd_pins axi_periphs/slv_reg15]
  connect_bd_net -net reset_rtl_1 [get_bd_ports cpu_reset] [get_bd_pins pcie_bridge/ext_reset_in]
  connect_bd_net -net slv_read0_1 [get_bd_ports slv_read0] [get_bd_pins axi_periphs/slv_read0]
  connect_bd_net -net slv_read10_1 [get_bd_ports slv_read10] [get_bd_pins axi_periphs/slv_read10]
  connect_bd_net -net slv_read11_1 [get_bd_ports slv_read11] [get_bd_pins axi_periphs/slv_read11]
  connect_bd_net -net slv_read12_1 [get_bd_ports slv_read12] [get_bd_pins axi_periphs/slv_read12]
  connect_bd_net -net slv_read13_1 [get_bd_ports slv_read13] [get_bd_pins axi_periphs/slv_read13]
  connect_bd_net -net slv_read14_1 [get_bd_ports slv_read14] [get_bd_pins axi_periphs/slv_read14]
  connect_bd_net -net slv_read15_1 [get_bd_ports slv_read15] [get_bd_pins axi_periphs/slv_read15]
  connect_bd_net -net slv_read1_1 [get_bd_ports slv_read1] [get_bd_pins axi_periphs/slv_read1]
  connect_bd_net -net slv_read2_1 [get_bd_ports slv_read2] [get_bd_pins axi_periphs/slv_read2]
  connect_bd_net -net slv_read3_1 [get_bd_ports slv_read3] [get_bd_pins axi_periphs/slv_read3]
  connect_bd_net -net slv_read4_1 [get_bd_ports slv_read4] [get_bd_pins axi_periphs/slv_read4]
  connect_bd_net -net slv_read5_1 [get_bd_ports slv_read5] [get_bd_pins axi_periphs/slv_read5]
  connect_bd_net -net slv_read6_1 [get_bd_ports slv_read6] [get_bd_pins axi_periphs/slv_read6]
  connect_bd_net -net slv_read7_1 [get_bd_ports slv_read7] [get_bd_pins axi_periphs/slv_read7]
  connect_bd_net -net slv_read8_1 [get_bd_ports slv_read8] [get_bd_pins axi_periphs/slv_read8]
  connect_bd_net -net slv_read9_1 [get_bd_ports slv_read9] [get_bd_pins axi_periphs/slv_read9]

  # Create address segments
  create_bd_addr_seg -range 0x8000 -offset 0x90000 [get_bd_addr_spaces pcie_bridge/axi_pcie_0/M_AXI] [get_bd_addr_segs axi_periphs/axi_bram_ctrl_0/S_AXI/Mem0] SEG_axi_bram_ctrl_0_Mem0
  create_bd_addr_seg -range 0x10000 -offset 0xA0000 [get_bd_addr_spaces pcie_bridge/axi_pcie_0/M_AXI] [get_bd_addr_segs axi_periphs/regfilex16_v1_0_0/s00_axi/reg0] SEG_regfilex16_v1_0_0_reg0
  

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


