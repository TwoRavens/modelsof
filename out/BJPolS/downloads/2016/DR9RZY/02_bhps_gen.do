log using $log/bhps_gen, replace 

/* 	02_bhps_gen.do :

	This file creates the analysis datasets. 
	
	This file calls 02a_opid_recode which fixes data entry errors. 

	This file saves several datasets in the $cleandta folder:
		height.dta
		height1416.dta
		height_youth.dta
		height1416_youth.dta  

	It also saves bs_dataset.dta (for use in bootstrapping), in $bootstrap.	  */ 

	
set seed 54321 
		
local lastwave 18


local varstokeep 	pid pno hid wave buno butype region* movest		 												///
					fiyr fiyrb fihhyr age xw_sex xw_race* xw_doby mastat mlstat mlchng hgspn orgmb 					///
					vote* *hgs *qf* school *end *enow *edhi tuin1 jbrgsc jlrgsc ghq* hlprb* hl2* hl* ph* 			///
					op* jb* js* aidhrs howlng lfsat* wind* hlh* hsval* hsow* hs2val* mgtot nvest* svac* debt* fieq* ///
					doi* julk* jlend* lfimp* qlf* fisit* f1* hl* hosp* hgest hgemp trust norg* xw_plbornc lad* 		///
					lrw* lew* hhw* xhw* xrw* xew* prrs2i bhps ukhls hhorig eprosh risk*


use `varstokeep' using $cleandta/complete_bhps.dta , clear 	// To drop proxy respondents, specify: if prrs2i == -8 


gen year=wave+1990



****** DEPENDENT VARIABLES	

/* For "Supports Conservative" we follow the BHPS strategy for their generated variable -vote- , but fill in information given by 
 proxy respondents.  */
	
gen cvote=. /* missing or wild, refused, proxy respondent, can't vote are all coded as missing */
replace cvote=1 if vote4==1 | vote3==1  /* Supports Conservative party */
replace cvote=0 if inrange(vote4,2,8) | inrange(vote3,2,8) | vote4==10 | vote3==10  /*  Supports labour, lib dem/lib/sdp, 
										scot nat, plaid cymru, green party, other answer, other party, none, */
replace cvote=1 if vote4==12 | vote3==12 /* For Northern Ireland subsample, code as conservative if support Ulster Unionist,
								 which is the most conservative Northern Ireland party as reported by Benoit Laver (2006)*/
replace cvote=0 if inrange(vote4,13,17) | inrange(vote3,13,17) /* For Northern Ireland subsample: SDLP, Alliance Party, 
								Democratic Unionist, Sinn Fein, other party */
label var cvote "Supports Conservative party"	

/* Turnout is turnout in previous general election.  For wave 14 this corresponds to 2001 election, and for wave 16 it's 2005 election.
Online questionnaire erroneously says 2005 turnout not asked until wave 17. */
gen turnout = vote7==1 if inrange(vote7,1,2)  /*proxy respondent, refused, don't know, and can't vote coded as missing*/
replace turnout=. if wave==15 /*turnout question for 2005 election not asked until 2006 survey*/
sort pid wave
replace turnout=turnout[_n+1] if wave==15 & pid==pid[_n+1] & pid!=. & pid!=-8
label var turnout "Voter Turnout (Previous General Election)" 

* Election Year?  
gen electionyear=inlist(year,1992,1997,2001,2005,2010)

* convote is voted Conservative previous general election.   
gen convote=. /* No turnout, missing or wild, refused, proxy respondent, don't know, are coded as missing */
replace convote=1 if vote8==1  /* Voted for Conservative party */
replace convote=0 if inrange(vote8,2,11)  /* Voted labour, lib dem/lib/sdp, scot nat, plaid cymru, green party, other party, other answer */
replace convote=1 if vote8==12 /* Northern Ireland: voted for Ulster Unionist */
replace convote=0 if inrange(vote8,13,17)  /* Northern Ireland: voted for SDLP, Alliance Party, Democratic Unionist, Sinn Fein, other party */
label var convote "Voted Conservative (Previous General Election)" 



/* For policy/attitude variables, we use the 5-pt ordinal measures of strength of belief, and also create a dummy for "strongly agree"/"agree".
	 missing, "refused", proxy, and "can't choose" are coded as missing.  BHPS counterintuitively uses a numeric code of strength of support
	 for a statement that is increasing in disagreement, so we reverse the order and center 0 at neither agree/disagree.  */

* opsocc (waves 1 3 5 7 10 14 17) : "Private enterprise is the best way to solve the UK's economic problems" 
gen peo=opsocc if opsocc>0
* opsocd (waves 1 3 5 7 10 14 17) : "Major public services and industries ought to be in state ownership" 
gen pso=opsocd if opsocd>0
* opsoce (waves 1 3 5 7 10 14 17) : "It is the government's responsibility to provide a job for everyone who wants one" 
gen gjo=opsoce if opsoce>0
* oppolc (waves 2 4 6 8 11 13 16) : "The government should place an upper limit on the amount of money that any one person can make" 
gen ulo=oppolc if oppolc>0

label define strongagreedisagree 2 "Strongly agree" 1 "Agree" 0 "Neither agree/disagree" -1 "Disagree" -2 "Strongly disagree"
label define agreedisagree 1 "Agree" 0 "Disagree"

foreach type in pe ps gj ul {
	recode `type'o (1=2) (2=1) (3=0) (4=-1) (5=-2) (else=.) 
	label values `type'o strongagreedisagree
	gen `type'd = inrange(`type'o,1,2) if !missing(`type'o)	
	label values `type'd agreedisagree
}

foreach suffix in o d {
label var pe`suffix' "Private enterprise solves economic problems" 
label var ps`suffix' "Public services ought to be state owned"	
label var gj`suffix' "Govt. has obligation to provide jobs"	
label var ul`suffix' "Govt. ought impose earnings ceiling"	
}
		
		
		
*	CONTROL VARIABLES

gen female=xw_sex==2  /* Use xw_ vars for time-invariant characteristics, such as sex.  
						 BHPS also includes a "last known sex" variable, which is identical in our sample. */
gen male=xw_sex==1  
label var female "Female"  
label var male "Male" 

