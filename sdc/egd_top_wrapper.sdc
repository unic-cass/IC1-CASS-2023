###############################################################################
# Created by write_sdc
# Fri Oct 27 05:14:19 2023
###############################################################################
current_design egd_top_wrapper
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 25.0000 [get_ports {wb_clk_i}]
set_clock_transition 0.1500 [get_clocks {clk}]
set_clock_uncertainty 0.2500 clk
set_propagated_clock [get_clocks {clk}]
set_clock_latency -source -min 4.6500 [get_clocks {clk}]
set_clock_latency -source -max 5.5700 [get_clocks {clk}]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.1900 [get_ports {la_data_out_23_16[7]}]
set_load -pin_load 0.1900 [get_ports {la_data_out_23_16[6]}]
set_load -pin_load 0.1900 [get_ports {la_data_out_23_16[5]}]
set_load -pin_load 0.1900 [get_ports {la_data_out_23_16[4]}]
set_load -pin_load 0.1900 [get_ports {la_data_out_23_16[3]}]
set_load -pin_load 0.1900 [get_ports {la_data_out_23_16[2]}]
set_load -pin_load 0.1900 [get_ports {la_data_out_23_16[1]}]
set_load -pin_load 0.1900 [get_ports {la_data_out_23_16[0]}]
set_load -pin_load 0.1900 [get_ports {la_data_out_26_24[2]}]
set_load -pin_load 0.1900 [get_ports {la_data_out_26_24[1]}]
set_load -pin_load 0.1900 [get_ports {la_data_out_26_24[0]}]
set_load -pin_load 0.1900 [get_ports {la_data_out_30_27[3]}]
set_load -pin_load 0.1900 [get_ports {la_data_out_30_27[2]}]
set_load -pin_load 0.1900 [get_ports {la_data_out_30_27[1]}]
set_load -pin_load 0.1900 [get_ports {la_data_out_30_27[0]}]
set_input_transition 0.6100 [get_ports {wb_clk_i}]
set_timing_derate -early 0.9500
set_timing_derate -late 1.0500
###############################################################################
# Design Rules
###############################################################################
set_max_transition 0.7500 [current_design]
set_max_fanout 12.0000 [current_design]
