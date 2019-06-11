use "JFGreen Replication II.dta", clear

**NOTE: FIRST 23 LINES SHOW HOW DATA ASSEMBLED**
***Independent Variables***
*add indpendent variables not included in Andonova et. al. data: NOTE, I do not include these in the replication data,
**though I describe how they are compiled below and in the text**

 merge m:1 Country_name using "/Users/jg3804/Dropbox/Domestic politics of CC/TCG Data/Govt Effectiveness.dta"
 drop _merge
 drop if Country_code==""
 
 merge m:1 Country_name using "/Users/jg3804/Dropbox/Domestic politics of CC/TCG Data/Fossil Fuel Exports.dta"
 **this adds fossil fuel exports, as a percentage of total exports, avg from 1990-2014.  From World Bank
 **drop World Bank regional stats as well as outdated Kountry codes.
 drop in 193/271
 drop _merge
 
 merge m:1 Country_name using "/Users/jg3804/Dropbox/Domestic politics of CC/TCG Data/CO2percap2011-15.dta"
 **this adds average per capita CO2 emissions from 1990-2012, the most recent year for which data available.  From the World Bank.
  **drop World Bank regional stats as well as outdated country codes.
 drop in 193/242
 drop _merge
 
 save, replace

 
**BEGIN REPLICATION HERE**
 
**transform NGO and ISO14000 variables to log**
gen log_iso14001=log(iso14001)
gen log_ngo_number = log(ngo_number)

***Dependent Variables***
*privStd=1 if recognizes private standard; 0 else
capture drop privStd
gen privStd=0 if Country_code!=""
replace privStd=1 if Country_name=="Australia" | ///
	Country_name=="Canada" | Country_name=="Costa Rica"	| Country_name=="Italy" | ///
	Country_name=="Japan" | Country_name=="Mexico" | Country_name=="Netherlands" | ///
	Country_name=="Korea, Rep." | Country_name=="Switzerland" | Country_name=="Thailand" | ///
	Country_name=="United Kingdom" | Country_name=="United States"

tab Country_name if privStd==1


****Sample Restriction Vars***
*hasOffsetProgram=1 if country has offset program
capture drop inEU
gen inEU=0 if Country_name!=""
replace inEU=1 if Country_name=="Austria" | Country_name=="Belgium" | Country_name=="Bulgaria" ///
	| Country_name=="Croatia" | Country_name=="Cyprus" | Country_name=="Czech Republic" | ///
	Country_name=="Denmark" | Country_name=="Estonia" | Country_name=="Finland" | ///
	Country_name=="France" | Country_name=="Germany" | Country_name=="Greece" | ///
	Country_name=="Hungary" | Country_name=="Ireland" | Country_name=="Italy" | ///
	Country_name=="Latvia" | Country_name=="Lithuania" | Country_name=="Luxembourg" | ///
	Country_name=="Malta" | Country_name=="Netherlands" | Country_name=="Poland" | ///
	Country_name=="Portugal" | Country_name=="Romania" | Country_name=="Slovak Republic" | ///
	Country_name=="Slovenia" | Country_name=="Spain" | Country_name=="Sweden" | ///
	Country_name=="United Kingdom"
tab Country_name if inEU==1

capture drop hasOffsetProgram
gen hasOffsetProgram=1 if inEU==1 | ///
	Country_name=="Switzerland" | Country_name=="United States" | ///
	Country_name=="Canada" | Country_name=="New Zealand" | ///
	Country_name=="China" | Country_name=="Japan" | ///
	Country_name=="Norway" | Country_name=="United Kingdom" | ///
	Country_name=="Korea, Rep." | Country_name=="Thailand" | ///
	Country_name=="Australia" | Country_name=="Costa Rica" | ///
	Country_name=="Mexico" | Country_name=="Brazil"

sum privStd if privStd==1
sum privStd if privStd==1 & hasOffsetProgram==1

save, replace

**REPLICATION of following tables can now be done with the code below**

**TABLE 1**
**network data; no relevant code**

**TABLE 2**
**text table; no relevant code**

**TABLE 3**
list Country_name if hasOffsetProgram==1
list Country_name if privStd==1

**TABLE 4**
**qualitative data; no code relevant**


**TABLE 5** to be placed in online appendix
sum govt_effect gdp_pc 
sum CO2_percap fossilfuel_pctexports
sum ngo_number iso14001

**TABLE 6**

**Model 1**
logit privStd gdp_pc govt_effective inEU if hasOffsetProgram==1

**Model 2**
logit privStd CO2_percap fossilfuel_pctexports inEU if hasOffsetProgram==1

**Model 3**
logit privStd log_ngo_number log_iso14001 inEU if hasOffsetProgram==1

**Model 4**
logit privStd gdp_pc govt_effective inEU CO2_percap fossilfuel_pctexports log_ngo_number log_iso14001 if hasOffsetProgram==1

**Model 4 without logged NGO and ISO (not reported in table, but used in text. See footnotes 16-18**
logit privStd gdp_pc govt_effective inEU CO2_percap fossilfuel_pctexports ngo_number iso14001 if hasOffsetProgram==1
listcoef, percent


**check VIFs for multicollinearity among independent variables, (Tables 7 & 8, online appendix)
collin  gdp_pc govt_effective inEU CO2_percap fossilfuel_pctexports log_ngo_number log_iso14001 if hasOffsetProgram==1
collin  govt_effective inEU CO2_percap fossilfuel_pctexports log_ngo_number log_iso14001 if hasOffsetProgram==1

**Model 5: multivariate logit with potentially collinear IVs omitted**
logit privStd govt_effective CO2_percap fossilfuel_pctexports log_ngo_number log_iso14001 inEU if hasOffsetProgram==1

**Robustness check: logits with each independent variable controlling for EU membership**

logit privStd gdp_pc inEU if hasOffsetProgram==1
logit privStd govt_effective inEU if hasOffsetProgram==1
logit privStd CO2_percap inEU if hasOffsetProgram==1
logit privStd fossilfuel_pctexports inEU if hasOffsetProgram==1
logit privStd log_ngo_number inEU if hasOffsetProgram==1
logit privStd log_iso14001 inEU if hasOffsetProgram==1

**t-test in Qualitative Section on environmental ngos
ttest ngo_number if hasOffsetProgram==1, by(privStd)


save, replace


