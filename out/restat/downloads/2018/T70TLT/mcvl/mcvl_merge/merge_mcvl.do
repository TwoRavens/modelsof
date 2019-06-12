* This do-file will arrange the raw data and output a data file 
* which contains all the information used in the different parts 
* of the analysis. Part of this code are taken from 
* Jorge De la Roca and Diego Puga (REStud 2017). We gratefully
* acknowledge their effort in providing the code.

*** income and personal information

foreach yr of numlist 2014 2013  2012 2011 2010 2009 2008 2007 2006 2005 {

insheet using "..\MCVL-`yr' CDF\MCVL`yr'PERSONAL_CDF.TXT", delimiter(";") clear
drop v11
rename v1 id
rename v2 ym_birth
destring ym_birth, replace
rename v3 sex
rename v4 nationality
rename v5 province_birth
rename v6 province_naf
rename v7 province_residence
rename v8 ym_death
destring ym_death, replace
rename v9 country_birth
rename v10 education
gen year=`yr'
save "personal_`yr'.dta", replace


insheet using "..\MCVL-`yr' CDF\MCVL`yr'FISCAL_CDF.TXT", delimiter(";") clear
rename v1 id

rename v3 id_firm

rename v4 province_fiscaldata
rename v5 income_type
rename v7 income_wage
replace income_wage=income_wage/100

rename v8 tax_withhold
replace tax_withhold=tax_withhold/100

rename v9 income_inkind
replace income_inkind=income_inkind/100
gen income=income_wage+income_inkind

rename v13 year_birth
rename v14 pers_famstatus
rename v15 pers_handicap
rename v19 tax_reductions
rename v20 tax_expdeduc

rename v23 pers_kids0_3
rename v25 pers_kids
rename v27 pers_kidshandi33_65
rename v29 pers_kidshandi33_65_2
rename v31 pers_kidshandi65
rename v33 pers_kis_total

rename v34 pers_elerly65_75
rename v36 pers_elerly75
rename v38 pers_elderlyhandi33_65
rename v40 pers_elderlyhandi33_65_2
rename v42 pers_elderlyhandi65

rename v44 pers_elderly_total

collapse (sum) income tax* (firstnm) province_fiscaldata year_birth pers* income_type, by(id id_firm)
gen year=`yr'
save "income_`yr'.dta", replace

}

***********
** MERGE **
***********

use "personal_2014.dta", clear


foreach yr of numlist 2013 2012 2011 2010 2009 2008 2007 2006 2005 {


append using "personal_`yr'.dta", force


}

sort id year
by id: gen obs=_N
drop if obs>10
sort id year
by id year: gen dup = cond(_N==1,0,_n)
drop if dup>0
save "personal_panel.dta", replace


use "income_2014.dta", clear
foreach yr of numlist 2013 2012 2011 2010 2009 2008 2007 2006 2005 {


append using "income_`yr'.dta", force

}


sort id year
by id: gen obs=_N

gsort id year -income
by id year: gen obs_year=_N
by id year: gen obs_year_n=_n
replace obs_year_n=99999 if obs_year_n>4
collapse (sum) income tax*  (firstnm) id_firm province_fiscaldata year_birth  pers* income_type, by(id obs_year_n year)
gen id_obs=obs_year_n
reshape wide  obs_year_n- pers_elderly_total income_type, i(id year) j(id_obs)

egen pers_famstatus=rowmax( pers_famstatus1 pers_famstatus2 pers_famstatus3 pers_famstatus4 pers_famstatus99999 )
drop pers_famstatus1 pers_famstatus2 pers_famstatus3 pers_famstatus4 pers_famstatus99999

gen pers_year_birth= year_birth1
drop year_birth1  year_birth2  year_birth3  year_birth4  year_birth99999

destring pers_handicap1, gen(pers_handicap)
drop pers_handicap1 pers_handicap2 pers_handicap3 pers_handicap4 pers_handicap99999

egen pers_kids=rowmax(pers_kids1 pers_kids2 pers_kids3 pers_kids4 pers_kids99999)
drop pers_kids1 pers_kids2 pers_kids3  pers_kids4 pers_kids99999

egen pers_kids_0to3=rowmax( pers_kids0_31 pers_kids0_32 pers_kids0_33 pers_kids0_34 pers_kids0_399999 )
drop pers_kids0_31 pers_kids0_32 pers_kids0_33 pers_kids0_399999 pers_kids0_34

egen pers_kids_handicap_33to65=rowmax( pers_kidshandi33_651 pers_kidshandi33_652 pers_kidshandi33_653 pers_kidshandi33_654 pers_kidshandi33_6599999 )
drop  pers_kidshandi33_651 pers_kidshandi33_652 pers_kidshandi33_653 pers_kidshandi33_6599999 pers_kidshandi33_654

egen pers_kids_handicap_33to65_2=rowmax( pers_kidshandi33_65_21 pers_kidshandi33_65_22 pers_kidshandi33_65_23  pers_kidshandi33_65_24 pers_kidshandi33_65_299999 )
drop  pers_kidshandi33_65_21 pers_kidshandi33_65_22 pers_kidshandi33_65_23 pers_kidshandi33_65_299999 pers_kidshandi33_65_24

egen pers_kids_total=rowmax( pers_kis_total1 pers_kis_total2 pers_kis_total3 pers_kis_total4 pers_kis_total99999  )
drop pers_kis_total1 pers_kis_total2 pers_kis_total3 pers_kis_total99999 pers_kis_total4

egen pers_kids_handicap_65=rowmax( pers_kidshandi651 pers_kidshandi652 pers_kidshandi653 pers_kidshandi654 pers_kidshandi659999)
drop pers_kidshandi651 pers_kidshandi652 pers_kidshandi653 pers_kidshandi654 pers_kidshandi659999

egen pers_elderly_65to75=rowmax( pers_elerly65_751 pers_elerly65_752 pers_elerly65_753 pers_elerly65_754 pers_elerly65_7599999)
drop  pers_elerly65_751 pers_elerly65_752 pers_elerly65_753 pers_elerly65_754 pers_elerly65_7599999

egen pers_elderly_75=rowmax( pers_elerly751 pers_elerly752 pers_elerly753 pers_elerly754 pers_elerly7599999 )
drop pers_elerly751 pers_elerly752 pers_elerly753 pers_elerly754 pers_elerly7599999

egen pers_elderly_total=rowmax( pers_elderly_total1 pers_elderly_total2 pers_elderly_total3 pers_elderly_total4 pers_elderly_total99999 )
drop pers_elderly_total1 pers_elderly_total2 pers_elderly_total3 pers_elderly_total4 pers_elderly_total99999

egen pers_elderly_handicap_33to65=rowmax( pers_elderlyhandi33_651 pers_elderlyhandi33_652 pers_elderlyhandi33_653 pers_elderlyhandi33_654 pers_elderlyhandi33_6599999 )
drop pers_elderlyhandi33_651 pers_elderlyhandi33_652 pers_elderlyhandi33_653 pers_elderlyhandi33_654 pers_elderlyhandi33_6599999

egen pers_elderly_handicap_33to65_2=rowmax( pers_elderlyhandi33_65_21 pers_elderlyhandi33_65_22 pers_elderlyhandi33_65_23 pers_elderlyhandi33_65_24 pers_elderlyhandi33_65_299999 )
drop pers_elderlyhandi33_65_21 pers_elderlyhandi33_65_22 pers_elderlyhandi33_65_23 pers_elderlyhandi33_65_24 pers_elderlyhandi33_65_299999

egen pers_elderly_handicap_65=rowmax( pers_elderlyhandi651 pers_elderlyhandi652 pers_elderlyhandi653 pers_elderlyhandi654 pers_elderlyhandi6599999 )
drop pers_elderlyhandi651 pers_elderlyhandi652 pers_elderlyhandi653 pers_elderlyhandi654 pers_elderlyhandi6599999


