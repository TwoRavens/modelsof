
************************
***   READ IN DATA   ***
************************
	version 12.1
	do "Scholz-Sicinski data prep.do"

* Add sorting variable for 75 job
	quietly abcode abcode abind75 ocxcuru inxcuru cwxcuru
	sort abcode
	merge m:1 abcode using "DOT_1970_v2.dta",gen(_merge_dot70)
	drop if _merge_dot70==2
	sort idpriv

***********************************
*** CREATE ADDITIONAL VARIABLES ***
***********************************

*collapse vocational training to a single indicator
	clonevar ivocat=ivocat74
	replace ivocat=1 if ivocat==2

* High school participation
	gen leadertot=0
	gen leaderind=0

	foreach leader in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 {
		replace leadertot=leadertot+leader`leader' if leader`leader'<. 
		replace leaderind=leaderind+1 if leader`leader'>0 & leader`leader'<.
	}
	gen hsleader=0
	replace hsleader=1 if leaderind>0

	foreach var of varlist varsports-miscact {
		gen indi`var'=0
		replace indi`var'=1 if `var'>0
		replace indi`var'=. if totact>=.
	}

*New total measure (1 club category=1 activity)
	gen total=0 if totact<.

	foreach club of numlist 1001 1002 1003 1004 1005 1006 1007 1008 1009 1010 1011 1012 1013 1014 1015 1020 1101 ///
	1102 1201 1202 1203 1204 1205 1206 1207 2001 2002 2003 2004 2005 2101 2102 2103 3001 ///
	3002 3003 3004 3005 3006 3007 3008 3101 3102 3103 4001 4002 4003 5001 5002 5003 5004 ///
	5101 5102 5103 5201 5301 5302 5303 6001 6002 6003 6004 6005 6006 6007 6008 6009 6010 ///
	6011 6012 7001 7002 7003 7004 7005 7006 7007 8001 8002 8003 8004 8005 8006 8007 8008 ///
	8009 8010 8011 8012 8013 9001 9002 9003 9004 9005 9006 9007 9101 9102 9103 9999 {

		qui gen club`club'=0
		foreach activ of numlist 1/27 { 
			qui replace club`club'=1 if activ`activ'==`club'
		}
	}
	qui do "/project/hauser/users/ksicinsk/networking/clubnames.do"

	foreach club of numlist 1001 1002 1003 1004 1005 1006 1007 1008 1009 1010 1011 1012 1013 1014 1015 1020 1101 ///
	1102 1201 1202 1203 1204 1205 1206 1207 2001 2002 2003 2004 2005 2101 2102 2103 3001 ///
	3002 3003 3004 3005 3006 3007 3008 3101 3102 3103 4001 4002 4003 5001 5002 5003 5004 ///
	5101 5102 5103 5201 5301 5302 5303 6001 6002 6003 6004 6005 6006 6007 6008 6009 6010 ///
	6011 6012 7001 7002 7003 7004 7005 7006 7007 8001 8002 8003 8004 8005 8006 8007 8008 ///
	8009 8010 8011 8012 8013 9001 9002 9003 9004 9005 9006 9007 9101 9102 9103 9999 {

		qui replace total=total+club`club'
	}

	gen hasclubsp=0
	gen hasintsp=0
	gen hasvarsp=0
	quietly levelsof schoolid,local(slist)	
	foreach school of local slist {
		di "School #`school' 
		qui sum clubsport if schoolid==`school'
		qui replace hasclubsp=1 if r(max)>0 & schoolid==`school'
		qui sum intsport if schoolid==`school'
		qui replace hasintsp=1 if r(max)>0 & schoolid==`school'
		qui sum varsports if schoolid==`school'
		qui replace hasvarsp=1 if r(max)>0 & schoolid==`school'
	}

	gen onlyvarsports=0
	replace onlyvarsports=1 if hasvarsp==1 & hasclubsp==0 & hasintsp==0

	gen inonlysports=0
	replace inonlysports=1 if indivarsports==1 & hasclubsp==0 & hasintsp==0

*DOT 
	replace Apt_Verbalm=6-Apt_Verbalm
	replace Apt_IQ=5-Apt_IQ
	replace peoplem=9-peoplem
	replace datam=9-datam
	foreach var of varlist datam peoplem GED_Lm GED_Mm Apt_Verbalm Apt_IQm {
		sum `var' if female==0 & zerowage74==0 & selfemp74==0
	replace `var'=`var'-r(mean)
	}

