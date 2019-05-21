
/* ###################
## Replication Stata Do File
## Blair, Fair, Malhotra, and Shapiro (2012),
## Poverty and Support for Militant Politics: Evidence from Pakistan.
## Forthcoming, American Journal of Political Science.
## Created 24 March 2011
## Modified 3 April 2012
## 
## Contact Graeme Blair, gblair@princeton.edu with questions
## #################### */

/* !!
## this file must be run before replication_analysis.do */

version 11

clear
set mem 100m
set more off

use "fms09-data-weighted-20june.dta", clear

ren d23 province
recode spn (98=501)
recode spn (99=502)

**** Handle missing data ****

qui foreach var of varlist * {
	mvdecode `var', mv(98=. \ 99=.)
	}

****recode q800 series so that 5 means like a lot and 1 means like not at all
local wh1 "a b c d e"
foreach z of local wh1 {
	local d2 "0 1 3 4"
	foreach y of local d2 {
		recode q8`y'0`z' (5=1 "not at all") (4=2 "a little") (3=3 "a moderate amount") (2=4 "a lot") (1=5 "a great deal"), pre(new)label(newrep)
      	}
	}

******subset on complete data
*identify people who were duplicates (assigned to same topic twice by enumerator/dataentry error)

local e1 "b c d e"
foreach x of local e1 {
	egen nonmiss_`x' = rownonmiss(q800`x' q810`x' q830`x' q840`x')     
	}
gen duplicate = nonmiss_b>1|nonmiss_c>1|nonmiss_d>1|nonmiss_e>1

***there were some control group people who also got treatment items***

gen duplicate2 = (q800a<6&(q800b<6|q800c<6|q800d<6|q800e<6|q810b<6|q810c<6|q810d<6|q810e<6|q830b<6|q830c<6|q830d<6|q830e<6|q840b<6|q840c<6|q840d<6|q840e<6)) ///
|(q810a<6&(q800b<6|q800c<6|q800d<6|q800e<6|q810b<6|q810c<6|q810d<6|q810e<6|q830b<6|q830c<6|q830d<6|q830e<6|q840b<6|q840c<6|q840d<6|q840e<6)) ///
|(q830a<6&(q800b<6|q800c<6|q800d<6|q800e<6|q810b<6|q810c<6|q810d<6|q810e<6|q830b<6|q830c<6|q830d<6|q830e<6|q840b<6|q840c<6|q840d<6|q840e<6)) ///
|(q840a<6&(q800b<6|q800c<6|q800d<6|q800e<6|q810b<6|q810c<6|q810d<6|q810e<6|q830b<6|q830c<6|q830d<6|q830e<6|q840b<6|q840c<6|q840d<6|q840e<6))


*identify people who produce full data
gen full = (q800a<6&q810a<6&q830a<6&q840a<6)|(nonmiss_b==1&nonmiss_c==1&nonmiss_d==1&nonmiss_e==1)

gen complete = full==1&duplicate!=1&duplicate2!=1

* Check our what the standard deviations are

local d2 "0 1 3 4"
foreach x of local d2 {
	egen q8`x'0sd2 = sd(newq8`x'0a) if complete==1   
	}

