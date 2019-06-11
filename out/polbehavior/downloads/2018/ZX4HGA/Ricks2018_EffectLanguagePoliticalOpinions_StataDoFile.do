** These commands replicate analysis in Jacob I. Ricks, "The Effect of Language on Political Appeal" **
**
** 



* get and process the data
clear all 
use "________YOUR PATH HERE________"

* descriptive statistics and covariate balance across treatment groups (Table 2)

sort reclip
by reclip: sum age
by reclip: sum male
by reclip: sum inc2014
by reclip: sum edu
by reclip: sum pt1
by reclip: sum isanhome

hotelling age male inc2014 edu pt1 isanhome, by(BSTIST)
hotelling age male inc2014 edu pt1 isanhome, by(isanIST)
hotelling age male inc2014 edu pt1 isanhome, by(isanBST)

* exploratory factor analysis (found in appendix) 

factor sp1 sp2 sp3 sp4 sp5 sp6 sp7 sp8 sp9 sp10 sp11 sp12 sp13 sp14, pcf
rotate, blank(0.1)

*** Chronbach alpha's 

alpha sp8 sp11 sp12 sp13 sp14, std item
alpha sp1 sp2 sp3 sp9, std item
alpha sp4 sp5 sp6 sp7 sp10, std item

*** generate three factor variables (electoral support, kinship, fitness for office)

factor sp8 sp11 sp12 sp13 sp14, pcf
rotate
predict electsup

factor sp1 sp2 sp3 sp9, pcf
rotate
predict kinship

factor sp4 sp5 sp6 sp7 sp10, pcf
rotate
predict fitness

* generate treatment effects with BST at baseline (Table 3) 

** Isan vs BST, For interpreting numbers, remember that BST = 0 & ISAN = 1

ttest electsup, by(isanBST)
ttest sp8, by(isanBST)
ttest sp11, by(isanBST)
ttest sp12, by(isanBST)
ttest sp13, by(isanBST)
ttest sp14, by(isanBST)

ttest kinship, by(isanBST)
ttest sp1, by(isanBST)
ttest sp2, by(isanBST)
ttest sp3, by(isanBST)
ttest sp9, by(isanBST)

ttest fitness, by(isanBST)
ttest sp4, by(isanBST)
ttest sp5, by(isanBST)
ttest sp6, by(isanBST)
ttest sp7, by(isanBST)
ttest sp10, by(isanBST)

** IST vs BST, For interpreting numbers, remember that BST = 1 & IST = 0 

ttest electsup, by(BSTIST)
ttest sp8, by(BSTIST)
ttest sp11, by(BSTIST)
ttest sp12, by(BSTIST)
ttest sp13, by(BSTIST)
ttest sp14, by(BSTIST)

ttest kinship, by(BSTIST)
ttest sp1, by(BSTIST)
ttest sp2, by(BSTIST)
ttest sp3, by(BSTIST)
ttest sp9, by(BSTIST)

ttest fitness, by(BSTIST)
ttest sp4, by(BSTIST)
ttest sp5, by(BSTIST)
ttest sp6, by(BSTIST)
ttest sp7, by(BSTIST)
ttest sp10, by(BSTIST)


* alternative tests (appendix)

** ordered logit results, supplementary table 3 and supplementary table 4

ologit sp1 i.clip age loginc sex edu pt isanhome i.prov, robust

ologit sp2 i.clip age loginc sex edu pt isanhome i.prov, robust

ologit sp3 i.clip age loginc sex edu pt isanhome i.prov, robust

ologit sp4 i.clip age loginc sex edu pt isanhome i.prov, robust

ologit sp5 i.clip age loginc sex edu pt isanhome i.prov, robust

ologit sp6 i.clip age loginc sex edu pt isanhome i.prov, robust

ologit sp7 i.clip age loginc sex edu pt isanhome i.prov, robust

ologit sp8 i.clip age loginc sex edu pt isanhome i.prov, robust

ologit sp9 i.clip age loginc sex edu pt isanhome i.prov, robust

ologit sp10 i.clip age loginc sex edu pt isanhome i.prov, robust

ologit sp11 i.clip age loginc sex edu pt isanhome i.prov, robust

ologit sp12 i.clip age loginc sex edu pt isanhome i.prov, robust

ologit sp13 i.clip age loginc sex edu pt isanhome i.prov, robust

ologit sp14 i.clip age loginc sex edu pt isanhome i.prov, robust

