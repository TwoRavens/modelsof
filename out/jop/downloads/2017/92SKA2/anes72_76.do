
use Data/anes_mergedfile_1972to1976.dta, clear
set more off, permanently


/* Question: How to answer likely rebuttal that candidate placement measurement error is 
correlated with self-placement measurement error, but we don't have multi-item scales for 
candidate issue placements.  This means that among lower knowledge people, candidate
placements will be very noisy, but their issue preference measured w a multi item scale
will still be correlated with their vote choice.
*/
  
/* ARS (2008) 1972-76 Economic Issues Scales (Common Items & All Items):

1972-76 Common Items Scale:

1972:
V720208 Government health insurance scale 1-7
V720629 Federal aid to minority groups 1-7  -- THIS IS IN ECONOMIC ISSUES?  We typically use to tap racial attitudes.
   SOME PEOPLE FEEL THAT THE GOVERNMENT IN WASHINGTON SHOULD MAKE EVERY POSSIBLE EFFORT TO IMPROVE THE SOCIAL  
                     AND ECONOMIC POSITION OF BLACKS AND OTHER MINORITY GROUPS.  OTHERS FEEL THAT THE
                     GOVERNMENT SHOULD NOT MAKE ANY SPECIAL EFFORT TO HELP MINORITIES BECAUSE THEY  
                     SHOULD HELP THEMSELVES. 
V720707 Big business feeling therm 0-100 
V720708 Poor people feeling therm 0-100
V720722 Labor union feeling therm 0-100
V720737 Labor union influence in american life and politics 3 pt scale 
V720738 Poor people influence in american life and politics 3 pt scale 
V720744 Big business influence in american life and politics 3 pt scale 
V720753 People on welfare influence in american life and politics 3 pt scale 
V721067 Gov see to job and standard of living/get ahead on own 1-7
V721068 Increase tax rates on high income/same for everyone 1-7 

1976:
V763241 Gov see to job and standard of living/get ahead on own 1-7
V763758 Gov see to job and standard of living/get ahead on own 1-7
V763264 Federal aid to minority groups 1-7  -- THIS IS IN ECONOMIC ISSUES?  We typically use to tap racial attitudes.
V763273 Government health insurance scale 1-7
V763566 Labor union influence in american life and politics 3 pt scale
V763567 Poor people influence in american life and politics 3 pt scale 
V763573 Big business influence in american life and politics 3 pt scale
V763582 People on welfare influence in american life and politics 3 pt scale
V763779 Increase tax rates on high income/same for everyone 1-7
V763821 Big business feeling therm 0-100
V763822 Poor people feeling therm 0-100
V763836 Labor union feeling therm 0-100

Question: Following 76 vars listed as included in 72-76 Common Items scale but did not occur in 1972 -- why included?
Assuming this is typo and these included in 72-76 All Items scale
V763751 Poor are poor bc wealthy keep them poor, agree/disagree 4 pt
V763752 Poor are poor bc not enough jobs for everyone, agree/disagree 4 pt
V763753 Poor have worse schools, agree/disagree 4 pt
V763754 Seniority system hurts poor people, agree/disagree 4 pt
V763755 Unions hurt poor people, agree/disagree 4 pt
V763757 Poor don't have equal chance, agree/disagree 4 pt
V763767 Urban unrest: solve poverty/use force 1-7 -- MORE OF A RACE QUESTION

1972-76 All Items Scale includes common items above plus:

1972:
V720214 Gov force industry to stop pollution 1-7
V720843 Poor have less/same chance to get ahead, which agree with more
V720848 Poor lazy/not equal chance, which agree with more
V720856 Why unemployed: lack skills/no jobs, which agree with more
V720688 Anyone who wants a job can get one 1-5
V720690 Poor people lack ability to get ahead 1-5
V720693 Poor people don't want to work hard, agree/disagree
V721111 Equality gone too far in this country, agree/disagree -- This is in "Economic issues"? Why? This is a race question
V721112 Old & handicapped take care of themselves, agree/disagree

1976:
V763353 Gov should spend less, agree/disagree 
V763589 Businessmen influence 3 pt
V763562 Should gov have pwr to regulate for safeft standards, yes/no
*/

/*
misstable patterns V720208 V720629 V720707 V720708 V720722 V720737 V720738 V720744 V720753 ///
V721067 V721068 V720214 V720843 V720848 V720856 V720688 V720690 V720693 V721111 V721112
*/


* CODING CANDIDATE PLACEMENTS ON ECONOMIC ISSUES IN 72 & 76

