*Do file containing all analysis except for the figures, which were created in R
*This file creates a dataset which is then used in R to create figures
*The names of the files uploaded are the standard names that the SHP uses

clear
set more off

cd "data location"

*******************************************************************************************************************************************
SECTION 1: CREATING AND MERGING THE FILES
*******************************************************************************************************************************************

*1. Merging in household information for individuals

***********

* Start by adding in parents' self-reported ideology to each cross-sectional dataset 
foreach y in 99 00 01 02 03 04 05 06 07 08 09 11 { 
use idpers idhous`y' idspou`y' age`y' sex`y' edugr`y' gldmaj`y' occupa`y' is1maj`y' wstat`y' educat`y' p`y'w101 p`y'p10 p`y'p13 p`y'p17 p`y'p04 p`y'p01 p`y'n42 p`y'n43 p`y'p02 p`y'p06 p`y'w01, p`y'w02, p`y'w03, p`y'w06, p`y'w237 i`y'ptotg using SHP`y'_P_USER, clear 
merge 1:1 idpers using shp_mp, keepusing (idfath__ idmoth__) 
drop _merge
drop if idhous`y'==.
save temp_parents`y', replace

use temp_parents`y', clear
drop idmoth__ idfath__
rename idpers idmoth__
rename p`y'p10 p`y'p10_m
keep idmoth__ p`y'p10_m
save temp_mother`y', replace

use temp_parents`y', clear
drop idfath__ idmoth__
rename idpers idfath__
rename p`y'p10 p`y'p10_f
keep idfath__ p`y'p10_f
save temp_father`y', replace

use temp_parents`y'
merge m:1 idmoth__ using temp_mother`y'
drop _merge
drop if idhous`y'==.
merge m:1 idfath__ using temp_father`y'
drop _merge
drop if idhous`y'==.
save shp`y'_p_user1, replace
}