replace age=. if age<0   
replace age=(1990+wave)-xw_doby if missing(age) & xw_doby>0  /* Recover missing age from dob (1 ob) */
tempvar age_ipolate
bys pid: ipolate age wave , epolate gen(`age_ipolate') /* Recover 5 missing obs from one individual who occasionally refuses to report her age */
replace age=`age_ipolate'
label var age "Age" 

/*Defining Prime Age sample: Chandler and Bock (1991) use data from Western Australia to find that female peak height at 26.8 years
	while male peak height is reached at 21.4 years.  Case and Paxson (2008) note that peak height
	for disadvantaged males may not be reached by adolescence -- they cite age 33.  We use the latter. */
gen prime_age=inrange(age,33,65) if !missing(age)

gen white=0 
replace white=1 if xw_race==1 | inrange(xw_racel,1,5)  
label var white "White" /* Code "white" when respondent identifies as white and 0 otherwise, instead of dropping when missing(race) or missing(racel).
						   Over 95 percent of the sample is white.  Note: racel is a more variegated indicator for ethnicity, asked in waves 13-18. */

						   
/* Marital status: The BHPS allows us to distinguish between "married" as self-identified (mastat=="married" or "living as couple")
					vs. legally married (mlstat). */

gen married = inrange(mastat,1,2)  /* There are 329 "legally married" obs (mlstat==1) that do not self identify as married or living 
									   as couple in that wave. */		
gen married_mastat	= mastat==1    /* For use when we dummy out all marital status categories */
gen livingascouple 	= mastat==2
gen widowed			= mastat==3
gen divorced		= mastat==4
gen separated		= mastat==5

gen married_legal	= mlstat==1
gen separated_legal	= mlstat==2
gen divorced_legal 	= mlstat==3
gen widowed_legal   = mlstat==4

label var married "Married"   
label var married_mastat "Married"   
label var married_legal "Married" 	
label var livingascouple "Living as Couple"
label var widowed "Widowed"
label var widowed_legal "Widowed"
label var divorced "Divorced"
label var divorced_legal "Divorced"
label var separated "Separated"
label var separated_legal "Separated"


* Use married rather than married_legal to define spouse, to be able to identify effect of legal status
gen wife=(female==1 & married==1) if !missing(married)
gen husband=(male==1 & married==1) if !missing(married)
gen single=married==0 if !missing(married)



/* Parents' occupation */
gen father_hg=xw_pahgs if xw_pahgs>=0 
gen mother_hg=xw_mahgs if xw_mahgs>=0 
label var father_hg "Father's Hope-Goldthorpe level" 									   
label var mother_hg "Mother's Hope-Goldthorpe level" 									   

/* Parents' education: only asked in Wave 13 */
bys pid: egen dad_school = max(paedhi)  
replace dad_school=. if dad_school<0 
bys pid: egen mom_school = max(maedhi) 
replace mom_school=. if mom_school<0 
								
label var dad_school "Father's schooling" 
label var mom_school "Mother's schooling" 
								
								
								
/* EDUCATION */

	* Following Case et al. (2009), we recode education into a 7 point ordinal variable 
tempvar case
gen `case'=qfachi if qfachi>0 
recode `case' (1=6) (2=5) (3=4) (4=3) (5=2) (6=1) (7=0), gen(edu_case_etal) 
label define edu_case_etal 6 `"higher degree"', modify 
label define edu_case_etal 5 `"1st degree"', modify 
label define edu_case_etal 4 `"hnd,hnc,teaching"', modify 
label define edu_case_etal 3 `"a level"', modify 
label define edu_case_etal 2 `"o level"', modify 
label define edu_case_etal 1 `"cse"', modify 
label define edu_case_etal 0 `"none of these"', modify 
label values edu_case_etal edu_case_etal 

	* Following Oswald and Powdthavee (2010), we code higher and first degrees 
gen higher_degree=. 
replace higher_degree=1 if qfachi==1 
replace higher_degree=1 if qfachi==7 & qfedhi==1  /* 'none of these' in qfachi, but response in qfedhi*/
replace higher_degree=1 if qfachi==. & qfedhi==1  /* missing in qfachi, but response in qfedhi*/
replace higher_degree=1 if qfachi==-7 & qfedhi==1  /*proxy respondents for qfachi, but response in qfedhi*/

replace higher_degree=0 if inrange(qfachi,2,6) 
replace higher_degree=0 if qfachi==7 & inrange(qfedhi,2,13) 
replace higher_degree=0 if qfachi==. & inrange(qfedhi,2,13) 
replace higher_degree=0 if qfachi==-7 & inrange(qfedhi,2,13) 

gen first_degree=. 
replace first_degree=1 if qfachi==2 
replace higher_degree=1 if qfachi==7 & qfedhi==2 
replace higher_degree=1 if qfachi==. & qfedhi==2 
replace higher_degree=1 if qfachi==-7 & qfedhi==2 

replace first_degree=0 if qfachi==1 | inrange(qfachi,3,6) 
replace first_degree=0 if qfachi==7 & qfedhi==1 | inrange(qfedhi,3,13) 
replace first_degree=0 if qfachi==. & qfedhi==1| inrange(qfedhi,3,13) 
replace first_degree=0 if qfachi==-7 & qfedhi==1| inrange(qfedhi,3,13) 

label var higher_degree "Higher degree" 
label var first_degree "First degree" 

	/* We add A-level and other post-GCSE/O-Level Qualifications*/
gen a_level=. 
replace a_level=1 if qfachi==3 | qfachi==4 

*NOTE: we take a conservative approach by coding the following individuals (with further qualifications) as having a_level==0 
replace a_level=0 if qfachi==7 & inrange(qfedhi,3,6)  /* 'none of these' in qfachi but further qualification in qfedhi: other, teaching, nursing*/
replace a_level=0 if qfachi==. & inrange(qfedhi,3,6)  /*further qualifications in qfedhi but missing in qfachi*/
replace a_level=0 if qfachi==-7 & inrange(qfedhi,3,6)  /*further qualifications in qfedhi but proxy in qfachi*/

replace a_level=0 if inrange(qfachi,1,2) | inrange(qfachi,5,6) 
replace a_level=0 if qfachi==7 & inrange(qfedhi,1,2) | inrange(qfedhi,7,13) 
replace a_level=0 if qfachi==. & inrange(qfedhi,1,2) |inrange(qfedhi,7,13) 
replace a_level=0 if qfachi==-7 & inrange(qfedhi,1,2) | inrange(qfedhi,7,13)  

label var a_level "A levels" 

/*Highest Educ Qualification-- has more complete data than qfachi, to be used in recovering missing years of schooling*/
gen edqual=. 
replace edqual=qfedhi if qfedhi>=1 


* Years of schooling  

	* Following Dickson (2008) and Hildreth (1999), we construct yrs of schooling as "school leaving age"-5 


foreach var in scend feend {  /* Age left school ... we use this to generate yrs of schooling, and fill in where missing or implausibly 
									high by using the average yrs of schooling for person's reported educational qualification*/
	gen new`var' = `var' if `var'>0
}

egen ageleaveschool=rowmax(newscend newfeend) /* rowmax ignores the missing value*/
replace ageleaveschool=age if jbstat==6  /* those who are full-time students*/

replace ageleaveschool=5 if school==1 & !inrange(qfedhi,1,13) /*Some obs report never went to school but also report a qual; */
								/*here we restrict assigning 0 yos only to those who do not report some other form of qualification*/
gen yrs_school=ageleaveschool-5  

* Carry forward values from wave 1, etc
sort pid wave
replace yrs_school=yrs_school[_n-1] if yrs_school==. & pid==pid[_n-1] 
* For those who still have missing yrs_school values, we replace using mean value for their reported level of educational qual
tempvar newyrschool	edqualmeanyos	
gen `newyrschool'=yrs_school if yrs_school<22 
bys edqual: egen `edqualmeanyos'=mean(`newyrschool') /*for missing yrs_school we assign mean for that level of educational qualif */
replace yrs_school = `edqualmeanyos' if missing(`newyrschool') & !missing(edqual) 

* For obs where we generated yrs_school using edqual: carry back to earlier & later waves 
sort pid wave
replace yrs_school=yrs_school[_n-1] if yrs_school==. & pid==pid[_n-1] 
replace yrs_school=yrs_school[_n-2] if yrs_school==. & pid==pid[_n-2] 
replace yrs_school=yrs_school[_n+1] if yrs_school==. & pid==pid[_n+1] 
replace yrs_school=yrs_school[_n+2] if yrs_school==. & pid==pid[_n+2] 

replace yrs_school = 21 if yrs_school>21 & !missing(yrs_school) /*Dickson (2008: 22-23) drops yos > 22, here instead we cap.  */
label var yrs_school "Years of schooling" 


* GCSEs (proxy measure of cognitive ability)
* Did respondent report passing any GCSEs/O-Levels?
gen gcse=.
replace gcse=0 if inlist(0,qfedb,qfedc,qfedd,qfede,qfedf,qfedg,qfedh,qfedk)
replace gcse=1 if inlist(1,qfedb,qfedc,qfedd,qfede,qfedf,qfedg,qfedh,qfedk)  /* Low or high pass */

bys pid: egen maxgcse=max(gcse)
drop gcse
rename maxgcse gcse
label var gcse "Reports having any GCSE/O-Levels"

/* There are different exams used in Scotland, and the type changed over time, but BHPS coding is mostly consistent.
	The BHPS unfortunately does not record actual score.  This is a problem when coding the CSE, which was an exam administered between
	1965-1987, targeted at non-elite students.  A score of 1 was equivalent to an O-level of A-C, which is fine as BHPS records both as
	"high pass".  But, only a CSE score of 2-3 is equivalent to O-level D-E, while BHPS records only whether respondent received a 2-5 on CSE.
	High passes: 	nqfede:  Post-1988 GCSEs with score of A-C
					nqfedc:  Between 1965-1987 [England, Wales, N Ireland] CSE's with score of 1
					nqfedf:  Pre-1975 O-level [does not distinguish high pass, but qfachi documents this score as high pass]	
					nqfedg:  Post-1975 O-levels with score of A-C
					nqfedl:  Scottish O-grades with score of A-C
	Low passes: 	nqfedd:  Post-1988 GCSE with score of D-G
					nqfedb:  Between 1965-1987 [England, Wales, N Ireland] CSE's with score of 2-5
					nqfedh:	 Post-1975 O-level with score of D-E
					nqfedk:	 Scottish O-grades with score of D-E
	We code the # of GCSE high and low passes, as well as a categorical variable 
	that takes 0 for none, 1 for 1-4 high/low passes, and 2 for 5 high/low passes. 
	Five GCSEs passed is the standard for entering university.  */
 
*  # of High Passes on GCSE
gen gcse_highpasses=0
foreach gcsetype in nqfede nqfedc nqfedf nqfedg nqfedl {
	replace gcse_highpasses=gcse_highpasses+`gcsetype' if `gcsetype'>=1 & !missing(`gcsetype') 
}

* # of Low Passes on GCSE
gen gcse_lowpasses=0
foreach gcsetype in nqfedd nqfedb nqfedh nqfedk {
	replace gcse_lowpasses=gcse_lowpasses+`gcsetype' if `gcsetype'>=1 & !missing(`gcsetype')
}

