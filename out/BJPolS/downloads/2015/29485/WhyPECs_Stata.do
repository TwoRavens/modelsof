 cd "/Users/marisakellam/..." 

*************************
* VARIABLE CALCULATIONS *
*************************

* RE-ELECTION

/*

tab electionID if immree==1


group(count |
         ry |
 pres_year) |      Freq.     Percent        Cum.
------------+-----------------------------------
   ARG 1995 |         64        4.52        4.52
   ARG 1999 |         60        4.24        8.76
   ARG 2003 |        232       16.40       25.16
   ARG 2007 |        329       23.25       48.41
   BRA 1998 |         64        4.52       52.93
   BRA 2002 |         68        4.81       57.74
   BRA 2006 |         72        5.09       62.83
   COL 2006 |        181       12.79       75.62
   ECU 2009 |        204       14.42       90.04
   VEN 2000 |         81        5.72       95.76
   VEN 2006 |         60        4.24      100.00
------------+-----------------------------------
      Total |      1,415      100.00



gen immree_modified if immree==1

* Menem in 1995
replace immree_modified=0 if country=="ARG" & polpartyA=="PJ" & pres_year==1995

* Cardoso in 1998
replace immree_modified=0 if country=="BRA" & polpartyA=="PSDB" & pres_year==1998

* Lula in 2006
replace immree_modified=0 if country=="BRA" & polpartyA=="PT" & pres_year==2006

* Uribe in 2006
replace immree_modified=0 if country=="COL" & polpartyA=="PC" & pres_year==2006

* Chavez in 2006 
replace immree_modified=0 if country=="VEN" & polpartyA=="MVR" & pres_year==2006

tab candidate_name electionID if immree!=immree_modified
*/

* RUNOFF

gen runoff=1 if prestype==2 | prestype==3
recode runoff .=0 if prestype==1 | prestype==4

* ETHNIC PARTIES

recode partyposA .=0 if ethnicA==1
recode partyposB .=0 if ethnicB==1

* DISTANCE

gen distance=(partyposB-partyposA)^2
replace distance=(partyposA)^2 if partyclassA!="none" & partyclassB=="none"
replace distance=(partyposB)^2 if partyclassA=="none" & partyclassB!="none"
replace distance=0 if partyclassA=="none" & partyclassB=="none"
replace distance=. if partyclassA=="unknown" | partyclassB=="unknown"

gen alt_distance=(alt_partyposB-alt_partyposA)^2
replace alt_distance=(alt_partyposA)^2 if alt_partyposA!=. & alt_partyposB==.
replace alt_distance=(alt_partyposB)^2 if alt_partyposA==. & alt_partyposB!=.
replace alt_distance=0 if alt_partyposA==. & alt_partyposB==.
replace alt_distance=. if partyclassA=="unknown" | partyclassB=="unknown"

gen bg_distance=abs(BGideologyA-BGideologyB)
replace bg_distance=abs(BGideologyA-10.5) if partyclassA!="none" & partyclassB=="none"
replace bg_distance=abs(BGideologyB-10.5) if partyclassA=="none" & partyclassB!="none"
replace bg_distance=0 if partyclassA=="none" & partyclassB=="none"
replace bg_distance=. if partyclassA=="unknown" | partyclassB=="unknown"



* SEAT RATIO

gen lag_seatratio = lag_seatsB / (lag_seatsA+lag_seatsB)
replace lag_seatratio = .5 if lag_seatsA==0 & lag_seatsB==0

*******
* NOTE:
* set=1 is an indicator that pulls out the rows of the data the correspond to the 
* dyads between the president-elect's party and all of the potential partner parties
*******

* ENPS

egen sumseats=sum(lag_seatsB/100) if set==1, by(electionID) /*use this to calculate the "others" category or parties that got less than 1% */
egen sumsqseats=sum((lag_seatsB/100)^2) if set==1, by(electionID) /*Sum of Pi^2, where Pi is the proportion of seats held by party i*/
gen enps=1/((sumsqseats)+(.01*(1-sumseats))) /*This calculates enps assuming that each 1% of the vote held by "others" belonged to a different party*/
replace sumseats=. if lag_seatsB==.
replace sumsqseats=. if lag_seatsB==.
replace enps=. if lag_seatsB==.

egen lag_enps=mode(enps), by(electionID)
drop enps sumseats sumsqseats
	
* IDEOLOGICAL POLARIZATION

gen seats_weight1 = (lag_seatsB)*partyposB if set==1
egen mlrp=sum(seats_weight1) if set==1, by(electionID) /*mean left-right position, see Coppedge 1998 */
recode mlrp 0=. if lag_seatsB==.
gen seats_weight2=(abs(partyposB-(mlrp/100)))*(lag_seatsB)
replace seats_weight2=0 if partyposB==0
egen ipseats=sum(seats_weight2) if set==1, by(electionID)
recode ipseats 0=. if lag_seatsB==.

egen lag_ipseats=mode(ipseats), by(electionID)
replace lag_ipseats=lag_ipseats/100
drop ipseats seats_weight* mlrp

gen alt_seats_weight1 = (lag_seatsB)*alt_partyposB if set==1
egen alt_mlrp=sum(alt_seats_weight1) if set==1, by(electionID) /*mean left-right position, see Coppedge 1998 */
recode alt_mlrp 0=. if lag_seatsB==.
gen alt_seats_weight2=(abs(alt_partyposB-(alt_mlrp/100)))*(lag_seatsB)
replace alt_seats_weight2=0 if alt_partyposB==0
egen alt_ipseats=sum(alt_seats_weight2) if set==1, by(electionID)
recode alt_ipseats 0=. if lag_seatsB==.

