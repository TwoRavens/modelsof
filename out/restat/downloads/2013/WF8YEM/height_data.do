clear
set memory 10g
set matsize 6000
cd "\\Mfso01\MyDocs\liner\My Documents\Filer\"

*** 2000 ****

use "vpl.dta", clear
sort bidnr
save "vpl.dta", replace
use "linda00f.dta", clear
keep bidnr bidnrf burvkodf bciv blkfnov bald bkon bant bfoland bnationt carb tlont nrv cbrutto csfvi cprim isocbid tkassa tarbst ivpltot istud bkungr bkuinst bystm barbink bstoran blillan tsjpersl tforpl tvuxers ctrapspl ctrapspl bfamst tkers tatjr takost bkungr pfp																																						
destring bkungr, replace
gen year = 2000
gen age = bald
gen cohort = 2000 - age
drop bald
sort bidnr
merge bidnr using "vpl.dta"
drop if _merge == 2
drop _merge
save "linda00_height.dta", replace

use "li00lonf", clear
keep bidnr manlon ssyk
rename manlon manlon_f
rename ssyk ssyk_f
sort bidnr
save "temp_li00lonf", replace

use "li00lon", clear
rename manlon manlon_b
rename ssyk ssyk_b
keep bidnr manlon ssyk
sort bidnr
merge bidnr using "temp_li00lonf"
drop _merge
sort bidnr
save "temp_li00loner", replace

use "linda00_height.dta", clear
sort bidnr
merge bidnr using "temp_li00loner"
save "linda00_height.dta", replace

*** 2001 ***

use "vpl.dta", clear
sort bidnr
save "vpl.dta", replace
use "linda01f.dta", clear
keep bidnr bidnrf burvkodf bciv blkfnov bald bkon bant bfoland bnationt carb tlont nrv cbrutto csfvi cprim isocbid tkassa tarbst ivpltot istud bkungr bkuinst bystm barbink bstoran blillan tsjpersl tforpl tvuxers ctrapspl bfamst tkers tatjr takost bkungr pfp																																					
destring bkungr, replace
gen year = 2001
gen age = bald
gen cohort = 2001 - age
drop bald
sort bidnr
merge bidnr using "vpl.dta"
drop if _merge == 2
drop _merge
save "linda01_height.dta", replace

use "li01lonf", clear
keep bidnr manlon ssyk
rename manlon manlon_f
rename ssyk ssyk_f
sort bidnr
save "temp_li01lonf", replace

use "li01lon", clear
rename manlon manlon_b
rename ssyk ssyk_b
keep bidnr manlon ssyk
sort bidnr
merge bidnr using "temp_li01lonf"
drop _merge
sort bidnr
save "temp_li01loner", replace

use "linda01_height.dta", clear
sort bidnr
merge bidnr using "temp_li01loner"
save "linda01_height.dta", replace

*** 2002 ***

use "vpl.dta", clear
sort bidnr
save "vpl.dta", replace
use "linda02f.dta", clear
keep bidnr bidnrf burvkodf bciv blkfnov bald bkon bant bfland bnat carb tlont nrv cbrutto csfvi cprim isocbid tkassa tarbst ivpltot istud bkungr bkuinst bystm barbink bstoran blillan tsjpersl tforpl tvuxers ctrapspl bfamst tkers tatjr takost bkungr pfp																																					
destring bkungr, replace
gen year = 2002
gen age = bald
gen cohort = 2002 - age
drop bald
sort bidnr
merge bidnr using "vpl.dta"
drop if _merge == 2
drop _merge
save "linda02_height.dta", replace

use "li02lonf", clear
keep bidnr manlon ssyk
rename manlon manlon_f
rename ssyk ssyk_f
sort bidnr
save "temp_li02lonf", replace

use "li02lon", clear
rename manlon manlon_b
rename ssyk ssyk_b
keep bidnr manlon ssyk
sort bidnr
merge bidnr using "temp_li02lonf"
drop _merge
sort bidnr
save "temp_li02loner", replace

use "linda02_height.dta", clear
sort bidnr
merge bidnr using "temp_li02loner"
save "linda02_height.dta", replace


*** 2003 ***

use "vpl.dta", clear
sort bidnr
save "vpl.dta", replace
use "linda03f.dta", clear
keep bidnr bidnrf burvkodf bciv blkfnov bald bkon bant bfland bnat carb tlont nrv cbrutto csfvi cprim isocbid tkassa tarbst ivpltot istud bkungr bkuinst bystm barbink bstoran blillan tsjpersl tforpl tvuxers ctrapspl bfamst tkers tatjr takost bkungr pfpatp																																						
destring bkungr, replace
gen year = 2003
gen age = bald
gen cohort = 2003 - age
drop bald
sort bidnr
merge bidnr using "vpl.dta"
drop if _merge == 2
drop _merge
save "linda03_height.dta", replace

use "li03lonf", clear
keep bidnr manlon ssyk
rename manlon manlon_f
rename ssyk ssyk_f
sort bidnr
save "temp_li03lonf", replace

use "li03lon", clear
rename manlon manlon_b
rename ssyk ssyk_b
keep bidnr manlon ssyk
sort bidnr
merge bidnr using "temp_li03lonf"
drop _merge
sort bidnr
save "temp_li03loner", replace

use "linda03_height.dta", clear
sort bidnr
merge bidnr using "temp_li03loner"
save "linda03_height.dta", replace

*** 2004 ***

