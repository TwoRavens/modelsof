tempfile political
use "Polity IV 2.dta", clear
capture drop Dem
gen Dem=0
replace Dem=1  if L5.polity<6 & polity>=6
replace Dem=. if polity==.
gen Democratization3=0
replace Democratization3=1 if L5.polity<=-7 & L5.polity>=-10 & polity>-7 & polity<6 
gen StableAutoc=0
replace StableAutoc= 1 if (L.polity<6 & L.polity>=-6) & (L2.polity<6 & L2.polity>=-6) & (L3.polity<6 & L3.polity>=-6) & (L4.polity<6 & L4.polity>=-6) & (L5.polity<6 & L5.polity>=-6)
replace StableAutoc= 1 if (L.polity<-6 & L.polity>=-10) & (L2.polity<-6 & L2.polity>=-10) & (L3.polity<-6 & L3.polity>=-10) & (L4.polity<-6 & L4.polity>=-10) & (L5.polity<-6 & L5.polity>=-10)

gen Democracy_year = 0
replace Democracy_year = 1 if polity>=6 & polity~=.

sort ccode year
save `political', replace

use "io topic and startyear.dta", clear
drop if ionumber==1830
rename styear year
keep if year>=1965

tempfile temp1 temp2
save `temp1', replace

keep year
duplicates drop year, force
sort year
gen global_IO_N = 0
save `temp2', replace

levels year, local (yr)
foreach y in `yr' {
use `temp1', clear
sum iotopic if year==`y'
local N = r(N)
use `temp2', clear
replace global_IO_N = global_IO_N + `N' if year>=`y' & `N'~=.
save `temp2', replace
}

sort year
save `temp2', replace


use "IGO Members for PJ MASTER Polity", clear
sort ccode year
save "IGO Members for PJ MASTER Polity", replace

use "IO form type", clear
sort ccode year
save "IO form type", replace

use "PJ Data ISQ", clear
set more off

sort ccode year
merge ccode year using `political', nokeep keep(Dem StableAutoc Democracy_year)
drop _merge

sort year
merge year using `temp2', nokeep keep(global_IO_N)
drop _merge
sum global_IO_N if year==1998
local N98 = r(N)
replace global_IO_N= `N98' if year==1999
replace global_IO_N= `N98' if year==2000

sum ccode year
sort ccode year
merge ccode year using "IO form type", nokeep keep(IO_form_type IO_join_type)
drop _merge
sum IO_form_type
replace IO_form_type=0 if IO_form_type==.
replace IO_join_type=0 if IO_join_type==.
duplicates drop ccode year, force
sum ccode year

gen IO_N = NpoliticalG + NpoliticalS + NpoliticalL + NeconomicM + NeconomicC + NeconomicR + Ntechnical

*** Form v Join
capture drop form
gen form = 0
replace form = 1 if form_high==1 | form_med==1 | form_low==1
capture drop join
gen join = 0
replace join = 1 if join_high==1 | join_med==1 | join_low==1

replace form=0 if ccode==200 & year==1993
replace form=0 if ccode==210 & year==1993
replace form=0 if ccode==211 & year==1993
replace form=0 if ccode==212 & year==1993
replace form=0 if ccode==220 & year==1993
replace form=0 if ccode==230 & year==1993
replace form=0 if ccode==235 & year==1993
replace form=0 if ccode==255 & year==1993
replace form=0 if ccode==325 & year==1993
replace form=0 if ccode==350 & year==1993
replace form=0 if ccode==205 & year==1993
replace form=1 if ccode==390 & year==1993

replace join=1 if ccode==200 & year==1993
replace join=1 if ccode==210 & year==1993
replace join=1 if ccode==211 & year==1993
replace join=1 if ccode==212 & year==1993
replace join=1 if ccode==220 & year==1993
replace join=1 if ccode==230 & year==1993
replace join=1 if ccode==235 & year==1993
replace join=1 if ccode==255 & year==1993
replace join=1 if ccode==325 & year==1993
replace join=1 if ccode==350 & year==1993
replace join=1 if ccode==205 & year==1993
replace join=1 if ccode==390 & year==1993

ttest form=join if Dem==1
ttest form=join if Dem==0

** Table 1 Results

logit form Dem if year>=1965, cluster(ccode)
estimates store c1
logit join Dem if year>=1965, cluster(ccode)
estimates store c4

logit form Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year if year>=1965, cluster(ccode)
estimates store c2
logit join Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year if year>=1965, cluster(ccode)
estimates store c5


set more off
capture drop region
gen region = 0
replace region = 1 if NAmerica==1
replace region = 2 if SAmerica==1
replace region = 3 if Europe==1
replace region = 4 if MidEast==1
replace region = 5 if Asia==1
replace region = 6 if Oceania==1

tempfile temp1 temp2 temp3 temp4 temp_main

gen form2=form
gen join2=join

save `temp_main', replace

