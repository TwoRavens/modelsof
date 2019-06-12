
* GENERAL INFO
	* Title: Ethnic Diversity, Segregation, and Ethnocentric Trust in Africa
    * Journal: British Journal of Political Science
	* Created by: Amanda Lea Robinson 
* DO FILE INFO
	* This .do file produces all analyses reported in the manuscript.
    * Requires the data file: Robinson_SegTrust.dta
    * An additional file (Robinson_SegTrust_Graphs.do) reproduces graphs/figures.

*********************************************************************************************************************
clear
set more off

* load data
use "Robinson_SegTrust.dta"

* define controls
global indcond gender age age2 secedu agworker indurban gentrust

* Define Effective Sample
set more off
mixed trustdiff c.elf_country $indcond  || country:  ||  region:
gen ABsample = e(sample) // defines AB sample
drop if ABsample==0
egen ctag=tag(country)
egen dtag=tag(country district)
egen rtag=tag(country region)
egen eatag=tag(eacode)

************************************
************************************
************************************
************************************

* Variance Component Models
set more off
eststo v1: melogit cetp_d || country:  ||  region:
eststo v2: meologit trustdiff || country:  ||  region:
eststo v3: melogit cetp_d || district:  ||  eacode:
eststo v4: meologit trustdiff || district:  ||  eacode:

********* Main Analyses **********

* COUNTRY DIVERSITY

set more off
eststo c1: melogit cetp_d c.elf_country $indcond  || country:  ||  region:
eststo c2: meologit trustdiff c.elf_country $indcond  || country:  ||  region:


* SUBNATIONAL DIVERSITY

set more off
eststo u1: melogit  cetp_d c.elf_reg $indcond  || country:  || region:
eststo u2: meologit trustdiff c.elf_reg $indcond  || country:  || region:


* COUNTRY AND SUBNATIONAL DIVERSITY

set more off
eststo i1: melogit cetp_d c.elf_country c.elf_reg $indcond  || country:  || region:
eststo i2: meologit trustdiff c.elf_country c.elf_reg $indcond  || country:  || region:


* DISTRICT DIVERSITY (MALAWI ONLY)

set more off
eststo cm1: melogit cetp_d c.elfdist $indcond  || district:  ||  eacode:
eststo cm2: meologit trustdiff c.elfdist $indcond  || district:  ||  eacode:


* LOCALITY DIVERSITY (MALAWI ONLY)

set more off
eststo um1:  melogit cetp_d c.elfea $indcond  || district:  ||  eacode:
eststo um2: meologit trustdiff c.elfea $indcond  || district:  ||  eacode:


* DISTRICT AND LOCALITY DIVERSITY (MALAWI ONLY)

set more off
eststo im1: melogit cetp_d c.elfdist c.elfea $indcond || district:  ||  eacode:
eststo im2: meologit trustdiff c.elfdist c.elfea $indcond || district:  ||  eacode:

* COUNTRY SEGREGATION 

set more off
eststo s1: melogit cetp_d c.dseg_dis   $indcond   || country:  || district:
eststo s2: meologit trustdiff c.dseg_dis   $indcond  || country:  ||	district:

set more off
eststo si1: melogit cetp_d c.dseg_dis##c.elf_country $indcond  || country:  ||	district:
eststo si2: meologit trustdiff c.dseg_dis##c.elf_country $indcond  || country:  ||	district:

* DISTRICT SEGREGATION (MALAWI ONLY)

set more off
eststo sm1: melogit cetp_d c.ddist   $indcond || district:  ||  eacode:
eststo sm2: meologit trustdiff c.ddist $indcond || district:  ||  eacode:

set more off
eststo sim1: melogit cetp_d c.ddist##c.elfdist $indcond || district:  ||  eacode:
eststo sim2: meologit trustdiff c.ddist##c.elfdist $indcond || district:  ||  eacode:


********* Appendices **********

* Fixed effects
set more off
eststo fu1: melogit cetp_d c.elf_reg $indcond  i.country, vce( cluster region)
eststo fu2: meologit trustdiff c.elf_reg $indcond  i.country, vce( cluster region)

set more off
eststo fum1: melogit cetp_d c.elfea $indcond  i.disnum if country==8, vce( cluster eacode)
eststo fum2: meologit trustdiff c.elfea $indcond  i.disnum if country==8, vce( cluster eacode)

