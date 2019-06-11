//Replication file for Cassese & Barnes POBE
//This file is used to create:
	//Tables 1-3 
	//A2-A6 in the online appendix (Table A1 is a desription of variables)
	//Figure 3
	//Figure A1 


clear
set more off
use  "ReplicationCassese&Barnes POBE.dta"


//Table 1. Determinants of Vote Choice Among Men and Women in 2012 and 2016
estimates clear
//Table 1. Model 1 2012 Vote for Romney Men
eststo: svy, subpop(if female==0):logit rep_votepres black hispanic other   college upper lower employed homemaker age married children cattend literal south  independent republican ideo7  if year==2012 
//store the estimates so I can compare them to the 2016 estimates using a seemingly unrealated logit and a wald test
estimates store estmen 

//Table 1. Model 2 2012 Vote for Romney Women
eststo: svy, subpop(if female==1):logit rep_votepres black hispanic other  college upper lower employed homemaker age married children cattend literal south  independent republican ideo7  if year==2012 
//store the estimates so I can compare them to the 2016 estimates using a seemingly unrealated logit and a wald test
estimates store estwomen

//use seemingly unrelated logit and wald test to compare estimates for men and women
//I shade the cells where the estimates are statistically different at the p<.10 level or lower
	suest estmen estwomen
	test [estmen_rep_votepres]black=[estwomen_rep_votepres]black
	test [estmen_rep_votepres]hispanic=[estwomen_rep_votepres]hispanic
	test [estmen_rep_votepres]other=[estwomen_rep_votepres]other
	test [estmen_rep_votepres]college=[estwomen_rep_votepres]college
	test [estmen_rep_votepres]upper=[estwomen_rep_votepres]upper
	test [estmen_rep_votepres]lower=[estwomen_rep_votepres]lower	
	test [estmen_rep_votepres]employed=[estwomen_rep_votepres]employed
	test [estmen_rep_votepres]homemaker=[estwomen_rep_votepres]homemaker
	test [estmen_rep_votepres]age=[estwomen_rep_votepres]age
	test [estmen_rep_votepres]married=[estwomen_rep_votepres]married
	test [estmen_rep_votepres]children=[estwomen_rep_votepres]children
	test [estmen_rep_votepres]cattend=[estwomen_rep_votepres]cattend
	test [estmen_rep_votepres]literal=[estwomen_rep_votepres]literal
	test [estmen_rep_votepres]south=[estwomen_rep_votepres]south
	test [estmen_rep_votepres]independent=[estwomen_rep_votepres]independent
	test [estmen_rep_votepres]republican=[estwomen_rep_votepres]republican
	test [estmen_rep_votepres]ideo7=[estwomen_rep_votepres]ideo7




estimates clear
//Table 1. Model 3 2016 Vote for Trump Men
eststo: svy, subpop(if female==0):logit  rep_votepres black hispanic other   college upper lower employed homemaker age married children cattend literal south  independent republican ideo7 if year==2016
//store the estimates so I can compare them to the 2016 estimates using a seemingly unrealated logit and a wald test
estimates store estmen


//Table 1. Model 4 2016 Vote for Trump Women

eststo: svy, subpop(if female==1):logit rep_votepres  black hispanic other   college upper lower employed homemaker age married children cattend literal south  independent republican ideo7 if year==2016
//store the estimates so I can compare them to the 2016 estimates using a seemingly unrealated logit and a wald test
estimates store estwomen

//use seemingly unrelated logit and wald test to compare estimates for men and women
//I shade the cells where the estimates are statistically different at the p<.10 level or lower
	suest estmen estwomen
	test [estmen_rep_votepres]black=[estwomen_rep_votepres]black
	test [estmen_rep_votepres]hispanic=[estwomen_rep_votepres]hispanic
	test [estmen_rep_votepres]other=[estwomen_rep_votepres]other
	test [estmen_rep_votepres]college=[estwomen_rep_votepres]college
	test [estmen_rep_votepres]upper=[estwomen_rep_votepres]upper
	test [estmen_rep_votepres]lower=[estwomen_rep_votepres]lower	
	test [estmen_rep_votepres]employed=[estwomen_rep_votepres]employed
	test [estmen_rep_votepres]homemaker=[estwomen_rep_votepres]homemaker
	test [estmen_rep_votepres]age=[estwomen_rep_votepres]age
	test [estmen_rep_votepres]married=[estwomen_rep_votepres]married
	test [estmen_rep_votepres]children=[estwomen_rep_votepres]children
	test [estmen_rep_votepres]cattend=[estwomen_rep_votepres]cattend
	test [estmen_rep_votepres]literal=[estwomen_rep_votepres]literal
	test [estmen_rep_votepres]south=[estwomen_rep_votepres]south
	test [estmen_rep_votepres]independent=[estwomen_rep_votepres]independent
	test [estmen_rep_votepres]republican=[estwomen_rep_votepres]republican
	test [estmen_rep_votepres]ideo7=[estwomen_rep_votepres]ideo7



estimates clear
//Table 1. Model 5 2012 Vote for Romney White Men
eststo: svy, subpop(if female==0 & white==1):logit rep_votepres  college upper lower employed homemaker age married children cattend literal south  independent republican ideo7  if year==2012 
//store the estimates so I can compare them to the 2016 estimates using a seemingly unrealated logit and a wald test
estimates store estmen

//Table 1. Model 6 2012 Vote for Romney White Women
eststo: svy, subpop(if female==1 & white==1):logit rep_votepres    college upper lower employed homemaker age married children cattend literal south  independent republican ideo7  if year==2012 
//store the estimates so I can compare them to the 2016 estimates using a seemingly unrealated logit and a wald test
estimates store estwomen

