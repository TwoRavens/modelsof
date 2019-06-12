/* This do file creates Figure 6 in main Text and Table 6 in Appendix for Duch Przepiorka Stevenson 2014 AJPS */
clear
set more off 
*use module2_dsfinal.dta, clear
cd "~/Dropbox/Wojtek/text/ajps_submission/data/Stata Data Files/"
use dps_online_experiment.dta, clear

egen newrespid=group(psid)


/* 
There were 1004 respondents, each got three questions and for each question were assigned to one of 120 
treatment groups corresponiding to weight allocations for the five positions (decisionmakers are identified only by the
policy positions that are assingned to each decisionmaker). In each question, the positions
of the decisionkakers were fixed (at the positions given below, which were the same for all questions) 
and the weight distribution was randomised, so that
the decisinmaker at position=4, for example, sometimes had a high weight or a low wieght. In addition, which DM was
the proposer was also randomized. The questions differed with respect to the distribution of available 
weights. That is, there were three sets of five weights (one for each question) and within a distribution
then the specific weight you got was randomly assigned.

The raw data have a line for a subject and give, for each question, a code (1-120) corresponding to the weight 
distribution used.  In addition the data give which DM(1-5) was chosen as the propsoer.  

The DM number (1-5) is in the number corresponding to the position in the spreadsheets. 

The positions and DM numbers in the spreadsheets are as follows:

*/

gen posdm1=4
gen posdm2=10
gen posdm3=16
gen posdm4=21
gen posdm5=28

label variable posdm1 "position of DM1 for all Questions"
label variable posdm2 "position of DM2 for all Questions"
label variable posdm3 "position of DM3 for all Questions"
label variable posdm4 "position of DM4 for all Questions"
label variable posdm5 "position of DM5 for all Questions"

/* We also only have treatment groups 1-120 identified in the data, 
but what we need are the actual weights that were assigned to each DM for
the question. This will be different for each subject, but will corrspond to the treatment numbers and corresponding weight distributions
that appear in the speadsheets */

/* bring in a file that takes this spreadsheet and turns it into
a stata file, so that we can merge information about each of the 120
treatments for each question (on Q1 for now) to the subjects that were
assigned that treatment */

sort treatdsvar1
merge treatdsvar1 using treatmenntdataQ1.dta
tab _merge
drop _merge

sort treatdsvar2
merge treatdsvar2 using treatmenntdataQ2.dta
tab _merge
drop _merge

sort treatdsvar3
merge treatdsvar3 using treatmenntdataQ3.dta
tab _merge
drop _merge

/* create median and mean variables */

capture drop weightedmeanq*
gen weightedmeanq1=(q1dm1wgt*4)+(q1dm2wgt*10)+(q1dm3wgt*16)+(q1dm4wgt*21)+(q1dm5wgt*28)
gen weightedmeanq2=(q2dm1wgt*4)+(q2dm2wgt*10)+(q2dm3wgt*16)+(q2dm4wgt*21)+(q2dm5wgt*28)
gen weightedmeanq3=(q3dm1wgt*4)+(q3dm2wgt*10)+(q3dm3wgt*16)+(q3dm4wgt*21)+(q3dm5wgt*28)


foreach jj of numlist 1 2 3 {
	gen w1q`jj'=q`jj'dm1wgt
	gen w2q`jj'=q`jj'dm1wgt+q`jj'dm1wgt
	gen w3q`jj'=q`jj'dm1wgt+q`jj'dm2wgt+q`jj'dm3wgt
	gen w4q`jj'=q`jj'dm1wgt+q`jj'dm2wgt+q`jj'dm3wgt+q`jj'dm4wgt
	gen w5q`jj'=q`jj'dm1wgt+q`jj'dm2wgt+q`jj'dm3wgt+q`jj'dm4wgt+q`jj'dm5wgt

	capture drop idmedianDMq`jj'
	gen idmedianDMq`jj'=0


	replace idmedianDMq`jj'=1 if (w1q`jj'>=.5)
	replace idmedianDMq`jj'=2 if (w1q`jj'<.5)&(w2q`jj'>=.5)
	replace idmedianDMq`jj'=3 if (w2q`jj'<.5)&(w3q`jj'>=.5)
	replace idmedianDMq`jj'=4 if (w3q`jj'<.5)&(w4q`jj'>=.5)
	replace idmedianDMq`jj'=5 if (w4q`jj'<.5)&(w5q`jj'>=.5)

	drop w1q`jj'-w5q`jj'
}



/* make some variables that give a 1 if the corresponding
  DM was the proposer */
  
foreach kk of numlist 1/5 {
	gen q1DMprop`kk'=0	 
	gen q2DMprop`kk'=0	
	gen q3DMprop`kk'=0	
}

foreach kk of numlist 1/5 {
	replace q1DMprop`kk'=1 if treatdsgrp1==`kk'	 
	replace q2DMprop`kk'=1 if treatdsgrp2==`kk'	 
	replace q3DMprop`kk'=1 if treatdsgrp3==`kk'	 
}

