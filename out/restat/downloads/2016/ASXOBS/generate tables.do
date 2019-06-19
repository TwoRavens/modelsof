cd "~/Desktop/Research/College Sports/Data Archive"
set more off
set matsize 11000

// The following "condition" exists to allow one to easily fold all the data processing and program definition code, contained in brackets, out of view
if 1==1 {

*** Open college data

use "college data.dta"
sort teamname year

*** Keep variables we intend to use

keep teamname year athletics_total alumni_ops_athletics alumni_ops_total ops_athletics_total_grand usnews_academic_rep_new acceptance_rate appdate satdate satmt75 satvr75 satmt25 satvr25 applicants_male applicants_female enrolled_male enrolled_female vse_alum_giving_rate first_time_students_total first_time_outofstate first_time_instate total_giving_pre_2004 alumni_total_giving asian hispanic black control
save temp.dta, replace

use "covers_data.dta"

*** Fix errors in data

drop if team==68 & date==14568 & line==.
drop if team==136 & date==14568 & line==.

*** Generate a week variable

sort team season date
gen week = 1 in 1

local obs_counter = 2
local week_counter = 2
local end_counter = _N

while `obs_counter'<=`end_counter' {
	if season[`obs_counter']!=season[`obs_counter'-1] | team[`obs_counter']!=team[`obs_counter'-1] {
		local week_counter = 1
	}
	quietly replace week = `week_counter' in `obs_counter'
	local week_counter = `week_counter' + 1
	local obs_counter = `obs_counter' + 1
}

*** Drop out any games that could potentially be conference championship games and games with no line

keep if week<=12 & month!=12 & month!=1
sort teamname season week
by teamname season: egen total_obs = count(line)
keep if total_obs>=8
replace win = . if line==.

*** Estimate the single game propensity score as a function of the betting line

forvalues i = 2(1)5 {
	gen line`i' = line^`i'
}
logit win line line2 line3 line4 line5
predict pscore
sum pscore, det

// Generate measure of how much the team over/underperforms the spread

gen outperform = realspread+line

// Generate variables to hold outperform measure (and quadratic in line for comparison) for each week of the season
// Treat obs with missing lines as neither under nor overperforming

sort teamname season week
forvalues i=1(1)11 {
	gen outperform_wk`i'_temp = outperform if week==`i'
	by teamname season: egen outperform_wk`i' = mean(outperform_wk`i'_temp)
	replace outperform_wk`i' = 0 if outperform_wk`i'==.
	drop outperform_wk`i'_temp
	gen outperformwk`i'_2 = outperform_wk`i'^2
	gen outperformwk`i'_3 = outperform_wk`i'^3	
}

// Regress line in week i on cubic of outperform in all previous weeks and take residuals to condition out the portion of the line in week i that is due to team's over/underperformance in previous weeks

gen line_clean = line if week==1
forvalues i=2(1)12 {
	local lag = `i' - 1
	reg line outperform_wk1-outperformwk`lag'_3 if week==`i'
	predict line_clean`i' if week==`i', resid
	replace line_clean`i' = line_clean`i' + _b[_cons]
	replace line_clean = line_clean`i' if week==`i'
}

// Estimate propensity score using the "clean" betting line that has been purged of team over/underperformance

forvalues i = 2(1)5 {
	gen line_clean_p`i' = line_clean^`i'
}
logit win line_clean line_clean_p2 line_clean_p3 line_clean_p4 line_clean_p5
predict pscore_clean_line
sum pscore_clean_line, det

// Generate season aggregate measures

sort teamname season week
by teamname season: egen seasonwins = total(win)
by teamname season: egen seasongames = count(win)
by teamname season: egen seasonspread = total(realspread)
by teamname season: egen seasonline = total(line)
by teamname season: egen seasonoutperform = total(outperform)
by teamname season: egen seasonwins_5 = total(win) if week>=5
by teamname season: egen seasongames_5 = count(win) if week>=5
gen pct_win = seasonwins/seasongames
assert pct_win>=0 & pct_win<=1 if pct_win!=.

// Generate expected win measures (clean and naive)

by teamname season: egen exp_wins_naive = total(pscore)
by teamname season: egen exp_wins = total(pscore_clean_line)
gen exp_win_pct = exp_wins/seasongames
forvalues w = 1(1)11 {
	by teamname season: egen exp_wins_wk`w' = total(pscore) if week>`w'
}
gen exp_wins_wk12 = 0
by teamname season: egen exp_wins_wk0 = total(pscore) if week>0

// Generate weekly measures of wins, pscores, etc.

sort teamname season week
forvalues i=1(1)12 {
	gen pscore_wk`i'_temp = pscore if week==`i'
	by teamname season: egen pscore_wk`i' = mean(pscore_wk`i'_temp)
	drop pscore_wk`i'_temp
	gen win_wk`i'_temp = win if week==`i'
	by teamname season: egen win_wk`i' = mean(win_wk`i'_temp)
	drop win_wk`i'_temp
}
forvalues i=1(1)12 {
	gen pscore_wk`i'_temp_clean = pscore_clean_line if week==`i'
	by teamname season: egen pscore_clean_wk`i' = mean(pscore_wk`i'_temp_clean)
	drop pscore_wk`i'_temp_clean
}

collapse (mean) seasonwins-pct_win exp_wins_naive exp_wins exp_win_pct exp_wins_wk1-exp_wins_wk12 exp_wins_wk0 bcs pscore_wk1-win_wk12 pscore_clean_wk1-pscore_clean_wk12, by(teamname season)
rename season year
sort teamname year
merge teamname year using temp.dta
!rm temp.dta
tab _merge
drop if _merge==1 | _merge==2
drop _merge
sort teamname year

*** Variables of interest

*** Generate variables for analysis

sort teamname year
foreach varname of varlist seasonwins-pct_win exp_wins exp_wins_wk1-exp_wins_wk12 exp_wins_wk0 exp_win_pct pscore_wk1-win_wk12 pscore_clean_wk1-pscore_clean_wk12 {
	gen lag_`varname' = `varname'[_n-1] if teamname==teamname[_n-1] & year==year[_n-1]+1
	gen lag2_`varname' = `varname'[_n-2] if teamname==teamname[_n-2] & year==year[_n-1]+1 & year==year[_n-2]+2
	gen lag3_`varname' = `varname'[_n-3] if teamname==teamname[_n-3] & year==year[_n-1]+1 & year==year[_n-2]+2 & year==year[_n-3]+3
	gen lag4_`varname' = `varname'[_n-4] if teamname==teamname[_n-4] & year==year[_n-1]+1 & year==year[_n-2]+2 & year==year[_n-3]+3 & year==year[_n-4]+4
	gen lead_`varname' = `varname'[_n+1] if teamname==teamname[_n+1] & year==year[_n+1]-1
	gen lead2_`varname' = `varname'[_n+2] if teamname==teamname[_n+2] & year==year[_n+1]-1 & year==year[_n+2]-2
}

egen school_id = group(teamname)
xi i.year
xtset school_id

// Deal with special reporting dates for SAT scores and applicants

sort teamname year
foreach varname of varlist satmt25 satmt75 satvr25 satvr75 {
	gen `varname'_temp = `varname'
	replace `varname'_temp = . if satdate==1
	replace `varname'_temp = `varname'[_n+1] if `varname'_temp==. & satdate[_n+1]==1 & teamname[_n+1]==teamname & year[_n+1]==year+1
	drop `varname'
	rename `varname'_temp `varname'
} 

foreach varname of varlist applicants_male applicants_female enrolled_male enrolled_female {
	gen `varname'_temp = `varname'
	replace `varname'_temp = . if appdate==1
	replace `varname'_temp = `varname'[_n+1] if `varname'_temp==. & appdate[_n+1]==1 & teamname[_n+1]==teamname & year[_n+1]==year+1
	drop `varname'
	rename `varname'_temp `varname'
} 

sort teamname year
foreach varname of varlist satmt25 satmt75 satvr25 satvr75 {
	gen `varname'_temp = `varname'
	replace `varname'_temp = `varname'[_n+1] if teamname[_n+1]==teamname & year[_n+1]==year+1
	drop `varname'
	rename `varname'_temp `varname'
} 

foreach varname of varlist applicants_male applicants_female enrolled_male enrolled_female {
	gen `varname'_temp = .
	replace `varname'_temp = `varname'[_n+1] if teamname[_n+1]==teamname & year[_n+1]==year+1
	drop `varname'
	rename `varname'_temp `varname'
} 

gen athletics_share = alumni_ops_athletics/alumni_ops_total if alumni_ops_athletics/alumni_ops_total>.05 & alumni_ops_athletics/alumni_ops_total<.8
gen alum_non_athl_ops = alumni_ops_total - alumni_ops_athletics
gen sat_75 = satmt75 + satvr75
gen sat_25 = satmt25 + satvr25
gen applicants = applicants_male + applicants_female
drop appdate satdate

rename ops_athletics_total_grand ops_athl_grndtotal
rename first_time_students_total firsttime_total
rename first_time_outofstate firsttime_outofstate

sort teamname year
foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 sat_75 {
	gen lag_`varname' = `varname'[_n-1] if teamname==teamname[_n-1] & year==year[_n-1]+1
	gen lag2_`varname' = `varname'[_n-2] if teamname==teamname[_n-2] & year==year[_n-2]+2
	gen lag3_`varname' = `varname'[_n-3] if teamname==teamname[_n-3] & year==year[_n-3]+3
	gen lag4_`varname' = `varname'[_n-4] if teamname==teamname[_n-4] & year==year[_n-4]+4
}

// Recode Cincinnati, Louisville, South Florida, and UConn as non-BCS since they only joined in 2002 or 2005. Recode Temple as BCS since it was BCS in 1991.

replace bcs=0 if teamname=="Cincinnati" | teamname=="Louisville" | teamname=="South Florida" | teamname=="Connecticut"
replace bcs=1 if teamname=="Temple"

// Generate variables that code missing values as non-existent games

forvalues w = 1(1)12 {
	gen lag_win_wk_edmiss`w' = lag_win_wk`w' if lag_seasongames!=.
	replace lag_win_wk_edmiss`w' = 1 if (lag_win_wk`w'==. | lag_pscore_wk`w'==.) & lag_seasongames!=.
	gen lag_pscore_wk_edmiss`w' = lag_pscore_wk`w' if lag_seasongames!=.
	replace lag_pscore_wk_edmiss`w' = 1 if (lag_win_wk`w'==. | lag_pscore_wk`w'==.) & lag_seasongames!=.
	gen lead2_win_wk_edmiss`w' = lead2_win_wk`w' if lead2_seasongames!=.
	replace lead2_win_wk_edmiss`w' = 1 if (lead2_win_wk`w'==. | lead2_pscore_wk`w'==.) & lead2_seasongames!=.
	gen lead2_pscore_wk_edmiss`w' = lead2_pscore_wk`w' if lead2_seasongames!=.
	replace lead2_pscore_wk_edmiss`w' = 1 if (lead2_win_wk`w'==. | lead2_pscore_wk`w'==.) & lead2_seasongames!=.
	gen lag2_win_wk_edmiss`w' = lag2_win_wk`w' if lag2_seasongames!=.
	replace lag2_win_wk_edmiss`w' = 1 if (lag2_win_wk`w'==. | lag2_pscore_wk`w'==.) & lag2_seasongames!=.
	gen lag2_pscore_wk_edmiss`w' = lag2_pscore_wk`w' if lag2_seasongames!=.
	replace lag2_pscore_wk_edmiss`w' = 1 if (lag2_win_wk`w'==. | lag2_pscore_wk`w'==.) & lag2_seasongames!=.
}

// Calculate IPW weights for dynamic sequential treatment effects

gen lag_ipw_weight = 1/((lag_win_wk_edmiss1*lag_pscore_wk_edmiss1+(1-lag_win_wk_edmiss1)*(1-lag_pscore_wk_edmiss1)) * (lag_win_wk_edmiss2*lag_pscore_wk_edmiss2+(1-lag_win_wk_edmiss2)*(1-lag_pscore_wk_edmiss2)) * (lag_win_wk_edmiss3*lag_pscore_wk_edmiss3+(1-lag_win_wk_edmiss3)*(1-lag_pscore_wk_edmiss3)) * (lag_win_wk_edmiss4*lag_pscore_wk_edmiss4+(1-lag_win_wk_edmiss4)*(1-lag_pscore_wk_edmiss4)) * (lag_win_wk_edmiss5*lag_pscore_wk_edmiss5+(1-lag_win_wk_edmiss5)*(1-lag_pscore_wk_edmiss5)) * (lag_win_wk_edmiss6*lag_pscore_wk_edmiss6+(1-lag_win_wk_edmiss6)*(1-lag_pscore_wk_edmiss6)) * (lag_win_wk_edmiss7*lag_pscore_wk_edmiss7+(1-lag_win_wk_edmiss7)*(1-lag_pscore_wk_edmiss7)) * (lag_win_wk_edmiss8*lag_pscore_wk_edmiss8+(1-lag_win_wk_edmiss8)*(1-lag_pscore_wk_edmiss8)) * (lag_win_wk_edmiss9*lag_pscore_wk_edmiss9+(1-lag_win_wk_edmiss9)*(1-lag_pscore_wk_edmiss9)) * (lag_win_wk_edmiss10*lag_pscore_wk_edmiss10+(1-lag_win_wk_edmiss10)*(1-lag_pscore_wk_edmiss10)) * (lag_win_wk_edmiss11*lag_pscore_wk_edmiss11+(1-lag_win_wk_edmiss11)*(1-lag_pscore_wk_edmiss11))* (lag_win_wk_edmiss12*lag_pscore_wk_edmiss12+(1-lag_win_wk_edmiss12)*(1-lag_pscore_wk_edmiss12))) if lag_seasongames!=.

gen lead2_ipw_weight = 1/((lead2_win_wk_edmiss1*lead2_pscore_wk_edmiss1+(1-lead2_win_wk_edmiss1)*(1-lead2_pscore_wk_edmiss1)) * (lead2_win_wk_edmiss2*lead2_pscore_wk_edmiss2+(1-lead2_win_wk_edmiss2)*(1-lead2_pscore_wk_edmiss2)) * (lead2_win_wk_edmiss3*lead2_pscore_wk_edmiss3+(1-lead2_win_wk_edmiss3)*(1-lead2_pscore_wk_edmiss3)) * (lead2_win_wk_edmiss4*lead2_pscore_wk_edmiss4+(1-lead2_win_wk_edmiss4)*(1-lead2_pscore_wk_edmiss4)) * (lead2_win_wk_edmiss5*lead2_pscore_wk_edmiss5+(1-lead2_win_wk_edmiss5)*(1-lead2_pscore_wk_edmiss5)) * (lead2_win_wk_edmiss6*lead2_pscore_wk_edmiss6+(1-lead2_win_wk_edmiss6)*(1-lead2_pscore_wk_edmiss6)) * (lead2_win_wk_edmiss7*lead2_pscore_wk_edmiss7+(1-lead2_win_wk_edmiss7)*(1-lead2_pscore_wk_edmiss7)) * (lead2_win_wk_edmiss8*lead2_pscore_wk_edmiss8+(1-lead2_win_wk_edmiss8)*(1-lead2_pscore_wk_edmiss8)) * (lead2_win_wk_edmiss9*lead2_pscore_wk_edmiss9+(1-lead2_win_wk_edmiss9)*(1-lead2_pscore_wk_edmiss9)) * (lead2_win_wk_edmiss10*lead2_pscore_wk_edmiss10+(1-lead2_win_wk_edmiss10)*(1-lead2_pscore_wk_edmiss10)) * (lead2_win_wk_edmiss11*lead2_pscore_wk_edmiss11+(1-lead2_win_wk_edmiss11)*(1-lead2_pscore_wk_edmiss11))* (lead2_win_wk_edmiss12*lead2_pscore_wk_edmiss12+(1-lead2_win_wk_edmiss12)*(1-lead2_pscore_wk_edmiss12))) if lead2_seasongames!=.

gen lag_ipw_weight_5 = 1/((lag_win_wk_edmiss5*lag_pscore_wk_edmiss5+(1-lag_win_wk_edmiss5)*(1-lag_pscore_wk_edmiss5)) * (lag_win_wk_edmiss6*lag_pscore_wk_edmiss6+(1-lag_win_wk_edmiss6)*(1-lag_pscore_wk_edmiss6)) * (lag_win_wk_edmiss7*lag_pscore_wk_edmiss7+(1-lag_win_wk_edmiss7)*(1-lag_pscore_wk_edmiss7)) * (lag_win_wk_edmiss8*lag_pscore_wk_edmiss8+(1-lag_win_wk_edmiss8)*(1-lag_pscore_wk_edmiss8)) * (lag_win_wk_edmiss9*lag_pscore_wk_edmiss9+(1-lag_win_wk_edmiss9)*(1-lag_pscore_wk_edmiss9)) * (lag_win_wk_edmiss10*lag_pscore_wk_edmiss10+(1-lag_win_wk_edmiss10)*(1-lag_pscore_wk_edmiss10)) * (lag_win_wk_edmiss11*lag_pscore_wk_edmiss11+(1-lag_win_wk_edmiss11)*(1-lag_pscore_wk_edmiss11))* (lag_win_wk_edmiss12*lag_pscore_wk_edmiss12+(1-lag_win_wk_edmiss12)*(1-lag_pscore_wk_edmiss12)))

gen lag2_ipw_weight = 1/((lag2_win_wk_edmiss1*lag2_pscore_wk_edmiss1+(1-lag2_win_wk_edmiss1)*(1-lag2_pscore_wk_edmiss1)) * (lag2_win_wk_edmiss2*lag2_pscore_wk_edmiss2+(1-lag2_win_wk_edmiss2)*(1-lag2_pscore_wk_edmiss2)) * (lag2_win_wk_edmiss3*lag2_pscore_wk_edmiss3+(1-lag2_win_wk_edmiss3)*(1-lag2_pscore_wk_edmiss3)) * (lag2_win_wk_edmiss4*lag2_pscore_wk_edmiss4+(1-lag2_win_wk_edmiss4)*(1-lag2_pscore_wk_edmiss4)) * (lag2_win_wk_edmiss5*lag2_pscore_wk_edmiss5+(1-lag2_win_wk_edmiss5)*(1-lag2_pscore_wk_edmiss5)) * (lag2_win_wk_edmiss6*lag2_pscore_wk_edmiss6+(1-lag2_win_wk_edmiss6)*(1-lag2_pscore_wk_edmiss6)) * (lag2_win_wk_edmiss7*lag2_pscore_wk_edmiss7+(1-lag2_win_wk_edmiss7)*(1-lag2_pscore_wk_edmiss7)) * (lag2_win_wk_edmiss8*lag2_pscore_wk_edmiss8+(1-lag2_win_wk_edmiss8)*(1-lag2_pscore_wk_edmiss8)) * (lag2_win_wk_edmiss9*lag2_pscore_wk_edmiss9+(1-lag2_win_wk_edmiss9)*(1-lag2_pscore_wk_edmiss9)) * (lag2_win_wk_edmiss10*lag2_pscore_wk_edmiss10+(1-lag2_win_wk_edmiss10)*(1-lag2_pscore_wk_edmiss10)) * (lag2_win_wk_edmiss11*lag2_pscore_wk_edmiss11+(1-lag2_win_wk_edmiss11)*(1-lag2_pscore_wk_edmiss11))* (lag2_win_wk_edmiss12*lag2_pscore_wk_edmiss12+(1-lag2_win_wk_edmiss12)*(1-lag2_pscore_wk_edmiss12))) if lag2_seasongames!=.