use "vpl.dta", clear
sort bidnr
save "vpl.dta", replace
use "linda04f.dta", clear
keep bidnr bidnrf burvkodf bsunniv bsuninr bsunar bciv blkfnov bald bkon bant bfland bnat carb tlont nrv cbrutto csfvi cprim isocbid tkassa tarbst ivpltot istud bkungr bkuinst bystm barbink bstoran blillan tsjpersl tforpl tvuxers ctrapspl bfamst tkers tatjr takost bkungr tsal																																	
destring bkungr, replace
gen year = 2004
gen age = bald
gen cohort = 2004 - age
drop bald
sort bidnr
merge bidnr using "vpl.dta"
drop if _merge == 2
drop _merge
save "linda04_height.dta", replace

use "li04lonf", clear
keep bidnr manlon ssyk
rename manlon manlon_f
rename ssyk ssyk_f
sort bidnr
save "temp_li04lonf", replace

use "li04lon", clear
rename manlon manlon_b
rename ssyk ssyk_b
keep bidnr manlon ssyk
sort bidnr
merge bidnr using "temp_li04lonf"
drop _merge
sort bidnr
save "temp_li04loner", replace

use "linda04_height.dta", clear
sort bidnr
merge bidnr using "temp_li04loner"
save "linda04_height.dta", replace


*** 2005 ***

use "vpl.dta", clear
sort bidnr
save "vpl.dta", replace
use "linda05f.dta", clear
keep bidnr bidnrf burvkodf bsunniv bsuninr bsunar bciv blkfnov bald bkon bant bfland bnat carb tlont nrv cbrutto csfvi cprim isocbid tkassa tarbst ivpltot istud bkungr bkuinst bystm barbink bstoran blillan tsjpersl tforpl tvuxers ctrapspl bfamst tkers tatjr takost bkungr tsal																																						
destring bkungr, replace
gen year = 2005
gen age = bald
gen cohort = 2005 - age
drop bald
sort bidnr
merge bidnr using "vpl.dta"
drop if _merge == 2
drop _merge
save "linda05_height.dta", replace

use "li05lonf", clear
keep bidnr manlon ssyk
rename manlon manlon_f
rename ssyk ssyk_f
sort bidnr
save "temp_li05lonf", replace

use "li05lon", clear
rename manlon manlon_b
rename ssyk ssyk_b
keep bidnr manlon ssyk
sort bidnr
merge bidnr using "temp_li05lonf"
drop _merge
sort bidnr
save "temp_li05loner", replace

use "linda05_height.dta", clear
sort bidnr
merge bidnr using "temp_li05loner"
save "linda05_height.dta", replace


*** 2006 ***

use "vpl.dta", clear
sort bidnr
save "vpl.dta", replace
use "linda06f.dta", clear
keep bidnr bidnrf burvkodf bsunniv bsuninr bsunar bciv blkfnov bald bkon bant bfland bnat carb tlont nrv cbrutto csfvi cprim isocbid tkassa tarbst ivpltot istud bkungr bkuinst bystm barbink bstoran blillan tsjpersl tforpl tvuxers ctrapspl bfamst tkers tatjr takost bkungr tsal																																
destring bkungr, replace
gen year = 2006
gen age = bald
gen cohort = 2006 - age
drop bald
sort bidnr
merge bidnr using "vpl.dta"
drop if _merge == 2
drop _merge
save "linda06_height.dta", replace

use "li06lonf", clear
keep bidnr manlon ssyk
rename manlon manlon_f
rename ssyk ssyk_f
sort bidnr
save "temp_li06lonf", replace

use "li06lon", clear
rename manlon manlon_b
rename ssyk ssyk_b
keep bidnr manlon ssyk
sort bidnr
merge bidnr using "temp_li06lonf"
drop _merge
sort bidnr
save "temp_li06loner", replace

use "linda06_height.dta", clear
sort bidnr
merge bidnr using "temp_li06loner"
save "linda06_height.dta", replace


*** 2007 ***

use "vpl.dta", clear
sort bidnr
save "vpl.dta", replace
use "linda07f.dta", clear
keep bidnr bidnrf burvkodf bsunniv bsuninr bsunar bciv blkfnov bald bkon bant bfland bnat carb tlont nrv cbrutto csfvi cprim isocbid tkassa tarbst ivpltot istud bkungr bkuinst bystm barbink bstoran blillan tsjpersl tforpl tvuxers ctrapspl bfamst tkers tatjr takost bkungr tsal																																						
destring bkungr, replace
gen year = 2007
gen age = bald
gen cohort = 2007 - age
drop bald
sort bidnr
merge bidnr using "vpl.dta"
drop if _merge == 2
drop _merge
save "linda07_height.dta", replace

use "li07lonf", clear
keep bidnr manlon ssyk
rename manlon manlon_f
rename ssyk ssyk_f
sort bidnr
save "temp_li07lonf", replace

use "li07lon", clear
rename manlon manlon_b
rename ssyk ssyk_b
keep bidnr manlon ssyk
sort bidnr
merge bidnr using "temp_li07lonf"
drop _merge
sort bidnr
save "temp_li07loner", replace

use "linda07_height.dta", clear
sort bidnr
merge bidnr using "temp_li07loner"
save "linda07_height.dta", replace

*** MERGE YEARS ***

use "linda07_height.dta", clear
append using "linda06_height.dta"
append using "linda05_height.dta"
append using "linda04_height.dta"
append using "linda03_height.dta"
append using "linda02_height.dta"
append using "linda01_height.dta"


*** Sample selection

gen sample = 1 if burvkodf == 1 & burvkodf~=. & year >= 1991 & year~=.
replace sample = 0 if bkon~=1
replace sample = 0 if cohort<= 1950
replace sample = 0 if cohort >= 1977
keep if sample == 1


save "height.dta", replace










