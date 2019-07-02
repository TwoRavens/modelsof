* British Journal of Political Science
* The Micro-Foundations of Party Competition and Issue Ownership: 


* GERMAN SOCIO-ECONOMIC PANEL (SOEP): Data managment 

* This file allows the following:
* 1. Data merging of raw SOEP data
* 2. Recode all variables used in the article


* -----------------------------------------------------------------------------
* DATA ACCESS: 
* To re-analyze this data set,  it is neccesary to apply for a 
* standard SOEP user contract in order to be granted access to the archived data,
* which can be requested via http://www.diw.de/en/diw_02.c.222836.en/access.html. 
* Here we are using version 24 (DOI: 10.5684/soep.v24). 


* DATA MERGING:
* The SOEP data is available in many single files. You first need to merge the variables
* from the different files into one masterfile.
	sort persnr year
	rename `welle'pbbil02 college 
** RECODING OF VARIABLES
/// Time variable is used in Markov model as count variable. 



* ========================================
** First year included in study

egen min_year = min(year) if pid!=., by(persnr)    /* Gen a variable when respondents were first included in the study,
												    which is later used to determine value of covariates ate t=0   */
																								 										
replace partynew = 0 if pid==0

tab partynew,m


foreach i of any 1 2 3 4 5   {

bysort persnr: gen pid5cat`i' = pid5cat[_n-`i']
lab val pid5cat`i' partylbl
}



foreach i of any 1 2 3 4 5   {

bysort persnr: gen econdev`i' = econdev_dum[_n-`i']

bysort persnr: gen enviro`i' = enviro_dum[_n-`i']
lab val enviro`i' worry

** Exploring Issue salience and party ID

sum  econdev_dum enviro_dum immig_dum crime_dum 

tab pid5cat econdev_dum , row nof
tab pid5cat enviro_dum , row nof
tab pid5cat crime_dum , row nof
tab pid5cat immig_dum , row nof 
 
 
bysort persnr: egen agemin = min(age)
tab sex

tab  psbil
gen educat = psbil
recode educat (-2/-1=.) (1=1) (2=2) (3/4=3) (5=2) (6=1) (7=3) 


tab college
recode college (4=1) (5=2) (6=2)

replace educat=4  if (college==1 |  college==2)  & educat==3

lab def educlbl 1 "Hauptschule: no/lower" 2"Mittlere Reife: Intermediate" ///
3"Abitur: Upper/still in school" 4"Degree"
lab val educat educlbl
tab educat

by persnr: egen bilmax = max(educat)
lab val bilmax educlbl
tab bilmax


tab polint,m
tab polint, nolabel

recode polint (4=1) (3=2) (2=3) (1=4) (-2=.) (-1=.)
*lab def pollbl 1 "not at all interested" 4 "very interested"
label value polint pollbl

tab polint,m

bysort persnr: gen pol1 = polint if year== min_year +1
recode pol1 (.=-2)
bysort persnr: egen polint_ini = max(pol1)
lab var polint_ini "Political interest at t=0"
recode polint_ini (-2=.)
drop pol1

bysort persnr: egen av_polint = mean(polint)
lab var av_polint "Average Political interest"


** Religiosity **

recode church (1=4) (2=3) (3=2) (4=1)

bysort persnr: gen chu1 = church if year== min_year
recode chu1 (.=-2)
bysort persnr: egen chur_ini = max(chu1)
lab var chur_ini "Chruch attendence at t=0"
recode chur_ini (-2=.)
drop chu1

bysort persnr: egen av_church= mean(church)
tab av_church
** Occupation ***

gen class=egp

recode class(1=1) (2=2) (3 4=3) (5 6 11=4) (8=5) (9 10=6) (15=0) (18=7) (-1=.) (-2=0)
replace class = 7 if egp==18


lab var class "New Goldthorpe Class codes incl unempl, pension, and other categories"
lab def egplbl1 1 "Class I" 2 "Class II" 3 "Class III_V" 4 "Class IV" 5 "Class VI" 6 "Class VII" 0"no class - other" 7"Pensioner"
lab val class egplbl1


bysort persnr: gen cla1 = class if year== min_year
recode cla1 (.=-2)
bysort persnr: egen class_ini = max(cla1)
recode class_ini (-2=.)
lab var class_ini "Initial class position at t=0"
lab val class_ini egplbl1
drop cla1

by persnr: egen class_mode= mode(class), minmode
lab val class_mode egplbl1
tab class_mode



**** Valid answers depending on PID ***

gen resp_pid=0
forvalues i = 1984/2007{
  replace resp_pid=1 if year == `i' & pid5cat !=.
  }
bysort persnr : egen sumpid = sum(resp_pid)
tab sumpid,m

drop if sumpid<3 // Only using respondents that have at least 3 valid repsonses


***--------------------------------****
* SAVE WORKING FILE 
***--------------------------------****


save "${outpath}Masterfile_SOEP.dta", replace
