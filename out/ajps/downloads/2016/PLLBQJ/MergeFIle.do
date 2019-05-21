********Generate Data and variables

***merge OECD aid data 2009 with cow codes 
use OECDto2009/oecd_upto2009v3.dta, clear
keep if donor == 20
keep if series == 20
drop if ccode == .
xtset ccode year
tsfill, full
merge ccode using ccodelist.dta, sort uniqusing update
drop if ccode == .
drop if _m == 2
drop _m
replace value = 0 if value == .
rename value ODAEC

*** Update dataset

merge country year using totecodanet99_09.dta, update sort
drop if ccode == .
drop if _m == 2
drop _m

*** Merge in deflators

merge year using OECDto2009/cv1995 (const dollars) 1960-2012.dta, sort uniqusing
drop if _m == 2
drop _m 
gen value = ODAEC
replace ODAEC = value/cf

****Merge in QOG variables

gen ccodecow = ccode
merge ccodecow year using QoG_t_s_v6Apr11.dta, sort uniqmaster

rename ccodecow cow
drop if _m < 3
drop _m

***Merge in CIRI variables

merge cow year using ciri2.dta, sort uniqusing
rename _m cirimerge


**** Merge in EU Council Heads

gen time = year
merge time using eucpnames.dta, uniqusing sort
rename counpre counpre1
drop if _m == 2
drop _m
replace time = year + .5

****Merge in presidencies

merge time using eucpnames.dta, uniqusing sort
drop if _m == 2
drop _m

rename counpre counpre2
replace counpre1 = "ÊGermany" if counpre1 == "ÊWest Germany"
replace counpre2 = "ÊGermany" if counpre2 == "ÊWest Germany"
replace counpre1 = "Austria" if year == 2006
replace counpre2 = "Finland" if year == 2006
replace counpre1 = "Germany" if year == 2007
replace counpre2 = "Portugal" if year == 2007
replace counpre1 = "Slovenia" if year == 2008
replace counpre2 = "France" if year == 2008
replace counpre1 = "Czech Republic" if year == 2009
replace counpre2 = "Sweden" if year == 2009

***** Generate former colonies

gen ones = 1
by ccode, sort: ipolate ht_colonial ones, generate(htcol2) epolate
replace ht_colonial = htcol2

gen col_uk = 0 
replace col_uk = 1 if ht_colonial == 5
gen col_fr = 0 
replace col_fr = 1 if ht_colonial == 6
gen col_sp = 0 
replace col_sp = 1 if ht_colonial == 2
gen col_por = 0 
replace col_por = 1 if ht_colonial == 7
gen col_italy = 0 
replace col_italy = 1 if ht_colonial == 3
gen col_neth = 0 
replace col_neth = 1 if ht_colonial == 1
gen col_bel = 0 
replace col_bel = 1 if ht_colonial == 8
replace col_uk = .5 if ht_colonial == 9
replace col_fr = .5 if ht_colonial == 9

*****generate former colonizers as president in first half of year and second half

gen CPcol1 = .
replace CPcol1 = col_uk if counpre1 == "ÊUnited Kingdom"
replace CPcol1 = col_fr if counpre1 == "ÊFrance"
replace CPcol1 = col_sp if counpre1 == "ÊSpain"
replace CPcol1 = col_italy if counpre1 == "ÊItaly"
replace CPcol1 = col_neth if counpre1 == "ÊNetherlands"
replace CPcol1 = col_bel if counpre1 == "ÊBelgium"
replace CPcol1 = col_por if counpre1 == "ÊPortugal"
replace CPcol1 = 0 if CPcol1 == .

gen CPcol2 = .
replace CPcol2 = col_uk if counpre2 == "ÊUnited Kingdom"
replace CPcol2 = col_fr if counpre2 == "ÊFrance"
replace CPcol2 = col_sp if counpre2 == "ÊSpain"
replace CPcol2 = col_italy if counpre2 == "ÊItaly"
replace CPcol2 = col_neth if counpre2 == "ÊNetherlands"
replace CPcol2 = col_bel if counpre2 == "ÊBelgium"
replace CPcol2 = col_por if counpre2 == "ÊPortugal"
replace CPcol2 = 0 if CPcol2 == .

****generate a variable for "any" colony