* Coethnic and Non-Coethnic Trust
set more off
eststo c3: meologit etrust c.elf_country $indcond || country: ||  region:
eststo c4: meologit netrust c.elf_country $indcond || country: ||  region:
eststo u3: meologit etrust c.elf_reg $indcond || country: || region:
eststo u4: meologit netrust c.elf_reg $indcond || country: || region:
eststo i3: meologit etrust c.elf_country c.elf_reg $indcond || country: || region:
eststo i4: meologit netrust c.elf_country c.elf_reg $indcond || country: || region:
eststo cm3: meologit etrust c.elfdist $indcond || district:  ||  eacode:
eststo cm4: meologit netrust c.elfdist $indcond || district:  ||  eacode:
eststo um3: meologit etrust c.elfea $indcond || district:  ||  eacode:
eststo um4: meologit netrust c.elfea $indcond || district:  ||  eacode:
eststo im3: meologit etrust c.elfdist c.elfea $indcond || district:  ||  eacode:
eststo im4: meologit netrust c.elfdist c.elfea $indcond || district:  ||  eacode:
eststo s3: meologit etrust c.dseg_dis  $indcond || country: ||	district:
eststo s4: meologit netrust c.dseg_dis   $indcond || country: ||	district:
eststo si3: meologit etrust c.dseg_dis##c.elf_country $indcond || country: ||	district:
eststo si4: meologit netrust c.dseg_dis##c.elf_country $indcond || country: ||	district:
eststo sm3: meologit etrust c.ddist   $indcond || district:  ||  eacode:
eststo sm4: meologit netrust c.ddist   $indcond || district:  ||  eacode:
eststo sim3: meologit etrust c.ddist##c.elfdist $indcond || district:  ||  eacode:
eststo sim4: meologit netrust c.ddist##c.elfdist $indcond || district:  ||  eacode:


* REPLICATE WITH DISTRICT (cross-national only) *

set more off
eststo cd1: melogit cetp_d c.elf_country $indcond  || country:  ||  district:
eststo cd2: meologit trustdiff c.elf_country $indcond  || country:  ||  district:

set more off
eststo d3: melogit cetp_d c.elf_dis $indcond || country:  || district:
eststo d4: meologit trustdiff c.elf_dis $indcond || country:  || district:

eststo d5: melogit cetp_d c.elf_country c.elf_dis $indcond || country:  || district:
eststo d6: meologit trustdiff c.elf_country c.elf_dis $indcond || country:  || district:


	
* RESTRICT TO "Indigenes ONLY"

set more off
eststo n1: melogit cetp_d c.elf_country $indcond  if indigene==1 || country:  ||  region:
eststo n2: meologit trustdiff c.elf_country $indcond if indigene==1  || country:  ||  region: 

eststo n3: melogit cetp_d c.elf_reg $indcond if indigene==1  || country:  || region:
eststo n4: meologit trustdiff c.elf_reg $indcond if indigene==1  || country:  || region: 

eststo n5: melogit cetp_d c.elf_country c.elf_reg $indcond if indigene==1  || country:  || region: 
eststo n6: meologit trustdiff c.elf_country c.elf_reg $indcond if indigene==1  || country:  || region: 

eststo n7: melogit cetp_d c.dseg_dis  $indcond if indigene==1  || country:  ||	district: 
eststo n8: meologit trustdiff c.dseg_dis  $indcond if indigene==1  || country:  ||	district: 

eststo n9: melogit cetp_d c.dseg_dis##c.elf_country $indcond if indigene==1  || country:  ||	district: 
eststo n10: meologit trustdiff c.dseg_dis##c.elf_country $indcond if indigene==1  || country:  ||	district: 

eststo n11: melogit cetp_d c.elfdist $indcond if indigene==1 || district:  ||  eacode:
eststo n12: meologit trustdiff c.elfdist $indcond if indigene==1 || district:  ||  eacode:

eststo n13: melogit cetp_d c.elfea $indcond if indigene==1 || district:  ||  eacode:
eststo n14: meologit trustdiff c.elfea $indcond if indigene==1 || district:  ||  eacode:

