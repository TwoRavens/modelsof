********************************
** AIDS AND HUMAN CAPITAL    	**
** build.do                   **
** Fortson                    **
** DATA FROM: measuredhs.com	**
********************************

cap log close
clear
set mem 900m
set more off

local inputdir "C:\Documents and Settings\jfortson\My Documents\Work\AIDS HC\Data\Unzipped Original Files"
local outputdir "C:\Documents and Settings\jfortson\My Documents\Work\AIDS HC\Data\Revised Files"
local maindir "C:\Documents and Settings\jfortson\My Documents\Work\AIDS HC\Data"

log using "`maindir'\build.log", replace

local latestwave 1
  local latestwave_build 1
  local latestwave_clean 1
local allwaves 1
  local build_allwaves 1
  local clean_allwaves 1
  local merge_allwaves 1
local individual 1

***********************
*** COMPREGION CODE ***
***********************

* COMPREGION *

* Note that compregion is only designed to work with the survey-years in this file.
* If future surveys are released but have the same v000 values, the program could
* generate incorrect compregions.

cap n program drop compregion
program define compregion

quietly {

cap n gen x_compregion = .

cap n sum x_region
if _rc != 0 cap gen x_region = region
if _rc != 0 cap gen x_region = hv024
if _rc != 0 error(9999)

cap n sum v000
if _rc != 0 cap gen v000 = hv000
if _rc != 0 error(9999)

cap n sum v007
if _rc != 0 cap gen v007 = hv007
if _rc != 0 error(9999)

* First change v000 when there are duplicates (and it matters for compregion)

replace v000 = "RW3" if v007 == 2000 & substr(v000,1,2) == "RW" 

* BURKINA FASO (x_country == 1, 2003, not easily comparable)

replace x_compregion = x_region if v000 == "BF4"

* CAMEROON (x_country == 2, 2004, 1998, 1991)

* COMPREGION DEFINITIONS
* 1 = North/ Extreme north/ Ad
* 2 = Central, South, & East & West & Littoral (include Yaounde and Douala) 
* 3 = Northwest & southwest

replace x_compregion = 1 if (v000 == "CM4" & (x_region == 1 | x_region == 5 | x_region == 7)) | (v000 == "CM3" & x_region == 1) | (v000 == "CM2" & x_region == 2)
replace x_compregion = 2 if (v000 == "CM4" & (x_region == 2 | x_region == 4 | x_region == 10 | x_region == 12 | x_region == 3 | x_region == 6 | x_region == 9)) | (v000 == "CM3" & (x_region == 2 | x_region == 3)) | (v000 == "CM2" & (x_region == 1 | x_region == 3 | x_region == 4))
replace x_compregion = 3 if (v000 == "CM4" & (x_region == 8 | x_region == 11)) | (v000 == "CM3" & x_region == 4) | (v000 == "CM2" & x_region == 5)

* COTE D'IVOIRE (x_country == 3, only 2005, 1994)

* COMPREGION DEFINITIONS
* 1 = centre or centre nord
* 2 = centre-est
* 3 = centre-ouest
* 4 = nord
* 5 = nord-est
* 6 = nord-ouest
* 7 = ouest
* 8 = sud (includes abidjan)
* 9 = sud-ouest

* Made changes to combine centre and centre-nord

replace x_compregion = 1 if (v000 == "CI5" & (x_region == 1 | x_region == 3)) | (v000 == "CI3" & (x_region == 1 | x_region == 2)) 
replace x_compregion = 2 if (v000 == "CI5" & x_region == 2) | (v000 == "CI3" & x_region == 4)
replace x_compregion = 3 if (v000 == "CI5" & x_region == 4) | (v000 == "CI3" & x_region == 7)
replace x_compregion = 4 if (v000 == "CI5" & x_region == 5) | (v000 == "CI3" & x_region == 10)
replace x_compregion = 5 if (v000 == "CI5" & x_region == 6) | (v000 == "CI3" & x_region == 3)
replace x_compregion = 6 if (v000 == "CI5" & x_region == 7) | (v000 == "CI3" & x_region == 9)
replace x_compregion = 7 if (v000 == "CI5" & x_region == 8) | (v000 == "CI3" & x_region == 8)
replace x_compregion = 8 if (v000 == "CI5" & (x_region == 9 | x_region == 11)) | (v000 == "CI3" & x_region == 5)
replace x_compregion = 9 if (v000 == "CI5" & x_region == 10) | (v000 == "CI3" & x_region == 6)

* ETHIOPIA (x_country == 4, 2005, 2000)

* COMPREGION DEFINITIONS
* 1 = tigray 
* 2 = afar
* 3 = amhara
* 4 = oromiya
* 5 = somali
* 6 = ben-gumz
* 7 = snnp
* 8 = gambela
* 9 = harari
* 10 = addis abeba
* 11 = dire dawa

replace x_compregion = x_region if v000 == "ET4" & x_region <=7
replace x_compregion = 8 if v000 == "ET4" & x_region == 12
replace x_compregion = 9 if v000 == "ET4" & x_region == 13
replace x_compregion = 10 if v000 == "ET4" & x_region == 14
replace x_compregion = 11 if v000 == "ET4" & x_region == 15

* GHANA (x_country == 5, 2003, 1998, 1993)

* COMPREGION DEFINITIONS
* 1 = western
* 2 = central
* 3 = greater accra
* 4 = volta
* 5 = eastern
* 6 = ashanti
* 7 = brong ahafo
* 8 = northern
* 9 = upper west
* 10 = upper east

replace x_compregion = x_region if (v000 == "GH4" | v000 == "GH3" | v000 == "GH2") 

* GUINEA (x_country == 6, 2005, earlier waves not comparable)

replace x_compregion = x_region if v000 == "GN4"

* KENYA (x_country == 7, 2003, 1998, 1993)

* COMPREGION DEFINITIONS
* 1 = nairobi
* 2 = central
* 3 = coast
* 4 = eastern
* 5 = nyanza
* 6 = rift valley
* 7 = western

replace x_compregion = x_region if (v000 == "KE4" | v000 == "KE3" | v000 == "KE2") & x_region != 8
* does not include northeastern province (not surveyed in 1993, 1998)

* LESOTHO (x_country == 8, 2004, no previous waves)

replace x_compregion = x_region if v000 == "LS4"

* MALAWI (x_country == 9, 2004, 2000, 1992)

* COMPREGION DEFINITIONS
* 1 = northern
* 2 = central
* 3 = southern

replace x_compregion = x_region if (v000 == "MW4" | v000 == "MW2")

* MALI (x_country == 10, 2001, 1995/1996)

* COMPREGION DEFINITIONS
* 1 = kayes 
* 2 = koulikoro
* 3 = sikasso
* 4 = segou
* 5 = mopti
* 6 = tombouctou
* 7 = gao
* 8 = bamako

replace x_compregion = x_region if (v000 == "ML4" | v000 == "ML3") & x_region <=7
replace x_compregion = 8 if (v000 == "ML4" & x_region == 9) | (v000 == "ML3" & x_region == 8)
* kidal, surveyed in 2001 but not 1995/1996, is dropped 

* NIGER (x_country == 11, 2006, 1998, 1992)

* COMPREGION DEFINITIONS
* 1 = niamey
* 2 = dosso
* 3 = maradi
* 4 = tahoua/agadez
* 5 = tillaberi
* 6 = zinda/diffa

replace x_compregion = 1 if (v000 == "NI5" & x_region == 8) | (v000 == "NI3" & x_region == 1) | (v000 == "NI2" & x_region == 1)
replace x_compregion = 2 if (v000 == "NI5" & x_region == 3) | (v000 == "NI3" & x_region == 2) | (v000 == "NI2" & x_region == 4)
replace x_compregion = 3 if (v000 == "NI5" & x_region == 4) | (v000 == "NI3" & x_region == 3) | (v000 == "NI2" & x_region == 5)
replace x_compregion = 4 if (v000 == "NI5" & (x_region == 5 | x_region == 1)) | (v000 == "NI3" & x_region == 4) | (v000 == "NI2" & (x_region == 6 | x_region == 2))
replace x_compregion = 5 if (v000 == "NI5" & x_region == 6) | (v000 == "NI3" & x_region == 5) | (v000 == "NI2" & x_region == 7)
replace x_compregion = 6 if (v000 == "NI5" & (x_region == 2 | x_region == 7)) | (v000 == "NI3" & x_region == 6) | (v000 == "NI2" & (x_region == 3 | x_region == 8))

* RWANDA (x_country == 12, 2005, 2000)

* COMPREGION DEFINITIONS
* 1 = ville de kigali
* 2 = kigali ngali
* 3 = gitarama
* 4 = butare
* 5 = gikongoro
* 6 = cyangugu
* 7 = kibuye
* 8 = gisenyi
* 9 = ruhengeri
* 10 = byumba
* 11 = umutara
* 12 = kibungo

replace x_compregion = x_region if v000 == "RW4"
replace x_compregion = 1 if v000 == "RW3" & x_region == 9
replace x_compregion = 2 if v000 == "RW3" & x_region == 10
replace x_compregion = 3 if v000 == "RW3" & x_region == 6
replace x_compregion = 4 if v000 == "RW3" & x_region == 1
replace x_compregion = 5 if v000 == "RW3" & x_region == 4
replace x_compregion = 6 if v000 == "RW3" & x_region == 3
replace x_compregion = 7 if v000 == "RW3" & x_region == 8
replace x_compregion = 8 if v000 == "RW3" & x_region == 5
replace x_compregion = 9 if v000 == "RW3" & x_region == 11
replace x_compregion = 10 if v000 == "RW3" & x_region == 2
replace x_compregion = 11 if v000 == "RW3" & x_region == 12
replace x_compregion = 12 if v000 == "RW3" & x_region == 7

* SENEGAL (x_country == 13, 2005, data for 1999 are a pain)

replace x_compregion = x_region if v000 == "SN4"

* TANZANIA (x_country == 14, 2004, 2003(HIV), 1999, 1996)

* COMPREGION DEFINITIONS
* 1 = Dodoma
* 2 = Arusha (includes Manyara from 2003, 2004) 
* 3 = Kilimanjaro 
* 4 = Tanga
* 5 = Morogoro
* 6 = Pwani
* 7 = Dar Es Salam 
* 8 = Lindi
* 9 = Mtwara
* 10 = Ruvuma
* 11 = Iringa
* 12 = Mbeya
* 13 = Singida
* 14 = Tabora
* 15 = Rukwa
* 16 = Kigoma
* 17 = Shinyanga
* 18 = Kagera
* 19 = Mwanza
* 20 = Mara

replace x_compregion = x_region if (v000 == "TZ3" | v000 == "TZ4" | v000 == "TZ5") & x_region <= 20
replace x_compregion = 2 if (v000 == "TZ4" | v000 == "TZ5") & x_region == 21
* excludes pemba, rest of zanzibar (zanzibar north, south, touwn, pemba north, south), since we don't have HIV data

* ZAMBIA (x_country == 15, 2001/2002, 1996, 1992)

* COMPREGION DEFINITIONS
* 1 = Central
* 2 = Copperbelt
* 3 = Eastern
* 4 = Luapula
* 5 = Lusaka
* 6 = Northern
* 7 = North-Western
* 8 = Southern
* 9 = Western

replace x_compregion = x_region if (v000 == "ZM2" | v000 == "ZM3" | v000 == "ZM4") 

label var x_compregion "Comparable Region"

}

