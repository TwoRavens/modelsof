********************************************************************************
*** Stata code to replicate the UK BCS Micro results.
*** Date: 12/03/2017			
********************************************************************************

* This stata do file estimates the models reported in Table 6: UK Self Report Arrest 
* Regressions, 2001/2 to 2010/11. To run this, the user must request access to the 
* 2001/02 - 2010/11 British Crime Survey Microdata. This is available from 
* www.dataservice.ac.uk - we are not authorised to provide the underlying data directly.


********************************************************************************
* PREAMBLE AND RE-CODING OF RAW DATA
********************************************************************************

* cd ".."

clear
use "bcs_2001-2002_2010-2011_clean.dta", clear

merge 1:1 rowlabel year using "indiv_weight_01-11.dta", replace update
drop if _merge==2
drop _merge

gen year_intvw =.
replace year_intvw = 2001 if year==1
replace year_intvw = 2002 if year==2
replace year_intvw = 2003 if year==3
replace year_intvw = 2004 if year==4
replace year_intvw = 2005 if year==5
replace year_intvw = 2006 if year==6
replace year_intvw = 2007 if year==7
replace year_intvw = 2008 if year==8
replace year_intvw = 2009 if year==9
replace year_intvw = 2010 if year==10
replace year_intvw = 2011 if year==11
gen entry_year = (year_intvw-age)+16
decode gor, gen(reg)

merge m:1 entry_year reg using "Regional_Urates_Males_1955_2009.dta"

*Sample is ages 16-65, males (65+ dropped)

keep if age<=65
keep if sex==1

*Other Variables

ge lowed = 0
replace lowed = 1 if (educat2==6|educat2==7|educint==2)

ge education = educat2 if educint==1&educat2<98&educint<8
replace education = 9 if educint==2&educint<8

ge d_edu = 0 if educint!=.
replace d_edu = 1 if educint==1
label var d_edu `"Any Qualification"'

ge d_work = 0 if rwork!=.
replace d_work = 1 if rwork==1
label var d_work `"Employed"'

ge d_child = 0 if nchil!=.
replace d_child = 1 if nchil==1
replace d_child = 2 if nchil==2
replace d_child = 3 if nchil>=3
label var d_child `"Number of Children"'

ge black = 0 if ethgrp2!=.
replace black = 1 if ethgrp2==4
label var black `"Black or Black British"'

ge asian = 0 if ethgrp2!=.
replace asian = 1 if ethgrp2==3
label var asian `"Asian or Asian British"'

ge work_income = 0 if tothhin1!=.
replace work_income = 1 if tothhin1>=4&tothhin1<=7
label var work_income `"Household Income £15000-£30000"'

ge middle_income = 0 if tothhin1!=.
replace middle_income = 1 if tothhin1>=8&tothhin1<=11
label var middle_income `"Household Income £30000-£50000"'

ge high_income = 0 if tothhin1!=.
replace high_income = 1 if tothhin1==12
label var high_income `"Household Income over £50000"'

replace everarr = 0 if everarr==2
label define everarr 0 "no", modify

drop if (everarr==9|everarr==8)

ge age_group = .
replace age_group = 1 if age==16
replace age_group = 2 if age==17
replace age_group = 3 if age==18
replace age_group = 4 if age==19
replace age_group = 5 if age>=20&age<=24
replace age_group = 6 if age>=25&age<=29
replace age_group = 7 if age>=30&age<=39
replace age_group = 8 if age>=40&age<=49
replace age_group = 9 if age>=50&age<=59
replace age_group = 10 if age>=60&age<=65

replace indivwgt = indivwgt/10000 if indivwgt>20000 & indivwgt!=.
gen wght = int(indivwgt)
ge entry_urate = unemp/100


********************************************************************************
* TABLE 6 
********************************************************************************

* Regional entry U rate 

#d	

xi: dprobit everarr entry_urate i.year i.age_group i.education i.tenure1 i.tothhin2 i.rstudy
	i.margrp i.nchil i.ethgrp2 i.rlstweek i.yrsaddr i.yrsarea i.gor [pw=wght], vce(cluster gor);
	
xi: dprobit everarr entry_urate i.year i.age_group i.tenure1 i.tothhin2 i.rstudy i.margrp
	i.nchil i.ethgrp2 i.rlstweek i.yrsaddr i.yrsarea i.gor [pw=wght] 
	if lowed==1 & region!=3, vce(cluster gor);
	
xi: dprobit everarr entry_urate i.year i.age_group i.tenure1 i.tothhin2 i.rstudy i.margrp
	i.nchil i.ethgrp2 i.rlstweek i.yrsaddr i.yrsarea i.gor [pw=wght]
	if educat2<=4 & region!=3, vce(cluster gor);

