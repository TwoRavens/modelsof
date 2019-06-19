******************************************************************************************************************************************
*MANUSCRIPT: Authorized Generic Entry prior to Patent Expiry: Reassessing Incentives for Independent Generic Entry 
*AUTHOR:     Silvia Appelt, University of Munich, silvia.appelt@lrz.uni-muenchen.de

******************************************************************************************************************************************
				                    *** MERGE NPI data tables: NPI DB07 (2001-2003/2004-2007) ***
						            		* Date last edit:  11 January 2015 * 
******************************************************************************************************************************************   
*PROGRAMME: STATA (last version used: STATA MP 13.0) 

version 13.0
set more off
cap log close
clear


*NPI DB07 (2001-2003/2004-2007)

*** (I) Renaming of variables for merge
use pzn_db07, clear
rename key_id pzn_id 
tostring pzn_id, gen(pzn_id_string)
rename value pzn
sort pzn_id_string
save pzn_db07_mod, replace

use atc1_db07, clear
drop atc1
rename key_id atc1_id
rename value atc1
sort atc1_id
save atc1_db07_mod, replace

use atc2_db07, clear
drop atc2
rename key_id atc2_id
rename value atc2
sort atc2_id
save atc2_db07_mod, replace

use atc3_db07, clear
drop atc3
rename key_id atc3_id
rename value atc3
sort atc3_id
save atc3_db07_mod, replace

use atc4_db07, clear
drop atc4
rename key_id atc4_id
rename value atc4
sort atc4_id
save atc4_db07_mod, replace

use nfc1_db07, clear
drop nfc1
rename key_id nfc1_id
rename value nfc1
sort nfc1_id
save nfc1_db07_mod, replace

use nfc2_db07, clear
drop nfc2
rename key_id nfc2_id
rename value nfc2
sort nfc2_id
save nfc2_db07_mod, replace

use nfc3_db07, clear
drop nfc3
rename key_id nfc3_id
rename value nfc3
sort nfc3_id
save nfc3_db07_mod, replace

use zklass_db07, clear
rename key_id zklass_id
rename value zusatzklasse
sort zklass_id
save zklass_db07_mod, replace

use hafo_db07, clear
rename key_id pzn_id 
tostring pzn_id, gen(pzn_id_string)
rename value handelsformen 
sort pzn_id_string
save hafo_db07_mod, replace

use hst_db07, clear
rename key_id hst_id 
rename value hersteller
sort hst_id
save hst_db07_mod, replace

use hst_hist_db07, clear
rename key_id hst_hist_id 
rename value hersteller_hist
sort hst_hist_id
save hst_hist_db07_mod, replace

use prd_db07, clear
rename key_id prd_id
rename value produkt
sort prd_id
save prd_db07_mod, replace

use prdo_db07, clear
rename key_id prdo_id
rename value produkt_pi
sort prdo_id
save prdo_db07_mod, replace

use gen_db07, clear
rename key_id gen_id
rename value generika
sort gen_id
save gen_db07_mod, replace

use fbetrag_db07, clear
rename key_id fbetrag_id
rename value festbetrag
sort fbetrag_id
save fbetrag_db07_mod, replace

use sub_db07, clear
rename key_id sub_id
rename value substanzen
sort sub_id
save sub_db07_mod, replace

use str_db07, clear
rename key_id str_id
rename value staerke
sort str_id
save str_db07_mod, replace

use pck_db07, clear
rename key_id pck_id
rename value packungen
sort pck_id
save pck_db07_mod, replace

use nnn_db07, clear
rename key_id nnn_id
rename value n1n2n3
sort nnn_id
save nnn_db07_mod, replace

use abg_db07, clear
rename key_id abg_id
rename value abgabe
sort abg_id
save abg_db07_mod, replace

use zzb_db07, clear
rename key_id zzb_id
rename value zzb
sort zzb_id
save zzb_db07_mod, replace