end

*******************
*** LATEST WAVE ***
*******************

if `latestwave' == 1 {

* This section creates combined.dta and cleaned.dta,
* which are the data files used for the main analysis.
* This includes just the most recent cross-section
* from each country.

*************
*** BUILD ***
*************

if `latestwave_build' == 1 {

** Merging household member recode files with hiv dataset

** Burkina Faso						
use "`inputdir'\bfar41fl.dta"
  rename hivclust hv001
  rename hivnumb hv002
  rename hivline hvidx
  sort hv001 hv002 hvidx
save "`outputdir'\BurkinaFaso_2003_HIV_r.dta", replace
clear

** Cameroon	
use "`inputdir'\CMAR42FL.dta"
  rename hivclust hv001
  rename hivnumb hv002
  rename hivline hvidx
  sort hv001 hv002 hvidx
save "`outputdir'\Cameroon_2004_HIV_r.dta", replace
clear

** Cote d'Ivoire					
use "`inputdir'\CIar50fl.dta"
  rename hivclust hv001
  rename hivnumb hv002
  rename hivline hvidx
  rename hivstruct shstruct
  sort hv001 shstruct hv002 hvidx
save "`outputdir'\CotedIvoire_2005_HIV_r.dta", replace
clear

** Ethiopia				
use "`inputdir'\ETar50fl.dta"
  rename hivclust hv001
  rename hivnumb hv002
  rename hivline hvidx
  sort hv001 hv002 hvidx
save "`outputdir'\Ethiopia_2005_HIV_r.dta", replace
clear

** Ghana					
use "`inputdir'\GHar4Afl.dta"
  rename hivclust hv001
  rename hivnumb hv002
  rename hivline hvidx
  sort hv001 hv002 hvidx
save "`outputdir'\Ghana_2003_HIV_r.dta", replace
clear

** Guinea						
use "`inputdir'\gnar51fl.dta"
  rename hivclust hv001
  rename hivnumb hv002
  rename hivline hvidx
  sort hv001 hv002 hvidx
save "`outputdir'\Guinea_2005_HIV_r.dta", replace
clear

** Kenya							
use "`inputdir'\KEar42fl.dta"
  rename hivclust hv001
  rename hivnumb hv002
  rename hivline hvidx
  sort hv001 hv002 hvidx
save "`outputdir'\Kenya_2003_HIV_r.dta", replace
clear

** Lesotho							
use "`inputdir'\lsar41fl.dta"
  rename hivclust hv001
  rename hivnumb hv002
  rename hivline hvidx
  sort hv001 hv002 hvidx
save "`outputdir'\Lesotho_2004_HIV_r.dta", replace
clear

** Malawi							
use "`inputdir'\MWar4Afl.dta"
  rename hivclust hv001
  rename hivnumb hv002
  rename hivline hvidx
  sort hv001 hv002 hvidx
save "`outputdir'\Malawi_2004_HIV_r.dta", replace
clear

** Mali							
use "`inputdir'\MLHT41FL.DTA"
  gen x_hivwt = hivpoids/1000000
  label var x_hivwt "HIV Weight"
  gen x_hiv = hiv_res
  label var x_hiv "HIV Test Result"

qui gen x_hiv_local = .
  local i = 1
  qui sum region
  scalar temp = r(max)
  while `i' <= temp {
    qui sum x_hiv [aw=x_hivwt] if region == `i' & age >=15 & age <= 49
    qui replace x_hiv_local = r(mean)*100 if region == `i' 
    local i = `i' + 1
  }

egen tag = tag(region)
keep if tag == 1
drop tag
keep region x_hiv_local
sort region
save "`outputdir'\Mali_2001_HIV_r.dta", replace
clear

** Niger							
use "`inputdir'\NIar50fl.dta"
  rename hivclust hv001
  rename hivnumb hv002
  rename hivline hvidx
  sort hv001 hv002 hvidx
save "`outputdir'\Niger_2006_HIV_r.dta",replace

** Rwanda							
use "`inputdir'\rwar51fl.dta"
  rename hivclust hv001
  rename hivnumb hv002
  rename hivline hvidx
  sort hv001 hv002 hvidx
save "`outputdir'\Rwanda_2005_HIV_r.dta", replace
clear

** Senegal						
use "`inputdir'\SNHT4HFL.DTA"
  rename hivclust hv001
  rename hivnumb hv002
  rename hivline hvidx
  rename hivconc shconces
  sort hv001 shconces hv002 hvidx
save "`outputdir'\Senegal_2005_HIV_r.dta", replace
clear

