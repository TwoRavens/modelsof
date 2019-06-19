*-----------------------------------------------------------------
version 10.0
cap clear
cap log close
set more off
set mem 700m
cd "E:\REStat_MS14767_Vol96(2)\Data preparation Compustat"
log using patentvars.log, replace
*-----------------------------------------------------------------

*****************************************************************
*** from compustat_master_all_countries.dta to			*
*** clean_compustat_master.dta 					*
*** This file creates the variable S by taking patent infos and *
*** r&d-expenditure together.					*
*** 2,500,000 entries remain in the patent data.		*
*****************************************************************

**********************
*In this part, patent data and compustat data are merged
***********************

use "raw data\apat63_99.dta"
so assignee
drop if gyear<1969

merge assignee using "patent files\cusipnamemerged_red.dta"

tab _merge 

**********************************************************
*
*      _merge |      Freq.     Percent        Cum.
* ------------+-----------------------------------
*           1 |  1,925,439       74.78       74.78
*           3 |    649,411       25.22      100.00
* ------------+-----------------------------------
*       Total |  2,574,850      100.00
*************************************************************

keep if _merge==3
drop _merge

*************************
* Check observations
count if assignee!=assignee[_n-1]
* must give number around 3590
***************************

*********************************
* Here some vars are generated
* If some further patent informationshall be kept, 
* the egen-line can easily be copied for each variable.
***************************

rename gyear year
so ticker year
drop if ticker==""
gen t=1
label var t "counting variable"
egen numpatentsy=sum(t), by(ticker year) 
label var numpatentsy "number of patents in a certain year"
egen claimsy=sum(claims), by(ticker year) 
label var claimsy "sum of claims in a certain year"
gen avclaims=claimsy/numpatentsy
label var avclaims "claimsy divided by numpatentsy"
drop t

/*

********************************************************
* we generate the patent stock, lagged vars
********************************************************

by ticker: gen yearweight=year[_n+1]-year if year!=year[_n+1]
gen xxx=numpatentsy
replace xxx=0 if xxx==.
so ticker year
by ticker: gen patents=xxx+xxx[_n-1]*(1-0.15)^yearweight if year!=year[_n-1]
label var patents "patentstock, depreciated"
drop xxx
replace patents=patents[_n-1] if year==year & ticker==ticker[_n-1] & patents==.
replace patents=0 if patents==.
so ticker year
by ticker: gen patents_t_1=patents[_n-1]
label var patents_t_1 "lagged patentstock, lag 1"
by ticker: gen patents_t_2=patents[_n-2]
label var patents_t_1 "lagged patentstock, lag 2"
by ticker: gen patents_t_3=patents[_n-3]
label var patents_t_1 "lagged patentstock, lag 3"
by ticker: gen patents_t_4=patents[_n-4]
label var patents_t_1 "lagged patentstock, lag 4"

*/

*********************************************************
* creating a panel
*********************************************************

save "patent files\apat69_99_cusip.dta", replace
drop if year>1998
save "patent files\apat69_98_cusip.dta", replace
drop if year>1997
save "patent files\apat69_97_cusip.dta", replace
drop if year>1996
save "patent files\apat69_96_cusip.dta", replace
drop if year>1995
save "patent files\apat69_95_cusip.dta", replace
drop if year>1994
save "patent files\apat69_94_cusip.dta", replace
drop if year>1993
save "patent files\apat69_93_cusip.dta", replace
drop if year>1992
save "patent files\apat69_92_cusip.dta", replace
drop if year>1991
save "patent files\apat69_91_cusip.dta", replace
drop if year>1990
save "patent files\apat69_90_cusip.dta", replace
drop if year>1989
save "patent files\apat69_89_cusip.dta", replace
drop if year>1988
save "patent files\apat69_88_cusip.dta", replace
drop if year>1987
save "patent files\apat69_87_cusip.dta", replace
drop if year>1986
save "patent files\apat69_86_cusip.dta", replace