//use seemingly unrelated logit and wald test to compare estimates for men and women
//I shade the cells where the estimates are statistically different at the p<.10 level or lower
	suest estmen estwomen

	test [estmen_rep_votepres]college=[estwomen_rep_votepres]college
	test [estmen_rep_votepres]upper=[estwomen_rep_votepres]upper
	test [estmen_rep_votepres]lower=[estwomen_rep_votepres]lower	
	test [estmen_rep_votepres]employed=[estwomen_rep_votepres]employed
	test [estmen_rep_votepres]homemaker=[estwomen_rep_votepres]homemaker
	test [estmen_rep_votepres]age=[estwomen_rep_votepres]age
	test [estmen_rep_votepres]married=[estwomen_rep_votepres]married
	test [estmen_rep_votepres]children=[estwomen_rep_votepres]children
	test [estmen_rep_votepres]cattend=[estwomen_rep_votepres]cattend
	test [estmen_rep_votepres]literal=[estwomen_rep_votepres]literal
	test [estmen_rep_votepres]south=[estwomen_rep_votepres]south
	test [estmen_rep_votepres]independent=[estwomen_rep_votepres]independent
	test [estmen_rep_votepres]republican=[estwomen_rep_votepres]republican
	test [estmen_rep_votepres]ideo7=[estwomen_rep_votepres]ideo7


estimates clear
//Table 1. Model 7 2016 Vote for Romney White Men
eststo: svy, subpop(if female==0 & white==1):logit rep_votepres  college upper lower employed homemaker age married children cattend literal south  independent republican ideo7  if year==2016 
//store the estimates so I can compare them to the 2016 estimates using a seemingly unrealated logit and a wald test
estimates store estmen

//Table 1. Model 8 2016 Vote for Romney White Women
eststo: svy, subpop(if female==1 & white==1):logit rep_votepres    college upper lower employed homemaker age married children cattend literal south  independent republican ideo7  if year==2016 
//store the estimates so I can compare them to the 2016 estimates using a seemingly unrealated logit and a wald test
estimates store estwomen

//use seemingly unrelated logit and wald test to compare estimates for men and women
//I shade the cells where the estimates are statistically different at the p<.10 level or lower
	suest estmen estwomen

	test [estmen_rep_votepres]college=[estwomen_rep_votepres]college
	test [estmen_rep_votepres]upper=[estwomen_rep_votepres]upper
	test [estmen_rep_votepres]lower=[estwomen_rep_votepres]lower	
	test [estmen_rep_votepres]employed=[estwomen_rep_votepres]employed
	test [estmen_rep_votepres]homemaker=[estwomen_rep_votepres]homemaker
	test [estmen_rep_votepres]age=[estwomen_rep_votepres]age
	test [estmen_rep_votepres]married=[estwomen_rep_votepres]married
	test [estmen_rep_votepres]children=[estwomen_rep_votepres]children
	test [estmen_rep_votepres]cattend=[estwomen_rep_votepres]cattend
	test [estmen_rep_votepres]literal=[estwomen_rep_votepres]literal
	test [estmen_rep_votepres]south=[estwomen_rep_votepres]south
	test [estmen_rep_votepres]independent=[estwomen_rep_votepres]independent
	test [estmen_rep_votepres]republican=[estwomen_rep_votepres]republican
	test [estmen_rep_votepres]ideo7=[estwomen_rep_votepres]ideo7




**************************************************************
//Table 2: Hostile Sexism and Discrimination among White Women
**************************************************************

set more off
eststo clear
//Table 2. Model 1 (2012 Hostile Sexism Model)
eststo: svy, subpop(if female==1 & white==1): regress   hostile_short  college upper lower unemployed homemaker age married children cattend literal south independent republican ideo7 govscopez egalz if year==2012

//Table 2. Model 2 (2016 Hostile Sexism Model)
eststo: svy, subpop(if female==1 & white==1): regress    hostile_short  college upper lower unemployed homemaker age married children cattend literal south independent republican ideo7 govscopez egalz if year==2016


//Table 2. Model 3 (2012 Discrimination Agains Women Model)
eststo: svy, subpop(if female==1 & white==1):ologit   discrim_women  college upper lower unemployed homemaker age married children cattend literal south independent republican ideo7 govscopez egalz if year==2012


//Table 2. Model 4 (2016 Discrimination Agains Women Model)
eststo: svy, subpop(if female==1 & white==1):ologit   discrim_women  college upper lower unemployed homemaker age married children cattend literal south independent republican ideo7 govscopez egalz if year==2016

**************************************************************
//Table 3: Sexism and White Women’s Vote Choice in 2012 and 2016
**************************************************************

set more off
eststo clear

//Table 3. Model 1 2012 Vote for Romney
eststo: svy, subpop(if female==1 & white==1):logit  rep_votepres hostile_short discrim_women college upper lower employed homemaker age married children cattend literal south  independent republican ideo7 govscopez egalz racialresentz author_add  if year==2012 
//store the estimates so I can compare them to the 2016 estimates using a seemingly unrealated logit and a wald test
estimates store est2012

//Table 3. Model 1 2012 Vote for Trump
eststo: svy, subpop(if female==1 & white==1):logit  rep_votepres hostile_short discrim_women college upper lower employed homemaker age married children cattend literal south  independent republican ideo7 govscopez egalz racialresentz author_add if year==2016
//store the estimates so I can compare them to the 2016 estimates using a seemingly unrealated logit and a wald test
estimates store est2016