qui {
use `temp_main', clear
tempvar var
gen `var' = region
gen spatiallag = .
save `temp1', replace

levels year, local(yr)
foreach y in `yr' {
qui {
use `temp1', clear
keep if year==`y'
save `temp2', replace
levels ccode, local(cc)
foreach c in `cc' {
use `temp2', clear
sum `var' if ccode==`c'
local m = r(mean)
keep if `var'==`m' & ccode~=`c'
sum form2 if Dem==1 & form2==1
local N = r(N)
replace form2 = form2/`N'
local total = sum(form2)
use `temp1', clear
local y1 = `y' + 1
replace spatiallag=`total' if year==`y1' & ccode==`c'
save `temp1', replace
}
} /* end of quite */
}
}

logit form Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N spatiallag if year>=1965, cluster(ccode)
estimates store c3

capture drop spatiallag

qui {
use `temp_main', clear
tempvar var
gen `var' = region
gen spatiallag = .
save `temp1', replace

levels year, local(yr)
foreach y in `yr' {
qui {
use `temp1', clear
keep if year==`y'
save `temp2', replace
levels ccode, local(cc)
foreach c in `cc' {
use `temp2', clear
sum `var' if ccode==`c'
local m = r(mean)
keep if `var'==`m' & ccode~=`c'
sum join2 if Dem==1 & join2==1
local N = r(N)
replace join2 = join2/`N'
local total = sum(join2)
use `temp1', clear
local y1 = `y' + 1
replace spatiallag=`total' if year==`y1' & ccode==`c'
save `temp1', replace
}
} /* end of quite */
}
}

logit join Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N spatiallag if year>=1965, cluster(ccode)
estimates store c6

** Table 1 Results

estout c1 c2 c3 c4 c5 c6/**/ using "C:\Users\Owner\Documents\Active Projects\Democ and IO replications\Tables\tablePJ5", replace /**/ style(tex) varlabels(_cons Constant) label legend starl(* 0.10 ** 0.05 *** 0.01) /**/ cells(b(label(Coef.) star fmt(%9.2f)) se(par fmt(%9.2f))) stats(N , labels(No. of Cases )) /**/ title(Form New IO, by Insitutionalization, by Function\label{geddesreg}) /**/ mlabels(, span prefix(\multicolumn{@span}{c}{) suffix(})) /**/ prehead("\begin{table}\caption{@title}" "\begin{center}" /**/ "\begin{tabular}{l*{@M}{rr}}" "\hline") posthead(\hline) /**/ prefoot(\hline) postfoot("\hline" /**/ "\end{tabular}" "\end{center}" "\end{table}") 

** Table 2 Results

logit join_high Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N spatiallag  if year>=1965, cluster(ccode)
estimates store c1
logit join_med Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N spatiallag  if year>=1965, cluster(ccode)
estimates store c2
logit join_low Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N spatiallag  if year>=1965, cluster(ccode)
estimates store c3

logit form_high Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N spatiallag  if year>=1965, cluster(ccode)
estimates store c4
logit form_med Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N spatiallag  if year>=1965, cluster(ccode)
estimates store c5
logit form_low Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N spatiallag  if year>=1965, cluster(ccode)
estimates store c6

estout c1 c2 c3 c4 c5 c6 /**/ using "C:\Users\Owner\Documents\Active Projects\Democ and IO replications\Tables\tablePJ5", replace /**/ style(tex) varlabels(_cons Constant) label legend starl(* 0.10 ** 0.05 *** 0.01) /**/ cells(b(label(Coef.) star fmt(%9.2f)) se(par fmt(%9.2f))) stats(N , labels(No. of Cases )) /**/ title(Form New IO, by Insitutionalization, by Function\label{geddesreg}) /**/ mlabels(, span prefix(\multicolumn{@span}{c}{) suffix(})) /**/ prehead("\begin{table}\caption{@title}" "\begin{center}" /**/ "\begin{tabular}{l*{@M}{rr}}" "\hline") posthead(\hline) /**/ prefoot(\hline) postfoot("\hline" /**/ "\end{tabular}" "\end{center}" "\end{table}") 