** Tanzania						
use "`inputdir'\TZar4Afl.dta"
  rename hivclust hv001
  rename hivnumb hv002
  rename hivline hvidx
  sort hv001 hv002 hvidx
save "`outputdir'\Tanzania_2003_HIV_r.dta",replace
clear

** Zambia							
use "`inputdir'\ZMHT41FL.DTA"
  gen region = hivprov
  label var region "Region"
  gen x_hivwt = hiv_wgt
  label var x_hivwt "HIV Weight"
  gen x_hiv = hivfinal
  replace x_hiv = 0 if x_hiv == 2
  label var x_hiv "HIV Test Result"

  qui gen x_hiv_local = .
  local i = 1
  qui sum region
  scalar temp = r(max)
  while `i' <= temp {
    qui sum x_hiv [aw=x_hivwt] if region == `i' & hivage >=15 & hivage <= 49
    qui replace x_hiv_local = r(mean)*100 if region == `i' 
    local i = `i' + 1
  }

egen tag = tag(hivprov)
keep if tag == 1
drop tag
keep hivprov x_hiv_local
sort hivprov
save "`outputdir'\Zambia_2001_HIV_r.dta", replace
clear

** Merging hiv dataset with household dataset		

** Burkina Faso						
use "`inputdir'\BFPR43FL.dta"
  sort hv001 hv002 hvidx
  merge hv001 hv002 hvidx using "`outputdir'\BurkinaFaso_2003_HIV_r.dta"
  quietly compress
  save "`outputdir'\BurkinaFaso_2003.dta", replace
clear

** Camerooon						
use "`inputdir'\CMPR44FL.DTA"
  sort hv001 hv002 hvidx
  merge hv001 hv002 hvidx using "`outputdir'\Cameroon_2004_HIV_r.dta"
  quietly compress
save "`outputdir'\Cameroon_2004.dta", replace
clear

** Cote d'Ivoire						
use "`inputdir'\CIPR50FL.dta"
  sort hv001 shstruct hv002 hvidx
  merge hv001 shstruct hv002 hvidx using "`outputdir'\CotedIvoire_2005_HIV_r.dta"
  quietly compress
  save "`outputdir'\CotedIvoire_2005.dta", replace
clear

** Ethiopia						
use "`inputdir'\ETPR50FL.DTA"
  sort hv001 hv002 hvidx
  merge hv001 hv002 hvidx using "`outputdir'\Ethiopia_2005_HIV_r.dta"
  quietly compress
  save "`outputdir'\Ethiopia_2005.dta", replace
clear

** Ghana					
use "`inputdir'\GHPR4AFL.DTA"
  sort hv001 hv002 hvidx
  merge hv001 hv002 hvidx using "`outputdir'\Ghana_2003_HIV_r.dta"
  quietly compress
  save "`outputdir'\Ghana_2003.dta", replace
clear

** Guinea							
use "`inputdir'\GNPR52FL.dta"
  sort hv001 hv002 hvidx
  merge hv001 hv002 hvidx using "`outputdir'\Guinea_2005_HIV_r.dta"
  quietly compress
  save "`outputdir'\Guinea_2005.dta", replace
clear

** Kenya							
use "`inputdir'\KEPR41FL.dta"
  sort hv001 hv002 hvidx
  merge hv001 hv002 hvidx using "`outputdir'\Kenya_2003_HIV_r.dta"
  quietly compress
  save "`outputdir'\Kenya_2003.dta", replace
clear

** Lesotho							
use "`inputdir'\LSPR41FL.dta"
  sort hv001 hv002 hvidx
  merge hv001 hv002 hvidx using "`outputdir'\Lesotho_2004_HIV_r.dta"
  quietly compress
  save "`outputdir'\Lesotho_2004.dta", replace
clear

** Malawi							
use "`inputdir'\MWPR4CFL.dta"
  sort hv001 hv002 hvidx
  merge hv001 hv002 hvidx using "`outputdir'\Malawi_2004_HIV_r.dta"
  quietly compress
  save "`outputdir'\Malawi_2004.dta", replace
clear

** Mali							
use "`inputdir'\MLPR41FL.DTA"
  gen region = hv024
  sort region 
  merge region using "`outputdir'\Mali_2001_HIV_r.dta"
  tab _merge
  drop if _merge == 2
  save "`outputdir'\Mali_2001.dta", replace
clear  

** Niger							
use "`inputdir'\NIPR50FL.dta"
  sort hv001 hv002 hvidx
  merge hv001 hv002 hvidx using "`outputdir'\Niger_2006_HIV_r.dta"
  save "`outputdir'\Niger_2006.dta", replace
clear

** Rwanda							
use "`inputdir'\RWPR52FL.dta"
  sort hv001 hv002 hvidx
  merge hv001 hv002 hvidx using "`outputdir'\Rwanda_2005_HIV_r.dta"
  quietly compress
  save "`outputdir'\Rwanda_2005.dta", replace
clear

** Senegal							
use "`inputdir'\SNPR4HFL.DTA"
  sort hv001 shconces hv002 hvidx
  merge hv001 shconces hv002 hvidx using "`outputdir'\Senegal_2005_HIV_r.dta"
  quietly compress
  save "`outputdir'\Senegal_2005.dta", replace
clear

** Tanzania						

use "`inputdir'\TZPR4AFL.DTA"
save "`outputdir'\Tanzania_2003.dta", replace

  sort hv001 hv002 hvidx
  merge hv001 hv002 hvidx using "`outputdir'\Tanzania_2003_HIV_r.dta"
  quietly compress
  save "`outputdir'\Tanzania_2003.dta", replace
clear

** Zambia							
use "`inputdir'\ZMPR42FL.dta"
  gen hivprov = hv024
  sort hivprov 
  merge hivprov using "`outputdir'\Zambia_2001_HIV_r.dta"
  tab _merge
  drop if _merge == 2
  quietly compress
  save "`outputdir'\Zambia_2001.dta", replace
clear


/*	renaming each hvXXX variable vXXX			*/

foreach name in "BurkinaFaso_2003" "Cameroon_2004" "CotedIvoire_2005" "Ethiopia_2005" "Ghana_2003" "Guinea_2005" "Kenya_2003" "Lesotho_2004" "Malawi_2004" "Mali_2001" "Niger_2006" "Rwanda_2005" "Senegal_2005" "Tanzania_2003" "Zambia_2001" {
  use "`outputdir'\\`name'.dta"
  aorder
  renpfix hv v
  save, replace
  clear
}

/*	create x_female dummy: 1 if female, 0 if male		
	and x_hiv dummy: 1 if tested pos, 0 if tested neg
	create x_momalive and x_dadalive 1 if yes 0 if no missing if dk or missing
*/

** Burkina Faso						
use "`outputdir'\BurkinaFaso_2003.dta"
gen x_hiv = hiv03
  replace x_hiv = 1 if x_hiv == 1 | x_hiv == 2 | x_hiv == 3
gen x_female = v104 - 1 // there are 2 missing values here, left coded as missing
gen x_hhweight = v005
gen x_momalive = v111
  replace x_momalive = . if x_momalive == 8
gen x_dadalive = v113
  replace x_dadalive = . if x_dadalive == 8
cap keep x_* v000 v001 v002 v003 v004 v005 v008 v109 v024 v007 v025 v105 v108 _merge hiv* v111 v113 v205-v212 vidx
save, replace
clear

** Cameroon						
use "`outputdir'\Cameroon_2004.dta"
gen x_hiv = 1 if hiv03 == 1
replace x_hiv = 0 if hiv03 == 0
gen x_female = v104 -1
gen x_hhweight = v005
gen x_momalive = v111
  replace x_momalive = . if x_momalive == 8
gen x_dadalive = v113
  replace x_dadalive = . if x_dadalive == 8
cap keep x_* v000 v001 v002 v003 v004 v005 v008 v109 v024 v025 v007 v025 v105 v108 _merge hivwt v111 v113 v205-v212 vidx
save, replace
clear

** Cote d'Ivoire					
use "`outputdir'\CotedIvoire_2005.dta"
gen x_hiv = hiv03
  replace x_hiv = . if x_hiv == 7 | x_hiv == . // codes indeterminants and missings as missing
