* DIRECTORIES

capture cd "/Users/gwyneth/Dropbox/Disseminators/Benin/Drafts/JEPS/AGKM JEPS replication files"
capture cd "Dropbox/Research/Disseminators/Benin/Drafts/JEPS/AGKM JEPS replication files"

log using "JEPS.smcl", replace

** Install coefplot
cap ssc install coefplot

********************************************************************************
set more off

********************************************************
*Load and define adminstrative data

use "merged_administrative_5.dta", clear

** Or regenerate merged data file
*qui do "working_data/merging_administrative_v2.do"


keep if merge2015==3

************************

replace condition="Control" if condition=="control"
replace condition="Control" if condition==""

drop treatment 
gen treatment=0
replace treatment=1 if condition!="Control" 

replace block = 4 if dosage==0 // villages in low dose all in same block

egen blid = group(commune block)  // generate block that combines block/commune

rename turnout survey_turnout
generate turnout=(total_valid+total_annulees)/regvoters
label var turnout "Voter turnout"
replace turnout=. if turnout>1 //31 Control villages and 1 T2T4

generate public=0 
	replace public=1 if condition=="T1T4" | condition=="T2T4"
generate civics=0 
	replace civics=1 if condition=="T2T3" | condition=="T2T4"
gen private=0
	replace private=1 if condition=="T1T3" | condition=="T2T3"
gen infoonly=0
	replace infoonly=1 if condition=="T1T3" | condition=="T1T4"


******************************************************************************

gen official_vote = incumbent_share
gen survey_vote = incumbent_vote

gen official_turnout = turnout

label variable official_vote "Voteshare Official Data"
label variable survey_v "Voteshare Survey Data"
label variable official_turnout "Turnout Official Data"
label variable survey_turn "Turnout Survey Data"


mean official_vote if survey_vote ~=.

mean survey_vote


mean official_turnout if survey_turnout ~=.

mean survey_turnout


*******************************************
** Explore causes of deviation

* Define deviation as difference between survey and admin outcome
gen deviation = survey_vote-official_vote

gen deviationt = survey_t-official_t

gen deviationsq=deviation^2
gen deviationtsq=deviationt^2
			
* Treatment and deviation
regress deviation treatment 
regress deviation treatment if goodnews==1
regress deviation treatment if goodnews==0
			
regress deviationt treatment 
regress deviationt treatment if goodnews==1
regress deviationt treatment if goodnews==0

* Attrition and deviation
*To get attrition in data, rerun balance_attrition.do with attrition at village level
*Re-run merging_administrative_v2.do which uses the survey_village_level data
*Also undo the drop merge at the top to see how bad the mismatch in sample is across survey and official data

regress deviation attrition 
regress deviation attrition if goodnews==1
regress deviation attrition_vote if goodnews==1
regress deviation attrition if goodnews==0
regress deviation attrition_vote if goodnews==0

regress deviationt attrition 
regress deviationt attrition if goodnews==1
regress deviationt attrition_vote if goodnews==1
regress deviationt attrition if goodnews==0
regress deviationt attrition_vote if goodnews==0

* Treatment does not predict attrition rates
regress attrition treatment if goodnews==1
regress attrition treatment if goodnews==0

*******************************************
** Show means

ttest survey_vote=official_vote
ttest survey_t=official_t

gen group_name="Official" in 1
replace group_name="Survey" in 2
replace group_name="Official" in 3
replace group_name="Survey" in 4

gen voteshare=. in 1/2
gen voteshareu=. in 1/4
gen votesharec=. in 1/4
gen upper=. in 1/2
gen upperu=. in 1/4
gen upperc=. in 1/4
gen lower=. in 1/2
gen loweru=. in 1/4
gen lowerc=. in 1/4
gen sd=. in 1/2
gen sdu=. in 1/4
gen sdc=. in 1/4
gen n=. in 1/2
gen nu=. in 1/4
gen nc=. in 1/4

gen data=. in 1/4
replace data=1 if _n==1
replace data=2 if _n==2
replace data=1 if _n==3
replace data=2 if _n==4

generate Urban="" in 1/4
replace Urban="Urban" if _n==1 | _n==2
replace Urban="Rural" if _n==3 | _n==4

generate Competitive="" in 1/4
replace Competitive="More competitive" if _n==1 | _n==2
replace Competitive="Less competitive" if _n==3 | _n==4

