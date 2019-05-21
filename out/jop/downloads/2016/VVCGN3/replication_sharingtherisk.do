**********************************************************************************************************
* Replication Code
* Sharing the Risk? Households, labor market vulnerability and social policy preferences in Western Europe
* Silja HŠusermann, Thomas Kurer and Hanna Schwander
* Journal of Politics, 2016
**********************************************************************************************************

* This script replicates all empirical results (tables and figures) based on the ESS.
* Outsiderness values are generated based on EU-SILC in a separate file ("create_outsiderness_SILC.do").
* Merging of the two data sources on line 970.

version 13
* parts of this code has been written using older stata versions, but code is fully compatible with version 13
clear all
set more off

********************************************
* 1. LOAD DATA
********************************************

* set directory (change to run)
cd "/Volumes/projects$/dualization/replicationJoP"

* use ESS 2008 (wave 4, Version e03, downloaded: March 10, 2010)

use "ESS4e03.dta"


********************************************
* 2. SAMPLE
********************************************

* country selection
* keep: BE, CH, DE, FR, DK, FI, NO, SE, ES, PT, GB, GR, NL

drop if cntry=="BG"
drop if cntry=="CY"
drop if cntry=="EE"
drop if cntry=="PL"
drop if cntry=="SI"
drop if cntry=="RU"
drop if cntry=="CZ"
drop if cntry=="HR"
drop if cntry=="HU"
drop if cntry=="IL"
drop if cntry=="LV"
drop if cntry=="RO"
drop if cntry=="SK"
drop if cntry=="TR"
drop if cntry=="UA"


********************************************
* 3. DATA PREPARATION
********************************************

* 3.1 Dependent Variables: Redistribution and Jobcreation
********************************************

* GINCDIF (B30): "The goverment should take measures to reduce differences in income levels"
* 1 agree strongly - 5 disagree strongly (7,8,9)

gen incdiff=gincdif
recode incdiff (1=5) (2=4) (3=3) (4=2) (5=1) (6=.) (7=.) (8=.)

* redist3 (only incdiff)

gen redist3=incdiff
la var redist3 "Redistribution (gov reduce inc diff)"

#delimit ;
la de redist3 
1  "disagree strongly"
2  "disagree"
3  "neither agree nor disagree"   
4  "agree"
5  "agree strongly";
la val redist3 redist3 ;
#delimit cr

* GVJBEVN (D15): "government's responsibility to ... ensure a job for everyone who wants one"
* 0 should not be - 10 should be (77, 88, 99)

* jobcreation

gen jobcreation=gvjbevn
recode jobcreation (77=.) (88=.) (99=.)
tab jobcreation
corr jobcreation gvjbevn


* 3.2 Main independent Variable: Outsiderness
********************************************

* Outsiderness Values are calculated in EU-SILC
* We need to create groups which allow for merging
* 20 occupational groups (5xclass, 2xage, 2xgender)
* Groups are created for both respondents and respondents' partners

* Create occupational groups for respondent

gen gender=.
replace gender=1 if gndr==2
replace gender=0 if gndr==1
label var gender "gender"

#delimit;
label define gender
1 "female"
0 "male", modify;
label values gender gender;
#delimit cr

gen young=0.
replace young=1 if agea<=40
label var young "young, under 40"

#delimit;
label define young
1 "below40"
0 "over40", modify;
label values young young;
#delimit cr

* Kitschelt/Rehm-classes (respondent and spouse)

* generating isco88-2d codes from the 4-digit ISCO88 codes
* respondents 
gen r_isco88_2d=real(substr(string(iscoco),1,2))

* respondents' spouses 
gen sp_isco88_2d=real(substr(string(iscocop),1,2))

* note: these codes are not 'clean', but the code below selects only regular isco88-2d codes 
gen isco88_2d=r_isco88_2d
replace isco88_2d=sp_isco88_2d if r_isco88_2d==.

label var r_isco88_2d "Respondent's occupational code (in ISCO88-2d) [ISCO88]"
label var sp_isco88_2d "Spouse's occupational code (in ISCO88-2d) [SPISCO88]"
label var isco88_2d "ISCO88, 2-digit (respondent OR spouse) [ISCO88 & SPISCO88]"

* to identify the self-employed 
gen selfempl=.
replace selfempl=0 if emplrel==1 | emplrel==3
replace selfempl=1 if emplrel==2
label var selfempl "Dummy for self-employed [emplrel=2]"

* to generate the socio-economic groups 
gen groups=.
replace groups=1 if isco88_2d==11 | isco88_2d==12 | isco88_2d==13 | isco88_2d==21
replace groups=2 if isco88_2d==41 | isco88_2d==42 | isco88_2d==31
replace groups=3 if isco88_2d==61 | isco88_2d==92 ///
  | isco88_2d==81 | isco88_2d==82 | isco88_2d==83 | isco88_2d==93 ///
  | isco88_2d==71 | isco88_2d==72 | isco88_2d==73 | isco88_2d==74
replace groups=4 if isco88_2d==22 | isco88_2d==23 | isco88_2d==24 ///
  | isco88_2d==32 | isco88_2d==33 | isco88_2d==34
replace groups=5 if isco88_2d==51 | isco88_2d==52 | isco88_2d == 91

* to allocate the self-employed to groups 
replace groups=1 if selfempl==1 & isco88_2d<=24 & groups!=.
replace groups=2 if selfempl==1 & isco88_2d> 24 & groups!=.

label var groups "Socio-economic groups (HK & PhR)"

#delimit;
label define groups  
1 "Capital accumulators"
2 "Mixed service functionaires"
3 "Blue and lower white collar"
4 "Socio-cultural (semi-)professionals"
5 "Low service functionaires", modify;
label values groups groups;

#delimit cr

* exclusive groups (20 occupational groups on which outsiderness is based)

*young women
gen youngfemale=.
la var youngfemale "young women"

replace youngfemale=1 if gender==1 & young==1
replace youngfemale=0 if gender==0 | young==0

#delimit;
label define youngfemale 
1 "young female"
0 "else", modify;
la val youngfemale youngfemale
;
#delimit cr


*young men
gen youngmale =.
la var youngmale "young men"

replace youngmale =1 if gender==0 & young==1
replace youngmale =0 if gender==1 | young==0

#delimit;
label define youngmale 
1 "young male"
0 "else", modify;
la val youngmale youngmale
;
#delimit cr

*Old women
gen oldfemale=.
la var oldfemale "old women"

replace oldfemale =1 if gender==1 & young==0
replace oldfemale =0 if gender==0 | young==1

#delimit;
label define oldfemale
1 "old female"
0 "else", modify;
la val oldfemale oldfemale
;
#delimit cr

*Old Men
gen oldmale=.
la var oldmale "old men"

replace oldmale=1 if gender==0 & young==0
replace oldmale=0 if gender==1 | young==1

#delimit;
label define oldmale
1 "old male"
0 "else", modify;
la val oldmale oldmale
;
#delimit cr


*LSF_youngfemale
gen LSF_youngfemale=.
la var LSF_youngfemale "LSF young women"

replace LSF_youngfemale=1 if youngfemale==1 & groups==5 
replace LSF_youngfemale=0 if youngfemale==1 & groups!=5
replace LSF_youngfemale=0 if youngfemale==0

la de LSF_youngfemale 1 "LSF young female" 0 "else", modify
la val LSF_youngfemale LSF_youngfemale 

*LSF young male
gen LSF_youngmale=.
la var LSF_youngmale "LSF young men"

replace LSF_youngmale=1 if youngmale==1 & groups==5 
replace LSF_youngmale=0 if youngmale==1 & groups!=5
replace LSF_youngmale=0 if youngmale==0

la de LSF_youngmale 1 "LSF young male" 0 "else", modify
la val LSF_youngmale LSF_youngmale

tab LSF_youngmale LSF_youngfemale

*LSF_oldfemale
gen LSF_oldfemale=.
la var LSF_oldfemale "LSF old Women"

replace LSF_oldfemale=1 if oldfemale==1 & groups==5
replace LSF_oldfemale=0 if oldfemale==0
replace LSF_oldfemale=0 if oldfemale==1 & groups!=5

la de LSF_oldfemale 1 "LSF old female" 0 "else"
la val LSF_oldfemale LSF_oldfemale

*LSF_oldmale
gen LSF_oldmale=.
la var LSF_oldmale "LSF Old Men"
replace LSF_oldmale=1 if oldmale==1 & groups==5
replace LSF_oldmale=0 if oldmale==1 & groups!=5
replace LSF_oldmale=0 if oldmale==0

la de LSF_oldmale 1 "LSF old male" 0 "else"
la val LSF_oldmale LSF_oldmale

tab LSF_oldmale LSF_oldfemale
tab LSF_youngmale LSF_oldmale

*SCP_youngfemale
gen SCP_youngfemale=.
la var SCP_youngfemale "SCP young women"

replace SCP_youngfemale=1 if youngfemale==1 & groups==4 
replace SCP_youngfemale=0 if youngfemale==1 & groups!=4
replace SCP_youngfemale=0 if youngfemale==0

