/*******************************************************************************
Preference for the Workplace, Investment in Human Capital, and Gender
 - Matthew Wiswall and Basit Zafar

Overview
1) Creates most of the tables and figures for the paper, everything but
the CPS and ACS table


*******************************************************************************/

clear all
set more off
macro drop _all

cap log close
global maindir S:\SHARE\drf\Conlon\Basit\NYU_hypotheticals\Files_To_QJE\

global datadir ${maindir}Data\
global output ${maindir}Output\
global WTP_bootstrapdir ${maindir}Output\WTP_Bootstrap\
global WTP_dollars_bootstrapdir ${maindir}Output\WTP_dollars_Bootstrap\
global WTP_percent_bootstrapdir ${maindir}Output\WTP_percent_Bootstrap\
global Beta_bootstrapdir ${maindir}Output\Beta_Bootstrap\

global bootstrap_reps 1000

global disc = .95 	// Discount rate that we're assuming

/*
These macros turn on/off various parts of the code, so that if you only want 
to rerun a certain part of it, you don't have to wait for the whole code to run.
*/
global redo_bootstrap = 1
local redo_descriptive_analysis = 1
local redo_percentiles_betas_wtps = 1
local redo_Table_6 = 1
local redo_heterogoneity = 1
local redo_followup_analysis = 1
local redo_delta_analysis = 1
local redo_expectations_regs = 1
local redo_attributes = 1


use "${datadir}survey_data_combined.dta", clear


**** Demographics, etc.
if `redo_descriptive_analysis' == 1 {
// Rename variables
foreach group in a b{
	forval s = 1/8{
		forval j = 1/3{
			rename hypo`s'`group'_job`j'_s2 hypo`s'`group'_job`j'
		}
	}
}

// Create probability density histograms (y-axis is percent) of selecting Job 1
preserve
keep id_7d female *_job1
foreach group in a b{
	forval s = 1/8{
		rename hypo`s'`group'_job1 hypojob1_`s'`group'
	}
}
reshape long hypojob1, i(id_7d female) j(scenario_group) string
histogram hypojob1, percent xtitle("Job 1") start(0) width(1) xtick(0(5)100) lcolor(black) color(gray) xlabel(0(10)100) ytick(0(5)15) ylabel(0(5)15) graphregion(fcolor(white))
graph export "${output}histpct_job1_all.pdf", replace

restore

********************************************************************************
* Part II: Cross tab of occupation by major
********************************************************************************
preserve
keep id_7d female self_econ* self_eng* self_hum* self_nat* self_nograd* 


foreach var in sci_s2 health_s2 bus_s2 govt_s2 edu_s2 {
	foreach f in 0 1 {
		foreach maj in econ eng hum nat nograd {
			local form %3.2f
			qui sum self_`maj'_`var' if female == `f', d
			local mean_`maj'_`var'_f`f': display `form' `r(mean)'
			local sd_`maj'_`var'_f`f': display `form' `r(sd)'
			local p50_`maj'_`var'_f`f': display `form' `r(p50)'
		}
		qui mean self_econ_`var' self_econ_`var' self_eng_`var' self_hum_`var' self_nograd_`var' if female == `f'
		qui test self_econ_`var'=self_econ_`var'=self_eng_`var'=self_hum_`var'=self_nograd_`var'
		local p_`var'_f`f': display %9.3f `r(p)'
	}
	foreach maj in econ eng hum nat nograd {
		qui mean self_`maj'_`var', over(female)
		qui test Male=Female
		local p_`maj'_`var'_f1 = `r(p)'
		local s_`maj'_`var'_f1 = ""
		if `p_`maj'_`var'_f1' < .1 {
			local s_`maj'_`var'_f1 = "*"
		}
		if `p_`maj'_`var'_f1' < .05 {
			local s_`maj'_`var'_f1 = "**"
		}
		if `p_`maj'_`var'_f1' < .01 {
			local s_`maj'_`var'_f1 = "***"
		}
	}
}

local f1_lab "Female respondents"
local f0_lab "Male respondents"
local sci_s2_lab "Science"
local health_s2_lab "Health"
local bus_s2_lab "Business"
local govt_s2_lab "Government"
local edu_s2_lab "Education"
local econ_lab "Econ/Business"
local eng_lab "Engineering"
local hum_lab "Humanaities"
local nat_lab "Natural Sciences"
local nograd_lab "No Degree"

file open table using "${output}Perceived_Mapping_Majors.csv", write replace
foreach var in sci_s2 health_s2 bus_s2 govt_s2 edu_s2 {
	file write table ",``var'_lab',"
}
file write table _n
foreach var in sci_s2 health_s2 bus_s2 govt_s2 edu_s2 {
	file write table ", Males, Females"
}
foreach maj in econ eng hum nat nograd {
	file write table _n "``maj'_lab'"
	foreach var in sci_s2 health_s2 bus_s2 govt_s2 edu_s2 {
		foreach f in 0 1 {
			file write table ",`mean_`maj'_`var'_f`f''`s_`maj'_`var'_f`f''"
		}
	}
	file write table _n ""
	foreach var in sci_s2 health_s2 bus_s2 govt_s2 edu_s2 {
		foreach f in 0 1 {
			file write table `",="[`p50_`maj'_`var'_f`f'']""'
		}
	}	
	file write table _n ""
	foreach var in sci_s2 health_s2 bus_s2 govt_s2 edu_s2 {
		foreach f in 0 1 {
			file write table `",="(`sd_`maj'_`var'_f`f'')""'
		}
	}

}
file write table _n _n "F-test"
foreach var in sci_s2 health_s2 bus_s2 govt_s2 edu_s2 {
	file write table ",`p_`var'_f0', `p_`var'_f1'"
}
file close table

restore

********************************************************************************
* Part III: Table of Job Attributes
********************************************************************************
*--By major

preserve
keep id_7d female self_grad*s2 self_earning*s2 self_wklyhrs*s2 self_ptoption*s2 self_bonus*s2 ///
	self_men*s2 self_layoff*s2 self45_earning*s2 self_rankability*s2 self_hrsgpa4*

tab self_ptoption_hum_s2 if female == 1
tab self_ptoption_econ_s2 

// Log earnings
foreach major in econ eng hum nat nograd{
	replace self_earning_`major'_s2 = .001 if self_earning_`major'_s2 == 0
	gen self_logearning_`major'_s2 = log(self_earning_`major'_s2)
	replace self_logearning_`major'_s2 =. if missing(self_earning_`major'_s2)
}

// Remove top/bottom 5% of earnings
foreach major in econ eng hum nat nograd{
	_pctile self_earning_`major'_s2, p(5,95) // remove top/bottom 5%
	return list
	local top = r(r2)
	local bottom = r(r1)
	replace self_earning_`major'_s2 = `top' if self_earning_`major'_s2 >= `top'
	replace self_earning_`major'_s2 = `bottom' if self_earning_`major'_s2 <= `bottom'	
	replace self_logearning_`major'_s2 = log(self_earning_`major'_s2)
}

// Generate raise (in percentage, 0 to 100)
foreach major in econ eng hum nat nograd{
	replace self45_earning_`major'_s2 = .001 if self45_earning_`major'_s2 == 0
	replace self45_earning_`major'_s2 = .999 if self45_earning_`major'_s2 == 1
	replace self_earning_`major'_s2 = .001 if self_earning_`major'_s2 == 0
	replace self_earning_`major'_s2 = .999 if self_earning_`major'_s2 == 1	
	gen self_raise_`major'_s2 = exp((ln(self45_earning_`major'_s2/self_earning_`major'_s2))/15)
	gen self_raisepct_`major'_s2 = self_raise_`major'_s2 - 1
	replace self_raisepct_`major'_s2 = self_raisepct_`major'_s2*100
}

// produce sumstat tables
gen self_hrsgpa4_nograd_s2 =0
foreach var in grad earning logearning layoff bonus men raisepct wklyhrs ptoption rankability hrsgpa4{
	foreach major in econ eng hum nat nograd{
		rename self_`var'_`major'_s2 self_`major'_`var'
	}
}

keep id_7d female self_econ* self_eng* self_hum* self_nat* self_nograd*

// order the variables: Probability, Earnings, Logearning, fired, bonus, fracmale, raise, hours, parttime
foreach major in econ eng hum nat nograd{
order self_`major'_grad self_`major'_earning self_`major'_logearning ///
	self_`major'_layoff self_`major'_bonus self_`major'_men ///
	self_`major'_raisepct self_`major'_wklyhrs self_`major'_ptoption ///
	self_`major'_rankability self_`major'_hrsgpa4
}



*--Parttime beliefs for hum and econ, by gender
// Create part-time cdfs
gen self_hum_ptoption_f = self_hum_ptoption if female == 1
gen self_econ_ptoption_f = self_econ_ptoption if female == 1
cumul self_hum_ptoption_f, gen(cdf_hum_ptoption_f) equal
cumul self_econ_ptoption_f, gen(cdf_econ_ptoption_f) equal

tempfile temp
save `temp', replace

stack cdf_hum_ptoption_f self_hum_ptoption_f cdf_econ_ptoption_f self_econ_ptoption_f, into(c ptoption) wide clear 	
line cdf_hum_ptoption_f cdf_econ_ptoption_f ptoption, sort ylab(, grid) scheme(tufte) ///
	ytitle("Density") legend(row(1) col(2) label(1 "Humanities") label(2 "Economics/Business")) ///
	title("Part-time Availability Beliefs of Female Respondents", size(medsmall)) ///
	xtitle("Part-time availability belief")
	graph export "${output}female_ptoption.pdf", replace

use `temp', clear

save `temp', replace



foreach var in grad earning raisepct layoff bonus men wklyhrs ptoption rankability hrsgpa4 {
	foreach f in 0 1 {
		foreach maj in econ eng hum nat nograd {
			local form %3.1f
			if "`var'" == "earning" {
				local form %7.0f
			}
			qui sum self_`maj'_`var' if female == `f', d
			local mean_`maj'_`var'_f`f': display `form' `r(mean)'
			local sd_`maj'_`var'_f`f': display `form' `r(sd)'
		}
		qui mean self_econ_`var' self_econ_`var' self_eng_`var' self_hum_`var' self_nograd_`var' if female == `f'
		qui test self_econ_`var'=self_econ_`var'=self_eng_`var'=self_hum_`var'=self_nograd_`var'
		local p_`var'_f`f': display %9.3f `r(p)'
	}
	foreach maj in econ eng hum nat nograd {
		qui mean self_`maj'_`var', over(female)
		qui test Male=Female
		local p_`maj'_`var'_f1 = `r(p)'
		local s_`maj'_`var'_f1 = ""
		if `p_`maj'_`var'_f1' < .1 {
			local s_`maj'_`var'_f1 = "*"
		}
		if `p_`maj'_`var'_f1' < .05 {
			local s_`maj'_`var'_f1 = "**"
		}
		if `p_`maj'_`var'_f1' < .01 {
			local s_`maj'_`var'_f1 = "***"
		}
	}
}

local f1_lab "Female respondents"
local f0_lab "Male respondents"
local grad_lab "Prob of majoring"
local earning_lab "Annual age 30 earnings"
local raisepct_lab "Annual \% inc in earnings"
local layoff_lab "Prob of being fired"
local bonus_lab "Bonus as \% of salary"
local men_lab "Prop of males at job"
local wklyhrs_lab "Hrs/week work"
local ptoption_lab "Likelihood of part-time availability"
local rankability_lab "Ability rank"
local hrsgpa4_lab "Hrs/wk of study time"
local econ_lab "Econ/Business"
local eng_lab "Engineering"
local hum_lab "Humanaities"
local nat_lab "Natural Sciences"
local nograd_lab "No Degree"

file open table using "${output}Perceived_Job_Attributes.csv", write replace
foreach var in grad earning raisepct layoff bonus men wklyhrs ptoption rankability hrsgpa4  {
	file write table ",``var'_lab'"
}
foreach f in 0 1 {
	file write table _n _n "`f`f'_lab'"
	foreach maj in econ eng hum nat nograd {
		file write table _n "``maj'_lab'"
		foreach var in grad earning raisepct layoff bonus men wklyhrs ptoption rankability hrsgpa4  {
			file write table ",`mean_`maj'_`var'_f`f''`s_`maj'_`var'_f`f''"
		}
		file write table _n ""
		foreach var in grad earning raisepct layoff bonus men wklyhrs ptoption rankability hrsgpa4  {
			file write table `",="(`sd_`maj'_`var'_f`f'')""'
		}
		
	}
	file write table _n _n "F-test"
	foreach var in grad earning raisepct layoff bonus men wklyhrs ptoption rankability hrsgpa4  {
		file write table ",`p_`var'_f`f''"
	}

}
file close table


restore

********************************************************************************
* Part IV: Choice Scenarios
********************************************************************************
// Mean/sd of probabilities assigned to the choices within each scenario, by gender
// Test distribution of choices by gender

*--Choice Scenario Summary Stats
cap log close
preserve
forvalues i=1/8{
	foreach group in a b{
		forvalues j=1/3{
			disp "********Question hypo`i'`group'********"			

			quietly sum hypo`i'`group'_job`j' if female == 0, d // Males
			local m_`i'`group'_job`j'_m = round(r(mean),.001)
			local med_`i'`group'_job`j'_m = round(r(p50),.001)
			local med_`i'`group'_job`j'_m = "[`med_`i'`group'_job`j'_m']"
			local sd_`i'`group'_job`j'_m = round(r(sd),.001)
			local sd_`i'`group'_job`j'_m = "(`sd_`i'`group'_job`j'_m')"
			local n_`i'`group'_job`j'_m = r(N)
			disp "Male, job `j'"
			disp "mean = `m_`i'`group'_job`j'_m'"
			disp "sd = `sd_`i'`group'_job`j'_m'"
			disp "median = `med_`i'`group'_job`j'_m'"
			
			quietly sum hypo`i'`group'_job`j' if female == 1, d // Females
			local m_`i'`group'_job`j'_f = round(r(mean),.001)
			local med_`i'`group'_job`j'_f = round(r(p50),.001)
			local med_`i'`group'_job`j'_f = "[`med_`i'`group'_job`j'_f']"
			local sd_`i'`group'_job`j'_f = round(r(sd),.001)
			local sd_`i'`group'_job`j'_f = "(`sd_`i'`group'_job`j'_f')"
			disp "Female, job `j'"
			disp "mean = `m_`i'`group'_job`j'_f'"
			disp "sd = `sd_`i'`group'_job`j'_f'"
			quietly ttest hypo`i'`group'_job`j', by(female)
			local p_`i'`group'_job`j' = round(r(p),.001)
			disp "p-value = `p_`i'`group'_job`j''"
			*gen choice_hypo`i'`group' = job`j' 
		}
	}
}


