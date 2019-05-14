*NOTE: In replication data, variable okpo is not actual firm identifier okpo and should not be used for matching with other data.

version 10
cd "/Users/gehlbach/Dropbox/Data/Russian Enterprise/Replication"
clear
set mem 1000m
set matsize 800


/* CREATE DATA */

/* create priv */
use full
duplicates drop okpo year, force
drop if ter == 1126 | ter == 1177 | ter == 1196 
gen lso = 1
replace lso = 0 if ldo == 1 | lfo == 1

/* region interactions */
foreach i of numlist 1 3/5 7 8 10/12 14 15 17/20 22 24/25 27/30 32/34 36/38 40/42 44/47 49 50 52/54 56/58 60 61 63/66 68/71 73 75 76 78/95 97/99 {
gen ter`i' = 1 if ter == 1100 + `i'
replace ter`i' = 0 if ter ~= 1100 + `i'
}
foreach i of numlist 1 3/5 7 8 10/12 14 15 17/20 22 24/25 27/30 32/34 36/38 40/42 44/47 49 50 52/54 56/58 60 61 63/66 68/71 73 75 76 78/95 97/99 {
gen lso_ter`i' = lso*ter`i'
}
foreach i of numlist 1 3/5 7 8 10/12 14 15 17/20 22 24/25 27/30 32/34 36/38 40/42 44/47 49 50 52/54 56/58 60 61 63/66 68/71 73 75 76 78/95 97/99 {
gen ldo_ter`i' = ldo*ter`i'
}
foreach i of numlist 1 3/5 7 8 10/12 14 15 17/20 22 24/25 27/30 32/34 36/38 40/42 44/47 49 50 52/54 56/58 60 61 63/66 68/71 73 75 76 78/95 97/99 {
gen dtldo_ter`i' = dtldo*ter`i'
}

/* industry interactions (demeaned so that privatization effect is for firm in "average" sector) */
forv i = 1(1)10 {
gen ind`i' = 1 if ind == `i'
replace ind`i' = 0 if ind ~= `i'
}
forv i = 1(1)10 {
egen ind`i'mean = mean(ind`i')
}
forv i = 1(1)10 {
gen dm`i' = ind`i'-ind`i'mean
}
forv i = 1(1)10 {
gen lso_dm`i' = lso*dm`i'
}
forv i = 1(1)10 {
gen ldo_dm`i' = ldo*dm`i'
}
forv i = 1(1)10 {
gen dtldo_dm`i' = dtldo*dm`i'
}

/* region*size interactions */
gen large = 0
replace large = 1 if small == 0
replace large = . if small == .
foreach i of numlist 1 3/5 7 8 10/12 14 15 17/20 22 24/25 27/30 32/34 36/38 40/42 44/47 49 50 52/54 56/58 60 61 63/66 68/71 73 75 76 78/95 97/99 {
gen s_dtldo_ter`i' = small*dtldo_ter`i'
}


/* BASELINE REGRESSIONS */

/* OLS model */
xi, noomit: reg lsale lso_t* ldo_t* lfo lso_dm* ldo_dm* e1-e10 c1-c10 iyr*, cluster(okpo) noconstant
preserve
matrix b = e(b)'
matrix lsoOLS = b[1..77,1]
matrix ldoOLS = b[78..154,1]
matrix V = e(V)
matrix VlsoOLS = V[1..77,1..77]
matrix VldoOLS = V[78..154,78..154]
matrix SE2lsoOLS = vecdiag(VlsoOLS)'
matrix SE2ldoOLS = vecdiag(VldoOLS)'
svmat lsoOLS
svmat ldoOLS
svmat VlsoOLS
svmat VldoOLS
svmat SE2lsoOLS
svmat SE2ldoOLS
rename lsoOLS1 lsoOLS
rename ldoOLS1 ldoOLS
rename SE2lsoOLS1 SE2lsoOLS
rename SE2ldoOLS1 SE2ldoOLS
keep in 1/77
order lsoOLS SE2lsoOLS VlsoOLS* ldoOLS SE2ldoOLS VldoOLS*
keep lsoOLS-VldoOLS77
save OLSmatrix, replace
restore