label define data 1 "Official" 2 "Survey"
label variable data data

summ official_vote if survey_vote~=., detail
replace voteshare=r(mean) if _n==1
replace upper=r(p95) if _n==1
replace lower=r(p5) if _n==1
replace sd=r(sd) if _n==1
replace n=r(N) if _n==1

summ official_vote if survey_vote~=. & urban==1, detail
replace voteshareu=r(mean) if _n==1
replace upperu=r(p95) if _n==1
replace loweru=r(p5) if _n==1
replace sdu=r(sd) if _n==1
replace nu=r(N) if _n==1

summ official_vote if survey_vote~=. & urban==0, detail
replace voteshareu=r(mean) if _n==3
replace upperu=r(p95) if _n==3
replace loweru=r(p5) if _n==3
replace sdu=r(sd) if _n==3
replace nu=r(N) if _n==3

summ official_vote if survey_vote~=. & competitive_margin==1, detail
replace votesharec=r(mean) if _n==1
replace upperc=r(p95) if _n==1
replace lowerc=r(p5) if _n==1
replace sdc=r(sd) if _n==1
replace nc=r(N) if _n==1

summ official_vote if survey_vote~=. & competitive_margin==0, detail
replace votesharec=r(mean) if _n==3
replace upperc=r(p95) if _n==3
replace lowerc=r(p5) if _n==3
replace sdc=r(sd) if _n==3
replace nc=r(N) if _n==3

summ survey_vote if survey_vote~=., detail
replace voteshare=r(mean) if _n==2
replace upper=r(p95) if _n==2
replace lower=r(p5) if _n==2
replace sd=r(sd) if _n==2
replace n=r(N) if _n==2

summ survey_vote if survey_vote~=. & urban==1, detail
replace voteshareu=r(mean) if _n==2
replace upperu=r(p95) if _n==2
replace loweru=r(p5) if _n==2
replace sdu=r(sd) if _n==2
replace nu=r(N) if _n==2

summ survey_vote if survey_vote~=. & urban==0, detail
replace voteshareu=r(mean) if _n==4
replace upperu=r(p95) if _n==4
replace loweru=r(p5) if _n==4
replace sdu=r(sd) if _n==4
replace nu=r(N) if _n==4

summ survey_vote if survey_vote~=. & competitive_margin==1, detail
replace votesharec=r(mean) if _n==2
replace upperc=r(p95) if _n==2
replace lowerc=r(p5) if _n==2
replace sdc=r(sd) if _n==2
replace nc=r(N) if _n==2

summ survey_vote if survey_vote~=. & competitive_margin==0, detail
replace votesharec=r(mean) if _n==4
replace upperc=r(p95) if _n==4
replace lowerc=r(p5) if _n==4
replace sdc=r(sd) if _n==4
replace nc=r(N) if _n==4

generate hi=voteshare + invttail(n-1,0.025)*(sd / sqrt(n))
generate low=voteshare - invttail(n-1,0.025)*(sd / sqrt(n))

generate hiu=voteshareu + invttail(nu-1,0.025)*(sdu / sqrt(nu))
generate lowu=voteshareu - invttail(nu-1,0.025)*(sdu / sqrt(nu))

generate hic=votesharec + invttail(nc-1,0.025)*(sdc / sqrt(nc))
generate lowc=votesharec - invttail(nc-1,0.025)*(sdc / sqrt(nc))

***Figure 1
graph twoway (bar voteshare data, barwidth(.6)) (rcap hi low data), ///
xlabel(1 "Official" 2 "Survey", noticks) xscale(r(0.5 2.5)) /// 
scheme(s1mono)  ytitle("Mean Incumbent Voteshare") yscale(r(0 .6)) ylabel(0(.1).5) ///
xtitle("") legend(order(2 "95% Confidence Interval"))

cap		graph export Drafts/JEPS/figures/voteshare_bar.pdf, as(pdf) replace
		
****Figure 3
graph twoway (bar voteshareu data, barwidth(.6)) (rcap hiu lowu data), by(Urban) ///
xlabel(1 "Official" 2 "Survey", noticks) xscale(r(0.5 2.5)) /// 
scheme(s1mono)  ytitle("Mean Incumbent Voteshare") yscale(r(0 .6)) ylabel(0(.1).5) ///
xtitle("") legend(order(2 "95% Confidence Interval"))

cap		graph export Drafts/JEPS/figures/voteshare_bar_urban.pdf, as(pdf) replace

