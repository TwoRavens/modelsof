* Date: April 18, 2019
* Purpose: Data cleaning

cls
clear all
set more off
capture log close

cd "D:\Dropbox\data"

********************************************************************************
* NDC characteristics     
********************************************************************************

use WAC_Unit_1994_2014.dta, clear

rename *, lower

gen branded = (innovatorindicator=="Innovator-Held Original Patent" & genericnameindicator=="Brand named")		

drop date_*

* FDA application type & approval date

foreach var in fdaandadate fdabladate fdandadate fdaandadatefdbmaintained fdandadatefdbmaintained {
gen `var'_num = regexs(1)  if regexm(`var', "^([0-9]+)[\/]*[0-9]*[ ]*[\-]*[ ]*")
gen `var'_date = regexs(0) if regexm(`var', "[0-9][0-9][\/][0-9][0-9][\/][0-9][0-9][0-9][0-9]$")
gen `var'_date2=date(`var'_date,"MDY")
format `var'_date2 %td
drop `var'_date
rename `var'_date2 `var'_date
}

* Unit = gram/mg/mcg/unit

gen isea_via = regexm(dosageform,"VIAL")==1    & billingunitformerlydrugformcode=="each" 

gen isea_cap = regexm(dosageform,"CAPSULE")==1 & billingunitformerlydrugformcode=="each" 

gen isea_tab = regexm(dosageform,"TABLET")==1  & billingunitformerlydrugformcode=="each" 

gen combo=regexm(genericname,"/")

gen mg=real(subinstr(regexs(1),",","",.)) if regexm(strength,"^([0-9.,]+) mg") 

replace mg=real(subinstr(regexs(1),",","",.))*75 if regexm(strength,"^([0-9.,]+) mEq") & genericname=="POTASSIUM CHLORIDE" & billingunitformerlydrugformcode=="milliliters"

replace mg=real(subinstr(regexs(1),",","",.))*1000 if regexm(strength,"^([0-9.,]+) gram")

replace mg=real(subinstr(regexs(1),",","",.))/1000 if regexm(strength,"^([0-9.,]+) mcg")

replace mg=real(subinstr(regexs(1),",","",.))*1.5 if regexm(strength,"^([0-9.,]+) mg PE")

gen unit=real(subinstr(regexs(1),",","",.)) if regexm(strength,"^([0-9.,]+) unit") 

replace unit=real(subinstr(regexs(1),",","",.))*10^6 if regexm(strength,"^([0-9.,]+) million unit") 

replace unit=real(subinstr(regexs(1),",","",.))*10^9 if regexm(strength,"^([0-9.,]+) billion unit")

replace unit=. if regexm(strength,"unit/mL") & billingunitformerlydrugformcode=="each"

gen ml_den = real(subinstr(regexs(2),",","",.)) if regexm(strength,"^([0-9.,]+) [a-zA-Z ]+/([0-9., ]*)[MLml]+") & billingunitformerlydrugformcode=="milliliters"

replace ml_den=1 if ml_den==.

replace mg=mg/ml_den if billingunitformerlydrugformcode=="milliliters"

replace unit=unit/ml_den if billingunitformerlydrugformcode=="milliliters"

drop ml_den

order genericname dosageform strength labelername billingunitformerlydrugformcode branded uscclassification brandname 

format %15s genericname dosageform billingunitformerlydrugformcode strength labelername uscclassification brandname 

sort ndc

save ndc_charac.dta, replace

********************************************************************************
* WAC Unit     
********************************************************************************

use WAC_Unit_1994_2014.dta, clear

rename *, lower

* Keep drugs from non-repackagers & Rx drugs

keep if ((innovatorindicator=="Innovator-Held Original Patent" & genericnameindicator=="Brand named") | ///
         (innovatorindicator=="Non-Innovator Drug" & genericnameindicator=="Generically named")) & ///
		repackagedindicator=="N" & rxotcindicator=="RX"

* Reshape data (wide=>long)

keep ndc date_*

