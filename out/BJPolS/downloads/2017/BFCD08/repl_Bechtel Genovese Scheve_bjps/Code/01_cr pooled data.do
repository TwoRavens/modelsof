*************************************************************************
* Replication archive for Bechtel, Genovese and Scheve (2016)            *
* "Interests, Norms and Support for the Provision of Global Public Goods:*
* The Case of Climate Cooperation", British Journal of Political Science *
*************************************************************************

set more off
clear

* Set global path 
global dropboxpath = "/Users/genovesefederica/Dropbox/Pref IEC_Context/repl_Bechtel Genovese Scheve_bjps/"
*global dropboxpath = "/Users/mbechtel/Desktop/repdata"
*"/Users/mbechtel/Desktop/Dropbox/Pref IEC_Context/repl_Bechtel Genovese Scheve_bjps/"
*global dropboxpath = "/Users/scheve/Dropbox/Pref IEC_Context/repl_Bechtel Genovese Scheve_bjps/"

/* get survey data */
cd "$dropboxpath/Data"

***********************************
* A. Prepare agreement-level data  
***********************************

/* Generate the initial pooled datasets at the agreement level from the raw YouGov data */

* Load French data
use "$dropboxpath/Data/Main FR/original survey data/main_fr_agreementlevel.dta"
gen country=1 //"France"

drop qualitycontrol_overall_scale 
*format conjoint1time %10.0g

* Load German data
append using "$dropboxpath/Data/Main GE/original survey data/main_ge_agreementlevel.dta"
replace country=2 if country>1 //"Germany" 
drop qualitycontrol_overall_scale 

* Load UK data
append using "$dropboxpath/Data/Main UK/original survey data/main_uk_agreementlevel.dta"
replace country=3 if country>2 //"UK" 

* Load US data
append using "$dropboxpath/Data/Main US/original survey data/main_us_agreementlevel.dta"
replace country=4 if country>3 //"US" 

label define country 1 "France" 2 "Germany" 3 "United Kingdom" 4 "United States"
label values country country

* Interview length indicator
drop length
gen length=minutes(endtime-starttime)
su length, det

gen length_high =0
replace length_high=1 if length>r(p75) & length<.

* saveold pooled data
saveold "$dropboxpath/Data/Main Pooled/main_pooled_agreementlevel.dta", replace

tab country

clear

***********************************
* B. Prepare individual-level data
***********************************

/* Generate the initial pooled datasets at the individual level from the raw YouGov data */

use "$dropboxpath/Data/Main FR/original survey data/main_fr.dta"
gen country=1 //"France"

drop qualitycontrol_overall_scale 

* Load German data
append using "$dropboxpath/Data/Main GE/original survey data/main_ge.dta"
replace country=2 if country>1 //"Germany" 
drop qualitycontrol_overall_scale 

* Load UK data
append using "$dropboxpath/Data/Main UK/original survey data/main_uk.dta"
replace country=3 if country>2 //"UK" 

* Load US data
append using "$dropboxpath/Data/Main US/original survey data/main_us.dta"
replace country=4 if country>3 //"US" 

label define country 1 "France" 2 "Germany" 3 "United Kingdom" 4 "United States"
label values country country

label variable altru_howmuch "Donation (£, Û, $)"

label var altru_donate "Donates:"
*label define donate 0 "No" 1 "Yes"
label values altru_donate donate

tab altru_donate country, col
xtset ID

* Length indicator
su length, det
gen length_high=0
replace length_high=1 if length>=r(p50)

* saveold pooled data

saveold "$dropboxpath/Data/Main Pooled/main_pooled.dta", replace

********************************
* C. Prepare the industry data 
********************************

/* Prepare the industry-level pollution measures from the industry-level pollution data, by country */

/* France */ 
clear
use "$dropboxpath/Data/Industry Data/isic4major_industrydata_fr.dta"

rename co2mteq_ipcc co2mteq 
rename propco2mteq_ipcc  propco2mteq
rename co2mteqipcc_employed co2mteq_employed
rename co2mteqipcc_va co2mteq_va

* Create the dichotomous/tertile/quartile variables

sum co2mt, detail
egen co2dichot =  xtile(co2mt), nquantiles(2)
table co2dichot, contents(n co2mt min co2mt max co2mt)
egen co2tert =  xtile(co2mt), nquantiles(3)
table co2tert, contents(n co2mt min co2mt max co2mt)
egen co2quart =  xtile(co2mt), nquantiles(4)
table co2quart, contents(n co2mt min co2mt max co2mt)

sum co2mteq, detail
egen co2eqdichot = xtile(co2mteq), nquantiles(2)
table co2eqdichot, contents(n co2mteq min co2mteq max co2mteq)
egen co2eqtert = xtile(co2mteq), nquantiles(3)
table co2eqtert, contents(n co2mteq min co2mteq max co2mteq)
egen co2eqquart = xtile(co2mteq), nquantiles(4)
table co2eqquart, contents(n co2mteq min co2mteq max co2mteq)

sum co2mteq_wb, detail
egen co2eqwbdichot = xtile(co2mteq_wb), nquantiles(2)
table co2eqwbdichot, contents(n co2mteq_wb min co2mteq_wb max co2mteq_wb)
egen co2eqwbtert = xtile(co2mteq_wb), nquantiles(3)
table co2eqwbtert, contents(n co2mteq_wb min co2mteq_wb max co2mteq_wb)
egen co2eqwbquart = xtile(co2mteq_wb), nquantiles(4)
table co2eqwbquart, contents(n co2mteq_wb min co2mteq_wb max co2mteq_wb)

sum enerintmtoe, detail
egen enerintdichot = xtile(enerintmtoe), nquantiles(2)
table enerintdichot, contents(n enerintmtoe min enerintmtoe max enerintmtoe)
egen enerinttert = xtile(enerintmtoe), nquantiles(3)
table enerinttert, contents(n enerintmtoe min enerintmtoe max enerintmtoe)
egen enerintquart = xtile(enerintmtoe), nquantiles(4)
table enerintquart, contents(n enerintmtoe min enerintmtoe max enerintmtoe)

sum propco2mt, detail
egen co2propdichot =  xtile(propco2mt), nquantiles(2)
table co2propdichot, contents(n propco2mt min propco2mt max propco2mt)
egen co2proptert =  xtile(propco2mt), nquantiles(3)
table co2proptert, contents(n propco2mt min propco2mt max propco2mt)
egen co2propquart = xtile(propco2mt), nquantiles(4)
table co2propquart, contents(n propco2mt min propco2mt max propco2mt)

sum propco2mteq_wb, detail
egen co2eqpropwbdichot = xtile(propco2mteq_wb), nquantiles(2)
table co2eqpropwbdichot, contents(n propco2mteq_wb min propco2mteq_wb max propco2mteq_wb)
egen co2eqpropwbtert = xtile(propco2mteq_wb), nquantiles(3)
table co2eqpropwbtert, contents(n propco2mteq_wb min propco2mteq_wb max propco2mteq_wb)
egen co2eqpropwbquart = xtile(propco2mteq), nquantiles(4)
table co2eqpropwbquart, contents(n propco2mteq_wb min propco2mteq_wb max propco2mteq_wb)

