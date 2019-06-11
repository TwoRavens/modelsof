******************************
***CCES SIMULATION VARIABES***
******************************

*Working Directory
cd "D:\Informant Paper\political_analysis\Replication Materials"

***************
***CCES DATA***
***************

*CCES-CC Data
use D:\Data\CCES\2010\CCes_2010_common_validated.dta, clear 

*************************************
***ADDING DISTRICT-LEVEL VARIABLES***
*************************************

*State FIPS Code
destring V302, g(state)

*Merging FIPS Code Data
merge m:1 state using "D:\Data\District Data\fips_state_code.dta", 
keep if _merge==3
drop _merge

*Creating District Variable
replace V276="AL" if V276=="00"
egen district=concat(state_abr V276)

*2010 District Data
merge m:1 district using "District-Level Data.dta"
keep if _merge==3
drop _merge

********************************
***INDIVIDUAL-LEVEL VARIABLES***
********************************

*PID
recode V212d 1/3=-1 4 8=0 5/7=1, g(pid3)

*Placing Candidates on Ideology
recode CC334J 8=., g(dlc_voter)
recode CC334K 8=., g(rlc_voter)

*Incumbent Ideology Error
g inclc=rlc_voter if repinc10==1&incran10==1
replace inclc=dlc_voter if deminc10==1&incran10==1
drop if inclc==.
reg nominate10 inclc
predict ince, resid
replace ince=abs(ince)

*Fixing Senator names CCES uses inconsistently
replace V513="John McCain" if V513=="John McCain, III"
replace V551="Charles Grassley" if V551=="Chuck Grassley"
replace V551="Richard Shelby" if V551=="Richard C. Shelby"
replace V551="Michael Crapo" if V551=="Mike Crapo"
replace V551="John Isakson" if V551=="Johnny Isakson"
replace V521="Charles E. Schumer" if V521=="Chuck Schumer"
replace V548="Blanche Lincoln" if V548=="Blanche Lambert Lincoln"
replace V548="Barbara Mikulski" if V548=="Barbara A. Mikulski"
replace V548="Daniel Inouye" if V548=="Daniel K. Inouye"
replace V548="Michael Bennet" if V548=="Michael F. Bennet"
replace V551="John Thune" if V551=="John R. Thune"
replace V558="Kirsten Gillibrand" if V558=="Kirsten E. Gillibrand"

*Linking incumbent senators to candidate senators
g sen1repsen1=0
replace sen1repsen1=1 if V513== V551
g sen1demsen1=0
replace sen1demsen1=1 if V513== V548
g sen2repsen1=0
replace sen2repsen1=1 if V521== V551
g sen2demsen1=0
replace sen2demsen1=1 if V521== V548
g sen1demsen2=0
replace sen1demsen2=1 if V513== V558

*Senator Ideology
g sen1lc=CC334F
g sen2lc=CC334G 
replace sen1lc=CC334H if sen1demsen1==1
replace sen1lc=CC334I if sen1repsen1==1
replace sen2lc=CC334H if sen2demsen1==1
replace sen2lc=CC334I if sen2repsen1==1
replace sen1lc=CC334Hb if sen1demsen2==1
recode sen1lc 8=.
recode sen2lc 8=.

*Incumbent Party
g increc=0
replace increc=1 if CC310d==2&V502=="Republican"
replace increc=1 if CC310d==3&V502=="Democratic"

*Political Knowledge
recode CC309a (2=1)(1 3 4/8=0), g(know1)
recode CC309b (2=1)(1 3 4/8=0), g(know2)
g know3=0 if CC309c!=.
replace know3=1 if CC309c==1&statesenate_pid==3|CC309c==2&statesenate_pid==1|CC309c==3&statesenate_pid==4|CC309c==3&statesenate_pid==2
g know4=0 if CC309d!=.
replace know4=1 if CC309d==1&statesenate_pid==3|CC309d==2&statesenate_pid==1|CC309d==3&statesenate_pid==4|CC309d==3&statesenate_pid==2
gen know5=1 if CC310a==2&V530=="Republican"
replace know5=1 if CC310a==3&V530=="Democratic"
replace know5=0 if CC310a==2&V530=="Democratic"
replace know5=0 if CC310a==3&V530=="Republican"
replace know5=0 if CC310a==1
replace know5=0 if CC310a>3&CC310a!=.
gen know6=1 if CC310b==2&V514=="Republican"|CC310b==3&V514=="Democratic"|CC310b==4&V514=="Independent"
replace know6=0 if CC310b==1|CC310b==5
replace know6=0 if CC310b==3&V514=="Republican"|CC310b==2&V514=="Democratic"|CC310b==4&V514=="Democratic"|CC310b==4&V514=="Republican"
replace know6=0 if CC310b==2&V514=="Independent"|CC310b==3&V514=="Independent"
gen know7=1 if CC310c==2&V522=="Republican"|CC310c==3&V522=="Democratic"
replace know7=0 if CC310c==1|CC310c>3&CC310c<10
replace know7=0 if CC310c==3&V522=="Republican"|CC310c==2&V522=="Democratic"
egen know=rowmean(know1-know7)

*News 
foreach var of varlist  CC301_1 CC301_2 CC301_3 CC301_4 {
	recode `var' 2=0
}
egen news=rowmean(CC301_1 CC301_2 CC301_3 CC301_4)

*Participation
foreach var of varlist CC417a_1 CC417a_2 CC417a_3 CC417a_4 {
	recode `var' 2=0
}
egen active=rowmean(CC417a_1 CC417a_2 CC417a_3 CC417a_4)

*Interest
recode V244 1=4 2=3 3=2 4 7=1, g(interest)

*Candidate for office
g candidate=0
foreach n of numlist 1(1)10 {
	replace candidate=1 if CC418bx_`n'==1 
}

*Expertise Index
foreach var of varlist increc know news interest active know1-know7 interest CC417a_1 CC417a_2 CC417a_3 CC417a_4 CC301_1 CC301_2 CC301_3 CC301_4{
	sum `var'
	replace `var'=(`var'-r(mean))/r(sd)
}
alpha increc know1-know7 interest CC417a_1 CC417a_2 CC417a_3 CC417a_4 CC301_1 CC301_2 CC301_3 CC301_4, g(expertise)

*Expertise - Cleaning Up
recode01 expertise
replace expertise=(expertise*99)+1
drop if expertise==.

*Expertise Indicators
g random=1
g expert=0
centile expertise, centile(50)
replace expert=1 if expertise>r(c_1)

*District Count
egen expert_n=sum(expert), by(district)

********************
***MEDIAN CUTOFFS***
********************

*District-level Variables
save temp1, replace
collapse nominate10 nominate10se term111 repinc10 deminc10 absdistpartymediannominate, by(district)


*Dummy Variable
egen absdistpartymediannominate_D=cut(absdistpartymediannominate), group(2)

*Cleaning Up
keep district absdistpartymediannominate*
save temp2, replace

*Adding Candidate-LeVel Data to CCEs
use temp1, clear
merge m:1 district using temp2

************
***SAVING***
************

*Cleaning up
keep term111 absdistpartymediannominate* inclc sen* expert expert_n random expertise pid3 rlc_voter dlc_voter repinc10 deminc10 incran10 nominate10* district
compress
save "CCES Data", replace
erase temp1.dta
erase temp2.dta 
