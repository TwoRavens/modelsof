
/////// part I: survey analysis ///////

**** recode variables ****

gen ppltrust=Q8
	recode ppltrust 1=0 2=1 3=2 4=3 5=4
	
gen polint=Q1
	recode polint 3/4=0 2=1 1=2
	
gen collective=Q3
	recode collective 4/5=0 3=1 2=2 1=3

gen agecat=age
	recode agecat 1=0 2=1 3=2 4=3 5=4 9=.

gen educat=edu
	recode educat 1/2=0 3=1 4=2 5=3 9=.
	label define edu 0 "below hs" 1 "hs" 2 "tech college" 3 "post univ"
	label values educat edu
	
gen female=sex
	recode female 1=0 2=1
		
gen income=Q49-1
	
gen dutyvote=Q15a
	recode dutyvote 2/3=1 1=2 9=0

gen nation_close=Q25_2
	recode nation_close 4=0 3=1 2=2 1=3

gen trust_elections=Q19
	recode trust_elections 1=2 2=1 3/5=0
	
gen trustgov=Q6
	recode trustgov 5=0 4=1 3=2 1/2=3
	
gen trustgov3=trustgov
		recode trustgov3 0/1=0 2=1 3=2
		
gen demsat=Q5
	recode demsat 4=0 3=1 2=2 1=3
	
	gen demsat3=demsat
		recode demsat3 1/2=2 3=1 4=0
	
// national types
gen territory=Q34
	recode territory 1=1 2=0
gen countrymen=Q35
	recode countrymen 1=1 2/3=0		
gen countrygov=Q36
	recode countrygov 1=1 2/3=0
gen culturediff2=Q37
	recode culturediff2 1/2=1 3/4=0
	

// definitions of taiwan

	// taiwan = own state and people/culture (dpp stance)
	gen taiwan_nation=0
		replace taiwan_nation=1 if territory==1 & countrygov==1 & countrymen==1 & culturediff2==1
	
	// taiwan = political state, part of chinese culture/people (weak kmt stance)
	gen taiwan_state1=0
		replace taiwan_state1=1 if territory==1 & countrygov==1 & countrymen==1 & culturediff2==0
	
	gen taiwan_state2=0
		replace taiwan_state2=1 if territory==1 & countrygov==1 & countrymen==0 & culturediff2==0
	
	// taiwan = part of china (strong kmt stance)
		
	gen taiwan_partchina1=0
		replace taiwan_partchina1=1 if territory==0 & countrygov==1 & countrymen==0 & culturediff2==0
	
	gen taiwan_partchina=0
		replace taiwan_partchina=1 if territory==0 & countrygov==0 & countrymen==0 & culturediff2==0

						
	gen nationtypes=.
	replace nationtypes=1 if taiwan_nation==1
	replace nationtypes=2 if taiwan_state1==1
	replace nationtypes=3 if taiwan_partchina==1	

	
**** analysis ****
//rescale variables 0-1
replace dutyvote=dutyvote/2
replace polint=polint/2
replace trust_elections=trust_elections/2
replace nation_close=nation_close/3
replace agecat=agecat/4
gen agesq=(agecat)^2
replace educat=educat/3
replace collective=collective/3
replace ppltrust=ppltrust/4
replace income=income/9
replace demsat3=demsat3/2


//replicate results in table 2
//pooled
reg dutyvote c.nation_close##c.trust_elections collective ppltrust polint agecat agesq educat [pweight=wt] if nationtypes!=.

//china nationalists
reg dutyvote c.nation_close##c.trust_elections collective ppltrust polint agecat agesq educat [pweight=wt] if taiwan_partchina==1 

//new taiwanese
reg dutyvote c.nation_close##c.trust_elections collective ppltrust polint agecat agesq educat [pweight=wt] if taiwan_state1==1


//taiwan nationalists
reg dutyvote c.nation_close##c.trust_elections collective ppltrust polint agecat agesq educat [pweight=wt] if taiwan_nation==1

