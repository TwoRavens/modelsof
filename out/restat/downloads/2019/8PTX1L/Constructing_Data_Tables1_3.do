/*Note 1: Annual raw data for each year between 1995 to 2010 comes from the Annual Manufacturing Survey (AMS) available at DANE's data processing center. Save this do file and the dataset "control.dta" and "ipp.dta" with the AMS raw data and run the do file. */
/*Note 2: The raw data is available in SAS, before running this do file export all raw data files to stata*/
********************************************************************************
**Making Years Homogeneous across variables*************************************
********************************************************************************
clear all
set more off
cd "\\bdatos_server\SALA DE PROCESAMIENTO\TC6_UNIVERSIDAD CASTILLA\SANDRA ROZO\ENTRA\Stata_files\" /*set preferred folder path*/
*************
**1995-1997**
*************
forvalues i=95(1)97 {
use mpio-`i'.dta, clear
duplicates drop nordest, force
sort nordest
save mpio-`i'.dta, replace

use c26-`i'.dta, clear
duplicates drop nordest, force
sort nordest
merge 1:1 nordest using mpio-`i'.dta
drop if mpio==.
keep  nordemp nordest mpio dpto 
save 19`i'.dta, replace

use c35-`i'.dta, clear
duplicates drop nordest, force
g gpf=c3r1c1+c3r2c1+c3r3c1+c3r4c1+ ///
c3r5c1+c3r6c1+c3r7c1+c3r8c1+c3r9c1
g gpav=c3r1c2+c3r2c2+c3r3c2+c3r4c2+c3r5c2+ ///
c3r6c2+c3r7c2+c3r8c2+c3r9c2
g gp=gpf+gpav
keep nordest gp 
save c35.dta, replace

use 19`i'.dta, clear
merge 1:1 nordest using c35.dta
drop _merge
drop if mpio==.
save 19`i'.dta, replace
erase c35.dta

use c4-`i'.dta, clear
duplicates drop nordest, force
g e_prop_mb=c4r1c1
g e_prop_hb=c4r1c2
g e_perm_mb=c4r2c1
g e_perm_hb=c4r2c2
g e_tem_mb=c4r3c1+c4r4c1
g e_tem_hb=c4r3c2+c4r4c2
g e_prop_mw=c4r1c3
g e_prop_hw=c4r1c4
g e_perm_mw=c4r2c3
g e_perm_hw=c4r2c4
g e_tem_mw=c4r3c3+c4r4c3
g e_tem_hw=c4r3c4+c4r4c4
keep nordemp nordest e_prop_mb-e_tem_hw
save c4`i'.dta, replace

use 19`i'.dta, clear
merge 1:1 nordest using c4`i'.dta
drop _merge
drop if mpio==.
save 19`i'.dta, replace
erase c4`i'.dta

use p-`i'.dta, clear
g np=1
collapse (sum) valorven, by (nordest)
sort nordest
save p.dta, replace
use 19`i'.dta, clear
sort nordest
merge 1:1 nordest using p.dta
drop if mpio==.
drop _merge
save 19`i'.dta, replace
erase p.dta
}

*************
**1998-1999**
*************
clear all
forvalues i=98(1)99{
use mpio-`i'.dta, clear
duplicates drop nordest, force
sort nordest
save mpio-`i'.dta, replace

use c26-`i'.dta, clear
duplicates drop nordest, force
merge 1:1 nordest using mpio-`i'.dta
drop if mpio==.
keep  nordemp nordest mpio dpto 
save 19`i'.dta, replace

use c35-`i'.dta, clear
duplicates drop nordest, force
g gpf=c3r1c1+c3r2c1+c3r3c1+c3r4c1+ ///
c3r5c1+c3r6c1+c3r7c1+c3r8c1+c3r9c1
g gpav=c3r1c2+c3r2c2+c3r3c2+c3r4c2+c3r5c2+ ///
c3r6c2+c3r7c2+c3r8c2+c3r9c2
g gp=gpf+gpav
keep nordest gp
save c35.dta, replace

use 19`i'.dta, clear
sort nordest
merge 1:1 nordest using c35.dta
drop _merge
drop if mpio==.
save 19`i'.dta, replace
erase c35.dta

use c4-`i'.dta, clear
duplicates drop nordest, force
g e_prop_mb=c4r1c1
g e_prop_hb=c4r1c2
g e_perm_mb=c4r2c1
g e_perm_hb=c4r2c2
g e_tem_mb=c4r3c1+c4r4c1
g e_tem_hb=c4r3c2+c4r4c2
g e_prop_mw=c4r1c3
g e_prop_hw=c4r1c4
g e_perm_mw=c4r2c3
g e_perm_hw=c4r2c4
g e_tem_mw=c4r3c3+c4r4c3
g e_tem_hw=c4r3c4+c4r4c4
keep nordemp nordest e_prop_mb-e_tem_hw
save c4`i'.dta, replace

use 19`i'.dta, clear
merge 1:1 nordest using c4`i'.dta
drop _merge
drop if mpio==.
save 19`i'.dta, replace
erase c4`i'.dta

use p-`i'.dta, clear
collapse (sum) valorven, by (nordest)
save p.dta, replace

use 19`i'.dta, clear
merge 1:1 nordest using p.dta
drop if mpio==.
drop _merge
save 19`i'.dta, replace
}