sum propco2mteq, detail
egen co2eqpropdichot = xtile(propco2mteq), nquantiles(2)
table co2eqpropdichot, contents(n propco2mteq min propco2mteq max propco2mteq)
egen co2eqproptert = xtile(propco2mteq), nquantiles(3)
table co2eqproptert, contents(n propco2mteq min propco2mteq max propco2mteq)
egen co2eqpropquart = xtile(propco2mteq), nquantiles(4)
table co2eqpropquart, contents(n propco2mteq min propco2mteq max propco2mteq)

sum propenerintmtoe, detail
egen propenerintdichot = xtile(propenerintmtoe), nquantiles(2)
table propenerintdichot, contents(n propenerintmtoe min propenerintmtoe max propenerintmtoe)
egen propenerinttert = xtile(propenerintmtoe), nquantiles(3)
table propenerinttert, contents(n propenerintmtoe min propenerintmtoe max propenerintmtoe)
egen propenerintquart = xtile(propenerintmtoe), nquantiles(4)
table propenerintquart, contents(n propenerintmtoe min propenerintmtoe max propenerintmtoe)

sum co2mt_employed, detail
egen co2employeddichot = xtile(co2mt_employed), nquantiles(2)
table co2employeddichot, contents(n co2mt_employed min co2mt_employed max co2mt_employed)
egen co2employedtert = xtile(co2mt_employed), nquantiles(3)
table co2employedtert, contents(n co2mt_employed min co2mt_employed max co2mt_employed)
egen co2employedquart = xtile(co2mt_employed), nquantiles(4)
table co2employedquart, contents(n co2mt_employed min co2mt_employed max co2mt_employed)

sum co2mteq_employed, detail
egen co2eqemployeddichot = xtile(co2mteq_employed), nquantiles(2)
table co2eqemployeddichot, contents(n co2mteq_employed min co2mteq_employed max co2mteq_employed)
egen co2eqemployedtert = xtile(co2mteq_employed), nquantiles(3)
table co2eqemployedtert, contents(n co2mteq_employed min co2mteq_employed max co2mteq_employed)
egen co2eqemployedquart= xtile(co2mteq_employed), nquantiles(4)
table co2eqemployedquart, contents(n co2mteq_employed min co2mteq_employed max co2mteq_employed)

sum co2mteqwb_employed, detail
egen co2eqemployedwbdichot = xtile(co2mteqwb_employed), nquantiles(2)
table co2eqemployedwbdichot, contents(n co2mteqwb_employed min co2mteqwb_employed max co2mteqwb_employed)
egen co2eqemployedwbtert = xtile(co2mteqwb_employed), nquantiles(3)
table co2eqemployedwbtert, contents(n co2mteqwb_employed min co2mteqwb_employed max co2mteqwb_employed)
egen co2eqemployedwbquart= xtile(co2mteqwb_employed), nquantiles(4)
table co2eqemployedwbquart, contents(n co2mteqwb_employed min co2mteqwb_employed max co2mteqwb_employed)

sum enerintmtoe_employed, detail
egen enerintemployeddichot = xtile(enerintmtoe_employed), nquantiles(2)
table enerintemployeddichot, contents(n enerintmtoe_employed min enerintmtoe_employed max enerintmtoe_employed)
egen enerintemployedtert = xtile(enerintmtoe_employed), nquantiles(3)
table enerintemployedtert, contents(n enerintmtoe_employed min enerintmtoe_employed max enerintmtoe_employed)
egen enerintemployedquart = xtile(enerintmtoe_employed), nquantiles(4)
table enerintemployedquart, contents(n enerintmtoe_employed min enerintmtoe_employed max enerintmtoe_employed)

sum co2mt_va, detail
egen co2vadichot = xtile(co2mt_va), nquantiles(2)
table co2vadichot, contents(n co2mt_va min co2mt_va max co2mt_va)
egen co2vatert = xtile(co2mt_va), nquantiles(3)
table co2vatert, contents(n co2mt_va min co2mt_va max co2mt_va)
egen co2vaquart = xtile(co2mt_va), nquantiles(4)
table co2vaquart, contents(n co2mt_va min co2mt_va max co2mt_va)

sum co2mteq_va, detail
egen co2eqvadichot = xtile(co2mteq_va), nquantiles(2)
table co2eqvadichot, contents(n co2mteq_va min co2mteq_va max co2mteq_va)
egen co2eqvatert = xtile(co2mteq_va), nquantiles(3)
table co2eqvatert, contents(n co2mteq_va min co2mteq_va max co2mteq_va)
egen co2eqvaquart = xtile(co2mteq_va), nquantiles(4)
table co2eqvaquart, contents(n co2mteq_va min co2mteq_va max co2mteq_va)

sum co2mteqwb_va, detail
egen co2eqvawbdichot = xtile(co2mteqwb_va), nquantiles(2)
table co2eqvawbdichot, contents(n co2mteqwb_va min co2mteqwb_va max co2mteqwb_va)
egen co2eqvawbtert = xtile(co2mteqwb_va), nquantiles(3)
table co2eqvawbtert, contents(n co2mteqwb_va min co2mteqwb_va max co2mteqwb_va)
egen co2eqvawbquart = xtile(co2mteqwb_va), nquantiles(4)
table co2eqvawbquart, contents(n co2mteqwb_va min co2mteqwb_va max co2mteqwb_va)

sum enerintmtoe_va, detail
egen enerintvadichot = xtile(enerintmtoe_va), nquantiles(2)
table enerintvadichot, contents(n enerintmtoe_va min enerintmtoe_va max enerintmtoe_va)
egen enerintvatert = xtile(enerintmtoe_va), nquantiles(3)
table enerintvatert, contents(n enerintmtoe_va min enerintmtoe_va max enerintmtoe_va)
egen enerintvaquart = xtile(enerintmtoe_va), nquantiles(4)
table enerintvaquart, contents(n enerintmtoe_va min enerintmtoe_va max enerintmtoe_va)

sort isic4_major_02
saveold "$dropboxpath/Data/Working Datasets/isic4major_industrydata_fr_premerge.dta", replace

/* Germany */ 
clear
use "$dropboxpath/Data/Industry Data/isic4major_industrydata_ger.dta"

rename co2mteq_ipcc co2mteq 
rename propco2mteq_ipcc  propco2mteq
rename co2mteqipcc_employed co2mteq_employed
rename co2mteqipcc_va co2mteq_va

* Create the dichotomous/tertile/quartile variables

sum co2mt, detail
egen co2dichot =  xtile(co2mt), nquantiles(2)
table co2dichot, contents(n co2mt min co2mt max co2mt)
egen co2tert =  xtile(co2mt), nquantiles(3)
table co2tert, contents(n co2mt min co2mt max co2mt)
egen co2quart =  xtile(co2mt), nquantiles(4)
table co2quart, contents(n co2mt min co2mt max co2mt)