eststo n15: melogit cetp_d c.elfdist c.elfea $indcond if indigene==1 || district:  ||  eacode:
eststo n16: meologit trustdiff c.elfdist c.elfea $indcond if indigene==1 || district:  ||  eacode:

eststo n17: melogit cetp_d c.ddist  $indcond if indigene==1 || district:  ||  eacode:
eststo n18: meologit trustdiff c.ddist  $indcond if indigene==1 || district:  ||  eacode:

eststo n19: melogit cetp_d c.ddist##c.elfdist $indcond if indigene==1 || district:  ||  eacode:
eststo n20: meologit trustdiff c.ddist##c.elfdist $indcond if indigene==1 || district:  ||  eacode:

* CONTROL FOR COETHNIC INTERVIEWERS (reduces sample due to data availability)

set more off
eststo coeth1: melogit cetp_d c.elf_country $indcond  coeth || country:  ||  region:
eststo coeth2: meologit trustdiff c.elf_country $indcond coeth  || country:  ||  region: 

eststo coeth3: melogit cetp_d c.elf_reg $indcond coeth  || country:  || region:
eststo coeth4: meologit trustdiff c.elf_reg $indcond coeth  || country:  || region: 

eststo coeth5: melogit cetp_d c.elf_country c.elf_reg $indcond coeth  || country:  || region: 
eststo coeth6: meologit trustdiff c.elf_country c.elf_reg $indcond coeth  || country:  || region: 

eststo coeth7: melogit cetp_d c.dseg_dis  $indcond coeth || country:  ||	district: 
eststo coeth8: meologit trustdiff c.dseg_dis  $indcond coeth || country:  ||	district: 

eststo coeth9: melogit cetp_d c.dseg_dis##c.elf_country $indcond coeth  || country:  ||	district: 
eststo coeth10: meologit trustdiff c.dseg_dis##c.elf_country $indcond coeth  || country:  ||	district: 

eststo coeth11: melogit cetp_d c.elfdist $indcond coeth || district:  ||  eacode:
eststo coeth12: meologit trustdiff c.elfdist $indcond coeth || district:  ||  eacode:

eststo coeth13: melogit cetp_d c.elfea $indcond coeth || district:  ||  eacode:
eststo coeth14: meologit trustdiff c.elfea $indcond coeth || district:  ||  eacode:

eststo coeth15: melogit cetp_d c.elfdist c.elfea $indcond coeth || district:  ||  eacode:
eststo coeth16: meologit trustdiff c.elfdist c.elfea $indcond coeth || district:  ||  eacode:

eststo coeth17: melogit cetp_d c.ddist  $indcond coeth || district:  ||  eacode:
eststo coeth18: meologit trustdiff c.ddist  $indcond coeth || district:  ||  eacode:

eststo coeth19: melogit cetp_d c.ddist##c.elfdist $indcond coeth || district:  ||  eacode:
eststo coeth20: meologit trustdiff c.ddist##c.elfdist $indcond coeth || district:  ||  eacode:


* CONTROL FOR PLURALITY STATUS 

set more off
eststo plur1: melogit cetp_d c.elf_country $indcond  majgroup_co   || country:  ||  region:
eststo plur2: meologit trustdiff c.elf_country $indcond majgroup_co  || country:  ||  region: 

eststo plur3: melogit cetp_d c.elf_reg $indcond majgroup_co   || country:  || region:
eststo plur4: meologit trustdiff c.elf_reg $indcond majgroup_co   || country:  || region: 

eststo plur5: melogit cetp_d c.elf_country c.elf_reg $indcond majgroup_co   || country:  || region: 
eststo plur6: meologit trustdiff c.elf_country c.elf_reg $indcond majgroup_co   || country:  || region: 

eststo plur7: melogit cetp_d c.dseg_dis  $indcond majgroup_co  || country:  ||	district: 
eststo plur8: meologit trustdiff c.dseg_dis  $indcond majgroup_co  || country:  ||	district: 

eststo plur9: melogit cetp_d c.dseg_dis##c.elf_country $indcond majgroup_co   || country:  ||	district: 
eststo plur10: meologit trustdiff c.dseg_dis##c.elf_country $indcond majgroup_co   || country:  ||	district: 

