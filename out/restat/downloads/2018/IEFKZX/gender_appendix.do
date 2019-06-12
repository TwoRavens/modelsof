/*do file name: gender_appendix.do*/



**************************Appendix Table 1A***************************
clear
use ccss.dta

gen sciencem=1 if major==7
replace sciencem=1 if major==8
replace sciencem=0 if major==1
replace sciencem=0 if major==2
replace sciencem=0 if major==3
replace sciencem=0 if major==4
replace sciencem=0 if major==5
replace sciencem=0 if major==6
replace sciencem=0 if major==9
replace sciencem=0 if major==10
replace sciencem=0 if major==11
replace sciencem=0 if major==12
replace sciencem=0 if major==13

gen female=1 if sex==2
replace female=0 if sex==1

codebook schoolname 
codebook schoolname if  tiers==1
codebook schoolname if  tiers==1 | tiers==2
codebook schoolname if  tiers==1 | tiers==2 | tiers==3
codebook schoolname if  tiers==1 | tiers==2 | tiers==3 | tiers==4
codebook schoolname if  tiers==5
codebook schoolname if  tiers==6
codebook schoolname if  tiers==7

tabstat female if yearin==2008,by(sciencem)
tabstat female if  tiers==1 | tiers==2 ,by(sciencem)
tabstat female if  tiers==1 | tiers==2 | tiers==3 ,by(sciencem)
tabstat female if  tiers==1 | tiers==2 | tiers==3 | tiers==4 ,by(sciencem)
tabstat female if  tiers==5 & yearin==2008,by(sciencem)
tabstat female if  tiers==6 & yearin==2008,by(sciencem)
tabstat female if  tiers==7 & yearin==2008,by(sciencem)


**************************Appendix Table IIC***************************
clear
use merge_clean.dta

gen t1 = 0
replace t1 = 1 if total>=540 & type==1
replace t1 = 1 if total>=570 & type==0

gen t2 = 0
replace t2 = 1 if total>=470 & total<540 & type==1
replace t2 = 1 if total>=500 & total<570 & type==0

gen t3 = 0
replace t3 = 1 if total>=420 & total<470 & type==1
replace t3 = 1 if total>=460 & total<500 & type==0

gen t4 = 0
replace t4 = 1 if total>=300 & total<420 & type==1
replace t4 = 1 if total>=340 & total<460 & type==0

gen none = 0
replace none = 1 if total<300 & type==1
replace none = 1 if total<340 & type==0

assert t1+t2+t3+t4+none==1

tabstat t1 t2 t3 t4 none ,by(type)
 
 
******************Appendix table 2*******************
/*Appendix table 2 column (1)*/
clear
use zhijian.dta

capture log close
drop if total==0 | chinese==0 | math==0 | english==0| integrate==0
log using T1_zhijian, replace
sum total chinese math integrate english
log close

/*Appendix table 2 column (2)*/
clear
use gaokao.dta

capture log close
set logtype text
log using T1_gaokao, replace
sum female type month gtotal gchinese gmath gintegrate genglish 
log close

/*Appendix table 2 column (3)*/
clear
use merge_clean.dta

capture log close
drop if total==0 | chinese==0 | math==0 | english==0| integrate==0
log using T1_merged, replace
sum female type month total chinese math integrate english gtotal gchinese gmath gintegrate genglish
log close

/*Appendix table 2 column (4)*/
use merge_clean.dta
append using zhijian.dta

gen mock=0
replace mock=1 if gchinese==.

reg total mock,robust
outreg2 using at2reg, bdec(3) se br excel replace
reg chinese mock,robust
outreg2 using at2reg, bdec(3) se br excel 
reg math mock,robust
outreg2 using at2reg, bdec(3) se br excel 
reg integrate mock,robust
outreg2 using at2reg, bdec(3) se br excel 
reg english mock,robust
outreg2 using at2reg, bdec(3) se br excel 

/*Appendix table 2 column (5)*/

clear
use merge_clean.dta
append using gaokao.dta

gen gaokao=0
replace gaokao=1 if chinese==.