use konz_db07, clear
rename key_id konz_id
rename value konzern
sort konz_id
save konz_db07_mod, replace

use einf_db07, clear
rename key_id einf_id
rename value prod_launch
sort einf_id
save einf_db07_mod, replace


*Historic values - previous producers (2001-2003 annually; therafter monthly) 
use val_hist_db07, clear  
local x=1
while `x'< 4 {
display "`x'"
count if val_`x'_1== .
count if val_`x'_2== .
count if val_`x'_3== .
count if val_`x'_4== .
count if val_`x'_5== .
count if val_`x'_9== .
count if val_`x'_10== .
count if val_`x'_11== .
count if val_`x'_12== .
count if val_`x'_13== .
local x=`x'+1
}
*Note: no historic values missing 
 
rename key_id pzn_id
local x=1
quietly while `x'< 4 {
local y=2000+`x'
rename val_`x'_1 absatz_gh`y' 
rename val_`x'_2 abverkauf_eh`y'
rename val_`x'_3 naturalrabatt_eh`y'
rename val_`x'_4 retouren_eh`y'
rename val_`x'_5 umsatz_gh`y' 
rename val_`x'_9 abverkauf_ums`y'
rename val_`x'_10 naturalrabatt_ums`y'
rename val_`x'_11 retouren_ums`y'
rename val_`x'_12 direkt_eh`y'
rename val_`x'_13 direkt_ums`y'
local x=`x'+1
}
tostring pzn_id, gen(pzn_id_string)
sort pzn_id_string
save val_hist_db07_mod, replace

*Market shares (retail form level, i.e. pzn) - previous producers (2001-2003)
use val_hst_hist_db07, clear
rename val_hst_hist_6_1_1 val_hst_hist_2001_1 
rename val_hst_hist_6_2_1 val_hst_hist_2002_1 
rename val_hst_hist_6_3_1 val_hst_hist_2003_1 

sum pzn_id
*161066 observations
*pzn_id & hst_hist_id unique identifier (161066 observations)
tostring pzn_id, gen(pzn_id_string)
tostring hst_hist_id, gen(hst_hist_id_string)

sort pzn_id_string hst_hist_id_string
save val_hst_hist_db07_mod, replace




*** (II) MERGE data (DB 07), incl. data on historic producers (hst_hist_db07, and val_hst_hist_db07)
use val_db07, clear
sum pzn_id
generate hst_hist_id=hst_id
tostring pzn_id, gen(pzn_id_string)
tostring hst_hist_id, gen(hst_hist_id_string)
*Notes: 
*pzn_id & hst_hist_id unique identifier
*prd_id and prdo_id are different whenever parallel imports are available 

sort pzn_id_string hst_hist_id_string
merge pzn_id_string hst_hist_id_string using val_hst_hist_db07_mod   
tab _merge

local x key_id pzn_id atc1_id atc2_id atc3_id atc4_id nfc1_id zklass_id nfc2_id nfc3_id hafo_id hst_id prd_id prdo_id gen_id fbetrag_id sub_id str_id pck_id nnn_id abg_id konz_id einf_id ze_faktor zzb_id
quietly foreach list of varlist `x' {
by pzn_id_string, sort: egen help=min(`list')
by pzn_id_string, sort: replace `list'=help
drop help
}

local x=1
quietly while `x'< 49 {
local y val_`x'_1 val_`x'_2 val_`x'_3 val_`x'_4 val_`x'_5 val_`x'_6 val_`x'_7 val_`x'_8 val_`x'_12 val_`x'_13 val_`x'_16
quietly foreach list of varlist `y' {
by pzn_id_string, sort: egen help=min(`list')
by pzn_id_string, sort: replace `list'=help 
drop help
}
local x=`x'+1
}

drop if _merge==1
drop _merge
sort hst_hist_id 
save hist_val_db07, replace