// Define program to run main p-score matching and sequential treatment effect results
// Takes args: bcs, trim_value, iv_flag, cluster_school
capture: program drop main_results
program define main_results
	// Note: Group sizes will not be perfectly balanced because there is clustering in p-scores (spreads are in 0.5 unit increments)
	forvalues w = 1(1)12 {
		capture: drop lag_pscore_wk`w'_group
		foreach varname of varlist lag_pscore_wk`w' {
			sum lag_pscore_wk`w' if lag_win_wk`w'==1 & `1'
			local min_treated = max(r(min),0.05)
			sum lag_pscore_wk`w' if lag_win_wk`w'==0 & `1'
			local max_treated = min(r(max), 0.95)
			centile `varname' if `1' & `varname'>=`min_treated' & `varname'<=`max_treated', centile(10(8)90)
			gen `varname'_group = .
			forvalues i = 2(1)11 {
				local iminus1 = `i' - 1
				local bottom_centile = r(c_`iminus1') 
				local top_centile = r(c_`i') 
				replace `varname'_group = `i' if `varname'>=`bottom_centile' & `varname'<`top_centile' & `1'
			}	
			replace `varname'_group = 1 if `varname'<r(c_1) & `1' & `varname'>=`min_treated'
			replace `varname'_group = 12 if `varname'>=r(c_11) & `varname'!=. & `1' & `varname'<=`max_treated'
		}
	}

	capture: drop variable_name 
	capture: drop ols_result
	capture: drop ols_pval
	capture: drop ols_N
	capture: drop ldv_result
	capture: drop ldv_pval
	capture: drop ldv_N

	gen variable_name = ""
	gen ols_result = .
	gen ols_pval = .
	gen ols_N = .
	gen ldv_result = .
	gen ldv_pval = .
	gen ldv_N = .

	// Run first stage for matching regressions

	capture: drop matching_dep_var
	gen str40 matching_dep_var = ""

	forvalues w = 1(1)12 {
		xi i.lag_pscore_wk`w'_group*lag_win_wk`w' i.lag_pscore_wk`w'_group*lag_pscore_wk`w', noomit
		reg lag_exp_wins_wk`w' _Ilag* if `1', vce(cluster school_id) noconstant
		tab lag_pscore_wk`w'_group if e(sample), matcell(freqmat) matrow(valmat)
		local totalestobs = r(N)
		svmat valmat, names(val)
		svmat freqmat, names(freq)	
		forvalues j = 1(1)12 {
			quietly sum freq1 if val1==`j' in 1/12
			if r(N)==1 {
				if r(mean)>3 {
					local freq`j' =	r(mean)			
				}
				else {
					local freq`j' = 0
				}
			}
			else {
				local freq`j' = 0
			}
		}
		drop val1 freq1
		capture: drop matching_fs_coeff_lhs_`w'
		gen matching_fs_coeff_lhs_`w' = .
		gen group = _n in 1/12
		gen groupsq = group^2 in 1/12
		forvalues j = 1(1)12 {
			replace matching_fs_coeff_lhs_`w' = _b[_IlagXlag__`j'] in `j'
		}
		reg matching_fs_coeff_lhs_`w' group groupsq
		predict matching_fs_coeff_`w'_pred in 1/12
		predict matching_fs_coeff_`w'_pred_se in 1/12, stdp
		drop group groupsq
		forvalues j = 1(1)12 {
			capture: drop matching_fs_coeff_`w'_`j' matching_fs_se_`w'_`j'
			gen matching_fs_coeff_`w'_`j' = matching_fs_coeff_`w'_pred[`j'] in 1/30
			gen matching_fs_se_`w'_`j' = matching_fs_coeff_`w'_pred_se[`j'] in 1/30
		}
		drop matching_fs_coeff_`w'_pred matching_fs_coeff_`w'_pred_se
		if `w'==12 {
			forvalues j = 1(1)12 {	
				replace matching_fs_coeff_`w'_`j' = 0 in 1/30
				replace matching_fs_se_`w'_`j' = 0 in 1/30
			}
		}
	}

	// Run reduced form for matching regressions

	forvalues w = 1(1)12 {
		capture: drop matching_coeff_`w' matching_se_`w' matching_rf_coeff_`w' matching_rf_se_`w' matching_N_`w'
		local i = 1
		gen float matching_coeff_`w' = .
		gen float matching_se_`w' = .
		gen float matching_N_`w' = .
		gen float matching_rf_coeff_`w' = .
		gen float matching_rf_se_`w' = .
		xi i.lag_pscore_wk`w'_group*lag_win_wk`w' i.lag_pscore_wk`w'_group*lag_pscore_wk`w', noomit
		foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
			replace matching_dep_var = "`varname'" in `i'
			reg `varname' _Ilag* if `1', vce(cluster school_id) noconstant
			tab lag_pscore_wk`w'_group if e(sample), matcell(freqmat) matrow(valmat)
			local totalestobs = r(N)
			svmat valmat, names(val)
			svmat freqmat, names(freq)	
			forvalues j = 1(1)12 {
				quietly sum freq1 if val1==`j' in 1/12
				if r(N)==1 {
					if r(mean)>3 {
						local freq`j' =	r(mean)			
					}
					else {
						local freq`j' = 0
					}
				}
				else {
					local freq`j' = 0
				}
			}
			drop val1 freq1
			// Enforce overlap: drop any cells with less than 2 wins or losses
			forvalues j = 1(1)12 {
				sum lag_win_wk`w' if e(sample) & lag_pscore_wk`w'_group==`j' & lag_win_wk`w'==1
				local wincount = r(N)
				sum lag_win_wk`w' if e(sample) & lag_pscore_wk`w'_group==`j' & lag_win_wk`w'==0
				local losscount = r(N)
				if min(`wincount',`losscount')<2 {
					local weight`j' = 0
				}
				else {
					local weight`j' = 1
				}
			}
			local totalestobs = (`freq1'*`weight1' + `freq2'*`weight2' + `freq3'*`weight3' + `freq4'*`weight4' + `freq5'*`weight5' + `freq6'*`weight6' + `freq7'*`weight7' + `freq8'*`weight8' + `freq9'*`weight9' + `freq10'*`weight10' + `freq11'*`weight11' + `freq12'*`weight12')
			lincom (_b[_IlagXlag__1]*`freq1'*`weight1' + _b[_IlagXlag__2]*`freq2'*`weight2' + _b[_IlagXlag__3]*`freq3'*`weight3' + _b[_IlagXlag__4]*`freq4'*`weight4' + _b[_IlagXlag__5]*`freq5'*`weight5' + _b[_IlagXlag__6]*`freq6'*`weight6' + _b[_IlagXlag__7]*`freq7'*`weight7' + _b[_IlagXlag__8]*`freq8'*`weight8' + _b[_IlagXlag__9]*`freq9'*`weight9' + _b[_IlagXlag__10]*`freq10'*`weight10' + _b[_IlagXlag__11]*`freq11'*`weight11' + _b[_IlagXlag__12]*`freq12'*`weight12')/`totalestobs'
			local C = r(estimate)
			local SE = r(se)
			replace matching_rf_coeff_`w' = `C' in `i'
			replace matching_rf_se_`w' = `SE' in `i'
			replace matching_N_`w' = e(N) in `i'		
			forvalues j = 1(1)12 {
				local fs`j' = 1 + matching_fs_coeff_`w'_`j'[`i']
				local fs_se`j' = matching_fs_se_`w'_`j'[`i']
			}
			lincom (_b[_IlagXlag__1]*`freq1'*`weight1'/`fs1' + _b[_IlagXlag__2]*`freq2'*`weight2'/`fs2' + _b[_IlagXlag__3]*`freq3'*`weight3'/`fs3' + _b[_IlagXlag__4]*`freq4'*`weight4'/`fs4' + _b[_IlagXlag__5]*`freq5'*`weight5'/`fs5' + _b[_IlagXlag__6]*`freq6'*`weight6'/`fs6' + _b[_IlagXlag__7]*`freq7'*`weight7'/`fs7' + _b[_IlagXlag__8]*`freq8'*`weight8'/`fs8' + _b[_IlagXlag__9]*`freq9'*`weight9'/`fs9' + _b[_IlagXlag__10]*`freq10'*`weight10'/`fs10' + _b[_IlagXlag__11]*`freq11'*`weight11'/`fs11' + _b[_IlagXlag__12]*`freq12'*`weight12'/`fs12')/`totalestobs'
			local C = r(estimate)
			local SE = (((_se[_IlagXlag__1]/(`fs1'))^2 + (`fs_se1'*_b[_IlagXlag__1]/(`fs1')^2)^2)*(`freq1'*`weight1'/`totalestobs')^2 +  ((_se[_IlagXlag__2]/(`fs2'))^2 + (`fs_se2'*_b[_IlagXlag__2]/(`fs2')^2)^2)*(`freq2'*`weight2'/`totalestobs')^2 +  ((_se[_IlagXlag__3]/(`fs3'))^2 + (`fs_se3'*_b[_IlagXlag__3]/(`fs3')^2)^2)*(`freq3'*`weight3'/`totalestobs')^2 +  ((_se[_IlagXlag__4]/(`fs4'))^2 + (`fs_se4'*_b[_IlagXlag__4]/(`fs4')^2)^2)*(`freq4'*`weight4'/`totalestobs')^2 +  ((_se[_IlagXlag__5]/(`fs5'))^2 + (`fs_se5'*_b[_IlagXlag__5]/(`fs5')^2)^2)*(`freq5'*`weight5'/`totalestobs')^2 +  ((_se[_IlagXlag__6]/(`fs6'))^2 + (`fs_se6'*_b[_IlagXlag__6]/(`fs6')^2)^2)*(`freq6'*`weight6'/`totalestobs')^2 +  ((_se[_IlagXlag__7]/(`fs7'))^2 + (`fs_se7'*_b[_IlagXlag__7]/(`fs7')^2)^2)*(`freq7'*`weight7'/`totalestobs')^2 +  ((_se[_IlagXlag__8]/(`fs8'))^2 + (`fs_se8'*_b[_IlagXlag__8]/(`fs8')^2)^2)*(`freq8'*`weight8'/`totalestobs')^2 +  ((_se[_IlagXlag__9]/(`fs9'))^2 + (`fs_se9'*_b[_IlagXlag__9]/(`fs9')^2)^2)*(`freq9'*`weight9'/`totalestobs')^2 +  ((_se[_IlagXlag__10]/(`fs10'))^2 + (`fs_se10'*_b[_IlagXlag__10]/(`fs10')^2)^2)*(`freq10'*`weight10'/`totalestobs')^2 +  ((_se[_IlagXlag__11]/(`fs11'))^2 + (`fs_se11'*_b[_IlagXlag__11]/(`fs11')^2)^2)*(`freq11'*`weight11'/`totalestobs')^2 +  ((_se[_IlagXlag__12]/(`fs12'))^2 + (`fs_se12'*_b[_IlagXlag__12]/(`fs12')^2)^2)*(`freq12'*`weight12'/`totalestobs')^2)^0.5	
			replace matching_coeff_`w' = `C' in `i'
			replace matching_se_`w' = `SE' in `i'
			local i = `i' + 1
		}
	}

	capture: drop total_N matching_coeff matching_se matching_rf_coeff matching_rf_se matching_N
	gen total_N = matching_N_1 + matching_N_2 + matching_N_3 + matching_N_4 + matching_N_5 + matching_N_6 + matching_N_7 + matching_N_8 + matching_N_9 + matching_N_10 + matching_N_11 + matching_N_12
	gen matching_rf_coeff = matching_rf_coeff_1*(matching_N_1/total_N) + matching_rf_coeff_2*(matching_N_2/total_N) + matching_rf_coeff_3*(matching_N_3/total_N) + matching_rf_coeff_4*(matching_N_4/total_N) + matching_rf_coeff_5*(matching_N_5/total_N) + matching_rf_coeff_6*(matching_N_6/total_N) + matching_rf_coeff_7*(matching_N_7/total_N) + matching_rf_coeff_8*(matching_N_8/total_N) + matching_rf_coeff_9*(matching_N_9/total_N) + matching_rf_coeff_10*(matching_N_10/total_N) + matching_rf_coeff_11*(matching_N_11/total_N) + matching_rf_coeff_12*(matching_N_12/total_N)
	gen matching_rf_se = ((matching_rf_se_1^2)*(matching_N_1/total_N)^2 + (matching_rf_se_2^2)*(matching_N_2/total_N)^2 + (matching_rf_se_3^2)*(matching_N_3/total_N)^2 + (matching_rf_se_4^2)*(matching_N_4/total_N)^2 + (matching_rf_se_5^2)*(matching_N_5/total_N)^2 + (matching_rf_se_6^2)*(matching_N_6/total_N)^2 + (matching_rf_se_7^2)*(matching_N_7/total_N)^2 + (matching_rf_se_8^2)*(matching_N_8/total_N)^2 + (matching_rf_se_9^2)*(matching_N_9/total_N)^2 + (matching_rf_se_10^2)*(matching_N_10/total_N)^2 + (matching_rf_se_11^2)*(matching_N_11/total_N)^2 + (matching_rf_se_12^2)*(matching_N_12/total_N)^2)^0.5
	gen matching_coeff = matching_coeff_1*(matching_N_1/total_N) + matching_coeff_2*(matching_N_2/total_N) + matching_coeff_3*(matching_N_3/total_N) + matching_coeff_4*(matching_N_4/total_N) + matching_coeff_5*(matching_N_5/total_N) + matching_coeff_6*(matching_N_6/total_N) + matching_coeff_7*(matching_N_7/total_N) + matching_coeff_8*(matching_N_8/total_N) + matching_coeff_9*(matching_N_9/total_N) + matching_coeff_10*(matching_N_10/total_N) + matching_coeff_11*(matching_N_11/total_N) + matching_coeff_12*(matching_N_12/total_N)
	gen matching_se = ((matching_se_1^2)*(matching_N_1/total_N)^2 + (matching_se_2^2)*(matching_N_2/total_N)^2 + (matching_se_3^2)*(matching_N_3/total_N)^2 + (matching_se_4^2)*(matching_N_4/total_N)^2 + (matching_se_5^2)*(matching_N_5/total_N)^2 + (matching_se_6^2)*(matching_N_6/total_N)^2 + (matching_se_7^2)*(matching_N_7/total_N)^2 + (matching_se_8^2)*(matching_N_8/total_N)^2 + (matching_se_9^2)*(matching_N_9/total_N)^2 + (matching_se_10^2)*(matching_N_10/total_N)^2 + (matching_se_11^2)*(matching_N_11/total_N)^2 + (matching_se_12^2)*(matching_N_12/total_N)^2)^0.5
	gen matching_N = max(matching_N_1, matching_N_2, matching_N_3, matching_N_4, matching_N_5, matching_N_6, matching_N_7, matching_N_8, matching_N_9, matching_N_10, matching_N_11, matching_N_12)

	local obscounter = 1
	local varcounter = 1
	while `obscounter'<=20 {
		local secounter = `obscounter' + 1
		replace variable_name = matching_dep_var[`varcounter'] in `obscounter'
		replace ols_N = matching_N[`varcounter'] in `obscounter'
		if `3'==0 {
			replace ols_result = matching_rf_coeff[`varcounter'] in `obscounter'
			replace ols_result = matching_rf_se[`varcounter'] in `secounter'
			replace ols_pval = 2*ttail(105,abs(matching_rf_coeff[`varcounter']/matching_rf_se[`varcounter'])) in `obscounter'
		}
		else {
			replace ols_result = matching_coeff[`varcounter'] in `obscounter'
			replace ols_result = matching_se[`varcounter'] in `secounter'
			replace ols_pval = 2*ttail(105,abs(matching_coeff[`varcounter']/matching_se[`varcounter'])) in `obscounter'
		}
		local varcounter = `varcounter' + 1
		local obscounter = `obscounter' + 2
	}


	// Create residualized dependent variables for matching regressions

	xi i.year i.school_id

	foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
		capture: drop r`varname'
		gen r`varname'_temp = `varname' - lag2_`varname'
		reg r`varname'_temp _Iyear* if `1'
		predict r`varname', resid
		drop r`varname'_temp
	}

	// Run reduced form for residualized matching regressions

	capture: drop matching_resid_dep_var
	gen str40 matching_resid_dep_var = ""

	forvalues w = 1(1)12 {
		capture: drop matching_resid_coeff_`w' matching_resid_se_`w' matching_resid_N_`w' matching_rf_resid_coeff_`w' matching_rf_resid_se_`w'
		local i = 1
		gen float matching_resid_coeff_`w' = .
		gen float matching_resid_se_`w' = .
		gen float matching_resid_N_`w' = .
		gen float matching_rf_resid_coeff_`w' = .
		gen float matching_rf_resid_se_`w' = .
		xi i.lag_pscore_wk`w'_group*lag_win_wk`w' i.lag_pscore_wk`w'_group*lag_pscore_wk`w', noomit
		foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
			replace matching_resid_dep_var = "`varname'" in `i'
			reg r`varname' _Ilag* if `1', `4' noconstant
			tab lag_pscore_wk`w'_group if e(sample), matcell(freqmat) matrow(valmat)
			local totalestobs = r(N)
			svmat valmat, names(val)
			svmat freqmat, names(freq)	
			forvalues j = 1(1)12 {
				quietly sum freq1 if val1==`j' in 1/12
				if r(N)==1 {
					if r(mean)>3 {
						local freq`j' =	r(mean)			
					}
					else {
						local freq`j' = 0
					}
				}
				else {
					local freq`j' = 0
				}
			}
			drop val1 freq1
			// Enforce overlap: drop any cells with less than 2 wins or losses
			forvalues j = 1(1)12 {
				sum lag_win_wk`w' if e(sample) & lag_pscore_wk`w'_group==`j' & lag_win_wk`w'==1
				local wincount = r(N)
				sum lag_win_wk`w' if e(sample) & lag_pscore_wk`w'_group==`j' & lag_win_wk`w'==0
				local losscount = r(N)
				if min(`wincount',`losscount')<2 {
					local weight`j' = 0
				}
				else {
					local weight`j' = 1
				}
			}
			local totalestobs = (`freq1'*`weight1' + `freq2'*`weight2' + `freq3'*`weight3' + `freq4'*`weight4' + `freq5'*`weight5' + `freq6'*`weight6' + `freq7'*`weight7' + `freq8'*`weight8' + `freq9'*`weight9' + `freq10'*`weight10' + `freq11'*`weight11' + `freq12'*`weight12')
			lincom (_b[_IlagXlag__1]*`freq1'*`weight1' + _b[_IlagXlag__2]*`freq2'*`weight2' + _b[_IlagXlag__3]*`freq3'*`weight3' + _b[_IlagXlag__4]*`freq4'*`weight4' + _b[_IlagXlag__5]*`freq5'*`weight5' + _b[_IlagXlag__6]*`freq6'*`weight6' + _b[_IlagXlag__7]*`freq7'*`weight7' + _b[_IlagXlag__8]*`freq8'*`weight8' + _b[_IlagXlag__9]*`freq9'*`weight9' + _b[_IlagXlag__10]*`freq10'*`weight10' + _b[_IlagXlag__11]*`freq11'*`weight11' + _b[_IlagXlag__12]*`freq12'*`weight12')/`totalestobs'
			local C = r(estimate)
			local SE = r(se)
			replace matching_rf_resid_coeff_`w' = `C' in `i'
			replace matching_rf_resid_se_`w' = `SE' in `i'
			replace matching_resid_N_`w' = e(N) in `i'		
			forvalues j = 1(1)12 {
				local fs`j' = 1 + matching_fs_coeff_`w'_`j'[`i']
				local fs_se`j' = matching_fs_se_`w'_`j'[`i']
			}
			lincom (_b[_IlagXlag__1]*`freq1'*`weight1'/`fs1' + _b[_IlagXlag__2]*`freq2'*`weight2'/`fs2' + _b[_IlagXlag__3]*`freq3'*`weight3'/`fs3' + _b[_IlagXlag__4]*`freq4'*`weight4'/`fs4' + _b[_IlagXlag__5]*`freq5'*`weight5'/`fs5' + _b[_IlagXlag__6]*`freq6'*`weight6'/`fs6' + _b[_IlagXlag__7]*`freq7'*`weight7'/`fs7' + _b[_IlagXlag__8]*`freq8'*`weight8'/`fs8' + _b[_IlagXlag__9]*`freq9'*`weight9'/`fs9' + _b[_IlagXlag__10]*`freq10'*`weight10'/`fs10' + _b[_IlagXlag__11]*`freq11'*`weight11'/`fs11' + _b[_IlagXlag__12]*`freq12'*`weight12'/`fs12')/`totalestobs'
			local C = r(estimate)
			local SE = (((_se[_IlagXlag__1]/(`fs1'))^2 + (`fs_se1'*_b[_IlagXlag__1]/(`fs1')^2)^2)*(`freq1'*`weight1'/`totalestobs')^2 +  ((_se[_IlagXlag__2]/(`fs2'))^2 + (`fs_se2'*_b[_IlagXlag__2]/(`fs2')^2)^2)*(`freq2'*`weight2'/`totalestobs')^2 +  ((_se[_IlagXlag__3]/(`fs3'))^2 + (`fs_se3'*_b[_IlagXlag__3]/(`fs3')^2)^2)*(`freq3'*`weight3'/`totalestobs')^2 +  ((_se[_IlagXlag__4]/(`fs4'))^2 + (`fs_se4'*_b[_IlagXlag__4]/(`fs4')^2)^2)*(`freq4'*`weight4'/`totalestobs')^2 +  ((_se[_IlagXlag__5]/(`fs5'))^2 + (`fs_se5'*_b[_IlagXlag__5]/(`fs5')^2)^2)*(`freq5'*`weight5'/`totalestobs')^2 +  ((_se[_IlagXlag__6]/(`fs6'))^2 + (`fs_se6'*_b[_IlagXlag__6]/(`fs6')^2)^2)*(`freq6'*`weight6'/`totalestobs')^2 +  ((_se[_IlagXlag__7]/(`fs7'))^2 + (`fs_se7'*_b[_IlagXlag__7]/(`fs7')^2)^2)*(`freq7'*`weight7'/`totalestobs')^2 +  ((_se[_IlagXlag__8]/(`fs8'))^2 + (`fs_se8'*_b[_IlagXlag__8]/(`fs8')^2)^2)*(`freq8'*`weight8'/`totalestobs')^2 +  ((_se[_IlagXlag__9]/(`fs9'))^2 + (`fs_se9'*_b[_IlagXlag__9]/(`fs9')^2)^2)*(`freq9'*`weight9'/`totalestobs')^2 +  ((_se[_IlagXlag__10]/(`fs10'))^2 + (`fs_se10'*_b[_IlagXlag__10]/(`fs10')^2)^2)*(`freq10'*`weight10'/`totalestobs')^2 +  ((_se[_IlagXlag__11]/(`fs11'))^2 + (`fs_se11'*_b[_IlagXlag__11]/(`fs11')^2)^2)*(`freq11'*`weight11'/`totalestobs')^2 +  ((_se[_IlagXlag__12]/(`fs12'))^2 + (`fs_se12'*_b[_IlagXlag__12]/(`fs12')^2)^2)*(`freq12'*`weight12'/`totalestobs')^2)^0.5	
			replace matching_resid_coeff_`w' = `C' in `i'
			replace matching_resid_se_`w' = `SE' in `i'
			local i = `i' + 1
		}
	}

	capture: drop total_resid_N matching_resid_coeff matching_resid_se matching_resid_N matching_rf_resid_coeff matching_rf_resid_se
	gen total_resid_N = matching_resid_N_1 + matching_resid_N_2 + matching_resid_N_3 + matching_resid_N_4 + matching_resid_N_5 + matching_resid_N_6 + matching_resid_N_7 + matching_resid_N_8 + matching_resid_N_9 + matching_resid_N_10 + matching_resid_N_11 + matching_resid_N_12
	gen matching_rf_resid_coeff = matching_rf_resid_coeff_1*(matching_resid_N_1/total_resid_N) + matching_rf_resid_coeff_2*(matching_resid_N_2/total_resid_N) + matching_rf_resid_coeff_3*(matching_resid_N_3/total_resid_N) + matching_rf_resid_coeff_4*(matching_resid_N_4/total_resid_N) + matching_rf_resid_coeff_5*(matching_resid_N_5/total_resid_N) + matching_rf_resid_coeff_6*(matching_resid_N_6/total_resid_N) + matching_rf_resid_coeff_7*(matching_resid_N_7/total_resid_N) + matching_rf_resid_coeff_8*(matching_resid_N_8/total_resid_N) + matching_rf_resid_coeff_9*(matching_resid_N_9/total_resid_N) + matching_rf_resid_coeff_10*(matching_resid_N_10/total_resid_N) + matching_rf_resid_coeff_11*(matching_resid_N_11/total_resid_N) + matching_rf_resid_coeff_12*(matching_resid_N_12/total_resid_N)
	gen matching_rf_resid_se = ((matching_rf_resid_se_1^2)*(matching_resid_N_1/total_resid_N)^2 + (matching_rf_resid_se_2^2)*(matching_resid_N_2/total_resid_N)^2 + (matching_rf_resid_se_3^2)*(matching_resid_N_3/total_resid_N)^2 + (matching_rf_resid_se_4^2)*(matching_resid_N_4/total_resid_N)^2 + (matching_rf_resid_se_5^2)*(matching_resid_N_5/total_resid_N)^2 + (matching_rf_resid_se_6^2)*(matching_resid_N_6/total_resid_N)^2 + (matching_rf_resid_se_7^2)*(matching_resid_N_7/total_resid_N)^2 + (matching_rf_resid_se_8^2)*(matching_resid_N_8/total_resid_N)^2 + (matching_rf_resid_se_9^2)*(matching_resid_N_9/total_resid_N)^2 + (matching_rf_resid_se_10^2)*(matching_resid_N_10/total_resid_N)^2 + (matching_rf_resid_se_11^2)*(matching_resid_N_11/total_resid_N)^2 + (matching_rf_resid_se_12^2)*(matching_resid_N_12/total_resid_N)^2)^0.5
	gen matching_resid_coeff = matching_resid_coeff_1*(matching_resid_N_1/total_resid_N) + matching_resid_coeff_2*(matching_resid_N_2/total_resid_N) + matching_resid_coeff_3*(matching_resid_N_3/total_resid_N) + matching_resid_coeff_4*(matching_resid_N_4/total_resid_N) + matching_resid_coeff_5*(matching_resid_N_5/total_resid_N) + matching_resid_coeff_6*(matching_resid_N_6/total_resid_N) + matching_resid_coeff_7*(matching_resid_N_7/total_resid_N) + matching_resid_coeff_8*(matching_resid_N_8/total_resid_N) + matching_resid_coeff_9*(matching_resid_N_9/total_resid_N) + matching_resid_coeff_10*(matching_resid_N_10/total_resid_N) + matching_resid_coeff_11*(matching_resid_N_11/total_resid_N) + matching_resid_coeff_12*(matching_resid_N_12/total_resid_N)
	gen matching_resid_se = ((matching_resid_se_1^2)*(matching_resid_N_1/total_resid_N)^2 + (matching_resid_se_2^2)*(matching_resid_N_2/total_resid_N)^2 + (matching_resid_se_3^2)*(matching_resid_N_3/total_resid_N)^2 + (matching_resid_se_4^2)*(matching_resid_N_4/total_resid_N)^2 + (matching_resid_se_5^2)*(matching_resid_N_5/total_resid_N)^2 + (matching_resid_se_6^2)*(matching_resid_N_6/total_resid_N)^2 + (matching_resid_se_7^2)*(matching_resid_N_7/total_resid_N)^2 + (matching_resid_se_8^2)*(matching_resid_N_8/total_resid_N)^2 + (matching_resid_se_9^2)*(matching_resid_N_9/total_resid_N)^2 + (matching_resid_se_10^2)*(matching_resid_N_10/total_resid_N)^2 + (matching_resid_se_11^2)*(matching_resid_N_11/total_resid_N)^2 + (matching_resid_se_12^2)*(matching_resid_N_12/total_resid_N)^2)^0.5
	gen matching_resid_N = max(matching_resid_N_1, matching_resid_N_2, matching_resid_N_3, matching_resid_N_4, matching_resid_N_5, matching_resid_N_6, matching_resid_N_7, matching_resid_N_8, matching_resid_N_9, matching_resid_N_10, matching_resid_N_11, matching_resid_N_12)

	local obscounter = 1
	local varcounter = 1
	while `obscounter'<=20 {
		local secounter = `obscounter' + 1
		replace ldv_N = matching_resid_N[`varcounter'] in `obscounter'
		if `3'==0 {
			replace ldv_result = matching_rf_resid_coeff[`varcounter'] in `obscounter'
			replace ldv_result = matching_rf_resid_se[`varcounter'] in `secounter'
			replace ldv_pval = 2*ttail(105,abs(matching_rf_resid_coeff[`varcounter']/matching_rf_resid_se[`varcounter'])) in `obscounter'
		}
		else {
			replace ldv_result = matching_resid_coeff[`varcounter'] in `obscounter'
			replace ldv_result = matching_resid_se[`varcounter'] in `secounter'
			replace ldv_pval = 2*ttail(105,abs(matching_resid_coeff[`varcounter']/matching_resid_se[`varcounter'])) in `obscounter'
		}
		local varcounter = `varcounter' + 1
		local obscounter = `obscounter' + 2
	}
	drop _I*
	xi i.year

	capture: drop ols_result_seq
	capture: drop ols_result_wgt_seq
	capture: drop ols_pval_seq
	capture: drop ols_N_seq
	capture: drop ldv_result_seq
	capture: drop ldv_result_wgt_seq
	capture: drop ldv_pval_seq
	capture: drop ldv_N_seq
	capture: drop ldv_se_wgt_seq

	gen ols_result_seq = .
	gen ols_result_wgt_seq = .
	gen ols_pval_seq = .
	gen ols_N_seq = .
	gen ldv_result_seq = .
	gen ldv_result_wgt_seq = .
	gen ldv_pval_seq = .
	gen ldv_N_seq = .
	gen ldv_se_wgt_seq = .
	local counter = 1

	capture: drop rseasonwins
	capture: drop rseasongames
	gen rseasonwins = lag_seasonwins - lag3_seasonwins
	gen rseasongames = lag_seasongames - lag3_seasongames

	foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
		capture: drop r`varname'
		gen r`varname' = `varname' - lag2_`varname'
		reg r`varname' rseasonwins lag3_seasonwins lag_seasongames lag3_seasongames _Iyear* if `1' & lag_ipw_weight<`2' [aw=lag_ipw_weight], vce(cluster school_id)
		replace ldv_result_seq = _b[rseasonwins] in `counter'
		replace ldv_pval_seq =  2*ttail(e(N_clust),abs(_b[rseasonwins]/_se[rseasonwins])) in `counter'
		replace ldv_N_seq = e(N) in `counter'
		local counter = `counter' + 1
		replace ldv_result_seq = _se[rseasonwins] in `counter'
		local counter = `counter' + 1
	}
	if `3'==0 {
		capture: drop ldv_pval_rf
		rename ldv_pval ldv_pval_rf
	}
end	

*********************************************

// Define program to run placebo p-score matching and sequential treatment effect results
// Takes args: bcs, trim_value, iv_flag
capture: program drop placebo_results
program define placebo_results
	// Note: Group sizes will not be perfectly balanced because there is clustering in p-scores (spreads are in 0.5 unit increments)
	forvalues w = 1(1)12 {
	capture: drop lead2_pscore_wk`w'_group
	foreach varname of varlist lead2_pscore_wk`w' {
		sum lead2_pscore_wk`w' if lead2_win_wk`w'==1 & `1'
		local min_treated = max(r(min),0.05)
		sum lead2_pscore_wk`w' if lead2_win_wk`w'==0 & `1'
		local max_treated = min(r(max), 0.95)
		centile `varname' if `1' & `varname'>=`min_treated' & `varname'<=`max_treated', centile(10(8)90)
		gen `varname'_group = .
		forvalues i = 2(1)11 {
			local iminus1 = `i' - 1
			local bottom_centile = r(c_`iminus1') 
			local top_centile = r(c_`i') 
			replace `varname'_group = `i' if `varname'>=`bottom_centile' & `varname'<`top_centile' & `1'
		}	
		replace `varname'_group = 1 if `varname'<r(c_1) & `1' & `varname'>=`min_treated'
		replace `varname'_group = 12 if `varname'>=r(c_11) & `varname'!=. & `1' & `varname'<=`max_treated'
	}
	}

	capture: drop variable_name 
	capture: drop ols_result
	capture: drop ols_pval
	capture: drop ols_N
	capture: drop ldv_result
	capture: drop ldv_pval
	capture: drop ldv_N

	gen variable_name = ""
	gen ols_result = .
	gen ols_pval = .
	gen ols_N = .
	gen ldv_result = .
	gen ldv_pval = .
	gen ldv_N = .

	// Run first stage for matching regressions

	capture: drop matching_dep_var
	gen str40 matching_dep_var = ""

	forvalues w = 1(1)12 {
	xi i.lead2_pscore_wk`w'_group*lead2_win_wk`w' i.lead2_pscore_wk`w'_group*lead2_pscore_wk`w', noomit
	reg lead2_exp_wins_wk`w' _Ilea* win_wk`w' lag_win_wk`w' if `1', vce(cluster school_id) noconstant
	tab lead2_pscore_wk`w'_group if e(sample), matcell(freqmat) matrow(valmat)
	local totalestobs = r(N)
	svmat valmat, names(val)
	svmat freqmat, names(freq)	
	forvalues j = 1(1)12 {
		quietly sum freq1 if val1==`j' in 1/12
		if r(N)==1 {
			if r(mean)>3 {
				local freq`j' =	r(mean)			
			}
			else {
				local freq`j' = 0
			}
		}
		else {
			local freq`j' = 0
		}
	}
	drop val1 freq1
	capture: drop matching_fs_coeff_lhs_`w'
	gen matching_fs_coeff_lhs_`w' = .
	gen group = _n in 1/12
	gen groupsq = group^2 in 1/12
	forvalues j = 1(1)12 {
		replace matching_fs_coeff_lhs_`w' = _b[_IleaXlead_`j'] in `j'
	}
	reg matching_fs_coeff_lhs_`w' group groupsq
	predict matching_fs_coeff_`w'_pred in 1/12
	predict matching_fs_coeff_`w'_pred_se in 1/12, stdp
	drop group groupsq
	forvalues j = 1(1)12 {
		capture: drop matching_fs_coeff_`w'_`j' matching_fs_se_`w'_`j'
		gen matching_fs_coeff_`w'_`j' = matching_fs_coeff_`w'_pred[`j'] in 1/30
		gen matching_fs_se_`w'_`j' = matching_fs_coeff_`w'_pred_se[`j'] in 1/30
	}
	drop matching_fs_coeff_`w'_pred matching_fs_coeff_`w'_pred_se
	if `w'==12 {
		forvalues j = 1(1)12 {	
			replace matching_fs_coeff_`w'_`j' = 0 in 1/30
			replace matching_fs_se_`w'_`j' = 0 in 1/30
		}
	}
	}

	// Run reduced form for matching regressions

	forvalues w = 1(1)12 {
	capture: drop matching_coeff_`w' matching_se_`w' matching_rf_coeff_`w' matching_rf_se_`w' matching_N_`w'
	local i = 1
	gen float matching_coeff_`w' = .
	gen float matching_se_`w' = .
	gen float matching_N_`w' = .
	gen float matching_rf_coeff_`w' = .
	gen float matching_rf_se_`w' = .
	xi i.lead2_pscore_wk`w'_group*lead2_win_wk`w' i.lead2_pscore_wk`w'_group*lead2_pscore_wk`w', noomit
	foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
		replace matching_dep_var = "`varname'" in `i'
		reg `varname' _Ilea* if `1', vce(cluster school_id) noconstant
		tab lead2_pscore_wk`w'_group if e(sample), matcell(freqmat) matrow(valmat)
		local totalestobs = r(N)
		svmat valmat, names(val)
		svmat freqmat, names(freq)	
		forvalues j = 1(1)12 {
			quietly sum freq1 if val1==`j' in 1/12
			if r(N)==1 {
				if r(mean)>3 {
					local freq`j' =	r(mean)			
				}
				else {
					local freq`j' = 0
				}
			}
			else {
				local freq`j' = 0
			}
		}
		drop val1 freq1
		// Enforce overlap: drop any cells with less than 2 wins or losses
		forvalues j = 1(1)12 {
			sum lead2_win_wk`w' if e(sample) & lead2_pscore_wk`w'_group==`j' & lead2_win_wk`w'==1
			local wincount = r(N)
			sum lead2_win_wk`w' if e(sample) & lead2_pscore_wk`w'_group==`j' & lead2_win_wk`w'==0
			local losscount = r(N)
			if min(`wincount',`losscount')<2 {
				local weight`j' = 0
			}
			else {
				local weight`j' = 1
			}
		}
		local totalestobs = (`freq1'*`weight1' + `freq2'*`weight2' + `freq3'*`weight3' + `freq4'*`weight4' + `freq5'*`weight5' + `freq6'*`weight6' + `freq7'*`weight7' + `freq8'*`weight8' + `freq9'*`weight9' + `freq10'*`weight10' + `freq11'*`weight11' + `freq12'*`weight12')
		lincom (_b[_IleaXlead_1]*`freq1'*`weight1' + _b[_IleaXlead_2]*`freq2'*`weight2' + _b[_IleaXlead_3]*`freq3'*`weight3' + _b[_IleaXlead_4]*`freq4'*`weight4' + _b[_IleaXlead_5]*`freq5'*`weight5' + _b[_IleaXlead_6]*`freq6'*`weight6' + _b[_IleaXlead_7]*`freq7'*`weight7' + _b[_IleaXlead_8]*`freq8'*`weight8' + _b[_IleaXlead_9]*`freq9'*`weight9' + _b[_IleaXlead_10]*`freq10'*`weight10' + _b[_IleaXlead_11]*`freq11'*`weight11' + _b[_IleaXlead_12]*`freq12'*`weight12')/`totalestobs'
		local C = r(estimate)
		local SE = r(se)
		replace matching_rf_coeff_`w' = `C' in `i'
		replace matching_rf_se_`w' = `SE' in `i'
		replace matching_N_`w' = e(N) in `i'		
		forvalues j = 1(1)12 {
			local fs`j' = 1 + matching_fs_coeff_`w'_`j'[`i']
			local fs_se`j' = matching_fs_se_`w'_`j'[`i']
		}
		lincom (_b[_IleaXlead_1]*`freq1'*`weight1'/`fs1' + _b[_IleaXlead_2]*`freq2'*`weight2'/`fs2' + _b[_IleaXlead_3]*`freq3'*`weight3'/`fs3' + _b[_IleaXlead_4]*`freq4'*`weight4'/`fs4' + _b[_IleaXlead_5]*`freq5'*`weight5'/`fs5' + _b[_IleaXlead_6]*`freq6'*`weight6'/`fs6' + _b[_IleaXlead_7]*`freq7'*`weight7'/`fs7' + _b[_IleaXlead_8]*`freq8'*`weight8'/`fs8' + _b[_IleaXlead_9]*`freq9'*`weight9'/`fs9' + _b[_IleaXlead_10]*`freq10'*`weight10'/`fs10' + _b[_IleaXlead_11]*`freq11'*`weight11'/`fs11' + _b[_IleaXlead_12]*`freq12'*`weight12'/`fs12')/`totalestobs'
		local C = r(estimate)
		local SE = (((_se[_IleaXlead_1]/(`fs1'))^2 + (`fs_se1'*_b[_IleaXlead_1]/(`fs1')^2)^2)*(`freq1'*`weight1'/`totalestobs')^2 +  ((_se[_IleaXlead_2]/(`fs2'))^2 + (`fs_se2'*_b[_IleaXlead_2]/(`fs2')^2)^2)*(`freq2'*`weight2'/`totalestobs')^2 +  ((_se[_IleaXlead_3]/(`fs3'))^2 + (`fs_se3'*_b[_IleaXlead_3]/(`fs3')^2)^2)*(`freq3'*`weight3'/`totalestobs')^2 +  ((_se[_IleaXlead_4]/(`fs4'))^2 + (`fs_se4'*_b[_IleaXlead_4]/(`fs4')^2)^2)*(`freq4'*`weight4'/`totalestobs')^2 +  ((_se[_IleaXlead_5]/(`fs5'))^2 + (`fs_se5'*_b[_IleaXlead_5]/(`fs5')^2)^2)*(`freq5'*`weight5'/`totalestobs')^2 +  ((_se[_IleaXlead_6]/(`fs6'))^2 + (`fs_se6'*_b[_IleaXlead_6]/(`fs6')^2)^2)*(`freq6'*`weight6'/`totalestobs')^2 +  ((_se[_IleaXlead_7]/(`fs7'))^2 + (`fs_se7'*_b[_IleaXlead_7]/(`fs7')^2)^2)*(`freq7'*`weight7'/`totalestobs')^2 +  ((_se[_IleaXlead_8]/(`fs8'))^2 + (`fs_se8'*_b[_IleaXlead_8]/(`fs8')^2)^2)*(`freq8'*`weight8'/`totalestobs')^2 +  ((_se[_IleaXlead_9]/(`fs9'))^2 + (`fs_se9'*_b[_IleaXlead_9]/(`fs9')^2)^2)*(`freq9'*`weight9'/`totalestobs')^2 +  ((_se[_IleaXlead_10]/(`fs10'))^2 + (`fs_se10'*_b[_IleaXlead_10]/(`fs10')^2)^2)*(`freq10'*`weight10'/`totalestobs')^2 +  ((_se[_IleaXlead_11]/(`fs11'))^2 + (`fs_se11'*_b[_IleaXlead_11]/(`fs11')^2)^2)*(`freq11'*`weight11'/`totalestobs')^2 +  ((_se[_IleaXlead_12]/(`fs12'))^2 + (`fs_se12'*_b[_IleaXlead_12]/(`fs12')^2)^2)*(`freq12'*`weight12'/`totalestobs')^2)^0.5	
		replace matching_coeff_`w' = `C' in `i'
		replace matching_se_`w' = `SE' in `i'
		local i = `i' + 1
	}
	}

	capture: drop total_N matching_coeff matching_se matching_rf_coeff matching_rf_se matching_N
	gen total_N = matching_N_1 + matching_N_2 + matching_N_3 + matching_N_4 + matching_N_5 + matching_N_6 + matching_N_7 + matching_N_8 + matching_N_9 + matching_N_10 + matching_N_11 + matching_N_12
	gen matching_rf_coeff = matching_rf_coeff_1*(matching_N_1/total_N) + matching_rf_coeff_2*(matching_N_2/total_N) + matching_rf_coeff_3*(matching_N_3/total_N) + matching_rf_coeff_4*(matching_N_4/total_N) + matching_rf_coeff_5*(matching_N_5/total_N) + matching_rf_coeff_6*(matching_N_6/total_N) + matching_rf_coeff_7*(matching_N_7/total_N) + matching_rf_coeff_8*(matching_N_8/total_N) + matching_rf_coeff_9*(matching_N_9/total_N) + matching_rf_coeff_10*(matching_N_10/total_N) + matching_rf_coeff_11*(matching_N_11/total_N) + matching_rf_coeff_12*(matching_N_12/total_N)
	gen matching_rf_se = ((matching_rf_se_1^2)*(matching_N_1/total_N)^2 + (matching_rf_se_2^2)*(matching_N_2/total_N)^2 + (matching_rf_se_3^2)*(matching_N_3/total_N)^2 + (matching_rf_se_4^2)*(matching_N_4/total_N)^2 + (matching_rf_se_5^2)*(matching_N_5/total_N)^2 + (matching_rf_se_6^2)*(matching_N_6/total_N)^2 + (matching_rf_se_7^2)*(matching_N_7/total_N)^2 + (matching_rf_se_8^2)*(matching_N_8/total_N)^2 + (matching_rf_se_9^2)*(matching_N_9/total_N)^2 + (matching_rf_se_10^2)*(matching_N_10/total_N)^2 + (matching_rf_se_11^2)*(matching_N_11/total_N)^2 + (matching_rf_se_12^2)*(matching_N_12/total_N)^2)^0.5
	gen matching_coeff = matching_coeff_1*(matching_N_1/total_N) + matching_coeff_2*(matching_N_2/total_N) + matching_coeff_3*(matching_N_3/total_N) + matching_coeff_4*(matching_N_4/total_N) + matching_coeff_5*(matching_N_5/total_N) + matching_coeff_6*(matching_N_6/total_N) + matching_coeff_7*(matching_N_7/total_N) + matching_coeff_8*(matching_N_8/total_N) + matching_coeff_9*(matching_N_9/total_N) + matching_coeff_10*(matching_N_10/total_N) + matching_coeff_11*(matching_N_11/total_N) + matching_coeff_12*(matching_N_12/total_N)
	gen matching_se = ((matching_se_1^2)*(matching_N_1/total_N)^2 + (matching_se_2^2)*(matching_N_2/total_N)^2 + (matching_se_3^2)*(matching_N_3/total_N)^2 + (matching_se_4^2)*(matching_N_4/total_N)^2 + (matching_se_5^2)*(matching_N_5/total_N)^2 + (matching_se_6^2)*(matching_N_6/total_N)^2 + (matching_se_7^2)*(matching_N_7/total_N)^2 + (matching_se_8^2)*(matching_N_8/total_N)^2 + (matching_se_9^2)*(matching_N_9/total_N)^2 + (matching_se_10^2)*(matching_N_10/total_N)^2 + (matching_se_11^2)*(matching_N_11/total_N)^2 + (matching_se_12^2)*(matching_N_12/total_N)^2)^0.5
	gen matching_N = max(matching_N_1, matching_N_2, matching_N_3, matching_N_4, matching_N_5, matching_N_6, matching_N_7, matching_N_8, matching_N_9, matching_N_10, matching_N_11, matching_N_12)

	local obscounter = 1
	local varcounter = 1
	while `obscounter'<=20 {
	local secounter = `obscounter' + 1
	replace variable_name = matching_dep_var[`varcounter'] in `obscounter'
	replace ols_N = matching_N[`varcounter'] in `obscounter'
	if `3'==0 {
		replace ols_result = matching_rf_coeff[`varcounter'] in `obscounter'
		replace ols_result = matching_rf_se[`varcounter'] in `secounter'
		replace ols_pval = 2*ttail(105,abs(matching_rf_coeff[`varcounter']/matching_rf_se[`varcounter'])) in `obscounter'
	}
	else {
		replace ols_result = matching_coeff[`varcounter'] in `obscounter'
		replace ols_result = matching_se[`varcounter'] in `secounter'
		replace ols_pval = 2*ttail(105,abs(matching_coeff[`varcounter']/matching_se[`varcounter'])) in `obscounter'
	}
	local varcounter = `varcounter' + 1
	local obscounter = `obscounter' + 2
	}

	// Create residualized dependent variables for matching regressions

	xi i.year i.school_id

	foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
	capture: drop r`varname'
	gen r`varname'_temp = `varname' - lag2_`varname'
	reg r`varname'_temp _Iyear* if `1'
	predict r`varname', resid
	drop r`varname'_temp
	}

	// Run reduced form for residualized matching regressions

	capture: drop matching_resid_dep_var
	gen str40 matching_resid_dep_var = ""

	forvalues w = 1(1)12 {
	capture: drop matching_resid_coeff_`w' matching_resid_se_`w' matching_resid_N_`w' matching_rf_resid_coeff_`w' matching_rf_resid_se_`w'
	local i = 1
	gen float matching_resid_coeff_`w' = .
	gen float matching_resid_se_`w' = .
	gen float matching_resid_N_`w' = .
	gen float matching_rf_resid_coeff_`w' = .
	gen float matching_rf_resid_se_`w' = .
	xi i.lead2_pscore_wk`w'_group*lead2_win_wk`w' i.lead2_pscore_wk`w'_group*lead2_pscore_wk`w', noomit
	foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
		replace matching_resid_dep_var = "`varname'" in `i'
		reg r`varname' _Ilea* win_wk`w' lag_win_wk`w' if `1', vce(cluster school_id) noconstant
		tab lead2_pscore_wk`w'_group if e(sample), matcell(freqmat) matrow(valmat)
		local totalestobs = r(N)
		svmat valmat, names(val)
		svmat freqmat, names(freq)	
		forvalues j = 1(1)12 {
			quietly sum freq1 if val1==`j' in 1/12
			if r(N)==1 {
				if r(mean)>3 {
					local freq`j' =	r(mean)			
				}
				else {
					local freq`j' = 0
				}
			}
			else {
				local freq`j' = 0
			}
		}
		drop val1 freq1
		// Enforce overlap: drop any cells with less than 2 wins or losses
		forvalues j = 1(1)12 {
			sum lead2_win_wk`w' if e(sample) & lead2_pscore_wk`w'_group==`j' & lead2_win_wk`w'==1
			local wincount = r(N)
			sum lead2_win_wk`w' if e(sample) & lead2_pscore_wk`w'_group==`j' & lead2_win_wk`w'==0
			local losscount = r(N)
			if min(`wincount',`losscount')<2 {
				local weight`j' = 0
			}
			else {
				local weight`j' = 1
			}
		}
		local totalestobs = (`freq1'*`weight1' + `freq2'*`weight2' + `freq3'*`weight3' + `freq4'*`weight4' + `freq5'*`weight5' + `freq6'*`weight6' + `freq7'*`weight7' + `freq8'*`weight8' + `freq9'*`weight9' + `freq10'*`weight10' + `freq11'*`weight11' + `freq12'*`weight12')
		lincom (_b[_IleaXlead_1]*`freq1'*`weight1' + _b[_IleaXlead_2]*`freq2'*`weight2' + _b[_IleaXlead_3]*`freq3'*`weight3' + _b[_IleaXlead_4]*`freq4'*`weight4' + _b[_IleaXlead_5]*`freq5'*`weight5' + _b[_IleaXlead_6]*`freq6'*`weight6' + _b[_IleaXlead_7]*`freq7'*`weight7' + _b[_IleaXlead_8]*`freq8'*`weight8' + _b[_IleaXlead_9]*`freq9'*`weight9' + _b[_IleaXlead_10]*`freq10'*`weight10' + _b[_IleaXlead_11]*`freq11'*`weight11' + _b[_IleaXlead_12]*`freq12'*`weight12')/`totalestobs'
		local C = r(estimate)
		local SE = r(se)
		replace matching_rf_resid_coeff_`w' = `C' in `i'
		replace matching_rf_resid_se_`w' = `SE' in `i'
		replace matching_resid_N_`w' = e(N) in `i'		
		forvalues j = 1(1)12 {
			local fs`j' = 1 + matching_fs_coeff_`w'_`j'[`i']
			local fs_se`j' = matching_fs_se_`w'_`j'[`i']
		}
		lincom (_b[_IleaXlead_1]*`freq1'*`weight1'/`fs1' + _b[_IleaXlead_2]*`freq2'*`weight2'/`fs2' + _b[_IleaXlead_3]*`freq3'*`weight3'/`fs3' + _b[_IleaXlead_4]*`freq4'*`weight4'/`fs4' + _b[_IleaXlead_5]*`freq5'*`weight5'/`fs5' + _b[_IleaXlead_6]*`freq6'*`weight6'/`fs6' + _b[_IleaXlead_7]*`freq7'*`weight7'/`fs7' + _b[_IleaXlead_8]*`freq8'*`weight8'/`fs8' + _b[_IleaXlead_9]*`freq9'*`weight9'/`fs9' + _b[_IleaXlead_10]*`freq10'*`weight10'/`fs10' + _b[_IleaXlead_11]*`freq11'*`weight11'/`fs11' + _b[_IleaXlead_12]*`freq12'*`weight12'/`fs12')/`totalestobs'
		local C = r(estimate)
		local SE = (((_se[_IleaXlead_1]/(`fs1'))^2 + (`fs_se1'*_b[_IleaXlead_1]/(`fs1')^2)^2)*(`freq1'*`weight1'/`totalestobs')^2 +  ((_se[_IleaXlead_2]/(`fs2'))^2 + (`fs_se2'*_b[_IleaXlead_2]/(`fs2')^2)^2)*(`freq2'*`weight2'/`totalestobs')^2 +  ((_se[_IleaXlead_3]/(`fs3'))^2 + (`fs_se3'*_b[_IleaXlead_3]/(`fs3')^2)^2)*(`freq3'*`weight3'/`totalestobs')^2 +  ((_se[_IleaXlead_4]/(`fs4'))^2 + (`fs_se4'*_b[_IleaXlead_4]/(`fs4')^2)^2)*(`freq4'*`weight4'/`totalestobs')^2 +  ((_se[_IleaXlead_5]/(`fs5'))^2 + (`fs_se5'*_b[_IleaXlead_5]/(`fs5')^2)^2)*(`freq5'*`weight5'/`totalestobs')^2 +  ((_se[_IleaXlead_6]/(`fs6'))^2 + (`fs_se6'*_b[_IleaXlead_6]/(`fs6')^2)^2)*(`freq6'*`weight6'/`totalestobs')^2 +  ((_se[_IleaXlead_7]/(`fs7'))^2 + (`fs_se7'*_b[_IleaXlead_7]/(`fs7')^2)^2)*(`freq7'*`weight7'/`totalestobs')^2 +  ((_se[_IleaXlead_8]/(`fs8'))^2 + (`fs_se8'*_b[_IleaXlead_8]/(`fs8')^2)^2)*(`freq8'*`weight8'/`totalestobs')^2 +  ((_se[_IleaXlead_9]/(`fs9'))^2 + (`fs_se9'*_b[_IleaXlead_9]/(`fs9')^2)^2)*(`freq9'*`weight9'/`totalestobs')^2 +  ((_se[_IleaXlead_10]/(`fs10'))^2 + (`fs_se10'*_b[_IleaXlead_10]/(`fs10')^2)^2)*(`freq10'*`weight10'/`totalestobs')^2 +  ((_se[_IleaXlead_11]/(`fs11'))^2 + (`fs_se11'*_b[_IleaXlead_11]/(`fs11')^2)^2)*(`freq11'*`weight11'/`totalestobs')^2 +  ((_se[_IleaXlead_12]/(`fs12'))^2 + (`fs_se12'*_b[_IleaXlead_12]/(`fs12')^2)^2)*(`freq12'*`weight12'/`totalestobs')^2)^0.5	
		replace matching_resid_coeff_`w' = `C' in `i'
		replace matching_resid_se_`w' = `SE' in `i'
		local i = `i' + 1
	}
	}

	capture: drop total_resid_N matching_resid_coeff matching_resid_se matching_resid_N matching_rf_resid_coeff matching_rf_resid_se
	gen total_resid_N = matching_resid_N_1 + matching_resid_N_2 + matching_resid_N_3 + matching_resid_N_4 + matching_resid_N_5 + matching_resid_N_6 + matching_resid_N_7 + matching_resid_N_8 + matching_resid_N_9 + matching_resid_N_10 + matching_resid_N_11 + matching_resid_N_12
	gen matching_rf_resid_coeff = matching_rf_resid_coeff_1*(matching_resid_N_1/total_resid_N) + matching_rf_resid_coeff_2*(matching_resid_N_2/total_resid_N) + matching_rf_resid_coeff_3*(matching_resid_N_3/total_resid_N) + matching_rf_resid_coeff_4*(matching_resid_N_4/total_resid_N) + matching_rf_resid_coeff_5*(matching_resid_N_5/total_resid_N) + matching_rf_resid_coeff_6*(matching_resid_N_6/total_resid_N) + matching_rf_resid_coeff_7*(matching_resid_N_7/total_resid_N) + matching_rf_resid_coeff_8*(matching_resid_N_8/total_resid_N) + matching_rf_resid_coeff_9*(matching_resid_N_9/total_resid_N) + matching_rf_resid_coeff_10*(matching_resid_N_10/total_resid_N) + matching_rf_resid_coeff_11*(matching_resid_N_11/total_resid_N) + matching_rf_resid_coeff_12*(matching_resid_N_12/total_resid_N)
	gen matching_rf_resid_se = ((matching_rf_resid_se_1^2)*(matching_resid_N_1/total_resid_N)^2 + (matching_rf_resid_se_2^2)*(matching_resid_N_2/total_resid_N)^2 + (matching_rf_resid_se_3^2)*(matching_resid_N_3/total_resid_N)^2 + (matching_rf_resid_se_4^2)*(matching_resid_N_4/total_resid_N)^2 + (matching_rf_resid_se_5^2)*(matching_resid_N_5/total_resid_N)^2 + (matching_rf_resid_se_6^2)*(matching_resid_N_6/total_resid_N)^2 + (matching_rf_resid_se_7^2)*(matching_resid_N_7/total_resid_N)^2 + (matching_rf_resid_se_8^2)*(matching_resid_N_8/total_resid_N)^2 + (matching_rf_resid_se_9^2)*(matching_resid_N_9/total_resid_N)^2 + (matching_rf_resid_se_10^2)*(matching_resid_N_10/total_resid_N)^2 + (matching_rf_resid_se_11^2)*(matching_resid_N_11/total_resid_N)^2 + (matching_rf_resid_se_12^2)*(matching_resid_N_12/total_resid_N)^2)^0.5
	gen matching_resid_coeff = matching_resid_coeff_1*(matching_resid_N_1/total_resid_N) + matching_resid_coeff_2*(matching_resid_N_2/total_resid_N) + matching_resid_coeff_3*(matching_resid_N_3/total_resid_N) + matching_resid_coeff_4*(matching_resid_N_4/total_resid_N) + matching_resid_coeff_5*(matching_resid_N_5/total_resid_N) + matching_resid_coeff_6*(matching_resid_N_6/total_resid_N) + matching_resid_coeff_7*(matching_resid_N_7/total_resid_N) + matching_resid_coeff_8*(matching_resid_N_8/total_resid_N) + matching_resid_coeff_9*(matching_resid_N_9/total_resid_N) + matching_resid_coeff_10*(matching_resid_N_10/total_resid_N) + matching_resid_coeff_11*(matching_resid_N_11/total_resid_N) + matching_resid_coeff_12*(matching_resid_N_12/total_resid_N)
	gen matching_resid_se = ((matching_resid_se_1^2)*(matching_resid_N_1/total_resid_N)^2 + (matching_resid_se_2^2)*(matching_resid_N_2/total_resid_N)^2 + (matching_resid_se_3^2)*(matching_resid_N_3/total_resid_N)^2 + (matching_resid_se_4^2)*(matching_resid_N_4/total_resid_N)^2 + (matching_resid_se_5^2)*(matching_resid_N_5/total_resid_N)^2 + (matching_resid_se_6^2)*(matching_resid_N_6/total_resid_N)^2 + (matching_resid_se_7^2)*(matching_resid_N_7/total_resid_N)^2 + (matching_resid_se_8^2)*(matching_resid_N_8/total_resid_N)^2 + (matching_resid_se_9^2)*(matching_resid_N_9/total_resid_N)^2 + (matching_resid_se_10^2)*(matching_resid_N_10/total_resid_N)^2 + (matching_resid_se_11^2)*(matching_resid_N_11/total_resid_N)^2 + (matching_resid_se_12^2)*(matching_resid_N_12/total_resid_N)^2)^0.5
	gen matching_resid_N = max(matching_resid_N_1, matching_resid_N_2, matching_resid_N_3, matching_resid_N_4, matching_resid_N_5, matching_resid_N_6, matching_resid_N_7, matching_resid_N_8, matching_resid_N_9, matching_resid_N_10, matching_resid_N_11, matching_resid_N_12)

	local obscounter = 1
	local varcounter = 1
	while `obscounter'<=20 {
	local secounter = `obscounter' + 1
	replace ldv_N = matching_resid_N[`varcounter'] in `obscounter'
	if `3'==0 {
		replace ldv_result = matching_rf_resid_coeff[`varcounter'] in `obscounter'
		replace ldv_result = matching_rf_resid_se[`varcounter'] in `secounter'
		replace ldv_pval = 2*ttail(105,abs(matching_rf_resid_coeff[`varcounter']/matching_rf_resid_se[`varcounter'])) in `obscounter'
	}
	else {
		replace ldv_result = matching_resid_coeff[`varcounter'] in `obscounter'
		replace ldv_result = matching_resid_se[`varcounter'] in `secounter'
		replace ldv_pval = 2*ttail(105,abs(matching_resid_coeff[`varcounter']/matching_resid_se[`varcounter'])) in `obscounter'
	}
	local varcounter = `varcounter' + 1
	local obscounter = `obscounter' + 2
	}
	drop _I*
	xi i.year

	capture: drop ols_result_seq
	capture: drop ols_result_wgt_seq
	capture: drop ols_pval_seq
	capture: drop ols_N_seq
	capture: drop ldv_result_seq
	capture: drop ldv_result_wgt_seq
	capture: drop ldv_pval_seq
	capture: drop ldv_N_seq
	capture: drop ldv_se_wgt_seq

	gen ols_result_seq = .
	gen ols_result_wgt_seq = .
	gen ols_pval_seq = .
	gen ols_N_seq = .
	gen ldv_result_seq = .
	gen ldv_result_wgt_seq = .
	gen ldv_pval_seq = .
	gen ldv_N_seq = .
	gen ldv_se_wgt_seq = .
	local counter = 1

	capture: drop rseasonwins
	gen rseasonwins = lead2_seasonwins - seasonwins

	foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
	capture: drop r`varname'
	gen r`varname' = `varname' - lag2_`varname'
	reg r`varname' rseasonwins seasonwins lag_seasonwins lead2_seasongames seasongames lag_seasongames _Iyear* if `1' & lead2_ipw_weight<`2' [aw=lead2_ipw_weight], vce(cluster school_id)
	replace ldv_result_seq = _b[rseasonwins] in `counter'
	replace ldv_pval_seq =  2*ttail(e(N_clust),abs(_b[rseasonwins]/_se[rseasonwins])) in `counter'
	replace ldv_N_seq = e(N) in `counter'
	local counter = `counter' + 1
	replace ldv_result_seq = _se[rseasonwins] in `counter'
	local counter = `counter' + 1
	}
	if `3'==0 {
		capture: drop ldv_pval_rf
		rename ldv_pval ldv_pval_rf
	}
end

*********************************************

// Define program to run week 5+ p-score matching and sequential treatment effect results
// Takes args: bcs, trim_value, iv_flag
capture: program drop main_results_5
program define main_results_5
	// Note: Group sizes will not be perfectly balanced because there is clustering in p-scores (spreads are in 0.5 unit increments)
	forvalues w = 1(1)12 {
		capture: drop lag_pscore_wk`w'_group
		foreach varname of varlist lag_pscore_wk`w' {
			sum lag_pscore_wk`w' if lag_win_wk`w'==1 & `1'
			local min_treated = max(r(min),0.05)
			sum lag_pscore_wk`w' if lag_win_wk`w'==0 & `1'
			local max_treated = min(r(max), 0.95)
			centile `varname' if `1' & `varname'>=`min_treated' & `varname'<=`max_treated', centile(10(8)90)
			gen `varname'_group = .
			forvalues i = 2(1)11 {
				local iminus1 = `i' - 1
				local bottom_centile = r(c_`iminus1') 
				local top_centile = r(c_`i') 
				replace `varname'_group = `i' if `varname'>=`bottom_centile' & `varname'<`top_centile' & `1'
			}	
			replace `varname'_group = 1 if `varname'<r(c_1) & `1' & `varname'>=`min_treated'
			replace `varname'_group = 12 if `varname'>=r(c_11) & `varname'!=. & `1' & `varname'<=`max_treated'
		}
	}

	capture: drop variable_name 
	capture: drop ols_result
	capture: drop ols_pval
	capture: drop ols_N
	capture: drop ldv_result
	capture: drop ldv_pval
	capture: drop ldv_N

	gen variable_name = ""
	gen ols_result = .
	gen ols_pval = .
	gen ols_N = .
	gen ldv_result = .
	gen ldv_pval = .
	gen ldv_N = .

	// Run first stage for matching regressions

	capture: drop matching_dep_var
	gen str40 matching_dep_var = ""

	forvalues w = 1(1)12 {
		xi i.lag_pscore_wk`w'_group*lag_win_wk`w' i.lag_pscore_wk`w'_group*lag_pscore_wk`w', noomit
		reg lag_exp_wins_wk`w' _Ilag* if `1', vce(cluster school_id) noconstant
		tab lag_pscore_wk`w'_group if e(sample), matcell(freqmat) matrow(valmat)
		local totalestobs = r(N)
		svmat valmat, names(val)
		svmat freqmat, names(freq)	
		forvalues j = 1(1)12 {
			quietly sum freq1 if val1==`j' in 1/12
			if r(N)==1 {
				if r(mean)>3 {
					local freq`j' =	r(mean)			
				}
				else {
					local freq`j' = 0
				}
			}
			else {
				local freq`j' = 0
			}
		}
		drop val1 freq1
		capture: drop matching_fs_coeff_lhs_`w'
		gen matching_fs_coeff_lhs_`w' = .
		gen group = _n in 1/12
		gen groupsq = group^2 in 1/12
		forvalues j = 1(1)12 {
			replace matching_fs_coeff_lhs_`w' = _b[_IlagXlag__`j'] in `j'
		}
		reg matching_fs_coeff_lhs_`w' group groupsq
		predict matching_fs_coeff_`w'_pred in 1/12
		predict matching_fs_coeff_`w'_pred_se in 1/12, stdp
		drop group groupsq
		forvalues j = 1(1)12 {
			capture: drop matching_fs_coeff_`w'_`j' matching_fs_se_`w'_`j'
			gen matching_fs_coeff_`w'_`j' = matching_fs_coeff_`w'_pred[`j'] in 1/30
			gen matching_fs_se_`w'_`j' = matching_fs_coeff_`w'_pred_se[`j'] in 1/30
		}
		drop matching_fs_coeff_`w'_pred matching_fs_coeff_`w'_pred_se
		if `w'==12 {
			forvalues j = 1(1)12 {	
				replace matching_fs_coeff_`w'_`j' = 0 in 1/30
				replace matching_fs_se_`w'_`j' = 0 in 1/30
			}
		}
	}

	// Run reduced form for matching regressions

	forvalues w = 1(1)12 {
		capture: drop matching_coeff_`w' matching_se_`w' matching_rf_coeff_`w' matching_rf_se_`w' matching_N_`w'
		local i = 1
		gen float matching_coeff_`w' = .
		gen float matching_se_`w' = .
		gen float matching_N_`w' = .
		gen float matching_rf_coeff_`w' = .
		gen float matching_rf_se_`w' = .
		xi i.lag_pscore_wk`w'_group*lag_win_wk`w' i.lag_pscore_wk`w'_group*lag_pscore_wk`w', noomit
		foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
			replace matching_dep_var = "`varname'" in `i'
			reg `varname' _Ilag* if `1', vce(cluster school_id) noconstant
			tab lag_pscore_wk`w'_group if e(sample), matcell(freqmat) matrow(valmat)
			local totalestobs = r(N)
			svmat valmat, names(val)
			svmat freqmat, names(freq)	
			forvalues j = 1(1)12 {
				quietly sum freq1 if val1==`j' in 1/12
				if r(N)==1 {
					if r(mean)>3 {
						local freq`j' =	r(mean)			
					}
					else {
						local freq`j' = 0
					}
				}
				else {
					local freq`j' = 0
				}
			}
			drop val1 freq1
			// Enforce overlap: drop any cells with less than 2 wins or losses
			forvalues j = 1(1)12 {
				sum lag_win_wk`w' if e(sample) & lag_pscore_wk`w'_group==`j' & lag_win_wk`w'==1
				local wincount = r(N)
				sum lag_win_wk`w' if e(sample) & lag_pscore_wk`w'_group==`j' & lag_win_wk`w'==0
				local losscount = r(N)
				if min(`wincount',`losscount')<2 {
					local weight`j' = 0
				}
				else {
					local weight`j' = 1
				}
			}
			local totalestobs = (`freq1'*`weight1' + `freq2'*`weight2' + `freq3'*`weight3' + `freq4'*`weight4' + `freq5'*`weight5' + `freq6'*`weight6' + `freq7'*`weight7' + `freq8'*`weight8' + `freq9'*`weight9' + `freq10'*`weight10' + `freq11'*`weight11' + `freq12'*`weight12')
			lincom (_b[_IlagXlag__1]*`freq1'*`weight1' + _b[_IlagXlag__2]*`freq2'*`weight2' + _b[_IlagXlag__3]*`freq3'*`weight3' + _b[_IlagXlag__4]*`freq4'*`weight4' + _b[_IlagXlag__5]*`freq5'*`weight5' + _b[_IlagXlag__6]*`freq6'*`weight6' + _b[_IlagXlag__7]*`freq7'*`weight7' + _b[_IlagXlag__8]*`freq8'*`weight8' + _b[_IlagXlag__9]*`freq9'*`weight9' + _b[_IlagXlag__10]*`freq10'*`weight10' + _b[_IlagXlag__11]*`freq11'*`weight11' + _b[_IlagXlag__12]*`freq12'*`weight12')/`totalestobs'
			local C = r(estimate)
			local SE = r(se)
			replace matching_rf_coeff_`w' = `C' in `i'
			replace matching_rf_se_`w' = `SE' in `i'
			replace matching_N_`w' = e(N) in `i'		
			forvalues j = 1(1)12 {
				local fs`j' = 1 + matching_fs_coeff_`w'_`j'[`i']
				local fs_se`j' = matching_fs_se_`w'_`j'[`i']
			}
			lincom (_b[_IlagXlag__1]*`freq1'*`weight1'/`fs1' + _b[_IlagXlag__2]*`freq2'*`weight2'/`fs2' + _b[_IlagXlag__3]*`freq3'*`weight3'/`fs3' + _b[_IlagXlag__4]*`freq4'*`weight4'/`fs4' + _b[_IlagXlag__5]*`freq5'*`weight5'/`fs5' + _b[_IlagXlag__6]*`freq6'*`weight6'/`fs6' + _b[_IlagXlag__7]*`freq7'*`weight7'/`fs7' + _b[_IlagXlag__8]*`freq8'*`weight8'/`fs8' + _b[_IlagXlag__9]*`freq9'*`weight9'/`fs9' + _b[_IlagXlag__10]*`freq10'*`weight10'/`fs10' + _b[_IlagXlag__11]*`freq11'*`weight11'/`fs11' + _b[_IlagXlag__12]*`freq12'*`weight12'/`fs12')/`totalestobs'
			local C = r(estimate)
			local SE = (((_se[_IlagXlag__1]/(`fs1'))^2 + (`fs_se1'*_b[_IlagXlag__1]/(`fs1')^2)^2)*(`freq1'*`weight1'/`totalestobs')^2 +  ((_se[_IlagXlag__2]/(`fs2'))^2 + (`fs_se2'*_b[_IlagXlag__2]/(`fs2')^2)^2)*(`freq2'*`weight2'/`totalestobs')^2 +  ((_se[_IlagXlag__3]/(`fs3'))^2 + (`fs_se3'*_b[_IlagXlag__3]/(`fs3')^2)^2)*(`freq3'*`weight3'/`totalestobs')^2 +  ((_se[_IlagXlag__4]/(`fs4'))^2 + (`fs_se4'*_b[_IlagXlag__4]/(`fs4')^2)^2)*(`freq4'*`weight4'/`totalestobs')^2 +  ((_se[_IlagXlag__5]/(`fs5'))^2 + (`fs_se5'*_b[_IlagXlag__5]/(`fs5')^2)^2)*(`freq5'*`weight5'/`totalestobs')^2 +  ((_se[_IlagXlag__6]/(`fs6'))^2 + (`fs_se6'*_b[_IlagXlag__6]/(`fs6')^2)^2)*(`freq6'*`weight6'/`totalestobs')^2 +  ((_se[_IlagXlag__7]/(`fs7'))^2 + (`fs_se7'*_b[_IlagXlag__7]/(`fs7')^2)^2)*(`freq7'*`weight7'/`totalestobs')^2 +  ((_se[_IlagXlag__8]/(`fs8'))^2 + (`fs_se8'*_b[_IlagXlag__8]/(`fs8')^2)^2)*(`freq8'*`weight8'/`totalestobs')^2 +  ((_se[_IlagXlag__9]/(`fs9'))^2 + (`fs_se9'*_b[_IlagXlag__9]/(`fs9')^2)^2)*(`freq9'*`weight9'/`totalestobs')^2 +  ((_se[_IlagXlag__10]/(`fs10'))^2 + (`fs_se10'*_b[_IlagXlag__10]/(`fs10')^2)^2)*(`freq10'*`weight10'/`totalestobs')^2 +  ((_se[_IlagXlag__11]/(`fs11'))^2 + (`fs_se11'*_b[_IlagXlag__11]/(`fs11')^2)^2)*(`freq11'*`weight11'/`totalestobs')^2 +  ((_se[_IlagXlag__12]/(`fs12'))^2 + (`fs_se12'*_b[_IlagXlag__12]/(`fs12')^2)^2)*(`freq12'*`weight12'/`totalestobs')^2)^0.5	
			replace matching_coeff_`w' = `C' in `i'
			replace matching_se_`w' = `SE' in `i'
			local i = `i' + 1
		}
	}

	capture: drop total_N matching_coeff matching_se matching_rf_coeff matching_rf_se matching_N
	gen total_N = matching_N_5 + matching_N_6 + matching_N_7 + matching_N_8 + matching_N_9 + matching_N_10 + matching_N_11 + matching_N_12
	gen matching_rf_coeff = matching_rf_coeff_5*(matching_N_5/total_N) + matching_rf_coeff_6*(matching_N_6/total_N) + matching_rf_coeff_7*(matching_N_7/total_N) + matching_rf_coeff_8*(matching_N_8/total_N) + matching_rf_coeff_9*(matching_N_9/total_N) + matching_rf_coeff_10*(matching_N_10/total_N) + matching_rf_coeff_11*(matching_N_11/total_N) + matching_rf_coeff_12*(matching_N_12/total_N)
	gen matching_rf_se = ((matching_rf_se_5^2)*(matching_N_5/total_N)^2 + (matching_rf_se_6^2)*(matching_N_6/total_N)^2 + (matching_rf_se_7^2)*(matching_N_7/total_N)^2 + (matching_rf_se_8^2)*(matching_N_8/total_N)^2 + (matching_rf_se_9^2)*(matching_N_9/total_N)^2 + (matching_rf_se_10^2)*(matching_N_10/total_N)^2 + (matching_rf_se_11^2)*(matching_N_11/total_N)^2 + (matching_rf_se_12^2)*(matching_N_12/total_N)^2)^0.5
	gen matching_coeff = matching_coeff_5*(matching_N_5/total_N) + matching_coeff_6*(matching_N_6/total_N) + matching_coeff_7*(matching_N_7/total_N) + matching_coeff_8*(matching_N_8/total_N) + matching_coeff_9*(matching_N_9/total_N) + matching_coeff_10*(matching_N_10/total_N) + matching_coeff_11*(matching_N_11/total_N) + matching_coeff_12*(matching_N_12/total_N)
	gen matching_se = ((matching_se_5^2)*(matching_N_5/total_N)^2 + (matching_se_6^2)*(matching_N_6/total_N)^2 + (matching_se_7^2)*(matching_N_7/total_N)^2 + (matching_se_8^2)*(matching_N_8/total_N)^2 + (matching_se_9^2)*(matching_N_9/total_N)^2 + (matching_se_10^2)*(matching_N_10/total_N)^2 + (matching_se_11^2)*(matching_N_11/total_N)^2 + (matching_se_12^2)*(matching_N_12/total_N)^2)^0.5
	gen matching_N = max(matching_N_5, matching_N_6, matching_N_7, matching_N_8, matching_N_9, matching_N_10, matching_N_11, matching_N_12)

	local obscounter = 1
	local varcounter = 1
	while `obscounter'<=20 {
		local secounter = `obscounter' + 1
		replace variable_name = matching_dep_var[`varcounter'] in `obscounter'
		replace ols_N = matching_N[`varcounter'] in `obscounter'
		if `3'==0 {
			replace ols_result = matching_rf_coeff[`varcounter'] in `obscounter'
			replace ols_result = matching_rf_se[`varcounter'] in `secounter'
			replace ols_pval = 2*ttail(105,abs(matching_rf_coeff[`varcounter']/matching_rf_se[`varcounter'])) in `obscounter'
		}
		else {
			replace ols_result = matching_coeff[`varcounter'] in `obscounter'
			replace ols_result = matching_se[`varcounter'] in `secounter'
			replace ols_pval = 2*ttail(105,abs(matching_coeff[`varcounter']/matching_se[`varcounter'])) in `obscounter'
		}
		local varcounter = `varcounter' + 1
		local obscounter = `obscounter' + 2
	}


	// Create residualized dependent variables for matching regressions

	xi i.year i.school_id

	foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
		capture: drop r`varname'
		gen r`varname'_temp = `varname' - lag2_`varname'
		reg r`varname'_temp _Iyear* if `1'
		predict r`varname', resid
		drop r`varname'_temp
	}


	// Run reduced form for residualized matching regressions

	capture: drop matching_resid_dep_var
	gen str40 matching_resid_dep_var = ""

	forvalues w = 1(1)12 {
		capture: drop matching_resid_coeff_`w' matching_resid_se_`w' matching_resid_N_`w' matching_rf_resid_coeff_`w' matching_rf_resid_se_`w'
		local i = 1
		gen float matching_resid_coeff_`w' = .
		gen float matching_resid_se_`w' = .
		gen float matching_resid_N_`w' = .
		gen float matching_rf_resid_coeff_`w' = .
		gen float matching_rf_resid_se_`w' = .
		xi i.lag_pscore_wk`w'_group*lag_win_wk`w' i.lag_pscore_wk`w'_group*lag_pscore_wk`w', noomit
		foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
			replace matching_resid_dep_var = "`varname'" in `i'
			reg r`varname' _Ilag* if `1', vce(cluster school_id) noconstant
			tab lag_pscore_wk`w'_group if e(sample), matcell(freqmat) matrow(valmat)
			local totalestobs = r(N)
			svmat valmat, names(val)
			svmat freqmat, names(freq)	
			forvalues j = 1(1)12 {
				quietly sum freq1 if val1==`j' in 1/12
				if r(N)==1 {
					if r(mean)>3 {
						local freq`j' =	r(mean)			
					}
					else {
						local freq`j' = 0
					}
				}
				else {
					local freq`j' = 0
				}
			}
			drop val1 freq1
			// Enforce overlap: drop any cells with less than 2 wins or losses
			forvalues j = 1(1)12 {
				sum lag_win_wk`w' if e(sample) & lag_pscore_wk`w'_group==`j' & lag_win_wk`w'==1
				local wincount = r(N)
				sum lag_win_wk`w' if e(sample) & lag_pscore_wk`w'_group==`j' & lag_win_wk`w'==0
				local losscount = r(N)
				if min(`wincount',`losscount')<2 {
					local weight`j' = 0
				}
				else {
					local weight`j' = 1
				}
			}
			local totalestobs = (`freq1'*`weight1' + `freq2'*`weight2' + `freq3'*`weight3' + `freq4'*`weight4' + `freq5'*`weight5' + `freq6'*`weight6' + `freq7'*`weight7' + `freq8'*`weight8' + `freq9'*`weight9' + `freq10'*`weight10' + `freq11'*`weight11' + `freq12'*`weight12')
			lincom (_b[_IlagXlag__1]*`freq1'*`weight1' + _b[_IlagXlag__2]*`freq2'*`weight2' + _b[_IlagXlag__3]*`freq3'*`weight3' + _b[_IlagXlag__4]*`freq4'*`weight4' + _b[_IlagXlag__5]*`freq5'*`weight5' + _b[_IlagXlag__6]*`freq6'*`weight6' + _b[_IlagXlag__7]*`freq7'*`weight7' + _b[_IlagXlag__8]*`freq8'*`weight8' + _b[_IlagXlag__9]*`freq9'*`weight9' + _b[_IlagXlag__10]*`freq10'*`weight10' + _b[_IlagXlag__11]*`freq11'*`weight11' + _b[_IlagXlag__12]*`freq12'*`weight12')/`totalestobs'
			local C = r(estimate)
			local SE = r(se)
			replace matching_rf_resid_coeff_`w' = `C' in `i'
			replace matching_rf_resid_se_`w' = `SE' in `i'
			replace matching_resid_N_`w' = e(N) in `i'		
			forvalues j = 1(1)12 {
				local fs`j' = 1 + matching_fs_coeff_`w'_`j'[`i']
				local fs_se`j' = matching_fs_se_`w'_`j'[`i']
			}
			lincom (_b[_IlagXlag__1]*`freq1'*`weight1'/`fs1' + _b[_IlagXlag__2]*`freq2'*`weight2'/`fs2' + _b[_IlagXlag__3]*`freq3'*`weight3'/`fs3' + _b[_IlagXlag__4]*`freq4'*`weight4'/`fs4' + _b[_IlagXlag__5]*`freq5'*`weight5'/`fs5' + _b[_IlagXlag__6]*`freq6'*`weight6'/`fs6' + _b[_IlagXlag__7]*`freq7'*`weight7'/`fs7' + _b[_IlagXlag__8]*`freq8'*`weight8'/`fs8' + _b[_IlagXlag__9]*`freq9'*`weight9'/`fs9' + _b[_IlagXlag__10]*`freq10'*`weight10'/`fs10' + _b[_IlagXlag__11]*`freq11'*`weight11'/`fs11' + _b[_IlagXlag__12]*`freq12'*`weight12'/`fs12')/`totalestobs'
			local C = r(estimate)
			local SE = (((_se[_IlagXlag__1]/(`fs1'))^2 + (`fs_se1'*_b[_IlagXlag__1]/(`fs1')^2)^2)*(`freq1'*`weight1'/`totalestobs')^2 +  ((_se[_IlagXlag__2]/(`fs2'))^2 + (`fs_se2'*_b[_IlagXlag__2]/(`fs2')^2)^2)*(`freq2'*`weight2'/`totalestobs')^2 +  ((_se[_IlagXlag__3]/(`fs3'))^2 + (`fs_se3'*_b[_IlagXlag__3]/(`fs3')^2)^2)*(`freq3'*`weight3'/`totalestobs')^2 +  ((_se[_IlagXlag__4]/(`fs4'))^2 + (`fs_se4'*_b[_IlagXlag__4]/(`fs4')^2)^2)*(`freq4'*`weight4'/`totalestobs')^2 +  ((_se[_IlagXlag__5]/(`fs5'))^2 + (`fs_se5'*_b[_IlagXlag__5]/(`fs5')^2)^2)*(`freq5'*`weight5'/`totalestobs')^2 +  ((_se[_IlagXlag__6]/(`fs6'))^2 + (`fs_se6'*_b[_IlagXlag__6]/(`fs6')^2)^2)*(`freq6'*`weight6'/`totalestobs')^2 +  ((_se[_IlagXlag__7]/(`fs7'))^2 + (`fs_se7'*_b[_IlagXlag__7]/(`fs7')^2)^2)*(`freq7'*`weight7'/`totalestobs')^2 +  ((_se[_IlagXlag__8]/(`fs8'))^2 + (`fs_se8'*_b[_IlagXlag__8]/(`fs8')^2)^2)*(`freq8'*`weight8'/`totalestobs')^2 +  ((_se[_IlagXlag__9]/(`fs9'))^2 + (`fs_se9'*_b[_IlagXlag__9]/(`fs9')^2)^2)*(`freq9'*`weight9'/`totalestobs')^2 +  ((_se[_IlagXlag__10]/(`fs10'))^2 + (`fs_se10'*_b[_IlagXlag__10]/(`fs10')^2)^2)*(`freq10'*`weight10'/`totalestobs')^2 +  ((_se[_IlagXlag__11]/(`fs11'))^2 + (`fs_se11'*_b[_IlagXlag__11]/(`fs11')^2)^2)*(`freq11'*`weight11'/`totalestobs')^2 +  ((_se[_IlagXlag__12]/(`fs12'))^2 + (`fs_se12'*_b[_IlagXlag__12]/(`fs12')^2)^2)*(`freq12'*`weight12'/`totalestobs')^2)^0.5	
			replace matching_resid_coeff_`w' = `C' in `i'
			replace matching_resid_se_`w' = `SE' in `i'
			local i = `i' + 1
		}
	}

	capture: drop total_resid_N matching_resid_coeff matching_resid_se matching_resid_N matching_rf_resid_coeff matching_rf_resid_se
	gen total_resid_N = matching_resid_N_5 + matching_resid_N_6 + matching_resid_N_7 + matching_resid_N_8 + matching_resid_N_9 + matching_resid_N_10 + matching_resid_N_11 + matching_resid_N_12
	gen matching_rf_resid_coeff = matching_rf_resid_coeff_5*(matching_resid_N_5/total_resid_N) + matching_rf_resid_coeff_6*(matching_resid_N_6/total_resid_N) + matching_rf_resid_coeff_7*(matching_resid_N_7/total_resid_N) + matching_rf_resid_coeff_8*(matching_resid_N_8/total_resid_N) + matching_rf_resid_coeff_9*(matching_resid_N_9/total_resid_N) + matching_rf_resid_coeff_10*(matching_resid_N_10/total_resid_N) + matching_rf_resid_coeff_11*(matching_resid_N_11/total_resid_N) + matching_rf_resid_coeff_12*(matching_resid_N_12/total_resid_N)
	gen matching_rf_resid_se = ((matching_rf_resid_se_5^2)*(matching_resid_N_5/total_resid_N)^2 + (matching_rf_resid_se_6^2)*(matching_resid_N_6/total_resid_N)^2 + (matching_rf_resid_se_7^2)*(matching_resid_N_7/total_resid_N)^2 + (matching_rf_resid_se_8^2)*(matching_resid_N_8/total_resid_N)^2 + (matching_rf_resid_se_9^2)*(matching_resid_N_9/total_resid_N)^2 + (matching_rf_resid_se_10^2)*(matching_resid_N_10/total_resid_N)^2 + (matching_rf_resid_se_11^2)*(matching_resid_N_11/total_resid_N)^2 + (matching_rf_resid_se_12^2)*(matching_resid_N_12/total_resid_N)^2)^0.5
	gen matching_resid_coeff = matching_resid_coeff_5*(matching_resid_N_5/total_resid_N) + matching_resid_coeff_6*(matching_resid_N_6/total_resid_N) + matching_resid_coeff_7*(matching_resid_N_7/total_resid_N) + matching_resid_coeff_8*(matching_resid_N_8/total_resid_N) + matching_resid_coeff_9*(matching_resid_N_9/total_resid_N) + matching_resid_coeff_10*(matching_resid_N_10/total_resid_N) + matching_resid_coeff_11*(matching_resid_N_11/total_resid_N) + matching_resid_coeff_12*(matching_resid_N_12/total_resid_N)
	gen matching_resid_se = ((matching_resid_se_5^2)*(matching_resid_N_5/total_resid_N)^2 + (matching_resid_se_6^2)*(matching_resid_N_6/total_resid_N)^2 + (matching_resid_se_7^2)*(matching_resid_N_7/total_resid_N)^2 + (matching_resid_se_8^2)*(matching_resid_N_8/total_resid_N)^2 + (matching_resid_se_9^2)*(matching_resid_N_9/total_resid_N)^2 + (matching_resid_se_10^2)*(matching_resid_N_10/total_resid_N)^2 + (matching_resid_se_11^2)*(matching_resid_N_11/total_resid_N)^2 + (matching_resid_se_12^2)*(matching_resid_N_12/total_resid_N)^2)^0.5
	gen matching_resid_N = max(matching_resid_N_5, matching_resid_N_6, matching_resid_N_7, matching_resid_N_8, matching_resid_N_9, matching_resid_N_10, matching_resid_N_11, matching_resid_N_12)

	local obscounter = 1
	local varcounter = 1
	while `obscounter'<=20 {
		local secounter = `obscounter' + 1
		replace ldv_N = matching_resid_N[`varcounter'] in `obscounter'
		if `3'==0 {
			replace ldv_result = matching_rf_resid_coeff[`varcounter'] in `obscounter'
			replace ldv_result = matching_rf_resid_se[`varcounter'] in `secounter'
			replace ldv_pval = 2*ttail(105,abs(matching_rf_resid_coeff[`varcounter']/matching_rf_resid_se[`varcounter'])) in `obscounter'	
		}
		else {
			replace ldv_result = matching_resid_coeff[`varcounter'] in `obscounter'
			replace ldv_result = matching_resid_se[`varcounter'] in `secounter'
			replace ldv_pval = 2*ttail(105,abs(matching_resid_coeff[`varcounter']/matching_resid_se[`varcounter'])) in `obscounter'
		}
		local varcounter = `varcounter' + 1
		local obscounter = `obscounter' + 2
	}
	drop _I*
	xi i.year

	capture: drop ols_result_seq
	capture: drop ols_result_wgt_seq
	capture: drop ols_pval_seq
	capture: drop ols_N_seq
	capture: drop ldv_result_seq
	capture: drop ldv_result_wgt_seq
	capture: drop ldv_pval_seq
	capture: drop ldv_N_seq
	capture: drop ldv_se_wgt_seq

	gen ols_result_seq = .
	gen ols_result_wgt_seq = .
	gen ols_pval_seq = .
	gen ols_N_seq = .
	gen ldv_result_seq = .
	gen ldv_result_wgt_seq = .
	gen ldv_pval_seq = .
	gen ldv_N_seq = .
	gen ldv_se_wgt_seq = .
	local counter = 1

	capture: drop rseasonwins
	capture: drop rseasongames 
	gen rseasonwins = lag_seasonwins_5 - lag3_seasonwins_5
	gen rseasongames = lag_seasongames_5 - lag3_seasongames_5

	foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
		capture: drop r`varname'
		gen r`varname' = `varname' - lag2_`varname'
		reg r`varname' rseasonwins lag3_seasonwins_5 lag_seasongames_5 lag3_seasongames_5 _Iyear* if `1' & lag_ipw_weight<`2' [aw=lag_ipw_weight_5], vce(cluster school_id)
		replace ldv_result_seq = _b[rseasonwins] in `counter'
		replace ldv_pval_seq =  2*ttail(e(N_clust),abs(_b[rseasonwins]/_se[rseasonwins])) in `counter'
		replace ldv_N_seq = e(N) in `counter'
		local counter = `counter' + 1
		replace ldv_result_seq = _se[rseasonwins] in `counter'
		local counter = `counter' + 1
	}
	if `3'==0 {
		capture: drop ldv_pval_rf
		rename ldv_pval ldv_pval_rf
	}
end

*********************************************

// Define program to run 2 years later p-score matching and sequential treatment effect results
// Takes args: bcs, trim_value, iv_flag
capture: program drop main_results_2yr
program define main_results_2yr
	forvalues w = 1(1)12 {
		capture: drop lag2_pscore_wk`w'_group
		foreach varname of varlist lag2_pscore_wk`w' {
			sum lag2_pscore_wk`w' if lag2_win_wk`w'==1 & `1'
			local min_treated = r(min)
			sum lag2_pscore_wk`w' if lag2_win_wk`w'==0 & `1'
			local max_treated = r(max)
			centile `varname' if `1' & `varname'>=`min_treated' & `varname'<=`max_treated', centile(5(5)95)
			gen `varname'_group = .
			forvalues i = 2(1)19 {
				local iminus1 = `i' - 1
				local bottom_centile = r(c_`iminus1') 
				local top_centile = r(c_`i') 
				replace `varname'_group = `i' if `varname'>=`bottom_centile' & `varname'<`top_centile' & `1'
			}	
			replace `varname'_group = 1 if `varname'<r(c_1) & `1'
			replace `varname'_group = 20 if `varname'>=r(c_19) & `varname'!=. & `1'
		}
	}

	capture: drop variable_name 
	capture: drop ols_result
	capture: drop ols_pval
	capture: drop ols_N
	capture: drop ldv_result
	capture: drop ldv_pval
	capture: drop ldv_N

	gen variable_name = ""
	gen ols_result = .
	gen ols_pval = .
	gen ols_N = .
	gen ldv_result = .
	gen ldv_pval = .
	gen ldv_N = .

	capture: drop fs_ny_result
	capture: drop fs_ny_N
	capture: drop fs_ny_pval
	gen fs_ny_result = .
	gen fs_ny_pval = .
	gen fs_ny_N = .

	// Run first stage for matching regressions

	capture: drop matching_dep_var
	gen str40 matching_dep_var = ""

	forvalues w = 1(1)12 {
		xi i.lag2_pscore_wk`w'_group*lag2_win_wk`w' i.lag2_pscore_wk`w'_group*lag2_pscore_wk`w', noomit
		reg lag2_exp_wins_wk`w' _Ilag* if `1', vce(cluster school_id) noconstant
		tab lag2_pscore_wk`w'_group if e(sample), matcell(freqmat) matrow(valmat)
		local totalestobs = r(N)
		svmat valmat, names(val)
		svmat freqmat, names(freq)	
		forvalues j = 1(1)12 {
			quietly sum freq1 if val1==`j' in 1/12
			if r(N)==1 {
				if r(mean)>3 {
					local freq`j' =	r(mean)			
				}
				else {
					local freq`j' = 0
				}
			}
			else {
				local freq`j' = 0
			}
		}
		drop val1 freq1
		capture: drop matching_fs_coeff_lhs_`w'
		gen matching_fs_coeff_lhs_`w' = .
		gen group = _n in 1/12
		gen groupsq = group^2 in 1/12
		forvalues j = 1(1)12 {
			replace matching_fs_coeff_lhs_`w' = _b[_IlagXlag2_`j'] in `j'
		}
		reg matching_fs_coeff_lhs_`w' group groupsq
		predict matching_fs_coeff_`w'_pred in 1/12
		predict matching_fs_coeff_`w'_pred_se in 1/12, stdp
		drop group groupsq
		forvalues j = 1(1)12 {
			capture: drop matching_fs_coeff_`w'_`j' matching_fs_se_`w'_`j'
			gen matching_fs_coeff_`w'_`j' = matching_fs_coeff_`w'_pred[`j'] in 1/30
			gen matching_fs_se_`w'_`j' = matching_fs_coeff_`w'_pred_se[`j'] in 1/30
		}
		drop matching_fs_coeff_`w'_pred matching_fs_coeff_`w'_pred_se
		if `w'==12 {
			forvalues j = 1(1)12 {	
				replace matching_fs_coeff_`w'_`j' = 0 in 1/30
				replace matching_fs_se_`w'_`j' = 0 in 1/30
			}
		}
	}

	// Run reduced form for matching regressions

	forvalues w = 1(1)12 {
		capture: drop matching_coeff_`w' matching_se_`w' matching_rf_coeff_`w' matching_rf_se_`w' matching_N_`w'
		local i = 1
		gen float matching_coeff_`w' = .
		gen float matching_se_`w' = .
		gen float matching_N_`w' = .
		gen float matching_rf_coeff_`w' = .
		gen float matching_rf_se_`w' = .
		xi i.lag2_pscore_wk`w'_group*lag2_win_wk`w' i.lag2_pscore_wk`w'_group*lag2_pscore_wk`w', noomit
		foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
			replace matching_dep_var = "`varname'" in `i'
			reg `varname' _Ilag* if `1', vce(cluster school_id) noconstant
			tab lag2_pscore_wk`w'_group if e(sample), matcell(freqmat) matrow(valmat)
			local totalestobs = r(N)
			svmat valmat, names(val)
			svmat freqmat, names(freq)	
			forvalues j = 1(1)12 {
				quietly sum freq1 if val1==`j' in 1/12
				if r(N)==1 {
					if r(mean)>3 {
						local freq`j' =	r(mean)			
					}
					else {
						local freq`j' = 0
					}
				}
				else {
					local freq`j' = 0
				}
			}
			drop val1 freq1
			// Enforce overlap: drop any cells with less than 2 wins or losses
			forvalues j = 1(1)12 {
				sum lag2_win_wk`w' if e(sample) & lag2_pscore_wk`w'_group==`j' & lag2_win_wk`w'==1
				local wincount = r(N)
				sum lag2_win_wk`w' if e(sample) & lag2_pscore_wk`w'_group==`j' & lag2_win_wk`w'==0
				local losscount = r(N)
				if min(`wincount',`losscount')<2 {
					local weight`j' = 0
				}
				else {
					local weight`j' = 1
				}
			}
			local totalestobs = (`freq1'*`weight1' + `freq2'*`weight2' + `freq3'*`weight3' + `freq4'*`weight4' + `freq5'*`weight5' + `freq6'*`weight6' + `freq7'*`weight7' + `freq8'*`weight8' + `freq9'*`weight9' + `freq10'*`weight10' + `freq11'*`weight11' + `freq12'*`weight12')
			lincom (_b[_IlagXlag2_1]*`freq1'*`weight1' + _b[_IlagXlag2_2]*`freq2'*`weight2' + _b[_IlagXlag2_3]*`freq3'*`weight3' + _b[_IlagXlag2_4]*`freq4'*`weight4' + _b[_IlagXlag2_5]*`freq5'*`weight5' + _b[_IlagXlag2_6]*`freq6'*`weight6' + _b[_IlagXlag2_7]*`freq7'*`weight7' + _b[_IlagXlag2_8]*`freq8'*`weight8' + _b[_IlagXlag2_9]*`freq9'*`weight9' + _b[_IlagXlag2_10]*`freq10'*`weight10' + _b[_IlagXlag2_11]*`freq11'*`weight11' + _b[_IlagXlag2_12]*`freq12'*`weight12')/`totalestobs'
			local C = r(estimate)
			local SE = r(se)
			replace matching_rf_coeff_`w' = `C' in `i'
			replace matching_rf_se_`w' = `SE' in `i'
			replace matching_N_`w' = e(N) in `i'		
			forvalues j = 1(1)12 {
				local fs`j' = 1 + matching_fs_coeff_`w'_`j'[`i']
				local fs_se`j' = matching_fs_se_`w'_`j'[`i']
			}
			lincom (_b[_IlagXlag2_1]*`freq1'*`weight1'/`fs1' + _b[_IlagXlag2_2]*`freq2'*`weight2'/`fs2' + _b[_IlagXlag2_3]*`freq3'*`weight3'/`fs3' + _b[_IlagXlag2_4]*`freq4'*`weight4'/`fs4' + _b[_IlagXlag2_5]*`freq5'*`weight5'/`fs5' + _b[_IlagXlag2_6]*`freq6'*`weight6'/`fs6' + _b[_IlagXlag2_7]*`freq7'*`weight7'/`fs7' + _b[_IlagXlag2_8]*`freq8'*`weight8'/`fs8' + _b[_IlagXlag2_9]*`freq9'*`weight9'/`fs9' + _b[_IlagXlag2_10]*`freq10'*`weight10'/`fs10' + _b[_IlagXlag2_11]*`freq11'*`weight11'/`fs11' + _b[_IlagXlag2_12]*`freq12'*`weight12'/`fs12')/`totalestobs'
			local C = r(estimate)
			local SE = (((_se[_IlagXlag2_1]/(`fs1'))^2 + (`fs_se1'*_b[_IlagXlag2_1]/(`fs1')^2)^2)*(`freq1'*`weight1'/`totalestobs')^2 +  ((_se[_IlagXlag2_2]/(`fs2'))^2 + (`fs_se2'*_b[_IlagXlag2_2]/(`fs2')^2)^2)*(`freq2'*`weight2'/`totalestobs')^2 +  ((_se[_IlagXlag2_3]/(`fs3'))^2 + (`fs_se3'*_b[_IlagXlag2_3]/(`fs3')^2)^2)*(`freq3'*`weight3'/`totalestobs')^2 +  ((_se[_IlagXlag2_4]/(`fs4'))^2 + (`fs_se4'*_b[_IlagXlag2_4]/(`fs4')^2)^2)*(`freq4'*`weight4'/`totalestobs')^2 +  ((_se[_IlagXlag2_5]/(`fs5'))^2 + (`fs_se5'*_b[_IlagXlag2_5]/(`fs5')^2)^2)*(`freq5'*`weight5'/`totalestobs')^2 +  ((_se[_IlagXlag2_6]/(`fs6'))^2 + (`fs_se6'*_b[_IlagXlag2_6]/(`fs6')^2)^2)*(`freq6'*`weight6'/`totalestobs')^2 +  ((_se[_IlagXlag2_7]/(`fs7'))^2 + (`fs_se7'*_b[_IlagXlag2_7]/(`fs7')^2)^2)*(`freq7'*`weight7'/`totalestobs')^2 +  ((_se[_IlagXlag2_8]/(`fs8'))^2 + (`fs_se8'*_b[_IlagXlag2_8]/(`fs8')^2)^2)*(`freq8'*`weight8'/`totalestobs')^2 +  ((_se[_IlagXlag2_9]/(`fs9'))^2 + (`fs_se9'*_b[_IlagXlag2_9]/(`fs9')^2)^2)*(`freq9'*`weight9'/`totalestobs')^2 +  ((_se[_IlagXlag2_10]/(`fs10'))^2 + (`fs_se10'*_b[_IlagXlag2_10]/(`fs10')^2)^2)*(`freq10'*`weight10'/`totalestobs')^2 +  ((_se[_IlagXlag2_11]/(`fs11'))^2 + (`fs_se11'*_b[_IlagXlag2_11]/(`fs11')^2)^2)*(`freq11'*`weight11'/`totalestobs')^2 +  ((_se[_IlagXlag2_12]/(`fs12'))^2 + (`fs_se12'*_b[_IlagXlag2_12]/(`fs12')^2)^2)*(`freq12'*`weight12'/`totalestobs')^2)^0.5	
			replace matching_coeff_`w' = `C' in `i'
			replace matching_se_`w' = `SE' in `i'
			local i = `i' + 1
		}
	}

	capture: drop total_N matching_coeff matching_se matching_rf_coeff matching_rf_se matching_N
	gen total_N = matching_N_1 + matching_N_2 + matching_N_3 + matching_N_4 + matching_N_5 + matching_N_6 + matching_N_7 + matching_N_8 + matching_N_9 + matching_N_10 + matching_N_11 + matching_N_12
	gen matching_rf_coeff = matching_rf_coeff_1*(matching_N_1/total_N) + matching_rf_coeff_2*(matching_N_2/total_N) + matching_rf_coeff_3*(matching_N_3/total_N) + matching_rf_coeff_4*(matching_N_4/total_N) + matching_rf_coeff_5*(matching_N_5/total_N) + matching_rf_coeff_6*(matching_N_6/total_N) + matching_rf_coeff_7*(matching_N_7/total_N) + matching_rf_coeff_8*(matching_N_8/total_N) + matching_rf_coeff_9*(matching_N_9/total_N) + matching_rf_coeff_10*(matching_N_10/total_N) + matching_rf_coeff_11*(matching_N_11/total_N) + matching_rf_coeff_12*(matching_N_12/total_N)
	gen matching_rf_se = ((matching_rf_se_1^2)*(matching_N_1/total_N)^2 + (matching_rf_se_2^2)*(matching_N_2/total_N)^2 + (matching_rf_se_3^2)*(matching_N_3/total_N)^2 + (matching_rf_se_4^2)*(matching_N_4/total_N)^2 + (matching_rf_se_5^2)*(matching_N_5/total_N)^2 + (matching_rf_se_6^2)*(matching_N_6/total_N)^2 + (matching_rf_se_7^2)*(matching_N_7/total_N)^2 + (matching_rf_se_8^2)*(matching_N_8/total_N)^2 + (matching_rf_se_9^2)*(matching_N_9/total_N)^2 + (matching_rf_se_10^2)*(matching_N_10/total_N)^2 + (matching_rf_se_11^2)*(matching_N_11/total_N)^2 + (matching_rf_se_12^2)*(matching_N_12/total_N)^2)^0.5
	gen matching_coeff = matching_coeff_1*(matching_N_1/total_N) + matching_coeff_2*(matching_N_2/total_N) + matching_coeff_3*(matching_N_3/total_N) + matching_coeff_4*(matching_N_4/total_N) + matching_coeff_5*(matching_N_5/total_N) + matching_coeff_6*(matching_N_6/total_N) + matching_coeff_7*(matching_N_7/total_N) + matching_coeff_8*(matching_N_8/total_N) + matching_coeff_9*(matching_N_9/total_N) + matching_coeff_10*(matching_N_10/total_N) + matching_coeff_11*(matching_N_11/total_N) + matching_coeff_12*(matching_N_12/total_N)
	gen matching_se = ((matching_se_1^2)*(matching_N_1/total_N)^2 + (matching_se_2^2)*(matching_N_2/total_N)^2 + (matching_se_3^2)*(matching_N_3/total_N)^2 + (matching_se_4^2)*(matching_N_4/total_N)^2 + (matching_se_5^2)*(matching_N_5/total_N)^2 + (matching_se_6^2)*(matching_N_6/total_N)^2 + (matching_se_7^2)*(matching_N_7/total_N)^2 + (matching_se_8^2)*(matching_N_8/total_N)^2 + (matching_se_9^2)*(matching_N_9/total_N)^2 + (matching_se_10^2)*(matching_N_10/total_N)^2 + (matching_se_11^2)*(matching_N_11/total_N)^2 + (matching_se_12^2)*(matching_N_12/total_N)^2)^0.5
	gen matching_N = max(matching_N_1, matching_N_2, matching_N_3, matching_N_4, matching_N_5, matching_N_6, matching_N_7, matching_N_8, matching_N_9, matching_N_10, matching_N_11, matching_N_12)

	local obscounter = 1
	local varcounter = 1
	while `obscounter'<=20 {
		local secounter = `obscounter' + 1
		replace variable_name = matching_dep_var[`varcounter'] in `obscounter'
		replace ols_N = matching_N[`varcounter'] in `obscounter'
	//	replace ols_result = matching_rf_coeff[`varcounter'] in `obscounter'
	//	replace ols_result = matching_rf_se[`varcounter'] in `secounter'
	//	replace ols_pval = 2*ttail(105,abs(matching_rf_coeff[`varcounter']/matching_rf_se[`varcounter'])) in `obscounter'
		replace ols_result = matching_coeff[`varcounter'] in `obscounter'
		replace ols_result = matching_se[`varcounter'] in `secounter'
		replace ols_pval = 2*ttail(105,abs(matching_coeff[`varcounter']/matching_se[`varcounter'])) in `obscounter'
		local varcounter = `varcounter' + 1
		local obscounter = `obscounter' + 2
	}


	// Create residualized dependent variables for matching regressions

	xi i.year i.school_id

	foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
		capture: drop r`varname'
		gen r`varname'_temp = `varname' - lag3_`varname'
		reg r`varname'_temp _Iyear* if `1'
		predict r`varname', resid
		drop r`varname'_temp
	}

	// Run reduced form for residualized matching regressions

	capture: drop matching_resid_dep_var
	gen str40 matching_resid_dep_var = ""

	forvalues w = 1(1)12 {
		capture: drop matching_resid_coeff_`w' matching_resid_se_`w' matching_resid_N_`w' matching_rf_resid_coeff_`w' matching_rf_resid_se_`w'
		local i = 1
		gen float matching_resid_coeff_`w' = .
		gen float matching_resid_se_`w' = .
		gen float matching_resid_N_`w' = .
		gen float matching_rf_resid_coeff_`w' = .
		gen float matching_rf_resid_se_`w' = .
		xi i.lag2_pscore_wk`w'_group*lag2_win_wk`w' i.lag2_pscore_wk`w'_group*lag2_pscore_wk`w', noomit
		foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
			replace matching_resid_dep_var = "`varname'" in `i'
			reg r`varname' _Ilag* if `1', vce(cluster school_id) noconstant
			tab lag2_pscore_wk`w'_group if e(sample), matcell(freqmat) matrow(valmat)
			local totalestobs = r(N)
			svmat valmat, names(val)
			svmat freqmat, names(freq)	
			forvalues j = 1(1)12 {
				quietly sum freq1 if val1==`j' in 1/12
				if r(N)==1 {
					if r(mean)>3 {
						local freq`j' =	r(mean)			
					}
					else {
						local freq`j' = 0
					}
				}
				else {
					local freq`j' = 0
				}
			}
			drop val1 freq1
			// Enforce overlap: drop any cells with less than 2 wins or losses
			forvalues j = 1(1)12 {
				sum lag2_win_wk`w' if e(sample) & lag2_pscore_wk`w'_group==`j' & lag2_win_wk`w'==1
				local wincount = r(N)
				sum lag2_win_wk`w' if e(sample) & lag2_pscore_wk`w'_group==`j' & lag2_win_wk`w'==0
				local losscount = r(N)
				if min(`wincount',`losscount')<2 {
					local weight`j' = 0
				}
				else {
					local weight`j' = 1
				}
			}
			local totalestobs = (`freq1'*`weight1' + `freq2'*`weight2' + `freq3'*`weight3' + `freq4'*`weight4' + `freq5'*`weight5' + `freq6'*`weight6' + `freq7'*`weight7' + `freq8'*`weight8' + `freq9'*`weight9' + `freq10'*`weight10' + `freq11'*`weight11' + `freq12'*`weight12')
			lincom (_b[_IlagXlag2_1]*`freq1'*`weight1' + _b[_IlagXlag2_2]*`freq2'*`weight2' + _b[_IlagXlag2_3]*`freq3'*`weight3' + _b[_IlagXlag2_4]*`freq4'*`weight4' + _b[_IlagXlag2_5]*`freq5'*`weight5' + _b[_IlagXlag2_6]*`freq6'*`weight6' + _b[_IlagXlag2_7]*`freq7'*`weight7' + _b[_IlagXlag2_8]*`freq8'*`weight8' + _b[_IlagXlag2_9]*`freq9'*`weight9' + _b[_IlagXlag2_10]*`freq10'*`weight10' + _b[_IlagXlag2_11]*`freq11'*`weight11' + _b[_IlagXlag2_12]*`freq12'*`weight12')/`totalestobs'
			local C = r(estimate)
			local SE = r(se)
			replace matching_rf_resid_coeff_`w' = `C' in `i'
			replace matching_rf_resid_se_`w' = `SE' in `i'
			replace matching_resid_N_`w' = e(N) in `i'		
			forvalues j = 1(1)12 {
				local fs`j' = 1 + matching_fs_coeff_`w'_`j'[`i']
				local fs_se`j' = matching_fs_se_`w'_`j'[`i']
			}
			lincom (_b[_IlagXlag2_1]*`freq1'*`weight1'/`fs1' + _b[_IlagXlag2_2]*`freq2'*`weight2'/`fs2' + _b[_IlagXlag2_3]*`freq3'*`weight3'/`fs3' + _b[_IlagXlag2_4]*`freq4'*`weight4'/`fs4' + _b[_IlagXlag2_5]*`freq5'*`weight5'/`fs5' + _b[_IlagXlag2_6]*`freq6'*`weight6'/`fs6' + _b[_IlagXlag2_7]*`freq7'*`weight7'/`fs7' + _b[_IlagXlag2_8]*`freq8'*`weight8'/`fs8' + _b[_IlagXlag2_9]*`freq9'*`weight9'/`fs9' + _b[_IlagXlag2_10]*`freq10'*`weight10'/`fs10' + _b[_IlagXlag2_11]*`freq11'*`weight11'/`fs11' + _b[_IlagXlag2_12]*`freq12'*`weight12'/`fs12')/`totalestobs'
			local C = r(estimate)
			local SE = (((_se[_IlagXlag2_1]/(`fs1'))^2 + (`fs_se1'*_b[_IlagXlag2_1]/(`fs1')^2)^2)*(`freq1'*`weight1'/`totalestobs')^2 +  ((_se[_IlagXlag2_2]/(`fs2'))^2 + (`fs_se2'*_b[_IlagXlag2_2]/(`fs2')^2)^2)*(`freq2'*`weight2'/`totalestobs')^2 +  ((_se[_IlagXlag2_3]/(`fs3'))^2 + (`fs_se3'*_b[_IlagXlag2_3]/(`fs3')^2)^2)*(`freq3'*`weight3'/`totalestobs')^2 +  ((_se[_IlagXlag2_4]/(`fs4'))^2 + (`fs_se4'*_b[_IlagXlag2_4]/(`fs4')^2)^2)*(`freq4'*`weight4'/`totalestobs')^2 +  ((_se[_IlagXlag2_5]/(`fs5'))^2 + (`fs_se5'*_b[_IlagXlag2_5]/(`fs5')^2)^2)*(`freq5'*`weight5'/`totalestobs')^2 +  ((_se[_IlagXlag2_6]/(`fs6'))^2 + (`fs_se6'*_b[_IlagXlag2_6]/(`fs6')^2)^2)*(`freq6'*`weight6'/`totalestobs')^2 +  ((_se[_IlagXlag2_7]/(`fs7'))^2 + (`fs_se7'*_b[_IlagXlag2_7]/(`fs7')^2)^2)*(`freq7'*`weight7'/`totalestobs')^2 +  ((_se[_IlagXlag2_8]/(`fs8'))^2 + (`fs_se8'*_b[_IlagXlag2_8]/(`fs8')^2)^2)*(`freq8'*`weight8'/`totalestobs')^2 +  ((_se[_IlagXlag2_9]/(`fs9'))^2 + (`fs_se9'*_b[_IlagXlag2_9]/(`fs9')^2)^2)*(`freq9'*`weight9'/`totalestobs')^2 +  ((_se[_IlagXlag2_10]/(`fs10'))^2 + (`fs_se10'*_b[_IlagXlag2_10]/(`fs10')^2)^2)*(`freq10'*`weight10'/`totalestobs')^2 +  ((_se[_IlagXlag2_11]/(`fs11'))^2 + (`fs_se11'*_b[_IlagXlag2_11]/(`fs11')^2)^2)*(`freq11'*`weight11'/`totalestobs')^2 +  ((_se[_IlagXlag2_12]/(`fs12'))^2 + (`fs_se12'*_b[_IlagXlag2_12]/(`fs12')^2)^2)*(`freq12'*`weight12'/`totalestobs')^2)^0.5	
			replace matching_resid_coeff_`w' = `C' in `i'
			replace matching_resid_se_`w' = `SE' in `i'
			local i = `i' + 1
		}
	}

	capture: drop total_resid_N matching_resid_coeff matching_resid_se matching_resid_N matching_rf_resid_coeff matching_rf_resid_se
	gen total_resid_N = matching_resid_N_1 + matching_resid_N_2 + matching_resid_N_3 + matching_resid_N_4 + matching_resid_N_5 + matching_resid_N_6 + matching_resid_N_7 + matching_resid_N_8 + matching_resid_N_9 + matching_resid_N_10 + matching_resid_N_11 + matching_resid_N_12
	gen matching_rf_resid_coeff = matching_rf_resid_coeff_1*(matching_resid_N_1/total_resid_N) + matching_rf_resid_coeff_2*(matching_resid_N_2/total_resid_N) + matching_rf_resid_coeff_3*(matching_resid_N_3/total_resid_N) + matching_rf_resid_coeff_4*(matching_resid_N_4/total_resid_N) + matching_rf_resid_coeff_5*(matching_resid_N_5/total_resid_N) + matching_rf_resid_coeff_6*(matching_resid_N_6/total_resid_N) + matching_rf_resid_coeff_7*(matching_resid_N_7/total_resid_N) + matching_rf_resid_coeff_8*(matching_resid_N_8/total_resid_N) + matching_rf_resid_coeff_9*(matching_resid_N_9/total_resid_N) + matching_rf_resid_coeff_10*(matching_resid_N_10/total_resid_N) + matching_rf_resid_coeff_11*(matching_resid_N_11/total_resid_N) + matching_rf_resid_coeff_12*(matching_resid_N_12/total_resid_N)
	gen matching_rf_resid_se = ((matching_rf_resid_se_1^2)*(matching_resid_N_1/total_resid_N)^2 + (matching_rf_resid_se_2^2)*(matching_resid_N_2/total_resid_N)^2 + (matching_rf_resid_se_3^2)*(matching_resid_N_3/total_resid_N)^2 + (matching_rf_resid_se_4^2)*(matching_resid_N_4/total_resid_N)^2 + (matching_rf_resid_se_5^2)*(matching_resid_N_5/total_resid_N)^2 + (matching_rf_resid_se_6^2)*(matching_resid_N_6/total_resid_N)^2 + (matching_rf_resid_se_7^2)*(matching_resid_N_7/total_resid_N)^2 + (matching_rf_resid_se_8^2)*(matching_resid_N_8/total_resid_N)^2 + (matching_rf_resid_se_9^2)*(matching_resid_N_9/total_resid_N)^2 + (matching_rf_resid_se_10^2)*(matching_resid_N_10/total_resid_N)^2 + (matching_rf_resid_se_11^2)*(matching_resid_N_11/total_resid_N)^2 + (matching_rf_resid_se_12^2)*(matching_resid_N_12/total_resid_N)^2)^0.5
	gen matching_resid_coeff = matching_resid_coeff_1*(matching_resid_N_1/total_resid_N) + matching_resid_coeff_2*(matching_resid_N_2/total_resid_N) + matching_resid_coeff_3*(matching_resid_N_3/total_resid_N) + matching_resid_coeff_4*(matching_resid_N_4/total_resid_N) + matching_resid_coeff_5*(matching_resid_N_5/total_resid_N) + matching_resid_coeff_6*(matching_resid_N_6/total_resid_N) + matching_resid_coeff_7*(matching_resid_N_7/total_resid_N) + matching_resid_coeff_8*(matching_resid_N_8/total_resid_N) + matching_resid_coeff_9*(matching_resid_N_9/total_resid_N) + matching_resid_coeff_10*(matching_resid_N_10/total_resid_N) + matching_resid_coeff_11*(matching_resid_N_11/total_resid_N) + matching_resid_coeff_12*(matching_resid_N_12/total_resid_N)
	gen matching_resid_se = ((matching_resid_se_1^2)*(matching_resid_N_1/total_resid_N)^2 + (matching_resid_se_2^2)*(matching_resid_N_2/total_resid_N)^2 + (matching_resid_se_3^2)*(matching_resid_N_3/total_resid_N)^2 + (matching_resid_se_4^2)*(matching_resid_N_4/total_resid_N)^2 + (matching_resid_se_5^2)*(matching_resid_N_5/total_resid_N)^2 + (matching_resid_se_6^2)*(matching_resid_N_6/total_resid_N)^2 + (matching_resid_se_7^2)*(matching_resid_N_7/total_resid_N)^2 + (matching_resid_se_8^2)*(matching_resid_N_8/total_resid_N)^2 + (matching_resid_se_9^2)*(matching_resid_N_9/total_resid_N)^2 + (matching_resid_se_10^2)*(matching_resid_N_10/total_resid_N)^2 + (matching_resid_se_11^2)*(matching_resid_N_11/total_resid_N)^2 + (matching_resid_se_12^2)*(matching_resid_N_12/total_resid_N)^2)^0.5
	gen matching_resid_N = max(matching_resid_N_1, matching_resid_N_2, matching_resid_N_3, matching_resid_N_4, matching_resid_N_5, matching_resid_N_6, matching_resid_N_7, matching_resid_N_8, matching_resid_N_9, matching_resid_N_10, matching_resid_N_11, matching_resid_N_12)

	local obscounter = 1
	local varcounter = 1
	while `obscounter'<=20 {
		local secounter = `obscounter' + 1
		replace ldv_N = matching_resid_N[`varcounter'] in `obscounter'
		if `3'==0 {
			replace ldv_result = matching_rf_resid_coeff[`varcounter'] in `obscounter'
			replace ldv_result = matching_rf_resid_se[`varcounter'] in `secounter'
			replace ldv_pval = 2*ttail(105,abs(matching_rf_resid_coeff[`varcounter']/matching_rf_resid_se[`varcounter'])) in `obscounter'	
		}
		else {
			replace ldv_result = matching_resid_coeff[`varcounter'] in `obscounter'
			replace ldv_result = matching_resid_se[`varcounter'] in `secounter'
			replace ldv_pval = 2*ttail(105,abs(matching_resid_coeff[`varcounter']/matching_resid_se[`varcounter'])) in `obscounter'
		}
		local varcounter = `varcounter' + 1
		local obscounter = `obscounter' + 2
	}
	drop _I*

	// Run "first stage" for the following year's record

	capture: drop matching_dep_var_nextyr
	gen str40 matching_dep_var_nextyr = ""

	gen overall = 1
	forvalues w = 1(1)12 {
		capture: drop matching_fs_coeff_ny`w' matching_fs_se_ny`w' matching_N_ny`w' matching_rf_fs_coeff_ny`w' matching_rf_fs_se_ny`w'
		local i = 1
		gen float matching_fs_coeff_ny`w' = .
		gen float matching_fs_se_ny`w' = .
	 	gen matching_N_ny`w' = .
		gen float matching_rf_fs_coeff_ny`w' = .
		gen float matching_rf_fs_se_ny`w' = .
		xi i.lag2_pscore_wk`w'_group*lag2_win_wk`w' i.lag2_pscore_wk`w'_group*lag2_pscore_wk`w', noomit
		foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 overall {
			replace matching_dep_var_nextyr = "`varname'" in `i'
			reg lag_exp_wins _Ilag* if `1' & `varname'!=., vce(cluster school_id) noconstant
			tab lag2_pscore_wk`w'_group if e(sample), matcell(freqmat) matrow(valmat)
			local totalestobs = r(N)
			svmat valmat, names(val)
			svmat freqmat, names(freq)	
			forvalues j = 1(1)12 {
				quietly sum freq1 if val1==`j' in 1/12
				if r(N)==1 {
					if r(mean)>3 {
						local freq`j' =	r(mean)			
					}
					else {
						local freq`j' = 0
					}
				}
				else {
					local freq`j' = 0
				}
			}
			drop val1 freq1
			// Enforce overlap: drop any cells with less than 2 wins or losses
			forvalues j = 1(1)12 {
				sum lag2_win_wk`w' if e(sample) & lag2_pscore_wk`w'_group==`j' & lag2_win_wk`w'==1
				local wincount = r(N)
				sum lag2_win_wk`w' if e(sample) & lag2_pscore_wk`w'_group==`j' & lag2_win_wk`w'==0
				local losscount = r(N)
				if min(`wincount',`losscount')<2 {
					local weight`j' = 0
				}
				else {
					local weight`j' = 1
				}
			}
			local totalestobs = (`freq1'*`weight1' + `freq2'*`weight2' + `freq3'*`weight3' + `freq4'*`weight4' + `freq5'*`weight5' + `freq6'*`weight6' + `freq7'*`weight7' + `freq8'*`weight8' + `freq9'*`weight9' + `freq10'*`weight10' + `freq11'*`weight11' + `freq12'*`weight12')
			lincom (_b[_IlagXlag2_1]*`freq1'*`weight1' + _b[_IlagXlag2_2]*`freq2'*`weight2' + _b[_IlagXlag2_3]*`freq3'*`weight3' + _b[_IlagXlag2_4]*`freq4'*`weight4' + _b[_IlagXlag2_5]*`freq5'*`weight5' + _b[_IlagXlag2_6]*`freq6'*`weight6' + _b[_IlagXlag2_7]*`freq7'*`weight7' + _b[_IlagXlag2_8]*`freq8'*`weight8' + _b[_IlagXlag2_9]*`freq9'*`weight9' + _b[_IlagXlag2_10]*`freq10'*`weight10' + _b[_IlagXlag2_11]*`freq11'*`weight11' + _b[_IlagXlag2_12]*`freq12'*`weight12')/`totalestobs'
			local C = r(estimate)
			local SE = r(se)
			replace matching_rf_fs_coeff_ny`w' = `C' in `i'
			replace matching_rf_fs_se_ny`w' = `SE' in `i'
			replace matching_N_ny`w' = e(N) in `i'		
			forvalues j = 1(1)12 {
				local fs`j' = 1 + matching_fs_coeff_`w'_`j'[`i']
				local fs_se`j' = matching_fs_se_`w'_`j'[`i']
			}
			lincom (_b[_IlagXlag2_1]*`freq1'*`weight1'/`fs1' + _b[_IlagXlag2_2]*`freq2'*`weight2'/`fs2' + _b[_IlagXlag2_3]*`freq3'*`weight3'/`fs3' + _b[_IlagXlag2_4]*`freq4'*`weight4'/`fs4' + _b[_IlagXlag2_5]*`freq5'*`weight5'/`fs5' + _b[_IlagXlag2_6]*`freq6'*`weight6'/`fs6' + _b[_IlagXlag2_7]*`freq7'*`weight7'/`fs7' + _b[_IlagXlag2_8]*`freq8'*`weight8'/`fs8' + _b[_IlagXlag2_9]*`freq9'*`weight9'/`fs9' + _b[_IlagXlag2_10]*`freq10'*`weight10'/`fs10' + _b[_IlagXlag2_11]*`freq11'*`weight11'/`fs11' + _b[_IlagXlag2_12]*`freq12'*`weight12'/`fs12')/`totalestobs'
			local C = r(estimate)
			local SE = (((_se[_IlagXlag2_1]/(`fs1'))^2 + (`fs_se1'*_b[_IlagXlag2_1]/(`fs1')^2)^2)*(`freq1'*`weight1'/`totalestobs')^2 +  ((_se[_IlagXlag2_2]/(`fs2'))^2 + (`fs_se2'*_b[_IlagXlag2_2]/(`fs2')^2)^2)*(`freq2'*`weight2'/`totalestobs')^2 +  ((_se[_IlagXlag2_3]/(`fs3'))^2 + (`fs_se3'*_b[_IlagXlag2_3]/(`fs3')^2)^2)*(`freq3'*`weight3'/`totalestobs')^2 +  ((_se[_IlagXlag2_4]/(`fs4'))^2 + (`fs_se4'*_b[_IlagXlag2_4]/(`fs4')^2)^2)*(`freq4'*`weight4'/`totalestobs')^2 +  ((_se[_IlagXlag2_5]/(`fs5'))^2 + (`fs_se5'*_b[_IlagXlag2_5]/(`fs5')^2)^2)*(`freq5'*`weight5'/`totalestobs')^2 +  ((_se[_IlagXlag2_6]/(`fs6'))^2 + (`fs_se6'*_b[_IlagXlag2_6]/(`fs6')^2)^2)*(`freq6'*`weight6'/`totalestobs')^2 +  ((_se[_IlagXlag2_7]/(`fs7'))^2 + (`fs_se7'*_b[_IlagXlag2_7]/(`fs7')^2)^2)*(`freq7'*`weight7'/`totalestobs')^2 +  ((_se[_IlagXlag2_8]/(`fs8'))^2 + (`fs_se8'*_b[_IlagXlag2_8]/(`fs8')^2)^2)*(`freq8'*`weight8'/`totalestobs')^2 +  ((_se[_IlagXlag2_9]/(`fs9'))^2 + (`fs_se9'*_b[_IlagXlag2_9]/(`fs9')^2)^2)*(`freq9'*`weight9'/`totalestobs')^2 +  ((_se[_IlagXlag2_10]/(`fs10'))^2 + (`fs_se10'*_b[_IlagXlag2_10]/(`fs10')^2)^2)*(`freq10'*`weight10'/`totalestobs')^2 +  ((_se[_IlagXlag2_11]/(`fs11'))^2 + (`fs_se11'*_b[_IlagXlag2_11]/(`fs11')^2)^2)*(`freq11'*`weight11'/`totalestobs')^2 +  ((_se[_IlagXlag2_12]/(`fs12'))^2 + (`fs_se12'*_b[_IlagXlag2_12]/(`fs12')^2)^2)*(`freq12'*`weight12'/`totalestobs')^2)^0.5	
			replace matching_fs_coeff_ny`w' = `C' in `i'
			replace matching_fs_se_ny`w' = `SE' in `i'
			local i = `i' + 1
		}
	}
	drop overall

	capture: drop total_N_ny matching_fs_coeff_ny matching_fs_se_ny matching_rf_fs_coeff_ny matching_rf_fs_se_ny matching_N_ny
	gen total_N_ny = matching_N_ny1 + matching_N_ny2 + matching_N_ny3 + matching_N_ny4 + matching_N_ny5 + matching_N_ny6 + matching_N_ny7 + matching_N_ny8 + matching_N_ny9 + matching_N_ny10 + matching_N_ny11 + matching_N_ny12
	gen matching_rf_fs_coeff_ny = matching_rf_fs_coeff_ny1*(matching_N_ny1/total_N_ny) + matching_rf_fs_coeff_ny2*(matching_N_ny2/total_N_ny) + matching_rf_fs_coeff_ny3*(matching_N_ny3/total_N_ny) + matching_rf_fs_coeff_ny4*(matching_N_ny4/total_N_ny) + matching_rf_fs_coeff_ny5*(matching_N_ny5/total_N_ny) + matching_rf_fs_coeff_ny6*(matching_N_ny6/total_N_ny) + matching_rf_fs_coeff_ny7*(matching_N_ny7/total_N_ny) + matching_rf_fs_coeff_ny8*(matching_N_ny8/total_N_ny) + matching_rf_fs_coeff_ny9*(matching_N_ny9/total_N_ny) + matching_rf_fs_coeff_ny10*(matching_N_ny10/total_N_ny) + matching_rf_fs_coeff_ny11*(matching_N_ny11/total_N_ny) + matching_rf_fs_coeff_ny12*(matching_N_ny12/total_N_ny)
	gen matching_rf_fs_se_ny = ((matching_rf_fs_se_ny1^2)*(matching_N_ny1/total_N_ny)^2 + (matching_rf_fs_se_ny2^2)*(matching_N_ny2/total_N_ny)^2 + (matching_rf_fs_se_ny3^2)*(matching_N_ny3/total_N_ny)^2 + (matching_rf_fs_se_ny4^2)*(matching_N_ny4/total_N_ny)^2 + (matching_rf_fs_se_ny5^2)*(matching_N_ny5/total_N_ny)^2 + (matching_rf_fs_se_ny6^2)*(matching_N_ny6/total_N_ny)^2 + (matching_rf_fs_se_ny7^2)*(matching_N_ny7/total_N_ny)^2 + (matching_rf_fs_se_ny8^2)*(matching_N_ny8/total_N_ny)^2 + (matching_rf_fs_se_ny9^2)*(matching_N_ny9/total_N_ny)^2 + (matching_rf_fs_se_ny10^2)*(matching_N_ny10/total_N_ny)^2 + (matching_rf_fs_se_ny11^2)*(matching_N_ny11/total_N_ny)^2 + (matching_rf_fs_se_ny12^2)*(matching_N_ny12/total_N_ny)^2)^0.5
	gen matching_fs_coeff_ny = matching_fs_coeff_ny1*(matching_N_ny1/total_N_ny) + matching_fs_coeff_ny2*(matching_N_ny2/total_N_ny) + matching_fs_coeff_ny3*(matching_N_ny3/total_N_ny) + matching_fs_coeff_ny4*(matching_N_ny4/total_N_ny) + matching_fs_coeff_ny5*(matching_N_ny5/total_N_ny) + matching_fs_coeff_ny6*(matching_N_ny6/total_N_ny) + matching_fs_coeff_ny7*(matching_N_ny7/total_N_ny) + matching_fs_coeff_ny8*(matching_N_ny8/total_N_ny) + matching_fs_coeff_ny9*(matching_N_ny9/total_N_ny) + matching_fs_coeff_ny10*(matching_N_ny10/total_N_ny) + matching_fs_coeff_ny11*(matching_N_ny11/total_N_ny) + matching_fs_coeff_ny12*(matching_N_ny12/total_N_ny)
	gen matching_fs_se_ny = ((matching_fs_se_ny1^2)*(matching_N_ny1/total_N_ny)^2 + (matching_fs_se_ny2^2)*(matching_N_ny2/total_N_ny)^2 + (matching_fs_se_ny3^2)*(matching_N_ny3/total_N_ny)^2 + (matching_fs_se_ny4^2)*(matching_N_ny4/total_N_ny)^2 + (matching_fs_se_ny5^2)*(matching_N_ny5/total_N_ny)^2 + (matching_fs_se_ny6^2)*(matching_N_ny6/total_N_ny)^2 + (matching_fs_se_ny7^2)*(matching_N_ny7/total_N_ny)^2 + (matching_fs_se_ny8^2)*(matching_N_ny8/total_N_ny)^2 + (matching_fs_se_ny9^2)*(matching_N_ny9/total_N_ny)^2 + (matching_fs_se_ny10^2)*(matching_N_ny10/total_N_ny)^2 + (matching_fs_se_ny11^2)*(matching_N_ny11/total_N_ny)^2 + (matching_fs_se_ny12^2)*(matching_N_ny12/total_N_ny)^2)^0.5
	gen matching_N_ny = max(matching_N_ny1, matching_N_ny2, matching_N_ny3, matching_N_ny4, matching_N_ny5, matching_N_ny6, matching_N_ny7, matching_N_ny8, matching_N_ny9, matching_N_ny10, matching_N_ny11, matching_N_ny12)

	local obscounter = 1
	local varcounter = 1
	while `obscounter'<=20 {
		local secounter = `obscounter' + 1
		replace fs_ny_N = matching_N_ny[`varcounter'] in `obscounter'
		if `3'==0 {
			replace fs_ny_result = matching_rf_fs_coeff_ny[`varcounter'] in `obscounter'
			replace fs_ny_result = matching_fs_se_ny[`varcounter'] in `secounter'
			replace fs_ny_pval = 2*ttail(105,abs(matching_rf_fs_coeff_ny[`varcounter']/matching_fs_se_ny[`varcounter'])) in `obscounter'	
		}
		else {
			replace fs_ny_result = matching_fs_coeff_ny[`varcounter'] in `obscounter'
			replace fs_ny_result = matching_fs_se_ny[`varcounter'] in `secounter'
			replace fs_ny_pval = 2*ttail(105,abs(matching_fs_coeff_ny[`varcounter']/matching_fs_se_ny[`varcounter'])) in `obscounter'
		}		
		local varcounter = `varcounter' + 1
		local obscounter = `obscounter' + 2
	}
	drop _I*
	xi i.year

	capture: drop ols_result_seq
	capture: drop ols_result_wgt_seq
	capture: drop ols_pval_seq
	capture: drop ols_N_seq
	capture: drop ldv_result_seq
	capture: drop ldv_result_wgt_seq
	capture: drop ldv_pval_seq
	capture: drop ldv_N_seq
	capture: drop ldv_se_wgt_seq

	gen ols_result_seq = .
	gen ols_result_wgt_seq = .
	gen ols_pval_seq = .
	gen ols_N_seq = .
	gen ldv_result_seq = .
	gen ldv_result_wgt_seq = .
	gen ldv_pval_seq = .
	gen ldv_N_seq = .
	gen ldv_se_wgt_seq = .
	local counter = 1

	capture: drop rseasonwins
	capture: drop rseasongames
	gen rseasonwins = lag2_seasonwins - lag4_seasonwins
	gen rseasongames = lag2_seasongames - lag4_seasongames

	foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
		capture: drop r`varname'
		gen r`varname' = `varname' - lag3_`varname'
		reg r`varname' rseasonwins lag4_seasonwins lag2_seasongames lag4_seasongames _Iyear* if `1' & lag2_ipw_weight<`2' [aw=lag2_ipw_weight], vce(cluster school_id)
		replace ldv_result_seq = _b[rseasonwins] in `counter'
		replace ldv_pval_seq =  2*ttail(e(N_clust),abs(_b[rseasonwins]/_se[rseasonwins])) in `counter'
		replace ldv_N_seq = e(N) in `counter'
		local counter = `counter' + 1
		replace ldv_result_seq = _se[rseasonwins] in `counter'
		local counter = `counter' + 1
	}
end
}

************************************************************
*** TABLE CODE (most tables call programs defined above) ***
************************************************************

**************************
* Table 1: Summary Stats *
**************************

capture: drop variable_name 
capture: drop mean
capture: drop std_dev
capture: drop sample_size
capture: drop teams
capture: drop first_year
capture: drop last_year

gen variable_name = ""
gen mean = .
gen std_dev = .
gen sample_size = .
gen int teams = .
gen first_year = .
gen last_year = .
local counter = 1
foreach varname of varlist lag_seasonwins lag_seasongames lag_exp_wins alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
	sum `varname'
	replace variable_name = "`varname'" in `counter'
	replace mean = r(mean) in `counter'
	replace std_dev = r(sd) in `counter'
	replace sample_size = r(N) in `counter'
	sum year if `varname'!=.
	replace first_year = r(min) in `counter'
	replace last_year = r(max) in `counter'
	local counter = `counter' + 1
}

local counter = `counter' + 2

foreach varname of varlist lag_seasonwins lag_seasongames lag_exp_wins alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
	sum `varname' if bcs==1
	replace variable_name = "`varname'" in `counter'
	replace mean = r(mean) in `counter'
	replace std_dev = r(sd) in `counter'
	replace sample_size = r(N) in `counter'
	sum year if `varname'!=.
	replace first_year = r(min) in `counter'
	replace last_year = r(max) in `counter'
	tab teamname if `varname'!=. & bcs==1
	replace teams = r(r) in `counter'
	local counter = `counter' + 1
}

local counter = `counter' + 2

foreach varname of varlist lag_seasonwins lag_seasongames lag_exp_wins alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
	sum `varname' if bcs==0
	replace variable_name = "`varname'" in `counter'
	replace mean = r(mean) in `counter'
	replace std_dev = r(sd) in `counter'
	replace sample_size = r(N) in `counter'
	sum year if `varname'!=.
	replace first_year = r(min) in `counter'
	replace last_year = r(max) in `counter'
	tab teamname if `varname'!=. & bcs==0
	replace teams = r(r) in `counter'
	local counter = `counter' + 1
}

browse variable_name-last_year

***************************************
* Table 2: Checking Covariate Balance *
***************************************

*** Choose sample (all/BCS/non-BCS)
local bcs "bcs<=1"
sum lead2_ipw_weight, det
local trim_value = r(p90)
local iv_flag = 1

placebo_results `bcs' `trim_value' `iv_flag'

browse variable_name ldv_result ldv_pval ldv_N ldv_result_seq ldv_pval_seq ldv_N_seq


******************************************
* Table 3: Matching Diff and STE Results *
******************************************

*** Choose sample (all/BCS/non-BCS)
local bcs "bcs<=1"
sum lag_ipw_weight, det
local trim_value = r(p90)
local iv_flag = 1
local cluster_school "vce(cluster school_id)"

main_results `bcs' `trim_value' `iv_flag' "`cluster_school'"

if `iv_flag'==0 {
	browse variable_name ldv_result ldv_pval_rf ldv_N ldv_result_seq ldv_pval_seq ldv_N_seq
}
else {
	browse variable_name ldv_result ldv_pval ldv_N ldv_result_seq ldv_pval_seq ldv_N_seq
}

// Graphical results
cd "~/Desktop/Research/College Sports/Temp" 
local table_counter = 1
local results_counter = 0
foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
	reg r`varname' lag3_seasonwins lag_seasongames lag3_seasongames _Iyear* if lag_ipw_weight<`trim_value' & `bcs' & lag_seasonwins!=. [aw=lag_ipw_weight], vce(cluster school_id)
	capture: drop r`varname'_resid
	predict r`varname'_resid if e(sample), resid
	sum r`varname' if e(sample), meanonly
	replace r`varname'_resid = r`varname'_resid + r(mean)
	reg rseasonwins lag3_seasonwins lag_seasongames lag3_seasongames _Iyear* if lag_ipw_weight<`trim_value' & `bcs' & e(sample) [aw=lag_ipw_weight], vce(cluster school_id)
	capture: drop rseasonwins_resid
	predict rseasonwins_resid if e(sample), resid
	sum rseasonwins if e(sample), meanonly
	replace rseasonwins_resid = rseasonwins_resid + r(mean)
}

foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
	if "`varname'"=="alumni_ops_athletics" | "`varname'"=="alum_non_athl_ops" | "`varname'"=="alumni_total_giving" {
		replace r`varname'_resid = r`varname'_resid/1000000
		label var r`varname'_resid "Millions of dollars"
	}
	if "`varname'"=="vse_alum_giving_rate" {
		label var r`varname'_resid "Share"		
	}
	if "`varname'"=="usnews_academic_rep_new" | "`varname'"=="sat_25" {
		label var r`varname'_resid "Points"		
	}
	if "`varname'"=="acceptance_rate" {
		label var r`varname'_resid "Share"		
		replace r`varname'_resid = r`varname'_resid/100
	}
	if "`varname'"=="applicants" | "`varname'"=="firsttime_outofstate" | "`varname'"=="first_time_instate" {
		label var r`varname'_resid "Students"		
	}
}

local alumni_ops_athleticstxt = "Athletic Operating Donations"
local alum_non_athl_opstxt = "Nonathletic Operating Donations"
local alumni_total_givingtxt = "Total Alumni Donations"
local vse_alum_giving_ratetxt "Alumni Giving Rate"
local usnews_academic_rep_newtxt = "Academic Reputation"
local applicantstxt = "Applicants"
local acceptance_ratetxt = "Acceptance Rate"
local firsttime_outofstatetxt = "First-Time Out-of-State Enrollment"
local first_time_instatetxt = "First-Time In-State Enrollment"
local sat_25txt = "25th Percentile SAT Score"

local counter = 1
foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
	lpoly r`varname'_resid rseasonwins_resid [aw=lag_ipw_weight], noscatter ci bw(2) lwidth(thin) lcolor(gs6) xlabel(-6(3)6, labsize(medlarge)) ylabel(, labsize(medlarge)) title("Panel `counter': Effect of Wins on ``varname'txt'", size(large) color(black)) xtitle(Change in Wins, size(medlarge)) ytitle(, size(medlarge)) note("") legend(off)
	graph save "gph_`counter'", replace
	local counter = `counter' + 1
}


***********************************************
* Table 4: Matching Diff and STE Results, BCS *
***********************************************

*** Choose sample (all/BCS/non-BCS)
local bcs "bcs==1"
sum lag_ipw_weight, det
local trim_value = r(p90)
local iv_flag = 1
local cluster_school "vce(cluster school_id)"

main_results `bcs' `trim_value' `iv_flag' "`cluster_school'"

if `iv_flag'==0 {
	browse variable_name ldv_result ldv_pval_rf ldv_N ldv_result_seq ldv_pval_seq ldv_N_seq
}
else {
	browse variable_name ldv_result ldv_pval ldv_N ldv_result_seq ldv_pval_seq ldv_N_seq
}

***************************************************
* Table 5: Matching Diff and STE Results, Non-BCS *
***************************************************

*** Choose sample (all/BCS/non-BCS)
local bcs "bcs==0"
sum lag_ipw_weight, det
local trim_value = r(p90)
local iv_flag = 1
local cluster_school "vce(cluster school_id)"

main_results `bcs' `trim_value' `iv_flag' "`cluster_school'"

if `iv_flag'==0 {
	browse variable_name ldv_result ldv_pval_rf ldv_N ldv_result_seq ldv_pval_seq ldv_N_seq
}
else {
	browse variable_name ldv_result ldv_pval ldv_N ldv_result_seq ldv_pval_seq ldv_N_seq
}


*******************************************************
* Table 6: Matching OLS and Diff Results For Weeks 5+ *
*******************************************************

*** Choose sample (all/BCS/non-BCS)
local bcs "bcs<=1"
sum lag_ipw_weight_5, det
local trim_value = r(p90)
local iv_flag = 1

main_results_5 `bcs' `trim_value' `iv_flag'

if `iv_flag'==0 {
	browse variable_name ldv_result ldv_pval_rf ldv_N ldv_result_seq ldv_pval_seq ldv_N_seq
}
else {
	browse variable_name ldv_result ldv_pval ldv_N ldv_result_seq ldv_pval_seq ldv_N_seq
}

*************************************************
*** Table 7: Matching results with 2 YEAR LAG ***
*************************************************

*** Choose sample (all/BCS/non-BCS)
local bcs "bcs<=1"
sum lag2_ipw_weight, det
local trim_value = r(p90)
local iv_flag = 1

main_results_2yr `bcs' `trim_value' `iv_flag'

browse variable_name ldv_result ldv_pval ldv_N fs_ny_result

dis "NOTE: To match Table 7, you must subtract the product of fs_ny_result and the first column in Table 7 from ldv_result. This nets out the effect on the outcome that is due to teams winning in year t-2 being more likely to also win in year t-1."

***************************************************
* Table A1: Unexpected Losses vs. Unexpected Wins *
***************************************************

// For unexpected losses, set the following line to "local unexp_wins = 0"
// For unexpected wins, set the following line to "local unexp_wins = 1"

local unexp_wins = 0

set more off

*** Open college data

use "college data.dta"
sort teamname year

*** Keep variables we intend to use

keep teamname year athletics_total alumni_ops_athletics alumni_ops_total ops_athletics_total_grand usnews_academic_rep_new acceptance_rate appdate satdate satmt75 satvr75 satmt25 satvr25 applicants_male applicants_female enrolled_male enrolled_female vse_alum_giving_rate first_time_students_total first_time_outofstate first_time_instate total_giving_pre_2004 alumni_total_giving asian hispanic black control
save temp.dta, replace

use "covers_data.dta"

*** Fix errors in data

drop if team==68 & date==14568 & line==.
drop if team==136 & date==14568 & line==.

*** Generate a week variable

sort team season date
gen week = 1 in 1

local obs_counter = 2
local week_counter = 2
local end_counter = _N

while `obs_counter'<=`end_counter' {
	if season[`obs_counter']!=season[`obs_counter'-1] | team[`obs_counter']!=team[`obs_counter'-1] {
		local week_counter = 1
	}
	quietly replace week = `week_counter' in `obs_counter'
	local week_counter = `week_counter' + 1
	local obs_counter = `obs_counter' + 1
}

*** Drop out any games that could potentially be conference championship games and games with no line

keep if week<=12 & month!=12 & month!=1
sort teamname season week
by teamname season: egen total_obs = count(line)
keep if total_obs>=8
replace win = . if line==.

*** Estimate the single game propensity score as a function of the betting line

forvalues i = 2(1)5 {
	gen line`i' = line^`i'
}
logit win line line2 line3 line4 line5
predict pscore
sum pscore, det

// Generate measure of how much the team over/underperforms the spread

gen outperform = realspread+line

// Generate variables to hold outperform measure (and quadratic in line for comparison) for each week of the season
// Treat obs with missing lines as neither under nor overperforming

sort teamname season week
forvalues i=1(1)11 {
	gen outperform_wk`i'_temp = outperform if week==`i'
	by teamname season: egen outperform_wk`i' = mean(outperform_wk`i'_temp)
	replace outperform_wk`i' = 0 if outperform_wk`i'==.
	drop outperform_wk`i'_temp
	gen outperformwk`i'_2 = outperform_wk`i'^2
	gen outperformwk`i'_3 = outperform_wk`i'^3	
}

// Regress line in week i on cubic of outperform in all previous weeks and take residuals to condition out the portion of the line in week i that is due to team's over/underperformance in previous weeks

gen line_clean = line if week==1
forvalues i=2(1)12 {
	local lag = `i' - 1
	reg line outperform_wk1-outperformwk`lag'_3 if week==`i'
	predict line_clean`i' if week==`i', resid
	replace line_clean`i' = line_clean`i' + _b[_cons]
	replace line_clean = line_clean`i' if week==`i'
}

// Estimate propensity score using the "clean" betting line that has been purged of team over/underperformance

forvalues i = 2(1)5 {
	gen line_clean_p`i' = line_clean^`i'
}
logit win line_clean line_clean_p2 line_clean_p3 line_clean_p4 line_clean_p5
predict pscore_clean_line
sum pscore_clean_line, det

// Generate season aggregate measures

sort teamname season week
by teamname season: egen seasonwins = total(win)
by teamname season: egen seasongames = count(win)
by teamname season: egen seasonspread = total(realspread)
by teamname season: egen seasonline = total(line)
by teamname season: egen seasonoutperform = total(outperform)
gen pct_win = seasonwins/seasongames
assert pct_win>=0 & pct_win<=1 if pct_win!=.

// Generate expected win measures (clean and naive)

by teamname season: egen exp_wins_naive = total(pscore)
by teamname season: egen exp_wins = total(pscore_clean_line)
gen exp_win_pct = exp_wins/seasongames
forvalues w = 1(1)11 {
	by teamname season: egen exp_wins_wk`w' = total(pscore) if week>`w'
}
gen exp_wins_wk12 = 0

// Generate weekly measures of wins, pscores, etc.

if `unexp_wins'==0 {
	replace pscore=. if pscore<0.5
}
else {
	if `unexp_wins'==1 {
		replace pscore=. if pscore>=0.5
		}
	else {
		dis "ERROR: Unexpected value for unexpected wins/losses macro"
		clear
		BREAK
	}
}

sort teamname season week
forvalues i=1(1)12 {
	gen pscore_wk`i'_temp = pscore if week==`i'
	by teamname season: egen pscore_wk`i' = mean(pscore_wk`i'_temp)
	drop pscore_wk`i'_temp
	gen win_wk`i'_temp = win if week==`i'
	by teamname season: egen win_wk`i' = mean(win_wk`i'_temp)
	drop win_wk`i'_temp
}

collapse (mean) seasongames seasonwins seasonspread seasonline seasonoutperform pct_win exp_wins_naive exp_wins exp_win_pct exp_wins_wk1-exp_wins_wk12 bcs pscore_wk1-win_wk12, by(teamname season)
rename season year
sort teamname year
merge teamname year using temp.dta
!rm temp.dta
tab _merge
drop if _merge==1 | _merge==2
drop _merge

sort teamname year

*** Variables of interest

*** Generate variables for analysis

sort teamname year
foreach varname of varlist seasongames-pct_win exp_wins exp_wins_wk1-exp_wins_wk12 exp_win_pct pscore_wk1-win_wk12 {
	gen lag_`varname' = `varname'[_n-1] if teamname==teamname[_n-1] & year==year[_n-1]+1
	gen lag2_`varname' = `varname'[_n-2] if teamname==teamname[_n-2] & year==year[_n-1]+1 & year==year[_n-2]+2
	gen lag3_`varname' = `varname'[_n-3] if teamname==teamname[_n-3] & year==year[_n-1]+1 & year==year[_n-2]+2 & year==year[_n-3]+3
	gen lag4_`varname' = `varname'[_n-4] if teamname==teamname[_n-4] & year==year[_n-1]+1 & year==year[_n-2]+2 & year==year[_n-3]+3 & year==year[_n-4]+4
	gen lead_`varname' = `varname'[_n+1] if teamname==teamname[_n+1] & year==year[_n+1]-1
	gen lead2_`varname' = `varname'[_n+2] if teamname==teamname[_n+2] & year==year[_n+1]-1 & year==year[_n+2]-2
}

egen school_id = group(teamname)
xi i.year
xtset school_id

// Deal with special reporting dates for SAT scores and applicants

sort teamname year
foreach varname of varlist satmt25 satmt75 satvr25 satvr75 {
	gen `varname'_temp = `varname'
	replace `varname'_temp = . if satdate==1
	replace `varname'_temp = `varname'[_n+1] if `varname'_temp==. & satdate[_n+1]==1 & teamname[_n+1]==teamname & year[_n+1]==year+1
	drop `varname'
	rename `varname'_temp `varname'
} 

foreach varname of varlist applicants_male applicants_female enrolled_male enrolled_female {
	gen `varname'_temp = `varname'
	replace `varname'_temp = . if appdate==1
	replace `varname'_temp = `varname'[_n+1] if `varname'_temp==. & appdate[_n+1]==1 & teamname[_n+1]==teamname & year[_n+1]==year+1
	drop `varname'
	rename `varname'_temp `varname'
} 

sort teamname year
foreach varname of varlist satmt25 satmt75 satvr25 satvr75 {
	gen `varname'_temp = `varname'
	replace `varname'_temp = `varname'[_n+1] if teamname[_n+1]==teamname & year[_n+1]==year+1
	drop `varname'
	rename `varname'_temp `varname'
} 

foreach varname of varlist applicants_male applicants_female enrolled_male enrolled_female {
	gen `varname'_temp = .
	replace `varname'_temp = `varname'[_n+1] if teamname[_n+1]==teamname & year[_n+1]==year+1
	drop `varname'
	rename `varname'_temp `varname'
} 

gen athletics_share = alumni_ops_athletics/alumni_ops_total if alumni_ops_athletics/alumni_ops_total>.05 & alumni_ops_athletics/alumni_ops_total<.8
gen alum_non_athl_ops = alumni_ops_total - alumni_ops_athletics
gen sat_75 = satmt75 + satvr75
gen sat_25 = satmt25 + satvr25
gen applicants = applicants_male + applicants_female
drop appdate satdate

rename ops_athletics_total_grand ops_athl_grndtotal
rename first_time_students_total firsttime_total
rename first_time_outofstate firsttime_outofstate

sort teamname year

foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 sat_75 {
	gen lag_`varname' = `varname'[_n-1] if teamname==teamname[_n-1] & year==year[_n-1]+1
	gen lag2_`varname' = `varname'[_n-2] if teamname==teamname[_n-2] & year==year[_n-2]+2
	gen lag3_`varname' = `varname'[_n-3] if teamname==teamname[_n-3] & year==year[_n-3]+3
	gen lag4_`varname' = `varname'[_n-4] if teamname==teamname[_n-4] & year==year[_n-4]+4
}


****************************
*** Run matching results ***
****************************

// Create matching bins

*** Choose sample (all/BCS/non-BCS)
local bcs "bcs<=1"

// Note: Group sizes will not be perfectly balanced because there is clustering in p-scores (spreads are in 0.5 unit increments)
forvalues w = 1(1)12 {
	capture: drop lag_pscore_wk`w'_group
	foreach varname of varlist lag_pscore_wk`w' {
		sum lag_pscore_wk`w' if lag_win_wk`w'==1 & `bcs'
		local min_treated = max(r(min),0.05)
*		local min_treated = r(min)
		sum lag_pscore_wk`w' if lag_win_wk`w'==0 & `bcs'
		local max_treated = min(r(max), 0.95)
*		local max_treated = r(max)
		centile `varname' if `bcs' & `varname'>=`min_treated' & `varname'<=`max_treated', centile(20(20)80)
		gen `varname'_group = .
		forvalues i = 2(1)4 {
			local iminus1 = `i' - 1
			local bottom_centile = r(c_`iminus1') 
			local top_centile = r(c_`i') 
			replace `varname'_group = `i' if `varname'>=`bottom_centile' & `varname'<`top_centile' & `bcs'
		}	
		replace `varname'_group = 1 if `varname'<r(c_1) & `bcs' & `varname'>=`min_treated'
		replace `varname'_group = 5 if `varname'>=r(c_4) & `varname'!=. & `bcs' & `varname'<=`max_treated'
	}
}


*********************************
* Matching OLS and Diff Results *
*********************************

capture: drop variable_name 
capture: drop ols_result
capture: drop ols_pval
capture: drop ols_N
capture: drop ldv_result
capture: drop ldv_pval
capture: drop ldv_N

gen variable_name = ""
gen ols_result = .
gen ols_pval = .
gen ols_N = .
gen ldv_result = .
gen ldv_pval = .
gen ldv_N = .

// Run first stage for matching regressions

capture: drop matching_dep_var
gen str40 matching_dep_var = ""

forvalues w = 1(1)12 {
	xi i.lag_pscore_wk`w'_group*lag_win_wk`w' i.lag_pscore_wk`w'_group*lag_pscore_wk`w', noomit
	reg lag_exp_wins_wk`w' _Ilag* if `bcs', vce(cluster school_id) noconstant
	tab lag_pscore_wk`w'_group if e(sample), matcell(freqmat) matrow(valmat)
	local totalestobs = r(N)
	svmat valmat, names(val)
	svmat freqmat, names(freq)	
	forvalues j = 1(1)5 {
		quietly sum freq1 if val1==`j' in 1/5
		if r(N)==1 {
			if r(mean)>3 {
				local freq`j' =	r(mean)			
			}
			else {
				local freq`j' = 0
			}
		}
		else {
			local freq`j' = 0
		}
	}
	drop val1 freq1
	capture: drop matching_fs_coeff_lhs_`w'
	gen matching_fs_coeff_lhs_`w' = .
	gen group = _n in 1/5
	gen groupsq = group^2 in 1/5
	forvalues j = 1(1)5 {
		replace matching_fs_coeff_lhs_`w' = _b[_IlagXlag_w_`j'] in `j'
	}
	reg matching_fs_coeff_lhs_`w' group groupsq
	predict matching_fs_coeff_`w'_pred in 1/5
	predict matching_fs_coeff_`w'_pred_se in 1/5, stdp
	drop group groupsq
	forvalues j = 1(1)5 {
		capture: drop matching_fs_coeff_`w'_`j' matching_fs_se_`w'_`j'
		gen matching_fs_coeff_`w'_`j' = matching_fs_coeff_`w'_pred[`j'] in 1/30
		gen matching_fs_se_`w'_`j' = matching_fs_coeff_`w'_pred_se[`j'] in 1/30
	}
	drop matching_fs_coeff_`w'_pred matching_fs_coeff_`w'_pred_se
	if `w'==12 {
		forvalues j = 1(1)5 {	
			replace matching_fs_coeff_`w'_`j' = 0 in 1/30
			replace matching_fs_se_`w'_`j' = 0 in 1/30
		}
	}
}

// Run reduced form for matching regressions

forvalues w = 1(1)12 {
	capture: drop matching_coeff_`w' matching_se_`w' matching_rf_coeff_`w' matching_rf_se_`w' matching_N_`w'
	local i = 1
	gen float matching_coeff_`w' = .
	gen float matching_se_`w' = .
	gen float matching_N_`w' = .
	gen float matching_rf_coeff_`w' = .
	gen float matching_rf_se_`w' = .
	xi i.lag_pscore_wk`w'_group*lag_win_wk`w' i.lag_pscore_wk`w'_group*lag_pscore_wk`w', noomit
	foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
		replace matching_dep_var = "`varname'" in `i'
		reg `varname' _Ilag* if `bcs', vce(cluster school_id) noconstant
		tab lag_pscore_wk`w'_group if e(sample), matcell(freqmat) matrow(valmat)
		local totalestobs = r(N)
		svmat valmat, names(val)
		svmat freqmat, names(freq)	
		forvalues j = 1(1)5 {
			quietly sum freq1 if val1==`j' in 1/5
			if r(N)==1 {
				if r(mean)>3 {
					local freq`j' =	r(mean)			
				}
				else {
					local freq`j' = 0
				}
			}
			else {
				local freq`j' = 0
			}
		}
		drop val1 freq1
		// Enforce overlap: drop any cells with less than 2 wins or losses
		forvalues j = 1(1)5 {
			sum lag_win_wk`w' if e(sample) & lag_pscore_wk`w'_group==`j' & lag_win_wk`w'==1
			local wincount = r(N)
			sum lag_win_wk`w' if e(sample) & lag_pscore_wk`w'_group==`j' & lag_win_wk`w'==0
			local losscount = r(N)
			if min(`wincount',`losscount')<2 {
				local weight`j' = 0
			}
			else {
				local weight`j' = 1
			}
		}
		local totalestobs = (`freq1'*`weight1' + `freq2'*`weight2' + `freq3'*`weight3' + `freq4'*`weight4' + `freq5'*`weight5')
		lincom (_b[_IlagXlag_w_1]*`freq1'*`weight1' + _b[_IlagXlag_w_2]*`freq2'*`weight2' + _b[_IlagXlag_w_3]*`freq3'*`weight3' + _b[_IlagXlag_w_4]*`freq4'*`weight4' + _b[_IlagXlag_w_5]*`freq5'*`weight5')/`totalestobs'
		local C = r(estimate)
		local SE = r(se)
		replace matching_rf_coeff_`w' = `C' in `i'
		replace matching_rf_se_`w' = `SE' in `i'
		replace matching_N_`w' = e(N) in `i'		
		forvalues j = 1(1)5 {
			local fs`j' = 1 + matching_fs_coeff_`w'_`j'[`i']
			local fs_se`j' = matching_fs_se_`w'_`j'[`i']
		}
		lincom (_b[_IlagXlag_w_1]*`freq1'*`weight1'/`fs1' + _b[_IlagXlag_w_2]*`freq2'*`weight2'/`fs2' + _b[_IlagXlag_w_3]*`freq3'*`weight3'/`fs3' + _b[_IlagXlag_w_4]*`freq4'*`weight4'/`fs4' + _b[_IlagXlag_w_5]*`freq5'*`weight5'/`fs5')/`totalestobs'
		local C = r(estimate)
		local SE = (((_se[_IlagXlag_w_1]/(`fs1'))^2 + (`fs_se1'*_b[_IlagXlag_w_1]/(`fs1')^2)^2)*(`freq1'*`weight1'/`totalestobs')^2 +  ((_se[_IlagXlag_w_2]/(`fs2'))^2 + (`fs_se2'*_b[_IlagXlag_w_2]/(`fs2')^2)^2)*(`freq2'*`weight2'/`totalestobs')^2 +  ((_se[_IlagXlag_w_3]/(`fs3'))^2 + (`fs_se3'*_b[_IlagXlag_w_3]/(`fs3')^2)^2)*(`freq3'*`weight3'/`totalestobs')^2 +  ((_se[_IlagXlag_w_4]/(`fs4'))^2 + (`fs_se4'*_b[_IlagXlag_w_4]/(`fs4')^2)^2)*(`freq4'*`weight4'/`totalestobs')^2 +  ((_se[_IlagXlag_w_5]/(`fs5'))^2 + (`fs_se5'*_b[_IlagXlag_w_5]/(`fs5')^2)^2)*(`freq5'*`weight5'/`totalestobs')^2)^0.5	
		replace matching_coeff_`w' = `C' in `i'
		replace matching_se_`w' = `SE' in `i'
		local i = `i' + 1
	}
}

capture: drop total_N matching_coeff matching_se matching_rf_coeff matching_rf_se matching_N
gen total_N = matching_N_1 + matching_N_2 + matching_N_3 + matching_N_4 + matching_N_5 + matching_N_6 + matching_N_7 + matching_N_8 + matching_N_9 + matching_N_10 + matching_N_11 + matching_N_12
gen matching_rf_coeff = matching_rf_coeff_1*(matching_N_1/total_N) + matching_rf_coeff_2*(matching_N_2/total_N) + matching_rf_coeff_3*(matching_N_3/total_N) + matching_rf_coeff_4*(matching_N_4/total_N) + matching_rf_coeff_5*(matching_N_5/total_N) + matching_rf_coeff_6*(matching_N_6/total_N) + matching_rf_coeff_7*(matching_N_7/total_N) + matching_rf_coeff_8*(matching_N_8/total_N) + matching_rf_coeff_9*(matching_N_9/total_N) + matching_rf_coeff_10*(matching_N_10/total_N) + matching_rf_coeff_11*(matching_N_11/total_N) + matching_rf_coeff_12*(matching_N_12/total_N)
gen matching_rf_se = ((matching_rf_se_1^2)*(matching_N_1/total_N)^2 + (matching_rf_se_2^2)*(matching_N_2/total_N)^2 + (matching_rf_se_3^2)*(matching_N_3/total_N)^2 + (matching_rf_se_4^2)*(matching_N_4/total_N)^2 + (matching_rf_se_5^2)*(matching_N_5/total_N)^2 + (matching_rf_se_6^2)*(matching_N_6/total_N)^2 + (matching_rf_se_7^2)*(matching_N_7/total_N)^2 + (matching_rf_se_8^2)*(matching_N_8/total_N)^2 + (matching_rf_se_9^2)*(matching_N_9/total_N)^2 + (matching_rf_se_10^2)*(matching_N_10/total_N)^2 + (matching_rf_se_11^2)*(matching_N_11/total_N)^2 + (matching_rf_se_12^2)*(matching_N_12/total_N)^2)^0.5
gen matching_coeff = matching_coeff_1*(matching_N_1/total_N) + matching_coeff_2*(matching_N_2/total_N) + matching_coeff_3*(matching_N_3/total_N) + matching_coeff_4*(matching_N_4/total_N) + matching_coeff_5*(matching_N_5/total_N) + matching_coeff_6*(matching_N_6/total_N) + matching_coeff_7*(matching_N_7/total_N) + matching_coeff_8*(matching_N_8/total_N) + matching_coeff_9*(matching_N_9/total_N) + matching_coeff_10*(matching_N_10/total_N) + matching_coeff_11*(matching_N_11/total_N) + matching_coeff_12*(matching_N_12/total_N)
gen matching_se = ((matching_se_1^2)*(matching_N_1/total_N)^2 + (matching_se_2^2)*(matching_N_2/total_N)^2 + (matching_se_3^2)*(matching_N_3/total_N)^2 + (matching_se_4^2)*(matching_N_4/total_N)^2 + (matching_se_5^2)*(matching_N_5/total_N)^2 + (matching_se_6^2)*(matching_N_6/total_N)^2 + (matching_se_7^2)*(matching_N_7/total_N)^2 + (matching_se_8^2)*(matching_N_8/total_N)^2 + (matching_se_9^2)*(matching_N_9/total_N)^2 + (matching_se_10^2)*(matching_N_10/total_N)^2 + (matching_se_11^2)*(matching_N_11/total_N)^2 + (matching_se_12^2)*(matching_N_12/total_N)^2)^0.5
gen matching_N = max(matching_N_1, matching_N_2, matching_N_3, matching_N_4, matching_N_5, matching_N_6, matching_N_7, matching_N_8, matching_N_9, matching_N_10, matching_N_11, matching_N_12)

local obscounter = 1
local varcounter = 1
while `obscounter'<=20 {
	local secounter = `obscounter' + 1
	replace variable_name = matching_dep_var[`varcounter'] in `obscounter'
	replace ols_N = matching_N[`varcounter'] in `obscounter'
*** Comment out following 3 lines to get the IV result
//	replace ols_result = matching_rf_coeff[`varcounter'] in `obscounter'
//	replace ols_result = matching_rf_se[`varcounter'] in `secounter'
//	replace ols_pval = 2*ttail(105,abs(matching_rf_coeff[`varcounter']/matching_rf_se[`varcounter'])) in `obscounter'
*** Comment out following 3 lines to get the RF result
	replace ols_result = matching_coeff[`varcounter'] in `obscounter'
	replace ols_result = matching_se[`varcounter'] in `secounter'
	replace ols_pval = 2*ttail(105,abs(matching_coeff[`varcounter']/matching_se[`varcounter'])) in `obscounter'
	local varcounter = `varcounter' + 1
	local obscounter = `obscounter' + 2
}

// Create residualized dependent variables for matching regressions

xi i.year i.school_id

foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
	capture: drop r`varname'
	gen r`varname'_temp = `varname' - lag2_`varname'
	reg r`varname'_temp _Iyear* if `bcs'
	predict r`varname', resid
	drop r`varname'_temp
}


// Run reduced form for residualized matching regressions

capture: drop matching_resid_dep_var
gen str40 matching_resid_dep_var = ""

forvalues w = 1(1)12 {
	capture: drop matching_resid_coeff_`w' matching_resid_se_`w' matching_resid_N_`w' matching_rf_resid_coeff_`w' matching_rf_resid_se_`w'
	local i = 1
	gen float matching_resid_coeff_`w' = .
	gen float matching_resid_se_`w' = .
	gen float matching_resid_N_`w' = .
	gen float matching_rf_resid_coeff_`w' = .
	gen float matching_rf_resid_se_`w' = .
	xi i.lag_pscore_wk`w'_group*lag_win_wk`w' i.lag_pscore_wk`w'_group*lag_pscore_wk`w', noomit
	foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
		replace matching_resid_dep_var = "`varname'" in `i'
		reg r`varname' _Ilag* if `bcs', vce(cluster school_id) noconstant
		tab lag_pscore_wk`w'_group if e(sample), matcell(freqmat) matrow(valmat)
		local totalestobs = r(N)
		svmat valmat, names(val)
		svmat freqmat, names(freq)	
		forvalues j = 1(1)5 {
			quietly sum freq1 if val1==`j' in 1/5
			if r(N)==1 {
				if r(mean)>3 {
					local freq`j' =	r(mean)			
				}
				else {
					local freq`j' = 0
				}
			}
			else {
				local freq`j' = 0
			}
		}
		drop val1 freq1
		// Enforce overlap: drop any cells with less than 2 wins or losses
		forvalues j = 1(1)5 {
			sum lag_win_wk`w' if e(sample) & lag_pscore_wk`w'_group==`j' & lag_win_wk`w'==1
			local wincount = r(N)
			sum lag_win_wk`w' if e(sample) & lag_pscore_wk`w'_group==`j' & lag_win_wk`w'==0
			local losscount = r(N)
			if min(`wincount',`losscount')<2 {
				local weight`j' = 0
			}
			else {
				local weight`j' = 1
			}
		}
		local totalestobs = (`freq1'*`weight1' + `freq2'*`weight2' + `freq3'*`weight3' + `freq4'*`weight4' + `freq5'*`weight5')
		lincom (_b[_IlagXlag_w_1]*`freq1'*`weight1' + _b[_IlagXlag_w_2]*`freq2'*`weight2' + _b[_IlagXlag_w_3]*`freq3'*`weight3' + _b[_IlagXlag_w_4]*`freq4'*`weight4' + _b[_IlagXlag_w_5]*`freq5'*`weight5')/`totalestobs'
		local C = r(estimate)
		local SE = r(se)
		replace matching_rf_resid_coeff_`w' = `C' in `i'
		replace matching_rf_resid_se_`w' = `SE' in `i'
		replace matching_resid_N_`w' = e(N) in `i'		
		forvalues j = 1(1)5 {
			local fs`j' = 1 + matching_fs_coeff_`w'_`j'[`i']
			local fs_se`j' = matching_fs_se_`w'_`j'[`i']
		}
		lincom (_b[_IlagXlag_w_1]*`freq1'*`weight1'/`fs1' + _b[_IlagXlag_w_2]*`freq2'*`weight2'/`fs2' + _b[_IlagXlag_w_3]*`freq3'*`weight3'/`fs3' + _b[_IlagXlag_w_4]*`freq4'*`weight4'/`fs4' + _b[_IlagXlag_w_5]*`freq5'*`weight5'/`fs5')/`totalestobs'
		local C = r(estimate)
		local SE = (((_se[_IlagXlag_w_1]/(`fs1'))^2 + (`fs_se1'*_b[_IlagXlag_w_1]/(`fs1')^2)^2)*(`freq1'*`weight1'/`totalestobs')^2 +  ((_se[_IlagXlag_w_2]/(`fs2'))^2 + (`fs_se2'*_b[_IlagXlag_w_2]/(`fs2')^2)^2)*(`freq2'*`weight2'/`totalestobs')^2 +  ((_se[_IlagXlag_w_3]/(`fs3'))^2 + (`fs_se3'*_b[_IlagXlag_w_3]/(`fs3')^2)^2)*(`freq3'*`weight3'/`totalestobs')^2 +  ((_se[_IlagXlag_w_4]/(`fs4'))^2 + (`fs_se4'*_b[_IlagXlag_w_4]/(`fs4')^2)^2)*(`freq4'*`weight4'/`totalestobs')^2 +  ((_se[_IlagXlag_w_5]/(`fs5'))^2 + (`fs_se5'*_b[_IlagXlag_w_5]/(`fs5')^2)^2)*(`freq5'*`weight5'/`totalestobs')^2)^0.5	
		replace matching_resid_coeff_`w' = `C' in `i'
		replace matching_resid_se_`w' = `SE' in `i'
		local i = `i' + 1
	}
}

capture: drop total_resid_N matching_resid_coeff matching_resid_se matching_resid_N matching_rf_resid_coeff matching_rf_resid_se
gen total_resid_N = matching_resid_N_1 + matching_resid_N_2 + matching_resid_N_3 + matching_resid_N_4 + matching_resid_N_5 + matching_resid_N_6 + matching_resid_N_7 + matching_resid_N_8 + matching_resid_N_9 + matching_resid_N_10 + matching_resid_N_11 + matching_resid_N_12
gen matching_rf_resid_coeff = matching_rf_resid_coeff_1*(matching_resid_N_1/total_resid_N) + matching_rf_resid_coeff_2*(matching_resid_N_2/total_resid_N) + matching_rf_resid_coeff_3*(matching_resid_N_3/total_resid_N) + matching_rf_resid_coeff_4*(matching_resid_N_4/total_resid_N) + matching_rf_resid_coeff_5*(matching_resid_N_5/total_resid_N) + matching_rf_resid_coeff_6*(matching_resid_N_6/total_resid_N) + matching_rf_resid_coeff_7*(matching_resid_N_7/total_resid_N) + matching_rf_resid_coeff_8*(matching_resid_N_8/total_resid_N) + matching_rf_resid_coeff_9*(matching_resid_N_9/total_resid_N) + matching_rf_resid_coeff_10*(matching_resid_N_10/total_resid_N) + matching_rf_resid_coeff_11*(matching_resid_N_11/total_resid_N) + matching_rf_resid_coeff_12*(matching_resid_N_12/total_resid_N)
gen matching_rf_resid_se = ((matching_rf_resid_se_1^2)*(matching_resid_N_1/total_resid_N)^2 + (matching_rf_resid_se_2^2)*(matching_resid_N_2/total_resid_N)^2 + (matching_rf_resid_se_3^2)*(matching_resid_N_3/total_resid_N)^2 + (matching_rf_resid_se_4^2)*(matching_resid_N_4/total_resid_N)^2 + (matching_rf_resid_se_5^2)*(matching_resid_N_5/total_resid_N)^2 + (matching_rf_resid_se_6^2)*(matching_resid_N_6/total_resid_N)^2 + (matching_rf_resid_se_7^2)*(matching_resid_N_7/total_resid_N)^2 + (matching_rf_resid_se_8^2)*(matching_resid_N_8/total_resid_N)^2 + (matching_rf_resid_se_9^2)*(matching_resid_N_9/total_resid_N)^2 + (matching_rf_resid_se_10^2)*(matching_resid_N_10/total_resid_N)^2 + (matching_rf_resid_se_11^2)*(matching_resid_N_11/total_resid_N)^2 + (matching_rf_resid_se_12^2)*(matching_resid_N_12/total_resid_N)^2)^0.5
gen matching_resid_coeff = matching_resid_coeff_1*(matching_resid_N_1/total_resid_N) + matching_resid_coeff_2*(matching_resid_N_2/total_resid_N) + matching_resid_coeff_3*(matching_resid_N_3/total_resid_N) + matching_resid_coeff_4*(matching_resid_N_4/total_resid_N) + matching_resid_coeff_5*(matching_resid_N_5/total_resid_N) + matching_resid_coeff_6*(matching_resid_N_6/total_resid_N) + matching_resid_coeff_7*(matching_resid_N_7/total_resid_N) + matching_resid_coeff_8*(matching_resid_N_8/total_resid_N) + matching_resid_coeff_9*(matching_resid_N_9/total_resid_N) + matching_resid_coeff_10*(matching_resid_N_10/total_resid_N) + matching_resid_coeff_11*(matching_resid_N_11/total_resid_N) + matching_resid_coeff_12*(matching_resid_N_12/total_resid_N)
gen matching_resid_se = ((matching_resid_se_1^2)*(matching_resid_N_1/total_resid_N)^2 + (matching_resid_se_2^2)*(matching_resid_N_2/total_resid_N)^2 + (matching_resid_se_3^2)*(matching_resid_N_3/total_resid_N)^2 + (matching_resid_se_4^2)*(matching_resid_N_4/total_resid_N)^2 + (matching_resid_se_5^2)*(matching_resid_N_5/total_resid_N)^2 + (matching_resid_se_6^2)*(matching_resid_N_6/total_resid_N)^2 + (matching_resid_se_7^2)*(matching_resid_N_7/total_resid_N)^2 + (matching_resid_se_8^2)*(matching_resid_N_8/total_resid_N)^2 + (matching_resid_se_9^2)*(matching_resid_N_9/total_resid_N)^2 + (matching_resid_se_10^2)*(matching_resid_N_10/total_resid_N)^2 + (matching_resid_se_11^2)*(matching_resid_N_11/total_resid_N)^2 + (matching_resid_se_12^2)*(matching_resid_N_12/total_resid_N)^2)^0.5
gen matching_resid_N = max(matching_resid_N_1, matching_resid_N_2, matching_resid_N_3, matching_resid_N_4, matching_resid_N_5, matching_resid_N_6, matching_resid_N_7, matching_resid_N_8, matching_resid_N_9, matching_resid_N_10, matching_resid_N_11, matching_resid_N_12)

local obscounter = 1
local varcounter = 1
while `obscounter'<=20 {
	local secounter = `obscounter' + 1
	replace ldv_N = matching_resid_N[`varcounter'] in `obscounter'
*** Comment out following 3 lines to get the IV result
//	replace ldv_result = matching_rf_resid_coeff[`varcounter'] in `obscounter'
//	replace ldv_result = matching_rf_resid_se[`varcounter'] in `secounter'
//	replace ldv_pval = 2*ttail(105,abs(matching_rf_resid_coeff[`varcounter']/matching_rf_resid_se[`varcounter'])) in `obscounter'	
*** Comment out following 3 lines to get the RF result
	replace ldv_result = matching_resid_coeff[`varcounter'] in `obscounter'
	replace ldv_result = matching_resid_se[`varcounter'] in `secounter'
	replace ldv_pval = 2*ttail(105,abs(matching_resid_coeff[`varcounter']/matching_resid_se[`varcounter'])) in `obscounter'
	local varcounter = `varcounter' + 1
	local obscounter = `obscounter' + 2
}
drop _I*

browse variable_name ldv_result ldv_pval ldv_N

************************
* Supplemental Results *
************************

************************************************************************
*** Run weighting results using Hirano Imbens Ridder (2003) (Table 4) **
************************************************************************

// Create matching bins

*** Choose sample (all/BCS/non-BCS)
local bcs "bcs<=1"

capture: drop variable_name 
capture: drop ols_result
capture: drop ols_pval
capture: drop ols_N
capture: drop ldv_result
capture: drop ldv_pval
capture: drop ldv_N

gen variable_name = ""
gen ols_result = .
gen ols_pval = .
gen ols_N = .
gen ldv_result = .
gen ldv_pval = .
gen ldv_N = .

// Run first stage for weighted regressions

capture: drop matching_dep_var
gen str40 matching_dep_var = ""

// Run reduced form for weighted regressions

forvalues w = 1(1)12 {
	capture: drop matching_coeff_`w' matching_se_`w' matching_N_`w'
	local i = 1
	gen float matching_coeff_`w' = .
	gen float matching_se_`w' = .
	gen float matching_N_`w' = .
	capture: drop weight
	gen weight = lag_win_wk`w'/lag_pscore_wk`w' + (1-lag_win_wk`w')/(1-lag_pscore_wk`w')
	foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
		replace matching_dep_var = "`varname'" in `i'
		reg `varname' lag_win_wk`w' if `bcs' & lag_pscore_wk`w'>=.05 & lag_pscore_wk`w'<=.95 [aw=weight], vce(cluster school_id)
		replace matching_coeff_`w' = _b[lag_win_wk`w'] in `i'
		replace matching_se_`w' = _se[lag_win_wk`w'] in `i'
		replace matching_N_`w' = e(N) in `i'
		local i = `i' + 1
	}
}

capture: drop total_N matching_rf_coeff matching_rf_se matching_N
gen total_N = matching_N_1 + matching_N_2 + matching_N_3 + matching_N_4 + matching_N_5 + matching_N_6 + matching_N_7 + matching_N_8 + matching_N_9 + matching_N_10 + matching_N_11 + matching_N_12
gen matching_rf_coeff = matching_coeff_1*(matching_N_1/total_N) + matching_coeff_2*(matching_N_2/total_N) + matching_coeff_3*(matching_N_3/total_N) + matching_coeff_4*(matching_N_4/total_N) + matching_coeff_5*(matching_N_5/total_N) + matching_coeff_6*(matching_N_6/total_N) + matching_coeff_7*(matching_N_7/total_N) + matching_coeff_8*(matching_N_8/total_N) + matching_coeff_9*(matching_N_9/total_N) + matching_coeff_10*(matching_N_10/total_N) + matching_coeff_11*(matching_N_11/total_N) + matching_coeff_12*(matching_N_12/total_N)
gen matching_rf_se = ((matching_se_1^2)*(matching_N_1/total_N)^2 + (matching_se_2^2)*(matching_N_2/total_N)^2 + (matching_se_3^2)*(matching_N_3/total_N)^2 + (matching_se_4^2)*(matching_N_4/total_N)^2 + (matching_se_5^2)*(matching_N_5/total_N)^2 + (matching_se_6^2)*(matching_N_6/total_N)^2 + (matching_se_7^2)*(matching_N_7/total_N)^2 + (matching_se_8^2)*(matching_N_8/total_N)^2 + (matching_se_9^2)*(matching_N_9/total_N)^2 + (matching_se_10^2)*(matching_N_10/total_N)^2 + (matching_se_11^2)*(matching_N_11/total_N)^2 + (matching_se_12^2)*(matching_N_12/total_N)^2)^0.5
gen matching_N = max(matching_N_1, matching_N_2, matching_N_3, matching_N_4, matching_N_5, matching_N_6, matching_N_7, matching_N_8, matching_N_9, matching_N_10, matching_N_11, matching_N_12)

local obscounter = 1
local varcounter = 1
while `obscounter'<=20 {
	local secounter = `obscounter' + 1
	replace variable_name = matching_dep_var[`varcounter'] in `obscounter'
	replace ols_N = matching_N[`varcounter'] in `obscounter'
	replace ols_result = matching_rf_coeff[`varcounter'] in `obscounter'
	replace ols_result = matching_rf_se[`varcounter'] in `secounter'
	replace ols_pval = 2*ttail(105,abs(matching_rf_coeff[`varcounter']/matching_rf_se[`varcounter'])) in `obscounter'
	local varcounter = `varcounter' + 1
	local obscounter = `obscounter' + 2
}

// Create residualized dependent variables for weighted regressions

xi i.year

foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
	reg `varname' lag2_`varname' _Iyear* if `bcs'
	capture: drop r`varname' 
	predict r`varname', resid
}

// Run reduced form for residualized weighted regressions

capture: drop matching_resid_dep_var
gen str40 matching_resid_dep_var = ""

forvalues w = 1(1)12 {
	capture: drop matching_resid_coeff_`w' matching_resid_se_`w' matching_resid_N_`w'
	local i = 1
	gen float matching_resid_coeff_`w' = .
	gen float matching_resid_se_`w' = .
	gen float matching_resid_N_`w' = .
	capture: drop weight
	gen weight = lag_win_wk`w'/lag_pscore_wk`w' + (1-lag_win_wk`w')/(1-lag_pscore_wk`w')
	foreach varname of varlist alumni_ops_athletics alum_non_athl_ops alumni_total_giving vse_alum_giving_rate usnews_academic_rep_new applicants acceptance_rate firsttime_outofstate first_time_instate sat_25 {
		replace matching_resid_dep_var = "`varname'" in `i'
		reg `varname' lag_win_wk`w' lag2_`varname' _Iyear* if `bcs' & lag_pscore_wk`w'>=.05 & lag_pscore_wk`w'<=.95 [aw=weight], vce(cluster school_id)
		replace matching_resid_coeff_`w' = _b[lag_win_wk`w'] in `i'
		replace matching_resid_se_`w' = _se[lag_win_wk`w'] in `i'
		replace matching_resid_N_`w' = e(N) in `i'
		local i = `i' + 1
	}
}

capture: drop total_resid_N 
capture: drop matching_resid_rf_coeff
capture: drop matching_resid_rf_se
capture: drop matching_resid_N
gen total_resid_N = matching_resid_N_1 + matching_resid_N_2 + matching_resid_N_3 + matching_resid_N_4 + matching_resid_N_5 + matching_resid_N_6 + matching_resid_N_7 + matching_resid_N_8 + matching_resid_N_9 + matching_resid_N_10 + matching_resid_N_11 + matching_resid_N_12
gen matching_resid_rf_coeff = matching_resid_coeff_1*(matching_resid_N_1/total_resid_N) + matching_resid_coeff_2*(matching_resid_N_2/total_resid_N) + matching_resid_coeff_3*(matching_resid_N_3/total_resid_N) + matching_resid_coeff_4*(matching_resid_N_4/total_resid_N) + matching_resid_coeff_5*(matching_resid_N_5/total_resid_N) + matching_resid_coeff_6*(matching_resid_N_6/total_resid_N) + matching_resid_coeff_7*(matching_resid_N_7/total_resid_N) + matching_resid_coeff_8*(matching_resid_N_8/total_resid_N) + matching_resid_coeff_9*(matching_resid_N_9/total_resid_N) + matching_resid_coeff_10*(matching_resid_N_10/total_resid_N) + matching_resid_coeff_11*(matching_resid_N_11/total_resid_N) + matching_resid_coeff_12*(matching_resid_N_12/total_resid_N)
gen matching_resid_rf_se = ((matching_resid_se_1^2)*(matching_resid_N_1/total_resid_N)^2 + (matching_resid_se_2^2)*(matching_resid_N_2/total_resid_N)^2 + (matching_resid_se_3^2)*(matching_resid_N_3/total_resid_N)^2 + (matching_resid_se_4^2)*(matching_resid_N_4/total_resid_N)^2 + (matching_resid_se_5^2)*(matching_resid_N_5/total_resid_N)^2 + (matching_resid_se_6^2)*(matching_resid_N_6/total_resid_N)^2 + (matching_resid_se_7^2)*(matching_resid_N_7/total_resid_N)^2 + (matching_resid_se_8^2)*(matching_resid_N_8/total_resid_N)^2 + (matching_resid_se_9^2)*(matching_resid_N_9/total_resid_N)^2 + (matching_resid_se_10^2)*(matching_resid_N_10/total_resid_N)^2 + (matching_resid_se_11^2)*(matching_resid_N_11/total_resid_N)^2 + (matching_resid_se_12^2)*(matching_resid_N_12/total_resid_N)^2)^0.5
gen matching_resid_N = max(matching_resid_N_1, matching_resid_N_2, matching_resid_N_3, matching_resid_N_4, matching_resid_N_5, matching_resid_N_6, matching_resid_N_7, matching_resid_N_8, matching_resid_N_9, matching_resid_N_10, matching_resid_N_11, matching_resid_N_12)

local obscounter = 1
local varcounter = 1
while `obscounter'<=20 {
	local secounter = `obscounter' + 1
	replace ldv_N = matching_resid_N[`varcounter'] in `obscounter'
	replace ldv_result = matching_resid_rf_coeff[`varcounter'] in `obscounter'
	replace ldv_result = matching_resid_rf_se[`varcounter'] in `secounter'
	replace ldv_pval = 2*ttail(105,abs(matching_resid_rf_coeff[`varcounter']/matching_resid_rf_se[`varcounter'])) in `obscounter'
	local varcounter = `varcounter' + 1
	local obscounter = `obscounter' + 2
}

drop _I*
