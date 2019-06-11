** Run under Stata 14.
// Start bashing it into continuous mstate format

**************************************
use "1 - svolik 2015 - discrete.dta", clear
// just do it this way.  calculate a variable that has the LC offset, and you can just add it to the final t0/t vars for continuous.
	bysort ccode (year): gen temp65 = T-1 if(_n==1 & panelC==1)
	bysort ccode panelC (year): egen lcOffset = max(temp65)
	recode lcOffset (.=0)
	

	
// keep first observation in spell only
bysort ccode panelC (year): egen startDate = min(year)
bysort ccode (year): egen startDate2 = min(year)
bysort ccode (year): egen start_yearT = min(start_year)
gen start_yearLC = min(startDate2, start_yearT)	// because of the ridiculous Haiti case where we end up getting negatives, somehow, if we just use start_yearT as the decider
order startDate start_yearLC, before(year)


// fix t
sort ccode year
replace T = L1.T + 1 if(year==2007 & T==.)	// for 2008 obsvs

bysort ccode panelC (year): gen test = _n	// for the ND obsvs
replace T = test if(stage!=1 & T==.)

	pause off
	pause

drop t test
rename T t

// fix t0
bysort ccode (year): genD transitionF = 1 if((F1.stage!=stage) | demend==1), dummy		

	// Fix the DOM observation, manually.  (Adding the demend==1 deals with all 9 Greek-like observations, but also snags this one DOM obsv. that it shouldn't.)
		replace stage = 1 if(ccode==42 & year==1963)


keep if(transitionF==1)
	drop transitionF
xtset ccode panelC
order t0, before(t)


rename t0 t0Old
rename t tOld

	// fill in start_year, end_year for ND spells
	bysort ccode panelC (year): egen min =  min(year)
	bysort ccode panelC (year): egen max =  max(year)
	

genD t0 = 0, label(t0: Starting clock time for duration)
order t0, before(stage)
sort ccode panelC
replace t0 = L.tOld   if(panelC==2)		// No +1, because we're starting the count from zero.
replace t0 = L.tOld + L.t0 if(panelC>2)

order t0, after(tOld)

gen t = (t0+stageDur)
order t, after(t0)


replace t0 = t0+lcOffset
replace t = t+lcOffset


drop t0Old tOld temp65 temp22 start_yearLC startDate2 start_yearT




// transitions to which stage next
genD nextStage = F1.stage, label(Next possible stage)
genD prevStage = L1.stage, label(Previous occupied stage)
order prevStage nextStage, after(stage)	

		
rename transition status



// Duplicate 3 times, gen a flag for it	
expand 5, gen(exp)	
	recode status (1=0) if(exp==1) 	//resetting status to 0
	recode orig (1=0) if(exp==1) 	//resetting orig to 0
order exp, first
sort ccode year exp	
		
	

// gen all poss combos for nextStage
bysort ccode year exp: gen tempStg = (_n)

order tempStg, after(nextStage)
replace nextStage = tempStg if(exp==1)		
drop tempStg		

		
// drop the impossibles
drop if(stage==nextStage & exp==1)	// e.g.) 0 -> 0 (imposs)

	// For stages 2-4, there's only one way out.  
	drop if(stage==2 & nextStage!=1 & exp==1)
	drop if(stage==3 & nextStage!=1 & exp==1)
	drop if(stage==4 & nextStage!=1 & exp==1)
	
	// Toss the last observation for the panel (it's RC'd.)
	drop if(nextStage==.) // drop if nextStage==., because it means we're at the last set of spells (RC'd)

	// Then, toss what remains--specifically, the duplicate for the actual trans obsv.
	duplicates tag ccode year nextStage, gen(tFlag)
	order tFlag, after(status)
	
	drop if(tFlag==1 & exp==1)			// the duplicate for the actual transition obsv		
	drop tFlag
	drop prevStage


// gen transition ID
	genD trans = ., label(transition ID, R-friendly version)
	order trans, after(status)
	
	recode trans (.=1) if(stage==1 & nextStage==2)
	recode trans (.=2) if(stage==1 & nextStage==3)
	recode trans (.=3) if(stage==1 & nextStage==4)
	recode trans (.=4) if(stage==2 & nextStage==1)
	recode trans (.=5) if(stage==3 & nextStage==1)
	recode trans (.=6) if(stage==4 & nextStage==1)
		// won't have any 3s or 6s, but wanted to keep the code here, in case we re-add in future


// Fix the 9 Greek problems--the countries where the transitions BACK to democracy happen in the same year as the transition OUT of democracy.
replace nextStage = 2 if(trans==. & y_coup==1)
	recode trans (.=1) if(y_coup==1)
	