* 1972 *
g r_job72 = V721071 // Gov jobs 
g d_job72 = V721072
g r_tax72 = V721076 //Tax rate high income
g d_tax72 = V721077
tab V721076
tab V721077
g r_ins72 = V720209 // Health insurance
g d_ins72 = V720210
g r_aid72 = V720630 // Fed aid to minorities
g d_aid72 = V720631


/* 1972 Party placements if we ever wanted to use: 
DemP V721074 RepP V721075
DemP V721079 RepP V721080
DemP V720212 RepP V720213
DemP V720633 RepP V720634
*/

* 1976 * 
g r_tax76 = V763780 // Tax rate high income
g d_tax76 = V763781 
 tab1 V763780 V763781
g r_ins76 = V763274 // Health insurance
g d_ins76 = V763275
g r_aid76 = V763265 // Fed aid to minorities
g d_aid76 = V763266
g r_job76 = V763242 // Gov jobs.  Same question diff respondents V763759 -- can't remember how to combine into one var
tabulate V763242 V763759 //The second question is the same respondents asked in the postelection wave
g d_job76 = V763243 // Gov jobs.  Same question diff respondents V763760 -- can't remember how to combine into one var
g r_unr76 = V763768 // Urban unrest
g d_unr76 = V763769
/* 1976 Party placements if we ever wanted to use: 
// DemP V763782 RepP V763783 
// DemP V763276 RepP V763277
// DemP V763267 RepP V763268
// DemP V763244 V763761 RepP V763245 V763762
// DemP V763770 RepP V763771
*/
/**/

recode d_job72 9=0
recode d_tax72 9=0
recode r_job72 9=0
recode r_tax72 9=0

for any job tax ins aid: recode d_X72 0=.
for any job tax ins aid: recode r_X72 0=.
for any job tax ins aid unr: recode d_X76 0=.
for any job tax ins aid unr: recode r_X76 0=.
* Coding Correct Candidate Placements on Economic Issues

g pcand_job72 = d_job72 < r_job72 & r_job72!=8 & d_job72!=8 if d_job72!=0 ///
	& r_job72!=0 & d_job72!=9 & r_job72!=9 & d_job72!=. & r_job72!=.
g pcand_tax72 = d_tax72 < r_tax72 & r_tax72!=8 & d_tax72!=8 if d_tax72!=0 ///
	& r_tax72!=0 & d_tax72!=9 & r_tax72!=9 & d_tax72!=. & r_tax72!=.
	
g pcand_ins72 = d_ins72 < r_ins72 & r_ins72!=8 & d_ins72!=8 if d_ins72!=0 ///
	& r_ins72!=0 & d_ins72!=9 & r_ins72!=9 & d_ins72!=. & r_ins72!=.
g pcand_aid72 = d_aid72 < r_aid72 & r_aid72!=8 & d_aid72!=8 if d_aid72!=0 ///
	& r_aid72!=0 & d_aid72!=9 & r_aid72!=9 & d_aid72!=. & r_aid72!=.

g pcand_job76 = d_job76 < r_job76 & r_job76!=8 & d_job76!=8 if d_job76!=0 ///
	& r_job76!=0 & d_job76!=9 & r_job76!=9 & d_job76!=. & r_job76!=.
g pcand_tax76 = d_tax76 <= r_tax76 & r_tax76!=8 & d_tax76!=8 if d_tax76!=0 ///
	& r_tax76!=0 & d_tax76!=9 & r_tax76!=9 & d_tax76!=. & r_tax76!=.
	*people don't seem to see much difference between Carter and Ford on taxes
	*we are classifying many people as incorrect and 76 who get this question right in 1972
	*see if <= clean things up
g pcand_ins76 = d_ins76 < r_ins76 & r_ins76!=8 & d_ins76!=8 if d_ins76!=0 ///
	& r_ins76!=0 & d_ins76!=9 & r_ins76!=9 & d_ins76!=. & r_ins76!=.
g pcand_aid76 = d_aid76 < r_aid76 & r_aid76!=8 & d_aid76!=8 if d_aid76!=0 ///
	& r_aid76!=0 & d_aid76!=9 & r_aid76!=9 & d_aid76!=. & r_aid76!=.
g pcand_unr76 = d_unr76 < r_unr76 & r_unr76!=8 & d_unr76!=8 if d_unr76!=0 ///
	& r_unr76!=0 & d_unr76!=9 & r_unr76!=9 & d_unr76!=. & r_unr76!=.

g plc72econ = (pcand_job72 + pcand_tax72 + pcand_ins72 + pcand_aid72)/4

g plc76econ = (pcand_job76 + pcand_tax76 + pcand_ins76 + pcand_aid76)/4  

