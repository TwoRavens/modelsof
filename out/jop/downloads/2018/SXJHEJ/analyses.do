*ANALYSES DO FILE

*this replicates the analyses in the manuscript, once the variables have been constructed
*the coding for the tables comes first, then the figures

*preliminaries
set more off, permanently
cd "/Users/spencerpiston/Dropbox/Chupperton/"


*Table 1. Discriminant Validity - Group Therms
use "/Users/spencerpiston/Dropbox/Chupperton/Chupperton 2016/Guilt Paper/JOP submitted/JOP rejected/JOP resubmission/JOP resubmitted/JOP rerejected/JOP reresubmitted/JOP Final Revisions_2.2018/replication files/2016 ANES pilot constructed data.dta", clear
svyset [pweight=weight]
set more off
svy, subpop(if white==1): reg thermbw guilt raceres newpartyid ideology female age education incbig incmiss married
svy, subpop(if white==1): reg thermhw guilt raceres newpartyid ideology female age education incbig incmiss married
svy, subpop(if white==1): reg thermmuslim guilt raceres newpartyid ideology female age education incbig incmiss married
svy, subpop(if white==1): reg thermtrans guilt raceres newpartyid ideology female age education incbig incmiss married
svy, subpop(if white==1): reg thermgay guilt raceres newpartyid ideology female age education incbig incmiss married

*Table 2. Guilt and Policy Opinion
use "/Users/spencerpiston/Dropbox/Chupperton/Chupperton 2016/Guilt Paper/JOP submitted/JOP rejected/JOP resubmission/JOP resubmitted/JOP rerejected/JOP reresubmitted/JOP Final Revisions_2.2018/replication files/2016 ANES pilot constructed data.dta", clear
svyset [pweight=weight]
svy, subpop(if white==1): reg affact guilt stlazybw raceres newpartyid ideology female age education incbig incmiss married
use "/Users/spencerpiston/Dropbox/Chupperton/Chupperton 2016/Guilt Paper/JOP submitted/JOP rejected/JOP resubmission/JOP resubmitted/JOP rerejected/JOP reresubmitted/JOP Final Revisions_2.2018/replication files/2013 YouGov constructed data.dta", clear
svyset [pweight=weight]
svy, subpop(if white==1): reg atb guilt stlazybw pidrep id female age0to1 educ0to1 classidentity married
svy, subpop(if white==1): reg obamacare guilt stlazybw pidrep id female age0to1 educ0to1 classidentity married
svy, subpop(if white==1): reg welfare guilt stlazybw pidrep id female age0to1 educ0to1 classidentity married

*Table 3. Guilt and Evaluations of Obama
*obamatherm ANES
use "/Users/spencerpiston/Dropbox/Chupperton/Chupperton 2016/Guilt Paper/JOP submitted/JOP rejected/JOP resubmission/JOP resubmitted/JOP rerejected/JOP reresubmitted/JOP Final Revisions_2.2018/replication files/2016 ANES pilot constructed data.dta", clear
svyset [pweight=weight]
svy, subpop(if white==1): reg obamatherm guilt stlazybw raceres newpartyid ideology female age education incbig incmiss married
*obamatherm YOUGOV
use "/Users/spencerpiston/Dropbox/Chupperton/Chupperton 2016/Guilt Paper/JOP submitted/JOP rejected/JOP resubmission/JOP resubmitted/JOP rerejected/JOP reresubmitted/JOP Final Revisions_2.2018/replication files/2013 YouGov constructed data.dta", clear
svyset [pweight=weight]
svy, subpop(if white==1): reg obamatherm guilt stlazybw pidrep id female age0to1 educ0to1 classidentity married
*obama approal ANES 
use "/Users/spencerpiston/Dropbox/Chupperton/Chupperton 2016/Guilt Paper/JOP submitted/JOP rejected/JOP resubmission/JOP resubmitted/JOP rerejected/JOP reresubmitted/JOP Final Revisions_2.2018/replication files/2016 ANES pilot constructed data.dta", clear
svyset [pweight=weight]
svy, subpop(if white==1): reg obamaapprov guilt stlazybw raceres newpartyid ideology female age education incbig incmiss married

