# This script sets up a Vivado project with all ip references resolved.
# tclapp::install ultrafast
file delete -force proj.xpr *.os *.jou *.log implement/* proj.srcs proj.cache proj.runs
#exec find ../source/ip ! -name "*.zip" -type f -delete
#
create_project -force proj 
#set_property board_part xilinx.com:kc705:part0:1.1 [current_project]
set_property board_part xilinx.com:vc709:part0:1.5 [current_project]
set_property target_language VHDL [current_project]
set_property default_lib work [current_project]
load_features ipintegrator
tclapp::install ultrafast -quiet
# this is to bypass error about muxed reference clock to MMCM.
set_property is_enabled false [get_drc_checks REQP-119] 

# Load in the custom IP block for the register file.
file delete -force ./ip
file mkdir ./ip
set_property ip_repo_paths ./ip [current_fileset]
update_ip_catalog
update_ip_catalog -add_ip ../source/regfilex16/user.org_user_regfilex16_v1_0_1.0.zip -repo_path ./ip

# Recreate the Block Diagram of the processor system.
source ../source/system.tcl
generate_target {synthesis implementation} [get_files ./proj.srcs/sources_1/bd/system/system.bd]

# Read in the hdl source.
read_vhdl [glob ../source/top.vhd]

read_xdc ../source/top.xdc


close_project