drop obs_year_n*
compress

merge m:1 id year using personal_panel.dta, update replace
keep if _merge==3

gen TEMPprovince_code= province_residence/1000
replace TEMPprovince_code=. if TEMPprovince_code==0
replace TEMPprovince_code=int(TEMPprovince_code)

drop _merge
merge m:1 TEMPprovince_code using "auxiliary\input_prov_ccaa2.dta"
rename TEMPcode_ccaa code_ccaa

replace income2=0 if income2==.
replace income3=0 if income3==.
replace income4=0 if income4==.
replace income99999=0 if income99999==.
gen income = income1 + income2 + income3 + income4 + income99999

xtset id year
gen income_lag=l.income

drop obs dup _merge 
compress

save panel.dta, replace

run ..\..\taxcalc\mtr_v6.do
save "panel_wtax.dta", replace


*** affiliation data

* 2014


foreach file of numlist 1 2 3 4 {
 clear all
 import delimited "..\MCVL-2014 CDF\MCVL2014AFILIAD`file'_CDF.TXT", delimiter(";") 

  rename v1 person_id        
  rename v2 regime
  rename v3 occupation                  
  rename v4 contract_type
  rename v5 ptcoef
  rename v6 entry_date
  rename v7 exit_date
  rename v8 reason_dismissal
  rename v9 disability
  rename v10 firm_id_sec
  rename v11 firm_muni
  rename v12 sector
  rename v13 firm_workers
  rename v14 firm_age
  rename v15 job_relationship
  rename v16 firm_ett
  rename v17 firm_jur_type
  rename v18 firm_jur_status
  rename v19 firm_id_tax
  rename v20 firm_id_main
  rename v21 firm_main_prov
  rename v22 new_date_contract1
  rename v23 prev_contract1
  rename v24 prev_ptcoef1
  rename v25 new_date_contract2
  rename v26 prev_contract2
  rename v27 prev_ptcoef2
  rename v28 new_date_occupation
  rename v29 prev_occupation
  rename v30 sector_cnae93
  drop v31-v34
  label var person_id "Individual identifier"
  label var regime "Social security regime"
  label var occupation "Occupational code"
  label var contract_type "Type of job contract"
  label var ptcoef "Part time coefficient in 1/1000 of full-time equivalent, 0 if full-time"
  label var entry_date "Date of entry in this affiliation"
  label var exit_date "Date of exit in this affiliation"
  label var reason_dismissal "Reason for dismissal in this affiliation"
  label var disability "Type of disability according to entry in affiliation"
  label var firm_id_sec "Firm establishment identifier"
  label var firm_muni "Firm establishment municipality if population above 40000"
  label var sector "3-digit sector code"
  label var firm_workers "Number of workers in firm establsihment"
  label var firm_age "Date firm establishment registered its first worker"
  label var job_relationship "Type of job relationship"
  label var firm_ett "Firm establishment is a temporary recruitment agency (ETT)"
  label var firm_jur_type "Firm establishment juridical classification (natural vs. legal entities)"
  label var firm_jur_status "Firm establishment juridical status (NIF for legal entities)"
  label var firm_id_tax "Firm establishment identifier for matching with tax data"
  label var firm_id_main "Common firm identifier for multi-establishment firm"
  label var firm_main_prov "Province associated with common firm identifier"
  label var new_date_contract1 "Date of first type of contract revision"
  label var prev_contract1 "Type of contract until first revision"
  label var prev_ptcoef1 "Part time coefficient until first revision (see ptcoef)"
  label var new_date_contract2 "Date of second type of contract revision"
  label var prev_contract2 "Type of contract until second revision"
  label var prev_ptcoef2 "Part time coefficient until second revision (see ptcoef)"
  label var new_date_occupation "Date of occupational code revision"
  label var prev_occupation "Occupational code until first revision"
  label var sector_cnae93 "3-digit sector code (CNAE 93)"


tostring entry_date, replace
generate str4 entry_yrv= substr(entry_date,1,4)
generate str2 entry_mo = substr(entry_date,5,6)
generate str2 entry_da = substr(entry_date,7,8)

destring entry*, force replace

tostring exit_date, replace
generate str4 exit_yr = substr(exit_date,1,4)
generate str2 exit_mo = substr(exit_date,5,6)
generate str2 exit_da = substr(exit_date,7,8)

destring exit*, force replace

drop if exit_yr<2014

replace exit_mo=12 if exit_yr==2015
replace exit_da=31 if exit_yr==2015
replace exit_yr=2014 if exit_yr==2015

gen exit_date_2=mdy( exit_mo , exit_da , exit_yr )
gen entry_date_2=mdy( entry_mo ,entry_da, entry_yr)
gen duration=exit_date_2-entry_date_2

save "affiliation_2014_`file'.dta", replace

}



* 2013


foreach file of numlist 1 2 3 4 {
 clear all
 import delimited "..\MCVL-2013 CDF\MCVL2013AFILIAD`file'_CDF.TXT", delimiter(";") 

  rename v1 person_id        
  rename v2 regime
  rename v3 occupation                  
  rename v4 contract_type
  rename v5 ptcoef
  rename v6 entry_date
  rename v7 exit_date
  rename v8 reason_dismissal
  rename v9 disability
  rename v10 firm_id_sec
  rename v11 firm_muni
  rename v12 sector
  rename v13 firm_workers
  rename v14 firm_age
  rename v15 job_relationship
  rename v16 firm_ett
  rename v17 firm_jur_type
  rename v18 firm_jur_status
  rename v19 firm_id_tax
  rename v20 firm_id_main
  rename v21 firm_main_prov
  rename v22 new_date_contract1
  rename v23 prev_contract1
  rename v24 prev_ptcoef1
  rename v25 new_date_contract2
  rename v26 prev_contract2
  rename v27 prev_ptcoef2
  rename v28 new_date_occupation
  rename v29 prev_occupation
  rename v30 sector_cnae93
  drop v31-v34
  label var person_id "Individual identifier"
  label var regime "Social security regime"
  label var occupation "Occupational code"
  label var contract_type "Type of job contract"
  label var ptcoef "Part time coefficient in 1/1000 of full-time equivalent, 0 if full-time"
  label var entry_date "Date of entry in this affiliation"
  label var exit_date "Date of exit in this affiliation"
  label var reason_dismissal "Reason for dismissal in this affiliation"
  label var disability "Type of disability according to entry in affiliation"
  label var firm_id_sec "Firm establishment identifier"
  label var firm_muni "Firm establishment municipality if population above 40000"
  label var sector "3-digit sector code"
  label var firm_workers "Number of workers in firm establsihment"
  label var firm_age "Date firm establishment registered its first worker"
  label var job_relationship "Type of job relationship"
  label var firm_ett "Firm establishment is a temporary recruitment agency (ETT)"
  label var firm_jur_type "Firm establishment juridical classification (natural vs. legal entities)"
  label var firm_jur_status "Firm establishment juridical status (NIF for legal entities)"
  label var firm_id_tax "Firm establishment identifier for matching with tax data"
  label var firm_id_main "Common firm identifier for multi-establishment firm"
  label var firm_main_prov "Province associated with common firm identifier"
  label var new_date_contract1 "Date of first type of contract revision"
  label var prev_contract1 "Type of contract until first revision"
  label var prev_ptcoef1 "Part time coefficient until first revision (see ptcoef)"
  label var new_date_contract2 "Date of second type of contract revision"
  label var prev_contract2 "Type of contract until second revision"
  label var prev_ptcoef2 "Part time coefficient until second revision (see ptcoef)"
  label var new_date_occupation "Date of occupational code revision"
  label var prev_occupation "Occupational code until first revision"
  label var sector_cnae93 "3-digit sector code (CNAE 93)"


tostring entry_date, replace
generate str4 entry_yrv= substr(entry_date,1,4)
generate str2 entry_mo = substr(entry_date,5,6)
generate str2 entry_da = substr(entry_date,7,8)

destring entry*, force replace

tostring exit_date, replace
generate str4 exit_yr = substr(exit_date,1,4)
generate str2 exit_mo = substr(exit_date,5,6)
generate str2 exit_da = substr(exit_date,7,8)

destring exit*, force replace

drop if exit_yr<2013

replace exit_mo=12 if exit_yr==2014
replace exit_da=31 if exit_yr==2014
replace exit_yr=2013 if exit_yr==2014

gen exit_date_2=mdy( exit_mo , exit_da , exit_yr )
gen entry_date_2=mdy( entry_mo ,entry_da, entry_yr)
gen duration=exit_date_2-entry_date_2

save "affiliation_2013_`file'.dta", replace

}