la de SCP_youngfemale 1 "SCP young female" 0 "else", modify
la val SCP_youngfemale SCP_youngfemale

*SCP young male
gen SCP_youngmale=.
la var SCP_youngmale "SCP young men"

replace SCP_youngmale=1 if youngmale==1 & groups==4
replace SCP_youngmale=0 if youngmale==1 & groups!=4
replace SCP_youngmale=0 if youngmale==0

la de SCP_youngmale 1 "SCP young male" 0 "else", modify
la val SCP_youngmale SCP_youngmale 

tab SCP_youngmale SCP_youngfemale

*SCP_oldfemale
gen SCP_oldfemale=.
la var SCP_oldfemale "SCP old Women"

replace SCP_oldfemale=1 if oldfemale==1 & groups==4
replace SCP_oldfemale=0 if oldfemale==0
replace SCP_oldfemale=0 if oldfemale==1 & groups!=4

la de SCP_oldfemale 1 "SCP old female" 0 "else"
la val SCP_oldfemale SCP_oldfemale

*SCP_oldmale
gen SCP_oldmale=.
la var SCP_oldmale "SCP Old Men"
replace SCP_oldmale=1 if oldmale==1 & groups==4
replace SCP_oldmale=0 if oldmale==1 & groups!=4
replace SCP_oldmale=0 if oldmale==0

la de SCP_oldmale 1 "SCP old male" 0 "else"
la val SCP_oldmale SCP_oldmale

tab SCP_oldmale SCP_oldfemale

*BC_youngfemale
gen BC_youngfemale=.
la var BC_youngfemale "BC young women"

replace BC_youngfemale=1 if youngfemale==1 & groups==3 
replace BC_youngfemale=0 if youngfemale==1 & groups!=3
replace BC_youngfemale=0 if youngfemale==0

la de BC_youngfemale 1 "BC young female" 0 "else", modify
la val BC_youngfemale BC_youngfemale

*BC young male
gen BC_youngmale=.
la var BC_youngmale "BC young men"

replace BC_youngmale=1 if youngmale==1 & groups==3
replace BC_youngmale=0 if youngmale==1 & groups!=3
replace BC_youngmale=0 if youngmale==0

la de BC_youngmale 1 "BC young male" 0 "else", modify
la val BC_youngmale BC_youngmale

*BC_oldfemale
gen BC_oldfemale=.
la var BC_oldfemale "BC old Women"

replace BC_oldfemale=1 if oldfemale==1 & groups==3
replace BC_oldfemale=0 if oldfemale==1 & groups!=3
replace BC_oldfemale=0 if oldfemale==0

la de BC_oldfemale 1 "BC old female" 0 "else"
la val BC_oldfemale BC_oldfemale

*BC_oldmale
gen BC_oldmale=.
la var BC_oldmale "BC Old Men"
replace BC_oldmale=1 if oldmale==1 & groups==3
replace BC_oldmale=0 if oldmale==1 & groups!=3
replace BC_oldmale=0 if oldmale==0

la de BC_oldmale 1 "BC old male" 0 "else"
la val BC_oldmale BC_oldmale

tab BC_oldmale BC_oldfemale
tab BC_youngmale BC_youngfemale

*MSF_youngfemale
gen MSF_youngfemale=.
la var MSF_youngfemale "MSF young women"

replace MSF_youngfemale=1 if youngfemale==1 & groups==2
replace MSF_youngfemale=0 if youngfemale==1 & groups!=2
replace MSF_youngfemale=0 if youngfemale==0

la de MSF_youngfemale 1 "MSF young female" 0 "else", modify
la val MSF_youngfemale MSF_youngfemale


*MSF young male
gen MSF_youngmale=.
la var MSF_youngmale "MSF young men"

replace MSF_youngmale=1 if youngmale==1 & groups==2
replace MSF_youngmale=0 if youngmale==1 & groups!=2
replace MSF_youngmale=0 if youngmale==0

la de MSF_youngmale 1 "MSF young male" 0 "else", modify
la val MSF_youngmale MSF_youngmale


*MSF_oldfemale
gen MSF_oldfemale=.
la var MSF_oldfemale "MSF old Women"

replace MSF_oldfemale=1 if oldfemale==1 & groups==2
replace MSF_oldfemale=0 if oldfemale==1 & groups!=2
replace MSF_oldfemale=0 if oldfemale==0

la de MSF_oldfemale 1 "MSF old female" 0 "else"
la val MSF_oldfemale MSF_oldfemale

*MSF_oldmale
gen MSF_oldmale=.
la var MSF_oldmale "BC Old Men"
replace MSF_oldmale=1 if oldmale==1 & groups==2
replace MSF_oldmale=0 if oldmale==1 & groups!=2
replace MSF_oldmale=0 if oldmale==0

la de MSF_oldmale 1 "MSF old male" 0 "else"
la val MSF_oldmale MSF_oldmale

tab MSF_oldmale MSF_oldfemale
tab MSF_youngmale MSF_youngfemale

gen MSF=.
replace MSF=1 if groups==2
replace MSF=0 if groups!=2

label var MSF "Mixed service functionaries"

label define MSF 1 "MSF" 0 "else"
label values MSF MSF

/*CA_youngfemale*/
gen CA_youngfemale=.
la var CA_youngfemale "CA young women"

replace CA_youngfemale=1 if youngfemale==1 & groups==1 
replace CA_youngfemale=0 if youngfemale==1 & groups!=1
replace CA_youngfemale=0 if youngfemale==0

la de CA_youngfemale 1 "CA young female" 0 "else", modify
la val CA_youngfemale CA_youngfemale 

/*CA young male*/
gen CA_youngmale=.
la var CA_youngmale "CA young men"

replace CA_youngmale=1 if youngmale==1 & groups==1 
replace CA_youngmale=0 if youngmale==1 & groups!=1
replace CA_youngmale=0 if youngmale==0

la de CA_youngmale 1 "CA young male" 0 "else", modify
la val CA_youngmale CA_youngmale

tab CA_youngmale CA_youngfemale


/*CA_oldfemale*/
gen CA_oldfemale=.
la var CA_oldfemale "CA old Women"

replace CA_oldfemale=1 if oldfemale==1 & groups==1
replace CA_oldfemale=0 if oldfemale==0
replace CA_oldfemale=0 if oldfemale==1 & groups!=1

la de CA_oldfemale 1 "CA old female" 0 "else"
la val CA_oldfemale CA_oldfemale

/*CA_oldmale*/
gen CA_oldmale=.
la var CA_oldmale "CA Old Men"
replace CA_oldmale=1 if oldmale==1 & groups==1
replace CA_oldmale=0 if oldmale==1 & groups!=1
replace CA_oldmale=0 if oldmale==0

la de CA_oldmale 1 "CA old male" 0 "else"
la val CA_oldmale CA_oldmale

tab CA_oldmale CA_oldfemale
tab CA_youngmale CA_oldmale


*Variable that contains all exl.groups *

gen exlgroups=.
la var exlgroups "socio-economic groups (excl)"

replace exlgroups =1 if LSF_youngfemale ==1
replace exlgroups =2 if LSF_youngmale ==1
replace exlgroups =3 if LSF_oldfemale ==1
replace exlgroups =4 if LSF_oldmale ==1
replace exlgroups =5 if SCP_youngfemale ==1
replace exlgroups =6 if SCP_youngmale ==1
replace exlgroups =7 if SCP_oldfemale ==1
replace exlgroups =8 if SCP_oldmale ==1
replace exlgroups =9 if BC_youngfemale ==1
replace exlgroups =10 if BC_youngmale ==1
replace exlgroups =11 if BC_oldfemale ==1
replace exlgroups =12 if BC_oldmale ==1
replace exlgroups =13 if MSF_youngfemale ==1
replace exlgroups =14 if MSF_youngmale ==1
replace exlgroups =15 if MSF_oldfemale ==1
replace exlgroups =16 if MSF_oldmale ==1
replace exlgroups = 17 if CA_youngfemale==1
replace exlgroups = 18 if CA_youngmale==1
replace exlgroups = 19 if CA_oldfemale==1
replace exlgroups = 20 if CA_oldmale==1


#delimit
la de exlgroups
1 "LSF_youngfemale"
2 "LSF_youngmale"
3 "LSF_oldfemale"
4 "LSF_oldmale"

5 "SCP_youngfemale"
6 "SCP_youngmale"
7 "SCP_oldfemale"
8 "SCP_oldmale"

9 "BC_youngfemale"
10 "BC_youngmale"
11 "BC_oldfemale"
12 "BC_oldmale"

13 "MSF_youngfemale"
14 "MSF_youngmale"
15 "MSF_oldfemale"
16 "MSF_oldmale"

17 "CA_youngfemale"
18 "CA_youngmale"
19 "CA_oldfemale"
20 "CA_oldmale", modify;
la val exlgroups exlgroups
;
#delimit cr


* Create occupational groups for partner
* exact same procedure

/* Condition: respondent must live with partner and second (3rd/4rd) person in household must be partner */

