
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
# source system_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7vx690tffg1761-2
#    set_property BOARD_PART xilinx.com:vc709:part0:1.5 [current_project]


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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_7x_mgt

  # Create pins
  create_bd_pin -dir I -from 0 -to 0 IBUF_DS_N
  create_bd_pin -dir I -from 0 -to 0 IBUF_DS_P
  create_bd_pin -dir O -from 0 -to 0 -type rst Rst
  create_bd_pin -dir O -type clk S00_ACLK
  create_bd_pin -dir I -type rst aux_reset_in
  create_bd_pin -dir I -type rst ext_reset_in
  create_bd_pin -dir I -type rst sys_rst_n

  # Create instance: axi_pcie3_0, and set properties
  set axi_pcie3_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_pcie3:1.0 axi_pcie3_0 ]
  set_property -dict [ list CONFIG.PCIE_BOARD_INTERFACE {pcie_express} CONFIG.SYS_RST_N_BOARD_INTERFACE {pcie_perst} CONFIG.axi_data_width {128_bit} CONFIG.axisten_freq {125} CONFIG.pf0_bar0_scale {Megabytes} CONFIG.pf0_bar0_size {16} CONFIG.pf0_device_id {7024} CONFIG.pl_link_cap_max_link_speed {5.0_GT/s} CONFIG.pl_link_cap_max_link_width {X4} CONFIG.plltype {QPLL1}  ] $axi_pcie3_0

  # Create instance: axi_pcie3_0_axi_periph, and set properties
  set axi_pcie3_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_pcie3_0_axi_periph ]
  set_property -dict [ list CONFIG.NUM_MI {1}  ] $axi_pcie3_0_axi_periph

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
  connect_bd_intf_net -intf_net axi_pcie3_0_M_AXI [get_bd_intf_pins axi_pcie3_0/M_AXI] [get_bd_intf_pins axi_pcie3_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net axi_pcie3_0_axi_periph_M00_AXI [get_bd_intf_pins M00_AXI] [get_bd_intf_pins axi_pcie3_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net axi_pcie3_0_pcie_7x_mgt [get_bd_intf_pins pcie_7x_mgt] [get_bd_intf_pins axi_pcie3_0/pcie_7x_mgt]

  # Create port connections
  connect_bd_net -net IBUF_DS_N_1 [get_bd_pins IBUF_DS_N] [get_bd_pins util_ds_buf_0/IBUF_DS_N]
  connect_bd_net -net IBUF_DS_P_1 [get_bd_pins IBUF_DS_P] [get_bd_pins util_ds_buf_0/IBUF_DS_P]
  connect_bd_net -net aux_reset_in_1 [get_bd_pins aux_reset_in] [get_bd_pins proc_sys_reset_0/aux_reset_in]
  connect_bd_net -net axi_pcie3_0_axi_aclk [get_bd_pins S00_ACLK] [get_bd_pins axi_pcie3_0/axi_aclk] [get_bd_pins axi_pcie3_0/axi_ctl_aclk] [get_bd_pins axi_pcie3_0_axi_periph/ACLK] [get_bd_pins axi_pcie3_0_axi_periph/M00_ACLK] [get_bd_pins axi_pcie3_0_axi_periph/S00_ACLK] [get_bd_pins fit_timer_0/Clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
  connect_bd_net -net fit_timer_0_Interrupt [get_bd_pins axi_pcie3_0/intx_msi_request] [get_bd_pins fit_timer_0/Interrupt]
  connect_bd_net -net pcie_perst_1 [get_bd_pins sys_rst_n] [get_bd_pins axi_pcie3_0/sys_rst_n]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins axi_pcie3_0_axi_periph/ARESETN] [get_bd_pins proc_sys_reset_0/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins Rst] [get_bd_pins axi_pcie3_0_axi_periph/M00_ARESETN] [get_bd_pins axi_pcie3_0_axi_periph/S00_ARESETN] [get_bd_pins fit_timer_0/Rst] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
  connect_bd_net -net reset_rtl_1 [get_bd_pins ext_reset_in] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net util_ds_buf_0_IBUF_OUT [get_bd_pins axi_pcie3_0/refclk] [get_bd_pins util_ds_buf_0/IBUF_OUT]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins axi_pcie3_0/msi_vector_num] [get_bd_pins xlconstant_0/dout]
  
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
  set pcie_perst [ create_bd_port -dir I -type rst pcie_perst ]
  set_property -dict [ list CONFIG.POLARITY {ACTIVE_LOW}  ] $pcie_perst
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

  # Create instance: pcie_bridge
  create_hier_cell_pcie_bridge [current_bd_instance .] pcie_bridge

  # Create instance: regfilex16_v1_0_0, and set properties
  set regfilex16_v1_0_0 [ create_bd_cell -type ip -vlnv user.org:user:regfilex16_v1_0:1.0 regfilex16_v1_0_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_pcie3_0_axi_periph_M00_AXI [get_bd_intf_pins pcie_bridge/M00_AXI] [get_bd_intf_pins regfilex16_v1_0_0/s00_axi]
  connect_bd_intf_net -intf_net pcie_bridge_pcie_7x_mgt [get_bd_intf_ports pcie_7x_mgt] [get_bd_intf_pins pcie_bridge/pcie_7x_mgt]

  # Create port connections
  connect_bd_net -net IBUF_DS_N_1 [get_bd_ports pcie_refclk_N] [get_bd_pins pcie_bridge/IBUF_DS_N]
  connect_bd_net -net IBUF_DS_P_1 [get_bd_ports pcie_refclk_P] [get_bd_pins pcie_bridge/IBUF_DS_P]
  connect_bd_net -net aux_reset_in_1 [get_bd_ports pcie_perstn] [get_bd_pins pcie_bridge/aux_reset_in]
  connect_bd_net -net axi_pcie3_0_axi_aclk [get_bd_ports axi_clk] [get_bd_pins pcie_bridge/S00_ACLK] [get_bd_pins regfilex16_v1_0_0/s00_axi_aclk]
  connect_bd_net -net pcie_perst_1 [get_bd_ports pcie_perst] [get_bd_pins pcie_bridge/sys_rst_n]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_ports axi_reset_n] [get_bd_pins pcie_bridge/Rst] [get_bd_pins regfilex16_v1_0_0/s00_axi_aresetn]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg0 [get_bd_ports slv_reg0] [get_bd_pins regfilex16_v1_0_0/slv_reg0]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg1 [get_bd_ports slv_reg1] [get_bd_pins regfilex16_v1_0_0/slv_reg1]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg2 [get_bd_ports slv_reg2] [get_bd_pins regfilex16_v1_0_0/slv_reg2]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg3 [get_bd_ports slv_reg3] [get_bd_pins regfilex16_v1_0_0/slv_reg3]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg4 [get_bd_ports slv_reg4] [get_bd_pins regfilex16_v1_0_0/slv_reg4]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg5 [get_bd_ports slv_reg5] [get_bd_pins regfilex16_v1_0_0/slv_reg5]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg6 [get_bd_ports slv_reg6] [get_bd_pins regfilex16_v1_0_0/slv_reg6]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg7 [get_bd_ports slv_reg7] [get_bd_pins regfilex16_v1_0_0/slv_reg7]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg8 [get_bd_ports slv_reg8] [get_bd_pins regfilex16_v1_0_0/slv_reg8]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg9 [get_bd_ports slv_reg9] [get_bd_pins regfilex16_v1_0_0/slv_reg9]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg10 [get_bd_ports slv_reg10] [get_bd_pins regfilex16_v1_0_0/slv_reg10]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg11 [get_bd_ports slv_reg11] [get_bd_pins regfilex16_v1_0_0/slv_reg11]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg12 [get_bd_ports slv_reg12] [get_bd_pins regfilex16_v1_0_0/slv_reg12]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg13 [get_bd_ports slv_reg13] [get_bd_pins regfilex16_v1_0_0/slv_reg13]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg14 [get_bd_ports slv_reg14] [get_bd_pins regfilex16_v1_0_0/slv_reg14]
  connect_bd_net -net regfilex16_v1_0_0_slv_reg15 [get_bd_ports slv_reg15] [get_bd_pins regfilex16_v1_0_0/slv_reg15]
  connect_bd_net -net reset_rtl_1 [get_bd_ports cpu_reset] [get_bd_pins pcie_bridge/ext_reset_in]
  connect_bd_net -net slv_read0_1 [get_bd_ports slv_read0] [get_bd_pins regfilex16_v1_0_0/slv_read0]
  connect_bd_net -net slv_read10_1 [get_bd_ports slv_read10] [get_bd_pins regfilex16_v1_0_0/slv_read10]
  connect_bd_net -net slv_read11_1 [get_bd_ports slv_read11] [get_bd_pins regfilex16_v1_0_0/slv_read11]
  connect_bd_net -net slv_read12_1 [get_bd_ports slv_read12] [get_bd_pins regfilex16_v1_0_0/slv_read12]
  connect_bd_net -net slv_read13_1 [get_bd_ports slv_read13] [get_bd_pins regfilex16_v1_0_0/slv_read13]
  connect_bd_net -net slv_read14_1 [get_bd_ports slv_read14] [get_bd_pins regfilex16_v1_0_0/slv_read14]
  connect_bd_net -net slv_read15_1 [get_bd_ports slv_read15] [get_bd_pins regfilex16_v1_0_0/slv_read15]
  connect_bd_net -net slv_read1_1 [get_bd_ports slv_read1] [get_bd_pins regfilex16_v1_0_0/slv_read1]
  connect_bd_net -net slv_read2_1 [get_bd_ports slv_read2] [get_bd_pins regfilex16_v1_0_0/slv_read2]
  connect_bd_net -net slv_read3_1 [get_bd_ports slv_read3] [get_bd_pins regfilex16_v1_0_0/slv_read3]
  connect_bd_net -net slv_read4_1 [get_bd_ports slv_read4] [get_bd_pins regfilex16_v1_0_0/slv_read4]
  connect_bd_net -net slv_read5_1 [get_bd_ports slv_read5] [get_bd_pins regfilex16_v1_0_0/slv_read5]
  connect_bd_net -net slv_read6_1 [get_bd_ports slv_read6] [get_bd_pins regfilex16_v1_0_0/slv_read6]
  connect_bd_net -net slv_read7_1 [get_bd_ports slv_read7] [get_bd_pins regfilex16_v1_0_0/slv_read7]
  connect_bd_net -net slv_read8_1 [get_bd_ports slv_read8] [get_bd_pins regfilex16_v1_0_0/slv_read8]
  connect_bd_net -net slv_read9_1 [get_bd_ports slv_read9] [get_bd_pins regfilex16_v1_0_0/slv_read9]

  # Create address segments
  create_bd_addr_seg -range 0x10000 -offset 0x44A00000 [get_bd_addr_spaces pcie_bridge/axi_pcie3_0/M_AXI] [get_bd_addr_segs regfilex16_v1_0_0/s00_axi/reg0] SEG_regfilex16_v1_0_0_reg0
  

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