for any job tax ins aid: g k_X_1_1=pcand_X72==1 & pcand_X76==1 if pcand_X72!=. & pcand_X76!=.
*for any job tax ins aid: replace k_X_1_1=. if (pcand_X72 +pcand_X76)==1

tab1 pcand_*72  pcand_*76
tab1 k_*_1_1

g kt_economic_1_1 = k_job_1_1 + k_tax_1_1+k_ins_1_1 +k_aid_1_1
tabulate kt_economic_1_1 


		 
* CREATING ECONOMIC ISSUES SCALES WITH R SELF PLACEMENTS ON SAME ISSUES USED IN CANDIDATE PLACEMENTS

g ins72 = V720208 // Government health insurance scale
g aid72 = V720629 // Federal aid to minority groups 
g job72 = V721067 // Gov see to job and standard of living/get ahead on own
g tax72 = V721068 // Increase tax rates on high income/same for everyone
tab V721068
g ins76 = V763273 // Government health insurance scale 1-7
g aid76 = V763264 // Federal aid to minority groups 1-7
tab1 V763241 V763758
tab V763241 V763758
g job76 = V763241  // Note we end up throwing out some people who averaged >7 or <1  
g tax76 = V763779 // Increase tax rates on high income/same for everyone 1-7
g urb76 = V763767 // Urban unrest: solve poverty/use force 1-7
tab V763779
* Coding missing values
tab1 V721068 V720208 V721067

for any job ins aid tax: tabulate d_X72 X72 ,col missing
for any job ins aid tax: tabulate d_X76 X76 ,col missing

for any job ins aid tax: replace d_X72= -99 if X72== 8 
for any job ins aid tax: replace r_X72= -99 if X72== 8 
for any job ins aid tax: replace d_X76= -99 if X76== 8 
for any job ins aid tax: replace r_X76= -99 if X76== 8 

for any job ins aid tax: recode X72 (8 =-99) (0 9 =.)
for any job ins aid tax urb: recode X76 (8 =-99) (0 9 =.)


* CREATING 1972 NON-ECONOMIC ISSUES SCALE

*Racial scale from Ansolabehere
 *items asking both 1972 and 1976 (common items)
 *for any 720106 720112 720115 720118 720202 720727 720729 720745 720845 720847 720849 720855 720859 720862: tabulate VX
 *the only ask placement items for the busing question
 
*Women scale from Ansolabehere et al. (common items)
*for any 763787 763796 763798 763802 763804 763808 763809 763811 763813 763839: tabulate VX
*763796 is just the abortion question-it's followed by a question about which party would support an amendment, but parties didn't really have positions

*Law and order scale from Ansolabehere et al. (common items)
*for any   720196 720621 720713 720714 720717 720726: tabulate VX
 *only pot and rights of the accused have placements

* Coding candidate placements on non-economic issues in 1972

g r_pot72 = V720197 // Pot legalization
g d_pot72 = V720198
g r_bus72 = V720203 // school busing
g d_bus72 = V720204 
g r_pltn72 = V720215 // gov reg of pollution         form 2 only
g d_pltn72 = V720216
g r_rts72 = V720622  // rights of accused criminals  *post
g d_rts72 = V720623 
g r_urbn72 = V720671 // how to deal w urban unrest   *post
g d_urbn72 = V720672
g r_cmps72 = V720679 // how to deal w cmpus unrest   *post
g d_cmps72 = V720680
g r_wmn72 = V720233 // women's role in society
g d_wmn72 = V720234
g r_nam72pre = V720185  // Vietnam withdrawal        form 2 only
g r_nam72post = V720591                           // form 1 only
g d_nam72pre = V720186  
g d_nam72post = V720592                           // form 1 only * no 76 question, obviously
gen r_nam72 =r_nam72post
gen d_nam72 =d_nam72post
tab1 r_*
tab1 V720198	V720679		

recode r_nam72 9=0
recode d_nam72 9=0

for any nam pot bus pltn rts urbn cmps wmn: recode r_X72 0=.
for any nam pot bus pltn rts urbn cmps wmn: recode d_X72 0=.

*Coding Correct Candidate Placements on Other Issues
g pcand_nam72 = d_nam72 < r_nam72 & r_nam72!=8 & d_nam72!=8 if d_nam72!=0 ///
	& r_nam72!=0 & d_nam72!=9 & r_nam72!=9 & d_nam72!=. & r_nam72!=.
g pcand_pot72 = d_pot72 < r_pot72 & r_pot72!=8 & d_pot72!=8 if d_pot72!=0 ///
	& r_pot72!=0 & d_pot72!=9 & r_pot72!=9 & d_pot72!=. & r_pot72!=.
