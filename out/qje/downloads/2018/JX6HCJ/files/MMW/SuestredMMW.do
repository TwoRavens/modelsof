
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* 
		capture drop xx* 
		capture drop Ssample*
		estimates clear
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	if ("`cmd'" == "reg" | "`cmd'" == "areg" | "`cmd'" == "regress") {
		if ("`absorb'" ~= "") quietly areg `dep' `testvars' `anything' `if' `in', absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `testvars' `anything' `if' `in', 
		quietly generate Ssample$i = e(sample)
		if ("`absorb'" ~= "") quietly areg `dep' `anything' if Ssample$i, absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `anything' if Ssample$i, 
		quietly predict double yyy$i if Ssample$i, resid
		local newtestvars = ""
		foreach var in `testvars' {
			if ("`absorb'" ~= "") quietly areg `var' `anything' if Ssample$i, absorb(`absorb')
			if ("`absorb'" == "") quietly reg `var' `anything' if Ssample$i, 
			quietly predict double xx`var'$i if Ssample$i, resid
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		quietly reg yyy$i `newtestvars', noconstant
		}
	else {
		`cmd' `dep' `testvars' `anything' `if' `in', 
		quietly generate Ssample$i = e(sample)
		local newtestvars = ""
		foreach var in `testvars' {
			quietly generate double xx`var'$i = `var' if Ssample$i
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		`cmd' `dep' `newtestvars' `anything' `if' `in', 
		}
	estimates store M$i
	local i = 0
	foreach var in `newtestvars' {
		matrix B[$j+`i',1] = _b[`var'], _se[`var']
		local i = `i' + 1
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

global j = $j + $k
end

****************************************
****************************************

use DatMMW, clear
renpfix amount100_ a100
renpfix amount200_ a200

matrix B = J(366,2,.)
global j = 1

*All of these aregs are simple regressions with fixed effects (no re) - but stata's method of calculation involves different finite sample correction 


*Table 2
global i = 0
mycmd (amount amount_female) areg realprof amount amount_female wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, absorb(sheno) cluster (sheno)
mycmd (amount amount_female) areg adjprof3 amount amount_female wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, absorb(sheno) cluster (sheno)
mycmd (firstyear_amount secondyear_amount thirdyear_amount) areg adjprof3 firstyear_amount secondyear_amount thirdyear_amount wave2-wave9 wave10 wave11 if Sample == 1 & sample2==1 & femaleverified==0, absorb(sheno) cluster(sheno)
mycmd (firstyear_amount secondyear_amount thirdyear_amount) areg adjprof3 firstyear_amount secondyear_amount thirdyear_amount wave2-wave9 wave10 wave11 if Sample == 1 & sample2==1 & femaleverified==1, absorb(sheno) cluster(sheno)
quietly suest $M, cluster(sheno)
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 2)

*Table 3 
global i = 0
mycmd (amount100 amount200 female_100 female_200) areg K2_noland amount100 amount200 female_100 female_200 wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 & prof~=., absorb(sheno) cluster(sheno)
mycmd (amount100 amount200 female_100 female_200) areg K2_noland amount100 amount200 female_100 female_200 wave2-wave4 femaleverified_wave2-femaleverified_wave4 if Sample == 1 & ets>1 & sample2==1 & prof~=. & timesince<=1 & wave<=4 , absorb(sheno) cluster(sheno)
mycmd (amount100 amount200 female_100 female_200) areg adjprof3 amount100 amount200 female_100 female_200 wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, absorb(sheno) cluster(sheno)
mycmd (inv_amount eq_amount) areg adjprof3 inv_amount eq_amount wave2-wave9 wave10 wave11 if Sample == 1 & ets>1 & sample2==1 & trtmnt_reported==trtmnt_actual & femaleverified==0, absorb(sheno) cluster (sheno)
mycmd (inv_amount eq_amount) areg adjprof3 inv_amount eq_amount wave2-wave9 wave10 wave11 if Sample == 1 & ets>1 & sample2==1 & trtmnt_reported==trtmnt_actual & femaleverified==1, absorb(sheno) cluster (sheno)
quietly suest $M, cluster(sheno)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 3)