gen anycol = col_uk  + col_fr  + col_sp +  col_italy +  col_neth + col_bel + col_por
replace anycol = col_fr  +  col_italy +  col_bel + col_neth + col_uk if time < 1986
replace anycol = col_fr  +  col_italy +  col_bel + col_neth if time < 1973

drop if year < 1975
duplicates drop ccode year, force
keep country ccode year ODAEC ht_colonial counpre1 counpre2 CPcol1 CPcol2 anycol new_empinx speech assn worker elecsd new_relfre formov dommov

xtset ccode year


*****generate dependent variable and key independent variables

replace ODAEC = 0 if ODAEC < 0 | ODAEC == .
gen lnodaec = log(ODAEC + 1)

gen EV = l1lnodaec
gen l2CPcol1 = l2.CPcol1
gen l2CPcol2 = l2.CPcol2
drop if l2.anycol == 0 | l2.anycol == .

save replication-3-12-12

**********Merge in aiddata

rename  aiddatapurposecode purpose
drop projectid
collapse (sum) commitmentconstant2000usd, by ( purpose recipientname year) 
save aiddata_collapse, replace
rename recipientname wdi_nm
sort wdi_nm
****merge in the country codes
merge wdi_nm using codes
replace cow_id=58   if wdi_nm=="Antigua & Barbuda"
replace cow_id=31   if wdi_nm=="Bahamas"
replace cow_id=346   if wdi_nm=="Bosnia-Herzegovina"
replace cow_id=482   if wdi_nm=="Central African Rep."
replace cow_id=437   if wdi_nm=="Cote D'Ivoire"
replace cow_id=651   if wdi_nm=="Egypt"
replace cow_id=420   if wdi_nm=="Gambia"
replace cow_id=630   if wdi_nm=="Iran"
replace cow_id=732   if wdi_nm=="Korea"
replace cow_id=812   if wdi_nm=="Laos"
replace cow_id=987  if wdi_nm=="Micronesia, Federated States of"
replace cow_id=365   if wdi_nm=="Russia"
replace cow_id=403   if wdi_nm=="Sao Tome & Principe"
replace cow_id=345   if wdi_nm=="Serbia"
replace cow_id=60   if wdi_nm=="St. Kitts & Nevis"
replace cow_id=57   if wdi_nm=="St.Vincent & Grenadines"
replace cow_id=652   if wdi_nm=="Syria"
replace cow_id=52   if wdi_nm=="Trinidad & Tobago"
replace cow_id=101   if wdi_nm=="Venezuela"
replace cow_id=816  if wdi_nm=="Viet Nam"
replace cow_id=679   if wdi_nm=="Yemen"
rename cow_id ccode
drop if ccode==.
drop _merge
sort ccode year
save aiddata_collapse, replace
sort ccode year
merge ccode year using replication-3-12-12
drop _m


***merge in Polity
merge ccode year using polityIV.dta, sort
drop if _m == 2
drop _m
save master2

*********merge in WB data

use wbdata_eu.dta, clear
gen isdemo = 0
replace isdemo = 1 if ht_regtype1 == 100
gen isindata = 0
replace isindata = 1 if ht_regtype1 != .
egen demnumer = sum(isdemo), by(ht_region2 year)
egen demdenom = sum(isindata), by(ht_region2 year)
gen demregion = (demnumer-isdemo)/(demdenom-isindata)
gen DACaid = iDC_DAC_TOTL_CD
gen logpop = log(gle_pop+1)
drop gle_pop
gen loggC = log(iNY_GDP_PCAP_KD+1)
drop iNY_GDP_PCAP_KD 
gen loggdp=log(iNY_GDP_MKTP_KD+1)
keep year ccode al_ethnic al_religion wvs_rel loggdpC iNY_GDP_PETR_RT_ZS iSE_PRM_TENR demregion logpop wdi_fr wdi_fdi wdi_exp wdi_imp wdi_urban loggdp ihme_ayef ihme_ayem DACaid
save wbdataeu.dta, replace

use master2.dta, clear
sort ccode year
gen commit = 0
replace commit = commitment 
collapse (sum) commit (firstnm) CPcol1 CPcol2 ODAEC ODAECg new_empinx polity2 anycol speech assn worker elecsd new_relfre formov dommov democ autoc exrec exconst polcomp pwt_open multilateral democracyaid_other (first) wdi_nm, by(ccode year) fast
sort ccode year
merge ccode year using wbdataeu.dta
drop if _merge == 2
drop _merge
quietly eststo clear
set more off

