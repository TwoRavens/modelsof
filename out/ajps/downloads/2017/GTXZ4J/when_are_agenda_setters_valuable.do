* PROGRAM :			when_are_agenda_setters_valuable.do
* AUTHOR :			Alexander Fouirnaies (fouirnaies@uchicago.edu)
* INFILE(S) :		when_are_agenda_setters_valuable.dta
* OUTFILE(S) :		table_1.tex, table_2.tex, table_3.tex, table_4.tex, table_5.tex, table_6.tex, 
*					figure_1.pdf, figure_2.pdf, figure_3a.pdf, figure_3b.pdf, figure_4.pdf,
*					appendix_table_1.tex, appendix_table_2.tex, appendix_table_3.tex,
*					appendix_table_4.tex, appendix_table_5.tex, appendix_table_6.tex, appendix_figure_1.pdf 
* DATE WRITTEN :	March 2017
*************************************************************************



***************** Install the Stata-modules: "reghdfe", "estout" and "labutil" *******************
**************************************************************************************************

cap ado uninstall reghdfe
ssc install reghdfe

cap ado uninstall estout
ssc install estout

cap ado uninstall labutil 
ssc install labutil

**************************************************************************************************

clear
program drop _all
set matsize 5000

**set locals to 1 to run code, zero to skip code.
local table_1=1
local figure_1=1
local table_2=1
local figure_2=1
local figure_3a=1
local figure_3b=1
local table_3=1
local figure_4=1
local table_4=1
local tables_5_and_6=1
local appendix=1


*********************************************************************
***** Replication code for  "When Are Agenda Setters Valuable?" *****
*********************************************************************


