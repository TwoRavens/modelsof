set more off
version 10
clear 
set memory 400m 
capture log close 
capture program drop _all 
log using ${pap4log}MNEexperience1_rev09, text replace

* Makes 4 tables: MNEexp_ind_rev09 and MNEexp_ind_rev09_nonMNE
* the last is based on workers in planbts that are always non-MNEs
* These 2 tables are alternatives for Table 6 
* Similarly: alternatives for Table 7 are: 
* MNEexp_plant_rev09 and MNEexp_plant_rev09_nonMNE
************************************************************

********
* 1
* Make temp data
******** 
    use ${pap4data}wagereg1temp.dta, clear
* Group 5 educational categories into 3
    quietly replace education=1 if education==0
    quietly replace education=3 if education==4
    quietly gen MNE=2 if dommne==1
    quietly replace MNE=1 if formne==1
    quietly replace MNE=0 if MNE==.
    keep aar pid bnr education MNE
    tsset pid aar
* Generate indicator for experience from allMNE, dom and for MNE
    gen erf=1 if MNE!=0
    gen erfdom=1 if MNE==2
    gen erffor=1 if MNE==1
* Indicator for always non-MNE
	bys bnr: egen nonMNE=sum(MNE)
	count if nonMNE==0
	count	
    quietly save ${pap4data}temp0.dta, replace


********
* 2.
********
* Share of non-MNE workers with MNEexp last 3 years.
****************************************************


program define indexp
* Accumulated experience last 3 years from MNEs for each individual
	sort pid aar
    bys pid: gen exp=sum(erf)
    assert exp!=.
    quietly replace exp=1 if exp>0
    bys pid: gen expdom=sum(erfdom)
    assert expdom!=.
    quietly replace expdom=1 if expdom>0
    bys pid: gen expfor=sum(erffor)
    assert expfor!=.
    quietly replace expfor=1 if expfor>0
	keep if `2'==0
    keep if aar==`1'
	drop erf*
    sort pid aar
    quietly save ${pap4data}temp3.dta, replace

    collapse (count) pid, by(aar education exp)
    * tot workers per year
    bys aar: egen tot=sum(pid)
    * tot workers per year and educ
    bys aar education: egen tot_e=sum(pid)
    keep if exp==1
    gen share=(pid/tot_e)*100
    bys aar: egen expall=sum(pid)
    gen shareall=(expall/tot)*100
    sort aar education
    mkmat share, mat(A)
    mkmat tot_e, mat(Ned)
    mkmat shareall if education==1, mat(B)
    mkmat tot if education==1, mat(C)
    mat N`1'=C,Ned'
	mat s`1'=B,A'

    use ${pap4data}temp3.dta, clear
    drop exp
    rename expdom exp
    collapse (count) pid, by(aar education exp)
    * tot workers per year
    bys aar: egen tot=sum(pid)
    * tot workers per year and educ
    bys aar education: egen tot_e=sum(pid)
    keep if exp==1
    gen share=(pid/tot_e)*100
    bys aar: egen expall=sum(pid)
    gen shareall=(expall/tot)*100
    sort aar education
    mkmat share, mat(A)
    mkmat shareall if education==1, mat(B)
	mat s`1'dom=B,A'

    use ${pap4data}temp3.dta, clear
    drop exp
    rename expfor exp
    collapse (count) pid, by(aar education exp)
    * tot workers per year
    bys aar: egen tot=sum(pid)
    * tot workers per year and educ
    bys aar education: egen tot_e=sum(pid)
    keep if exp==1
    gen share=(pid/tot_e)*100
    bys aar: egen expall=sum(pid)
    gen shareall=(expall/tot)*100
    sort aar education
    mkmat share, mat(A)
    mkmat shareall if education==1, mat(B)
	mat s`1'for=B,A'

mat ind`1'=s`1'\s`1'dom\s`1'for\N`1'
mat rownames ind`1'=MNE_exp Domestic_MNE_exp Foreign_MNE_exp Total_workers

mat colnames ind`1'=All ed1 ed2 ed3
end