*** Compute Risk Ratios
set more off
sum IO_N  if year>=1965
local m1 = r(mean)
sum NAmerica   if year>=1965
local m2 = r(mean)
sum SAmerica  if year>=1965
local m3 = r(mean)
sum Asia  if year>=1965
local m4 = r(mean)
sum Oceania  if year>=1965
local m5 = r(mean)
sum Europe  if year>=1965
local m6 = r(mean)
sum MidEast  if year>=1965
local m7 = r(mean)
sum FormerCommunist  if year>=1965
local m8 = r(mean)
sum Independence  if year>=1965
local m9 = r(mean)
sum year if year>=1965
local m10 = r(mean)

foreach DV of varlist form join {
qui {
logit `DV' Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year if year>=1965, cluster(ccode)
local c0 = _coef[_con]
local c1 = _coef[IO_N] 
local c2 = _coef[Dem]
local c3 = _coef[NAmerica] 
local c4 = _coef[SAmerica] 
local c5 = _coef[Asia] 
local c6 = _coef[Oceania] 
local c7 = _coef[Europe] 
local c8 = _coef[MidEast] 
local c9 = _coef[FormerCommunist] 
local c10 = _coef[Independence]
local c11 = _coef[year] 

#delimit ; 
local xbhat0 = 
`c0'*1 +  
`c1'*`m1' + 
`c2'*0 + 
`c3'*`m2' + 
`c4'*`m3' + 
`c5'*`m4' + 
`c6'*`m5' + 
`c7'*`m6' + 
`c8'*`m7' + 
`c9'*`m8' + 
`c10'*`m9' + 
`c11'*`m10'; 
#delimit cr
local p0 = 1/(1 + (-`xbhat0'))

#delimit ; 
local xbhat1 = 
`c0'*1 +  
`c1'*`m1' + 
`c2'*1 + 
`c3'*`m2' + 
`c4'*`m3' + 
`c5'*`m4' + 
`c6'*`m5' + 
`c7'*`m6' + 
`c8'*`m7' + 
`c9'*`m8' + 
`c10'*`m9' + 
`c11'*`m10'; 
#delimit cr
local p1 = 1/(1 + (-`xbhat1'))

local rr11 = `p1'/`p0'
} /* End of Quite */

di `rr11'
di " "


}


*** Descriptive Statistics for Independent Variables
sum Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year if year>=1965

*** Descriptive Statistics for Dependent Variables
sum join form if year>=1965



** Proportion of Country-Years in which democratizing states are joining an existing IO
ttest join, by(Dem)
** Proportion of Country-Years in which democratizing states are forming a new IO
ttest form, by(Dem)


** MODEL FIT STATISTICS (PERCENT CORRECTLY PREDICTED)

logit join Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year if year>=1965, cluster(ccode)
capture drop p 
capture drop predict_join
predict p
gen predict_join = 0
replace predict_join = 1 if p>0.5
tab predict_join join
capture drop p

di "Percent of non-joins correctly predicted: " 718/2293
di "Percent of joins correctly predicted: " 2929/3442

logit form Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year if year>=1965, cluster(ccode)
capture drop p predict_form
predict p
gen predict_form = 0
replace predict_form = 1 if p>0.5
tab predict_form form
capture drop p

di "Percent of non-forms correctly predicted: " 953/4121
di "Percent of forms correctly predicted: " 1336/1614

** Sequencing Test
tempfile master
save `master', replace
levels ccode, local(cc)

* drop established democracies
foreach c in `cc' {
sum Democracy_year if year==1965 & ccode==`c'
local m = r(min)
if `m'==1 {
drop if ccode==`c'
}
}

* keep only non-established democracies after they democratized
keep if Democracy_year==1

* generate cummulative formation variable
tsset ccode year
capture drop d_N
capture drop N_form
gen d_N = IO_N - L.IO_N
gen N_form = 0
levels ccode, local(cc)
foreach c in `cc' {
local N_f = 0
levels year if ccode==`c', local(yr)
foreach y in `yr' {
sum d_N if year==`y' & ccode==`c'
local m = r(min)
if `m'==. {
local m = 0
}
local N_f = `N_f' + `m'
replace N_form = `N_f' if year==`y' & ccode==`c'
}
}

capture drop L_N_form
gen L_N_form = L5.N_form
logit join L_N_form, cluster(ccode)

use `master', clear
