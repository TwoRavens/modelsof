*****************************
* DOES PLANNING REGULATION PROTECT INDEPENDENT RETAILERS?
* Do file to prepare job creation and job destruction in 521
* Created by Raffaella Sadun (rsadun@hbs.edu)
*****************************

clear
clear matrix
set mem 800m
cd "T:\LSE\Raffaella_Sadun\_Papers Replication\Retail\data"

************************
* Compute n and x rates for small chains
* note: code identifies as entry also brownfield entry (this is to take into account acquisitions of smaller chain stores)
**************************
u "prel", replace
keep ruref luref year 
* merge with shop definition in chain regs file
so luref year
merge 1:1 luref year using "chains_sept12_precollapse"
drop _m
drop if check==2
* Define type, break down entry of indep from chain, and look at types of stores within chains
gen type=.
replace type=5 if check==1
replace type=1 if tt1==1
replace type=2 if tt2==1
replace type=3 if tt3==1
replace type=4 if tt4==1
save chains_sept12_precollapse_gro_prel, replace

u chains_sept12_precollapse_gro_prel, replace
* Keep any type of store that at some point appears to be a small store belonging to a large chain
bys luref: egen  tt=max(tt3)
keep if tt==1

* Exclude transitions to larger stores
bys luref: egen  tt_1=max(tt4)
drop if tt_1==1

keep ruref luref year type emp_lu la_code very_large
rename luref luref_old
egen luref=group(luref type)
drop luref_old
drop if year==1997
sa chains_sept12_precollapse_gro_v1, replace

forvalues z=1998(1)2003{
local j=`z'+1
use chains_sept12_precollapse_gro_v1, clear

* Define emp growth rate
keep if year==`z' | year==`j'

* Generate markers for entrant, exitor, continuer
so luref year
byso luref: egen sum_y=sum(year)
byso luref: gen status=1 if sum_y==`z'+`j'
byso luref: replace status=2 if sum_y==`j'
byso luref: replace status=3 if sum_y==`z'
label define status_lab 1 stayer 2 entrant 3 exitor
label values status status_lab

ge emp_`j'	=emp_lu if year==`j'
ge emp_`z'	=emp_lu if year==`z'
bys luref: egen m_`j' = max(emp_`j')
bys luref: egen m_`z' = max(emp_`z')
replace emp_`j' = m_`j'
replace emp_`z' = m_`z'
ge empgr 	=(emp_`j'-emp_`z')/((emp_`z'+emp_`j')/2)
ge avg 		=(emp_`j'+emp_`z')/2

* Now add bit for entrants and exitors
replace empgr=2 if emp_`z'==.
replace empgr=-2 if emp_`j'==.
replace avg=emp_`j' if status==2
replace avg=emp_`z' if status==3

* Generate variable for empgr
ge va=1 if empgr==2
replace va=2 if empgr>=0 & empgr~=2
replace va=3 if empgr<0 & empgr~=-2
replace va=4 if empgr==-2

ge var="Entry" if empgr==2
replace var="Exp" if empgr>=0 & empgr~=2
replace var="Contr" if empgr<0 & empgr~=-2
replace var="Exit" if empgr==-2
sa creation_`j', replace
}

*********
* Collapse at LA level
* Yearly data by Local Authority by type of stores
* Now using weights by type la_code year cells fro type stats
* Weights by la_code year for aggregate stuff
*********
forvalues z=1998(1)2003{
local j=`z'+1
use creation_`j', clear

* Keep only 1 year
replace year=`j' if status==3
sort status 
keep if year==`j'

* Generate weight by year, type and local authority
bys year la_code:          egen tot_all=sum(avg)
bys year la_code type:     egen tot_type=sum(avg)
bys la_code:               egen avg_tot_all=mean(tot_all)
bys la_code type:          egen avg_tot_type=mean(tot_type)
ge weight1=avg/ tot_all
ge weight2=avg/ tot_type

* Generate dataset of stats
ge empgr_w1=weight1*empgr
ge empgr_w2=weight2*empgr


bys la_code: egen gro=sum(empgr_w1)
bys la_code var: egen gro_comp=sum(empgr_w1)
bys la_code type: egen gro_type=sum(empgr_w2)
bys la_code type var: egen gro_type_comp=sum(empgr_w2)
* Drop store specific variables to avoid confusion
drop luref* ruref emp_lu sum_y emp_* m_* empgr* avg weight* tot* va very_large
so la_co year type status var
duplicates drop
so la_code year
save creation_`j'_y_la_type, replace
}


