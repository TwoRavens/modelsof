**** Analysis of Development Impact of RSE in Vanuatu

** Set directory
clear matrix
clear
cd C:\seasonalworker\ReStatReplicationFiles\


*** Open replication data
use TongaReplicationData.dta, clear

** Per capita income and consumption
gen pcy1=r1pcy1
gen pcy2=r1pcy2
replace pcy1=pcy if wave>=2
replace pcy2=pcy if wave>=2
replace pccons=r1pccons if wave==1 

** make sure migrants currently in New Zealand are not included in household size
gen hhsizeNM=hhsize
replace hhsizeNM=hhsize-1 if inNZnow==1

replace pcy2=pcy2*(hhsize/hhsizeNM)
replace pccons=pccons*(hhsize/hhsizeNM)

gen logpcy1=log(pcy1)
gen logpcy2=log(pcy2)
gen logpccons=log(pccons)

 *** Poor in terms of income per head below $1 and $2 per day
 gen poor1=pcy2<350.4
 gen poor2=pcy2<700.8

*** Generate Wave dummies and Indicator for RSE household in time period since worker left.
gen wave2=wave==2
gen wave3=wave==3
gen wave4=wave==4
gen RSEpost=0
replace RSEpost=1 if r2RSE==1 & wave>=2
replace RSEpost=1 if (r3repeat==1|r3newRSE==1|r3returnee==1) & wave>=3
replace RSEpost=1 if (r4repeat==1|r4newRSE==1|r4returnee==1|r4RSE==1) & wave==4
tab RSEpost wave
* note RSEpost is the same as the variable everRSE

*** Propensity-Score matching to create Propensity-Scores

 * Model 1: add last two years of lags of wage income and having a wage worker
 gen wage2007inc2=wage2007inc^2
 gen wage2006inc2=wage2006inc^2
 
 #delimit ;
 local squares "hhsize nmales1850 nadults nschoolage 
englitshare_male1850 postf4share_male1850 healthverygoodshare_male1850 drinkalcoholshare_male1850 meanhardlab 
shareadultsprevNZ numrelativesNZ 
assetindex pigs chickens cattle tongandwell dwellingwood tongatapu
r1pcy1 r1pccons ";
#delimit cr
foreach x of local squares {
gen z`x' = `x'*`x'
}
 
  #delimit ;
pscore RSEworker z* hhsize nmales1850 nadults nschoolage 
englitshare_male1850 postf4share_male1850 healthverygoodshare_male1850 drinkalcoholshare_male1850 meanhardlab 
shareadultsprevNZ numrelativesNZ 
assetindex pigs chickens cattle tongandwell dwellingwood tongatapu
r1pcy1 r1pccons 
 wage2007inc wage2006inc wage2007inc2 wage2006inc2 maleworker2007 maleworker2006
 if wave==1, pscore(ps3);
 
 #delimit cr
 * Model 2: restrict to sample of applicants
 gen Applicant=RSEworker==1|RSEapplicant==1
  #delimit ;
pscore RSEworker z* hhsize nmales1850 nadults nschoolage 
englitshare_male1850 postf4share_male1850 healthverygoodshare_male1850 drinkalcoholshare_male1850 meanhardlab 
shareadultsprevNZ numrelativesNZ 
assetindex pigs chickens cattle tongandwell dwellingwood tongatapu
r1pcy1 r1pccons 
 wage2007inc wage2006inc wage2007inc2 wage2006inc2 maleworker2007 maleworker2006
 if wave==1 & Applicant==1, pscore(ps4);

 
 #delimit cr
 
 for num 3/4: egen mpsX=max(psX), by(seq_no)
 
 gen wagegrowth=wage2007inc-wage2006inc
 
 ***** Table 1: Comparison of Baseline Means for Different Groups
 #delimit cr
 * First Compare RSE households to All others
matrix R=[1,1,1,1,1,1]
matrix colnames R="mean nonRSE" "mean RSE" "N nonRSE" "N RSE" "N tot" "p value"
#delimit ;
quietly foreach var in hhsize nmales1850 englitshare_male1850 postf4share_male1850
 healthverygoodshare_male1850 drinkalcoholshare_male1850 meanhardlab 
 shareadultsprevNZ numrelativesNZ 