sum co2mteq, detail
egen co2eqdichot = xtile(co2mteq), nquantiles(2)
table co2eqdichot, contents(n co2mteq min co2mteq max co2mteq)
egen co2eqtert = xtile(co2mteq), nquantiles(3)
table co2eqtert, contents(n co2mteq min co2mteq max co2mteq)
egen co2eqquart = xtile(co2mteq), nquantiles(4)
table co2eqquart, contents(n co2mteq min co2mteq max co2mteq)

sum co2mteq_wb, detail
egen co2eqwbdichot = xtile(co2mteq_wb), nquantiles(2)
table co2eqwbdichot, contents(n co2mteq_wb min co2mteq_wb max co2mteq_wb)
egen co2eqwbtert = xtile(co2mteq_wb), nquantiles(3)
table co2eqwbtert, contents(n co2mteq_wb min co2mteq_wb max co2mteq_wb)
egen co2eqwbquart = xtile(co2mteq_wb), nquantiles(4)
table co2eqwbquart, contents(n co2mteq_wb min co2mteq_wb max co2mteq_wb)

sum enerintmtoe, detail
egen enerintdichot = xtile(enerintmtoe), nquantiles(2)
table enerintdichot, contents(n enerintmtoe min enerintmtoe max enerintmtoe)
egen enerinttert = xtile(enerintmtoe), nquantiles(3)
table enerinttert, contents(n enerintmtoe min enerintmtoe max enerintmtoe)
egen enerintquart = xtile(enerintmtoe), nquantiles(4)
table enerintquart, contents(n enerintmtoe min enerintmtoe max enerintmtoe)

sum propco2mt, detail
egen co2propdichot =  xtile(propco2mt), nquantiles(2)
table co2propdichot, contents(n propco2mt min propco2mt max propco2mt)
egen co2proptert =  xtile(propco2mt), nquantiles(3)
table co2proptert, contents(n propco2mt min propco2mt max propco2mt)
egen co2propquart = xtile(propco2mt), nquantiles(4)
table co2propquart, contents(n propco2mt min propco2mt max propco2mt)

sum propco2mteq_wb, detail
egen co2eqpropwbdichot = xtile(propco2mteq_wb), nquantiles(2)
table co2eqpropwbdichot, contents(n propco2mteq_wb min propco2mteq_wb max propco2mteq_wb)
egen co2eqpropwbtert = xtile(propco2mteq_wb), nquantiles(3)
table co2eqpropwbtert, contents(n propco2mteq_wb min propco2mteq_wb max propco2mteq_wb)
egen co2eqpropwbquart = xtile(propco2mteq), nquantiles(4)
table co2eqpropwbquart, contents(n propco2mteq_wb min propco2mteq_wb max propco2mteq_wb)

sum propco2mteq, detail
egen co2eqpropdichot = xtile(propco2mteq), nquantiles(2)
table co2eqpropdichot, contents(n propco2mteq min propco2mteq max propco2mteq)
egen co2eqproptert = xtile(propco2mteq), nquantiles(3)
table co2eqproptert, contents(n propco2mteq min propco2mteq max propco2mteq)
egen co2eqpropquart = xtile(propco2mteq), nquantiles(4)
table co2eqpropquart, contents(n propco2mteq min propco2mteq max propco2mteq)

sum propenerintmtoe, detail
egen propenerintdichot = xtile(propenerintmtoe), nquantiles(2)
table propenerintdichot, contents(n propenerintmtoe min propenerintmtoe max propenerintmtoe)
egen propenerinttert = xtile(propenerintmtoe), nquantiles(3)
table propenerinttert, contents(n propenerintmtoe min propenerintmtoe max propenerintmtoe)
egen propenerintquart = xtile(propenerintmtoe), nquantiles(4)
table propenerintquart, contents(n propenerintmtoe min propenerintmtoe max propenerintmtoe)

sum co2mt_employed, detail
egen co2employeddichot = xtile(co2mt_employed), nquantiles(2)
table co2employeddichot, contents(n co2mt_employed min co2mt_employed max co2mt_employed)
egen co2employedtert = xtile(co2mt_employed), nquantiles(3)
table co2employedtert, contents(n co2mt_employed min co2mt_employed max co2mt_employed)
egen co2employedquart = xtile(co2mt_employed), nquantiles(4)
table co2employedquart, contents(n co2mt_employed min co2mt_employed max co2mt_employed)

sum co2mteq_employed, detail
egen co2eqemployeddichot = xtile(co2mteq_employed), nquantiles(2)
table co2eqemployeddichot, contents(n co2mteq_employed min co2mteq_employed max co2mteq_employed)
egen co2eqemployedtert = xtile(co2mteq_employed), nquantiles(3)
table co2eqemployedtert, contents(n co2mteq_employed min co2mteq_employed max co2mteq_employed)
egen co2eqemployedquart= xtile(co2mteq_employed), nquantiles(4)
table co2eqemployedquart, contents(n co2mteq_employed min co2mteq_employed max co2mteq_employed)

sum co2mteqwb_employed, detail
egen co2eqemployedwbdichot = xtile(co2mteqwb_employed), nquantiles(2)
table co2eqemployedwbdichot, contents(n co2mteqwb_employed min co2mteqwb_employed max co2mteqwb_employed)
egen co2eqemployedwbtert = xtile(co2mteqwb_employed), nquantiles(3)
table co2eqemployedwbtert, contents(n co2mteqwb_employed min co2mteqwb_employed max co2mteqwb_employed)
egen co2eqemployedwbquart= xtile(co2mteqwb_employed), nquantiles(4)
table co2eqemployedwbquart, contents(n co2mteqwb_employed min co2mteqwb_employed max co2mteqwb_employed)

sum enerintmtoe_employed, detail
egen enerintemployeddichot = xtile(enerintmtoe_employed), nquantiles(2)
table enerintemployeddichot, contents(n enerintmtoe_employed min enerintmtoe_employed max enerintmtoe_employed)
egen enerintemployedtert = xtile(enerintmtoe_employed), nquantiles(3)
table enerintemployedtert, contents(n enerintmtoe_employed min enerintmtoe_employed max enerintmtoe_employed)
egen enerintemployedquart = xtile(enerintmtoe_employed), nquantiles(4)
table enerintemployedquart, contents(n enerintmtoe_employed min enerintmtoe_employed max enerintmtoe_employed)

sum co2mt_va, detail
egen co2vadichot = xtile(co2mt_va), nquantiles(2)
table co2vadichot, contents(n co2mt_va min co2mt_va max co2mt_va)
egen co2vatert = xtile(co2mt_va), nquantiles(3)
table co2vatert, contents(n co2mt_va min co2mt_va max co2mt_va)
egen co2vaquart = xtile(co2mt_va), nquantiles(4)
table co2vaquart, contents(n co2mt_va min co2mt_va max co2mt_va)

sum co2mteq_va, detail
egen co2eqvadichot = xtile(co2mteq_va), nquantiles(2)
table co2eqvadichot, contents(n co2mteq_va min co2mteq_va max co2mteq_va)
egen co2eqvatert = xtile(co2mteq_va), nquantiles(3)
table co2eqvatert, contents(n co2mteq_va min co2mteq_va max co2mteq_va)
egen co2eqvaquart = xtile(co2mteq_va), nquantiles(4)
table co2eqvaquart, contents(n co2mteq_va min co2mteq_va max co2mteq_va)

