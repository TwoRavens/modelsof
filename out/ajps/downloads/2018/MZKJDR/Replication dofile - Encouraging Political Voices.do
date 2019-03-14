****************************************************************************************************
* Replication do-file for "Encouraging Political Voices of Underrepresented Citizens through Coproduction - Evidence from a Randomized Field Trial"
****************************************************************************************************

*Hjortskov, Morten, Simon Calmar Andersen and Morten Jakobsen. 2017. "Encouraging Political Voices of Underrepresented Citizens through Coproduction - Evidence from a Randomized Field Trial.", American Journal of Political Science


*************************
* Manuscript
*************************


use "D:\Data\Workdata\703931\Morten Hjortskov\Coproduction and Voice\AJPS\Replication files\Encouraging_political_voices.dta", clear

*Table 1 - Overview of the Experimental Design

tab ekspgr_sprogsc


*Table 2 (and E.1) - Estimated Effect of Coproduction Intervention (Intent-to-treat) on Voicing in the Citizen Survey

xtreg svar2009 i.ekspgr_sprogsc i.grp mlow mmiddle mhigh b1.antmor gender age agem morenlig marb lonm1000 i.ieland_kat, i(institution8_sc) vce(cluster institution8_sc) re
gen the871 = e(sample)

xtreg svar2009 i.ekspgr_sprogsc if the871==1, i(institution8_sc) vce(cluster institution8_sc) re

xtreg svar2009 i.ekspgr_sprogsc i.grp if the871==1, i(institution8_sc) vce(cluster institution8_sc) re

xtreg svar2009 i.ekspgr_sprogsc i.grp mlow mmiddle mhigh b1.antmor gender age agem morenlig marb lonm1000 i.ieland_kat if the871==1, i(institution8_sc) vce(cluster institution8_sc) re


*Table 3 (and E.2) - Estimated Effect of Coproduction Intervention (Intent-to-treat) on Voting

xtreg elec2009 i.ekspgr_sprogsc i.grp mlow mmiddle mhigh b1.antmor gender age agem morenlig marb lonm1000 i.ieland_kat, i(institution8_sc) vce(cluster institution8_sc) re
gen the698 = e(sample)

xtreg elec2009 i.ekspgr_sprogsc if the698==1, i(institution8_sc) vce(cluster institution8_sc) re

xtreg elec2009 i.ekspgr_sprogsc i.grp if the698==1, i(institution8_sc) vce(cluster institution8_sc) re

xtreg elec2009 i.ekspgr_sprogsc i.grp mlow mmiddle mhigh b1.antmor gender age agem morenlig marb lonm1000 i.ieland_kat if the698==1, i(institution8_sc) vce(cluster institution8_sc) re


*Table 4 (and E.7) - Effect of Interventions on Voice Among Those Who Voted/Did not Vote
xtreg svar2009 itt2 itt3 i.grp mlow mmiddle mhigh b1.antmor gender age agem morenlig marb lonm1000 i.ieland_kat, i(institution8_sc) vce(cluster institution8_sc) re 
gen plainmed = e(sample)

xtreg svar2009 itt2 itt3 if plainmed==1 & elec2009==1, i(institution8_sc) vce(cluster institution8_sc) re 

xtreg svar2009 itt2 itt3 i.grp mlow mmiddle mhigh b1.antmor gender age agem morenlig marb lonm1000 i.ieland_kat if plainmed==1 & elec2009==1, i(institution8_sc) vce(cluster institution8_sc) re 

xtreg svar2009 itt2 itt3 if plainmed==1 & elec2009==0, i(institution8_sc) vce(cluster institution8_sc) re 

xtreg svar2009 itt2 itt3 i.grp mlow mmiddle mhigh b1.antmor gender age agem morenlig marb lonm1000 i.ieland_kat if plainmed==1 & elec2009==0, i(institution8_sc) vce(cluster institution8_sc) re 


*************************
* Supporting information
*************************


*Table A.1 - Summary Statistics of the Control and Treatment Groups

