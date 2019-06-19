capture log close
local msamacro="pho dc vegas sanfran sandiego la chi denver seattle"
set more off
foreach j in `msamacro' {


*organize dataquick sales data
gzuse ./`j'/`j'sale.dta.gz,clear
egen uidt=group(sr_unique_id)
gen bad=(sr_arms_length_flag!="1")
drop if sr_full_part_code=="P" 
drop if bad==0 & sr_val_transfer<=1000
gen idt=_n
drop sr_scm_id mm_state_code mm_muni_name mm_fips_state_code mm_fips_muni_code mm_fips_county_name sr_parcel_nbr_raw sr_site_addr_raw sr_mail_addr_raw sr_mail_house_nbr sr_mail_fraction sr_mail_dir sr_mail_street_name sr_mail_suf sr_mail_post_dir sr_mail_unit_pre sr_mail_unit_val sr_mail_city sr_mail_state sr_mail_zip sr_mail_plus_4 sr_mail_crrt sr_lgl_dscrptn sr_lgl_keyed_block sr_lgl_keyed_lot sr_lgl_keyed_plat_book sr_lgl_keyed_plat_page sr_lgl_keyed_range sr_lgl_keyed_section sr_lgl_keyed_sub_name sr_lgl_keyed_township sr_lgl_keyed_tract sr_lgl_keyed_unit filler
replace sr_loan_val_1=0 if sr_loan_val_1==.
replace sr_loan_val_2=0 if sr_loan_val_2==.
replace sr_loan_val_3=0 if sr_loan_val_3==.
gen loanamt=sr_loan_val_1+sr_loan_val_2+sr_loan_val_3
drop sr_loan*
save hist_`j'_2.dta,replace

*organize dataquick assessor data
gzuse ./`j'/`j'assr.dta.gz,clear
**single family residences
keep if use_code_std=="RSFR"
gen sa_site_street_name_fullt=sa_site_street_name
replace sa_site_street_name=substr(sa_site_street_name,1,4)

*identify potential combinations of address to use to merge with the listings data
rename sa_site_unit_val unitnumber
tostring sa_site_zip,replace
gen sa_site_zip_fullt=sa_site_zip
replace sa_site_zip=substr(sa_site_zip,1,4)
gen var1=sa_site_house_nbr+sa_site_street_name+unitnumber+sa_site_zip
replace var1=subinstr(var1," ","",.)
replace var1=lower(var1)

gen var4=sa_site_house_nbr+sa_site_street_name+sa_site_suf+unitnumber+sa_site_zip
replace var4=subinstr(var4," ","",.)
replace var4=lower(var4)
replace var4="QQQQ" if var4==var1

gen var5=sa_site_house_nbr+sa_site_street_name+sa_site_suf+sa_site_post_dir+unitnumber+sa_site_zip
replace var5=subinstr(var5," ","",.)
replace var5=lower(var5)
replace var5="TTTT" if var5==var4

replace sa_yr_blt=-55 if sa_yr_blt==0
replace sa_yr_blt=-55 if sa_yr_blt==.
replace sa_sqft=-55 if sa_sqft==0
replace sa_sqft=-55 if sa_sqft==.
tostring sa_yr_blt sa_sqft,replace
gen var3=sa_site_house_nbr+sa_sqft+sa_yr_blt+sa_site_zip
replace var3=subinstr(var3," ","",.)
replace var3=lower(var3)


keep var* property_id sa_sqft sa_yr_blt sa_site_street_name_fullt sa_site_zip_fullt
sort property_id 
save assr_`j'_2.dta,replace

******************************************************
**merge each delisting to the dataquick assessor data
******************************************************
use temp11a_`j'_update_r2.dta,clear
drop var1
sort lowaddress numdatel
gen final=1 if lowaddress!=lowaddress[_n+1]

egen idl=group(lowaddress2)

sort lowaddress2 numdatel
gen sa_site_street_name_full=sa_site_street_name
replace sa_site_street_name=substr(sa_site_street_name,1,4)
gen sa_site_zip_full=sa_site_zip
replace sa_site_zip=substr(sa_site_zip,1,4)
gen var1=sa_site_house_nbr+sa_site_street_name+unitnumber+sa_site_zip
replace var1=subinstr(var1," ","",.)
replace var1=lower(var1)