* 2012

foreach file of numlist 1 2 3  {
 clear all
 import delimited "..\MCVL-2012 CDF\MCVL2012AFILIAD`file'_CDF.TXT", delimiter(";") 


 rename v1 person_id        
  rename v2 regime
  rename v3 occupation                  
  rename v4 contract_type
  rename v5 ptcoef
  rename v6 entry_date
  rename v7 exit_date
  rename v8 reason_dismissal
  rename v9 disability
  rename v10 firm_id_sec
  rename v11 firm_muni
  rename v12 sector
  rename v13 firm_workers
  rename v14 firm_age
  rename v15 job_relationship
  rename v16 firm_ett
  rename v17 firm_jur_type
  rename v18 firm_jur_status
  rename v19 firm_id_tax
  rename v20 firm_id_main
  rename v21 firm_main_prov
  rename v22 new_date_contract1
  rename v23 prev_contract1
  rename v24 prev_ptcoef1
  rename v25 new_date_contract2
  rename v26 prev_contract2
  rename v27 prev_ptcoef2
  rename v28 new_date_occupation
  rename v29 prev_occupation
  rename v30 sector_cnae93
  label var person_id "Individual identifier"
  label var regime "Social security regime"
  label var occupation "Occupational code"
  label var contract_type "Type of job contract"
  label var ptcoef "Part time coefficient in 1/1000 of full-time equivalent, 0 if full-time"
  label var entry_date "Date of entry in this affiliation"
  label var exit_date "Date of exit in this affiliation"
  label var reason_dismissal "Reason for dismissal in this affiliation"
  label var disability "Type of disability according to entry in affiliation"
  label var firm_id_sec "Firm establishment identifier"
  label var firm_muni "Firm establishment municipality if population above 40000"
  label var sector "3-digit sector code"
  label var firm_workers "Number of workers in firm establsihment"
  label var firm_age "Date firm establishment registered its first worker"
  label var job_relationship "Type of job relationship"
  label var firm_ett "Firm establishment is a temporary recruitment agency (ETT)"
  label var firm_jur_type "Firm establishment juridical classification (natural vs. legal entities)"
  label var firm_jur_status "Firm establishment juridical status (NIF for legal entities)"
  label var firm_id_tax "Firm establishment identifier for matching with tax data"
  label var firm_id_main "Common firm identifier for multi-establishment firm"
  label var firm_main_prov "Province associated with common firm identifier"
  label var new_date_contract1 "Date of first type of contract revision"
  label var prev_contract1 "Type of contract until first revision"
  label var prev_ptcoef1 "Part time coefficient until first revision (see ptcoef)"
  label var new_date_contract2 "Date of second type of contract revision"
  label var prev_contract2 "Type of contract until second revision"
  label var prev_ptcoef2 "Part time coefficient until second revision (see ptcoef)"
  label var new_date_occupation "Date of occupational code revision"
  label var prev_occupation "Occupational code until first revision"
  label var sector_cnae93 "3-digit sector code (CNAE 93)"

  
  

tostring entry_date, replace
generate str4 entry_yrv= substr(entry_date,1,4)
generate str2 entry_mo = substr(entry_date,5,6)
generate str2 entry_da = substr(entry_date,7,8)

destring entry*, force replace

tostring exit_date, replace
generate str4 exit_yr = substr(exit_date,1,4)
generate str2 exit_mo = substr(exit_date,5,6)
generate str2 exit_da = substr(exit_date,7,8)

destring exit*, force replace

drop if exit_yr<2012

replace exit_mo=12 if exit_yr==2013
replace exit_da=31 if exit_yr==2013
replace exit_yr=2012 if exit_yr==2013

gen exit_date_2=mdy( exit_mo , exit_da , exit_yr )
gen entry_date_2=mdy( entry_mo ,entry_da, entry_yr)
gen duration=exit_date_2-entry_date_2

save "affiliation_2012_`file'.dta", replace

}

* 2011