/* so now we reshape the data so that instead of a subject as a line
we have a subject-DM is a line */
*drop if qds1==.
 reshape long q1dm@wgt q2dm@wgt q3dm@wgt q1rightloc1p q2rightloc1p q3rightloc1p  posdm q1DMprop q2DMprop q3DMprop, i(newrespid) j(DMid) 


/* so now we have five lines per respondent and can look to see if the 
responden's chosen policy ( qds1) is predicted by who was the proposer and
the weights. */

/* first lets get a histogram of the positions that were chosen for each distribution */

/*
histogram qds1, name(gg1, replace) nodraw xtitle("Subject's Predicted Policy Outcome (an allocation to the animal shelter)", size(small)) freq ylabel(, labsize(vsmall)) xlabel(, labsize(vsmall)) ytitle ("Frequency", size(small)) title(Distribution =  
histogram qds2, name(gg2, replace) nodraw xtitle("Subject's Predicted Policy Outcome (an allocation to the animal shelter)", size(small)) freq ylabel(, labsize(vsmall)) xlabel(, labsize(vsmall)) ytitle ("Frequency", size(small))
histogram qds3, name(gg3, replace) nodraw xtitle("Subject's Predicted Policy Outcome (an allocation to the animal shelter)", size(small)) freq ylabel(, labsize(vsmall)) xlabel(, labsize(vsmall)) ytitle ("Frequency", size(small))

graph combine gg1 gg2 gg3, col(1)
graph export guesseshistogram.emf, replace
*/


gen q1_diffpos=abs(qds1-posdm) /* how far the policy is from the dm's position */
gen q2_diffpos=abs(qds2-posdm) /* how far the policy is from the dm's position */
gen q3_diffpos=abs(qds3-posdm) /* how far the policy is from the dm's position */

*gen weightprop=dmwgt*DMprop

label variable q1dmwgt "DM's weight in Q1"
label variable q1DMprop "DM is proposer in Q1"
label variable q2dmwgt "DM's weight in Q2"
label variable q2DMprop "DM is proposer in Q2"
label variable q3dmwgt "DM's weight in Q3"
label variable q3DMprop "DM is proposer in Q3"

/* the following chart makes it clear that there is a 
   DM specific fixed effect for the distance DV. The middle possition has
   the shortest distances on average and these distances increase (symmetrically) for
   DM's (positions) that get more extreme, so this needs to be aacounted for in the estimation
 */

bysort DMid:sum q1_diffpos q1dmwgt
bysort DMid:sum q2_diffpos q3dmwgt
bysort DMid:sum q2_diffpos q3dmwgt

gen DMidsq=DMid*DMid

/** do some regressions that look to see if weight, maj stats, biggest, and proposer 
matters to how far the respondents predicted position was from each DM **/

/* each question seperatelty starting with question 1 */

gen q1majdm=0
replace q1majdm=1 if q1dmwgt>.5
gen q1majprop=q1majdm*q1DMprop

/*
regress q1_diffpos  q1dmwgt q1DMprop q1majdm
regress q1_diffpos  i.q1DMid q1dmwgt q1DMprop q1majdm
regress q1_diffpos  DMid DMidsq q1dmwgt q1DMprop q1majdm
regress q1_diffpos  DMid DMidsq q1dmwgt q1DMprop q1majdm q1majprop

regress q1_diffpos  DMid DMidsq q1dmwgt q1DMprop q1majdm q1majprop if qds1~=15


xtmixed q1_diffpos  q1dmwgt q1DMprop q1majdm || _all: R.DMid || newrespid:

xtmixed q1_diffpos  q1dmwgt q1DMprop q1majdm || DMid: 

xtmixed q1_diffpos  q1dmwgt q1DMprop q1majdm q1majprop || DMid: 

xtmixed q1_diffpos  q1dmwgt q1DMprop q1majdm || newrespid: q1dmwgt q1DMprop q1majdm 


capture drop bbt*
estsimp regress q1_diffpos  DMid DMidsq q1dmwgt q1DMprop q1majdm q1majprop if qds1~=15, genname(bbt)
setx DMid 3 DMidsq 9 q1dmwgt .2 q1DMprop 0 q1majdm 0 q1majprop 0
simqi, fd(ev) changex(q1DMprop 0 1)
simqi, fd(ev) changex(q1majdm 0 1)
simqi, fd(ev) changex(q1dmwgt .1 .4)
*/


local dist1 ".02 .06 .10 .29 .53"
local dist2 ".11 .13 .17 .21 .38" 
local dist3 ".17 .19 .20 .21 .23"
local d1low=.02
local d1high=.53
local d2low=.11
local d2high=.38
local d3low=.17
local d3high=.23

tab DMid, gen(dummyDMid)