foreach gcsetype in gcse_highpasses gcse_lowpasses {
	bys pid: egen max`gcsetype'=max(`gcsetype')
	drop `gcsetype'
	rename max`gcsetype' `gcsetype'
	replace `gcsetype'=. if missing(gcse)
	}

egen gcse_passes=rowtotal(gcse_highpasses gcse_lowpasses) , missing
gen gcse_points=gcse_highpasses*6.5 + gcse_lowpasses*2.5
label var gcse_passes 		"GCSE Passes"
label var gcse_highpasses 	"GCSE High Passes"
label var gcse_lowpasses 	"GCSE Low Passes"
label var gcse_points 		"GCSE Points"


/* Health Status  
		We code by summing the 13 health problems faced by the respondent.  These are:
(1) Problems/disability connected with: arms, legs, hands, feet, back, or neck (including arthritis and rheumatism) 
(2) Difficulty in seeing (other than needing glasses to read normal size print) 
(3) Difficulty in hearing 
(4) Skin conditions/allergies 
(5) Chest/breathing problems, asthma, bronchitis
(6) Heart/blood pressure or blood circulation problems 
(7) Stomach/liver/kidneys 
(8) Diabetes 
(9) Anxiety, depression or bad nerves 
(10) Alcohol or drug related problems 
(11) Epilepsy 
(12) Migraine or frequent headaches 
(13) Other health problems. */
* note that in wave 11 they additionally asked about cancer and stroke (hlprbn and hlprbo), but since these questions were not asked consistently over time we do not include them ehre.


foreach x in a b c d e f g h i j k l m {
	local health_`x' : variable label hlprb`x' 
	gen healthproblem_`x' = hlprb`x'==1 if hlprb`x' >=0 
	label var healthproblem_`x' "`health_`x''"
	}

egen healthproblems=rowtotal(healthproblem_a - healthproblem_m) , missing

egen healthproblems_ukhls=rowtotal(healthproblem_a healthproblem_b healthproblem_c healthproblem_e ///
	healthproblem_f healthproblem_g healthproblem_h healthproblem_k ) , missing /* ukhls doesn't ask all of the health questions*/

label var healthproblems  "Health problems (0-13)"
label var healthproblems_ukhls "Health problems (0-8)"


/* MENTAL HEALTH GHQ Mental Health Score */

foreach x in a b c d e f g h i j k l {
	gen ghq_`x'= inrange(ghq`x',3,4) if ghq`x'>0 
}
egen ghqscore=rowtotal(ghq_a-ghq_l), missing
label var ghqscore "GHQ Mental Health"


/* REGION */			

/*  Missing region: --region-- is not recorded for 330 indivs in wave 14, while 19 are missing region in wave 16. */
replace region=. if region<0 

/* Due to missings, we use --region2-- (Government Office Region, GOR) to --region--.  For a very small number of obs, there is a conflict.  
For instance, there are 8 obs that report Scotland for region but report English locations for region2.  
Use http://www.communities.gov.uk/documents/planningandbuilding/pdf/150268.pdf to crosswalk. */
gen newregion=region2 
label values newregion aregion2  
replace newregion=. if newregion<0 

replace newregion=7 if newregion==. & (region==1 | region==2) /* 'Inner' and 'Outer' London go to London GOR */
replace newregion=8 if newregion==. & region==3   /* 'Rest of Southeast' goes to Southeast GOR */
replace newregion=9 if newregion==. & region==4   /* 'Southwest' goes to Southwest England GOR */
replace newregion=6 if newregion==. & region==5   /* 'East Anglia' goes to East of England GOR */
replace newregion=4 if newregion==. & region==6   /* 'East Midlands' goes to East Midlands GOR */
replace newregion=5 if newregion==. & region==7  /* 'West Midlands conurbation' goes to West Midlands GOR */ 
replace newregion=2 if newregion==. & region==9  /* 'Greater Manchester' goes to North West GOR  */
replace newregion=2 if newregion==. & region==10  /* 'Merseyside' goes to North West GOR  */
replace newregion=2 if newregion==. & region==11  /* 'Rest of Northwest' goes to North West GOR */
replace newregion=3 if newregion==. & region==12  /* 'South Yorkshire' goes to Yorkshire and the Humber GOR */
replace newregion=3 if newregion==. & region==13  /* 'West Yorkshire' goes to Yorkshire and the Humber GOR */
replace newregion=3 if newregion==. & region==14  /* 'Rest of Yorkshire and Humber' goes to Yorkshire and the Humber GOR*/
replace newregion=1 if newregion==. & region==15  /* 'Tyne and Wear' goes to North East GOR*/
replace newregion=1 if newregion==. & region==16   /* 'Rest of North' goes to North East GOR -- this is a guess since the category also maps to North West*/
replace newregion=10 if newregion==. & region==17   /* 'Wales' goes to Wales GOR */
replace newregion=11 if newregion==. & region==18  /* 'Scotland' goes to Scotland GOR */
replace newregion=12 if newregion==. & region==19   /*Northern Ireland*/


/*  Missing region2: region2 is not recorded for 61 indivs in wave 14, while only 32 are missing in wave 15, and 24 are missing region in wave 16. 
To recover the likely region for the remaining missings, we replace if the individual indicates they did not move in intervening period.*/
 
sort pid wave
replace newregion=newregion[_n-1] if newregion==. & movest==1 & pid==pid[_n-1] 
replace newregion=newregion[_n-2] if newregion==. & movest==1 & movest[_n-1]==1 & pid==pid[_n-1] & pid==pid[_n-2] 
replace newregion=newregion[_n-3] if newregion==. & movest==1 & movest[_n-1]==1 & movest[_n-2]==1 & pid==pid[_n-1] & pid==pid[_n-2] & pid==pid[_n-3] 
replace newregion=newregion[_n-4] if newregion==. & movest==1 & movest[_n-1]==1 & movest[_n-2]==1 & movest[_n-3]==1 /*
*/ & pid==pid[_n-1] & pid==pid[_n-2] & pid==pid[_n-3] & pid==pid[_n-4]

replace newregion=newregion[_n+1] if newregion==. & movest==1 & pid==pid[_n+1] 
replace newregion=newregion[_n+2] if newregion==. & movest==1 & movest[_n+1]==1 & pid==pid[_n+1] & pid==pid[_n+2] 
replace newregion=newregion[_n+3] if newregion==. & movest==1 & movest[_n+1]==1 & movest[_n+2]==1 & pid==pid[_n+1] & pid==pid[_n+2] & pid==pid[_n+3] 
replace newregion=newregion[_n+4] if newregion==. & movest==1 & movest[_n+1]==1 & movest[_n+2]==1 & movest[_n+3]==1 /*
*/ & pid==pid[_n+1] & pid==pid[_n+2] & pid==pid[_n+3] & pid==pid[_n+4]

gen england=.  
	replace england=1 if inrange(newregion,1,9) 
	replace england=0 if inrange(newregion,10,12) 
gen wales=. 
	replace wales=1 if newregion==10 
	replace wales=0 if inrange(newregion,1,9) | inrange(newregion,11,12) 
gen scotland=. 
	replace scotland=1 if newregion==11 
	replace scotland=0 if inrange(newregion,1,10) | newregion==12  
gen northern_ireland=. 
	replace northern_ireland=1 if newregion==12 
	replace northern_ireland=0 if inrange(newregion,1,11) 
label variable england "England" 
label variable scotland "Scotland" 
label variable wales "Wales" 
label variable northern_ireland "Northern Ireland" 

drop if england==.  /* Dropping Channel Islands (region2==13), which are not part of UK */

* Generate region dummies for use in gender gap tables
tab newregion, gen(newregion)
label var newregion1 "North East GOR"
label var newregion2 "North West GOR"
label var newregion3 "Yorkshire & the Humber GOR"
label var newregion4 "East Midlands GOR"
label var newregion5 "West Midlands GOR"
label var newregion6 "East Anglia GOR"
label var newregion7 "London GOR"
label var newregion8 "Southeast GOR"
label var newregion9 "Southwest GOR"
label var newregion10 "Wales"
label var newregion11 "Scotland"
label var newregion12 "Northern Ireland"


/* RELIGION 	
	Religion is asked in different questions for different subsamples depending on the wave.
		England, Scotland, Wales: oprlg1 is asked in waves 1 7 9 14 18
		Northern Ireland: oprlg1 is asked in waves 7 9 11 14 and oprlg5 is asked in waves 13 15 16 17 18. */

/*	oprlg1: Some of these categories were recoded over the years.  For example, Hindu and Sikh are given the same code in different waves.  
Fortunately, we aggregate to a level that absorbs these differences. */
label define religion  -9 "missing or wild"
label define religion  -8 "inapplicable" , add  
label define religion  -7 "proxy respondent" , add      
label define religion  -2 "refused" , add
label define religion  -1 "don't know /didn't answer" , add    
label define religion   1 "no religion" , add   
label define religion   2 "c of e /anglican" , add      
label define religion   3 "roman catholic" , add
label define religion   4 "presbyt/c of scot" , add    
label define religion   5 "methodist" , add     
label define religion   6 "baptist" , add
label define religion   7 "congregation/urc" , add      
label define religion   8 "other christian" , add
label define religion   9 "christian" , add     
label define religion  10 "muslim/islam (other christian in wave 14)" , add
label define religion  11 "hindu" , add 
label define religion  12 "jewish (muslim/islam in wave 14)" , add
label define religion  13 "sikh (hindu in wave 14)" , add
label define religion  14 "other" , add   
label define religion  15 "sikh (wave 14)" , add
label define religion  16 "other (wave 14)" , add
label define religion  17 "Catholic (NI)" , add
label define religion  18 "Presbyterian (NI)" , add 
label define religion  19 "Church of Ireland (NI)" , add
label define religion  20 "Methodist (NI)" , add
label define religion  21 "Baptist (NI)" , add
label define religion  22 "Free Presb. (NI)" , add
label define religion  23 "Brethren (NI)" , add
label define religion  24 "Protestant nes (NI)" , add
label define religion  25 "Other Christian (NI)" , add
label define religion  26 "Jewish (NI)" , add
label define religion  27 "Other non-Christian (NI)" , add

gen religion=oprlg1 if oprlg1>0
label values religion religion


/* Consolidate religion questions for Northern Ireland subsample.  In all cases, the existing value for oprlg1 is missing or inapplicable. 
oprlg5 (Denomination):
          -9 missing or wilds
          -8 not applicable 
          -7 proxy respondent       
          -2 refused
          -1 don't know     
           1 catholic       
           2 presbyterian   
           3 church of ireland      
           4 methodist      
           5 baptist
           6 free presbyterian      
           7 brethren       
           8 protestant - not specified     
           9 other christian
          10 jewish 
          11 other non-christian    
          12 no religion 
		  13 islam (waves 16 & 18)
		  15 other non-christian religion (waves 17 & 18)
		  16 no religion (waves 17 & 18)   */ 
 
replace religion = 17 if oprlg5 == 1  & northern_ireland==1  /* Catholic */
replace religion = 18 if oprlg5 == 2  & northern_ireland==1  /* Presbyterian */
replace religion = 19 if oprlg5 == 3  & northern_ireland==1  /* Church of Ireland */
replace religion = 20 if oprlg5 == 4  & northern_ireland==1  /* Methodist  */
replace religion = 21 if oprlg5 == 5  & northern_ireland==1  /* Baptist */
replace religion = 22 if oprlg5 == 6  & northern_ireland==1  /* Free Presbyterian */
replace religion = 23 if oprlg5 == 7  & northern_ireland==1  /* Brethren */
replace religion = 24 if oprlg5 == 8  & northern_ireland==1  /* Protestant (not specified) */
replace religion = 25 if oprlg5 == 9  & northern_ireland==1  /* Other Christian */
replace religion = 26 if oprlg5 == 10 & northern_ireland==1  /* Jewish */
replace religion = 27 if ( oprlg5 == 11 | oprlg5 == 15 ) & northern_ireland==1  /* Other non-Christian */
replace religion = 1 if ( oprlg5 == 12 | oprlg5 == 16 ) & northern_ireland==1   /* No religion */
replace religion = 10 if oprlg5 == 13 & northern_ireland==1  /* Islam */
	
/* Religion questions are not asked in all waves.  We assign values in the following order of precedence:
		1. The most recent previous wave.
		2. The closest subsequent wave.
		3. Later subsequent waves.
		4. Waves prior to the most recent one in which religion is asked.   

		We code missing, proxy respondent, "don't know" and "refused" as missing.  */

		
foreach num of numlist 1 7 9 11 13/18 { 
	gen rel_wave`num' = religion if wave==`num' 
	bys pid: egen maxrel_wave`num' = max(rel_wave`num') 
}
foreach num of numlist 1 7 9 14 18 { 
	replace religion = maxrel_wave`num' if inrange(wave,1,6) & religion==. & northern_ireland==0 
}
foreach num of numlist 7 9 14 18 1 { 
	replace religion = maxrel_wave`num' if inrange(wave,7,9) & religion==.  & northern_ireland==0 
} 
foreach num of numlist 9 14 18 7 1 { 
	replace religion = maxrel_wave`num' if inrange(wave,10,14) & religion==. & northern_ireland==0 
} 
foreach num of numlist 14 18 9 7 1 { 
	replace religion = maxrel_wave`num' if inrange(wave,15,17) & religion==. & northern_ireland==0 
} 