foreach file of numlist 1 2 3  {
 clear all
 import delimited "..\MCVL-2011 CDF\MCVL2011AFILIA`file'_CDF.TXT", delimiter(";") 



  rename v1 person_id        
  rename v2 regime
  rename v3 occupation                  
  rename v4 contract_type
  rename v5 ptcoef
  rename v6 entry_date
  rename v7 exit_date
  rename v8 reason_dismissal
  rename v9 disability
  rename v10 firm_id_sec
  rename v11 firm_muni
  rename v12 sector
  rename v13 firm_workers
  rename v14 firm_age
  rename v15 job_relationship
  rename v16 firm_ett
  rename v17 firm_jur_type
  rename v18 firm_jur_status
  rename v19 firm_id_tax
  rename v20 firm_id_main
  rename v21 firm_main_prov
  rename v22 new_date_contract1
  rename v23 prev_contract1
  rename v24 prev_ptcoef1
  rename v25 new_date_contract2
  rename v26 prev_contract2
  rename v27 prev_ptcoef2
  rename v28 new_date_occupation
  rename v29 prev_occupation
  rename v30 sector_cnae93
  label var person_id "Individual identifier"
  label var regime "Social security regime"
  label var occupation "Occupational code"
  label var contract_type "Type of job contract"
  label var ptcoef "Part time coefficient in 1/1000 of full-time equivalent, 0 if full-time"
  label var entry_date "Date of entry in this affiliation"
  label var exit_date "Date of exit in this affiliation"
  label var reason_dismissal "Reason for dismissal in this affiliation"
  label var disability "Type of disability according to entry in affiliation"
  label var firm_id_sec "Firm establishment identifier"
  label var firm_muni "Firm establishment municipality if population above 40000"
  label var sector "3-digit sector code"
  label var firm_workers "Number of workers in firm establsihment"
  label var firm_age "Date firm establishment registered its first worker"
  label var job_relationship "Type of job relationship"
  label var firm_ett "Firm establishment is a temporary recruitment agency (ETT)"
  label var firm_jur_type "Firm establishment juridical classification (natural vs. legal entities)"
  label var firm_jur_status "Firm establishment juridical status (NIF for legal entities)"
  label var firm_id_tax "Firm establishment identifier for matching with tax data"
  label var firm_id_main "Common firm identifier for multi-establishment firm"
  label var firm_main_prov "Province associated with common firm identifier"
  label var new_date_contract1 "Date of first type of contract revision"
  label var prev_contract1 "Type of contract until first revision"
  label var prev_ptcoef1 "Part time coefficient until first revision (see ptcoef)"
  label var new_date_contract2 "Date of second type of contract revision"
  label var prev_contract2 "Type of contract until second revision"
  label var prev_ptcoef2 "Part time coefficient until second revision (see ptcoef)"
  label var new_date_occupation "Date of occupational code revision"
  label var prev_occupation "Occupational code until first revision"
  label var sector_cnae93 "3-digit sector code (CNAE 93)"
  
    

tostring entry_date, replace
generate str4 entry_yrv= substr(entry_date,1,4)
generate str2 entry_mo = substr(entry_date,5,6)
generate str2 entry_da = substr(entry_date,7,8)

destring entry*, force replace

tostring exit_date, replace
generate str4 exit_yr = substr(exit_date,1,4)
generate str2 exit_mo = substr(exit_date,5,6)
generate str2 exit_da = substr(exit_date,7,8)

destring exit*, force replace

drop if exit_yr<2011

replace exit_mo=12 if exit_yr==2012
replace exit_da=31 if exit_yr==2012
replace exit_yr=2011 if exit_yr==2012

gen exit_date_2=mdy( exit_mo , exit_da , exit_yr )
gen entry_date_2=mdy( entry_mo ,entry_da, entry_yr)
gen duration=exit_date_2-entry_date_2

save "affiliation_2011_`file'.dta", replace

}

  
  * 2010
  
  foreach file of numlist 1 2 3  {
 clear all
 import delimited "..\MCVL-2010 CDF\MCVL2010AFILIAD`file'_CDF.TXT", delimiter(";") 

  
  
   rename v1 person_id        
  rename v2 regime
  rename v3 occupation                  
  rename v4 contract_type
  rename v5 ptcoef
  rename v6 entry_date
  rename v7 exit_date
  rename v8 reason_dismissal
  rename v9 disability
  rename v10 firm_id_sec
  rename v11 firm_muni
  rename v12 sector
  rename v13 firm_workers
  rename v14 firm_age
  rename v15 job_relationship
  rename v16 firm_ett
  rename v17 firm_jur_type
  rename v18 firm_jur_status
  rename v19 firm_id_tax
  rename v20 firm_id_main
  rename v21 firm_main_prov
  rename v22 new_date_contract1
  rename v23 prev_contract1
  rename v24 prev_ptcoef1
  rename v25 new_date_contract2
  rename v26 prev_contract2
  rename v27 prev_ptcoef2
  rename v28 new_date_occupation
  rename v29 prev_occupation
  rename v30 sector_cnae93
  label var person_id "Individual identifier"
  label var regime "Social security regime"
  label var occupation "Occupational code"
  label var contract_type "Type of job contract"
  label var ptcoef "Part time coefficient in 1/1000 of full-time equivalent, 0 if full-time"
  label var entry_date "Date of entry in this affiliation"
  label var exit_date "Date of exit in this affiliation"
  label var reason_dismissal "Reason for dismissal in this affiliation"
  label var disability "Type of disability according to entry in affiliation"
  label var firm_id_sec "Firm establishment identifier"
  label var firm_muni "Firm establishment municipality if population above 40000"
  label var sector "3-digit sector code"
  label var firm_workers "Number of workers in firm establsihment"
  label var firm_age "Date firm establishment registered its first worker"
  label var job_relationship "Type of job relationship"
  label var firm_ett "Firm establishment is a temporary recruitment agency (ETT)"
  label var firm_jur_type "Firm establishment juridical classification (natural vs. legal entities)"
  label var firm_jur_status "Firm establishment juridical status (NIF for legal entities)"
  label var firm_id_tax "Firm establishment identifier for matching with tax data"
  label var firm_id_main "Common firm identifier for multi-establishment firm"
  label var firm_main_prov "Province associated with common firm identifier"
  label var new_date_contract1 "Date of first type of contract revision"
  label var prev_contract1 "Type of contract until first revision"
  label var prev_ptcoef1 "Part time coefficient until first revision (see ptcoef)"
  label var new_date_contract2 "Date of second type of contract revision"
  label var prev_contract2 "Type of contract until second revision"
  label var prev_ptcoef2 "Part time coefficient until second revision (see ptcoef)"
  label var new_date_occupation "Date of occupational code revision"
  label var prev_occupation "Occupational code until first revision"
  label var sector_cnae93 "3-digit sector code (CNAE 93)"
  
    

tostring entry_date, replace
generate str4 entry_yrv= substr(entry_date,1,4)
generate str2 entry_mo = substr(entry_date,5,6)
generate str2 entry_da = substr(entry_date,7,8)

destring entry*, force replace

tostring exit_date, replace
generate str4 exit_yr = substr(exit_date,1,4)
generate str2 exit_mo = substr(exit_date,5,6)
generate str2 exit_da = substr(exit_date,7,8)

destring exit*, force replace

drop if exit_yr<2010

replace exit_mo=12 if exit_yr==2011
replace exit_da=31 if exit_yr==2011
replace exit_yr=2010 if exit_yr==2011

gen exit_date_2=mdy( exit_mo , exit_da , exit_yr )
gen entry_date_2=mdy( entry_mo ,entry_da, entry_yr)
gen duration=exit_date_2-entry_date_2

save "affiliation_2010_`file'.dta", replace

}

* 2009

foreach num of numlist 1/3 {
clear all
 import delimited "..\MCVL-2009 CDF\MCVL2009AFILIAD`num'_CDF.TXT", delimiter(";") 

  rename v1 person_id        
  rename v2 regime
  rename v3 occupation                  
  rename v4 contract_type
  rename v5 ptcoef
  rename v6 entry_date
  rename v7 exit_date
  rename v8 reason_dismissal
  rename v9 disability
  rename v10 firm_id_sec
  rename v11 firm_muni
  rename v12 sector
  rename v13 firm_workers
  rename v14 firm_age
  rename v15 job_relationship
  rename v16 firm_ett
  rename v17 firm_jur_type
  rename v18 firm_jur_status
  rename v19 firm_id_tax
  rename v20 firm_id_main
  rename v21 firm_main_prov
  rename v22 new_date_contract1
  rename v23 prev_contract1
  rename v24 prev_ptcoef1
  rename v25 new_date_contract2
  rename v26 prev_contract2
  rename v27 prev_ptcoef2
  rename v28 new_date_occupation
  rename v29 prev_occupation
  label var person_id "Individual identifier"
  label var regime "Social security regime"
  label var occupation "Occupational code"
  label var contract_type "Type of job contract"
  label var ptcoef "Part time coefficient in 1/1000 of full-time equivalent, 0 if full-time"
  label var entry_date "Date of entry in this affiliation"
  label var exit_date "Date of exit in this affiliation"
  label var reason_dismissal "Reason for dismissal in this affiliation"
  label var disability "Type of disability according to entry in affiliation"
  label var firm_id_sec "Firm establishment identifier"
  label var firm_muni "Firm establishment municipality if population above 40000"
  label var sector "3-digit sector code"
  label var firm_workers "Number of workers in firm establsihment"
  label var firm_age "Date firm establishment registered its first worker"
  label var job_relationship "Type of job relationship"
  label var firm_ett "Firm establishment is a temporary recruitment agency (ETT)"
  label var firm_jur_type "Firm establishment juridical classification (natural vs. legal entities)"
  label var firm_jur_status "Firm establishment juridical status (NIF for legal entities)"
  label var firm_id_tax "Firm establishment identifier for matching with tax data"
  label var firm_id_main "Common firm identifier for multi-establishment firm"
  label var firm_main_prov "Province associated with common firm identifier"
  label var new_date_contract1 "Date of first type of contract revision"
  label var prev_contract1 "Type of contract until first revision"
  label var prev_ptcoef1 "Part time coefficient until first revision (see ptcoef)"
  label var new_date_contract2 "Date of second type of contract revision"
  label var prev_contract2 "Type of contract until second revision"
  label var prev_ptcoef2 "Part time coefficient until second revision (see ptcoef)"
  label var new_date_occupation "Date of occupational code revision"
  label var prev_occupation "Occupational code until first revision"
  sort person_id entry_date exit_date firm_id_sec

  
  tostring entry_date, replace
generate str4 entry_yrv= substr(entry_date,1,4)
generate str2 entry_mo = substr(entry_date,5,6)
generate str2 entry_da = substr(entry_date,7,8)

destring entry*, force replace

tostring exit_date, replace
generate str4 exit_yr = substr(exit_date,1,4)
generate str2 exit_mo = substr(exit_date,5,6)
generate str2 exit_da = substr(exit_date,7,8)

destring exit*, force replace

drop if exit_yr<2009

replace exit_mo=12 if exit_yr==2010
replace exit_da=31 if exit_yr==2010
replace exit_yr=2009 if exit_yr==2010

gen exit_date_2=mdy( exit_mo , exit_da , exit_yr )
gen entry_date_2=mdy( entry_mo ,entry_da, entry_yr)
gen duration=exit_date_2-entry_date_2
  
  save "affiliation_2009_`num'.dta", replace

}


