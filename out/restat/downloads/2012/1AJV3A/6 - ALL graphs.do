set logtype text
set more off
clear all 
set mem 150m
set matsize 150

set scheme s1mono

global repfiles "C:\Users\Michael McMahon\Dropbox\Giavazzi Restat - Publication version\Replication files"
cd "$repfiles"

* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

do "6b - EC uncertainty graphs.do"

* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

do "6c - UE rate graph.do"

* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

clear all
version 9
global datapath "C:\Users\Michael McMahon\Dropbox\GSOEP21"
cd "$datapath\GiavazziMcMahonReStat"

use final.dta, replace

*BASELINE SAVING RESULTS

drop if age>68
drop if age<24

bysort new_hhnum: gen obs = _N
drop if obs!=6

drop if foreign==1

*PROPENSITY SCORES
preserve

*LOGIT FE

xtlogit  affected education_years people_hh marital gender ue age, fe
estimates store FE
predict test 

#delimit ;
	twoway (histogram test if affected==0, discrete percent width(0.1) )
      , xtitle("Pr(treated = 1 | household characteristics)", size(small)) ytitle("Percent of Predicted distribution", size(small)) 
	graphregion(color(white))
	title("Civil Servants", size(medsmall)) fxsize(150);
#delimit cr
graph save "CS_prop" , replace

#delimit ;
	twoway (histogram test if affected==1, discrete percent width(0.1) )
      , xtitle("Pr(treated = 1 | household characteristics)", size(small)) ytitle("Percent of Predicted distribution", size(small))
	graphregion(color(white))
	title("Non-Civil Servants", size(medsmall)) fxsize(150);
#delimit cr
graph save "NONCS_prop" , replace

#delimit ;
	graph combine "CS_prop" "NONCS_prop"
	, colfirst ycommon rows(1) 
	 title("Propensity Score - Probability Distribution", size(medsmall)) 
	/*graphregion(margin(l=10 r=10))*/
	note("The horizontal axis shows the estimated probability of being treated measured from a panel logit regression" 
"of being treated - being affected by the uncertainty (a non-CS individual) - on various controls"
"including a household fixed effect. The vertical axis shows the percent of households in each group.", span size(small)) 
	graphregion(color(white))
	scale(1);
#delimit cr
graph export "C:\Users\Michael McMahon\Dropbox\GSOEP21\GiavazziMcMahonReStat\prop_scores.eps", replace

restore

* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

preserve

drop if worry_fin==.
drop if worry_fin==-1

drop if worry_ec==.
drop if worry_ec==-1

drop if worry_job==.
drop if worry_job==-1
replace worry_job=3  if labour_split==0
replace worry_job=1  if labour_split==2

replace worry_fin = 4-worry_fin
replace worry_job = 4-worry_job
replace worry_ec = 4-worry_ec

keep if labour_split>=3

egen byte tagger = tag(pnum)
bysort new_hhnum: egen head_changes = sum(tagger) 
bysort new_hhnum: egen same_head = max(head_changes)

keep if same_head==1

keep year affected worry_fin worry_job worry_ec new_hhnum 

#delimit ;
collapse (mean) mean_worry_fin=worry_fin (median) med_worry_fin=worry_fin (p75) p75_worry_fin=worry_fin (p25) p25_worry_fin=worry_fin (p60) p60_worry_fin=worry_fin (p40) p40_worry_fin=worry_fin
(mean) mean_worry_job=worry_job (median) med_worry_job=worry_job (p75) p75_worry_job=worry_job (p25) p25_worry_job=worry_job (p60) p60_worry_job=worry_job (p40) p40_worry_job=worry_job
(mean) mean_worry_ec=worry_ec (median) med_worry_ec=worry_ec (p75) p75_worry_ec=worry_ec (p25) p25_worry_ec=worry_ec (p60) p60_worry_ec=worry_ec (p40) p40_worry_ec=worry_ec
, by(affected year);
#delimit cr

