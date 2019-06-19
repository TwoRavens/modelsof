capture log close
local msamacro="pho dc vegas sanfran sandiego la chi denver seattle"
set more off
foreach j in `msamacro' {


*organize dataquick sales data
gzuse ./`j'/`j'sale,clear
egen idlm=group(sr_unique_id)
drop if sr_full_part_code=="P" | sr_arms_length_flag!="1" | sr_val_transfer<=1000 
by property_id,sort: gen temp=_N
drop if temp>=10
drop temp
drop if sr_buyer==sr_seller
save hist_`j'_2.dta,replace

*organize dataquick assessor data
gzuse ./`j'/`j'assr,clear
**this is a code that identifies single family residences
keep if use_code_std=="RSFR"

rename sa_site_unit_val unitnumber
tostring sa_site_zip,replace
gen var1=sa_site_house_nbr+sa_site_street_name+sa_site_zip+unitnumber
replace var1=subinstr(var1," ","",.)
replace var1=lower(var1)
gen var2=sa_site_house_nbr+sa_site_street_name+sa_site_zip
replace var2=subinstr(var2," ","",.)
replace var2=lower(var2)
replace var2="ZZZZ" if var2==var1

replace sa_yr_blt=-55 if sa_yr_blt==0
replace sa_yr_blt=-55 if sa_yr_blt==.
replace sa_sqft=-55 if sa_sqft==0
replace sa_sqft=-55 if sa_sqft==.
tostring sa_yr_blt sa_sqft,replace
gen var3=sa_site_house_nbr+sa_sqft+sa_yr_blt+sa_site_zip
replace var3=subinstr(var3," ","",.)
replace var3=lower(var3)
sort property_id 
save assr_`j'_2.dta,replace


gzuse ./`j'/`j'sale,clear
egen idl=group(sr_unique_id)
*get date in DQ data
gen datel=string(sr_date_transfer,"%11.0g")
gen yearl=substr(datel,1,4)
gen monthl=substr(datel,5,2)
gen dayl=substr(datel,7,2)

destring yearl,replace
destring monthl,replace
destring dayl,replace
gen numdatel=mdy(monthl,dayl,yearl)

gen majorchng=(sr_tran_type!="R")
drop if sr_full_part_code=="P" | sr_arms_length_flag!="1" | sr_val_transfer<=1000 
by property_id,sort: gen temp=_N
drop if temp>=10
drop temp
drop if sr_buyer==sr_seller

count
sort property_id
joinby property_id using assr_`j'_2.dta, unmatched(master) update replace
keep if use_code_std=="RSFR"


gen idt=_n

rename sr_val_transfer price
rename distress_indicator foreid

drop _merge

gen s1=sr_seller
gen b1=sr_buyer


*merge each sale to its most recent sale
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
replace datediff=9999999 if idl==idlm
replace datediff=9999999 if datediff<=90


gsort idl datediff -sr_val_transfer
by idl: gen match=1 if idt!=. & _n==1  & datediff!=9999999
by idl: egen smatch=sum(match)
by idl: gen smatch2=_n
gen k1=1 if smatch2==1 & smatch==0
keep if match==1 | k1==1
gen  mergetype=(match==1)

tab mergetype

replace sr_val_transfer=. if mergetype==0
replace numdatet=. if mergetype==0
replace sr_unique_id=. if mergetype==0
rename numdatet lastsaledate
rename sr_val_transfer lastsalepr
rename distress_indicator lastforeid

**************************************************************************************
count
drop _merge


rm assr_`j'_2.dta
rm hist_`j'_2.dta


*for phoenix and seattle, the first case shiller index value starts 13 and 25 months after the case shiller index for other cities
gen trash="`j'"
gen thresh=1
replace thresh=13 if trash=="pho"
replace thresh=25 if trash=="seattle"
 

gen my0=(year(lastsaledate)-1988)*12+month(lastsaledate)


sort idl numdatel
by idl: gen index=_n

*month number of current list price
gen my=(year(numdatel)-1988)*12+month(numdatel)
gen weeknum=numdatel-dow(numdatel)

**drop outliers 
gen interval=my-my0
drop if interval<6 
gen temp=abs(ln(price)-ln(lastsalepr))/interval
drop if temp>.05
drop if price<20000
drop if lastsalepr<20000
drop if price>4000000
drop if lastsalepr>4000000
drop if my0<thresh
drop temp
gen temp=abs(ln(price)-ln(lastsalepr))/interval

sort numdatel
*make interval weights and robust weights according to CS methodology
pctile pct=temp ,nq(100)
gen rw=1
replace rw=.25 if temp>pct[95]
replace rw=.75 if temp>pct[90] & temp<=pct[95]
*this is taken from CS methodology on interval weights 
gen rw2=-.02105*interval/12+1.0105


gen weights=1

gen id=_n

replace price=price/10000
replace lastsalepr=lastsalepr/10000
count
gen numdatet=numdatel
drop numdatel

**see which sales merge to a delisting
joinby property_id using temp11e_`j'_r2, unmatched(master) 

 
drop datet yeart montht dayt datediff_c good* temp k1 match smatch*

gen datediff_c=numdatet-numdatel
gen good1=(datediff_c>=0 & datediff_c<365& datediff_c!=.)
gen good=(datediff_c>=-30 & datediff_c<365& datediff_c!=.)

*for transactions that match more than once, keep one with closest match
gsort idl -good -good1 backinsix datediff_c
by idl,sort: gen temp=_n
replace datediff_c=. if temp>1 & idl!=.
replace idl=. if temp>1 & idl!=.


gsort idt -good -good1 backinsix datediff_c
by idt: gen match=1 if idl!=. & _n==1 & good==1 
by idt: egen smatch=sum(match)
by idt: gen smatch2=_n
gen k1=1 if smatch2==1 & smatch==0
keep if match==1 | k1==1 
replace match=0 if match==.

**************************************************************************************************************
*merge on case shiller index associated with month of previous sale
drop _merge
sort my0
merge my0 using delta0.dta,nokeep

gen lnpricehat=ln(lastsalepr)-delta0

gen quarter=1 if month(numdatet)<=3
replace quarter=2 if month(numdatet)>3 & month(numdatet)<=6 
replace quarter=3 if month(numdatet)>6 & month(numdatet)<=9 
replace quarter=4 if month(numdatet)>9 & month(numdatet)<=12 
gen qy=year(numdatet)*10+quarter
save temp123,replace
collapse (mean) match ,by(qy)
gen cityid="`j'"
save tempmatch`j',replace
use temp123,clear


gen adjprice=price
gen rw3=1
gen seas=1
gen houseid=1
keep  dayl my my0 lastsalepr price adjprice rw rw2 rw3 id seas houseid weeknum delta0 weights*
order  dayl my my0 lastsalepr price adjprice rw rw2 rw3 id seas houseid weeknum delta0 weights*
outsheet using `j'_salepr_close.txt,nonames replace
*now only sales that link to a mls record
use temp123,clear
rm temp123.dta
gen adjprice=price
gen rw3=1
gen seas=1
gen houseid=1
keep if match==1 
keep  dayl my my0 lastsalepr price adjprice rw rw2 rw3 id seas houseid weeknum delta0 weights*
order  dayl my my0 lastsalepr price adjprice rw rw2 rw3 id seas houseid weeknum delta0 weights*
outsheet using `j'_salepr_close_mls.txt,nonames replace


log close
}