* 2008

foreach num of numlist 1/3 {
clear all
 import delimited "..\MCVL-2008 CDF\AFILANON`num'.trs", delimiter(";") 
  rename v1 person_id        
  rename v2 regime
  rename v3 occupation                  
  rename v4 contract_type
  rename v5 ptcoef
  rename v6 entry_date
  rename v7 exit_date
  rename v8 reason_dismissal
  rename v9 disability
  rename v10 firm_id_sec
  rename v11 firm_muni
  rename v12 sector_cnae93
  rename v13 firm_workers
  rename v14 firm_age
  rename v15 job_relationship
  rename v16 firm_ett
  rename v17 firm_jur_type
  rename v18 firm_jur_status
  rename v19 firm_id_tax
  rename v20 firm_id_main
  rename v21 firm_main_prov
  rename v22 new_date_contract1
  rename v23 prev_contract1
  rename v24 prev_ptcoef1
  rename v25 new_date_contract2
  rename v26 prev_contract2
  rename v27 prev_ptcoef2
  rename v28 new_date_occupation
  rename v29 prev_occupation
  label var person_id "Individual identifier"
  label var regime "Social security regime"
  label var occupation "Occupational code"
  label var contract_type "Type of job contract"
  label var ptcoef "Part time coefficient in 1/1000 of full-time equivalent, 0 if full-time"
  label var entry_date "Date of entry in this affiliation"
  label var exit_date "Date of exit in this affiliation"
  label var reason_dismissal "Reason for dismissal in this affiliation"
  label var disability "Type of disability according to entry in affiliation"
  label var firm_id_sec "Firm establishment identifier"
  label var firm_muni "Firm establishment municipality if population above 40000"
  label var sector_cnae93 "3-digit sector code"
  label var firm_workers "Number of workers in firm establsihment"
  label var firm_age "Date firm establishment registered its first worker"
  label var job_relationship "Type of job relationship"
  label var firm_ett "Firm establishment is a temporary recruitment agency (ETT)"
  label var firm_jur_type "Firm establishment juridical classification (natural vs. legal entities)"
  label var firm_jur_status "Firm establishment juridical status (NIF for legal entities)"
  label var firm_id_tax "Firm establishment identifier for matching with tax data"
  label var firm_id_main "Common firm identifier for multi-establishment firm"
  label var firm_main_prov "Province associated with common firm identifier"
  label var new_date_contract1 "Date of first type of contract revision"
  label var prev_contract1 "Type of contract until first revision"
  label var prev_ptcoef1 "Part time coefficient until first revision (see ptcoef)"
  label var new_date_contract2 "Date of second type of contract revision"
  label var prev_contract2 "Type of contract until second revision"
  label var prev_ptcoef2 "Part time coefficient until second revision (see ptcoef)"
  label var new_date_occupation "Date of occupational code revision"
  label var prev_occupation "Occupational code until first revision"
  sort person_id entry_date exit_date firm_id_sec
  
    tostring entry_date, replace
generate str4 entry_yrv= substr(entry_date,1,4)
generate str2 entry_mo = substr(entry_date,5,6)
generate str2 entry_da = substr(entry_date,7,8)

destring entry*, force replace

tostring exit_date, replace
generate str4 exit_yr = substr(exit_date,1,4)
generate str2 exit_mo = substr(exit_date,5,6)
generate str2 exit_da = substr(exit_date,7,8)

destring exit*, force replace

drop if exit_yr<2008

replace exit_mo=12 if exit_yr==2009
replace exit_da=31 if exit_yr==2009
replace exit_yr=2008 if exit_yr==2009

gen exit_date_2=mdy( exit_mo , exit_da , exit_yr )
gen entry_date_2=mdy( entry_mo ,entry_da, entry_yr)
gen duration=exit_date_2-entry_date_2
  
  
  save "affiliation_2008_`num'.dta", replace
  }

* 2007

foreach num of numlist 1/3 {
clear all

 import delimited "..\MCVL-2007 CDF\AFILANON`num'.trs", delimiter(";") 
 
  rename v1 person_id        
  rename v2 regime
  rename v3 occupation                  
  rename v4 contract_type
  rename v5 ptcoef
  rename v6 entry_date
  rename v7 exit_date
  rename v8 reason_dismissal
  rename v9 disability
  rename v10 firm_id_sec
  rename v11 firm_muni
  rename v12 sector_cnae93
  rename v13 firm_workers
  rename v14 firm_age
  rename v15 job_relationship
  rename v16 firm_ett
  rename v17 firm_jur_type
  rename v18 firm_jur_status
  rename v19 firm_id_tax
  rename v20 firm_id_main
  rename v21 firm_main_prov
  rename v22 new_date_contract1
  rename v23 prev_contract1
  rename v24 prev_ptcoef1
  rename v25 new_date_contract2
  rename v26 prev_contract2
  rename v27 prev_ptcoef2
  rename v28 new_date_occupation
  rename v29 prev_occupation
  label var person_id "Individual identifier"
  label var regime "Social security regime"
  label var occupation "Occupational code"
  label var contract_type "Type of job contract"
  label var ptcoef "Part time coefficient in 1/1000 of full-time equivalent, 0 if full-time"
  label var entry_date "Date of entry in this affiliation"
  label var exit_date "Date of exit in this affiliation"
  label var reason_dismissal "Reason for dismissal in this affiliation"
  label var disability "Type of disability according to entry in affiliation"
  label var firm_id_sec "Firm establishment identifier"
  label var firm_muni "Firm establishment municipality if population above 40000"
  label var sector_cnae93 "3-digit sector code"
  label var firm_workers "Number of workers in firm establsihment"
  label var firm_age "Date firm establishment registered its first worker"
  label var job_relationship "Type of job relationship"
  label var firm_ett "Firm establishment is a temporary recruitment agency (ETT)"
  label var firm_jur_type "Firm establishment juridical classification (natural vs. legal entities)"
  label var firm_jur_status "Firm establishment juridical status (NIF for legal entities)"
  label var firm_id_tax "Firm establishment identifier for matching with tax data"
  label var firm_id_main "Common firm identifier for multi-establishment firm"
  label var firm_main_prov "Province associated with common firm identifier"
  label var new_date_contract1 "Date of first type of contract revision"
  label var prev_contract1 "Type of contract until first revision"
  label var prev_ptcoef1 "Part time coefficient until first revision (see ptcoef)"
  label var new_date_contract2 "Date of second type of contract revision"
  label var prev_contract2 "Type of contract until second revision"
  label var prev_ptcoef2 "Part time coefficient until second revision (see ptcoef)"
  label var new_date_occupation "Date of occupational code revision"
  label var prev_occupation "Occupational code until first revision"
  sort person_id entry_date exit_date firm_id_sec
  
  
      tostring entry_date, replace
generate str4 entry_yrv= substr(entry_date,1,4)
generate str2 entry_mo = substr(entry_date,5,6)
generate str2 entry_da = substr(entry_date,7,8)

destring entry*, force replace

tostring exit_date, replace
generate str4 exit_yr = substr(exit_date,1,4)
generate str2 exit_mo = substr(exit_date,5,6)
generate str2 exit_da = substr(exit_date,7,8)

destring exit*, force replace

drop if exit_yr<2007

replace exit_mo=12 if exit_yr==2008
replace exit_da=31 if exit_yr==2008
replace exit_yr=2007 if exit_yr==2008

gen exit_date_2=mdy( exit_mo , exit_da , exit_yr )
gen entry_date_2=mdy( entry_mo ,entry_da, entry_yr)
gen duration=exit_date_2-entry_date_2
  
  
  
   save "affiliation_2007_`num'.dta", replace
}