//use seemingly unrelated logit and wald test to compare estimates in 2012 to estimates in 2016
//I shade the cells where the estimates are statistically different at the p<.10 level or lower
	suest est2012 est2016
	test [est2012_rep_votepres]hostile_short=[est2016_rep_votepres]hostile_short
	test [est2012_rep_votepres]discrim_women=[est2016_rep_votepres]discrim_women
	test [est2012_rep_votepres]college=[est2016_rep_votepres]college
	test [est2012_rep_votepres]lower=[est2016_rep_votepres]lower
	test [est2012_rep_votepres]homemaker=[est2016_rep_votepres]homemaker
	test [est2012_rep_votepres]south=[est2016_rep_votepres]south
	test [est2012_rep_votepres]govscopez=[est2016_rep_votepres]govscopez
	test [est2012_rep_votepres]egalz=[est2016_rep_votepres]egalz
	test [est2012_rep_votepres]racialresentz=[est2016_rep_votepres]racialresentz
	test [est2012_rep_votepres]author_add=[est2016_rep_votepres]author_add

 

**************************************************************
//Online Appendix
**************************************************************


//Table A1. Variable Descriptions
//This table is a discription of how varaibles are coded. 

**************************************************************
//Table A2. Voter Characteristics in 2016 
**************************************************************

//All Survey Respondents (Columns 2-5)
svy: tab race if rep_votepres==0 & female==0 & year==2016
svy: tab race if rep_votepres==0 & female==1 & year==2016
svy: tab race if rep_votepres==1 & female==0 & year==2016
svy: tab race if rep_votepres==1 & female==1 & year==2016
svy: tab college if rep_votepres==0 & female==0 & year==2016
svy: tab college if rep_votepres==0 & female==1 & year==2016
svy: tab college if rep_votepres==1 & female==0 & year==2016
svy: tab college if rep_votepres==1 & female==1 & year==2016


svy: tab inc3 if rep_votepres==0 & female==0 & year==2016
svy: tab inc3 if rep_votepres==0 & female==1 & year==2016
svy: tab inc3 if rep_votepres==1 & female==0 & year==2016
svy: tab inc3 if rep_votepres==1 & female==1 & year==2016


svy: tab employed if rep_votepres==0 & female==0 & year==2016
svy: tab employed if rep_votepres==0 & female==1 & year==2016
svy: tab employed if rep_votepres==1 & female==0 & year==2016
svy: tab employed if rep_votepres==1 & female==1 & year==2016

svy: tab homemaker if rep_votepres==0 & female==0 & year==2016
svy: tab homemaker if rep_votepres==0 & female==1 & year==2016
svy: tab homemaker if rep_votepres==1 & female==0 & year==2016
svy: tab homemaker if rep_votepres==1 & female==1 & year==2016


svy: tab age3 if rep_votepres==0 & female==0 & year==2016
svy: tab age3 if rep_votepres==0 & female==1 & year==2016
svy: tab age3 if rep_votepres==1 & female==0 & year==2016
svy: tab age3 if rep_votepres==1 & female==1 & year==2016

svy: tab married if rep_votepres==0 & female==0 & year==2016
svy: tab married if rep_votepres==0 & female==1 & year==2016
svy: tab married if rep_votepres==1 & female==0 & year==2016
svy: tab married if rep_votepres==1 & female==1 & year==2016

svy: tab child if rep_votepres==0 & female==0 & year==2016
svy: tab child if rep_votepres==0 & female==1 & year==2016
svy: tab child if rep_votepres==1 & female==0 & year==2016
svy: tab child if rep_votepres==1 & female==1 & year==2016


svy: tab church if rep_votepres==0 & female==0 & year==2016
svy: tab church if rep_votepres==0 & female==1 & year==2016
svy: tab church if rep_votepres==1 & female==0 & year==2016
svy: tab church if rep_votepres==1 & female==1 & year==2016

svy: tab literal if rep_votepres==0 & female==0 & year==2016
svy: tab literal if rep_votepres==0 & female==1 & year==2016
svy: tab literal if rep_votepres==1 & female==0 & year==2016
svy: tab literal if rep_votepres==1 & female==1 & year==2016

svy: tab south if rep_votepres==0 & female==0 & year==2016
svy: tab south if rep_votepres==0 & female==1 & year==2016
svy: tab south if rep_votepres==1 & female==0 & year==2016
svy: tab south if rep_votepres==1 & female==1 & year==2016

gen pid3  = 1 if republican ==1
replace pid3  = 2 if republican ==0 & independent==0
replace pid3  = 3 if independent==1

svy: tab pid3 if rep_votepres==0 & female==0 & year==2016
svy: tab pid3 if rep_votepres==0 & female==1 & year==2016
svy: tab pid3 if rep_votepres==1 & female==0 & year==2016
svy: tab pid3 if rep_votepres==1 & female==1 & year==2016

svy: tab republican if rep_votepres==0 & female==0 & year==2016
svy: tab pid3 if rep_votepres==0 & female==1 & year==2016
svy: tab pid3 if rep_votepres==1 & female==0 & year==2016
svy: tab pid3 if rep_votepres==1 & female==1 & year==2016



//White Survey Respondents Only (Columns 6-9)
svy: tab college if rep_votepres==0 & female==0 & year==2016 & race==1
svy: tab college if rep_votepres==0 & female==1 & year==2016 & race==1
svy: tab college if rep_votepres==1 & female==0 & year==2016 & race==1
svy: tab college if rep_votepres==1 & female==1 & year==2016 & race==1


svy: tab inc3 if rep_votepres==0 & female==0 & year==2016 & race==1
svy: tab inc3 if rep_votepres==0 & female==1 & year==2016 & race==1
svy: tab inc3 if rep_votepres==1 & female==0 & year==2016 & race==1
svy: tab inc3 if rep_votepres==1 & female==1 & year==2016 & race==1


svy: tab employed if rep_votepres==0 & female==0 & year==2016 & race==1
svy: tab employed if rep_votepres==0 & female==1 & year==2016 & race==1
svy: tab employed if rep_votepres==1 & female==0 & year==2016 & race==1
svy: tab employed if rep_votepres==1 & female==1 & year==2016 & race==1