if `table_1'==1 {

	*************
	** Table 1 **
	*************
	
	estimates clear //clear estimates
	use "when_are_agenda_setters_valuable.dta", clear //open dataset
	
	eststo: xtreg pct_amountindustry_1   i.StateChamberYear    Leader   Chair IncMaj, fe cluster(CandId) //fixed-effects regression

	eststo: xtreg log_amountindustry_1   i.StateChamberYear    Leader   Chair IncMaj, fe cluster(CandId) //fixed-effects regression
	
	esttab  using "table_1.tex" ///
	,  replace keep(Leader Chair IncMaj  )  label se  nostar ///
	substitute( "\hline" "\midrule" N_clust "Legislators" N "Observations") ///
	noobs nonumbers nomtitles fragment scalar(N N_clust ) b(%4.2fc %4.2fc) sfmt(  %9.0fc  %9.0fc  ) // save results in tex format

}





if `figure_1'==1 { 

	**************
	** Figure 1 **
	**************

	use "when_are_agenda_setters_valuable.dta", clear //open dataset
	 
	xtreg pct_amountindustry_1  i.StateChamberYear chairs_rules chairs_approp chairs_business chairs_waysandmeans chairs_energy chairs_law chairs_education chairs_health chairs_finance chairs_agriculture chairs_transportation chairs_other  Leader_minleader Leader_majleader Leader_speakerpres IncMaj , fe cluster(CandId) //fixed-effects regression
	
	//create empty variables
	gen est_leader = .
	gen upper_leader=.
	gen lower_leader=.
	gen est_chair = .
	gen upper_chair=.
	gen lower_chair=.
	gen est = .
	gen position = ""
	local i=1
	
	// save the estimates and confidence intervals for party-leader estimates
	qui foreach v in  Leader_minleader Leader_majleader Leader_speakerpres {
		replace est = _b[`v'] if _n==`i'
		replace est_leader = _b[`v'] if _n==`i'
		replace upper_leader = _b[`v']+1.96*_se[`v'] if _n==`i' //1.96 are chosen to produce 95%-confidence intervals
		replace lower_leader = _b[`v']-1.96*_se[`v'] if _n==`i'
		local varlab : variable label `v'
		replace position = "`varlab'" if _n == `i'
		local i=`i' + 1
	}
	
	// save the estimates and confidence intervals for committee-chair estimates	
	qui foreach v in chairs_rules chairs_approp chairs_waysandmeans chairs_energy chairs_business chairs_law chairs_education chairs_health chairs_finance chairs_agriculture chairs_transportation chairs_other  {
		replace est = _b[`v'] if _n==`i'
		replace est_chair = _b[`v'] if _n==`i'
		replace upper_chair = _b[`v']+1.96*_se[`v'] if _n==`i'
		replace lower_chair = _b[`v']-1.96*_se[`v'] if _n==`i'
		local varlab : variable label `v'
		replace position = "`varlab'" if _n == `i'
		local i=`i' + 1
	}
	
	keep est* upper* lower* position
	keep if position!=""
	sort est
	gen n1 = _n
	labmask n1, values(position)
	
	twoway (rcap lower_chair upper_chair n1,   horizontal lcolor(lavender) msize(medium) ) ///
	(dot est_chair n1,  horizontal ndots(1) mcolor(lavender) msize(medlarge)  msymbol(diamond_hollow) ) ///
	(rcap lower_leader upper_leader n1,   horizontal lcolor(dknavy) msize(tiny) lpattern("shortdash") ) ///
	(dot est_leader n1,  horizontal ndots(1) mcolor(dknavy) msize(medlarge) ) ,  ///
	subtitle(, bcolor(white))   xline(0, lcolor(black)) graphregion(color(white))   ///
	title("") xtitle("Effect of Attaining a Party- or Committee-leadership" "Position on % of Total Industry Contributions", ///
	size(small)) xlabel(0 (0.25) 2 ,labsize(small) ) ytitle("") ///
	ylabel(1 (1) 15,valuelabel angle(horizontal) labsize(small) )  ///
	legend( size(small) order(  4 "Leaders" 2  "Chairs" ) ring(0) position(4) col(1) )
	graph export "figure_1.pdf", replace //save pdf file

}


if `table_2'==1 {

	*************
	** Table 2 **
	*************

	estimates clear
	use "when_are_agenda_setters_valuable.dta", clear //open dataset

	keep if chamber=="house" //only keep lower chambers
	
	eststo: xtreg pct_amountindustry_1 speakerpowerXspeaker  Leader_speaker Chair IncMaj squireXLeader_speaker limitXLeader_speaker i.StateChamberYear, fe cluster(CandId)	//fixed-effects regression
	
	eststo: xtreg log_amountindustry_1 speakerpowerXspeaker  Leader_speaker Chair IncMaj  squireXLeader_speaker limitXLeader_speaker i.StateChamberYear, fe cluster(CandId) //fixed-effects regression
	
	esttab  using "table_2.tex" ///
	,  replace keep(speakerpowerXspeaker Leader_speakerpres Chair IncMaj  )  label se  nostar ///
	substitute( "\hline" "\midrule" N_clust "Legislators" N "Observations") ///
	noobs nonumbers nomtitles fragment scalar(N N_clust ) b(%4.2fc %4.2fc) sfmt(  %9.0fc  %9.0fc  ) 

}




if `figure_2'==1 {

	**************
	** Figure 2 **
	**************

	estimates clear
	use "when_are_agenda_setters_valuable.dta", clear //open dataset
	
	gen industry=""

	matrix B = J(100, 10, .)
	local j=1
	qui foreach i of varlist industry1 - industry86 { // run fixed-effects regression for each of the industries
		
		xtreg log_`i'_1 Chair Leader IncMaj  i.StateChamberYear , fe cluster(CandId)
		matrix B[`j', 1] = _b[Leader]
		matrix B[`j', 2] = _b[Leader] - invnorm(1-[0.05/70])*_se[Leader] // Bonferroni one sided test, 0.05 sign. level, 70 tests
		matrix B[`j', 3] = _b[Leader] + invnorm(1-[0.05/70])*_se[Leader]
	
		matrix B[`j', 4] = _b[Chair]
		matrix B[`j', 5] = _b[Chair] - invnorm(1-[0.05/70])*_se[Chair]
		matrix B[`j', 6] = _b[Chair] + invnorm(1-[0.05/70])*_se[Chair]
		
		matrix B[`j', 10] =`j'
	
		local varlab : variable label `i'
		replace industry = "`varlab'" if _n == `j'
		local j=`j'+1
	}

	svmat B
	keep B* industry
	keep if B1 != .
	rename B1 b_leader
	rename B2 ci_lower_leader
	rename B3 ci_upper_leader
	rename B4 b_chair
	rename B5 ci_lower_chair
	rename B6 ci_upper_chair
	
	replace industry = regexr(industry, "iscellaneous" ,"isc.")
	
	//only plot estimates for 70 most sensitive industries (drop 16 first obs)
	sort b_leader
	drop if _n<17
	gen n1=_n 
	gen n2=_n 
	 
	
	labmask n1, values(industry) //lable results
	replace n2=n2-0.4
	
	twoway (rcap ci_lower_leader ci_upper_leader n1,   horizontal lcolor(dknavy) lpattern("shortdash") msize(tiny) ) ///
	(dot b_leader n1,  horizontal ndots(1) mcolor(dknavy) msize(small) ) /// mlabel(labelmarker) mlabgap(12) mlabcolor(black) mlabsize(vsmall) ) ///
	(rcap ci_lower_chair ci_upper_chair n2,  horizontal lcolor(lavender) msize(tiny) ) ///
	(dot b_chair n2,  horizontal ndots(1) msymbol(diamond_hollow) mcolor(lavender) msize(small)  ) ///
	 ,  subtitle(, bcolor(white))   xline(0, lcolor(black)) graphregion(color(white))   ///
	 title("") xtitle("Effect of Attaining Agenda-setting Power" "on (log of) Contributions", size(vsmall)) xlabel(0 (0.2) 1 ,labsize(small) ) ///
	 ylabel(1 (1) 70,valuelabel angle(horizontal) labsize(tiny) )   ysize(20) xsize(15) ///
	legend( size(small) order( 2 "Leader" 4 "Chair" ) ring(0) position(4) col(1) ) 
	graph export "figure_2.pdf", replace 
	
	

}



if `figure_3a'==1 {

	***************
	** Figure 3a **
	***************

	use "when_are_agenda_setters_valuable.dta", clear //open dataset
	
	foreach v in agriculture energy finance health construction business  transportation education law { 
		rename pct_`v'_1 pct_amount_`v'

		}
		
	//keep only relevant variables
	keep year CandId chairs_* *amount_education  *amount_agriculture *amount_energy *amount_law *amount_finance  *amount_health  *amount_construction *amount_business  *amount_transportation  
	
	**reshape to long format such that each row pertains to a candidate-sector-year
	qui reshape long  chairs_  pct_amount_ , i(CandId year ) j(sector) string
	
	
	local outcome pct_amount_
	order CandId sector year  chairs_* 
	sort CandId sector year
	
	by CandId sector: replace year = _n
	by CandId sector: egen minyear = min(year)
	by CandId sector: gen ChangeToChair = year if chairs_==1 & chairs_[_n-1]==0 // not Chair at t-1, Chair at t
	replace ChangeToChair = . if minyear == ChangeToChair //
	by CandId sector: egen YearChange = min(ChangeToChair) // first year change to chair
	gen t = year - YearChange // years relative to first change
	gen c = `outcome' if  YearChange==. // minority incumbents money not in treatment group
	sort CandId year 
	by CandId year : egen control = mean(c) // mean of
	replace `outcome' = . if year>YearChange & chairs_==0
	sort CandId year
	collapse (mean) `outcome' control , by(t)
		replace t = t+1
	drop if t>5 | t<-5
	
		twoway (line pct_amount t, lcolor(dknavy)) (line control t, lpattern(shortdash) lcolor(lavender) ) ///
 , tline(0  , lpatter(shortdash) lcolor(black) ) text(1 0 "First session as chair of" "sector-relevant committee" "kicks in after election 0", placement(right)) ///
	graphregion(color(white)) ytitle("% of Total Contributions Allocated" "by Sector j to Legislator i", size(medium)) xtitle("Elections Relative to Year of Attaining Chair Position", size(medium)) tlabel(-5 (1) 5) ylabel(0 (1) 5) ///
	legend(order(1 "Average Donations from Sectors with" "Vested Interest in Committeee" 2 "Average Donations from Sectors without" "Committee-specific Interests" ) ring(0) position(11) col(1) size(medsmall)) 	
	
	graph export "figure_3a.pdf", replace 

}






if `figure_3b'==1 {

	***************
	** Figure 3b **
	***************

	use "when_are_agenda_setters_valuable.dta", clear //open dataset
	local i = 1
	gen b_other=.
	gen se_other = .
	gen b_interests = .
	gen se_interests = .
	gen c= .
	gen industry = ""
	qui foreach v in agriculture energy health transportation construction business finance   education law { // run fixed-effects regression for each of the sectors
		drop c
		gen c = chairs_`v'==0 & Chair==1
		xtreg pct_`v'_1   i.StateChamberYear   Leader chairs_`v' c  IncMaj , fe cluster(CandId)
		
		replace industry = "`v'" if _n==`i'
		replace b_interests = _b[chairs_`v'] if _n==`i'
		replace se_interests = _se[chairs_`v'] if _n==`i'	
		replace b_other = _b[c] if _n==`i'
		replace se_other = _se[c]	 if _n==`i'	
		local i = `i'+1
	}
	keep b_* se_* industry
	drop if b_other==.
	sort b_interests
	replace industry = proper(industry)
	gen upper_interests = b_interests + 1.96*se_interests
	gen lower_interests = b_interests - 1.96*se_interests
	gen upper_other = b_other + 1.96*se_other
	gen lower_other = b_other - 1.96*se_other

	gen n1 = _n 
	gen n2 = _n+0.1
	gen n3 = _n-0.1
	labmask n1, values(industry)
	
	twoway (rcap lower_interests upper_interests n1,   horizontal lcolor(dknavy) msize(medium) ) ///
	(dot b_interests n1,  horizontal ndots(1) mcolor(dknavy) msize(medium) ) /// 
	 (rcap lower_other upper_other n2,  horizontal lcolor(lavender) msize(tiny) lpattern("shortdash") ) ///
	(dot b_other n2,  horizontal ndots(1) msymbol(square_hollow) mcolor(lavender) msize(medium)  ) ///	
	 ,  subtitle(, bcolor(white))   xline(0, lcolor(black)) graphregion(color(white))   ///
	 title("") xtitle("Effect of Attaining Committee-Chair Position" "on % of Total Sector Contributions", size(medium)) xlabel(0 (0.25) 2 ,labsize(small) ) ///
	 ylabel(1 (1) 9,valuelabel angle(horizontal) labsize(medsmall) )  ///
	legend( size(medsmall) order( 2 "Sector Relevant Chairs" 4 "Sector Nonrelevant Chairs" ) ring(0) position(4) col(1) ) 	
	graph export "figure_3b.pdf", replace 

}



if `table_3'==1 {

	**************
	** Table 3 **
	**************

	use "when_are_agenda_setters_valuable.dta", clear //open dataset
	
	foreach v in agriculture energy finance health construction business  transportation education law {
		rename log_amount_`v'_1 log_amount_`v'
		rename pct_`v'_1 pct_amount_`v'

		}
		
	//keep only relevant variables
	keep   party Leader IncMaj StateChamberYear state year chamber CandId chairs_*   *_amount_agriculture *amount_energy *amount_finance  *amount_health  *amount_transportation *amount_construction *amount_business *amount_education *amount_law  
	
	**reshape to long format such that each row pertains to a candidate-sector-year
	qui reshape long  chairs_   amount_  log_amount_ pct_amount_, i(CandId year ) j(sector) string
	
	egen SectorChamberYears = group(sector state chamber year)
	egen CandIdYears = group(CandId year)
	egen CandIdSector = group(CandId sector)
	label var chairs_  "Chair of Committee \\ Regulating Sector j"
	estimates clear

	eststo: reghdfe pct_amount_  chairs_    , absorb(CandIdYear  CandIdSector   SectorChamberYears ) cluster(CandId) keepsingletons
	
	eststo: reghdfe log_amount_  chairs_   , absorb(CandIdYear CandIdSector   SectorChamberYears ) cluster(CandId) keepsingletons

	esttab  using "table_3.tex" ///
	,  replace keep(chairs_  ) label se  nostar ///
		substitute( "\hline" "\midrule" N_clust "Legislators" N "Observations") ///
	noobs nonumbers nomtitles fragment scalar(N N_clust ) b(%4.2fc %4.2fc) sfmt(  %9.0fc  %9.0fc  ) 
	
}






if `figure_4'==1 {

	**************
	** Figure 4 **
	**************
	
	use "when_are_agenda_setters_valuable.dta", clear //open dataset

	qui foreach year in 1990 1992 1994 1996 1998 2000 2002 2004 2006 2008 2010 2012 {	//generate interactions between Leader/Chairs variables and year dummies
		gen y`year' = year==`year'
		gen y`year'_Xleader = Leader*y`year'
		gen y`year'_Xchair = Chair*y`year'
		}
	replace year = year-1 if mod(year, 2)==1 // combine few odd year election states with other states
	qui xtreg pct_amountindustry_1 *_X*    IncMaj   i.StateChamberYear  , fe cluster(CandId)
	
	gen b_Leader =.
	gen upper_Leader =.
	gen lower_Leader =.
	gen b_Chair=.
	gen upper_Chair =.
	gen lower_Chair =.
	qui foreach year in 1990 1992 1994 1996 1998 2000 2002 2004 2006 2008 2010 2012 {	
		replace b_Leader = _b[y`year'_Xleader] if year==`year'
		replace upper_Leader = _b[y`year'_Xleader]+1.96*_se[y`year'_Xleader] if year==`year'
		replace lower_Leader = _b[y`year'_Xleader]-1.96*_se[y`year'_Xleader] if year==`year'
		replace b_Chair = _b[y`year'_Xchair] if year==`year'
		replace upper_Chair = _b[y`year'_Xchair]+1.96*_se[y`year'_Xchair] if year==`year'
		replace lower_Chair = _b[y`year'_Xchair]-1.96*_se[y`year'_Xchair] if year==`year'
	}
	
		
	collapse (mean) *_Leader* *_Chair* , by(year )
	
	qui reshape long b_ upper_ lower_ , i(year) j(y) string
	
	drop if year<=1994 | year>2012
	twoway (line b_ year, lcolor(dknavy) ) (line upper_ year,lpattern("dash") lcolor(dknavy)) (line lower_ year,lpattern("dash") lcolor(dknavy)) , by( y ,  note("") graphregion(color(white)) legend(off)  col(2)  ) ///
	subtitle(, bcolor(white)) yline(0, lcolor(black)) graphregion(color(white) ) ylabel(0 (0.25) 1.5) xlabel(1996 (4) 2012, angle(45))  xtitle("")  ytitle("Difference-in-Difference Estimates" "on % of Total Industry Donations") 
	
	graph export "figure_4.pdf", replace 
	
}






if `table_4'==1 {

	**************
	** Table 4 **
	**************

	use "when_are_agenda_setters_valuable.dta", clear //open dataset
	
	estimates clear
	eststo: xtreg pct_amountindustry_1 i.StateChamberYear  LeaderXtime ChairXtime  Leader Chair IncMaj  , fe cluster(CandId)
	
	preserve
	bysort state chamber year: egen mean=mean(amountindustry_1) ,
	drop if mean==.
	bysort state: egen min = min(year)
	keep if min==1988 | min==1990
	eststo: xtreg pct_amountindustry_1  i.StateChamberYear LeaderXtime ChairXtime    Leader Chair    IncMaj   , fe cluster(CandId)
	restore
	
	keep if pct_amountindustry_1!=.
	eststo: xtreg pct_industrypostelect  i.StateChamberYear LeaderXtime ChairXtime   Leader Chair    IncMaj   , fe cluster(CandId)
		
	esttab  using "table_4.tex" ///
	,  replace keep(Chair Leader IncMaj LeaderXtime ChairXtime) label se  nostar ///
		substitute( "\hline" "\midrule" N_clust "Legislators" N "Observations") ///
	noobs nonumbers nomtitles fragment scalar(N N_clust ) b(%4.2fc %4.2fc) sfmt(  %9.0fc  %9.0fc  ) 
		
}





	
if `tables_5_and_6'==1 {	
	
	*************
	** Table 5 **
	*************
	
	estimates clear
	use "when_are_agenda_setters_valuable.dta", clear //open dataset
	
	gen leader_amountindustry_1 = amountindustry_1 if Leader==1
	gen chair_amountindustry_1 = amountindustry_1 if Chair==1
	gen rankandfile_amountindustry_1 = amountindustry_1 if Chair==0 & Leader==0

	*collapse donations to the chamber-year level
	collapse (sum) amountindustry_1 ///
			 (sum) total_leader = leader_amountindustry_1 (mean) mean_leader = leader_amountindustry_1 ///
	         (sum) total_chair = chair_amountindustry_1 (mean) mean_chair = chair_amountindustry_1 ///
	         (sum) total_rankandfile = rankandfile_amountindustry_1 (mean) mean_rankandfile = rankandfile_amountindustry_1 ///
			 (mean) TotalChamber_industry_1 corp_limit_1 corp_unlimited_1   if amountindustry_1!=., by(StateChamber state year)
	
	label var corp_limit_1  "Log(Corporate Limit) $\times$ \\ Limited Corporate"
	label var corp_unlimited_1  "Unlimited Corporate"	
	
	*obs where there are either no leader, chair or rank-and-file obs (because legislators retire)
	drop if mean_leader==. | mean_chair==. | mean_rankandfile==.
	gen log_leader = ln(1+total_leader)
	gen log_chair = ln(1+total_chair)
	gen log_rank = ln(1+total_rank)
	gen log_total = ln(1+amountindustry_1)
		
	eststo:  areg log_leader  corp_unlimited_1 corp_limit_1      i.year , a(StateChamber) cluster(StateChamber)	

	eststo:  areg log_chair corp_unlimited_1 corp_limit_1    i.year , a(StateChamber) cluster(StateChamber)	

	eststo:  areg log_rank corp_unlimited_1 corp_limit_1     i.year , a(StateChamber) cluster(StateChamber)	
	
	esttab  using "table_5.tex" ///
	,  replace keep(corp_limit_1 corp_unlimited_1  )  label se  nostar ///
		substitute( "\hline" "\midrule" N_clust "Legislators" N "Observations") ///
	noobs nonumbers nomtitles fragment scalar(N N_clust ) b(%4.2fc %4.2fc) sfmt(  %9.0fc  %9.0fc  ) 
	

	
	*************
	** Table 6 **
	*************	
	
	
	gen pct_leadership = 100* [total_leader+total_chair ]/ TotalChamber_industry_1
	
	estimates clear
	eststo:  areg pct_leadership corp_unlimited_1 corp_limit_1    i.year , a(StateChamber) cluster(StateChamber)	


	esttab  using "table_6.tex" ///
	,  replace keep(corp_limit_1 corp_unlimited_1   )  label se nostar ///
		substitute( "\hline" "\midrule" N_clust "Legislators" N "Observations") ///
	noobs nonumbers nomtitles fragment scalar(N N_clust ) b(%4.2fc %4.2fc) sfmt(  %9.0fc  %9.0fc  ) 
	
}



*************************************************************
***** Replication code for the results in the Appendix  *****
*************************************************************


if `appendix'==1 {
	
	**********************
	** Appendix Table 1 **
	**********************	
	
	use "when_are_agenda_setters_valuable.dta", clear //open dataset
	
	
	quietly {
		cap log close
		set linesize 255
		log using "appendix_table_1.tex", text replace
		noisily dis "\begin{tabular}{l ccccc}"
		noisily dis "\toprule \toprule"
		noisily dis "  & Mean   & St.Dev.   &  Min.   & Max. & Obs.  \\"
		noisily dis "\midrule"
	
		foreach v of varlist pct_amountindustry_1 log_amountindustry_1 Leader Chair IncMaj {
			sum `v' if Leader!=. & amountindustry_1!=. , d
			noisily dis  `"`: var label `v''"' " & " %3.2f r(mean) " & " %3.2f r(sd) " & " %3.2f r(min) " & " %3.2f r(max)  " & " %9.0fc r(N) "\\[2mm]"
		}
		noisily dis "\bottomrule \bottomrule"	
		noisily dis "\end{tabular}"
		
		log off
	}
	



	**********************
	** Appendix Table 2 **
	**********************	

	use "when_are_agenda_setters_valuable.dta", clear //open dataset

	gen obs_leader = 1 if Leader==1 & amountindustry_1!=. //dummy equal to one if leader at time t runs and collects money at t+1
	gen obs_chair = 1 if Chair==1 & amountindustry_1!=. //dummy equal to one if committee chair at time t runs and collects money at t+1
	gen obs_rank = 1 if Chair==0 & Leader==0 & amountindustry_1!=. //dummy equal to one if legislator is neither leader nor committee chair
	
	collapse (count) obs* (min) minyear = year (max) maxyear=year if amountindustry_1!=.   ,by(state)
	
	quietly {
		cap log close
		set linesize 255
		log using "appendix_table_2.tex", text replace
		noisily dis " \begin{table}[htbp] "
		noisily dis " \caption{{\bf \# observations by state and chamber.}\label{tab:obs}} "
		noisily dis " \begin{center} "
		noisily dis " \begin{adjustbox}{max width=\textwidth} "
		noisily dis "\begin{tabular}{lcccc | lcccc}"
		noisily dis "\toprule \toprule"
		noisily dis " \cmidrule(lr){2-3}  \cmidrule(lr){4-5} \cmidrule(lr){7-8}  \cmidrule(lr){9-10} "
		noisily dis " State  & Period & Leaders & Chairs & Rank and File & State  & Period & Leaders & Chairs & Rank and File\\"
		noisily dis "\midrule"
	
		forval i=1 (2) 50 { 
		di state[`i']	
		noisily dis  state[`i'] " & " %4.0f minyear[`i'] "-" %4.0f maxyear[`i'] " & " %4.0f obs_leader[`i']  " & " %4.0f obs_chair[`i'] "&" %4.0f obs_rank[`i'] 
		noisily dis "&" state[`i'+1] " & " %4.0f minyear[`i'+1] "-" %4.0f maxyear[`i'+1] " & " %4.0f obs_leader[`i'+1]  " & " %4.0f obs_chair[`i'+1] "&" %4.0f obs_rank[`i'+1]  "\\"
	
		}
	
		collapse (sum) obs*
		noisily dis  " \midrule"
		noisily dis  " &  &  & & & " 
		noisily dis " Total & &" %4.0f obs_leader[1] " & " %4.0f obs_chair[1]  " & "  %4.0f obs_rank[1]  "\\"
		
		noisily dis "\bottomrule \bottomrule"	
		noisily dis "\end{tabular}"
		noisily dis "\end{adjustbox}"
		noisily dis "\end{center}"
		noisily dis "\end{table}"
		
		log off
	}
	


	
	**********************
	** Appendix Table 3 **
	**********************		


	**Dropping pre-1998 observations
	estimates clear
	use "when_are_agenda_setters_valuable.dta", clear //open dataset

	drop if year<1998

	*pct
	eststo: xtreg pct_amountindustry_1  i.StateChamberYear Leader   Chair IncMaj, fe cluster(CandId)
	
	*log
	eststo: xtreg log_amountindustry_1  i.StateChamberYear  Leader   Chair IncMaj, fe cluster(CandId)
	
	
	esttab  using "appendix_table_3.tex" ///
	,  replace keep(Leader Chair IncMaj  )  label se  nostar ///
	substitute( "\hline" "\midrule" N_clust "Legislators" N "Observations") ///
	noobs nonumbers nomtitles fragment scalar(N N_clust ) b(%4.2fc %4.2fc) sfmt(  %9.0fc  %9.0fc  ) 
	
	


	
	**********************
	** Appendix Table 4 **
	**********************		
		
	**Adjusting for seniority
	estimates clear
	use "when_are_agenda_setters_valuable.dta", clear //open dataset

	*pct
	eststo: xtreg pct_amountindustry_1  i.StateChamberYear i.Seniority   Leader   Chair IncMaj, fe cluster(CandId)
	
	*log
	eststo: xtreg log_amountindustry_1  i.StateChamberYear i.Seniority   Leader   Chair IncMaj, fe cluster(CandId)
	
	
	esttab  using "appendix_table_4.tex" ///
	,  replace keep(Leader Chair IncMaj  )  label se  nostar ///
	substitute( "\hline" "\midrule" N_clust "Legislators" N "Observations") ///
	noobs nonumbers nomtitles fragment scalar(N N_clust ) b(%4.2fc %4.2fc) sfmt(  %9.0fc  %9.0fc  ) 
	

	**********************
	** Appendix Table 5 **
	**********************		
	
	
	**Adjusting for vote shares
	estimates clear
	use "when_are_agenda_setters_valuable.dta", clear //open dataset

	keep if NumberOfSeats==1 //vote shares are only comparable across single-member districts.
	*pct
	eststo: xtreg pct_amountindustry_1  i.StateChamberYear vtsh   Leader   Chair IncMaj , fe cluster(CandId)
	
	*log
	eststo: xtreg log_amountindustry_1  i.StateChamberYear vtsh   Leader   Chair IncMaj, fe cluster(CandId)
	
	esttab  using "appendix_table_5.tex" ///
	,  replace keep(Leader Chair IncMaj  )  label se  nostar ///
	substitute( "\hline" "\midrule" N_clust "Legislators" N "Observations") ///
	noobs nonumbers nomtitles fragment scalar(N N_clust ) b(%4.2fc %4.2fc) sfmt(  %9.0fc  %9.0fc  ) 
	
	
	
	
	**********************
	** Appendix Table 6 **
	**********************	
	
	**adjusting for seat margin (pct)
	estimates clear
	use "when_are_agenda_setters_valuable.dta", clear //open dataset

	*pct
	eststo: xtreg pct_amountindustry_1  i.StateChamberYear Leader   Chair IncMaj IncSeatshare, fe cluster(CandId)
	
	*log
	eststo: xtreg log_amountindustry_1  i.StateChamberYear  Leader   Chair IncMaj IncSeatshare, fe cluster(CandId)
	
	esttab  using "appendix_table_6.tex" ///
	,  replace keep(Leader Chair IncMaj  )  label se  nostar ///
	substitute( "\hline" "\midrule" N_clust "Legislators" N "Observations") ///
	noobs nonumbers nomtitles fragment scalar(N N_clust ) b(%4.2fc %4.2fc) sfmt(  %9.0fc  %9.0fc  ) 
	
	

	
	************************
	*** Appendix Figure 1 **
	************************	
	
	*pre-treatment
	use "when_are_agenda_setters_valuable.dta", clear //open dataset

	sort CandId year
	forval i=1/3 {
		by CandId: gen Chair_plus`i'=Chair[_n+`i']
		by CandId: gen Leader_plus`i'=Leader[_n+`i']
		by CandId: gen IncMaj_plus`i'=IncMaj[_n+`i']		
	}
	rename Chair Chair_plus0
	rename Leader Leader_plus0
	rename IncMaj IncMaj_plus0
	
	xtreg log_amountindustry_1   Chair_plus*  Leader_plus*  IncMaj_plus*  i.StateChamberYear  , fe cluster(CandId)
	matrix B = J(50, 10, .)
	qui forval i=0/3 {
		local j=`i'+1
		matrix B[`j', 1] = _b[Chair_plus`i']
		matrix B[`j', 2] = _b[Chair_plus`i'] - 1.96*_se[Chair_plus`i']
		matrix B[`j', 3] = _b[Chair_plus`i'] + 1.96*_se[Chair_plus`i']
	
		matrix B[`j', 4] = _b[Leader_plus`i']
		matrix B[`j', 5] = _b[Leader_plus`i'] - 1.96*_se[Leader_plus`i']
		matrix B[`j', 6] = _b[Leader_plus`i'] + 1.96*_se[Leader_plus`i']
		matrix B[`j', 7] = -`i'+0.1
		matrix B[`j', 8] = -`i'+0.2
	
	}
	
	svmat B
	keep if B1 != .
	keep B* 
		
	 twoway   (rcap B2 B3 B7,  lcolor(green)) (scatter B1 B7,  mcolor(green) msymbol(square)) ///
	 (rcap B5 B6 B8,  lcolor(dknavy)) (scatter B4 B8,  mcolor(dknavy)) , ///
	 subtitle(, bcolor(white)) xline(0, lpattern(dash) lcolor(black)) graphregion(color(white)) yline(0,lcolor(black)) ///
	 title("Pre-treatment Effect") legend(order(2 "Chair" 4 "Leader")  ring(0) position(11) ) ytitle("Estimated Effect on log(1+contributions)") ///
	 xtitle("Terms Relative to Treatment")
	 
	 
	graph export "appendix_figure_1.pdf", replace 
	  
		
	
	

}