*Uniform naming for tables
	foreach var of newlist pop exp expsq mar tenure union outwis ind ieduc educ occ {
		qui gen `var'=.
	}
	la var pop "Popul. place residence"
	la var exp "Experience"
	la var expsq "Exp. Squared"
	la var mar "Marital status"
	la var tenure "Tenure"
	la var union "Union"
	la var ind "Industry"
	la var educ "Education (years)"
	la var fathed "Father's education"
	la var mothed "Mother's education"
	la var pinc57 "Family income '57"
	la var farmbg "Farm background"
	la var milty "Military service"
	la var ipop57 "Town size 57"
	la var ivocat "Vocational training '75"
	la var plantsize92 "Plant size"
	la var agersp "Age"
	la var outwis "Resides outside Wisconsin"
	la var meanrat "Beauty"
	la var meanrat_mcoder "Beauty, coder: m"
	la var meanrat_fcoder "Beauty, coder: f"
	la var iqscore "IQ score (std)"
	la var numempls92 "Number of employers 75-92"
	la var fullhh "Lived with both parents"
	la var hssize "High school class size"
	la var nummar7592 "Number of marriages 1975-1992"
	la var momemployed "Mother employed"
	la var varsports "Varsity sports (number)"
	la var indivarsports "In varsity sports"
	la var indischgovt "In student government"
	la var indiservact "In service organizations"
	la var sibsnum "Number of siblings"
	la var zheight "Height (standardized)"
	la var total "Total # of activities"
	la var fathproex "Father executive"
	la var selfacc92m "Self-acceptance score"
	la var purplife92m "Purpose-in-life score"
	la var extraver92m "Measure of extraversion"
	la var agreeable92m "Measure of agreeableness"
	la var conscientious92m "Measure of conscientiousness"
	la var neurotic92m "Measure of neuroticism"
	la var open92m "Measure of openness"
	la var datam "Worker functions - Data"
	la var peoplem "Worker functions - People"
	la var GED_Lm "Language development"
	la var GED_Mm "Mathematical development"
	la var Apt_Verbalm "Verbal aptitude"
	la var Apt_IQm "Intelligence aptitude"

* SAVE DATA FOR POOLED REGRESSION REQUESTED BY REVIEWERS
	preserve	
	keep idpriv lwage74 lwage92 zbeautyf iqscore fathed mothed fathproex pinc57 farmbg ipop57 sibsnum  ///
	fullhh momemployed  hssize milty pop74 pop92 exp74 exp92 expsq74 expsq92 mar74 mar92 tenure74 tenure92 ///
	union74 union92 outwis74 outwis92 ind74 ind92 ieduc74 ieduc92 ivocat female zerowage74 zerowage92 selfemp74 selfemp92
	save "for pooled.dta",replace
	restore

****************
*** ANALYSIS ***
****************

log using "Scholz-Sicinski main code.log", replace

* TABLE 1: Attractiveness and Log Earnings of Men
* (Follow Neal and Johnson) 

	xi: regress lwage74 zbeautyf iqscore if female==0 & zerowage74==0 & selfemp74==0  
		estimates store a_wage74iq

	xi:regress lwage92 zbeautyf iqscore if female==0 & zerowage92==0 & selfemp92==0  
		estimates store a_wage92iq

	foreach var of varlist outwis pop exp expsq mar tenure union occ ind ieduc {
		qui replace `var'=`var'74     
	}
	xi: regress lwage74 zbeautyf iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	 fullhh momemployed  hssize milty pop exp expsq mar tenure union outwis i.ind i.ieduc ///
	 ivocat  if female==0 & zerowage74==0 & selfemp74==0
		estimates store a_wage74fs

	foreach var of varlist outwis pop exp expsq mar tenure union occ ind ieduc {
		qui replace `var'=`var'92
	}
	xi:regress lwage92 zbeautyf iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	 fullhh momemployed  hssize milty pop exp expsq mar tenure union outwis i.ind i.ieduc ///
	 ivocat if female==0 & zerowage92==0 & selfemp92==0
		estimates store a_wage92fs