g pcand_bus72 = d_bus72 < r_bus72 & r_bus72!=8 & d_bus72!=8 if d_bus72!=0 ///
	& r_bus72!=0 & d_bus72!=9 & r_bus72!=9 & d_bus72!=. & r_bus72!=.
g pcand_pltn72 = d_pltn72 < r_pltn72 & r_pltn72!=8 & d_pltn72!=8 if d_pltn72!=0 ///
	& r_pltn72!=0 & d_pltn72!=9 & r_pltn72!=9 & d_pltn72!=. & r_pltn72!=.
g pcand_rts72 = d_rts72 < r_rts72 & r_rts72!=8 & d_rts72!=8 if d_rts72!=0 ///
	& r_rts72!=0 & d_rts72!=9 & r_rts72!=9 & d_rts72!=. & r_rts72!=.
g pcand_urbn72 = d_urbn72 < r_urbn72 & r_urbn72!=8 & d_urbn72!=8 if d_urbn72!=0 ///
	& r_urbn72!=0 & d_urbn72!=9 & r_urbn72!=9 & d_urbn72!=. & r_urbn72!=.
g pcand_cmps72 = d_cmps72 < r_cmps72 & r_cmps72!=8 & d_cmps72!=8 if d_cmps72!=0 ///
	& r_cmps72!=0 & d_cmps72!=9 & r_cmps72!=9 & d_cmps72!=. & r_cmps72!=.
g pcand_wmn72 = d_wmn72 < r_wmn72 & r_wmn72!=8 & d_wmn72!=8 if d_wmn72!=0 ///
	& r_wmn72!=0 & d_wmn72!=9 & r_wmn72!=9 & d_wmn72!=. & r_wmn72!=.

g plc72other = (pcand_nam72 + pcand_pot72 + pcand_bus72 + pcand_pltn72 ///
	+ pcand_rts72 + pcand_urbn72 + pcand_cmps72 + pcand_wmn72)/8

g plc72other_5 = (pcand_nam72 + pcand_pot72 + pcand_bus72 ///
	+ pcand_rts72 + pcand_wmn72)/5


* Party placements for 1972 and 1976 (Kelsey originally coded these in the cumulative file)	
*there is also an inflation question it was only asked on form 2
g pd_ins72 = V720212 // form 1 only
g pr_ins72 = V720213 // form 1 only
g pd_job72 = V720176  // form 1 only
g pr_job72 = V720177  // form 1 only
g pd_tax_p72 = V720665  // form 1 only
g pr_tax_p72 = V720666 // form 1 only
g pr_aid_p72 = V720634
g pd_aid_p72 = V720633


g pd_job76 = V763244
g pr_job76 = V763245
g pd_ins76 = V763276
g pr_ins76 = V763277
g pd_tax_p76 = V763782
g pr_tax_p76 = V763783 
g pd_aid76 = V763267
g pr_aid76 = V763268
tab1 pd_* pr_*

recode pd_* pr_* (0 9=.) (8 =99) // Use this for cand. place
*Create Party Position Knowl. Vars* PRE
foreach i in job ins aid_p tax_p {
  g knp_`i'72 = pd_`i'72 < pr_`i'72 & pr_`i'72 < 99 & pd_`i'72 != 99 &  pr_`i'72 != 99 if pd_`i'72!= . & pr_`i'72 != .
}
foreach i in job ins aid tax_p {
  g knp_`i'76 = pd_`i'76 < pr_`i'76 & pr_`i'76 < 99 & pd_`i'76 != 99 &  pr_`i'76 != 99 if pd_`i'76!= . & pr_`i'76 != .
}
rename knp_aid_p72 knp_aid72
rename knp_tax_p72 knp_tax72
rename knp_tax_p76 knp_tax76
foreach i in job ins aid tax {
  g knp_`i' = knp_`i'72 == 1 & knp_`i'76 == 1 if knp_`i'72!=. & knp_`i'76!=.
}
sum knp_*

	
* Coding R self-placement on same non-economic issues used in candidate placements

g pltn72 = V720214         
g rts72 = V720621         
g urbn72 = V720670         
g cmps72 = V720678         
g wmn72 = V720232                  
g bus72 = V720202 
g pot72 = V720196

g nam72_pre = V720184
g nam72 = V720590      // form 1 
recode nam72 9=0

for any pltn rts urbn cmps wmn bus pot nam: tab X72,nol
for any pltn rts urbn cmps wmn bus pot nam: recode X72  ( 8 =-99) (0 9 =.)