ologit sp15 i.clip age loginc sex edu pt isanhome i.prov, robust

ologit sp16 i.clip age loginc sex edu pt isanhome i.prov, robust


** marginal effects plots

*** generate dummy variables, collapse "strongly agree" & "agree" responses into 1, all others into 0

gen dummy1=1 if sp1==4 | sp1==5
replace dummy1 = 0 if sp1 ==1 | sp1 == 2 | sp1 == 3

gen dummy2=1 if sp2==4 | sp2==5
replace dummy2 = 0 if sp2 ==1 | sp2 == 2 | sp2 == 3

gen dummy3=1 if sp3==4 | sp3==5
replace dummy3 = 0 if sp3 ==1 | sp3 == 2 | sp3 == 3

gen dummy4=1 if sp4==4 | sp4==5
replace dummy4 = 0 if sp4 ==1 | sp4 == 2 | sp4 == 3

gen dummy5=1 if sp5==4 | sp5==5
replace dummy5 = 0 if sp5 ==1 | sp5 == 2 | sp5 == 3

gen dummy6=1 if sp6==4 | sp6==5
replace dummy6 = 0 if sp6 ==1 | sp6 == 2 | sp6 == 3

gen dummy7=1 if sp7==4 | sp7==5
replace dummy7 = 0 if sp7 ==1 | sp7 == 2 | sp7 == 3

gen dummy8=1 if sp8==4 | sp8==5
replace dummy8 = 0 if sp8 ==1 | sp8 == 2 | sp8 == 3

gen dummy9=1 if sp9==4 | sp9==5
replace dummy9 = 0 if sp9 ==1 | sp9 == 2 | sp9 == 3

gen dummy10=1 if sp10==4 | sp10==5
replace dummy10 = 0 if sp10 ==1 | sp10 == 2 | sp10 == 3

gen dummy11=1 if sp11==4 | sp11==5
replace dummy11 = 0 if sp11 ==1 | sp11 == 2 | sp11 == 3

gen dummy12=1 if sp12==4 | sp12==5
replace dummy12 = 0 if sp12 ==1 | sp12 == 2 | sp12 == 3

gen dummy13=1 if sp13==4 | sp13==5
replace dummy13 = 0 if sp13 ==1 | sp13 == 2 | sp13 == 3

gen dummy14=1 if sp14==4 | sp14==5
replace dummy14 = 0 if sp14 ==1 | sp14 == 2 | sp14 == 3

gen dummy15=1 if sp15==4 | sp15==5
replace dummy15 = 0 if sp15 ==1 | sp15 == 2 | sp15 == 3

gen dummy16=1 if sp16==4 | sp16==5
replace dummy16 = 0 if sp16 ==1 | sp16 == 2 | sp16 == 3


*** create margins for Isan vs BST, For interpreting numbers, remember that BST = 0 & ISAN = 1

logit dummy1 i.isanBST age male loginc edu pt isanhome i.prov
margins, dydx(isanBST)

logit dummy2 i.isanBST age male loginc edu pt isanhome i.prov
margins, dydx(isanBST)

logit dummy3 i.isanBST age male loginc edu pt isanhome i.prov
margins, dydx(isanBST)

logit dummy4 i.isanBST age male loginc edu pt isanhome i.prov
margins, dydx(isanBST)

logit dummy5 i.isanBST age male loginc edu pt isanhome i.prov
margins, dydx(isanBST)

logit dummy6 i.isanBST age male loginc edu pt isanhome i.prov
margins, dydx(isanBST)

logit dummy7 i.isanBST age male loginc edu pt isanhome i.prov
margins, dydx(isanBST)

logit dummy8 i.isanBST age male loginc edu pt isanhome i.prov
margins, dydx(isanBST)

logit dummy9 i.isanBST age male loginc edu pt isanhome i.prov
margins, dydx(isanBST)

logit dummy10 i.isanBST age male loginc edu pt isanhome i.prov
margins, dydx(isanBST)

logit dummy11 i.isanBST age male loginc edu pt isanhome i.prov
margins, dydx(isanBST)

logit dummy12 i.isanBST age male loginc edu pt isanhome i.prov
margins, dydx(isanBST)

logit dummy13 i.isanBST age male loginc edu pt isanhome i.prov
margins, dydx(isanBST)

logit dummy14 i.isanBST age male loginc edu pt isanhome i.prov
margins, dydx(isanBST)

