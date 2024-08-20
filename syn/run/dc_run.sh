#! /bin/csh -f

### set neccesary env
setenv TOP top
setenv VER silver_v1
setenv DATA `data +%y%m%d`
setenv syn_style rtl2syn
# rtl2syn / dft2iso

### create new folders
cd ../net/
if (-e ${DATA}) then
else mkdir ${DATA}${VER}
endif
# cd ../rpt/
# cd ../sdc/

### run script
cd ../run/
/tools/synopsys/syn-P-2019.03-SP3/bin/dc_shell-xg-t -f ../scr/compile.tcl |tee ../log/${TOP}_${VER}_${DATA}_compile.log