*Figure 1. N/A - Question Wording

*Figure 2. Distribution
use "/Users/spencerpiston/Dropbox/Chupperton/Chupperton 2016/Guilt Paper/JOP submitted/JOP rejected/JOP resubmission/JOP resubmitted/JOP rerejected/JOP reresubmitted/JOP Final Revisions_2.2018/replication files/2016 ANES pilot constructed data.dta", clear
svyset [pweight=weight]
twoway hist guilt, ///
	graphregion( color(white) ) ///
	percent ///
	fcolor(gray) lcolor(black) /// 
	ylabel(, nogrid) ///
	yscale(titlegap(2) range(0 30)) ///
	xtitle("") ///
	title("") ///
	ytitle(Percent of Respondents) ///
	xscale(titlegap(4)) ///
	ylabel(0 "0" 10 "10" 20 "20" 30 "30" 40 "40" 50 "50" 60 "60" 70 "70") ///
	xlabel(0.02 `" "Lowest" "Guilt" "' .98 `" "Highest" "Guilt" "') 

*Figure 3. Job Training Experiment	
use "/Users/spencerpiston/Dropbox/Chupperton/Chupperton 2016/Guilt Paper/JOP submitted/JOP rejected/JOP resubmission/JOP resubmitted/JOP rerejected/JOP reresubmitted/JOP Final Revisions_2.2018/replication files/2016 YouGov constructed data.dta", clear
svyset [pweight=weight]
svy: reg jobtrain blackdisc##c.guilt blackdisc##c.raceres blackdisc##c.stlazyb pidrep0to1 ideo0to1 age0to1 male educ0to1 inc0to1 south
margins, dydx(blackdisc) at(guilt=(0(.1)1))
marginsplot, ///
	title("") ///
	ytitle("M.E. of Discrimination Frame") ///
    xtitle("Guilt Index") ///
    yscale(titlegap(2)) ///
    ylabel(-.4 "-.4" -.2 "-.2" 0 "0" .2 ".2" .4 ".4") ///
    xscale(titlegap(1)) ///
    xlabel(0 "Lowest" .98 "Highest") ///
    graphregion( color(white) ) ///
    plot1op(lcolor(black) lwidth(medium) mcolor(black) lpattern(solid)) ///
    ci1opts(color(gs12)) /// 
    recast(line) recastci(rarea) ///
    legend(cols(1)) ///
	yline(.2 .4 -.2 -.4, lcolor(gs15)) ///
	yline(0, lcolor(gray) lpattern(dash)) ///
    l(95)

*Figure 4. Candidate Experiment
use "/Users/spencerpiston/Dropbox/Chupperton/Chupperton 2016/Guilt Paper/JOP submitted/JOP rejected/JOP resubmission/JOP resubmitted/JOP rerejected/JOP reresubmitted/JOP Final Revisions_2.2018/replication files/2014 SSI constructed data.dta", clear
set more off
logit larsonvote i.black##c.guiltbind i.black##c.stindex0to1 i.black##c.raceres pidrep0to1 ideo0to1 male educ0to1 inc0to1 if rwhite==1
margins, dydx(black) at(guilt=(0(.1)1))
marginsplot, ///
	title("") ///
	ytitle("M.E. of Candidate Race(Black)") ///
    xtitle("Guilt Index") ///
    yscale(titlegap(2)) ///
    ylabel(-.4 "-.4" -.2 "-.2" 0 "0" .2 ".2" .4 ".4") ///
    xscale(titlegap(1)) ///
    xlabel(0 "Lowest" .98 "Highest") ///
    graphregion( color(white) ) ///
    plot1op(lcolor(black) lwidth(medium) mcolor(black) lpattern(solid)) ///
    ci1opts(color(gs12)) /// 
    recast(line) recastci(rarea) ///
	yline(.2 .4 -.2 -.4, lcolor(gs15)) ///
	yline(0, lcolor(gray) lpattern(dash)) ///
    legend(cols(1)) ///
    l(95)