gen x_female =  v104 - 1
gen x_hhweight = v105
gen x_momalive = v111
  replace x_momalive = . if x_momalive == 8
gen x_dadalive = v113
  replace x_dadalive = . if x_dadalive == 8
cap keep x_* v000 v001 v002 v003 v004 v005 v007 v008 v024 v025 v105 v108 v109 hiv05 shstruct v205-v212 vidx
save, replace
clear

** Ethiopia						
use "`outputdir'\Ethiopia_2005.dta"
gen x_hiv = hiv03
replace x_hiv = . if x_hiv == 8	//codes missings as missings
gen x_female = v104 -1
gen x_hhweight = v005
gen x_momalive = v111
  replace x_momalive = . if x_momalive == 8
gen x_dadalive = v113
  replace x_dadalive = . if x_dadalive == 8
cap keep x_* v000 v001 v002 v003 v004 v005 v008 v109 v024 v007 v025 v105 v108 _merge hiv05 v111 v113 v205-v212 vidx
save, replace
clear

** Ghana							
use "`outputdir'\Ghana_2003.dta"
gen x_hiv = hiv03
  replace x_hiv = . if x_hiv == 8 | x_hiv == 9 | x_hiv == . // codes unlabeled and missings as missings
  replace x_hiv = 1 if x_hiv == 2 | x_hiv == 3
gen x_female = v104-1
gen x_hhweight = v005
gen x_momalive = v111
  replace x_momalive = . if x_momalive == 8
gen x_dadalive = v113
  replace x_dadalive = . if x_dadalive == 8
cap keep x_* v000 v001 v002 v003 v004 v005 v008 v109 v024 v007 v025 v105 v108 _merge hiv05 v111 v113 v205-v212 vidx
save, replace
clear

** Guinea							
use "`outputdir'\Guinea_2005.dta"
gen x_hiv = hiv03
  replace x_hiv = . if x_hiv == 7 | x_hiv == . // codes indeterminants and missings as missings
gen x_female = v104 - 1
gen x_hhweight = v005
gen x_momalive = v111
  replace x_momalive = . if x_momalive == 8 | x_momalive == .
gen x_dadalive = v113
  replace x_dadalive = . if x_dadalive == 8 | x_dadalive == .
cap keep x_* v000 v001 v002 v003 v004 v005 v007 v008 v024 v025 v105 v108 v109 hiv05 v205-v212 vidx
save, replace
clear

** Kenya							
use "`outputdir'\Kenya_2003.dta"				
gen x_hiv = hiv03
  replace x_hiv = . if x_hiv == 7 //codes indeterminates as missing
gen x_female = v104 - 1
gen x_hhweight = v005
gen x_momalive = v111
  replace x_momalive = . if x_momalive == 8
gen x_dadalive = v113
  replace x_dadalive = . if x_dadalive == 8
cap keep x_* v000 v001 v002 v003 v004 v005 v109 v024 v007 v008 v025 v105 v108 _merge hiv05 v111 v113 v205-v212 vidx
save, replace
clear

** Lesotho							
use "`outputdir'\Lesotho_2004.dta"
gen x_hiv = hiv03
  replace x_hiv = . if x_hiv == 7	//codes indeterminates as missing
gen x_female = v104 -1
gen x_hhweight = v005
gen x_momalive = v111
  replace x_momalive = . if x_momalive == 8
gen x_dadalive = v113
  replace x_dadalive = . if x_dadalive == 8
cap keep x_* v000 v001 v002 v003 v004 v005 v008 v109 v024 v007 v025 v105 v108 _merge hiv05 v111 v113 v205-v212 vidx
save, replace
clear

** Malawi							
use "`outputdir'\Malawi_2004.dta"
gen x_hiv = hiv03
gen x_female = v104 -1
gen x_hhweight = v005
gen x_momalive = v111
  replace x_momalive = . if x_momalive == 8
gen x_dadalive = v113
  replace x_dadalive = . if x_dadalive == 8
cap keep x_* v000 v001 v002 v003 v004 v005 v008 v109 v024 v007 v025 v105 v108 _merge hiv05 v111 v113 v205-v212 vidx
save, replace
clear

** Mali							
use "`outputdir'\Mali_2001.dta"
gen x_female = v104-1
gen x_hhweight = v005
gen x_momalive = v111
  replace x_momalive = . if x_momalive == 8
gen x_dadalive = v113
  replace x_dadalive = . if x_dadalive == 8
cap keep x_* v000 v001 v002 v003 v004 v005 v008 v109 v024 v007 v025 v105 v108 _merge v111 v113 v205-v212 vidx hhid shconces
save, replace
clear

** Niger							
use "`outputdir'\Niger_2006.dta"
gen x_hiv = hiv03
  replace x_hiv = 1 if x_hiv == 1 | x_hiv == 2 | x_hiv == 3
gen x_female = v104-1
gen x_hhweight = v005
gen x_momalive = v111
  replace x_momalive = . if x_momalive == 8
gen x_dadalive = v113
  replace x_dadalive = . if x_dadalive == 8
cap keep x_* v000 v001 v002 v003 v004 v005 v008 v109 v024 v007 v025 v105 v108 _merge v111 v113 hiv05 v205-v212 vidx
save, replace
clear


** Rwanda							
use "`outputdir'\Rwanda_2005.dta"
gen x_hiv = hiv03
gen x_female = v104 - 1
gen x_hhweight = v005
gen x_momalive = v111
  replace x_momalive = . if x_momalive == 8 | x_momalive == .
gen x_dadalive = v113
  replace x_dadalive = . if x_dadalive == 8 | x_dadalive == .
cap keep x_* v000 v001 v002 v003 v004 v005 v007 v008 v024 v025 v105 v108 v109 hiv05 v205-v212 vidx
save, replace
clear

** Senegal							
use "`outputdir'\Senegal_2005.dta"
gen x_hiv = rhiv07c	// Senegal has testing for 2 types of HIV
replace x_hiv = . if x_hiv == 7	// codes indeterminates as missing
gen x_female = v104 -1
gen x_hhweight = v005
gen x_momalive = v111
  replace x_momalive = . if x_momalive == 8
gen x_dadalive = v113
  replace x_dadalive = . if x_dadalive == 8
keep x_* v000 v001 v002 v003 v004 v005 shconces v008 v109 v024 v007 v025 v105 v108 _merge rhivweight v111 v113 v205-v212 vidx
save, replace
clear

** Tanzania						
use "`outputdir'\Tanzania_2003.dta"
gen x_hiv = hiv03 // this dataset only has 0 1 and .
gen x_female = v104 -1
gen x_hhweight = v005
gen x_momalive = v111
  replace x_momalive = . if x_momalive == 8
gen x_dadalive = v113
  replace x_dadalive = . if x_dadalive == 8
keep x_* v000 v001 v002 v003 v004 v005 v109 v024 v007 v008 v025 v105 v108 _merge hiv05 v111 v113 v205-v212 vidx
save, replace
clear

** Zambia							
use "`outputdir'\Zambia_2001.dta"
gen x_female = v104-1
gen x_hhweight = v005
gen x_momalive = v111
  replace x_momalive = . if x_momalive == 8
gen x_dadalive = v113
  replace x_dadalive = . if x_dadalive == 8
keep x_* v000 v001 v002 v003 v004 v005 v109 v024 v007 v008 v025 v105 v108 _merge v111 v113 v205-v212 vidx
save, replace

******************************************************************
**								**
**			APPENDING PRELIM DATASETS		**
**								**
******************************************************************

use "`outputdir'\Senegal_2005.dta"
  append using "`outputdir'\Malawi_2004.dta"
  append using "`outputdir'\Lesotho_2004.dta"
  append using "`outputdir'\Ethiopia_2005.dta"
  append using "`outputdir'\Ghana_2003.dta"
  append using "`outputdir'\BurkinaFaso_2003.dta"
  append using "`outputdir'\Kenya_2003.dta"
  append using "`outputdir'\Cameroon_2004.dta"
  append using "`outputdir'\Tanzania_2003.dta"
  append using "`outputdir'\Mali_2001.dta"
  append using "`outputdir'\Zambia_2001.dta"
  append using "`outputdir'\CotedIvoire_2005.dta"
  append using "`outputdir'\Guinea_2005.dta"
  append using "`outputdir'\Rwanda_2005.dta"
  append using "`outputdir'\Niger_2006.dta"