file open resultsfile using ${output}ChoiceScenarios.csv, write replace
file write resultsfile "Question 1a,Males,Females" _n
file write resultsfile "Job 1,`m_1a_job1_m',`m_1a_job1_f'" _n
file write resultsfile ",`med_1a_job1_m',`med_1a_job1_f'" _n
file write resultsfile ",`sd_1a_job1_m',`sd_1a_job1_f'" _n
file write resultsfile "p-value,`p_1a_job1'" _n
file write resultsfile _n
file write resultsfile "Job 2,`m_1a_job2_m',`m_1a_job2_f'" _n
file write resultsfile ",`med_1a_job2_m',`med_1a_job2_f'" _n
file write resultsfile ",`sd_1a_job2_m',`sd_1a_job2_f'" _n
file write resultsfile "p-value,`p_1a_job2'" _n
file write resultsfile _n
file write resultsfile "Job 3,`m_1a_job3_m',`m_1a_job3_f'" _n
file write resultsfile ",`med_1a_job3_m',`med_1a_job3_f'" _n
file write resultsfile ",`sd_1a_job3_m',`sd_1a_job3_f'" _n
file write resultsfile "p-value,`p_1a_job3'" _n
file write resultsfile _n
file write resultsfile _n
file write resultsfile "Question 2a,Males,Females" _n
file write resultsfile "Job 1,`m_2a_job1_m',`m_2a_job1_f'" _n
file write resultsfile ",`med_2a_job1_m',`med_2a_job1_f'" _n
file write resultsfile ",`sd_2a_job1_m',`sd_2a_job1_f'" _n
file write resultsfile "p-value,`p_2a_job1'" _n
file write resultsfile _n
file write resultsfile "Job 2,`m_2a_job2_m',`m_2a_job2_f'" _n
file write resultsfile ",`med_2a_job2_m',`med_2a_job2_f'" _n
file write resultsfile ",`sd_2a_job2_m',`sd_2a_job2_f'" _n
file write resultsfile "p-value,`p_2a_job2'" _n
file write resultsfile _n
file write resultsfile "Job 3,`m_2a_job3_m',`m_2a_job3_f'" _n
file write resultsfile ",`med_2a_job3_m',`med_2a_job3_f'" _n
file write resultsfile ",`sd_2a_job3_m',`sd_2a_job3_f'" _n
file write resultsfile "p-value,`p_2a_job3'" _n
file write resultsfile _n
file write resultsfile _n
file write resultsfile "Question 3a,Males,Females" _n
file write resultsfile "Job 1,`m_3a_job1_m',`m_3a_job1_f'" _n
file write resultsfile ",`med_3a_job1_m',`med_3a_job1_f'" _n
file write resultsfile ",`sd_3a_job1_m',`sd_3a_job1_f'" _n
file write resultsfile "p-value,`p_3a_job1'" _n
file write resultsfile _n
file write resultsfile "Job 2,`m_3a_job2_m',`m_3a_job2_f'" _n
file write resultsfile ",`med_3a_job2_m',`med_3a_job2_f'" _n
file write resultsfile ",`sd_3a_job2_m',`sd_3a_job2_f'" _n
file write resultsfile "p-value,`p_3a_job2'" _n
file write resultsfile _n
file write resultsfile "Job 3,`m_3a_job3_m',`m_3a_job3_f'" _n
file write resultsfile ",`med_3a_job3_m',`med_3a_job3_f'" _n
file write resultsfile ",`sd_3a_job3_m',`sd_3a_job3_f'" _n
file write resultsfile "p-value,`p_3a_job3'" _n
file write resultsfile _n
file write resultsfile _n
file write resultsfile "Question 4a,Males,Females" _n
file write resultsfile "Job 1,`m_4a_job1_m',`m_4a_job1_f'" _n
file write resultsfile ",`med_4a_job1_m',`med_4a_job1_f'" _n
file write resultsfile ",`sd_4a_job1_m',`sd_4a_job1_f'" _n
file write resultsfile "p-value,`p_4a_job1'" _n
file write resultsfile _n
file write resultsfile "Job 2,`m_4a_job2_m',`m_4a_job2_f'" _n
file write resultsfile ",`med_4a_job2_m',`med_4a_job2_f'" _n
file write resultsfile ",`sd_4a_job2_m',`sd_4a_job2_f'" _n
file write resultsfile "p-value,`p_4a_job2'" _n
file write resultsfile _n
file write resultsfile "Job 3,`m_4a_job3_m',`m_4a_job3_f'" _n
file write resultsfile ",`med_4a_job3_m',`med_4a_job3_f'" _n
file write resultsfile ",`sd_4a_job3_m',`sd_4a_job3_f'" _n
file write resultsfile "p-value,`p_4a_job3'" _n
file write resultsfile _n
file write resultsfile _n
file write resultsfile "Question 5a,Males,Females" _n
file write resultsfile "Job 1,`m_5a_job1_m',`m_5a_job1_f'" _n
file write resultsfile ",`med_5a_job1_m',`med_5a_job1_f'" _n
file write resultsfile ",`sd_5a_job1_m',`sd_5a_job1_f'" _n
file write resultsfile "p-value,`p_5a_job1'" _n
file write resultsfile _n
file write resultsfile "Job 2,`m_5a_job2_m',`m_5a_job2_f'" _n
file write resultsfile ",`med_5a_job2_m',`med_5a_job2_f'" _n
file write resultsfile ",`sd_5a_job2_m',`sd_5a_job2_f'" _n
file write resultsfile "p-value,`p_5a_job2'" _n
file write resultsfile _n
file write resultsfile "Job 3,`m_5a_job3_m',`m_5a_job3_f'" _n
file write resultsfile ",`med_5a_job3_m',`med_5a_job3_f'" _n
file write resultsfile ",`sd_5a_job3_m',`sd_5a_job3_f'" _n
file write resultsfile "p-value,`p_5a_job3'" _n
file write resultsfile _n
file write resultsfile _n
file write resultsfile "Question 6a,Males,Females" _n
file write resultsfile "Job 1,`m_6a_job1_m',`m_6a_job1_f'" _n
file write resultsfile ",`med_6a_job1_m',`med_6a_job1_f'" _n
file write resultsfile ",`sd_6a_job1_m',`sd_6a_job1_f'" _n
file write resultsfile "p-value,`p_6a_job1'" _n
file write resultsfile _n
file write resultsfile "Job 2,`m_6a_job2_m',`m_6a_job2_f'" _n
file write resultsfile ",`med_6a_job2_m',`med_6a_job2_f'" _n
file write resultsfile ",`sd_6a_job2_m',`sd_6a_job2_f'" _n
file write resultsfile "p-value,`p_6a_job2'" _n
file write resultsfile _n
file write resultsfile "Job 3,`m_6a_job3_m',`m_6a_job3_f'" _n
file write resultsfile ",`med_6a_job3_m',`med_6a_job3_f'" _n
file write resultsfile ",`sd_6a_job3_m',`sd_6a_job3_f'" _n
file write resultsfile "p-value,`p_6a_job3'" _n
file write resultsfile _n
file write resultsfile _n
file write resultsfile "Question 7a,Males,Females" _n
file write resultsfile "Job 1,`m_7a_job1_m',`m_7a_job1_f'" _n
file write resultsfile ",`med_7a_job1_m',`med_7a_job1_f'" _n
file write resultsfile ",`sd_7a_job1_m',`sd_7a_job1_f'" _n
file write resultsfile "p-value,`p_7a_job1'" _n
file write resultsfile _n
file write resultsfile "Job 2,`m_7a_job2_m',`m_7a_job2_f'" _n
file write resultsfile ",`med_7a_job2_m',`med_7a_job2_f'" _n
file write resultsfile ",`sd_7a_job2_m',`sd_7a_job2_f'" _n
file write resultsfile "p-value,`p_7a_job2'" _n
file write resultsfile _n
file write resultsfile "Job 3,`m_7a_job3_m',`m_7a_job3_f'" _n
file write resultsfile ",`med_7a_job3_m',`med_7a_job3_f'" _n
file write resultsfile ",`sd_7a_job3_m',`sd_7a_job3_f'" _n
file write resultsfile "p-value,`p_7a_job3'" _n
file write resultsfile _n
file write resultsfile _n
file write resultsfile "Question 8a,Males,Females" _n
file write resultsfile "Job 1,`m_8a_job1_m',`m_8a_job1_f'" _n
file write resultsfile ",`med_8a_job1_m',`med_8a_job1_f'" _n
file write resultsfile ",`sd_8a_job1_m',`sd_8a_job1_f'" _n
file write resultsfile "p-value,`p_8a_job1'" _n
file write resultsfile _n
file write resultsfile "Job 2,`m_8a_job2_m',`m_8a_job2_f'" _n
file write resultsfile ",`med_8a_job2_m',`med_8a_job2_f'" _n
file write resultsfile ",`sd_8a_job2_m',`sd_8a_job2_f'" _n
file write resultsfile "p-value,`p_8a_job2'" _n
file write resultsfile _n
file write resultsfile "Job 3,`m_8a_job3_m',`m_8a_job3_f'" _n
file write resultsfile ",`med_8a_job3_m',`med_8a_job3_f'" _n
file write resultsfile ",`sd_8a_job3_m',`sd_8a_job3_f'" _n
file write resultsfile "p-value,`p_8a_job3'" _n
file write resultsfile _n
file write resultsfile _n


file write resultsfile "Question 1b,Males,Females" _n
file write resultsfile "Job 1,`m_1b_job1_m',`m_1b_job1_f'" _n
file write resultsfile ",`med_1a_job1_m',`med_1b_job1_f'" _n
file write resultsfile ",`sd_1a_job1_m',`sd_1b_job1_f'" _n
file write resultsfile "p-value,`p_1b_job1'" _n
file write resultsfile _n
file write resultsfile "Job 2,`m_1b_job2_m',`m_1b_job2_f'" _n
file write resultsfile ",`med_1a_job2_m',`med_1b_job2_f'" _n
file write resultsfile ",`sd_1a_job2_m',`sd_1b_job2_f'" _n
file write resultsfile "p-value,`p_1b_job2'" _n
file write resultsfile _n
file write resultsfile "Job 3,`m_1b_job3_m',`m_1b_job3_f'" _n
file write resultsfile ",`med_1a_job3_m',`med_1b_job3_f'" _n
file write resultsfile ",`sd_1a_job3_m',`sd_1b_job3_f'" _n
file write resultsfile "p-value,`p_1b_job3'" _n
file write resultsfile _n
file write resultsfile _n
file write resultsfile "Question 2b,Males,Females" _n
file write resultsfile "Job 1,`m_2b_job1_m',`m_2b_job1_f'" _n
file write resultsfile ",`med_2b_job1_m',`med_2b_job1_f'" _n
file write resultsfile ",`sd_2b_job1_m',`sd_2b_job1_f'" _n
file write resultsfile "p-value,`p_2b_job1'" _n
file write resultsfile _n
file write resultsfile "Job 2,`m_2b_job2_m',`m_2b_job2_f'" _n
file write resultsfile ",`med_2b_job2_m',`med_2b_job2_f'" _n
file write resultsfile ",`sd_2b_job2_m',`sd_2b_job2_f'" _n
file write resultsfile "p-value,`p_2b_job2'" _n
file write resultsfile _n
file write resultsfile "Job 3,`m_2b_job3_m',`m_2b_job3_f'" _n
file write resultsfile ",`med_2b_job3_m',`med_2b_job3_f'" _n
file write resultsfile ",`sd_2b_job3_m',`sd_2b_job3_f'" _n
file write resultsfile "p-value,`p_2b_job3'" _n
file write resultsfile _n
file write resultsfile _n
file write resultsfile "Question 3b,Males,Females" _n
file write resultsfile "Job 1,`m_3b_job1_m',`m_3b_job1_f'" _n
file write resultsfile ",`med_3b_job1_m',`med_3b_job1_f'" _n
file write resultsfile ",`sd_3b_job1_m',`sd_3b_job1_f'" _n
file write resultsfile "p-value,`p_3b_job1'" _n
file write resultsfile _n
file write resultsfile "Job 2,`m_3b_job2_m',`m_3b_job2_f'" _n
file write resultsfile ",`med_3b_job2_m',`med_3b_job2_f'" _n
file write resultsfile ",`sd_3b_job2_m',`sd_3b_job2_f'" _n
file write resultsfile "p-value,`p_3b_job2'" _n
file write resultsfile _n
file write resultsfile "Job 3,`m_3b_job3_m',`m_3b_job3_f'" _n
file write resultsfile ",`med_3b_job3_m',`med_3b_job3_f'" _n
file write resultsfile ",`sd_3b_job3_m',`sd_3b_job3_f'" _n
file write resultsfile "p-value,`p_3b_job3'" _n
file write resultsfile _n
file write resultsfile _n
file write resultsfile "Question 4b,Males,Females" _n
file write resultsfile "Job 1,`m_4b_s2_job1_m',`m_4b_job1_f'" _n
file write resultsfile ",`med_4b_job1_m',`med_4b_job1_f'" _n
file write resultsfile ",`sd_4b_job1_m',`sd_4b_job1_f'" _n
file write resultsfile "p-value,`p_4b_job1'" _n
file write resultsfile _n
file write resultsfile "Job 2,`m_4b_job2_m',`m_4b_job2_f'" _n
file write resultsfile ",`med_4b_job2_m',`med_4b_job2_f'" _n
file write resultsfile ",`sd_4b_job2_m',`sd_4b_job2_f'" _n
file write resultsfile "p-value,`p_4b_job2'" _n
file write resultsfile _n
file write resultsfile "Job 3,`m_4b_job3_m',`m_4b_job3_f'" _n
file write resultsfile ",`med_4b_job3_m',`med_4b_job3_f'" _n
file write resultsfile ",`sd_4b_job3_m',`sd_4b_job3_f'" _n
file write resultsfile "p-value,`p_4b_job3'" _n
file write resultsfile _n
file write resultsfile _n
file write resultsfile "Question 5b,Males,Females" _n
file write resultsfile "Job 1,`m_5b_job1_m',`m_5b_job1_f'" _n
file write resultsfile ",`med_5b_job1_m',`med_5b_job1_f'" _n
file write resultsfile ",`sd_5b_job1_m',`sd_5b_job1_f'" _n
file write resultsfile "p-value,`p_5b_job1'" _n
file write resultsfile _n
file write resultsfile "Job 2,`m_5b_job2_m',`m_5b_job2_f'" _n
file write resultsfile ",`med_5b_job2_m',`med_5b_job2_f'" _n
file write resultsfile ",`sd_5b_job2_m',`sd_5b_job2_f'" _n
file write resultsfile "p-value,`p_5b_job2'" _n
file write resultsfile _n
file write resultsfile "Job 3,`m_5b_job3_m',`m_5b_job3_f'" _n
file write resultsfile ",`med_5b_job3_m',`med_5b_job3_f'" _n
file write resultsfile ",`sd_5b_job3_m',`sd_5b_job3_f'" _n
file write resultsfile "p-value,`p_5b_job3'" _n
file write resultsfile _n
file write resultsfile _n
file write resultsfile "Question 6b,Males,Females" _n
file write resultsfile "Job 1,`m_6b_job1_m',`m_6b_job1_f'" _n
file write resultsfile ",`med_6b_job1_m',`med_6b_job1_f'" _n
file write resultsfile ",`sd_6b_job1_m',`sd_6b_job1_f'" _n
file write resultsfile "p-value,`p_6b_job1'" _n
file write resultsfile _n
file write resultsfile "Job 2,`m_6b_job2_m',`m_6b_job2_f'" _n
file write resultsfile ",`med_6b_job2_m',`med_6b_job2_f'" _n
file write resultsfile ",`sd_6b_job2_m',`sd_6b_job2_f'" _n
file write resultsfile "p-value,`p_6b_job2'" _n
file write resultsfile _n
file write resultsfile "Job 3,`m_6b_job3_m',`m_6b_job3_f'" _n
file write resultsfile ",`med_6b_job3_m',`med_6b_job3_f'" _n
file write resultsfile ",`sd_6b_job3_m',`sd_6b_job3_f'" _n
file write resultsfile "p-value,`p_6b_job3'" _n
file write resultsfile _n
file write resultsfile _n
file write resultsfile "Question 7b,Males,Females" _n
file write resultsfile "Job 1,`m_7b_job1_m',`m_7b_job1_f'" _n
file write resultsfile ",`med_7b_job1_m',`med_7b_job1_f'" _n
file write resultsfile ",`sd_7b_job1_m',`sd_7b_job1_f'" _n
file write resultsfile "p-value,`p_7b_job1'" _n
file write resultsfile _n
file write resultsfile "Job 2,`m_7b_job2_m',`m_7b_job2_f'" _n
file write resultsfile ",`med_7b_job2_m',`med_7b_job2_f'" _n
file write resultsfile ",`sd_7b_job2_m',`sd_7b_job2_f'" _n
file write resultsfile "p-value,`p_7b_job2'" _n
file write resultsfile _n
file write resultsfile "Job 3,`m_7b_job3_m',`m_7b_job3_f'" _n
file write resultsfile ",`med_7b_job3_m',`med_7b_job3_f'" _n
file write resultsfile ",`sd_7b_job3_m',`sd_7b_job3_f'" _n
file write resultsfile "p-value,`p_7b_job3'" _n
file write resultsfile _n
file write resultsfile _n
file write resultsfile "Question 8b,Males,Females" _n
file write resultsfile "Job 1,`m_8b_job1_m',`m_8b_job1_f'" _n
file write resultsfile ",`med_8b_job1_m',`med_8b_job1_f'" _n
file write resultsfile ",`sd_8b_job1_m',`sd_8b_job1_f'" _n
file write resultsfile "p-value,`p_8b_job1'" _n
file write resultsfile _n
file write resultsfile "Job 2,`m_8b_job2_m',`m_8b_job2_f'" _n
file write resultsfile ",`med_8b_job2_m',`med_8b_job2_f'" _n
file write resultsfile ",`sd_8b_job2_m',`sd_8b_job2_f'" _n
file write resultsfile "p-value,`p_8b_job2'" _n
file write resultsfile _n
file write resultsfile "Job 3,`m_8b_job3_m',`m_8b_job3_f'" _n
file write resultsfile ",`med_8b_job3_m',`med_8b_job3_f'" _n
file write resultsfile ",`sd_8b_job3_m',`sd_8b_job3_f'" _n
file write resultsfile "p-value,`p_8b_job3'" _n
file close resultsfile

restore

********************************************************************************
* Part VI: Demographics
********************************************************************************

preserve
gen surv2016_working = (surv2016 ==1) & (employed != "No")

*--Summary Stats
// Number of respondents
count
local all = r(N)
count if female == 0
local males = r(N)
count if female == 1
local females = r(N)

// Grade Level
gen grade_all = substr(grade_s2,1,1)
destring grade_all, replace
replace grade_all = 4 if grade_all >= 4
tab grade_all
tab grade_all if female == 0
tab grade_all if female == 1

// Age
gen year = birthyear_s2
replace year = birthyear if missing(birthyear_s2)
gen age = 2012 - year
sum age
local age = round(r(mean),.1)
local sd_age = round(r(sd),.1)
sum age if female == 0
local age_0 = round(r(mean),.1)
local sd_age_0 = round(r(sd),.1)
sum age if female == 1
local age_1 = round(r(mean),.1)
local sd_age_1 = round(r(sd),.1)

// Race
gen other = bl_hisp
replace other = oth if missing(other) | bl_hisp == 0
tab white
tab asian
tab other
tab white if female == 0
tab asian if female == 0
tab other if female == 0
tab white if female == 1
tab asian if female == 1
tab other if female == 1

// Parent's Income ($1000)
replace parent_income_all = parent_income_all/1000

// Mother's Education - at least B.A.
replace mother_educ_s2 = mother_educ if missing(mother_educ_s2)
replace mother_educ_s2 = "0" if mother_educ_s2 == "College degree"
replace mother_educ_s2 = "1" if mother_educ_s2 == "Graduate degree"
replace mother_educ_s2 = "2" if mother_educ_s2 == "Grammar school or less"
replace mother_educ_s2 = "3" if mother_educ_s2 == "High school graduate"
replace mother_educ_s2 = "4" if mother_educ_s2 == "Post-secondary school other than college"
replace mother_educ_s2 = "5" if mother_educ_s2 == "Some college"
replace mother_educ_s2 = "6" if mother_educ_s2 == "Some graduate school"
replace mother_educ_s2 = "7" if mother_educ_s2 == "Some high school"
destring mother_educ_s2, replace
gen dummy_mother_educ = 1 if mother_educ_s2 == 0 | mother_educ_s2 == 1 | mother_educ_s2 == 6
replace dummy_mother_educ = 0 if missing(dummy_mother_educ)
tab dummy_mother_educ
tab dummy_mother_educ if female == 0
tab dummy_mother_educ if female == 1

// Father's Education - at least B.A.
replace father_educ_s2 = father_educ if missing(father_educ_s2)
replace father_educ_s2 = "0" if father_educ_s2 == "College degree"
replace father_educ_s2 = "1" if father_educ_s2 == "Graduate degree"
replace father_educ_s2 = "2" if father_educ_s2 == "Grammar school or less"
replace father_educ_s2 = "3" if father_educ_s2 == "High school graduate"
replace father_educ_s2 = "4" if father_educ_s2 == "Post-secondary school other than college"
replace father_educ_s2 = "5" if father_educ_s2 == "Some college"
replace father_educ_s2 = "6" if father_educ_s2 == "Some graduate school"
replace father_educ_s2 = "7" if father_educ_s2 == "Some high school"
destring father_educ_s2, replace
gen dummy_father_educ = 1 if father_educ_s2 == 0 | father_educ_s2 == 1 | father_educ_s2 == 6
replace dummy_father_educ = 0 if missing(dummy_father_educ)
tab dummy_father_educ
tab dummy_father_educ if female == 0
tab dummy_father_educ if female == 1

// Major
foreach major in econ eng hum nat {
	disp "All"
	tab `major'
	disp "Male"
	tab `major' if female == 0
	disp "Female"
	tab `major' if female == 1
}


*--Write to File
foreach var in age parent_income_all sat_math_all sat_verbal_all gpa_overall_all{
	sum `var'
	local `var' = round(r(mean),.01)
	local sd_`var' = round(r(sd),.01)
	ttest `var', by(female)
	local p_`var' = round(r(p),.001)
	local p_`var' = "`p_`var''"
	local `var'_m = round(r(mu_1),.01)
	local `var'_f = round(r(mu_2),.01)
	local sd_`var'_m = round(r(sd_1),.01)
	local sd_`var'_f = round(r(sd_2),.01)

}


*--Chi-squared test for binary variables, Males vs Females
// Grade
gen fresh = (grade_all == 1)
gen soph = (grade_all == 2)
gen jun = (grade_all == 3)
gen sen = (grade_all == 4)
gen mother = dummy_mother_educ
gen father = dummy_father_educ

foreach var in fresh soph jun sen white asian other mother father econ eng hum nat {
	tab `var' female, chi2
	local p_`var' = round(r(p),.001)
	local p_`var' = "`p_`var''"
	qui sum `var'
	local `var'_a = round(r(mean)*100, .01)
	qui sum `var' if female == 1
	local `var'_f = round(r(mean)*100, .01)
	qui sum `var' if female == 0
	local `var'_m = round(r(mean)*100, .01)
	}

// Chi-squared test: distribution across the 4 majors by gender
gen major = "econ" if econ == 1
replace major = "eng" if eng == 1
replace major = "hum" if hum == 1
replace major = "nat" if nat == 1
tab major female, chi2


