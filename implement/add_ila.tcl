# this subscript adds an In-system Logic Analyzer (ILA) to the design

# These are the signal we want to see in the ILA
set_property mark_debug true [get_nets [list cpu_reset]]
#
create_debug_core ila1 ila
set_property C_DATA_DEPTH 2048 [get_debug_cores ila1]

# Now find all the nets that are marked for debug.
set ila_nets [get_nets -hier -filter {MARK_DEBUG==1}]
set num_ila_nets [llength [get_nets [list $ila_nets]]]

set_property port_width 1 [get_debug_ports ila1/clk]
set_property port_width $num_ila_nets [get_debug_ports ila1/probe0]
connect_debug_port ila1/probe0 [get_nets [list $ila_nets ]]
get_nets [list $ila_nets]
connect_debug_port ila1/clk [get_nets [list pcie_sys_i/axi_clk ]]

write_debug_probes -force ./results/ila1.ltx