****Figure 4
graph twoway (bar votesharec data, barwidth(.6)) (rcap hic lowc data), by(Competitive) ///
xlabel(1 "Official" 2 "Survey", noticks) xscale(r(0.5 2.5)) /// 
scheme(s1mono)  ytitle("Mean Incumbent Voteshare") yscale(r(0 .6)) ylabel(0(.1).5) ///
xtitle("") legend(order(2 "95% Confidence Interval"))

cap		graph export Drafts/JEPS/figures/voteshare_bar_competitive.pdf, as(pdf) replace

gen turnout1=. in 1/2
gen sd1=. in 1/2
gen n1=. in 1/2

summ official_t if survey_turn~=., detail
replace turnout1=r(mean) if _n==1
replace sd1=r(sd) if _n==1
replace n1=r(N) if _n==1

summ survey_turn if survey_turn~=., detail
replace turnout1=r(mean) if _n==2
replace sd1=r(sd) if _n==2
replace n1=r(N) if _n==2

generate hi1=turnout1 + invttail(n1-1,0.025)*(sd1 / sqrt(n1))
generate low1=turnout1 - invttail(n1-1,0.025)*(sd1 / sqrt(n1))

****Figure 2
graph twoway (bar turnout1 data, barwidth(.6)) (rcap hi1 low1 data), ///
xlabel(1 "Official" 2 "Survey", noticks) xscale(r(0.5 2.5)) /// 
scheme(s1mono)  ytitle("Mean Voter Turnout") ylabel(0(.1).9) ///
xtitle("") legend(order(2 "95% Confidence Interval"))

cap		graph export Drafts/JEPS/figures/turnout_bar.pdf, as(pdf) replace	

************************

***Figures 5 and 6
** Plots with confidence intervals from regressions


label variable treatment "Treatment Effect"

areg official_vote treatment if survey_vote~=.&goodnews==1, absorb(blid)		
		est store Official

preserve

	use "survey_merge.dta", clear

	* Run do file
	do 01_survey_clean.do
		areg incumbent_vote treatment if goodnews==1, absorb(blid) vce(cluster quartier)
				est store Survey



	coefplot Official Survey, vertical  yline(0) keep(treatment)  ///
	ylabel(, angle(horizontal)) graphr(color(white)) xlabel(, noticks)

	
cap			graph export Drafts/JEPS/figures/treatment_goodnewsCIs.pdf, as(pdf) replace	

** 
		
restore


areg official_vote treatment if survey_vote~=.&goodnews==0, absorb(blid)		
		est store Official

*preserve

use "survey_merge.dta", clear

	* Run do file
	do 01_survey_clean.do
	areg incumbent_vote treatment if goodnews==0, absorb(blid) vce(cluster quartier)
				est store Survey

		
		
	coefplot Official Survey, vertical  yline(0) keep(treatment)  ///
	ylabel(, angle(horizontal)) graphr(color(white)) xlabel(, noticks)
	
cap			graph export Drafts/JEPS/figures/treatment_badnewsCIs.pdf, as(pdf) replace	

				
*****Appendix
** Table G1
clear
use "merged_administrative_5.dta"
do balance_unmatched-matchedvillages.do

**Table G2
gen lg_voters = log(regvoters)
*hist lg_voters

* Change two very high vote margins in low dosage to missing
replace margin = . if margin > 1

matrix define hist=J(5, 4, .)
matrix colnames hist = "Mean High Dosage" "Mean Low Dosage" "Difference" "P-Value"    
matrix rownames hist = "Registered Voters (log)" "Urban" "Competitive (dichotomous)" ///
		       "Vote Margin" "Overall Performance" 

local i = 0			   
foreach var in lg_voters area competitive_margin margin main_index {
	local i = `i' + 1
	qui regress `var' dosage, cluster(commune)
	local a = _b[_cons] + _b[dosage]
	display `a'
	matrix hist[`i', 1] = round(`a', .01)
	matrix hist[`i', 2] = round(_b[_cons], .01)
	matrix hist[`i', 3] = round(abs(_b[dosage]), .01)
	matrix temp = r(table)
	local p = temp[4, 1]
	display `p'
	matrix hist[`i', 4] = round(`p', .01)

}			   

tab condition_numeric, gen(tr)
			   
matrix list hist

cap esttab m(hist) using Drafts/Tables/dosage_balance_admin.tex, replace nomtitle ///
	addnote("P-values generated from tests in which we cluster on commune.")
	

