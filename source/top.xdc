
# Script to compile the FPGA with zynq processor system all the way to bit file.
#report_timing_summary -file $outputDir/post_synth_timing_summary.rpt
#report_utilization -file $outputDir/post_synth_util.rpt
# this is to bypass error about muxed reference clock to MMCM.
# this tells the compiler about the configuration bank supply voltage.
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 2.5 [current_design]
#
set IOSTANDARD_VADJ LVCMOS33