*COEFFICIENT TESTS REQUESTED BY REVIEWERS
	regress lwage74 zbeautyf iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	 fullhh momemployed  hssize milty pop74 exp74 expsq74 mar74 tenure74 union74 outwis74 i.ind74 i.ieduc74 ///
	 ivocat  if female==0 & zerowage74==0 & selfemp74==0
		estimates store T174fs

	regress lwage92 zbeautyf iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	 fullhh momemployed  hssize milty pop92 exp92 expsq92 mar92 tenure92 union92 outwis92 i.ind92 i.ieduc92 ///
	 ivocat if female==0 & zerowage92==0 & selfemp92==0
		estimates store T192fs

	suest a_wage74iq a_wage92iq
		test [a_wage74iq_mean]zbeautyf=[a_wage92iq_mean]zbeautyf
	suest T174fs T192fs
		test [T174fs_mean]zbeautyf=[T192fs_mean]zbeautyf


*TABLE 2: Facial Attractiveness, Height and Earnings
* (Height distinct from beauty)

	foreach var of varlist outwis pop exp expsq mar tenure union occ ind ieduc {
		qui replace `var'=`var'74     
	}
	xi: regress lwage74 zbeautyf zheight iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	 fullhh momemployed  hssize milty pop exp expsq mar tenure union outwis i.ind i.ieduc ///
	 ivocat  if female==0 & zerowage74==0 & selfemp74==0
		estimates store hgt74

	foreach var of varlist outwis pop exp expsq mar tenure union occ ind ieduc {
		qui replace `var'=`var'92
	}
	xi:regress lwage92 zbeautyf zheight iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	 fullhh momemployed  hssize milty pop exp expsq mar tenure union outwis i.ind i.ieduc ///
	 ivocat if female==0 & zerowage92==0 & selfemp92==0
		estimates store hgt92

	xi: regress lwage74 zbeautyf zheight iqscore if female==0 & zerowage74==0 & selfemp74==0  
		estimates store hgt74iq

	xi:regress lwage92 zbeautyf zheight iqscore if female==0 & zerowage92==0 & selfemp92==0  
		estimates store hgt92iq

*Panel 2: Bauty quintiles (moved to supplementary material)
	xtile qbeautyf=meanrat if female==0, nq(5)	

	foreach quintile in 1 2 3 4 5 {
		gen q`quintile'b=0
		la var q`quintile'b "Beauty quintile `quintile'"
		replace q`quintile'b=1 if qbeautyf==`quintile'
	}

	xi: regress lwage74 q1b q2b q4b q5b iqscore if female==0 & zerowage74==0 & selfemp74==0 
		estimates store quint_74iq

	xi: regress lwage92 q1b q2b q4b q5b iqscore if female==0 & zerowage74==0 & selfemp74==0 
		estimates store quint_92iq

	foreach var of varlist outwis pop exp expsq mar tenure union occ ind ieduc {
		qui replace `var'=`var'74     
	}
	xi: regress lwage74 q1b q2b q4b q5b iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	 fullhh momemployed  hssize milty pop exp expsq mar tenure union outwis i.ind i.ieduc ///
	 ivocat  if female==0 & zerowage74==0 & selfemp74==0
		estimates store quintiles_74

	foreach var of varlist outwis pop exp expsq mar tenure union occ ind ieduc {
		qui replace `var'=`var'92
	}
	xi:regress lwage92 q1b q2b q4b q5b iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	 fullhh momemployed  hssize milty pop exp expsq mar tenure union outwis i.ind i.ieduc ///
	 ivocat if female==0 & zerowage92==0 & selfemp92==0
		estimates store quintiles_92

*TABLE 3: Attractiveness and Health

*Beauty and health
	foreach var of varlist outwis pop exp expsq mar tenure union occ ind ieduc {
		qui replace `var'=`var'92
	}
	xi: oprobit ohealth zbeautyf iqscore if female==0 & zerowage92==0 & selfemp92==0  
		estimates store oprob_iq

	xi: oprobit ohealth zbeautyf iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	 fullhh momemployed  hssize milty pop exp expsq mar tenure union outwis i.ind i.ieduc ///
	 ivocat  if female==0 & zerowage92==0 & selfemp92==0
		estimates store oprob_fs

*Beauty and mortality
	gen dead=livgrad-1	
	tab dead if female==0

	xi: dprobit dead zbeautyf iqscore if female==0
		estimates store mortiq

	foreach var of varlist outwis pop exp expsq mar tenure union occ ind ieduc {
		qui replace `var'=`var'74
	}
	xi: dprobit dead zbeautyf iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	fullhh momemployed  hssize milty pop exp expsq mar tenure union outwis i.ind i.ieduc ///
	ivocat  if female==0 
		estimates store mortfs

