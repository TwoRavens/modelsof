
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [,cluster(string) fe]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', cluster(`cluster') `fe' 
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$i,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [,cluster(string) fe]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	quietly `anything' `if' `in', cluster(`cluster') `fe' 
	capture testparm `testvars'
	if (_rc == 0) {
		matrix FF[$i,1] = r(p), r(drop), e(df_r)
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

use DatMMW, clear

matrix F = J(51,4,.)
matrix B = J(210,2,.)

global i = 1
global j = 1

*All of these xtregs are simple regressions with fixed effects (no re) - but stata's method of calculation involves different finite sample correction - see paper

*Table 2
mycmd (amount amount_female) xtreg realprof amount amount_female wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, fe cluster (sheno)
mycmd (amount amount_female) xtreg adjprof3 amount amount_female wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, fe cluster (sheno)
mycmd (firstyear_amount secondyear_amount thirdyear_amount) xtreg adjprof3 firstyear_amount secondyear_amount thirdyear_amount wave2-wave9 wave10 wave11 if Sample == 1 & sample2==1 & femaleverified==0, fe cluster(sheno)
mycmd (firstyear_amount secondyear_amount thirdyear_amount) xtreg adjprof3 firstyear_amount secondyear_amount thirdyear_amount wave2-wave9 wave10 wave11 if Sample == 1 & sample2==1 & femaleverified==1, fe cluster(sheno)

*Table 3 
mycmd (amount100 amount200 female_100 female_200) xtreg K2_noland amount100 amount200 female_100 female_200 wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 & prof~=., fe cluster(sheno)
mycmd (amount100 amount200 female_100 female_200) xtreg K2_noland amount100 amount200 female_100 female_200 wave2-wave4 femaleverified_wave2-femaleverified_wave4 if Sample == 1 & ets>1 & sample2==1 & prof~=. & timesince<=1 & wave<=4 , fe cluster(sheno)
mycmd (amount100 amount200 female_100 female_200) xtreg adjprof3 amount100 amount200 female_100 female_200 wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, fe cluster(sheno)
mycmd (inv_amount eq_amount) xtreg adjprof3 inv_amount eq_amount wave2-wave9 wave10 wave11 if Sample == 1 & ets>1 & sample2==1 & trtmnt_reported==trtmnt_actual & femaleverified==0, fe cluster (sheno)
mycmd (inv_amount eq_amount) xtreg adjprof3 inv_amount eq_amount wave2-wave9 wave10 wave11 if Sample == 1 & ets>1 & sample2==1 & trtmnt_reported==trtmnt_actual & femaleverified==1, fe cluster (sheno)

*Table 5 
mycmd (amount100 amount200 amount100_female amount200_female) xtreg K2_noland amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount200_nwageworkers amount200_assetindex amount100_female_nwageworkers amount100_female_assetindex amount200_female_nwageworkers amount200_female_assetindex wave2-wave9 wave10 wave11  nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11 femaleverified_wave2-femaleverified_wave11   if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female) xtreg K2_noland amount100 amount200 amount100_female amount200_female amount100_ednyearsFIRM amount100_p_digitspan amount200_ednyearsFIRM amount200_p_digitspan amount100_female_ednyearsFIRM amount100_female_p_digitspan amount200_female_ednyearsFIRM amount200_female_p_digitspan wave2-wave9 wave10 wave11   ednyearsFIRM_wave2-ednyearsFIRM_wave11 p_digitspan_wave2-p_digitspan_wave11     femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female) xtreg K2_noland amount100 amount200 amount100_female amount200_female amount100_p_lotBcrra amount200_p_lotBcrra amount100_female_p_lotBcrra amount200_female_p_lotBcrra    wave2-wave9 wave10 wave11 p_lotBcrra_wave2-p_lotBcrra_wave11  femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female) xtreg K2_noland amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount100_ednyearsFIRM amount100_p_digitspan amount100_p_lotBcrra amount200_nwageworkers amount200_assetindex amount200_ednyearsFIRM amount200_p_digitspan  amount200_p_lotBcrra  amount100_female_nwageworkers amount100_female_assetindex amount100_female_ednyearsFIRM amount100_female_p_digitspan  amount100_female_p_lotBcrra amount200_female_nwageworkers amount200_female_assetindex amount200_female_ednyearsFIRM amount200_female_p_digitspan amount200_female_p_lotBcrra wave2-wave9 wave10 wave11 nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11 ednyearsFIRM_wave2-ednyearsFIRM_wave11 p_lotBcrra_wave2-p_lotBcrra_wave11 p_digitspan_wave2-p_digitspan_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female) xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount200_nwageworkers amount200_assetindex amount100_female_nwageworkers amount100_female_assetindex amount200_female_nwageworkers amount200_female_assetindex  wave2-wave9 wave10 wave11 nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female) xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_ednyearsFIRM amount100_p_digitspan amount200_ednyearsFIRM amount200_p_digitspan amount100_female_ednyearsFIRM amount100_female_p_digitspan amount200_female_ednyearsFIRM amount200_female_p_digitspan wave2-wave9 wave10 wave11   ednyearsFIRM_wave2-ednyearsFIRM_wave11  p_digitspan_wave2-p_digitspan_wave11     femaleverified_wave2-femaleverified_wave11   if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female) xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_p_lotBcrra amount200_p_lotBcrra amount100_female_p_lotBcrra amount200_female_p_lotBcrra    wave2-wave9 wave10 wave11   p_lotBcrra_wave2-p_lotBcrra_wave11  femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female) xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount100_ednyearsFIRM amount100_p_digitspan  amount100_p_lotBcrra amount200_nwageworkers amount200_assetindex amount200_ednyearsFIRM amount200_p_digitspan  amount200_p_lotBcrra  amount100_female_nwageworkers amount100_female_assetindex amount100_female_ednyearsFIRM amount100_female_p_digitspan  amount100_female_p_lotBcrra amount200_female_nwageworkers amount200_female_assetindex amount200_female_ednyearsFIRM amount200_female_p_digitspan  amount200_female_p_lotBcrra wave2-wave9 wave10 wave11   nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11   ednyearsFIRM_wave2-ednyearsFIRM_wave11 p_lotBcrra_wave2-p_lotBcrra_wave11 p_digitspan_wave2-p_digitspan_wave11      femaleverified_wave2-femaleverified_wave11   if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)

*Table 6 
foreach X in timetosolve fatherbus motherbus optimismI p_carer reasongrow4 athomebus selfefficacy financialliteracy impulsiveness passionforwork tenacity locusofcontrol trust achievement powermotivation polychronicity workcentrality organization {
	mycmd (amount100 amount200 amount100_female amount200_female) xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_`X' amount200_`X' amount100_fem_`X' amount200_fem_`X' wave2-wave9 wave10 wave11 `X'_wave2-`X'_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, fe cluster (sheno)	
	}

*Table 7 
mycmd (amount100 amount200 amount100_female amount200_female amount100_propfem amount200_propfem amount100_propfem_fem amount200_propfem_fem) xtreg K2_noland amount100 amount200 amount100_female amount200_female amount100_propfem amount200_propfem amount100_propfem_fem amount200_propfem_fem wave2-wave9 wave10 wave11 propfem_wave2-propfem_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female amount100_propfem amount200_propfem amount100_propfem_fem amount200_propfem_fem) xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_propfem amount200_propfem amount100_propfem_fem amount200_propfem_fem wave2-wave9 wave10 wave11 propfem_wave2-propfem_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female amount100_pindfemale amount200_pindfemale amount100_pindfemale_fem amount200_pindfemale_fem) xtreg K2_noland amount100 amount200 amount100_female amount200_female amount100_pindfemale amount200_pindfemale amount100_pindfemale_fem amount200_pindfemale_fem wave2-wave9 wave10 wave11 pindfemale_wave2-pindfemale_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female amount100_pindfemale amount200_pindfemale amount100_pindfemale_fem amount200_pindfemale_fem) xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_pindfemale amount200_pindfemale amount100_pindfemale_fem amount200_pindfemale_fem wave2-wave9 wave10 wave11 pindfemale_wave2-pindfemale_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)

*Table 8 
foreach X in enroll5to12 enroll12to15 enroll17to18 rexp_month_groceries rexp_month_health rexp_month_education {
	mycmd (amount100 amount200 amount100_female amount200_female) xtreg `X' amount100 amount200 amount100_female amount200_female wave5 wave9 wave11 femaleverified_wave5 femaleverified_wave9 femaleverified_wave11 if Sample == 1 & ets>1 , fe cluster (sheno)
	}