// Manually add in the proportions
file open resultsfile using "${output}SampleStatistics.csv", write replace
file write resultsfile "Demographic Table" _n
file write resultsfile ",All,Males,Females,p-value" _n
file write resultsfile "Number of respondents, `all',`males',`females'" _n
file write resultsfile _n
file write resultsfile "School Year:" _n
file write resultsfile "Freshmen,`fresh_a'%,`fresh_m'%,`fresh_f'%,`p_fresh'" _n
file write resultsfile "Sophomore,`soph_a'%,`soph_m'%,`soph_f'%,`p_soph'" _n
file write resultsfile "Junior,`jun_a'%,`jun_m'%,`jun_f'%,`p_jun'" _n
file write resultsfile "Senior or more,`sen_a'%,`sen_m'%,`sen_f'%,`p_sen'" _n
file write resultsfile "Mean Age, `age',`age_m', `age_m',`p_age'" _n
file write resultsfile `",="(`sd_age')",="(`sd_age_m')",="(`sd_age_f')","' _n
file write resultsfile "Race:" _n
file write resultsfile "White,`white_a'%,`white_m'%,`white_f'%,=`p_white'" _n
file write resultsfile "Asian,`asian_a'%,`asian_m'%,`asian_f'%,=`p_asian'" _n
file write resultsfile "Non-Asian Minority,`other_a'%,`other_m'%,`other_f'%,`p_other'" _n
file write resultsfile _n
file write resultsfile "Parent's Characteristics:" _n
file write resultsfile "Parents' Income ($1000s),`parent_income_all',`parent_income_all_m',`parent_income_all_f',`p_parent_income_all'" _n
file write resultsfile `",="(`sd_parent_income_all')",="(`sd_parent_income_all_m')",="(`sd_parent_income_all_f')""' _n
file write resultsfile "Mother B.A. or More,`mother_a'%,`mother_m'%,`mother_f'%,`p_mother'" _n
file write resultsfile _n
file write resultsfile "Father B.A. or More,`father_a'%,`father_m'%,`father_f'%,`p_father'" _n
file write resultsfile _n
file write resultsfile "Ability Measures:" _n
file write resultsfile "SAT Math Score,`sat_math_all',`sat_math_all_m',`sat_math_all_f',`p_sat_math_all'" _n
file write resultsfile `",="(`sd_sat_math_all')",="(`sd_sat_math_all_m')",="(`sd_sat_math_all_f')""' _n
file write resultsfile "SAT Verbal Score,`sat_verbal_all',`sat_verbal_all_m',`sat_verbal_all_f',`p_sat_verbal_all'" _n
file write resultsfile `",="(`sd_sat_verbal_all')",="(`sd_sat_verbal_all_m')",="(`sd_sat_verbal_all_f')""' _n
file write resultsfile "GPA,`gpa_overall_all',`gpa_overall_all_m',`gpa_overall_all_f',`p_gpa_overall_all'" _n
file write resultsfile `",="(`sd_gpa_overall_all')",="(`sd_gpa_overall_all_m')",="(`sd_gpa_overall_all_f')""' _n
file write resultsfile "Intended/Current Major" _n
file write resultsfile "Economics,`econ_a'%,`econ_m'%,`econ_f'%,`p_econ'" _n
file write resultsfile "Engineering,`eng_a'%,`eng_m'%,`eng_f'%,`p_eng'" _n
file write resultsfile "Humanities,`hum_a'%,`hum_m'%,`hum_f'%,`p_hum'" _n
file write resultsfile "Natural Science,`nat_a'%,`nat_m'%,`nat_f'%,`p_nat'" _n
file close resultsfile

tempfile original
save `original'
restore

********************************************************************************
* Part VI: Demographics
********************************************************************************
preserve
gen surv2016_working = (surv2016 ==1) & (employed != "No")

*--Summary Stats
// Grade Level
gen grade_all = substr(grade_s2,1,1)
destring grade_all, replace
replace grade_all = 4 if grade_all >= 4

// Age
gen year = birthyear_s2
replace year = birthyear if missing(birthyear_s2)
gen age = 2012 - year

// Race
gen other = bl_hisp
replace other = oth if missing(other) | bl_hisp == 0

// Parent's Income ($1000)
replace parent_income_all = parent_income_all/1000

// Mother's Education - at least B.A.
replace mother_educ_s2 = mother_educ if missing(mother_educ_s2)
replace mother_educ_s2 = "0" if mother_educ_s2 == "College degree"
replace mother_educ_s2 = "1" if mother_educ_s2 == "Graduate degree"
replace mother_educ_s2 = "2" if mother_educ_s2 == "Grammar school or less"
replace mother_educ_s2 = "3" if mother_educ_s2 == "High school graduate"
replace mother_educ_s2 = "4" if mother_educ_s2 == "Post-secondary school other than college"
replace mother_educ_s2 = "5" if mother_educ_s2 == "Some college"
replace mother_educ_s2 = "6" if mother_educ_s2 == "Some graduate school"
replace mother_educ_s2 = "7" if mother_educ_s2 == "Some high school"
destring mother_educ_s2, replace
gen dummy_mother_educ = 1 if mother_educ_s2 == 0 | mother_educ_s2 == 1 | mother_educ_s2 == 6
replace dummy_mother_educ = 0 if missing(dummy_mother_educ)

// Father's Education - at least B.A.
replace father_educ_s2 = father_educ if missing(father_educ_s2)
replace father_educ_s2 = "0" if father_educ_s2 == "College degree"
replace father_educ_s2 = "1" if father_educ_s2 == "Graduate degree"
replace father_educ_s2 = "2" if father_educ_s2 == "Grammar school or less"
replace father_educ_s2 = "3" if father_educ_s2 == "High school graduate"
replace father_educ_s2 = "4" if father_educ_s2 == "Post-secondary school other than college"
replace father_educ_s2 = "5" if father_educ_s2 == "Some college"
replace father_educ_s2 = "6" if father_educ_s2 == "Some graduate school"
replace father_educ_s2 = "7" if father_educ_s2 == "Some high school"
destring father_educ_s2, replace
gen dummy_father_educ = 1 if father_educ_s2 == 0 | father_educ_s2 == 1 | father_educ_s2 == 6
replace dummy_father_educ = 0 if missing(dummy_father_educ)

gen fresh = (grade_all == 1)
gen soph = (grade_all == 2)
gen jun = (grade_all == 3)
gen sen = (grade_all == 4)
gen mother = dummy_mother_educ
gen father = dummy_father_educ

gen major = "econ" if econ == 1
replace major = "eng" if eng == 1
replace major = "hum" if hum == 1
replace major = "nat" if nat == 1

tempfile temp
save `temp', replace
* samples: "" is everyone, "_c" is those who gave consent to contact for followup, "_f" is followup, "_fw" is followup AND working
foreach samp in "" "_c" "_f" "_fw" {
use `temp', clear
if "`samp'" == "" {
}
if "`samp'" == "_c" {
keep if followup == "Yes"
}
if "`samp'" == "_f" {
keep if surv2016 == 1
}
if "`samp'" == "_fw" {
keep if surv2016_working == 1
}

qui count
local N`samp' = r(N)

append using `original', gen(original)
gen samp_var = original == 0
*continuous variables
foreach var in age parent_income_all sat_math_all sat_verbal_all gpa_overall_all{
	sum `var' if samp_var == 1
	local `var'`samp': display %3.2f `r(mean)'
	local sd_`var'`samp': display %3.2f `r(sd)'
	if inlist("`samp'", "_c", "_f", "_fw") {
	ttest `var', by(samp_var)
	local p_`var'`samp' = round(r(p),.001)
	if r(p)< .1  {
	local stars_`var'`samp' "*"
	}
	if r(p)< .05  {
	local stars_`var'`samp' "**"
	}
	if r(p)< .01  {
	local stars_`var'`samp' "***"
	}
	}
}
*binary variables
foreach var in fresh soph jun sen white asian other mother father econ eng hum nat female {
	sum `var' if samp_var == 1
	local `var'`samp': display %3.1f 100*`r(mean)'
	if inlist("`samp'", "_c", "_f", "_fw") {
	tab `var' samp_var, chi2
	local p_`var'`samp' = round(r(p),.001)
	if r(p)< .1  {
	local stars_`var'`samp' "*"
	}
	if r(p)< .05  {
	local stars_`var'`samp' "**"
	}
	if r(p)< .01  {
	local stars_`var'`samp' "***"
	}
	}
}
}
keep if followup == "Yes"

tempfile followup
save `followup'
use `original', clear
foreach samp in "_f" "_fw" {
use `original', clear
if "`samp'" == "_f" {
keep if surv2016 == 1
}
if "`samp'" == "_fw" {
keep if surv2016_working == 1
}

append using `followup', gen(appended_from_followup)
drop samp_var
gen samp_var = appended_from_followup == 0
*continuous variables
foreach var in age parent_income_all sat_math_all sat_verbal_all gpa_overall_all{
	ttest `var', by(samp_var)
	local p_`var'`samp'_c = round(r(p),.001)
	if r(p)< .1  {
	local stars_`var'`samp' = "`stars_`var'`samp''" + "+"
	}
	if r(p)< .05  {
	local stars_`var'`samp' = "`stars_`var'`samp''" + "+"
	}
	if r(p)< .01  {
	local stars_`var'`samp' = "`stars_`var'`samp''" + "+"
	}
}

*binary variables
foreach var in fresh soph jun sen white asian other mother father econ eng hum nat female {
	tab `var' samp_var, chi2
	local p_`var'`samp'_c = round(r(p),.001)
	if r(p)< .1  {
	local stars_`var'`samp' = "`stars_`var'`samp''" + "+"
	}
	if r(p)< .05  {
	local stars_`var'`samp' = "`stars_`var'`samp''" + "+"
	}
	if r(p)< .01  {
	local stars_`var'`samp' = "`stars_`var'`samp''" + "+"
	}
}

}

// Manually add in the proportions
file open resultsfile using "${output}demographics_by_sample.csv", write replace
file write resultsfile "Demographic Table" _n
file write resultsfile ",All,Consent,Followup,Followup (Working)" _n
file write resultsfile "Number of respondents, `N',`N_c',`N_f',`N_fw'" _n
file write resultsfile _n
file write resultsfile "Female,`female'%,`female_c'%`stars_female_c',`female_f'%`stars_female_f',`female_fw'%`stars_female_fw'" _n
file write resultsfile "School Year:" _n
file write resultsfile "Freshmen,`fresh'%,`fresh_c'%`stars_fresh_c',`fresh_f'%`stars_fresh_f',`fresh_fw'%`stars_fresh_fw'" _n
file write resultsfile "Sophomore,`soph'%,`soph_c'%`stars_soph_c',`soph_f'%`stars_soph_f',`soph_fw'%`stars_soph_fw'" _n
file write resultsfile "Junior,`jun'%,`jun_c'%`stars_jun_c',`jun_f'%`stars_jun_f',`jun_fw'%`stars_jun_fw'" _n
file write resultsfile "Senior or more,`sen'%,`sen_c'%`stars_sen_c',`sen_f'%`stars_sen_f',`sen_fw'%`stars_sen_fw'" _n
file write resultsfile "Mean Age,`age',`age_c'`stars_age_c',`age_f'`stars_age_f',`age_fw'`stars_age_fw'" _n
file write resultsfile `",="(`sd_age')",="(`sd_age_c')",="(`sd_age_f')",="(`sd_age_fw')","' _n
file write resultsfile "Race:" _n
file write resultsfile "White,`white'%,`white_c'%`stars_white_c',`white_f'%`stars_white_f',`white_fw'%`stars_white_fw'" _n
file write resultsfile "Asian,`asian'%,`asian_c'%`stars_asian_c',`asian_f'%`stars_asian_f',`asian_fw'%`stars_asian_fw'" _n
file write resultsfile "Non-Asian Minority,`other'%,`other_c'%`stars_other_c',`other_f'%`stars_other_f',`other_fw'%`stars_other_fw'" _n
file write resultsfile _n
file write resultsfile "Parent's Characteristics:" _n
file write resultsfile "Parents' Income ($1000s),`parent_income_all',`parent_income_all_c'`stars_parent_income_all_c',`parent_income_all_f'`stars_parent_income_all_f',`parent_income_all_fw'`stars_parent_income_all_fw'" _n
file write resultsfile `",="(`sd_parent_income_all')",="(`sd_parent_income_all_c')",="(`sd_parent_income_all_f')",="(`sd_parent_income_all_fw')""' _n
file write resultsfile "Mother B.A. or More,`mother'%,`mother_c'%`stars_mother_c',`mother_f'%`stars_mother_f',`mother_fw'%`stars_mother_fw'" _n
file write resultsfile _n
file write resultsfile "Father B.A. or More,`father'%,`father_c'%`stars_father_c',`father_f'%`stars_father_f',`father_fw'%`stars_father_fw'" _n
file write resultsfile _n
file write resultsfile "Ability Measures:" _n
file write resultsfile "SAT Math Score,`sat_math_all',`sat_math_all_c'`stars_sat_math_all_c',`sat_math_all_f'`stars_sat_math_all_f',`sat_math_all_fw'`stars_sat_math_all_fw'" _n
file write resultsfile `",="(`sd_sat_math_all')",="(`sd_sat_math_all_c')",="(`sd_sat_math_all_f')",="(`sd_sat_math_all_fw')""' _n
file write resultsfile "SAT Verbal Score,`sat_verbal_all',`sat_verbal_all_c'`stars_sat_verbal_all_c',`sat_verbal_all_f'`stars_sat_verbal_all_f',`sat_verbal_all_fw'`stars_sat_verbal_all_fw'" _n
file write resultsfile `",="(`sd_sat_verbal_all')",="(`sd_sat_verbal_all_c')",="(`sd_sat_verbal_all_f')",="(`sd_sat_verbal_all_fw')""' _n
file write resultsfile "GPA,`gpa_overall_all',`gpa_overall_all_c'`stars_gpa_overall_all_c',`gpa_overall_all_f'`stars_gpa_overall_all_f',`gpa_overall_all_fw'`stars_gpa_overall_all_fw'" _n
file write resultsfile `",="(`sd_gpa_overall_all')",="(`sd_gpa_overall_all_c')",="(`sd_gpa_overall_all_f')",="(`sd_gpa_overall_all_fw')""' _n
file write resultsfile "Intended/Current Major" _n
file write resultsfile "Economics,`econ'%,`econ_c'%`stars_econ_c',`econ_f'%`stars_econ_f',`econ_fw'%`stars_econ_fw'" _n
file write resultsfile "Engineering,`eng'%,`eng_c'%`stars_eng_c',`eng_f'%`stars_eng_f',`eng_fw'%`stars_eng_fw'" _n
file write resultsfile "Humanities,`hum'%,`hum_c'%`stars_hum_c',`hum_f'%`stars_hum_f',`hum_fw'%`stars_hum_fw'" _n
file write resultsfile "Natural Science,`nat'%,`nat_c'%`stars_nat_c',`nat_f'%`stars_nat_f',`nat_fw'%`stars_nat_fw'" _n
file close resultsfile

local cols 4
local header "\begin{table}\caption{`caption'}\label{`label'} \centering \begin{tabular}{l*{`cols'}{c}}"
local footer "\end{tabular}\end{table}"
// Manually add in the proportions
file open resultsfile using "${output}demographics_by_sample.tex", write replace
file write resultsfile "`header'" _n
file write resultsfile " & All & Consent & Followup & Followup (Working) \\ \hline" _n
file write resultsfile "Number of respondents &  `N' & `N_c' & `N_f' & `N_fw' \\" _n
file write resultsfile " & & & & \\"_n
file write resultsfile "Female & `female'\% &`female_c'\%`stars_female_c' & `female_f'\%`stars_female_f' & `female_fw'\%`stars_female_fw' \\" _n
file write resultsfile "School Year: & & & & \\" _n
file write resultsfile "Freshmen & `fresh'\% & `fresh_c'\%`stars_fresh_c' & `fresh_f'\%`stars_fresh_f' & `fresh_fw'\%`stars_fresh_fw' \\" _n
file write resultsfile "Sophomore & `soph'\% & `soph_c'\%`stars_soph_c' & `soph_f'\%`stars_soph_f' & `soph_fw'\%`stars_soph_fw' \\" _n
file write resultsfile "Junior & `jun'\% & `jun_c'\%`stars_jun_c' & `jun_f'\%`stars_jun_f' & `jun_fw'\%`stars_jun_fw' \\" _n
file write resultsfile "Senior or more & `sen'\% & `sen_c'\%`stars_sen_c' & `sen_f'\%`stars_sen_f' & `sen_fw'\%`stars_sen_fw' \\" _n
file write resultsfile "Mean Age & `age' & `age_c'`stars_age_c' & `age_f'`stars_age_f' & `age_fw'`stars_age_fw' \\" _n
file write resultsfile `" & (`sd_age') & (`sd_age_c') & (`sd_age_f') & (`sd_age_fw') \\ "' _n
file write resultsfile "Race: & & & & \\" _n
file write resultsfile "White & `white'\% & `white_c'\%`stars_white_c' & `white_f'\%`stars_white_f' & `white_fw'\%`stars_white_fw' \\" _n
file write resultsfile "Asian & `asian'\% & `asian_c'\%`stars_asian_c' & `asian_f'\%`stars_asian_f' & `asian_fw'\%`stars_asian_fw' \\" _n
file write resultsfile "Non-Asian Minority & `other'\% & `other_c'\%`stars_other_c' & `other_f'\%`stars_other_f' & `other_fw'\%`stars_other_fw' \\" _n
file write resultsfile " & & & & \\"_n
file write resultsfile "Parent's Characteristics: & & & & \\" _n
file write resultsfile "Parents' Income (\\\$1000s) & `parent_income_all' & `parent_income_all_c'`stars_parent_income_all_c' & `parent_income_all_f'`stars_parent_income_all_f' & `parent_income_all_fw'`stars_parent_income_all_fw' \\"  _n
file write resultsfile `" & (`sd_parent_income_all') & (`sd_parent_income_all_c') & (`sd_parent_income_all_f') & (`sd_parent_income_all_fw') \\"' _n
file write resultsfile "Mother B.A. or More & `mother'\% & `mother_c'\%`stars_mother_c' & `mother_f'\%`stars_mother_f' & `mother_fw'\%`stars_mother_fw' \\" _n
file write resultsfile " & & & & \\"_n
file write resultsfile "Father B.A. or More & `father'\% & `father_c'\%`stars_father_c' & `father_f'\%`stars_father_f' & `father_fw'\%`stars_father_fw' \\" _n
file write resultsfile " & & & & \\"_n
file write resultsfile "Ability Measures: & & & &  \\" _n
file write resultsfile "SAT Math Score & `sat_math_all' & `sat_math_all_c'`stars_sat_math_all_c' & `sat_math_all_f'`stars_sat_math_all_f' & `sat_math_all_fw'`stars_sat_math_all_fw' \\" _n
file write resultsfile `" & (`sd_sat_math_all') & (`sd_sat_math_all_c') & (`sd_sat_math_all_f') & (`sd_sat_math_all_fw') \\"' _n
file write resultsfile "SAT Verbal Score & `sat_verbal_all' & `sat_verbal_all_c'`stars_sat_verbal_all_c' & `sat_verbal_all_f'`stars_sat_verbal_all_f' & `sat_verbal_all_fw'`stars_sat_verbal_all_fw' \\" _n
file write resultsfile `" & (`sd_sat_verbal_all') & (`sd_sat_verbal_all_c') & (`sd_sat_verbal_all_f') & (`sd_sat_verbal_all_fw') \\"' _n
file write resultsfile "GPA & `gpa_overall_all' & `gpa_overall_all_c'`stars_gpa_overall_all_c' & `gpa_overall_all_f'`stars_gpa_overall_all_f' & `gpa_overall_all_fw'`stars_gpa_overall_all_fw' \\" _n
file write resultsfile `" & (`sd_gpa_overall_all') & (`sd_gpa_overall_all_c') & (`sd_gpa_overall_all_f') & (`sd_gpa_overall_all_fw') \\"' _n
file write resultsfile "Intended/Current Major & & & & \\" _n
file write resultsfile "Economics & `econ'\% & `econ_c'\%`stars_econ_c' & `econ_f'\%`stars_econ_f' & `econ_fw'\%`stars_econ_fw' \\" _n
file write resultsfile "Engineering & `eng'\% & `eng_c'\%`stars_eng_c' & `eng_f'\%`stars_eng_f' & `eng_fw'\%`stars_eng_fw' \\" _n
file write resultsfile "Humanities & `hum'\% & `hum_c'\%`stars_hum_c' & `hum_f'\%`stars_hum_f' & `hum_fw'\%`stars_hum_fw' \\" _n
file write resultsfile "Natural Science & `nat'\% & `nat_c'\%`stars_nat_c' & `nat_f'\%`stars_nat_f' & `nat_fw'\%`stars_nat_fw' \\" _n
file write resultsfile "`footer'"
file close resultsfile
restore

}



tempfile maindataset
save `maindataset'


*** descriptive analysis of estimated betas/WTPs
if `redo_percentiles_betas_wtps' == 1 {
foreach m in 1 {
global model = `m'	// 1: estimate earnings and then earnings growth separately
			// 2: estimate earnings and future earnings (generated from earnings growth) separately

global suffix "_model${model}"

foreach type in "Beta" "WTP_dollars" "WTP_percent" {

if "`type'" == "WTP_dollars" {
global wtp_beta_file "${datadir}indv_beta_wtp_dollars${suffix}.dta"
global bs_suffix "dollars"
}
if "`type'" == "WTP_percent" {
global wtp_beta_file "${datadir}indv_beta_wtp_percent${suffix}.dta"
global bs_suffix "percent"
}
if "`type'" == "Beta" {
global wtp_beta_file "${datadir}indv_beta_wtp_percent${suffix}.dta"
global bs_suffix ""
}
if "`type'" == "Beta" {

global vars b1 b2 b3 b4 b5 b6 b7
global decimals .01
}

if "`type'" == "WTP_dollars" | "`type'" == "WTP_percent" {
global vars wtp_fired wtp_bonus wtp_men wtp_raise wtp_hours wtp_pt

if "`type'" == "WTP_dollars" {
global decimals .01
}
if "`type'" == "WTP_percent" {
global decimals .01
}
}

use ${wtp_beta_file}, clear
rename (*fracmale* *parttime*) (*men* *pt*)
***********************************************Part II: Bootstrapping*************************************************
*--Creating the bootstrapped samples
if $redo_bootstrap == 1 {
preserve
foreach g in "" "_m" "_f" {
if "`g'" == "_m" {
local gender_cond " if female == 0"
}
if "`g'" == "_f" {
local gender_cond " if female == 1"
}
if "`g'" == "" {
local gender_cond ""
}

// Overall
foreach var in $vars {
	foreach stat in "mean" "sd" "p50" "p25" "p75" "skewness" "N" {
		local filename = "${`type'_bootstrapdir}" + "`stat'_`var'${bs_suffix}${suffix}`g'"
		postfile memory_`stat' `var' using "`filename'", replace
	}
	forvalues counter=1/$bootstrap_reps {
	use "${wtp_beta_file}", clear  
	rename (*fracmale* *parttime*) (*men* *pt*)
	
	set seed `counter'
	bsample, cluster(id_7d) // resample from full sample
	quietly sum `var' `gender_cond', d
	foreach stat in "mean" "sd" "p50" "p25" "p75" "skewness" "N" {
		post memory_`stat' (r(`stat'))
	}
}
foreach stat in "mean" "sd" "p50" "p25" "p75" "skewness" "N" {
	postclose memory_`stat'
}
}
}
restore
}



foreach var in $vars {
	sum `var', d
	foreach stat in "mean" "sd" "p50" "p25" "p75" "skewness" "N" {
	local `stat'_`var' = round(r(`stat'), ${decimals})
	local `stat'_`var' = round(r(`stat'), ${decimals})
	}
	sum `var' if female == 0, d
	foreach stat in "mean" "sd" "p50" "p25" "p75" "skewness" "N" {
	local `stat'_`var'_m = round(r(`stat'), ${decimals})
	}
	sum `var' if female == 1, d
	foreach stat in "mean" "sd" "p50" "p25" "p75" "skewness" "N" {
	local `stat'_`var'_f = round(r(`stat'), ${decimals})
	}
}

