clear
set more off

*cd "/Users/jmontgomery/Dropbox/Congressional staff/Replication Archive/"
cd "/Users/bnyhan/Documents/Dropbox/Congressional staff/Replication Archive/"

/*Figure 1b*/

mkdir "Densities"

forval i=105/111 {
clear
insheet using "MemberMemberProjections/Policy/ProjMatrixPolicy`i'.csv", comma
drop v1
quietly egen sumties=rowtotal(*)
tab sumties
tab sumties if sumties>0 & sumties!=.
drop sumties
quietly egen maxties=rowmax(*)
tab maxties if maxties>0 & maxties!=.
drop maxties
*gen sumties2plus=(sumties>1 & sumties!=.)
foreach var of varlist n* {
quietly replace `var'=1 if `var'>1 & `var'!=.
}
quietly egen sumtiesbinary=rowtotal(n*)
su sumtiesbinary
tab sumtiesbinary if sumtiesbinary>0 & sumtiesbinary!=.
quietly egen sumties=rowtotal(*)
gen anytie=(sumtiesbinary>0)
quietly collapse (mean) sumties sumtiesbinary anytie
display `i'
list
gen cong=`i'
save "Densities/density`i'.dta", replace
}

use "Densities/density105.dta", clear
forval i=106/111 {
append using "Densities/density`i'.dta"
}

list

rename sumtiesbinary stbpolicy

sort cong
keep cong stbpolicy
save "Densities/densitypercong.dta", replace


clear

forval i=105/111 {
clear
insheet using "MemberMemberProjections/Senior/ProjMatrixSenior`i'.csv", comma
drop v1
quietly egen sumties=rowtotal(*)
tab sumties
tab sumties if sumties>0 & sumties!=.
drop sumties
quietly egen maxties=rowmax(*)
tab maxties if maxties>0 & maxties!=.
*gen sumties2plus=(sumties>1 & sumties!=.)
foreach var of varlist n* {
quietly replace `var'=1 if `var'>1 & `var'!=.
}
quietly egen sumtiesbinary=rowtotal(n*)
su sumtiesbinary
tab sumtiesbinary if sumtiesbinary>0 & sumtiesbinary!=.
quietly egen sumties=rowtotal(*)
gen anytie=(sumtiesbinary>0)
quietly collapse (mean) sumties sumtiesbinary anytie
display `i'
list
gen cong=`i'
save "Densities/densitysenior`i'.dta", replace
}

use "Densities/densitysenior105.dta", clear
forval i=106/111 {
append using "Densities/densitysenior`i'.dta"
}

twoway line sumtiesbinary cong, ylab(0(.25)1,nogrid) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ytitle("Mean senior staff ties") scheme(s2mono) xtitle("Congress") xlab(105(1)111)

list

keep cong sumtiesbinary
sort cong
capture drop _merge
merge 1:1 cong using "Densities/densitypercong.dta"
tab _merge

list

sort cong
twoway (line sumtiesbinary cong,lcolor(gs9))(line stbpolicy cong, ylab(0(.25)1,nogrid) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ytitle("Mean ties between members (per member)") scheme(s2mono) xtitle("Congress") xlab(105(1)111) legend(lab(1 "Senior staff") lab(2 "Senior/policy staff")))

/*cleanup*/
cd "Densities"
!rm *.dta
cd ..
!rmdir "Densities/" 