mycmd (amount100 amount200 amount100_female amount200_female) xtreg assetindex1 amount100 amount200 amount100_female amount200_female wave5 wave9 wave11 femaleverified_wave5 femaleverified_wave9 femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, fe cluster (sheno)

*Table 9 
foreach X in K2_noland adjprof3 inv fixed {
	mycmd (amount100 amount200 amount100_power amount200_power) xtreg `X' amount100 amount200 amount100_power amount200_power wave2-wave9 wave10 wave11 power_wave2 - power_wave11 if Sample == 1 & ets>1 & sample2==1 & femaleverified==1, fe cluster(sheno)	
	}

bysort sheno: gen N = _n
sort N Strata sheno
global N = 408
generate Order = _n
generate double U = .
mata Y = st_data((1,$N),("treatever100","treatever200","treatmentround"))

mata ResF = J($reps,51,.); ResD = J($reps,51,.); ResDF = J($reps,51,.); ResB = J($reps,210,.); ResSE = J($reps,210,.)
forvalues c = 1/$reps {
	matrix FF = J(51,3,.)
	matrix BB = J(210,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort Strata U in 1/$N
	mata st_store((1,$N),("treatever100","treatever200","treatmentround"),Y)
	sort sheno N
	foreach j in treatever100 treatever200 treatmentround {
		quietly replace `j' = `j'[_n-1] if N > 1 & sheno == sheno[_n-1]
		}
	quietly replace amount = .25*(wave>=6) if treatever100 == 0 & treatever200 == 0
	quietly replace amount = (wave>treatmentround) if treatever100 == 1
	quietly replace amount = 2*(wave>treatmentround) if treatever200 == 1
	quietly replace amount100 = (amount == 1)
	quietly replace amount200 = (amount == 2)

