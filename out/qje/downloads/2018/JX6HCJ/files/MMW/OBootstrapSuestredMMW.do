

capture program drop mycmd
program define mycmd
	syntax anything [aw pw] [if] [in] [, robust cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* 
		capture drop xx* 
		capture drop Ssample*
		matrix B = J(1,300,.)
		estimates clear
		global j = 0
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	if ("`cmd'" == "reg" | "`cmd'" == "areg" | "`cmd'" == "regress") {
		if ("`absorb'" ~= "") quietly areg `dep' `testvars' `anything' [`weight' `exp'] `if' `in', absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `testvars' `anything' [`weight' `exp'] `if' `in', 
		quietly generate Ssample$i = e(sample)
		if ("`absorb'" ~= "") quietly areg `dep' `anything' [`weight' `exp'] if Ssample$i, absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `anything' [`weight' `exp'] if Ssample$i, 
		quietly predict double yyy$i if Ssample$i, resid
		local newtestvars = ""
		foreach var in `testvars' {
			if ("`absorb'" ~= "") quietly areg `var' `anything' [`weight' `exp'] if Ssample$i, absorb(`absorb')
			if ("`absorb'" == "") quietly reg `var' `anything' [`weight' `exp'] if Ssample$i, 
			quietly predict double xx`var'$i if Ssample$i, resid
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		capture reg yyy$i `newtestvars' [`weight' `exp'], noconstant
		if (_rc == 0) {
			estimates store M$i
			foreach var in `newtestvars' {
				global j = $j + 1
				matrix B[1,$j] = _b[`var']
				}
			}
		}
	else {
		local newtestvars = ""
		foreach var in `testvars' {
			quietly generate double xx`var'$i = `var' 
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		capture `cmd' `dep' `newtestvars' `anything' `if' `in', 
		if (_rc == 0) {
			estimates store M$i
			foreach var in `newtestvars' {
				global j = $j + 1
				matrix B[1,$j] = _b[`var']
				}
			}
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

end

****************************************
****************************************


use DatMMW, clear
renpfix amount100_ a100
renpfix amount200_ a200

*Table 2
global i = 0
mycmd (amount amount_female) areg realprof amount amount_female wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, absorb(sheno) cluster (sheno)
mycmd (amount amount_female) areg adjprof3 amount amount_female wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, absorb(sheno) cluster (sheno)
mycmd (firstyear_amount secondyear_amount thirdyear_amount) areg adjprof3 firstyear_amount secondyear_amount thirdyear_amount wave2-wave9 wave10 wave11 if Sample == 1 & sample2==1 & femaleverified==0, absorb(sheno) cluster(sheno)
mycmd (firstyear_amount secondyear_amount thirdyear_amount) areg adjprof3 firstyear_amount secondyear_amount thirdyear_amount wave2-wave9 wave10 wave11 if Sample == 1 & sample2==1 & femaleverified==1, absorb(sheno) cluster(sheno)
quietly suest $M, cluster(sheno)
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 2)
matrix B2 = B[1,1..$j]

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
matrix B3 = B[1,1..$j]

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
matrix B5 = B[1,1..$j]

*Table 6 
global i = 0
foreach X in timetosolve fatherbus motherbus optimismI p_carer reasongrow4 athomebus selfefficacy financialliteracy impulsiveness passionforwork tenacity locusofcontrol trust achievement powermotivation polychronicity workcentrality organization {
	mycmd (amount100 amount200 a100female a200female) areg adjprof3 amount100 amount200 a100female a200female a100`X' a200`X' a100fem_`X' a200fem_`X' wave2-wave9 wave10 wave11 `X'_wave2-`X'_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, absorb(sheno) cluster (sheno)	
	}
quietly suest $M, cluster(sheno)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)
matrix B6 = B[1,1..$j]

*Table 7 
global i = 0
mycmd (amount100 amount200 a100female a200female a100propfem a200propfem a100propfem_fem a200propfem_fem) areg K2_noland amount100 amount200 a100female a200female a100propfem a200propfem a100propfem_fem a200propfem_fem wave2-wave9 wave10 wave11 propfem_wave2-propfem_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd (amount100 amount200 a100female a200female a100propfem a200propfem a100propfem_fem a200propfem_fem) areg adjprof3 amount100 amount200 a100female a200female a100propfem a200propfem a100propfem_fem a200propfem_fem wave2-wave9 wave10 wave11 propfem_wave2-propfem_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd (amount100 amount200 a100female a200female a100pindfemale a200pindfemale a100pindfemale_fem a200pindfemale_fem) areg K2_noland amount100 amount200 a100female a200female a100pindfemale a200pindfemale a100pindfemale_fem a200pindfemale_fem wave2-wave9 wave10 wave11 pindfemale_wave2-pindfemale_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd (amount100 amount200 a100female a200female a100pindfemale a200pindfemale a100pindfemale_fem a200pindfemale_fem) areg adjprof3 amount100 amount200 a100female a200female a100pindfemale a200pindfemale a100pindfemale_fem a200pindfemale_fem wave2-wave9 wave10 wave11 pindfemale_wave2-pindfemale_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
quietly suest $M, cluster(sheno)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 7)
matrix B7 = B[1,1..$j]