gen gender_sp = gndr2 if rshipa2==1
replace gender_sp = gndr3 if rshipa3==1
replace gender_sp = gndr4 if rshipa4==1

recode gender_sp (1=0) (2=1)

la de gender_sp 1 "female" 0 "male", modify
la val gender_sp gender_sp


gen age_sp = 2008- yrbrn2 if rshipa2==1
replace age_sp = 2008- yrbrn3 if rshipa3==1
replace age_sp = 2008- yrbrn4 if rshipa4==1


gen young_sp =.
replace young_sp =1 if age_sp <=40
replace young_sp =0 if age_sp >40


* respondents' spouses is already defined:
* gen sp_isco88_2d=real(substr(string(iscocop),1,2))

gen selfempl_sp=.
replace selfempl_sp=0 if emprelp==1 | emprelp==3
replace selfempl_sp=1 if emprelp==2
label var selfempl_sp "Dummy for self-employed [emprelp=2]"

* to generate the socio-economic groups for the partner
gen groups_sp=.
replace groups_sp=1 if sp_isco88_2d==11 | sp_isco88_2d==12 | sp_isco88_2d==13 | sp_isco88_2d==21
replace groups_sp=2 if sp_isco88_2d==41 | sp_isco88_2d==42 | sp_isco88_2d==31
replace groups_sp=3 if sp_isco88_2d==61 | sp_isco88_2d==92 ///
  | sp_isco88_2d==81 | sp_isco88_2d==82 | sp_isco88_2d==83 | sp_isco88_2d==93 ///
  | sp_isco88_2d==71 | sp_isco88_2d==72 | sp_isco88_2d==73 | sp_isco88_2d==74
replace groups_sp=4 if sp_isco88_2d==22 | sp_isco88_2d==23 | sp_isco88_2d==24 ///
  | sp_isco88_2d==32 | sp_isco88_2d==33 | sp_isco88_2d==34
replace groups_sp=5 if sp_isco88_2d==51 | sp_isco88_2d==52 | sp_isco88_2d == 91

* to allocate the self-employed to groups_sp 
replace groups_sp=1 if selfempl_sp==1 & sp_isco88_2d<=24 & groups_sp!=.
replace groups_sp=2 if selfempl_sp==1 & sp_isco88_2d> 24 & groups_sp!=.

label var groups_sp "Socio-economic groups_sp"

#delimit;
label define groups_sp  
1 "Capital accumulators"
2 "Mixed service functionaires"
3 "Blue and lower white collar"
4 "Socio-cultural (semi-)professionals"
5 "Low service functionaires", modify;
label values groups_sp groups_sp;

#delimit cr


*Partner: young women
gen youngfemale_sp=.
la var youngfemale_sp "young women [partner]"

replace youngfemale_sp=1 if gender_sp==1 & young_sp==1
replace youngfemale_sp=0 if gender_sp==0 | young_sp==0

#delimit;
label define youngfemale_sp 
1 "young female [partner]"
0 "else", modify;
la val youngfemale_sp youngfemale_sp
;
#delimit cr

*Partner: young men
gen youngmale_sp =.
la var youngmale_sp "young_sp men [partner]"

replace youngmale_sp =1 if gender_sp==0 & young_sp==1
replace youngmale_sp =0 if gender_sp==1 | young_sp==0

#delimit;
label define youngmale_sp 
1 "youngmale [partner]"
0 "else", modify;
la val youngmale_sp youngmale_sp
;
#delimit cr

tab young_sp youngmale_sp

*Partner: Old women
gen oldfemale_sp=.
la var oldfemale_sp "old women [partner]"

replace oldfemale_sp =1 if gender_sp==1 & young_sp==0
replace oldfemale_sp =0 if gender_sp==0 | young_sp==1

#delimit;
label define oldfemale_sp
1 "old female [partner]"
0 "else", modify;
la val oldfemale_sp oldfemale_sp
;
#delimit cr

*Partner: Old Men
gen oldmale_sp=.
la var oldmale_sp "old men [partner]"

replace oldmale_sp=1 if gender_sp==0 & young_sp==0
replace oldmale_sp=0 if gender_sp==1 | young_sp==1

#delimit;
label define oldmale_sp
1 "old male_sp"
0 "else", modify;
la val oldmale_sp oldmale_sp
;
#delimit cr

*LSF_youngfemale_sp
gen LSF_youngfemale_sp=.
la var LSF_youngfemale_sp "LSF young_sp women [partner]"

replace LSF_youngfemale_sp=1 if youngfemale_sp==1 & groups_sp==5 
replace LSF_youngfemale_sp=0 if youngfemale_sp==1 & groups_sp!=5
replace LSF_youngfemale_sp=0 if youngfemale_sp==0

la de LSF_youngfemale_sp 1 "LSF young female [partner]" 0 "else", modify
la val LSF_youngfemale_sp LSF_youngfemale_sp 


*LSF young_sp male_sp
gen LSF_youngmale_sp=.
la var LSF_youngmale_sp "LSF young_sp men [partner]"

replace LSF_youngmale_sp=1 if youngmale_sp==1 & groups_sp==5 
replace LSF_youngmale_sp=0 if youngmale_sp==1 & groups_sp!=5
replace LSF_youngmale_sp=0 if youngmale_sp==0

la de LSF_youngmale_sp 1 "LSF youngmale [partner]" 0 "else", modify
la val LSF_youngmale_sp LSF_youngmale_sp

tab LSF_youngmale_sp LSF_youngfemale_sp, m


*LSF_oldfemale_sp
gen LSF_oldfemale_sp=.
la var LSF_oldfemale_sp "LSF old Women [partner]"

replace LSF_oldfemale_sp=1 if oldfemale_sp==1 & groups_sp==5
replace LSF_oldfemale_sp=0 if oldfemale_sp==0
replace LSF_oldfemale_sp=0 if oldfemale_sp==1 & groups_sp!=5

la de LSF_oldfemale_sp 1 "LSF old female [partner]" 0 "else"
la val LSF_oldfemale_sp LSF_oldfemale_sp

*LSF_oldmale_sp
gen LSF_oldmale_sp=.
la var LSF_oldmale_sp "LSF Old Men [partner]"
replace LSF_oldmale_sp=1 if oldmale_sp==1 & groups_sp==5
replace LSF_oldmale_sp=0 if oldmale_sp==1 & groups_sp!=5
replace LSF_oldmale_sp=0 if oldmale_sp==0

la de LSF_oldmale_sp 1 "LSF old male  [partner]" 0 "else"
la val LSF_oldmale_sp LSF_oldmale_sp

tab LSF_oldmale_sp LSF_oldfemale_sp
tab LSF_youngmale_sp LSF_oldmale_sp
 

*SCP_youngfemale_sp
gen SCP_youngfemale_sp=.
la var SCP_youngfemale_sp "SCP young women [partner]"

replace SCP_youngfemale_sp=1 if youngfemale_sp==1 & groups_sp==4 
replace SCP_youngfemale_sp=0 if youngfemale_sp==1 & groups_sp!=4
replace SCP_youngfemale_sp=0 if youngfemale_sp==0

la de SCP_youngfemale_sp 1 "SCP young female [partner]" 0 "else", modify
la val SCP_youngfemale_sp SCP_youngfemale_sp

*SCP young male_sp
gen SCP_youngmale_sp=.
la var SCP_youngmale_sp "SCP young men [partner]"

replace SCP_youngmale_sp=1 if youngmale_sp==1 & groups_sp==4
replace SCP_youngmale_sp=0 if youngmale_sp==1 & groups_sp!=4
replace SCP_youngmale_sp=0 if youngmale_sp==0

la de SCP_youngmale_sp 1 "SCP young male [partner]" 0 "else", modify
la val SCP_youngmale_sp SCP_youngmale_sp 

tab SCP_youngmale_sp SCP_youngfemale_sp


*SCP_oldfemale_sp
gen SCP_oldfemale_sp=.
la var SCP_oldfemale_sp "SCP old Women [partner]"

replace SCP_oldfemale_sp=1 if oldfemale_sp==1 & groups_sp==4
replace SCP_oldfemale_sp=0 if oldfemale_sp==0
replace SCP_oldfemale_sp=0 if oldfemale_sp==1 & groups_sp!=4

la de SCP_oldfemale_sp 1 "SCP old female [partner]" 0 "else"
la val SCP_oldfemale_sp SCP_oldfemale_sp

*SCP_oldmale_sp
gen SCP_oldmale_sp=.
la var SCP_oldmale_sp "SCP Old Men [partner]"
replace SCP_oldmale_sp=1 if oldmale_sp==1 & groups_sp==4
replace SCP_oldmale_sp=0 if oldmale_sp==1 & groups_sp!=4
replace SCP_oldmale_sp=0 if oldmale_sp==0

la de SCP_oldmale_sp 1 "SCP old male [partner]" 0 "else"
la val SCP_oldmale_sp SCP_oldmale_sp

tab SCP_oldmale_sp SCP_oldfemale_sp