egen alt_lag_ipseats=mode(alt_ipseats), by(electionID)
replace alt_lag_ipseats=alt_lag_ipseats/100
drop alt_ipseats alt_seats_weight* alt_mlrp



****************
* DATA SUMMARY *
****************

egen PEC=max(pecAB), by(electionID polpartyA)
tabstat PEC if voteA>10 & prespartyB==1, by(country) stat(sum n)

egen pec_sum=sum(voteA) if PEC==1 & prespartyB==1, by(electionID)
replace pec_sum=0 if PEC==0 & prespartyB==1
egen PECvote=max(pec_sum), by(electionID)
drop pec_sum
hist PECvote if set==1 & prespartyB==1, percent start(0) xlabel(0(20)100) width(10) xtitle("Percent of Votes Cast for Coalition Candidates (TOTAL)") ytitle("Percent of Elections") scheme(s1mono)
graph export votehistogram.eps, replace

************
* ANALYSIS *
************

gen policyBXdist = policyB*distance
gen policyBXimmree = policyB*immree_modified
save PEC_analysis.dta, replace

local model "pecAB policyB distance policyBXdist immree_modified policyBXimmree ethnicB runoff concurrent lag_enps lag_ipseats lag_seatratio "

set more off
logit `model'   , cluster(electionID) nolog
relogit `model' , cluster(electionID) 
xtlogit `model' , fe i(countryID) nolog
xtlogit `model' , re i(electionID) nolog

tab pecAB if e(sample)

* PREDICTED CORRECTLY, ROC CURVE

set more off
local model "pecAB policyB distance policyBXdist immree_modified policyBXimmree ethnicB runoff concurrent lag_enps lag_ipseats lag_seatratio "
logit `model'   , cluster(electionID) nolog
lroc
xtlogit `model' , re i(electionID) nolog
predict prob, pu0 
roctab pecAB prob, graph summary
drop prob

* RESULTS TABLE

set more off
local model "pecAB policyB distance policyBXdist immree_modified policyBXimmree ethnicB runoff concurrent lag_enps lag_ipseats lag_seatratio "
logit `model'   , cluster(electionID) nolog
	outreg2 using results, replace label tex(fragment) ctitle(pooled)
relogit `model' , cluster(electionID)
	outreg2 using results, append label tex(fragment) ctitle(rare events)
xtlogit `model' , fe i(countryID) nolog
	outreg2 using results, append label tex(fragment) ctitle (country FE)
xtlogit `model' , re i(electionID) nolog
	outreg2 using results, append label tex(fragment) onecol long ctitle(pres RE)

* RARE EVENTS: Change runoff from 0 to 1

local model "pecAB policyB distance policyBXdist immree_modified policyBXimmree ethnicB runoff concurrent lag_enps lag_ipseats lag_seatratio "
relogit `model' , cluster(electionID)
setx median
relogitq, fd(pr) changex(runoff 0 1 ) listx
relogitq, rr(runoff 0 1 ) listx
disp 100*(.54-1)


* MARIGINAL EFFECTS

* Summarize Variables
set more off
local model "pecAB policyB distance policyBXdist immree_modified policyBXimmree ethnicB runoff concurrent lag_enps lag_ipseats lag_seatratio "
logit `model'   , cluster(electionID) nolog
sum policyB distance immree_modified ethnicB runoff concurrent lag_enps lag_ipseats lag_seatratio  if e(sample), detail
tab distance if e(sample)
tab distance if policyB==1 & e(sample)
tab distance if policyB==0 & e(sample)

* "Clarify"

use PEC_analysis.dta, clear
set more off
local model "pecAB policyB distance policyBXdist immree_modified policyBXimmree ethnicB runoff concurrent lag_enps lag_ipseats lag_seatratio "
xtlogit `model' , re i(electionID) nolog

preserve
drawnorm _b1-_b13, n(10000) means(e(b)) cov(e(V)) clear
postutil clear
postfile mypost ME SET SIM prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using marginaleffects.dta, replace

	/*SET CHOSEN VALUES AT MEDIANS  */
	scalar C1=1			/*policyB */
	scalar C2=.25		/*distance */
	scalar C3=(C1*C2)	/*interaction*/
	scalar C4=0			/*immree_modified*/
	scalar C5=(C1*C4)	/*interaction*/
	
	scalar C6=0			/*ethnicB*/
	scalar C7=1			/*runoff*/
	scalar C8=1			/*concurrent*/
	scalar C9=4.3		/*lag_enps*/
	scalar C10=.44		/*lag_ipseats*/
	scalar C11=.38		/*lag_seatratio*/
	scalar CONS=1	

		*generate x_betahat0 = _b1*C1 + _b2*C2 + _b3*(C1*C2) + _b4*C4 + _b5*(C1*C4) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
		*generate x_betahat1 = _b1*C1 + _b2*C2 + _b3*(C1*C2) + _b4*C4 + _b5*(C1*C4) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS

		
*MARGINAL EFFECT OF BEING A POLICY-SEEKING PARTY
scalar marginaleffect=1

	*IMMEDIATE REELECTION PROHIBITED:  CHANGE OFFICE-SEEKING PARTY TO POLICY SEEKING PARTY, AT EACH VALUE OF DISTANCE
	scalar setvalue=0
	scalar A=0
	scalar B=1
	scalar C4=0
    foreach d of numlist 0 .25 1 2.25 4 {
    	scalar simulation=`d'
		generate x_betahat0 = _b1*A + _b2*`d' + _b3*(A*`d') + _b4*C4 + _b5*(A*C4) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
		generate x_betahat1 = _b1*B + _b2*`d' + _b3*(B*`d') + _b4*C4 + _b5*(B*C4) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
		do xtlogit_predictprob.do
        }
        
  	*IMMEDIATE REELECTION POSSIBLE:  CHANGE OFFICE-SEEKING PARTY TO POLICY SEEKING PARTY, AT EACH VALUE OF DISTANCE
	scalar setvalue= 1
	scalar A=0
	scalar B=1
	scalar C4=1
    foreach d of numlist 0 .25 1 2.25 4 {
    	scalar simulation=(`d')
		generate x_betahat0 = _b1*A + _b2*`d' + _b3*(A*`d') + _b4*C4 + _b5*(A*C4) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
		generate x_betahat1 = _b1*B + _b2*`d' + _b3*(B*`d') + _b4*C4 + _b5*(B*C4) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
		do xtlogit_predictprob.do
        }      
        