*--Summary Statistics
// Overall
foreach g in "" "_f" "_m" {
	foreach var in $vars  {
		foreach stat in "mean" "sd" "p50" "p25" "p75" "skewness" {
				local d = ${decimals}
				if "`stat'" == "skewness" {
					local d = .01
				}
				local filename = "${`type'_bootstrapdir}" + "`stat'_`var'${bs_suffix}${suffix}`g'"
				use "`filename'", clear // Mean
				quietly sum `var', d
				local se`stat'_`var'`g'  = round(r(sd), `d')				
				local t`stat'_`var'`g'  = ``stat'_`var'`g''/`se`stat'_`var'`g''
				local p`stat'_`var'`g'  = 2*ttail(`N_`var'`g''-1, abs(`t`stat'_`var'`g''))
				local st`stat'_`var'`g'  = ""
				if `p`stat'_`var'`g'' < .1 {
					local st`stat'_`var'`g'  "*"
				}
				
				if `p`stat'_`var'`g'' < .05 {
					local st`stat'_`var'`g'  "**"
				}
				if `p`stat'_`var'`g'' < .01 {
					local st`stat'_`var'`g'  "***"
				}
		}
	}
}

foreach var in $vars  {
	foreach stat in "mean" "sd" "p50" "p25" "p75" "skewness" {

		local tdiff`stat'_`var'_f = (``stat'_`var'_f' - ``stat'_`var'_m')/((`se`stat'_`var'_f'^2+`se`stat'_`var'_m'^2)^(1/2))
		local pdiff`stat'_`var'_f = 2*ttail(`N_`var'_f' + `N_`var'_m' -1, abs(`tdiff`stat'_`var'_f'))
		local stdiff`stat'_`var'_f = ""
		if `pdiff`stat'_`var'_f' < .1 {
			local stdiff`stat'_`var'_f "+"
		}
		
		if `pdiff`stat'_`var'_f' < .05 {
			local stdiff`stat'_`var'_f "++"
		}
		
		if `pdiff`stat'_`var'_f' < .01 {
			local stdiff`stat'_`var'_f "+++"
		}
	
	}
}

foreach var in $vars  {
	foreach stat in "mean" "sd" "p50" "p25" "p75" "skewness" {
		foreach g in "" "_m" "_f" {
			local `stat'_`var'`g': display %9.2f ``stat'_`var'`g''
			local se`stat'_`var'`g': display %9.2f `se`stat'_`var'`g''
		}
	}
}


local mean_lab "Mean"
local p50_lab "Median"
local p25_lab "25th pct."
local p75_lab "75th pct."
local sd_lab "Std. dev"
local skewness_lab "Skewness"

local b1_lab "Age 30 log earnings" 
local b2_lab "Probability of being fired" 
local wtp_fired_lab "Probability of being fired" 
local b3_lab "Bonus as a prop. of earnings" 
local wtp_bonus_lab "Bonus as a prop. of earnings" 
local b4_lab "Prop of males in similar positions" 
local wtp_men_lab "Prop of males in similar positions" 
local b5_lab "\% increase in annual earnings" 
local wtp_raise_lab "\% increase in annual earnings"
local b6_lab "Hours per week of work" 
local wtp_hours_lab "Hours per week of work"
local b7_lab "Part-time option available" 
local wtp_pt_lab "Part-time option available" 

local cols 3
local var1 = word("$vars", 1)
local header "\begin{table}\caption{`caption'}\label{`label'} \centering \begin{tabular}{l*{`cols'}{c}}"
local footer "\end{tabular}\end{table}"
file open table using "${output}mean_`type'${suffix}.tex", write replace
file write table "`header' \hline \hline" _n
file write table "& Overall & Males & Females \\ \hline" _n
foreach var in $vars {
file write table "``var'_lab'"
foreach g in "" "_m" "_f" {
file write table " & `mean_`var'`g''`stmean_`var'`g''`stdiffmean_`var'`g''"
}
file write table "\\" _n
if inlist("`type'", "WTP_dollars", "WTP_percent") {
foreach g in "" "_m" "_f" {
file write table " & [`p50_`var'`g''`stp50_`var'`g''`stdiffp50_`var'`g'']"
}
file write table "\\" _n
}

foreach g in "" "_m" "_f" {
file write table " & (`semean_`var'`g'')"
}
file write table "\\" _n
}
file write table "Oberservations & `N_`var1'' & `N_`var1'_m' & `N_`var1'_f' \\ \hline" _n
file write table _n "`footer'" _n
file close table

local cols 3
local header "\begin{table}\caption{`caption'}\label{`label'} \centering \begin{tabular}{ll*{`cols'}{c}}"
file open table using "${output}stats_`type'${suffix}.tex", write replace
file write table "`header' \hline \hline" _n

file write table " & & Overall & Males & Females \\ \hline" _n
foreach var in $vars {
	file write table "``var'_lab' & & & & \\" _n
	foreach stat in "p50" "p25" "p75" "sd" "skewness" {
		file write table "& ``stat'_lab'"
			foreach g in "" "_m" "_f" {
				file write table "& ``stat'_`var'`g''`st`stat'_`var'`g''`stdiff`stat'_`var'`g''"
			}
		file write table " \\" _n 
	}		
}
file write table " \\" _n "Obersvations & & `N_`var1'' & `N_`var1'_m' & `N_`var1'_f' \\ \hline" _n

file write table "`footer'"
file close table 

}

}
}