sum co2mteqwb_va, detail
egen co2eqvawbdichot = xtile(co2mteqwb_va), nquantiles(2)
table co2eqvawbdichot, contents(n co2mteqwb_va min co2mteqwb_va max co2mteqwb_va)
egen co2eqvawbtert = xtile(co2mteqwb_va), nquantiles(3)
table co2eqvawbtert, contents(n co2mteqwb_va min co2mteqwb_va max co2mteqwb_va)
egen co2eqvawbquart = xtile(co2mteqwb_va), nquantiles(4)
table co2eqvawbquart, contents(n co2mteqwb_va min co2mteqwb_va max co2mteqwb_va)

sum enerintmtoe_va, detail
egen enerintvadichot = xtile(enerintmtoe_va), nquantiles(2)
table enerintvadichot, contents(n enerintmtoe_va min enerintmtoe_va max enerintmtoe_va)
egen enerintvatert = xtile(enerintmtoe_va), nquantiles(3)
table enerintvatert, contents(n enerintmtoe_va min enerintmtoe_va max enerintmtoe_va)
egen enerintvaquart = xtile(enerintmtoe_va), nquantiles(4)
table enerintvaquart, contents(n enerintmtoe_va min enerintmtoe_va max enerintmtoe_va)

sort isic4_major_02
saveold "$dropboxpath/Data/Working Datasets/isic4major_industrydata_ger_premerge.dta", replace

/* UK */ 
clear
use "$dropboxpath/Data/Industry Data/isic4major_industrydata_uk.dta"

rename co2mteq_ipcc co2mteq 
rename propco2mteq_ipcc  propco2mteq
rename co2mteqipcc_employed co2mteq_employed
rename co2mteqipcc_va co2mteq_va

* Create the dichotomous/tertile/quartile variables

sum co2mt, detail
egen co2dichot =  xtile(co2mt), nquantiles(2)
table co2dichot, contents(n co2mt min co2mt max co2mt)
egen co2tert =  xtile(co2mt), nquantiles(3)
table co2tert, contents(n co2mt min co2mt max co2mt)
egen co2quart =  xtile(co2mt), nquantiles(4)
table co2quart, contents(n co2mt min co2mt max co2mt)

sum co2mteq, detail
egen co2eqdichot = xtile(co2mteq), nquantiles(2)
table co2eqdichot, contents(n co2mteq min co2mteq max co2mteq)
egen co2eqtert = xtile(co2mteq), nquantiles(3)
table co2eqtert, contents(n co2mteq min co2mteq max co2mteq)
egen co2eqquart = xtile(co2mteq), nquantiles(4)
table co2eqquart, contents(n co2mteq min co2mteq max co2mteq)

sum co2mteq_wb, detail
egen co2eqwbdichot = xtile(co2mteq_wb), nquantiles(2)
table co2eqwbdichot, contents(n co2mteq_wb min co2mteq_wb max co2mteq_wb)
egen co2eqwbtert = xtile(co2mteq_wb), nquantiles(3)
table co2eqwbtert, contents(n co2mteq_wb min co2mteq_wb max co2mteq_wb)
egen co2eqwbquart = xtile(co2mteq_wb), nquantiles(4)
table co2eqwbquart, contents(n co2mteq_wb min co2mteq_wb max co2mteq_wb)

sum enerintmtoe, detail
egen enerintdichot = xtile(enerintmtoe), nquantiles(2)
table enerintdichot, contents(n enerintmtoe min enerintmtoe max enerintmtoe)
egen enerinttert = xtile(enerintmtoe), nquantiles(3)
table enerinttert, contents(n enerintmtoe min enerintmtoe max enerintmtoe)
egen enerintquart = xtile(enerintmtoe), nquantiles(4)
table enerintquart, contents(n enerintmtoe min enerintmtoe max enerintmtoe)

sum propco2mt, detail
egen co2propdichot =  xtile(propco2mt), nquantiles(2)
table co2propdichot, contents(n propco2mt min propco2mt max propco2mt)
egen co2proptert =  xtile(propco2mt), nquantiles(3)
table co2proptert, contents(n propco2mt min propco2mt max propco2mt)
egen co2propquart = xtile(propco2mt), nquantiles(4)
table co2propquart, contents(n propco2mt min propco2mt max propco2mt)

sum propco2mteq_wb, detail
egen co2eqpropwbdichot = xtile(propco2mteq_wb), nquantiles(2)
table co2eqpropwbdichot, contents(n propco2mteq_wb min propco2mteq_wb max propco2mteq_wb)
egen co2eqpropwbtert = xtile(propco2mteq_wb), nquantiles(3)
table co2eqpropwbtert, contents(n propco2mteq_wb min propco2mteq_wb max propco2mteq_wb)
egen co2eqpropwbquart = xtile(propco2mteq), nquantiles(4)
table co2eqpropwbquart, contents(n propco2mteq_wb min propco2mteq_wb max propco2mteq_wb)

sum propco2mteq, detail
egen co2eqpropdichot = xtile(propco2mteq), nquantiles(2)
table co2eqpropdichot, contents(n propco2mteq min propco2mteq max propco2mteq)
egen co2eqproptert = xtile(propco2mteq), nquantiles(3)
table co2eqproptert, contents(n propco2mteq min propco2mteq max propco2mteq)
egen co2eqpropquart = xtile(propco2mteq), nquantiles(4)
table co2eqpropquart, contents(n propco2mteq min propco2mteq max propco2mteq)

sum propenerintmtoe, detail
egen propenerintdichot = xtile(propenerintmtoe), nquantiles(2)
table propenerintdichot, contents(n propenerintmtoe min propenerintmtoe max propenerintmtoe)
egen propenerinttert = xtile(propenerintmtoe), nquantiles(3)
table propenerinttert, contents(n propenerintmtoe min propenerintmtoe max propenerintmtoe)
egen propenerintquart = xtile(propenerintmtoe), nquantiles(4)
table propenerintquart, contents(n propenerintmtoe min propenerintmtoe max propenerintmtoe)

sum co2mt_employed, detail
egen co2employeddichot = xtile(co2mt_employed), nquantiles(2)
table co2employeddichot, contents(n co2mt_employed min co2mt_employed max co2mt_employed)
egen co2employedtert = xtile(co2mt_employed), nquantiles(3)
table co2employedtert, contents(n co2mt_employed min co2mt_employed max co2mt_employed)
egen co2employedquart = xtile(co2mt_employed), nquantiles(4)
table co2employedquart, contents(n co2mt_employed min co2mt_employed max co2mt_employed)

sum co2mteq_employed, detail
egen co2eqemployeddichot = xtile(co2mteq_employed), nquantiles(2)
table co2eqemployeddichot, contents(n co2mteq_employed min co2mteq_employed max co2mteq_employed)
egen co2eqemployedtert = xtile(co2mteq_employed), nquantiles(3)
table co2eqemployedtert, contents(n co2mteq_employed min co2mteq_employed max co2mteq_employed)
egen co2eqemployedquart= xtile(co2mteq_employed), nquantiles(4)
table co2eqemployedquart, contents(n co2mteq_employed min co2mteq_employed max co2mteq_employed)