*BC_youngfemale_sp
gen BC_youngfemale_sp=.
la var BC_youngfemale_sp "BC young women [partner]"

replace BC_youngfemale_sp=1 if youngfemale_sp==1 & groups_sp==3 
replace BC_youngfemale_sp=0 if youngfemale_sp==1 & groups_sp!=3
replace BC_youngfemale_sp=0 if youngfemale_sp==0

la de BC_youngfemale_sp 1 "BC young_sp female_sp" 0 "else", modify
la val BC_youngfemale_sp BC_youngfemale_sp

*BC young_sp male_sp
gen BC_youngmale_sp=.
la var BC_youngmale_sp "BC young_sp men [partner]"

replace BC_youngmale_sp=1 if youngmale_sp==1 & groups_sp==3
replace BC_youngmale_sp=0 if youngmale_sp==1 & groups_sp!=3
replace BC_youngmale_sp=0 if youngmale_sp==0

la de BC_youngmale_sp 1 "BC young male [partner]" 0 "else", modify
la val BC_youngmale_sp BC_youngmale_sp

*BC_oldfemale_sp
gen BC_oldfemale_sp=.
la var BC_oldfemale_sp "BC old Women [partner]"

replace BC_oldfemale_sp=1 if oldfemale_sp==1 & groups_sp==3
replace BC_oldfemale_sp=0 if oldfemale_sp==1 & groups_sp!=3
replace BC_oldfemale_sp=0 if oldfemale_sp==0

la de BC_oldfemale_sp 1 "BC old female [partner]" 0 "else"
la val BC_oldfemale_sp BC_oldfemale_sp

*BC_oldmale_sp
gen BC_oldmale_sp=.
la var BC_oldmale_sp "BC Old Men [partner]"
replace BC_oldmale_sp=1 if oldmale_sp==1 & groups_sp==3
replace BC_oldmale_sp=0 if oldmale_sp==1 & groups_sp!=3
replace BC_oldmale_sp=0 if oldmale_sp==0

la de BC_oldmale_sp 1 "BC old male [partner]" 0 "else"
la val BC_oldmale_sp BC_oldmale_sp

tab BC_oldmale_sp BC_oldfemale_sp
tab BC_youngmale_sp BC_youngfemale_sp


*MSF_youngfemale_sp
gen MSF_youngfemale_sp=.
la var MSF_youngfemale_sp "MSF young_sp women [partner]"

replace MSF_youngfemale_sp=1 if youngfemale_sp==1 & groups_sp==2
replace MSF_youngfemale_sp=0 if youngfemale_sp==1 & groups_sp!=2
replace MSF_youngfemale_sp=0 if youngfemale_sp==0

la de MSF_youngfemale_sp 1 "MSF young female [partner]" 0 "else", modify
la val MSF_youngfemale_sp MSF_youngfemale_sp


*MSF young_sp male_sp
gen MSF_youngmale_sp=.
la var MSF_youngmale_sp "MSF young men [partner]"

replace MSF_youngmale_sp=1 if youngmale_sp==1 & groups_sp==2
replace MSF_youngmale_sp=0 if youngmale_sp==1 & groups_sp!=2
replace MSF_youngmale_sp=0 if youngmale_sp==0

la de MSF_youngmale_sp 1 "MSF youngmale [partner]" 0 "else", modify
la val MSF_youngmale_sp MSF_youngmale_sp


*MSF_oldfemale_sp
gen MSF_oldfemale_sp=.
la var MSF_oldfemale_sp "MSF old Women [partner]"

replace MSF_oldfemale_sp=1 if oldfemale_sp==1 & groups_sp==2
replace MSF_oldfemale_sp=0 if oldfemale_sp==1 & groups_sp!=2
replace MSF_oldfemale_sp=0 if oldfemale_sp==0

la de MSF_oldfemale_sp 1 "MSF old female [partner]" 0 "else"
la val MSF_oldfemale_sp MSF_oldfemale_sp

*MSF_oldmale_sp
gen MSF_oldmale_sp=.
la var MSF_oldmale_sp "BC Old Men [partner]"
replace MSF_oldmale_sp=1 if oldmale_sp==1 & groups_sp==2
replace MSF_oldmale_sp=0 if oldmale_sp==1 & groups_sp!=2
replace MSF_oldmale_sp=0 if oldmale_sp==0

la de MSF_oldmale_sp 1 "MSF old male [partner]" 0 "else"
la val MSF_oldmale_sp MSF_oldmale_sp

tab MSF_oldmale_sp MSF_oldfemale_sp
tab MSF_youngmale_sp MSF_youngfemale_sp


/*Partner: CA_youngfemale*/
gen CA_youngfemale_sp=.
la var CA_youngfemale_sp "CA young women [partner]"

replace CA_youngfemale_sp=1 if youngfemale_sp==1 & groups_sp==1 
replace CA_youngfemale_sp=0 if youngfemale_sp==1 & groups_sp!=1
replace CA_youngfemale_sp=0 if youngfemale_sp==0

la de CA_youngfemale_sp 1 "CA young female [partner]" 0 "else", modify
la val CA_youngfemale_sp CA_youngfemale_sp 

/*Partner: CA young male*/
gen CA_youngmale_sp=.
la var CA_youngmale_sp "CA young men [partner]"

replace CA_youngmale_sp=1 if youngmale_sp==1 & groups_sp==1 
replace CA_youngmale_sp=0 if youngmale_sp==1 & groups_sp!=1
replace CA_youngmale_sp=0 if youngmale_sp==0

la de CA_youngmale_sp 1 "CA young male [partner]" 0 "else", modify
la val CA_youngmale_sp CA_youngmale_sp

tab CA_youngmale_sp CA_youngfemale_sp


/*Partner: CA_oldfemale_sp*/
gen CA_oldfemale_sp=.
la var CA_oldfemale_sp "CA old Women [partner]"

replace CA_oldfemale_sp=1 if oldfemale_sp==1 & groups_sp==1
replace CA_oldfemale_sp=0 if oldfemale_sp==0
replace CA_oldfemale_sp=0 if oldfemale_sp==1 & groups_sp!=1

la de CA_oldfemale_sp 1 "CA old female [partner]" 0 "else"
la val CA_oldfemale_sp CA_oldfemale_sp

/*Partner: CA_oldmale_sp*/
gen CA_oldmale_sp=.
la var CA_oldmale_sp "CA Old Men [partner]"
replace CA_oldmale_sp=1 if oldmale_sp==1 & groups_sp==1
replace CA_oldmale_sp=0 if oldmale_sp==1 & groups_sp!=1
replace CA_oldmale_sp=0 if oldmale_sp==0

la de CA_oldmale_sp 1 "CA old male [partner]" 0 "else"
la val CA_oldmale_sp CA_oldmale_sp

tab CA_oldmale_sp CA_oldfemale_sp
tab CA_youngmale_sp CA_oldmale_sp

gen exlgroups_sp=.
la var exlgroups_sp "socio-economic groups (excl) [partner]"

replace exlgroups_sp =1 if LSF_youngfemale_sp ==1
replace exlgroups_sp =2 if LSF_youngmale_sp ==1
replace exlgroups_sp =3 if LSF_oldfemale_sp ==1
replace exlgroups_sp =4 if LSF_oldmale_sp ==1
replace exlgroups_sp =5 if SCP_youngfemale_sp ==1
replace exlgroups_sp =6 if SCP_youngmale_sp ==1
replace exlgroups_sp =7 if SCP_oldfemale_sp ==1
replace exlgroups_sp =8 if SCP_oldmale_sp ==1
replace exlgroups_sp =9 if BC_youngfemale_sp ==1
replace exlgroups_sp =10 if BC_youngmale_sp ==1
replace exlgroups_sp =11 if BC_oldfemale_sp ==1
replace exlgroups_sp =12 if BC_oldmale_sp ==1
replace exlgroups_sp =13 if MSF_youngfemale_sp ==1
replace exlgroups_sp =14 if MSF_youngmale_sp ==1
replace exlgroups_sp =15 if MSF_oldfemale_sp ==1
replace exlgroups_sp =16 if MSF_oldmale_sp ==1
replace exlgroups_sp =17 if CA_youngfemale_sp ==1
replace exlgroups_sp =18 if CA_youngmale_sp ==1
replace exlgroups_sp =19 if CA_oldfemale_sp ==1
replace exlgroups_sp =20 if CA_oldmale_sp ==1

#delimit
la de exlgroups_sp
1 "LSF_young female [partner]"
2 "LSF_young male [partner]"
3 "LSF_oldfemale [partner]"
4 "LSF_oldmale [partner]"

5 "SCP_young female [partner]"
6 "SCP_young male [partner]"
7 "SCP_oldfemale [partner]"
8 "SCP_oldmale [partner]"

9 "BC_young female [partner]"
10 "BC_young male [partner]"
11 "BC_oldfemale [partner]"
12 "BC_oldmale [partner]"

13 "MSF_young female [partner]"
14 "MSF_young male [partner]"
15 "MSF_oldfemale [partner]"
16 "MSF_oldmale [partner]"