count
joinby var1 using assr_`j'_2.dta, unmatched(master) update replace
gen streetsame=1-(sa_site_street_name_fullt==sa_site_street_name_full)
gen zipsame=1-(sa_site_zip_fullt==sa_site_zip_full)

gsort idl streetsame zipsame property_id 
by idl: gen match=1 if property_id!=. & _n==1 
by idl: egen smatch=sum(match)
by idl: gen smatch2=_n
gen k1=1 if smatch2==1 & smatch==0
keep if match==1 | k1==1
gen  mergetype_r=(match==1)
drop smatch* _merge var* k1 streetsame zipsame

gen var4=sa_site_house_nbr+sa_site_street_name+unitnumber+sa_site_zip
replace var4="XXXXXX" if mergetype_r>0
replace var4=subinstr(var4," ","",.)
replace var4=lower(var4)
count
joinby var4 using assr_`j'_2.dta, unmatched(master) update replace
gen streetsame=1-(sa_site_street_name_fullt==sa_site_street_name_full)
gen zipsame=1-(sa_site_zip_fullt==sa_site_zip_full)

gsort idl streetsame zipsame property_id 
by idl: replace match=1 if property_id!=. & _n==1 
by idl: egen smatch=sum(match)
by idl: gen smatch2=_n
gen k1=1 if smatch2==1 & smatch==0
keep if match==1 | k1==1
replace  mergetype_r=4 if match==1 & mergetype_r==0
drop smatch* _merge var1 k1 var* streetsame zipsame

gen var5=sa_site_house_nbr+sa_site_street_name+unitnumber+sa_site_zip
replace var5="XXXXXX" if mergetype_r>0
replace var5=subinstr(var5," ","",.)
replace var5=lower(var5)
count
joinby var5 using assr_`j'_2.dta, unmatched(master) update replace
gen streetsame=1-(sa_site_street_name_fullt==sa_site_street_name_full)
gen zipsame=1-(sa_site_zip_fullt==sa_site_zip_full)

gsort idl streetsame zipsame property_id 
by idl: replace match=1 if property_id!=. & _n==1 
by idl: egen smatch=sum(match)
by idl: gen smatch2=_n
gen k1=1 if smatch2==1 & smatch==0
keep if match==1 | k1==1
replace  mergetype_r=5 if match==1 & mergetype_r==0
drop smatch* _merge var1 k1 var* streetsame zipsame

tostring residence_sqft year_built,replace
gen var3=sa_site_house_nbr+residence_sqft+year_built+sa_site_zip
replace var3="YYYYY" if mergetype_r>0
replace var3=subinstr(var3," ","",.)
replace var3=lower(var3)
count
joinby var3 using assr_`j'_2.dta, unmatched(master) update replace
gen streetsame=1-(sa_site_street_name_fullt==sa_site_street_name_full)
gen zipsame=1-(sa_site_zip_fullt==sa_site_zip_full)

gsort idl streetsame zipsame property_id 
by idl: replace match=1 if property_id!=. & _n==1 
by idl: egen smatch=sum(match)
by idl: gen smatch2=_n
gen k1=1 if smatch2==1 & smatch==0
keep if match==1 | k1==1
replace  mergetype_r=3 if match==1 & mergetype_r==0
drop smatch* _merge var* k1 streetsame zipsame match

sort lowaddress -mergetype_r
replace property_id=property_id[_n-1] if mergetype_r==0 & mergetype_r[_n-1]>0
tab mergetype_r


*******************************************************************
*merge each delisting to the sales data to get the previous sale
********************************************************************