/*NORTHERN IRELAND*/	
/* N Ireland subsample must be aggregated differently since it is surveyed about religion more frequently */	
	* religion only asked of entire northern ireland sample in wave 18 (asked only of new entrants)

foreach num of numlist 7 9 11 13/18 { 
	replace religion = maxrel_wave`num' if inrange(wave,7,9) & religion==. & northern_ireland==1 
	} 
foreach num of numlist 9 11 13/18 7 { 
	replace religion = maxrel_wave`num' if wave==10 & religion==. & northern_ireland==1 
	} 
foreach num of numlist 11 13/18 9 7 { 
	replace religion = maxrel_wave`num' if inrange(wave,11,12) & religion==. & northern_ireland==1 
	}	
/* For NI, they ask religion only of new NI respondents for waves 13, 15, 16, 17 so we recover existing NI sample members'
 religion from waves in which everyone is asked. */
foreach num of numlist 11 14 18 9 7 { 
	replace religion = maxrel_wave`num' if inrange(wave,13,14) & religion==. & northern_ireland==1 
	}	
foreach num of numlist 14 18 9 7 11 { 
	replace religion = maxrel_wave`num' if wave==15 & religion==. & northern_ireland==1 
	}	
foreach num of numlist 14 18 9 7 11 15 { 
	replace religion = maxrel_wave`num' if wave==16 & religion==. & northern_ireland==1 
	}	
foreach num of numlist 14 18 9 7 11 16 15 { 
	replace religion = maxrel_wave`num' if inrange(wave,17,18) & religion==. & northern_ireland==1 
	}	
	
gen no_religion = .  
	replace no_religion=1 if religion==1 | religion==-2 | religion==-1 
	replace no_religion=0 if inrange(religion,2,27) 
gen catholic = . 
	replace catholic=1 if religion==3 | religion==17 
	replace catholic=0 if inrange(religion,-2,27) & religion~=3 & religion~=17 
gen non_christian = .    /* non_christian includes muslim, hindu, sikh, jewish, other non-christian */
	replace non_christian=1 if inrange(religion,11,16) | religion==27 | (wave~=14 & religion==10) 
	replace non_christian=0 if inrange(religion,-2,9) | inrange(religion,17,26) | (wave==14 & religion==10)  
gen nc_christian = . 
	replace nc_christian=0 if no_religion==1 | catholic==1 | non_christian==1 
	replace nc_christian=1 if no_religion==0 & catholic==0 & non_christian==0 
label var no_religion "No religion"  
label var non_christian "Non Christian" 
label var catholic "Catholic" 
label var nc_christian "Non-Catholic Christian" 


   

	/*		INCOME	
For income, we use the derived/imputed variables provided by the BHPS, rather than aggregating ourselves.  Alternatives are
to use fiyhhl and fihhynl (household) and fiyrl and fiyrnl (individual).  In the case of individual income we get almost the identical 
result.  But the correlation is above .99 for both hhold and indiv.    */

		* 1. Nominal Individual Income  
/*
gen check_fiyr=fiyrl+fiyrnl if fiyrl>=0 & fiyrnl>=0  
gen tag=1 if (fiyr-1>check_fiyr | fiyr+1<check_fiyr) & !missing(fiyr) & !missing(check_fiyr) // Allows for rounding error
	/* This reproduces fiyr almost exactly.  The sole exception (tag==1) is one individual in wave 3 whose nonlabor income is for some reason not
	included in fiyr.  Note that BHPS does not use -egen =rowtotal() , missing-.  */
*/
gen anincome_nominal=fiyr if fiyr>=0
label var anincome_nominal "Income (nominal)" 

gen neg_benefit_income=-1*fiyrb if fiyrb>0 /* Need to multiply by -1 since there is no -egen rowdiff- */

egen incomenoben_nominal = rowtotal (neg_benefit_income anincome_nominal) , missing

		* 2. Real Individual Income 
gen index=. 
replace index=133.5 if year==1991
replace index=138.5 if year==1992
replace index=140.7 if year==1993
replace index=144.1 if year==1994
replace index=149.1 if year==1995
replace index=152.7 if year==1996
replace index=157.5 if year==1997
replace index=162.9 if year==1998
replace index=165.4 if year==1999
replace index=170.3 if year==2000
replace index=173.3 if year==2001
replace index=176.2 if year==2002
replace index=181.3 if year==2003
replace index=186.7 if year==2004
replace index=192   if year==2005
replace index=198.1 if year==2006
replace index=206.6 if year==2007
replace index=214.8 if year==2008
replace index=213.7 if year==2009

local setbaseyear 2008 
sum index if year == `setbaseyear' 
local index_deflate=r(mean) 
gen index_newdeflator= index/`index_deflate' 

foreach incomevar in anincome incomenoben { 
	gen real_`incomevar' =			`incomevar'_nominal/index_newdeflator 
	gen log_real_`incomevar' =		log(real_`incomevar') 
	gen real_`incomevar'_000s	= 	real_`incomevar'/1000 
	label var real_`incomevar' 		"Real income" 
	label var log_real_`incomevar' 	"Log real income" 
	label var real_`incomevar'_000s "Real income (000s pounds)" 
}


		* 3. Nominal Household Income 		
/*  
There is a discrepancy between fihhyr and fiyr.  For instance:
	gen newinc=fiyr if fiyr>=0  // Exclude missings, proxies, etc
	bysort hid: egen check_fihhyr = sum(newinc)  // Summing household income from fiyr
	gen diff_fihhyr=check_fihhyr-fihhyr if fihhyr>=0 

Here we find a substantial difference between the two measures.

We can see the discrepancy even more easily when we focus on single-member households:
bysort hid : egen count_hid=count(hid)
gen diff_fihhyr_singletons=newinc-fihhyr if count_hid==1 & fihhyr>=0 

Most of these differences are zero (or within a rounding error), but 10% are substantially different, with a mean difference of 3000 pounds.
We have contacted BHPS about this issue and are awaiting a reply. 
*/		

gen hholdincome=fihhyr if fihhyr>=0
label var hholdincome "Household Income (nominal)" 

		** 4. Real Household Income and winsorized
gen real_hhold_income=hholdincome/index_newdeflator 
label var real_hhold_income "Real household income" 

gen real_hhold_income_000s=real_hhold_income/1000 
label var real_hhold_income_000s "Real hhold income (000s pounds)" 

gen log_real_hhold_income=log(real_hhold_income) 
label var log_real_hhold_income "Log real household income" 

winsor real_hhold_income_000s , gen(w_hhincome) p(.005)
label var w_hhincome "Real hhold income (000s pounds)" 
gen w_loghhincome=log(w_hhincome) 
label var w_loghhincome "Log real household income" 
	
		** 5.  Winsorized real individual income 	
foreach var of varlist real_anincome_000s real_incomenoben_000s {
	tempvar f`var' m`var' wf`var' wm`var' 
	gen `f`var''=`var' if female==1
	gen `m`var''=`var' if male==1
	winsor `f`var'' , gen(`wf`var'') p(.005)  /*  Winsorizing deals with implausible incomes */
	winsor `m`var'' , gen(`wm`var'') p(.005)  
	}
	
gen wincome=			`wfreal_anincome_000s' 		if female==1 
replace wincome=		`wmreal_anincome_000s' 		if male==1 

gen wincome_noben=		`wfreal_incomenoben_000s' 	if female==1 
replace wincome_noben=	`wmreal_incomenoben_000s' 	if male==1 

foreach wincomevar in wincome wincome_noben {
	gen log_`wincomevar'=		log(`wincomevar'*1000) 
	label var `wincomevar' "Real income (000s pounds)" 
	label var log_`wincomevar' "Log real income" 
}

/* Unfortunately, despite indications in the codebook, fiyr does not seem to fully incorporate fiyrb.  That is, some individuals get positive values for fiyrb 
 but zero for fiyr.  Thus, we cannot use wincome_noben. */

bys hid buno: egen wincome_buno = total(wincome) , missing


/***************************************** 
 FINANCIAL WINDFALLS, asked in waves 5, 7-18 (for some reason, windfalls are not included in non-labor income).
	We include them in income, although if we extrapolate "rich/poor" (based on income percentiles) back to pre-2000 waves, then 
		those individuals who receive a windfall in 2000 were not necessarily rich before that point. 
********************************************		*/

gen windfall=. 
replace windfall=1 if windf==1
replace windfall=0 if windf==2

gen insur_windf = windfay if windfay>0 /* insurance windfall*/
gen pens_windf  = windfby if windfby>0 /* pension windfall*/
gen accid_windf = windfcy if windfcy>0 /* accident windfall*/
gen redun_windf = windfdy if windfdy>0 /* redundancy windfall */
gen beq_windf   = windffy if windffy>0 /* bequest windfall */
gen lott_windf  = windfgy if windfgy>0 /* lottery or gambling windfall*/ 
gen other_windf = windfhy if windfhy>0 /* asked waves 7-18*/
replace other_windf = windfy if windfy>0 & wave==5 /*windfy asked only in wave 5*/