sum co2mteqwb_employed, detail
egen co2eqemployedwbdichot = xtile(co2mteqwb_employed), nquantiles(2)
table co2eqemployedwbdichot, contents(n co2mteqwb_employed min co2mteqwb_employed max co2mteqwb_employed)
egen co2eqemployedwbtert = xtile(co2mteqwb_employed), nquantiles(3)
table co2eqemployedwbtert, contents(n co2mteqwb_employed min co2mteqwb_employed max co2mteqwb_employed)
egen co2eqemployedwbquart= xtile(co2mteqwb_employed), nquantiles(4)
table co2eqemployedwbquart, contents(n co2mteqwb_employed min co2mteqwb_employed max co2mteqwb_employed)

sum enerintmtoe_employed, detail
egen enerintemployeddichot = xtile(enerintmtoe_employed), nquantiles(2)
table enerintemployeddichot, contents(n enerintmtoe_employed min enerintmtoe_employed max enerintmtoe_employed)
egen enerintemployedtert = xtile(enerintmtoe_employed), nquantiles(3)
table enerintemployedtert, contents(n enerintmtoe_employed min enerintmtoe_employed max enerintmtoe_employed)
egen enerintemployedquart = xtile(enerintmtoe_employed), nquantiles(4)
table enerintemployedquart, contents(n enerintmtoe_employed min enerintmtoe_employed max enerintmtoe_employed)

sum co2mt_va, detail
egen co2vadichot = xtile(co2mt_va), nquantiles(2)
table co2vadichot, contents(n co2mt_va min co2mt_va max co2mt_va)
egen co2vatert = xtile(co2mt_va), nquantiles(3)
table co2vatert, contents(n co2mt_va min co2mt_va max co2mt_va)
egen co2vaquart = xtile(co2mt_va), nquantiles(4)
table co2vaquart, contents(n co2mt_va min co2mt_va max co2mt_va)

sum co2mteq_va, detail
egen co2eqvadichot = xtile(co2mteq_va), nquantiles(2)
table co2eqvadichot, contents(n co2mteq_va min co2mteq_va max co2mteq_va)
egen co2eqvatert = xtile(co2mteq_va), nquantiles(3)
table co2eqvatert, contents(n co2mteq_va min co2mteq_va max co2mteq_va)
egen co2eqvaquart = xtile(co2mteq_va), nquantiles(4)
table co2eqvaquart, contents(n co2mteq_va min co2mteq_va max co2mteq_va)

sum co2mteqwb_va, detail
egen co2eqvawbdichot = xtile(co2mteqwb_va), nquantiles(2)
table co2eqvawbdichot, contents(n co2mteqwb_va min co2mteqwb_va max co2mteqwb_va)
egen co2eqvawbtert = xtile(co2mteqwb_va), nquantiles(3)
table co2eqvawbtert, contents(n co2mteqwb_va min co2mteqwb_va max co2mteqwb_va)
egen co2eqvawbquart = xtile(co2mteqwb_va), nquantiles(4)
table co2eqvawbquart, contents(n co2mteqwb_va min co2mteqwb_va max co2mteqwb_va)

sum enerintmtoe_va, detail
egen enerintvadichot = xtile(enerintmtoe_va), nquantiles(2)
table enerintvadichot, contents(n enerintmtoe_va min enerintmtoe_va max enerintmtoe_va)
egen enerintvatert = xtile(enerintmtoe_va), nquantiles(3)
table enerintvatert, contents(n enerintmtoe_va min enerintmtoe_va max enerintmtoe_va)
egen enerintvaquart = xtile(enerintmtoe_va), nquantiles(4)
table enerintvaquart, contents(n enerintmtoe_va min enerintmtoe_va max enerintmtoe_va)

sort isic4_major_02
saveold "$dropboxpath/Data/Working Datasets/isic4major_industrydata_uk_premerge.dta", replace

/* US */ 

clear
use "$dropboxpath/Data/Industry Data/isic4major_industrydata_us.dta"

rename co2mteq_ipcc co2mteq 
rename propco2mteq_ipcc  propco2mteq
rename co2mteqipcc_employed co2mteq_employed
rename co2mteqipcc_va co2mteq_va

* Create the dichotomous/tertile/quartile variables

sum co2mt, detail
egen co2dichot =  xtile(co2mt), nquantiles(2)
table co2dichot, contents(n co2mt min co2mt max co2mt)
egen co2tert =  xtile(co2mt), nquantiles(3)
table co2tert, contents(n co2mt min co2mt max co2mt)
egen co2quart =  xtile(co2mt), nquantiles(4)
table co2quart, contents(n co2mt min co2mt max co2mt)

sum co2mteq, detail
egen co2eqdichot = xtile(co2mteq), nquantiles(2)
table co2eqdichot, contents(n co2mteq min co2mteq max co2mteq)
egen co2eqtert = xtile(co2mteq), nquantiles(3)
table co2eqtert, contents(n co2mteq min co2mteq max co2mteq)
egen co2eqquart = xtile(co2mteq), nquantiles(4)
table co2eqquart, contents(n co2mteq min co2mteq max co2mteq)

sum co2mteq_wb, detail
egen co2eqwbdichot = xtile(co2mteq_wb), nquantiles(2)
table co2eqwbdichot, contents(n co2mteq_wb min co2mteq_wb max co2mteq_wb)
egen co2eqwbtert = xtile(co2mteq_wb), nquantiles(3)
table co2eqwbtert, contents(n co2mteq_wb min co2mteq_wb max co2mteq_wb)
egen co2eqwbquart = xtile(co2mteq_wb), nquantiles(4)
table co2eqwbquart, contents(n co2mteq_wb min co2mteq_wb max co2mteq_wb)

sum enerintmtoe, detail
egen enerintdichot = xtile(enerintmtoe), nquantiles(2)
table enerintdichot, contents(n enerintmtoe min enerintmtoe max enerintmtoe)
egen enerinttert = xtile(enerintmtoe), nquantiles(3)
table enerinttert, contents(n enerintmtoe min enerintmtoe max enerintmtoe)
egen enerintquart = xtile(enerintmtoe), nquantiles(4)
table enerintquart, contents(n enerintmtoe min enerintmtoe max enerintmtoe)

sum propco2mt, detail
egen co2propdichot =  xtile(propco2mt), nquantiles(2)
table co2propdichot, contents(n propco2mt min propco2mt max propco2mt)
egen co2proptert =  xtile(propco2mt), nquantiles(3)
table co2proptert, contents(n propco2mt min propco2mt max propco2mt)
egen co2propquart = xtile(propco2mt), nquantiles(4)
table co2propquart, contents(n propco2mt min propco2mt max propco2mt)

