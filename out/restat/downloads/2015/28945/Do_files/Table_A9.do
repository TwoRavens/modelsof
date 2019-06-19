*-----------------------------------------------------------------------------------------------------------------------------*
* This do file constructs Table A.9 of the web appendix of Berman and Couttenier (2014)										  *
* This version: january 29, 2014																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all
cd "$Results"
*
						*--------------------------------------------*
						*--------------------------------------------*
						*  		TABLE A9: DYAD FIXED EFFECTS  		 *
						*--------------------------------------------*
						*--------------------------------------------*
*
******************************
* Cols 1-2 : with UCDP - GED *
******************************
*			
use "$Output_data\data_BC_Restat2014", clear
compress
drop if conflict_c3 == .
collapse (mean) conflict_c3, by(gid iso3 year dyad_c3)
save temp, replace
*
foreach country in AGO BDI	BEN	BFA	CAF	CIV	CMR	COD	COG	COM	DJI	ERI	ESH	ETH	GHA	GIN	GMB	GNB	KEN	LBR	LSO	MDG	MLI	MOZ	MRT	NAM	NER	NGA	RWA	SDN	SEN	SLE	SOM	SWZ	TCD	TGO	TZA	UGA	ZAF	ZMB	ZWE{
use temp, clear
keep if iso3 == "`country'"
egen dyad_iso3 =  group(dyad_c3)
collapse (mean) conflict, by(gid iso3 dyad_iso3 dyad_c3)
save `country', replace
}
*
use AGO, clear
foreach country in 	BDI	BEN	BFA	CAF	CIV	CMR	COD	COG	COM	DJI	ERI	ESH	ETH	GHA	GIN	GMB	GNB	KEN	LBR	LSO	MDG	MLI	MOZ	MRT	NAM	NER	NGA	RWA	SDN	SEN	SLE	SOM	SWZ	TCD	TGO	TZA	UGA	ZAF	ZMB	ZWE{
append using `country'
}
*
foreach country in AGO	BDI	BEN	BFA	CAF	CIV	CMR	COD	COG	COM	DJI	ERI	ESH	ETH	GHA	GIN	GMB	GNB	KEN	LBR	LSO	MDG	MLI	MOZ	MRT	NAM	NER	NGA	RWA	SDN	SEN	SLE	SOM	SWZ	TCD	TGO	TZA	UGA	ZAF	ZMB	ZWE{
erase `country'.dta
}
*
drop conflict
sort gid iso3 dyad_iso3
egen gid_iso3 = group(gid iso3)
save temp0, replace
*
use temp0, clear
g test = 1
collapse (mean) test, by(iso3 dyad_iso3 dyad_c3)
drop test
sort iso3 dyad_iso3
save temp1, replace
*
use temp0, clear
g test = 1
collapse (mean) test, by(gid iso3 gid_iso3)
drop test
sort gid_iso3
save temp2, replace
*
use temp0, clear
fillin gid_iso3 dyad_iso3
*
drop gid iso3 dyad_c3
sort gid_iso3
merge gid_iso3 using temp2, nokeep
tab _merge
drop _merge 
*
sort  iso3 dyad_iso3
merge iso3 dyad_iso3 using temp1, nokeep
tab _merge
keep if _merge == 3
*
sort gid iso3 dyad_iso3 
expand 18
sort gid iso3 dyad_iso3 
bys  gid iso3 dyad_iso3: gen count=_n
g year = .
replace year = 1989 if count==1
forvalues t=1990(1)2006{
	replace year = `t' if year[_n-1] == `t'-1
}
*
drop count _merge _fillin
save temp0, replace
erase temp1.dta
erase temp2.dta
*
use "$Output_data\data_BC_Restat2014", clear
keep conflict_c3 dyad_c3 lshock_fao lshock_fao_dist exposure_crisis crisis_ldist gid year fao_region
sort gid  year
rename dyad_c3 dyad_c3_old
compress
save temp1, replace
*
use temp0, clear
compress
sort  gid year
merge gid year using temp1, nokeep
drop _merge

