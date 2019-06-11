**** generating variables ****

//main variables 
	gen dutyvote=Q67
		recode dutyvote 1=1 2=0 9=.

	gen voted=Q40
		recode voted 1/3=0 4=1

	gen nationpride=Q19
		recode nationpride 1=2 2=1 3/4=0 9=.

//covariates
	gen collective=Q27
		recode collective 1=10 2=9 3=8 4=7 5=6 6=5 7=4 8=3 9=2 10=1 99=.
		
	gen demsat=Q28
		recode demsat 99=.
	
	gen demsat3=demsat
		recode demsat3 0/4=0 5=1 6/10=2
	
	gen female=Q15
	recode female 1=0 2=1

	gen age=Q16
	gen agecat=age
		recode agecat 19/29=1 30/39=2 40/49=3 50/59=4 60/88=5
		
	gen trustpeople=Q35
		recode trustpeople 1=3 2=2 3=1 4=0 9=.
		
	gen partystrength=.
		replace partystrength=2 if Q50==1|Q50==2|Q50==3|Q50==4|Q50==5
		replace partystrength=1 if Q51==1|Q51==2|Q51==3|Q51==4|Q51==5
		replace partystrength=0 if Q51==6
	
	gen party=.
		replace party=1 if Q50==1 | Q50==4 | Q51==1 | Q51==4
		replace party=2 if Q50==2 | Q51==2
		replace party=0 if Q50==3 | Q51==3 | Q50==5 | Q51==5
		label define part 0 "other" 1 "cons" 2 "lib"
		label values party part
	
	gen educ=Q120 
		recode educ 0=0 8=0 1/2=0 3/4=1 5=2 6/7=3
		label define educlevel 0 "under hs" 1 "hs" 2 "college" 3 "above"
		label values educ educlevel
	
	gen incomelevel=Q124
		recode incomelevel 99=.
		
	gen electint=Q38
		recode electint 1=0 2=1 3=2 4=3 9=.
		
//rescale all variables 0-1
	replace nationpride=nationpride/2
	replace collective=(collective-1)/9
	replace electint=electint/3
	replace agecat=(agecat-1)/4
	replace trustpeople=(trustpeople-1)/3
	replace partystrength=partystrength/2
	replace educ=educ/3
	gen educsq=(educ)^2
	replace incomelevel=(incomelevel-1)/8
	replace age=(age-19)/69
	gen agesq=(age)^2
		

**** analysis ****

// replicate main results in table 2, column 1
logit dutyvote c.nationpride##c.partystrength collective trustpeople electint age agesq educ i.party [pweight=wt]

// in odds ratios
logit dutyvote c.nationpride##c.partystrength collective trustpeople electint age agesq educ i.party [pweight=wt], or



// replicate figuure 1, left column
logit dutyvote c.nationpride##c.partystrength collective trustpeople electint age agesq educ i.party [pweight=wt]
margins, dydx(partystrength) at(nationpride=(0(.1)1))
marginsplot


//placebo test: still get neg interaction when nationpride replaced with a non-identity incentive? no
logit dutyvote c.demsat##c.partystrength collective trustpeople electint age agesq educ i.party [pweight=wt]
logit dutyvote c.electint##c.partystrength collective trustpeople electint age agesq educ i.party [pweight=wt]

//placebo test2: neg interaction holds when partystrengh replaced with diff incentive? yes
logit dutyvote c.nationpride##c.electint collective trustpeople electint age agesq educ [pweight=wt]
logit dutyvote c.nationpride##c.demsat collective trustpeople electint age agesq educ [pweight=wt]