assetindex pigs chickens cattle tongandwell  tongatapu
r1pcy2 r1pccons poor1 poor2 maleworker2007 wagegrowth {;
	ttest `var' if wave==1,by(RSEworker);
	matrix A=[r(mu_1),r(mu_2),r(N_1) ,r(N_2),r(N_1)+r(N_2)  ,r(p)];
	matrix rownames A=`var';
	matrix list A;
	matrix R=R\A;
	matrix list R;
};
set linesize 200;
matrix list R;
 
#delimit cr
* Then compare to households matched against for PS-1 households
matrix R=[1,1,1,1,1,1]
matrix colnames R="mean nonRSE" "mean RSE" "N nonRSE" "N RSE" "N tot" "p value"
#delimit ;
quietly foreach var in hhsize nmales1850 englitshare_male1850 postf4share_male1850
 healthverygoodshare_male1850 drinkalcoholshare_male1850 meanhardlab 
 shareadultsprevNZ numrelativesNZ 
assetindex pigs chickens cattle tongandwell  tongatapu
r1pcy2 r1pccons poor1 poor2 maleworker2007 wagegrowth{;
	ttest `var' if wave==1 & ps3>=0.1 & ps3<=0.9,by(RSEworker);
	matrix A=[r(mu_1),r(mu_2),r(N_1) ,r(N_2),r(N_1)+r(N_2)  ,r(p)];
	matrix rownames A=`var';
	matrix list A;
	matrix R=R\A;
	matrix list R;
};
set linesize 200;
matrix list R;

#delimit cr
* Matched on applicants too - PS-2
matrix R=[1,1,1,1,1,1]
matrix colnames R="mean nonRSE" "mean RSE" "N nonRSE" "N RSE" "N tot" "p value"
#delimit ;
quietly foreach var in hhsize nmales1850 englitshare_male1850 postf4share_male1850
 healthverygoodshare_male1850 drinkalcoholshare_male1850 meanhardlab 
 shareadultsprevNZ numrelativesNZ 
assetindex pigs chickens cattle tongandwell  tongatapu
r1pcy2 r1pccons poor1 poor2 maleworker2007 wagegrowth{;
	ttest `var' if wave==1 & ps4>=0.1 & ps4<=0.9,by(RSEworker);
	matrix A=[r(mu_1),r(mu_2),r(N_1) ,r(N_2),r(N_1)+r(N_2)  ,r(p)];
	matrix rownames A=`var';
	matrix list A;
	matrix R=R\A;
	matrix list R;
};
set linesize 200;
matrix list R;
 
  #delimit cr
 
 ** Median wage growth
 bysort RSEworker: centile wagegrowth if wave==1
 bysort RSEworker: centile wagegrowth if wave==1 & ps3>=0.1 & ps3<=0.9
 bysort RSEworker: centile wagegrowth if wave==1 & ps4>=0.1 & ps4<=0.9
 
 *** Re-scale components of income so comparing on 6 month scale for all
 replace netremittancesall=netremittancesall*0.5 if wave==1|wave==4
 replace grossremittancesall=grossremittancesall*0.5 if wave==1|wave==4
 replace grossremittancesRSE=grossremittancesall*0.5 if wave==1|wave==4
 
 replace ag_income_hh=ag_income_hh*0.5 if wave==1|wave==4
 replace wageinc=wageinc*26
 replace grow_value_hh=grow_value_hh*26
 replace grow_valuelesspork=grow_valuelesspork*26
 replace communityspend=communityspend*6
 replace domtransfersin=domtransfersin*0.5 if wave==4
 replace domtransfersout=domtransfersout*0.5 if wave==4
 gen savingspc=pcy2-pccons
 
 *** Trimpoints
 for var pcy2 logpcy2 pccons logpccons savingspc:egen X_99=pctile(X), p(99)
 
 **** TABLE 3: IMPACTS ON INCOME AND CONSUMPTION MEASURES
 ** 8 Columns are for DD, DD-Matching on All, DD-Matching on Applicants, 3 trimmed, and FE, FE-Matching, FE-Matching on All, and 8 trimmed
 ** Then a Row will be for each outcome
 
  #delimit ;