reshape long date_ , i(ndc) j(mdate) s

gen mdate2 = monthly(mdate,"MY")
drop mdate
rename mdate2 mdate
format %tm mdate

rename date_ wac_unit

sort ndc mdate

save price_wac_unit_cleaned.dta, replace


********************************************************************************
* ASP Unit
********************************************************************************

use ASP_Unit_2005_2014_v2.dta, clear

rename *, lower

* Keep drugs from non-repackagers & Rx drugs

keep if ((innovatorindicator=="Innovator-Held Original Patent" & genericnameindicator=="Brand named") | ///
         (innovatorindicator=="Non-Innovator Drug" & genericnameindicator=="Generically named")) & ///
		repackagedindicator=="N" & rxotcindicator=="RX"

gen branded = (innovatorindicator=="Innovator-Held Original Patent" & genericnameindicator=="Brand named")		

* Reshape data

keep ndc date_*

reshape long date_ , i(ndc) j(mdate) s

gen mdate2 = monthly(mdate,"MY")
drop mdate
rename mdate2 mdate
format %tm mdate

rename date_ asp_unit

sort ndc mdate

save price_asp_unit_cleaned.dta, replace

********************************************************************************
* Merge data
********************************************************************************

* Pricing

use price_wac_unit_cleaned.dta, clear
merge 1:1 ndc mdate using price_asp_unit_cleaned.dta
drop _merge

* NDC characteristics

sort ndc 
merge m:1 ndc using ndc_charac.dta
drop if _merge==2
drop _merge

* Hospital

gen uscshort = regexs(1) if regexm(uscclassification,"^([0-9]+)[ ][\-]") 
sort uscshort

merge m:1 uscshort using USC_ATC4.dta
drop if _merge==2
drop _merge

foreach i in hosp90 hosp80 hosp70 hosp60 hosp50 retl90 retl80 retl70 retl60 retl50 {
replace `i'=0 if `i'==.
}

* Part B 

sort uscshort

merge m:1 uscshort using partb_usc.dta
drop if _merge==2
drop _merge

replace partb=0 if partb==.

merge m:1 ndc using ndc_hcpcs_crosswalk.dta
drop if _merge==2
drop _merge

replace partb_cms=0 if partb_cms==.

* PPI

sort mdate
merge m:1 mdate using ppi_pharma.dta
drop if _merge==2
drop _merge

* NDC (applno) 

sort ndc
merge m:1 ndc using fdandc_pack.dta
drop if _merge==2
drop _merge

* Priority/biologic/approval date 

destring fdaandadate_num fdabladate_num fdandadate_num fdaandadatefdbmaintained_num fdandadatefdbmaintained_num, replace

egen applno = rowmin(fdaandadate_num fdabladate_num fdandadate_num fdaandadatefdbmaintained_num fdandadatefdbmaintained_num)

replace applno = fdandc_applno if applno==.

sort applno
merge m:1 applno using fda_applno.dta
drop if _merge==2
drop _merge

********************************************************************************
* Data preparation 
********************************************************************************

drop if wac_unit==.

rename billingunitformerlydrugformcode drugformcode

format %15s ndc

sort ndc mdate

* Adjust for price inflation

foreach x in wac_day wac_unit fss_unit asp_unit {
gen `x'96 = `x'/ppi_pharma*180.7 /* base date = Jan 1996*/
gen `x'14 = `x'/ppi_pharma*404.2 /* base date = Dec 2014 */
}

* Define branded drugs

replace branded=0 if anda==1 

replace branded=1 if nda==1

* Define non-part B drugs

foreach p in 50 60 70 80 90 {
gen notpartb_`p' = partb_cms==0 & retl`p'==1
}

* Generate competition variables 

gen yr=year(dofm(mdate))

gen generic=1-branded

sort mdate uscshort
by mdate uscshort: egen mon_bra_usc=total(branded)
by mdate uscshort: egen mon_gen_usc=total(generic)

sort yr uscshort
by yr uscshort: egen yr_bra_usc=total(branded)
by yr uscshort: egen yr_gen_usc=total(generic)