replace nextStage = 3 if(trans==. & y_inc==1)
	recode trans (.=2) if(y_inc==1)

	// In fixing the Greek problems, you now need to toss the equivalent observation.  For instance, you now (correctly) have a 1->2 observation w/status==1 for Greece at t0==13 and t==16.  You also have a 1->2 for status==0, for the exact same situation.  Drop the ==0.
	duplicates tag ccode year nextStage, gen(tFlag)
	drop if(tFlag==1 & status==0)			// the duplicate for the actual transition obsv		
	
	
	
// Finally, toss all the intermediate spells that we don't need.  E.g.) France, t0 = 95 to t = 97.
drop if trans==. 	// this will also get rid of any of the nextStage==5 observations.  Multitasking FTW.
	

*******************************************************
***** The variable list *****
*****************************

local list lgdp_1_std growth_1_std exec_pres prevd_mil 
	* Based on Table 5, Model 2 (trans eq) for Svolik 2015

*******************************************************

* zero (housekeep): replace all the vars with blanks.
foreach x of local list{
	replace `x' = .
}

preserve
	tempfile main
	use "1 - svolik 2015 - discrete.dta", clear
	drop if(orig==0)
	save `main', replace	
restore


* first, merge strictly based on the proper start date for the spell
drop mergeYear ccodeYr
id ccode start_year, gen(ccodeYr)
merge ccodeYr using "`main'", uniqusing sort nokeep keep(`list' mergeYear) update
tab _merge
drop _merge


* second, merge on observed start date in Svolik's dataset
foreach x of local list{		// to ensure that all the transitions out of stages 2-4 are blank, and ready to be updated
	replace `x' = . if(stage!=1)
}

drop ccodeYr
id ccode startDate, gen(ccodeYr)
merge ccodeYr using "`main'", uniqusing sort nokeep keep(`list' mergeYear) update
tab _merge
drop _merge


* third, merge the lag (based on proper start date).  (e.g., if we have an obsv for 1964 with no data, take the data from 1963)
preserve
	tempfile lag
	use "1 - svolik 2015 - discrete.dta", clear
	
	gen temp = year + 1
	drop ccodeYrL
	id ccode temp, gen(ccodeYrL)
	
	replace mergeYear = temp
	drop if(orig==0)
	save `lag', replace	
restore

drop ccodeYrL
id ccode start_year, gen(ccodeYrL)

merge ccodeYrL using "`lag'", uniqusing sort nokeep keep(`list' mergeYear) update
tab _merge
drop _merge


* fourth, merge the lag (based on observed start date).  (e.g., if we have an obsv for 1964 with no data, take the data from 1963)
drop ccodeYrL
id ccode startDate, gen(ccodeYrL)
merge ccodeYrL using "`lag'", uniqusing sort nokeep keep(`list' mergeYear) update
tab _merge
drop _merge

	/* OK, who's missing data, after all this?

		tab ccode if(mergeYear==.)
		
			  ccode |      Freq.     Percent        Cum.
		------------+-----------------------------------
				220 |          1       20.00       20.00
				255 |          1       20.00       40.00
				315 |          3       60.00      100.00
		------------+-----------------------------------
			  Total |          5      100.00

		 - FRN (220): spell starts 1944 (ends 1945).  Last available data is 1940.  Again, uneasy sticking in pre-war data.
		 - GER (255): spell starts 1990.  No prior data for unified Germany.  Just take it from 1992 (which is where Svolik starts his panel for post-CW Germany, at t=2).
		 - CZE (315): spell starts 1945 (ends 1992).  But, last available data is 1938.  A little uneasy using pre-war data, in this case.
		 
		Four of the five observations have no reasonable nearby ccodeYr in Svolik's original dataset.  Looks like we'll just drop them.
		
		The fifth, Germany, should just use the 1992 value.  Merge that, and then done.
		
	*/

* fifth: special Germany.
preserve
	use `main', clear
	keep if(ccode==255 & year==1991)
	replace ccodeYr = 2551990
	replace mergeYear = 1991
	save `main', replace
restore

drop ccodeYr
id ccode startDate, gen(ccodeYr)
merge ccodeYr using `main', sort uniqusing nokeep keep(`list' mergeYear) update
tab _merge
drop _m


* loop once complete	 
foreach x of local list{
	forvalues let=1/6{
		clonevar `x'`let'=`x'
		replace `x'`let' = 0 if(trans!=`let')
		label variable `x'`let' `"Value of `x' for trans==`let'"'
	}
	drop `x'
}


// Housekeep
id ccode panelC, gen(ccodeSwID) 
		
notes: Last modified: TS
notes: Modified by: `c(username)' 
order exp orig panelC , last

drop growth_1 lgdp_1 demend
order t0, before(t)
order startDate start_year, last
drop year
compress

sort ccode t0 nextStage

// write the semi-markov
replace t = t-t0
replace t0 = 0

saveold "3 - svolik 2015 - continuous, no TVC [gap time].dta", replace version(11)