reg female gaokao,robust
outreg2 using at2reg2, bdec(3) se br excel replace
reg type gaokao,robust
outreg2 using at2reg2, bdec(3) se br excel 
reg month gaokao,robust
outreg2 using at2reg2, bdec(3) se br excel 
reg gtotal gaokao,robust
outreg2 using at2reg2, bdec(3) se br excel 
reg gchinese gaokao,robust
outreg2 using at2reg2, bdec(3) se br excel 
reg gmath gaokao,robust
outreg2 using at2reg2, bdec(3) se br excel 
reg gintegrate gaokao,robust
outreg2 using at2reg2, bdec(3) se br excel 
reg genglish gaokao,robust
outreg2 using at2reg2, bdec(3) se br excel 


******************Appendix table 3*******************
clear
use merge_clean.dta

/*Appendix table 3 column (1)*/
set logtype text
log using t3_1, replace
sum total if female==1
sum total chinese math integrate english if female==1 & type==1
sum total chinese math integrate english if female==1 & type==0
log close

/*Appendix table 3 column (2)*/
set logtype text
log using t3_2, replace
sum total if female==0
sum total chinese math integrate english if female==0 & type==1
sum total chinese math integrate english if female==0 & type==0
log close

/*Appendix table 3 column (3)*/
reg total female
outreg2 using t3_3, bdec(3) se br excel replace
foreach var of varlist total chinese math integrate english{
reg `var' female if type==1
outreg2 using t3_3, bdec(3) se br excel append
}

foreach var of varlist total chinese math integrate english{
reg `var' female if type==0
outreg2 using t3_3, bdec(3) se br excel append
}

/*Appendix table 3 column (4)*/
set logtype text
log using t3_4, replace
sum gtotal if female==1
sum gtotal gchinese gmath gintegrate genglish if female==1 & type==1
sum gtotal gchinese gmath gintegrate genglish if female==1 & type==0
log close

/*Appendix table 3 column (5)*/
set logtype text
log using t3_5, replace
sum gtotal if female==0
sum gtotal gchinese gmath gintegrate genglish if female==0 & type==1
sum gtotal gchinese gmath gintegrate genglish if female==0 & type==0
log close

/*Appendix table 3 column (6)*/
reg gtotal female
outreg2 using t3_6, bdec(3) se br excel replace

foreach var of varlist gtotal gchinese gmath gintegrate genglish{
reg `var' female if type==1
outreg2 using t3_6, bdec(3) se br excel append
}

foreach var of varlist gtotal gchinese gmath gintegrate genglish{
reg `var' female if type==0
outreg2 using t3_6, bdec(3) se br excel append
}

/*Appendix table 3 column (7)*/
reg dtotal female
outreg2 using t3_7, bdec(3) se br excel replace

foreach var of varlist dtotal dchinese dmath dintegrate denglish{
reg `var' female if type==1
outreg2 using t3_7, bdec(3) se br excel append
}

foreach var of varlist dtotal dchinese dmath dintegrate denglish{
reg `var' female if type==0
outreg2 using t3_7, bdec(3) se br excel append
}

 
*********************** Appendix Table 4 ***************************
clear
use merge_clean.dta

set more off
xi: reg dtotal female, robust
outreg2 female using at4, bdec(3) se br excel replace
xi: areg dtotal female i.schoolcode month, absorb(postcode) robust
outreg2 female using at4, bdec(3) se br excel append

foreach var of varlist chinese math integrate english{
xi: reg d`var' female, robust
outreg2 female using at4, bdec(3) se br excel append
xi: areg d`var' female i.schoolcode month, absorb(postcode) robust
outreg2 female using at4, bdec(3) se br excel append
}

foreach var of varlist total chinese math integrate english{
xi: reg d`var' female if type==1, robust
outreg2 female using at4, bdec(3) se br excel append
xi: areg d`var' female i.schoolcode month if type==1, absorb(postcode) robust
outreg2 female using at4, bdec(3) se br excel append
}
foreach var of varlist total chinese math integrate english{
xi: reg d`var' female if type==0, robust
outreg2 female using at4, bdec(3) se br excel append
xi: areg d`var' female i.schoolcode month if type==0, absorb(postcode) robust
outreg2 female using at4, bdec(3) se br excel append
}

******************Appendix table 5*******************
clear
use merge_clean.dta

xtile ztotal_q3 = ztotal, nq(3)
set more off

/*Appendix table 5 part A full sample*/
xi: areg zdztotal female i.schoolcode month if ztotal_q3==1, absorb(postcode) robust	
outreg2 female using t5_a, bdec(3) se br excel replace
xi: areg zdztotal female i.schoolcode month if ztotal_q3==2, absorb(postcode) robust	
outreg2 female using t5_a, bdec(3) se br excel append
xi: areg zdztotal female i.schoolcode month if ztotal_q3==3, absorb(postcode) robust	
outreg2 female using t5_a, bdec(3) se br excel append