local windfalltypes insur_windf pens_windf accid_windf redun_windf beq_windf lott_windf other_windf 

egen windfall_income=rowtotal(`windfalltypes')  , missing

* Deflate and winsorize
gen real_windfall_income=windfall_income/index_newdeflator 
winsor real_windfall_income, gen(wreal_windfall_income) p(.005) /* winsorizing windfalls to deal with implausibly large values */
	gen w_windfall=wreal_windfall_income/1000


label var w_windfall "Real windfall income (000s)"

bys hid buno: egen windfall_buno=total(w_windfall) , missing
label var windfall_buno "Real windfall income (buno, 000s)"

bys hid: egen windfall_hid=total(w_windfall) , missing
label var windfall_hid "Real windfall income (hhold, 000s)"

egen wincome_windfall = rowtotal(wincome w_windfall) , missing
label var wincome_windfall "Real income plus windfall (000s)"

egen w_hhincome_windfall = rowtotal(w_hhincome windfall_hid) , missing
label var w_hhincome_windfall "Real hhold income plus windfall (000s)"



	/* Note: The BHPS is better at recording cash transfers received; it doesn't ask a lot about
	   what kinds of social services people use.  So, in the future might want to limit this to
	   transfers, which would mean NOT including the info on use of eldercare and NHS.*/
	
	


**  INCOME BY BENEFIT TYPE 

/* 	We use our own definition of benefits rather than the generated variable fiyrb (in indresp.dta).
	According to the User's Guide, fiyrb sums income from ficodes 1,5,6,16 to 22, or 31 to 41 
	(dividing joint income by two when appropriate).  However, there are inconsistencies in this variable's construction.  
		a. It seems that other benefits outside this list of ficodes have been included in fiyrb.  The ones we have noticed are 
		the job seeker's allowance and the child tax credit.  
		b. There are several obs, most of which arise in wave 6, for which fiyrb does not count certain benefits.  For instance, try:
local fiyrblist pensioner widowpension widowmom severe_disab invalid_pens ind_injury attendance mobility_allow invalidcare wardisability /*
*/ incomesupport incomesupport ub ni_sickness childben loneparentben_a wf_taxcredit maternity housingben counciltax_ben other_stateben 
gen tag2=.
foreach var of local firyblist {
	di "fiyrb is less than `var' for this many cases:"
replace tag2=1 if fiyrb<`var'-1 & !missing(`var') & fiyrb>=0
}
	This is a stark test, as it only counts cases when the total fiyrb is less than any given component, but even here we flag 169 obs. 
	It's not clear if there's an additional rule that determines whether fiyrb will include a certain income source?

   The following code may also be of use: 
   
use height, clear
local roundfiyrb 1
gen bhps_fiyrb=fiyrb if fiyrb>=0  
egen test_fiyrb=rowtotal(pensioner widowpension widowmom pensioncredit severe_disab invalid_pens ind_injury attendance mobility_allow invalidcare /*
*/	wardisability disability disabled_persons incapacity dla_care dla_mobility dla_dk incomesupport incomesupport ub ni_sickness /*
*/	childben loneparentben_a wf_taxcredit maternity housingben counciltax_ben other_stateben jsa ctc rtw_credit edu_grant), missing
/* Note that this test_fiyrb variable includes more categories of ficode than mentioned in the User's Guide, in an attempt to more closely 
	approximate bhps_fiyrb.  */