*MARGINAL EFFECT OF IMMEDIATE REELECTION PROHIBITION
scalar marginaleffect=2   

	*POLICY-SEEKING PARTY: CHANGE RE-ELECTION FROM PROHIBITED TO POSSIBLE, AT EACH VALUE OF DISTANCE
	 scalar setvalue=1
	 scalar A=0
	 scalar B=1
	 scalar C1=1
	 foreach d of numlist 0 .25 1 2.25 4 {
    	scalar simulation=`d'
		generate x_betahat0 = _b1*C1 + _b2*`d' + _b3*(C1*`d') + _b4*A + _b5*(C1*A) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
		generate x_betahat1 = _b1*C1 + _b2*`d' + _b3*(C1*`d') + _b4*B + _b5*(C1*B) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
		do xtlogit_predictprob.do
        }
        
   	*OFFICE-SEEKING PARTY: CHANGE RE-ELECTION FROM PROHIBITED TO POSSIBLE, AT EACH VALUE OF DISTANCE
	 scalar setvalue=0
	 scalar A=0
	 scalar B=1
	 scalar C1=0
	 foreach d of numlist 0 .25 1 2.25 4 {
    	scalar simulation=`d'
		generate x_betahat0 = _b1*C1 + _b2*`d' + _b3*(C1*`d') + _b4*A + _b5*(C1*A) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
		generate x_betahat1 = _b1*C1 + _b2*`d' + _b3*(C1*`d') + _b4*B + _b5*(C1*B) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
		do xtlogit_predictprob.do
        }     
 