***generate variables for analysis
replace ODAEC = 0 if ODAEC < 0
gen f1EV = log(ODAEC + 1)

* Exclude observations post-end

replace CPcol1 = . if year > 2006
replace CPcol2 = . if year > 2006

xtset ccode year

gen EV = l1.f1EV
gen l2CPcol1 = l2.CPcol1
gen l2CPcol2 = l2.CPcol2
gen f1EVsqrt = ODAEC^.5
gen EVsqrt = l1.f1EVsqrt
replace ODAECg = 0 if ODAECg < 0
gen f1EVg = log(ODAECg+1)
gen EVg = l1.f1EVg
gen f1EVsqrtg = (ODAECg)^.5
gen EVsqrtg = l1.f1EVsqrtg
gen lncommit = log(commit/1000000 + 1)
gen l1lncommit = l1.lncommit
gen l2lncommit = l2.lncommit
gen lndisbur = f1EV
gen l1lndisbur = EV
gen l2lndisbur = l1.EV
gen multiaid = log(multilateral+1)
gen demoaid = log(democracyaid_other+1)
replace multiaid = 0 if multiaid == .
replace demoaid = 0 if demoaid == .
gen l1multiaid = l1.multiaid
gen l1demoaid = l1.demoaid
replace DACaid = 0 if DACaid == .
gen logDACaid = log(DACaid+1)
gen l1logDACaid = l1.logDACaid

***log imports and exports- these are percent GDP
replace wdi_imp=log(wdi_imp) 
replace wdi_exp=log(wdi_exp)

*** generate covariates
drop al_ethnic al_religion
foreach i of varlist ihme_ayef-loggdp {
gen cov`i' = l2.`i'
gen cov`i'F = 0
replace cov`i'F = 1 if cov`i' == .
replace cov`i' = -99 if cov`i' == .
}

drop if l2.anycol == 0 | l2.anycol == .
gen uniquecol = CPcol1*year + 2*CPcol2*year
by ccode: egen uniquecol2 = mean(uniquecol)
egen uniquecol3 = group(uniquecol2)
drop uniquecol uniquecol2

****Fixed effects
xi: quietly reg EV i.year i.ccode


**********merge in VDem
merge 1:1 ccode year using "v-dem_formerge.dta"
drop if _merge==2
drop _merge


****Note that the variables AA AACA ATDC CA CU DCFTA EEA EMAA EPPCCA FTA SAA were hand coded using data from the EU's website. See codebook.

****Generating additional variables

sort ccode year

foreach i of varlist new_empinx polity2 {
gen `i'avg = (`i' + f1.`i' + f2.`i' + f3.`i')/4
}

gen EVcent=EV-2.154306
gen engage=0
replace engage=1 if EV==1 | AA==1 | ATDC==1 | CA==1 | EMAA==1 | EPPCCA==1
gen engageavg = (engage + f1.engage + f2.engage + f3.engage)/4
gen dep7=aid/(commit2+aid)
gen dep7XEVcent=dep7*EVcent
gen dep7Xl2CPcol2=dep7*l2CPcol2

keep new_empinxavg new_empinx polity2 polity2avg EV  l2CPcol2  _I*  year  ccode ihme_ayem wdi_exp wdi_fdi wdi_imp wvs_rel iNY_GDP_PETR_RT_ZS demregion logpop loggdpC loggdp l1demoaid l1multiaid demoaid multiaid l1logDACaid logDACaid l2CPcol1 pwt_open engage engageavg dommov formov new_relfre elecsd worker assn speech v2x_liberal  v2x_frassoc_thick v2x_freexp_thick v2xcl_rol AA AACA ATDC CA CU DCFTA EEA EMAA EPPCCA FTA SAA EVsqrt EVg f1EV EVsqrtg lncommit lndisbur l2lncommit l1lncommit l1lndisbur l2lndisbur EVcent dep7XEVcent dep7Xl2CPcol2 dep7

save Final_Supplemental2 

keep year ccode new_empinx polity2 EV l2CPcol2 cov* _I* new_empinxavg polity2avg

save Final_Main 