sum propco2mteq_wb, detail
egen co2eqpropwbdichot = xtile(propco2mteq_wb), nquantiles(2)
table co2eqpropwbdichot, contents(n propco2mteq_wb min propco2mteq_wb max propco2mteq_wb)
egen co2eqpropwbtert = xtile(propco2mteq_wb), nquantiles(3)
table co2eqpropwbtert, contents(n propco2mteq_wb min propco2mteq_wb max propco2mteq_wb)
egen co2eqpropwbquart = xtile(propco2mteq), nquantiles(4)
table co2eqpropwbquart, contents(n propco2mteq_wb min propco2mteq_wb max propco2mteq_wb)

sum propco2mteq, detail
egen co2eqpropdichot = xtile(propco2mteq), nquantiles(2)
table co2eqpropdichot, contents(n propco2mteq min propco2mteq max propco2mteq)
egen co2eqproptert = xtile(propco2mteq), nquantiles(3)
table co2eqproptert, contents(n propco2mteq min propco2mteq max propco2mteq)
egen co2eqpropquart = xtile(propco2mteq), nquantiles(4)
table co2eqpropquart, contents(n propco2mteq min propco2mteq max propco2mteq)

sum propenerintmtoe, detail
egen propenerintdichot = xtile(propenerintmtoe), nquantiles(2)
table propenerintdichot, contents(n propenerintmtoe min propenerintmtoe max propenerintmtoe)
egen propenerinttert = xtile(propenerintmtoe), nquantiles(3)
table propenerinttert, contents(n propenerintmtoe min propenerintmtoe max propenerintmtoe)
egen propenerintquart = xtile(propenerintmtoe), nquantiles(4)
table propenerintquart, contents(n propenerintmtoe min propenerintmtoe max propenerintmtoe)

sum co2mt_employed, detail
egen co2employeddichot = xtile(co2mt_employed), nquantiles(2)
table co2employeddichot, contents(n co2mt_employed min co2mt_employed max co2mt_employed)
egen co2employedtert = xtile(co2mt_employed), nquantiles(3)
table co2employedtert, contents(n co2mt_employed min co2mt_employed max co2mt_employed)
egen co2employedquart = xtile(co2mt_employed), nquantiles(4)
table co2employedquart, contents(n co2mt_employed min co2mt_employed max co2mt_employed)

sum co2mteq_employed, detail
egen co2eqemployeddichot = xtile(co2mteq_employed), nquantiles(2)
table co2eqemployeddichot, contents(n co2mteq_employed min co2mteq_employed max co2mteq_employed)
egen co2eqemployedtert = xtile(co2mteq_employed), nquantiles(3)
table co2eqemployedtert, contents(n co2mteq_employed min co2mteq_employed max co2mteq_employed)
egen co2eqemployedquart= xtile(co2mteq_employed), nquantiles(4)
table co2eqemployedquart, contents(n co2mteq_employed min co2mteq_employed max co2mteq_employed)

sum co2mteqwb_employed, detail
egen co2eqemployedwbdichot = xtile(co2mteqwb_employed), nquantiles(2)
table co2eqemployedwbdichot, contents(n co2mteqwb_employed min co2mteqwb_employed max co2mteqwb_employed)
egen co2eqemployedwbtert = xtile(co2mteqwb_employed), nquantiles(3)
table co2eqemployedwbtert, contents(n co2mteqwb_employed min co2mteqwb_employed max co2mteqwb_employed)
egen co2eqemployedwbquart= xtile(co2mteqwb_employed), nquantiles(4)
table co2eqemployedwbquart, contents(n co2mteqwb_employed min co2mteqwb_employed max co2mteqwb_employed)

sum enerintmtoe_employed, detail
egen enerintemployeddichot = xtile(enerintmtoe_employed), nquantiles(2)
table enerintemployeddichot, contents(n enerintmtoe_employed min enerintmtoe_employed max enerintmtoe_employed)
egen enerintemployedtert = xtile(enerintmtoe_employed), nquantiles(3)
table enerintemployedtert, contents(n enerintmtoe_employed min enerintmtoe_employed max enerintmtoe_employed)
egen enerintemployedquart = xtile(enerintmtoe_employed), nquantiles(4)
table enerintemployedquart, contents(n enerintmtoe_employed min enerintmtoe_employed max enerintmtoe_employed)

sum co2mt_va, detail
egen co2vadichot = xtile(co2mt_va), nquantiles(2)
table co2vadichot, contents(n co2mt_va min co2mt_va max co2mt_va)
egen co2vatert = xtile(co2mt_va), nquantiles(3)
table co2vatert, contents(n co2mt_va min co2mt_va max co2mt_va)
egen co2vaquart = xtile(co2mt_va), nquantiles(4)
table co2vaquart, contents(n co2mt_va min co2mt_va max co2mt_va)

sum co2mteq_va, detail
egen co2eqvadichot = xtile(co2mteq_va), nquantiles(2)
table co2eqvadichot, contents(n co2mteq_va min co2mteq_va max co2mteq_va)
egen co2eqvatert = xtile(co2mteq_va), nquantiles(3)
table co2eqvatert, contents(n co2mteq_va min co2mteq_va max co2mteq_va)
egen co2eqvaquart = xtile(co2mteq_va), nquantiles(4)
table co2eqvaquart, contents(n co2mteq_va min co2mteq_va max co2mteq_va)

sum co2mteqwb_va, detail
egen co2eqvawbdichot = xtile(co2mteqwb_va), nquantiles(2)
table co2eqvawbdichot, contents(n co2mteqwb_va min co2mteqwb_va max co2mteqwb_va)
egen co2eqvawbtert = xtile(co2mteqwb_va), nquantiles(3)
table co2eqvawbtert, contents(n co2mteqwb_va min co2mteqwb_va max co2mteqwb_va)
egen co2eqvawbquart = xtile(co2mteqwb_va), nquantiles(4)
table co2eqvawbquart, contents(n co2mteqwb_va min co2mteqwb_va max co2mteqwb_va)

sum enerintmtoe_va, detail
egen enerintvadichot = xtile(enerintmtoe_va), nquantiles(2)
table enerintvadichot, contents(n enerintmtoe_va min enerintmtoe_va max enerintmtoe_va)
egen enerintvatert = xtile(enerintmtoe_va), nquantiles(3)
table enerintvatert, contents(n enerintmtoe_va min enerintmtoe_va max enerintmtoe_va)
egen enerintvaquart = xtile(enerintmtoe_va), nquantiles(4)
table enerintvaquart, contents(n enerintmtoe_va min enerintmtoe_va max enerintmtoe_va)

sort isic4_major_02
saveold "$dropboxpath/Data/Working Datasets/isic4major_industrydata_us_premerge.dta", replace

clear

************************************************
* D. Merge agreement-level data + industry data
************************************************

/* First merge agreement datasets with the rearranged ISIC 22 category, i.e. the individuals who responded `none of these' 
to the industry of employment question but were still assigned to an industry based on their job description (see Appendix, p. 3).
Then add the industry-level pollution measures to the agreement-level dataset */

/* France */ 

use "$dropboxpath/Data/Main FR/original survey data/main_fr_agreementlevel.dta"
drop _merge
gen country=1 //"France"
drop qualitycontrol_overall_scale 

sort ID
cd "$dropboxpath/Data/Main FR"
merge m:1 ID using france_rearrangedisiccat22.dta
tab _merge
drop _merge

