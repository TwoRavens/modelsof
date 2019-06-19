******************************************************************************************************************************************
*MANUSCRIPT: Authorized Generic Entry prior to Patent Expiry: Reassessing Incentives for Independent Generic Entry 
*AUTHOR:     Silvia Appelt, University of Munich, silvia.appelt@lrz.uni-muenchen.de

******************************************************************************************************************************************
				                    *** MERGE NPI data tables: NPI DB05 (1999-2001/2002-2005) ***
						            		* Date last edit:  11 January 2015 * 
******************************************************************************************************************************************   
*PROGRAMME: STATA (last version used: STATA MP 13.0) 
 
version 13.0
set more off
cap log close
clear


*NPI DB05 (1999-2001/2002-2005)

*** (I) Renaming of variables for merge
use pzn_db05, clear
rename key_id pzn_id
sum pzn_id
rename value pzn
sort pzn_id
save pzn_db05_mod, replace

use atc1_db05, clear
drop atc1
rename key_id atc1_id
rename value atc1
sort atc1_id
save atc1_db05_mod, replace

use atc2_db05, clear
drop atc2
rename key_id atc2_id
rename value atc2
sort atc2_id
save atc2_db05_mod, replace

use atc3_db05, clear
drop atc3
rename key_id atc3_id
rename value atc3
sort atc3_id
save atc3_db05_mod, replace

use atc4_db05, clear
drop atc4
rename key_id atc4_id
rename value atc4
sort atc4_id
save atc4_db05_mod, replace

use nfc1_db05, clear
drop nfc1
rename key_id nfc1_id
rename value nfc1
sort nfc1_id
save nfc1_db05_mod, replace

use nfc2_db05, clear
drop nfc2
rename key_id nfc2_id
rename value nfc2
sort nfc2_id
save nfc2_db05_mod, replace

use nfc3_db05, clear
drop nfc3
rename key_id nfc3_id
rename value nfc3
sort nfc3_id
save nfc3_db05_mod, replace

use zklass_db05, clear
rename key_id zklass_id
rename value zusatzklasse
sort zklass_id
save zklass_db05_mod, replace

use hafo_db05, clear
rename value handelsformen
rename key_id hafo_id
sum hafo_id
sort hafo_id
save hafo_db05_mod, replace

use hst_db05, clear
rename key_id hst_id
rename value hersteller
sort hst_id
save hst_db05_mod, replace

use hst_hist_db05, clear
rename key_id hst_hist_id
rename value hersteller_hist
sort hst_hist_id
save hst_hist_db05_mod, replace

use prd_db05, clear
rename key_id prd_id
rename value produkt
sort prd_id
save prd_db05_mod, replace

use prdo_db05, clear
rename key_id prdo_id
rename value produkt_pi
sort prdo_id
save prdo_db05_mod, replace

use gen_db05, clear
rename key_id gen_id
rename value generika
sort gen_id
save gen_db05_mod, replace

use fbetrag_db05, clear
rename key_id fbetrag_id
rename value festbetrag
sort fbetrag_id
save fbetrag_db05_mod, replace

use sub_db05, clear
rename key_id sub_id
rename value substanzen
sort sub_id
save sub_db05_mod, replace

use str_db05, clear
rename key_id str_id
rename value staerke
sort str_id
save str_db05_mod, replace

use pck_db05, clear
rename key_id pck_id
rename value packungen
sort pck_id
save pck_db05_mod, replace

use nnn_db05, clear
rename key_id nnn_id
rename value n1n2n3
sort nnn_id
save nnn_db05_mod, replace

use abg_db05, clear
rename key_id abg_id
rename value abgabe
sort abg_id
save abg_db05_mod, replace

use ais_db05, clear
rename key_id ais_id
rename value aut_idem
sort ais_id
save ais_db05_mod, replace

use konz_db05, clear
rename key_id konz_id
rename value konzern
sort konz_id
save konz_db05_mod, replace

use einf_db05, clear
rename key_id einf_id
rename value prod_launch
sort einf_id
save einf_db05_mod, replace

*Historic values - previous producers (1999-2001 annually; therafter monthly) 
use val_hist_db05, clear 
local x=1
while `x'< 2 {
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
*Note: Historic values are missing in some cases (abverkauf_ums, naturalrabatt_ums, retouren_ums)
  
rename key_id pzn_id
sum pzn_id
local x=1
quietly while `x'< 4 {
local y=1998+`x'
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
save val_hist_db05_mod, replace

*Market shares (retail form level, i.e. pzn) - previous producers (1999-2001)
use val_hst_hist_db05, clear
sort pzn_id hst_hist
rename val_hst_hist_6_1_1 val_hst_hist_1999_1 
rename val_hst_hist_6_2_1 val_hst_hist_2000_1 
rename val_hst_hist_6_3_1 val_hst_hist_2001_1 

sum pzn_id
*182691 observations
*pzn_id & hst_hist_id unique identifier (182691 observations)

tostring pzn_id, gen(pzn_id_string)
tostring hst_hist_id, gen(hst_hist_id_string)

sort pzn_id_string hst_hist_id_string
save val_hst_hist_db05_mod, replace


*** (II) MERGE data (DB 05), incl. data on historic producers (hst_hist_db05, and val_hst_hist_db05)
use val_db05, clear
sum pzn_id
generate hst_hist_id=hst_id
tostring pzn_id, gen(pzn_id_string)
tostring hst_hist_id, gen(hst_hist_id_string)
*Notes: 
*pzn_id & hst_hist_id unique identifier
*prd_id and prdo_id are different whenever parallel imports are available 

sort pzn_id_string hst_hist_id_string
merge pzn_id_string hst_hist_id_string using val_hst_hist_db05_mod   
tab _merge

local x key_id pzn_id atc1_id atc2_id atc3_id atc4_id nfc1_id zklass_id nfc2_id nfc3_id hafo_id hst_id prd_id prdo_id gen_id fbetrag_id sub_id str_id pck_id nnn_id abg_id ais_id konz_id einf_id ze_faktor
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
save hist_val_db05, replace

count if pzn_id!=key_id
count if pzn_id!=hafo_id
count if key_id!=hafo_id
sort hst_hist_id 
save hist_val_db05, replace

*MERGE historic producer names
merge hst_hist_id using hst_hist_db05_mod   
tab _merge
drop _merge
sort pzn_id_string 
save hist_val_db05, replace

*MERGE historic market values (1999-2001)
merge pzn_id_string using val_hist_db05_mod
tab _merge
drop _merge
sort pzn_id 
save hist_val_db05, replace


****Assign market values at retail form level to producers (variable * market share current and historic producer)
**a) 2002-2005 (monthly)
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
by pzn_id, sort: egen help11=min(val_`x'_16)
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
by pzn_id, sort: replace val_`x'_16=help11*val_hst_hist_`x'_1
drop help*
local x=`x'+1
}

**b) 1999-2001 (annual)
local x=1999
quietly while `x'< 2002 {
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
save hist_val_db05, replace