* Creating "Non-economic Issues" Scales

g other_iss72 = (pltn72 + rts72 + urbn72 + cmps72 + wmn72 + bus72 + pot72 + nam72)/8
* hist other_iss72, percent

g other_iss72_5 = (rts72 + wmn72 + bus72 + pot72 + nam72)/5
* hist other_iss72_5, percent


* INVESTIGATING STABILITY BETWEEN 72/76 WAVES

* Coding additional 1972 economic item self-placements:

g bbus72 = V720707 // Big business feeling therm 0-100 
g poor72 = V720708 // Poor people feeling therm 0-100
g unon72 = V720722 // Labor union feeling therm 0-100
g unoninf72 = V720737 // Labor union influence in american life and politics 3 pt scale 
g poorinf72 = V720738 // Poor people influence in american life and politics 3 pt scale 
g bbusinf72 = V720744 // Big business influence in american life and politics 3 pt scale 
g welfinf72 = V720753 // People on welfare influence in american life and politics 3 pt scale 

for any bbus poor unon: replace X72 =. if X72 > 97
for any unoninf poorinf bbusinf welfinf: replace X72 =. if X72 < 1
for any unoninf poorinf bbusinf welfinf: replace X72 =. if X72 > 3

* re-scaling and coding in consistent direction (higher = more conservative)

for any poor unon: replace X72 = (X72*(-1))+100
for any bbus poor unon: replace X72 = (X72)/100
for any unoninf poorinf welfinf: recode X72 (3=1) (1=3)
for any unoninf poorinf bbusinf welfinf: replace X72 = (X72-1)/2

* Coding additional 1976 economic item self-placements:

g unoninf76 = V763566 
g poorinf76 = V763567 
g bbusinf76 = V763573
g welfinf76 = V763582 
g bbus76 = V763821 
g poor76 = V763822 
g unon76 = V763836 

* re-scaling and coding in consistent direction

for any bbus poor unon: replace X76 =. if X76 > 97
for any unoninf poorinf bbusinf welfinf: replace X76 =. if X76 < 1
for any unoninf poorinf bbusinf welfinf: replace X76 =. if X76 > 3

for any poor unon: replace X76 = (X76*(-1))+100
for any bbus poor unon: replace X76 = (X76)/100
for any unoninf poorinf welfinf: recode X76 (3=1) (1=3)
for any unoninf poorinf bbusinf welfinf: replace X76 = (X76-1)/2

* Creating Economic Issues scales with all self-placement items

g econ_iss72all = (job72 + tax72 + ins72 + aid72 + bbus72 + poor72 + unon72 + unoninf72 ///
	+ poorinf72 + bbusinf72 + welfinf72)/11 

g econ_iss76all = (job76 + tax76 + ins76 + aid76 + bbus76 + poor76 + unon76 + unoninf76 ///
	+ poorinf76 + bbusinf76 + welfinf76)/11

/* egen econ_iss76all = rowmean(job76 tax76 ins76 aid76 bbus76 poor76 unon76 unoninf76 ///
	poorinf76 bbusinf76 welfinf76) */

/* Question for Gabe: Without deletion of missing data, e.g. when using egen, cross-wave 
correlation is a decent bit lower */


* Coding correct candidate placements, R is correct only if placements ON ECON ISSUES Sin both waves right

for any job tax ins aid: g plc7276X = 1 if pcand_X72==1 & pcand_X76==1
for any job tax ins aid: replace plc7276X = 0 if pcand_X72==0 | pcand_X76==0 

g plc7276econ = (plc7276job + plc7276tax + plc7276ins + plc7276aid)/4


* Coding correct candidate placements, R gets 1/2 pt if placement ON ECON ISSUES in one wave right

g plc7276econEz = (pcand_job72 + pcand_tax72 + pcand_ins72 + pcand_aid72 ///
	+ pcand_job76 + pcand_tax76 + pcand_ins76 + pcand_aid76)/8

* REPEATING EXERCISE W 4 NON-ECONOMIC ITEMS (Excluding Urbn) W CANDIDATE PLACEMENTS IN BOTH WAVES

g other_4iss72nm = (rts72 + wmn72 + bus72 + pot72)/4
* hist other_4iss72nm, percent

g rts76 = V763248        
g urbn76 = V763767         
g wmn76 = V763787                  
g bus76 = V763257 
g pot76 = V763772

for any rts urbn wmn bus pot: recode X76 ( 8 =-99) (0 9 =.)
for any rts urbn wmn bus pot:recode X76  ( 8 =-99) (0 9 =.)
for any rts urbn wmn bus pot: tab X76 