* 2006

foreach num of numlist 1/3 {
 clear all
 insheet using "..\MCVL-2006 CDF\AFILANON`num'.trs", clear delimiter(";")
  rename v1 person_id        
  rename v2 regime
  rename v3 occupation                  
  rename v4 contract_type
  rename v5 ptcoef
  rename v6 entry_date
  rename v7 exit_date
  rename v8 reason_dismissal
  rename v9 disability
  rename v10 firm_id_sec
  rename v11 firm_muni
  rename v12 sector_cnae93
  rename v13 firm_workers
  rename v14 firm_age
  rename v15 job_relationship
  rename v16 firm_ett
  rename v17 firm_jur_type
  rename v18 firm_jur_status
  rename v19 firm_id_tax
  rename v20 firm_id_main
  rename v21 firm_main_prov
  rename v22 new_date_contract1
  rename v23 prev_contract1
  rename v24 prev_ptcoef1
  rename v25 new_date_contract2
  rename v26 prev_contract2
  rename v27 prev_ptcoef2
  rename v28 new_date_occupation
  rename v29 prev_occupation
  label var person_id "Individual identifier"
  label var regime "Social security regime"
  label var occupation "Occupational code"
  label var contract_type "Type of job contract"
  label var ptcoef "Part time coefficient in 1/1000 of full-time equivalent, 0 if full-time"
  label var entry_date "Date of entry in this affiliation"
  label var exit_date "Date of exit in this affiliation"
  label var reason_dismissal "Reason for dismissal in this affiliation"
  label var disability "Type of disability according to entry in affiliation"
  label var firm_id_sec "Firm establishment identifier"
  label var firm_muni "Firm establishment municipality if population above 40000"
  label var sector_cnae93 "3-digit sector code"
  label var firm_workers "Number of workers in firm establsihment"
  label var firm_age "Date firm establishment registered its first worker"
  label var job_relationship "Type of job relationship"
  label var firm_ett "Firm establishment is a temporary recruitment agency (ETT)"
  label var firm_jur_type "Firm establishment juridical classification (natural vs. legal entities)"
  label var firm_jur_status "Firm establishment juridical status (NIF for legal entities)"
  label var firm_id_tax "Firm establishment identifier for matching with tax data"
  label var firm_id_main "Common firm identifier for multi-establishment firm"
  label var firm_main_prov "Province associated with common firm identifier"
  label var new_date_contract1 "Date of first type of contract revision"
  label var prev_contract1 "Type of contract until first revision"
  label var prev_ptcoef1 "Part time coefficient until first revision (see ptcoef)"
  label var new_date_contract2 "Date of second type of contract revision"
  label var prev_contract2 "Type of contract until second revision"
  label var prev_ptcoef2 "Part time coefficient until second revision (see ptcoef)"
  label var new_date_occupation "Date of occupational code revision"
  label var prev_occupation "Occupational code until first revision"
  sort person_id entry_date exit_date firm_id_sec
  
  
  
    
tostring entry_date, replace
generate str4 entry_yrv= substr(entry_date,1,4)
generate str2 entry_mo = substr(entry_date,5,6)
generate str2 entry_da = substr(entry_date,7,8)

destring entry*, force replace

tostring exit_date, replace
generate str4 exit_yr = substr(exit_date,1,4)
generate str2 exit_mo = substr(exit_date,5,6)
generate str2 exit_da = substr(exit_date,7,8)

destring exit*, force replace

drop if exit_yr<2006

replace exit_mo=12 if exit_yr==2007
replace exit_da=31 if exit_yr==2007
replace exit_yr=2006 if exit_yr==2007

gen exit_date_2=mdy( exit_mo , exit_da , exit_yr )
gen entry_date_2=mdy( entry_mo ,entry_da, entry_yr)
gen duration=exit_date_2-entry_date_2
  
  
  
   save "affiliation_2006_`num'.dta", replace
   }

   * 2005
   
   foreach num of numlist 1/3 {
 
 clear all
 insheet using "..\MCVL-2005 CDF\AFILANON`num'.trs", clear delimiter(";")
  rename v1 person_id        
  rename v2 regime
  rename v3 occupation                  
  rename v4 contract_type
  rename v5 ptcoef
  rename v6 entry_date
  rename v7 exit_date
  rename v8 reason_dismissal
  rename v9 disability
  rename v10 firm_id_sec
  rename v11 firm_muni
  rename v12 sector_cnae93
  rename v13 firm_workers
  rename v14 firm_age
  rename v15 job_relationship
  rename v16 firm_ett
  rename v17 firm_jur_type
  rename v18 firm_jur_status
  rename v19 firm_id_tax
  rename v20 firm_id_main
  rename v21 firm_main_prov
  rename v22 new_date_contract1
  rename v23 prev_contract1
  rename v24 prev_ptcoef1
  rename v25 new_date_contract2
  rename v26 prev_contract2
  rename v27 prev_ptcoef2
  rename v28 new_date_occupation
  rename v29 prev_occupation
  label var person_id "Individual identifier"
  label var regime "Social security regime"
  label var occupation "Occupational code"
  label var contract_type "Type of job contract"
  label var ptcoef "Part time coefficient in 1/1000 of full-time equivalent, 0 if full-time"
  label var entry_date "Date of entry in this affiliation"
  label var exit_date "Date of exit in this affiliation"
  label var reason_dismissal "Reason for dismissal in this affiliation"
  label var disability "Type of disability according to entry in affiliation"
  label var firm_id_sec "Firm establishment identifier"
  label var firm_muni "Firm establishment municipality if population above 40000"
  label var sector_cnae93 "3-digit sector code"
  label var firm_workers "Number of workers in firm establsihment"
  label var firm_age "Date firm establishment registered its first worker"
  label var job_relationship "Type of job relationship"
  label var firm_ett "Firm establishment is a temporary recruitment agency (ETT)"
  label var firm_jur_type "Firm establishment juridical classification (natural vs. legal entities)"
  label var firm_jur_status "Firm establishment juridical status (NIF for legal entities)"
  label var firm_id_tax "Firm establishment identifier for matching with tax data"
  label var firm_id_main "Common firm identifier for multi-establishment firm"
  label var firm_main_prov "Province associated with common firm identifier"
  label var new_date_contract1 "Date of first type of contract revision"
  label var prev_contract1 "Type of contract until first revision"
  label var prev_ptcoef1 "Part time coefficient until first revision (see ptcoef)"
  label var new_date_contract2 "Date of second type of contract revision"
  label var prev_contract2 "Type of contract until second revision"
  label var prev_ptcoef2 "Part time coefficient until second revision (see ptcoef)"
  label var new_date_occupation "Date of occupational code revision"
  label var prev_occupation "Occupational code until first revision"
  sort person_id entry_date exit_date firm_id_sec
  
  
  
    
      tostring entry_date, replace
generate str4 entry_yrv= substr(entry_date,1,4)
generate str2 entry_mo = substr(entry_date,5,6)
generate str2 entry_da = substr(entry_date,7,8)

destring entry*, force replace

tostring exit_date, replace
generate str4 exit_yr = substr(exit_date,1,4)
generate str2 exit_mo = substr(exit_date,5,6)
generate str2 exit_da = substr(exit_date,7,8)

destring exit*, force replace

drop if exit_yr<2005

replace exit_mo=12 if exit_yr==2006
replace exit_da=31 if exit_yr==2006
replace exit_yr=2005 if exit_yr==2006

gen exit_date_2=mdy( exit_mo , exit_da , exit_yr )
gen entry_date_2=mdy( entry_mo ,entry_da, entry_yr)
gen duration=exit_date_2-entry_date_2
  
  
  
  
  save "affiliation_2005_`num'", replace
}