*amount_femaleverified is miscoded above - will follow the miscoding in the randomization to duplicate the regressions
	quietly replace amount_femaleverified = amount*femaleverified
	quietly replace amount_femaleverified=.25 if amount_femaleverified==0 & wave>=6

	foreach j in firstyear secondyear thirdyear {
		quietly replace `j'_amount = amount*`j'
		}
	foreach j in inv eq {
		quietly replace `j'_amount = amount*perc_`j'
		}
	foreach j in 100 200 {
		quietly replace amount`j'_female = amount`j'*femaleverified
		quietly replace amount`j'_propfem = amount`j'*(propfem_det)
		quietly replace amount`j'_propfem_fem = amount`j'*(propfem_det)*femaleverified
		quietly replace female_`j' = amount`j'*femaleverified
		quietly replace amount`j'_power = amount`j'*power
		quietly replace amount`j'_pindfemale = amount`j'*pind_female
		quietly replace amount`j'_pindfemale_fem = amount`j'*pind_female*femaleverified
		foreach k in nwageworkers assetindex ednyearsFIRM p_digitspan p_lotBcrra {
			quietly replace amount`j'_`k' = amount`j'*dm_`k'
			quietly replace amount`j'_female_`k' = amount`j'*dm_`k'*femaleverified
			}
		}
	foreach j in timetosolve fatherbus motherbus optimismI p_carer reasongrow4 athomebus selfefficacy financialliteracy impulsiveness passionforwork tenacity locusofcontrol trust achievement powermotivation polychronicity workcentrality organization {
		quietly replace amount100_`j' = amount100*dm_`j'
		quietly replace amount200_`j' = amount200*dm_`j'
		quietly replace amount100_fem_`j' = amount100*dm_`j'*femaleverified
		quietly replace amount200_fem_`j' = amount200*dm_`j'*femaleverified
		}

global i = 1
global j = 1

*Table 2
mycmd1 (amount amount_female) xtreg realprof amount amount_female wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, fe cluster (sheno)
mycmd1 (amount amount_female) xtreg adjprof3 amount amount_female wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, fe cluster (sheno)
mycmd1 (firstyear_amount secondyear_amount thirdyear_amount) xtreg adjprof3 firstyear_amount secondyear_amount thirdyear_amount wave2-wave9 wave10 wave11 if Sample == 1 & sample2==1 & femaleverified==0, fe cluster(sheno)
mycmd1 (firstyear_amount secondyear_amount thirdyear_amount) xtreg adjprof3 firstyear_amount secondyear_amount thirdyear_amount wave2-wave9 wave10 wave11 if Sample == 1 & sample2==1 & femaleverified==1, fe cluster(sheno)