foreach lhs of varlist pcy2 logpcy2 pccons savingspc logpccons  hhsizeNM
{;
 * Ever in RSE as measure of exposure;
 reg `lhs' RSEworker RSEpost wave2-wave4, cluster(seq_no);
 outreg2 RSEpost using Table2row_`lhs'.out, replace slow(400);
 reg `lhs' RSEworker RSEpost wave2-wave4 if mps3>=0.1 & mps3<=0.9, cluster(seq_no);
 outreg2 RSEpost using Table2row_`lhs'.out, append slow(400);
 reg `lhs' RSEworker RSEpost wave2-wave4 if mps4>=0.1 & mps4<=0.9, cluster(seq_no);
 outreg2 RSEpost using Table2row_`lhs'.out, append slow(400);
 reg `lhs' RSEworker RSEpost wave2-wave4 if mps4>=0.1 & mps4<=0.9 & pcy2<pcy2_99, cluster(seq_no);
 outreg2 RSEpost using Table2row_`lhs'.out, append slow(400);
 xtreg `lhs' RSEpost wave2-wave4, fe cluster(seq_no) i(seq_no);
 outreg2 RSEpost using Table2row_`lhs'.out, append slow(400);
 xtreg `lhs' RSEpost wave2-wave4 if mps3>=0.1 & mps3<=0.9, fe cluster(seq_no) i(seq_no);
 outreg2 RSEpost using Table2row_`lhs'.out, append slow(400);
 xtreg `lhs' RSEpost wave2-wave4 if mps4>=0.1 & mps4<=0.9, fe cluster(seq_no) i(seq_no);
 outreg2 RSEpost using Table2row_`lhs'.out, append slow(400);
 xtreg `lhs' RSEpost wave2-wave4 if mps4>=0.1 & mps4<=0.9 & pcy2<pcy2_99, fe cluster(seq_no) i(seq_no);
 outreg2 RSEpost using Table2row_`lhs'.out, append slow(400);
 };
 #delimit cr
 *** Baseline means for RSE households for Table 2
 sum pcy2 logpcy2 pccons logpccons savingspc hhsizeNM if wave==1 & RSEworker==1
 
 
 ***Trying only observations which are a nearest neighbor
 attnw pcy2 RSEworker if wave==1, pscore(mps4) comsup matchvar(nndefine) matchdta(tongann) id(seq_no)

cap drop _merge
sort seq_no
merge seq_no using tongann.dta 

 #delimit ;
foreach lhs of varlist pcy2 logpcy2 pccons  logpccons savingspc hhsizeNM
{;
 * Ever in RSE as measure of exposure;
 reg `lhs' RSEworker RSEpost wave2-wave4 if nndefine==1, cluster(seq_no);
 outreg2 RSEpost using Table2nn.out, append slow(400);
 xtreg `lhs' RSEpost wave2-wave4 if nndefine==1, fe cluster(seq_no) i(seq_no);
 outreg2 RSEpost using Table2nn.out, append slow(400);
 };
 #delimit cr
 
**** Appendix: Robustness to alternative specification: difference-in-differences matching
*** Issue is how to combine multiple rounds of follow-up data, here we take average
for num 2/4: gen pcy2_waveX=pcy2 if wave==X
for num 2/4: egen mpcy2_waveX=mean(pcy2_waveX), by(seq_no)
egen postpcy2=rmean(mpcy2_wave2 mpcy2_wave3 mpcy2_wave4)
gen growpcy2=postpcy2-pcy2 if wave==1

 #delimit ;
pscore RSEworker z* hhsize nmales1850 nadults nschoolage 
englitshare_male1850 postf4share_male1850 healthverygoodshare_male1850 drinkalcoholshare_male1850 meanhardlab 
shareadultsprevNZ numrelativesNZ 
assetindex pigs chickens cattle tongandwell dwellingwood tongatapu
r1pcy1 r1pccons 
 wage2007inc wage2006inc wage2007inc2 wage2006inc2 maleworker2007 maleworker2006
 if wave==1, pscore(ps1) comsup blockid(myblock1);
#delimit cr
gen comsup1=comsup
  #delimit ;