svy: tab homemaker if rep_votepres==0 & female==0 & year==2016 & race==1
svy: tab homemaker if rep_votepres==0 & female==1 & year==2016 & race==1
svy: tab homemaker if rep_votepres==1 & female==0 & year==2016 & race==1
svy: tab homemaker if rep_votepres==1 & female==1 & year==2016 & race==1


svy: tab age3 if rep_votepres==0 & female==0 & year==2016 & race==1
svy: tab age3 if rep_votepres==0 & female==1 & year==2016 & race==1
svy: tab age3 if rep_votepres==1 & female==0 & year==2016 & race==1
svy: tab age3 if rep_votepres==1 & female==1 & year==2016 & race==1

svy: tab married if rep_votepres==0 & female==0 & year==2016 & race==1
svy: tab married if rep_votepres==0 & female==1 & year==2016 & race==1
svy: tab married if rep_votepres==1 & female==0 & year==2016 & race==1
svy: tab married if rep_votepres==1 & female==1 & year==2016 & race==1

svy: tab child if rep_votepres==0 & female==0 & year==2016 & race==1
svy: tab child if rep_votepres==0 & female==1 & year==2016 & race==1
svy: tab child if rep_votepres==1 & female==0 & year==2016 & race==1
svy: tab child if rep_votepres==1 & female==1 & year==2016 & race==1


svy: tab church if rep_votepres==0 & female==0 & year==2016 & race==1
svy: tab church if rep_votepres==0 & female==1 & year==2016 & race==1
svy: tab church if rep_votepres==1 & female==0 & year==2016 & race==1
svy: tab church if rep_votepres==1 & female==1 & year==2016 & race==1

svy: tab literal if rep_votepres==0 & female==0 & year==2016 & race==1
svy: tab literal if rep_votepres==0 & female==1 & year==2016 & race==1
svy: tab literal if rep_votepres==1 & female==0 & year==2016 & race==1
svy: tab literal if rep_votepres==1 & female==1 & year==2016 & race==1

svy: tab south if rep_votepres==0 & female==0 & year==2016 & race==1
svy: tab south if rep_votepres==0 & female==1 & year==2016 & race==1
svy: tab south if rep_votepres==1 & female==0 & year==2016 & race==1
svy: tab south if rep_votepres==1 & female==1 & year==2016 & race==1

svy: tab pid3 if rep_votepres==0 & female==0 & year==2016 & race==1
svy: tab pid3 if rep_votepres==0 & female==1 & year==2016 & race==1
svy: tab pid3 if rep_votepres==1 & female==0 & year==2016 & race==1
svy: tab pid3 if rep_votepres==1 & female==1 & year==2016 & race==1


**************************************************************
//Table A3. Voter Characteristics in 2012 
**************************************************************

//All Survey Respondents (Columns 2-5)
svy: tab race if rep_votepres==0 & female==0 & year==2012 
svy: tab race if rep_votepres==0 & female==1 & year==2012 
svy: tab race if rep_votepres==1 & female==0 & year==2012 
svy: tab race if rep_votepres==1 & female==1 & year==2012 
svy: tab college if rep_votepres==0 & female==0 & year==2012 
svy: tab college if rep_votepres==0 & female==1 & year==2012 
svy: tab college if rep_votepres==1 & female==0 & year==2012 
svy: tab college if rep_votepres==1 & female==1 & year==2012 


svy: tab inc3 if rep_votepres==0 & female==0 & year==2012 
svy: tab inc3 if rep_votepres==0 & female==1 & year==2012 
svy: tab inc3 if rep_votepres==1 & female==0 & year==2012 
svy: tab inc3 if rep_votepres==1 & female==1 & year==2012 


svy: tab employed if rep_votepres==0 & female==0 & year==2012 
svy: tab employed if rep_votepres==0 & female==1 & year==2012 
svy: tab employed if rep_votepres==1 & female==0 & year==2012 
svy: tab employed if rep_votepres==1 & female==1 & year==2012 

svy: tab homemaker if rep_votepres==0 & female==0 & year==2012 
svy: tab homemaker if rep_votepres==0 & female==1 & year==2012 
svy: tab homemaker if rep_votepres==1 & female==0 & year==2012 
svy: tab homemaker if rep_votepres==1 & female==1 & year==2012 


svy: tab age3 if rep_votepres==0 & female==0 & year==2012 
svy: tab age3 if rep_votepres==0 & female==1 & year==2012 
svy: tab age3 if rep_votepres==1 & female==0 & year==2012 
svy: tab age3 if rep_votepres==1 & female==1 & year==2012 

svy: tab married if rep_votepres==0 & female==0 & year==2012 
svy: tab married if rep_votepres==0 & female==1 & year==2012 
svy: tab married if rep_votepres==1 & female==0 & year==2012 
svy: tab married if rep_votepres==1 & female==1 & year==2012 

svy: tab child if rep_votepres==0 & female==0 & year==2012 
svy: tab child if rep_votepres==0 & female==1 & year==2012 
svy: tab child if rep_votepres==1 & female==0 & year==2012 
svy: tab child if rep_votepres==1 & female==1 & year==2012 


svy: tab church if rep_votepres==0 & female==0 & year==2012 
svy: tab church if rep_votepres==0 & female==1 & year==2012 
svy: tab church if rep_votepres==1 & female==0 & year==2012 
svy: tab church if rep_votepres==1 & female==1 & year==2012 

svy: tab literal if rep_votepres==0 & female==0 & year==2012 
svy: tab literal if rep_votepres==0 & female==1 & year==2012 
svy: tab literal if rep_votepres==1 & female==0 & year==2012 
svy: tab literal if rep_votepres==1 & female==1 & year==2012 

