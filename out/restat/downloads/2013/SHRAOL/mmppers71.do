*Analysis of the MMP71 following McKenzie and Rapoport*
*Use pers dataset in the MMP: characteristics do not need to coincide with the survey year*
clear
capture log close
set matsize 800
set memory 900m
log using mmppers71.log, replace

*Opening the personal data*
use "c:\DATA\MMP\pers107.dta", clear

*Restrict the dataset to observations in the MMP71*
*drop if commun > 71*

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

*Migration variable: household heads who have never migrated or who migrated two years before the survey*
gen mig = 0 if usyr1==8888
replace mig = 1 if usyr1 > surveyyr - 2 & usyr1 < 8888

*Rural migrants in the survey*
svy: mean rural
svy, subpop(if mig == 1): mean rural

*Sex variable*
gen mujer = 0
replace mujer = 1 if sex == 2

*Creating schooling years*
gen schoolyears = edyrs
replace schoolyears = . if edyrs == 8888 
replace schoolyears = . if edyrs == 9999 

*Labor force participation*
gen laborforce = 0
replace laborforce = 1 if (occ > 99 & occ < 9999)
replace laborforce = 1 if (occ == 10)
replace laborforce = . if occ == 9999

*Unemployment*
gen paro = 0 if laborforce == 1
replace paro = 1 if occ == 10

*Work in agriculture*
gen agriculture = 0 if laborforce == 1
replace agriculture = 1 if (occ > 409 & occ <420)
replace agriculture = . if occ == 9999

save mmp71allmr, replace