*TABLE 4: Attractiveness and Early Human Capital Formation

	xi:dprobit indivarsports zbeautyf iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	 fullhh momemployed  hssize if female==0 
		estimates store varsprt

	xi:dprobit indischgovt zbeautyf iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	 fullhh momemployed  hssize if female==0 
		estimates store studntgov

	xi:dprobit indiservact zbeautyf iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	 fullhh momemployed  hssize if female==0 
		estimates store servicorg

	xi:regress total zbeautyf iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	 fullhh momemployed  hssize if female==0 
		estimates store totalact

*TABLE 5: Earnings and High School Activities	

	foreach var of varlist outwis pop exp expsq mar tenure union occ ind ieduc {
		qui replace `var'=`var'74     
	}
	xi: regress lwage74 zbeautyf indivarsports inonlysports onlyvarsports indischgovt total iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	 fullhh momemployed  hssize milty pop exp expsq mar tenure union outwis i.ind i.ieduc ///
	 ivocat  if female==0 & zerowage74==0 & selfemp74==0  
		estimates store hs_wage74

	foreach var of varlist outwis pop exp expsq mar tenure union occ ind ieduc {
		qui replace `var'=`var'92
	}
	xi:regress lwage92 zbeautyf indivarsports inonlysports onlyvarsports indischgovt total iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	 fullhh momemployed  hssize milty pop exp expsq mar tenure union outwis i.ind i.ieduc ///
	 ivocat if female==0 & zerowage92==0 & selfemp92==0  
		estimates store hs_wage92

	xi: regress lwage74 zbeautyf indivarsports inonlysports onlyvarsports indischgovt total iqscore if female==0 & zerowage74==0 & selfemp74==0   
		estimates store hs_wage74iq

	xi:regress lwage92 zbeautyf indivarsports inonlysports onlyvarsports indischgovt total iqscore if female==0 & zerowage92==0 & selfemp92==0  
		estimates store hs_wage92iq

*TABLE 6: Earnings and Confidence
	xi: regress lwage74 zbeautyf selfacc92m purplife92m iqscore if female==0 & zerowage74==0 & selfemp74==0
		estimates store conf2_74iq 

	xi:regress lwage92 zbeautyf selfacc92m purplife92m iqscore  if female==0 & zerowage92==0 & selfemp92==0
		estimates store conf2_92iq

	foreach var of varlist outwis pop exp expsq mar tenure union occ ind ieduc {
		qui replace `var'=`var'74     
	}
	xi: regress lwage74 zbeautyf selfacc92m purplife92m iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	 fullhh momemployed  hssize milty pop exp expsq mar tenure union outwis i.ind i.ieduc ///
	 ivocat  if female==0 & zerowage74==0 & selfemp74==0
		estimates store conf2_74fs

	foreach var of varlist outwis pop exp expsq mar tenure union occ ind ieduc {
		qui replace `var'=`var'92
	}
	xi:regress lwage92 zbeautyf selfacc92m purplife92m iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	 fullhh momemployed  hssize milty pop exp expsq mar tenure union outwis i.ind i.ieduc ///
	 ivocat if female==0 & zerowage92==0 & selfemp92==0
		estimates store conf2_92fs

	egen zself=std(selfacc92m) if female==0
	egen zpurp=std(purplife92m) if female==0

	regress zbeautyf zself  if female==0
	regress zbeautyf zself iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 fullhh if female==0
	regress zbeautyf zpurp if female==0
	regress zbeautyf zpurp iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 fullhh if female==0
	regress zself zpurp if female==0

*TABLE 7: Attractiveness and Personality

	xi:regress extraver92m zbeautyf iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	fullhh momemployed  hssize if female==0
		estimates store extra

	xi:regress agreeable92m zbeautyf iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	fullhh momemployed  hssize if female==0
		estimates store agree 

	xi:regress conscientious92m zbeautyf iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	fullhh momemployed  hssize if female==0
		estimates store conscientious

	xi:regress neurotic92m zbeautyf iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	fullhh momemployed  hssize if female==0
		estimates store neurotic

	xi:regress open92m zbeautyf iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	fullhh momemployed  hssize if female==0
		estimates store open