***********
**2000-02**
***********
clear all
forvalues i=0(1)2{
use mpio-0`i'.dta, clear
sort nordest
save mpio-0`i'.dta, replace

use c26-0`i'.dta, clear
sort nordest
merge 1:1 nordest using mpio-0`i'.dta
drop _merge
drop if mpio==.
keep  nordemp nordest mpio dpto 
save 200`i'.dta, replace

use c35-0`i'.dta, clear
duplicates drop nordest, force
g gpf_w=c3r1pt+c3r2pt+c3r4pt+c3r4pt+ ///
c3r5pt+c3r6pt+c3r7pt+c3r8pt+c3r9pt
g gpf_b=c3r1c1+c3r2c1+c3r3c1+c3r4c1+ ///
c3r5c1+c3r6c1+c3r7c1+c3r8c1+c3r9c1
g gpav=c3r1c2+c3r2c2+c3r3c2+c3r4c2+c3r5c2+ ///
c3r6c2+c3r7c2+c3r8c2+c3r9c2
g gp=gpf_w+gpf_b+gpav
keep nordest gp
save c35.dta, replace

use 200`i'.dta, clear
sort nordest
merge 1:1 nordest using c35.dta
drop _merge
drop if mpio==.
save 200`i'.dta, replace
erase c35.dta

use c4-0`i'.dta, clear
g e_prop_mb=c4r1c1
g e_prop_hb=c4r1c2
g e_perm_mb=c4r2c1
g e_perm_hb=c4r2c2
g e_tem_mb=c4r3c1+c4r4c1
g e_tem_hb=c4r3c2+c4r4c2
g e_prop_mw=c4r1c3+c4r1c1n+c4r2c1e
g e_prop_hw=c4r1c4+c4r1c2n+c4r2c2e
g e_perm_mw=c4r2c3+c4r1c3n+c4r2c3e
g e_perm_hw=c4r2c4+c4r1c4n+c4r2c4e
g e_tem_mw=c4r3c3+c4r1c5n+c4r2c5e+c4r4c3+c4r1c7n+c4r2c7e
g e_tem_hw=c4r3c4+c4r1c6n+c4r2c6e+c4r4c4+c4r1c8n+c4r2c8e
keep nordemp nordest e_prop_mb-e_tem_hw
save c40`i'.dta, replace
use 200`i'.dta, clear
sort nordest
merge 1:1 nordest using c40`i'.dta
drop _merge
drop if mpio==.
save 200`i'.dta, replace
erase c40`i'.dta

use p-0`i'.dta, clear
collapse (sum) valorven, by (nordest)
save p.dta, replace
use 200`i'.dta, clear
sort nordest
merge 1:1 nordest using p.dta
drop if mpio==.
drop _merge
save 200`i'.dta, replace
erase p.dta
}

********
**2003**
********
use mpio-03.dta, clear
sort nordest
save mpio-03.dta, replace

use c26-03.dta, clear
sort nordest
merge 1:1 nordest using mpio-03.dta
drop _merge
drop if mpio==.
keep  nordemp nordest mpio dpto
save 2003.dta, replace

use c35-03.dta, clear
duplicates drop nordest, force
g gpf_w=c3r1pt+c3r2pt+c3r4pt+c3r4pt+ ///
c3r5pt+c3r6pt+c3r7pt+c3r8pt+c3r9pt
g gpf_b=c3r1c1+c3r2c1+c3r3c1+c3r4c1+ ///
c3r5c1+c3r6c1+c3r7c1+c3r8c1+c3r9c1
g gpav=c3r1c2+c3r2c2+c3r3c2+c3r4c2+c3r5c2+ ///
c3r6c2+c3r7c2+c3r8c2+c3r9c2
g gp=gpf_w+gpf_b+gpav
keep nordest gp
save c35.dta, replace
use 2003.dta, clear
sort nordest
merge 1:1 nordest using c35.dta
drop _merge
drop if mpio==.
save 2003.dta, replace
erase c35.dta

use c4-03.dta, clear
g e_prop_mb=c4r1c1
g e_prop_hb=c4r1c2
g e_perm_mb=c4r2c1
g e_perm_hb=c4r2c2
g e_tem_mb=c4r3c1+c4r4c1
g e_tem_hb=c4r3c2+c4r4c2
g e_prop_mw=c4r1c3+c4r1c1n+c4r2c1e
g e_prop_hw=c4r1c4+c4r1c2n+c4r2c2e
g e_perm_mw=c4r2c3+c4r1c3n+c4r2c3e
g e_perm_hw=c4r2c4+c4r1c4n+c4r2c4e
g e_tem_mw=c4r3c3+c4r1c5n+c4r2c5e+c4r4c3+c4r1c7n+c4r2c7e
g e_tem_hw=c4r3c4+c4r1c6n+c4r2c6e+c4r4c4+c4r1c8n+c4r2c8e
keep nordemp nordest e_prop_mb-e_tem_hw
save c403.dta, replace
use 2003.dta, clear
merge 1:1 nordest using c403.dta
drop _merge
drop if mpio==.
save 2003.dta, replace
erase c403.dta

use p-03.dta, clear
collapse (sum) valorven (mean), by (nordest)
save p.dta, replace
use 2003.dta, clear
sort nordest
merge 1:1 nordest using p.dta
drop if mpio==.
drop _merge
save 2003.dta, replace
erase p.dta
*******************
***2004-09*********
*******************
forvalues i=4(1)9{
use mpio-0`i'.dta, clear
sort nordest
save mpio-0`i'.dta, replace

use c26-0`i'.dta, clear
merge 1:1 nordest using mpio-0`i'.dta
drop _merge
drop if mpio==.
keep  nordemp nordest mpio dpto 
save 200`i'.dta, replace

use c35-0`i'.dta, clear
duplicates drop nordest, force
g gpf_w=c3r1pt+c3r2pt+c3r3pt+c3r4pt+ ///
c3r5pt+c3r6pt+c3r7pt+c3r8pt+c3r9pt
g gpf_b=c3r1c1+c3r2c1+c3r3c1+c3r4c1+ ///
c3r5c1+c3r6c1+c3r7c1+c3r8c1+c3r9c1
g gpav=c3r1c2+c3r2c2+c3r3c2+c3r4c2+c3r5c2+ ///
c3r6c2+c3r7c2+c3r8c2+c3r9c2
g gp=gpf_b+gpf_w+gpav
keep nordest gp
save c35.dta, replace
use 200`i'.dta, clear
merge 1:1 nordest using c35.dta
drop _merge
drop if mpio==.
save 200`i'.dta, replace

use c4-0`i'.dta, clear
g e_prop_mb=c4r1c1
g e_prop_hb=c4r1c2
g e_perm_mb=c4r2c1
g e_perm_hb=c4r2c2
g e_tem_mb=c4r3c1+c4r4c1
g e_tem_hb=c4r3c2+c4r4c2
g e_prop_mw=c4r1c3+c4r1c1n+c4r2c1e
g e_prop_hw=c4r1c4+c4r1c2n+c4r2c2e
g e_perm_mw=c4r2c3+c4r1c3n+c4r2c3e
g e_perm_hw=c4r2c4+c4r1c4n+c4r2c4e
g e_tem_mw=c4r3c3+c4r4c3+c4r1c5n+c4r1c7n+c4r2c5e+c4r2c7e
g e_tem_hw=c4r3c4+c4r4c4+c4r1c6n+c4r1c8n+c4r2c6e+c4r2c8e
keep nordemp nordest e_prop_mb-e_tem_hw
save c40`i'.dta, replace
use 200`i'.dta, clear
sort nordest
merge 1:1 nordest using c40`i'.dta
drop _merge
drop if mpio==.
save 200`i'.dta, replace
erase c40`i'.dta

use p-06.dta, clear
collapse (sum) valorven, by (nordest)
save p.dta, replace
use 200`i'.dta, clear
sort nordest
merge 1:1 nordest using p.dta
drop if mpio==.
drop _merge
save 200`i'.dta, replace
erase p.dta
}


****************
***2010*********
****************
use mpio-10.dta, clear
sort nordest
save mpio-10.dta, replace

use c26-10.dta, clear
sort nordest
merge 1:1 nordest using mpio-10.dta
drop _merge
drop if mpio==.
keep  nordemp nordest mpio dpto 
save 2010.dta, replace

use c35-10.dta, clear
duplicates drop nordest, force
g gpf_w=c3r1pt+c3r2pt+c3r3pt+c3r4pt+ ///
c3r5pt+c3r6pt+c3r7pt+c3r8pt+c3r9pt
g gpf_b=c3r1c1+c3r2c1+c3r3c1+c3r4c1+ ///
c3r5c1+c3r6c1+c3r7c1+c3r8c1+c3r9c1
g gpav=c3r1c2+c3r2c2+c3r3c2+c3r4c2+c3r5c2+ ///
c3r6c2+c3r7c2+c3r8c2+c3r9c2
g gp=gpf_b+gpf_w+gpav
keep nordest gp
save c35.dta, replace
use 2010.dta, clear
sort nordest
merge 1:1 nordest using c35.dta
drop _merge
drop if mpio==.
save 2010.dta, replace

use c4-10.dta, clear
g e_prop_mb=c4r1c1
g e_prop_hb=c4r1c2
g e_perm_mb=c4r2c1
g e_perm_hb=c4r2c2
g e_tem_mb=c4r3c1+c4r4c1
g e_tem_hb=c4r3c2+c4r4c2
g e_prop_mw=c4r1c3+c4r1c1n+c4r2c1e
g e_prop_hw=c4r1c4+c4r1c2n+c4r2c2e
g e_perm_mw=c4r2c3+c4r1c3n+c4r2c3e
g e_perm_hw=c4r2c4+c4r1c4n+c4r2c4e
g e_tem_mw=c4r3c3+c4r4c3+c4r1c5n+c4r1c7n+c4r2c5e+c4r2c7e
g e_tem_hw=c4r3c4+c4r4c4+c4r1c6n+c4r1c8n+c4r2c6e+c4r2c8e
keep nordemp nordest e_prop_mb-e_tem_hw
save c410.dta, replace
use 2010.dta, clear
merge 1:1 nordest using c410.dta
drop _merge
drop if mpio==.
save 2010.dta, replace
erase c410.dta

use p-10.dta, clear
collapse (sum) valorven, by (nordest)
save p.dta, replace
use 2010.dta, clear
sort nordest
merge 1:1 nordest using p.dta
drop if mpio==.
drop _merge
save 2010.dta, replace
erase p.dta


********************************************************************************
**Merging Panel*****************************************************************
********************************************************************************
clear all
cd "\\bdatos_server\SALA DE PROCESAMIENTO\TC6_UNIVERSIDAD CASTILLA\SANDRA ROZO\ENTRA\Stata_files\" /*set preferred folder path*/
set more off
forvalues i=1995(1)1999 {
use `i'.dta, clear
keep year nordest nordemp mpio dpto gp
e_prop_mb e_prop_hb e_perm_mb e_perm_hb ///
e_tem_mb e_tem_hb e_prop_mw e_prop_hw ///
e_perm_mw e_perm_hw e_tem_mw e_tem_hw ///
valorven 
save `i'r.dta, replace
}
forvalues i=2000(1)2010{
use `i'.dta, clear
keep year nordest nordemp mpio dpto gp
e_prop_mb e_prop_hb e_perm_mb e_perm_hb ///
e_tem_mb e_tem_hb e_prop_mw e_prop_hw ///
e_perm_mw e_perm_hw e_tem_mw e_tem_hw ///
valorven 
save `i'r.dta, replace
}

use 1995r.dta, clear
sort nordest year
save panel.dta, replace
forvalues i=1996(1)2010{
use panel.dta, clear
merge 1:1 nordest year using `i'r.dta
drop _merge
save panel.dta, replace
erase `i'r.dta
}
save panel.dta, replace
********************************************************************************
**Creating Main Variables*******************************************************
********************************************************************************
drop if nordemp==.
g e=e_prop_mb+e_prop_mw+e_prop_hb+e_prop_hw+e_perm_mb+e_perm_mw+e_perm_hb+e_perm_hw+e_tem_mb+e_tem_mw+e_tem_hb+e_tem_hw
label var year "1995-2011"
label var nordest "id firm"
label var gp "personnel expenditures"
label var e "Employees"
label var valorven "Production value"
rename valorven vv
merge m:1 year using ipp
drop if _merge==2
drop _merge
g rvv=vv/ipp
g w=(gp)/e
foreach var of varlist rvv w {
g l`var'=log(`var')
}
rename mpio muncod
keep year muncod nordest lrvv lw
save panel.dta, replace

merge m:1 muncod year using controls
drop if _merge==2
drop _merge
save panel.dta, replace


