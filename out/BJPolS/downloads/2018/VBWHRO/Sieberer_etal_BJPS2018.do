

clear
macro drop _all
local c_date = c(current_date)
local date_string = subinstr("`c_date'", " ", "_", .)

cd "C:\Users\ba1hy3\Documents\Projekte\NA_EzA\RNote_2017\BJPS\final"
capture log close
log using Sieberer_etal_BJPS2018_`date_string'.log, replace text

********************************************************************************
********************************************************************************
* This Do-file contains code to reproduce the graphs and findings reported in
* Sieberer, Ulrich / Saalfeld, Thomas / Ohmura, Tamaki / Bergmann, Henning /
* Bailer, Stefanie, 2018, Roll call votes in the German Bundestag. 
* A new data set, 1949-2013, British Journal of Political Science

* The replication datasets are available in the BJPolS Dataverse
* doi: XXXXX

* IMPORTANT NOTE: 
* The replication datasets only contain the variables used in the letter.
* The full datasets described in the manuscript are available in the 
* Harvard Dataverse, doi: XXXX
********************************************************************************
********************************************************************************


// Name: 	Sieberer_etal_BJPS2018.do
// Task: 	data analysis for Letter in BJPS
// Version:	July 2018

version 15.1
set more off



********************************************************************************
********************************************************************************
* 1. VOTE CHARACTERISTICS
********************************************************************************
********************************************************************************

use vote_characteristics_BJPS, clear


* number of observations in dataset (mentioned in Figure 1)
*************************************************************
count

* number of votes (only one record per RCV) (mentioned in Figure 1)
*********************************************************************
// identify RCVs on multiple alternatives at once 
//    (recorded as multiple votes in the dataset) 

egen tag=tag(vote_id2)
count if tag


* Number RCV per legislative period (Figure 2)
***********************************************
graph hbar (count) vote_id2 if tag, over(elecper, relabel(1 "LP1 (1949-1953)" ///
	2 "LP2 (1953-1957)" 3 "LP3 (1957-1961)" 4 "LP4 (1961-1965)" ///
	5 "LP5 (1965-1969)" 6 "LP6 (1969-1972)" 7 "LP7 (1972-1976)" ///
	8 "LP8 (1976-1980)" 9 "*LP9 (1980-1983)" 10 "LP10 (1983-1987)" ///
	11 "LP11 (1987-1991)" 12 "LP12 (1991-1994)" 13 "LP13 (1994-1998)" ///
	14 "LP14 (1998-2002)" 15 "*LP15 (2002-2005)" 16 "LP16 (2005-2009)" ///
	17 "LP17 (2009-2013)")) ///
	blab(bar, size(medsmall)) ///
	ytitle("") ///
	note(" " "* Legislative period ended prematurely due to early elections." ///
	, span) scheme(s1mono)
graph export Figure2.emf, replace


* RCV request (Figure 3)
************************
tab request_oppo if tag
tab request_govoppo if tag
tab request_gov if tag
tab request_govpart if tag

// create threefold variable gov -  oppo -  both
gen request_threefold=.
	replace request_threefold=1 if request_gov==1|request_govpart==1
	replace request_threefold=2 if request_oppo==1
	replace request_threefold=3 if request_govoppo==1 |request_noparty==1
	replace request_threefold=99 if request_threefold==.
label define request_threefold 1 "Government" 2 "Opposition" 3 "Both" ///
	99 "Unknown"
label values request_threefold request_threefold

// number of RCVs with information on requestor
tab request_threefold if tag

// generate a variable with sum of votes per category and legislative period
egen group_requestor=group(elecper request_threefold)
bysort group_requestor: egen sum_requestor_lp=sum(tag)

// label legislative period to include time spans
label define elecper2 1 "1949-53" 2 "1953-57" 3 "1957-61" ///
	4 "1961-65" 5 "1965-69" 6 "1969-72" 7 "1972-76" ///
	8 "1976-80" 9 "1980-83" 10 "1983-87" ///
	11 "1987-91" 12 "1991-94" 13 "1994-98" ///
	14 "1998-02" 15 "2002-05" 16 "2005-09" ///
	17 "2009-13"
label values elecper elecper2

// graph
tabplot request_threefold elecper if tag, percent(elecper) miss ///
	showval(sum_requestor_lp, format(%9.0f) mlabsize(small)) ///
	ytitle("") xtitle("") ///
	xlab(, angle(90)) subtitle("") note( ///
	"Numbers: absolute number of roll calls in category" ///
	"Height of bars: percentage in this category (in this legislative period)" ///
	" " ///
	"Unit of observation: roll call (n= 1,958)" , span) scheme(s1mono)
graph export Figure3.emf, replace


* Policy areas of motions (Figure 4)
************************************
tab policy1 if tag, sort nol

// aggregate small categories to other
clonevar policy1_agg = policy1
	recode policy1_agg (2=99) (4=99) (5=99) (6=99) (7=99) (8=99) (10=99) ///
		(14=99) (15=99) (18=99) (21=99) (24=99) (25=99) 
	label define policy1_agg 1 "Economics" 3 "Health" 12 "Law & crime" ///
		13 "Welfare" 16 "Defense" 19 "Int. affairs" 20 "Gov. operation" ///
		27 "Const. amend." 99 "Other"
	label values policy1_agg policy1_agg

// generate a variable with sum of votes per category and legislative period
egen group_policy1_agg=group(elecper policy1_agg)
bysort group_policy1_agg: egen sum_policy1_agg_lp=sum(tag)

// use tabplot (Nick Cox)
tabplot policy1_agg elecper if tag, percent(elecper) miss ///
	showval(sum_policy1_agg_lp, format(%9.0f) mlabsize(vsmall) offset(.22)) ///
	ytitle("") xtitle("") ///
	ysize(4.5) ylab(, labsize(small)) xlab(, angle(90) labsize(small)) subtitle("") note( ///
	"Numbers: absolute number of roll calls in this category" ///
	"Height of bars: percentage in this category (in this legislative period)" " " ///
	"Unit of observation: roll call (n= 1,958)" , span) scheme(s1mono)
graph export Figure4.emf, replace
	
* Free votes (mentioned in text)
********************************
tab free_vote if tag

* sponsor of motion (mentioned in text)
***************************************
tab sponsor_spd if tag
tab sponsor_cducsu if tag
tab sponsor_fdp if tag
tab sponsor_greens if tag
tab sponsor_leftpds if tag

// create threefold variable sponsor
gen sponsor_threefold=.
	replace sponsor_threefold=1 if sponsor_govall==1|sponsor_govone==1
	replace sponsor_threefold=3 if sponsor_mps==1
	replace sponsor_threefold=2 if sponsor_threefold==.
label define sponsor_threefold 1 "Government" 2 "Opposition" ///
	3 "Cross-partisan group of MPs"
label values sponsor_threefold sponsor_threefold

tab sponsor_threefold if tag


* relationship sponsor - requestor (mentioned in text)
*******************************************************
// create threefold variable
gen sponsor_is_requestor=.
	replace sponsor_is_requestor=1 if ///
		(sponsor_kpd==1 & request_kpd==1) ///
		| (sponsor_leftpds==1 & request_leftpds==1) ///
		| (sponsor_greens==1 & request_greens==1) ///
		| (sponsor_spd==1 & request_spd==1) ///
		| (sponsor_fdp==1 & request_fdp==1) ///
		| (sponsor_cducsu==1 & request_cducsu==1) ///
		| (sponsor_gbbhe==1 & request_gbbhe==1) ///
		| (sponsor_dafvp==1 & request_dafvp==1) ///
		| (sponsor_dp==1 & request_dp==1) ///
		| (sponsor_fu==1 & request_fu==1) ///
		| (sponsor_spd==1 & request_spd==1)
	replace sponsor_is_requestor=0 if sponsor_is_requestor==.
	replace sponsor_is_requestor=99 if ///
		request_unknown==1
	label define sponsor_is_requestor 1 "yes" 0 "no" 99 "requestor unknown"	
	label values sponsor_is_requestor sponsor_is_requestor 

tab sponsor_is_requestor if tag & sponsor_is_requestor!=99



********************************************************************************
********************************************************************************
* 2. MP CHARACTERISTICS
********************************************************************************
********************************************************************************

use mp_characteristics_BJPS, clear

egen tag_mp = tag(mp_id)

* number of observations (mentioned in Figure 1)
************************************************
count

* number of mandates (mentioned in Figure 1)
********************************************
// create tag variable for one observation per MP and legislative period
egen tag_mp_elecper=tag(mp_id elecper)
count if tag_mp_elecper==1  // => 10299

* number of unique MPs (mentioned in text and Figure 1)
********************************************************
count if tag_mp==1


********************************************************************************
********************************************************************************
* 3. VOTING BEHAVIOR
********************************************************************************
********************************************************************************

use voting_behavior_BJPS, clear
merge m:1 vote_id using vote_characteristics_BJPS, keepusing(vote_id2 free_vote)

* number of observations / voting decisions (mentioned in text and Figure 1)
****************************************************************************
count // => number of observations in dataset

// ID for individual voting decisions
egen tag = tag(mp_id vote_id2)
count if tag


* deviating behavior (Figure 5)
*******************************
// generate variable on government status
gen govstatus=.
	replace govstatus=1 if ///
		(ppg==2&(elecper==1|elecper==2|elecper==3|elecper==4|elecper==5 ///
			|elecper==10|elecper==11|elecper==12|elecper==13|elecper==16|elecper==17)) ///
		| (ppg==1&(elecper==6|elecper==7|elecper==8 ///
			|elecper==14|elecper==15|elecper==16)) ///
		|(ppg==4&(elecper==1|elecper==4|elecper==6 ///
			|elecper==7|elecper==8|elecper==9|elecper==10|elecper==11|elecper==12 ///
			|elecper==13|elecper==17)) ///
		| (ppg==5 & (elecper==14|elecper==15))
	replace govstatus=2 if ///
		(ppg==2&(elecper==6|elecper==7|elecper==8|elecper==14|elecper==15)) ///
		| (ppg==1&(elecper==1|elecper==2|elecper==3|elecper==4|elecper==10 ///
			|elecper==11|elecper==12|elecper==13|elecper==17)) ///
		| (ppg==4&(elecper==3|elecper==14|elecper==15|elecper==16)) ///
		| (ppg==5 & (elecper==9|elecper==10|elecper==11|elecper==12 ///
			|elecper==13|elecper==16|elecper==17)) ///
		| (ppg==6)
	replace govstatus=3 if ///
		(ppg==2&elecper==9) ///
		| (ppg==1&(elecper==5|elecper==9)) ///
		| (ppg==4&(elecper==2|elecper==5)) ///
		| (ppg==11)
	label define govstatus 1 "Government" 2 "Opposition" 3 "Mixed"
	label values govstatus govstatus

// label legislative period to include time spans
label define elecper2 1 "1949-53" 2 "1953-57" 3 "1957-61" ///
	4 "1961-65" 5 "1965-69" 6 "1969-72" 7 "1972-76" ///
	8 "1976-80" 9 "1980-83" 10 "1983-87" ///
	11 "1987-91" 12 "1991-94" 13 "1994-98" ///
	14 "1998-02" 15 "2002-05" 16 "2005-09" ///
	17 "2009-13"
label values elecper elecper2

// graph
count if (vote_dev==1|vote_dev==2|vote_dev==3) & free_vote!=1

tabplot vote_dev elecper if (vote_dev==1|vote_dev==2|vote_dev==3) ///
	& free_vote!=1, by(ppg, graphregion(margin(small)) col(2) ///
	note(" " "Numbers: percentage in this category (in this legislative period)" ///
	"Color of bars: government status during this legislative period (government=black, opposition=white, both=grey)" /// ///
	" " "Unit of observation: behavior of individual MP on single RCV (n=925,721)." ///
	"Free votes, absences, and votes without identifiable party line excluded.", span)) ///
	xtitle("") percent(elecper ppg) ///
	showval(offset(.35) format(%9.0f) mlabsize(*0.9)) ///
	separate(govstatus) bar1(bcol(black)) bar2(bcol(gs14) bfcol(none)) bar3(bcol(gs12)) ///
	xsize(6) xlab(, angle(90) labsize(medsmall)) ///
	ylab(1 "weak" 2 "strong" 3 "none") ytitle("Deviation from the party line") ///
	graphregion(margin(zero)) scheme(s1mono) 
graph export Figure5.emf, replace
	

log close
exit