17 "CA_young female [partner]"
18 "CA_young male [partner]"
19 "CA_oldfemale [partner]"
20 "CA_oldmale [partner]", modify;
la val exlgroups_sp exlgroups_sp
;
#delimit cr


* Now merge outsiderness values calculated in EU-SILC based on occupational groups

replace cntry="UK" if cntry=="GB"

merge m:m cntry exlgroups using "outsiderness_tomerge.dta"

* drop using only cases (countries not covered by ESS)
drop if _merge==2
drop _merge

merge m:m cntry exlgroups_sp using "outsiderness_sp_tomerge.dta"
* 16'975 obs not matched due to missing partner
* drop using only cases (countries not covered by ESS)
drop if _merge==2
drop _merge



* 3.3 Other covariates
********************************************

* education4 in degrees (ordinal)

gen education4=edulvl
recode education4 (0=1) (1=1) (2=2) (3=3) (4=4) (5=5) (6=5) (7=.) (8=.) (9=.)

label var education4 "education (degrees)"

#delimit;
label define education4
1 "primary or less"
2 "lower secondary"
3 "upper secondary"
4 "post-secondary"
5 "tertiary", modify;
label values education4 education4;
#delimit cr


*  couple household

recode partner (1=1) (2=0), gen(couple3)

la var couple3 "Living in a couple household"
label value couple3 couple3
label de couple3 1 "lives with partner" 0 "does not live with partner"

* union member

gen union = .
replace union = 1 if mbtru==1
replace union = 0 if mbtru==2
replace union = 0 if mbtru==3

label value union Union
label define Union 0 "not member" 1 "member"
label variable union "Union membership"

* church attendance

gen church = .
replace church = 1 if rlgatnd==7
replace church = 2 if rlgatnd==6
replace church = 3 if rlgatnd==5
replace church = 4 if rlgatnd==4
replace church = 5 if rlgatnd==3
replace church = 6 if rlgatnd==2
replace church = 7 if rlgatnd==1

label value church Church
label define Church 1 "never" 2 "less often" 3 "only on special holy days" 4 "once a month" ///
 5 "once a week" 6 "more than once a week" 7 "every day"
label variable church "Church attendance"

* age

gen age = .
replace age = agea
drop if age>=85


* income

gen income=hinctnta
replace income=. if hinctnta==77
replace income=. if hinctnta==88
replace income=. if hinctnta==99
tab income hinctnta

* public employment

gen public = (tporgwk==1 | tporgwk==2)
replace public = . if tporgwk == .

* cultural liberalism

recode freehms (1=5 "strongly agree") (2=4 "agree") (3=3 "neutral") (4=2 "disagree") (5=1 "stronlgy disagree"), ge(gayrights)
la var gayrights "gays and lesbians free to live life as they whish"


* immigrant status

gen citizen = (ctzcntr==1)
replace citizen = . if ctzcntr == . 

* children

gen child1 = (chldhm==1)
replace child1 = . if chldhm == .

* employment contract

gen tempbroad = .
replace tempbroad = 1 if wrkctra == 3
replace tempbroad = 1 if wrkctra == 2
replace tempbroad = 0 if wrkctra == 1

* weight
* combine population and design weight

gen weight = pweight*dweight

* numeric country dummies

tabulate cntry, gen(c)
label var c1 "Belgium"
label var c2 "Switzerland"
label var c3 "Germany"
label var c4 "Denmark"
label var c5 "Spain"
label var c6 "Finland"
label var c7 "France"
label var c8 "UK"
label var c9 "Greece"
label var c10 "Netherlands"
label var c11 "Norway"
label var c12 "Portugal"
label var c13 "Sweden"


* 3.4 Data Cleaning
********************************************

* exclude same-sex couples because they yield outsiderness values above/below the gender-specific maxima
* this introduces bias when studying intra-household safety nets

sum outsiderness2c if gender==0
* scatter outsiderness2c outsiderness2c_sp if gender==1, xline(0.66)
* scatter outsiderness2c outsiderness2c_sp if gender==1 & outsiderness2c_sp>1, mlabel(idno) 

drop if idno==133321
drop if idno==44200
drop if idno==40191
drop if idno==1115&c5==1
drop if idno==61705

sum outsiderness2c if gender==1
* scatter outsiderness2c outsiderness2c_sp if gender==0, xline(-1.394)
* scatter outsiderness2c outsiderness2c_sp if gender==0 & outsiderness2c_sp<-1.3, mlabel(idno) 

drop if idno==2009&c5==1

********************************************
* 4. ANALYSIS
********************************************

set scheme sj

* Table 1: Determinants of social policy preferences. Coefficients from ordered logit regressions.

qui ologit redist3 outsiderness2c education4 income gender age public gayrights union child1 citizen tempbroad church c1-c13 [pweight=weight] if outsiderness2c_sp!=., cluster(cntry)
fitstat
estadd fitstat
estimates store m1redist

qui ologit jobcreation outsiderness2c education4 income gender age public gayrights union child1 citizen tempbroad church c1-c13 [pweight=weight] if outsiderness2c_sp!=., cluster(cntry)
fitstat
estadd fitstat
estimates store m1job

qui ologit redist3 outsiderness2c outsiderness2c_sp education4 income gender age public gayrights union child1 citizen tempbroad church c1-c13 [pweight=weight] if outsiderness2c_sp!=., cluster(cntry)
fitstat
estadd fitstat
estimates store m2redist

qui ologit jobcreation outsiderness2c outsiderness2c_sp education4 income gender age public gayrights union child1 citizen tempbroad church c1-c13 [pweight=weight] if outsiderness2c_sp!=., cluster(cntry)
fitstat
estadd fitstat
estimates store m2job

qui ologit redist3 c.outsiderness2c##c.outsiderness2c_sp education4 income gender age public gayrights union child1 citizen tempbroad church c1-c13 [pweight=weight] if outsiderness2c_sp!=., cluster(cntry)
fitstat
estadd fitstat
estimates store m3redist

qui ologit jobcreation c.outsiderness2c##c.outsiderness2c_sp education4 income gender age public gayrights union child1 citizen tempbroad church c1-c13 [pweight=weight] if outsiderness2c_sp!=., cluster(cntry)
fitstat
estadd fitstat
estimates store m3job

estout m1redist m1job m2redist m2job m3redist m3job, label varwidth(25) varlabels(_cons "Constant" redist3 "Redistribution" outsiderness2c ///
"Outsiderness" education4 "Education" income "Income" gender "Female" age "Age" union "Union membership" church "Church attendance" ///
couple3 "Living in a couple household" public "Public Employment" gayrights "Cultural Liberalism" jobcreation ///
"Jobcreation" insurance1 "Pension" insurance3 "Unemp Benefit")cells(b(star fmt(%9.3f)) se(par fmt(%9.2f))) ///
style(fixed) starlevels(* 0.10 ** 0.05 *** 0.01) stats(r2_mz bic0 N ll,fmt(3 1 0 1) labels("Pseudo R2" "BIC" "N" "Log likelihood"))


* Figure 1: Predicted Probabilities of supporting or opposing ...

* Create Dummies (support vs. oppose)

gen redist45 = (redist3==4 | redist3==5)
replace redist45= . if redist3==.
tab redist3 redist45, m

gen redist12 = (redist3==1 | redist3==2)
replace redist12= . if redist3==.
tab redist3 redist12, m


gen job710 = (jobc>6)
replace job710=. if jobcreation==.
tab jobcreation job710, m

gen job13 = (jobc<4)
replace job13=. if jobcreation==.
tab jobcreation job13, m

* Create x-axis baseline

gen baseline = .
replace baseline = -2 in 1
replace baseline = -1 in 2
replace baseline = 0 in 3
replace baseline = 1 in 4
replace baseline = 2 in 5


qui ologit redist45 c.outsiderness2c##c.outsiderness2c_sp education4 income gender age  gayrights public union child1 citizen tempbroad church c1-c12 [pweight=weight], cluster(cntry)
margins, at(outsiderness2c=(-2(1)2) education4=3 gender=1 union=0 church=3 gayrights=4 public=0 child1=0 citizen=1 tempbroad=0) predict(outcome(1))

matrix supportredist = r(b)'
matrix list supportredist
svmat supportredist, names(supportredist)

qui ologit redist12 c.outsiderness2c##c.outsiderness2c_sp education4 income gender gayrights age public union child1 citizen tempbroad church c1-c12 [pweight=weight], cluster(cntry)
margins, at(outsiderness2c=(-2(1)2) education4=3 gender=1 union=0 church=3 gayrights=4 public=0 child1=0 citizen=1 tempbroad=0) predict(outcome(1))

matrix opposeredist = r(b)'
matrix list opposeredist
svmat opposeredist, names(opposeredist)

la var supportred "Support Redistribution (y=4,5)"
la var opposered "Oppose Redistribution (y=1,2)"