svy: tab south if rep_votepres==0 & female==0 & year==2012 
svy: tab south if rep_votepres==0 & female==1 & year==2012 
svy: tab south if rep_votepres==1 & female==0 & year==2012 
svy: tab south if rep_votepres==1 & female==1 & year==2012 

svy: tab pid3 if rep_votepres==0 & female==0 & year==2012 
svy: tab pid3 if rep_votepres==0 & female==1 & year==2012 
svy: tab pid3 if rep_votepres==1 & female==0 & year==2012 
svy: tab pid3 if rep_votepres==1 & female==1 & year==2012 

//White Survey Respondents Only (Columns 6-9)
svy: tab college if rep_votepres==0 & female==0 & year==2012  & race==1
svy: tab college if rep_votepres==0 & female==1 & year==2012  & race==1
svy: tab college if rep_votepres==1 & female==0 & year==2012  & race==1
svy: tab college if rep_votepres==1 & female==1 & year==2012  & race==1


svy: tab inc3 if rep_votepres==0 & female==0 & year==2012  & race==1
svy: tab inc3 if rep_votepres==0 & female==1 & year==2012  & race==1
svy: tab inc3 if rep_votepres==1 & female==0 & year==2012  & race==1
svy: tab inc3 if rep_votepres==1 & female==1 & year==2012  & race==1


svy: tab employed if rep_votepres==0 & female==0 & year==2012  & race==1
svy: tab employed if rep_votepres==0 & female==1 & year==2012  & race==1
svy: tab employed if rep_votepres==1 & female==0 & year==2012  & race==1
svy: tab employed if rep_votepres==1 & female==1 & year==2012  & race==1

svy: tab homemaker if rep_votepres==0 & female==0 & year==2012  & race==1
svy: tab homemaker if rep_votepres==0 & female==1 & year==2012  & race==1
svy: tab homemaker if rep_votepres==1 & female==0 & year==2012  & race==1
svy: tab homemaker if rep_votepres==1 & female==1 & year==2012  & race==1


svy: tab age3 if rep_votepres==0 & female==0 & year==2012  & race==1
svy: tab age3 if rep_votepres==0 & female==1 & year==2012  & race==1
svy: tab age3 if rep_votepres==1 & female==0 & year==2012  & race==1
svy: tab age3 if rep_votepres==1 & female==1 & year==2012  & race==1

svy: tab married if rep_votepres==0 & female==0 & year==2012  & race==1
svy: tab married if rep_votepres==0 & female==1 & year==2012  & race==1
svy: tab married if rep_votepres==1 & female==0 & year==2012  & race==1
svy: tab married if rep_votepres==1 & female==1 & year==2012  & race==1

svy: tab child if rep_votepres==0 & female==0 & year==2012  & race==1
svy: tab child if rep_votepres==0 & female==1 & year==2012  & race==1
svy: tab child if rep_votepres==1 & female==0 & year==2012  & race==1
svy: tab child if rep_votepres==1 & female==1 & year==2012  & race==1


svy: tab church if rep_votepres==0 & female==0 & year==2012  & race==1
svy: tab church if rep_votepres==0 & female==1 & year==2012  & race==1
svy: tab church if rep_votepres==1 & female==0 & year==2012  & race==1
svy: tab church if rep_votepres==1 & female==1 & year==2012  & race==1

svy: tab literal if rep_votepres==0 & female==0 & year==2012  & race==1
svy: tab literal if rep_votepres==0 & female==1 & year==2012  & race==1
svy: tab literal if rep_votepres==1 & female==0 & year==2012  & race==1
svy: tab literal if rep_votepres==1 & female==1 & year==2012  & race==1

svy: tab south if rep_votepres==0 & female==0 & year==2012  & race==1
svy: tab south if rep_votepres==0 & female==1 & year==2012  & race==1
svy: tab south if rep_votepres==1 & female==0 & year==2012  & race==1
svy: tab south if rep_votepres==1 & female==1 & year==2012  & race==1

svy: tab pid3 if rep_votepres==0 & female==0 & year==2012  & race==1
svy: tab pid3 if rep_votepres==0 & female==1 & year==2012  & race==1
svy: tab pid3 if rep_votepres==1 & female==0 & year==2012  & race==1
svy: tab pid3 if rep_votepres==1 & female==1 & year==2012  & race==1



**************************************************************
//Table A4: Sexism and White Women’s Feelings toward the Presidential Candidates  
**************************************************************
 
//Table A4. Model 1 2012 Feelings Towards Romney
eststo: svy, subpop(if female==1 & white==1):regress  rep_therm_post hostile_short discrim_women college upper lower employed homemaker age married children cattend literal south  independent republican ideo7 govscopez egalz racialresentz author_add urbanm suburbanm townm  if year==2012
//Estimate without survey weights to obtain correct number of observations 
regress  rep_therm_post hostile_short discrim_women college upper lower employed homemaker age married children cattend literal south  independent republican ideo7 govscopez egalz racialresentz author_add  if female==1 & white==1 & year==2012

//Table A4. Model 2 2016 Feelings Towards Trump
eststo: svy, subpop(if female==1 & white==1):regress  rep_therm_post  hostile_short discrim_women college upper lower employed homemaker age married children cattend literal south independent republican ideo7 govscopez egalz racialresentz author_add if year==2016    
//Estimate without survey weights to obtain correct number of observations 
regress  rep_therm_post hostile_short discrim_women college upper lower employed homemaker age married children cattend literal south  independent republican ideo7 govscopez egalz racialresentz author_add  if female==1 & white==1 & year==2016


************************************************************** 
//Table A5: Gender Differences in the Effects of Sexism on Vote Choice and Feelings Towards Presidential Candidates
**************************************************************

set more off
eststo clear