*MERGE qualitative data
use hist_val_db05, clear
sort pzn_id
merge pzn_id using pzn_db05_mod
tab _merge
drop _merge
sort atc1_id
save hist_val_db05, replace

merge atc1_id using atc1_db05_mod
tab _merge
drop if _merge==2
drop _merge
sort atc2_id
save hist_val_db05, replace

merge atc2_id using atc2_db05_mod
tab _merge
drop if _merge==2
drop _merge
sort atc3_id
save hist_val_db05, replace

merge atc3_id using atc3_db05_mod
tab _merge
drop if _merge==2
drop _merge
sort atc4_id
save hist_val_db05, replace

merge atc4_id using atc4_db05_mod
tab _merge
drop if _merge==2
drop _merge
sort nfc1_id
save hist_val_db05, replace

merge nfc1_id using nfc1_db05_mod
tab _merge
drop if _merge==2
drop _merge
sort nfc2_id
save hist_val_db05, replace

merge nfc2_id using nfc2_db05_mod
tab _merge
drop if _merge==2
drop _merge
sort nfc3_id
save hist_val_db05, replace

merge nfc3_id using nfc3_db05_mod
tab _merge
drop if _merge==2
drop _merge
sort zklass_id
save hist_val_db05, replace

merge zklass_id using zklass_db05_mod
tab _merge
drop _merge
sort hafo_id
save hist_val_db05, replace

merge hafo_id using hafo_db05_mod
tab _merge
drop _merge
sort hst_id
save hist_val_db05, replace

merge hst_id using hst_db05_mod      
tab _merge
drop _merge
sort prd_id
save hist_val_db05, replace

merge prd_id using prd_db05_mod
tab _merge
drop _merge
sort prdo_id
save hist_val_db05, replace

merge prdo_id using prdo_db05_mod
tab _merge
drop if _merge==2
drop _merge
sort gen_id
save hist_val_db05, replace

merge gen_id using gen_db05_mod
tab _merge
drop _merge
sort fbetrag_id
save hist_val_db05, replace

merge fbetrag_id using fbetrag_db05_mod
tab _merge
drop _merge
sort sub_id
save hist_val_db05, replace

merge sub_id using sub_db05_mod
tab _merge
drop _merge
sort str_id
save hist_val_db05, replace

merge str_id using str_db05_mod
tab _merge
drop _merge
sort pck_id
save hist_val_db05, replace

merge pck_id using pck_db05_mod
tab _merge
drop _merge
sort nnn_id
save hist_val_db05, replace

merge nnn_id using nnn_db05_mod
tab _merge
drop _merge
sort abg_id
save hist_val_db05, replace

merge abg_id using abg_db05_mod
tab _merge
drop _merge
sort ais_id
save hist_val_db05, replace

merge ais_id using ais_db05_mod
tab _merge
drop _merge
sort konz_id
save hist_val_db05, replace

merge konz_id using konz_db05_mod
tab _merge
drop _merge
sort einf_id
save hist_val_db05, replace

merge einf_id using einf_db05_mod
tab _merge
drop _merge
sort pzn_id
save hist_val_db05, replace


*Rename Variables
local x=1
quietly while `x'<13 {
local y=2002
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
rename val_`x'_16 aut_idem_`x'_`y'
local x=`x'+1
}

local x=13
quietly while `x'<25 {
local x2=`x'-12
local y=2003
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
rename val_`x'_16 aut_idem_`x2'_`y'
local x=`x'+1
}

local x=25
quietly while `x'<37 {
local x2=`x'-24
local y=2004
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
rename val_`x'_16 aut_idem_`x2'_`y'
local x=`x'+1
}