logit dummy15 i.isanBST age male loginc edu pt isanhome i.prov
margins, dydx(isanBST)

logit dummy16 i.isanBST age male loginc edu pt isanhome i.prov
margins, dydx(isanBST)


*** create margins for IST vs BST, For interpreting numbers, remember that BST = 1 & IST = 0

logit dummy1 i.BSTIST age male loginc edu pt isanhome i.prov
margins, dydx(BSTIST)

logit dummy2 i.BSTIST age male loginc edu pt isanhome i.prov
margins, dydx(BSTIST)

logit dummy3 i.BSTIST age male loginc edu pt isanhome i.prov
margins, dydx(BSTIST)

logit dummy4 i.BSTIST age male loginc edu pt isanhome i.prov
margins, dydx(BSTIST)

logit dummy5 i.BSTIST age male loginc edu pt isanhome i.prov
margins, dydx(BSTIST)

logit dummy6 i.BSTIST age male loginc edu pt isanhome i.prov
margins, dydx(BSTIST)

logit dummy7 i.BSTIST age male loginc edu pt isanhome i.prov
margins, dydx(BSTIST)

logit dummy8 i.BSTIST age male loginc edu pt isanhome i.prov
margins, dydx(BSTIST)

logit dummy9 i.BSTIST age male loginc edu pt isanhome i.prov
margins, dydx(BSTIST)

logit dummy10 i.BSTIST age male loginc edu pt isanhome i.prov
margins, dydx(BSTIST)

logit dummy11 i.BSTIST age male loginc edu pt isanhome i.prov
margins, dydx(BSTIST)

logit dummy12 i.BSTIST age male loginc edu pt isanhome i.prov
margins, dydx(BSTIST)

logit dummy13 i.BSTIST age male loginc edu pt isanhome i.prov
margins, dydx(BSTIST)

logit dummy14 i.BSTIST age male loginc edu pt isanhome i.prov
margins, dydx(BSTIST)

logit dummy15 i.BSTIST age male loginc edu pt isanhome i.prov
margins, dydx(BSTIST)

logit dummy16 i.BSTIST age male loginc edu pt isanhome i.prov
margins, dydx(BSTIST)


** repeated means tests with only Isan speakers, this repeats the analysis above after removing all those who do not speak Isan at either work or home from the data
** this also saves the data file as a reduced file 

keep if speakisan==1
save "________YOUR PATH HERE________" 

* descriptive statistics and covariate balance across treatment groups (Supplementary Table 5)

sort reclip
by reclip: sum age
by reclip: sum male
by reclip: sum inc2014
by reclip: sum edu
by reclip: sum pt1
by reclip: sum isanhome

hotelling age male inc2014 edu pt1 isanhome, by(BSTIST)
hotelling age male inc2014 edu pt1 isanhome, by(isanIST)
hotelling age male inc2014 edu pt1 isanhome, by(isanBST)

* generate treatment effects with BST at baseline (Supplementary Table 6) 

** Isan vs BST, For interpreting numbers, remember that BST = 0 & ISAN = 1

ttest electsup, by(isanBST)
ttest sp8, by(isanBST)
ttest sp11, by(isanBST)
ttest sp12, by(isanBST)
ttest sp13, by(isanBST)
ttest sp14, by(isanBST)

ttest kinship, by(isanBST)
ttest sp1, by(isanBST)
ttest sp2, by(isanBST)
ttest sp3, by(isanBST)
ttest sp9, by(isanBST)

ttest fitness, by(isanBST)
ttest sp4, by(isanBST)
ttest sp5, by(isanBST)
ttest sp6, by(isanBST)
ttest sp7, by(isanBST)
ttest sp10, by(isanBST)

** IST vs BST, For interpreting numbers, remember that BST = 1 & IST = 0 

ttest electsup, by(BSTIST)
ttest sp8, by(BSTIST)
ttest sp11, by(BSTIST)
ttest sp12, by(BSTIST)
ttest sp13, by(BSTIST)
ttest sp14, by(BSTIST)

ttest kinship, by(BSTIST)
ttest sp1, by(BSTIST)
ttest sp2, by(BSTIST)
ttest sp3, by(BSTIST)
ttest sp9, by(BSTIST)

ttest fitness, by(BSTIST)
ttest sp4, by(BSTIST)
ttest sp5, by(BSTIST)
ttest sp6, by(BSTIST)
ttest sp7, by(BSTIST)
ttest sp10, by(BSTIST)