drop if  dyad_iso3 == .
sort gid dyad_iso3 year
egen group = group(gid iso3 dyad_iso3)
tsset group year
tab year, gen(yeard)
*
tab conflict_c3
replace conflict_c3 = 0 if dyad_c3 != dyad_c3_old
tab conflict_c3
/*regressions*/
eststo est_a1: xtreg  conflict_c3  lshock_fao 				  yeard*, fe ro cluster(fao_region)
eststo est_a2: xtreg  conflict_c3  lshock_fao lshock_fao_dist yeard*, fe ro cluster(fao_region)
*
eststo est_b1: xtreg  conflict_c3  exposure_crisis  			  yeard*, fe ro cluster(fao_region)
eststo est_b2: xtreg  conflict_c3  exposure_crisis crisis_ldist yeard*, fe ro cluster(fao_region)
*
erase temp1.dta
erase temp0.dta
*
**************************
* Cols 3-4: with ACLED I *
**************************
*			
use "$Output_data\data_BC_Restat2014", clear
compress
drop if conflict_c1 == .
collapse (mean) conflict_c1, by(gid iso3 year dyad_c1)
save temp, replace
*
foreach country in AGO	BDI	CAF	CIV	COD	COG	GIN	LBR	RWA	SDN	SLE	UGA{
use temp, clear
keep if iso3 == "`country'"
egen dyad_iso3 =  group(dyad_c1)
collapse (mean) conflict, by(gid iso3 dyad_iso3 dyad_c1)
save `country', replace
}
*
use AGO, clear
foreach country in	BDI	CAF	CIV	COD	COG	GIN	LBR	RWA	SDN	SLE	UGA{
append using `country'
}
*
foreach country in AGO	BDI	CAF	CIV	COD	COG	GIN	LBR	RWA	SDN	SLE	UGA{
erase `country'.dta
}
*
drop conflict
sort gid iso3 dyad_iso3
egen gid_iso3 = group(gid iso3)
save temp0, replace
*
use temp0, clear
g test = 1
collapse (mean) test, by(iso3 dyad_iso3 dyad_c1)
drop test
sort iso3 dyad_iso3
save temp1, replace
*
use temp0, clear
g test = 1
collapse (mean) test, by(gid iso3 gid_iso3)
drop test
sort gid_iso3
save temp2, replace
*
use temp0, clear
fillin gid_iso3 dyad_iso3
*
drop gid iso3 dyad_c1
sort gid_iso3
merge gid_iso3 using temp2, nokeep
tab _merge
drop _merge 
*
sort  iso3 dyad_iso3
merge iso3 dyad_iso3 using temp1, nokeep
tab _merge
keep if _merge == 3
*
sort gid iso3 dyad_iso3 
expand 27
sort gid iso3 dyad_iso3 
bys gid iso3 dyad_iso3: gen count=_n
g year = .
replace year = 1980 if count==1
forvalues t=1981(1)2006{
	replace year = `t' if year[_n-1] == `t'-1
}
drop count _merge _fillin
save temp0, replace
erase temp1.dta
erase temp2.dta
*
use "$Output_data\data_BC_Restat2014", clear
keep conflict_c1 dyad_c1 lshock_fao lshock_fao_dist exposure_crisis crisis_ldist gid year fao_region
sort gid  year
rename dyad_c1 dyad_c1_old
compress
save temp1, replace
*
use temp0, clear
compress
sort  gid year
merge gid year using temp1, nokeep
drop _merge
*
drop if  dyad_iso3 == .
sort gid dyad_iso3 year
egen group = group(gid iso3 dyad_iso3)
tsset group year
tab year, gen(yeard)
*
tab conflict_c1
replace conflict_c1 = 0 if dyad_c1 != dyad_c1_old 
tab conflict_c1
/* regressions */
eststo est_a3: xtreg  conflict_c1  lshock_fao 				  yeard*, fe ro cluster(fao_region)
eststo est_a4: xtreg  conflict_c1  lshock_fao lshock_fao_dist yeard*, fe ro cluster(fao_region)
*
eststo est_b3: xtreg  conflict_c1  exposure_crisis  			  yeard*, fe ro cluster(fao_region)
eststo est_b4: xtreg  conflict_c1  exposure_crisis crisis_ldist yeard*, fe ro cluster(fao_region)
*
erase temp1.dta
erase temp0.dta
*
***************************
* cols 5-6: with ACLED II *
***************************
*			
use "$Output_data\data_BC_Restat2014", clear
compress
drop if conflict_c2 == .
collapse (mean) conflict_c2, by(gid iso3 year dyad_c2)
save temp, replace
*
foreach country in AGO	BDI	BEN	BFA	BWA	CAF	CIV	CMR	COD	COG	DJI	ERI	ESH	ETH	GAB	GHA	GIN	GMB	GNB	GNQ	KEN	LBR	LSO	MDG	MLI	MOZ	MRT	MWI	NAM	NER	NGA	RWA	SDN	SEN	SLE	SOM	SWZ	TCD	TGO	TZA	UGA	ZAF	ZMB	ZWE{
use temp, clear
keep if iso3 == "`country'"
egen dyad_iso3 =  group(dyad_c2)
collapse (mean) conflict, by(gid iso3 dyad_iso3 dyad_c2)
save `country', replace
}
*
use AGO, clear
foreach country in	BDI	BEN	BFA	BWA	CAF	CIV	CMR	COD	COG	DJI	ERI	ESH	ETH	GAB	GHA	GIN	GMB	GNB	GNQ	KEN	LBR	LSO	MDG	MLI	MOZ	MRT	MWI	NAM	NER	NGA	RWA	SDN	SEN	SLE	SOM	SWZ	TCD	TGO	TZA	UGA	ZAF	ZMB	ZWE{
append using `country'
}
*
foreach country in AGO	BDI	BEN	BFA	BWA	CAF	CIV	CMR	COD	COG	DJI	ERI	ESH	ETH	GAB	GHA	GIN	GMB	GNB	GNQ	KEN	LBR	LSO	MDG	MLI	MOZ	MRT	MWI	NAM	NER	NGA	RWA	SDN	SEN	SLE	SOM	SWZ	TCD	TGO	TZA	UGA	ZAF	ZMB	ZWE{
erase `country'.dta
}
*
drop conflict
sort gid iso3 dyad_iso3
egen gid_iso3 = group(gid iso3)
save temp0, replace
*
use temp0, clear
g test = 1
collapse (mean) test, by(iso3 dyad_iso3 dyad_c2)
drop test
sort iso3 dyad_iso3
save temp1, replace
*
use temp0, clear
g test = 1
collapse (mean) test, by(gid iso3 gid_iso3)
drop test
sort gid_iso3
save temp2, replace
*
use temp0, clear
fillin gid_iso3 dyad_iso3
*
drop gid iso3 dyad_c2
sort gid_iso3
merge gid_iso3 using temp2, nokeep
tab _merge
drop _merge 
*
sort  iso3 dyad_iso3
merge iso3 dyad_iso3 using temp1, nokeep
tab _merge
keep if _merge == 3
*
sort gid iso3 dyad_iso3 
expand 19
sort gid iso3 dyad_iso3 
bys gid iso3 dyad_iso3: gen count=_n
g year = .
replace year = 1997 if count==1
forvalues t=1998(1)2006{
	replace year = `t' if year[_n-1] == `t'-1
}
*
drop count _merge _fillin
save temp0, replace
erase temp1.dta
erase temp2.dta