use `maindataset', replace

if `redo_Table_6' == 1 {
local model_list 1 2 3 4 5 6 
global vars wtp_fired wtp_bonus wtp_men wtp_raise wtp_hours wtp_pt
***********************************************Part II: Bootstrapping*************************************************
*--Creating the bootstrapped samples
if $redo_bootstrap == 1 {
foreach m in 1 2 3 4 5 6 {
foreach type in "d" "p"  {
global suffix "_model`m'"
if "`type'" == "p" {
local type_long "percent"
}
if "`type'" == "d" {
local type_long "dollars"
}
global wtp_beta_file "${datadir}indv_beta_wtp_`type_long'${suffix}.dta"

use "${wtp_beta_file}", clear
rename (*fracmale* *parttime*) (*men* *pt*)

preserve
foreach g in "" "_m" "_f" {
if "`g'" == "_m" {
local gender_cond " if female == 0"
}
if "`g'" == "_f" {
local gender_cond " if female == 1"
}
if "`g'" == "" {
local gender_cond ""
}

// Overall
foreach var in $vars {
display "`var'`g'"
	foreach stat in "mean" "p50" {
		local filename = "${WTP_`type_long'_bootstrapdir}" + "`stat'_`var'_`type'${suffix}`g'"
		postfile memory_`stat' `var' using "`filename'", replace
	}
	forvalues counter=1/$bootstrap_reps {
	use "${wtp_beta_file}", clear 
	rename (*fracmale* *parttime*) (*men* *pt*)
	
	set seed `counter'
	bsample, cluster(id_7d) // resample from full sample
	quietly sum `var' `gender_cond', d
	foreach stat in "mean" "p50"  {
		post memory_`stat' (r(`stat'))
	}
}
foreach stat in "mean" "p50"  {
	postclose memory_`stat'
}
}
}
restore
}
}
}

// UPDATED 10/6/16: We report the ACTUAL statistics, not bootstrapped means
foreach m in `model_list' {
global suffix "_model`m'"
foreach type in "d" "p"  {
if "`type'" == "p" {
local type_long "percent"
}
if "`type'" == "d" {
local type_long "dollars"
}
use "${datadir}indv_beta_wtp_`type_long'${suffix}.dta", clear
rename (*fracmale* *parttime*) (*men* *pt*)

foreach var in $vars {
	sum `var', d
	foreach stat in "mean" "p50" "N" {
	local `stat'_`var'_`type'`m': display %3.2f `r(`stat')'
	local `stat'_`var'_`type'`m': display %3.2f `r(`stat')'
	}
	sum `var' if female == 0, d
	foreach stat in "mean" "p50" "N"  {
	local `stat'_`var'_`type'_m`m': display %3.2f `r(`stat')'
	}
	sum `var' if female == 1, d
	foreach stat in "mean" "p50" "N"  {
	local `stat'_`var'_`type'_f`m': display %3.2f `r(`stat')'
	}
}

*--Summary Statistics
// Overall
foreach g in "" "_f" "_m" {
	foreach var in $vars  {
		foreach stat in "mean" "p50"  {
				local filename = "${WTP_`type_long'_bootstrapdir}" + "`stat'_`var'_`type'${suffix}`g'"
				use "`filename'", clear // Mean
				quietly sum `var', d
				local se`stat'_`var'_`type'`g'`m': display %3.2f `r(sd)'				
				local t`stat'_`var'_`type'`g'`m'  = ``stat'_`var'_`type'`g'`m''/`se`stat'_`var'_`type'`g'`m''
				local p`stat'_`var'_`type'`g'`m'  = 2*ttail(`N_`var'_`type'`g'`m''-1, abs(`t`stat'_`var'_`type'`g'`m''))
				local st`stat'_`var'_`type'`g'`m'  = ""
				if `p`stat'_`var'_`type'`g'`m'' < .1 {
					local st`stat'_`var'_`type'`g'`m'  "*"
				}
		
				if `p`stat'_`var'_`type'`g'`m'' < .05 {
					local st`stat'_`var'_`type'`g'`m'  "**"
				}
				if `p`stat'_`var'_`type'`g'`m'' < .01 {
					local st`stat'_`var'_`type'`g'`m'  "***"
				}
		}
	}
}

foreach var in $vars  {
	foreach stat in "mean" "p50"  {

		local tdiff`stat'_`var'_`type'_f`m' = (``stat'_`var'_`type'_f`m'' - ``stat'_`var'_`type'_m`m'')/((`se`stat'_`var'_`type'_f`m''^2+`se`stat'_`var'_`type'_m`m''^2)^(1/2))
		local pdiff`stat'_`var'_`type'_f`m' = 2*ttail(`N_`var'_`type'_f`m'' + `N_`var'_`type'_m`m'' -1, abs(`tdiff`stat'_`var'_`type'_f`m''))
		local stdiff`stat'_`var'_`type'_f`m' = ""
		if `pdiff`stat'_`var'_`type'_f`m'' < .1 {
			local stdiff`stat'_`var'_`type'_f`m' "+"
		}
		
		if `pdiff`stat'_`var'_`type'_f`m'' < .05 {
			local stdiff`stat'_`var'_`type'_f`m' "++"
		}
		
		if `pdiff`stat'_`var'_`type'_f`m'' < .01 {
			local stdiff`stat'_`var'_`type'_f`m' "+++"
		}
	
	}
}


} 




foreach type in "d" "p"  {

foreach var in $vars  {
	foreach stat in "mean" "p50"  {
		foreach g in "" "_m" "_f" {
			display `"local tmod`stat'_`var'_`type'`g'`m' = (``stat'_`var'_`type'`g'`m'' - ``stat'_`var'_`type'`g'1')/((`se`stat'_`var'_`type'`g'`m''^2+`se`stat'_`var'_`type'`g'1'^2)^(1/2))"'
			
			local tmod`stat'_`var'_`type'`g'`m' = (``stat'_`var'_`type'`g'`m'' - ``stat'_`var'_`type'`g'1')/((`se`stat'_`var'_`type'`g'`m''^2+`se`stat'_`var'_`type'`g'1'^2)^(1/2))
			
			local pmod`stat'_`var'_`type'`g'`m' = 2*ttail(`N_`var'_`type'`g'`m'' + `N_`var'_`type'`g'1' -1, abs(`tmod`stat'_`var'_`type'`g'`m''))
			display "`pmod`stat'_`var'_`type'`g'`m''"
			local stmod`stat'_`var'_`type'`g'`m' = ""
			
			if `pmod`stat'_`var'_`type'`g'`m'' < .1 {
				local stmod`stat'_`var'_`type'`g'`m' "\^{}"
			}
	
			if `pmod`stat'_`var'_`type'`g'`m'' < .05 {
				local stmod`stat'_`var'_`type'`g'`m' "\^{}\^{}"
			}

			if `pmod`stat'_`var'_`type'`g'`m'' < .01 {
				local stmod`stat'_`var'_`type'`g'`m' "\^{}\^{}\^{}"
			}
			noisily display "`type' `var' `stat'"
			
		
		}
	}
}
}
}


local b1_lab "Age 30 log earnings" 
local b2_lab "Probability of being fired" 
local wtp_fired_lab "Probability of being fired" 
local b3_lab "Bonus as a prop. of earnings" 
local wtp_bonus_lab "Bonus as a prop. of earnings" 
local b4_lab "Prop of males in similar positions" 
local wtp_men_lab "Prop of males in similar positions" 
local b5_lab "\% increase in annual earnings" 
local wtp_raise_lab "\% increase in annual earnings"
local b6_lab "Hours per week of work" 
local wtp_hours_lab "Hours per week of work"
local b7_lab "Part-time option available" 
local wtp_pt_lab "Part-time option available" 


local cols 6
local header "\begin{table}\caption{`caption'}\label{`label'} \centering \begin{tabular}{l*{`cols'}{c}}"
local footer "\end{tabular}\end{table}"
local m = 1
global suffix "_model`m'"
file open table using "${output}Table_6_WTP_estimates${suffix}.tex", write replace
file write table "`header' \hline \hline" _n
file write table " & WTP(Dollars) &  &  & WTP (as \% of average earnings) &  &  \\ \hline" _n
file write table " & Overall & Males & Females & Overall & Males & Females\\ \hline" _n
foreach var in $vars {
	file write table "``var'_lab'"
	foreach type in "d" "p" {
	foreach g in "" "_m" "_f" {
	file write table " & `mean_`var'_`type'`g'`m''`stmean_`var'_`type'`g'`m''`stdiffmean_`var'_`type'`g'`m''"
	}
	}
	file write table " \\" _n
	foreach type in "d" "p" {
	foreach g in "" "_m" "_f" {
	file write table " & (`semean_`var'_`type'`g'`m'')"
	}
	}
	file write table " \\" _n		
	foreach type in "d" "p" {
	foreach g in "" "_m" "_f" {
	file write table " & [`p50_`var'_`type'`g'`m'']`stp50_`var'_`type'`g'`m''`stdiffp50_`var'_`type'`g'`m''"
	}
	}
	file write table " \\" _n	
}

file write table "`footer'"
file close table 

file open table using "${output}Table_6_WTP_estimates${suffix}.csv", write replace
file write table ", WTP(Dollars),,, WTP (as \% of average earnings),,  \\ \hline" _n
file write table ", Overall, Males, Females, Overall, Males, Females\\ \hline" _n
foreach var in $vars {
	file write table "``var'_lab'"
	foreach type in "d" "p" {
	foreach g in "" "_m" "_f" {
	file write table ", `mean_`var'_`type'`g'`m''`stmean_`var'_`type'`g'`m''`stdiffmean_`var'_`type'`g'`m''"
	}
	}
	file write table _n	
	foreach type in "d" "p" {
	foreach g in "" "_m" "_f" {
	file write table `",="(`semean_`var'_`type'`g'`m'')""'
	}
	}
	file write table _n		
	foreach type in "d" "p" {
	foreach g in "" "_m" "_f" {
	file write table ", [`p50_`var'_`type'`g'`m'']`stp50_`var'_`type'`g'`m''`stdiffp50_`var'_`type'`g'`m''"
	}
	}
	file write table _n
}

file close table 




local type "p"
foreach model in 2 3 4 5 6 {
global suffix "_model`model'"

file open table using "${output}ComparingModels_WTP_estimates${suffix}.csv", write replace
file write table ", Model 1,,, Model `model',,  \\ \hline" _n
file write table ", Overall, Males, Females, Overall, Males, Females\\ \hline" _n
foreach var in $vars {
	file write table "``var'_lab'"
	foreach m in 1 `model' {
	foreach g in "" "_m" "_f" {
	file write table ", `mean_`var'_`type'`g'`m''`stmean_`var'_`type'`g'`m''`stdiffmean_`var'_`type'`g'`m''`stmodp50_`var'_`type'`g'`m''"
	}
	}
	file write table _n	
	foreach m in 1 `model' {
	foreach g in "" "_m" "_f" {
	file write table `",="(`semean_`var'_`type'`g'`m'')""'
	}
	}
	file write table _n		
	foreach m in 1 `model' {
	foreach g in "" "_m" "_f" {
	file write table ", [`p50_`var'_`type'`g'`m'']`stp50_`var'_`type'`g'`m''`stdiffp50_`var'_`type'`g'`m''`stmodp50_`var'_`type'`g'`m''"
	}
	}
	file write table _n
}


file close table 
local cols 6
local header "\begin{table}\caption{`caption'}\label{`label'} \centering \begin{tabular}{l*{`cols'}{c}}"
local footer "\end{tabular}\end{table}"
file open table using "${output}ComparingModels_WTP_estimates${suffix}.tex", write replace
file write table "`header' \hline \hline" _n
file write table "& Model 1 & & & Model `model' & &  \\ \hline" _n
file write table "&  Overall & Males & Females & Overall & Males & Females\\ \hline" _n
foreach var in $vars {
	file write table "``var'_lab'"
	foreach m in 1 `model' {
	foreach g in "" "_m" "_f" {
	file write table " & `mean_`var'_`type'`g'`m''`stmean_`var'_`type'`g'`m''`stdiffmean_`var'_`type'`g'`m''`stmodp50_`var'_`type'`g'`m''"
	}
	}
	file write table " \\" _n 	
	foreach m in 1 `model' {
	foreach g in "" "_m" "_f" {
	file write table `" & (`semean_`var'_`type'`g'`m'')"'
	}
	}
	file write table " \\" _n 	
	foreach m in 1 `model' {
	foreach g in "" "_m" "_f" {
	file write table " & [`p50_`var'_`type'`g'`m'']`stp50_`var'_`type'`g'`m''`stdiffp50_`var'_`type'`g'`m''`stmodp50_`var'_`type'`g'`m''"
	}
	}
	file write table " \\" _n 	
}
file write table "`footer'" _n

file close table 


}



}


use `maindataset', replace

********************************************************************************
* Part III: WTP by Observables
********************************************************************************
if `redo_heterogoneity' == 1 {

merge 1:1 id_7d using "${datadir}indv_beta_wtp_percent_model1.dta", nogen

global varnames wtp_fired wtp_bonus wtp_fracmale wtp_raise wtp_hours wtp_parttime
*--Create demographic variables
// Probability of being married
gen prob_ft = 0
foreach maj in "econ" "eng" "hum" "nat" "nograd" {
replace prob_ft = prob_ft + self_ft_`maj'_s2/100*self_grad_`maj'_s2/100
}

gen ft = prob_ft > .8 if !missing(prob_ft) 
// Parent's Income: above average vs below median income
sum parent_income_all, d
gen parinc = 1 if parent_income_all > 87500
replace parinc = 0 if parent_income_all <= 87500 & !missing(parent_income_all)
label var parinc "=1 if parents' income is above median"

// Prob. of full-time work
gen prob_fulltime = 0
foreach maj in "econ" "hum" "eng" "nat" {
replace prob_fulltime = prob_fulltime + self_grad_`maj'_s2/100*self_ft_`maj'_s2/100
}

// Parent's Education
replace mother_educ_s2 = mother_educ if missing(mother_educ_s2)
replace mother_educ_s2 = "0" if mother_educ_s2 == "College degree"
replace mother_educ_s2 = "1" if mother_educ_s2 == "Graduate degree"
replace mother_educ_s2 = "2" if mother_educ_s2 == "Grammar school or less"
replace mother_educ_s2 = "3" if mother_educ_s2 == "High school graduate"
replace mother_educ_s2 = "4" if mother_educ_s2 == "Post-secondary school other than college"
replace mother_educ_s2 = "5" if mother_educ_s2 == "Some college"
replace mother_educ_s2 = "6" if mother_educ_s2 == "Some graduate school"
replace mother_educ_s2 = "7" if mother_educ_s2 == "Some high school"
destring mother_educ_s2, replace
gen dummy_mother_educ = 1 if mother_educ_s2 == 0 | mother_educ_s2 == 1 | mother_educ_s2 == 5 | mother_educ_s2 == 6
replace dummy_mother_educ = 0 if missing(dummy_mother_educ)
replace father_educ_s2 = father_educ if missing(father_educ_s2)
replace father_educ_s2 = "0" if father_educ_s2 == "College degree"
replace father_educ_s2 = "1" if father_educ_s2 == "Graduate degree"
replace father_educ_s2 = "2" if father_educ_s2 == "Grammar school or less"
replace father_educ_s2 = "3" if father_educ_s2 == "High school graduate"
replace father_educ_s2 = "4" if father_educ_s2 == "Post-secondary school other than college"
replace father_educ_s2 = "5" if father_educ_s2 == "Some college"
replace father_educ_s2 = "6" if father_educ_s2 == "Some graduate school"
replace father_educ_s2 = "7" if father_educ_s2 == "Some high school"
destring father_educ_s2, replace
gen dummy_father_educ = 1 if father_educ_s2 == 0 | father_educ_s2 == 1 | father_educ_s2 == 5 | father_educ_s2 == 6
replace dummy_father_educ = 0 if missing(dummy_father_educ)

// Combine Parents' Educations
gen pareduc = 1 if dummy_mother_educ == 1 & dummy_father_educ == 1
replace pareduc = 0 if inlist(dummy_mother_educ, 0) | inlist(dummy_father_educ, 0)
label var pareduc "=1 if both parents have some college"

// Grade Level: upper vs lower classmen
gen grade_all = substr(grade_s2,1,1)
destring grade_all, replace
gen senior = grade_all >= 4

// Above Median SAT 
gen total_sat = sat_math_all + sat_verbal_all
rename sat_verbal_all sat_verb_all
foreach subj in math verb {
sum sat_`subj'_all, d
local median_sat_`subj' = `r(p50)'
gen `subj'_above = 1 if sat_`subj'_all > `median_sat_`subj''
replace `subj'_above = 0 if sat_`subj'_all < `median_sat_`subj'' & !missing(sat_`subj'_all)
label var `subj'_above "=1 if above median `subj' SAT score"

// Create Dummys for Missing SAT Score
gen dummy_`subj' = 1 if missing(`subj'_above)
replace dummy_`subj' = 0 if !missing(`subj'_above)
replace `subj'_above = 0 if dummy_`subj' == 1
label var dummy_`subj' "Missing `subj' SAT Scores"
}



// Marriage and Children Beliefs
gen marriage = (self_married_econ_s2*(self_grad_econ_s2/100)+self_married_eng_s2*(self_grad_eng_s2/100)+ ///
	self_married_hum_s2*(self_grad_hum_s2/100)+self_married_nat_s2*(self_grad_nat_s2/100))
	*+ self_married_nograd_s2*(self_grad_nograd_s2/100))/100 // Probability of being married at age 30, out of 1
gen nochild_all = nochild_econ_30_s2*(self_grad_econ_s2/100)+nochild_eng_30_s2*(self_grad_eng_s2/100) + ///
	nochild_hum_30_s2*(self_grad_hum_s2/100)+nochild_nat_30_s2*(self_grad_nat_s2/100) 
	*+ nochild_nograd_30_s2*(self_grad_nograd_s2/100)
gen onechild_all = onechild_econ_30_s2*(self_grad_econ_s2/100)+onechild_eng_30_s2*(self_grad_eng_s2/100) + ///
	onechild_hum_30_s2*(self_grad_hum_s2/100)+onechild_nat_30_s2*(self_grad_nat_s2/100) 
	*+ onechild_nograd_30_s2*(self_grad_nograd_s2/100)
gen twochild_all = twochild_econ_30_s2*(self_grad_econ_s2/100)+twochild_eng_30_s2*(self_grad_eng_s2/100) + ///
	twochild_hum_30_s2*(self_grad_hum_s2/100)+twochild_nat_30_s2*(self_grad_nat_s2/100) 
	*+ twochild_nograd_30_s2*(self_grad_nograd_s2/100)	
gen threechild_all = threechild_econ_30_s2*(self_grad_econ_s2/100)+threechild_eng_30_s2*(self_grad_eng_s2/100) + ///
	threechild_hum_30_s2*(self_grad_hum_s2/100)+threechild_nat_30_s2*(self_grad_nat_s2/100) 
	*+ threechild_nograd_30_s2*(self_grad_nograd_s2/100)

gen children = 0*(nochild_all/100) + 1*(onechild_all/100) + 2*(twochild_all/100) + 3*(threechild_all/100)	

// Above Median marriage
sum marriage, d
local med_marriage = r(p50)
gen marry = 1 if marriage > `med_marriage'
replace marry = 0 if marriage <= `med_marriage'
label var marry "=1 if probability of being marriage by age 30 is above median"

// UPDATED 6/28/16: Cut fertility so one group has 1/3
sum children, d
*local med_children = r(p50)
gen kids = children > r(p50) if !missing(children)  // prob of having 0 kids
*label var kids "=1 if number of children is above median"
label var kids "=1 if expects to have kids"
gen kids_gt_0 = 1 if children > 0 & !missing(children)  // prob of having 0 kids
replace kids_gt_0 = 0 if children == 0
label var kids_gt_0 "=1 if Exp. Pr(Have kids > 0)"

gen econ_gt_50 = self_grad_econ_s2 > 50
gen prob_econ = self_grad_econ_s2
save ${datadir}indv_beta_wtp_percent_model1_withdemos, replace

preserve
*************--Bootstrap WTP
if $redo_bootstrap == 1 {

foreach var in female math_above verb_above white parinc pareduc marry kids kids_gt_0 ft econ_gt_50 senior {
foreach b in $varnames {
	// Below (var == 0)
	postfile memory_mean `b' using "${output}WTP_Bootstrap//`b'_`var'_0_model1", replace
	forvalues counter=1/${bootstrap_reps} {
	use ${datadir}indv_beta_wtp_percent_model1_withdemos, clear
	set seed `counter'
	bsample, cluster(id_7d) // resample from full sample
	quietly sum `b' if `var' == 0, d
	post memory_mean (r(mean))
}
postclose memory_mean
}
foreach b in $varnames {
	// Above (var == 1)
	postfile memory_mean `b' using "${output}WTP_Bootstrap//`b'_`var'_1_model1", replace
	forvalues counter=1/${bootstrap_reps} {
	use ${datadir}indv_beta_wtp_percent_model1_withdemos, clear
	set seed `counter'
	bsample, cluster(id_7d) // resample from full sample
	quietly sum `b' if `var' == 1, d
	post memory_mean (r(mean))
}
postclose memory_mean
}
}
}

*************--WTP Summary Stats
foreach var in female math_above verb_above white parinc pareduc marry kids kids_gt_0 ft econ_gt_50 senior {
foreach b in $varnames {
	
	*--Below (var == 0)
	// Actual mean
	use ${datadir}indv_beta_wtp_percent_model1_withdemos, clear
	quietly sum `b' if `var' == 0, d
	local `var'_`b'_0 = round(r(mean),.01)
	local N_`var'_`b'_0 = r(N)
	// Bootstrapped SE
	use "${output}WTP_Bootstrap/`b'_`var'_0_model1", clear
	quietly sum `b', d
	local se_`var'_`b'_0 = round(r(sd),.01)
	
	*--Above (var == 1)
	// Actual mean
	use ${datadir}indv_beta_wtp_percent_model1_withdemos, clear
	quietly sum `b' if `var' == 1, d
	local `var'_`b'_1 = round(r(mean),.01)
	local N_`var'_`b'_1 = r(N)
	// Bootstrapped SE	
	use "${output}WTP_Bootstrap/`b'_`var'_1_model1", clear
	quietly sum `b', d
	local se_`var'_`b'_1 = round(r(sd),.01)
}
}

// Percent in each group
use ${datadir}indv_beta_wtp_percent_model1_withdemos, clear


*************--WTP for Marriage and Kids by Gender
*--Bootstrap
if $redo_bootstrap == 1 {

foreach var in marry kids kids_gt_0 {
foreach b in $varnames {
	// Above Median & Male
	postfile memory_mean `b' using "${output}WTP_Bootstrap//`b'_`var'_1_m_model1", replace
	forvalues counter=1/${bootstrap_reps} {
	use ${datadir}indv_beta_wtp_percent_model1_withdemos, clear
	set seed `counter'
	bsample, cluster(id_7d) // resample from full sample
	quietly sum `b' if `var' == 1 & female == 0, d
	post memory_mean (r(mean))
}
postclose memory_mean
}
foreach b in $varnames {
	// Above Median & Female
	postfile memory_mean `b' using "${output}WTP_Bootstrap//`b'_`var'_1_f_model1", replace
	forvalues counter=1/${bootstrap_reps} {
	use ${datadir}indv_beta_wtp_percent_model1_withdemos, clear
	set seed `counter'
	bsample, cluster(id_7d) // resample from full sample
	quietly sum `b' if `var' == 1 & female == 1, d
	post memory_mean (r(mean))
}
postclose memory_mean
}
foreach b in $varnames {
	// Below Median & Male
	postfile memory_mean `b' using "${output}WTP_Bootstrap//`b'_`var'_0_m_model1", replace
	forvalues counter=1/${bootstrap_reps} {
	use ${datadir}indv_beta_wtp_percent_model1_withdemos, clear
	set seed `counter'
	bsample, cluster(id_7d) // resample from full sample
	quietly sum `b' if `var' == 0 & female == 0, d
	post memory_mean (r(mean))
}
postclose memory_mean
}
foreach b in $varnames {
	// Below Median & Female
	postfile memory_mean `b' using "${output}WTP_Bootstrap//`b'_`var'_0_f_model1", replace
	forvalues counter=1/${bootstrap_reps} {
	use ${datadir}indv_beta_wtp_percent_model1_withdemos, clear
	set seed `counter'
	bsample, cluster(id_7d) // resample from full sample
	quietly sum `b' if `var' == 0 & female == 1, d
	post memory_mean (r(mean))
}
postclose memory_mean
}
}
}
*--Summary Stats
foreach var in marry kids kids_gt_0 {
foreach b in $varnames {
	*--Above Median and Male
	// Actual mean
	use ${datadir}indv_beta_wtp_percent_model1_withdemos, clear
	quietly sum `b' if `var' == 1 & female ==0, d
	local `var'_`b'_1_m = round(r(mean),.01)
	local N_`var'_`b'_1_m = r(N)
	// Bootstrapped SE		
	use "${output}WTP_Bootstrap//`b'_`var'_1_m_model1", clear
	quietly sum `b', d
	local se_`var'_`b'_1_m = round(r(sd),.01)	
	
	*--Above Median and Female
	// Actual mean
	use ${datadir}indv_beta_wtp_percent_model1_withdemos, clear
	quietly sum `b' if `var' == 1 & female == 1, d
	local `var'_`b'_1_f = round(r(mean),.01)
	local N_`var'_`b'_1_f = r(N)
	// Bootstrapped SE			
	use "${output}WTP_Bootstrap//`b'_`var'_1_f_model1", clear
	quietly sum `b', d
	local se_`var'_`b'_1_f = round(r(sd),.01)	

	*--Below Median and Male
	// Actual mean
	use ${datadir}indv_beta_wtp_percent_model1_withdemos, clear
	quietly sum `b' if `var' == 0 & female ==0, d
	local `var'_`b'_0_m = round(r(mean),.01)
	local N_`var'_`b'_0_m = r(N)
	// Bootstrapped SE			
	use "${output}WTP_Bootstrap//`b'_`var'_0_m_model1", clear
	quietly sum `b', d
	local se_`var'_`b'_0_m = round(r(sd),.01)	
	
	*--Below Median and Female
	// Actual mean
	use ${datadir}indv_beta_wtp_percent_model1_withdemos, clear
	quietly sum `b' if `var' == 0 & female ==1, d
	local `var'_`b'_0_f = round(r(mean),.01)
	local N_`var'_`b'_0_f = r(N)
	// Bootstrapped SE			
	use "${output}WTP_Bootstrap//`b'_`var'_0_f_model1", clear
	quietly sum `b', d
	local se_`var'_`b'_0_f = round(r(sd),.01)		
}
}
foreach b in $varnames {
foreach cut in female math_above verb_above white parinc pareduc marry senior kids kids_gt_0 ft econ_gt_50 {
foreach n in 0 1 {
local sd_`cut'_`b'_`n' = `se_`cut'_`b'_`n''*(`N_`cut'_`b'_`n'')^(1/2)
local t_`cut'_`b'_`n' = ``cut'_`b'_`n''/`se_`cut'_`b'_`n''
local p_`cut'_`b'_`n' = 2*ttail(`N_`cut'_`b'_`n''-1, abs(`t_`cut'_`b'_`n''))
local s_`cut'_`b'_`n' = ""

if `p_`cut'_`b'_`n'' < .1 {
local s_`cut'_`b'_`n' "*"
}
if `p_`cut'_`b'_`n'' < .05 {
local s_`cut'_`b'_`n' "**"
}
if `p_`cut'_`b'_`n'' < .01 {
local s_`cut'_`b'_`n' "***"
}
}
local t_diff_`cut'_`b' = abs((``cut'_`b'_1' - ``cut'_`b'_0')/((`se_`cut'_`b'_1'^2 +`se_`cut'_`b'_0'^2)^(1/2)))
local p_diff_`cut'_`b' = 2*ttail(`N_`cut'_`b'_1' + `N_`cut'_`b'_0'-1, abs(`t_diff_`cut'_`b''))
local s_diff_`cut'_`b' = ""
if `p_diff_`cut'_`b'' < .1 {
local s_diff_`cut'_`b' "+"
}
if `p_diff_`cut'_`b'' < .05 {
local s_diff_`cut'_`b' "++"
}
if `p_diff_`cut'_`b'' < .01 {
local s_diff_`cut'_`b' "+++"
}
}

}
foreach b in $varnames {
foreach cut in marry kids kids_gt_0 {
foreach g in "f" "m" {
foreach n in 0 1 {
local t_`cut'_`b'_`n'_`g' = ``cut'_`b'_`n'_`g''/`se_`cut'_`b'_`n'_`g''
local p_`cut'_`b'_`n'_`g' = 2*ttail(`N_`cut'_`b'_`n'_`g''-1, abs(`t_`cut'_`b'_`n'_`g''))
local s_`cut'_`b'_`n'_`g' = ""
if `p_`cut'_`b'_`n'_`g'' < .1 {
local s_`cut'_`b'_`n'_`g' "*"
}
if `p_`cut'_`b'_`n'_`g'' < .05 {
local s_`cut'_`b'_`n'_`g' "**"
}
if `p_`cut'_`b'_`n'_`g'' < .01 {
local s_`cut'_`b'_`n'_`g' "***"
}
}


local t_diff_`cut'_`b'_`g' = abs((``cut'_`b'_1_`g'' - ``cut'_`b'_0_`g'')/((`se_`cut'_`b'_1_`g''^2+`se_`cut'_`b'_0_`g''^2)^(1/2)))
local p_diff_`cut'_`b'_`g' = 2*ttail(`N_`cut'_`b'_1_`g'' + `N_`cut'_`b'_0_`g''-1, abs(`t_diff_`cut'_`b'_`g''))
local s_diff_`cut'_`b'_`g' = ""

if `p_diff_`cut'_`b'_`g'' < .1 {
local s_diff_`cut'_`b'_`g' "+"
}
if `p_diff_`cut'_`b'_`g'' < .05 {
local s_diff_`cut'_`b'_`g' "++"
}
if `p_diff_`cut'_`b'_`g'' < .01 {
local s_diff_`cut'_`b'_`g' "+++"
}
}
}
}
foreach cut in "female" "math_above" "verb_above" "white" "pareduc" "marry" "kids" "kids_gt_0" "senior" "ft" "econ_gt_50" {
	foreach b in $varnames {
		foreach n in 0 1 {
			foreach stat in "" "se_" {
				if length("``stat'`cut'_`b'_`n''") > strpos("``stat'`cut'_`b'_`n''", ".") + 2 & strpos("``stat'`cut'_`b'_`n''", ".") != 0{
					local `stat'`cut'_`b'_`n' = substr("``stat'`cut'_`b'_`n''", 1, strpos("``stat'`cut'_`b'_`n''", ".") + 2)
				}
			display "``stat'`cut'_`b'_`n''"
			}
		}
	}
}


local firstvar = word("$varnames", 1)

file open results using "${output}WTP_heterogeneity_model1.csv", write replace
file write results "WTP" _n
file write results ",,N,Fired,Bonus,Prop. of Male,Raise, Hours,Part-time" _n
// Gender
foreach cut in "female" "math_above" "verb_above" "white" "pareduc" "parinc" "marry" "kids" "kids_gt_0" "senior" "ft" "econ_gt_50" {
if "`cut'" == "female" {
local yes  "Gender,Female,"
local no ",Male,"
}
if "`cut'" == "verb_above" {
local yes  "SAT Verbal Score,Above Median (690),"
local no ",Below Median,"
}
if "`cut'" == "math_above" {
local yes  "SAT Math Score,Above Median (710),"
local no ",Below Median,"
}
if "`cut'" == "white" {
local yes  "Race,White,"
local no ",Nonwhite,"
}
if "`cut'" == "pareduc" {
local yes  "Parents' Education,At least some college,"
local no ",No college,"
}
if "`cut'" == "parinc" {
local yes  "Parents' Income,Above Median,"
local no ",Below Median,"
}

if "`cut'" == "marry" {
local yes  "Marriage by Age 30,Above Median (60%),"
local no ",Below Median,"
}
if "`cut'" == "kids" {
local yes  "Number of Children,Above Median (0.91),"
local no ",Below Median,"
}
if "`cut'" == "kids_gt_0" {
local yes  "Prob. Have Children,Positive,"
local no ",Zero,"
}
if "`cut'" == "senior" {
local yes  "Grade,Senior or older,"
local no ",Junior or younger,"
}
if "`cut'" == "ft" {
local yes  "Prob of full-time work, >80%,"
local no ",<= 80%,"
}
if "`cut'" == "econ_gt_50" {
local yes  "Economics Probability, >50%,"
local no ",<= 50%,"
}

file write results _n "`yes'`N_`cut'_`firstvar'_1',"
foreach b in $varnames {
file write results "``cut'_`b'_1'`s_`cut'_`b'_1'`s_diff_`cut'_`b'',"
}
file write results _n ",, ,"
foreach b in $varnames {
file write results `"="(`se_`cut'_`b'_1')","'

}


file write results _n "`no' `N_`cut'_`firstvar'_0',"
foreach b in $varnames {
file write results "``cut'_`b'_0'`s_`cut'_`b'_0',"
}
file write results _n ",,,"
foreach b in $varnames {
file write results `"="(`se_`cut'_`b'_0')","'
}
}

file close results


file open results using "${output}WTP_heterogeneity_model1.tex", write replace
local cols 8
local header "\begin{table}\caption{`caption'}\label{`label'} \centering \begin{tabular}{ll*{`cols'}{c}}"
local footer "\end{tabular}\end{table}"
file write results "`header' \hline \hline" _n

file write results "Characteristics & & N  & Fired & Bonus & Prop. Men & Raise & Hours & Part-time \\ \hline"
// Gender
foreach cut in "female" "math_above" "verb_above" "white" "pareduc" "parinc" "marry" "kids" "kids_gt_0" "senior" "ft" "econ_gt_50" {
if "`cut'" == "female" {
local yes  "Gender &Female &"
local no "& Male &"
}
if "`cut'" == "math_above" {
local yes  "SAT Math Score & Above Median (710) &"
local no "& Below Median &"
}
if "`cut'" == "verb_above" {
local yes  "SAT Verbal Score & Above Median (690) &"
local no "& Below Median &"
}
if "`cut'" == "white" {
local yes  "Race & White &"
local no " & Nonwhite &"
}
if "`cut'" == "pareduc" {
local yes  "Parents' Education & At least some college &"
local no "& No college &"
}
if "`cut'" == "parinc" {
local yes  "Parents' Income & Above Median & "
local no " & Below Median & "
}
if "`cut'" == "marry" {
local yes  "Marriage by Age 30 & Above Median (60\%) &"
local no " & Below Median &"
}
if "`cut'" == "kids" {
local yes  "Number of Children & Above Median (0.91) &"
local no "& Below Median &"
}
if "`cut'" == "kids_gt_0" {
local yes  "Prob. Have Children & Positive &"
local no "& Zero & "
}
if "`cut'" == "senior" {
local yes  "Grade & Senior or older &"
local no "& Junior or younger &"
}
if "`cut'" == "ft" {
local yes  "Prob of full-time work & $>$80\% &"
local no "& $<=$ 80\% &"
}
if "`cut'" == "econ_gt_50" {
local yes  "Economics Probability & $>$50\% &"
local no "& $<=$ 50\% &"
}

file write results _n "`yes'`N_`cut'_`firstvar'_1'"
foreach b in $varnames {
file write results "& ``cut'_`b'_1'`s_`cut'_`b'_1'`s_diff_`cut'_`b''"
}
file write results " \\" _n "& & "
foreach b in $varnames {
file write results `"& (`se_`cut'_`b'_1')"'

}


file write results " \\" _n "`no' `N_`cut'_`firstvar'_0' "
foreach b in $varnames {
file write results " & ``cut'_`b'_0'`s_`cut'_`b'_0'"
}
file write results " \\" _n "& & "
foreach b in $varnames {
file write results `"& (`se_`cut'_`b'_0')"'
}
file write results " \\"

}
file write results " \\ \hline" _n
file write results "`footer'"
file close results
restore


********************************************************************************
* Part II: Regress WTP on Observables
********************************************************************************



// Multivariate Regression on All Observables
local all female math_above verb_above white parinc pareduc marry kids ft senior
foreach var in math_above verb_above white parinc pareduc marry kids ft econ_gt_50 senior {
gen `var'Xfemale = `var'*female
}

label variable female "Female"

label variable math_above "SAT math above median"
label variable math_aboveXfemale "SAT math above median X female"

label variable verb_above "SAT verbal above median"
label variable verb_aboveXfemale "SAT verbal above median X female"

label variable white "White"
label variable whiteXfemale "White X female"

label variable parinc "Parent income above median"
label variable parincXfemale "Parent income above median X female"

label variable pareduc "Parents educated"
label variable pareducXfemale "Parents educated X female"

label variable marry "Prob. will marry above median"
label variable marryXfemale "Prob. will marry above median X female"

label variable kids "Prob. will have kids above median"
label variable kidsXfemale "Prob. will have kids above median X female"

label variable ft "Prob. will work fulltime above median"
label variable ftXfemale "Prob. will work fulltime above median X female"

label variable econ_gt_50 "Prob. major in econ above median"
label variable econ_gt_50Xfemale "Prob. major in econ above median X female"

label variable prob_econ "Prob. major in econ"
*label variable prob_econXfemale "Prob. major in econ X female"

label variable senior "Senior"
label variable seniorXfemale "Senior X female"

eststo clear

foreach b of varlist  wtp_* {
	eststo, title("`b'"): bootstrap, rep(${bootstrap_reps}) cluster(id_7d) seed (1): reg `b' `all' 
	estadd ysumm
}


esttab using "${output}WTP_reg.csv", se replace ///
	stats(ymean r2 N, label("Mean of Dep. Var." "R-squared" "Number of Observations") fmt(%6.3g %6.4g %8.1g %6.0g %8.2g)) ///
	star(+ 0.15 * 0.10 ** 0.05 *** 0.01) mtitles("Fired" "Bonus" "Prop. of Male" "Raise" "Hours" "Parttime") ///
	constant label b(2) se(2)
esttab using "${output}WTP_reg.tex", se replace ///
	stats(ymean r2 N, label("Mean of Dep. Var." "R-squared" "Number of Observations") fmt(%6.3g %6.4g %8.1g %6.0g %8.2g)) ///
	star(+ 0.15 * 0.10 ** 0.05 *** 0.01) mtitles("Fired" "Bonus" "Prop. of Male" "Raise" "Hours" "Parttime") ///
	constant label b(2) se(2)


}