gen bhpstoohigh=0
replace bhpstoohigh=1 if round(test_fiyrb,`roundfiyrb')<round(bhps_fiyrb,`roundfiyrb') & !missing(test_fiyrb) & !missing(bhps_fiyrb)
replace bhpstoohigh=. if missing(test_fiyrb) | missing(bhps_fiyrb)
gen bhpstoolow=0
replace bhpstoolow=1 if round(test_fiyrb,`roundfiyrb')>round(bhps_fiyrb,`roundfiyrb') & !missing(test_fiyrb) & !missing(bhps_fiyrb)
replace bhpstoolow=. if missing(test_fiyrb) | missing(bhps_fiyrb)
tab bhpstoohigh
tab bhpstoolow
tab wave if bhpstoohigh==1
tab wave if bhpstoolow==1
corr bhps_fiyrb test_fiyrb
*/

/* NOTE: Sara will fix this code later, since we are no longer using it for height & it she is not sure she will use it  :


merge 1:1 pid wave using benefits
drop if _merge==2 /* One individual for whom we have benefit income but no survey data */
drop _merge

* Deflate & winsorize benefits income 
local programlist pensioner widowpension widowmom pensioncredit severe_disab invalid_pens ind_injury attendance mobility_allow invalidcare /*
*/	wardisability disability disabled_persons incapacity dla_care dla_mobility dla_dk incomesupport incomesupport ub ni_sickness /*
*/	childben loneparentben_a wf_taxcredit maternity housingben counciltax_ben other_stateben jsa ctc rtw_credit  /* edu_grant sickinsur childmaint */

foreach type of local programlist {
gen real_`type'=`type'/index_newdeflator 
winsor real_`type', gen(wreal_`type') p(.03) /* winsorizing benefit amounts to deal with implausibly large values */
	gen wreal_`type'_000s=wreal_`type'/1000
}


/* Code different benefit amounts by type: contrib, means-tested, universal.  Not clear how to categorize "Other state benefit" so we omit.
	Return to work is means tested (www.gov.uk).  It's not clear that "educational grant" is a govt benefit so we omit.  */

* 12 Means-Tested:
egen total_meanstest=rowtotal(wreal_counciltax_ben_000s /*
*/	wreal_incomesupport_000s /*
*/	wreal_pensioncredit_000s /*
*/	wreal_housingben_000s /*
*/	wreal_wf_taxcredit_000s /*
*/	wreal_loneparentben_a_000s /* 
*/	wreal_disabled_persons_000s /*
*/	wreal_jsa_000s /*
*/	wreal_ub_000s /*
*/	wreal_incomesupport_000s /*
*/	wreal_ctc_000s /*
*/  wreal_rtw_credit_000s ), missing
label var total_meanstest "Means-tested benefit income (000s)"
		
* 12 Universal:	
egen total_universal=rowtotal(wreal_childben_000s /*
*/	wreal_severe_disab_000s /*
*/	wreal_ind_injury_000s /*
*/	wreal_attendance_000s /*
*/	wreal_mobility_allow_000s  /*
*/	wreal_wardisability_000s /*
*/	wreal_disability_000s /*
*/	wreal_dla_care_000s /*
*/	wreal_dla_mobility_000s /*
*/	wreal_dla_dk_000s /*
*/	wreal_invalidcare_000s) /*
*/  , missing
label var total_universal "Universal benefit income (000s)"

* 7 Contrib:
egen total_contrib=rowtotal(wreal_pensioner_000s ///
	wreal_widowmom_000s ///
	wreal_widowpension_000s ///
	wreal_invalid_pens_000s ///
	wreal_incapacity_000s ///
	wreal_ni_sickness_000s ///
	wreal_maternity_000s ) ///
	, missing
label var total_contrib "Contributory benefit income (000s)"
*/

/* FREE TIME 

We take the difference of 24*7=168 and the total hours reported working at job (regular and overtime), caregiving, and housework.  

Hours worked at job are aggregated from jbhrs and jshrs (number of hours worked per week for non-self and 
self-employed, which BHPS topcodes at 97 --- 98 and 99 are presumably don't know) and jbot (overtime hrs).

Caregiving (does not include children) is asked in blocks, so we use the average of each block.  
We topcode "100+ hours" at 100.
  
Housework is reported in howlng. */


/* BEGIN COMMENT:
gen reg_hrs=jbhrs if jbhrs>=0 & jbhrs<=97  
replace reg_hrs=jshrs if jbhrs<0 & jshrs>=0 & jshrs<=97
gen ot_hrs=jbot if jbot>=0

egen hrs_worked=rowtotal(reg_hrs ot_hrs) , missing 

gen hrs_care=.  
replace hrs_care=2 if aidhrs==1 /* 0-4 hrs per week */
replace hrs_care=7 if aidhrs==2 /* 5-9 hrs per week */
replace hrs_care=14.5 if aidhrs==3 /* 10-19 hrs per wk */
replace hrs_care=27 if aidhrs==4 /* 20-34 hrs per wk */
replace hrs_care=42 if aidhrs==5 /* 35-49 hrs per wk */
replace hrs_care=74.5 if aidhrs==6 /* 50-99 hrs per wk */
replace hrs_care=100 if aidhrs==7 /* 100+ hrs per wk */
replace hrs_care=10 if aidhrs==8 /* varies under 20 */
replace hrs_care=60 if aidhrs==9 /* varies 20 hrs + */

gen hrs_housework=howlng if howlng>=0

egen totalworkhrs=rowtotal(hrs_worked hrs_care hrs_housework) , missing
winsor totalworkhrs, gen(wtotalworkhrs) p(.005) highonly /* Winsorize to deal with implausibly high hours (including over 168) */ 

gen freetime=168-wtotalworkhrs
label var freetime "Free time (hrs/wk)"


* Not in remunerative work, DWP definition
gen DWP_notworking=hrs_worked<=16 if !missing(hrs_worked)
label var DWP_notworking "Not Working, DWP definition"
*/
		* END COMMENT

/*	HEIGHT */
tempvar heightfeettoinch femaleheight maleheight wfemaleheight wmaleheight height14 height16
replace hlhtf=. if hlhtf<0  /* Some missings are coded as negative */
replace hlhti=. if hlhti<0 
replace hlhtc=. if hlhtc<3 
gen `heightfeettoinch'=hlhtf*12 if hlhtm==1 
egen height = rowtotal(`heightfeettoinch' hlhti) if hlhtm==1  /* Most respondents report feet and inches ... */
replace height=hlhtc*.3937 if hlhtm==2  /* ... but some report in cm */
gen `femaleheight'=height if female==1
gen `maleheight'=height if male==1
winsor `femaleheight', gen(`wfemaleheight') p(.005)  /*  Winsorizing deals with implausibly short/tall individuals */
winsor `maleheight', gen(`wmaleheight') p(.005) 
replace height=`wfemaleheight' if female==1
replace height=`wmaleheight' if male==1
bys pid: egen meanheight=mean(height) /* To recover values for individuals with missing height in a given wave, we take the mean. */
gen `height14'=height if wave==14
gen `height16'=height if wave==16
bys pid: egen height14=max(`height14')
bys pid: egen height16=max(`height16') 

label var height 		"Height (inches)" 
label var meanheight 	"Height (inches)" 
label var height14 		"Height (inches)" 
label var height16 		"Height (inches)" 

tempfile height
save `height'


/* BEGIN COMMENT:

***********  ADDING COUPLE ID

/*	The BHPS doesn't track hholds across waves, so to create a couple identifier (cid):
 (a) using married sample, create husband and wife datasets
 (b) match wives to their husbands
 (c) generate a couple id (cid) by stringing pid & husband's pid and concatenating 
 (d) keep pid, wave, cid, husband pid
 (e) For FEMALES: merge pid wave onto the female(wives) dataset
 (f) For MALES: merge husb_pid & wave to the male dataset
 (g) append male and female datasets
 (h) create and append singles dataset (cid==pid)  */
 
tempfile husbands wives couples wives_cid couples_cid couples_singles_cid
 
* Husband dataset 
use `height' , clear 
keep if husband==1		/* 74,484 obs in this dataset*/
rename * husb_*  	 /* rename spouse identifier variables in male dataset */
format husb_pid %12.0f  /* Uses stata %f format: %w.df.  Output width is 12 digits; no decimal.*/
gen husb_linenumber = husb_pno /* pno is person number within household, used to match to wife */
rename husb_hid hid 
rename husb_wave wave
keep hid husb_pid wave husb_linenumber husb_married* husb_mlchng 
do $do/cid_husb.do 		/* Recoding to identify spouse correctly: e.g., match spouses who are living in separate households */
save `husbands' 	

* Wife dataset
use `height', clear
keep if wife==1		/* 78,890 obs in this dataset */
rename hgspn husb_linenumber  /* hgspn is pno of spouse */
format pid %12.0f
keep pid hid husb_linenumber wave married* mlchng 
do $do/cid_wife.do 		/* Recoding to identify spouse correctly: e.g., match spouses who are living in separate households */
save `wives' 	

* Merge wives dataset to husbands dataset
merge 1:1 hid husb_linenumber using `husbands' , nogenerate

/* Sometimes the spouse is not interviewed in a given wave, but we can identify them from surrounding waves.  This is important 	
	because we want the couple identifier to be defined correctly for the spouse who is present.  */

	** Replace (husb_)pid where the missing obs are between two present & identical (husb_)pid.

sort pid wave /* Replace missing husb_pid */
local i=2 
while `i' < `lastwave' {
 replace husb_pid=husb_pid[_n+`i'] if missing(husb_pid) & husb_pid[_n-1]==husb_pid[_n+`i'] & pid==pid[_n+`i'] & pid==pid[_n-1] & !missing(pid)
 local ++i
	}

sort husb_pid wave /*Replace missing pid (for wives) */
local i=2 
while `i' < `lastwave' {
 replace pid=pid[_n+`i'] if missing(pid) & pid[_n-1]==pid[_n+`i'] & pid[_n-1]!=. & pid[_n+`i']!=. & husb_pid==husb_pid[_n+`i'] & husb_pid==husb_pid[_n-1] & !missing(husb_pid)
 local ++i
	}	

/* (b) There are many instances where the missing pid's/husb_pid's are at the beginning or end of a series, e.g. missing in waves 1-4
 then present in waves 5-8.  We assume that an individual is with the same spouse if, for all the 'missing' years: 
(a) they are legally married [married==1 or husb_married==1] or living together
[married==1 or husb_married==1]; and 
(b) their marital status has not changed in the past year(s) [mlchng==2 (no change) or husb_mlchng==2]
In theory the mlchng question applies only to legally married couples, but in looking at the data, people answer it 
even when they answer married==1 (but married_legal==0).*/

	/* Impute missing husb_pids and pid's for waves 1 and 2 (where mlchng is not asked).  
	Here, we impute missing pid's if a person had no marital change in wave 3, and was legally married in wave 1 or 2.*/

sort pid wave /*for missing husbands*/
replace husb_pid=husb_pid[_n+1] if missing(husb_pid) & married_legal[_n+1]==1 & mlchng[_n+1]==2 & wave==2  & wave[_n+1]==3 & pid==pid[_n+1] 
replace husb_pid=husb_pid[_n+2] if missing(husb_pid) & married_legal==1 & married_legal[_n+1]==1 & married_legal[_n+2]==1 & mlchng[_n+2]==2 & pid==pid[_n+1] & pid==pid[_n+2] & wave==1 & wave[_n+1]==2 & wave[_n+2]==3

sort husb_pid wave /*for missing wives*/
replace pid=pid[_n+1] if missing(pid) & husb_married_legal[_n+1]==1 & husb_mlchng[_n+1]==2 & wave==2  & wave[_n+1]==3 & husb_pid==husb_pid[_n+1]
replace pid=pid[_n+2] if missing(pid) & husb_married_legal==1 & husb_married_legal[_n+1]==1 & husb_married_legal[_n+2]==1 & husb_mlchng[_n+2]==2 & husb_pid==husb_pid[_n+1] & husb_pid==husb_pid[_n+2] & wave==1 & wave[_n+1]==2 & wave[_n+2]==3

	/* For all other waves (where mlchng is asked each year): */

* Replace missing husbands' husb_pid
sort pid wave
replace husb_pid=husb_pid[_n+1] if missing(husb_pid) & pid==pid[_n+1] & !missing(pid) & mlchng[_n+1]==2 & mlchng==2 
replace husb_pid=husb_pid[_n+2] if missing(husb_pid) & pid==pid[_n+2] & !missing(pid) & mlchng[_n+2]==2 & mlchng[_n+1]==2 & mlchng==2 
replace husb_pid=husb_pid[_n+3] if missing(husb_pid) & pid==pid[_n+3] & !missing(pid) & mlchng[_n+3]==2 & mlchng[_n+2]==2 & mlchng[_n+1]==2 & mlchng==2 
replace husb_pid=husb_pid[_n+4] if missing(husb_pid) & pid==pid[_n+4] & !missing(pid) & mlchng[_n+4]==2 & mlchng[_n+3]==2 & mlchng[_n+2]==2 & mlchng[_n+1]==2 & mlchng==2 
replace husb_pid=husb_pid[_n+5] if missing(husb_pid) & pid==pid[_n+5] & !missing(pid) & mlchng[_n+5]==2 & mlchng[_n+4]==2 & mlchng[_n+3]==2 & mlchng[_n+2]==2 & mlchng[_n+1]==2 & mlchng==2 
	/* no need to do more than [_n+5]-- since no subsequent changes are made */
replace husb_pid=husb_pid[_n-1] if missing(husb_pid) & pid==pid[_n-1] & !missing(pid) & mlchng[_n-1]==2 & mlchng==2 
	/* no need to do more than [_n-1]-- since no changes are made */

do $do/cid_husb_recode.do  	/* Eliminate duplicate husb_pid mistakenly created by above recode.  This happens when (a) one spouse was not interviewed in
								a previous wave and (b) there are discrepancies in the reporting of whether or not there has been a change in marital status. */	

* Replace missing wives' pid
sort husb_pid wave /*replace pid's of missing wives where there is no gap of missing obs, but where we know */
replace pid=pid[_n+1] if missing(pid) & !missing(husb_pid) & husb_pid==husb_pid[_n+1] & husb_mlchng[_n+1]==2 & husb_mlchng==2 
replace pid=pid[_n+2] if missing(pid) & !missing(husb_pid) & husb_pid==husb_pid[_n+2] & husb_mlchng[_n+2]==2 & husb_mlchng[_n+1]==2 & husb_mlchng==2 
replace pid=pid[_n+3] if missing(pid) & !missing(husb_pid) & husb_pid==husb_pid[_n+3] & husb_mlchng[_n+3]==2 & husb_mlchng[_n+2]==2 & husb_mlchng[_n+1]==2 & husb_mlchng==2 
replace pid=pid[_n+4] if missing(pid) & !missing(husb_pid) & husb_pid==husb_pid[_n+4] & husb_mlchng[_n+4]==2 & husb_mlchng[_n+3]==2 & husb_mlchng[_n+2]==2 & husb_mlchng[_n+1]==2 & husb_mlchng==2 
replace pid=pid[_n+5] if missing(pid) & !missing(husb_pid) & husb_pid==husb_pid[_n+5] & husb_mlchng[_n+5]==2 & husb_mlchng[_n+4]==2 & husb_mlchng[_n+3]==2 & husb_mlchng[_n+2]==2 & husb_mlchng[_n+1]==2 & husb_mlchng==2 
	/* no need to do more than [_n+5]-- since no subsequent changes are made */
replace pid=pid[_n-1] if missing(pid) & !missing(husb_pid) & husb_pid==husb_pid[_n-1] & husb_mlchng[_n-1]==2 & husb_mlchng==2 
	/* no need to do more than [_n-1]-- no subsequent changes are made */

do $do/cid_wife_recode.do  	/* Eliminate duplicate wife_pid mistakenly created by above recode.  This happens when (a) spouse was not interviewed in
								a previous wave and (b) there are discrepancies in the reporting of whether or not there has been a change in marital status. */	

/* String the pid and husband_pid and concatenate to create cid */

	egen cid=concat(pid husb_pid), format(%24.0f)  
	keep pid wave cid hid husb_pid
	
	save `couples'
	
	
/* Merge pid wave onto the FEMALE (wife) dataset */
keep pid wave cid hid
drop if pid==.
merge 1:1 pid wave using `wives'
drop if _merge==1
drop _merge 

save `wives_cid'

/* Merge pid wave onto the MALE (husband) dataset */
use `couples' , clear
keep husb_pid wave cid hid
drop if husb_pid==.
merge 1:1 husb_pid wave using `husbands'
drop if _merge==1
drop _merge 
rename husb_pid pid

/* Append husbands and wives */
append using `wives_cid'
save `couples_cid'

/* Add cid to singles and append */
use `height', clear
keep if single==1  
gen double cid = pid /* For singles, cid is just their pid.  Use -gen double- to avoid precision problems */
tostring cid, replace format(%24.0f)  
keep pid cid wave
append using `couples_cid'
label var cid "Cross-wave couple identifier"
keep pid cid wave 

save `couples_singles_cid'
*/
	**** END COMMENT


/* CHARACTERISTICS OF PARENTS */

local parentvars wincome cvote height age yrs_school edu_case_etal white no_religion non_christian catholic nc_christian 	

use $cleandta/egoaltcomplete, clear /* Dataset containing relationship codes */
do $do/02a_opid_recode.do /* In a handful of cases, the (biological) parent id changes over time, due to misidentification 
							(e.g., of a grandparent as parent in one wave).  This do file fixes such errors. */

keep if rel==13 /* The only relationship we want to preserve is that between child and biological parent. */
tempfile moms dads parents
tempvar mom dad
gen `mom'=1 if osex==2  /* Alter's relationship to Ego is Natural Parent, and Alter is female */
gen `dad'=1 if osex==1  /* Alter's relationship to Ego is Natural Parent, and Alter is male */


foreach parent in mom dad {
	preserve
	keep if ``parent''==1
	bys pid: egen `parent'sd=sd(opid)
	assert `parent'sd==0 | missing(`parent'sd) /* Verify that each child reports the same birth mother/father for all waves */
	keep opid /* all we need is the moms'/dads' pid */
	duplicates drop 
	rename opid pid /* in order to merge */
	merge 1:m pid using `height' , keepusing(`parentvars' wave)
	keep if _merge==3  /* Only keep matches */
	drop _merge
	foreach var of local parentvars {
		rename `var' `parent'_`var'
		local `parent'vars ``parent'vars' `parent'_`var' /* Make a list of variables, e.g. mom_wincome, mom_cvote, etc */
	}
	reshape wide ``parent'vars', i(pid) j(wave)
	rename pid `parent'id
	save ``parent's'
	restore
}

*Kids : Merge in parents' info, first moms, then dads
gen double motherid_temp=opid if osex==2  /* the "double" is required else the id numbers lose precision and will not match */
gen double fatherid_temp=opid if osex==1  /* the "double" is required else the id numbers lose precision and will not match */
bys pid : egen double momid=max(motherid_temp)  /* the "double" is required else the id numbers lose precision and will not match */
bys pid : egen double dadid=max(fatherid_temp)  /* the "double" is required else the id numbers lose precision and will not match */
collapse (mean) momid dadid , by(pid)

foreach parent in mom dad {
	merge m:1 `parent'id using ``parent's'
	rename _merge `parent'merge
}
keep if mommerge==3 | dadmerge==3 

*Merge back to `height'
keep pid mom* dad*
tostring momid dadid, replace
tempfile parents
save `parents'


/* BEGIN COMMENT:  Sara thinks we can cut this... it was for Conditionality Paper.

/* Age of Youngest Resident Child of Respondent*/

use $cleandta/egoaltcomplete, clear
bysort hid pno: egen npar = sum(rel==13 | rel==14) /*natural or adoptive parent*/
bysort hid pno: egen nkids = sum(rel==4 | rel==5) /*natural or adoptive child*/
label var npar "Number of Parents"

* Create Parents Dataset
preserve
keep if nkids>=1 /*keep only parents; this drops adult siblings (for ex) in the hh from sample*/
sort hid pno
`dirclean'
tempfile parentsinfo
save `parentsinfo' /*saves a parent-only dataset*/
restore

* Create Kids' Dataset
keep if npar>=1 /*keep only children of main survey respondents. */
tempfile kidsinfo
save `kidsinfo'

use $cleandta/indallcomplete
sort hid pid
merge 1:m hid pid using `kidsinfo'  /*kids is using dataset; indall is master*/
drop if _m==1
drop _m
drop opno /*this is parents'/relatives' pno*/
rename pno opno /*rename kid pid to opid to match with parents' dataset*/
keep hid opno age /*buno*/
bysort hid opno: keep if _n==1


merge 1:m hid opno using `parentsinfo' /*merge kids' info to parent dataset*/
tab _m
drop if _m==1 | _m==2
drop _m

bysort hid /*buno*/ pno : egen youngch=min(age) /*difference is here*/
label var youngch "Age of R's youngest child"
bysort hid /*buno*/ pno: keep if _n==1
keep hid pid youngch /*buno*/

`dirclean'
tempfile youngch
save `youngch'
*/
		*** END COMMENT

	
	
** SAVING DATASETS

use `height', clear
/* BEGIN COMMENT
merge 1:1 pid wave using `couples_singles_cid' 
drop if _merge==2
drop _merge

merge 1:1 hid /*buno*/ pid using `youngch', nogenerate
count
*/
	**** END COMMENT
merge m:1 pid using `parents'
count
drop if _merge==2
drop _merge
drop if year==.

* Supplement account of parents' schooling (from paedhi, maedhi) using parents' own reports when available (from qfachi --> dad_edu_case_etal1 etc)

*Step 1: recode dad_case and mom_case to match dad_school/mom_school (ie, paedhi)
forvalues wavenumber=1/18 { 
foreach parent in mom dad {
	tempvar `parent'school`wavenumber'
	gen 	``parent'school`wavenumber''=2 if `parent'_edu_case_etal`wavenumber'==0  /* "none of these" ==> "left school no quals" */
	replace ``parent'school`wavenumber''=3 if inrange(`parent'_edu_case_etal`wavenumber',1, 3) /* o-level, a-level ==> "left school some quals" */
	replace ``parent'school`wavenumber''=4 if `parent'_edu_case_etal`wavenumber'==4 /*hnd,hnc ==> "got further ed quals" */
	replace ``parent'school`wavenumber''=5 if inrange(`parent'_edu_case_etal`wavenumber',5,6) /*1st, higher degree ==> "got uni/higher degree"*/
	bysort pid : egen `parent'schoolX`wavenumber' = max(``parent'school`wavenumber'')  /* use funny character to easily drop later */
}
}
* Step 2: Create new parent educational variable, using dad_school as base, then where missing, supplement with dad_edu_case variable
foreach parent in mom dad {
	egen new`parent'school = rowmax(`parent'schoolX1-`parent'schoolX18)
	replace new`parent'school = `parent'_school if !missing(`parent'_school)
	}

* dummy out parents' education

foreach parent in dad mom {
	gen `parent'noqual=inrange(new`parent'school,1,2) if !missing(new`parent'school)
	gen `parent'somequal =new`parent'school==3 if !missing(new`parent'school)
	gen `parent'furthered =new`parent'school==4 if !missing(new`parent'school)
	gen `parent'uni =new`parent'school==5 if !missing(new`parent'school)
}
	
label var momnoqual "Mom no qual"
label var momsomequal "Mom some qual"
label var momfurthered "Mom further ed"
label var momuni "Mom degree"

label var dadnoqual "Dad no qual"
label var dadsomequal "Dad some qual"
label var dadfurthered "Dad further ed"
label var daduni "Dad degree"

* Create totals of other parents' variables
foreach var of local parentvars {
	forvalues j=1/`lastwave' {
		if `"`var'"' != "wincome" egen parents_`var'`j'=rowmean(mom_`var'`j' dad_`var'`j')
		else if `"`var'"' == "wincome" egen parents_`var'`j'=rowtotal(mom_`var'`j' dad_`var'`j') , missing
	}
}
order pid mom_* dad_* , sequential

* Averages of mom and dad vars
foreach parent in mom dad {
foreach var of local parentvars {
	gen `parent'_`var'_t1t5=.
	forvalues t=1/13 {
		local tplus4=`t' + 4
		tempvar `parent'`var'1to5`t'
		egen ``parent'`var'1to5`t''=rowmean(`parent'_`var'`t'-`parent'_`var'`tplus4')
		replace `parent'_`var'_t1t5=``parent'`var'1to5`t'' if xw_doby==1990+`t'
	}
	gen `parent'_`var'_t2t2=.
	forvalues t=3/16 {
		local tplus2=`t' + 2
		local tminus2=`t' - 2
		tempvar `parent'`var'2to2`t'
		egen ``parent'`var'2to2`t''=rowmean(`parent'_`var'`tminus2'-`parent'_`var'`tplus2')
		replace `parent'_`var'_t2t2=``parent'`var'2to2`t'' if xw_doby==1990+`t'
	}
	egen `parent'_`var'_first5=rowmean(`parent'_`var'1-`parent'_`var'5)
	egen `parent'_`var'_whole=rowmean(`parent'_`var'1-`parent'_`var'16)	
}
}


* Combine parents' information
foreach var of local parentvars {
	egen parents_`var'_t1t5 = rowmean(dad_`var'_t1t5 mom_`var'_t1t5)
	egen parents_`var'_t2t2 = rowmean(dad_`var'_t2t2 mom_`var'_t2t2)
	egen parents_`var'_first5 = rowmean(dad_`var'_first5 mom_`var'_first5)
	egen parents_`var'_whole = rowmean(dad_`var'_whole mom_`var'_whole)
	label var parents_`var'_t1t5 "Avg of Parents' `var' (First 5 Years from birth)"
	label var parents_`var'_t2t2 "Avg of Parents' `var' (Pre/post natal)"
	label var parents_`var'_first5 "Avg of Parents' `var' (First 5 Years of BHPS)"
	label var parents_`var'_whole "Avg of Parents' `var'"
	}

* Generate sibling id
tempvar sibid
gen `sibid'=momid + dadid
replace `sibid'= subinstr(`sibid',".","",.)
gen double sibid=real(`sibid')

/* BEGIN COMMENT
* Remove period from cid
replace cid = subinstr(cid,".","",.)
*/
	** END COMMENT
	
drop _* *X*
gen whole=1 /* For use in loops */
compress
saveold $cleandta/height , replace /* Save in version 12.  Long -filefilter- commands fail in Stata 13. */


keep if wave==14 | wave==16
saveold $cleandta/height1416 , replace /* Save in version 12.  Long -filefilter- commands fail in Stata 13. */
keep if northern_ireland==0 & age>17
keep female male age wincome height wave cvote turnout convote gjo pso peo ulo
saveold $bootstrap/bs_dataset , replace /* Save in version 12.  Long -filefilter- commands fail in Stata 13. */



******************** YOUTH DATASET
	local youthvarstokeep pid hid wave xw_doby xw_sex region* yphap ypest* yph* ypvte*

	use `youthvarstokeep' using $cleandta/complete_bhps_youth.dta , clear

	
gen age=wave+1990-xw_doby  /* ypdoby4 is an alternative (not identical to xw_doby), but xw_doby is the BHPS's "best guess" */
gen female=xw_sex==2 
gen male=xw_sex==1 
label var female "Female" 
label var male "Male" 
label var age "Age"

gen newregion=region2 if region2>0  /* As in main sample, use region2, and recover missing information using region.  */
replace newregion=8  if missing(newregion) & region==3 
replace newregion=2  if missing(newregion) & region==11 
replace newregion=10 if missing(newregion) & region==17 
replace newregion=11 if missing(newregion) & region==18
replace newregion=12 if missing(newregion) & region==19

gen england = inrange(newregion,1,9) if inrange(newregion,1,12) /* Channel Islands (region2==13) are not part of UK and are coded as missing */ 
gen wales = newregion==10 if inrange(newregion,1,12)
gen scotland = newregion==11 if inrange(newregion,1,12) 
gen northern_ireland = newregion==12 if inrange(newregion,1,12)	

	merge m:1 pid using `parents'
	drop if _merge==2 /* Drop if using only */
	drop _merge

foreach var of local parentvars {
	forvalues j=1/`lastwave' {
	if `"`var'"' != "wincome" egen parents_`var'`j'=rowmean(mom_`var'`j' dad_`var'`j')
	else if `"`var'"' == "wincome" egen parents_`var'`j'=rowtotal(mom_`var'`j' dad_`var'`j') , missing
	}
}