//replicate figure 1, right column
reg dutyvote i.nationtypes##c.nation_close##c.trust_elections collective ppltrust polint agecat agesq educat [pweight=wt] if nationtypes!=.
margins nationtypes, dydx(trust_elections) at(nation_close=(0(.1)1))
marginsplot, noci

// replicate table 3
gen dutytax_china=Q33
	recode dutytax_china 3/5=0 2=1 1=2
	replace dutytax_china=dutytax_china/2
	
gen class=Q9
	recode class 4/5=0 3=1  1/2=2
	replace class=class/2

reg dutytax_china nation_close collective ppltrust class female agecat agesq [pweight=wt] if taiwan_partchina==1 
reg dutytax_china nation_close collective ppltrust class female agecat agesq [pweight=wt] if taiwan_nation==1

//replicate appendix 2: placebo test replacing trust_elections with diff incentive (democratic satisfaction)
reg dutyvote c.nation_close##c.demsat3 collective ppltrust polint agecat agesq educat [pweight=wt] if nationtypes==1
reg dutyvote c.nation_close##c.demsat3 collective ppltrust polint agecat agesq educat [pweight=wt] if nationtypes==2
reg dutyvote c.nation_close##c.demsat3 collective ppltrust polint agecat agesq educat [pweight=wt] if nationtypes==3

//replicate appendix 8
	gen nationtypes2=.
	replace nationtypes2=1 if territory==1 & countrygov==1 & countrymen==1
	replace nationtypes2=2 if territory==1 & countrygov==1 & countrymen==0
	replace nationtypes2=3 if territory==0 & countrygov==0 & countrymen==0

reg dutyvote c.nation_close##c.trust_elections collective ppltrust polint agecat agesq educat [pweight=wt] if nationtypes2==1
reg dutyvote c.nation_close##c.trust_elections collective ppltrust polint agecat agesq educat [pweight=wt] if nationtypes2==2
reg dutyvote c.nation_close##c.trust_elections collective ppltrust polint agecat agesq educat [pweight=wt] if nationtypes2==3


//////// part 2: experiment /////////

gen duty=Q48
	recode duty 1=1 2=0
	
gen moreclose=Q47
	recode moreclose 3/5=0 2=1 1=2
	replace moreclose=moreclose/2
replace trustgov3=trustgov3/2


//replicate appendix 5: covariate balance check
ttest female, by(treatment) 
ttest agecat, by(treatment)
ttest educat, by(treatment)
ttest taiwan_nation, by(treatment)
ttest taiwan_state1, by(treatment)
ttest taiwan_partchina, by(treatment)
ttest taiwan_partchina1, by(treatment)
ttest collective, by(treatment)
ttest trustgov3, by(treatment)

*** treatment effects (duty attitude)***

// replicate figure 2
	reg duty treatment if nationtypes!=. [pweight=wt]
	estimates store all
	
	reg duty treatment if taiwan_nation==1 [pweight=wt]
	estimates store taiwan
	
	reg duty treatment if taiwan_partchina==1 | taiwan_partchina1==1 [pweight=wt]
	estimates store china
	
	coefplot all taiwan china, drop(_cons)
	
// replicate appendix 6: manipulation check

by treatment, sort: tab moreclose
ttest moreclose, by(treatment)
ttest moreclose if taiwan_partchina==1, by(treatment)
ttest moreclose if taiwan_partchina==1 | taiwan_partchina1==1, by(treatment)

ttest moreclose if taiwan_state2==1, by(treatment)
ttest moreclose if taiwan_state1==1, by(treatment)
ttest moreclose if taiwan_nation==1, by(treatment)

//replicate graph

gen tc=.
replace tc=0 if taiwan_nation==1
replace tc=1 if taiwan_partchina==1 | taiwan_partchina1==1

collapse (mean) meanclose=moreclose (sd) sdclose=moreclose (count) n=moreclose, by(treatment tc)
gen hiclose=meanclose+invttail(n-1, 0.025)*(sdclose/sqrt(n))
gen lowclose=meanclose-invttail(n-1, 0.025)*(sdclose/sqrt(n))
graph twoway (bar meanclose treatment) (rcap hiclose lowclose treatment), by(tc)
