*Repeat the ENET analysis for the MMP107 (2005)*
*Use life dataset in the MMP: it records person-year observations*
clear
capture log close
set matsize 800
set memory 900m
log using mmpruralurbanlife.log, replace

*Opening the personal data to merge it later with the life data*
use "c:\DATA\MMP\pers107.dta", clear
keep if relhead==1
sort country commun surveypl surveyyr hhnum
save pers107heads, replace

use "c:\DATA\MMP\life107.dta", clear

*Restrict the dataset to observations in the 2000-2004 period*
drop if year < 2000

/*Survey commands*/
svyset, clear
svyset [pweight=weight]

*File of community sizes*
sort commun
merge commun using commun107, uniqusing

*Identify rural communities (less than 2,500 inhabitants)*
gen rural = (metrocat==4)

*Age variable*
ren age edad

*Migration variable (migrants between 2000 and 2004*
gen mig = 0
replace mig = 1 if usyr1 == year
replace mig = 1 if usyrl == year

*Rural migrants in the survey*
svy: mean rural
svy, subpop(if mig == 1): mean rural

*Sex variable*
gen mujer = 0
replace mujer = 1 if sex == 2

*Creating schooling years*
gen schoolyears = educ
replace schoolyears = . if educ == 9999

*Labor force participation*
gen laborforce = 0
replace laborforce = 1 if (occup > 99 & occup < 9999)
replace laborforce = 1 if (occup == 10)
replace laborforce = . if occup == 9999

*Unemployment*
gen paro = 0 if laborforce == 1
replace paro = 1 if occup == 10

*Work in agriculture*
gen agriculture = 0 if laborforce == 1
replace agriculture = 1 if (occup > 409 & occup <420)
replace agriculture = . if occup == 9999

*You have to merge the pers107 dataset to get information on wages in Mexico*
drop _merge
sort country commun surveypl surveyyr hhnum
merge country commun surveypl surveyyr hhnum using pers107heads, keep(ldowage v22) uniqusing

*Creating the wage variable as hourly wages following Chiquiar and Hanson (2005)*
gen hwage = .
replace hwage = ldowage if ldowage > 0 & ldowage ~= 9999 & v22 == 1
replace hwage = ldowage/8 if ldowage > 0 & ldowage ~= 9999 & v22 == 2
replace hwage = ldowage/(5*8) if ldowage > 0 & ldowage ~= 9999 & v22 == 3
replace hwage = ldowage/(5*8*2.25) if ldowage > 0 & ldowage ~= 9999 & v22 == 4
replace hwage = ldowage/(5*8*4.5) if ldowage > 0 & ldowage ~= 9999 & v22 == 5
replace hwage = ldowage/(5*8*4.5*12) if ldowage > 0 & ldowage ~= 9999 & v22 == 6
replace hwage = . if v22 == 8888
replace hwage = . if v22 == 9999

*Erase wage observations from people qualified as unemployed or not in the labor force*
replace hwage = . if paro == 1
replace hwage = . if laborforce == 0

/*Calculate the percentage of wage earners in the data*/
gen wageearner = 0
replace wageearner = 1 if hwage ~= .

*Create real wage series (1 January 2006 dollars) Exchange rate from IFS=10.7777*
*Use inflation data from the INPC series in Banxico (quarterly averages base June 2002) and bring them to December 2005=116.301*
gen rhwage = .
replace rhwage = (hwage*116.301)/(10.7777*89.71129943) if surveyyr == 2000
replace rhwage = (hwage*116.301)/(10.7777*95.42387876) if surveyyr == 2001
replace rhwage = (hwage*116.301)/(10.7777*100.2243989) if surveyyr == 2002
replace rhwage = (hwage*116.301)/(10.7777*104.7815) if surveyyr == 2003
replace rhwage = (hwage*116.301)/(10.7777*109.6940833) if surveyyr == 2004

_pctile rhwage [pw=weight], percentiles(.5 99.5)

*Suppressing the .5% largest and smallest values following Hanson (2006)*
replace rhwage = . if rhwage < r(r1)
replace rhwage = . if rhwage > r(r2)

gen lhwage = log(rhwage)

*Variable reflecting if the individual had migration experience*
gen migexp = (usyr1<year)

save mmp107heads, replace