order pid mom_* dad_* , sequential  /* Variables must be correctly ordered for the following -rowmean-*/

* Five year average of mom and dad cvote & wincome
foreach parent in mom dad {
foreach var of local parentvars {
	gen `parent'_`var'_t1t5=.
	forvalues t=1/13 {
		local tplus4=`t' + 4
		tempvar `parent'`var'1to5`t'
		egen ``parent'`var'1to5`t''=rowmean(`parent'_`var'`t'-`parent'_`var'`tplus4')
		replace `parent'_`var'_t1t5=``parent'`var'1to5`t'' if xw_doby==1990+`t'
	}
	gen `parent'_`var'_t2t2=.
	forvalues t=3/16 {
		local tplus2=`t' + 2
		local tminus2=`t' - 2
		tempvar `parent'`var'2to2`t'
		egen ``parent'`var'2to2`t''=rowmean(`parent'_`var'`tminus2'-`parent'_`var'`tplus2')
		replace `parent'_`var'_t2t2=``parent'`var'2to2`t'' if xw_doby==1990+`t'
	}
	egen `parent'_`var'_first5=rowmean(`parent'_`var'1-`parent'_`var'5)
	egen `parent'_`var'_whole=rowmean(`parent'_`var'1-`parent'_`var'16)	
}
}

