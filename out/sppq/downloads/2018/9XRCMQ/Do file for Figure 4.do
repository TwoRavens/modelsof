* Loading data with user's personal file pathway
use "Holyoke_Brown_Replication Data File_SPPQ.dta", clear
* commands to produce the raw data for Figure 4
gen diffXgrad = diffusion * gradrateaveragechange
xtmixed cerscore diffusion gradrateaveragechange diffXgrad charterfactor neafactor dempercent governor reducedenroll reducedteachers reduceddeficit gsp || stateid: citizenideo if middlethird==1, mle
matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
gen change=((_n-122)/1000)
replace change =. if _n > 271
gen conbx = b1 + b3*change if _n < 272
gen consx = sqrt(varb1 + varb3*(change^2)+2 * covb1b3*change) if _n < 272
gen ax = 1.96 * consx
gen upperbound = conbx + ax
gen lowerbound = conbx - ax
rename conbx marginal_effect
* To create the EXCEL file for Figure 4
export excel marginal_effect upperbound lowerbound using "Fig4data.xlsx", firstrow(variables)
* This created a new EXCEL file called "Fig4data.xlsx"
* Open the EXCEL file
* Use the "Insert" tab in EXCEL to create a line graph, and customize