/*Appendix table 5 part B science stream*/
xi: areg zdztotal female i.schoolcode month if ztotal_q3==1 & type==1, absorb(postcode) robust	
outreg2 female using t5_b, bdec(3) se br excel replace
xi: areg zdztotal female i.schoolcode month if ztotal_q3==2 & type==1, absorb(postcode) robust	
outreg2 female using t5_b, bdec(3) se br excel append
xi: areg zdztotal female i.schoolcode month if ztotal_q3==3 & type==1, absorb(postcode) robust	
outreg2 female using t5_b, bdec(3) se br excel append

/*Appendix table 5 part C arts stream*/
xi: areg zdztotal female i.schoolcode month if ztotal_q3==1 & type==0, absorb(postcode) robust	
outreg2 female using t5_c, bdec(3) se br excel replace
xi: areg zdztotal female i.schoolcode month if ztotal_q3==2 & type==0, absorb(postcode) robust	
outreg2 female using t5_c, bdec(3) se br excel append
xi: areg zdztotal female i.schoolcode month if ztotal_q3==3 & type==0, absorb(postcode) robust	
outreg2 female using t5_c, bdec(3) se br excel append

******************Appendix table 6*******************
clear
use survey,clear

/*Appendix Table 6A: Daily Study Hour*/
foreach var of varlist totalh05- engh12{
ttest  `var', by(female)
}

gen diffh54=totalh04-totalh05
gen diffh43=totalh03-totalh04
gen diffh32=totalh02-totalh03
gen diffh21=totalh01-totalh02
gen diffh112=totalh12-totalh01
  
gen diffch54= chih04-chih05
gen diffch43= chih03-chih04
gen diffch32= chih02-chih03
gen diffch21= chih01-chih02
gen diffch112=chih12-chih01 
  
gen diffmh54=mathh04-mathh05
gen diffmh43=mathh03-mathh04
gen diffmh32=mathh02-mathh03
gen diffmh21=mathh01-mathh02
gen diffmh112=mathh12-mathh01 

gen diffih54= inth04-inth05
gen diffih43= inth03-inth04
gen diffih32= inth02-inth03
gen diffih21= inth01-inth02
gen diffih112=inth12-inth01  

gen diffeh54= engh04-engh05
gen diffeh43= engh03-engh04
gen diffeh32= engh02-engh03
gen diffeh21= engh01-engh02
gen diffeh112=engh12-engh01


reg diffh54 female,robust
outreg2 using t6_a, bdec(3) se br excel replace

foreach var of varlist  diffh43-diffeh112{
reg `var' female,robust
outreg2 using t6_a, bdec(3) se br excel append
}

/*Appendix Table 6B: Gaokao Preparation*/

foreach var of varlist prepare05-prepare12{
ttest  `var', by(female)
}


gen diffprepare54= prepare04-prepare05
gen diffprepare43= prepare03-prepare04
gen diffprepare32= prepare02-prepare03
gen diffprepare21= prepare01-prepare02
gen diffprepare112=prepare12-prepare01


reg prepare05 female,robust
outreg2 using t6_b, bdec(3) se br excel replace

foreach var of varlist  prepare04-prepare12{
reg `var' female,robust
outreg2 using t6_b, bdec(3) se br excel append
}

foreach var of varlist  diffprepare54-diffprepare112{
reg `var' female,robust
outreg2 using t6_b, bdec(3) se br excel append
}

/*Appendix Table 6C: Study Effectiveness*/

foreach var of varlist  effi05-effi12{
ttest  `var', by(female)
}


gen diffeffi54= effi04-effi05
gen diffeffi43= effi03-effi04
gen diffeffi32= effi02-effi03
gen diffeffi21= effi01-effi02
gen diffeffi112=effi12-effi01

reg effi05 female,robust
outreg2 using t6_c, bdec(3) se br excel replace

foreach var of varlist   effi04-effi12{
reg `var' female,robust
outreg2 using t6_c, bdec(3) se br excel append
}

foreach var of varlist  diffeffi54-diffeffi112{
reg `var' female,robust
outreg2 using t6_c, bdec(3) se br excel append
}