xtreg svar2009 itt2 itt3 i.grp mlow mmiddle mhigh b1.antmor gender age agem morenlig marb lonm1000 i.ieland_kat, i(institution8_sc) vce(cluster institution8_sc) re
gen balancemed=e(sample)

tabulate mlow ekspgr_sprogsc if balancemed==1, column
tabulate mmiddle ekspgr_sprogsc if balancemed==1, column
tabulate mhigh ekspgr_sprogsc if balancemed==1, column
tabulate mornoedu ekspgr_sprogsc if balancemed==1, column
table ekspgr_sprogsc if balancemed==1, c(mean antmor n antmor)
tabulate gender ekspgr_sprogsc if balancemed==1, column
tabulate morenlig ekspgr_sprogsc if balancemed==1, column
tabulate marb ekspgr_sprogsc if balancemed==1, column
table ekspgr_sprogsc if balancemed==1, c(mean agem n agem)
table ekspgr_sprogsc if balancemed==1, c(mean age n age)
table ekspgr_sprogsc if balancemed==1, c(mean lonm1000 n lonm1000)
tabulate ieland_kat ekspgr_sprogsc if balancemed==1, column

mlogit ekspgr_sprogsc mlow mhigh mmiddle mornoedu antmor gender morenlig marb agem age lonm1000 i.ieland_kat, vce(cluster institution8_sc)


*Table A.2 - Balance Checks at Preschool level. Means and proportions (n in parentheses)

* Data on children in schools in Aarhus at baseline 
use "E:\workdata\702736\Børn i inst 2008\Børn i inst 2008.dta", clear

* Informtion on experimental groups
merge m:1 institution8 using "E:\workdata\702736\Papers\Voice\Oversigt over inst med i eksperimentet (ud fra sprogscreenninger).dta", keep(match master using)
drop if _merge==1
drop _merge

* Collapsing to school-level 
collapse (count) pnr (mean) etnisk pige ctype_enlig mudd_videre fudd_videre alder_md8 husindkomst ekspgr_itt, by(institution8)
rename pnr antalbørniinst

bysort ekspgr_itt: sum antalbørniinst 
bysort ekspgr_itt: sum etnisk 
bysort ekspgr_itt: sum pige 
bysort ekspgr_itt: sum ctype_enlig 
bysort ekspgr_itt: sum mudd_videre 
bysort ekspgr_itt: sum fudd_videre 
bysort ekspgr_itt: sum alder_md8 
bysort ekspgr_itt: sum husindkomst 

reg antalbørniinst i.ekspgr_itt
reg etnisk i.ekspgr_itt
reg pige i.ekspgr_itt
reg ctype_enlig i.ekspgr_itt
reg mudd_videre i.ekspgr_itt
reg fudd_videre i.ekspgr_itt
reg alder_md8 i.ekspgr_itt
reg husindkomst i.ekspgr_itt


* Data on the school teachers
use "E:\workdata\702736\Pædagogundersøgelser, 2008 og 2010\Pædagogundersøgelserne 2008-10.dta", clear

* Dropping school in data that are not part of the study population
drop if ekspgr_itt==.
drop if institution8==77
drop if institution8==348
drop if institution8==364
drop if institution8==377
drop if institution8==396

* Collapsing to school-level 
collapse ekspgr_itt itt1 itt2 itt3 kvinde alder8 tenure8 totalsygedage7_8 lønprtimer8_vers1 lønprtimer8_vers2 antalbørnialt_bhv8 antal_dsa_inst8 antal_dsa_bhv8 andel_dsa_inst8 andel_dsa_bhv8 sprogpenge8 sprogpenge8_alle antalbørnialt_inst8 pos_gen8 commit_gen8 stress8 stress_gen8, by(institution8)

bysort ekspgr_itt: sum kvinde
bysort ekspgr_itt: sum alder8 
bysort ekspgr_itt: sum tenure8 
bysort ekspgr_itt: sum totalsygedage7_8 
bysort ekspgr_itt: sum pos_gen8 
bysort ekspgr_itt: sum commit_gen8 
bysort ekspgr_itt: sum stress_gen8