*******
* Run program above for different 3 year periods  
* and export table for 1993 and 2000
*******
* Keep only years 1992-1995
	 use ${pap4data}temp0.dta, clear
    qui drop if aar<1992
    qui drop if aar>1995 
	indexp 1995 MNE
* Keep only years until 1993
	 use ${pap4data}temp0.dta, clear
    qui drop if aar>1993
	indexp 1993 MNE
* Keep only years 1997-00
	use ${pap4data}temp0.dta, clear
    qui drop if aar<1997
	indexp 2000 MNE

mat list ind1993
mat list ind1995
mat list ind2000

* Export  table for individuals with MNEexperience: 
    matrix B=ind1993\ind2000
	#delimit ;
    outtable using ${pap4tab}MNEexp_ind_rev09, mat(B) nobox 
	center f(%6.1f) replace caption("Share of workers in nonMNEs with MNE experience in 1993 and 2000");
	#delimit cr

*******
* Run program above for different 3 year periods  
* and export table for 1993 and 2000
*******
* Keep only years 1992-1995
	 use ${pap4data}temp0.dta, clear
    qui drop if aar<1992
    qui drop if aar>1995 
	indexp 1995 nonMNE
* Keep only years until 1993
	 use ${pap4data}temp0.dta, clear
    qui drop if aar>1993
	indexp 1993 nonMNE
* Keep only years 1997-00
	use ${pap4data}temp0.dta, clear
    qui drop if aar<1997
	indexp 2000 nonMNE

mat list ind1993
mat list ind1995
mat list ind2000

* Export  table for individuals with MNEexperience: 
    matrix B=ind1993\ind2000
	#delimit ;
    outtable using ${pap4tab}MNEexp_ind_rev09nonMNE, mat(B) nobox 
	center f(%6.1f) replace caption("Share of workers in nonMNEs with MNE experience in 1993 and 2000");
	#delimit cr

*******
* 3. 
*******
* Plant level: share of nonMNEs that have workers with MNE exp.
****************************************************************

program define plantexp
	sort pid aar
    bys pid: gen exp=sum(erf)
    assert exp!=.
    quietly replace exp=1 if exp>0
    bys pid: gen expdom=sum(erfdom)
    assert expdom!=.
    quietly replace expdom=1 if expdom>0
    bys pid: gen expfor=sum(erffor)
    assert expfor!=.
    quietly replace expfor=1 if expfor>0
* Keep if MNE=0 or nonMNE==0
	keep if `2'==0
    keep if aar==`1'
	drop erf* aar
    quietly save ${pap4data}temp3.dta, replace


bys bnr: egen MNEexp=sum(exp)
assert MNEexp!=.
qui replace MNEexp=1 if MNEexp!=0
foreach t in 1 2 3 {
bys bnr: egen dMNEexp`t'=sum(exp) if education==`t'
bys bnr: egen MNEexp`t'=mean(dMNEexp`t')
replace MNEexp`t'=0 if MNEexp`t'==.
replace MNEexp`t'=1 if MNEexp`t'!=0
}
bys bnr: gen n=_n
keep if n==1
keep MNEex*
gen N=_N

collapse (mean) N (sum) MNEexp MNEexp1 MNEexp2 MNEexp3
gen s=(MNEexp/N)*100
mkmat s, mat(a)
foreach t in 1 2 3 {
gen s`t'=(MNEexp`t'/N)*100
mkmat s`t', mat(a`t')
}
matrix MNE=a,a1,a2,a3

use ${pap4data}temp3.dta, clear
drop exp
rename expdom exp
bys bnr: egen MNEexp=sum(exp)
assert MNEexp!=.
qui replace MNEexp=1 if MNEexp!=0
foreach t in 1 2 3 {
bys bnr: egen dMNEexp`t'=sum(exp) if education==`t'
bys bnr: egen MNEexp`t'=mean(dMNEexp`t')
replace MNEexp`t'=0 if MNEexp`t'==.
replace MNEexp`t'=1 if MNEexp`t'!=0
}
bys bnr: gen n=_n
keep if n==1
keep MNEex*
gen N=_N

