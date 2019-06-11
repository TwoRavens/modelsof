
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', absorb(`absorb')
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', absorb(`absorb')
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end


****************************************
****************************************

global b = 366

use DatMMW, clear

matrix B = J($b,1,.)

global j = 1

*All of these aregs are simple regressions with fixed effects (no re) - but stata's method of calculation involves different finite sample correction - see paper

*Table 2
mycmd (amount amount_female) areg realprof amount amount_female wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, absorb(sheno) cluster (sheno)
mycmd (amount amount_female) areg adjprof3 amount amount_female wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, absorb(sheno) cluster (sheno)
mycmd (firstyear_amount secondyear_amount thirdyear_amount) areg adjprof3 firstyear_amount secondyear_amount thirdyear_amount wave2-wave9 wave10 wave11 if Sample == 1 & sample2==1 & femaleverified==0, absorb(sheno) cluster(sheno)
mycmd (firstyear_amount secondyear_amount thirdyear_amount) areg adjprof3 firstyear_amount secondyear_amount thirdyear_amount wave2-wave9 wave10 wave11 if Sample == 1 & sample2==1 & femaleverified==1, absorb(sheno) cluster(sheno)

*Table 3 
mycmd (amount100 amount200 female_100 female_200) areg K2_noland amount100 amount200 female_100 female_200 wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 & prof~=., absorb(sheno) cluster(sheno)
mycmd (amount100 amount200 female_100 female_200) areg K2_noland amount100 amount200 female_100 female_200 wave2-wave4 femaleverified_wave2-femaleverified_wave4 if Sample == 1 & ets>1 & sample2==1 & prof~=. & timesince<=1 & wave<=4 , absorb(sheno) cluster(sheno)
mycmd (amount100 amount200 female_100 female_200) areg adjprof3 amount100 amount200 female_100 female_200 wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, absorb(sheno) cluster(sheno)
mycmd (inv_amount eq_amount) areg adjprof3 inv_amount eq_amount wave2-wave9 wave10 wave11 if Sample == 1 & ets>1 & sample2==1 & trtmnt_reported==trtmnt_actual & femaleverified==0, absorb(sheno) cluster (sheno)
mycmd (inv_amount eq_amount) areg adjprof3 inv_amount eq_amount wave2-wave9 wave10 wave11 if Sample == 1 & ets>1 & sample2==1 & trtmnt_reported==trtmnt_actual & femaleverified==1, absorb(sheno) cluster (sheno)

