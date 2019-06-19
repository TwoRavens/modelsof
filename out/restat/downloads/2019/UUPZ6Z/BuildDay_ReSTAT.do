*clear
clear mata 
clear matrix
set matsize 11000
set maxvar 30000 

cd $directory

**-> Globals
************************************
global cov912  totfelb totmisb  wrstrefb_* refindex                          c.chscr#i.labelfac91 c.rskscr#i.labelfac91  i.labelfac912 rskscr chscr female black hisp agerel i.quarter  recpoolf
global cov913  totfelb totmisb  wrstrefb_* refindex                                                                       i.labelfac912 rskscr chscr female black hisp agerel i.quarter  recpoolf
global cov612  totfelb totmisb  wrstrefb_* refindex  c.rec_out#i.labelfac61  c.chscr#i.labelfac61 c.rskscr#i.labelfac61   i.labelfac613  rskscr chscr female black hisp agerel i.quarter recpoolf
global out tarrest tarrfel tconvict tconvfel anypris
global out1 tarrest1 tarrfel1 tconvict1 tconvfel1 anypris
global supin if quarter>7 & quarter<18
global noncog skills_p skills_r agg_p agg_r att_p att_r noncog_r noncog_p
global shortlist age female black chscr rskscr los prevcom totfelb totmisb
global sample if quarter>7 & quarter<18 & freqlabelFE>50 & labelfac91!=102 & labelfac91!=5 & labelfac91!=14 & labelfac91!=24 & recpoolf==1
global noncog2 agg attitude implsv noncog_r socskill future noncog_p
global covnorsk totfelb totmisb  wrstrefb_1 wrstrefb_2 wrstrefb_3 wrstrefb_4 refindex   chscr female black hisp agerel recpoolf
global covnoch totfelb totmisb  wrstrefb_1 wrstrefb_2 wrstrefb_3 wrstrefb_4 refindex   rskscr female black hisp agerel recpoolf




****** load data ("Probation CAR.dta" is one of the raw files I received and contains all of the probation sample variables minus the PACT info)
use Probation CAR.dta

* add PACT stuff
merge 1:1 RELEASE_YR ID_VAR FILE_TYPE CAR_CPACT using Probation CPACT firstpact.dta, nogen update replace
rename shscr rskscr

* drop variables which are not day treatment facilities
gen day=(type==5.5)
gen PCP03=(type==9)
gen keepz=1 if day==1 |PCP03==1
keep if keepz==1
drop keepz

* clean up labels
do CleanLabelDay_ReSTAT

* do diagnostics, add fixed effects, this includes an identification test
do DayUJT_ReSTAT

* get rid of kids without PACT
drop if RELEASE_YR==607

* gen numzz
sort ID_VAR rec_in rec_out, stable
generate numzz=_n

* recode missing variables
do TidyDay_ReSTAT

* build occupancy variables
do Occupancy_ReSTAT

* generate new recidivism variables
do CrimeTypeDay_ReSTAT

* add factors, indicators, etc
do Factors_ReSTAT

* build the specific noncognitive variables
 do Noncog_Detail_ReSTAT
 
* add PACT post-release
save MasterDay_ReSTAT,replace
do NewPactsDay_ReSTAT
use MasterDay_ReSTAT.dta
merge 1:1 RELEASE_YR ID_VAR FILE_TYPE CAR_CPACT  ///
	using Probation_CPACT_8_ReSTAT.dta,nogen 
drop if type==.
drop if numzz==.

* generate new covariates
gen female=(sex=="F")
la var female "Female"
gen black=(race==4)
la var black "Afr-Am"
gen white=(race==8)
la var white "White"
gen hisp=(ethnicty==2)
la var hisp "Hispanic"
gen losround=round(los/30)
gen violfel3=(wrstrefb==1)
la var violfel3 "MS prior-violent felony"
gen propfel3=(wrstrefb==2)
la var propfel3 "MS prior-property felony"
tab wrstrefb, gen(wrstrefb_)
la var wrstrefb_1 "MS prior-violent felony"
la var wrstrefb_2 "MS prior-property felony"
la var wrstrefb_3 "MS prior-other felony"
la var wrstrefb_4 "MS prior-misdemeanor"
egen rskscr2=std(rskscr)
la var rskscr2 "Own Risk"
egen chscr2=std(chscr)
la var chscr2 "Own CH" 
egen refindex2=std(refindex)
replace gangz_8=1 if gangz_8>0
replace gangz_8=0 if gangz_8<0
gen lastfirst=(lastpact==1&firstpact==1)