/* FEFT model */
set more off
reg dtlsale dtldo_t* dtlfo dtldo_dm* dte1-dte10 dtc1-dtc10 dtiyr*, cluster(okpo)
preserve
matrix b = e(b)'
matrix privDT = b[1..77,1]
matrix V = e(V)
matrix VprivDT = V[1..77,1..77]
matrix SE2privDT = vecdiag(VprivDT)'
svmat privDT
svmat VprivDT
svmat SE2privDT
rename privDT1 privDT
rename SE2privDT1 SE2privDT
keep in 1/77
order privDT SE2privDT VprivDT* 
keep privDT-VprivDT77
save DTmatrix, replace
restore

/* FEFT model, small vs. large */
*drop regions with no small privatizations
egen meansmall = mean(small) if ldo == 1, by(ter)
egen incsmall = max(meansmall), by(ter)
replace incsmall = 1 if incsmall > 0
tab ter if incsmall == 0
*one region: ter == 1144
#delimit ;
reg dtlsale 
s_dtldo_ter1-s_dtldo_ter42 
s_dtldo_ter45-s_dtldo_ter99 
dtldo_ter1-dtldo_ter42
dtldo_ter45-dtldo_ter99 
dtldo_dm1-dtldo_dm10
dtlfo dte1 dte2 dte3 dte4 dte5 dte6 dte7 dte8 dte9 dte10 
dtc1 dtc2 dtc3 dtc4 dtc5 dtc6 dtc7 dtc8 dtc9 dtc10 dtiyr* 
if ter ~= 1144, cluster(okpo);
#delimit cr
preserve
matrix b = e(b)'
matrix sprivDT = b[1..76,1]
matrix V = e(V)
matrix VsprivDT = V[1..76,1..76]
matrix SE2sprivDT = vecdiag(VsprivDT)'
svmat sprivDT
svmat VsprivDT
svmat SE2sprivDT
rename sprivDT1 sprivDT
rename SE2sprivDT1 SE2sprivDT
keep in 1/76
order sprivDT SE2sprivDT VsprivDT* 
keep sprivDT-VsprivDT76
save sDTmatrix, replace
restore

/* FEFT model, only fever == 0 */
reg dtlsale dtldo_t* dtldo_dm* dte1-dte10 dtc1-dtc10 dtiyr* if fever == 0, cluster(okpo)
preserve
matrix b = e(b)'
matrix privDTnof = b[1..77,1]
matrix V = e(V)
matrix VprivDTnof = V[1..77,1..77]
matrix SE2privDTnof = vecdiag(VprivDTnof)'
svmat privDTnof
svmat VprivDTnof
svmat SE2privDTnof
rename privDTnof1 privDTnof
rename SE2privDTnof1 SE2privDTnof
keep in 1/77
order privDTnof SE2privDTnof VprivDTnof* 
keep privDTnof-VprivDTnof77
save DTnofmatrix, replace
restore

/* FEFT model, drop Moscow and St. Petersburg */
reg dtlsale dtldo_ter1-dtldo_ter38 dtldo_ter41-dtldo_ter44 dtldo_ter46-dtldo_ter99 dtlfo dtldo_dm* dte1-dte10 dtc1-dtc10 dtiyr* if ter ~= 1140 & ter ~= 1145, cluster(okpo)
preserve
matrix b = e(b)'
matrix privDTnoc = b[1..75,1]
matrix V = e(V)
matrix VprivDTnoc = V[1..75,1..75]
matrix SE2privDTnoc = vecdiag(VprivDTnoc)'
svmat privDTnoc
svmat VprivDTnoc
svmat SE2privDTnoc
rename privDTnoc1 privDTnoc
rename SE2privDTnoc1 SE2privDTnoc
keep in 1/75
order privDTnoc SE2privDTnoc VprivDTnoc* 
keep privDTnoc-VprivDTnoc75
save DTnocmatrix, replace
restore


/* PRIVATIZATION PROPENSITY */

clear
use full
duplicates drop okpo, force
sort ter
by ter: egen terdever=mean(dever)
duplicates drop ter, force
keep ter terdever
sort ter
save terdever, replace
*variable included in regional.dta


