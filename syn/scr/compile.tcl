### Set env and path ###
set TOP [getenv TOP]
set INCLUDE_PATH ../hdl/
set SCRIPT_PATH ../scr/
set NETLIST_PATH ../net/
set REPORT_PATH ../rpt/
set DDC_PATH ../ddc/
set SDC_PATH ../sdc/
set SDF_PATH ../sdf/
set LIB_PATH ../lib/

### Develop HDL files ###
set RTL_INCLUDE ${INCLUDE_PATH}rtl_include.v
current_design $TOP

### Specify libraries ###
set base_path { /ext/technology/smic/0.18um/IP/StdCell/aci/sc-m/synopsys/   \
                ${LIB_PATH} \
    }
set search_path [concat $search_path [list . /tools/synopsys/syn-P-2019.03-SP3/libraries/syn    \
                 $base_path  \
    ]]
# set link_library -- 所有相关电路的db库（包括stdcell、ip等）
set link_library [list \
    ss_1v62_125c.db \
    sram1152x16m8_slow_syn.db   \
    IO.db   \
    ]
# set target_library -- 综合生成网表的目标工艺db库
set target_library [list    \
    ss_1v62_125c.db \
    ]
# set symbol_library [optional] --GUI界面图形符号库

# set synthetic_library -- DesignWare的db库（包括标准的verilog运算符、扩展的运算符）
set synthetic_library [list\
    standard.sldb   \
    dw_foundation.sldb  \
    ]
# set create_mw_lib [optional] --milkyway物理库
# set mw_design_library $TOP
# create_mw_lib -technology $tech_file    \
#               -mw_reference_library $mw_reference_library   \
#                                     $mw_design_library
# open_mw_lib $mw_design_library

### Read design ###
analyze -format sverilog ${RTL_INCLUDE} -define simc180
elaborate $TOP

### Define design enviroment ###
set_operating_conditions ss_1v62_125c
set_wire_load_mode top
# set_drive
# set_driving_cell
# set_load
# set_fanout_load
# set_min_library

### Set design constraints ###
source -e -v ${SCRIPT_PATH}${TOP}_cons.sdc

### Select compile strategy

### Synthesize and optimize the design ###
# ICG
set INSERT_CG true
set CG_MIN_BITWIDTH 5
# DONT USE
set DONT_USE enable
set DONT_USE_CELL {
    */DLY*  \
    }
# DONT TOUCH
set DONT_TOUCH enable
set DONT_TOUCH_CELL {
    }

set congestion_high_effort false
# POWER
set power_high_effort true
# Others
set_fix_multiple_port_nets  -feedthroughs   -outputs    -buffer_constrant
compile_ultra -no_autoungroup -no_boundary_optimization -gate_clock -retime -scan -no_seq_output_inversion

### Analyze and resolve design problems ###
check_design > ${REPORT_PATH}${DATE}${VER}/${TOP}_check_design.rpt
check_timing > ${REPORT_PATH}${DATE}${VER}/${TOP}_check_timing.rpt
# report_clock > ${REPORT+PATH}${DATE}${VER}/${TOP}_clock_pre.rpt
report_area -hierarchy -nosplit > ${REPORT_PATH}${DATE}${VER}/${TOP}_area_pre.rpt
report_constranit -all > ${REPORT_PATH}${DATE}${VER}/${TOP}_all_vio_pre.rpt
# report_clock_gating -hier > ${REPORT_PATH}${DATE}${VER}/${TOP}_icg_pre.rpt
report_timing -loops -max_path 100 -nworst 100 > ${REPORT_PATH}${DATE}${VER}/${TOP}_loop_pre.rpt
# report_power > ${REPORT_PATH}${DATE}${VER}/${TOP}_power_pre.rpt

### Save the design database ###
write_sdc -verion 1.4 ${SDC_PATH}${DATA}${VER}/${TOP}_cons.sdc
write -format ddc -hierarchy -output ${DDC_PATH}${TOP}${VER}_${DATE}.ddc
write -format verilog -hierarchy -output ${NETLIST_PATH}${DATE}${VER}/${TOP}.v