*Table 3 
mycmd1 (amount100 amount200 female_100 female_200) xtreg K2_noland amount100 amount200 female_100 female_200 wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 & prof~=., fe cluster(sheno)
mycmd1 (amount100 amount200 female_100 female_200) xtreg K2_noland amount100 amount200 female_100 female_200 wave2-wave4 femaleverified_wave2-femaleverified_wave4 if Sample == 1 & ets>1 & sample2==1 & prof~=. & timesince<=1 & wave<=4 , fe cluster(sheno)
mycmd1 (amount100 amount200 female_100 female_200) xtreg adjprof3 amount100 amount200 female_100 female_200 wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, fe cluster(sheno)
mycmd1 (inv_amount eq_amount) xtreg adjprof3 inv_amount eq_amount wave2-wave9 wave10 wave11 if Sample == 1 & ets>1 & sample2==1 & trtmnt_reported==trtmnt_actual & femaleverified==0, fe cluster (sheno)
mycmd1 (inv_amount eq_amount) xtreg adjprof3 inv_amount eq_amount wave2-wave9 wave10 wave11 if Sample == 1 & ets>1 & sample2==1 & trtmnt_reported==trtmnt_actual & femaleverified==1, fe cluster (sheno)

*Table 5 
mycmd1 (amount100 amount200 amount100_female amount200_female) xtreg K2_noland amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount200_nwageworkers amount200_assetindex amount100_female_nwageworkers amount100_female_assetindex amount200_female_nwageworkers amount200_female_assetindex wave2-wave9 wave10 wave11  nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11 femaleverified_wave2-femaleverified_wave11   if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd1 (amount100 amount200 amount100_female amount200_female) xtreg K2_noland amount100 amount200 amount100_female amount200_female amount100_ednyearsFIRM amount100_p_digitspan amount200_ednyearsFIRM amount200_p_digitspan amount100_female_ednyearsFIRM amount100_female_p_digitspan amount200_female_ednyearsFIRM amount200_female_p_digitspan wave2-wave9 wave10 wave11   ednyearsFIRM_wave2-ednyearsFIRM_wave11 p_digitspan_wave2-p_digitspan_wave11     femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd1 (amount100 amount200 amount100_female amount200_female) xtreg K2_noland amount100 amount200 amount100_female amount200_female amount100_p_lotBcrra amount200_p_lotBcrra amount100_female_p_lotBcrra amount200_female_p_lotBcrra    wave2-wave9 wave10 wave11 p_lotBcrra_wave2-p_lotBcrra_wave11  femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd1 (amount100 amount200 amount100_female amount200_female) xtreg K2_noland amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount100_ednyearsFIRM amount100_p_digitspan amount100_p_lotBcrra amount200_nwageworkers amount200_assetindex amount200_ednyearsFIRM amount200_p_digitspan  amount200_p_lotBcrra  amount100_female_nwageworkers amount100_female_assetindex amount100_female_ednyearsFIRM amount100_female_p_digitspan  amount100_female_p_lotBcrra amount200_female_nwageworkers amount200_female_assetindex amount200_female_ednyearsFIRM amount200_female_p_digitspan amount200_female_p_lotBcrra wave2-wave9 wave10 wave11 nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11 ednyearsFIRM_wave2-ednyearsFIRM_wave11 p_lotBcrra_wave2-p_lotBcrra_wave11 p_digitspan_wave2-p_digitspan_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd1 (amount100 amount200 amount100_female amount200_female) xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount200_nwageworkers amount200_assetindex amount100_female_nwageworkers amount100_female_assetindex amount200_female_nwageworkers amount200_female_assetindex  wave2-wave9 wave10 wave11 nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd1 (amount100 amount200 amount100_female amount200_female) xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_ednyearsFIRM amount100_p_digitspan amount200_ednyearsFIRM amount200_p_digitspan amount100_female_ednyearsFIRM amount100_female_p_digitspan amount200_female_ednyearsFIRM amount200_female_p_digitspan wave2-wave9 wave10 wave11   ednyearsFIRM_wave2-ednyearsFIRM_wave11  p_digitspan_wave2-p_digitspan_wave11     femaleverified_wave2-femaleverified_wave11   if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd1 (amount100 amount200 amount100_female amount200_female) xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_p_lotBcrra amount200_p_lotBcrra amount100_female_p_lotBcrra amount200_female_p_lotBcrra    wave2-wave9 wave10 wave11   p_lotBcrra_wave2-p_lotBcrra_wave11  femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd1 (amount100 amount200 amount100_female amount200_female) xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount100_ednyearsFIRM amount100_p_digitspan  amount100_p_lotBcrra amount200_nwageworkers amount200_assetindex amount200_ednyearsFIRM amount200_p_digitspan  amount200_p_lotBcrra  amount100_female_nwageworkers amount100_female_assetindex amount100_female_ednyearsFIRM amount100_female_p_digitspan  amount100_female_p_lotBcrra amount200_female_nwageworkers amount200_female_assetindex amount200_female_ednyearsFIRM amount200_female_p_digitspan  amount200_female_p_lotBcrra wave2-wave9 wave10 wave11   nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11   ednyearsFIRM_wave2-ednyearsFIRM_wave11 p_lotBcrra_wave2-p_lotBcrra_wave11 p_digitspan_wave2-p_digitspan_wave11      femaleverified_wave2-femaleverified_wave11   if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)