*Table 8 
global i = 0
foreach X in enroll5to12 enroll12to15 enroll17to18 rexp_month_groceries rexp_month_health rexp_month_education {
	mycmd (amount100 amount200 a100female a200female) areg `X' amount100 amount200 a100female a200female wave5 wave9 wave11 femaleverified_wave5 femaleverified_wave9 femaleverified_wave11 if Sample == 1 & ets>1 , absorb(sheno) cluster (sheno)
	}
mycmd (amount100 amount200 a100female a200female) areg assetindex1 amount100 amount200 a100female a200female wave5 wave9 wave11 femaleverified_wave5 femaleverified_wave9 femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, absorb(sheno) cluster (sheno)
quietly suest $M, cluster(sheno)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 8)
matrix B8 = B[1,1..$j]

*Dropping colinear equations

*Table 9 
global i = 0
*foreach X in K2_noland adjprof3 inv fixed {
foreach X in adjprof3 inv fixed {
	mycmd (amount100 amount200 a100power a200power) areg `X' amount100 amount200 a100power a200power wave2-wave9 wave10 wave11 power_wave2 - power_wave11 if Sample == 1 & ets>1 & sample2==1 & femaleverified==1, absorb(sheno) cluster(sheno)	
	}
quietly suest $M, cluster(sheno)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 9)
matrix B9 = B[1,1..$j]

gen Order = _n
sort sheno Order
gen N = 1
gen Dif = (sheno ~= sheno[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

mata ResF = J($reps,35,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop sheno
	rename obs sheno

xtset sheno

*Table 2
global i = 0
mycmd (amount amount_female) areg realprof amount amount_female wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, absorb(sheno) cluster (sheno)
mycmd (amount amount_female) areg adjprof3 amount amount_female wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, absorb(sheno) cluster (sheno)
mycmd (firstyear_amount secondyear_amount thirdyear_amount) areg adjprof3 firstyear_amount secondyear_amount thirdyear_amount wave2-wave9 wave10 wave11 if Sample == 1 & sample2==1 & femaleverified==0, absorb(sheno) cluster(sheno)
mycmd (firstyear_amount secondyear_amount thirdyear_amount) areg adjprof3 firstyear_amount secondyear_amount thirdyear_amount wave2-wave9 wave10 wave11 if Sample == 1 & sample2==1 & femaleverified==1, absorb(sheno) cluster(sheno)

capture suest $M, cluster(sheno)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B2)*invsym(V)*(B[1,1..$j]-B2)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 2)
		}
	}

*Table 3 
global i = 0
mycmd (amount100 amount200 female_100 female_200) areg K2_noland amount100 amount200 female_100 female_200 wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 & prof~=., absorb(sheno) cluster(sheno)
mycmd (amount100 amount200 female_100 female_200) areg K2_noland amount100 amount200 female_100 female_200 wave2-wave4 femaleverified_wave2-femaleverified_wave4 if Sample == 1 & ets>1 & sample2==1 & prof~=. & timesince<=1 & wave<=4 , absorb(sheno) cluster(sheno)
mycmd (amount100 amount200 female_100 female_200) areg adjprof3 amount100 amount200 female_100 female_200 wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, absorb(sheno) cluster(sheno)
mycmd (inv_amount eq_amount) areg adjprof3 inv_amount eq_amount wave2-wave9 wave10 wave11 if Sample == 1 & ets>1 & sample2==1 & trtmnt_reported==trtmnt_actual & femaleverified==0, absorb(sheno) cluster (sheno)
mycmd (inv_amount eq_amount) areg adjprof3 inv_amount eq_amount wave2-wave9 wave10 wave11 if Sample == 1 & ets>1 & sample2==1 & trtmnt_reported==trtmnt_actual & femaleverified==1, absorb(sheno) cluster (sheno)