/*Appendix Table 6D: Effort in the Mock exams*/

foreach var of varlist  effortchinese-effortenglish{
ttest  `var', by(female)
}

reg effortchinese female,robust
outreg2 using t6_d, bdec(3) se br excel replace

foreach var of varlist   effortmath-effortenglish{
reg `var' female,robust
outreg2 using t6_d, bdec(3) se br excel append
}


/*Appendix Table 6E: Expectation about Performance in Gaokao*/

foreach var of varlist  changechinese-changeenglish{
ttest  `var', by(female)
}

reg changechinese female,robust
outreg2 using t6_e, bdec(3) se br excel replace

foreach var of varlist  changemath changeenglish{
reg `var' female,robust
outreg2 using t6_e, bdec(3) se br excel append
}

*********************** Appendix Table 7***************************
clear
use merge_clean.dta

/* Appendix Table 7 Panel A*/
gen cutoff3pxfemale = cutoff3p*female
gen cutoff3nxfemale =cutoff3n*female 
gen cutoff1120pxfemale = cutoff1120p*female

set more off
xi: areg zdztotal female i.schoolcode month if cutoff3n==1, absorb(postcode) robust
outreg2 female using at7a, bdec(3) se br excel replace
xi: areg zdztotal female i.schoolcode month if cutoff3p==1, absorb(postcode) robust
outreg2 female using at7a, bdec(3) se br excel append
xi: areg zdztotal female i.schoolcode month if cutoff410n==1, absorb(postcode) robust
outreg2 female using at7a, bdec(3) se br excel append
xi: areg zdztotal female i.schoolcode month if cutoff410p==1, absorb(postcode) robust
outreg2 female using at7a, bdec(3) se br excel append
xi: areg zdztotal female i.schoolcode month if cutoff1120n==1, absorb(postcode) robust
outreg2 female using at7a, bdec(3) se br excel append
xi: areg zdztotal female i.schoolcode month if cutoff1120p==1, absorb(postcode) robust
outreg2 female using at7a, bdec(3) se br excel append
xi: reg zdztotal cutoff3nxfemale cutoff3n female i.school*cutoff3n i.cutoff3n*month i.postcode*cutoff3n if (cutoff3n==1 | cutoff1120p==1), robust
outreg2 cutoff3nxfemale using at7a, bdec(3) se br excel append
xi: reg zdztotal cutoff1120pxfemale cutoff1120p female i.school*cutoff1120p i.cutoff1120p*month i.postcode*cutoff1120p if (cutoff1120n==1 | cutoff1120p==1), robust
outreg2 cutoff1120pxfemale using at7a, bdec(3) se br excel append
 
/* Appendix Table 7 Panel B*/

gen cutoff3p09 = 0
gen cutoff3n09 = 0
replace cutoff3p09=1 if total>=610 & total<=613 & type==1
replace cutoff3p09=1 if total>=540 & total<=543 & type==1
replace cutoff3p09=1 if total>=600 & total<=603 & type==0
replace cutoff3p09=1 if total>=520 & total<=523 & type==0
replace cutoff3n09=1 if total>=607 & total<610 & type==1
replace cutoff3n09=1 if total>=537 & total<540 & type==1
replace cutoff3n09=1 if total>=597 & total<600 & type==0
replace cutoff3n09=1 if total>=517 & total<520 & type==0

gen cutoff410p09 = 0
gen cutoff410n09 = 0
replace cutoff410p09=1 if total>=614 & total<=620 & type==1
replace cutoff410n09=1 if total>=600 & total<=606 & type==1
replace cutoff410p09=1 if total>=544 & total<=550 & type==1
replace cutoff410n09=1 if total>=530 & total<=536 & type==1
replace cutoff410p09=1 if total>=604 & total<=610 & type==0
replace cutoff410n09=1 if total>=590 & total<=596 & type==0
replace cutoff410p09=1 if total>=524 & total<=530 & type==0
replace cutoff410n09=1 if total>=510 & total<=516 & type==0

gen cutoff1120p09=0
gen cutoff1120n09=0
replace cutoff1120p09=1 if total>=621 & total<=630 & type==1
replace cutoff1120n09=1 if total>=590 & total<=599 & type==1
replace cutoff1120p09=1 if total>=551 & total<=560 & type==1
replace cutoff1120n09=1 if total>=520 & total<=529 & type==1
replace cutoff1120p09=1 if total>=611 & total<=620 & type==0
replace cutoff1120n09=1 if total>=580 & total<=589 & type==0
replace cutoff1120p09=1 if total>=531 & total<=540 & type==0
replace cutoff1120n09=1 if total>=500 & total<=509 & type==0

