*clear
clear mata 
clear matrix
set matsize 11000
set maxvar 30000 

global directory Path_To_Directory
cd $directory

**-> Globals
************************************
global cov912  totfelb totmisb  wrstrefb_* refindex                          c.chscr#i.labelfac91 c.rskscr#i.labelfac91  i.labelfac912 rskscr chscr female black hisp agerel i.quarter  recpoolf
global cov913  totfelb totmisb  wrstrefb_* refindex                                                                       i.labelfac912 rskscr chscr female black hisp agerel i.quarter  recpoolf
global cov914  totfelb totmisb  wrstrefb_* refindex                         											  i.labelfac912 			female black hisp agerel i.quarter  recpoolf
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


****** load data ("Residential CAR.dta" is one of the raw files I received and contains all of the residential sample variables minus the PACT info)
use "Residential CAR.dta"

* add PACT stuff ("Residential CPACT.dta" is one of the raw files I received and contains the pre-entry PACT info for the residential sample)
merge 1:1 RELEASE_YR ID_VAR FILE_TYPE CAR_CPACT using "Residential CPACT.dta", nogen  
rename shscr rskscr
 

************************************
******* Build covariates ************
************************************


* generate an identifier for each row
sort ID_VAR rec_in rec_out, stable
generate numzz=_n

* clean up labels, outsheet to build peer variables
do CleanLabel_ReSTAT


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

gen ones=1
bysort labelfac912:egen freqlabelFE=total(ones)

* do diagnostic tests add some extra fixed effects - this also runs one of the identification tests
do UJT_ReSTAT

* recode missing variables
do Tidy_ReSTAT

* build crime type variables
do CrimeType_ReSTAT

* figure out average occupancy of each facility
do Occupancy_ReSTAT

* build the indicators, factors and sumary variables
 do Factors_ReSTAT
 
* build the specific noncognitive variables
 do Noncog_Detail_ReSTAT

* add PACT outcome variables
save Master_ReSTAT.dta,replace
do NewPACTs_ReSTAT.do
use Master_ReSTAT.dta
merge 1:1 RELEASE_YR ID_VAR FILE_TYPE CAR_CPACT ///
	using CPACT_1_ReSTAT.dta, nogen 
merge 1:1 RELEASE_YR ID_VAR FILE_TYPE CAR_CPACT  ///
	using CPACT_8_ReSTAT.dta,nogen 

*build time gap between release and outcome PACTs
gen pact1gap=pactdte1-rec_out
*gen pact8gap=pactdte8-rec_out
gen pactgap=rec_in-pactdte
*gen secpact=(pact8gap>90 & pact8gap!=. & noncog_r!=.)
gen frstpact=(pact1gap<90 & pact1gap!=. & noncog_r!=.)


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
gen rec_outsq=rec_out^2
gen rskscr3=rskscr*3
egen rskscr2=std(rskscr)
la var rskscr2 "Own Risk"
egen chscr2=std(chscr)
la var chscr2 "Own CH" 
gen futuresq=future^2
gen future3=(future>=3)
gen future6=(future>=6)
gen los2=rec_out-rec_in
gen non607=(RELEASE_YR==607)
sort non607 labelfac912 numzz
gen numzzperm=_n
egen refindex2=std(refindex)


*** indicator for the number of observations per facility
sort ID_VAR rec_in
bysort labelclean: egen freqlabel=total(ones)


* add zip code data
merge m:m zip1 using "~/Dropbox/Florida/Florida Data/County Data/zipcode.dta", nogen
drop if type==.

*bin the risk scores
gen rsklev=1     if rskscr==0 | rskscr==1 
replace rsklev=2 if rskscr==2 | rskscr==3
replace rsklev=3 if rskscr==4 | rskscr==5
replace rsklev=4 if rskscr==6 | rskscr==7
replace rsklev=5 if rskscr==8 | rskscr==9
replace rsklev=6 if rskscr==10 | rskscr==11
replace rsklev=7 if rskscr==12 | rskscr==13
replace rsklev=8 if rskscr==14 | rskscr==15
replace rsklev=9 if rskscr==16 | rskscr==17 | rskscr==18
tab rsklev, gen(rsklev_)







