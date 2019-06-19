
clear
set type double, permanently
set more off

do prepare_hcfa.do

do tableA2_leave_out_states.do

do tableA3_identification.do

do tableA4_alt_IVs.do

**
** NOTE: Results are in log file, not in table
**
do tableA5_gls

do tableA6_hcfa.do

do tableA7_gsp.do

do tableA8_other_goods.do

do tableA9_nonlinear.do

do tableA10_geo_time.do

do tableA11_dickey_fuller.do

do tableA12_lr