use affiliation_2005_3, replace
append using affiliation_2005_2
append using affiliation_2005_1
gen year=2005

foreach yr of numlist 2006 2007 2008 2009 2010 2011 2012 {

 foreach num of numlist 1 2 3 {

append using affiliation_`yr'_`num'.dta, force
replace year=`yr' if year==.

}

}


foreach yr of numlist 2013 2014 {

 foreach num of numlist 1 2 3 4 {

append using affiliation_`yr'_`num'.dta, force
replace year=`yr' if year==.

}

}


* define income types

gen type_selfemployed=0
replace type_selfemployed=1 if regime>=500 & regime<600

gen type_employed=0
replace type_employed=1 if regime<=200

gen type_other=0
replace type_other=1 if regime>=600

bysort person_id year: egen type_selfemployed_income=max(type_selfemployed)
bysort person_id year: egen type_employed_income=max(type_employed)


bysort person_id year: egen max_duration=max( duration )
keep if duration==max_duration
bysort person_id year: gen obs_tot_id=_N
bysort person_id year duration: gen obs_within_id=_n
drop if reason_dismissal==54&obs_tot_id>1&obs_within_id>1
drop if reason_dismissal==93&obs_tot_id>1&obs_within_id>1
drop obs_within_id obs_tot_id
bysort person_id year: gen obs_tot_id=_N
bysort person_id year duration: gen obs_within_id=_n
drop if obs_within_id>1 & obs_tot_id>1
rename person_id id

xtset id year

destring firm_id_main, replace force
gen reason_dismissal_lag=l.reason_dismissal
gen firm_muni_lag=l.firm_muni
gen firm_main_prov_lag=l.firm_main_prov
destring firm_id_main, replace force
gen firm_id_main_lag=l.firm_id_main
gen firm_id_tax_lag=l.firm_id_tax
compress

save "affiliation_panel.dta", replace

**********************************
**** GENERAL DATA MANIPULATION ***
**********************************

use "panel_wtax.dta", clear

**  create migration and location information

drop TEMPprovince_code 
gen TEMPprovince_code  = province_residence/1000
replace TEMPprovince_code  =. if TEMPprovince_code==0
replace TEMPprovince_code  = int(TEMPprovince_code )
merge m:1 TEMPprovince_code  using "auxiliary\input_prov_ccaa2.dta", update replace
gen code_ccaa_residence=TEMPcode_ccaa
rename TEMPprovince_code code_prov
drop TEMPcode_ccaa _merge

gen TEMPprovince_code = province_fiscaldata1
merge m:1 TEMPprovince_code using "auxiliary\input_prov_ccaa2.dta", update replace
gen code_ccaa_fiscal=TEMPcode_ccaa
label var code_ccaa_fiscal "region (fiscal data based)"
drop _merge TEMPprovince_code TEMPcode_ccaa

gen TEMPprovince_code = province_naf
merge m:1 TEMPprovince_code using "auxiliary\input_prov_ccaa2.dta", update replace
gen code_ccaa_socsec=TEMPcode_ccaa
label var code_ccaa_socsec "region (social security register)"
drop _merge TEMPprovince_code TEMPcode_ccaa

* migration based on fiscal data

xtset id year
gen move_fiscal=0
gen move_from_fiscal=0
gen move_to_fiscal=0

foreach yr of numlist 2014 2013 2012 2011 2010 2009 2008 2007 2006 2005 {

gen move`yr'_fiscal=1 if code_ccaa_fiscal~=l.code_ccaa_fiscal & year==`yr'&code_ccaa_fiscal~=.&l.code_ccaa_fiscal~=.

replace move`yr'_fiscal=0 if move`yr'_fiscal==.
replace move_fiscal=1  if code_ccaa_fiscal~=l.code_ccaa_fiscal & year==`yr'&code_ccaa_fiscal~=.&l.code_ccaa_fiscal~=.
replace move_from_fiscal=l.code_ccaa_fiscal if move`yr'_fiscal==1
replace move_to_fiscal=code_ccaa_fiscal if move`yr'_fiscal==1
}


* migration based on social security registration

xtset id year
gen move_socsec=0
gen move_from_socsec=0
gen move_to_socsec=0

foreach yr of numlist 2014 2013 2012 2011 2010 2009 2008 2007 2006 2005 {

gen move`yr'_socsec=1 if code_ccaa_socsec~=l.code_ccaa_socsec & year==`yr'&code_ccaa_socsec~=.&l.code_ccaa_socsec~=.

replace move`yr'_fiscal=0 if move`yr'_fiscal==.

replace move_socsec=1  if code_ccaa_socsec~=l.code_ccaa_socsec & year==`yr'&code_ccaa_socsec~=.&l.code_ccaa_socsec~=.
replace move_from_socsec=l.code_ccaa_socsec if move`yr'_socsec==1
replace move_to_socsec=code_ccaa_socsec if move`yr'_socsec==1
}

drop code_ccaa

* migration based on register data


gen code_ccaa=code_ccaa_residence
label var code_ccaa "region (register based - padron municipal in april t+1)"
label var code_ccaa_residence "region (register based - padron municipal in april t+1)"

xtset id year

gen move=0
gen move_from=0
gen move_to=0

foreach yr of numlist 2014 2013 2012 2011 2010 2009 2008 2007 2006 2005 {

gen move`yr'=1 if code_ccaa~=l.code_ccaa & year==`yr'&code_ccaa~=.&l.code_ccaa~=.
label var move`yr' "=1 if moved in `yr' to the current region"

replace move`yr'=0 if move`yr'==.

replace move=1  if code_ccaa~=l.code_ccaa & year==`yr'&code_ccaa~=.&l.code_ccaa~=.
replace move_from=l.code_ccaa if move`yr'==1
replace move_to=code_ccaa if move`yr'==1
}

replace move=.  if (code_ccaa==.|l.code_ccaa==.)


label var move "=1 if moved to the current region with respect to t-1 residence"
label var move_from "origin region / code t-1 residence"
label var move_to "destination region / code t residence"

* provincve moving information based on register

gen move_from_prov=l.code_prov
gen move_to_prov=code_prov

label var move_from_prov "origin province / code t-1 residence"
label var move_to_prov "destination province / code t residence"

gen move_prov=0


foreach yr of numlist 2014 2013 2012 2011 2010 2009 2008 2007 2006 2005 {
replace move_prov=1  if code_prov~=l.code_prov & year==`yr'&code_prov~=.&l.code_prov~=.
}
replace move_prov=.  if (code_prov==.|l.code_prov==.|code_prov==0|l.code_prov==0)
label var move_prov "=1 if moved to the current province with respect to t-1 province of residence"

* neighborhhood moving information based on register

gen zip = mod(province_residence,1000)
gen move_from_nbh=l.province_residence if zip~=0
gen move_to_nbh=province_residence if zip~=0

label var move_from_nbh "origin neighborhood / code t-1 neighborhood"
label var move_to_nbh "destination neighborhood / code t neighborhood"

gen move_nbh=0


foreach yr of numlist 2014 2013 2012 2011 2010 2009 2008 2007 2006 2005 {
replace move_nbh=1  if province_residence~=l.province_residence & year==`yr'&province_residence~=.&l.province_residence~=.&zip~=0&l.zip~=0
}
replace move_nbh=. if (zip==0|l.zip==0)
label var move_prov "=1 if moved to the current province with respect to t-1 province of residence"

* some other variables

egen obs_ccaa=count(code_ccaa_residence), by(year code_ccaa_residence)
label var obs_ccaa "total # observations per region/year"

gen move_out_06=1 if f.id==. & f2.id==. & f3.id==. & f4.id==. & f5.id==. & f6.id==. & f7.id==. & f8.id==. & f9.id==.  &year==2005
label var move_out_06 "leaving sample in 2006 (in sample in 2005)"

gen move_out_07=1 if f.id==. & f2.id==. & f3.id==. & f4.id==. & f5.id==. & f6.id==. & f7.id==. & f8.id==.   &year==2006
label var move_out_07 "leaving sample in 2007 (in sample in 2006)"

gen move_out_08=1 if f.id==. & f2.id==. & f3.id==. & f4.id==. & f5.id==. & f6.id==. & f7.id==. &year==2007
label var move_out_08 "leaving sample in 2008 (in sample in 2007)"

gen move_out_09=1 if f.id==. & f2.id==. & f3.id==. & f4.id==. & f5.id==. & f6.id==. &year==2008
label var move_out_09 "leaving sample in 2009 (in sample in 2008)"

gen move_out_10=1 if f.id==. & f2.id==. & f3.id==. & f4.id==. & f5.id==. &year==2009
label var move_out_10 "leaving sample in 2010 (in sample in 2009)"

gen move_out_11=1 if f.id==. & f2.id==. & f3.id==. & f4.id==. &year==2010
label var move_out_11 "leaving sample in 2011 (in sample in 2010)"

gen move_out_12=1 if f.id==. & f2.id==. & f3.id==. &year==2011
label var move_out_12 "leaving sample in 2012 (in sample in 2011)"

gen move_out_13=1 if f.id==. & f2.id==.  &year==2012
label var move_out_13 "leaving sample in 2013 (in sample in 2012)"

gen move_out_14=1 if f.id==.   &year==2013
label var move_out_14 "leaving sample in 2014 (in sample in 2013)"

** arrange controls

xtset id year

* age

gen year_birth= round(ym_birth/100)
gen age=year-year_birth
label var age "age"

* education

destring education, force replace
gen edu_uni=1 if education >43
replace edu_uni=0 if edu_uni==.
label var edu_uni "=1 if higher education"

* death

gen year_death=round( ym_death/100)
label var year_death "year of death"

gen dead=1 if year_death<=year& year_death~=0
label var dead "=1 if died in this year"

* occupation

merge m:1 id year using affiliation_panel.dta, update replace force
drop if _merge==2

gen occu_cat=1
replace occu_cat=2 if occupation==1
replace occu_cat=3 if occupation>=2&occupation<=3
replace occu_cat=4 if occupation>=4
replace occu_cat=999 if _merge==1
replace occu_cat=888 if occupation==0& type_selfemployed~=1
drop _merge

* gender

gen gender = 0
replace gender = 1 if sex==1

* industry

gen sector_cat=0
replace sector_cat=1 if sector<100&year>=2009
replace sector_cat=2 if sector>=100&sector<350&year>=2009
replace sector_cat=3 if sector>=350&sector<360&year>=2009
replace sector_cat=4 if sector>=360&sector<400&year>=2009
replace sector_cat=5 if sector>=400&sector<450&year>=2009
replace sector_cat=6 if sector>=450&sector<490&year>=2009
replace sector_cat=7 if sector>=490&sector<550&year>=2009
replace sector_cat=8 if sector>=550&sector<580&year>=2009
replace sector_cat=9 if sector>=580&sector<640&year>=2009
replace sector_cat=10 if sector>=640&sector<680&year>=2009
replace sector_cat=11 if sector>=680&sector<690&year>=2009
replace sector_cat=12 if sector>=690&sector<770&year>=2009
replace sector_cat=13 if sector>=770&sector<840&year>=2009
replace sector_cat=14 if sector>=840&sector<850&year>=2009
replace sector_cat=15 if sector>=850&sector<860&year>=2009
replace sector_cat=16 if sector>=860&sector<890&year>=2009
replace sector_cat=17 if sector>=900&sector<940&year>=2009
replace sector_cat=18 if sector>=940&sector<970&year>=2009
replace sector_cat=19 if sector>=970&sector<990&year>=2009
replace sector_cat=20 if sector>=990&year>=2009

replace sector_cat=1 if sector_cnae93<150&year<2009
replace sector_cat=2 if sector_cnae93>=150&sector_cnae93<400&year<2009
replace sector_cat=3 if sector_cnae93>=400&sector_cnae93<403&year<2009
replace sector_cat=4 if sector_cnae93>=403&sector_cnae93<450&year<2009
replace sector_cat=5 if sector_cnae93>=450&sector_cnae93<500&year<2009
replace sector_cat=6 if sector_cnae93>=500&sector_cnae93<550&year<2009
replace sector_cat=8 if sector_cnae93>=550&sector_cnae93<600&year<2009
replace sector_cat=7 if sector_cnae93>=600&sector_cnae93<640&year<2009
replace sector_cat=9 if sector_cnae93>=640&sector_cnae93<650&year<2009
replace sector_cat=10 if sector_cnae93>=650&sector_cnae93<700&year<2009
replace sector_cat=11 if sector_cnae93>=700&sector_cnae93<720&year<2009
replace sector_cat=9 if sector_cnae93>=720&sector_cnae93<730&year<2009
replace sector_cat=12 if sector_cnae93>=730&sector_cnae93<740&year<2009
replace sector_cat=13 if sector_cnae93>=740&sector_cnae93<750&year<2009
replace sector_cat=14 if sector_cnae93>=750&sector_cnae93<800&year<2009
replace sector_cat=15 if sector_cnae93>=800&sector_cnae93<850&year<2009
replace sector_cat=16 if sector_cnae93>=850&sector_cnae93<900&year<2009
replace sector_cat=18 if sector_cnae93>=900&sector_cnae93<920&year<2009
replace sector_cat=17 if sector_cnae93>=920&sector_cnae93<930&year<2009
replace sector_cat=18 if sector_cnae93>=930&sector_cnae93<950&year<2009
replace sector_cat=19 if sector_cnae93>=950&sector_cnae93<990&year<2009
replace sector_cat=20 if sector_cnae93>=990&year<2009


* drop what is not used in the analysis

drop if id==.
drop if code_ccaa_residence==.
drop if code_ccaa_residence==15
drop if code_ccaa_residence==16
drop if code_ccaa_residence==99
drop if code_ccaa_residence==19
drop if code_ccaa_residence==18


save "data_complete_intermediate.dta", replace


* create percentile

keep id year income code_ccaa age

gen percentile=.

foreach yr of numlist 2014 2013 2012 2011 2010 2009 2008 2007 2006 2005 {

xtile percentile`yr' = income if year==`yr', nq(100)
replace  percentile=percentile`yr' if percentile==.
}

keep id year percentile 
save "data_percentiles.dta", replace

use "data_complete_intermediate.dta", replace
merge 1:1 id year using data_percentiles.dta

* drop age after

drop if age<18
drop if age>65


** save the data
save "..\..\replication\data\data_complete.dta", replace


shell erase "data_percentiles.dta"
shell erase "data_complete_intermediate.dta"
shell erase "affiliation_*.dta"
shell erase "personal_*.dta"
shell erase "income_*.dta"

use panel.dta, replace
run ..\..\taxcalc\mtr_v6_tau.do

shell erase "panel*.dta"