******************************************
******* Outsheet for Peer Variables  ******************
******************************************

* build peer matrix
sort numzz
outsheet numzz labelfac91 rec_in rec_out ///
	using ResPeerData_ReSTAT.csv,comma replace

* build peer variables for demographics
sort numzz
outsheet numzz black white hisp age ///
	using ResPeerDemo_ReSTAT.csv,comma replace

* outsheet variables to build peer skill measures
sort numzz
outsheet numzz sex_off robbery agg_ass  weapon  burglary auto_theft gralarceny drug_off ass_nonag misdrug_off ///
	petlarceny assault drugtot larceny ///
	using skilltrans_ReSTAT.csv,comma replace

* build peer variables for risk, CH, and factors
sort numzz
outsheet numzz rskscr chscr gang h_drugalc h_schoolprob h_famprob h_trauma rsklev_* ///
	 using ResPeerMain_ReSTAT.csv,comma replace

* build peer variables for noncogs 
sort numzz
outsheet numzz agg implsv attitude socskill future noncog_r noncog_p skills_p skills_r agg_p agg_r att_p att_r ///
	 using ResPeerNoncog_ReSTAT.csv,comma replace


*build distance matrix (distance between home towns)
preserve
drop if RELEASE_YR==607
keep latitude longitude zip1
duplicates drop
outsheet zip1 longitude latitude using ResDistance_ReSTAT.csv,comma replace
restore
sort numzz
outsheet numzz zip1  using ResDistance1_ReSTAT.csv, comma replace

* -->>>>>>>>>>>>>>>>>>>>
******************************************
******* -> go to R files and build peer variables
******************************************

******************************************
******************************************
******************************************



******************************************
**** Merge in peer variables **************
******************************************

* Demographics
merge 1:1 numzz using ResPeerDemos_ReSTAT.dta,nogen 
* Criminal Skills
merge 1:1 numzz using skills_ReSTAT.dta,nogen 
* Peer Risk, CH, Risk Levels, Factors
merge 1:1 numzz using PeerMain_ReSTAT.dta,nogen 
* Peer noncogs
merge 1:1 numzz using peernoncog_ReSTAT.dta,nogen 
* Peer distance variables
merge 1:1 numzz using distance_ReSTAT.dta",nogen 
merge 1:1 numzz using distance15_ReSTAT.dta",nogen 


* generate skill interaction terms
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
egen peerCH202=std(peerch20)   
egen peerRSK202=std(peerrsk20)   
la var peerCH202 "Peer CH, near"
la var peerRSK202 "Peer RSK, near"
egen ph_gangz2=std(ph_gangz)
la var ph_gangz2 "Peer Gang"


foreach x in ph_drugsalc ph_schoolprob ph_famprob ph_trauma {
egen `x'2=std(`x') 
}


foreach x in pnoncog_r pagg pimplsv psocskill pfuture pattitude {
egen `x'2=std(`x') 
}

** label
la var pagg2 "Peer aggression"
la var pattitude2 "Peer antisocial attitude"
la var pimplsv2 "Peer impulsivity"
la var psocskill2 "Peer social skills"
la var pfuture2 "Peer future thinking"


la var ph_drugsalc2 "Peer Drugs/Alcohol"
la var ph_schoolprob2 "Peer School Problems"
la var ph_famprob2 "Peer Unstable Home"
la var ph_trauma2 "Peer Abuse/Trauma"
la var ph_gangz2 "Peer Gang"


la var pattitude2 "Peer Attitude"
la var pagg2 "Peer Agg"
la var pimplsv2 "Peer Implsv"
la var pnoncog_r2 "Peer Noncog_r"
la var psocskill2 "Peer Socskill"
la var pfuture2 "Peer Future"
la var probbery "Peer robbery"
la var plarceny "Peer larceny"
la var pburglary "Peer burglary"
la var pauto_theft "Peer auto theft"
la var pdrug_off "Peer drug"