pscore RSEworker z* hhsize nmales1850 nadults nschoolage 
englitshare_male1850 postf4share_male1850 healthverygoodshare_male1850 drinkalcoholshare_male1850 meanhardlab 
shareadultsprevNZ numrelativesNZ 
assetindex pigs chickens cattle tongandwell dwellingwood tongatapu
r1pcy1 r1pccons 
 wage2007inc wage2006inc wage2007inc2 wage2006inc2 maleworker2007 maleworker2006
 if wave==1 & Applicant==1, pscore(ps2) comsup blockid(myblock2);
gen comsup2=comsup;
#delimit cr
* Regression with this outcome variable
attk growpcy2 RSEworker if wave==1 & comsup1==1, pscore(ps1) bootstrap
attk growpcy2 RSEworker if wave==1 & comsup1==1, pscore(ps1) bootstrap epan
attr growpcy2 RSEworker if wave==1 & comsup1==1, pscore(ps1)  radius(0.1)
attr growpcy2 RSEworker if wave==1 & comsup1==1, pscore(ps1)  radius(0.05)
atts growpcy2 RSEworker if wave==1 & comsup1==1, pscore(ps1) blockid(myblock1) 

attk growpcy2 RSEworker if wave==1 & comsup2==1, pscore(ps2) bootstrap
attk growpcy2 RSEworker if wave==1 & comsup2==1, pscore(ps2) bootstrap epan
attr growpcy2 RSEworker if wave==1 & comsup2==1, pscore(ps2)  radius(0.1)
attr growpcy2 RSEworker if wave==1 & comsup2==1, pscore(ps2)  radius(0.05)
atts growpcy2 RSEworker if wave==1 & comsup1==1, pscore(ps2) blockid(myblock2) 
  
*** Do the same for per capita expenditure
for num 2/4: gen pccons_waveX=pccons if wave==X
for num 2/4: egen mpccons_waveX=mean(pccons_waveX), by(seq_no)
egen postpccons=rmean(mpccons_wave2 mpccons_wave3 mpccons_wave4)
gen growpccons=postpccons-pccons if wave==1

attk growpccons RSEworker if wave==1 & comsup1==1, pscore(ps1) bootstrap
attk growpccons RSEworker if wave==1 & comsup1==1, pscore(ps1) bootstrap epan
attr growpccons RSEworker if wave==1 & comsup1==1, pscore(ps1)  radius(0.1)
attr growpccons RSEworker if wave==1 & comsup1==1, pscore(ps1)  radius(0.05)
atts growpccons RSEworker if wave==1 & comsup1==1, pscore(ps1) blockid(myblock1) 

attk growpccons RSEworker if wave==1 & comsup2==1, pscore(ps2) bootstrap
attk growpccons RSEworker if wave==1 & comsup2==1, pscore(ps2) bootstrap epan
attr growpccons RSEworker if wave==1 & comsup2==1, pscore(ps2)  radius(0.1)
attr growpccons RSEworker if wave==1 & comsup2==1, pscore(ps2)  radius(0.05)
atts growpccons RSEworker if wave==1 & comsup1==1, pscore(ps2) blockid(myblock2) 
 
  *** Appendix 1 Table: Status by round
 bysort wave: tab RSEpost
 gen newRSE=0
 tsset seq_no wave
 gen lagRSEpost=L.RSEpost
 replace newRSE=1 if RSEpost==1 & lagRSEpost==0
 bysort wave: tab newRSE
gen repeatRSE=0
tsset seq_no wave
gen lagstockRSE=L.stockRSE
gen changestockRSE=stockRSE-lagstockRSE
replace repeatRSE=1 if newRSE==0 & RSEpost==1 & changestockRSE>0 & changestockRSE~=.
bysort wave: tab repeatRSE
 
 

 
 
 #delimit cr
 **** TABLE 4: HOME-IMPROVEMENTS, ASSET OWNERSHIP, ETC.
 *** Make dwelling improvement at all
 egen anydwellingimprove=max(dwellingimprove), by(seq_no)
 egen anyassetpurchase=max(newassetpurchase), by(seq_no)
 