//Table A5. Model 1 2012 Vote for Romney
eststo: svy, subpop(if  white==1):logit  rep_votepres i.female##c.hostile_short i.female##c.discrim_women college upper lower employed homemaker age married children cattend literal south  independent republican ideo7 govscopez egalz racialresentz author_add  if year==2012

//Table A5. Model 2 2016 Vote for Trump
eststo: svy, subpop(if  white==1):logit  rep_votepres i.female##c.hostile_short i.female##c.discrim_women college upper lower employed homemaker age married children cattend literal south  independent republican ideo7 govscopez egalz racialresentz author_add  if year==2016

//Table A5. Model 3 2012 Feelings Towards Romney
eststo: svy, subpop(if  white==1):regress  rep_therm_post i.female##c.hostile_short i.female##c.discrim_women college upper lower employed homemaker age married children cattend literal south  independent republican ideo7 govscopez egalz racialresentz author_add  if year==2012

//Table A5. Model 4 2016 Feelings Towards Trump
eststo: svy, subpop(if white==1):regress  rep_therm_post i.female##c.hostile_short i.female##c.discrim_women college upper lower employed homemaker age married children cattend literal south  independent republican ideo7 govscopez egalz racialresentz author_add  if year==2016



//Table A6: White Women’s Vote Choice and Feelings Towards Presidential Candidates, Controlling for Rurality 

set more off
eststo clear

//Table A6. Model 1 2012 Vote for Romney
eststo: svy, subpop(if female==1 & white==1):logit  rep_votepres hostile_short discrim_women college upper lower employed homemaker age married children cattend literal south  independent republican ideo7 govscopez egalz racialresentz author_add urbanm suburbanm townm if year==2012 

//Table A6. Model 2 2016 Vote for Trump
eststo: svy, subpop(if female==1 & white==1):logit  rep_votepres hostile_short discrim_women college upper lower employed homemaker age married children cattend literal south  independent republican ideo7 govscopez egalz racialresentz author_add urbanm suburbanm townm ruralm if year==2016

//Table A6. Model 3 2012 Feelings Towards Romney
eststo: svy, subpop(if female==1 & white==1):regress  rep_therm_post hostile_short discrim_women college upper lower employed homemaker age married children cattend literal south  independent republican ideo7 govscopez egalz racialresentz author_add urbanm suburbanm townm  if year==2012

//Table A6. Model 4 2016 Feelings Towards Trump
eststo: svy, subpop(if female==1 & white==1):regress  rep_therm_post  hostile_short discrim_women college upper lower employed homemaker age married children cattend literal south independent republican ideo7 govscopez egalz racialresentz author_add urbanm suburbanm townm ruralm if year==2016    


**************************************************************  
//Figure 2. Percentage of Low and High-Income White Voters Supporting Republican
//Presidential Candidates in 2012 and 2016 (American National Election Studies) 
************************************************************** 
 
 
************************************************************** 
//Figure 2: The Effects of Sexism on Vote Choice among White Men and Women
**************************************************************
 

//Panel A: Probability of Voting Republican by Hostile Sexism
set more off
//Probability of Voting Romney in 2012 by Hostile Sexism 
svy, subpop(if  white==1):logit  rep_votepres i.female##c.hostile_short i.female##c.discrim_women college upper lower employed homemaker age married children cattend literal south ideo7 independent republican govscopez egalz racialresentz author_add  if year==2012

//use the margins contrast option to calculate a series of differences between predicted probabilities
	margins, at(hostile_short=(-1.5 2.8) female=(1))  contrast(atjoint effect) level(90) saving(f_h_12, replace) //women hostile12
	margins, at(hostile_short=(-1.5 2.8)  female=(0)) contrast(atjoint effect) level(90) saving(m_h_12, replace) //men hostile12

gen meanvoteh = . 
gen hvoteh=.
gen lvoteh=.
gen axis=.

replace meanvoteh =  -.0520341  in 1
replace hvoteh =  .0690748 in 1
replace lvoteh =  -.1731429 in 1
replace axis = 1 in 1

replace meanvoteh =  .0737713 in 2
replace hvoteh =   .1625577 in 2
replace lvoteh =   -.0150151  in 2
replace axis = 2 in 2
	
set more off
//Probability of Voting Trump in 2016 by Hostile Sexism 	
svy, subpop(if  white==1):logit  rep_votepres i.female##c.hostile_short i.female##c.discrim_women college upper lower employed homemaker age married children cattend literal south ideo7 independent republican govscopez egalz racialresentz author_add  if year==2016


//use the margins contrast option to calculate a series of differences between predicted probabilities
	margins, at(hostile_short=(-1.5 2.8)  female=(1))  contrast(atjoint effect) level(90) saving(f_h_16, replace) //women hostile16
	margins, at(hostile_short=(-1.5 2.8)  female=(0))  contrast(atjoint effect) level(90) saving(m_h_16, replace) //men hostile16

replace meanvoteh =   .1400389  in 3
replace hvoteh =   .2594785 in 3
replace lvoteh =  .0205994   in 3
replace axis = 3 in 3

replace meanvoteh =   .1425222  in 4
replace hvoteh =  .2848905 in 4
replace lvoteh =  .0001539   in 4
replace axis = 4 in 4	

	 # delimit ;
		
twoway rbar hvoteh lvoteh axis, color(black) barwidth (.010)||
 scatter meanvoteh axis if axis==1, symbol(square) color(black) msize(large)||
 scatter meanvoteh axis if axis==3, symbol(square) color(black) msize(large)||
 scatter meanvoteh axis if axis==2, symbol(circle) color(black) msize(large)||
 scatter meanvoteh axis if axis==4, symbol(circle) color(black) msize(large)
 xtitle(" ", size(medium))
  			ytitle("P(Vote| Sexism=Low) - P(Vote| Sexism=High)", height(6) size(medsmall))  
  			title("Panel A", size(medium) color(black))
			subtitle("Probability of Voting Republican by Hostile Sexism", size(medsmall) color(black))
			 yline(0,lp(dash) lc(gray)) 
			 ylab(-.3 (.2) .4 , nogrid labsize(medsmall)) 
			 xlab(1 "Women (2012)" 2 "Men (2012)" 3 "Women (2016)" 4 "Men (2016)", nogrid   labsize(medsmall)) 