g other_4iss76nm = (rts76 + urbn76 + wmn76 + bus76 + pot76)/5
* hist other_4iss76nm, percent

* Coding correct candidate placements, R is correct only if placements in both waves right

g d_pot76 = V763774 
g d_rts76 = V763250
g d_wmn76 = V763789
g d_bus76 = V763259 
g d_urbn76 = V763769

g r_urbn76 = V763768     
g r_pot76 = V763773      
g r_wmn76 = V763788    
tabulate V763788  
g r_rts76 = V763249      
g r_bus76 = V763258      

g pcand_rts76 = d_rts76 < r_rts76 & r_rts76!=8 & d_rts76!=8 if d_rts76!=0 ///
	& r_rts76!=0 & d_rts76!=9 & r_rts76!=9 & d_rts76!=. & r_rts76!=.
g pcand_urbn76 = d_urbn76 < r_urbn76 & r_urbn76!=8 & d_urbn76!=8 if d_urbn76!=0 ///
	& r_urbn76!=0 & d_urbn76!=9 & r_urbn76!=9 & d_urbn76!=. & r_urbn76!=.
g pcand_wmn76 = d_wmn76 < r_wmn76 & r_wmn76!=8 & d_wmn76!=8 if d_wmn76!=0 ///
	& r_wmn76!=0 & d_wmn76!=9 & r_wmn76!=9 & d_wmn76!=. & r_wmn76!=.
g pcand_bus76 = d_bus76 < r_bus76 & r_bus76!=8 & d_bus76!=8 if d_bus76!=0 ///
	& r_bus76!=0 & d_bus76!=9 & r_bus76!=9 & d_bus76!=. & r_bus76!=.
g pcand_pot76 = d_pot76 < r_pot76 & r_pot76!=8 & d_pot76!=8 if d_pot76!=0 ///
	& r_pot76!=0 & d_pot76!=9 & r_pot76!=9 & d_pot76!=. & r_pot76!=.

for any rts wmn bus pot: g plc7276X = 1 if pcand_X72==1 & pcand_X76==1
for any rts wmn bus pot: replace plc7276X = 0 if pcand_X72==0 | pcand_X76==0 

g plc7276other = (plc7276rts + plc7276wmn + plc7276bus + plc7276pot)/4
 

 
 *********************************************
 **Coding Scales from Ansolabehere et al.
 *********************************************
 *correctly place parties on woman's Place question
 tab pcand_wmn7*
 tab1 *_wmn* pcand_wmn7*
 g k_wmn_1_1 =pcand_wmn72== 1 & pcand_wmn76== 1  if pcand_wmn72!=. & pcand_wmn76!=.
for var  wmn72 wmn76 : egen std_X =std(X)

 tabulate k_wmn_1_1 
 corr wmn72 wmn76 if k_wmn_1_1 ==1
 corr wmn72 wmn76 if k_wmn_1_1 ==0
  *quickly check how many people consistently placed parties on the reverse sides: not many, just 24
  corr wmn72 wmn76 if  pcand_wmn72==0 & pcand_wmn76 ==0 & r_wmn72!=d_wmn72 & r_wmn76!=d_wmn76& r_wmn72!=8 & d_wmn72!=8 & r_wmn76!=8 & d_wmn76!=8

*Busing
g k_bus_1_1 =pcand_bus72== 1 & pcand_bus76== 1  if pcand_bus72!=. & pcand_bus76!=.
for var  bus72 bus76 : egen std_X =std(X)
 
*Law and Order Scale  (from Ansolabehere et al.) 
g k_pot_1_1 =pcand_pot72== 1 & pcand_pot76== 1  if pcand_pot72!=. & pcand_pot76!=.
for var  pot72 pot76 : egen stdo_X =std(X)

g k_rts_1_1 =pcand_rts72== 1 & pcand_rts76== 1  if pcand_rts72!=. & pcand_rts76!=.
for var  rts72 rts76 : egen stdo_X =std(X)

corr pot* d_pot* r_pot*
pwcorr pot* d_pot* r_pot*,obs
corr rts* d_rts* r_rts*
corr  pot* d_pot* r_pot* rts* d_rts* r_rts*
tab1 pcand_rts72 pcand_rts76 pcand_pot72 pcand_pot76
tab k_rts_1_1
tab k_pot_1_1
tab k_rts_1_1 k_pot_1_1
g kt_order_1_1 =k_rts_1_1+ k_pot_1_1
factor stdo_*72, pcf
 predict  order_72
factor stdo_*76, pcf
 predict order_76
 
* Coding correct candidate placements, R gets 1/2 pt if placement in one wave right