local d2 "0 1 3 4"
foreach x of local d2 {
	sum q8`x'0sd2   
	}

**q800 = .983; q810 = 1.15; q830 = 1.28; q840 = 1.18; avg = 1.15 

egen control_combx = rowtotal (newq800a newq810a newq830a newq840a)
gen control_comb_avgx = control_combx/20 if control_combx > 0 &complete==1

egen pakmil_combx = rowtotal (newq800b newq810b newq830b newq840b)
gen pakmil_comb_avgx = pakmil_combx/5 if pakmil_combx > 0 & complete==1

egen afgmil_combx = rowtotal (newq800c newq810c newq830c newq840c)
gen afgmil_comb_avgx = afgmil_combx/5 if afgmil_combx > 0 & complete==1

egen alq_combx = rowtotal (newq800d newq810d newq830d newq840d)
gen alq_comb_avgx = alq_combx/5 if alq_combx > 0 & complete==1

egen tanzeem_combx = rowtotal (newq800e newq810e newq830e newq840e)
gen tanzeem_comb_avgx = tanzeem_combx/5 if tanzeem_combx > 0 & complete==1

****combines control condition with each group individually*****

egen comb_avgx_pakmilx = rowtotal (control_comb_avgx pakmil_comb_avgx)
egen comb_avgx_afgmilx = rowtotal (control_comb_avgx afgmil_comb_avgx) 
egen comb_avgx_alqx = rowtotal (control_comb_avgx alq_comb_avgx) 
egen comb_avgx_tanzeemx = rowtotal (control_comb_avgx tanzeem_comb_avgx)

rename comb_avgx_pakmilx comb_avgx_group1
rename comb_avgx_afgmilx comb_avgx_group2
rename comb_avgx_alqx comb_avgx_group3
rename comb_avgx_tanzeemx comb_avgx_group4

gen pakmil = pakmil_comb_avgx!=. if complete==1
gen afgmil = afgmil_comb_avgx!=. if complete==1
gen alq = alq_comb_avgx!=. if complete==1
gen tanzeem = tanzeem_comb_avgx!=. if complete==1

rename pakmil group1
rename afgmil group2
rename alq group3
rename tanzeem group4

** Generate generic measure of support
gen militancy_support = (comb_avgx_group1+comb_avgx_group2+comb_avgx_group3+comb_avgx_group4)/4

gen militancy_weight = 1.148945 *wtpru

gen control = q800a!=. if complete==1

gen treatment=control
recode treatment (0=1) (1=0)


****creating weights

gen controlweight = 1.148945 if control_combx > 0 &complete==1

gen pakweight = .
recode pakweight (.=.983415) if newq800b!=. &complete==1
recode pakweight (.=1.150536) if newq810b!=. &complete==1
recode pakweight (.=1.278917) if newq830b!=. &complete==1
recode pakweight (.=1.182913) if newq840b!=. &complete==1
egen control_pakweight = rowtotal(controlweight pakweight) if complete==1
gen control_pakweight_full = control_pakweight*wtpru

gen afgweight = .
recode afgweight (.=.983415) if newq800c!=. &complete==1
recode afgweight (.=1.150536) if newq810c!=. &complete==1
recode afgweight (.=1.278917) if newq830c!=. &complete==1
recode afgweight (.=1.182913) if newq840c!=. &complete==1
egen control_afgweight = rowtotal(controlweight afgweight) if complete==1
gen control_afgweight_full = control_afgweight*wtpru

gen alqweight = .
recode alqweight (.=.983415) if newq800d!=. &complete==1
recode alqweight (.=1.150536) if newq810d!=. &complete==1
recode alqweight (.=1.278917) if newq830d!=. &complete==1
recode alqweight (.=1.182913) if newq840d!=. &complete==1
egen control_alqweight = rowtotal(controlweight alqweight) if complete==1
gen control_alqweight_full = control_alqweight*wtpru

gen tanweight = .
recode tanweight (.=.983415) if newq800e!=. &complete==1
recode tanweight (.=1.150536) if newq810e!=. &complete==1
recode tanweight (.=1.278917) if newq830e!=. &complete==1
recode tanweight (.=1.182913) if newq840e!=. &complete==1
egen control_tanweight = rowtotal(controlweight tanweight) if complete==1
gen control_tanweight_full = control_tanweight*wtpru

rename control_pakweight_full group1weight
rename control_afgweight_full group2weight
rename control_alqweight_full group3weight
rename control_tanweight_full group4weight

***testing

forval x = 1/4 {
   svyset spn [pweight=group`x'weight], strata(province)
   svy: reg comb_avgx_group`x' group`x' if complete==1
  }

************

***generate main variables for dif-in-dif

****education

gen d11b = d11
recode d11b (7=0)
gen educ = d11b>3

forval x = 1/4 {
   gen group`x'_educ = group`x'*educ
   }

gen educ2 = d11b/6

forval x = 1/4 {
   gen group`x'_educ2 = group`x'*educ2
   }

recode d11b (1 2 = 1) (3 = 2) (4 5 6 = 3), gen(educ3)
replace educ3 = educ3/3

forval x = 1/4 {
   gen group`x'_educ3 = group`x'*educ3
   }

***religiosity

gen jihad_military = q50>1 if q50!=. 

forval x = 1/4 {
   gen group`x'_jihad_military = group`x'*jihad_military
   }

gen dars = (q20 < 2)