gen cutoff3p09xfemale=cutoff3p09*female
gen cutoff3n09xfemale=cutoff3n09*female
gen cutoff410p09xfemale=cutoff410p09*female 
gen cutoff410n09xfemale=cutoff410n09*female 
gen cutoff1120p09xfemale=cutoff1120p09*female 


set more off
xi: areg zdztotal female i.schoolcode month if cutoff3n09==1, absorb(postcode) robust
outreg2 female using at7b, bdec(3) se br excel replace
xi: areg zdztotal female i.schoolcode month if cutoff3p09==1, absorb(postcode) robust
outreg2 female using at7b, bdec(3) se br excel append
xi: areg zdztotal female i.schoolcode month if cutoff410n09==1, absorb(postcode) robust
outreg2 female using at7b, bdec(3) se br excel append
xi: areg zdztotal female i.schoolcode month if cutoff410p09==1, absorb(postcode) robust
outreg2 female using at7b, bdec(3) se br excel append
xi: areg zdztotal female i.schoolcode month if cutoff1120n09==1, absorb(postcode) robust
outreg2 female using at7b, bdec(3) se br excel append
xi: areg zdztotal female i.schoolcode month if cutoff1120p09==1, absorb(postcode) robust
outreg2 female using at7b, bdec(3) se br excel append
xi: reg zdztotal cutoff3n09xfemale cutoff3n09 female i.school*cutoff3n09 i.cutoff3n09*month i.postcode*cutoff3n09 if (cutoff3n09==1 | cutoff1120p09==1), robust
outreg2 cutoff3nxfemale using at7b, bdec(3) se br excel append
xi: reg zdztotal cutoff1120p09xfemale cutoff1120p09 female i.school*cutoff1120p09 i.cutoff1120p09*month i.postcode*cutoff1120p09 if (cutoff1120n09==1 | cutoff1120p09==1), robust
outreg2 cutoff1120pxfemale using at7b, bdec(3) se br excel append


*********************** Appendix Table 8 ***************************
clear
use merge_clean.dta

foreach var of varlist chinese math integrate english{
gen femalexzdz`var' = female*zdz`var'
}

foreach var of varlist chinese math integrate english{
gen femalexzg`var' = female*zg`var'
}

egen postcodexfemale = group(postcode female)


gen bigshock=0
replace bigshock=1 if dchinese>4.75
replace bigshock=1 if dchinese<-4.75

set more off
xi: areg zdzmath femalexzdzchinese zdzchinese female i.schoolcode month if bigshock==1, absorb(postcode) robust
outreg2 femalexzdzchinese zdzchinese female using at8, bdec(3) se br excel replace
xi: areg zdzmath femalexzdzchinese zdzchinese female i.schoolcode*female i.female*month if bigshock==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese zdzchinese female  using at8, bdec(3) se br excel append
xi: areg zdzmath femalexzdzchinese zdzchinese female i.schoolcode*female i.female*month if cutoff3==1 & bigshock==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese zdzchinese female  using at8, bdec(3) se br excel append
xi: areg zdzmath femalexzdzchinese zdzchinese female i.schoolcode*female i.female*month if cutoff5==1 & bigshock==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese zdzchinese female  using at8, bdec(3) se br excel append
xi: areg zdzmath femalexzdzchinese zdzchinese female i.schoolcode*female i.female*month if cutoff610==1 & bigshock==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese zdzchinese female  using at8, bdec(3) se br excel append
xi: areg zdzmath femalexzdzchinese zdzchinese female i.schoolcode*female i.female*month if cutoff1120==1 & bigshock==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese zdzchinese female  using at8, bdec(3) se br excel append


*********************** Appendix Table 9***************************
clear
use merge_clean.dta

egen dchineseper3=cut(zdzchinese) if female==0, group(200)
egen dchineseper4=cut(zdzchinese) if female==1, group(200)
gen dropout1=1
replace dropout1=. if dchineseper3==0
replace dropout1=. if dchineseper3==199
replace dropout1=. if dchineseper4==0
replace dropout1=. if dchineseper4==199

foreach var of varlist chinese math integrate english{
gen femalexzdz`var' = female*zdz`var'
}