* Append yearly and la data for all types of stores
clear
ge temp=.
forvalues z=1998(1)2003{
local j=`z'+1
append using creation_`j'_y_la_type
}
drop temp
replace var="entry_j" if var=="Entry"
replace var="exp_j" if var=="Exp"
replace var="contr_j" if var=="Contr"
replace var="exit_j" if var=="Exit"
drop status
reshape wide gro_comp gro_type_com, i(year la_code type) j(var) string
foreach var in entry_j exp_j contr_j exit_j{
rename gro_comp`var' `var'
rename gro_type_comp`var' `var'_type
}
order la_code year gro entry_j exp_j contr_j exit_j type gro_type entry_j exp_j_ contr_j_ exit_j_

foreach var in entry_j exp_j contr_j exit_j{
bys la_code year: replace `var' = `var'[_n-1] if `var'==. & `var'[_n-1]~=.
bys la_code year: replace `var' = `var'[_n+1] if `var'==. & `var'[_n+1]~=.
bys la_code year: replace `var' = `var'[_n+1] if `var'==. & `var'[_n+1]~=.
bys la_code year: replace `var' = `var'[_n+1] if `var'==. & `var'[_n+1]~=.
bys la_code year: replace `var' = `var'[_n+1] if `var'==. & `var'[_n+1]~=.
bys la_code year: replace `var' = `var'[_n+1] if `var'==. & `var'[_n+1]~=.
}
egen r=rownonmiss(entry_j_t exp_j_t contr_j_t exit_j_t)
drop if r==0
drop r
foreach var in entry_j_t exp_j_t contr_j_t exit_j_t{
replace `var'=0 if `var'==.
}

foreach var in j j_type{
replace exit_`var'=-exit_`var'
replace contr_`var'=-contr_`var'
gen creation_`var'= entry_`var'+exp_`var'
gen destruction_`var'=contr_`var'+exit_`var'
gen net_growth_`var'=creation_`var'-destruction_`var'
gen gross_reall_`var'=creation_`var'+destruction_`var'
gen excess_reall_`var'=gross_reall_`var'-abs(entry_`var'+exit_`var')
}
so la_code year 
save creation_ally_la_type_long, replace

u ret_home_pop_basic_entry, replace
merge 1:m la_code year using creation_ally_la_type_long
keep if _m==3 
drop _m
so la_code year
merge m:1 la_code year using datachains_sept12_v1
drop if m_very==1
drop if delta_emp_tt3==.
foreach var in entry_j_type exit_j_type exp_j_type contr_j_type {
replace `var'=`var'_indep if type==5
} 
ta year, ge(yy)
sa ret_home_pop_chains_gro_long, replace


************************
* Compute n and x rates for large chains stores
* Note: in this case what matters is complete exit (so aquisitions not relevant)
**************************
u chains_sept12_precollapse_gro_prel, replace
drop type
drop if year==1997
tabstat emp_lu if check==3, s(mean med p10 p25 p50 p75 p90)

* Keep any type of store that at some point appears to be a large chain retail store
gen bigstore=emp_lu>150 if year>1997
bys luref: egen  tt=max(bigstore)
bys luref: egen  ttm=min(emp_lu)
keep if tt==1 & ttm>100

* Exclude transitions to very small stores
bys luref: egen  tt_1=max(tt3)
drop if tt_1==1

keep ruref luref year  emp_lu la_code 
sa bigstores, replace
**