forval x = 1/4 {
   gen group`x'_dars = group`x'*dars
   }

gen darsattend = .
recode darsattend (.=0) if q20==2
recode darsattend (.=1) if q20==1&q30>15&q30<20
recode darsattend (.=2) if q20==1&q30>10&q30<15
recode darsattend (.=3) if q20==1&q30==10
recode darsattend (.=4) if q20==1&q30==9
recode darsattend (.=5) if q20==1&q30==8
recode darsattend (.=6) if q20==1&q30==7.5
recode darsattend (.=7) if q20==1&q30==4
recode darsattend (.=8) if q20==1&q30==3
recode darsattend (.=9) if q20==1&q30==2
recode darsattend (.=10) if q20==1&q30==1
replace darsattend = darsattend/10

forval x = 1/4 {
   gen group`x'_darsattend = group`x'*darsattend
   }

gen intolerant = (d19==1&q560==1)|(d19==2&q560==2) 

forval x = 1/4 {
   gen group`x'_intolerant = group`x'*intolerant
   }

gen ahlesunnat = 1 if q10 == 6
replace ahlesunnat = 0 if q10 < 6
	
forval x = 1/4 {
   gen group`x'_ahlesunnat = group`x'*ahlesunnat
   }

gen q50b = q50
recode q50b (1=0) (2/3=1)
gen q160eb = q160e
recode q160eb (1=1) (2=0)
gen q190b = q190
recode q190b (1=1) (2/5=0)
gen q440b = q440
recode q440b (1=1) (2=0)
gen q560b = q560
recode q560b (1=1) (2/3=0)
gen q570b = q570
recode q570b (1=0) (2/3=1)

gen relindex = (q50b+q160eb+q190b+q440b+q560b+q570b)/6

forval x = 1/4 {
   gen group`x'_relindex = group`x'*relindex
   }

gen q570bx = q570
recode q570bx (1=0) (2/3=1) (.=0)
gen q50cx = q50
recode q50cx (1/2=0) (3=1) (.=0)
gen relindex2x = (q570bx+q50cx)/2
forval x = 1/4 {
   gen group`x'_relindex2x = group`x'*relindex2x
   }

forval x = 1/4 {
   gen group`x'_q570bx = group`x'*q570bx
   }

forval x = 1/4 {
   gen group`x'_q50cx = group`x'*q50cx
   }

gen q30b = q30==1
forval x = 1/4 {
   gen group`x'_q30b = group`x'*q30b
   }


****rel serious

gen relserious = q30b + (1-ahlesunnat)
forval x = 1/4 {
   gen group`x'_relserious = group`x'*relserious
   }

gen relserious2 = relserious/2



gen ahlesunnatx =  ahlesunnat==1
gen relseriousx = (q30b + (1-ahlesunnatx))/2
forval x = 1/4 {
   gen group`x'_relseriousx = group`x'*relseriousx
   }


**** Democracy variables
gen electreps = q300 < 2
gen indcourts = q320 < 2
gen freespeech = q340 < 2
gen proprights = q360 < 2

gen demvalues = (proprights+freespeech+indcourts+electreps)/4

gen civmil = q370 < 2
gen assemble = q350 <2

gen demvalues2 = (proprights+freespeech+indcourts+electreps+civmil+assemble)/6

forval x = 1/4 {
   gen group`x'_indcourts = group`x'*indcourts
   }

forval x = 1/4 {
   gen group`x'_demvalues = group`x'*demvalues
   }

forval x = 1/4 {
   gen group`x'_demvalues2 = group`x'*demvalues2
   }


**urban

gen urban = d25==1

forval x = 1/4 {
   gen group`x'_urban = group`x'*urban
   }


****views of us****

gen negus = q510==5 if q510!=.

forval x = 1/4 {
   gen group`x'_negus = group`x'*negus
   }

gen negus2 = ((q500 + q510)-2)/8 if q510 ! =. & q500 != .
forval x = 1/4 {
   gen group`x'_negus2 = group`x'*negus2
   }


***region

gen prov_1 = province==1
gen prov_2 = province==2
gen prov_3 = province==3
gen prov_4 = province==4