local x=37
quietly while `x'<49 {
local x2=`x'-36
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
rename val_`x'_16 aut_idem_`x2'_`y'
local x=`x'+1
}

save hist_val_db05, replace
drop val_hst_hist*
sort pzn_id


*** Keep copy of key variables (NPI DB05) prior to merge with NPI DB06/07
gen out_of_stock05= regexm(pzn,"@")
generate gen_id_db05=gen_id
generate subs_db05= substanzen
generate produkt_db05=produkt
generate produkt_pi_db05=produkt_pi
gen year_launch_form_db05=year(einfue)
generate date_launch_form_db05=einfue
generate producer_db05=hersteller
generate producer_hist_db05=hersteller_hist
generate parent_db05= konzern
save hist_db05, replace

*generate modified version of pzn_id for merge with NPI DB06/07 (unique identifier of retail forms)
*Note: reuse of pzn_ids following exit of medical products
generate pzn_id_mod long=pzn_id

*** Product market exits 2005 (864 cases detected, e.g. merging NPI DB05 and DB06 and comparing product/retail form names)
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1353
replace pzn_id_mod=pzn_id+0.5 if pzn_id==8355
replace pzn_id_mod=pzn_id+0.5 if pzn_id==8361
replace pzn_id_mod=pzn_id+0.5 if pzn_id==8556
replace pzn_id_mod=pzn_id+0.5 if pzn_id==8562
replace pzn_id_mod=pzn_id+0.5 if pzn_id==13994
replace pzn_id_mod=pzn_id+0.5 if pzn_id==40778
replace pzn_id_mod=pzn_id+0.5 if pzn_id==46031
replace pzn_id_mod=pzn_id+0.5 if pzn_id==71649
replace pzn_id_mod=pzn_id+0.5 if pzn_id==75156
replace pzn_id_mod=pzn_id+0.5 if pzn_id==75162
replace pzn_id_mod=pzn_id+0.5 if pzn_id==88940
replace pzn_id_mod=pzn_id+0.5 if pzn_id==89069
replace pzn_id_mod=pzn_id+0.5 if pzn_id==123702
replace pzn_id_mod=pzn_id+0.5 if pzn_id==142763
replace pzn_id_mod=pzn_id+0.5 if pzn_id==143716
replace pzn_id_mod=pzn_id+0.5 if pzn_id==156073
replace pzn_id_mod=pzn_id+0.5 if pzn_id==166025
replace pzn_id_mod=pzn_id+0.5 if pzn_id==166031
replace pzn_id_mod=pzn_id+0.5 if pzn_id==180686
replace pzn_id_mod=pzn_id+0.5 if pzn_id==180692
replace pzn_id_mod=pzn_id+0.5 if pzn_id==182372
replace pzn_id_mod=pzn_id+0.5 if pzn_id==187889
replace pzn_id_mod=pzn_id+0.5 if pzn_id==189807
replace pzn_id_mod=pzn_id+0.5 if pzn_id==189813
replace pzn_id_mod=pzn_id+0.5 if pzn_id==191454
replace pzn_id_mod=pzn_id+0.5 if pzn_id==198189
replace pzn_id_mod=pzn_id+0.5 if pzn_id==201796
replace pzn_id_mod=pzn_id+0.5 if pzn_id==208580
replace pzn_id_mod=pzn_id+0.5 if pzn_id==210513
replace pzn_id_mod=pzn_id+0.5 if pzn_id==229493
replace pzn_id_mod=pzn_id+0.5 if pzn_id==258247
replace pzn_id_mod=pzn_id+0.5 if pzn_id==258253
replace pzn_id_mod=pzn_id+0.5 if pzn_id==295573
replace pzn_id_mod=pzn_id+0.5 if pzn_id==295596
replace pzn_id_mod=pzn_id+0.5 if pzn_id==351840
replace pzn_id_mod=pzn_id+0.5 if pzn_id==351857
replace pzn_id_mod=pzn_id+0.5 if pzn_id==403324
replace pzn_id_mod=pzn_id+0.5 if pzn_id==453552
replace pzn_id_mod=pzn_id+0.5 if pzn_id==486830
replace pzn_id_mod=pzn_id+0.5 if pzn_id==562212
replace pzn_id_mod=pzn_id+0.5 if pzn_id==563163
replace pzn_id_mod=pzn_id+0.5 if pzn_id==568172
replace pzn_id_mod=pzn_id+0.5 if pzn_id==589636
replace pzn_id_mod=pzn_id+0.5 if pzn_id==589688
replace pzn_id_mod=pzn_id+0.5 if pzn_id==631048
replace pzn_id_mod=pzn_id+0.5 if pzn_id==639943
replace pzn_id_mod=pzn_id+0.5 if pzn_id==671898
replace pzn_id_mod=pzn_id+0.5 if pzn_id==671906
replace pzn_id_mod=pzn_id+0.5 if pzn_id==831741
replace pzn_id_mod=pzn_id+0.5 if pzn_id==832485
replace pzn_id_mod=pzn_id+0.5 if pzn_id==833088
replace pzn_id_mod=pzn_id+0.5 if pzn_id==833094
replace pzn_id_mod=pzn_id+0.5 if pzn_id==833289
replace pzn_id_mod=pzn_id+0.5 if pzn_id==846205
replace pzn_id_mod=pzn_id+0.5 if pzn_id==882744
replace pzn_id_mod=pzn_id+0.5 if pzn_id==882750
replace pzn_id_mod=pzn_id+0.5 if pzn_id==928765
replace pzn_id_mod=pzn_id+0.5 if pzn_id==928771
replace pzn_id_mod=pzn_id+0.5 if pzn_id==928788
replace pzn_id_mod=pzn_id+0.5 if pzn_id==976451
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1068537
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1136641
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1162992
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1163023
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1163201
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1172565
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1190126
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1216015
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1227651
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1316998
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1318431
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1327306
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1339597
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1347912
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1348538
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1554485
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1554597
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1574335
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1592592
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1636131
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1640807
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1678804
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1678810
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1678827
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1744932
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1744949
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1744955
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1744978
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1745771
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1745819
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1745825
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1746210
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1746227
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1746279
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1746380
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1746517
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1746569
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1746931
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1748338
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1748539
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1752446
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1758650
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1782766
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1808968
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1847796
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1851740
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1851823
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1896435
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1896458
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1896903
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1907021
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1921854
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1953044
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2006797
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2121759
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2121995
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2124350
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2128431
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2144157
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2152978
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2180319
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2180443
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2180466
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2180503
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2180526
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2181170
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2181193
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2182353
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2185587
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2191547
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2347794
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2405818
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2475380
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2475463
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2491628
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2499587
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2499593
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2504928
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2535573
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2540999
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2542219
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2550242
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2554659
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2554671
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2598421
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2622875
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2627269
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2715157
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2715163
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2719250
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2719267
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2719497
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2719505
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2720299
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2733066
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2733103
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2733155
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2733422
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2739206
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2750053
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2750604
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2751070
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2757026
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2761890
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2767148
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2767154
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2767160
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2768550
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2774869
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2783609
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2822769
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2886396
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2887711
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2887763
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2887846
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2887875
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2887881
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2899281
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3005021
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3047580
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3047597
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3055757
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3060675
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3087444
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3096331
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3096354
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3121135
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3121276
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3126871
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3172575
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3176171
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3176188
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3177236
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3179525
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3184673
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3248982
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3286712
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3286735
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3287226
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3291819
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3291825
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3291848
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3293681
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3293698
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3294580
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3294953
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3294976
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3294982
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3294999
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3297236
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3297242
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3297259
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3297584
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3300033
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3300369
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3300375
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3302167
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3302569
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3302776
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3308603
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3308626
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3308649
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3308655
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3309206
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3311485
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3311539
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3316100
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3316117
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3318234
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3323318
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3323695
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3323749
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3332205
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3332240
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3332493
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3332501
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3333742
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3338685
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3342652
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3349418
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3350195
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3368982
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3373285
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3374557
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3387117
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3387643
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3400510
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3401053
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3401082
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3401739
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3402207
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3404169
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3407067
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3418119
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3427029
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3427271
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3430161
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3430267
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3434897
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3441070
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3453452
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3455497
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3455505
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3455511
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3455528
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3455540
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3455557
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3455563
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3455617
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3455623
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3466756
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3471616
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3473578
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3477079
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3477085
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3507389
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3514946
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3514952
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3530773
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3545757
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3545763
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3560449
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3560863
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3562023
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3625568
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3667621
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3675112
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3675129
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3680596
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3686699
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3686920
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3687440
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3689261
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3689982
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3738580
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3739378
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3757175
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3757554
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3760898
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3760906
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3761320
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3763738
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3763744
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3763980
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3765269
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3765275
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3768055
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3768629
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3770141
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3770158
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3770164
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3771519
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3772217
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3772246
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3772312
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3782954
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3783014
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3783020
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3797737
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3797743
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3812885
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3815174
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3822398
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3828053
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3828981
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3829905
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3830021
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3830044
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3835426
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3845063
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3845086
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3846654
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3846660
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3850986
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3873409
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3878677
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3879197
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3879464
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3879783
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3879808
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3879814
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3880237
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3880243
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3897485
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3898042
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3919494
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3952250
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3956845
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3965643
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3965666
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3965703
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3965726
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3976440
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3976842
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3981470
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4019284
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4020979
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4209949
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4209961
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4221614
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4221620
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4258439
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4263239
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4263245
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4266605
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4301158
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4337104
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4337989
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4382257
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4405811
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4405828
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4406472
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4411421
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4443119
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4446833
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4450036
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4453738
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4465003
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4498327
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4499083
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4514173
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4515155
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4522037
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4527589
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4532834
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4535577
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4535583
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4535873
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4536602
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4536855
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4541810
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4545713
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4553859
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4556421
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4556438
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4561600
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4568134
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4585807
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4586178
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4594522
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4596917
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4603617
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4610936
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4611829
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4612295
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4612303
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4613136
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4613254
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4613277
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4634693
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4635416
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4636887
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4636893
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4637160
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4637177
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4637266
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4637272
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4637409
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4637415
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4639615
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4639897
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4642273
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4642356
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4642362
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4642379
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4644013
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4644036
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4646064
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4646851
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4647253
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4647997
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4648293
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4648301
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4648318
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4650723
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4650769
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4650781
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4660940
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4668775
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4668812
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4668829
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4669208
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4672400
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4674830
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4676987
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4677389
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4677403
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4684515
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4745240
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4745429
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4745435
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4746015
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4746021
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4748669
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4748882
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4748899
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4749373
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4779888
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4779902
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4780124
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4796846
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4807018
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4815710
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4831057
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4832967
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4833010
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4833033
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4833197
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4833375
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4836706
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4836712
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4846691
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4846722
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4851752
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4883404
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4883427
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4884272
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4885171
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4885231
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4887520
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4887922
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4898707
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4900433
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4905979
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4906306
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4911974
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4920252
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4920341
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4920358
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4927521
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4927596
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4935093
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4939843
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4945097
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4945111
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4946412
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4946429
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4946435
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4949221
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4953671
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4965237
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4967816
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4969169
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4975106
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4982750
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4982796
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4982891
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4991140
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4991743
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4991766
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6306674
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6317519
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6318737
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6318743
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6318789
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6318795
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6318803
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6320148
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6322650
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6324436
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6324442
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6331407
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6340145
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6341073
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6341191
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6609601
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6611087
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6641898
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6873640
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6878778
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6952109
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6961031
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6962510
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6964029
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6965589
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6983802
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6985592
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6987355
replace pzn_id_mod=pzn_id+0.5 if pzn_id==568901
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1682680
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1683225
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1684012
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1895507
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1921825
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2749506
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2749512
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2750024
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3194602
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3965695
replace pzn_id_mod=pzn_id+0.5 if pzn_id==8496
replace pzn_id_mod=pzn_id+0.5 if pzn_id==122111
replace pzn_id_mod=pzn_id+0.5 if pzn_id==122140
replace pzn_id_mod=pzn_id+0.5 if pzn_id==122157
replace pzn_id_mod=pzn_id+0.5 if pzn_id==166019
replace pzn_id_mod=pzn_id+0.5 if pzn_id==234488
replace pzn_id_mod=pzn_id+0.5 if pzn_id==384288
replace pzn_id_mod=pzn_id+0.5 if pzn_id==791680
replace pzn_id_mod=pzn_id+0.5 if pzn_id==900985
replace pzn_id_mod=pzn_id+0.5 if pzn_id==900991
replace pzn_id_mod=pzn_id+0.5 if pzn_id==903363
replace pzn_id_mod=pzn_id+0.5 if pzn_id==903386
replace pzn_id_mod=pzn_id+0.5 if pzn_id==903392
replace pzn_id_mod=pzn_id+0.5 if pzn_id==911463
replace pzn_id_mod=pzn_id+0.5 if pzn_id==911486
replace pzn_id_mod=pzn_id+0.5 if pzn_id==911492
replace pzn_id_mod=pzn_id+0.5 if pzn_id==911500
replace pzn_id_mod=pzn_id+0.5 if pzn_id==911517
replace pzn_id_mod=pzn_id+0.5 if pzn_id==911523
replace pzn_id_mod=pzn_id+0.5 if pzn_id==911546
replace pzn_id_mod=pzn_id+0.5 if pzn_id==911552
replace pzn_id_mod=pzn_id+0.5 if pzn_id==914042
replace pzn_id_mod=pzn_id+0.5 if pzn_id==914059
replace pzn_id_mod=pzn_id+0.5 if pzn_id==929368
replace pzn_id_mod=pzn_id+0.5 if pzn_id==941091
replace pzn_id_mod=pzn_id+0.5 if pzn_id==955785
replace pzn_id_mod=pzn_id+0.5 if pzn_id==956000
replace pzn_id_mod=pzn_id+0.5 if pzn_id==964442
replace pzn_id_mod=pzn_id+0.5 if pzn_id==971436
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1014441
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1014458
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1032396
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1036017
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1036023
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1036046
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1036052
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1036069
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1036075
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1036081
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1036098
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1038128
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1039139
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1103535
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1103541
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1118212
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1163193
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1175552
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1175569
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1178639
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1178645
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1178651
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1178668
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1178674
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1178680
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1178697
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1178705
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1193076
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1227622
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1227639
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1227645
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1227668
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1227674
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1292766
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1307166
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1325997
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1326790
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1334370
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1334387
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1362627
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1362656
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1392580
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1398743
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1399636
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1400078
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1402172
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1402189
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1422565
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1431707
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1431713
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1463009
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1463015
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1468610
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1470860
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1486080
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1492465
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1511010
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1511027
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1562355
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1575079
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1575174
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1575286
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1575292
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1575300
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1575642
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1575731
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1575949
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1576038
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1576357
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1576802
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1576908
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1577003
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1577109
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1577204
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1577316
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1591807
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1610025
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1635048
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1654152
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1659758
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1659764
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1659787
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1674574
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1688435
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1688441
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1750594
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1750602
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1750677
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1750683
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1750772
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1750789
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1808951
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1830063
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1847388
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1978481
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1981974
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2256063
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2350684
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2373538
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2422656
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2422768
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2475428
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2475434
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2475440
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2475457
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2477982
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2477999
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2500391
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3047640
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3080353
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3087421
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3087438
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3156352
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3229588
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3248999
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3273483
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3312616
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3396228
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3428684
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3455480
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3455586
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3455592
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3455600
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3455646
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3455652
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3455669
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3466816
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3488120
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3488137
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3492989
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3501122
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3507395
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3522029
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3522041
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3560900
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3751362
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3845560
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3936038
replace pzn_id_mod=pzn_id+0.5 if pzn_id==3937925
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4021312
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4251532
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4498310
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4498333
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4499077
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4503732
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4503749
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4504074
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4505978
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4507799
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4508729
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4508735
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4510614
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4510620
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4511648
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4512079
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4514167
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4514492
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4514500
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4514517
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4514546
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4515178
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4521492
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4522250
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4525403
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4526147
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4527603
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4531148
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4532254
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4532260
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4538682
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4540348
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4540354
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4541827
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4541856
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4541885
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4541891
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4541951
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4541968
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4542264
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4542347
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4543772
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4543789
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4544607
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4545736
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4545742
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4546032
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4547273
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4547310
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4548404
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4548568
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4548574
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4549289
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4549295
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4549697
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4549875
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4550111
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4550134
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4550140
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4551085
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4551091
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4553948
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4564018
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4564136
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4564432
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4564550
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4564685
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4564923
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4565058
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4565472
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4567063
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4567175
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4567181
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4567399
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4568111
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4568128
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4568921
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4569286
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4571142
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4580052
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4583955
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4583961
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4583978
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4583984
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4583990
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4584009
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4584920
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4585813
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4587166
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4587172
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4587189
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4587344
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4587350
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4587769
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4588527
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4592546
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4592552
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4592569
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4593008
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4593014
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4593089
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4593095
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4593362
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4594485
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4594516
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4594539
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4594545
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4594568
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4596277
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4596283
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4596308
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4596515
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4598508
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4598796
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4601452
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4601506
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4601512
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4601995
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4603304
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4603379
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4605697
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4608767
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4611835
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4613260
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4628936
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4628965
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4637390
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4639609
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4771697
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4810115
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4854012
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4897116
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4908179
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4920223
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4930457
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4930463
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4930687
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4930859
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4944614
replace pzn_id_mod=pzn_id+0.5 if pzn_id==4944643
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6307490
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6340091
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6618267
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6969274
replace pzn_id_mod=pzn_id+0.5 if pzn_id==6985586
replace pzn_id_mod=pzn_id+0.5 if pzn_id==1746641
replace pzn_id_mod=pzn_id+0.5 if pzn_id==2886396

*** Product market exits 2006 (1066 cases detected, e.g. merging NPI DB06 and DB07 and comparing product/retail form names)
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2128
replace pzn_id_mod=pzn_id+0.6 if pzn_id==14953
replace pzn_id_mod=pzn_id+0.6 if pzn_id==25833
replace pzn_id_mod=pzn_id+0.6 if pzn_id==26092
replace pzn_id_mod=pzn_id+0.6 if pzn_id==26175
replace pzn_id_mod=pzn_id+0.6 if pzn_id==28777
replace pzn_id_mod=pzn_id+0.6 if pzn_id==62805
replace pzn_id_mod=pzn_id+0.6 if pzn_id==69345
replace pzn_id_mod=pzn_id+0.6 if pzn_id==69397
replace pzn_id_mod=pzn_id+0.6 if pzn_id==70093
replace pzn_id_mod=pzn_id+0.6 if pzn_id==70472
replace pzn_id_mod=pzn_id+0.6 if pzn_id==70489
replace pzn_id_mod=pzn_id+0.6 if pzn_id==71023
replace pzn_id_mod=pzn_id+0.6 if pzn_id==71052
replace pzn_id_mod=pzn_id+0.6 if pzn_id==71069
replace pzn_id_mod=pzn_id+0.6 if pzn_id==71425
replace pzn_id_mod=pzn_id+0.6 if pzn_id==71566
replace pzn_id_mod=pzn_id+0.6 if pzn_id==73387
replace pzn_id_mod=pzn_id+0.6 if pzn_id==73393
replace pzn_id_mod=pzn_id+0.6 if pzn_id==73418
replace pzn_id_mod=pzn_id+0.6 if pzn_id==80252
replace pzn_id_mod=pzn_id+0.6 if pzn_id==80542
replace pzn_id_mod=pzn_id+0.6 if pzn_id==80559
replace pzn_id_mod=pzn_id+0.6 if pzn_id==80996
replace pzn_id_mod=pzn_id+0.6 if pzn_id==81027
replace pzn_id_mod=pzn_id+0.6 if pzn_id==81062
replace pzn_id_mod=pzn_id+0.6 if pzn_id==85019
replace pzn_id_mod=pzn_id+0.6 if pzn_id==88816
replace pzn_id_mod=pzn_id+0.6 if pzn_id==101505
replace pzn_id_mod=pzn_id+0.6 if pzn_id==101770
replace pzn_id_mod=pzn_id+0.6 if pzn_id==104248
replace pzn_id_mod=pzn_id+0.6 if pzn_id==107689
replace pzn_id_mod=pzn_id+0.6 if pzn_id==114933
replace pzn_id_mod=pzn_id+0.6 if pzn_id==114956
replace pzn_id_mod=pzn_id+0.6 if pzn_id==114962
replace pzn_id_mod=pzn_id+0.6 if pzn_id==116990
replace pzn_id_mod=pzn_id+0.6 if pzn_id==122080
replace pzn_id_mod=pzn_id+0.6 if pzn_id==123926
replace pzn_id_mod=pzn_id+0.6 if pzn_id==123932
replace pzn_id_mod=pzn_id+0.6 if pzn_id==164635
replace pzn_id_mod=pzn_id+0.6 if pzn_id==164687
replace pzn_id_mod=pzn_id+0.6 if pzn_id==164701
replace pzn_id_mod=pzn_id+0.6 if pzn_id==164718
replace pzn_id_mod=pzn_id+0.6 if pzn_id==167757
replace pzn_id_mod=pzn_id+0.6 if pzn_id==171084
replace pzn_id_mod=pzn_id+0.6 if pzn_id==171397
replace pzn_id_mod=pzn_id+0.6 if pzn_id==175952
replace pzn_id_mod=pzn_id+0.6 if pzn_id==179565
replace pzn_id_mod=pzn_id+0.6 if pzn_id==181740
replace pzn_id_mod=pzn_id+0.6 if pzn_id==183319
replace pzn_id_mod=pzn_id+0.6 if pzn_id==186677
replace pzn_id_mod=pzn_id+0.6 if pzn_id==189836
replace pzn_id_mod=pzn_id+0.6 if pzn_id==190934
replace pzn_id_mod=pzn_id+0.6 if pzn_id==194205
replace pzn_id_mod=pzn_id+0.6 if pzn_id==194286
replace pzn_id_mod=pzn_id+0.6 if pzn_id==195742
replace pzn_id_mod=pzn_id+0.6 if pzn_id==201566
replace pzn_id_mod=pzn_id+0.6 if pzn_id==224900
replace pzn_id_mod=pzn_id+0.6 if pzn_id==239965
replace pzn_id_mod=pzn_id+0.6 if pzn_id==246586
replace pzn_id_mod=pzn_id+0.6 if pzn_id==246592
replace pzn_id_mod=pzn_id+0.6 if pzn_id==250346
replace pzn_id_mod=pzn_id+0.6 if pzn_id==250352
replace pzn_id_mod=pzn_id+0.6 if pzn_id==250369
replace pzn_id_mod=pzn_id+0.6 if pzn_id==265402
replace pzn_id_mod=pzn_id+0.6 if pzn_id==265431
replace pzn_id_mod=pzn_id+0.6 if pzn_id==271667
replace pzn_id_mod=pzn_id+0.6 if pzn_id==277641
replace pzn_id_mod=pzn_id+0.6 if pzn_id==277658
replace pzn_id_mod=pzn_id+0.6 if pzn_id==278379
replace pzn_id_mod=pzn_id+0.6 if pzn_id==297276
replace pzn_id_mod=pzn_id+0.6 if pzn_id==306584
replace pzn_id_mod=pzn_id+0.6 if pzn_id==312099
replace pzn_id_mod=pzn_id+0.6 if pzn_id==394051
replace pzn_id_mod=pzn_id+0.6 if pzn_id==394068
replace pzn_id_mod=pzn_id+0.6 if pzn_id==405783
replace pzn_id_mod=pzn_id+0.6 if pzn_id==405808
replace pzn_id_mod=pzn_id+0.6 if pzn_id==425018
replace pzn_id_mod=pzn_id+0.6 if pzn_id==425024
replace pzn_id_mod=pzn_id+0.6 if pzn_id==445297
replace pzn_id_mod=pzn_id+0.6 if pzn_id==445771
replace pzn_id_mod=pzn_id+0.6 if pzn_id==457751
replace pzn_id_mod=pzn_id+0.6 if pzn_id==458472
replace pzn_id_mod=pzn_id+0.6 if pzn_id==458621
replace pzn_id_mod=pzn_id+0.6 if pzn_id==458644
replace pzn_id_mod=pzn_id+0.6 if pzn_id==467169
replace pzn_id_mod=pzn_id+0.6 if pzn_id==473951
replace pzn_id_mod=pzn_id+0.6 if pzn_id==474005
replace pzn_id_mod=pzn_id+0.6 if pzn_id==486793
replace pzn_id_mod=pzn_id+0.6 if pzn_id==500837
replace pzn_id_mod=pzn_id+0.6 if pzn_id==500955
replace pzn_id_mod=pzn_id+0.6 if pzn_id==501179
replace pzn_id_mod=pzn_id+0.6 if pzn_id==507934
replace pzn_id_mod=pzn_id+0.6 if pzn_id==516560
replace pzn_id_mod=pzn_id+0.6 if pzn_id==519021
replace pzn_id_mod=pzn_id+0.6 if pzn_id==520171
replace pzn_id_mod=pzn_id+0.6 if pzn_id==535882
replace pzn_id_mod=pzn_id+0.6 if pzn_id==558802
replace pzn_id_mod=pzn_id+0.6 if pzn_id==558819
replace pzn_id_mod=pzn_id+0.6 if pzn_id==558831
replace pzn_id_mod=pzn_id+0.6 if pzn_id==558848
replace pzn_id_mod=pzn_id+0.6 if pzn_id==563743
replace pzn_id_mod=pzn_id+0.6 if pzn_id==563766
replace pzn_id_mod=pzn_id+0.6 if pzn_id==564760
replace pzn_id_mod=pzn_id+0.6 if pzn_id==565937
replace pzn_id_mod=pzn_id+0.6 if pzn_id==581250
replace pzn_id_mod=pzn_id+0.6 if pzn_id==585259
replace pzn_id_mod=pzn_id+0.6 if pzn_id==596464
replace pzn_id_mod=pzn_id+0.6 if pzn_id==600007
replace pzn_id_mod=pzn_id+0.6 if pzn_id==601030
replace pzn_id_mod=pzn_id+0.6 if pzn_id==601047
replace pzn_id_mod=pzn_id+0.6 if pzn_id==604991
replace pzn_id_mod=pzn_id+0.6 if pzn_id==605022
replace pzn_id_mod=pzn_id+0.6 if pzn_id==605499
replace pzn_id_mod=pzn_id+0.6 if pzn_id==605542
replace pzn_id_mod=pzn_id+0.6 if pzn_id==605571
replace pzn_id_mod=pzn_id+0.6 if pzn_id==605602
replace pzn_id_mod=pzn_id+0.6 if pzn_id==620843
replace pzn_id_mod=pzn_id+0.6 if pzn_id==622807
replace pzn_id_mod=pzn_id+0.6 if pzn_id==629956
replace pzn_id_mod=pzn_id+0.6 if pzn_id==665521
replace pzn_id_mod=pzn_id+0.6 if pzn_id==665538
replace pzn_id_mod=pzn_id+0.6 if pzn_id==665544
replace pzn_id_mod=pzn_id+0.6 if pzn_id==665550
replace pzn_id_mod=pzn_id+0.6 if pzn_id==667187
replace pzn_id_mod=pzn_id+0.6 if pzn_id==669252
replace pzn_id_mod=pzn_id+0.6 if pzn_id==705918
replace pzn_id_mod=pzn_id+0.6 if pzn_id==741156
replace pzn_id_mod=pzn_id+0.6 if pzn_id==741162
replace pzn_id_mod=pzn_id+0.6 if pzn_id==741179
replace pzn_id_mod=pzn_id+0.6 if pzn_id==749117
replace pzn_id_mod=pzn_id+0.6 if pzn_id==753509
replace pzn_id_mod=pzn_id+0.6 if pzn_id==791674
replace pzn_id_mod=pzn_id+0.6 if pzn_id==793839
replace pzn_id_mod=pzn_id+0.6 if pzn_id==796499
replace pzn_id_mod=pzn_id+0.6 if pzn_id==817103
replace pzn_id_mod=pzn_id+0.6 if pzn_id==825083
replace pzn_id_mod=pzn_id+0.6 if pzn_id==865728
replace pzn_id_mod=pzn_id+0.6 if pzn_id==893653
replace pzn_id_mod=pzn_id+0.6 if pzn_id==900614
replace pzn_id_mod=pzn_id+0.6 if pzn_id==976681
replace pzn_id_mod=pzn_id+0.6 if pzn_id==976698
replace pzn_id_mod=pzn_id+0.6 if pzn_id==976706
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1122739
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1122745
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1133602
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1133619
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1133654
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1230854
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1234473
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1234510
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1234527
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1237193
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1237371
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1240491
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1240516
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1267751
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1272255
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1281024
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1292625
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1292648
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1292654
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1292849
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1293168
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1293286
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1293292
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1293300
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1293317
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1293323
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1293346
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1293582
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1293808
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1293926
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1294423
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1295115
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1295339
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1295374
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1295428
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1295523
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1295977
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1295983
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1296008
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1296014
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1296020
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1296037
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1296072
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1296089
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1296095
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1296132
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1296155
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1306758
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1348857
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1364164
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1404449
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1410786
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1414784
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1420951
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1421005
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1421040
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1422111
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1422128
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1422163
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1422803
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1422832
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1422915
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1431736
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1431742
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1431759
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1431765
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1440511
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1451124
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1458882
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1476644
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1477299
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1483288
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1497020
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1500124
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1501187
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1501649
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1501939
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1556886
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1562415
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1565810
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1565833
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1565862
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1565916
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1580844
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1596578
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1596584
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1596590
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1628717
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1636125
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1637165
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1640983
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1643906
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1648068
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1660997
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1675131
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1677822
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1678773
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1683395
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1683685
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1683805
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1683811
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1696009
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1744814
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1744820
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1746658
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1746871
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1746894
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1806774
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1807383
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1808885
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1837970
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1838515
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1853319
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1858920
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1869183
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1875278
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1875284
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1875723
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1875798
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1877219
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1896932
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1896949
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1896961
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1896978
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1905335
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1919797
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1925214
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1953021
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2027664
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2027724
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2032458
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2035362
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2037378
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2073641
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2081451
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2084828
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2084834
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2084923
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2096300
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2098457
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2102443
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2119627
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2121570
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2121587
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2121630
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2138553
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2139943
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2140610
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2143212
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2151766
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2151789
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2154836
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2156634
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2157007
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2158969
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2160297
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2160305
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2162310
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2162333
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2170930
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2172952
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2173756
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2173934
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2174460
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2177079
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2177091
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2177286
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2177872
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2185274
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2185280
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2185297
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2186641
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2190654
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2197403
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2198118
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2198124
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2233381
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2236095
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2236907
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2253455
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2255046
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2260030
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2262000
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2262224
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2296973
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2353211
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2354469
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2363994
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2395675
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2395681
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2404730
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2407639
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2408521
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2411204
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2411492
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2411546
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2411581
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2411629
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2411664
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2411701
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2417595
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2419246
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2419252
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2424282
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2424307
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2435015
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2474630
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2475196
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2475500
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2475523
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2483422
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2483439
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2483528
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2484918
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2488649
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2488891
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2488916
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2488922
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2489560
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2497849
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2497855
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2497938
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2498062
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2498168
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2498174
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2498180
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2498257
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2498317
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2498346
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2498352
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2498406
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2498524
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2498530
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2498547
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2498599
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2499044
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2499067
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2508990
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2511733
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2512017
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2512023
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2512046
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2512052
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2512164
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2512170
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2512187
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2512193
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2512201
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2512218
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2512224
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2512230
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2512247
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2512276
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2512282
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2512307
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2512313
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2512336
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2512342
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2512359
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2512365
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2512402
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2512425
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2512460
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2512508
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2512632
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2515317
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2522441
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2522470
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2534071
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2539341
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2539602
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2540663
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2540686
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2542426
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2542461
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2542478
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2542610
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2542627
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2546507
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2546513
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2547582
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2579010
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2583690
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2589296
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2615332
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2620706
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2640620
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2736834
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2736840
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2737503
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2738201
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2743490
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2749587
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2761909
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2762665
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2766841
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2766858
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2766901
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2766918
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2774852
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2803246
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2814735
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2814758
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2814787
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2814801
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2814818
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2814830
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2822775
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2823177
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2824886
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2886108
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2886166
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2886189
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2888320
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3000638
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3001649
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3001655
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3001661
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3001709
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3003430
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3003482
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3004754
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3005305
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3006931
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3011636
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3011642
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3011659
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3011665
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3011671
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3012452
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3013931
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3014089
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3014095
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3014103
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3014149
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3014617
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3014623
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3014764
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3014770
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3022769
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3025555
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3025561
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3029493
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3029518
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3029524
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3032644
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3032650
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3032733
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3032756
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3032762
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3035298
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3035772
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3036866
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3041353
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3042513
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3042536
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3042625
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3043949
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3044699
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3044713
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3045428
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3045641
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3046675
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3047611
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3047628
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3049917
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3049946
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3051765
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3052279
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3052351
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3053066
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3053646
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3057638
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3057934
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3058299
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3062303
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3064130
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3072282
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3072342
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3072448
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3072454
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3072460
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3072661
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3073436
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3073442
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3075151
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3077262
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3079841
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3079953
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3083653
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3085853
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3087208
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3087390
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3088107
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3089199
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3089271
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3089288
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3095047
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3097282
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3097997
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3116128
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3116134
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3116140
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3118860
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3120911
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3125050
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3126138
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3126144
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3128456
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3128901
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3130128
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3133753
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3140546
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3141706
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3141994
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3157274
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3157848
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3171156
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3171185
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3194594
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3197227
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3201785
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3201839
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3202916
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3207782
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3253055
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3253061
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3253078
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3253084
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3253090
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3253109
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3256763
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3300866
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3316560
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3318487
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3318493
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3319854
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3320857
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3323123
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3323287
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3323293
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3323301
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3323703
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3323838
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3332381
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3332659
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3332783
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3332808
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3333481
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3334776
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3335764
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3337438
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3337496
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3337935
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3337941
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3338461
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3338490
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3347767
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3350812
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3351183
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3363559
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3363565
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3372742
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3402561
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3404979
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3410773
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3419277
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3425906
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3430994
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3434118
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3434130
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3435046
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3442974
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3453417
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3464415
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3470634
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3472018
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3472024
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3475229
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3484257
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3487830
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3488048
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3490140
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3491719
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3492498
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3495479
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3497231
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3497248
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3498182
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3498199
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3499520
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3499709
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3499715
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3499721
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3500631
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3501978
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3506786
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3511439
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3513705
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3513734
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3514308
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3514314
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3514320
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3515437
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3516313
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3517318
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3518631
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3518832
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3519346
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3522101
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3524152
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3531376
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3531407
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3539946
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3541067
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3549169
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3551580
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3551605
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3551611
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3551628
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3551982
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3551999
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3552332
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3553024
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3554124
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3558748
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3560946
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3561207
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3561377
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3561609
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3561791
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3563229
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3625947
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3625953
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3625976
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3629017
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3631793
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3631830
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3633941
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3637175
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3637181
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3637318
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3646754
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3650678
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3664516
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3664522
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3664752
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3669146
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3669181
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3669442
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3669459
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3672177
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3673544
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3687210
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3687227
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3722343
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3722461
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3724164
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3740281
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3740306
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3746800
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3746817
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3770885
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3774506
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3796815
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3797766
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3804578
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3811006
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3811704
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3812247
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3812253
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3812276
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3817003
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3820092
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3820100
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3820117
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3820123
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3820815
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3828840
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3829443
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3829526
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3832103
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3835768
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3836621
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3836791
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3837299
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3837371
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3837394
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3837796
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3838117
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3838353
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3838979
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3838985
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3840829
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3852212
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3872120
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3873421
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3874107
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3874478
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3875420
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3876945
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3878447
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3881685
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3888032
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3888109
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3895629
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3905782
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3905813
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3907410
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3916171
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3916797
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3916811
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3920942
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3921077
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3921166
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3921189
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3921195
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3921203
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3921226
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3921232
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3921249
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3926057
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3926465
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3926471
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3926488
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3926494
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3926519
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3926620
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3926637
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3927134
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3929771
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3929788
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3929794
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3935760
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3939516
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3939539
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3952149
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3953189
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3956242
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3962834
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3964744
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3968564
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3970236
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3973884
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3976279
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3976894
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3976925
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3981151
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3981435
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3981441
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3981665
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3981671
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3991681
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3991706
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3993088
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3993355
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3993361
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3994768
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3994805
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3994811
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3994886
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3995199
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4006904
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4013258
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4018066
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4018764
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4022659
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4023185
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4028900
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4086607
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4087570
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4088167
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4088405
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4088411
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4088428
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4088902
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4201600
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4204159
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4216530
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4221270
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4223866
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4224328
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4225049
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4226764
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4227982
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4230613
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4230926
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4232954
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4235941
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4260347
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4267533
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4338411
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4352262
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4361999
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4363113
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4377003
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4386456
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4430312
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4430387
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4430418
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4430559
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4430565
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4430571
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4430967
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4433687
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4433693
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4440279
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4440405
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4442634
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4443390
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4443697
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4445360
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4451610
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4461689
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4461703
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4464104
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4464110
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4464966
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4476320
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4476797
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4477880
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4491590
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4491609
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4491615
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4492520
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4559632
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4559804
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4559810
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4560227
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4563941
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4563958
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4563964
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4563970
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4564490
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4565466
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4565532
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4566307
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4567057
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4567235
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4568223
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4569116
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4569197
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4569837
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4570065
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4570415
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4570421
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4570740
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4570786
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4572934
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4576837
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4579669
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4597443
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4597905
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4607822
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4611769
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4612214
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4616910
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4616933
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4616956
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4617039
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4617051
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4617074
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4617223
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4617246
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4617252
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4617275
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4617281
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4617298
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4617312
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4620403
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4620774
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4622520
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4622603
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4622626
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4646070
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4648525
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4650812
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4651007
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4655749
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4655755
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4657197
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4657205
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4664240
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4664524
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4664553
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4675077
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4675516
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4678070
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4679365
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4680121
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4692147
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4744329
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4745300
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4745346
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4745412
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4761345
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4771177
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4771183
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4771562
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4777530
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4777607
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4777955
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4777984
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4790536
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4790542
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4790588
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4798880
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4808414
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4808420
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4815779
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4824212
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4824264
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4824293
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4825111
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4825140
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4825298
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4828693
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4831560
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4832909
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4832944
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4833139
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4833323
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4835026
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4851077
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4851108
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4851114
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4851574
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4851597
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4854058
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4854549
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4854710
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4854839
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4854851
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4854880
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4854940
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4855419
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4862052
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4862129
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4862276
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4862282
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2198319
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3629945
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3673662
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3758499
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3956354
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4616991
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4617016
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4617022
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4646093
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4676295
replace pzn_id_mod=pzn_id+0.6 if pzn_id==459394
replace pzn_id_mod=pzn_id+0.6 if pzn_id==1240634
replace pzn_id_mod=pzn_id+0.6 if pzn_id==2200186
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3010915
replace pzn_id_mod=pzn_id+0.6 if pzn_id==3626734
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4862299
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4868190
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4868474
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4873535
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4878024
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4878395
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4878403
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4887951
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4900114
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4903940
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4904052
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4904951
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4904968
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4904974
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4906335
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4908185
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4908216
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4911690
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4913588
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4913594
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4913602
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4918947
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4918953
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4919094
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4920068
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4920217
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4921820
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4921889
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4922593
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4922601
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4922618
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4924646
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4926616
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4929218
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4929224
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4929721
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4943164
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4943170
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4954618
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4955351
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4963215
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4963244
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4964485
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4968595
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4968856
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4968916
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4968939
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4968945
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4968951
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4971918
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4973030
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4973047
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4973076
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4977039
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4981549
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4981762
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4995184
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4995209
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4995936
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4998633
replace pzn_id_mod=pzn_id+0.6 if pzn_id==6973034
replace pzn_id_mod=pzn_id+0.6 if pzn_id==6349005
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4898647
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4898682
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4898699
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4916701
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4998917
replace pzn_id_mod=pzn_id+0.6 if pzn_id==4998998

*identify changes in the producer selling retail form
by pzn_id_mod, sort: egen pzn_index_db05=count(pzn_id_mod)
tab pzn_index_db05
generate prod_change=0 
replace prod_change=1 if pzn_index_db05!=1
tab prod_change

generate pzn_diff=0
replace pzn_diff=1 if pzn_id!=pzn_id_mod
tab pzn_diff
generate pzn_diff_db05=pzn_diff

*Difference in 2059 (1930 unique) cases
egen check=group(pzn_id) if pzn_diff==1
sum check
drop check

*unique identifier: pzn_id_string pzn_diff hst_hist_id_string
sort pzn_id_string pzn_diff hst_hist_id_string
save hist_db05, replace


*** end of do file