capture suest $M, cluster(sheno)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B3)*invsym(V)*(B[1,1..$j]-B3)'
		mata test = st_matrix("test"); ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', test[1,1], 3)
		}
	}

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

capture suest $M, cluster(sheno)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B5)*invsym(V)*(B[1,1..$j]-B5)'
		mata test = st_matrix("test"); ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', test[1,1], 5)
		}
	}

*Table 6 
global i = 0
foreach X in timetosolve fatherbus motherbus optimismI p_carer reasongrow4 athomebus selfefficacy financialliteracy impulsiveness passionforwork tenacity locusofcontrol trust achievement powermotivation polychronicity workcentrality organization {
	mycmd (amount100 amount200 a100female a200female) areg adjprof3 amount100 amount200 a100female a200female a100`X' a200`X' a100fem_`X' a200fem_`X' wave2-wave9 wave10 wave11 `X'_wave2-`X'_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, absorb(sheno) cluster (sheno)	
	}

capture suest $M, cluster(sheno)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B6)*invsym(V)*(B[1,1..$j]-B6)'
		mata test = st_matrix("test"); ResF[`c',16..20] = (`r(p)', `r(drop)', `r(df)', test[1,1], 6)
		}
	}

*Table 7 
global i = 0
mycmd (amount100 amount200 a100female a200female a100propfem a200propfem a100propfem_fem a200propfem_fem) areg K2_noland amount100 amount200 a100female a200female a100propfem a200propfem a100propfem_fem a200propfem_fem wave2-wave9 wave10 wave11 propfem_wave2-propfem_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd (amount100 amount200 a100female a200female a100propfem a200propfem a100propfem_fem a200propfem_fem) areg adjprof3 amount100 amount200 a100female a200female a100propfem a200propfem a100propfem_fem a200propfem_fem wave2-wave9 wave10 wave11 propfem_wave2-propfem_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd (amount100 amount200 a100female a200female a100pindfemale a200pindfemale a100pindfemale_fem a200pindfemale_fem) areg K2_noland amount100 amount200 a100female a200female a100pindfemale a200pindfemale a100pindfemale_fem a200pindfemale_fem wave2-wave9 wave10 wave11 pindfemale_wave2-pindfemale_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd (amount100 amount200 a100female a200female a100pindfemale a200pindfemale a100pindfemale_fem a200pindfemale_fem) areg adjprof3 amount100 amount200 a100female a200female a100pindfemale a200pindfemale a100pindfemale_fem a200pindfemale_fem wave2-wave9 wave10 wave11 pindfemale_wave2-pindfemale_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)

capture suest $M, cluster(sheno)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B7)*invsym(V)*(B[1,1..$j]-B7)'
		mata test = st_matrix("test"); ResF[`c',21..25] = (`r(p)', `r(drop)', `r(df)', test[1,1], 7)
		}
	}

*Table 8 
global i = 0
foreach X in enroll5to12 enroll12to15 enroll17to18 rexp_month_groceries rexp_month_health rexp_month_education {
	mycmd (amount100 amount200 a100female a200female) areg `X' amount100 amount200 a100female a200female wave5 wave9 wave11 femaleverified_wave5 femaleverified_wave9 femaleverified_wave11 if Sample == 1 & ets>1 , absorb(sheno) cluster (sheno)
	}
mycmd (amount100 amount200 a100female a200female) areg assetindex1 amount100 amount200 a100female a200female wave5 wave9 wave11 femaleverified_wave5 femaleverified_wave9 femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, absorb(sheno) cluster (sheno)

capture suest $M, cluster(sheno)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B8)*invsym(V)*(B[1,1..$j]-B8)'
		mata test = st_matrix("test"); ResF[`c',26..30] = (`r(p)', `r(drop)', `r(df)', test[1,1], 8)
		}
	}

*Table 9 
global i = 0
foreach X in adjprof3 inv fixed {
	mycmd (amount100 amount200 a100power a200power) areg `X' amount100 amount200 a100power a200power wave2-wave9 wave10 wave11 power_wave2 - power_wave11 if Sample == 1 & ets>1 & sample2==1 & femaleverified==1, absorb(sheno) cluster(sheno)	
	}

capture suest $M, cluster(sheno)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B9)*invsym(V)*(B[1,1..$j]-B9)'
		mata test = st_matrix("test"); ResF[`c',31..35] = (`r(p)', `r(drop)', `r(df)', test[1,1], 9)
		}
	}
}

drop _all
set obs $reps
forvalues i = 1/35 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save results\OBootstrapSuestredMMW, replace

erase aa.dta
erase aaa.dta