*Table 5 
mycmd (amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount200_nwageworkers amount200_assetindex amount100_female_nwageworkers amount100_female_assetindex amount200_female_nwageworkers amount200_female_assetindex) areg K2_noland amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount200_nwageworkers amount200_assetindex amount100_female_nwageworkers amount100_female_assetindex amount200_female_nwageworkers amount200_female_assetindex wave2-wave9 wave10 wave11  nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11 femaleverified_wave2-femaleverified_wave11   if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female amount100_ednyearsFIRM amount100_p_digitspan amount200_ednyearsFIRM amount200_p_digitspan amount100_female_ednyearsFIRM amount100_female_p_digitspan amount200_female_ednyearsFIRM amount200_female_p_digitspan) areg K2_noland amount100 amount200 amount100_female amount200_female amount100_ednyearsFIRM amount100_p_digitspan amount200_ednyearsFIRM amount200_p_digitspan amount100_female_ednyearsFIRM amount100_female_p_digitspan amount200_female_ednyearsFIRM amount200_female_p_digitspan wave2-wave9 wave10 wave11   ednyearsFIRM_wave2-ednyearsFIRM_wave11 p_digitspan_wave2-p_digitspan_wave11     femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female amount100_p_lotBcrra amount200_p_lotBcrra amount100_female_p_lotBcrra amount200_female_p_lotBcrra) areg K2_noland amount100 amount200 amount100_female amount200_female amount100_p_lotBcrra amount200_p_lotBcrra amount100_female_p_lotBcrra amount200_female_p_lotBcrra    wave2-wave9 wave10 wave11 p_lotBcrra_wave2-p_lotBcrra_wave11  femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount100_ednyearsFIRM amount100_p_digitspan amount100_p_lotBcrra amount200_nwageworkers amount200_assetindex amount200_ednyearsFIRM amount200_p_digitspan  amount200_p_lotBcrra amount100_female_nwageworkers amount100_female_assetindex amount100_female_ednyearsFIRM amount100_female_p_digitspan  amount100_female_p_lotBcrra amount200_female_nwageworkers amount200_female_assetindex amount200_female_ednyearsFIRM amount200_female_p_digitspan amount200_female_p_lotBcrra) areg K2_noland amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount100_ednyearsFIRM amount100_p_digitspan amount100_p_lotBcrra amount200_nwageworkers amount200_assetindex amount200_ednyearsFIRM amount200_p_digitspan  amount200_p_lotBcrra  amount100_female_nwageworkers amount100_female_assetindex amount100_female_ednyearsFIRM amount100_female_p_digitspan  amount100_female_p_lotBcrra amount200_female_nwageworkers amount200_female_assetindex amount200_female_ednyearsFIRM amount200_female_p_digitspan amount200_female_p_lotBcrra wave2-wave9 wave10 wave11 nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11 ednyearsFIRM_wave2-ednyearsFIRM_wave11 p_lotBcrra_wave2-p_lotBcrra_wave11 p_digitspan_wave2-p_digitspan_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount200_nwageworkers amount200_assetindex amount100_female_nwageworkers amount100_female_assetindex amount200_female_nwageworkers amount200_female_assetindex) areg adjprof3 amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount200_nwageworkers amount200_assetindex amount100_female_nwageworkers amount100_female_assetindex amount200_female_nwageworkers amount200_female_assetindex  wave2-wave9 wave10 wave11 nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female amount100_ednyearsFIRM amount100_p_digitspan amount200_ednyearsFIRM amount200_p_digitspan amount100_female_ednyearsFIRM amount100_female_p_digitspan amount200_female_ednyearsFIRM amount200_female_p_digitspan) areg adjprof3 amount100 amount200 amount100_female amount200_female amount100_ednyearsFIRM amount100_p_digitspan amount200_ednyearsFIRM amount200_p_digitspan amount100_female_ednyearsFIRM amount100_female_p_digitspan amount200_female_ednyearsFIRM amount200_female_p_digitspan wave2-wave9 wave10 wave11   ednyearsFIRM_wave2-ednyearsFIRM_wave11  p_digitspan_wave2-p_digitspan_wave11     femaleverified_wave2-femaleverified_wave11   if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female amount100_p_lotBcrra amount200_p_lotBcrra amount100_female_p_lotBcrra amount200_female_p_lotBcrra) areg adjprof3 amount100 amount200 amount100_female amount200_female amount100_p_lotBcrra amount200_p_lotBcrra amount100_female_p_lotBcrra amount200_female_p_lotBcrra    wave2-wave9 wave10 wave11   p_lotBcrra_wave2-p_lotBcrra_wave11  femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount100_ednyearsFIRM amount100_p_digitspan amount100_p_lotBcrra amount200_nwageworkers amount200_assetindex amount200_ednyearsFIRM amount200_p_digitspan amount200_p_lotBcrra amount100_female_nwageworkers amount100_female_assetindex amount100_female_ednyearsFIRM amount100_female_p_digitspan amount100_female_p_lotBcrra amount200_female_nwageworkers amount200_female_assetindex amount200_female_ednyearsFIRM amount200_female_p_digitspan amount200_female_p_lotBcrra) areg adjprof3 amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount100_ednyearsFIRM amount100_p_digitspan  amount100_p_lotBcrra amount200_nwageworkers amount200_assetindex amount200_ednyearsFIRM amount200_p_digitspan  amount200_p_lotBcrra  amount100_female_nwageworkers amount100_female_assetindex amount100_female_ednyearsFIRM amount100_female_p_digitspan  amount100_female_p_lotBcrra amount200_female_nwageworkers amount200_female_assetindex amount200_female_ednyearsFIRM amount200_female_p_digitspan  amount200_female_p_lotBcrra wave2-wave9 wave10 wave11   nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11   ednyearsFIRM_wave2-ednyearsFIRM_wave11 p_lotBcrra_wave2-p_lotBcrra_wave11 p_digitspan_wave2-p_digitspan_wave11      femaleverified_wave2-femaleverified_wave11   if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)