********
* Now take each cross sectional survey in turn, and then merge in information at the household level
foreach y in 99 00 01 02 03 04 05 06 07 08 09 11 {   
use shp`y'_p_user1.dta
sort idhous`y'
save shp`y'_p_user1.dta,replace

use shp`y'_h_user.dta
sort idhous`y'
save shp`y'_h_user.dta,replace

quietly merge idhous`y' using shp`y'_p_user1.dta
drop if age`y'<14   /* children's characteristics are included in the sample, but only those aged 14 and over get interviewed fully */
keep idpers* idspou* idhous* age* sex* edugr* canton* occupa* wstat* educat`y' i??eqsg i??eqog is1maj?? i??ptotg p??w101 p??p10 p??p13 p??p17 p??p04 p??p01 p??n42 p??n43 p??p02 p??p06 p??w01, p??w02, p??w03, p??w06, p??w237 p??p10_f p??p10_m /* these are the vars that we want to keep in each wave */ 
save shp`y'_merge.dta,replace
}



**************************************************************************************************************************************

*2. Merging Together waves to create merged dataset in long format

	* Changing the variable names to make it easier to convert into long format
local wave = 1  /* starts a counter to indicate the wave number */
foreach y in 99 00 01 02 03 04 05 06 07 08 09 11 {
use shp`y'_merge, clear
renvars idhous* idspou* age* sex* edugr* educat* canton* occupa* wstat* is1maj*, postsub(`y')  /*getting rid of the two-digit year indicator in the variable names*/
renvars p??w101 p??p10 p??p13 p??p17 p??p04 p??p01 p??n42 p??n43 p??p02 p??p06 p??w01, p??w02, p??w03, p??w06, p??w237 p??p10_f p??p10_m, presub (p`y' p)
renvars i??eqsg i??eqog i??ptotg, presub (i`y' i)
gen wave=`wave' /*creates a variable to index the wave*/
local wave = `wave' + 1 /*this sets the wave number for the next survey*/
save tempp`y', replace
}
	
use tempp11, clear
foreach y in 99 00 01 02 03 04 05 06 07 08 09 {
append using tempp`y'
}


order wave, first
order idpers, first
sort idpers wave
save "shp_panel.dta", replace

***********************************************************************************************************************************

*3. Now bring in parental background

* Social origin dataset
use idpers p__o17 p__o34 p__p46 p__p47 p__o58 p__o59 cspfaj_ using shp_so.dta
sort idpers
save "shp_so1.dta", replace

* Merge social origin data with panel waves
joinby idpers using "shp_panel.dta", unmatched(both)
drop _merge
rename p__p46 pp46
rename p__p47 pp47
rename p__o17 po17
rename p__o34 po34
rename p__o58 po58
rename p__o59 po59
rename cspfaj_ cspfaj
order wave, first
order idpers, first
save "shp_panel.dta", replace


*******************************************************************************************************************************************
SECTION 2: ANALYSIS
*******************************************************************************************************************************************

use shp_panel.dta

***************************************************************************

*1. creating variables etc.

drop if age<18   /*get rid of those who are less than working age*/
drop if wstat==0 /* Now want just those people who are not retired in a given wave*/

local regvars pp13 pp17 pp10 ieqsg ieqog iptotg is1maj canton sex age pw101 pp01 pn42 pn43 pp02 pp06 cspfaj educat wstat idpers idhous wave pp46 pp47 po17 po34 po58 po59

foreach i in `regvars' {   /*SHP uses these codes for "don't know"/"inapplicable" and so on. Converting them to missing data*/
quietly recode `i' -1=.
quietly recode `i' -2=.
quietly recode `i' -3=.
quietly recode `i' -4=.
quietly recode `i' -5=.
quietly recode `i' -6=.
quietly recode `i' -7=.
quietly recode `i' -8=.
quietly recode `i' -9=.
}


gen opn_socsec=pp13 /*3=want soc expenditure raised*/
replace opn_socsec=0 if pp13==1
replace opn_socsec=0.5 if pp13==2
replace opn_socsec=1 if pp13==3

gen opn_socsec1=pp13
replace opn_socsec1=1 if pp13==3
replace opn_socsec1=0 if pp13==2|pp13==1

gen opn_taxes=pp17  /*1=want taxes on rich increased*/
replace opn_taxes=1 if pp17==1
replace opn_taxes=0.5 if pp17==2
replace opn_taxes=0 if pp17==3

gen opn_taxes1=pp17
replace opn_taxes1=1 if pp17==1
replace opn_taxes1=0 if pp17==2|pp17==3

gen gender=sex  /* women =1*/
replace gender=0 if sex==1
replace gender=1 if sex==2

gen ed_noschool=educat
replace ed_noschool = 15 if educat==0
replace ed_noschool = 0 if ed_noschool!=15&educat!=.
replace ed_noschool = 1 if ed_noschool==15

gen ed_uni=educat
replace ed_uni = 1 if educat==10
replace ed_uni = 0 if educat!=10&educat!=.

*Income - inflation adjustment and logging (adjusted using swiss inflation data)
gen hincome=.  /*Household Income*/
replace hincome = ieqog if wave==1
replace hincome = ieqog/1.0156 if wave==2
replace hincome = ieqog/1.0256 if wave==3
replace hincome = ieqog/1.0322 if wave==4
replace hincome = ieqog/1.0388 if wave==5
replace hincome = ieqog/1.0472 if wave==6
replace hincome = ieqog/1.0594 if wave==7
replace hincome = ieqog/1.0706 if wave==8
replace hincome = ieqog/1.0784 if wave==9
replace hincome = ieqog/1.1047 if wave==10
replace hincome = ieqog/1.0993 if wave==11
replace hincome = ieqog/1.1091 if wave==12


gen l_inc=log(hincome)  /*household income*/

gen subj_urisk=pw101  /*subjective perception of the risk of unemployment*/

tsset idpers wave

*save "SHP_allpaneldata.dta", replace

**************************************************************************************************************************************************

*2. Creating dataset for regressions 

* dropping people for whom data is missing
drop if opn_socsec==.| opn_taxes==.| subj_urisk==.| l_inc==. |gender==. |ed_noschool==.| ed_uni==.| age==.|canton==.
tsset idpers wave

bys idpers: gen nobs=[_N]   /* how many waves are they here for?*/

*Run this commented-off code to find out how many individuals there are initially
/*keep idpers wave nobs
reshape wide nobs, i(idpers) j(wave)*/


/* dropping people who appear in only one wave */
drop if nobs==1  

**********************************************************************************************************************************************
*3. For analyzing DVs and IVs ["DATA" section of paper]

*For checking urisk variable: create regions

foreach i in 1 2 3 4 5 6 7 8 9 10 11 12{
	sum subj_urisk if wave==`i'
}

*Regions (http://en.wikipedia.org/wiki/NUTS:CH)

*Lake Geneva Region (lemanique): geneva, vaud, valais
gen geneva=0
replace geneva=1 if canton==8|canton==23|canton==24
*Espace Mitteland: Bern, fribourg, jura, neuchatel, solothurn
gen mittell=0
replace mittell=1 if canton==4|canton==7|canton==11|canton==13|canton==18
*Northwest Switzerland: Argovie, Bale-Ville, Bale-Campagne
gen nw=0
replace nw=1 if canton==1|canton==5|canton==6
*zurich: zurich
gen zurich=0
replace zurich=1 if canton==26
*Eastern Switzerland: glarus, schaffhausen, appenzell ausserrhoden, appenzell innerhoden, st gallen, grisons, thurgau,
gen east=0
replace east=1 if canton==9|canton==17|canton==2|canton==3|canton==16|canton==10|canton==20
*central Switzerland: lucerne, uri, schwyz,obwalden, nidwalden,zug
gen central=0
replace central=1 if canton==12|canton==22|canton==19|canton==15|canton==14|canton==25
*ticino
gen ticino=0
replace ticino=1 if canton==21


**********************************************************************************************************************************************
*4. For "DATA DESCRIPTION" Section 

* How many waves and years people are there for?*/

bys idpers: egen len=max(wave)  
gen lenobs=len-len1  /* Gives difference between first and last wave in years*/



*Run this commented-off code to find out how many individuals we end up with, etc.
/*keep idpers wave nobs lenobs
reshape wide nobs lenobs, i(idpers) j(wave)

gen number=.  /*How many waves is each person present for?*/
replace number=nobs1 if nobs1!=.
replace number=nobs2 if nobs2!=.
replace number=nobs3 if nobs3!=.
replace number=nobs4 if nobs4!=.
replace number=nobs5 if nobs5!=.
replace number=nobs6 if nobs6!=.
replace number=nobs7 if nobs7!=.
replace number=nobs8 if nobs8!=.
replace number=nobs9 if nobs9!=.
replace number=nobs10 if nobs10!=.
replace number=nobs11 if nobs11!=.

tab(number)
summ number

gen lengthof=.  /*How long is each person in the panel for (in years)?*/
replace lengthof=lenobs1 if lenobs1!=.
replace lengthof=lenobs2 if lenobs2!=.
replace lengthof=lenobs3 if lenobs3!=.
replace lengthof=lenobs4 if lenobs4!=.
replace lengthof=lenobs5 if lenobs5!=.
replace lengthof=lenobs6 if lenobs6!=.
replace lengthof=lenobs7 if lenobs7!=.
replace lengthof=lenobs8 if lenobs8!=.
replace lengthof=lenobs9 if lenobs9!=.
replace lengthof=lenobs10 if lenobs10!=.
replace lengthof=lenobs11 if lenobs11!=.

tab(lengthof)
clear*/

*Analysis of stability over time [for Fig 3]

gen firstbelief1=.  /* This gives the belief held in the very first wave we see them in, regardless of wave number*/
bys idpers: replace firstbelief1=opn_socsec if wave==len1
bys idpers : replace firstbelief1 = firstbelief1[_n-1] if firstbelief1 == . /*works in a 'cascade' manner, filling in all waves*/

gen firstbelieft1=.  
bys idpers: replace firstbelieft1=opn_taxes if wave==len1
bys idpers : replace firstbelieft1 = firstbelieft1[_n-1] if firstbelieft1 == . 

gen beliefdiff=.
bys idpers: replace beliefdiff=opn_socsec[_n]-firstbelief1

gen beliefdifft=.
bys idpers: replace beliefdifft=opn_taxes[_n]-firstbelieft1

gen wavegap=.
bys idpers: replace wavegap=wave[_n]-len1

**********************************************************************************************************************************************

*5. Regressions 

fvset base 1 canton
fvset base 1 wave

gen agesq=age*age


* Table 1 (cross-sectional)
reg opn_socsec l_inc subj_urisk gender ed_noschool ed_uni age agesq  i.wave , cl(idhous)
estimates store m1
reg opn_socsec l_inc subj_urisk gender ed_noschool ed_uni age agesq  i.canton i.wave , cl(idhous)
estimates store m2
reg opn_taxes l_inc subj_urisk gender ed_noschool ed_uni age agesq  i.wave , cl(idhous)
estimates store m3
reg opn_taxes l_inc subj_urisk gender ed_noschool ed_uni age agesq  i.canton i.wave , cl(idhous)
estimates store m4

estout m1 m2 m3 m4, style(tex) cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.05) legend label varlabels(_cons Constant) stats(N r2) 


* Table 2 (fixed effects)

xtreg opn_socsec l_inc subj_urisk ed_noschool ed_uni age agesq  i.canton i.wave, fe cl(idhous) nonest
estimates store m1
xtreg opn_taxes l_inc subj_urisk ed_noschool ed_uni age agesq  i.canton i.wave, fe cl(idhous) nonest
estimates store m2

estout m1 m2, style(tex) cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.05) legend label varlabels(_cons Constant) stats(N r2) 


**********************************************************************************************************************************************

*6. Analysis of Large Changes [for Figs 4 and 5]

gen socsec_lag=.
bys idpers: replace socsec_lag=opn_socsec[_n-1]
gen taxes_lag=.
bys idpers: replace taxes_lag=opn_taxes[_n-1]

* Income change categories
gen inc_chdcat=0
replace inc_chdcat=1 if chincome1<-50
replace inc_chdcat=2 if chincome1<-45&chincome1>=-50
replace inc_chdcat=3 if chincome1<-40&chincome1>=-45
replace inc_chdcat=4 if chincome1<-35&chincome1>=-40
replace inc_chdcat=5 if chincome1<-30&chincome1>=-35
replace inc_chdcat=6 if chincome1<-25&chincome1>=-30
replace inc_chdcat=7 if chincome1<-20&chincome1>=-25
replace inc_chdcat=8 if chincome1<-15&chincome1>=-20
replace inc_chdcat=9 if chincome1<-10&chincome1>=-15
replace inc_chdcat=10 if chincome1<-5&chincome1>=-10
replace inc_chdcat=11 if chincome1<0&chincome1>=-5

gen inc_chupcat=0
replace inc_chupcat=11 if chincome1>50
replace inc_chupcat=10 if chincome1>45&chincome1<=50
replace inc_chupcat=9 if chincome1>40&chincome1<=45
replace inc_chupcat=8 if chincome1>35&chincome1<=40
replace inc_chupcat=7 if chincome1>30&chincome1<=35
replace inc_chupcat=6 if chincome1>25&chincome1<=30
replace inc_chupcat=5 if chincome1>20&chincome1<=25
replace inc_chupcat=4 if chincome1>15&chincome1<=20
replace inc_chupcat=3 if chincome1>10&chincome1<=15
replace inc_chupcat=2 if chincome1>5&chincome1<=10
replace inc_chupcat=1 if chincome1>0&chincome1<=5


***

gen churisk_up=.
replace churisk_up=1 if diff_urisk>2&diff_urisk!=.
replace churisk_up=0 if diff_urisk<3&diff_urisk!=.

gen churisk_down=.
replace churisk_down=1 if diff_urisk<-2&diff_urisk!=.
replace churisk_down=0 if diff_urisk>-3&diff_urisk!=.

gen chincome_down = .
replace chincome_down = 1 if chincome1<-31.4113&chincome1!=.
replace chincome_down = 0 if chincome1>-31.4113 & chincome1!=.

gen chincome_up = .
replace chincome_up = 1 if chincome1>65.013&chincome1!=.
replace chincome_up = 0 if chincome1<65.013 & chincome1!=.

bys idpers: gen wavegapl=wave[_n]-wave[_n-1]
bys idpers: gen wavegap2l=wave[_n]-wave[_n-2]

***

gen churisk_downlag=0
	*Capture people who had a big change last wave and have sustained it this period 
bys idpers: replace churisk_downlag=1 if wavegapl<2&churisk_down[_n-1]==1&((subj_urisk-subj_urisk[_n-1])<=0)

gen churisk_downlag2=0
bys idpers: replace churisk_downlag2=1 if wavegap2l<3&churisk_down[_n-2]==1&((subj_urisk-subj_urisk[_n-2])<=0)

gen churisk_uplag=0
bys idpers: replace churisk_uplag=1 if wavegapl<2&churisk_up[_n-1]==1&((subj_urisk-subj_urisk[_n-1])>=0)

gen churisk_uplag2=0
bys idpers: replace churisk_uplag2=1 if wavegap2l<3&churisk_up[_n-2]==1&((subj_urisk-subj_urisk[_n-2])>=0)

gen churisk_up1 = .
replace churisk_up1= 1 if (churisk_up==1|churisk_uplag==1|churisk_uplag2==1)
replace churisk_up1= 0 if (churisk_up==0&churisk_uplag!=1&churisk_uplag2!=1)

gen churisk_down1 = .
replace churisk_down1= 1 if (churisk_down==1|churisk_downlag==1|churisk_downlag2==1)
replace churisk_down1= 0 if (churisk_down==0&churisk_downlag!=1&churisk_uplag2!=1)

***

gen chincome_downlag=0
bys idpers: replace chincome_downlag=1 if wavegapl<2&chincome_down[_n-1]==1&((chincome1-chincome1[_n-1])<(3))
gen chincome_downlag2=0
bys idpers: replace chincome_downlag2=1 if wavegap2l<3&chincome_down[_n-2]==1&((chincome1-chincome1[_n-2])<(3))

gen chincome_uplag=0
bys idpers: replace chincome_uplag=1 if wavegapl<2&chincome_up[_n-1]==1&((chincome1-chincome1[_n-1])>(-3))
drop chincome_uplag2
gen chincome_uplag2=0
bys idpers: replace chincome_uplag2=1 if wavegap2l<3&chincome_up[_n-2]==1&((chincome1-chincome1[_n-2])>(-3))

gen chincome_up1 = .
replace chincome_up1= 1 if (chincome_up==1|chincome_uplag==1|chincome_uplag2==1)
replace chincome_up1= 0 if (chincome_up==0&chincome_uplag!=1&chincome_uplag2!=1)

gen chincome_down1 = .
replace chincome_down1= 1 if (chincome_down==1|chincome_downlag==1|chincome_downlag2==1)
replace chincome_down1= 0 if (chincome_down==0&chincome_downlag!=1&chincome_uplag2!=1)


xtreg opn_socsec churisk_up1 churisk_down1 chincome_up1 chincome_down1 ed_noschool ed_uni age agesq  i.canton i.wave, fe cl(idhous) nonest
xtreg opn_taxes churisk_up1 churisk_down1 chincome_up1 chincome_down1 ed_noschool ed_uni age agesq  i.canton i.wave, fe cl(idhous) nonest



************************************************************************************************************************************************************************************

*7. Belief Formation

* Code leftwing parents
gen lwingdad=.
replace lwingdad=1 if pp46<5
replace lwingdad=0 if pp46>4
replace lwingdad=. if pp46==.

gen lwingmum=.
replace lwingmum=1 if pp47<5
replace lwingmum=0 if pp47>4
replace lwingmum=. if pp47==.

* Cross parents' reports versus own reports of ideology [footnote 33: run commented-off code]

/*	*Get rid of missingness
recode pp10_f -1 =. 
recode pp10_f -2 =. 
recode pp10_f -3 =. 
recode pp10_f -4 =. 
recode pp10_f -5 =. 
recode pp10_f -6 =. 
recode pp10_f -7 =. 

	*Generate average of father's own beliefs
bys idpers: egen fathav=mean(pp10_f)
bys idpers: gen ideoldiff=pp46-fathav

	*Min age
bys idpers: egen age1 = min(age)

	*Reshape to wide to get a measure for each person
keep idpers wave ideoldiff age1
reshape wide ideoldiff age1, i(idpers) j(wave)
	*Take a row average of the ideoldiff variables to get the answer (they're all the same, anyway)
egen mideoldiff=rmean(ideoldiff1 ideoldiff2 ideoldiff3 ideoldiff4 ideoldiff5 ideoldiff6 ideoldiff7 ideoldiff8 ideoldiff9 ideoldiff10 ideoldiff11)
egen minage=rmean(age11 age12 age13 age14 age15 age16 age17 age18 age19 age110 age111)
	*Test
summ mideoldiff
sum mideoldiff if mideoldiff>2|mideoldiff<-2
sum mideoldiff if mideoldiff>3|mideoldiff<-3


* Cross check mothers reports versus own reports of ideology

	*Get rid of missingness
recode pp10_m -1 =. 
recode pp10_m -2 =. 
recode pp10_m -3 =. 
recode pp10_m -4 =. 
recode pp10_m -5 =. 
recode pp10_m -6 =. 
recode pp10_m -7 =. 

	*Generate average of father's own beliefs
bys idpers: egen mothav=mean(pp10_m)
bys idpers: gen ideoldiff_m=pp46-mothav

	*Reshape to wide to get a measure for each person
keep idpers wave ideoldiff_m age1
reshape wide ideoldiff_m age1, i(idpers) j(wave)
	*Take a row average of the ideoldiff variables to get the answer (they're all the same, anyway)
egen mideoldiff=rmean(ideoldiff_m1 ideoldiff_m2 ideoldiff_m3 ideoldiff_m4 ideoldiff_m5 ideoldiff_m6 ideoldiff_m7 ideoldiff_m8 ideoldiff_m9 ideoldiff_m10 ideoldiff_m11)
egen minage=rmean(age11 age12 age13 age14 age15 age16 age17 age18 age19 age110 age111)
	*Test
summ mideoldiff
sum mideoldiff if mideoldiff>2|mideoldiff<-2
sum mideoldiff if mideoldiff>3|mideoldiff<-3 */


* Code Poor family
gen poorfam=.
replace poorfam=1 if po58==1
replace poorfam=0 if po58==2
replace poorfam=. if poorfam==.

gen poordad=.
replace poordad=1 if cspfaj>5
replace poordad=0 if cspfaj>0&cspfaj<6
replace poordad=. if cspfaj<1|cspfaj==.

gen poor = .
replace poor = 1 if poordad==1|poorfam==1
replace poor = 0 if poordad==0&poorfam==0

* Regressions (Fig 7]
reg opn_socsec l_inc subj_urisk lwingdad poor gender ed_noschool ed_uni age agesq  i.canton i.wave, cl(idhous)
estimates store m1
reg opn_socsec l_inc subj_urisk lwingmum poor gender ed_noschool ed_uni age agesq  i.canton i.wave, cl(idhous)
estimates store m2
reg opn_taxes l_inc subj_urisk lwingdad poor gender ed_noschool ed_uni age agesq  i.canton i.wave, cl(idhous)
estimates store m1
reg opn_taxes l_inc subj_urisk lwingmum poor gender ed_noschool ed_uni age agesq  i.canton i.wave, cl(idhous)
estimates store m2


* Connection of income and urisk to background
sum(hincome) if poor==0
sum(hincome) if poor==1
sum(subj_urisk) if poor==0
sum(subj_urisk) if poor==1

sum(hincome) if poorfam==0
sum(hincome) if poorfam==1
sum(subj_urisk) if poorfam==0
sum(subj_urisk) if poorfam==1

sum(hincome) if lwingdad==1
sum(hincome) if lwingdad==0
sum(subj_urisk) if lwingdad==1
sum(subj_urisk) if lwingdad==0

sum(hincome) if lwingmum==1
sum(hincome) if lwingmum==0
sum(subj_urisk) if lwingmum==1
sum(subj_urisk) if lwingmum==0



*** For Figures 8 and 9 

bys idpers: egen noyearsmax=max(wave)
bys idpers: gen noyears=noyearsmax-len1   /*number of years (not waves) in panel*/

bys idpers: gen yearstodate=wave-len1 


gen firsturisk=.  
bys idpers: replace firsturisk=subj_urisk if wave==len1
bys idpers: replace firsturisk = firsturisk[_n-1] if firsturisk == . /*works in a 'cascade' manner, filling in all waves*/

gen firstinc=.  
bys idpers: replace firstinc=hincome if wave==len1
bys idpers: replace firstinc = firstinc[_n-1] if firstinc == . /*works in a 'cascade' manner, filling in all waves*/


gen churisk_age =.
bys idpers: replace churisk_age = subj_urisk[_n]-firsturisk if wave!=len1

gen chbelief=.
bys idpers: replace chbelief = opn_socsec[_n]-firstbelief1 if wave!=len1

gen chbelieft=.
bys idpers: replace chbelieft = opn_taxes[_n]-firstbelieft1 if wave!=len1

gen chincome_age=.
bys idpers: replace chincome_age = ((hincome[_n]-firstinc)/firstinc)*100 if wave!=len1


** To transfer to R for making the figures
save "SHP_finaldata.dta", replace
keep opn_socsec opn_taxes wave age len1 nobs pp04 educat geneva mittell nw zurich east central ticino beliefdiff beliefdifft wavegap subj_urisk inc_cat diff_urisk diff_socsec diff_taxes chincome1 socsec_lag taxes_lag inc_chdcat inc_chupcat churisk_age chincome_age chbelief chbelieft noyears age1 is1maj yearstodate
saveold "SHP_finaldataR.dta", version(12) replace


*****************************************************************************************************************************************************
*****************************************************************************************************************************************************


** MATERIAL FOR SUPPLEMENTARY INFO **

*** 1. Stuff in the "DATA" section

* Is soc spending just about federal-local divide?

sum(pp04) if opn_socsec==0
sum(pp04) if opn_socsec==0.5
sum(pp04) if opn_socsec==1

sum(pp10) if opn_socsec==0
sum(pp10) if opn_socsec==0.5
sum(pp10) if opn_socsec==1

tab(opn_taxes) if opn_socsec==0
tab(opn_taxes) if opn_socsec==0.5
tab(opn_taxes) if opn_socsec==1

*For the 2011 unemployment benefits correlation analysis
/*clear
use "SHP11_P_USER.dta"

local vars p11p13 p11p17 p11p61
foreach i in `vars' {   /*SHP uses these codes for "don't know"/"inapplicable" and so on. Converting them to missing data*/
recode `i' -1=.
recode `i' -2=.
recode `i' -3=.
}

keep p11p13 p11p17 p11p61
saveold "2011R.dta", version(12) replace
*/

******************

*** 2. Stuff in the "DATA DESCRIPTION" section

/*Characteristics of those who only appear for one wave*/

tab(opn_socsec1) if nobs==1
tab(opn_taxes1) if nobs==1

sum(hincome) if nobs==1
tab(gender) if nobs==1
tab(ed_noschool) if nobs==1
tab(ed_uni) if nobs==1
sum(subj_urisk) if nobs==1
sum(age) if nobs==1

/*investigating characteristics after attrition (Table S1)*/

bys idpers: egen len1=min(wave) /* number of first wave we seem them in*/

local tabvars opn_socsec1 opn_taxes1 gender ed_noschool ed_uni
local sumvars hincome age subj_urisk 

foreach i in `tabvars'{ /* This gives the relevant var in the very first wave we see them in, regardless of wave number*/
gen firstobs_`i'=.  
bys idpers: replace firstobs_`i'=`i' if wave==len1
tab firstobs_`i'
}

foreach i in `sumvars'{
gen firstobs_`i'=.  
bys idpers: replace firstobs_`i'=`i' if wave==len1
sum firstobs_`i'
}

******************

*** 3. Regression cross-checks etc.


** Cross-sectional
ologit opn_socsec l_inc subj_urisk gender ed_noschool ed_uni age agesq  i.canton i.wave , cl(idhous)
estimates store m1
logit opn_socsec1 l_inc subj_urisk gender ed_noschool ed_uni age agesq  i.canton i.wave , cl(idhous)
estimates store m2
ologit opn_taxes l_inc subj_urisk gender ed_noschool ed_uni age agesq  i.canton i.wave , cl(idhous)
estimates store m3
logit opn_taxes1 l_inc subj_urisk gender ed_noschool ed_uni age agesq  i.canton i.wave , cl(idhous)
estimates store m4

estout m1 m2 m3 m4, style(tex) cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.05) legend label varlabels(_cons Constant) stats(N r2) 



** Fixed Effects

	*No Wave Dummies
xtreg opn_socsec l_inc subj_urisk ed_noschool ed_uni age agesq  i.canton, fe cl(idhous) nonest
estimates store m1
xtreg opn_taxes l_inc subj_urisk ed_noschool ed_uni age agesq  i.canton, fe cl(idhous) nonest
estimates store m2

estout m1 m2, style(tex) cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.05) legend label varlabels(_cons Constant) stats(N r2) 


	*Linear 2-point
xtreg opn_socsec1 l_inc subj_urisk ed_noschool ed_uni age agesq  i.canton i.wave , fe cl(idhous) nonest
estimates store m1
xtreg opn_taxes1 l_inc subj_urisk ed_noschool ed_uni age agesq  i.canton i.wave , fe cl(idhous) nonest
estimates store m3

	*income by decile
xtile incq=hincome,nq(10)

xtreg opn_socsec incq subj_urisk ed_noschool ed_uni age agesq  i.canton i.wave , fe cl(idhous) nonest
estimates store m2
xtreg opn_taxes incq subj_urisk ed_noschool ed_uni age agesq  i.canton i.wave , fe cl(idhous) nonest
estimates store m4
		
estout m1 m2 m3 m4, style(tex) cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.05) legend label varlabels(_cons Constant) stats(N r2) 

*********

	*Only those who began the panel in the middle category
xtreg opn_socsec l_inc subj_urisk ed_noschool ed_uni age agesq  i.canton i.wave if firstbelief1==0.5, fe cl(idhous) nonest
estimates store m1
xtreg opn_taxes l_inc subj_urisk ed_noschool ed_uni age agesq  i.canton i.wave if firstbelieft1==0.5, fe cl(idhous) nonest
estimates store m2

estout m1 m2, style(tex) cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.05) legend label varlabels(_cons Constant) stats(N r2) 


*********

* How much variability is there in the indep vars? [supp info]

*Changes
gen diff_urisk=.	
bys idpers: replace diff_urisk=subj_urisk[_n]-subj_urisk[_n-1] 

gen diff_socsec=.	
bys idpers: replace diff_socsec=opn_socsec[_n]-opn_socsec[_n-1] 

gen diff_taxes=.	
bys idpers: replace diff_taxes=opn_taxes[_n]-opn_taxes[_n-1] 

gen chincome1=.
bys idpers: replace chincome1 = ((hincome[_n]-hincome[_n-1])/hincome[_n-1])*100

*keep diff_urisk diff_income chincome1
*version 10.1: xi:  outsheet using "shppanel.csv", comma  

*********

* Family Background regs without education controls

reg opn_socsec lwingdad poor gender age agesq  i.canton i.wave, cl(idhous)
reg opn_socsec lwingmum poor  gender age agesq  i.canton i.wave, cl(idhous)
reg opn_taxes  lwingdad poor gender age agesq  i.canton i.wave, cl(idhous)
reg opn_taxes lwingmum poor gender age agesq  i.canton i.wave, cl(idhous)