/*g plc7276otherEz = (pcand_rts72 + pcand_urbn72 + pcand_wmn72 + pcand_bus72 ///
	+ pcand_pot72 + pcand_rts76 + pcand_urbn76 + pcand_wmn76 + pcand_bus76 ///
	+ pcand_pot76)/10
*/
	
g plc7276otherEz = (pcand_rts72 + pcand_wmn72 + pcand_bus72 ///
	+ pcand_pot72 + pcand_rts76 + pcand_wmn76 + pcand_bus76 ///
	+ pcand_pot76)/8

for any rts bus wmn pot: sum d_X76 r_X76 if r_X76!=8 & d_X76!=8 &d_X76!=0 ///
 & r_X76!=0 & d_X76!=9 & r_X76!=9

* Coding Don't Know responses

for any job tax ins aid pltn urbn cmps wmn bus pot nam: g dkr_X72 = 1 if r_X72==8 
for any job tax ins aid pltn urbn cmps wmn bus pot nam: g dkd_X72 = 1 if d_X72==8
egen dk_iss72 = rowtotal(dkr_pltn72 dkr_urbn72 dkr_cmps72 dkr_wmn72 /// 
	dkr_bus72 dkr_pot72 dkr_nam72 dkd_pltn72 dkd_urbn72 dkd_cmps72 dkd_wmn72 ///
	dkd_bus72 dkd_pot72 dkd_nam72) 

tab dk_iss72, mis


* Coding Candidate Placements Ex Incorrect Placements w DKs as 0's

for any pltn rts urbn cmps wmn bus pot nam: g know_X72 = 0 if r_X72==8 | d_X72==8
for any pltn rts urbn cmps wmn bus pot nam: g dplc_X72 = d_X72 if (d_X72 < 8 & d_X72 > 0) 
for any pltn rts urbn cmps wmn bus pot nam: g rplc_X72 = r_X72 if (r_X72 < 8 & r_X72 > 0) 
for any pltn rts urbn cmps wmn bus pot nam: replace know_X72 = 1 if dplc_X72 < rplc_X72 & rplc_X72!=.

g plc72other_5kdk = (know_rts72 + know_wmn72 ///
	+ know_bus72 + know_pot72 + know_nam72)/5

tab plc72other_5kdk



/* egen know72 = rowmean(know_pltn72 know_rts72 know_urbn72 know_cmps72 know_wmn72 ///
	know_bus72 know_pot72 know_nam72) */

* trying w 4 economic issues

for any job tax ins aid: g know_X72 = 0 if r_X72==8 | d_X72==8
for any job tax ins aid: g dplc_X72 = d_X72 if (d_X72 < 8 & d_X72 > 0)
for any job tax ins aid: g rplc_X72 = r_X72 if (r_X72 < 8 & r_X72 > 0)
for any job tax ins aid: replace know_X72 = 1 if dplc_X72 < rplc_X72

g knowecon72 = (know_job72 + know_tax72 + know_ins72 + know_aid72)/4

tab knowecon72


* Coding presidential vote, pid, and ideology
tabulate V720478
g pvote72 = V720478
replace pvote72 = . if pvote72>2
replace pvote72 = . if pvote72<1
recode pvote72 (2=0)

g pid72 = V720140/6
replace pid72 = . if pid72>1

g ide72 = V720652
replace ide72 = . if ide72>7
recode ide72 (0=.)
replace ide72 = (ide72-1)/6 

g pvote76 = V763665
replace pvote76 = . if pvote76>2
replace pvote76 = . if pvote76<1
recode pvote76 (2=0)

g pid76 = V763174/6
replace pid76 = . if pid76>1

g ide76 = V763286
replace ide76 = . if ide76>7
recode ide76 (0=.)
replace ide76 = (ide76-1)/6 

* Coding education

g educ72 = 1 if V720300 < 50
replace educ72 = 2 if V720300==50 | V720300==51
replace educ72 = 3 if V720300==61
replace educ72 = 4 if V720300==71
replace educ72 = 5 if V720300==81 
replace educ72 = 6 if V720300==82
replace educ72 = 6 if V720300==83
replace educ72 = 6 if V720300==84
replace educ72 = 6 if V720300==85
replace educ72 = . if V720300 > 85


* Coding factual political knowledge
*72
tab V720943 V720944,col
g pterm = V720943
recode pterm (1=0) (2=1) (3/98=0) (99=.) (00=.)
g sterm = V720944
recode sterm (1/5=0) (6=1) (7/98=0) (99=.) (00=.)
tab V720949
g cterm = V720949
recode cterm (1=0) (2=1) (3/98=0) (99=.) (00=.)
g hspre = V720950
tab V720950
recode hspre (1/3=0) (5=1) (8=0) (9=.) (0=.)
tab V720951
g hspost = V720951 
recode hspost (1/3=0) (5=1) (8=0) (9=.) (0=.)