save "`maindir'\combined.dta", replace
clear

}

*************
*** CLEAN ***
*************

if `latestwave_clean' == 1 {

use "`maindir'\combined.dta"

** WEIGHTS ***

replace x_hhweight = x_hhweight/1000000
label var x_hhweight "Household Weight"

gen x_hivweight = hiv05/1000000 if hiv05 != .
replace x_hivweight = rhivweight/1000000 if v000 == "SN4"
label var x_hivweight "HIV Sample Weight"

** OTHER VARIABLES **

* Country
gen x_bf = 1 if v000 == "BF4"
  replace x_bf = 0 if v000 != "BF4"
  label var x_bf "From Burkina Faso"
gen x_cm = 1 if v000 == "CM4"
  replace x_cm = 0 if v000 != "CM4"
  label var x_cm "From Cameroon"
gen x_ci = 1 if v000 == "CI5"
  replace x_ci = 0 if v000 != "CI5"
  label var x_ci "From Cote d'Ivoire"
gen x_et = 1 if v000 == "ET4"
  replace x_et = 0 if v000 != "ET4"
  label var x_et "From Ethiopia"
gen x_gh = 1 if v000 == "GH4"
  replace x_gh = 0 if v000 != "GH4"
  label var x_gh "From Ghana"
gen x_gn = 1 if v000 == "GN4"
  replace x_gn = 0 if v000 != "GN4"
  label var x_gn "From Guinea"
gen x_ke = 1 if v000 == "KE4"
  replace x_ke = 0 if v000 != "KE4"
  label var x_ke "From Kenya"
gen x_ls = 1 if v000 == "LS4"
  replace x_ls = 0 if v000 != "LS4"
  label var x_ls "From Lesotho"
gen x_ml = 1 if v000 == "ML4"
  replace x_ml = 0 if v000 != "ML4"
  label var x_ml "From Mali"
gen x_mw = 1 if v000 == "MW4"
  replace x_mw = 0 if v000 != "MW4"
  label var x_mw "From Malawi"
gen x_ni = 1 if v000 == "NI5"
  replace x_ni = 0 if v000 != "NI5"
  label var x_ni "From Niger"
gen x_rw = 1 if v000 == "RW4"
  replace x_rw = 0 if v000 != "RW4"
  label var x_rw "From Rwanda"
gen x_sn = 1 if v000 == "SN4"
  replace x_sn = 0 if v000 != "SN4"
  label var x_sn "From Senegal"
gen x_tz = 1 if v000 == "TZ5"
  replace x_tz = 0 if v000 != "TZ5"
  label var x_tz "From Tanzania"
gen x_zm = 1 if v000 == "ZM4"
  replace x_zm = 0 if v000 != "ZM4"
  label var x_zm "From Zambia"

gen x_country = 1 if x_bf == 1
replace x_country = 2 if x_cm == 1
replace x_country = 3 if x_ci == 1
replace x_country = 4 if x_et == 1
replace x_country = 5 if x_gh == 1
replace x_country = 6 if x_gn == 1
replace x_country = 7 if x_ke == 1
replace x_country = 8 if x_ls == 1
replace x_country = 9 if x_mw == 1
replace x_country = 10 if x_ml == 1
replace x_country = 11 if x_ni == 1
replace x_country = 12 if x_rw == 1
replace x_country = 13 if x_sn == 1
replace x_country = 14 if x_tz == 1
replace x_country = 15 if x_zm == 1

label define countries 1 "Burkina Faso" 2 "Cameroon" 3 "Cote d'Ivoire" 4 "Ethiopia" 5 "Ghana" 6 "Guinea" 7 "Kenya" 8 "Lesotho" 9 "Malawi" 10 "Mali" 11 "Niger" 12 "Rwanda" 13 "Senegal" 14 "Tanzania" 15 "Zambia" 
label values x_country countries
label var x_country "Country"

global country "x_bf x_cm x_ci x_et x_gh x_gn x_ke x_ls x_mw x_ml x_ni x_rw x_sn x_tz x_zm"

** ECONOMIC VARIABLES ***

* Education

gen x_educ = v108
replace x_educ = . if x_educ == 98
label var x_educ "Years of Schooling"

* Education > 0

gen x_educ_positive = 1 if x_educ>0 & x_educ!=.
replace x_educ_positive = 0 if x_educ == 0
label var x_educ_positive "Years of Schooling > 0"

* Education >= Primary

gen x_educ_primary = 1 if (v109 == 2 | v109 == 3 | v109 == 4 | v109 == 5) 
replace x_educ_primary = . if (v109 == 8 | v109 == .) 
replace x_educ_primary = 0 if (v109 == 0 | v109 == 1) 

* Assets

gen x_toilet = 1 if v205 >= 10 & v205 <=23 
replace x_toilet = 0 if v205 > 23 & v205 != .

gen x_electricity = 1 if v206 == 1
replace x_electricity = 0 if v206 == 0

gen x_radio = 1 if v207 == 1
replace x_radio = 0 if v207 == 0

gen x_tv = 1 if v208 == 1
replace x_tv = 0 if v208 == 0

gen x_refrigerator = 1 if v209 == 1
replace x_refrigerator = 0 if v209 == 0

gen x_bike = 1 if v210 == 1
replace x_bike = 0 if v210 == 0

gen x_motorcycle = 1 if v211 == 1
replace x_motorcycle = 0 if v211 == 0

gen x_car = 1 if v212 == 1
replace x_car = 0 if v212 == 0

gen x_assets_fraction = 0
gen x_temp = 0
foreach asset of varlist x_radio x_tv x_refrigerator x_bike x_motorcycle x_car x_toilet x_electricity {
  qui replace x_temp=x_temp+1 if `asset'==. 
}
foreach asset of varlist x_radio x_tv x_refrigerator x_bike x_motorcycle x_car x_toilet x_electricity {
  qui replace x_assets_fraction = x_assets_fraction + `asset' if `asset'!=.
}
*divide this by the number of components
replace x_assets_fraction = x_assets_fraction / (8-x_temp)
replace x_assets_fraction = . if x_temp>=5 & x_temp<=8
label var x_assets_fraction "Fraction of Assets"
drop x_temp

** DEMOGRAPHIC VARIABLES ***

* Age

gen x_age = v105
replace x_age = . if x_age == 98
label var x_age "Age in Years"

* Grades Behind

gen x_behind = .
replace x_behind = (x_age - 6) - x_educ
replace x_behind = 0 if x_behind == -1 
replace x_behind = . if x_behind < -1

* Five-Year Age Groups

gen x_age_1 = 1 if x_age >= 15 & x_age <=19
replace x_age_1 = 0 if x_age_1==.
label var x_age_1 "Age 15-19"

gen x_age_2 = 1 if x_age >= 20 & x_age <=24
replace x_age_2 = 0 if x_age_2==.
label var x_age_2 "Age 20-24"

gen x_age_3 = 1 if x_age >= 25 & x_age <= 29
replace x_age_3 = 0 if x_age_3==.
label var x_age_3 "Age 25-29"

gen x_age_4 = 1 if x_age >= 30 & x_age <= 34
replace x_age_4 = 0 if x_age_4==.
label var x_age_4 "Age 30-34"

gen x_age_5 = 1 if x_age >= 35 & x_age <= 39
replace x_age_5 = 0 if x_age_5==.
label var x_age_5 "Age 35-39"

gen x_age_6 = 1 if x_age >= 40 & x_age <= 44
replace x_age_6 = 0 if x_age_6==.
label var x_age_6 "Age 40-44"

gen x_age_7 = 1 if x_age >= 45 & x_age <= 49
replace x_age_7 = 0 if x_age_7==.
label var x_age_7 "Age 45-49"