*TABLE 8: Earnings, Attractiveness and Personality

	xi: regress lwage74 zbeautyf extraver92m agreeable92m conscientious92m neurotic92m open92m iqscore if female==0 & zerowage74==0 & selfemp74==0
		estimates store pers5_74iq 

	xi:regress lwage92 zbeautyf extraver92m agreeable92m conscientious92m neurotic92m open92m iqscore  if female==0 & zerowage92==0 & selfemp92==0
		estimates store pers5_92iq 

	foreach var of varlist outwis pop exp expsq mar tenure union occ ind ieduc {
		qui replace `var'=`var'74     
	}
	xi: regress lwage74 zbeautyf extraver92m agreeable92m conscientious92m neurotic92m open92m iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	 fullhh momemployed  hssize milty pop exp expsq mar tenure union outwis i.ind i.ieduc ///
	 ivocat  if female==0 & zerowage74==0 & selfemp74==0
		estimates store pers5_74fs

	foreach var of varlist outwis pop exp expsq mar tenure union occ ind ieduc {
		qui replace `var'=`var'92
	}
	xi:regress lwage92 zbeautyf extraver92m agreeable92m conscientious92m neurotic92m open92m iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	 fullhh momemployed  hssize milty pop exp expsq mar tenure union outwis i.ind i.ieduc ///
	 ivocat if female==0 & zerowage92==0 & selfemp92==0
		estimates store pers5_92fs

*TABLE 9: Earnings and All Channels	//RESULTS CHANGE BECAUSE OF NEW ACTIVITIES DATA

	xi: regress lwage74 zbeautyf indivarsports inonlysports onlyvarsports total selfacc92m purplife92m extraver92m agreeable92m conscientious92m neurotic92m open92m iqscore ///
	if female==0 & zerowage74==0 & selfemp74==0 
		estimates store gdad_74iq 

	estat hettest

*Gelbach 
	xi: b1x2 lwage74 if female==0 & zerowage74==0 & selfemp74==0 , x1all(zbeautyf iqscore) x2all(indivarsports inonlysports onlyvarsports total selfacc92m purplife92m ///
	 extraver92m agreeable92m conscientious92m neurotic92m open92m) x2delta(g1 = indivarsports inonlysports onlyvarsports total : g2=selfacc92m purplife92m ///
	: g3=extraver92m agreeable92m conscientious92m neurotic92m open92m) x1only(zbeautyf) 

	xi:regress lwage92 zbeautyf indivarsports inonlysports onlyvarsports total selfacc92m purplife92m extraver92m agreeable92m conscientious92m neurotic92m open92m iqscore /// 
	if female==0 & zerowage92==0 & selfemp92==0  
		estimates store gdad_92iq 

	estat hettest

*Gelbach 
	xi: b1x2 lwage92 if female==0 & zerowage92==0 & selfemp92==0 , x1all(zbeautyf iqscore) x2all(indivarsports inonlysports onlyvarsports total selfacc92m purplife92m ///
	 extraver92m agreeable92m conscientious92m neurotic92m open92m) x2delta(g1 = indivarsports inonlysports onlyvarsports total : g2=selfacc92m purplife92m ///
	: g3=extraver92m agreeable92m conscientious92m neurotic92m open92m) x1only(zbeautyf) 

	foreach var of varlist outwis pop exp expsq mar tenure union occ ind ieduc {
		qui replace `var'=`var'74     
	}
	xi: regress lwage74 zbeautyf indivarsports inonlysports onlyvarsports total selfacc92m purplife92m extraver92m agreeable92m conscientious92m neurotic92m open92m iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	 fullhh momemployed  hssize milty pop exp expsq mar tenure union outwis i.ind i.ieduc ///
	 ivocat  if female==0 & zerowage74==0 & selfemp74==0  
		estimates store gdad_74fs

	estat hettest

*Gelbach
	xi: b1x2 lwage74 if female==0 & zerowage74==0 & selfemp74==0 , x1all(zbeautyf iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum fullhh momemployed hssize milty pop exp expsq mar tenure union outwis i.ind i.ieduc ivocat) ///
	x2all(indivarsports inonlysports onlyvarsports total selfacc92m purplife92m extraver92m agreeable92m conscientious92m neurotic92m open92m) ///
	x2delta(g1 = indivarsports inonlysports onlyvarsports total : g2 = selfacc92m purplife92m : g3=extraver92m agreeable92m conscientious92m neurotic92m open92m) x1only(zbeautyf) 

	foreach var of varlist outwis pop exp expsq mar tenure union occ ind ieduc {
		qui replace `var'=`var'92
	}
	xi:regress lwage92 zbeautyf indivarsports inonlysports onlyvarsports total selfacc92m purplife92m extraver92m agreeable92m conscientious92m neurotic92m open92m iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	 fullhh momemployed  hssize milty pop exp expsq mar tenure union outwis i.ind i.ieduc ///
	 ivocat if female==0 & zerowage92==0 & selfemp92==0 
		estimates store gdad_92fs

	estat hettest