count if pzn_id!=key_id
count if pzn_id!=hafo_id
count if key_id!=hafo_id
drop pzn_id
destring pzn_id_string, generate(pzn_id)
drop key_id
destring pzn_id_string, generate(key_id)
drop  hafo_id
destring pzn_id_string, generate(hafo_id)
count if pzn_id!=key_id
count if pzn_id!=hafo_id
count if key_id!=hafo_id
sort hst_hist_id 
save hist_val_db07, replace

*MERGE historic producer names
merge hst_hist_id using hst_hist_db07_mod   
tab _merge
drop _merge
sort pzn_id_string 
save hist_val_db07, replace

*MERGE historic market values
merge pzn_id_string using val_hist_db07_mod
tab _merge
drop _merge
sort pzn_id_string
save hist_val_db07, replace




****Assign market values at retail form level to producers (variable * market share current and historic producer)
**a) 2004-2007 (monthly)
local x=1
quietly while `x'< 49 {
by pzn_id, sort: egen help1=min(val_`x'_1)
by pzn_id, sort: egen help2=min(val_`x'_2)
by pzn_id, sort: egen help3=min(val_`x'_3)
by pzn_id, sort: egen help4=min(val_`x'_4)
by pzn_id, sort: egen help5=min(val_`x'_5)
by pzn_id, sort: egen help6=min(val_`x'_6)
by pzn_id, sort: egen help7=min(val_`x'_7)
by pzn_id, sort: egen help8=min(val_`x'_8)
by pzn_id, sort: egen help9=min(val_`x'_12)
by pzn_id, sort: egen help10=min(val_`x'_13)
by pzn_id, sort: replace val_`x'_1=help1*val_hst_hist_`x'_1
by pzn_id, sort: replace val_`x'_2=help2*val_hst_hist_`x'_1
by pzn_id, sort: replace val_`x'_3=help3*val_hst_hist_`x'_1
by pzn_id, sort: replace val_`x'_4=help4*val_hst_hist_`x'_1
by pzn_id, sort: replace val_`x'_5=help5*val_hst_hist_`x'_1
by pzn_id, sort: replace val_`x'_6=help6*val_hst_hist_`x'_1
by pzn_id, sort: replace val_`x'_7=help7*val_hst_hist_`x'_1
by pzn_id, sort: replace val_`x'_8=help8*val_hst_hist_`x'_1
by pzn_id, sort: replace val_`x'_12=help9*val_hst_hist_`x'_1
by pzn_id, sort: replace val_`x'_13=help10*val_hst_hist_`x'_1
drop help*
local x=`x'+1
}

**b) 2001-2003 (annual)
local x=2001
quietly while `x'< 2004 {
by pzn_id, sort: egen help1=min(absatz_gh`x')
by pzn_id, sort: egen help2=min(abverkauf_eh`x' )
by pzn_id, sort: egen help3=min(naturalrabatt_eh`x')
by pzn_id, sort: egen help4=min(retouren_eh`x')
by pzn_id, sort: egen help5=min(umsatz_gh`x')
by pzn_id, sort: egen help6=min(abverkauf_ums`x')
by pzn_id, sort: egen help7=min(naturalrabatt_ums`x')
by pzn_id, sort: egen help8=min(retouren_ums`x')
by pzn_id, sort: egen help9=min(direkt_eh`x')
by pzn_id, sort: egen help10=min(direkt_ums`x')

by pzn_id, sort: replace absatz_gh`x'=help1*val_hst_hist_`x'_1
by pzn_id, sort: replace abverkauf_eh`x'=help2*val_hst_hist_`x'_1
by pzn_id, sort: replace naturalrabatt_eh`x'=help3*val_hst_hist_`x'_1
by pzn_id, sort: replace retouren_eh`x'=help4*val_hst_hist_`x'_1
by pzn_id, sort: replace umsatz_gh`x'=help5*val_hst_hist_`x'_1
by pzn_id, sort: replace abverkauf_ums`x'=help6*val_hst_hist_`x'_1
by pzn_id, sort: replace naturalrabatt_ums`x'=help7*val_hst_hist_`x'_1
by pzn_id, sort: replace retouren_ums`x'=help8*val_hst_hist_`x'_1
by pzn_id, sort: replace direkt_eh`x'=help9*val_hst_hist_`x'_1
by pzn_id, sort: replace direkt_ums`x'=help10*val_hst_hist_`x'_1
drop help*
local x=`x'+1
}
sort pzn_id_string
save hist_val_db07, replace


*MERGE qualitative data
merge pzn_id_string using pzn_db07_mod
tab _merge
drop _merge
sort atc1_id
save hist_val_db07, replace

merge atc1_id using atc1_db07_mod
tab _merge
drop if _merge==2
drop _merge
sort atc2_id
save hist_val_db07, replace

merge atc2_id using atc2_db07_mod
tab _merge
drop if _merge==2
drop _merge
sort atc3_id
save hist_val_db07, replace

merge atc3_id using atc3_db07_mod
tab _merge
drop if _merge==2
drop _merge
sort atc4_id
save hist_val_db07, replace

merge atc4_id using atc4_db07_mod
tab _merge
drop if _merge==2
drop _merge
sort nfc1_id
save hist_val_db07, replace

merge nfc1_id using nfc1_db07_mod
tab _merge
drop if _merge==2
drop _merge
sort nfc2_id
save hist_val_db07, replace

merge nfc2_id using nfc2_db07_mod
tab _merge
drop if _merge==2
drop _merge
sort nfc3_id
save hist_val_db07, replace

merge nfc3_id using nfc3_db07_mod
tab _merge
drop if _merge==2
drop _merge
sort zklass_id
save hist_val_db07, replace

merge zklass_id using zklass_db07_mod
tab _merge
drop _merge
sort pzn_id_string
save hist_val_db07, replace

merge pzn_id_string using hafo_db07_mod
tab _merge
drop _merge
sort hst_id
save hist_val_db07, replace

merge hst_id using hst_db07_mod      
tab _merge
drop _merge
sort prd_id
save hist_val_db07, replace

merge prd_id using prd_db07_mod
tab _merge
drop _merge
sort prdo_id
save hist_val_db07, replace

merge prdo_id using prdo_db07_mod
tab _merge
drop if _merge==2
drop _merge
sort gen_id
save hist_val_db07, replace

merge gen_id using gen_db07_mod
tab _merge
drop _merge
sort fbetrag_id
save hist_val_db07, replace

merge fbetrag_id using fbetrag_db07_mod
tab _merge
drop _merge
sort sub_id
save hist_val_db07, replace

merge sub_id using sub_db07_mod
tab _merge
drop _merge
sort str_id
save hist_val_db07, replace

merge str_id using str_db07_mod
tab _merge
drop _merge
sort pck_id
save hist_val_db07, replace

merge pck_id using pck_db07_mod
tab _merge
drop _merge
sort nnn_id
save hist_val_db07, replace

merge nnn_id using nnn_db07_mod
tab _merge
drop _merge
sort abg_id
save hist_val_db07, replace

merge abg_id using abg_db07_mod
tab _merge
drop _merge
sort zzb_id
save hist_val_db07, replace

merge zzb_id using zzb_db07_mod
tab _merge
drop _merge
sort konz_id
save hist_val_db07, replace

merge konz_id using konz_db07_mod
tab _merge
drop _merge
sort einf_id
save hist_val_db07, replace

merge einf_id using einf_db07_mod
tab _merge
drop _merge
drop val_*_16
sort pzn_id
save hist_val_db07, replace


*Rename Variables
local x=1
quietly while `x'<13 {
local y=2004
rename val_`x'_1 absatz_gh_`x'_`y'
rename val_`x'_2 abverkauf_eh_`x'_`y'
rename val_`x'_3 naturalrabatt_eh_`x'_`y'
rename val_`x'_4 retouren_eh_`x'_`y'
rename val_`x'_5 umsatz_gh_`x'_`y'
rename val_`x'_6 hap_`x'_`y'
rename val_`x'_7 avp_`x'_`y'
rename val_`x'_8 fbetrag_`x'_`y'
rename val_`x'_12 direkt_eh_`x'_`y'
rename val_`x'_13 direkt_ums_`x'_`y'
local x=`x'+1
}

local x=13
quietly while `x'<25 {
local x2=`x'-12
local y=2005
rename val_`x'_1 absatz_gh_`x2'_`y'
rename val_`x'_2 abverkauf_eh_`x2'_`y'
rename val_`x'_3 naturalrabatt_eh_`x2'_`y'
rename val_`x'_4 retouren_eh_`x2'_`y'
rename val_`x'_5 umsatz_gh_`x2'_`y'
rename val_`x'_6 hap_`x2'_`y'
rename val_`x'_7 avp_`x2'_`y'
rename val_`x'_8 fbetrag_`x2'_`y'
rename val_`x'_12 direkt_eh_`x2'_`y'
rename val_`x'_13 direkt_ums_`x2'_`y'
local x=`x'+1
}

local x=25
quietly while `x'<37 {
local x2=`x'-24
local y=2006
rename val_`x'_1 absatz_gh_`x2'_`y'
rename val_`x'_2 abverkauf_eh_`x2'_`y'
rename val_`x'_3 naturalrabatt_eh_`x2'_`y'
rename val_`x'_4 retouren_eh_`x2'_`y'
rename val_`x'_5 umsatz_gh_`x2'_`y'
rename val_`x'_6 hap_`x2'_`y'
rename val_`x'_7 avp_`x2'_`y'
rename val_`x'_8 fbetrag_`x2'_`y'
rename val_`x'_12 direkt_eh_`x2'_`y'
rename val_`x'_13 direkt_ums_`x2'_`y'
local x=`x'+1
}

local x=37
quietly while `x'<49 {
local x2=`x'-36
local y=2007
rename val_`x'_1 absatz_gh_`x2'_`y'
rename val_`x'_2 abverkauf_eh_`x2'_`y'
rename val_`x'_3 naturalrabatt_eh_`x2'_`y'
rename val_`x'_4 retouren_eh_`x2'_`y'
rename val_`x'_5 umsatz_gh_`x2'_`y'
rename val_`x'_6 hap_`x2'_`y'
rename val_`x'_7 avp_`x2'_`y'
rename val_`x'_8 fbetrag_`x2'_`y'
rename val_`x'_12 direkt_eh_`x2'_`y'
rename val_`x'_13 direkt_ums_`x2'_`y'
local x=`x'+1
}

save hist_val_db07, replace
drop val_hst_hist*
sort pzn_id
save hist_db07, replace


*** Keep copy of key variables (NPI DB07) prior to merge with NPI DB05/06
gen out_of_stock07= regexm(pzn,"@")
generate gen_id_db07=gen_id
generate subs_db07= substanzen
generate produkt_db07=produkt
generate produkt_pi_db07=produkt_pi
gen year_launch_form_db07=year(einfue)
generate date_launch_form_db07=einfue
generate producer_db07=hersteller
generate producer_hist_db07=hersteller_hist
generate parent_db07= konzern
save hist_db07, replace


*generate modified version of pzn_id for merge with NPI DB05/07 (unique identifier of retail forms)
*Note: reuse of pzn_ids following exit of medical products
rename pzn_id pzn_id_mod
generate pzn_id long=pzn_id_mod

*identify changes in the producer selling retail form
by pzn_id_mod, sort: egen pzn_index_db07=count(pzn_id_mod)
tab pzn_index_db07
generate prod_change=0 
replace prod_change=1 if pzn_index_db07!=1
tab prod_change

generate pzn_diff=0
generate pzn_diff_db07=pzn_diff
*unique identifier: pzn_id_string pzn_diff hst_hist_id_string

sort pzn_id_string pzn_diff hst_hist_id_string
save hist_db07, replace


*** end of do file