*** make measure for number of observations per facility
gen ones=1
sort ID_VAR rec_in
bysort labelclean: egen freqlabel=sum(ones)
la var freqlabel "Frequency for peer overlap"



*build the quarter of exit variable
gen quarters = quarter(rec_out)
gen quarter=.
replace quarter = 1 if quarters==3 & RELEASE_YR==607
replace quarter = 2 if quarters==4 & RELEASE_YR==607
replace quarter = 3 if quarters==1 & RELEASE_YR==607
replace quarter = 4 if quarters==2 & RELEASE_YR==607
replace quarter = 5 if quarters==3 & RELEASE_YR==708
replace quarter = 6 if quarters==4 & RELEASE_YR==708
replace quarter = 7 if quarters==1 & RELEASE_YR==708
replace quarter = 8 if quarters==2 & RELEASE_YR==708
replace quarter = 9 if quarters==3 & RELEASE_YR==809
replace quarter = 10 if quarters==4 & RELEASE_YR==809
replace quarter = 11 if quarters==1 & RELEASE_YR==809
replace quarter = 12 if quarters==2 & RELEASE_YR==809
replace quarter = 13 if quarters==3 & RELEASE_YR==910
replace quarter = 14 if quarters==4 & RELEASE_YR==910
replace quarter = 15 if quarters==1 & RELEASE_YR==910
replace quarter = 16 if quarters==2 & RELEASE_YR==910
replace quarter = 17 if quarters==3 & RELEASE_YR==1011
replace quarter = 18 if quarters==4 & RELEASE_YR==1011
replace quarter = 19 if quarters==1 & RELEASE_YR==1011
replace quarter = 20 if quarters==2 & RELEASE_YR==1011
tab quarter, gen(quarter_)

	

* outsheet variables to build peerRSK peerCH
sort numzz
outsheet numzz chlev* rskscr chscr gangz labelfac61 rec_in rec_out ///
	using ResDay_ReSTAT.csv, comma replace

* outsheet variables to build peer skill measures
sort numzz
outsheet numzz sex_off robbery agg_ass  weapon  burglary auto_theft gralarceny drug_off ass_nonag misdrug_off ///
	petlarceny assault drugtot larceny ///
	using skilltrans_day_ReSTAT.csv, comma replace


********************************************
****** -> go to R, run the master file
********************************************
********************************************
********************************************
********************************************
********************************************
********************************************



merge 1:1 numzz using PeerDay_ReSTAT.dta,nogen 
* Criminal Skills
merge 1:1 numzz using skills_day_ReSTAT.dta,nogen 

* criminal skill interactions
foreach x in sex_off robbery agg_ass  weapon  burglary auto_theft gralarceny drug_off ass_nonag misdrug_off petlarceny assault larceny drugtot{
gen p`x'Y=p`x'*`x'
}
foreach x in sex_off robbery agg_ass  weapon  burglary auto_theft gralarceny drug_off ass_nonag misdrug_off petlarceny assault larceny drugtot{
gen `x'N=(`x'!=1)
gen p`x'N=p`x'*`x'N
}

* standardize
egen peerRSK2=std(peerrsk) 
la var peerRSK2 "Peer Risk"
egen peerCH2=std(peerch) 
la var peerCH2 "Peer CH"
egen ph_gangz2=std(ph_gangz) 
la var ph_gangz2 "Peer Gang"


save MasterDay_ReSTAT.dta, replace





* outsheet data for split sample ID tests
gen use=1 $supin  & freqlabelFE>50 & rskscr!=. 
replace use=. if use==0
gen labelID=labelfac61 if use==1
sort use labelID ID_VAR rec_in, stable
gen numzz2=_n
preserve
drop if use==.
drop labelfac61
encode labelclean, gen(labelfac61)
sort numzz2
outsheet numzz2 rec_in rec_out quarter rskscr2 chscr2 labelID labelfac613 labelfac61 using ///
	IDtestDay_ReSTAT.csv,comma replace
restore