* aggregate outliers for peer risk levels
gen prsklev7_9=prsklev_7+prsklev_8+prsklev_9
gen prsklev1_2=prsklev_1+prsklev_2


la var prsklev7_9 "Highest risk peers"
la var prsklev1_2 "Lowest risk peers"
la var prsklev_3 "Peer risk lev 4-5"
la var prsklev_4 "Peer risk lev 6-7"
la var prsklev_5 "Peer risk lev 8-9"
la var prsklev_6 "Peer risk lev 10-11"


*** make labels
la var totfelb "Total prior felony charges"
la var totmisb "Total prior misdemeanor charges"
la var mspriora "Most serious prior adj. charge"
la var chscr "Own CH score"
la var rskscr "Own risk score"
la var rec_out "Date of release"
la var tconvict1 "Conviction 1yr post"
la var tconvfel1 "Felony conviction 1yr post"
la var tarrest1 "Arrest 1yr post"
la var tarrfel1 "Felony arrest 1yr post"
la var anypris "Adult or juv. prison 1 yr post"
la var totfadjb "Total prior adjudicated felonies"
la var totmadjb "Total prior adjudicated misdemeanors"
la var refindex "Index of prior crimes"
la var los "Length of stay"
la var age "Age at entry"
la var agerel "Age at release"
la var age "Age at entry"
la var noncog_r "Risky noncog index"
la var h_drugalc "Drugs/Alcohol"
la var h_schoolprob "School Problems"
la var h_famprob "Unstable Home"
la var h_trauma "Abuse/Trauma"
la var h_peers "Gangs/Anti-Social Peers"
la var pblack "Perc Afr-Am"
la var page "Av Age"
la var phisp "Perc Hisp"


* build variables for graphs
gen male=(female==0)
foreach x in prsklev1_2 prsklev_3 prsklev_4 prsklev_5  prsklev_6 prsklev7_9{
gen `x'f=`x'*female
gen `x'm=`x'*male
}

gen lorisk=(rskscr<=5)
gen medrisk=(rskscr>5 & rskscr<10)
gen hirisk=(rskscr>=10)
foreach x in prsklev1_2 prsklev_3 prsklev_4 prsklev_5  prsklev_6 prsklev7_9{
gen `x'lo=`x'*lorisk
gen `x'med=`x'*medrisk
gen `x'hi=`x'*hirisk
}



save Master_ReSTAT.dta, replace


******************************************
******* Build data for permutation  ***********
******************************************

* make a little data set for doing permutation tests in R
* need to be certain the dataset (oldf) is ordered by labelfac912
preserve
drop if RELEASE_YR==607
sort labelfac912 numzzperm
outsheet  rec_in rec_out labelfac91 freqlabelFE $out1 numzzperm pact1gap los2 noncog_r_final2 noncog_rr noncog_p_final2 noncog_pr totfelb totmisb  wrstrefb refindex  labelfac912 peerRSK2 peerCH2  county rskscr chscr female black hisp agerel  recpoolf ///
	using Permu_ReSTAT.csv, replace comma
restore


******************************************
******* Build data for ID tests *********
******************************************

gen use=.
replace use=1 $supin  & freqlabel>50 & rskscr!=. & RELEASE_YR!=607
replace use=. if labelfac91==102 | labelfac91==5 | labelfac91==14 | labelfac91==24
gen labelID=labelfac912 $supin & recpoolf==1 & freqlabel>50
replace labelID=. if use==.
sort use labelID ID_VAR rec_in, stable
gen numzz2=_n

preserve
drop if use==.
drop labelfac91
encode(labelclean), gen(labelfac91)
tab labelfac91
distinct(labelfac91)
sort numzz2
outsheet numzz2 rec_in rec_out quarter rskscr2 chscr2 labelID labelfac91 labelfac912 using IDtest_ReSTAT.csv",comma replace
restore