gen x_age_8 = 1 if x_age >= 50 & x_age <= 54
replace x_age_8 = 0 if x_age_8==.
label var x_age_8 "Age 50-54"

gen x_age_9 = 1 if x_age >= 55 & x_age <= 59
replace x_age_9 = 0 if x_age_9==.
label var x_age_9 "Age 55-59"

* Urban/Rural

gen x_rural = 1 if v025 == 2
replace x_rural = 0 if v025 == 1
label var x_rural "Rural"

gen x_surveyyear = v007
replace x_surveyyear = 2005 if x_et == 1
label var x_surveyyear "Year of Survey"

gen x_hivsurveyyear = 2004 if x_ls == 1 | x_mw == 1 | x_cm == 1
replace x_hivsurveyyear = 2006 if x_ni == 1
replace x_hivsurveyyear = 2005 if x_et == 1 | x_sn == 1 | x_rw == 1 | x_gn == 1 | x_ci == 1
replace x_hivsurveyyear = 2003 if x_gh == 1 | x_bf == 1 | x_ke == 1 | x_tz == 1
replace x_hivsurveyyear = 2001 if x_ml == 1 
replace x_hivsurveyyear = 2001.5 if x_zm == 1

replace v008 = v008 + 92 if x_et == 1
gen x_yob = floor(1900 + (v008/12) - x_age)
label var x_yob "Year of Birth"

* Region

tab v024, gen(x_region_)
gen x_region = v024
replace x_region = . if x_region > 95


******************************************

foreach country in bf ci cm et gh gn ke ls mw ni rw sn tz  {
  di "`country'"
  local i = 1
  qui sum x_region if x_`country'==1
  scalar temp = r(max)
  while `i' <= temp {
    qui sum x_hiv [aw=x_hivweight] if x_`country'==1 & x_region == `i' & x_age >=15 & x_age <= 49
    qui replace x_hiv_local = r(mean)*100 if x_`country'==1 & x_region == `i' 
    local i = `i' + 1
  }
}

gen include = .

gen x_post = 0 if x_age >=15 & x_age < 50
replace x_post = 1 if x_yob >= 1980 & x_yob != . & x_age>=15 & x_age < 50

gen x_interact = x_hiv_local * x_post

egen x_fe = group(x_country x_region)
label var x_fe "Region Fixed Effects"

tab x_yob, gen(x_yobdummies_)
tab x_age, gen(x_agedummies_)

egen x_cluster = group(x_country x_region)

gen new_hiv = x_hiv_local if x_yob >= 1992 & x_yob!=.
replace new_hiv = 0 if x_yob < 1992 & x_yob != .

keep x_* v000 v001 v002 v007 vidx shconces shstruct include new_hiv hhid

sort x_country
merge x_country using "`maindir'\population.dta"

gen new_weight = .
foreach country in bf cm ci et gh gn ke ls mw ml ni rw sn tz zm  {
  sum x_hhweight if x_`country' == 1
  replace new_weight = (x_hhweight) * (x_population / r(sum)) if x_`country' == 1
  sum new_weight if x_`country' == 1
  return list
}

save "`maindir'\cleaned.dta", replace

}

}

*****************
*** ALL WAVES ***
*****************