ysize(5)
xscale(range(.75 4.25) )

			legend(off)
            graphregion(fcolor(white))
 			plotregion(fcolor(white))
 			graphregion(color(white))
 			name(change_hostile, replace);
			
			#delimit cr
	
	

//Panel B: Probability of Voting Republican by Discrimination 
set more off

//Probability of Voting Romney in 2012 by Discrimination 
svy, subpop(if  white==1):logit  rep_votepres i.female##c.hostile_short i.female##c.discrim_women college upper lower employed homemaker age married children cattend literal south ideo7 independent republican govscopez egalz racialresentz author_add if year==2012

//use the margins contrast option to calculate a series of differences between predicted probabilities
	margins, at(discrim_women=(1 5) female=(1))  level(90)  contrast(atjoint effect) saving(f_d_12, replace) //women hostile12
	margins, at(discrim_women=(1 5) female=(0)) level(90)   contrast(atjoint effect) saving(m_d_12, replace) //men hostile12


gen meanvoted = . 
gen hvoted=.
gen lvoted=.
gen axisd=.

replace meanvoted =  -.0675028  in 1
replace hvoted =  .0305853 in 1
replace lvoted =   -.1655908 in 1
replace axisd = 1 in 1

replace meanvoted =  -.0789182 in 2
replace hvoted =  .0108277 in 2
replace lvoted =  -.1686641  in 2
replace axisd = 2 in 2	
	

//Probability of Voting Trump in 2016 by Discrimination 
svy, subpop(if  white==1):logit  rep_votepres i.female##c.hostile_short i.female##c.discrim_women college upper lower employed homemaker age married children cattend literal south ideo7 independent republican govscopez egalz racialresentz author_add if year==2016

//use the margins contrast option to calculate a series of differences between predicted probabilities
	margins, at(discrim_women=(1 5)  female=(1))  level(90)  contrast(atjoint effect) saving(f_d_16, replace) //women hostile16
	margins, at(discrim_women=(1 5)  female=(0))  level(90)  contrast(atjoint effect) saving(m_d_16, replace) //men hostile16


replace meanvoted = -.1571636 in 3
replace hvoted =  -.0651309 in 3
replace lvoted =    -.2491964  in 3
replace axisd = 3 in 3

replace meanvoted =   -.0255263 in 4
replace hvoted =   .0603533 in 4
replace lvoted =  -.1114058  in 4
replace axisd = 4 in 4


	
	 # delimit ;
		
twoway rbar hvoted lvoted axisd, color(black) barwidth (.010)||
 scatter meanvoted axis if axisd==1, symbol(square) color(black) msize(large)||
 scatter meanvoted axis if axisd==3, symbol(square) color(black) msize(large)||
 scatter meanvoted axis if axisd==2, symbol(circle) color(black) msize(large)||
 scatter meanvoted axis if axisd==4, symbol(circle) color(black) msize(large)
 xtitle(" ", size(medium))
  			ytitle("P(Vote| Discrim=Low) - P(Vote| Discrim=High)",  height(6) size(medsmall))  
  			title("Panel B", size(medium) color(black))
				subtitle("Probability of Voting Republican by Discrimination", size(medsmall) color(black))
			 yline(0,lp(dash) lc(gray)) 
			 ylab(-.3 (.2) .4 , nogrid labsize(medsmall)) 
			 xlab(1 "Women (2012)" 2 "Men (2012)" 3 "Women (2016)" 4 "Men (2016)", nogrid   labsize(medsmall)) 
ysize(5)
xscale(range(.75 4.25) )
			legend(off)
            graphregion(fcolor(white))
 			plotregion(fcolor(white))
 			graphregion(color(white))
 			name(change_discrimination, replace);


			#delimit cr	 
 
************************************************************** 
//Figure A1 The Effect of Sexism on Candidate Evaluations
**************************************************************
 
//Panel A: Feelings towards Republican Candidate by Hostile Sexism

//Feelings towards Romney in 2012 by Hostile Sexism
set more off
svy, subpop(if  white==1):regress  rep_therm_post i.female##c.hostile_short i.female##c.discrim_women college upper lower employed homemaker age married children cattend literal south ideo7 independent republican govscopez egalz racialresentz author_add  if year==2012
//use the margins contrast option to calculate a series of differences between predicted probabilities
	margins, at(hostile_short=(-1.5 2.8) female=(1))  contrast(atjoint effect) level(90) saving(f_h_12, replace) //women hostile12
	margins, at(hostile_short=(-1.5 2.8)  female=(0)) contrast(atjoint effect) level(90) saving(m_h_12, replace) //men hostile12

//Save first difference values for plot	
gen meanvoteh = . 
gen hvoteh=.
gen lvoteh=.
gen axis=.

replace meanvoteh =    -5.303504  in 1
replace hvoteh =  1.929436 in 1
replace lvoteh =    -12.53644 in 1
replace axis = 1 in 1

replace meanvoteh =   -5.653973  in 2
replace hvoteh =   1.075657 in 2
replace lvoteh =   -12.3836  in 2
replace axis = 2 in 2
	
//Feelings Towards Trump in 2016 by Hostile Sexism	
set more off	
svy, subpop(if  white==1):regress  rep_therm_post i.female##c.hostile_short i.female##c.discrim_women college upper lower employed homemaker age married children cattend literal south ideo7 independent republican govscopez egalz racialresentz author_add  if year==2016