reg laddertoday RSEpost if wave==4 & mps3>=0.1 & mps3<=0.9, robust
outreg2 RSEpost using table4.out, replace
reg laddertoday RSEpost if wave==4 & mps4>=0.1 & mps4<=0.9, robust
outreg2 RSEpost using table4.out, append 

* robustness - check if results holding controlling for recall of ladder before
reg laddertoday RSEpost ladderbefore if wave==4, robust
reg laddertoday RSEpost ladderbefore if wave==4 & mps3>=0.1 & mps3<=0.9, robust
reg laddertoday RSEpost ladderbefore if wave==4 & mps4>=0.1 & mps4<=0.9, robust

  
reg anydwellingimprove RSEpost if wave==4 & mps3>=0.1 & mps3<=0.9, robust
outreg2 RSEpost using table4.out, append 
reg anydwellingimprove RSEpost if wave==4 & mps4>=0.1 & mps4<=0.9, robust
outreg2 RSEpost using table4.out, append 

reg anyassetpurchase RSEpost if wave==4 & mps3>=0.1 & mps3<=0.9, robust
outreg2 RSEpost using table4.out, append 
reg anyassetpurchase RSEpost if wave==4 & mps4>=0.1 & mps4<=0.9, robust
outreg2 RSEpost using table4.out, append 

for var hhbankaccount pigs chickens cattle  s6q1_400-s6q1_423: gen base_X=X if wave==1
for var hhbankaccount pigs chickens cattle  s6q1_400-s6q1_423: egen mbase_X=max(base_X), by(seq_no) 

gen boat=s6q1_419==1|s6q1_418==1
gen base_boat=boat if wave==1
egen mbase_boat=max(base_boat), by(rse_id)

#delimit ;
foreach lhs of varlist hhbankaccount pigs cattle chickens   s6q1_400 s6q1_402 s6q1_403 s6q1_405 s6q1_406 s6q1_409 s6q1_410 boat s6q1_421 s6q1_423 
{;
reg `lhs' RSEpost mbase_`lhs' if wave==4 & mps3>=0.1 & mps3<=0.9, robust;
outreg2 RSEpost using table4.out, append slow(400);
reg `lhs' RSEpost mbase_`lhs' if wave==4 & mps4>=0.1 & mps4<=0.9, robust;
outreg2 RSEpost using table4.out, append slow(400);
};
#delimit cr 


 *** Table 5 - child's education
 use IndividualDataTonga.dta, clear

* New Table 5
reg attend RSEworker mbaseattend baseage if baseage>=6 & baseage<=14 & wave==4, robust
outreg2 RSEworker using table5b.out, replace bdec(3)
reg attend RSEworker mbaseattend baseage if baseage>=6 & baseage<=14 & wave==4 & mps3>=0.1 & mps3<=0.9, robust
outreg2 RSEworker using table5b.out, append bdec(3)
reg attend RSEworker mbaseattend baseage if baseage>=6 & baseage<=14 & wave==4 & mps4>=0.1 & mps4<=0.9, robust
outreg2 RSEworker using table5b.out, append bdec(3)
reg attend RSEworker mbaseattend baseage if baseage>=15 & baseage<=18 & wave==4, robust
outreg2 RSEworker using table5b.out, append bdec(3)
reg attend RSEworker mbaseattend baseage if baseage>=15 & baseage<=18 & wave==4 & mps3>=0.1 & mps3<=0.9, robust
outreg2 RSEworker using table5b.out, append bdec(3)
reg attend RSEworker mbaseattend baseage if baseage>=15 & baseage<=18 & wave==4 & mps4>=0.1 & mps4<=0.9, robust
outreg2 RSEworker using table5b.out, append bdec(3)

sum attend if RSEworker==0 & baseage>=6 & baseage<=14
sum attend if RSEworker==0 & baseage>=6 & baseage<=14 & mps3>=0.1 & mps3<=0.9
sum attend if RSEworker==0 & baseage>=6 & baseage<=14 & mps4>=0.1 & mps4<=0.9

sum attend if RSEworker==0 & baseage>=15 & baseage<=18
sum attend if RSEworker==0 & baseage>=15 & baseage<=18 & mps3>=0.1 & mps3<=0.9
sum attend if RSEworker==0 & baseage>=15 & baseage<=18 & mps4>=0.1 & mps4<=0.9

