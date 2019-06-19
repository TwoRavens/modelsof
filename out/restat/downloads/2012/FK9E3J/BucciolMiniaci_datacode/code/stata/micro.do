* micro.do FILE

* This do-file combines the multiply imputed datasets from SCF2004

* Alessandro Bucciol (alessandro.bucciol@univr.it)
* University of Verona
* March 2010

********************************************************************



cd "..\..\Data\Estimates\"
cd "benchmark\"
* cd "robustness_10y\"
* cd "robustness_nom\"
* cd "robustness_60obs\"
* cd "robustness_realw\"

clear
set mem 50m
set more off

* Convert each imputation of datasets in Stata format
local m 1
qui while `m'< 6 {
	insheet using "micro_`m'.txt", clear
	do "..\..\..\code\stata\rename"
	* Destring bias*
	gen bi0 = bias0 if rtol0 !=0
	destring bi0, replace float
	replace bi0 = 0 if rtol0 == 0
	drop bias0
	rename bi0 bias0
	gen bi1 = bias1 if rtol1 !=0
	destring bi1, replace float
	replace bi1 = 0 if rtol1 == 0
	drop bias1
	rename bi1 bias1
	do "..\..\..\code\stata\label"

	* Adjust values
	replace x5702 = 0 if x5702 < 0
	replace x5704 = 0 if x5704 < 0
	replace x5706 = 0 if x5706 < 0
	replace x5708 = 0 if x5708 < 0
	replace x5710 = 0 if x5710 < 0
	replace x5712 = 0 if x5712 < 0
	replace x5714 = 0 if x5714 < 0
	replace x5716 = 0 if x5716 < 0
	replace x5718 = 0 if x5718 < 0
	replace x5720 = 0 if x5720 < 0
	replace x5722 = 0 if x5722 < 0
	replace x5724 = 0 if x5724 < 0
	replace x5729 = 0 if x5729 < 0
	replace x4112 = 0 if x4112 < 0
	replace x5306 = 0 if x5306 < 0
	replace x4712 = 0 if x4712 < 0
	replace x5311 = 0 if x5311 < 0
	replace finwth = 0 if finwth < 0
	replace totwth = 0 if totwth < 0

	save "micro_`m'.dta", replace
	local m = `m'+1
}

* Merge datasets
clear
use micro_1
append using micro_2
append using micro_3
append using micro_4
append using micro_5

* Create statistics of averages
sort id
macro def vars ///
imp x42001 x5702 x5704 x5706 x5708 x5710 x5712 x5714 x5716 x5718 x5720 x5722 x5724 x5729 x101 x8021 x8022 x8023 x5901 ///
x6809 x6030 x4100 x4106 x7402 x7401 x4112 x4113 x5306 x5307 x103 x104 x105 x6101 x6810 x6124 x4700 x4706 x7412 x7411 ///
x4712 x4713 x5311 x5312 x301 x3014 x3008 x7112 x3504 x7111 x7100 x6497 x8300 x7132 x5801 x5802 x5819 x5821 x5824 x5825 ///
finwth flagfin wftran wfbond wfstok totwth flagtot wttran wtbond wtstok wthcap wtrest wthous ///
portsd0 opt0_tran opt0_bond opt0_stok rtol0 bias0 opt1_tran opt1_bond opt1_stok rtol1 bias1 ///
portsd2 opt2_tran opt2_bond opt2_stok opt2_hcap opt2_rest rtol2 bias2 opt3_tran opt3_bond opt3_stok opt3_hcap opt3_rest rtol3 bias3

collapse $vars, by(id)
drop if imp != 3

* Round values
replace x101 = round(x101)
replace x8021 = round(x8021)
replace x8022 = round(x8022)
replace x8023 = round(x8023)
replace x5901 = round(x5901)
replace x6809 = round(x6809)
replace x6030 = round(x6030)
replace x4100 = round(x4100)
replace x4106 = round(x4106)
replace x7402 = round(x7402)
replace x7401 = round(x7401)
replace x4113 = round(x4113)
replace x5307 = round(x5307)
replace x103 = round(x103)
replace x104 = round(x104)
replace x105 = round(x105)
replace x6101 = round(x6101)
replace x6810 = round(x6810)
replace x6124 = round(x6124)
replace x4700 = round(x4700)
replace x4706 = round(x4706)
replace x7412 = round(x7412)
replace x7411 = round(x7411)
replace x4713 = round(x4713)
replace x5312 = round(x5312)
replace x301 = round(x301)
replace x3014 = round(x3014)
replace x3008 = round(x3008)
replace x7112 = round(x7112)
replace x3504 = round(x3504)
replace x7111 = round(x7111)
replace x7100 = round(x7100)
replace x6497 = round(x6497)
replace x8300 = round(x8300)
replace x5801 = round(x5801)
replace x5819 = round(x5819)
replace x5824 = round(x5824)
replace x5825 = round(x5825)

do "..\..\..\code\stata\label"
drop imp
save micro.dta,replace
* outfile using micro.txt, comma wide replace

cd "..\..\..\code\stata"