if `allwaves' == 1 {

  if `build_allwaves' == 1 {
 
  clear
  drop _all
  set more off
 
  cd "`inputdir'"

  * Combine househould member recode files into one file

  /* Filenames
  CMPR22FL	Cameroon - 1991
  CMPR31FL	Cameroon - 1998
  CMPR44FL	Cameroon - 2004
  CIPR35FL	Cote d'Ivoire - 1994
  CIPR50FL	Cote d'Ivoire - 2005
  ETPR41FL	Ethiopia - 2000
  ETPR50FL	Ethiopia - 2005
  GHPR31FL	Ghana - 1993
  GHPR41FL	Ghana - 1998
  GHPR4AFL	Ghana - 2003
  KEPR33FL	Kenya - 1993
  KEPR3AFL	Kenya - 1998
  KEPR41FL	Kenya - 2003
  MWPR22FL	Malawi - 1992
  MWPR41FL	Malawi - 2000
  MWPR4CFL	Malawi - 2004
  MLPR32FL	Mali - 1995/1996
  MLPR41FL	Mali - 2001
  NIPR22FL	Niger - 1992
  NIPR31FL	Niger - 1998
  NIPR50FL	Niger - 2006
  RWPR41FL	Rwanda - 2000
  RWPR52FL	Rwanda - 2005
  TZPR3AFL	Tanzania - 1996
  TZPR41FL	Tanzania - 1999
  TZPR4AFL	Tanzania - 2003
  ZMPR21FL	Zambia - 1992
  ZMPR31FL	Zambia - 1996
  ZMPR42FL	Zambia - 2001/2002
  */

  loc flist CMPR22FL CMPR31FL CMPR44FL CIPR35FL CIPR50FL ETPR41FL ETPR50FL GHPR31FL GHPR41FL GHPR4AFL ///
	    KEPR33FL KEPR3AFL KEPR41FL MWPR22FL MWPR41FL MWPR4CFL MLPR32FL MLPR41FL NIPR22FL NIPR31FL ///
	    NIPR50FL RWPR41FL RWPR52FL TZPR3AFL TZPR41FL TZPR4AFL ZMPR21FL ZMPR31FL ZMPR42FL 
  loc fnum = 1
  foreach fname in `flist'{
	clear
	use `fname'
	gen fname = "`fname'"
	gen fnum = `fnum'
	gen fcntry = substr("`fname'",1,2)
	order fname fnum fcntry
	save temp_`fnum', replace
	loc ++fnum
	}
  loc fnum = 1
  foreach fname in `flist'{
	if (`fnum' == 1) {
         use temp_`fnum', nolabel
         cap gen shstruct = .
         cap gen shmenage = .
      }
	else append using temp_`fnum', nolabel
      keep hv* shmenage shstruct fcntry fname
      erase "temp_`fnum'.dta"
	loc ++fnum
	}
	renpfix hv v
  
  cd "`maindir'"

  save allwaves_combined.dta, replace 

  }

  if `clean_allwaves' == 1 {
 
  clear
  cd "`maindir'"
  use allwaves_combined.dta  

  keep v000 v001 v002 vidx shmenage shstruct v005 v007 v008 v024 v025 v104 v105 v108 v109 fcntry fname v205-v212

  * Country

  loc ccodes_up BF CM CI ET GH GN KE LS MW ML NI RW SN TZ ZM 
  loc ccodes bf cm ci et gh gn ke ls mw ml ni rw sn tz zm 
  loc cnums   1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 
  loc cnames ""Burkina Faso" "Cameroon" "Cote d'Ivoire" "Ethiopia" "Ghana" "Guinea" "Kenya" "Lesotho" "Malawi" "Mali" "Niger" "Rwanda" "Senegal" "Tanzania" "Zambia" 
  gen x_country = .
  loc countries
  loc country
  loc i = 1
  foreach c in `ccodes' {
	loc cname : word `i' of `cnames'
	loc cnum  : word `i' of `cnums'
      loc ccode_up : word `i' of `ccodes_up'
	di in white "`cnum' - `c' - `cname'"
	gen x_`c' = (substr(v000,1,2)=="`ccode_up'")
	label var x_`c' "From `cname'"
	replace x_country = `cnum' if (substr(v000,1,2)=="`ccode_up'")
	loc countries `"`countries' `cnum' "`cname'""'
	loc country `country' x_`c'
	loc ++i
	}
  di `"label is: `countries'"'
  di "country is: `country'"
  global country `country'
  label define countries `countries'
  label values x_country countries
  label var x_country "Country"

  * Survey Year

  gen x_surveyyear = v007
  replace x_surveyyear = 1900 + v007 if v007 < 100
  replace x_surveyyear = 2005 if x_et == 1 & v007 == 1997
  replace x_surveyyear = 2000 if x_et == 1 & v007 == 1992
  replace x_surveyyear = 1998 if v000 == "GH3"
  replace x_surveyyear = 1995.5 if v000 == "ML3"
  replace x_surveyyear = 2004 if x_surveyyear == 2005 & v000 == "MW4"
  replace x_surveyyear = 2003 if x_surveyyear == 2004 & v000 == "TZ5"
  replace x_surveyyear = 1996 if x_surveyyear == 1997 & v000 == "ZM3"
  replace x_surveyyear = 2001.5 if v000 == "ZM4"
  label var x_surveyyear "Year of Survey"

  * ID if Survey Year <= 1994

  preserve
  keep if x_surveyyear <= 1994
  isid v000 v001 v002 vidx shstruct shmenage, missok
  restore

  * Region

  tab v024, gen(x_region_)
  gen x_region = v024
  replace x_region = . if x_region > 95

  * Weights

  gen x_hhweight = v005/1000000
  label var x_hhweight "Household Weight"

  * Age

  gen x_age = v105
  replace x_age = . if x_age == 98
  label var x_age "Age in Years"

  * Compregion

  compregion 

  * Education

  gen x_educ = v108
  replace x_educ = . if (x_educ == 98) | (x_educ == 96) | (x_educ == 97)
  label var x_educ "Years of Schooling"

  * Education > 0

  gen x_educ_positive = 1 if (x_educ>0) & (x_educ!=.)
  replace x_educ_positive = 0 if (x_educ == 0)
  label var x_educ_positive "Years of Schooling > 0"

  * Education >= Primary

  gen x_educ_primary = 0 if (inlist(v109,0,1))
  replace x_educ_primary = 1 if (inlist(v109,2,3,4,5))
  replace x_educ_primary = . if (inlist(v109,8,.))

  * Grades Behind

  gen x_behind = .
  replace x_behind = (x_age - 6) - x_educ
  replace x_behind = 0 if x_behind == -1 
  replace x_behind = . if x_behind < -1

  * Assets

  gen x_toilet = 1 if v205 >= 10 & v205 <=23 
  replace x_toilet = 0 if v205 > 23 & v205 != .

  gen x_electricity = 1 if v206 == 1
  replace x_electricity = 0 if v206 == 0
  
  gen x_radio = 1 if v207 == 1
  replace x_radio = 0 if v207 == 0

  gen x_tv = 1 if v208 == 1
  replace x_tv = 0 if v208 == 0

  gen x_refrigerator = 1 if v209 == 1
  replace x_refrigerator = 0 if v209 == 0

  gen x_bike = 1 if v210 == 1
  replace x_bike = 0 if v210 == 0

  gen x_motorcycle = 1 if v211 == 1
  replace x_motorcycle = 0 if v211 == 0

  gen x_car = 1 if v212 == 1
  replace x_car = 0 if v212 == 0

  gen x_assets_fraction = 0
  gen x_temp = 0
  foreach asset of varlist x_radio x_tv x_refrigerator x_bike x_motorcycle x_car x_toilet x_electricity {
    qui replace x_temp=x_temp+1 if `asset'==. 
  }
  foreach asset of varlist x_radio x_tv x_refrigerator x_bike x_motorcycle x_car x_toilet x_electricity {
    qui replace x_assets_fraction = x_assets_fraction + `asset' if `asset'!=.
  }

  replace x_assets_fraction = x_assets_fraction / (8-x_temp)
  replace x_assets_fraction = . if x_temp>=5 & x_temp<=8
  label var x_assets_fraction "Fraction of Assets"
  drop x_temp

  * Sex

  gen x_female = 1 if v104 == 2
  replace x_female = 0 if v104 == 1 
  label var x_female "Female"

  * Five-Year Age Groups

  loc agmin 15 20 25 30 35 40 45
  loc agmax 19 24 29 34 39 44 49 
  loc i = 1
  foreach _min in `agmin' {
	loc _max: word `i' of `agmax'
	di in white ". gen x_age_`i' = ((`_min' <= x_age) & (x_age <= `_max'))"
	gen x_age_`i' = ((`_min' <= x_age) & (x_age <= `_max'))
	di in white `". label var x_age_`i' "Age `_min'-`_max'""'
	label var x_age_`i' "Age `_min'-`_max'"
	loc ++i
	}

  * Urban/Rural

  gen x_rural = 1 if (v025 == 2)
  replace x_rural = 0 if (v025 == 1)
  label var x_rural "Rural"

  * Year of Birth 

  replace v008 = v008 + 92 if x_et == 1
  gen x_yob = floor(1900 + (v008/12) - x_age)
  label var x_yob "Year of Birth"

  * Primary Sample 

  gen x_primary = 0
  replace x_primary = 1 if v000 == "CI5" | v000 == "CM4" | (v000 == "ET4" & v007 == 1997) | v000 == "GH4" | v000 == "KE4" | v000 == "ML4" | (v000 == "MW4" & (v007 == 2004 | v007 == 2005)) | v000 == "NI5" | v000 == "RW4" | v000 == "TZ5" | v000 == "ZM4"

  * Include
 
  gen include = 0

  * Regression Variables

  gen x_post = 0 if x_yob !=. 
  replace x_post = 1 if (x_yob >= 1980) & (x_yob != .) 

  egen x_compfe = group(x_country x_compregion)
  label var x_compfe "Compregion Fixed Effects"

  tab x_yob, gen(x_yobdummies_)
  tab x_age, gen(x_agedummies_)
  
  keep x_* v000 v001 v002 v007 vidx shstruct shmenage include
  sort x_country x_compregion
  
  sort x_country
  merge x_country using "`maindir'\population.dta"
  tab _merge
  keep if _merge == 3
  drop _merge

  gen new_weight = .
  foreach country in bf cm ci et gh gn ke ls mw ml ni rw sn tz zm {
    sum x_hhweight if x_`country' == 1
    replace new_weight = (x_hhweight) * (x_population / r(sum)) if x_`country' == 1
    sum new_weight if x_`country' == 1
    return list
  }

  * fixing duplicates; this variable will be used to create wave FEs
  gen wave = v000  
  replace wave = "ET3" if wave == "ET4" & v007 == 1992 
  replace wave = "MW3" if wave == "MW4" & v007 == 2000
  replace wave = "TZ2" if wave == "TZ3" & v007 == 96

  sort x_country x_compregion
  save allwaves_cleaned.dta, replace

  } 

  if `merge_allwaves' ==  1 {

  *** Mali ***
  
  use "`inputdir'\MLHT41FL.DTA"
  gen x_hivwt = hivpoids/1000000
  label var x_hivwt "HIV Weight"
  gen x_hiv = hiv_res
  label var x_hiv "HIV Test Result"

  gen v000 = "ML4"
  gen x_surveyyear = 2001
  gen x_region = region
  gen v007 = 2001
  compregion

  qui gen x_hiv_compregion_ml = .
  local i = 1
  qui sum x_compregion
  scalar temp = r(max)
  while `i' <= temp {
    qui sum x_hiv [aw=x_hivwt] if x_compregion == `i' & age >=15 & age <= 49
    qui replace x_hiv_compregion_ml = r(mean)*100 if x_compregion == `i' 
    local i = `i' + 1
  }

  egen tag = tag(x_compregion)
  keep if tag == 1
  drop tag
  gen x_country = 10
  keep x_compregion x_hiv_compregion_ml x_country
  sort x_country x_compregion
  save "Mali_temp.dta", replace

  *** Zambia ***

  use "`inputdir'\ZMHT41FL.DTA"
  gen x_region = hivprov
  gen x_hivwt = hiv_wgt
  label var x_hivwt "HIV Weight"
  gen x_hiv = hivfinal
  replace x_hiv = 0 if x_hiv == 2
  label var x_hiv "HIV Test Result"

  gen v000 = "ZM4"
  gen x_surveyyear = 2001
  gen v007 = 2001
  compregion

  qui gen x_hiv_compregion_zm = .
  local i = 1
  qui sum x_compregion
  scalar temp = r(max)
  while `i' <= temp {
    qui sum x_hiv [aw=x_hivwt] if x_compregion == `i' & hivage >=15 & hivage <= 49
    qui replace x_hiv_compregion_zm = r(mean)*100 if x_compregion == `i' 
    local i = `i' + 1
  }

  egen tag = tag(x_compregion)
  keep if tag == 1
  drop tag
  gen x_country = 15
  keep x_compregion x_hiv_compregion_zm x_country
  sort x_country x_compregion
  save "Zambia_temp.dta", replace

  *** Others ***

  clear
  
  cd "`maindir'"

  use cleaned.dta   

  compregion

  keep if x_hiv != .
  drop if x_bf == 1 | x_gn == 1 | x_ls == 1 | x_sn == 1
  drop if x_ml == 1 | x_zm == 1
  keep x_ci x_cm x_et x_gh x_ke x_ls x_mw x_ni x_rw x_tz x_country x_compregion x_hivweight x_hiv x_age
  
  gen x_hiv_compregion = .
  foreach country in ci cm et gh ke mw ni rw tz {
  di "`country'"
  local i = 1
  qui sum x_compregion if x_`country'==1
  scalar temp = r(max)
  while `i' <= temp {
    qui sum x_hiv [aw=x_hivweight] if x_`country'==1 & x_compregion == `i' & x_age >=15 & x_age <= 49
    qui replace x_hiv_compregion = r(mean)*100 if x_`country'==1 & x_compregion == `i' 
    local i = `i' + 1
    }
  }
  label var x_hiv_compregion "HIV Prevalence in Compregion"

  drop if x_compregion == .
  egen tag = tag(x_country x_compregion)
  keep if tag == 1
  keep x_country x_compregion x_hiv_compregion

  sort x_country x_compregion
  merge x_country x_compregion using allwaves_cleaned.dta
  tab _merge
  drop if _merge == 1
  drop _merge

  sort x_country x_compregion
  merge x_country x_compregion using Mali_temp.dta
  tab _merge
  drop _merge
  replace x_hiv_compregion = x_hiv_compregion_ml if x_ml == 1
  drop x_hiv_compregion_ml
  
  sort x_country x_compregion
  merge x_country x_compregion using Zambia_temp.dta
  tab _merge
  drop _merge

  replace x_hiv_compregion = x_hiv_compregion_zm if x_zm == 1
  drop x_hiv_compregion_zm

  save allwaves_merged.dta, replace
   
  erase Mali_temp.dta
  erase Zambia_temp.dta
  
  }

}

if `individual' == 1 {

local men_files BFMR41FL CMMR44FL ETMR50FL GHMR4AFL GNMR52FL KEMR41FL LSMR41FL MWMR4CFL MLMR41FL NIMR50FL RWMR52FL SNMR4HFL ZMMR41FL 
local individual_files bfir43fl cmir44fl CIIR50FL etir50fl ghir4afl gnir52fl KEIR41fl lsir41fl mwir4cfl mlir41fl niir50fl rwir52fl snir4hfl TZIR4AFL zmir42fl 

* the individual files for CI and TZ include both men and women

local counter 1

foreach wave in `men_files' `individual_files' {

  di "`wave'"
  qui use "`inputdir'\\`wave'.dta", clear
  
  cap rename mv000 v000
  cap rename mv001 v001
  cap rename mv002 v002
  cap rename mv003 v003
  cap rename mv005 v005
  cap rename mv012 v012
  cap rename mv104 v104
  cap rename mv024 v024
  cap rename sstruct smstruct
  cap rename sconces smconces

  qui gen file = "`wave'"

  foreach var in aidsex sm801 sm209a s501 sm448 sm738 sm654 sm720 sm748 sm737 mv483 sm801 sm654 s601 mv483 v104 v024 smconces smstruct {
    cap gen `var' = .
  }
  keep aidsex v000 v001 v002 v003 v005 v012 file sm801 sm209a s501 sm448 sm738 sm654 sm720 sm748 sm737 mv483 sm801 sm654 s601 mv483 v104 v024 smconces smstruct 
	
  if `counter' == 1 save "`maindir'\individual.dta", replace
  else qui append using "`maindir'\individual.dta"
  save "`maindir'\individual.dta", replace
  local ++counter
}

save "`maindir'\individual.dta", replace

gen wave = v000
label var wave "Survey Wave"

tab wave

gen x_country = .
replace x_country = 1 if wave == "BF4"
replace x_country = 2 if wave == "CM4"
replace x_country = 3 if wave == "CI5"
replace x_country = 4 if wave == "ET4"
replace x_country = 5 if wave == "GH4"
replace x_country = 6 if wave == "GN4"
replace x_country = 7 if wave == "KE4"
replace x_country = 8 if wave == "LS4"
replace x_country = 9 if wave == "MW4"
replace x_country = 10 if wave == "ML4"
replace x_country = 11 if wave == "NI5"
replace x_country = 12 if wave == "RW4"
replace x_country = 13 if wave == "SN4"
replace x_country = 14 if wave == "TZ5"
replace x_country = 15 if wave == "ZM4"
label var x_country "Country"

gen x_region = v024
label var x_region "Region"

gen x_age = v012
label var x_age "Age of Respondent"

gen x_indweight = v005/1000000
label var x_indweight "Individual Weight"

tab s501 aidsex if wave == "CI5", missing 
tab s601 aidsex if wave == "TZ5", missing 

gen x_circumcised = .
replace x_circumcised = sm801 if wave == "BF4"
replace x_circumcised = sm209a if wave == "CM4"
replace x_circumcised = s501 if wave == "CI5" & aidsex == 1
replace x_circumcised = sm448 if wave == "ET4"
replace x_circumcised = sm738 if wave == "GH4"
replace x_circumcised = sm654 if wave == "GN4"
replace x_circumcised = sm720 if wave == "KE4"
replace x_circumcised = sm748 if wave == "LS4"
replace x_circumcised = sm737 if wave == "MW4"
* NONE EXISTS FOR ML4 
replace x_circumcised = mv483 if wave == "NI5"
replace x_circumcised = sm801 if wave == "RW4" 
replace x_circumcised = sm654 if wave == "SN4"
replace x_circumcised = s601 if wave == "TZ5" & aidsex == 1
* NONE EXISTS FOR ZM4
label var x_circumcised "Is Respondent Circumcised?"

* s601 for TZ5 says "male circumcision" but has values for women
* but the tabulations seem to match d501 from the earlier (4H) file, 
* which was "are you circumcised"

tab x_circumcised wave

gen x_nomoves = 1 if v104 == 95
replace x_nomoves = 0 if v104 != . & v104!= 96 & v104 != 97 & v104 != 99 & v104 != 95  & v104 != 98
label var x_nomoves "Has Not Moved"

gen x_yearsincurrent = v104 if v104 != 95 & v104 != 96 & v104 != 97 & v104 != 99
gen x_agemovedtocurrent = x_age - x_yearsincurrent

replace x_agemovedtocurrent = . if x_agemovedtocurrent < 0
replace x_yearsincurrent = . if x_agemovedtocurrent == .

keep file v000 v001 v002 v003 smconces smstruct wave x_country x_region x_circumcised x_nomoves x_age x_yearsincurrent x_agemovedtocurrent x_indweight
sort v000 v001 v002 v003 smconces smstruct

save "`maindir'\individual.dta", replace

keep v000 v001 v002 v003 smconces smstruct x_nomoves x_agemovedtocurrent x_yearsincurrent
save "`maindir'\migration.dta", replace

use "`maindir'\individual.dta"

gen x_circum_regional = .
forvalues i = 1/15 {
  sum x_region if x_country == `i' 
  forvalues j = 1/`r(max)' {
    sum x_circumcised [aw = x_indweight] if x_age>=20 & x_age<=44 & x_country == `i' & x_region == `j' 
    replace x_circum_regional = r(mean)*100 if x_country == `i' & x_region == `j'
  }
}

label var x_circum_regional "Regional Circumcision Rate, Men 20-44"

keep x_country x_region x_circum_regional

cap drop tag
egen tag = tag(x_country x_region)
keep if tag == 1
drop tag

sort x_country x_region

save "`maindir'\circumcision.dta", replace

}

log close
