##----FM Common Env Setting---##
set synopsys_auto_setup true
set hdlin_unresolved_modules black_box
set hdlin_dwroot /tools/synopsys/syn-P-2019.03-SP3
set hdlin_sverilog_std 2012

set verification_timeout_limit 5:00:00
set verification_failing_point_limit 1000
set verification_run_analyze_points false
set verification_clock_gate_edge_analysis true
set verification_blackbox_match_mode identity
set verification_constant_prop_mode top
set verification_set_undriven_signals "binary"
set verification_verify_directly_undriven_output true
set name_match_multibit_register_reverse_order false 

set signature_analysis_primary_output true
set signature_analysis_match_compare_points true
set verification_effort_level high

set PRJHOME ../design/rtl 
set USER yyy

read_db -technology_library {
    ../lib/ss_1v62_125c.db  \
    ../lib/memory.db    \
}

## Reference
read_sverilog -container r -vcs {-f ./top_reference_filelist.f}

set_top                     r:/WORK/top_top
set_implementation_design   r:/WORK/top_top
set_black_box               r:/WORK/top_top/reg_top_inst
set_constant                r:/WORK/top_top/pad_top_inst/scan_mode_reg/Q 0

## Implementation
read_sverilog -container i -vcs {-f ./top_implementation_filelist.f}

set_top                     i:/WORK/top_top
set_implementation_design   i:/WORK/top_top
set_black_box               i:/WORK/top_top/chip_reg_inst
set_constant                i:/WORK/top_top/pad_top_inst/scan_mode_reg/Q 0

## Match
match 

report_matched_points     > matched_point.rpt 
report_unmatched_points   > unmatched_point.rpt 

## Verify
verify 

report_passing_points       > passing.rpt 
report_failing_points       > failing.rpt
report_unverified_points    > unverified.rpt 
report_dont_verify_points   > dont_verify.rpt 
report_black_boxes          > black_boxes.rpt