joinby property_id using hist_`j'_2, unmatched(master) update replace
 

*get date in DQ data
gen datet=string(sr_date_transfer,"%11.0g")
gen yeart=substr(datet,1,4)
gen montht=substr(datet,5,2)
gen dayt=substr(datet,7,2)
destring yeart,replace
destring montht,replace
destring dayt,replace
gen numdatet=mdy(montht,dayt,yeart)


gen datediff=numdatel-numdatet
replace datediff=9999999 if  bad==1
replace datediff=9999999 if  datediff<=90

gsort idl datediff -sr_val_transfer
by idl: gen match=1 if idt!=. & _n==1 & datediff!=9999999 & bad==0
by idl: egen smatch=sum(match)
by idl: gen smatch2=_n
gen k1=1 if smatch2==1 & smatch==0
keep if match==1 | k1==1
gen  mergetype=(match==1)
gen majorchng=(sr_tran_type!="R" & mergetype==1)

tab mergetype

replace sr_val_transfer=. if mergetype==0
replace numdatet=. if mergetype==0
replace sr_unique_id=. if mergetype==0
rename numdatet lastsaledate
rename sr_val_transfer lastsalepr
rename distress_indicator lastforeid
drop sr_unique_id loanamt

**************************************************************************************
count
*lowaddress uniquely identifies observations
drop _merge
sort lowaddress2



drop temp*

*this variable is no longer used
gen weirddate=1

*******************************
*merge each delisting to the sales data to see if it sells
*******************************
drop match smatch smatch2 k1 datet yeart montht dayt idt bad sr_date_transfer
joinby property_id using hist_`j'_2, unmatched(master) update replace


*get date in DQ data
gen datet=string(sr_date_transfer,"%11.0g")
gen yeart=substr(datet,1,4)
gen montht=substr(datet,5,2)
gen dayt=substr(datet,7,2)
destring yeart,replace
destring montht,replace
destring dayt,replace
gen numdatet=mdy(montht,dayt,yeart)


gen datediff_c=numdatet-numdatel
replace datediff_c=9999999 if  bad==1
gen good1=(datediff_c>=0 & datediff_c<365& datediff_c!=.)
gen good=(datediff_c>=-30 & datediff_c<365& datediff_c!=.)

*for transactions that match more than once, keep one with closest match
gen backinsix=(length_new<=12)
gsort idt -good -good1 weirddate backinsix datediff_c
by idt: gen temp=_n
replace datediff_c=. if temp>1 & idt!=.
replace datediff_c=. if bad==1 & idt!=.
replace idt=. if temp>1 & idt!=.
replace idt=. if bad==1 & idt!=.

*stata sorts missings at the end no matter what
gsort idl -good -good1 weirddate backinsix datediff_c
by idl: gen match=1 if idt!=. & _n==1 & good==1 & bad==0 
by idl: egen smatch=sum(match)
by idl: gen smatch2=_n
gen k1=1 if smatch2==1 & smatch==0
keep if match==1 | k1==1 
gen  mergetype_c=(match==1)
sort lowaddress2
drop _merge temp
rename sr_val_transfer salepr
rename sr_unique_id uid
rename distress_indicator foreid
rename loanamt loanamt_sale

**try to identify potential foreclosures, information about foreclosures is no longer used

drop match smatch smatch2 k1 datet yeart montht dayt idt bad sr_date_transfer
joinby property_id using hist_`j'_2, unmatched(master) update replace


*get date in DQ data
gen datet=string(sr_date_transfer,"%11.0g")
gen yeart=substr(datet,1,4)
gen montht=substr(datet,5,2)
gen dayt=substr(datet,7,2)
destring yeart,replace
destring montht,replace
destring dayt,replace
gen numdatef=mdy(montht,dayt,yeart)


gen datediff_f=numdatel-numdatef
replace datediff_f=999999 if datediff_f<=90

sort idt datediff_f
by idt,sort: gen temp=_n
replace datediff_f=. if temp>1 & idt!=.
replace idt=. if temp>1 & idt!=.

sort idl datediff_f
by idl: gen match=1 if idt!=. & _n==1 & datediff_f<=730 & datediff_f>90 & bad==1
by idl: egen smatch=sum(match)
by idl: gen smatch2=_n
gen k1=1 if smatch2==1 & smatch==0
keep if match==1 | k1==1 
gen  mergetype_f=(match==1)
sort lowaddress2
drop _merge temp

replace distress_indicator="" if mergetype_f==0


save temp11e_`j'_r2,replace

rm assr_`j'_2.dta
rm hist_`j'_2.dta

capture log close
}
