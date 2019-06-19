**************
**Prepare data
**************
use "./data/VAdataset.dta", clear
drop if ecode==icode
collapse (sum) vaexports exports, by(ecode enum icode inum year)
sort ecode icode
merge ecode icode using "./data/distance.dta"
keep if _merge==3
drop _merge
keep ecode enum icode inum year vaexports exports dist
replace ecode="ROU" if ecode=="ROM"
replace icode="ROU" if icode=="ROM"

*****************************
**Merge with RTA data (September 2015 version)
*****************************
sort ecode icode year 
merge 1:m ecode icode year using "./data/EIAdata.dta"
keep if _merge==3
drop _merge
replace eia="0" if eia=="NoCty"
destring eia, replace

**************
**Define Panel
**************
egen pair=group(ecode icode)
egen yr=group(year)
tsset pair yr

*********************
**Define VAX and RTAs
*********************
gen vax=vaexports/exports
gen rta=eia>=3

**Define Phase In
gen temp=yr if rta==1 & L.rta==0
by pair, sort: egen adoptionyear=median(temp)
gen yrsafterrta=yr-adoptionyear
replace yrsafterrta=-99 if yrsafterrta==.

***************
**Define sample
***************
drop if ecode=="CZE" | ecode=="EST" | ecode=="RUS" | ecode=="SVK" | ecode=="SVN"
drop if icode=="CZE" | icode=="EST" | icode=="RUS" | icode=="SVK" | icode=="SVN"
egen enum_temp=group(ecode)
egen inum_temp=group(icode)

gen sample=0
replace sample=1 if exports>1 & vax<10

sort enum inum year
save "./data/RTA_data", replace

*****************
**RTA Event Study
*****************
clear
gen temp=.
save "./data/append_file", replace

**Compute inside vs. outside VAX ratios
forvalues i=1/37 {
	forvalues j=1/37 {
		if `i'~=`j' {
		use "./data/RTA_data.dta", clear
		keep if sample==1
		keep if enum_temp==`i' | enum_temp==`j' | inum_temp==`i' | inum_temp==`j'
		gen treatment=(enum_temp==`i' & inum_temp==`j') | (inum_temp==`i' & enum_temp==`j')
		by ecode icode, sort: egen ever=max(rta)
		drop if ever==1 & treatment~=1
		collapse (sum) exports* vaexports*, by(treatment year)
		gen vax=vaexports/exports
		drop exports* vaexports*
		reshape wide vax, i(year) j(treatment)
		gen enum_temp=`i'
		gen inum_temp=`j'
		append using "./data/append_file.dta"
		save "./data/append_file.dta", replace
	}
	}
	}

duplicates drop year vax0 vax1, force	
sort enum_temp inum_temp year
merge 1:1 enum_temp inum_temp year using "./data/RTA_data", keepusing(ecode icode rta adoptionyear yrsafterrta)
keep if _merge==3 
drop _merge enum_temp inum_temp temp
drop if adoptionyear==. /*Drop pairs that never form an RTA*/
save "./data/RTA_data", replace
erase "./data/append_file.dta"
	
**Collapse the data, taking means
use "./data/RTA_data.dta", clear
drop if vax0==. | vax1==.
collapse (mean) vax_control=vax0 vax_treat=vax1 (semean) vax_control_se=vax0 vax_treat_se=vax1, by(yrsafterrta)
gen vax_treat_high= vax_treat+1.645*vax_treat_se
gen vax_treat_low= vax_treat-1.645*vax_treat_se
gen vax_control_high= vax_control+1.645*vax_control_se
gen vax_control_low= vax_control-1.645*vax_control_se
erase "./data/RTA_data.dta"

***************************
**Figure 5: RTA Event Study
***************************
#d ; 
line vax_treat vax_treat_high vax_treat_low vax_control vax_control_high vax_control_low yrsafterrta if yrsafter>=-20 & yrsafter<=20, 
	lcolor(navy navy navy gs8 gs8 gs8) lpattern(solid dash dash solid dash dash) xtitle("Normalized year of adoption of RTA") ytitle("")
	legend(label(1 "Treatment") label(4 "Control") order(1 4) position(7) ring(0) col(1) symxsize(*.5) region(style(none)))
	ylabel(.7(.05)1)
	plotregion(style(none)) graphregion(fcolor(white) lwidth(none) ilwidth(none) margin());
graph export "./figures_and_tables/rta_event_study.pdf", replace;	

