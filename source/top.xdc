
# Script to compile the FPGA with zynq processor system all the way to bit file.
#report_timing_summary -file $outputDir/post_synth_timing_summary.rpt
#report_utilization -file $outputDir/post_synth_util.rpt
# this is to bypass error about muxed reference clock to MMCM.
# this tells the compiler about the configuration bank supply voltage.
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 2.5 [current_design]
#
set IOSTANDARD_VADJ LVCMOS33
create_clock -period 38.400 -name clkin26 -waveform {0.000 19.200} [get_ports clkin26]
set_property IOSTANDARD $IOSTANDARD_VADJ [get_ports clkin26]
#
#set_clock_groups -physically_exclusive -group clkout208_clk_wiz_0 -group userclk1
set_clock_groups -name lime_clk_group -asynchronous -group [get_clocks -include_generated_clocks clkin26] -group [get_clocks userclk1]
#
set_property IOSTANDARD $IOSTANDARD_VADJ [get_ports pcie_perstn]
set_property PACKAGE_PIN G25 [get_ports pcie_perstn]
set_property PACKAGE_PIN U7 [get_ports pcie_refclk_N]
#
set_property IOSTANDARD LVCMOS15 [get_ports cpu_reset]
set_property PACKAGE_PIN AB7 [get_ports cpu_reset]
#
set_property IOB TRUE [get_ports {lime1_data* lime1_tx_iq_sel lime1_rx_iq_sel}]
#set_property DONT_TOUCH true [get_property PARENT [get_nets lime1_tx_iq_sel]]
set_output_delay -clock clkin26 -max 30.000 [get_ports {lime1_data* lime1_tx_iq_sel}]
set_output_delay -clock clkin26 -min 0.000 [get_ports {lime1_data* lime1_tx_iq_sel}]
set_input_delay -clock clkin26 -max 30.000 [get_ports {lime1_data* lime1_rx_iq_sel}]
set_input_delay -clock clkin26 -min 1.000 [get_ports {lime1_data* lime1_rx_iq_sel}]
#
set_property IOB TRUE [get_ports {lime3_data* lime3_tx_iq_sel lime3_rx_iq_sel}]
#set_property DONT_TOUCH true [get_property PARENT [get_nets lime3_tx_iq_sel]]
set_output_delay -clock clkin26 -max 30.000 [get_ports {lime3_data* lime3_tx_iq_sel}]
set_output_delay -clock clkin26 -min 0.000 [get_ports {lime3_data* lime3_tx_iq_sel}]
set_input_delay -clock clkin26 -max 30.000 [get_ports {lime3_data* lime3_rx_iq_sel}]
set_input_delay -clock clkin26 -min 1.000 [get_ports {lime3_data* lime3_rx_iq_sel}]
#
set_property IOB TRUE [get_ports {lime2_data* lime2_rx_iq_sel}]
set_input_delay -clock clkin26 -max 30.000 [get_ports {lime2_data* lime2_rx_iq_sel}]
set_input_delay -clock clkin26 -min 1.000 [get_ports {lime2_data* lime2_rx_iq_sel}]
#
set_property IOB TRUE [get_ports {lime4_data* lime4_rx_iq_sel}]
set_input_delay -clock clkin26 -max 30.000 [get_ports {lime4_data* lime4_rx_iq_sel}]
set_input_delay -clock clkin26 -min 1.000 [get_ports {lime4_data* lime4_rx_iq_sel}]
# Note LED[7:5] are on Vadj bank.
set_property IOSTANDARD $IOSTANDARD_VADJ [get_ports {led[7]}]
set_property PACKAGE_PIN F16 [get_ports {led[7]}]
set_property IOSTANDARD $IOSTANDARD_VADJ [get_ports {led[6]}]
set_property PACKAGE_PIN E18 [get_ports {led[6]}]
set_property IOSTANDARD $IOSTANDARD_VADJ [get_ports {led[5]}]
set_property PACKAGE_PIN G19 [get_ports {led[5]}]
set_property IOSTANDARD $IOSTANDARD_VADJ [get_ports {led[4]}]
set_property PACKAGE_PIN AE26 [get_ports {led[4]}]
# Note LED[3:0] are on 1.5V bank.
set_property IOSTANDARD LVCMOS15 [get_ports {led[3]}]
set_property PACKAGE_PIN AB9 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS15 [get_ports {led[2]}]
set_property PACKAGE_PIN AC9 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS15 [get_ports {led[1]}]
set_property PACKAGE_PIN AA8 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS15 [get_ports {led[0]}]
set_property PACKAGE_PIN AB8 [get_ports {led[0]}]
#