sort mdate genericname dosageform strength
by mdate genericname: egen mon_bra_mol=total(branded)
by mdate genericname: egen mon_gen_mol=total(generic)
by mdate genericname dosageform: egen mon_bra_molform=total(branded)
by mdate genericname dosageform: egen mon_gen_molform=total(generic)
by mdate genericname dosageform strength: egen mon_bra_molformstr=total(branded)
by mdate genericname dosageform strength: egen mon_gen_molformstr=total(generic)

sort yr genericname dosageform strength
by yr genericname: egen yr_bra_mol=total(branded)
by yr genericname: egen yr_gen_mol=total(generic)
by yr genericname dosageform: egen yr_bra_molform=total(branded)
by yr genericname dosageform: egen yr_gen_molform=total(generic)
by yr genericname dosageform strength: egen yr_bra_molformstr=total(branded)
by yr genericname dosageform strength: egen yr_gen_molformstr=total(generic)

foreach a in bra gen {
foreach b in usc mol molform molformstr {
replace yr_`a'_`b' = yr_`a'_`b'/12
}
}

* Keep launch prices

sort ndc mdate 
by ndc: gen ndc1st=_n==1
keep if ndc1st==1 & branded==1
replace partbexception=0 if partbexception==.

* Generate NDC dummies

encode ndc, gen(ndcgroup)

* Generate time dummies

quietly tab mdate, gen(monfe)
quietly tab yr, gen(yrfe)


forval i=1/19 {
gen partbyrfe`i'=partb_cms*yrfe`i'
}


forval i=1/19 {
gen partbexyrfe`i'=partbexception*yrfe`i'
}

* Generate USC dummies

encode uscclassification, gen(uscgroup)
quietly tab uscclassification, gen(uscfe)

forval n=2/5 {
gen usccode`n' = substr(usccode,1,`n')
quietly tab usccode`n', gen(usc`n'fe)
encode usccode`n', gen(usc`n'group)
}

* Generate AHFS dummies

gen ahfscode_num = regexs(0) if regexm(ahfscode,"^[0-9]+[\:][0-9\.]*")
gen ahfscode1 = substr(ahfscode_num,1,2)
gen ahfscode2 = substr(ahfscode_num,1,5)
gen ahfscode3 = substr(ahfscode_num,1,8)
gen ahfscode4 = substr(ahfscode_num,1,11)

forval n=1/4 {
quietly tab ahfscode`n', gen(ahfs`n'fe)
}

* Generate drug form dummies

quietly tab dosageform, gen(dffe)

* Generate molecule dummies 

quietly tab genericname, gen(molfe)

encode genericname, gen(molgroup)

* Generate labeler dummies 

quietly tab labelername, gen(labfe)

* Generate drug unit dummies

gen isml=drugformcode=="milliliters"

gen isea=drugformcode=="each"

* Generate timing dummies

gen mdate_entry=mofd(hcfamarketentrydate2)

format %tm mdate_entry

gen consistent = (et1==t1 & et0==t0)

gen over6mon = abs(mdate-mdate_entry)>6 & abs(mdate-mdate_entry)~=.

* Generate log price

gen lnwac_unit=log(wac_unit)

gen lnwac_day=log(wac_day)

tostring yr, generate(yrs)	

* Count Part B drugs in USC

forval i=2/5 {
bys usccode`i': egen countpartb`i' = total(partb_cms==1) 
}

* Adjust WAC for inflation

gen wac_unit10 = wac_unit/ppi_pharma*331.5 /* base date = Dec 2010 */
gen lnwac_unit10=log(wac_unit10)

* Merge MMS data

sort brandname
merge m:1 brandname using mms_rev.dta
drop _merge
bys uscclassification: egen totrevpartb10 = total(revpartb10)
bys uscclassification: egen totrevhosp10 = total(revhosp10)
gen mms_usc=totrevpartb10/totrevhosp10 

* Save file

save pricing.dta, replace