foreach var of varlist chinese math integrate english{
gen femalexzg`var' = female*zg`var'
}

egen postcodexfemale = group(postcode female)

set more off
xi: areg zdzmath femalexzdzchinese zdzchinese female i.schoolcode month if dropout==1, absorb(postcode) robust
outreg2 femalexzdzchinese zdzchinese female using at9, bdec(3) se br excel replace
xi: areg zdzmath femalexzdzchinese zdzchinese female i.schoolcode*female i.female*month if dropout==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese zdzchinese female  using at9, bdec(3) se br excel append
xi: areg zdzmath femalexzdzchinese zdzchinese female i.schoolcode*female i.female*month if cutoff3==1 & dropout==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese zdzchinese female  using at9, bdec(3) se br excel append
xi: areg zdzmath femalexzdzchinese zdzchinese female i.schoolcode*female i.female*month if cutoff5==1 & dropout==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese zdzchinese female  using at9, bdec(3) se br excel append
xi: areg zdzmath femalexzdzchinese zdzchinese female i.schoolcode*female i.female*month if cutoff610==1 & dropout==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese zdzchinese female  using at9, bdec(3) se br excel append
xi: areg zdzmath femalexzdzchinese zdzchinese female i.schoolcode*female i.female*month if cutoff1120==1 & dropout==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese zdzchinese female  using at9, bdec(3) se br excel append

*********************** Appendix Table 10***************************
clear
use merge_clean.dta

foreach var of varlist chinese math integrate english{
bysort gender type: egen mean`var'=mean(`var')
bysort gender type: egen sd`var' = sd(`var')

bysort gender type: egen meang`var'=mean(g`var')
bysort gender type: egen sdg`var' = sd(g`var')

bysort type: gen z`var'_f = (`var' - mean`var')/sd`var' if female==1
bysort type: gen zg`var'_f = (g`var' - meang`var')/sdg`var' if female==1
bysort type: gen z`var'_m = (`var' - mean`var')/sd`var' if female==0
bysort type: gen zg`var'_m = (g`var' - meang`var')/sdg`var' if female==0

gen dz`var'_f = zg`var'_f - z`var'_f
gen dz`var'_m = zg`var'_m - z`var'_m

egen zdz`var'_f = std(dz`var'_f)
egen zdz`var'_m = std(dz`var'_m)
}

foreach var of varlist chinese math integrate english{
gen zdz`var'_own=zdz`var'_f
replace zdz`var'_own=zdz`var'_m if zdz`var'_own==.
}

foreach var of varlist chinese math integrate english{
gen femalexzdz`var'_own = female*zdz`var'_own
}



egen postcodexfemale = group(postcode female)


set more off
xi: areg zdzmath_own femalexzdzchinese_own zdzchinese_own female i.schoolcode month, absorb(postcode) robust
outreg2 femalexzdzchinese_own zdzchinese_own female using at10, bdec(3) se br excel replace
xi: areg zdzmath_own femalexzdzchinese_own zdzchinese_own female i.schoolcode*female i.female*month, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese_own zdzchinese_own female  using at10, bdec(3) se br excel append
xi: areg zdzmath_own femalexzdzchinese_own zdzchinese_own female i.schoolcode*female i.female*month if cutoff3==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese_own zdzchinese_own female  using at10, bdec(3) se br excel append
xi: areg zdzmath_own femalexzdzchinese_own zdzchinese_own female i.schoolcode*female i.female*month if cutoff5==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese_own zdzchinese_own female  using at10, bdec(3) se br excel append
xi: areg zdzmath_own femalexzdzchinese_own zdzchinese_own female i.schoolcode*female i.female*month if cutoff610==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese_own zdzchinese_own female  using at10, bdec(3) se br excel append
xi: areg zdzmath_own femalexzdzchinese_own zdzchinese_own female i.schoolcode*female i.female*month if cutoff1120==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese_own zdzchinese_own female  using at10, bdec(3) se br excel append


*********************** Appendix Table 11***************************
clear
use merge_clean.dta

foreach var of varlist chinese math integrate english{
gen femalexzdz`var' = female*zdz`var'
}

foreach var of varlist chinese math integrate english{
gen femalexzg`var' = female*zg`var'
}

egen postcodexfemale = group(postcode female)