*Table 6 
foreach X in timetosolve fatherbus motherbus optimismI p_carer reasongrow4 athomebus selfefficacy financialliteracy impulsiveness passionforwork tenacity locusofcontrol trust achievement powermotivation polychronicity workcentrality organization {
	mycmd (amount100 amount200 amount100_female amount200_female amount100_`X' amount200_`X' amount100_fem_`X' amount200_fem_`X') areg adjprof3 amount100 amount200 amount100_female amount200_female amount100_`X' amount200_`X' amount100_fem_`X' amount200_fem_`X' wave2-wave9 wave10 wave11 `X'_wave2-`X'_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, absorb(sheno) cluster (sheno)	
	}

*Table 7 
mycmd (amount100 amount200 amount100_female amount200_female amount100_propfem amount200_propfem amount100_propfem_fem amount200_propfem_fem) areg K2_noland amount100 amount200 amount100_female amount200_female amount100_propfem amount200_propfem amount100_propfem_fem amount200_propfem_fem wave2-wave9 wave10 wave11 propfem_wave2-propfem_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female amount100_propfem amount200_propfem amount100_propfem_fem amount200_propfem_fem) areg adjprof3 amount100 amount200 amount100_female amount200_female amount100_propfem amount200_propfem amount100_propfem_fem amount200_propfem_fem wave2-wave9 wave10 wave11 propfem_wave2-propfem_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female amount100_pindfemale amount200_pindfemale amount100_pindfemale_fem amount200_pindfemale_fem) areg K2_noland amount100 amount200 amount100_female amount200_female amount100_pindfemale amount200_pindfemale amount100_pindfemale_fem amount200_pindfemale_fem wave2-wave9 wave10 wave11 pindfemale_wave2-pindfemale_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female amount100_pindfemale amount200_pindfemale amount100_pindfemale_fem amount200_pindfemale_fem) areg adjprof3 amount100 amount200 amount100_female amount200_female amount100_pindfemale amount200_pindfemale amount100_pindfemale_fem amount200_pindfemale_fem wave2-wave9 wave10 wave11 pindfemale_wave2-pindfemale_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)

*Table 8 
foreach X in enroll5to12 enroll12to15 enroll17to18 rexp_month_groceries rexp_month_health rexp_month_education {
	mycmd (amount100 amount200 amount100_female amount200_female) areg `X' amount100 amount200 amount100_female amount200_female wave5 wave9 wave11 femaleverified_wave5 femaleverified_wave9 femaleverified_wave11 if Sample == 1 & ets>1 , absorb(sheno) cluster (sheno)
	}
mycmd (amount100 amount200 amount100_female amount200_female) areg assetindex1 amount100 amount200 amount100_female amount200_female wave5 wave9 wave11 femaleverified_wave5 femaleverified_wave9 femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, absorb(sheno) cluster (sheno)

*Table 9 
foreach X in K2_noland adjprof3 inv fixed {
	mycmd (amount100 amount200 amount100_power amount200_power) areg `X' amount100 amount200 amount100_power amount200_power wave2-wave9 wave10 wave11 power_wave2 - power_wave11 if Sample == 1 & ets>1 & sample2==1 & femaleverified==1, absorb(sheno) cluster(sheno)	
	}

egen M = group(sheno)
sum M
global reps = r(max)

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if M == `c'

global j = 1

*Table 2
mycmd1 (amount amount_female) areg realprof amount amount_female wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, absorb(sheno) cluster (sheno)
mycmd1 (amount amount_female) areg adjprof3 amount amount_female wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, absorb(sheno) cluster (sheno)
mycmd1 (firstyear_amount secondyear_amount thirdyear_amount) areg adjprof3 firstyear_amount secondyear_amount thirdyear_amount wave2-wave9 wave10 wave11 if Sample == 1 & sample2==1 & femaleverified==0, absorb(sheno) cluster(sheno)
mycmd1 (firstyear_amount secondyear_amount thirdyear_amount) areg adjprof3 firstyear_amount secondyear_amount thirdyear_amount wave2-wave9 wave10 wave11 if Sample == 1 & sample2==1 & femaleverified==1, absorb(sheno) cluster(sheno)

*Table 3 
mycmd1 (amount100 amount200 female_100 female_200) areg K2_noland amount100 amount200 female_100 female_200 wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 & prof~=., absorb(sheno) cluster(sheno)
mycmd1 (amount100 amount200 female_100 female_200) areg K2_noland amount100 amount200 female_100 female_200 wave2-wave4 femaleverified_wave2-femaleverified_wave4 if Sample == 1 & ets>1 & sample2==1 & prof~=. & timesince<=1 & wave<=4 , absorb(sheno) cluster(sheno)
mycmd1 (amount100 amount200 female_100 female_200) areg adjprof3 amount100 amount200 female_100 female_200 wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, absorb(sheno) cluster(sheno)
mycmd1 (inv_amount eq_amount) areg adjprof3 inv_amount eq_amount wave2-wave9 wave10 wave11 if Sample == 1 & ets>1 & sample2==1 & trtmnt_reported==trtmnt_actual & femaleverified==0, absorb(sheno) cluster (sheno)
mycmd1 (inv_amount eq_amount) areg adjprof3 inv_amount eq_amount wave2-wave9 wave10 wave11 if Sample == 1 & ets>1 & sample2==1 & trtmnt_reported==trtmnt_actual & femaleverified==1, absorb(sheno) cluster (sheno)

*Table 5 
mycmd1 (amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount200_nwageworkers amount200_assetindex amount100_female_nwageworkers amount100_female_assetindex amount200_female_nwageworkers amount200_female_assetindex) areg K2_noland amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount200_nwageworkers amount200_assetindex amount100_female_nwageworkers amount100_female_assetindex amount200_female_nwageworkers amount200_female_assetindex wave2-wave9 wave10 wave11  nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11 femaleverified_wave2-femaleverified_wave11   if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd1 (amount100 amount200 amount100_female amount200_female amount100_ednyearsFIRM amount100_p_digitspan amount200_ednyearsFIRM amount200_p_digitspan amount100_female_ednyearsFIRM amount100_female_p_digitspan amount200_female_ednyearsFIRM amount200_female_p_digitspan) areg K2_noland amount100 amount200 amount100_female amount200_female amount100_ednyearsFIRM amount100_p_digitspan amount200_ednyearsFIRM amount200_p_digitspan amount100_female_ednyearsFIRM amount100_female_p_digitspan amount200_female_ednyearsFIRM amount200_female_p_digitspan wave2-wave9 wave10 wave11   ednyearsFIRM_wave2-ednyearsFIRM_wave11 p_digitspan_wave2-p_digitspan_wave11     femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd1 (amount100 amount200 amount100_female amount200_female amount100_p_lotBcrra amount200_p_lotBcrra amount100_female_p_lotBcrra amount200_female_p_lotBcrra) areg K2_noland amount100 amount200 amount100_female amount200_female amount100_p_lotBcrra amount200_p_lotBcrra amount100_female_p_lotBcrra amount200_female_p_lotBcrra    wave2-wave9 wave10 wave11 p_lotBcrra_wave2-p_lotBcrra_wave11  femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd1 (amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount100_ednyearsFIRM amount100_p_digitspan amount100_p_lotBcrra amount200_nwageworkers amount200_assetindex amount200_ednyearsFIRM amount200_p_digitspan  amount200_p_lotBcrra amount100_female_nwageworkers amount100_female_assetindex amount100_female_ednyearsFIRM amount100_female_p_digitspan  amount100_female_p_lotBcrra amount200_female_nwageworkers amount200_female_assetindex amount200_female_ednyearsFIRM amount200_female_p_digitspan amount200_female_p_lotBcrra) areg K2_noland amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount100_ednyearsFIRM amount100_p_digitspan amount100_p_lotBcrra amount200_nwageworkers amount200_assetindex amount200_ednyearsFIRM amount200_p_digitspan  amount200_p_lotBcrra  amount100_female_nwageworkers amount100_female_assetindex amount100_female_ednyearsFIRM amount100_female_p_digitspan  amount100_female_p_lotBcrra amount200_female_nwageworkers amount200_female_assetindex amount200_female_ednyearsFIRM amount200_female_p_digitspan amount200_female_p_lotBcrra wave2-wave9 wave10 wave11 nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11 ednyearsFIRM_wave2-ednyearsFIRM_wave11 p_lotBcrra_wave2-p_lotBcrra_wave11 p_digitspan_wave2-p_digitspan_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd1 (amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount200_nwageworkers amount200_assetindex amount100_female_nwageworkers amount100_female_assetindex amount200_female_nwageworkers amount200_female_assetindex) areg adjprof3 amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount200_nwageworkers amount200_assetindex amount100_female_nwageworkers amount100_female_assetindex amount200_female_nwageworkers amount200_female_assetindex  wave2-wave9 wave10 wave11 nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd1 (amount100 amount200 amount100_female amount200_female amount100_ednyearsFIRM amount100_p_digitspan amount200_ednyearsFIRM amount200_p_digitspan amount100_female_ednyearsFIRM amount100_female_p_digitspan amount200_female_ednyearsFIRM amount200_female_p_digitspan) areg adjprof3 amount100 amount200 amount100_female amount200_female amount100_ednyearsFIRM amount100_p_digitspan amount200_ednyearsFIRM amount200_p_digitspan amount100_female_ednyearsFIRM amount100_female_p_digitspan amount200_female_ednyearsFIRM amount200_female_p_digitspan wave2-wave9 wave10 wave11   ednyearsFIRM_wave2-ednyearsFIRM_wave11  p_digitspan_wave2-p_digitspan_wave11     femaleverified_wave2-femaleverified_wave11   if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd1 (amount100 amount200 amount100_female amount200_female amount100_p_lotBcrra amount200_p_lotBcrra amount100_female_p_lotBcrra amount200_female_p_lotBcrra) areg adjprof3 amount100 amount200 amount100_female amount200_female amount100_p_lotBcrra amount200_p_lotBcrra amount100_female_p_lotBcrra amount200_female_p_lotBcrra    wave2-wave9 wave10 wave11   p_lotBcrra_wave2-p_lotBcrra_wave11  femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd1 (amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount100_ednyearsFIRM amount100_p_digitspan amount100_p_lotBcrra amount200_nwageworkers amount200_assetindex amount200_ednyearsFIRM amount200_p_digitspan amount200_p_lotBcrra amount100_female_nwageworkers amount100_female_assetindex amount100_female_ednyearsFIRM amount100_female_p_digitspan amount100_female_p_lotBcrra amount200_female_nwageworkers amount200_female_assetindex amount200_female_ednyearsFIRM amount200_female_p_digitspan amount200_female_p_lotBcrra) areg adjprof3 amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount100_ednyearsFIRM amount100_p_digitspan  amount100_p_lotBcrra amount200_nwageworkers amount200_assetindex amount200_ednyearsFIRM amount200_p_digitspan  amount200_p_lotBcrra  amount100_female_nwageworkers amount100_female_assetindex amount100_female_ednyearsFIRM amount100_female_p_digitspan  amount100_female_p_lotBcrra amount200_female_nwageworkers amount200_female_assetindex amount200_female_ednyearsFIRM amount200_female_p_digitspan  amount200_female_p_lotBcrra wave2-wave9 wave10 wave11   nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11   ednyearsFIRM_wave2-ednyearsFIRM_wave11 p_lotBcrra_wave2-p_lotBcrra_wave11 p_digitspan_wave2-p_digitspan_wave11      femaleverified_wave2-femaleverified_wave11   if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)

*Table 6 
foreach X in timetosolve fatherbus motherbus optimismI p_carer reasongrow4 athomebus selfefficacy financialliteracy impulsiveness passionforwork tenacity locusofcontrol trust achievement powermotivation polychronicity workcentrality organization {
	mycmd1 (amount100 amount200 amount100_female amount200_female amount100_`X' amount200_`X' amount100_fem_`X' amount200_fem_`X') areg adjprof3 amount100 amount200 amount100_female amount200_female amount100_`X' amount200_`X' amount100_fem_`X' amount200_fem_`X' wave2-wave9 wave10 wave11 `X'_wave2-`X'_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, absorb(sheno) cluster (sheno)	
	}

*Table 7 
mycmd1 (amount100 amount200 amount100_female amount200_female amount100_propfem amount200_propfem amount100_propfem_fem amount200_propfem_fem) areg K2_noland amount100 amount200 amount100_female amount200_female amount100_propfem amount200_propfem amount100_propfem_fem amount200_propfem_fem wave2-wave9 wave10 wave11 propfem_wave2-propfem_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd1 (amount100 amount200 amount100_female amount200_female amount100_propfem amount200_propfem amount100_propfem_fem amount200_propfem_fem) areg adjprof3 amount100 amount200 amount100_female amount200_female amount100_propfem amount200_propfem amount100_propfem_fem amount200_propfem_fem wave2-wave9 wave10 wave11 propfem_wave2-propfem_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd1 (amount100 amount200 amount100_female amount200_female amount100_pindfemale amount200_pindfemale amount100_pindfemale_fem amount200_pindfemale_fem) areg K2_noland amount100 amount200 amount100_female amount200_female amount100_pindfemale amount200_pindfemale amount100_pindfemale_fem amount200_pindfemale_fem wave2-wave9 wave10 wave11 pindfemale_wave2-pindfemale_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)
mycmd1 (amount100 amount200 amount100_female amount200_female amount100_pindfemale amount200_pindfemale amount100_pindfemale_fem amount200_pindfemale_fem) areg adjprof3 amount100 amount200 amount100_female amount200_female amount100_pindfemale amount200_pindfemale amount100_pindfemale_fem amount200_pindfemale_fem wave2-wave9 wave10 wave11 pindfemale_wave2-pindfemale_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , absorb(sheno) cluster (sheno)

*Table 8 
foreach X in enroll5to12 enroll12to15 enroll17to18 rexp_month_groceries rexp_month_health rexp_month_education {
	mycmd1 (amount100 amount200 amount100_female amount200_female) areg `X' amount100 amount200 amount100_female amount200_female wave5 wave9 wave11 femaleverified_wave5 femaleverified_wave9 femaleverified_wave11 if Sample == 1 & ets>1 , absorb(sheno) cluster (sheno)
	}
mycmd1 (amount100 amount200 amount100_female amount200_female) areg assetindex1 amount100 amount200 amount100_female amount200_female wave5 wave9 wave11 femaleverified_wave5 femaleverified_wave9 femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, absorb(sheno) cluster (sheno)

*Table 9 
foreach X in K2_noland adjprof3 inv fixed {
	mycmd1 (amount100 amount200 amount100_power amount200_power) areg `X' amount100 amount200 amount100_power amount200_power wave2-wave9 wave10 wave11 power_wave2 - power_wave11 if Sample == 1 & ets>1 & sample2==1 & femaleverified==1, absorb(sheno) cluster(sheno)	
	}

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}


drop _all
set obs $reps
forvalues i = 1/$b {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
svmat double B
gen N = _n
save results\OJackknifeMMW, replace



