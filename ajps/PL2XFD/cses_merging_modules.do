******************************************************************************
** file name: 	cses_merging_modules.do  									**
** purpose: 	merging four cses datasets in a single file					**
** paper:		gender, political knowledge and descriptive representation	**
** date: 		september 2017												**
** authors: 	Ruth Dassonneville and Ian McAllister						**
******************************************************************************


/* NOTE ON HOW TO RUN THIS DOFILE:
All CSES datasets can be found and downloaded on the CSES-website: http://www.cses.org/datacenter/download.htm
For running this do-file, first download the datasets and save them in your working directory
under the following names: 
- CSES_module 1.dta
- CSES_module 2.dta
- CSES_module 3.dta
- CSES_module 4.dta 
All datasets are in the 'Source datasets'-folder */

cd "/Users/ruthdassonneville/Desktop/gender and knowledge - replication/"

** RENAMING
** For merging module 1, 2, 3 and 4, I rename B1001-B1009, C1001-C1009 AND D1001-1009 into A1001-A1009

** MODULE 2 **
use "CSES_module 2.dta", clear

rename B1001 A1001
rename B1002 A1002
rename B1003 A1003
rename B1004 A1004
rename B1005 A1005
rename B1006 A1006
rename B1007 A1007
rename B1008 A1008
rename B1009 A1009

destring A1006, replace
destring A1008, replace
destring A1009, replace

save "CSES_module 2_new.dta", replace

** MODULE 3 **
use "CSES_module 3.dta", clear

rename C1001 A1001
rename C1002 A1002
rename C1003 A1003
rename C1004 A1004
rename C1005 A1005
rename C1006 A1006
rename C1007 A1007
rename C1008 A1008
rename C1009 A1009

destring A1006, replace
destring A1008, replace
destring A1009, replace

save "CSES_module 3_new.dta", replace


** MODULE 4 **

use "CSES_module 4.dta", clear

rename D1001 A1001
rename D1002_VER A1002
rename D1003 A1003
rename D1004 A1004
rename D1005 A1005
rename D1006 A1006
rename D1007 A1007
rename D1008 A1008
rename D1009 A1009

destring A1006, replace
destring A1008, replace
destring A1009, replace

save "CSES_module 4_new.dta", replace


** MERGING CSES MODULE 1, 2, 3 AND 4 

use "CSES_module 1.dta", clear
destring A1008, replace

gen flanders=1 if A1004=="BELF1999"
gen wallonia=1 if A1004=="BELW1999"

replace A1004="BEL_1999" if A1004=="BELF1999"
replace A1004="BEL_1999" if A1004=="BELW1999"

append using "CSES_module 2_new.dta" "CSES_module 3_new.dta" "CSES_module 4_new.dta"

** MODULE VARIABLE **

gen Module=.
replace Module=1 if A1001=="CSES-MODULE-1"
replace Module=2 if A1001=="CSES-MODULE-2"
replace Module=3 if A1001=="CSES-MODULE-3"
replace Module=4 if A1001=="CSES-MODULE-4"

** ERRORS

* Chile error in coding`; Germany phone and mail surveys combined
recode A1006  (1502 = 1520) (2761 2762=2760)

* Romania not consitently same three-letter code
replace A1004="ROU_2009" if A1004=="ROM_2009"

** error in Hong Kong A1004
replace A1004="HKG_2008" if A1004=="HGK_2008"

* Some countries name are missing in A1006
label define A1006 560 "Belgium" 3720 "Ireland"  4170 "Kyrgyzstan" 4990 "Montenegro" ///
5542 "New Zealand" 6880 "Serbia" 8402 "United States"
label values A1006 A1006

* identification of the election study - merge Germany 2002 mail and phone surveys
gen id_elect=A1004 
replace A1004="DEU_2002" if id_elect=="DEU22002" | id_elect=="DEU12002"
replace id_elect="DEU_2002" if A1004=="DEU_2002"
label variable id_elect "election study id (alpha polity)"

* country
gen country=A1006 
label values country A1006

*year of election
gen elect_year=A1008 
label variable elect_year "election year"


* generate A1004 variable with BE subsamples
replace flanders=1 if A1004=="BEL_2003" & A1007==1	// flemish subsample
replace wallonia=1 if A1004=="BEL_2003" & A1007==2	// walloon subsample

generate A1004BE=A1004
replace A1004BE="BELF1999" if A1004=="BEL_1999" & flanders==1
replace A1004BE="BELW1999" if A1004=="BEL_1999" & wallonia==1
replace A1004BE="BELF2003" if A1004=="BEL_2003" & flanders==1
replace A1004BE="BELW2003" if A1004=="BEL_2003" & wallonia==1

save "CSES_combined.dta", replace