set more off
/*Appendix Table 9  Part A*/
xi: areg zgmath femalexzdzchinese zdzchinese female i.schoolcode*female i.female*month, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese zdzchinese female using at11a, bdec(3) se br excel replace
xi: areg zgmath femalexzdzchinese zdzchinese female i.schoolcode*female i.female*month if cutoff3==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese zdzchinese female using at11a, bdec(3) se br excel append
xi: areg zgmath femalexzdzchinese zdzchinese female i.schoolcode*female i.female*month if cutoff5==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese zdzchinese female using at11a, bdec(3) se br excel append
xi: areg zgmath femalexzdzchinese zdzchinese female i.schoolcode*female i.female*month if cutoff610==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese zdzchinese female using at11a, bdec(3) se br excel append
xi: areg zgmath femalexzdzchinese zdzchinese female i.schoolcode*female i.female*month if cutoff1120==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese zdzchinese female using at11a, bdec(3) se br excel append

/*Appendix Table 9  Part B*/
xi: areg zmath femalexzdzchinese zdzchinese female i.schoolcode*female i.female*month, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese zdzchinese female using at11b, bdec(3) se br excel replace
xi: areg zmath femalexzdzchinese zdzchinese female i.schoolcode*female i.female*month if cutoff3==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese zdzchinese female using at11b, bdec(3) se br excel append
xi: areg zmath femalexzdzchinese zdzchinese female i.schoolcode*female i.female*month if cutoff5==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese zdzchinese female using at11b, bdec(3) se br excel append
xi: areg zmath femalexzdzchinese zdzchinese female i.schoolcode*female i.female*month if cutoff610==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese zdzchinese female using at11b, bdec(3) se br excel append
xi: areg zmath femalexzdzchinese zdzchinese female i.schoolcode*female i.female*month if cutoff1120==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese zdzchinese female using at11b, bdec(3) se br excel append


*********************** Appendix Table 12***************************
clear
use merge_clean.dta

*Cumulative performance on Day 1*
gen day1 = chinese + math
egen zday1_1 = std(day1) if type==1
egen zday1_0 = std(day1) if type==0
gen zday1=.
replace zday1 = zday1_1 if type==1
replace zday1 = zday1_0 if type==0

gen gday1 = gchinese + gmath
egen zgday1_1 = std(gday1) if type==1
egen zgday1_0 = std(gday1) if type==0
gen zgday1=.
replace zgday1 = zgday1_1 if type==1
replace zgday1 = zgday1_0 if type==0

gen dzday1 = zgday1 - zday1

gen femalexdzday1 = female*dzday1
gen femalexzgday1 = female*zgday1

*Cumulative Performance on First 3 Exams*
gen day12 = chinese + math + integrate
egen zday12_1 = std(day12) if type==1
egen zday12_0 = std(day12) if type==0
gen zday12=.
replace zday12 = zday12_1 if type==1
replace zday12 = zday12_0 if type==0

gen gday12 = gchinese + gmath + gintegrate
egen zgday12_1 = std(gday12) if type==1
egen zgday12_0 = std(gday12) if type==0
gen zgday12=.
replace zgday12 = zgday12_1 if type==1
replace zgday12 = zgday12_0 if type==0

gen dzday12 = zgday12 - zday12
egen zdzday12 = std(dzday12)
sum zdzday12

gen femalexzdzday12 = female*zdzday12
gen femalexzgday12 = female*zgday12

egen postcodexfemale = group(postcode female)

set more off
xi: areg zgenglish femalexzdzday12 zdzday12 female i.schoolcode*female i.female*month, absorb(postcodexfemale) robust
outreg2 femalexzdzday12 zdzday12 female using at12, bdec(3) se br excel append
xi: areg zgenglish femalexzdzday12 zdzday12 female i.schoolcode*female i.female*month if cutoff3==1, absorb(postcodexfemale) robust
outreg2 femalexzdzday12 zdzday12 female using at12, bdec(3) se br excel append
xi: areg zgenglish femalexzdzday12 zdzday12 female i.schoolcode*female i.female*month if cutoff5==1, absorb(postcodexfemale) robust
outreg2 femalexzdzday12 zdzday12 female using at12, bdec(3) se br excel append
xi: areg zgenglish femalexzdzday12 zdzday12 female i.schoolcode*female i.female*month if cutoff610==1, absorb(postcodexfemale) robust
outreg2 femalexzdzday12 zdzday12 female using at12, bdec(3) se br excel append
xi: areg zgenglish femalexzdzday12 zdzday12 female i.schoolcode*female i.female*month if cutoff1120==1, absorb(postcodexfemale) robust
outreg2 femalexzdzday12 zdzday12 female using at12, bdec(3) se br excel append