*Table 6 
foreach X in timetosolve fatherbus motherbus optimismI p_carer reasongrow4 athomebus selfefficacy financialliteracy impulsiveness passionforwork tenacity locusofcontrol trust achievement powermotivation polychronicity workcentrality organization {
	mycmd1 (amount100 amount200 amount100_female amount200_female) xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_`X' amount200_`X' amount100_fem_`X' amount200_fem_`X' wave2-wave9 wave10 wave11 `X'_wave2-`X'_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, fe cluster (sheno)	
	}

*Table 7 
mycmd1 (amount100 amount200 amount100_female amount200_female amount100_propfem amount200_propfem amount100_propfem_fem amount200_propfem_fem) xtreg K2_noland amount100 amount200 amount100_female amount200_female amount100_propfem amount200_propfem amount100_propfem_fem amount200_propfem_fem wave2-wave9 wave10 wave11 propfem_wave2-propfem_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd1 (amount100 amount200 amount100_female amount200_female amount100_propfem amount200_propfem amount100_propfem_fem amount200_propfem_fem) xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_propfem amount200_propfem amount100_propfem_fem amount200_propfem_fem wave2-wave9 wave10 wave11 propfem_wave2-propfem_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd1 (amount100 amount200 amount100_female amount200_female amount100_pindfemale amount200_pindfemale amount100_pindfemale_fem amount200_pindfemale_fem) xtreg K2_noland amount100 amount200 amount100_female amount200_female amount100_pindfemale amount200_pindfemale amount100_pindfemale_fem amount200_pindfemale_fem wave2-wave9 wave10 wave11 pindfemale_wave2-pindfemale_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd1 (amount100 amount200 amount100_female amount200_female amount100_pindfemale amount200_pindfemale amount100_pindfemale_fem amount200_pindfemale_fem) xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_pindfemale amount200_pindfemale amount100_pindfemale_fem amount200_pindfemale_fem wave2-wave9 wave10 wave11 pindfemale_wave2-pindfemale_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)

*Table 8 
foreach X in enroll5to12 enroll12to15 enroll17to18 rexp_month_groceries rexp_month_health rexp_month_education {
	mycmd1 (amount100 amount200 amount100_female amount200_female) xtreg `X' amount100 amount200 amount100_female amount200_female wave5 wave9 wave11 femaleverified_wave5 femaleverified_wave9 femaleverified_wave11 if Sample == 1 & ets>1 , fe cluster (sheno)
	}
mycmd1 (amount100 amount200 amount100_female amount200_female) xtreg assetindex1 amount100 amount200 amount100_female amount200_female wave5 wave9 wave11 femaleverified_wave5 femaleverified_wave9 femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, fe cluster (sheno)

*Table 9 
foreach X in K2_noland adjprof3 inv fixed {
	mycmd1 (amount100 amount200 amount100_power amount200_power) xtreg `X' amount100 amount200 amount100_power amount200_power wave2-wave9 wave10 wave11 power_wave2 - power_wave11 if Sample == 1 & ets>1 & sample2==1 & femaleverified==1, fe cluster(sheno)	
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..51] = FF[.,1]'; ResD[`c',1..51] = FF[.,2]'; ResDF[`c',1..51] = FF[.,3]'
mata ResB[`c',1..210] = BB[.,1]'; ResSE[`c',1..210] = BB[.,2]'

}


drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/51 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/210 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save results\FisherRedMMW, replace





