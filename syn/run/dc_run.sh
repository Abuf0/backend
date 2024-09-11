#! /bin/csh -f

### set neccesary env
setenv TOP hdmi_colorbar_top
setenv VER DEMO_v1
setenv DATE `date +%y%m%d`
setenv syn_style rtl2syn
# rtl2syn / dft2iso

### create new folders
cd ../net/ 
if (-e ${DATE}) then
else mkdir ${DATE}${VER}
endif

cd ../rpt/
if (-e ${DATE}) then
else mkdir ${DATE}${VER}
endif

cd ../sdc/
if (-e ${DATE}) then
else mkdir ${DATE}${VER}
endif

### run script
cd ../run/
/tools/synopsys/syn-P-2019.03-SP3/bin/dc_shell-xg-t -f ../scr/compile.tcl |tee ../log/${TOP}_${VER}_${DATE}_compile.log