eststo plur11: melogit cetp_d c.elfdist $indcond  majgroup_dis || district:  ||  eacode:
eststo plur12: meologit trustdiff c.elfdist $indcond  majgroup_dis || district:  ||  eacode:

eststo plur13: melogit cetp_d c.elfea $indcond  majgroup_dis || district:  ||  eacode:
eststo plur14: meologit trustdiff c.elfea $indcond  majgroup_dis || district:  ||  eacode:

eststo plur15: melogit cetp_d c.elfdist c.elfea $indcond  majgroup_dis || district:  ||  eacode:
eststo plur16: meologit trustdiff c.elfdist c.elfea $indcond  majgroup_dis || district:  ||  eacode:

eststo plur17: melogit cetp_d c.ddist  $indcond  majgroup_dis || district:  ||  eacode:
eststo plur18: meologit trustdiff c.ddist  $indcond  majgroup_dis || district:  ||  eacode:

eststo plur19: melogit cetp_d c.ddist##c.elfdist $indcond  majgroup_dis || district:  ||  eacode:
eststo plur20: meologit trustdiff c.ddist##c.elfdist $indcond  majgroup_dis || district:  ||  eacode:





* DROPPING EACH COUNTRY
foreach n of numlist 1 2 4 5 6 7 8 9 10 11 12 13 14 15 16 17 {
preserve
drop if country==`n'
set more off
eststo cd5_`n': melogit cetp_d c.elf_country c.elf_reg $indcond  || country:  || region: 
eststo cd7_`n': melogit cetp_d c.dseg_dis   $indcond   || country:  || district:
restore
}



* Add number of observations by group
global est c1 c2 c3 c4 v1 u1 v2 u2 u3 u4 i1 i2 i3 i4 ///
            cm1 cm2 cm3 cm4 um1 um2 um3 um4 im1 im2 im3 im4 s1 s2 s3 s4 si1 si2 si3 ///
            si4 sm1 sm2 sm3 sm4 sim1 sim2 sim3 sim4 cd1 cd2 d3 d4 d5 d6 n1 n2 n3 n4 ///
            n5 n6 n7 n8 n9 n10 n11 n12 n13 n14 n15 n16 n17 n18 n19 n20 coeth1 coeth2 coeth3 coeth4 ///
            coeth5 coeth6 coeth7 coeth8 coeth9 coeth10 coeth11 coeth12 coeth13 coeth14 coeth15 /// 
            coeth16 coeth17 coeth18 coeth19 coeth20 plur1 plur2 plur3 plur4 ///
            plur5 plur6 plur7 plur8 plur9 plur10 plur11 plur12 plur13 plur14 plur15 /// 
            plur16 plur17 plur18 plur19 plur20 fu1 fu2 fum1 fum2
foreach e in $est {
est restore `e'
mat N_g =e(N_g)
estadd scalar Nc=N_g[1,1]: `e'
estadd scalar Nr=N_g[1,2]: `e'
}

* Add # of observations for analyses dropping each country
foreach n of numlist 1 2 4 5 6 7 8 9 10 11 12 13 14 15 16 17 {
foreach c of numlist 5 7 {
est restore cd`c'_`n'
mat N_g =e(N_g)
estadd scalar Nc=N_g[1,1]: cd`c'_`n'
estadd scalar Nr=N_g[1,2]: cd`c'_`n'
}
}

* Add # of observations for Fixed-Effects models: fu1 fu2 fum1 fum2
foreach e in fu1 fu2 {
est restore `e'
estadd scalar Nt=16: `e'
}

foreach e in fum1 fum2 {
est restore `e'
estadd scalar Nt=26: `e'
}




* Summary Statistics

* individual level
estpost summ cetp_d trustdiff etrust netrust $indcond indigene coeth majgroup_co majgroup_dis if ABsample==1
eststo summ_ind
* country level
estpost summ elf_country dseg_dis  if ctag==1
eststo summ_country
* region level
estpost summ elf_reg if rtag==1 
eststo summ_reg
* district level 
estpost summ elf_dis if dtag==1 
eststo summ_dis
estpost summ elfdist ddist  if dtag==1 & country==8
eststo summ_dis_m
* ea level
estpost summ  elfea if eatag==1 & country==8
eststo summ_ea_m