forvalues z=86/99 {
use "patent files\apat69_`z'_cusip.dta", clear
egen t=group(cusip)
egen T=max(t)
replace T=T+1
drop t

order cusip
so cusip

gen k=0
replace k=1  if subcat==11       
replace k=2  if subcat==12       
replace k=3  if subcat==13       
replace k=4  if subcat==14       
replace k=5  if subcat==15       
replace k=6  if subcat==19       
replace k=7  if subcat==21       
replace k=8  if subcat==22       
replace k=9  if subcat==23       
replace k=10 if subcat==24       
replace k=11 if subcat==31       
replace k=12 if subcat==32       
replace k=13 if subcat==33       
replace k=14 if subcat==39       
replace k=15 if subcat==41       
replace k=16 if subcat==42       
replace k=17 if subcat==43       
replace k=18 if subcat==44       
replace k=19 if subcat==45       
replace k=20 if subcat==46       
replace k=21 if subcat==49       
replace k=22 if subcat==51       
replace k=23 if subcat==52       
replace k=24 if subcat==53       
replace k=25 if subcat==54       
replace k=26 if subcat==55       
replace k=27 if subcat==59       
replace k=28 if subcat==61       
replace k=29 if subcat==62       
replace k=30 if subcat==63       
replace k=31 if subcat==64       
replace k=32 if subcat==65       
replace k=33 if subcat==66       
replace k=34 if subcat==67       
replace k=35 if subcat==68       
replace k=36 if subcat==69 

gen t=1
egen ct=sum(t), by(cusip k)
drop t year appyear nclass cat subcat patent
so cusip k
drop if cusip==cusip[_n+1] & k==k[_n+1]

gen kk1 =ct
gen kk2 =ct
gen kk3 =ct
gen kk4 =ct
gen kk5 =ct
gen kk6 =ct
gen kk7 =ct
gen kk8 =ct
gen kk9 =ct
gen kk10=ct
gen kk11=ct
gen kk12=ct
gen kk13=ct
gen kk14=ct
gen kk15=ct
gen kk16=ct
gen kk17=ct
gen kk18=ct
gen kk19=ct
gen kk20=ct
gen kk21=ct
gen kk22=ct
gen kk23=ct
gen kk24=ct
gen kk25=ct
gen kk26=ct
gen kk27=ct
gen kk28=ct
gen kk29=ct
gen kk30=ct
gen kk31=ct
gen kk32=ct
gen kk33=ct
gen kk34=ct
gen kk35=ct
gen kk36=ct

drop if cusip=="."

egen id=group(cusip k)

************************
* Dataset is reshaped here
************************

reshape long kk, i(id) j(j)
drop id

replace kk=0 if j~=k

so cusip j kk
drop if cusip==cusip[_n+1] & j==j[_n+1]                       
drop k ct

****************************
* Dataset is reshaped again
*************************

egen id=group(cusip j)
reshape wide kk, i(id) j(j)
drop id

forvalues i=1/36 {
egen k`i'=max(kk`i'), by(cusip)
drop kk`i'
}

count if cusip==cusip[_n-1]
drop if cusip==cusip[_n-1]

************************************
* Here we start bulding the variable
********************************

set matsize 5000

******************************
* The patent distribution information for all firms is stored in one matrix M, where each
* row of the matrix gives the patent distribution of one firm. The dimensions of the matrix
* is N*36, where N is the number of firms in the dataset
*****************************

mkmat k1 k2 k3 k4 k5 k6 k7 k8 k9 k10 k11 k12 k13 k14 k15 k16 k17 k18 k19 k20 k21 k22 k23 k24 k25 k26 k27 k28 k29 k30 k31 k32 k33 k34 k35 k36, matrix(M)

******************************
* The matrix MS is calculated. it is the product of M with its transpose. The resulting matrix
* will be a square matrix of dimension N*N. Each element of the matrix will be equal to 
* the inner product of a pair of firms' patent-distribution-vectors, where the diagonal
* elements are the inner product of one firm's patent distribution with itself, and they
* are thus sums of squares. The latter elements are stored in the row vector d.
*****************************

matrix MS=M*M'
matrix d=vecdiag(MS)

*****************************
* The outer product of the vector of sums of squares (d) is stored as the N*N matrix D.
* Each element of the matrix will thus be equal to the product of two sums of squares.
*******************************

matrix D=d'*d

egen id=group(cusip)

****************************
* The colums of the matrices MS and D are stored as variables, so that functions can
* be applied to the single elements of the matrices.
************************

svmat D
svmat MS

**************************
* The following loop first takes the square root of each observation in each D-variable
* (i.e. of each element in matrix D). Now all elemnts of MS and D that have the same
* position (row i, column j) constitute, respectively, the numerator and the denominator
* for an uncentered correlation coeffecient between the patent distributions of firms
* i and j. Thus, a fraction of each of these pairs is calculated and stored in MS
* which now constitutes a correlation matrix for ALL firms, only that the diagonal 
* elements (which are 1) are set to zero, as, later on, a firms own r&d expenditures
* are not supposed to enter its potential spillover pool.
************************************

local i=1
while `i'<T {
replace D`i'=sqrt(D`i')
replace MS`i'=MS`i'/D`i'
drop D`i'
replace MS`i'=0 if id==`i'
local i=`i'+1
}

************************************
* In the following loop, for each row of the technological correlation matrix MS
* (which refers to one firm), all elements are set to zero which measure the technology
* correletion between the firm and another firm that does NOT belong to the same
* SIC4 industry. This procedure could be applied to any groups of firms, i.e. 
* firms belonging to the same SIC2/SIC3 industry, or the group of insiders and 
* outsiders of one rjv as we defined them.
**************************************

egen id_sic=group(sic4)
local i=1
while `i'<T {
gen n=id_sic if id==`i'
egen nn=max(n)
replace MS`i'=0 if id_sic~=nn
drop n nn
local i=`i'+1
}

save "patent files\proximity86_`z'.dta", replace
}

**************************
* The information on r&d-expenditures from the compustat data is isolated.
****************************

use "clean_compustat_master.dta", clear
keep  ticker name countryinc year rdexpense CUSIP
rename CUSIP cusip
so cusip year
drop if rdexpense==.

save "patent files\clean_compustat_master_rd.dta", replace

*******************************
* The r&d information is seperated into year specific datasets. Observations
* where are r&d-expenditures are not observed are DROPPED. I.e., whenever the r&d-expenditure
* variable takes on the value zero, this means that zero expenditures are actually
* OBSERVED.
*******************************

forvalues z=86/99 {
use "patent files\clean_compustat_master_rd.dta", clear
keep if year==19`z' & rdexpense~=. 
save "patent files\clean_compustat_master_rd`z'.dta",replace
}

**********************************
* Now, for each year, the dataset containing the correlation matrices are merged
* with the r&d-expenditure information. What makes the issue tricky is that 
* firms are potentially observed in the correlation-matrix data set stemming from 
* the patent data that are not observed in the r&d-expenditure dataset because the 
* variable was not observed in compustat for these firms. In such cases, not only
* the corresponding row for the firm must be dropped, but also the corresponding
* column. New id's must be assigned in order not to mess up the order
* of rows and columns.
************************************



set more off
forvalues z=86/99 {
use "patent files\proximity86_`z'.dta", clear
so cusip
merge cusip using "patent files\clean_compustat_master_rd`z'.dta"
drop if _merge==2
egen id_new=group(cusip) if _merge==3
egen u=group(cusip) if _merge==1
egen tt=max(u)
replace tt=tt+1
local f=1
while `f'<tt {
gen dro=id if u==`f'
egen dropp=max(dro)
local dr=dropp
drop MS`dr'
drop dro dropp
local f=`f'+1
}
local f=1
drop tt u
egen tt=max(id_new)
replace tt=tt+1
while `f'<tt {
gen p=id_new if id_new==`f'
egen s=max(p)
drop p
local p=s
drop s
gen q=id if id_new==`f'
egen r=max(q)
drop q
local q=r
drop r
rename MS`q' MS`p'a
rename MS`p'a MS`p'

local f=`f'+1
}
drop if _merge==1
drop _merge
local m=tt-1
mkmat MS1-MS`m', matrix(MM)
mkmat rdexpense, matrix(rd)
matrix S`z'=MM*rd
svmat S`z'
rename S`z'1 S`z'
save "patent files\spillover_pool_`z'.dta", replace
}

forvalues z=86/99 {
use "patent files\spillover_pool_`z'.dta", clear
keep S`z' year T cusip ticker numpatentsy claimsy avclaims
save "patent files\spillover_pool_`z'_red.dta", replace
}

use "patent files\spillover_pool_86_red.dta", clear
forvalues z=87/99 {
append using "patent files\spillover_pool_`z'_red.dta"
}

gen S=.
forvalues z=86/99 {
replace S=S`z' if S`z'~=.
drop S`z'
}

label var S "spillover variable, patents"

so ticker year
save "patent files\spillover_pool_panel.dta", replace

keep ticker year cusip S numpatentsy claimsy avclaims 
so cusip year 
order cusip ticker year

desc

save "patentvars.dta", replace


********************************
* This resulting data set contains various data on patents and the new variable S.
* It may now be merged with the whole compustat database.
*******************************

log close