use `maindataset', replace


**** Followup survey analysis
if `redo_followup_analysis' == 1 {



gen in_followup_survey = surv2016
// Observed job characteristics from 2016 survey
egen working = group(employed)

cap log close
log using "${output}TableA7_PanelB.txt", text replace
*** These tabs give the numbers for panel B of Table A7
tab working
tab working if female == 1 
tab working if female == 0
log close
drop if working == 1  // currently not working

destring income, replace

gen log_income = log(income)
replace log_income = .0001 if income==0

destring percent_chance_fired, replace

rename (av_an_inc_earnings_colleagues percent_colleagues_laid_off) (percent_increase_colleagues colleagues_laid_off)
foreach perc in colleagues_laid_off percent_pay_bonus percent_colleagues_male percent_increase_colleagues{
	replace `perc' = substr(`perc',1,1) if length(`perc')==2
	replace `perc' = substr(`perc',1,2) if length(`perc')==3
	replace `perc' = substr(`perc',1,3) if length(`perc')==4
	destring `perc', replace
}

gen futureearning = 0
forval y = 1/30 {
		qui replace futureearning = futureearning  ///
		+ ${disc}^`y'*ln(income*(1+colleagues_laid_off/100)^`y')
}

replace hours_per_week_self = substr(hours_per_week_self,1,2)
destring hours_per_week_self, replace
replace part_time_option = "1" if part_time_option == "Yes"
replace part_time_option = "0" if part_time_option == "No"
destring part_time_option, replace

// Remove respondent with missing followup observations
drop if id_7d == 8294018

// Paternity/Maternity Leave
gen pat_mat_leave = (!mi(maternity_leave) | !mi(paternity_leave))

// Flexible Work Options
gen flexible_work = (!mi(flexible_work_options))

// Missing variables
foreach var in pat_mat_leave flexible_work {
	disp "`var'"
	count if mi(`var')
	gen mi_`var' = (mi(`var'))
	replace `var' = 0 if mi_`var' == 1
}

gen parttime_flex_option = (flexible_work==1 | part_time_option == 1)
replace parttime_flex_option = . if in_followup_survey != 1
// Actual earnings
destring earnings_expected_30, replace


*--Correlations
// Generate expected raise (in percentage, 0 to 100)
foreach major in econ eng hum nat nograd{
	replace self45_earning_`major'_s2 = .001 if self45_earning_`major'_s2 == 0
	replace self45_earning_`major'_s2 = .999 if self45_earning_`major'_s2 == 1
	replace self_earning_`major'_s2 = .001 if self_earning_`major'_s2 == 0
	replace self_earning_`major'_s2 = .999 if self_earning_`major'_s2 == 1	
	gen self_raise_`major'_s2 = exp((ln(self45_earning_`major'_s2/self_earning_`major'_s2))/15)
	gen self_raisepct_`major'_s2 = self_raise_`major'_s2 - 1
	replace self_raisepct_`major'_s2 = self_raisepct_`major'_s2*100
}

// Convert to 0-1 scale
foreach major in econ eng hum nat nograd{
	replace self_ptoption_`major'_s2 = self_ptoption_`major'_s2/100
}

// Prob of being fired
foreach var in layoff {
	replace self_`var'_hum_s2 = self_`var'_hum if mi(self_`var'_hum_s2)
	replace self_`var'_nat_s2 = self_`var'_nat if mi(self_`var'_nat_s2)
	replace self_`var'_nograd_s2 = self_`var'_nograd if mi(self_`var'_nograd_s2)
}


*--Students' actual major (Based on 2016 survey)
tab major1
gen chosen_major1 = "econ" if inlist(major1,"Accounting","Business Studies","Economics","Economics and Mathematics", "Finance", "International Business (Co-Major)", "Marketing")
replace chosen_major1 = "eng" if inlist(major1,"Computer Science","Information Systems","Mechanical Engineering","Physics")
replace chosen_major1 = "nat" if inlist(major1,"Biochemistry","Chemistry","Environmental Studies","Mathematics")
replace chosen_major1 = "hum" if mi(chosen_major1) & !mi(major1)
tab major2
gen chosen_major2 = "econ" if inlist(major2,"Accounting","Business Studies","Economics","Finance", "International Business (Co-Major)", "Marketing")
replace chosen_major2 = "eng" if inlist(major2,"Physics")
replace chosen_major2 = "nat" if inlist(major2,"Chemistry","Environmental Studies")
replace chosen_major2 = "hum" if mi(chosen_major2) & !mi(major2)

// 6 students have second majors in a different major category
replace chosen_major2 = "" if chosen_major2 == chosen_major1


// Expected job characteristics of actual major
foreach var in bonus layoff men raisepct wklyhrs ptoption earning{
	gen expected_`var' =.
}
foreach var in bonus layoff men raisepct wklyhrs ptoption earning{
	foreach major in econ eng hum nat nograd{
		replace expected_`var' = self_`var'_`major'_s2 if chosen_major1 == "`major'"
	}
}
// Take a weighted average of the perceived characteristics if a student has two majors
foreach var in bonus layoff men raisepct wklyhrs ptoption{
	foreach major in econ eng hum nat nograd{
		replace expected_`var' = (self_`var'_`major'_s2 + expected_`var')/2 if chosen_major2 == "`major'"
	}
}
gen parinc = 1 if parent_income_all > 87500
replace parinc = 0 if parent_income_all <= 87500 & !missing(parent_income_all)
label var parinc "=1 if parents' income is above median"

// Parent's Education
replace mother_educ_s2 = mother_educ if missing(mother_educ_s2)
replace mother_educ_s2 = "0" if mother_educ_s2 == "College degree"
replace mother_educ_s2 = "1" if mother_educ_s2 == "Graduate degree"
replace mother_educ_s2 = "2" if mother_educ_s2 == "Grammar school or less"
replace mother_educ_s2 = "3" if mother_educ_s2 == "High school graduate"
replace mother_educ_s2 = "4" if mother_educ_s2 == "Post-secondary school other than college"
replace mother_educ_s2 = "5" if mother_educ_s2 == "Some college"
replace mother_educ_s2 = "6" if mother_educ_s2 == "Some graduate school"
replace mother_educ_s2 = "7" if mother_educ_s2 == "Some high school"
destring mother_educ_s2, replace
gen dummy_mother_educ = 1 if mother_educ_s2 == 0 | mother_educ_s2 == 1 | mother_educ_s2 == 5 | mother_educ_s2 == 6
replace dummy_mother_educ = 0 if missing(dummy_mother_educ)
replace father_educ_s2 = father_educ if missing(father_educ_s2)
replace father_educ_s2 = "0" if father_educ_s2 == "College degree"
replace father_educ_s2 = "1" if father_educ_s2 == "Graduate degree"
replace father_educ_s2 = "2" if father_educ_s2 == "Grammar school or less"
replace father_educ_s2 = "3" if father_educ_s2 == "High school graduate"
replace father_educ_s2 = "4" if father_educ_s2 == "Post-secondary school other than college"
replace father_educ_s2 = "5" if father_educ_s2 == "Some college"
replace father_educ_s2 = "6" if father_educ_s2 == "Some graduate school"
replace father_educ_s2 = "7" if father_educ_s2 == "Some high school"
destring father_educ_s2, replace
gen dummy_father_educ = 1 if father_educ_s2 == 0 | father_educ_s2 == 1 | father_educ_s2 == 5 | father_educ_s2 == 6
replace dummy_father_educ = 0 if missing(dummy_father_educ)

// Combine Parents' Educations
gen pareduc = 1 if dummy_mother_educ == 1 & dummy_father_educ == 1
replace pareduc = 0 if inlist(dummy_mother_educ, 0) | inlist(dummy_father_educ, 0)
label var pareduc "=1 if both parents have some college"


// Above Median SAT 
gen total_sat = sat_math_all + sat_verbal_all
rename sat_verbal_all sat_verb_all
foreach subj in math verb {
sum sat_`subj'_all, d
local median_sat_`subj' = `r(p50)'
gen `subj'_above = 1 if sat_`subj'_all > `median_sat_`subj''
replace `subj'_above = 0 if sat_`subj'_all < `median_sat_`subj'' & !missing(sat_`subj'_all)
label var `subj'_above "=1 if above median `subj' SAT score"
}

tempfile temp
save `temp'
use `maindataset', replace
gen in_followup_survey = surv2016

*drop if id_7d == 8294018
replace in_followup_survey = 0 if id_7d == 8294018

