clear

set more off

use "nceer3.dta" 

/**Dvs 
USA opinion:usa (q15), q102 -> becomes usop1 usop2
US harm or good: q34l, q103l -> usharm1 usharm2
Country support US: q35, q104l -> ussup1 ussup2
Approve US methods: q36, q105 -> usapp1 usapp2
Agree with statement: q40
**/

gen usop1=usa if usa<6
gen usop2=q102 if q102<6

label values usop1 gopos
label values usop2 gopos

gen usharm1=-1*q34l+6 if q34l<6
gen usharm2=-1*q103l+6 if q103l<6

label define noharm 5 "much more good than harm" 4 "more good than harm" 3 "same" 2 "more harm than good" 1 "much more harm than good"
label values usharm1 noharm
label values usharm2 noharm

gen ussup1=q35 if q35<6
gen ussup2=q104l if q104l<6

label values ussup1 idear
label values ussup2 idear

gen usapp1=-1*q36+6 if q36<6
gen usapp2=-1*q105+6 if q105<6

label define rappus 5 "Str Approve" 4 Approve 3 Neutral 2 Disapprove 1 "Str Disapprove" 6 "No opinion"

label values usapp1 rappus
label values usapp2 rappus

/**Creates index using all four variables measuring opinion towards US**/
alpha usop1 usharm1 ussup1 usapp1, gen(usindexpre4)
alpha usop2 usharm2 ussup2 usapp2, gen(usindexpos4)

/**Creates index using three US opinion variables. Drops usop because this was asked before manipulation. This way index measures opinions after manipulation, and after manipulation AND discussion**/
alpha usharm1 ussup1 usapp1, gen(usindexpre3)
alpha usharm2 ussup2 usapp2, gen(usindexpos3)

/**US opinion Change**/
gen usopchg=usop2-usop1
gen usharmchg=usharm2-usharm1
gen ussupchg=ussup2-ussup1
gen usappchg=usapp2-usapp1
gen usindex3chg=usindexpos3-usindexpre3
gen usindex4chg=usindexpos4-usindexpre4

/**Recode q39, q40 and q42 for regression interactions so that no-quotation category is equal to zero**/
gen q39r=q39-1
replace q39r=0 if cond==5
gen q40r=q40-1
replace q40r=0 if cond==5

recode q42 1=4 2=3 3=2 4=1 5=0, gen(q42rev)
recode q42 1=2 2=1 3/5=0, gen(q42rev3)

gen q42r=q42-1
replace q42r=0 if cond==5

gen bushq42=bush*q42r
gen ambq42=ambd*q42r
gen ordamq42=ordam*q42r
gen noattq42=noatt*q42r

egen us4group=mean(usindexpre4), by(groupn)
egen us4loc=mean(usindexpre4), by(location)
egen ussd4group=sd(usindexpre4), by(groupn)
egen ussd4loc=sd(usindexpre4), by(location)

char cond[omit] 5
/**omit kulyab- lowest value on q40 and fourth value on preindex**/
char location[omit] 5

log using "isq-tables.log", replace

/**Check distribution of stimuli across groups. Always 1-3 in each group except once with no one with "no quotation." **/
tab groupn cond

/**p6 (fn 10): Creates index using all four variables measuring opinion towards US**/
alpha usop1 usharm1 ussup1 usapp1
alpha usop2 usharm2 ussup2 usapp2
corr usindexpre4 usindexpos4

/** Table 1: Mean by treatment **/
tabstat q40 usindexpre4 usindexpos4, stats(mean) by(cond) f(%5.3f)
/** Comments on Table 1 (pp. 8-9, including fn 12, 13 and 14) **/
ttest q40 if cond==1 | cond==4, by(cond)
ttest q40, by(bush)
ttest usindexpre4, by(bush)
/**reference taken out in final draft**/
oneway usindexpre4 cond, tab
ttest usindexpre4, by(noq)

/**Difference between usop1 and usop2 pg 9**/
tab usopchg

/**More consensus views of the US. SD of index is reported, but results are similar for direct question- USOP. 
Fewer strongly negative opinions can be seen with the changes before/after discussion at the 10th & 90th percentile **/
tabstat usop1 usop2 usindexpre4 usindexpos4, s(mean p10 median p90 sd iqr) c(s) f(%5.3g)
sdtest usindexpre4=usindexpos4
sdtest usop2=usop1

/**Regression to the mean discussion on pg 9, fn 15 
(Controls are ambiguous- corr is the same for no attribution and no quote**/
corr usindexpre4 usindexpos4 if bush==1
corr usindexpre4 usindexpos4 if noatt==1
corr usindexpre4 usindexpos4 if noq==1
corr usindexpre4 usindexpos4 if noq==1 | noatt==1

/** Table 2 Pre Discussion and Post Discussion DV= index **/
xi: regress usindexpre4 bush ambd ordam noatt i.location q7 relig age educ2
estimates store rgpre4f
xi: regress usindexpos4 bush ambd ordam noatt i.location us4group ussd4group usindexpre4
estimates store rgpos4s

estimates table rgpre4f rgpos4s, b(%6.3f) star (.01 .05 .1)

/** Appendix **/
sum usop1 usharm1 ussup1 usapp1 usindexpre4 usop2 usharm2 ussup2 usapp2 usindexpos4
tab groupn location
tab groupn cond
sum usindexpos4 if usindexpre4~=.
table groupn, c(mean female mean age mean q7 mean relig mean usindexpre4) f(%5.2g)
tabstat female age q7 relig usindexpre4, s(mean) f(%5.2g)
log close