* Combine parents' information
foreach var of local parentvars {
	egen parents_`var'_t1t5 = rowmean(dad_`var'_t1t5 mom_`var'_t1t5)
	egen parents_`var'_t2t2 = rowmean(dad_`var'_t2t2 mom_`var'_t2t2)
	egen parents_`var'_first5 = rowmean(dad_`var'_first5 mom_`var'_first5)
	egen parents_`var'_whole = rowmean(dad_`var'_whole mom_`var'_whole)
	label var parents_`var'_t1t5 "Avg of Parents' `var' (First 5 Years from birth)"
	label var parents_`var'_t2t2 "Avg of Parents' `var' (Pre/post natal)"
	label var parents_`var'_first5 "Avg of Parents' `var' (First 5 Years of BHPS)"
	label var parents_`var'_whole "Avg of Parents' `var'"
	}	
	


/* Youth: race 
	 xw_race variables are only given for youth sample if they have aged into the main sample by wave 18.  
	 We code as nonwhite if either parent responds as nonwhite in any wave.  */  

gen white=1
forvalues j=1/`lastwave' {
	replace white=0 if dad_white`j'==0 | mom_white`j'==0
	}

/* Youth: religion 
	We define based on the mother, filling in with the father if mother's religion is missing. */

foreach var in no_religion non_christian nc_christian catholic {
  gen `var'=.
  forvalues j=1/16 {
	replace `var'=1 if mom_`var'`j'==1 
	replace `var'=0 if mom_`var'`j'==0
	}
  forvalues j=1/16 {	
	replace `var'=1 if dad_`var'`j'==1 & missing(`var')     
	replace `var'=0 if dad_`var'`j'==0 & missing(`var')
	}
}
	

/* Youth: self-esteem variables*/

* Appearance (originally coded 1-7, hi-lo)

label define happinessscale 1 "Completely Unhappy" 2 "Mostly Unhappy" 3 "Somewhat Unhappy" /*
						 */ 4 "Neither happy nor unhappy" 5 "Somewhat Happy" 6 "Mostly Happy"  7 "Completely Happy"

gen appearo=yphap if yphap>0  /*1-7*/
recode appearo (1=7) (2=6) (3=5)  (5=3 ) (6=2) (7=1) (else=.) 
label values appearo happinessscale

gen appeard=0
replace appeard=1 if inrange(appearo,5,7)
label define happyunhappy 1 "Happy" 0 "Unhappy"
label values appeard happyunhappy 
label var appeard "Happy about Appearance"

* Ability (Originally coded 1-4, Agree-Disagree)
gen ableo=ypestj if ypestj>0
* Solve Problems
gen solveo=ypestk if ypestk>0
* Not Proud of Self
gen notproudo=ypesti if ypesti>0
* Failure
gen failo=ypeste if ypeste>0
* No Good At All 
gen nogoodo=ypestf if ypestf>0

label define agreedisagree1to4 4 "Strongly agree" 3 "Agree" 2 "Disagree" 1 "Strongly disagree"

foreach type in able solve notproud fail nogood {
	recode `type'o (1=4) (2=3) (3=2) (4=1) (else=.) 
	label values `type'o agreedisagree1to4
	gen `type'd = inrange(`type'o,3,4) if !missing(`type'o)	
	label values `type'd agreedisagree
}


foreach suffix in o d {
label var able`suffix' "I am as able as most people" 
label var solve`suffix' "I can usually solve my own problems" 
label var notproud`suffix' "I don't have much to be proud of" 
label var fail`suffix' "I am inclined to feel I am a failure" 
label var nogood`suffix' "At times I feel I am no good at all" 
}


/* Youth: height */

tempvar feet inches cm feettoinch femaleheight maleheight wfemaleheight wmaleheight yphap ypestj ypestk ypesti ypeste ypestf
gen `feet'=yphtf if yphtf >0  /* Missings, don't knows are coded as negative */
gen `inches'=yphfi if yphfi>=0 
replace `inches'=yphti if yphti>=0 & missing(yphfi)  /* For some reason, wave 18 uses yphti for inches while waves 14 and 16 use yphfi */
gen `cm'=yphtc if yphtc>0 
gen `feettoinch'=`feet'*12   
egen height = rowtotal(`feettoinch' `inches') , missing   /* Most respondents report feet and inches ... */
replace height=`cm'*.3937 if missing(height)  /* ... but some report in cm */
gen `femaleheight'=height if female==1
gen `maleheight'=height if male==1
winsor `femaleheight', gen(`wfemaleheight') p(.005)  /*  Winsorizing deals with implausibly short/tall individuals */
winsor `maleheight', gen(`wmaleheight') p(.005) 
replace height=`wfemaleheight' if female==1
replace height=`wmaleheight' if male==1

/* cvote: Note that it is not asked the same as in the main sample.  
  Youth: If you could vote for a political party which would you vote for? 
(Comparable adult question (vote, a derived var) asks "which party support?".
There is an equivalent question for adults (vote3- which party would you vote for tomorrow?), but it has 
approx 66% missings.  In contrast, vote has a much higher response rate.*/

gen cvote=. /* missing, "refused", "don't know", and proxy coded as missing */
	replace cvote=1 if ypvte3==1  | ypvte3==12
	replace cvote=0 if inrange(ypvte3,2,11) | inrange(ypvte3,13,18) /* 15% respond ypvte3==18 (none of them) */

	
*Saving youth datasets
drop _* /* Drop tempvars */
compress
saveold $cleandta/height_youth, replace /* Save in version 12.  Long -filefilter- commands fail in Stata 13. */
keep if wave==14 | wave==16
saveold $cleandta/height1416_youth, replace /* Save in version 12.  Long -filefilter- commands fail in Stata 13. */

clear
log close
exit