// Mother's Education - at least B.A.
replace mother_educ_s2 = mother_educ if missing(mother_educ_s2)
replace mother_educ_s2 = "0" if mother_educ_s2 == "College degree"
replace mother_educ_s2 = "1" if mother_educ_s2 == "Graduate degree"
replace mother_educ_s2 = "2" if mother_educ_s2 == "Grammar school or less"
replace mother_educ_s2 = "3" if mother_educ_s2 == "High school graduate"
replace mother_educ_s2 = "4" if mother_educ_s2 == "Post-secondary school other than college"
replace mother_educ_s2 = "5" if mother_educ_s2 == "Some college"
replace mother_educ_s2 = "6" if mother_educ_s2 == "Some graduate school"
replace mother_educ_s2 = "7" if mother_educ_s2 == "Some high school"
destring mother_educ_s2, replace
gen dummy_mother_educ = 1 if mother_educ_s2 == 0 | mother_educ_s2 == 1 | mother_educ_s2 == 6
replace dummy_mother_educ = 0 if missing(dummy_mother_educ)
tab dummy_mother_educ
tab dummy_mother_educ if female == 0
tab dummy_mother_educ if female == 1

// Father's Education - at least B.A.
replace father_educ_s2 = father_educ if missing(father_educ_s2)
replace father_educ_s2 = "0" if father_educ_s2 == "College degree"
replace father_educ_s2 = "1" if father_educ_s2 == "Graduate degree"
replace father_educ_s2 = "2" if father_educ_s2 == "Grammar school or less"
replace father_educ_s2 = "3" if father_educ_s2 == "High school graduate"
replace father_educ_s2 = "4" if father_educ_s2 == "Post-secondary school other than college"
replace father_educ_s2 = "5" if father_educ_s2 == "Some college"
replace father_educ_s2 = "6" if father_educ_s2 == "Some graduate school"
replace father_educ_s2 = "7" if father_educ_s2 == "Some high school"
destring father_educ_s2, replace
gen dummy_father_educ = 1 if father_educ_s2 == 0 | father_educ_s2 == 1 | father_educ_s2 == 6
replace dummy_father_educ = 0 if missing(dummy_father_educ)
tab dummy_father_educ
tab dummy_father_educ if female == 0
tab dummy_father_educ if female == 1

destring current_age, replace

// Age
gen year = birthyear_s2
replace year = birthyear if missing(birthyear_s2)
cap drop current_age
gen current_age = 2016 - year

// Grade Level
gen grade_all = substr(grade_s2,1,1)
destring grade_all, replace
replace grade_all = 4 if grade_all >= 4
recode grade_all (3=0) (4=1)

// Parent's Income ($1000)
replace parent_income_all = parent_income_all/1000  // income in 1000s


gen other = bl_hisp
replace other = oth if missing(other) | bl_hisp == 0

gen male = (female == 0)

egen working = group(employed)




// Missing variables
foreach var in male white asian current_age grade_all parent_income_all dummy_mother_educ ///
	dummy_father_educ sat_verbal sat_math gpa_overall_s2 econ eng nat {
	disp "`var'"
	count if mi(`var')
	gen mi_`var' = (mi(`var'))
	replace `var' = 0 if mi_`var' == 1
}

label var male "Male"
label var white "White" 
label var asian "Asian" 
label var current_age "Age"
label var grade_all "School Year: Senior or More"
label var parent_income_all "Parents' Income (1000s)"
label var dummy_mother_educ "Mother B.A. or More"
label var dummy_father_educ "Father B.A. or More"
label var sat_verbal "SAT Verbal Score"
label var sat_math "SAT Math Score"
label var gpa_overall_s2 "GPA"
label var econ "Economics/Business"
label var eng "Engineering"
label var nat "Natural Sciences"

eststo clear
eststo: reg in_followup_survey male white asian current_age grade_all parent_income_all ///
	dummy_mother_educ dummy_father_educ sat_verbal sat_math gpa_overall_s2 econ eng nat if followup == "Yes"
estadd ysumm

test male white asian current_age grade_all parent_income_all dummy_mother_educ dummy_father_educ ///
	sat_verbal sat_math gpa_overall_s2 econ eng nat 

estadd scalar F_test = `r(p)'
esttab , se replace ///
	stats(F_test ymean r2 N, label("F-test (p-value)" "Mean of Dep. Var." "R-squared" "Number of Observations") fmt(%6.3g %6.4g %8.1g %6.0g %8.2g)) ///
	star(* 0.10 ** 0.05 *** 0.01) label constant	
esttab using "${output}selection_into_followup.csv", se replace ///
	stats(F_test ymean r2 N, label("F-test (p-value)" "Mean of Dep. Var." "R-squared" "Number of Observations") fmt(%6.3g %6.4g %8.1g %6.0g %8.2g)) ///
	star(* 0.10 ** 0.05 *** 0.01) label constant	
esttab using "${output}selection_into_followup.tex", se replace ///
	stats(F_test ymean r2 N, label("F-test (p-value)" "Mean of Dep. Var." "R-squared" "Number of Observations") fmt(%6.3g %6.4g %8.1g %6.0g %8.2g)) ///
	star(* 0.10 ** 0.05 *** 0.01) label constant	

use `temp', clear

tab working
tab working if female == 1
tab working if female == 0


*--Summary Stats
file open results using "${output}followup_survey_characteristics.csv", write replace
file write results "Summary Stats" _n
file write results "Current Job Characteristics, Overall, Male, Female" _n
gen log_income_ft = log_income if working == 3
local vars log_income_ft percent_pay_bonus hours_per_week_self percent_chance_fired  percent_colleagues_male ///
	percent_increase_colleagues   parttime_flex_option ///
	  
foreach var of local vars{
	// Overall
	sum `var', d
	local mean = round(r(mean),.001)
	local med = round(r(p50),.001)
	local sd = round(r(sd),.001)
	local N = r(N)
	// Males only
	sum `var' if female == 0, d
	local mean_m = round(r(mean),.001)
	local med_m = round(r(p50),.001)
	local sd_m = round(r(sd),.001)
	local N_m = r(N)
	// Femles only
	sum `var' if female == 1, d
	local mean_f = round(r(mean),.001)
	local med_f = round(r(p50),.001)
	local sd_f = round(r(sd),.001)	
	local N_f = r(N)

	// T-tests, Males vs Females
	ttest `var', by(female)
	local p_`var' = round(r(p),.001)	
	
	file write results "`var', `mean', `mean_m', `mean_f', `p_`var''" _n
	file write results ", [`med'], [`med_m'], [`med_f']" _n
	file write results ", (`sd'), (`sd_m'), (`sd_f')" _n	
	file write results "N, `N', `N_m', `N_f'" _n			
}

file close results

********************************************************************************
* Table 9: Job Characteristics and Estimated WTP
********************************************************************************
merge 1:1 id_7d using "${datadir}indv_beta_wtp_percent_model1.dta", nogen

*--Convert parttime flex option to 0-100 scale
replace parttime_flex_option = parttime_flex_option*100

rename (parttime_flex_option percent_chance_fired percent_pay_bonus percent_colleagues_male ///
	percent_increase_colleagues hours_per_week_self futureearning) ///
	(actual_parttime actual_fired actual_bonus actual_fracmale actual_raise actual_hours actual_futureearning)	





global vars fired bonus fracmale raise hours parttime


set seed 1
gen rand = runiform(0,1)
foreach var in $vars {
bys in_followup_survey (wtp_`var' rand): gen rank_wtp_`var' = _n if in_followup_survey == 1
bys in_followup_survey wtp_`var': egen min_rank_wtp_`var' = min(rank_wtp_`var')
replace rank_wtp_`var' = min_rank_wtp_`var'
drop min_rank_wtp_`var'
bys in_followup_survey (actual_`var' rand): gen rank_actual_`var' = _n if in_followup_survey == 1
bys in_followup_survey actual_`var': egen min_rank_actual_`var' = min(rank_actual_`var')
replace rank_actual_`var' = min_rank_actual_`var'
drop min_rank_actual_`var'
reg rank_actual_`var' rank_wtp_`var'
}

preserve
keep if in_followup_survey == 1
keep id_7d rank_wtp_* rank_actual_* 
gen tag = _n

reshape long rank_wtp_ rank_actual_, i(id_7d) j(var) str
rename *_ *
gen corr = .
gen p = .
qui sum tag
local num_tags = `r(max)'
foreach i of numlist 1/`num_tags' {
qui corr rank_actual rank_wtp if tag == `i'
matrix define A`i' = r(C)
local corr`i' = A`i'[2,1]
qui replace corr = `corr`i'' if tag == `i'
local t`i' = `corr`i''/(((1-`corr`i''^2)/(`r(N)'-2))^(1/2))
replace p = 2*ttail(`r(N)'-1, abs(`t`i'')) if tag == `i'
}
gen sig = p < .1
log using ${output}individual_correlation_detailed_sum.txt, text replace

bys id_7d: keep if _n == 1
mean corr
test corr = 0

sum corr, d
gen corr_gt_0 = corr > 0
bitest corr_gt_0 = .5

tab sig

sum corr, d

sort corr

list corr p

log close
restore


local fired_reg_label "Fired"
local bonus_reg_label "Bonus"
local fracmale_reg_label "Fraction Male"
local hours_reg_label "Hours"
local raise_reg_label "Raise - Colleagues"
local parttime_reg_label "Parttime Flexible Option"

preserve
encode chosen_major1, gen(chosen_major1_n)
encode chosen_major2, gen(chosen_major2_n)
drop chosen_major?
rename (chosen_major?_n) (chosen_major?)
replace chosen_major2 = 0 if missing(chosen_major2)
     
bootstrap, reps(${bootstrap_reps}):  sureg 					///
	(actual_fired wtp_fired )		///
	(actual_bonus wtp_bonus )		///
	(actual_fracmale wtp_fracmale )		///
	(actual_raise wtp_raise )		///
	(actual_hours wtp_hours )		///
	(actual_parttime wtp_parttime)
	test wtp_fired=wtp_bonus=wtp_fracmale=wtp_raise=wtp_hours=wtp_parttime