qui ologit job710 c.outsiderness2c##c.outsiderness2c_sp education4 income gender gayrights age public union child1 citizen tempbroad church c1-c12 [pweight=weight], cluster(cntry)
margins, at(outsiderness2c=(-2(1)2) education4=3 gender=1 union=0 church=3 gayrights=4 public=0 child1=0 citizen=1 tempbroad=0) predict(outcome(1))

matrix supportjob = r(b)'
matrix list supportjob
svmat supportjob, names(supportjob)

qui ologit job13 c.outsiderness2c##c.outsiderness2c_sp education4 income gender age public  gayrights union child1 citizen tempbroad church c1-c12 [pweight=weight], cluster(cntry)
margins, at(outsiderness2c=(-2(1)2) education4=3 gender=1 union=0 church=3 gayrights=4 public=0 child1=0 citizen=1 tempbroad=0) predict(outcome(1))

matrix opposejob = r(b)'
matrix list opposejob
svmat opposejob, names(opposejob)

la var supportjob "Support Jobcreation (y=7-10)"
la var opposejob "Oppose Jobcreation (y=0-3)"


graph twoway 	connected supportredist baseline, msymbol(o) mcolor(gs12) title("Redistribution") xtitle("Labor Market Vulnerability (Outsiderness)") ytitle("Predicted Probability") ylabel(0(0.2)0.8) yaxis(1) legend(row(2)) /// 
    ||			connected opposeredist baseline, msymbol(o) mcolor(gs8)  title("Redistribution") xtitle("Labor Market Vulnerability (Outsiderness)") ytitle("Predicted Probability") ylabel(0(0.2)0.8) yaxis(1) legend(row(2)) name(redist, replace)

 
graph twoway 	connected supportjob baseline, msymbol(o) mcolor(gs12) title("Jobcreation") xtitle("Labor Market Vulnerability (Outsiderness)") ytitle("Predicted Probability") ylabel(0(0.2)0.8) yaxis(1) legend(row(2)) /// 
    ||			connected opposejob baseline, msymbol(o) mcolor(gs8)  title("Jobcreation") xtitle("Labor Market Vulnerability (Outsiderness)") ytitle("Predicted Probability") ylabel(0(0.2)0.8) yaxis(1) legend(row(2)) name(job, replace)



* Figure 2: Marginal Effect of labor market vulnerability

qui ologit redist3 c.outsiderness2c##c.outsiderness2c_sp education4 income gender age public gayrights union child1 citizen tempbroad church c1-c13 [pweight=weight] if outsiderness2c_sp!=., cluster(cntry)
margins, dydx(outsiderness2c) at(outsiderness2c_sp = (-2(0.5)2)) predict(xb)
marginsplot, yline(0) ylabel(-0.5(0.25)0.75) recast(line) recastci(rline) ciopts(lpattern(dash)) title("Redistribution") xtitle("Partner's labor market vulnerability") ytitle("Marginal effect of respondent's labor market vulnerability", size(small))

qui ologit jobcreation c.outsiderness2c##c.outsiderness2c_sp education4 income gender age public gayrights union child1 citizen tempbroad church c1-c13 [pweight=weight] if outsiderness2c_sp!=., cluster(cntry)
margins, dydx(outsiderness2c) at(outsiderness2c_sp = (-2(0.5)2)) predict(xb)
marginsplot, yline(0) ylabel(-0.5(0.25)0.75) recast(line) recastci(rline) ciopts(lpattern(dash)) title("Jobcreation") xtitle("Partner's labor market vulnerability") ytitle("Marginal effect of respondent's labor market vulnerability", size(small))

* Figure 3: Predicted probability of supporting redistribution and activation for men and women...

sum outsiderness2c if gender==1
sum outsiderness2c if gender==0
gen outout = outsiderness2c*outsiderness2c_sp

ologit redist45 c.outsiderness2c c.outsiderness2c_sp outout education4 income age public gayrights union child1 citizen tempbroad church c1-c12 [pweight=weight] if gender==1
prgen outsiderness2c_sp, gen(xfemale)

ologit redist45 c.outsiderness2c c.outsiderness2c_sp outout education4 income age public gayrights union child1 citizen tempbroad church c1-c12 [pweight=weight] if gender==0
prgen outsiderness2c_sp, gen(xmale)


mean outsiderness2c if gender==1

qui ologit redist45 c.outsiderness2c##c.outsiderness2c_sp education4 income gender age public gayrights union child1 citizen tempbroad church c1-c13 [pweight=weight] if gender==1, cluster(cntry)
margins, at(outsiderness2c_sp=(-1.682863	-1.425472	-1.16808	-0.9106889	-0.6532975	-0.3959062	-0.1385148	0.1188765	0.3762679	0.6336592	0.8910506) outsiderness2c=(.3441884 )) atmeans predict(outcome(1))

matrix all_femaleredist = r(b)'
matrix list all_femaleredist
svmat all_femaleredist, names(all_femaleredist)

matrix v=r(V)
matrix list v
matrix seall_femaleredist=vecdiag(cholesky(diag(vecdiag(v))))'
svmat seall_femaleredist, names(seall_femaleredist)
generate ulall_femaleredist = all_femaleredist + 1.96*seall_femaleredist
generate llall_femaleredist = all_femaleredist - 1.96*seall_femaleredist

qui ologit job710 c.outsiderness2c##c.outsiderness2c_sp education4 income gender age public gayrights union child1 citizen tempbroad church c1-c13 [pweight=weight] if gender==1, cluster(cntry)
margins, at(outsiderness2c_sp=(-1.682863	-1.425472	-1.16808	-0.9106889	-0.6532975	-0.3959062	-0.1385148	0.1188765	0.3762679	0.6336592	0.8910506) outsiderness2c=(.3441884 )) atmeans predict(outcome(1))


matrix all_femalejob = r(b)'
matrix list all_femalejob
svmat all_femalejob, names(all_femalejob)

matrix v=r(V)
matrix list v
matrix seall_femalejob=vecdiag(cholesky(diag(vecdiag(v))))'
svmat seall_femalejob, names(seall_femalejob)
generate ulall_femalejob = all_femalejob + 1.96*seall_femalejob
generate llall_femalejob = all_femalejob - 1.96*seall_femalejob

mean outsiderness2c if gender==0

qui ologit redist45 c.outsiderness2c##c.outsiderness2c_sp education4 income gender age public gayrights union child1 citizen tempbroad church c1-c13 [pweight=weight] if gender==0, cluster(cntry)
margins, at(outsiderness2c_sp=(-1.394046	-1.024561	-0.655077	-0.2855925	0.083892	0.4533765	0.822861	1.192345	1.56183	1.931314	2.300799) outsiderness2c=(-.4838386)) atmeans predict(outcome(1))

matrix all_maleredist = r(b)'
matrix list all_maleredist
svmat all_maleredist, names(all_maleredist)

matrix v=r(V)
matrix list v
matrix seall_maleredist=vecdiag(cholesky(diag(vecdiag(v))))'
svmat seall_maleredist, names(seall_maleredist)
generate ulall_maleredist = all_maleredist + 1.96*seall_maleredist
generate llall_maleredist = all_maleredist - 1.96*seall_maleredist


qui ologit job710 c.outsiderness2c##c.outsiderness2c_sp education4 income gender age public gayrights union child1 citizen tempbroad church c1-c13 [pweight=weight] if gender==0, cluster(cntry)
margins, at(outsiderness2c_sp=(-1.394046	-1.024561	-0.655077	-0.2855925	0.083892	0.4533765	0.822861	1.192345	1.56183	1.931314	2.300799) outsiderness2c=(-.4838386)) atmeans predict(outcome(1))

matrix all_malejob = r(b)'
matrix list all_malejob
svmat all_malejob, names(all_malejob)

matrix v=r(V)
matrix list v
matrix seall_malejob=vecdiag(cholesky(diag(vecdiag(v))))'
svmat seall_malejob, names(seall_malejob)
generate ulall_malejob = all_malejob + 1.96*seall_malejob
generate llall_malejob = all_malejob - 1.96*seall_malejob

graph twoway connected all_femaleredist xfemax, msymbol(o) mcolor(gs8) xlabel(-1.7(0.5)2.3) yline(0)  yaxis(1) title("Redistribution", size(medsmall)) subtitle("All countries", size(medsmall)) xtitle("Partner's labor market vulnerability") ytitle("Pred. Probability of Support") /// 
     ||      connected llall_femaleredist xfemax, clpattern(dash) clwidth(vthin) clcolor(black) msymbol(none) yaxis(1)  ///
     ||      connected ulall_femaleredist xfemax, clpattern(dash) clwidth(vthin) clcolor(black) msymbol(none) yaxis(1)  ///
	 ||      connected all_maleredist xmalex, msymbol(d) mcolor(gs14) xlabel(-1.7(0.5)2.3) yline(0)  yaxis(1) title("Redistribution", size(medsmall)) subtitle("All countries", size(medsmall)) xtitle("Partner's labor market vulnerability") ytitle("Pred. Probability of Support") /// 
     ||      connected llall_maleredist xmalex, clpattern(dash) clwidth(vthin) clcolor(black) msymbol(none) yaxis(1)  ///
     ||      connected ulall_maleredist xmalex, clpattern(dash) clwidth(vthin) clcolor(black) msymbol(none) yaxis(1) legend(off)