use "$Output_data\data_BC_Restat2014", clear
keep conflict_c2 dyad_c2 lshock_fao lshock_fao_dist exposure_crisis crisis_ldist gid year fao_region
sort gid  year
rename dyad_c2 dyad_c2_old
compress
save temp1, replace

use temp0, clear
compress
sort  gid year
merge gid year using temp1, nokeep
drop _merge

drop if  dyad_iso3 == .
sort gid dyad_iso3 year
egen group = group(gid iso3 dyad_iso3)
tsset group year
tab year, gen(yeard)
*
tab conflict_c2
replace conflict_c2 = 0 if dyad_c2 != dyad_c2_old 
tab conflict_c2
/* regressions */
eststo est_a5: xtreg  conflict_c2  lshock_fao 				  yeard*, fe ro cluster(fao_region)
eststo est_a6: xtreg  conflict_c2  lshock_fao lshock_fao_dist yeard*, fe ro cluster(fao_region)
*
eststo est_b5: xtreg  conflict_c2  exposure_crisis  			  yeard*, fe ro cluster(fao_region)
eststo est_b6: xtreg  conflict_c2  exposure_crisis crisis_ldist yeard*, fe ro cluster(fao_region)
*
erase temp1.dta
erase temp0.dta
erase temp.dta
*
global panel_a "est_a1 est_a2 est_a3 est_a4 est_a5 est_a6"
global panel_b "est_b1 est_b2 est_b3 est_b4 est_b5 est_b6"
*
log using "$Results\Table_A9.log", replace
*
esttab $panel_a, mtitles keep(lshock_fao lshock_fao_dist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab $panel_a, mtitles keep(lshock_fao lshock_fao_dist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
esttab $panel_b, mtitles keep(exposure_crisis crisis_ldist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab $panel_b, mtitles keep(exposure_crisis crisis_ldist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
*********************************
* TYPE OF CONFLICT AND DISTANCE *
*********************************
*
use "$Output_data\data_BC_Restat2014", clear
drop if conflict_c3 == . | year>1999
*
tab war if conflict_c1 == 1
tab war if conflict_c2 == 1
tab war if conflict_c3 == 1
*
gen location = group_gid
*
bys iso3 year: egen sum_conflict_c3 = max(conflict_c3)
bys iso3 year: egen sum_conflict_c1 = max(conflict_c1)

bys sum_conflict_c3: tab aim
bys sum_conflict_c3: tab ethwar

bys aim: tab conflict_c3
*
bys aim:    sum distance_cp if conflict_c3 == 1 & aim != ., d
bys ethwar: sum distance_cp if conflict_c3 == 1 & aim != ., d

bys aim:    sum bdist1 if conflict_c3 == 1 & aim != ., d
bys ethwar: sum bdist1 if conflict_c3 == 1 & aim != ., d

tab aim