// Actual WTP values
eststo clear
foreach var in $vars {
display `"qui eststo `var', title("`var' Fullsample"): bootstrap, reps(${bootstrap_reps}): reg actual_`var' wtp_`var' `extra_vars'"'
	qui eststo `var', title("`var' Fullsample"): bootstrap, reps(${bootstrap_reps}): reg actual_`var' wtp_`var' `extra_vars' `missing_extra_vars'
	estadd ysumm 
	sum wtp_`var' if e(sample) == 1 , d
	estadd scalar sd_wtp = `r(sd)':  `var'
	estadd scalar effect_size = _b[wtp_`var']*`r(sd)':  `var'
}

esttab using "${output}followup_wtp_regs.csv", se replace ///
	stats(sd_wtp effect_size ymean ysd r2 N, label("SD of WTP" "Effect Size" "Mean of Dep. Var." "Std of Dep. Var." "R-squared" "Number of Observations") ///
	fmt(%6.3g %6.4g %8.1g %6.0g %8.2g)) star(* 0.10 ** 0.05 *** 0.01) b(2) se(2) ///
	label constant order(wtp_*)

esttab using "${output}followup_wtp_regs.tex", se replace ///
	stats(sd_wtp effect_size ymean ysd r2 N, label("SD of WTP" "Effect Size" "Mean of Dep. Var." "Std of Dep. Var." "R-squared" "Number of Observations") ///
	fmt(%6.3g %6.4g %8.1g %6.0g %8.2g)) star(* 0.10 ** 0.05 *** 0.01) b(2) se(2) ///
	label constant order(wtp_*) 
restore

// Restrict sample to the 59 employed
keep if in_followup_survey == 1

// Remove respondent with missing followup observations
drop if id_7d == 8294018



foreach major in econ eng hum nat{
	gen actual_`major' = (chosen_major1 == "`major'" | chosen_major2 == "`major'")
}

foreach var in bonus layoff men raisepct wklyhrs ptoption earning{
	foreach major in econ eng hum nat nograd{
		replace expected_`var' = self_`var'_`major'_s2 if chosen_major1 == "`major'"
	}
}
// Take a weighted average of the perceived characteristics if a student has two majors
foreach var in bonus layoff men raisepct wklyhrs ptoption{
	foreach major in econ eng hum nat nograd{
		replace expected_`var' = (self_`var'_`major'_s2 + expected_`var')/2 if chosen_major2 == "`major'"
	}
}


gen log_earning = log(earnings_expected_30)

gen parttime = working == 4 if !missing(working)

label variable female "Female" 
label variable parttime "Part-time"
label variable log_earning "Log Earnings"
label variable b1 "Beta-Log Earnings"
label variable b2 "Beta-Fired"
label variable b3 "Beta-Bonus"
label variable b4 "Beta-\% Male"
label variable b5 "Beta-Raise"
label variable b6 "Beta-Hours"
label variable b7 "Beta-Parttime"

replace major_cat = "Econ" if major_cat == "Business and Economics"
replace major_cat = "Eng" if major_cat == "Engineering and Computer Science"
replace major_cat = "Hum" if major_cat == "Humanities and Other Social Sciences"
replace major_cat = "NatSci" if major_cat == "Natural Sciences and Math"

*--Working Full-time
// Remove outlier in parttime earnings 
sum log_earning, d
drop if log_earning >= r(max) & working != 3  // also drops two missing observations

foreach n of numlist 1/7 {
gen b`n'_norm = b`n'/b1
}
global betas b1 b2 b3 b4 b5 b6 b7

local race white asian other
local demos i.grade_all current_age `race' parent_income_all i.dummy_mother_educ i.dummy_father_educ ///
		sat_math sat_verbal gpa_overall_s2
encode occupation, gen(occupation_n)
encode occupation_other, gen(occupation_other_n)

gen occ_cat = .
replace occ_cat = 1 if inlist(occupation_n, 7, 8)
replace occ_cat = 2 if inlist(occupation_n, 2, 12)
replace occ_cat = 3 if inlist(occupation_n, 9, 13)
replace occ_cat = 4 if inlist(occupation_n, 6, 15) | inlist(occupation_other_n, 3, 4)
replace occ_cat = 5 if inlist(occupation_n, 10, 11)
replace occ_cat = 6 if inlist(occupation_n, 3) |  inlist(occupation_other_n, 5)
replace occ_cat = 10*occupation_n if missing(occ_cat) & occupation_n != 14
replace occ_cat = 100*occupation_other_n if missing(occ_cat)

		
// (a): Female dummy + constant
estimates clear
eststo, title("All Employed (a)"): xi: reg log_earning female parttime
estadd ysumm 

eststo, title("All Employed (a)"): xi: reg log_earning female parttime  i.major_cat
estadd ysumm 

set seed 1
eststo, title("All Employed (b)"): xi: bootstrap, reps($bootstrap_reps): reg log_earning female parttime ${betas}
testparm ${betas}, equal
estadd ysumm	

// (a) + beta estimates
set seed 1
eststo, title("All Employed (b)"): xi: bootstrap, reps($bootstrap_reps): reg log_earning female parttime ${betas}  i.major_cat
testparm ${betas}, equal
estadd ysumm




estout using "${output}followup_earnings_regs_betas.xls", ///
		starlevels(* 0.10 ** 0.05 *** 0.01) ///
		cells(b(star fmt(4)) se(par fmt(4))) order(female ${`vars'}) ///
		stats(ymean r2 N, label("Mean of Dep. Var" "R-squared" "Number of Observations") fmt(%6.0g)) ///
		label legend ///
		replace		
esttab using "${output}followup_earnings_regs_betas.tex", ///
		starlevels(* 0.10 ** 0.05 *** 0.01) ///
		cells(b(star fmt(4)) se(par fmt(4))) order(female ${`vars'}) ///
		stats(ymean r2 N, label("Mean of Dep. Var" "R-squared" "Number of Observations") fmt(%6.0g)) ///
		label legend ///
		replace		

}








use `maindataset', replace

**** Major choice model
if `redo_delta_analysis' == 1 {
global N 247
local reps $bootstrap_reps

*qui {
use `maindataset', replace
merge 1:1 id_7d using "${datadir}indv_beta_wtp_percent_model1.dta", nogen

replace self_layoff_hum_s2 = self_layoff_hum if missing(self_layoff_hum_s2)
replace self_layoff_nat_s2 = self_layoff_nat if missing(self_layoff_nat_s2)

// Reshape data so that each row is an ID x major pair
keep id_7d female b? self45_earning_*_s2 self_earning_*_s2 self_rankability_*_s2	///
	self_layoff_*_s2 self_hrsgpa4_*_s2 self_grad_*_s2					///
	self_bonus_*_s2 self_men_*_s2 self_wklyhrs_*_s2 self_ptoption_*_s2 self_layoff_*_s2
rename (self45_earning_*_s2 self_earning_*_s2 self_layoff_*_s2 self_bonus_*_s2 	///
	self_men_*_s2 self_ptoption_*_s2 self_rankability_*_s2 			///
	self_hrsgpa4_*_s2 self_wklyhrs_*_s2 self_grad_*_s2) (earning45_* 	///
	earning_* layoff_* bonus_* men_* parttime_* rankability_* hrsgpa4_* 	///
	wklyhrs_* grad_*)
	
*--Replace extreme values
foreach major in econ eng hum nat nograd{
	// Parttime, 0 to 1
	replace parttime_`major' = parttime_`major'/100

	// Generate percent increase in raise, 0 to 100
	replace earning_`major' = .001 if earning_`major' == 0
	replace earning_`major' = .999 if earning_`major' == 1
	replace earning_`major' = .001 if earning_`major' == 0
	replace earning_`major' = .999 if earning_`major' == 1	
	gen raise_`major' = exp((ln(earning45_`major'/earning_`major'))/15)
	gen raisepct_`major' = (raise_`major' - 1)*100

	// Log(earnings)
	replace earning_`major' = 0.001 if earning_`major' == 0
	replace earning_`major' = .999 if earning_`major' == 1
	gen logearning_`major' = ln(earning_`major') // earnings in dollars
}
gen hrsgpa4_nograd = 0
rename (rankability_* hrsgpa4_*) (z1_* z2_*)
// Create x, xbeta,  and z differences
foreach major in econ eng hum nat nograd{
	foreach attr in logearning layoff bonus men raisepct wklyhrs parttime {
		gen diff_`attr'_`major' = `attr'_`major' - `attr'_hum
	}
	gen xb_`major' = b1*(logearning_`major' - logearning_hum) + /// 
		b2*(layoff_`major' - layoff_hum) + ///
		b3*(bonus_`major' - bonus_hum) + ///
		b4*(men_`major' - men_hum) + ///
		b5*(raisepct_`major' - raisepct_hum) + ///
		b6*(wklyhrs_`major' - wklyhrs_hum) + ///
		b7*(parttime_`major' - parttime_hum)
	// Z's
	gen diff_z1_`major' = z1_`major' - z1_hum
	gen diff_z2_`major' = z2_`major' - z2_hum
}

*--Step 1: Prepare dataset for LAD

	// Rescale stated probabilities if we exclude dropout
	foreach major in econ eng hum nat{
		replace grad_`major' = grad_`major'/(100-grad_nograd)
	}
	drop grad_nograd
	
	// Replace extreme values
	foreach major in econ eng hum nat{
		replace grad_`major' = 0.001 if grad_`major' == 0
		replace grad_`major' = .999 if grad_`major' == 1
	}
	
	// Generate probabilities of choosing each major (log odds)
	foreach major in econ eng hum nat{
		gen prob_ratio_`major' = ln(grad_`major'/grad_hum)
	}	



reshape long 	xb_ diff_z1_ diff_z2_ prob_ratio_ z1_ z2_ layoff_ wklyhrs_ bonus_ 	///
		men_ parttime_ logearning_ raise_ raisepct_ diff_logearning_ 			///
		diff_layoff_ diff_bonus_ diff_men_ diff_raisepct_ diff_wklyhrs_ 	///
		diff_parttime_ earning_ earning45_, i(id_7d female) j(major) string
drop if major == "nograd"


rename (*_) (*) 
label var xb "X*Beta"
label var diff_z1 "Diff Ability"
label var diff_z2 "Diff Difficulty"

// Generate Dummy for missing observations
gen dummy_xb = (mi(xb))
replace xb = 0 if mi(xb)

tab major, gen(major)
rename (major1 major2 major3 major4) (econ eng hum nat) 	

preserve
drop if major == "hum"

encode major, gen(major_n)
tab major_n
estimates clear


tab major_n, gen(major_d)
set seed 1
bootstrap, reps(`reps') cluster(id_7d): qreg prob_ratio xb diff_z1 diff_z2 dummy_xb major_d2 major_d3
eststo betas1
estimates save betas, replace
set seed 1
bootstrap, reps(`reps') cluster(id_7d): qreg prob_ratio xb diff_z1 diff_z2 dummy_xb major_d1 major_d3
eststo betas2
estimates save betas, replace
set seed 1
bootstrap, reps(`reps') cluster(id_7d): qreg prob_ratio xb diff_z1 diff_z2 dummy_xb major_d1 major_d2
eststo betas3
estimates save betas, replace
set seed 1
bootstrap, reps(`reps') cluster(id_7d): qreg prob_ratio xb diff_z1 diff_z2 dummy_xb i.major_n


esttab betas1 betas2 betas3 using ${output}delta_estimates.tex,  replace se(3) b(3)	///
	coeflabels(	xb "Job Attributes" diff_z1 "Ability Rank"			///
			diff_z2 "Study time" major_d1 "Economics" major_d2 "Engineering"	///
			major_d3 "Natural Science" _cons "Constant"		///
			diff_logearning "Log Earnings" diff_layoff "Fired Prob."	////
			diff_bonus "Bonus" diff_men "Prop Males"		///
			diff_raisepct "Earnings Growth" diff_wklyhrs "Hours"	///
			diff_parttime "Part-time Available")  	///
	drop(dummy_xb)
esttab betas1 betas2 betas3 using ${output}delta_estimates.csv,  replace se(3) b(3)	///
	coeflabels(	xb "Job Attributes" diff_z1 "Ability Rank"			///
			diff_z2 "Study time" major_d1 "Economics" major_d2 "Engineering"	///
			major_d3 "Natural Science" _cons "Constant"		///
			diff_logearning "Log Earnings" diff_layoff "Fired Prob."	////
			diff_bonus "Bonus" diff_men "Prop Males"		///
			diff_raisepct "Earnings Growth" diff_wklyhrs "Hours"	///
			diff_parttime "Part-time Available")  	///
	drop(dummy_xb)
restore


gen delta = _b[xb]
forvalues num=1/7{
	gen alpha`num' = delta * b`num'
}
gen gamma1 = _b[diff_z1]
gen gamma2 = _b[diff_z2]
gen coef_eng = _b[_cons] + _b[2.major_n]
gen coef_nat = _b[_cons] + _b[3.major_n]
gen coef_econ = _b[_cons]
gen coef_hum = 0
gen coef_dummy_xb = _b[dummy_xb]

gen bonus_pre_trim = bonus
replace bonus = . if bonus > 100
 

foreach var in wklyhrs bonus men layoff parttime raisepct logearning z1 z2 	///
	alpha1 alpha2 alpha3 alpha4 alpha5 alpha6 alpha7 {
bys female: egen `var'_temp = mean(`var')
}

gen prob_numerator_indv = exp(alpha1*logearning + alpha2*layoff +		///
	alpha3*bonus + alpha4*men + alpha5*raisepct + 		///
	alpha6*wklyhrs + alpha7*parttime + gamma1*z1 +		///
	gamma2*z2 + coef_eng*eng + coef_nat*nat + coef_econ*econ +		///
	coef_hum*hum)
bys id_7d: egen prob_denominator_indv= sum(prob_numerator_indv)
gen prob_indv = prob_numerator_indv/prob_denominator_indv

bys id_7d: egen sum_prob_indv = sum(prob_indv)
noisily sum sum_prob_indv, d
gen prob_numerator = exp(alpha1_temp*logearning_temp + alpha2_temp*layoff_temp +		///
	alpha3_temp*bonus_temp + alpha4_temp*men_temp + alpha5_temp*raisepct_temp + 		///
	alpha6_temp*wklyhrs_temp + alpha7_temp*parttime_temp + gamma1*z1_temp +		///
	gamma2*z2_temp + coef_eng*eng + coef_nat*nat + coef_econ*econ +		///
	coef_hum*hum)
bys id_7d: egen prob_denominator= sum(prob_numerator)
gen prob = prob_numerator/prob_denominator

gen prob_base = prob
drop prob prob_numerator prob_denominator *_temp



foreach b of varlist wklyhrs bonus layoff raisepct men parttime logearning {
foreach maj in "eng" "nat" "hum" "econ" {
foreach var in wklyhrs bonus men layoff parttime raisepct logearning z1 z2 	///
	alpha1 alpha2 alpha3 alpha4 alpha5 alpha6 alpha7 {
bys female major: egen `var'_temp = mean(`var')
}
sum `b' if female == 1 
local `b'_`maj'_val1_f = r(mean)
local `b'_`maj'_val2_f = r(mean) + r(sd)
sum `b' if female == 0
local `b'_`maj'_val1_m = r(mean)
local `b'_`maj'_val2_m = r(mean) + r(sd)


foreach v in 1 2 {
replace `b'_temp = ``b'_`maj'_val`v'_f' if female == 1 & major == "`maj'"
replace `b'_temp = ``b'_`maj'_val`v'_m' if female == 0 & major == "`maj'"

display ``b'_`maj'_val`v'_m'
display ``b'_`maj'_val`v'_f'


gen prob_numerator = exp(alpha1_temp*logearning_temp + alpha2_temp*layoff_temp +		///
	alpha3_temp*bonus_temp + alpha4_temp*men_temp + alpha5_temp*raisepct_temp + 		///
	alpha6_temp*wklyhrs_temp + alpha7_temp*parttime_temp + gamma1*z1_temp +		///
	gamma2*z2_temp + coef_eng*eng + coef_nat*nat + coef_econ*econ +		///
	coef_hum*hum)
bys id_7d: egen prob_denominator= sum(prob_numerator)
gen prob_`b'_`maj'_`v' = prob_numerator/prob_denominator if major == "`maj'"
drop prob_numerator prob_denominator
}
drop *_temp
gen change_prob_`b'_`maj' = (prob_`b'_`maj'_2 -prob_`b'_`maj'_1)/prob_base
qui sum change_prob_`b'_`maj' if female == 1
local `b'_`maj'_f = round(100*r(mean), .1)
qui sum change_prob_`b'_`maj' if female == 0
local `b'_`maj'_m = round(100*r(mean), .1)
}
}

foreach b in layoff parttime wklyhrs bonus raisepct men logearning {
foreach g in f m {
local `b'_ave_`g' = (``b'_econ_`g'' + ``b'_eng_`g'' + ``b'_hum_`g'' + ``b'_nat_`g'')/4
local `b'_ave_`g': di %9.2f ``b'_ave_`g''
}
}


local f_line "Female, Fired, Part-time, Hours, Bonus, Raise, Frac. Men, Log. Earning"
local m_line "Male, "

file open table using ${output}marginal_effect_w_startend.csv, write replace
foreach g in f m {
file write table _n "``g'_line'"
file write table _n "Start"
foreach b in layoff parttime wklyhrs bonus raisepct men logearning {
local `b'_`maj'_val1_`g': di %9.2f ``b'_`maj'_val1_`g''
file write table ",``b'_econ_val1_`g''"
}
file write table _n "Ending"
foreach b in layoff parttime wklyhrs bonus raisepct men logearning {
local `b'_`maj'_val2_`g': di %9.2f ``b'_`maj'_val2_`g''
file write table ",``b'_econ_val2_`g''"
}
file write table _n "Mean"
foreach b in layoff parttime wklyhrs bonus raisepct men logearning {
file write table ",``b'_ave_`g''%"
}
file write table _n
}

file close table

foreach b in layoff parttime wklyhrs bonus raisepct men {
foreach g in f m {
local ratio_`b'_ave_`g' = ``b'_ave_`g''/`logearning_ave_`g''
local ratio_`b'_ave_`g': display %3.2f `ratio_`b'_ave_`g''
}
}

local f_line "Female & Fired & Part-time & Hours & Bonus & Raise & Frac. Men & Log. Earning"
local m_line "Male &&&&&&&"
local cols 8
local header "\begin{table}\caption{`caption'}\label{`label'} \centering \begin{tabular}{l*{`cols'}{c}}"
local footer "\end{tabular}\end{table}"
file open table using ${output}marginal_effect_w_startend.tex, write replace
file write table "`header' \hline \hline" _n
foreach g in f m {
file write table _n "``g'_line' \\ \hline"
file write table _n "Start"
foreach b in layoff parttime wklyhrs bonus raisepct men logearning {
file write table " &``b'_econ_val1_`g''"
}
file write table " \\ " _n "Ending"
foreach b in layoff parttime wklyhrs bonus raisepct men logearning {
file write table " & ``b'_econ_val2_`g''"
}
file write table " \\ " _n "Mean"
foreach b in layoff parttime wklyhrs bonus raisepct men logearning {
file write table " & ``b'_ave_`g''\%"
}
file write table " \\ " _n "Ratio to Earnings Effect"
foreach b in layoff parttime wklyhrs bonus raisepct men logearning {
file write table " & `ratio_`b'_ave_`g''"
}
file write table " \\ \hline"

}
file write table _n "`footer'"

file close table

bys id_7d: gen first = _n == 1

preserve
foreach n of numlist 1/7 {
gen b`n'_orig = b`n'
}
replace bonus = bonus_pre_trim
encode major, gen(major_n)


drop xb
gen xb = b1*(logearning) + /// 
	b2*(layoff) + ///
	b3*(bonus) + ///
	b4*(men) + ///
	b5*(raisepct) + ///
	b6*(wklyhrs) + ///
	b7*(parttime)
replace xb = 0 if dummy_xb == 1

foreach var in xb z1 z2 dummy_xb {
bys id_7d: gen temp = `var' if hum == 1
bys id_7d: egen `var'_hum = max(temp)
drop temp
}
	
gen prob_numerator = exp(	delta	*(xb - xb_hum)				///
			+	gamma1	*(z1 - z1_hum)				///
			+	gamma2	*(z2 - z2_hum)				///
			+ coef_eng*eng + coef_nat*nat + coef_econ*econ)
bys id_7d: egen prob_denominator = sum(prob_numerator)
gen prob_1 = prob_numerator/prob_denominator
label var prob_1 "Original preferences"
gen temp = earning*prob_1
bys id_7d: egen exp_earning_1 = sum(temp)
drop temp

foreach n of numlist 1/7 {
sum b`n' if female == 0,
local mean_b`n'_m = r(mean)
local med_b`n'_m = r(p50)

sum b`n' if female == 1,
local mean_b`n'_f = r(mean)
local med_b`n'_f = r(mean)

replace b`n' = b`n' + (`mean_b`n'_m' - `mean_b`n'_f') if female == 1 

}

drop xb xb_hum 

gen xb = b1*(logearning) + /// 
	b2*(layoff) + ///
	b3*(bonus) + ///
	b4*(men) + ///
	b5*(raisepct) + ///
	b6*(wklyhrs) + ///
	b7*(parttime)
replace xb = 0 if dummy_xb == 1

foreach var in xb {
bys id_7d: gen temp = `var' if hum == 1
bys id_7d: egen `var'_hum = max(temp)
drop temp
}
drop prob_numerator prob_denominator
gen prob_numerator = exp(	delta	*(xb - xb_hum)				///
			+	gamma1	*(z1 - z1_hum)				///
			+	gamma2	*(z2 - z2_hum)				///
			+ coef_eng*eng + coef_nat*nat + coef_econ*econ )
bys id_7d: egen prob_denominator = sum(prob_numerator)
gen prob_2 = prob_numerator/prob_denominator
 label var prob_2 "Mean-shifted preferences"

gen temp = earning*prob_2
bys id_7d: egen exp_earning_2 = sum(temp)
drop temp
foreach n of numlist 1/7 {
replace b`n' = b`n'_orig
}

cap log close
log using "${output}shifting_preferences.txt", text replace
mean prob_1 prob_2  if female == 1, over(major_n)
mean prob_1 if female == 0, over(major_n)

mean exp_earning_1 exp_earning_2 if first == 1 & female == 1
mean exp_earning_1  if first == 1 & female == 0

log close
restore




}












****  Expectation regressions
if `redo_expectations_regs' == 1 {
use `maindataset', replace

keep id_7d female self_earning*s2 self_wklyhrs*s2 self_ptoption*s2 self45_earning*s2 major_cat_s2

// Log earnings
foreach major in econ eng hum nat nograd{
	replace self_earning_`major'_s2 = .001 if self_earning_`major'_s2 == 0
	gen self_logearning_`major'_s2 = log(self_earning_`major'_s2)
	replace self_logearning_`major'_s2 =. if missing(self_earning_`major'_s2)
}

// Remove top/bottom 5% of earnings
foreach major in econ eng hum nat nograd{
	_pctile self_earning_`major'_s2, p(5,95) // remove top/bottom 5%
	return list
	local top = r(r2)
	local bottom = r(r1)
	replace self_earning_`major'_s2 = `top' if self_earning_`major'_s2 >= `top'
	replace self_earning_`major'_s2 = `bottom' if self_earning_`major'_s2 <= `bottom'	
	replace self_logearning_`major'_s2 = log(self_earning_`major'_s2)
}

// Generate raise (in percentage, 0 to 100)
foreach major in econ eng hum nat nograd{
	replace self45_earning_`major'_s2 = .001 if self45_earning_`major'_s2 == 0
	replace self45_earning_`major'_s2 = .999 if self45_earning_`major'_s2 == 1
	replace self_earning_`major'_s2 = .001 if self_earning_`major'_s2 == 0
	replace self_earning_`major'_s2 = .999 if self_earning_`major'_s2 == 1	
	gen self_raise_`major'_s2 = exp((ln(self45_earning_`major'_s2/self_earning_`major'_s2))/15)
	gen self_raisepct_`major'_s2 = self_raise_`major'_s2 - 1
	replace self_raisepct_`major'_s2 = self_raisepct_`major'_s2*100
}

// produce sumstat tables
gen self_hrsgpa4_nograd_s2 =0
foreach var in earning logearning raisepct wklyhrs ptoption{
	foreach major in econ eng hum nat nograd{
		rename self_`var'_`major'_s2 self_`major'_`var'
	}
}

keep id_7d female self_econ* self_eng* self_hum* self_nat* self_nograd* major_cat_s2

rename self_* *
rename 	(*_earning *_wklyhrs *_ptoption *_logearning *_raisepct) 					///
		(earning_* wklyhrs_* ptoption_* logearning_* raisepct_*)
merge 1:1 id_7d using "${datadir}indv_beta_wtp_percent_model1.dta", nogen

reshape long earning wklyhrs ptoption logearning raisepct, i(id_7d) j(major) string

foreach n of numlist 1/7 {
gen b`n'_norm = b`n'/b1
}
global betas b1 b2 b3 b4 b5 b6 b7


replace major = "Econ" if major == "_econ"
replace major = "Eng" if major == "_eng"
replace major = "Hum" if major == "_hum"
replace major = "NatSci" if major == "_nat"
replace major = "NoGrad" if major == "_nograd"


replace major_cat_s2 = "Econ" if major_cat_s2 == "Business and Economics"
replace major_cat_s2 = "Eng" if major_cat_s2 == "Engineering and Computer Science"
replace major_cat_s2 = "Hum" if major_cat_s2 == "Humanities and Other Social Sciences"
replace major_cat_s2 = "NatSci" if major_cat_s2 == "Natural Sciences and Math"


estimates clear
eststo, title(): xi: reg logearning female if major == major_cat_s2
estadd ysumm

eststo, title(): xi: reg logearning female i.major if major == major_cat_s2
estadd ysumm

set seed 1
eststo, title(): xi: bootstrap, reps($bootstrap_reps):  reg logearning female ${betas} if major == major_cat_s2
testparm ${betas}, equal
estadd ysumm

set seed 1
eststo, title(): xi: bootstrap, reps($bootstrap_reps):  reg logearning female ${betas}  i.major if major == major_cat_s2
testparm ${betas}, equal
estadd ysumm


estout using "${output}expectation_regs_ownmajor.xls", ///
		starlevels(* 0.10 ** 0.05 *** 0.01) ///
		cells(b(star fmt(4)) se(par fmt(4))) ///
		stats(ymean r2 N, label("Mean of Dep. Var" "R-squared" "Number of Observations") fmt(%6.0g)) ///
		label legend   ///
		replace	
esttab using "${output}expectation_regs_ownmajor_model1.tex", ///
		starlevels(* 0.10 ** 0.05 *** 0.01) ///
		cells(b(star fmt(4)) se(par fmt(4))) ///
		stats(ymean r2 N, label("Mean of Dep. Var" "R-squared" "Number of Observations") fmt(%6.0g)) ///
		label legend   ///
		replace	
}


use `maindataset', replace


*********  Attributes of job-choice scenarios 
if `redo_attributes' == 1  {


import excel "${datadir}/choice_scenarios_for_stata.xlsx", sheet("Sheet1") firstrow clear

gen logearning = log(earning)
foreach var of varlist raise fired bonus fracmale {
replace `var' = 100*`var'
}
gen parttime_n = 1 if parttime == "Yes"
replace parttime_n = 0 if parttime == "No"
drop parttime
rename parttime_n parttime



foreach var in earning raise hours parttime fired bonus fracmale {
qui sum `var', d
local format "%3.2f"
if "`var'" == "earning" local format "%8.0f"
local `var'_mean: display `format' `r(mean)'
local `var'_min: display `format' `r(min)'
local `var'_max: display `format' `r(max)'
local `var'_sd: display `format' `r(sd)'
}

file open csvtable using "${output}attributes_sumstats.csv", write replace

file write csvtable ", Mean, S.D., Min, Max"
foreach var in earning raise hours parttime fired bonus fracmale {
file write csvtable _n "`var'"
foreach stat in mean sd  min max {
file write csvtable ",``var'_`stat''"
}
}
file close csvtable

local cols 4
local header "\begin{table}\caption{`caption'}\label{`label'} \centering \begin{tabular}{l*{`cols'}{c}}"
local footer "\end{tabular}\end{table}"

file open table using "${output}attributes_sumstats.tex", write replace
file write table "`header' \hline \hline" _n
file write table "& Mean & S.D. & Min & Max"
foreach var in earning raise hours parttime fired bonus fracmale {
file write table " \\" _n "`var'"
foreach stat in mean sd  min max {
file write table "& ``var'_`stat''"
}
}
file write table " \\" _n "`footer'"

file close table

}


use `maindataset', replace