graph twoway connected all_femalejob xfemax, msymbol(o) mcolor(gs8) xlabel(-1.7(0.5)2.3)   ylabel(0.3(0.1)0.7) yaxis(1) title("Jobcreation", size(medsmall)) subtitle("All countries", size(medsmall)) xtitle("Partner's labor market vulnerability") ytitle("Pred. Probability of Support") /// 
     ||      connected llall_femalejob xfemax, clpattern(dash) clwidth(vthin) clcolor(black) msymbol(none) yaxis(1)  ///
     ||      connected ulall_femalejob xfemax, clpattern(dash) clwidth(vthin) clcolor(black) msymbol(none) yaxis(1)  ///
	 ||      connected all_malejob xmalex, msymbol(d) mcolor(gs14) xlabel(-1.7(0.5)2.3)  ylabel(0.3(0.1)0.7) yaxis(1) title("Jobcreation", size(medsmall)) subtitle("All countries", size(medsmall)) xtitle("Partner's labor market vulnerability") ytitle("Pred. Probability of Support") /// 
     ||      connected llall_malejob xmalex, clpattern(dash) clwidth(vthin) clcolor(black) msymbol(none) yaxis(1)  ///
     ||      connected ulall_malejob xmalex, clpattern(dash) clwidth(vthin) clcolor(black) msymbol(none) yaxis(1) legend(off)

* check with marginsplot (without overlay, not shown in paper)
* (margins and marginsplot has not been available yet for earlier versions of the paper)
qui ologit redist45 c.outsiderness2c##c.outsiderness2c_sp education4 income gender age public gayrights union child1 citizen tempbroad church c1-c13 [pweight=weight] if gender==1, cluster(cntry)
margins, at(outsiderness2c_sp=(-1.682863	-1.425472	-1.16808	-0.9106889	-0.6532975	-0.3959062	-0.1385148	0.1188765	0.3762679	0.6336592	0.8910506) outsiderness2c=(.3441884 )) atmeans predict(outcome(1))
marginsplot

qui ologit redist45 c.outsiderness2c##c.outsiderness2c_sp education4 income gender age public gayrights union child1 citizen tempbroad church c1-c13 [pweight=weight] if gender==0, cluster(cntry)
margins, at(outsiderness2c_sp=(-1.394046	-1.024561	-0.655077	-0.2855925	0.083892	0.4533765	0.822861	1.192345	1.56183	1.931314	2.300799) outsiderness2c=(-.4838386)) atmeans predict(outcome(1))
marginsplot


* Figure 4: Share of female outsiders with safety net insider partner on total respondents

bysort cntry: egen meanmale = mean(outsiderness2c) if gender==0
mean outsiderness2c if cntry=="BE"&gender==0
bysort cntry: egen meanmale2 = mean(meanmale)
drop meanmale
rename meanmale2 meanmale

gen onefemale = 1 if gender==1&outsiderness2c_sp!=.

bysort cntry: egen femaletotal = total(onefemale)

gen safetynet = (outsiderness2c_sp<meanmale) if gender==1
replace safetynet = . if outsiderness2c_sp==.

bysort cntry: egen safetynettotal = total(safetynet)

gen outsidersafetynet = (outsiderness2c_sp<meanmale) if gender==1&outsiderness2c>0
replace outsidersafetynet = . if outsiderness2c_sp==.
bysort cntry: egen outsidersafetynettotal = total(outsidersafetynet)

gen one = 1
replace one = . if outsiderness2c==.
bysort cntry: egen allrespondents = total(one)
gen sharesafetyallrespondents = outsidersafetynettotal/allrespondents

graph bar sharesafetyallrespon, over(cntry, sort(1)) ytitle("Share of Female Outsider with 'Household Safety Net'" "(% of all Respondents)", size(medsmall) margin(medsmall)) intensity(*1.2)


********************************************
* 5. APPENDIX
********************************************

* for identical design install and use scheme lean1:
* set scheme lean1

* Figure A2a: Boxplot

graph box outsiderness2c, over(cntry) ytitle("Outsiderness")

* Table A2b: Distribution of labor market vulnerability per country

table exlgroups cntry, content(mean outsiderness2c)
table cntry, content(mean outsiderness2c min outsiderness2c max outsiderness2c)

* Table A3: Determinants of social policy preferences for individuals without partner

qui ologit redist3 outsiderness2c education4 income gender age public gayrights union citizen child1 tempbroad church c1-c13 [pweight=weight] if partner==2, cluster(cntry)
fitstat
estadd fitstat
estimates store m1redist_single_rob

qui ologit jobcreation outsiderness2c education4 income gender age public gayrights union citizen child1 tempbroad church c1-c13 [pweight=weight] if partner==2, cluster(cntry)
fitstat
estadd fitstat
estimates store m1job_single_rob

estout m1redist_single_rob m1job_single_rob, label varwidth(25) varlabels(_cons "Constant" redist3 "Redistribution" outsiderness2c ///
"Outsiderness" education4 "Education" income "Income" gender "Female" age "Age" union "Union membership" church "Church attendance" ///
couple3 "Living in a couple household" public "Public Employment" gayrights "Cultural Liberalism" jobcreation ///
"Jobcreation" insurance1 "Pension" insurance3 "Unemp Benefit")cells(b(star fmt(%9.3f)) se(par fmt(%9.2f))) ///
style(fixed) starlevels(* 0.10 ** 0.05 *** 0.01) stats(r2_mz bic N ll,fmt(3 0 1) labels("Pseudo R2" "BIC" "N" "Log likelihood"))

* Table A4: Gender-specific determinants of social policy prefernces

qui logit redist45 c.outsiderness2c##c.outsiderness2c_sp education4 income  age public gayrights union child1 citizen tempbroad church c1-c13 [pweight=weight] if outsiderness2c_sp!=.&gender==1, cluster(cntry)
fitstat
estadd fitstat
estimates store mA3redistF

qui logit job710 c.outsiderness2c##c.outsiderness2c_sp education4 income age public gayrights union child1 citizen tempbroad church c1-c13 [pweight=weight] if outsiderness2c_sp!=.&gender==1, cluster(cntry)
fitstat
estadd fitstat
estimates store mA3jobF

qui logit redist45 c.outsiderness2c##c.outsiderness2c_sp education4 income age public gayrights union child1 citizen tempbroad church c1-c13 [pweight=weight] if outsiderness2c_sp!=.&gender==0, cluster(cntry)
fitstat
estadd fitstat
estimates store mA3redistM

qui logit job710 c.outsiderness2c##c.outsiderness2c_sp education4 income  age public gayrights union child1 citizen tempbroad church c1-c13 [pweight=weight] if outsiderness2c_sp!=.&gender==0, cluster(cntry)
fitstat
estadd fitstat
estimates store mA3jobM

estout mA3redistM mA3redistF mA3jobM mA3jobF, label varwidth(25) varlabels(_cons "Constant" redist3 "Redistribution" outsiderness2c ///
"Outsiderness" education4 "Education" income "Income" gender "Female" age "Age" union "Union membership" church "Church attendance" ///
couple3 "Living in a couple household" gayrights "Cultural Liberalism" jobcreation ///
"Jobcreation" insurance1 "Pension" insurance3 "Unemp Benefit")cells(b(star fmt(%9.3f)) se(par fmt(%9.2f))) ///
style(fixed) starlevels(* 0.10 ** 0.05 *** 0.01) stats(r2_mz bic0 N ll,fmt(3 1 0 1) labels("Pseudo R2" "BIC" "N" "Log likelihood"))


* Figure A5 and A6: Country-specific predicted probabilities of supporting or opposing redistribution/activation, depending on partner's lmv

bysort gndr cntry: egen p25 = pctile(outsiderness2c_sp), p(25)
bysort gndr cntry: egen p50 = pctile(outsiderness2c_sp), p(50)
bysort gndr cntry: egen p75 = pctile(outsiderness2c_sp), p(75)

set more off

levelsof cntry, local(levels) 
foreach l of local levels {

* FEMALE

* Redist

qui ologit redist45 c.outsiderness2c##c.outsiderness2c_sp education4 income gender age public gayrights union child1 citizen tempbroad church [pweight=weight] if gender==1&cntry=="`l'"
margins, at((min)outsiderness2c_sp (mean)outsiderness2c) at((p25)outsiderness2c_sp (mean)outsiderness2c) at((p50)outsiderness2c_sp (mean)outsiderness2c) at((p75)outsiderness2c_sp (mean)outsiderness2c) at((max)outsiderness2c_sp (mean)outsiderness2c) atmeans predict(outcome(1))


matrix all_femaleredist`l' = r(b)'
matrix list all_femaleredist`l'
svmat all_femaleredist`l', names(all_femaleredist`l')

matrix v=r(V)
matrix list v
matrix seall_femaleredist`l'=vecdiag(cholesky(diag(vecdiag(v))))'
svmat seall_femaleredist`l', names(seall_femaleredist`l')
generate ulall_femaleredist`l' = all_femaleredist`l' + 1.96*seall_femaleredist`l'
generate llall_femaleredist`l' = all_femaleredist`l' - 1.96*seall_femaleredist`l'

