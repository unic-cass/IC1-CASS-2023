###############################################################################
# Created by write_sdc
# Thu Oct 26 16:52:06 2023
###############################################################################
current_design R4_butter
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 25.0000 
set_clock_uncertainty 0.2500 clk
set_clock_latency -source -min 4.5000 [get_clocks {clk}]
set_clock_latency -source -max 6.0000 [get_clocks {clk}]
###############################################################################
# Environment
###############################################################################
set_input_transition -min 0.0500 [get_ports {la_oenb[7]}]
set_input_transition -max 0.4400 [get_ports {la_oenb[7]}]
set_input_transition -min 0.0500 [get_ports {la_oenb[6]}]
set_input_transition -max 0.4400 [get_ports {la_oenb[6]}]
set_input_transition -min 0.0500 [get_ports {la_oenb[5]}]
set_input_transition -max 0.4400 [get_ports {la_oenb[5]}]
set_input_transition -min 0.0500 [get_ports {la_oenb[4]}]
set_input_transition -max 0.4400 [get_ports {la_oenb[4]}]
set_input_transition -min 0.0500 [get_ports {la_oenb[3]}]
set_input_transition -max 0.4400 [get_ports {la_oenb[3]}]
set_input_transition -min 0.0500 [get_ports {la_oenb[2]}]
set_input_transition -max 0.4400 [get_ports {la_oenb[2]}]
set_input_transition -min 0.0500 [get_ports {la_oenb[1]}]
set_input_transition -max 0.4400 [get_ports {la_oenb[1]}]
set_input_transition -min 0.0500 [get_ports {la_oenb[0]}]
set_input_transition -max 0.4400 [get_ports {la_oenb[0]}]
set_timing_derate -early 0.9500
set_timing_derate -late 1.0500
###############################################################################
# Design Rules
###############################################################################
set_max_transition 0.7500 [current_design]
set_max_fanout 10.0000 [current_design]