foreach dd of numlist 1 2 3 {

capture drop q`dd'dmwgtDum*
tab q`dd'dmwgt, gen(q`dd'dmwgtDum)

capture drop bbt*
estsimp regress q`dd'_diffpos  dummyDMid2-dummyDMid5 q`dd'dmwgtDum2-q`dd'dmwgtDum5 q`dd'DMprop, genname(bbt) cluster(newrespid)


	capture drop predvalue
	capture drop predLOW
	capture drop predHIGH
	capture drop predvaluep
	capture drop predLOWp
	capture drop predHIGHp
	capture drop xaxis
	set type double  
	generate predvalue=.
	generate predLOW=.
	generate predHIGH=.
	generate predvaluep=.
	generate predLOWp=.
	generate predHIGHp=.
	generate xaxis=.

	label variable xaxis "vote weight"

	local b=1 

	capture drop predA

	set more off

	
	setx q`dd'dmwgtDum2 0
	setx q`dd'dmwgtDum3 0
	setx q`dd'dmwgtDum4 0
	setx q`dd'dmwgtDum5 0
	
	setx dummyDMid2 0
	setx dummyDMid3 0
	setx dummyDMid4 0
	setx dummyDMid5 0
	

	local setdmcase=3
	
	local c=1
	foreach a of numlist `dist`dd'' {
	
		replace xaxis=`a' in `b' 	
		
		/* non-proposers */
		
		if `c'==1 {
			setx  dummyDMid`setdmcase' 1 q`dd'DMprop 0  
		}
			else {
			setx  dummyDMid`setdmcase' 1 q`dd'dmwgtDum`c' 1 q`dd'DMprop 0   
		}	
	
		simqi, genev(predA)
								
		summarize predA				
		replace predvalue = r(mean) in `b'
	
		
	    _pctile predA, p(2.5,97.5)		
		replace predLOW = r(r1) in `b'
		replace predHIGH = r(r2) in `b'
		drop predA	

		/* proposers */
		

		setx q`dd'dmwgtDum2 0
		setx q`dd'dmwgtDum3 0
		setx q`dd'dmwgtDum4 0
		setx q`dd'dmwgtDum5 0
		
		setx dummyDMid2 0
		setx dummyDMid3 0
		setx dummyDMid4 0
		setx dummyDMid5 0
		
		if `c'==1 {
			setx  dummyDMid`setdmcase' 1 q`dd'DMprop 1  
		}
		
		
		else {
			setx  dummyDMid`setdmcase' 1 q`dd'dmwgtDum`c' 1 q`dd'DMprop 1  
		}
		simqi, genev(predA)
								
		summarize predA				
		replace predvaluep = r(mean) in `b'
	
		
	    _pctile predA, p(2.5,97.5)		
		replace predLOWp = r(r1) in `b'
		replace predHIGHp = r(r2) in `b'
		drop predA	
		
		
		local b = `b' + 1	
		local c = `c' + 1
	}

	
	regress predvaluep xaxis if (xaxis~=.23&xaxis~=.38&xaxis~=.53)
	regress predvalue xaxis if (xaxis~=.23&xaxis~=.38&xaxis~=.53)
	
	# delimit ;
	twoway lfit predvaluep xaxis if (xaxis~=.23&xaxis~=.38&xaxis~=.53), range(`d`dd'low' `d`dd'high') color (black)
		|| lfit predvalue xaxis if (xaxis~=.23&xaxis~=.38&xaxis~=.53), range(`d`dd'low' `d`dd'high') color(black)
		|| rbar predLOWp predHIGHp xaxis,  mwidth msize(2.5) color(gs6)
		|| scatter predvaluep xaxis,  msymbol(O) mcolor(black)
		|| rbar predLOW predHIGH xaxis, mwidth msize(1) color(gs12)
		|| scatter predvalue xaxis, msymbol(O) mcolor(black)
			legend(off)
			xtitle("Voting Weight", size(vsmall))
			xlabel(`dist`dd'' , labsize(vsmall) ) 
			ylabel(, labsize(vsmall))
			ytitle("Distance Between DM's Position" "and the Subject's Predicted Outcome", size(vsmall))
			title("Distribution = {`dist`dd''}", size(small))
			graphregion(fcolor(none))
			name(q`dd'graph, replace)
			nodraw;	
			

	# delimit cr
	


	}
	
		# delimit ;
	
	 graph combine q1graph q2graph q3graph, 
		scheme(s1mono)
			note( "Lighter confidence bars are for non-proposers; Darker bars are for for proposers."
					" "
			  "Fitted lines are calulated using only cases other than the DM with the most voting weight.  None of the slopes are statistically significant.", size(tiny));
	# delimit cr

	graph export surveymaingraphDummies_May92012.png, replace
	
	
	*t1("Distance between Respondent's Predicted Policy Outcome and" "the Policy Position of a DM with given Characteristics", size(small))