*MARGINAL EFFECT OF DISTANCE
scalar marginaleffect=3

	*CHANGE DISTANCE FROM 0 TO .25
	scalar simulation=0
	scalar A=0
	scalar B=.25
	foreach p of numlist 1 0 {
		foreach re of numlist 1 0 {
			scalar setvalue = `p'+(`re'/10)
			generate x_betahat0 = _b1*`p' + _b2*A + _b3*(`p'*A) + _b4*`re' + _b5*(`p'*`re') + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
			generate x_betahat1 = _b1*`p' + _b2*B + _b3*(`p'*B) + _b4*`re' + _b5*(`p'*`re') + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
			do xtlogit_predictprob.do
			}
		}
 	
 	*CHANGE DISTANCE FROM .25 TO 1
	scalar simulation=.25
	scalar A=.25
	scalar B=1
	foreach p of numlist 1 0 {
		foreach re of numlist 1 0 {
			scalar setvalue = `p'+(`re'/10)
			generate x_betahat0 = _b1*`p' + _b2*A + _b3*(`p'*A) + _b4*`re' + _b5*(`p'*`re') + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
			generate x_betahat1 = _b1*`p' + _b2*B + _b3*(`p'*B) + _b4*`re' + _b5*(`p'*`re') + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
			do xtlogit_predictprob.do
			}
		}
 	
 	*CHANGE DISTANCE FROM 1 TO 2.25
	scalar simulation=1
	scalar A=1
	scalar B=2.25
	foreach p of numlist 1 0 {
		foreach re of numlist 1 0 {
			scalar setvalue = `p'+(`re'/10)
			generate x_betahat0 = _b1*`p' + _b2*A + _b3*(`p'*A) + _b4*`re' + _b5*(`p'*`re') + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
			generate x_betahat1 = _b1*`p' + _b2*B + _b3*(`p'*B) + _b4*`re' + _b5*(`p'*`re') + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
			do xtlogit_predictprob.do
			}
		}
 	
 	*CHANGE DISTANCE FROM 2.25 TO 4
	scalar simulation=2.25
	scalar A=2.25
	scalar B=4
	foreach p of numlist 1 0 {
		foreach re of numlist 1 0 {
			scalar setvalue = `p'+(`re'/10)
			generate x_betahat0 = _b1*`p' + _b2*A + _b3*(`p'*A) + _b4*`re' + _b5*(`p'*`re') + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
			generate x_betahat1 = _b1*`p' + _b2*B + _b3*(`p'*B) + _b4*`re' + _b5*(`p'*`re') + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
			do xtlogit_predictprob.do
			}
		}
postclose mypost
***************************************************************************************************
use marginaleffects.dta, clear
gen pctchg=100*diff_hat/prob_hat0
format SET %9.1f
gen statsig=0 if diff_lo<=0 & diff_hi>=0
recode statsig .=0 if diff_lo>=0 & diff_hi<=0
recode statsig .=1
edit

gen marginal_effect=""
gen immediate_reelection=""
gen party_orientation=""
gen distance=.

replace marginal_effect="Office to Policy" if ME==1
replace marginal_effect="Prohibited to Possible" if ME==2
replace marginal_effect="Increase to next value" if ME==3
replace immediate_reelection="Prohibited" if ME==1 & SET==0
replace immediate_reelection="Possible" if ME==1 & SET==1
replace immediate_reelection="Possible" if ME==3 & SET>1
replace immediate_reelection="Possible" if ME==3 & SET>0 & SET<1
replace immediate_reelection="Prohibited" if ME==3 & SET==1.0
replace immediate_reelection="Prohibited" if ME==3 & SET==0.0
replace party_orientation="Policy" if ME==2 & SET==1
replace party_orientation="Office" if ME==2 & SET==0
replace party_orientation="Policy" if ME==3 & SET>=1
replace party_orientation="Office" if ME==3 & SET<1
replace distance=sqrt(SIM)

replace statsig=. if distance>1 & party_orientation=="Office"
replace statsig=. if distance>1 & marginal_effect=="Office to Policy"
gsort ME -party_orientation -immediate_reelection distance

save marginaleffects.dta, replace


* Marginal effect of being a policy oriented party when reelection is prohibited:
* Note that distance is maxed out at 1 for office seeking parties.
list distance diff_hat diff_lo diff_hi pctchg statsig if marginal_effect=="Office to Policy" & immediate_reelection=="Prohibited" & SIM==0
list distance diff_hat diff_lo diff_hi pctchg statsig if marginal_effect=="Office to Policy" & immediate_reelection=="Prohibited" & SIM==0.25
list distance diff_hat diff_lo diff_hi pctchg statsig if marginal_effect=="Office to Policy" & immediate_reelection=="Prohibited" & SIM==1   

* Marginal effect of increasing distance to the next level when reelection is prohibited, for policy-oriented parties:
list distance diff_hat diff_lo diff_hi pctchg statsig if marginal_effect=="Increase to next value" & immediate_reelection=="Prohibited" & SIM==0 & party_orientation=="Policy"
list distance diff_hat diff_lo diff_hi pctchg statsig if marginal_effect=="Increase to next value" & immediate_reelection=="Prohibited" & SIM==0.25 & party_orientation=="Policy"
list distance diff_hat diff_lo diff_hi pctchg statsig if marginal_effect=="Increase to next value" & immediate_reelection=="Prohibited" & SIM==1 & party_orientation=="Policy"   
list distance diff_hat diff_lo diff_hi pctchg statsig if marginal_effect=="Increase to next value" & immediate_reelection=="Prohibited" & SIM==2.25 & party_orientation=="Policy"
  
* Marginal effect of Prohibiting Reelection, for policy-oriented parties:
list distance diff_hat diff_lo diff_hi pctchg statsig if marginal_effect=="Prohibited to Possible" & party_orientation=="Policy" & SIM==0
list distance diff_hat diff_lo diff_hi pctchg statsig if marginal_effect=="Prohibited to Possible" & party_orientation=="Policy" & SIM==0.25
list distance diff_hat diff_lo diff_hi pctchg statsig if marginal_effect=="Prohibited to Possible" & party_orientation=="Policy" & SIM==1   
list distance diff_hat diff_lo diff_hi pctchg statsig if marginal_effect=="Prohibited to Possible" & party_orientation=="Policy" & SIM==2.25   
list distance diff_hat diff_lo diff_hi pctchg statsig if marginal_effect=="Prohibited to Possible" & party_orientation=="Policy" & SIM==4  

*Combined Graph
format distance %9.1f
gen distance_plus=distance+.5
format distance_plus %9.1f

#delimit ;
twoway rspike diff_lo diff_hi distance if marginal_effect=="Office to Policy"  & immediate_reelection=="Prohibited" & distance<=1, 
	horizontal lpattern(solid) lwidth(medthick) lcolor(black)
	ylabel(0(.5)2, angle(0)) ymtick(-.25(.25)2.25, noticks) xlabel(-.05(.01).05, nolabels noticks) xline(0, lcolor(gray)) ytitle("") xtitle("") 
	text(1.25 .04 "{bf:Policy-Seeking Party}")
	plotregion(style(none)) xscale(off);
graph copy policy, replace;

#delimit ;
twoway rspike diff_lo diff_hi distance_plus if marginal_effect=="Increase to next value"  & immediate_reelection=="Prohibited" & party_orientation=="Policy" , 
	horizontal lpattern(dash) lwidth(medthick) lcolor(black)
	ylabel(0(.5)2, angle(0)) ymtick(-.25(.25)2.25, noticks) xlabel(-.05(.01).05, nolabels noticks) xline(0, lcolor(gray)) ytitle("") xtitle("") 
	text(1.25 -.035 "{bf:Increase Distance}") 
	plotregion(style(none)) xscale(off);     
graph copy distance, replace ;

#delimit ;
twoway rspike diff_lo diff_hi distance if marginal_effect=="Prohibited to Possible"  & party_orientation=="Policy" , 
	horizontal lpattern(shortdash_dot) lwidth(medthick) lcolor(black)
	ylabel(0(.5)2, angle(0)) ymtick(-.25(.25)2.25, noticks) xlabel(-.05(.01).05) xline(0, lcolor(gray)) ytitle("") xtitle("") 
	text(1.5 .02 "Immediate Reelection Possible")
	plotregion(style(none));
graph copy reelection, replace ;


#delimit ;	
graph combine policy distance reelection, 
	cols(1) imargin(0 0 0 2) ycommon xcommon
	l1title(Absolute value of ideological distance, size(small)) 
	b2title(95% confidence interval for difference in predicted probability of PEC, size(small)) 
	commonscheme scheme(s1mono) ;

graph export marginaleffects.pdf, replace




***************************************************************************************************

* APPENDIX

use PEC_analysis.dta, clear

/* BASELINE */

	set more off
	local model "pecAB policyB distance policyBXdist immree_modified policyBXimmree ethnicB runoff concurrent lag_enps lag_ipseats lag_seatratio "
	logit `model'   , cluster(electionID) nolog
	relogit `model' , cluster(electionID)
	xtlogit `model' , fe i(countryID) nolog
	xtlogit `model' , re i(electionID) nolog


/* ALTERNATIVE CODING OF POLICY VS OFFICE-ORIENTED PARTIES */

gen alt_policyBXdist = alt_policyB*alt_distance
gen alt_policyBXimmree = alt_policyB*immree_modified
save PEC_analysis.dta, replace

	set more off
	local model "pecAB alt_policyB alt_distance alt_policyBXdist immree_modified alt_policyBXimmree ethnicB runoff concurrent lag_enps lag_ipseats lag_seatratio "
	logit `model'   , cluster(electionID) nolog
	relogit `model' , cluster(electionID)
	xtlogit `model' , fe i(countryID) nolog
	xtlogit `model' , re i(electionID) nolog
		outreg2 using appendixresults, replace label long tex(fragment) ctitle(Alt Coding)	

/* ALTERNATIVE MEASURE OF IDEOLOGICAL DISTANCE */

gen bg_policyBXdist = policyB*bg_distance
save PEC_analysis.dta, replace

	set more off
	local model "pecAB policyB bg_distance bg_policyBXdist immree_modified policyBXimmree ethnicB runoff concurrent lag_enps lag_ipseats lag_seatratio "
	logit `model'   , cluster(electionID) nolog
	relogit `model' , cluster(electionID)
	xtlogit `model' , fe i(countryID) nolog
	xtlogit `model' , re i(electionID) nolog
		outreg2 using appendixresults, append label tex(fragment) onecol long ctitle(Alt Distance)
	
/* VP DATA */

	tab vpB, missing
	/*replace vpB=. if country=="COS" & pres_year==1982 & polpartyA=="PRC" & polpartyB=="PRD"*/
	/*replace vpB=. if country=="COS" & pres_year==1982 & polpartyA=="PRC" & polpartyB=="PDC"*/

	local model "pecAB policyB distance policyBXdist immree_modified policyBXimmree ethnicB runoff concurrent lag_enps lag_ipseats lag_seatratio "
	set more off
	logit `model'   , cluster(electionID) nolog
	tab vpB if e(sample), missing


	* RESULTS WITHOUT THE 24 CASES OF vpB=1 
	
	local model "pecAB policyB distance policyBXdist immree_modified policyBXimmree ethnicB runoff concurrent lag_enps lag_ipseats lag_seatratio if vpB!=1"
	set more off
	logit `model'   , cluster(electionID) nolog
	relogit `model' , cluster(electionID)
	xtlogit `model' , fe i(countryID) nolog
	xtlogit `model' , re i(electionID) nolog
		outreg2 using appendixresults, append label long tex(fragment) ctitle(No VP cases)


/* RESTRICT ONLY TO PARTY-Bs THAT HELD SEATS IN LEGISLATURE AT THE TIME OF ELECTION i.e. LAG SEATS>0 */

	local model "pecAB policyB distance policyBXdist immree_modified policyBXimmree ethnicB runoff concurrent lag_enps lag_ipseats lag_seatratio if lag_seatsB>0"
	set more off
	logit `model'   , cluster(electionID) nolog
	tab pecAB if e(sample)
	relogit `model' , cluster(electionID)
	xtlogit `model' , fe i(countryID) nolog
	xtlogit `model' , re i(electionID) nolog
		outreg2 using appendixresults, append label long tex(fragment) ctitle(Current Legislature)

		
		
		
***************************************************************************************************
* Marginal Effects for Appendix Models

use PEC_analysis.dta, clear

***********	
* Baseline

set more off
local model "pecAB policyB distance policyBXdist immree_modified policyBXimmree ethnicB runoff concurrent lag_enps lag_ipseats lag_seatratio "
xtlogit `model' , re i(electionID) nolog
preserve
drawnorm _b1-_b13, n(10000) means(e(b)) cov(e(V)) clear
postutil clear
postfile mypost ME SET SIM  prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using marginaleffects_appendx1.dta, replace


	/*SET CHOSEN VALUES AT MEDIANS  */
	scalar C1=1			/*policyB */
	scalar C2=.25		/*distance */
	scalar C3=(C1*C2)	/*interaction*/
	scalar C4=0			/*immree_modified*/
	scalar C5=(C1*C4)	/*interaction*/
	
	scalar C6=0			/*ethnicB*/
	scalar C7=1			/*runoff*/
	scalar C8=1			/*concurrent*/
	scalar C9=4.3		/*lag_enps*/
	scalar C10=.44		/*lag_ipseats*/
	scalar C11=.38		/*lag_seatratio*/
	scalar CONS=1	

scalar setvalue=1 /*Baseline*/

	*CHANGE OFFICE-SEEKING PARTY TO POLICY SEEKING PARTY
	scalar marginaleffect=1
	scalar simulation=0
	scalar A=0
	scalar B=1
 	generate x_betahat0 = _b1*A + _b2*C2 + _b3*(A*C2) + _b4*C4 + _b5*(A*C4) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
	generate x_betahat1 = _b1*B + _b2*C2 + _b3*(B*C2) + _b4*C4 + _b5*(B*C4) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
	do xtlogit_predictprob.do
        
	*CHANGE DISTANCE FROM .5 TO 1, so squared distance from .25 (50th percentile) to 1 (75th percentile)
	scalar marginaleffect=2
	scalar simulation=0
	scalar A=.25
	scalar B=1
 	generate x_betahat0 = _b1*C1 + _b2*A + _b3*(C1*A) + _b4*C4 + _b5*(C1*C4) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
	generate x_betahat1 = _b1*C1 + _b2*B + _b3*(C1*B) + _b4*C4 + _b5*(C1*C4) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
	do xtlogit_predictprob.do
	postclose mypost

***********	
* Alternative Coding

set more off
local model "pecAB alt_policyB alt_distance alt_policyBXdist immree_modified alt_policyBXimmree ethnicB runoff concurrent lag_enps lag_ipseats lag_seatratio "
xtlogit `model' , re i(electionID) nolog
preserve
drawnorm _b1-_b13, n(10000) means(e(b)) cov(e(V)) clear
postutil clear
postfile mypost ME SET SIM  prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using marginaleffects_appendx2.dta, replace

	/*SET CHOSEN VALUES AT MEDIANS  */
	scalar C1=1			/*policyB */
	scalar C2=.25		/*distance */
	scalar C3=(C1*C2)	/*interaction*/
	scalar C4=0			/*immree_modified*/
	scalar C5=(C1*C4)	/*interaction*/
	
	scalar C6=0			/*ethnicB*/
	scalar C7=1			/*runoff*/
	scalar C8=1			/*concurrent*/
	scalar C9=4.3		/*lag_enps*/
	scalar C10=.44		/*lag_ipseats*/
	scalar C11=.38		/*lag_seatratio*/
	scalar CONS=1		

scalar setvalue=2 /*Alt Coding*/

	*CHANGE OFFICE-SEEKING PARTY TO POLICY SEEKING PARTY
	scalar marginaleffect=1
	scalar simulation=0
	scalar A=0
	scalar B=1
 	generate x_betahat0 = _b1*A + _b2*C2 + _b3*(A*C2) + _b4*C4 + _b5*(A*C4) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
	generate x_betahat1 = _b1*B + _b2*C2 + _b3*(B*C2) + _b4*C4 + _b5*(B*C4) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
	do xtlogit_predictprob.do
	
	*CHANGE DISTANCE FROM .5 TO 1, so squared distance from .25 (50th percentile) to 1 (75th percentile)
	scalar marginaleffect=2
	scalar simulation=0
	scalar A=.25
	scalar B=1
 	generate x_betahat0 = _b1*C1 + _b2*A + _b3*(C1*A) + _b4*C4 + _b5*(C1*C4) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
	generate x_betahat1 = _b1*C1 + _b2*B + _b3*(C1*B) + _b4*C4 + _b5*(C1*C4) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
	do xtlogit_predictprob.do
	postclose mypost
	
***********	
* Alternative Distance 

set more off
local model "pecAB policyB bg_distance bg_policyBXdist immree_modified policyBXimmree ethnicB runoff concurrent lag_enps lag_ipseats lag_seatratio "
xtlogit `model' , re i(electionID) nolog
sum bg_distance1 if e(sample), detail
preserve
drawnorm _b1-_b13, n(10000) means(e(b)) cov(e(V)) clear
postutil clear
postfile mypost ME SET SIM  prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using marginaleffects_appendx3.dta, replace

	/*SET CHOSEN VALUES AT MEDIANS  */
	scalar C1=1			/*policyB */
	scalar C2=4.5		/*distance */
	scalar C3=(C1*C2)	/*interaction*/
	scalar C4=0			/*immree_modified*/
	scalar C5=(C1*C4)	/*interaction*/
	
	scalar C6=0			/*ethnicB*/
	scalar C7=1			/*runoff*/
	scalar C8=1			/*concurrent*/
	scalar C9=4.3		/*lag_enps*/
	scalar C10=.44		/*lag_ipseats*/
	scalar C11=.38		/*lag_seatratio*/
	scalar CONS=1		

scalar setvalue=3 /*Alt Distance*/

	*CHANGE OFFICE-SEEKING PARTY TO POLICY SEEKING PARTY
	scalar marginaleffect=1
	scalar simulation=0
	scalar A=0
	scalar B=1
 	generate x_betahat0 = _b1*A + _b2*C2 + _b3*(A*C2) + _b4*C4 + _b5*(A*C4) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
	generate x_betahat1 = _b1*B + _b2*C2 + _b3*(B*C2) + _b4*C4 + _b5*(B*C4) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
	do xtlogit_predictprob.do
	
	*CHANGE DISTANCE FROM 4.5 TO 7.1 (50th percentile to 75th percentile)
	scalar marginaleffect=2
	scalar simulation=0
	scalar A=4.5
	scalar B=7.1
 	generate x_betahat0 = _b1*C1 + _b2*A + _b3*(C1*A) + _b4*C4 + _b5*(C1*C4) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
	generate x_betahat1 = _b1*C1 + _b2*B + _b3*(C1*B) + _b4*C4 + _b5*(C1*C4) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
	do xtlogit_predictprob.do
	postclose mypost	
		
	
***********	
* No VP

set more off
local model "pecAB policyB distance policyBXdist immree_modified policyBXimmree ethnicB runoff concurrent lag_enps lag_ipseats lag_seatratio if vpB!=1"
xtlogit `model' , re i(electionID) nolog
preserve
drawnorm _b1-_b13, n(10000) means(e(b)) cov(e(V)) clear
postutil clear
postfile mypost ME SET SIM  prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using marginaleffects_appendx4.dta, replace

	/*SET CHOSEN VALUES AT MEDIANS  */
	scalar C1=1			/*policyB */
	scalar C2=.25		/*distance */
	scalar C3=(C1*C2)	/*interaction*/
	scalar C4=0			/*immree_modified*/
	scalar C5=(C1*C4)	/*interaction*/
	
	scalar C6=0			/*ethnicB*/
	scalar C7=1			/*runoff*/
	scalar C8=1			/*concurrent*/
	scalar C9=4.3		/*lag_enps*/
	scalar C10=.44		/*lag_ipseats*/
	scalar C11=.38		/*lag_seatratio*/
	scalar CONS=1	

scalar setvalue=4 /*No VP cases*/

	*CHANGE OFFICE-SEEKING PARTY TO POLICY SEEKING PARTY
	scalar marginaleffect=1
	scalar simulation=0
	scalar A=0
	scalar B=1
 	generate x_betahat0 = _b1*A + _b2*C2 + _b3*(A*C2) + _b4*C4 + _b5*(A*C4) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
	generate x_betahat1 = _b1*B + _b2*C2 + _b3*(B*C2) + _b4*C4 + _b5*(B*C4) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
	do xtlogit_predictprob.do
        
	*CHANGE DISTANCE FROM .5 TO 1, so squared distance from .25 (50th percentile) to 1 (75th percentile)
	scalar marginaleffect=2
	scalar simulation=0
	scalar A=.25
	scalar B=1
 	generate x_betahat0 = _b1*C1 + _b2*A + _b3*(C1*A) + _b4*C4 + _b5*(C1*C4) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
	generate x_betahat1 = _b1*C1 + _b2*B + _b3*(C1*B) + _b4*C4 + _b5*(C1*C4) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
	do xtlogit_predictprob.do
	postclose mypost
	
***********	
* Current Legislature	

set more off
local model "pecAB policyB distance policyBXdist immree_modified policyBXimmree ethnicB runoff concurrent lag_enps lag_ipseats lag_seatratio if lag_seatsB>0"
xtlogit `model' , re i(electionID) nolog
preserve
drawnorm _b1-_b13, n(10000) means(e(b)) cov(e(V)) clear
postutil clear
postfile mypost ME SET SIM  prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using marginaleffects_appendx5.dta, replace

	/*SET CHOSEN VALUES AT MEDIANS  */
	scalar C1=1			/*policyB */
	scalar C2=.25		/*distance */
	scalar C3=(C1*C2)	/*interaction*/
	scalar C4=0			/*immree_modified*/
	scalar C5=(C1*C4)	/*interaction*/
	
	scalar C6=0			/*ethnicB*/
	scalar C7=1			/*runoff*/
	scalar C8=1			/*concurrent*/
	scalar C9=4.3		/*lag_enps*/
	scalar C10=.44		/*lag_ipseats*/
	scalar C11=.38		/*lag_seatratio*/
	scalar CONS=1	

scalar setvalue=5 /*Current Legislature*/

	*CHANGE OFFICE-SEEKING PARTY TO POLICY SEEKING PARTY
	scalar marginaleffect=1
	scalar simulation=0
	scalar A=0
	scalar B=1
 	generate x_betahat0 = _b1*A + _b2*C2 + _b3*(A*C2) + _b4*C4 + _b5*(A*C4) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
	generate x_betahat1 = _b1*B + _b2*C2 + _b3*(B*C2) + _b4*C4 + _b5*(B*C4) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
	do xtlogit_predictprob.do
        
	*CHANGE DISTANCE FROM .5 TO 1, so squared distance from .25 (50th percentile) to 1 (75th percentile)
	scalar marginaleffect=2
	scalar simulation=0
	scalar A=.25
	scalar B=1
 	generate x_betahat0 = _b1*C1 + _b2*A + _b3*(C1*A) + _b4*C4 + _b5*(C1*C4) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
	generate x_betahat1 = _b1*C1 + _b2*B + _b3*(C1*B) + _b4*C4 + _b5*(C1*C4) + _b6*C6 + _b7*C7  + _b8*C8  + _b9*C9  + _b10*C10 + _b11*C11 + _b12*CONS
	do xtlogit_predictprob.do
	postclose mypost
	
	
******
* NOTE: I took the individual marginaleffects_appendix1-5.dta files and appended them into a single file called marginaleffects_appendix.dta
******
use marginaleffects_appendix.dta, clear


list SET diff_hat if ME==1
list SET diff_hat if ME==2

#delimit ;
twoway rspike diff_lo diff_hi SET if ME==1, 
	horizontal lpattern(solid) lwidth(medthick) lcolor(black)
	yscale(reverse off) ylabel(.5(1)5.5, nolabels noticks)
	xlabel(-.06(.01).06, nolabels noticks) xline(0, lcolor(red)) ytitle("") xtitle("") 
	text(1.0 .05 "{bf: Policy-Seeking}")
	text(1.2 .02 "Original")
	text(2.2 .023 "Alternate Coding")
	text(3.2 .01 "Alternate Distance")
	text(4.2 .015 "No VP cases")
	text(5.2 .025 "Current Leg. Parties Only")
	plotregion(style(none)) xscale(off);
	
graph copy appendix_policy, replace

#delimit ;
twoway rspike diff_lo diff_hi SET if ME==2, 
	horizontal lpattern(solid) lwidth(medthick) lcolor(black)
	yscale(reverse off) ylabel(.5(1)5.5, nolabels noticks)
	xlabel(-.06(.01).06) xline(0, lcolor(red)) ytitle("") xtitle("") 
	text(1.0 -.05 "{bf: Distance}")
	text(1.2 -.016 "Original")
	text(2.2 -.015 "Alternate Coding")
	text(3.2 -.010 "Alternate Distance")
	text(4.2 -.015 "No VP cases")
	text(5.2 -.026 "Current Leg. Parties Only")
	plotregion(style(none)) ;
	
graph copy appendix_distance, replace

#delimit ;	
graph combine appendix_policy appendix_distance, 
	cols(1) imargin(0 0 0 4) ycommon xcommon
	b2title(95% confidence interval for difference in predicted probability of PEC, size(small)) 
	commonscheme scheme(s1mono) ;

graph export appendix_marginaleffects.eps, replace

***************************************************************************************************

* NATIONALIZATION PLOT */

use PEC_analysis.dta, clear

egen legID=group(country leg_year), label
merge m:1 country leg_year using PSNS.dta
list country leg_year if _merge==2 /* nonconcurrent/midterms */
drop if _merge==2
drop _merge
label var psns "Party System Nationalization Score"

*******
* NOTE:
* set=1 is an indicator that pulls out the rows of the data the correspond to the 
* dyads between the president-elect's party and all of the potential partner parties
*******

egen office_seats = sum(seatsB) if policyB==0 & set==1, by(legID)
egen office_total = mode(office_seats), by(legID)
recode office_total .=0
drop office_seats
scatter psns office_total if set==1 & prespartyB==1, mlabel(legID) mlabsize(vsmall)



#delimit ;
twoway (scatter psns office_total if set==1 & prespartyB==1, msymbol(O) mcolor(black))
	(scatter psns office_total if set==1 & prespartyB==1 & office_total>25 & psns>.7, mlabel(legID) mlabsize(small) msymbol(O) mcolor(black)),
	ylabel(.5(.1)1, angle(0) labsize(vsmall)) 
	xlabel(0(10)50, labsize(vsmall)) scheme(s1mono) legend(off)
	ytitle("Party System Nationalization Score" "(Jones & Mainwaring 2003)", size(small))
	xtitle("Combined Seat Share Won by Exclusively Office-Seeking Parties", size(small));
#delimit cr
graph export nationalization.eps, replace


save PEC_analysis.dta, replace

***************************************************************************************************

use WiesehomeierBenoit2007_Summary.dta, clear

gen include=0
recode include 0=1 if Country=="ARG"
recode include 0=1 if Country=="BOL"
recode include 0=1 if Country=="BRA"
recode include 0=1 if Country=="CHL"
recode include 0=1 if Country=="CRI"
recode include 0=1 if Country=="COL"
recode include 0=1 if Country=="ECU"
recode include 0=1 if Country=="PER"
recode include 0=1 if Country=="URY"
recode include 0=1 if Country=="MEX"
recode include 0=1 if Country=="VEN"

egen CtryCode=group(Country) if include==1 , label

gen office=0
recode office 0=1 if Country=="ARG" & Party=="FrePoBo"
recode office 0=1 if Country=="BRA" & Party=="PMDB" 
recode office 0=1 if Country=="BRA" & Party=="PTB" 
recode office 0=1 if Country=="BRA" & Party=="PV" 
recode office 0=1 if Country=="CHL" & Party=="PRI" 
recode office 0=1 if Country=="COL" & Party=="MIRA"
recode office 0=1 if Country=="CRI" & Party=="PASE" 
recode office 0=1 if Country=="ECU" & Party=="PRE" 
recode office 0=1 if Country=="ECU" & Party=="PSP"
recode office 0=1 if Country=="MEX" & Party=="PVEM" 
recode office 0=1 if Country=="PER" & Party=="AF" 
recode office 0=1 if Country=="PER" & Party=="RN" 

*****
* Dimension 1 is Taxes v. Spending
* Scale 2 is Importance (rather than position)
*****
gen Particularistic = Mean if office==1 & Scale==2 & Dimension==1 & include==1
gen Programmatic = Mean if office==0 & Scale==2 & Dimension==1 & include==1

#delimit ;
scatter Particularistic CtryCode, mlab(Party) mlabsize(vsmall) mlabcolor(blue) mcolor(blue) msize(small)  || 
	scatter Programmatic CtryCode, mcolor(black) msymbol(Oh) msize(small) ||
	, xlabel(1(1)11, angle(vertical) valuelabel labsize(small)) xtitle("")
	ylabel(6(2)20, labsize(vsmall) angle(horizontal)) ytitle("Mean rating on the importance of taxes v. spending dimension", size(small))
	legend(size(small) position(1) ring(0))
	;
#delimit cr
graph export wies-benoit.eps, replace