//use the margins contrast option to calculate a series of differences between predicted probabilities
	margins, at(hostile_short=(-1.5 2.8)  female=(1))  contrast(atjoint effect) level(90) saving(f_h_16, replace) //women hostile16
	margins, at(hostile_short=(-1.5 2.8)  female=(0))  contrast(atjoint effect) level(90) saving(m_h_16, replace) //men hostile16

//Save First Difference Values for Plot
replace meanvoteh =    7.743822   in 3
replace hvoteh =    -.3530247 in 3
replace lvoteh =  15.84067  in 3
replace axis = 3 in 3

replace meanvoteh =   12.42414  in 4
replace hvoteh =  21.95943 in 4
replace lvoteh =   2.88885   in 4
replace axis = 4 in 4	

	 # delimit ;
		
twoway rbar hvoteh lvoteh axis, color(black) barwidth (.010)||
 scatter meanvoteh axis if axis==1, symbol(square) color(black) msize(large)||
 scatter meanvoteh axis if axis==3, symbol(square) color(black) msize(large)||
 scatter meanvoteh axis if axis==2, symbol(circle) color(black) msize(large)||
 scatter meanvoteh axis if axis==4, symbol(circle) color(black) msize(large)
 xtitle(" ", size(medium))
  			ytitle("EV(Feelings| Sexism=Low) - P(Feelings| Sexism=High)", height(6) size(medsmall))  
  			title("Panel A", size(medium) color(black))
			subtitle("Feelings towards Republican Candidate by Hostile Sexism", size(medsmall) color(black))
			 yline(0,lp(dash) lc(gray)) 
			 ylab(-30 (10) 30 , nogrid labsize(medsmall)) 
			 xlab(1 "Women (2012)" 2 "Men (2012)" 3 "Women (2016)" 4 "Men (2016)", nogrid   labsize(medsmall)) 
ysize(5)
xscale(range(.75 4.25) )

			legend(off)
            graphregion(fcolor(white))
 			plotregion(fcolor(white))
 			graphregion(color(white))
 			name(change_hostile, replace);
			
			#delimit cr 

			
//Panel B: Feelings towards Republican Candidate by Discrimination

 //Feelings towards Romney in 2012 by Discrimination
set more off
svy, subpop(if  white==1):reg  rep_therm_post i.female##c.hostile_short i.female##c.discrim_women college upper lower employed homemaker age married children cattend literal south ideo7 independent republican govscopez egalz racialresentz author_add if year==2012

//use the margins contrast option to calculate a series of differences between predicted probabilities
	margins, at(discrim_women=(1 5) female=(1))  level(90)  contrast(atjoint effect) saving(f_d_12, replace) //women hostile12
	margins, at(discrim_women=(1 5) female=(0)) level(90)   contrast(atjoint effect) saving(m_d_12, replace) //men hostile12

capture drop  meanvoted  
capture drop hvoted
capture drop lvoted
capture drop axisd

gen meanvoted = . 
gen hvoted=.
gen lvoted=.
gen axisd=.

replace meanvoted =   -8.620792   in 1
replace hvoted =  -2.117069 in 1
replace lvoted =     -15.12452  in 1
replace axisd = 1 in 1

replace meanvoted =  -6.390207  in 2
replace hvoted =   -.6776928 in 2
replace lvoted =   -12.10272   in 2 
replace axisd = 2 in 2	
	
//Feelings towards Trump in 2016 by Discrimination	
svy, subpop(if  white==1):reg  rep_therm_post i.female##c.hostile_short i.female##c.discrim_women college upper lower employed homemaker age married children cattend literal south ideo7 independent republican govscopez egalz racialresentz author_add if year==2016

//use the margins contrast option to calculate a series of differences between predicted probabilities
	margins, at(discrim_women=(1 5)  female=(1))  level(90)  contrast(atjoint effect) saving(f_d_16, replace) //women hostile16
	margins, at(discrim_women=(1 5)  female=(0))  level(90)  contrast(atjoint effect) saving(m_d_16, replace) //men hostile16


replace meanvoted = -13.04441  in 3
replace hvoted =  -6.868913 in 3
replace lvoted =    -19.2199  in 3
replace axisd = 3 in 3

replace meanvoted =   -9.092641  in 4
replace hvoted =   -1.71406 in 4
replace lvoted =    -16.47122 in 4
replace axisd = 4 in 4


	
	 # delimit ;
		
twoway rbar hvoted lvoted axisd, color(black) barwidth (.010)||
 scatter meanvoted axis if axisd==1, symbol(square) color(black) msize(large)||
 scatter meanvoted axis if axisd==3, symbol(square) color(black) msize(large)||
 scatter meanvoted axis if axisd==2, symbol(circle) color(black) msize(large)||
 scatter meanvoted axis if axisd==4, symbol(circle) color(black) msize(large)
 xtitle(" ", size(medium))
  			ytitle("EV(Feeling| Discrim=Low) - EV(Feeling| Discrim=High)",  height(6) size(medsmall))  
  			title("Panel B", size(medium) color(black))
				subtitle("Feelings towards Republican Candidate by Discrimination", size(medsmall) color(black))
			 yline(0,lp(dash) lc(gray)) 
			 ylab(-30 (10) 30 , nogrid labsize(medsmall)) 
			 xlab(1 "Women (2012)" 2 "Men (2012)" 3 "Women (2016)" 4 "Men (2016)", nogrid   labsize(medsmall)) 
ysize(5)
xscale(range(.75 4.25) )
			legend(off)
            graphregion(fcolor(white))
 			plotregion(fcolor(white))
 			graphregion(color(white))
 			name(change_discrimination, replace);


			#delimit cr				
