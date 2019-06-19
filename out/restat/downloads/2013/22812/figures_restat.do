cd "D:\NCESData\cadena-benkeys\CadenaKeysNPSAS\statadata"
set more off
use mergedcleaned04, clear
append using mergedcleaned00

/* additional selection criteria suggested by referees */
gen refundamt = stafmax-netcst9

keep if refundamt>-10000 & refundamt<=5500

/*locpoly graphs*/
locpoly allnone refundamt if offcampus == 1, degree(1) at(refundamt) gen(offcamp_more) noscatter width(1000)
locpoly allnone refundamt if offcampus == 0 , degree(1) at(refundamt) gen(oncamp_more) noscatter width(1000)

replace offcamp_more = . if offcampus == 0
replace oncamp_more = . if offcampus == 1

graph twoway (line offcamp_more refundamt, sort) (line oncamp_more refundamt , sort) /*(line offcamp_less refundamt, sort) (line oncamp_less refundamt , sort)*/ if refundamt <=5500 & refundamt >-10000


/*locpoly + dots graphs*/
capture drop amountcat ybar ybar_off ybar_on
gen amountcat = round(refundamt-1, 2000)
replace amountcat = 5500 if amountcat == 6000
bysort amountcat offcampus: egen ybar = mean(allnone)

gen ybar_off = ybar if offcampus==1
gen ybar_on = ybar if offcampus==0

label variable ybar_off "Take-up Rate - Off-Campus"
label variable ybar_on "Take-up Rate - On-Campus"
label variable offcamp_more "Smoothed Rate - Off-Campus"
label variable oncamp_more "Smoothed Rate - On-Campus"


graph twoway (scatter ybar_off amountcat) (scatter ybar_on amountcat) (line offcamp_more refundamt, sort) (line oncamp_more refundamt , sort) if refundamt > -10000 & refundamt <8500, xtitle("Student Account Balance if Loan Accepted") ytitle("Loan Acceptance Rate") scheme(s2mono)

graph save "D:\NCESData\cadena-benkeys\CadenaKeysNPSAS\output\figures\locpoly_with dots 041808.gph", replace