* Jobcreation

qui ologit job710 c.outsiderness2c##c.outsiderness2c_sp education4 income gender age public gayrights union child1 citizen tempbroad church [pweight=weight] if gender==1&cntry=="`l'"
margins, at((min)outsiderness2c_sp (mean)outsiderness2c) at((p25)outsiderness2c_sp (mean)outsiderness2c) at((p50)outsiderness2c_sp (mean)outsiderness2c) at((p75)outsiderness2c_sp (mean)outsiderness2c) at((max)outsiderness2c_sp (mean)outsiderness2c) atmeans predict(outcome(1))


matrix all_femalejob`l' = r(b)'
matrix list all_femalejob`l'
svmat all_femalejob`l', names(all_femalejob`l')

matrix v=r(V)
matrix list v
matrix seall_femalejob`l'=vecdiag(cholesky(diag(vecdiag(v))))'
svmat seall_femalejob`l', names(seall_femalejob`l')
generate ulall_femalejob`l' = all_femalejob`l' + 1.96*seall_femalejob`l'
generate llall_femalejob`l' = all_femalejob`l' - 1.96*seall_femalejob`l'


* MALE

* Redistribution

qui ologit redist45 c.outsiderness2c##c.outsiderness2c_sp education4 income gender age public gayrights union church [pweight=weight] if gender==0&cntry=="`l'"
margins, at((min)outsiderness2c_sp (mean)outsiderness2c) at((p25)outsiderness2c_sp (mean)outsiderness2c) at((p50)outsiderness2c_sp (mean)outsiderness2c) at((p75)outsiderness2c_sp (mean)outsiderness2c) at((max)outsiderness2c_sp (mean)outsiderness2c) atmeans predict(outcome(1))

matrix all_maleredist`l' = r(b)'
matrix list all_maleredist`l'
svmat all_maleredist`l', names(all_maleredist`l')

matrix v=r(V)
matrix list v
matrix seall_maleredist`l'=vecdiag(cholesky(diag(vecdiag(v))))'
svmat seall_maleredist`l', names(seall_maleredist`l')
generate ulall_maleredist`l' = all_maleredist`l' + 1.96*seall_maleredist`l'
generate llall_maleredist`l' = all_maleredist`l' - 1.96*seall_maleredist`l'

* Jobcreation

qui ologit job710 c.outsiderness2c##c.outsiderness2c_sp education4 income gender age public gayrights union church [pweight=weight] if gender==0&cntry=="`l'"
margins, at((min)outsiderness2c_sp (mean)outsiderness2c) at((p25)outsiderness2c_sp (mean)outsiderness2c) at((p50)outsiderness2c_sp (mean)outsiderness2c) at((p75)outsiderness2c_sp (mean)outsiderness2c) at((max)outsiderness2c_sp (mean)outsiderness2c) atmeans predict(outcome(1))

matrix all_malejob`l' = r(b)'
matrix list all_malejob`l'
svmat all_malejob`l', names(all_malejob`l')

matrix v=r(V)
matrix list v
matrix seall_malejob`l'=vecdiag(cholesky(diag(vecdiag(v))))'
svmat seall_malejob`l', names(seall_malejob`l')
generate ulall_malejob`l' = all_malejob`l' + 1.96*seall_malejob`l'
generate llall_malejob`l' = all_malejob`l' - 1.96*seall_malejob`l'

egen fminpartner`l' = min(outsiderness2c_sp) if gender==1 & cntry=="`l'"
gen fp25partner`l' = p25 if gender==1&cntry=="`l'"
gen fp50partner`l' = p50 if gender==1&cntry=="`l'"
gen fp75partner`l' = p75 if gender==1&cntry=="`l'"
egen fmaxpartner`l' = max(outsiderness2c_sp) if gender==1 & cntry=="`l'"

egen mminpartner`l' = min(outsiderness2c_sp) if gender==0 & cntry=="`l'"
gen mp25partner`l' = p25 if gender==0&cntry=="`l'"
gen mp50partner`l' = p50 if gender==0&cntry=="`l'"
gen mp75partner`l' = p75 if gender==0&cntry=="`l'"
egen mmaxpartner`l' = max(outsiderness2c_sp) if gender==0 & cntry=="`l'"

egen fminpartner1`l' = mean(fminpartner`l')
egen fp25partner1`l' = mean(fp25partner`l')
egen fp50partner1`l' = mean(fp50partner`l')
egen fp75partner1`l' = mean(fp75partner`l')
egen fmaxpartner1`l' = mean(fmaxpartner`l')

egen mminpartner1`l' = mean(mminpartner`l')
egen mp25partner1`l' = mean(mp25partner`l')
egen mp50partner1`l' = mean(mp50partner`l')
egen mp75partner1`l' = mean(mp75partner`l')
egen mmaxpartner1`l' = mean(mmaxpartner`l')

gen fxaxis`l' = .
replace fxaxis`l' = fminpartner1`l' in 1
replace fxaxis`l' = fp25partner1`l' in 2
replace fxaxis`l' = fp50partner1`l' in 3
replace fxaxis`l' = fp75partner1`l' in 4
replace fxaxis`l' = fmaxpartner1`l' in 5

gen mxaxis`l' = .
replace mxaxis`l' = mminpartner1`l' in 1
replace mxaxis`l' = mp25partner1`l' in 2
replace mxaxis`l' = mp50partner1`l' in 3
replace mxaxis`l' = mp75partner1`l' in 4
replace mxaxis`l' = mmaxpartner1`l' in 5


graph twoway connected all_femaleredist`l' fxaxis`l', msymbol(o) mcolor(gs8) xlabel(-1.7(0.5)2.3) yaxis(1) subtitle("`l'", size(medsmall)) ylabel(0(.2)1) ytitle("") xtitle("") /// 
     ||      connected llall_femaleredist`l' fxaxis`l', clpattern(dash) clwidth(vthin) clcolor(black) msymbol(none) yaxis(1)  ///
     ||      connected ulall_femaleredist`l' fxaxis`l', clpattern(dash) clwidth(vthin) clcolor(black) msymbol(none) yaxis(1)  ///
	 ||      connected all_maleredist`l' mxaxis`l', msymbol(d) mcolor(gs14) xlabel(-1.7(0.5)2.3) yaxis(1) subtitle("`l'", size(medsmall))  ylabel(0(.2)1) ytitle("") xtitle("") /// 
     ||      connected llall_maleredist`l' mxaxis`l', clpattern(dash) clwidth(vthin) clcolor(black) msymbol(none) yaxis(1)  ///
     ||      connected ulall_maleredist`l' mxaxis`l', clpattern(dash) clwidth(vthin) clcolor(black) msymbol(none) yaxis(1) legend(off) saving(F3a_redist`l')


graph twoway connected all_femalejob`l' fxaxis`l', msymbol(o) mcolor(gs8) xlabel(-1.7(0.5)2.3) yaxis(1) subtitle("`l'", size(medsmall)) ylabel(0(.2)1) ytitle("") xtitle("") /// 
     ||      connected llall_femalejob`l' fxaxis`l', clpattern(dash) clwidth(vthin) clcolor(black) msymbol(none) yaxis(1)  ///
     ||      connected ulall_femalejob`l' fxaxis`l', clpattern(dash) clwidth(vthin) clcolor(black) msymbol(none) yaxis(1)  ///
	 ||      connected all_malejob`l' mxaxis`l', msymbol(d) mcolor(gs14) xlabel(-1.7(0.5)2.3) yaxis(1) subtitle("`l'", size(medsmall)) ylabel(0(.2)1) ytitle("") xtitle("") /// 
     ||      connected llall_malejob`l' mxaxis`l', clpattern(dash) clwidth(vthin) clcolor(black) msymbol(none) yaxis(1)  ///
     ||      connected ulall_malejob`l' mxaxis`l', clpattern(dash) clwidth(vthin) clcolor(black) msymbol(none) yaxis(1) legend(off) saving(F3a_job`l')


 }
	 
graph combine F3a_redistBE.gph F3a_redistCH.gph F3a_redistDE.gph F3a_redistDK.gph F3a_redistES.gph F3a_redistFI.gph F3a_redistFR.gph F3a_redistUK.gph F3a_redistGR.gph F3a_redistNL.gph F3a_redistNO.gph F3a_redistPT.gph F3a_redistSE.gph, imargin(0 0 0 0)
graph combine F3a_jobBE.gph F3a_jobCH.gph F3a_jobDE.gph F3a_jobDK.gph F3a_jobES.gph F3a_jobFI.gph F3a_jobFR.gph F3a_jobUK.gph F3a_jobGR.gph F3a_jobNL.gph F3a_jobNO.gph F3a_jobPT.gph F3a_jobSE.gph, imargin(0 0 0 0)



* el fin.