sort isic4_major_02
cd "$dropboxpath/Data/Working Datasets"
merge m:1 isic4_major_02 using isic4major_industrydata_fr_premerge.dta
tab _merge
drop _merge
sort ID

saveold "$dropboxpath/Data/Main FR/main_fr_agreementlevel_industry.dta", replace

/* Germany */ 
clear

use "$dropboxpath/Data/Main GE/original survey data/main_ge_agreementlevel.dta"
drop _merge
gen country=2 //"Germany"
drop qualitycontrol_overall_scale 

sort ID
cd "$dropboxpath/Data/Main GE"
merge m:1 ID using germany_rearrangedisiccat22.dta
tab _merge
drop _merge

sort isic4_major_02
cd "$dropboxpath/Data/Working Datasets"
merge m:1 isic4_major_02 using isic4major_industrydata_ger_premerge.dta
tab _merge
drop _merge
sort ID

saveold "$dropboxpath/Data/Main GE/main_ger_agreementlevel_industry.dta", replace

/* UK */ 
clear
use "$dropboxpath/Data/Main Uk/original survey data/main_uk_agreementlevel.dta"
drop _merge
gen country=3 //"UK"

sort ID
cd "$dropboxpath/Data/Main Uk"
merge m:1 ID using uk_rearrangedisiccat22.dta
tab _merge
drop _merge

sort isic4_major_02
cd "$dropboxpath/Data/Working Datasets"
merge m:1 isic4_major_02 using isic4major_industrydata_uk_premerge.dta
tab _merge
drop _merge
sort ID

saveold "$dropboxpath/Data/Main Uk/main_uk_agreementlevel_industry.dta", replace

/* US */ 
clear
use "$dropboxpath/Data/Main US/original survey data/main_us_agreementlevel.dta"
drop _merge
gen country=4 //"US"

sort ID
cd "$dropboxpath/Data/Main US"
merge m:1 ID using us_rearrangedisiccat22.dta
tab _merge
drop _merge

sort isic4_major_02
cd "$dropboxpath/Data/Working Datasets"
merge m:1 isic4_major_02 using isic4major_industrydata_us_premerge.dta
tab _merge
drop _merge
sort ID

saveold "$dropboxpath/Data/Main US/main_us_agreementlevel_industry.dta", replace
clear

/* Pooled */ 

* Load French data
use "$dropboxpath/Data/Main FR/main_fr_agreementlevel_industry.dta"

* Load German data
append using "$dropboxpath/Data/Main GE/main_ger_agreementlevel_industry.dta"

* Load UK data
append using "$dropboxpath/Data/Main Uk/main_uk_agreementlevel_industry.dta"

* Load US data
append using "$dropboxpath/Data/Main US/main_us_agreementlevel_industry.dta"

label define country 1 "France" 2 "Germany" 3 "United Kingdom" 4 "United States"
label values country country

* Interview length indicator
drop length
gen length=minutes(endtime-starttime)
su length, det

gen length_high =0
replace length_high=1 if length>r(p75) & length<.

* Save agreement level data: Only ID, conjoint data, and ISIC4 variable
keep ID country isic4_major_02 ID agreement conjoint  conjoint1 conjoint2 conjoint3 conjoint4 rating_cj choice_cj ctries_cj cost_cj emissions_cj distrib_cj sanctions_cj monitoring_cj order conjoint1time conjoint2time conjoint3time conjoint4time attentioncheck_pass_yougov attentioncheck_1 attentioncheck_2 attentioncheck_3 attentioncheck_4 attentioncheck_5 attentioncheck_6
saveold "$dropboxpath/Data/Working Datasets/main_pooled_agreementlevel_industry.dta", replace

***************************************************************************************************
* E. Merge individual-level data + industry data and Generate final pooled individual-level dataset
***************************************************************************************************

/* First merge individual datasets with the rearranged ISIC 22 category, i.e. the individuals who responded `none of these' 
to the industry of employment question but were still assigned to an industry based on their job description (see Appendix, p. 3).
Then add the industry-level pollution measures to the individual-level dataset */

/* France */ 
clear
use "$dropboxpath/Data/Main FR/original survey data/main_fr.dta"
gen country=1 //"France"
drop qualitycontrol_overall_scale 

sort ID
cd "$dropboxpath/Data/Main FR"
merge m:1 ID using france_rearrangedisiccat22.dta
tab _merge
drop _merge

sort isic4_major_02
cd "$dropboxpath/Data/Working Datasets"
merge m:1 isic4_major_02 using isic4major_industrydata_fr_premerge.dta
tab _merge
drop _merge
sort age

saveold "$dropboxpath/Data/Main FR/main_fr_industry.dta", replace

/* Germany */ 
clear
use "$dropboxpath/Data/Main GE/original survey data/main_ge.dta"
gen country=2 //"Germany"
drop qualitycontrol_overall_scale 

sort ID
cd "$dropboxpath/Data/Main GE"
merge m:1 ID using germany_rearrangedisiccat22.dta
tab _merge
drop _merge

sort isic4_major_02
cd "$dropboxpath/Data/Working Datasets"
merge m:1 isic4_major_02 using isic4major_industrydata_ger_premerge.dta
tab _merge
drop _merge
sort age

saveold "$dropboxpath/Data/Main GE/main_ger_industry.dta", replace

/* UK */ 
clear
use "$dropboxpath/Data/Main Uk/original survey data/main_uk.dta"
gen country=3 //"UK"

sort ID
cd "$dropboxpath/Data/Main Uk"
merge m:1 ID using uk_rearrangedisiccat22.dta
tab _merge
drop _merge

sort isic4_major_02
cd "$dropboxpath/Data/Working Datasets"
merge m:1 isic4_major_02 using isic4major_industrydata_uk_premerge.dta
tab _merge
drop _merge
sort age

saveold "$dropboxpath/Data/Main Uk/main_uk_industry.dta", replace

/* US */ 
clear
use "$dropboxpath/Data/Main US/original survey data/main_us.dta"
gen country=4 //"US"

sort ID
cd "$dropboxpath/Data/Main US"
merge m:1 ID using us_rearrangedisiccat22.dta
tab _merge
drop _merge

sort isic4_major_02
cd "$dropboxpath/Data/Working Datasets"
merge m:1 isic4_major_02 using isic4major_industrydata_us_premerge.dta
tab _merge
drop _merge
sort age

saveold "$dropboxpath/Data/Main US/main_us_industry.dta", replace

/* Pooled */ 

* Load French data
use "$dropboxpath/Data/Main FR/main_fr_industry.dta"

* Load German data
append using "$dropboxpath/Data/Main GE/main_ger_industry.dta"

* Load UK data
append using "$dropboxpath/Data/Main UK/main_uk_industry.dta"

* Load US data
append using "$dropboxpath/Data/Main US/main_us_industry.dta"

label define country 1 "France" 2 "Germany" 3 "United Kingdom" 4 "United States"
label values country country

label variable altru_howmuch "Donation (£, Û, $)"

label var altru_donate "Donates:"
*label define donate 0 "No" 1 "Yes"
label values altru_donate donate