xi: areg zenglish femalexzdzday12 zdzday12 female i.schoolcode*female i.female*month, absorb(postcodexfemale) robust
outreg2 femalexzdzday12 zdzday12 female using at12, bdec(3) se br excel append
xi: areg zenglish femalexzdzday12 zdzday12 female i.schoolcode*female i.female*month if cutoff3==1, absorb(postcodexfemale) robust
outreg2 femalexzdzday12 zdzday12 female using at12, bdec(3) se br excel append
xi: areg zenglish femalexzdzday12 zdzday12 female i.schoolcode*female i.female*month if cutoff5==1, absorb(postcodexfemale) robust
outreg2 femalexzdzday12 zdzday12 female using at12, bdec(3) se br excel append
xi: areg zenglish femalexzdzday12 zdzday12 female i.schoolcode*female i.female*month if cutoff610==1, absorb(postcodexfemale) robust
outreg2 femalexzdzday12 zdzday12 female using at12, bdec(3) se br excel append
xi: areg zenglish femalexzdzday12 zdzday12 female i.schoolcode*female i.female*month if cutoff1120==1, absorb(postcodexfemale) robust
outreg2 femalexdzday12 dzday12 female using at12, bdec(3) se br excel append


******************Appendix table 13*******************
clear
use merge_clean.dta

foreach var of varlist chinese math integrate english{
gen femalexzdz`var' = female*zdz`var'
}

foreach var of varlist chinese math integrate english{
gen femalexzg`var' = female*zg`var'
}

gen femalexzdzchinese_pos = 0
replace femalexzdzchinese_pos=femalexzdzchinese if dzchinese>=0

gen femalexzdzchinese_neg = 0
replace femalexzdzchinese_neg=femalexzdzchinese if dzchinese<0

gen zdzchinese_pos = 0
replace zdzchinese_pos = zdzchinese if dzchinese>=0

gen zdzchinese_neg = 0
replace zdzchinese_neg = zdzchinese if dzchinese<0

egen postcodexfemale = group(postcode female)

/*Day 1 exam*/
set more off
xi: areg zdzmath femalexzdzchinese_pos femalexzdzchinese_neg zdzchinese_pos zdzchinese_neg female i.schoolcode*female i.female*month, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese_pos femalexzdzchinese_neg zdzchinese_pos zdzchinese_neg using at13, bdec(3) se br excel replace
test femalexzdzchinese_pos = femalexzdzchinese_neg

xi: areg zdzmath femalexzdzchinese_pos femalexzdzchinese_neg zdzchinese_pos zdzchinese_neg female i.schoolcode*female i.female*month if cutoff3==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese_pos femalexzdzchinese_neg zdzchinese_pos zdzchinese_neg using at13, bdec(3) se br excel append
test femalexzdzchinese_pos = femalexzdzchinese_neg

xi: areg zdzmath femalexzdzchinese_pos femalexzdzchinese_neg zdzchinese_pos zdzchinese_neg female i.schoolcode*female i.female*month  if cutoff5==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese_pos femalexzdzchinese_neg zdzchinese_pos zdzchinese_neg using at13, bdec(3) se br excel append
test femalexzdzchinese_pos = femalexzdzchinese_neg

xi: areg zdzmath femalexzdzchinese_pos femalexzdzchinese_neg zdzchinese_pos zdzchinese_neg female i.schoolcode*female i.female*month if cutoff610==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese_pos femalexzdzchinese_neg zdzchinese_pos zdzchinese_neg using at13, bdec(3) se br excel append
test femalexzdzchinese_pos = femalexzdzchinese_neg

xi: areg zdzmath femalexzdzchinese_pos femalexzdzchinese_neg zdzchinese_pos zdzchinese_neg female i.schoolcode*female i.female*month if cutoff1120==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese_pos femalexzdzchinese_neg zdzchinese_pos zdzchinese_neg using at13, bdec(3) se br excel append
test femalexzdzchinese_pos = femalexzdzchinese_neg
******************************************************************************************************
************************************END***************************************************************
******************************************************************************************************
