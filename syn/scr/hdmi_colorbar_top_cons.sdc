### sdc version
set sdc_version 1.4

### Set Variaty/Units

### DRC-- design rule constrants
set_input_transition 2 [all_inputs]
set_max_transition 2.5 [current_design]
set_max_fanout 50 [current_design]
set_load 50 [all_outputs]

### Timing constrants
# clock definitions/clock lantency/uncertainty/groups/icg
## clk_100m domain
create_clock [get_pins crgu_inst/clk_in] -name clk_100m -period 10 -add
set_clock_uncertainty -setup 0 [get_clocks clk_100m]
set_clock_uncertainty -hold 0.3 [get_clocks clk_100m]

# divider output
create_generated_clock [get_pins crgu_inst/clk_out2] -name clk_20m   -source [get_pins crgu_inst/clk_in]    -master_clock clk_100m  -divide_by 5  -add
set_clock_uncertainty -setup 0 [get_clocks clk_20m]
set_clock_uncertainty -hold 0.3 [get_clocks clk_20m]

# invert output
## create_generated_clock [get_pins crgu_inst/dtc_clkinvd4_inst/Y]
create_generated_clock [get_pins crgu_inst/clk_in_inv] -name clk_100m_inv   -source [get_pins crgu_inst/clk_in]    -master_clock clk_100m  -divide_by 1  -combination -invert  -add
set_clock_uncertainty -setup 0 [get_clocks clk_100m_inv]
set_clock_uncertainty -hold 0.3 [get_clocks clk_100m_inv]

## groups
#set_clock_groups    -name clk_grp_0 -group [get_clocks  {clk_100m clk_100m_inv clk_20m}]      
#                    -asynchronous                                                                                                      

## icg
set_clock_gating_check  -rise  -setup 0.5 [current_design]
set_clock_gating_check  -fall  -setup 0.5 [current_design]
set_clock_gating_check  -rise  -hold 0.5 [current_design]
set_clock_gating_check  -fall  -hold 0.5 [current_design]

# set input/output delay (output clock can be virtual clock)
set_input_delay 5 [all_inputs]  -max  -clock clk_100m
set_output_delay 5 [all_outputs]    -min    -clock clk_100m

### Timing exceptions -- multi-cycle/false path/disable_timing/case_analysis
# set_false_path -from    -to
# set_disable_timing -from  -to
# set_multicycle_path   -setup/hold 2 -from  -to
# set_case_analysis 0 xx