tab altru_donate country, col
xtset ID
sort country age

* Length indicator
su length, det
gen length_high=0
replace length_high=1 if length>=r(p50)

/* UK isic4_major in original data is missing if the question was not asked. Check with replaced the missings with 99 (UK is only country with missings on this variable)*/
replace  isic4_major=99 if  isic4_major==.

/* Label industrial categorical variables split at the median */
label var co2dichot "CO2 intensity (M tons per total CO2 output)"
label var co2eqdichot "CO2 eq intensity (M tons per total GHG output, IPCC)"
label var co2eqwbdichot "CO2 eq intensity (M tons per total GHG output, WB)"
label var enerintdichot "Oil eq intensity (M tons per total net energy flow)"

label var co2propdichot "CO2 intensity, proportions of total CO2 output"
label var co2eqpropwbdichot "CO2 eq intensity, proportions of total GHG output, IPCC"
label var co2eqpropdichot "CO2 eq intensity, proportions of total GHG output, WB"
label var propenerintdichot "Oil eq intensity, proportions of total net energy flow"

label var co2employeddichot "CO2 intensity (M tons per total CO2 output) weighted by employees"
label var co2eqemployeddichot "CO2 eq intensity (M tons per total GHG output, IPCC) weighted by employees"
label var co2eqemployedwbdichot "CO2 eq intensity (M tons per total GHG output, WB) weighted by employees"
label var enerintemployeddichot "Oil eq energy intensity (M tons per total net energy flow) weighted by employees"

label var co2vadichot "CO2 intensity (M tons per total CO2 output) weighted by value added"
label var co2eqvadichot "CO2 eq intensity (M tons per total GHG output, IPCC) weighted by value added"
label var co2eqvawbdichot "CO2 eq intensity (M tons per total GHG output, WB) weighted by value added"
label var enerintvadichot "Oil eq energy intensity (M tons per total net energy flow) weighted by value added"

/* Recode industrial categorical variables with consumers*/

* Create category (3) for "consumers" (i.e. for respondents that were not asked the industry of employment question)
foreach x of varlist co2* enerint* propco2* propenerint* {
        replace `x'= 3  if isic4_major_02==99
      }
      
* 3 German respondents were coded as "paid work" (employment==1) but isic_major is 99. We code their pollution costs as missing. 
foreach x of varlist co2* enerint* propco2* propenerint* {
        replace `x'= .  if  employment==1 &  isic4_major_02==99
      }   
 

* Recode CO2 intensity variables
recode co2dichot (1=0) (2=1) (3=2), gen(industryco2)
lab define industryco2 0 low 1 high 2 consumers
lab values industryco2 industryco2
tab industryco2

* Recode CO2 eq intensity variables (IPCC indicator)
recode co2eqdichot (1=0) (2=1) (3=2), gen(industryco2eq)
lab define industryco2eq 0 low 1 high 2 consumers
lab values industryco2eq industryco2eq
tab industryco2eq

* Recode CO2 eq intensity variables (World Bank indicator)
recode co2eqwbdichot (1=0) (2=1) (3=2), gen(industryco2eq_wb)
lab define industryco2eq_wb 0 low 1 high 2 consumers
lab values industryco2eq_wb industryco2eq_wb
tab industryco2eq_wb

* Recode Net energy intensity variables 
recode enerintdichot (1=0) (2=1) (3=2), gen(industryoileq)
lab define industryoileq 0 low 1 high 2 consumers
lab values industryoileq industryoileq
tab industryoileq

* Recode CO2 intensity variables weighted by employees
recode co2employeddichot (1=0) (2=1) (3=2), gen(industryco2_emp)
lab define industryco2_emp 0 low 1 high 2 consumers
lab values industryco2_emp industryco2_emp
tab industryco2_emp

* Recode CO2 eq intensity variables (IPCC indicator) weighted by employees 
recode co2eqemployeddichot (1=0) (2=1) (3=2), gen(industryco2eq_emp)
lab define industryco2eq_emp 0 low 1 high 2 consumers
lab values industryco2eq_emp industryco2eq_emp
tab industryco2eq_emp

* Recode CO2 eq intensity variables (World Bank indicator) weighted by employees 
recode co2eqemployedwbdichot (1=0) (2=1) (3=2), gen(industryco2eqwb_emp)
lab define industryco2eqwb_emp 0 low 1 high 2 consumers
lab values industryco2eqwb_emp industryco2eqwb_emp
tab industryco2eqwb_emp

* Recode Net energy intensity flow variables weighted by employees
recode enerintemployeddichot (1=0) (2=1) (3=2), gen(industryoileq_emp)
lab define industryoileq_emp 0 low 1 high 2 consumers
lab values industryoileq_emp industryoileq_emp
tab industryoileq_emp

* Recode employment variable
recode employment (2=0) (5=0) (7=0) (.=0) (10=0) (11=0) (1=1) (3=2) (4=2) (6=3), gen(emp_status)
tab employment
label define emp_status 0 Other 1 "Paid work" 2 Unemployed 3 Retired   
label values emp_status emp_status
tab emp_status

* Binary recode of willingness to pay for environment measure
gen pay_env_high_group=.
su pay_env, det
replace pay_env_high_group=0 if pay_env<r(p50)
replace pay_env_high_group=1 if pay_env>=r(p50)
tab pay_env_high_group
label values pay_env_high_group hilo

/* employment
 1 Paid work
           2 In education
           3 Unemployed (looking)
           4 Unemployed
           5 Sick/disabled
           6 Retired
           7 Community service
          10 Other
          11 Military service
*/

* Only code employed
foreach var of varlist industryco2 industryco2eq industryco2eq_wb industryoileq industryco2_emp industryco2eq_emp industryco2eqwb_emp industryoileq_emp {
gen `var'_onlyemp=`var'
replace `var'_onlyemp=. if emp_status!=1
tab `var'_onlyemp
}
*drop industryco2 industryco2eq industryco2eq_wb industryoileq industryco2_emp industryco2eq_emp industryco2eqwb_emp industryoileq_emp 

***  Compute alternative weights for employed sample only
* a) Generate new variable with all missing
gen eweight=.
label var eweight "Adjusted weights for employed sample only"

* Compute the sum of the weights for the employed sample (with CO2 information)
su weight if emp_status==1, det 

/* Generate social norms/behavioral variables*/
label var recip_s_method "Reciprocity"

*list industryco2 emp_status isic4_major_02 isic4_major if industryco2==2 & emp_status==1

* saveold pooled data
sort ID
saveold "$dropboxpath/Data/Main Pooled/main_pooled_industry.dta", replace

***************************************************
* F. Generate final pooled agreement-level dataset
***************************************************

/* Merge the final pooled individual-level data to the pooled agreement-level data */
clear
use "$dropboxpath/Data/Working Datasets/main_pooled_agreementlevel_industry.dta"
sort ID

merge ID using "$dropboxpath/Data/Main Pooled/main_pooled_industry.dta"
tab _merge
saveold "$dropboxpath/Data/Main Pooled/main_pooled_agreementlevel_industry.dta", replace

clear
exit