label variable  mean_worry_fin Mean
label variable  p75_worry_fin "75th Percentile"
label variable  p25_worry_fin "25th Percentile"
label variable  p60_worry_fin "60th Percentile"
label variable  p40_worry_fin "40th Percentile"
label variable  med_worry_fin "Median"

label variable  mean_worry_job Mean
label variable  p75_worry_job "75th Percentile"
label variable  p25_worry_job "25th Percentile"
label variable  p60_worry_job "60th Percentile"
label variable  p40_worry_job "40th Percentile"
label variable  med_worry_job "Median"

label variable  mean_worry_ec Mean
label variable  p75_worry_ec "75th Percentile"
label variable  p25_worry_ec "25th Percentile"
label variable  p60_worry_ec "60th Percentile"
label variable  p40_worry_ec "40th Percentile"
label variable  med_worry_ec "Median"

capture program drop worry_charts
program define worry_charts
while "`1'"!="" {
	#delimit ;
		twoway (line mean_worry_`1' year if affected==0, lcolor(black) lwidth(thick) lpattern(solid) /*connect(stairstep)*/)
		(line  p75_worry_`1' year if affected==0, lcolor(black) lwidth(thin) lpattern(dash) connect(stairstep))	 
		(line  p25_worry_`1' year if affected==0, lcolor(black) lwidth(thin) lpattern(dash) connect(stairstep))
	      , xtitle("Year", size(small)) ytitle("Qualitative Worry Scale: 3 = Most Worried", size(small))  ylabel(0(0.5)3)
		legend(pos(3)  order(2 1 3) textwidth(15) ring(1) size(vsmall) cols(1)  
		symxsize(4) rowgap(1) region(fcolor(none) lstyle(none)))  
		title("Civil Servants", size(medsmall)) fxsize(150);
	graph save "CS_worry_`1'" , replace;
		twoway (line mean_worry_`1' year if affected==1, lcolor(black) lwidth(thick) lpattern(solid) /*connect(stairstep)*/)	
		(line  p75_worry_`1' year if affected==1, lcolor(black) lwidth(thin) lpattern(dash) connect(stairstep))	 
		(line  p25_worry_`1' year if affected==1, lcolor(black) lwidth(thin) lpattern(dash) connect(stairstep))
	      , xtitle("Year", size(small)) ytitle("Qualitative Worry Scale: 3 = Most Worried", size(small))  ylabel(0(0.5)3)
		legend(pos(3)  order(2 1 3) textwidth(15) ring(1) size(vsmall) cols(1)  
		symxsize(4) rowgap(1) region(fcolor(none) lstyle(none))) 
		title("Non-Civil Servants", size(medsmall)) fxsize(150);
	graph save "NONCS_worry_`1'" , replace;
#delimit cr
	if "`1'" == "job"  {  
		local title "Self-assessed Worries about Job Security"
	}
	else if "`1'" == "fin"  {    
		local title "Self-assessed Worries about Household Finances"
	}
	else if "`1'" == "ec"  {  
		local title "Self-assessed Worries about the Economy"
	}
	else {  
		local title "ADD TITLE"
	}
	display "`title'"
#delimit ;
	graph combine "CS_worry_`1'" "NONCS_worry_`1'", 
	colfirst xcommon cols(1) 
	 title(`title', size(medsmall)) 
	note("Baseline sample using GSOEP data: uses only households where the same respondent answers each year.", span size(small)) scale(1);
#delimit cr
graph export "C:\Users\Michael McMahon\Dropbox\GSOEP21\GiavazziMcMahonReStat\worry_`1'.eps", replace

macro shift
}
end

worry_charts  ec fin job

restore

* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

preserve
  
clear all
version 9
global datapath "C:\Users\Michael McMahon\Dropbox\GSOEP21"
cd "$datapath\GiavazziMcMahonReStat"

use final.dta, replace

*BASELINE SAVING RESULTS

bysort new_hhnum: gen obs = _N
drop if obs!=6

drop if foreign==1

keep if year==1998

collapse (mean) mean_sr_y_pos=sr_y_pos  mean_sr_c_y_pos=sr_c_y_pos , by(agegrp)

label var agegrp "Age"
label var mean_sr_y_pos "Reported SR (Mean)"
label var mean_sr_c_y_pos "Corrected SR (Mean)"

#delimit ;
twoway (line mean_sr_y_pos agegrp, lcolor(red) lwidth(thick) lpattern(dash) yline(0, lwidth(thin) lcolor(black) noextend) ) 
	(line  mean_sr_c_y_pos agegrp, lcolor(black) lwidth(thick) lpattern(solid))	 
		, xtitle("Head of Household Age", size(small)) ytitle("Household Saving Rate (% of Disposable Income)", size(small)) 
		graphregion(color(white))
		note("Baseline sample using GSOEP data: Mean saving rate by head of household age group in 1998", span size(small)) 
		legend(pos(0)  textwidth(15) ring(1) size(vsmall) cols(1) 
		symxsize(4) rowgap(1) region(fcolor(none) lstyle(none))) ;
#delimit cr
graph export "C:\Users\Michael McMahon\Dropbox\GSOEP21\GiavazziMcMahonReStat\corrected_saving.eps", replace

restore

* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

preserve 

keep year affected sr_y_pos new_hhnum 

#delimit ;
collapse (mean) mean_sr_y_pos=sr_y_pos (median) med_sr_y_pos=sr_y_pos (p75) p75_sr_y_pos=sr_y_pos (p25) p25_sr_y_pos=sr_y_pos
, by(affected year);
#delimit cr

label variable  mean_sr_y_pos Mean
label variable  p75_sr_y_pos "75th Percentile"
label variable  p25_sr_y_pos "25th Percentile"
label variable  med_sr_y_pos "Median"

#delimit ;
	twoway (line mean_sr_y_pos year if affected==0, lcolor(black) lwidth(thick) lpattern(solid) )
	(line  p75_sr_y_pos year if affected==0, lcolor(black) lwidth(thin) lpattern(dash) )	 
	(line  p25_sr_y_pos year if affected==0, lcolor(black) lwidth(thin) lpattern(dash) )
	, xtitle("Year", size(small)) ytitle("% of Disposable Income", size(small))  ylabel(0(4)20)
	graphregion(color(white))
	legend(pos(3)  order(2 1 3) textwidth(15) ring(1) size(vsmall) cols(1)  
	symxsize(4) rowgap(1) region(fcolor(none) lstyle(none)))  
	title("Civil Servants", size(medsmall)) fxsize(150);
graph save "CS_saving" , replace;
	twoway (line mean_sr_y_pos year if affected==1, lcolor(black) lwidth(thick) lpattern(solid) )	
	(line  p75_sr_y_pos year if affected==1, lcolor(black) lwidth(thin) lpattern(dash) )	 
	(line  p25_sr_y_pos year if affected==1, lcolor(black) lwidth(thin) lpattern(dash) )
      , xtitle("Year", size(small)) ytitle("% of Disposable Income", size(small))  ylabel(0(4)20)
	graphregion(color(white))
	legend(pos(3)  order(2 1 3) textwidth(15) ring(1) size(vsmall) cols(1)  
	symxsize(4) rowgap(1) region(fcolor(none) lstyle(none))) 
	title("Non-Civil Servants", size(medsmall)) fxsize(150);
graph save "NONCS_saving" , replace;
	
	graph combine "CS_saving" "NONCS_saving", 
	colfirst xcommon cols(1) 
	graphregion(color(white))
	 title("Household Saving Rate (% of Disposable Income)", size(medsmall)) 
	note("Baseline sample using GSOEP data.", span size(small)) scale(1);
#delimit cr
graph export "C:\Users\Michael McMahon\Dropbox\GSOEP21\GiavazziMcMahonReStat\savings.eps", replace

restore

* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