collapse (mean) N (sum) MNEexp MNEexp1 MNEexp2 MNEexp3
gen s=(MNEexp/N)*100
mkmat s, mat(a)
foreach t in 1 2 3 {
gen s`t'=(MNEexp`t'/N)*100
mkmat s`t', mat(a`t')
}
matrix MNEdom=a,a1,a2,a3

use ${pap4data}temp3.dta, clear
drop exp
rename expfor exp
bys bnr: egen MNEexp=sum(exp)
assert MNEexp!=.
qui replace MNEexp=1 if MNEexp!=0
foreach t in 1 2 3 {
bys bnr: egen dMNEexp`t'=sum(exp) if education==`t'
bys bnr: egen MNEexp`t'=mean(dMNEexp`t')
replace MNEexp`t'=0 if MNEexp`t'==.
replace MNEexp`t'=1 if MNEexp`t'!=0
}
bys bnr: gen n=_n
keep if n==1
keep MNEex*
gen N=_N

collapse (mean) N (sum) MNEexp MNEexp1 MNEexp2 MNEexp3
gen s=(MNEexp/N)*100
mkmat s, mat(a)
foreach t in 1 2 3 {
gen s`t'=(MNEexp`t'/N)*100
mkmat s`t', mat(a`t')
}
matrix MNEfor=a,a1,a2,a3

list N
matrix plant`1'=MNE\MNEdom\MNEfor
end

****************
 * Run program above for different 3 year periods  
****************
* Keep only years 1992-1995
	 use ${pap4data}temp0.dta, clear
    qui drop if aar<1992
    qui drop if aar>1995 
	plantexp 1995 MNE
* Keep only years until 1993
	 use ${pap4data}temp0.dta, clear
    qui drop if aar>1993
	plantexp 1993 MNE
* Keep only years 1997-00
	use ${pap4data}temp0.dta, clear
    qui drop if aar<1997
	plantexp 2000 MNE

mat list plant1993
mat list plant1995

mat list plant2000



* Export  table: 
    * Remember plant number (nonMNEs in 1993 and 2000) is 1993=4401 and 2000=4009
* Export  table for individuals with MNEexperience: 
    matrix B=plant1993\plant2000
	#delimit ;
    outtable using ${pap4tab}MNEexp_plant_rev09, mat(B) nobox 
	center f(%6.1f) replace caption("Share of nonMNEs that employ workers with MNE experience: 1993 and 2000");
	#delimit cr


****************
 * Run program above for different 3 year periods  
****************
* Keep only years 1992-1995
	 use ${pap4data}temp0.dta, clear
    qui drop if aar<1992
    qui drop if aar>1995 
	plantexp 1995 nonMNE
* Keep only years until 1993
	 use ${pap4data}temp0.dta, clear
    qui drop if aar>1993
	plantexp 1993 nonMNE
* Keep only years 1997-00
	use ${pap4data}temp0.dta, clear
    qui drop if aar<1997
	plantexp 2000 nonMNE

mat list plant1993
mat list plant1995
mat list plant2000



* Export  table: 
    * Remember plant number (always nonMNEs) in 1993=4117 and 2000=3813
	* This is the table I prefer
* Export  table for individuals with MNEexperience: 
    matrix B=plant1993\plant2000
	#delimit ;
    outtable using ${pap4tab}MNEexp_plant_rev09nonMNE, mat(B) nobox 
	center f(%6.1f) replace caption("Share of nonMNEs that employ workers with MNE experience: 1993 and 2000");
	#delimit cr


matrix drop _all
erase ${pap4data}temp0.dta 
erase ${pap4data}temp3.dta
program drop _all

capture log close 
exit