*Gelbach 
	xi: b1x2 lwage92 if female==0 & zerowage92==0 & selfemp92==0 , x1all(zbeautyf iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum fullhh momemployed hssize milty pop exp expsq mar tenure union outwis i.ind i.ieduc ivocat) ///
	x2all(indivarsports inonlysports onlyvarsports total selfacc92m purplife92m extraver92m agreeable92m conscientious92m neurotic92m open92m) ///
	x2delta(g1 = indivarsports inonlysports onlyvarsports total : g2 = selfacc92m purplife92m : g3=extraver92m agreeable92m conscientious92m neurotic92m open92m) x1only(zbeautyf) 


*TABLE 11: New DOT stuff

	foreach var of varlist outwis pop exp expsq mar tenure union occ ind ieduc {
		qui replace `var'=`var'74     
	}

	foreach var of varlist datam peoplem GED_Lm GED_Mm Apt_Verbalm Apt_IQm {
		di "`var': Interactions"
		qui centile `var',centile(5 20 50 80 95)
		local centlist=string(r(c_1))+" "+string(r(c_2))+" "+string(r(c_3))+" "+string(r(c_4))+" "+string(r(c_5))
		local origlab : variable label `var'

		xi: regress lwage74 c.zbeautyf##c.`var' iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
		 fullhh momemployed  hssize milty pop exp expsq mar tenure union outwis i.ieduc ///
		 ivocat  if female==0 & zerowage74==0 & selfemp74==0
			estimates store v74_`var'e
		di "Marginal effects at `var' centiles 5, 20, 50, 80 and 95"
		margins, dydx(zbeautyf) at(`var'=(`centlist'))
		marginsplot, yline(0) ytitle(" ") xtitle (" ") title("`origlab'", span) xlab(none)
		graph save "./Tables/`var'.gph",replace
	}
	graph combine "./Tables/datam.gph" ///
	"./Tables/peoplem.gph" ///
	"./Tables/Apt_Verbalm.gph" ///
	"./Tables/Apt_IQm.gph" ///
	"./Tables/GED_Lm.gph" ///
	"./Tables/GED_Mm.gph" , ycommon xcommon title("DOT 1975")
	graph export "./Tables/DOT75.ps", as(ps) replace
	!ps2pdf "./Tables/DOT75.ps"

*Employer changes

	sum numempls92 if female==0 & selfemp74==0,d 

	xi: regress numempls92 q1b q5b iqscore if female==0 & selfemp74==0  
		estimates store numemp_iq

	foreach var of varlist pop exp expsq mar tenure union outwis ind occ ieduc {
		qui replace `var'=`var'74
	}
	xi: regress numempls92 q1b q5b iqscore fathed mothed fathproex pinc57 farmbg i.ipop57 sibsnum  ///
	 fullhh momemployed  hssize milty pop exp expsq mar tenure union outwis i.ind i.ieduc ///
	 ivocat nummar7592 if female==0 & selfemp74==0  
		estimates store numemp_fs


* SUMMARY STATISTICS
di "Summary statistics"

* 1957
xi: tabstat i.ipop57 zbeautyf female iqscore  pinc57 farmbg hssize indivarsports indischgovt indiservact total hsrank /// 
if female==0, columns(statistics) statistics(mean sd min max n) varwidth(16) f(%9.3f)

* 1975
xi: tabstat i.ieduc74 pop74 exp74 mar74 tenure74 union74 outwis74 ind74 educ74 ivocat lwage74 fathed mothed fathproex sibsnum ///
fullhh  momemployed milty if female==0 & selfemp74==0 & lwage74<., columns(statistics) ///
statistics(mean sd min max n) varwidth(16) f(%9.3f)

*1992
xi: tabstat i.ieduc92 pop92 exp92 mar92 tenure92 union92 outwis92 ind92 educ92 lwage92 ///
numempls92 health dead zheight selfacc92m purplife92m h3 h4 h5 ///
extraver92m agreeable92m conscientious92m neurotic92m open92m  if female==0 & selfemp92==0 & lwage92<., columns(statistics) ///
statistics(mean sd min max n) varwidth(16) f(%9.3f)

*2011
tabstat dead if female==0 , columns(statistics) statistics(mean sd min max n) varwidth(16) f(%9.3f)

log c

****************************
*   TABLES AND FIGURES   ***
****************************

cd "./Tables"

drop aa003re-avt06sp sa006re-nb002rer ca003re-dh120 xidof77-xalcm58 ba001re-bvt06sp //drop excess vars, so outreg will work
drop _I* 

foreach num of numlist 1(1)14 {
	qui gen _Iieduc_`num'=.
	qui gen _Iipop57_`num'=.
	qui gen _Iind_`num'=.
	qui gen _Iihealth_`num'=.
}
la var _Iipop57_2 "Medium hometown population"
la var _Iipop57_3 "Large hometown population"
la var _Iieduc_2 "Educ - some college"
la var _Iieduc_3 "Educ - BA degree"
la var _Iieduc_4 "Educ - MA and beyond"
la var _Iihealth_4 "Health - good"
la var _Iihealth_5 "Health - excellent"


/* 

#delimit ;
outreg2 [v74_datame v74_peopleme v74_GED_Lme v74_GED_Mme v74_Apt_Verbalme v74_Apt_IQme] using "DOT sorting", word bdec(3) tdec(3) rdec(3) replace 
title(Table tbd,"Sorting, Based on the Dictionary of Occupational Titles, 1975") 
addnote("Note: ")  
drop(fathed mothed fathproex pinc57 farmbg _Iipop57* sibsnum fullhh momemployed hssize milty pop exp* mar tenure union outwis _Iieduc* ivocat)
label
;
#delimit cr


#delimit ;
outreg2 [numemp_iq numemp_fs] using "Revised Employer Changes", word bdec(3) tdec(3) rdec(3) replace 
title(Table tbd,"Employer Changes between 1975 and 1992") 
addnote("Note: Excludes self-employed.")  
sortvar(q1b q5b iqscore tenure _Iieduc* ivocat exp* mar outwis fathed mothed fathproex pinc57 farmbg _Iipop57*)
drop (_Iind*)
label
;
#delimit cr


#delimit ;
outreg2 [edbeau rankbeau iqbeau edbeau_bg rankbeau_bg iqbeau_bg] using "Revised EducRankIQ", word bdec(3) tdec(3) rdec(3) replace 
title(Table tbd,"Basic Correlations of Attractiveness with Education, High School Rank and IQ") 
addnote("Note: ")  
label
;
#delimit cr


#delimit ;
outreg2 [a_wage74iq a_wage92iq a_wage74fs a_wage92fs] using "Revised Table 1", word bdec(3) tdec(3) rdec(3) replace 
title(Table 1, "Attractiveness and Log Earnings of Men") 
addnote("Note 1. Excludes self-employed. Included in this category are individuals that reported a wage, but derived a majority of their income from their business and were self-employed in the other wave of the survey.  Note 2. Regressions in columns III and IV also include industry dummies.")  
drop (_Iind*)
label
sortvar(zbeautyf iqscore _Iieduc* ivocat exp* tenure mar outwis fathed mothed fathproex pinc57 farmbg _Iipop57*)
;
#delimit cr

#delimit ;
outreg2 [hgt74iq hgt92iq hgt74 hgt92] using "Revised Table 2", word bdec(3) tdec(3) rdec(3) replace 
title(Table 2, "Facial Attractiveness, Height and Earnings") 
addnote("Note: Excludes self-employed.  Regressions in columns III and IV also include industry dummies as well as the covariates in columns 3 and 4 of Table 1.")  
sortvar(zbeautyf zheight iqscore _Iieduc* ivocat exp* tenure mar outwis fathed mothed fathproex pinc57 farmbg _Iipop57*)
keep(zbeautyf zheight iqscore)
label
;
#delimit cr


#delimit ;
outreg2 [quint_74iq quint_92iq quintiles_74 quintiles_92] using "Revised Quintile Regressions", word bdec(3) tdec(3) rdec(3) replace 
title(Table 2 Panel 2, "Robustness of the Facial Attractiveness - Earnings Correlation") 
addnote("Note: In Panel 2, the reference category is the 3rd quintile.")  
keep(q1b q2b q4b q5b iqscore)
label
;
#delimit cr


#delimit ;
outreg2 [mortiq mortfs oprob_iq oprob_fs] using "Revised Table 3", word bdec(3) tdec(3) rdec(3) replace 
title(Table 3, "Attractiveness and Health") 
addnote("Note: Dependent variable is self-rated health status on a 4 point scale.  Exclusions same as in earnings regressions.")  
sortvar(zbeautyf iqscore _Iieduc* ivocat exp* tenure mar outwis fathed mothed fathproex pinc57 farmbg _Iipop57*)
drop (_Iind*)
label
;
#delimit cr


#delimit ;
outreg2 [varsprt studntgov servicorg totalact] using "Revised Table 4", word bdec(3) tdec(3) rdec(3) replace 
title(Table 4, "Attractiveness and Early Human Capital Formation") 
addnote("Note: Marginal effects and pseudo r-squared are reported in probit regressions (columns 1-3)")  
label
;
#delimit cr

#delimit ;
outreg2 [hs_wage74iq hs_wage92iq hs_wage74 hs_wage92] using "Revised Table 5", word bdec(3) tdec(3) rdec(3) replace 
title(Table 5, "Earnings and High School Activities") 
addnote("Note: Excludes self-employed.  Regressions in columns III and IV also include industry dummies.")  
sortvar(zbeautyf indivarsports indischgovt total iqscore _Iieduc* ivocat exp* tenure mar outwis fathed mothed fathproex pinc57 farmbg _Iipop57*)
drop (_Iind* inonlysports onlyvarsports)
label
;
#delimit cr

#delimit ;
outreg2 [conf2_74iq conf2_92iq conf2_74fs conf2_92fs] using "Revised Table 6", word bdec(3) tdec(3) rdec(3) replace 
title(Table 6, "Earnings and Confidence") 
addnote("Note: Excludes self-employed.  Regressions in columns III and IV also include industry dummies.")  
sortvar(zbeautyf selfacc92m purplife92m iqscore _Iieduc* ivocat exp* tenure mar outwis fathed mothed fathproex pinc57 farmbg _Iipop57*)
drop (_Iind*)
label
;
#delimit cr

#delimit ;
outreg2 [extra agree conscientious neurotic open] using "Revised Table 7", word bdec(3) tdec(3) rdec(3) replace 
title(Table 7, "Attractiveness and Personality") 
addnote("Note: Dependent variables are summary scores.")  
label
;
#delimit cr

#delimit ;
outreg2 [pers5_74iq pers5_92iq pers5_74fs pers5_92fs] using "Revised Table 8", word bdec(3) tdec(3) rdec(3) replace 
title(Table 8, "Earnings, Attractiveness and Personality") 
addnote("Note: Excludes self-employed.  Regressions in columns III and IV also include industry dummies.")  
sortvar(zbeautyf extraver92m agreeable92m conscientious92m neurotic92m open92m iqscore _Iieduc* ivocat exp* tenure mar outwis fathed mothed fathproex pinc57 farmbg _Iipop57*)
drop (_Iind*)
label
;
#delimit cr


#delimit ;
outreg2 [gdad_74iq gdad_92iq gdad_74fs gdad_92fs] using "Revised Table 9", word bdec(3) tdec(3) rdec(3) replace 
title(Table 9, "Earnings and All Channels") 
addnote("Note: Excludes self-employed.  Regressions in columns III and IV also include industry dummies.")  
sortvar(zbeautyf indivarsports indischgovt total selfacc92m purplife92m extraver92m agreeable92m conscientious92m neurotic92m open92m iqscore _Iieduc* ivocat exp* tenure mar outwis fathed mothed fathproex pinc57 farmbg _Iipop57*)
drop (_Iind* inonlysports onlyvarsports) 
label
;
#delimit cr

#delimit ;
outreg2 [a_wage74iq a_wage92iq a_wage74fs a_wage92fs] using "Revised Table 1 with health", word bdec(3) tdec(3) rdec(3) replace 
title(Table 1, "Attractiveness and Log Earnings of Men") 
addnote("Note 1. Excludes self-employed. Included in this category are individuals that reported a wage, but derived a majority of their income from their business and were self-employed in the other wave of the survey.  Note 2. Regressions in columns III and IV also include industry dummies.")  
drop (_Iind*)
label
sortvar(zbeautyf _Iihealth* iqscore _Iieduc* ivocat exp* tenure mar outwis fathed mothed fathproex pinc57 farmbg _Iipop57*)
;
#delimit cr
*/