**Table G3
matrix define hist=J(10, 5, .)
matrix colnames hist = "Control" "Info Only/Private" "Info Only/Public" "Civics/Private" "Civics/Public"   
matrix rownames hist = "Registered Voters (log)" " " "Urban" " " "Competitive (dichotomous)" " " ///
		       "Vote Margin" " " "Overall Performance" " "
	
local i = -1	
local j = 0		   
foreach var in regvoters area competitive_margin margin main_index {
	local i = `i' + 2
	local j = `j' + 2

	qui regress `var' tr2-tr5 if dosage==1, cluster(commune)
	local a1 = _b[_cons] + _b[tr2]
	local a2 = _b[_cons] + _b[tr3]
	local a3 = _b[_cons] + _b[tr4]
	local a4 = _b[_cons] + _b[tr5]

	display `a'
	matrix hist[`i', 1] = round(_b[_cons], .01)
	matrix hist[`i', 2] = round(`a1', .01)
	matrix hist[`i', 3] = round(`a2', .01)
	matrix hist[`i', 4] = round(`a3', .01)
	matrix hist[`i', 5] = round(`a4', .01)
	
	matrix temp = r(table)

	matrix hist[`j', 2] = round(temp[4, 1], .01)
	matrix hist[`j', 3] = round(temp[4, 2], .01)
	matrix hist[`j', 4] = round(temp[4, 3], .01)
	matrix hist[`j', 5] = round(temp[4, 4], .01)
}				
	
matrix list hist
	
cap esttab m(hist) using Drafts/Tables/balance_high_dose.tex, replace nomtitle ///
	addnote("P-values generated from tests in which we cluster on commune.")matrix define hist=J(10, 5, .)
matrix colnames hist = "Control" "Info Only/Private" "Info Only/Public" "Civics/Private" "Civics/Public"   
matrix rownames hist = "Registered Voters (log)" " " "Urban" " " "Competitive (dichotomous)" " " ///
		       "Vote Margin" " " "Overall Performance" " "
	
local i = -1	
local j = 0		   
foreach var in regvoters area competitive_margin margin main_index {
	local i = `i' + 2
	local j = `j' + 2

	qui regress `var' tr2-tr5 if dosage==1, cluster(commune)
	local a1 = _b[_cons] + _b[tr2]
	local a2 = _b[_cons] + _b[tr3]
	local a3 = _b[_cons] + _b[tr4]
	local a4 = _b[_cons] + _b[tr5]

	display `a'
	matrix hist[`i', 1] = round(_b[_cons], .01)
	matrix hist[`i', 2] = round(`a1', .01)
	matrix hist[`i', 3] = round(`a2', .01)
	matrix hist[`i', 4] = round(`a3', .01)
	matrix hist[`i', 5] = round(`a4', .01)
	
	matrix temp = r(table)

	matrix hist[`j', 2] = round(temp[4, 1], .01)
	matrix hist[`j', 3] = round(temp[4, 2], .01)
	matrix hist[`j', 4] = round(temp[4, 3], .01)
	matrix hist[`j', 5] = round(temp[4, 4], .01)
}				
	
matrix list hist
	
cap esttab m(hist) using Drafts/Tables/balance_high_dose.tex, replace nomtitle ///
	addnote("P-values generated from tests in which we cluster on commune.")
	
**Table G4
matrix define hist=J(5, 4, .)
matrix colnames hist = "Mean Treatment" "Mean Control" "Difference" "P-Value"    
matrix rownames hist = "Registered Voters (log)" "Urban" "Competitive (dichotomous)" ///
		       "Vote Margin" "Overall Performance" 

local i = 0			   
foreach var in regvoters area competitive_margin margin main_index {
	local i = `i' + 1
	qui regress `var' treatment if dosage==0
	local a = _b[_cons] + _b[treatment]
	display `a'
	matrix hist[`i', 1] = round(`a', .01)
	matrix hist[`i', 2] = round(_b[_cons], .01)
	matrix hist[`i', 3] = round(abs(_b[treatment]), .01)
	matrix temp = r(table)
	local p = temp[4, 1]
	display `p'
	matrix hist[`i', 4] = round(`p', .01)

}			   

			   
matrix list hist

cap esttab m(hist) using Drafts/Tables/balance_low_dosage.tex, replace nomtitle 

log close