reg kvinde i.ekspgr_itt
reg alder8  i.ekspgr_itt 
reg tenure8  i.ekspgr_itt 
reg totalsygedage7_8  i.ekspgr_itt
reg pos_gen8  i.ekspgr_itt
reg commit_gen8  i.ekspgr_itt
reg stress_gen  i.ekspgr_itt


*Table B.1 - Dependent variables

sum svar2009 if ekspgr_sprogsc!=.
sum elec2009 if ekspgr_sprogsc!=.


*Table C.1 - Illustrating Underrepresentation among Immigrants in the 2009 Government Feedback Survey and in the Municipal Election of 2009

*Answered Survey (per child, country of origin and highest education is coded as mothers)
use "D:\Data\Workdata\703931\Morten Hjortskov\Coproduction and Voice\AJPS\Replication files\Table_C1_Voice.dta", clear
tab landgrp_m complete2009, row
tab uddmgrp complete2009, row

*Voted (per parent, both mother and father)
use "D:\Data\Workdata\703931\Morten Hjortskov\Coproduction and Voice\AJPS\Replication files\Table_C1_Election.dta", clear
tab landgrp stemte, row
tab uddgrp stemte, row


*Table D.1 - Balance in the Compliance Survey
use "D:\Data\Workdata\703931\Morten Hjortskov\Coproduction and Voice\AJPS\Replication files\Encouraging_political_voices.dta", clear

ivregress 2sls svar2009 i.grp mlow mmiddle mhigh i.antmor gender age agem morenlig marb lonm1000 i.ieland_kat hvem_svarede1 hvem_svarede2 (fået=kontrolvskuffert), vce(cluster institution8_sc) first
gen ivmedart = e(sample)

sort kontrolvskuffert
by kontrolvskuffert: sum ibn.grp mornoedu mlow mmiddle mhigh antmor gender age agem morenlig marb lonm1000 ibn.ieland_kat hvem_svarede1 hvem_svarede2 hvem_svarede3 if ivmedart==1


global usednominal "mornoedu mmiddle mhigh gender morenlig marb"
global usedinterval "age agem antmor lonm1000"

foreach var of varlist $usednominal {
	xtreg kontrolvskuffert `var' if ivmedart==1, i(dag_afd2009) vce(cluster dag_afd2009) re
	}

foreach var of varlist $usedinterval {
	xtreg kontrolvskuffert `var' if ivmedart==1, i(dag_afd2009) vce(cluster dag_afd2009) re
	}
	
xtreg kontrolvskuffert i.ieland_kat if ivmedart==1, i(dag_afd2009)	vce(cluster dag_afd2009)
xtreg kontrolvskuffert hvem_svarede1 if ivmedart==1, i(dag_afd2009)	vce(cluster dag_afd2009)
xtreg kontrolvskuffert hvem_svarede2 if ivmedart==1, i(dag_afd2009)	vce(cluster dag_afd2009)
xtreg kontrolvskuffert hvem_svarede3 if ivmedart==1, i(dag_afd2009)	vce(cluster dag_afd2009)


*Table D.2 - Attrition from the Compliance Survey by Experimental Groups

tab ivmedart kontrolvskuffert, column


*Table D.3 (and E.3 + E.4) - Estimated Effects on Voicing Comparing Assigned, Received, and Engaged

xtreg svar2009 itt2 i.grp mlow mmiddle mhigh i.antmor gender age agem morenlig marb lonm1000 i.ieland_kat hvem_svarede1 hvem_svarede2 if ivmedart==1, i(institution8_sc) vce(cluster institution8_sc)
ivregress 2sls svar2009 i.grp mlow mmiddle mhigh b1.antmor gender age agem morenlig marb lonm1000 i.ieland_kat hvem_svarede1 hvem_svarede2 (fået=kontrolvskuffert) if ivmedart==1, vce(cluster institution8_sc) first
ivregress 2sls svar2009 i.grp mlow mmiddle mhigh b1.antmor gender age agem morenlig marb lonm1000 i.ieland_kat hvem_svarede1 hvem_svarede2 (brugdum=kontrolvskuffert) if ivmedart==1, vce(cluster institution8_sc) first


*Table D.4 (and E.5 + E.6) - Estimated Effects on Voting Comparing Assigned, Received, and Engaged