forvalues z=1998(1)2003{
local j=`z'+1
use bigstores, clear

* Define emp growth rate
keep if year==`z' | year==`j'

* Generate markers for entrant, exitor, continuer
so luref year
byso luref: egen sum_y=sum(year)
byso luref: gen status=1 if sum_y==`z'+`j'
byso luref: replace status=2 if sum_y==`j'
byso luref: replace status=3 if sum_y==`z'
label define status_lab 1 stayer 2 entrant 3 exitor
label values status status_lab

ge emp_`j'	=emp_lu if year==`j'
ge emp_`z'	=emp_lu if year==`z'
bys luref: egen m_`j' = max(emp_`j')
bys luref: egen m_`z' = max(emp_`z')
replace emp_`j' = m_`j'
replace emp_`z' = m_`z'
ge empgr 	=(emp_`j'-emp_`z')/((emp_`z'+emp_`j')/2)
ge avg 		=(emp_`j'+emp_`z')/2

* Now add bit for entrants and exitors
replace empgr=2 if emp_`z'==.
replace empgr=-2 if emp_`j'==.
replace avg=emp_`j' if status==2
replace avg=emp_`z' if status==3

* Generate variable for empgr
ge va=1 if empgr==2
replace va=2 if empgr>=0 & empgr~=2
replace va=3 if empgr<0 & empgr~=-2
replace va=4 if empgr==-2

ge var="Entry" if empgr==2
replace var="Exp" if empgr>=0 & empgr~=2
replace var="Contr" if empgr<0 & empgr~=-2
replace var="Exit" if empgr==-2
sa bigstores_`j', replace
}

*********
* Collapse at LA level
* Yearly data by Local Authority by type of stores
* Now using weights by type la_code year cells fro type stats
* Weights by la_code year for aggregate stuff
*********
forvalues z=1998(1)2003{
local j=`z'+1
use bigstores_`j', clear

* Keep only 1 year
replace year=`j' if status==3
sort status 
keep if year==`j'

* Generate weight by year, type and local authority
bys year la_code:          egen tot_all=sum(avg)
bys la_code:               egen avg_tot_all=mean(tot_all)
ge weight1=avg/ tot_all

* Generate dataset of stats
ge empgr_w1=weight1*empgr

* Generate count of exits at the local authority level
gen count_exit=status==3
bys la_code: egen n_exits=sum(count_exit)
gen count_entry=status==2
bys la_code: egen n_entry=sum(count_entry)
gen count_inc=status==1
bys la_code: egen n_inc=sum(count_inc)
drop count_*

bys la_code: egen gro=sum(empgr_w1)
bys la_code var: egen gro_comp=sum(empgr_w1)
* Drop store specific variables to avoid confusion
drop luref* ruref emp_lu sum_y emp_* m_* empgr* avg weight* tot* va 
so la_co year status var
duplicates drop
so la_code year
save bigstores_`j'_y_la, replace
}

* Append yearly and la data for all types of stores
clear
ge temp=.
forvalues z=1998(1)2003{
local j=`z'+1
append using bigstores_`j'_y_la
}
drop temp
replace var="entry_j" if var=="Entry"
replace var="exp_j" if var=="Exp"
replace var="contr_j" if var=="Contr"
replace var="exit_j" if var=="Exit"
drop status
reshape wide gro_comp , i(year la_code ) j(var) string
foreach var in entry_j exp_j contr_j exit_j{
rename gro_comp`var' `var'
}
order la_code year gro entry_j exp_j contr_j exit_j entry_j 

foreach var in entry_j exp_j contr_j exit_j{
bys la_code year: replace `var' = `var'[_n-1] if `var'==. & `var'[_n-1]~=.
bys la_code year: replace `var' = `var'[_n+1] if `var'==. & `var'[_n+1]~=.
bys la_code year: replace `var' = `var'[_n+1] if `var'==. & `var'[_n+1]~=.
bys la_code year: replace `var' = `var'[_n+1] if `var'==. & `var'[_n+1]~=.
bys la_code year: replace `var' = `var'[_n+1] if `var'==. & `var'[_n+1]~=.
bys la_code year: replace `var' = `var'[_n+1] if `var'==. & `var'[_n+1]~=.
}
foreach var in entry_j exp_j contr_j exit_j{
replace `var'=0 if `var'==.
}

foreach var in j {
replace exit_`var'=-exit_`var'
replace contr_`var'=-contr_`var'
gen creation_`var'= entry_`var'+exp_`var'
gen destruction_`var'=contr_`var'+exit_`var'
gen net_growth_`var'=creation_`var'-destruction_`var'
gen gross_reall_`var'=creation_`var'+destruction_`var'
gen excess_reall_`var'=gross_reall_`var'-abs(entry_`var'+exit_`var')
}
so la_code year 
save bigstores_ally_la, replace