*Table 5 
global i = 0
mycmd (amount100 amount200 a100female a200female) areg K2_noland amount100 amount200 a100female a200female a100nwageworkers a100assetindex a200nwageworkers a200assetindex a100female_nwageworkers a100female_assetindex a200female_nwageworkers a200female_assetindex wave2-wave9 wave10 wave11  nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11 femaleverified_wave2-femaleverified_wave11   if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd (amount100 amount200 a100female a200female) areg K2_noland amount100 amount200 a100female a200female a100ednyearsFIRM a100p_digitspan a200ednyearsFIRM a200p_digitspan a100female_ednyearsFIRM a100female_p_digitspan a200female_ednyearsFIRM a200female_p_digitspan wave2-wave9 wave10 wave11   ednyearsFIRM_wave2-ednyearsFIRM_wave11 p_digitspan_wave2-p_digitspan_wave11     femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd (amount100 amount200 a100female a200female) areg K2_noland amount100 amount200 a100female a200female a100p_lotBcrra a200p_lotBcrra a100female_p_lotBcrra a200female_p_lotBcrra    wave2-wave9 wave10 wave11 p_lotBcrra_wave2-p_lotBcrra_wave11  femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd (amount100 amount200 a100female a200female) areg K2_noland amount100 amount200 a100female a200female a100nwageworkers a100assetindex a100ednyearsFIRM a100p_digitspan a100p_lotBcrra a200nwageworkers a200assetindex a200ednyearsFIRM a200p_digitspan  a200p_lotBcrra  a100female_nwageworkers a100female_assetindex a100female_ednyearsFIRM a100female_p_digitspan  a100female_p_lotBcrra a200female_nwageworkers a200female_assetindex a200female_ednyearsFIRM a200female_p_digitspan a200female_p_lotBcrra wave2-wave9 wave10 wave11 nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11 ednyearsFIRM_wave2-ednyearsFIRM_wave11 p_lotBcrra_wave2-p_lotBcrra_wave11 p_digitspan_wave2-p_digitspan_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd (amount100 amount200 a100female a200female) areg adjprof3 amount100 amount200 a100female a200female a100nwageworkers a100assetindex a200nwageworkers a200assetindex a100female_nwageworkers a100female_assetindex a200female_nwageworkers a200female_assetindex  wave2-wave9 wave10 wave11 nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd (amount100 amount200 a100female a200female) areg adjprof3 amount100 amount200 a100female a200female a100ednyearsFIRM a100p_digitspan a200ednyearsFIRM a200p_digitspan a100female_ednyearsFIRM a100female_p_digitspan a200female_ednyearsFIRM a200female_p_digitspan wave2-wave9 wave10 wave11   ednyearsFIRM_wave2-ednyearsFIRM_wave11  p_digitspan_wave2-p_digitspan_wave11     femaleverified_wave2-femaleverified_wave11   if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd (amount100 amount200 a100female a200female) areg adjprof3 amount100 amount200 a100female a200female a100p_lotBcrra a200p_lotBcrra a100female_p_lotBcrra a200female_p_lotBcrra    wave2-wave9 wave10 wave11   p_lotBcrra_wave2-p_lotBcrra_wave11  femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd (amount100 amount200 a100female a200female) areg adjprof3 amount100 amount200 a100female a200female a100nwageworkers a100assetindex a100ednyearsFIRM a100p_digitspan  a100p_lotBcrra a200nwageworkers a200assetindex a200ednyearsFIRM a200p_digitspan  a200p_lotBcrra  a100female_nwageworkers a100female_assetindex a100female_ednyearsFIRM a100female_p_digitspan  a100female_p_lotBcrra a200female_nwageworkers a200female_assetindex a200female_ednyearsFIRM a200female_p_digitspan  a200female_p_lotBcrra wave2-wave9 wave10 wave11   nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11   ednyearsFIRM_wave2-ednyearsFIRM_wave11 p_lotBcrra_wave2-p_lotBcrra_wave11 p_digitspan_wave2-p_digitspan_wave11      femaleverified_wave2-femaleverified_wave11   if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
quietly suest $M, cluster(sheno)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)

*Table 6 
global i = 0
foreach X in timetosolve fatherbus motherbus optimismI p_carer reasongrow4 athomebus selfefficacy financialliteracy impulsiveness passionforwork tenacity locusofcontrol trust achievement powermotivation polychronicity workcentrality organization {
	mycmd (amount100 amount200 a100female a200female) areg adjprof3 amount100 amount200 a100female a200female a100`X' a200`X' a100fem_`X' a200fem_`X' wave2-wave9 wave10 wave11 `X'_wave2-`X'_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, absorb(sheno) cluster (sheno)	
	}
quietly suest $M, cluster(sheno)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)

*Table 7 
global i = 0
mycmd (amount100 amount200 a100female a200female a100propfem a200propfem a100propfem_fem a200propfem_fem) areg K2_noland amount100 amount200 a100female a200female a100propfem a200propfem a100propfem_fem a200propfem_fem wave2-wave9 wave10 wave11 propfem_wave2-propfem_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd (amount100 amount200 a100female a200female a100propfem a200propfem a100propfem_fem a200propfem_fem) areg adjprof3 amount100 amount200 a100female a200female a100propfem a200propfem a100propfem_fem a200propfem_fem wave2-wave9 wave10 wave11 propfem_wave2-propfem_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd (amount100 amount200 a100female a200female a100pindfemale a200pindfemale a100pindfemale_fem a200pindfemale_fem) areg K2_noland amount100 amount200 a100female a200female a100pindfemale a200pindfemale a100pindfemale_fem a200pindfemale_fem wave2-wave9 wave10 wave11 pindfemale_wave2-pindfemale_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd (amount100 amount200 a100female a200female a100pindfemale a200pindfemale a100pindfemale_fem a200pindfemale_fem) areg adjprof3 amount100 amount200 a100female a200female a100pindfemale a200pindfemale a100pindfemale_fem a200pindfemale_fem wave2-wave9 wave10 wave11 pindfemale_wave2-pindfemale_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
quietly suest $M, cluster(sheno)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 7)

*Table 8 
global i = 0
foreach X in enroll5to12 enroll12to15 enroll17to18 rexp_month_groceries rexp_month_health rexp_month_education {
	mycmd (amount100 amount200 a100female a200female) areg `X' amount100 amount200 a100female a200female wave5 wave9 wave11 femaleverified_wave5 femaleverified_wave9 femaleverified_wave11 if Sample == 1 & ets>1 , absorb(sheno) cluster (sheno)
	}
mycmd (amount100 amount200 a100female a200female) areg assetindex1 amount100 amount200 a100female a200female wave5 wave9 wave11 femaleverified_wave5 femaleverified_wave9 femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, absorb(sheno) cluster (sheno)
quietly suest $M, cluster(sheno)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 8)

*Table 9 
global i = 0
foreach X in K2_noland adjprof3 inv fixed {
	mycmd (amount100 amount200 a100power a200power) areg `X' amount100 amount200 a100power a200power wave2-wave9 wave10 wave11 power_wave2 - power_wave11 if Sample == 1 & ets>1 & sample2==1 & femaleverified==1, absorb(sheno) cluster(sheno)	
	}
quietly suest $M, cluster(sheno)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 9)

drop _all
svmat double F
svmat double B
save results/SuestredMMW, replace