ivregress 2sls elec2009 i.grp mlow mmiddle mhigh i.antmor gender age agem morenlig marb lonm1000 i.ieland_kat (fået = kontrolvskuffert), vce(cluster institution8_sc)
gen ivelecmed = e(sample)

xtreg elec2009 itt2 if ivelecmed==1, i(institution8_sc) vce(cluster institution8_sc)
xtreg elec2009 itt2 i.grp mlow mmiddle mhigh i.antmor gender age agem morenlig marb lonm1000 i.ieland_kat hvem_svarede1 hvem_svarede2 if ivelecmed==1, i(institution8_sc) vce(cluster institution8_sc)
ivregress 2sls elec2009 (fået = kontrolvskuffert) if ivelecmed==1, vce(cluster institution8_sc)
ivregress 2sls elec2009 i.grp mlow mmiddle mhigh i.antmor gender age agem morenlig marb lonm1000 i.ieland_kat hvem_svarede1 hvem_svarede2 (fået = kontrolvskuffert) if ivelecmed==1, vce(cluster institution8_sc)
ivregress 2sls elec2009 (brugdum = kontrolvskuffert) if ivelecmed==1, vce(cluster institution8_sc)
ivregress 2sls elec2009 i.grp mlow mmiddle mhigh i.antmor gender age agem morenlig marb lonm1000 i.ieland_kat hvem_svarede1 hvem_svarede2 (brugdum = kontrolvskuffert) if ivelecmed==1, vce(cluster institution8_sc)


*Table F.1 - Main Results with Random Effects and Clustered Standard Errors at the District Level
xtreg svar2009 i.ekspgr_sprogsc i.grp mlow mmiddle mhigh b1.antmor gender age agem morenlig marb lonm1000 i.ieland_kat, i(institution8_sc) vce(cluster institution8_sc) re
gen the871 = e(sample)

xtreg svar2009 i.ekspgr_sprogsc if the871==1, i(dagtilbudsnummer8) vce(cluster dagtilbudsnummer8) re
xtreg svar2009 i.ekspgr_sprogsc i.grp if the871==1, i(dagtilbudsnummer8) vce(cluster dagtilbudsnummer8) re
xtreg svar2009 i.ekspgr_sprogsc i.grp mlow mmiddle mhigh b1.antmor gender age agem morenlig marb lonm1000 i.ieland_kat if the871==1, i(dagtilbudsnummer8) vce(cluster dagtilbudsnummer8) re


*Table F.2 - Main Results with OLS and Logit Specifications

xtreg svar2009 i.ekspgr_sprogsc if the871==1, i(institution8_sc) vce(cluster institution8_sc) re
xtreg svar2009 i.ekspgr_sprogsc i.grp if the871==1, i(institution8_sc) vce(cluster institution8_sc) re
xtreg svar2009 i.ekspgr_sprogsc i.grp mlow mmiddle mhigh b1.antmor gender age agem morenlig marb lonm1000 i.ieland_kat if the871==1, i(institution8_sc) vce(cluster institution8_sc) re
regress svar2009 i.ekspgr_sprogsc if the871==1, vce(cluster institution8_sc)
regress svar2009 i.ekspgr_sprogsc i.grp if the871==1, vce(cluster institution8_sc)
regress svar2009 i.ekspgr_sprogsc i.grp i.grp mlow mmiddle mhigh b1.antmor gender age agem morenlig marb lonm1000 i.ieland_kat if the871==1, vce(cluster institution8_sc)
xtlogit svar2009 i.ekspgr_sprogsc if the871==1, i(institution8_sc) vce(cluster institution8_sc) re
xtlogit svar2009 i.ekspgr_sprogsc i.grp if the871==1, i(institution8_sc) vce(cluster institution8_sc) re
xtlogit svar2009 i.ekspgr_sprogsc i.grp mlow mmiddle mhigh gender age agem morenlig marb lonm1000 i.ieland_kat if the871==1, i(institution8_sc) vce(cluster institution8_sc) re //obs, var nødt til at droppe antmor pga. perfekt forklaring