*which party is more conservative
tab1 V720498 V720499  V720500 
tab V720499  V720500 
tab V720499  V720498, 
tab   V720500 
g knw_general1=V720500
recode knw_general1 (2 4=1) (1 3 5 8=0) (9 0=.) //Which party is more conservative *Relatively small sample
g knw_general2=V720587 // Which party favors amnesty
recode knw_general2 (3 5 8=0) (9 0=.)
tab V720943,nol
g knw_general3=V720943 //(pterm) How many times can someone be elected pres.
recode knw_general3 (2=1) (1 3 4 5 6 7 10 98=0) (99 00=.)
g knw_congress4=V720944 //(//sterm) Length of senate term
recode knw_congress4 (6=1) (1 2 3 4 5 7 8 9 97 98=0) (99 00=.) 
g knw_congress5=cterm
g knw_hspre=hspre
g knw_hspost=hspost
*cterm/hspre/hspost

g knw_congress1=V720945
recode knw_congress1 (1=1) (9 0=.) (5 8=0)
g knw_congress2=V742174
recode knw_congress2 (1=1) (9 0=.) (5 8=0)

g knw_congress3=V742214
recode knw_congress3 (1=1) (9 0=.) (5 8=0)

tab V763683
recode V763683 (5=1) (9 0=.) (8 8=0),gen(knw_cong76b)
recode V763684 (5=1) (9 0=.) (8 8=0),gen(knw_cong76a)

 
* Coding interviewer rating of political information
tab V720429
g int72 = 5-V720429 if V720429<9
g int76 = 5-V763517 if V763517<9
sum int*
tab int*

egen int_average = rowmean(int72 int76)
*misstable patterns knw_* pterm sterm  cterm hspre  hspost int_average

sum knw_* pterm sterm  cterm hspre  hspost int72 int76

tab1 knw_* pterm sterm  cterm hspre  hspost int72 int76
pwcorr knw_* pterm sterm  cterm hspre  hspost int72 int76,obs

for var knw_* pterm sterm  cterm hspre  hspost int_average: tab X V720943 ,mis
/*
g knw_total=knw_general1 + knw_general2 + knw_general3 + knw_congress1 + knw_congress2 + knw_congress3 ///
+ knw_congress4 + knw_congress5 + knw_hspre + knw_hspost+int72
g knw_total2=knw_general1 + knw_general2 + knw_general3 + knw_congress1  ///
+ knw_congress4 + knw_congress5 + knw_hspre + knw_hspost+int72
pwcorr cterm hspre hspost knw_* int_average
*/
*so many missing observations on some variables that I'm creating a average of available items
egen knwcount = rownonmiss( knw_* pterm sterm  cterm hspre  hspost int_average)
*tabulate 	knwcount					
*tabulate 	knwcount	if  k_job_1_1 !=.& k_tax_1_1 !=. &k_ins_1_1 !=.&k_aid_1_1 !=.
tab knwcount V720003 

*drop if 	knwcount<13  // drop the one person missing most of these items
for var knw_* pterm sterm  cterm hspre  hspost  int_average: impute X knw_* pterm sterm  cterm hspre  hspost  int72 int76 ,g(iX) 
for var knw_* pterm sterm  cterm hspre  hspost  int_average: replace X =iX 
egen knw_total = rowtotal( knw_* pterm sterm  cterm hspre  hspost int_average)
alpha  knw_* pterm sterm  cterm hspre  hspost int_average if  pid72!=. & pid76!=.
sum  knw_total   knw_* pterm sterm  cterm hspre  hspost int_average 
sum  knw_total   knw_* pterm sterm  cterm hspre  hspost int_average 

*tab knw_total
*histogram knw_total
*pwcorr economic_72 economic_76  knw_average knw_tota* knwldg72 knw_* , obs

*thermometer difference
g therm_72 =V720255 - V720254
g therm_76 =V763299 - V763298 
*rescal both to seven-point scale
sum therm_*
norm therm_72 
norm therm_76
for num 72 76: replace therm_X = (therm_X *6) +1
corr therm_*
*sunflower therm_*

*party ideology placements  *asked only in the post in 1972
tab V720652
tab V720656 V720657
tab V763289 V763290
g d_ide_72  = V720656 
g r_ide_72  = V720657 
g d_ide_76  = V763289 
g r_ide_76  = V763290 