forval y = 1/4 {
	forval x = 1/4 {
   		gen group`x'_prov_`y' = group`x'*prov_`y'
	  	 }
	}

***field supervisor dummies

tab1 name1, gen(field)

****SES variables ***************

* Nominal income
gen nom_income = d13/1000

forval x = 1/4 {
	g group`x'_nom_income = group`x'*nom_income
}

* Income category
gen inc = d12>2 if d12<6
gen highinc = d12>2 if d12!=.
gen lowinc = d12==1 if d12!=.

forval x = 1/4 {
   gen group`x'_inc = group`x'*inc
   }

forval x = 1/4 {
   gen group`x'_highinc = group`x'*highinc
   }

forval x = 1/4 {
   gen group`x'_lowinc = group`x'*lowinc
   }


* Generate wealth index
gen tv = (s1-2)/-1
gen air = (s2-2)/-1
gen street = (s3-2)/-1
gen outdoor = (s4-2)/-1
gen computer = (d7a-2)/-1
gen cell = (d7b-2)/-1
gen car = (d15-2)/-1
gen compuse = (d5-2)/-1
gen internet = (d6-2)/-1
gen news = (d7c-2)/-1
gen wealthindex = car+tv+air+street+outdoor+computer+cell
replace wealthindex = wealthindex/7

* Generate relative wealth index
gen relwealth = (d17-5)/-4 if d17<6
gen persfin = (q110-5)/-4 if q110<6

forval x = 1/4 {
   gen group`x'_wealthindex = group`x'*wealthindex
   gen group`x'_relwealth = group`x'*relwealth
   gen group`x'_persfin = group`x'*persfin
   }

* Generate deviations from income expected by urban/rural, province, and posessions
*District FE
qui tab d24, gen(d_)
* Education FE
qui tab d11b, gen(ed_)
* Income category FE
qui tab d12, gen (in_)

* Linear predictor
reg d13 in_* ed_* prov_2-prov_4 urban wealthindex
predict inc_dev, rstand
predict income_deviation, res
gen negdev = (income_deviation < 0) if income_deviation != .

* Categorical predictor
recode d12 (4 5 = 4), gen(d12b)
oprobit d12b ed_* prov_2-prov_4 urban wealthindex d_*
predict p1 p2 p3 p4
egen inc_cat = rowmax(p1 p2 p3 p4)
forval x = 1/4 {
	replace inc_cat = `x' if p`x' == inc_cat
	}
gen negdev2 = (inc_cat > d12b) 
gen posdev2 = (inc_cat < d12b)

* Predictor of large deviations in linear predictor
gen negdev3 = (inc_dev < -1)
gen posdev3 = (inc_dev > 1)


forval x = 1/4 {
   gen group`x'_negdev = group`x'*negdev
   gen group`x'_negdev2 = group`x'*negdev2
   gen group`x'_posdev2 = group`x'*posdev2
   gen group`x'_negdev3 = group`x'*negdev3
   gen group`x'_posdev3 = group`x'*posdev3
   }


* Views on land reform and income inequality

gen ineqbig = (q520==1)
gen needref = (q540==1)

forval x = 1/4 {
   gen group`x'_ineqbig = group`x'*ineqbig
   gen group`x'_needref = group`x'*needref
   }

* Generate in province urban/rural specific income cuts in quintiles
gen low_nat = 0
gen high_nat = 0
_pctile d13 [pweight=wtpru], p(20 80)
replace low_nat = 1 if d13 <= r(r1) 
replace high_nat = 1 if d13 > r(r2) 
	

forval x = 1/4 {
   gen group`x'_high_nat = group`x'*high_nat
   gen group`x'_low_nat = group`x'*low_nat
   }

* Generate in province specific income cuts in quintiles
gen low_prov = 0
gen high_prov = 0
	
forval x = 1/4 {
	_pctile d13 if province==`x' [pweight=wtpru], p(20 80)
	replace low_prov = 1 if d13 <= r(r1) & province==`x' 
	replace high_prov = 1 if d13 > r(r2) & province==`x'
	}

forval x = 1/4 {
   gen group`x'_high_prov = group`x'*high_prov
   gen group`x'_low_prov = group`x'*low_prov
   }


* Generate in province urban/rural specific income cuts in quintiles
gen low_urprov = 0
gen high_urprov = 0
	
forval y = 0/1 {
	forval x = 1/4 {
		_pctile d13 if province==`x' & urban==`y' [pweight=wtpru], p(20 80)
		replace low_urprov = 1 if d13 <= r(r1) & province==`x' & urban==`y'
		replace high_urprov = 1 if d13 > r(r2) & province==`x' & urban==`y'
		}
	}

replace low_urprov = . if d13 == .
replace high_urprov = . if d13 == .

g treatment_low_urprov = treatment * low_urprov
g treatment_high_urprov = treatment * high_urprov
g low_urprov_urban = low_urprov * urban
g high_urprov_urban = high_urprov * urban
g treatment_low_urprov_urban = treatment * low_urprov_urban
g treatment_high_urprov_urban = treatment * high_urprov_urban

forval x = 1/4 {
   gen group`x'_high_urprov = group`x'*high_urprov
   gen group`x'_low_urprov = group`x'*low_urprov
   }
   

gen low_urprov2 = 0
gen high_urprov2 = 0

forval y = 0/1 {
	forval x = 1/4 {
		_pctile d13 if province==`x' & urban==`y' [pweight=wtpru], p(20 80)
		replace low_urprov2 = 1 if d13 <= r(r1) & province==`x' & urban==`y'
		replace high_urprov2 = 1 if d13 > r(r2) & province==`x' & urban==`y'
		}
	}
	

forval x = 1/4 {
   gen group`x'_high_urprov2 = group`x'*high_urprov2
   gen group`x'_low_urprov2 = group`x'*low_urprov2
   }
   


* Generate variables for subjective relative income
gen earnmore = (d17 < 3)
gen earnless = (d17 > 3)

forval x = 1/4 {
   gen group`x'_earnmore = group`x'*earnmore
   gen group`x'_earnless = group`x'*earnless
   }

* Generate province specific median income cuts
bysort urban province: egen medinc = median(d13)
gen li_urprov = (d13 < medinc)
forval x = 1/4 {
   gen group`x'_li_urprov = group`x'*li_urprov
   }


* Variables for expectations and past change, so that in 0-1 with higher being better (so negative coefficient on support is expectation).

gen inc_retro = (q110-1)/4 if q110<6
gen inc_prospec = (q120-1)/4 if q120<6
gen cominc_retro = (q130-1)/4 if q130<6
gen cominc_prospec = (q140-1)/4 if q140<6

local k "inc_retro inc_prospec cominc_retro cominc_prospec"
foreach y of local k {
	forval x = 1/4 {
   		gen group`x'_`y' = group`x'*`y'
   		}
   }

* Variables for occupation
g laborer_farmer = (d4==5 | d4==6)
g shop_priv = (d4==1 | d4==2 | d4==4)
g govt = (d4==3)
g other = (laborer_farmer==0 & shop_priv==0 & govt==0)

forval x = 1/4 {
	g group`x'_laborer_farmer = group`x'*laborer_farmer
	g group`x'_shop_priv = group`x'*shop_priv
	g group`x'_govt = group`x'*govt
	g group`x'_other = group`x'*other
}

* Are government workers more secure than other workers, and thus less likely to be opposed to militant groups?

g low_urprov_govt = low_urprov * govt

forval x = 1/4 {
	g group`x'_low_urprov_govt = group`x'_low_urprov * govt
}

* Are poor with greater assets mores secure than others and thus less likely to be opposed to militant groups?

g low_urprov_wealth = low_urprov * wealthindex

forval x = 1/4 {
	g group`x'_low_urprov_wealth = group`x'_low_urprov * wealthindex
}

*********

* Generate Pashtun effect by looking at respondents who speak pashto effect
gen pashto = (d18==4)
forval x = 1/4 {
   gen group`x'_pashto = group`x'*pashto
   }
  
***********

decode d24, gen(district)
replace district = trim(district)

*** CREATING INTERACTIONS BETWEEN TREATMENT AND DEMOCRATIC VALUES ****

forval x = 1/4 {
 *  gen group`x'_indcourts = group`x'*indcourts
   }

forval x = 1/4 {
   gen group`x'_electreps = group`x'*electreps
   }

forval x = 1/4 {
   gen group`x'_freespeech = group`x'*freespeech
   }

forval x = 1/4 {
   gen group`x'_proprights = group`x'*proprights
   }

forval x = 1/4 {
   gen group`x'_civmil = group`x'*civmil
   }

forval x = 1/4 {
   gen group`x'_assemble = group`x'*assemble
   }

alpha indcourts electreps freespeech proprights civmil assemble if complete==1



***** CREATING DEMOCRACY SCALE AND TREATMENT INTERACTION *******

*gen demvalues2 = (proprights+freespeech+indcourts+electreps+civmil+assemble)/6

*forval x = 1/4 {
*   gen group`x'_demvalues2 = group`x'*demvalues2
*   }


*****MAKING TREATMENT-INTERACTION CONTROLS*****

gen married = (d1-2)/-1
forval x = 1/4 {
   gen group`x'_married = group`x'*married
   }

gen age = (d2-18)/70
forval x = 1/4 {
   gen group`x'_age = group`x'*age
   }

gen online = (d6-2)/-1
forval x = 1/4 {
   gen group`x'_online = group`x'*online
   }

gen cellphone = (d7b-2)/-1
forval x = 1/4 {
   gen group`x'_cellphone = group`x'*cellphone
   }

gen newstv = (d7c-2)/-1
forval x = 1/4 {
   gen group`x'_newstv = group`x'*newstv
   }

gen read = d8>1 
gen write = d9>1 
gen math = d10==1
forval x = 1/4 {
   gen group`x'_read = group`x'*read
   }
forval x = 1/4 {
   gen group`x'_write = group`x'*write
   }
forval x = 1/4 {
   gen group`x'_math = group`x'*math
   }

****EDUCATION already coded as educ2

gen income = (d12-1)/4 if d12!=.
forval x = 1/4 {
   gen group`x'_income = group`x'*income
   }

gen sunni = d19==1
forval x = 1/4 {
   gen group`x'_sunni = group`x'*sunni
   }


***** MISSING INCOME DATA FLAG

gen income2 = income
gen income2_miss = income==.
recode income2 (.=0)

******ATTITUDINAL MEASURES

gen usviews1 = (q500-1)/4
gen usviews2 =  (q510-1)/4
gen sharia = (q150-5)/-4
gen sharia_phys = q160e==1



*********COMBINING GROUPS*****************************************************************************************************


gen treatment_indcourts = treatment*indcourts
gen treatment_electreps = treatment*electreps
gen treatment_freespeech = treatment*freespeech
gen treatment_proprights = treatment*proprights
gen treatment_civmil = treatment*civmil
gen treatment_assemble = treatment*assemble
gen treatment_demvalues2 = treatment*demvalues2


*************************** TREATMENT-CONTROL INTERACTIONS

gen treatment_married = treatment*married
gen treatment_age = treatment*age
gen treatment_online = treatment*online
gen treatment_cellphone = treatment*cellphone
gen treatment_newstv = treatment*newstv
gen treatment_read = treatment*read
gen treatment_write = treatment*write
gen treatment_math = treatment*math
gen treatment_educ2 = treatment*educ2
gen treatment_income2 = treatment*income2
gen treatment_income2_miss = treatment*income2_miss
gen treatment_sunni = treatment*sunni
gen treatment_prov_2 = treatment*prov_2
gen treatment_prov_3 = treatment*prov_3
gen treatment_prov_4 = treatment*prov_4
gen treatment_income = treatment*income

gen treatment_usviews1 = treatment*usviews1
gen treatment_usviews2 = treatment*usviews2
gen treatment_sharia = treatment*sharia
gen treatment_sharia_phys = treatment*sharia_phys


*************GROUP GOALS THREE-WAY INTERACTION

gen groupgoal1 = (q610ai-2)/-1
gen groupgoal2 = (q610aii-2)/-1 
gen groupgoal3 =  (q610aiii-2)/-1


gen groupgoals = (groupgoal1+groupgoal2+groupgoal3)/3

gen demvalues2_groupgoals = groupgoals*demvalues2
gen treatment_demvalues2_groupgoals = groupgoals*demvalues2*treatment
gen treatment_groupgoals = treatment * groupgoals


************CODE FOR FEMALE (DIDN'T DO THIS EARLIER)

gen female = d22-1
gen treatment_female = treatment*female

g mid_urprov = low_urprov == 0 & high_urprov == 0
g treatment_mid_urprov = treatment * mid_urprov

g treatment_li_urprov = treatment * li_urprov

save "data_for_analysis.dta", replace

