* Import BDS data to Haver AFter modifying in MATLAB
*
* Required Inputs:
* 	"bds_f_agemsa_release.csv" from the Business Dynamics Statistics Dataset
*
* Outputs:
* 	"BDS_Data_msa.dta"
* Created 11/5/2014 by Todd Messer
* Updated 5/28/2015 to just pull from the raw csv.  This gets rid of A LOT of
* 	useless files that have since been archived.

**************
* Import Data
**************
*cd "O:\PROJ_LIB\FirmEntryPersistence\MSA Data\Data\BDS"
*cd "/Users/michaelsiemer/Dropbox/FirmEntryPersistence/CleanedCodeTodd/MSA Data/Data/BDS"
cd "/Users/michaelsiemer/Dropbox/JMP Summer 2015/BDS"
import delimited using "bds_f_age_release.csv", clear delimiter(",") varnames(1)

* Rename Year
rename year2 year

* Get Age Letters
replace fage4 = substr(fage4,1,1)

* Replace Age Letters with Numbers
gen fage = .
replace fage = 0 if fage4=="a"
replace fage = 1 if fage4=="b"
replace fage = 2 if fage4=="c"
replace fage = 3 if fage4=="d"
replace fage = 4 if fage4=="e"
replace fage = 5 if fage4=="f"
replace fage = 10 if fage4=="g"
replace fage = 15 if fage4=="h"
replace fage = 20 if fage4=="i"
replace fage = 25 if fage4=="j"
replace fage = 26 if fage4=="k"
replace fage = 99 if fage4=="l"

**************
* Modify Data
**************
* Calculate the following statistics:
* 	1) Number of Startups
* 	2) Number of Young Firms (<5)
* 	3) Number of Young Firms (<10)
* 	4) Total number of firms
* 	5) Employment at Startup
* 	6) Employment at Young Firms (<5)
* 	7) Employment at Young Firms (<10)
* 	8) Total employment
bysort year: egen TotalFirms_BDS 	 = total(firms)
bysort year: egen StartupFirms_BDS	 = total(firms/(fage==0))
bysort year: egen YoungFirms_5_BDS  = total(firms/(fage<=5))
bysort year: egen YoungFirms_10_BDS = total(firms/(fage<=10))
bysort year: egen OldFirms_5_BDS  = total(firms/(fage>5))
bysort year: egen OldFirms_10_BDS = total(firms/(fage>10))
bysort year: egen ExitFirms_BDS= total(firmdeath_firms)
bysort year: egen ExitFirmsEmp_BDS= total(firmdeath_emp)


 levelsof fage, local(levels) 
 foreach l of local levels {
bysort year: egen NumFirms_Age_`l'	 = total(firms/(fage==`l'))
bysort year: egen EmpFirms_Age_`l'	 = total(emp/(fage==`l'))
bysort year: egen ExitFirms_Age_`l'	 = total(firmdeath_firms/(fage==`l'))
bysort year: egen ExitFirmsEmp_Age_`l'	 = total(firmdeath_emp/(fage==`l'))
bysort year: gen ExitFirmsRate_Age_`l'	 = ExitFirms_Age_`l' /NumFirms_Age_`l'
bysort year: gen ExitFirmsEmpRate_Age_`l' = ExitFirmsEmp_Age_`l' /EmpFirms_Age_`l'
bysort year: gen SizeFirm_Age_`l'=EmpFirms_Age_`l'/NumFirms_Age_`l'

}
bysort year: egen TotalEmp_BDS 	 = total(emp)
bysort year: egen StartupEmp_BDS	 = total(emp/(fage==0))

bysort year: egen YoungEmp_5_BDS  	 = total(emp/(fage<=5))
bysort year: egen YoungEmp_10_BDS 	 = total(emp/(fage<=10))
bysort year: egen OldEmp_5_BDS  	 = total(emp/(fage>5))
bysort year: egen OldEmp_10_BDS 	 = total(emp/(fage>10))
gen ExitFirmsRate_BDS= ExitFirms_BDS/TotalFirms_BDS 
gen ExitFirmsEmpRate_BDS= ExitFirmsEmp_BDS/TotalEmp_BDS 
gen NetEntryRate_BDS=(StartupFirms_BDS-ExitFirms_BDS)/TotalEmp_BDS 
bysort year: gen AvgSizeEntrants_BDS	 = StartupEmp_BDS/StartupFirms_BDS
bysort year: gen AvgSize_BDS	 = TotalEmp_BDS /TotalFirms_BDS 

*****************
* Create Datasets
*****************
* Keep unique observation for msa-year components
keep year *_BDS ExitFirms_BDS SizeFirm_Age* ExitFirmsEmp_BDS NumFirms_Age* EmpFirms_Age* ExitFirms_Age*  ExitFirmsRate_Age* ExitFirmsEmpRate_Age*  ExitFirmsEmp_Age* ExitFirmsRate_BDS ExitFirmsEmpRate_BDS NetEntryRate_BDS AvgSizeEntrants_BDS AvgSize_BDS
egen tag = tag(year)
keep if tag==1
drop tag

save "BDS_Data `c(current_date)'", replace


export excel using "/Users/michaelsiemer/Dropbox/JMP Summer 2015/BDS/BDS_for_Matlab.xls", firstrow(variables)

*keep year ExitFirms_BDS ExitFirmsEmp_BDS SizeFirm_Age* NumFirms_Age* EmpFirms_Age* ExitFirms_Age*  ExitFirmsRate_Age* ExitFirmsEmpRate_Age*  ExitFirmsEmp_Age* ExitFirmsRate_BDS ExitFirmsEmpRate_BDS NetEntryRate_BDS AvgSizeEntrants_BDS AvgSize_BDS


*save "BDS_Data_addon `c(current_date)'", replace
