***********************Conditional pass-through*****************

clear
clear matrix
clear mata

set matsize 10000
set maxvar 10000

**Using Northern California stores
local area 6
use temp`area', clear

bysort oparea upc_id: gen counter=_n
replace counter=0 if counter~=1

drop if nrev<0

****create brand shares
*drop the 12 digit categories
drop if upc_id>=100000000000

*********IF 11 digits want to knock off the first one
gen first=floor(upc_id/10000000000)
gen firstfive=floor(upc_id/100000) 
replace firstfive=firstfive-(first*100000) if first>0
drop first


**PL info

**why are categories missing?
merge m:1 upc_id using classify_upc_all
tab _merge
keep if _merge==3
drop _merge

merge m:1 upc_id using pl_data, keepusing(pl)
drop _merge

drop if grev==.

replace pl=0 if pl==.
replace pl=0 if firstfive==70378
replace pl=0 if firstfive==88110

replace firstfive=1 if pl==1
replace firstfive=1 if firstfive==21130 | firstfive==58200 | firstfive==58203 | firstfive==79893 
replace pl=1 if firstfive==1

*single brand for pl
bysort firstfive: egen bupcs=total(counter)

***create brand shares*** 
foreach j in subsubclass_id subclass_id class_id category_id group_id{
sort oparea `j' firstfive
by oparea `j' firstfive: egen totrev_`j'=total(nrev*counter)
by oparea `j': egen tot`j'=total(nrev*counter)
gen bshare_`j'=totrev_`j'/tot`j'
gen share_`j'=nrev/tot`j'
drop tot`j' totrev_`j'
}

*****dropping rare products? dropping irrelevant categories?
bysort category_id: egen upctot=total(counter)
bysort category_id: egen safeupctot=total(counter*pl)


bysort category_id: gen catcounter=_n
bysort oparea upc_id: gen nummonths=_N


***first filter? drop 48 categories with no pl products
drop if safeupctot==0
keep if nummonths==41
drop nummonths



****Need to fix VI categories as well
*categories that should be VI
drop vi
gen vi=0
replace vi=1 if category_id==405 | category_id==801 | category_id==820 | category_id==2135 | category_id==2835 | category_id==2970 | category_id==201 | category_id==202 | group_id==96 | category_id==3601 | category_id==3620 | category_id==3625 | category_id==3630 | category_id==4201 | category_id==4205

*These are:
*405: jams/jellies/preserves
*801: carbonated soft drinks
*820: bottled water
*2135: tomato paste/sauce/puree
*2835: shelf stable pasta and pizza sauce
*2970: hispanic salsa
*201: cookies
*202: crackers
*96XX: commercial breads  (not in-store)
*3601: milk
*3620: sour cream
*3625: cottage cheese
*3630: refrigerated yogurts
*4201: packaged ice cream
*4205: frozen novelties

gen pl_nonvi=0
replace pl_nonvi=1 if pl==1 & vi==0

gen pl_vi=0
replace pl_vi=1 if pl==1 & vi==1


****creating indexes (weighted and unweighted) -- can also do them at the group level



*now create wc index
foreach j in group_id{
sort oparea `j' month
by oparea `j' month: egen wcindex_uw_`j'=mean(wcost)
}



****looking at select groups?
**which are groups with high pass-through?

merge m:1 month using com_single

****assign manually

gen com=dairy if category_id==3601 | category_id==3610 | category_id==3615 
replace com=wheat if group_id==96 
replace com=corn if category_id==801 
replace com=tomato if category_id==2835 | category_id==2130 | category_id==2135 | category_id==501 | category_id==2970


****Generate one period changes for identification of major price changes****
sort oparea upc_id month
gen dgp0=log(gprice)-log(gprice[_n-1]) if upc_id==upc_id[_n-1]
gen dwc0=log(wcost)-log(wcost[_n-1]) if upc_id==upc_id[_n-1]

summ dgp0 dwc0, detail

foreach j in gprice{
gen ch`j'5=0
replace ch`j'5=1 if abs(dgp0)>0.05
gen ch`j'10=0
replace ch`j'10=1 if abs(dgp0)>0.1
}

foreach j in wcost{
gen ch`j'5=0
replace ch`j'5=1 if abs(dwc0)>0.05
gen ch`j'10=0
replace ch`j'10=1 if abs(dwc0)>0.1
}


summ ch*

***to construct spells, we want to calculate price (and com) change from moment price first changes to next change
***this will require multiple spells
***goods whose prices never change?

**could start in first period? but that would be sort of weird too



local j gprice
local spell ch`j'5

sort upc_id `spell' month
gen dgpspell5=log(gprice)-log(gprice[_n-1]) if upc_id==upc_id[_n-1] & `spell'==1 & `spell'[_n-1]==1
gen dgpspell5_wc=log(wcost)-log(wcost[_n-1]) if upc_id==upc_id[_n-1] & `spell'==1 & `spell'[_n-1]==1
gen dgpspell5_wci=log(wcindex_uw_group_id)-log(wcindex_uw_group_id[_n-1]) if upc_id==upc_id[_n-1] & `spell'==1 & `spell'[_n-1]==1
gen dgpspell5_com=log(com)-log(com[_n-1]) if upc_id==upc_id[_n-1] & `spell'==1 & `spell'[_n-1]==1

gen dum`spell'=0
replace dum`spell'=1 if `spell'==1 & `spell'[_n-1]==1
gen t`spell'=.
replace t`spell'=month-month[_n-1] if upc_id==upc_id[_n-1] & `spell'==1 & `spell'[_n-1]==1


local spell ch`j'10
sort upc_id `spell' month
gen dgpspell10=log(gprice)-log(gprice[_n-1]) if upc_id==upc_id[_n-1] & `spell'==1 & `spell'[_n-1]==1
gen dgpspell10_wc=log(wcost)-log(wcost[_n-1]) if upc_id==upc_id[_n-1] & `spell'==1 & `spell'[_n-1]==1
gen dgpspell10_wci=log(wcindex_uw_group_id)-log(wcindex_uw_group_id[_n-1]) if upc_id==upc_id[_n-1] & `spell'==1 & `spell'[_n-1]==1
gen dgpspell10_com=log(com)-log(com[_n-1]) if upc_id==upc_id[_n-1] & `spell'==1 & `spell'[_n-1]==1
gen dum`spell'=0
replace dum`spell'=1 if `spell'==1 & `spell'[_n-1]==1
gen t`spell'=.
replace t`spell'=month-month[_n-1] if upc_id==upc_id[_n-1] & `spell'==1 & `spell'[_n-1]==1



local j wcost
local spell ch`j'5
sort upc_id `spell' month
gen dwcspell5=log(wcost)-log(wcost[_n-1]) if upc_id==upc_id[_n-1] & `spell'==1 & `spell'[_n-1]==1
gen dwcspell5_wci=log(wcindex_uw_group_id)-log(wcindex_uw_group_id[_n-1]) if upc_id==upc_id[_n-1] & `spell'==1 & `spell'[_n-1]==1
gen dwcspell5_com=log(com)-log(com[_n-1]) if upc_id==upc_id[_n-1] & `spell'==1 & `spell'[_n-1]==1
gen dum`spell'=0
replace dum`spell'=1 if `spell'==1 & `spell'[_n-1]==1
gen t`spell'=.
replace t`spell'=month-month[_n-1] if upc_id==upc_id[_n-1] & `spell'==1 & `spell'[_n-1]==1



local spell ch`j'10
sort upc_id `spell' month
gen dwcspell10=log(wcost)-log(wcost[_n-1]) if upc_id==upc_id[_n-1] & `spell'==1 & `spell'[_n-1]==1
gen dwcspell10_wci=log(wcindex_uw_group_id)-log(wcindex_uw_group_id[_n-1]) if upc_id==upc_id[_n-1] & `spell'==1 & `spell'[_n-1]==1
gen dwcspell10_com=log(com)-log(com[_n-1]) if upc_id==upc_id[_n-1] & `spell'==1 & `spell'[_n-1]==1
gen dum`spell'=0
replace dum`spell'=1 if `spell'==1 & `spell'[_n-1]==1
gen t`spell'=.
replace t`spell'=month-month[_n-1] if upc_id==upc_id[_n-1] & `spell'==1 & `spell'[_n-1]==1





**allow for category-specific time-trends?
drop if upc_id==.
cap: egen upc=group(upc_id)

bysort upc_id: egen nspell=total(chgprice5)


*pooled commodity
gen comcat=0
replace comcat=1 if category_id==3601 | category_id==3610 | category_id==3615 
replace comcat=1 if category_id==801 
replace comcat=1 if group_id==96 
replace comcat=1 if category_id==2835 | category_id==2130 | category_id==2135 | category_id==501 | category_id==2970



*set threshold for price change spells to to 5%
local cut=5
local cluslevel upc_id

local abslevel one
local level subclass_id
local blevel category_id
local hetlevel category_id
local index dgpspell`cut'_com
local yvar dgpspell`cut'
cap: drop int*
gen intpl_vi=pl_vi*`index'
gen intpl_nonvi=pl_nonvi*`index'
gen intshare=share_`level'*`index'
gen intbshare=bshare_`blevel'*`index'


local restrict if comcat==1 & nspell<14

local excontrol c.tchgprice`cut' c.tchgprice`cut'#pl_vi c.tchgprice`cut'#pl_nonvi 
areg `yvar' `excontrol' `index' i.`hetlevel'#c.`index' intpl_vi intpl_nonvi `restrict', absorb(`abslevel') vce(cluster `cluslevel')
outreg2 using lrpt.tex,  keep(`index' intpl_vi intpl_nonvi) replace ctitle(com)

local excontrol c.tchgprice`cut' c.tchgprice`cut'#pl_vi c.tchgprice`cut'#pl_nonvi  c.tchgprice`cut'#c.share_`level' c.tchgprice`cut'#c.bshare_`blevel'
areg `yvar' `excontrol' `index' i.`hetlevel'#c.`index' int* `restrict', absorb(`abslevel') vce(cluster `cluslevel')
outreg2 using lrpt.tex,  keep(`index' intpl_vi intpl_nonvi intshare intbshare) append ctitle(com)




*****wc to retail/wholesale prices

local level subclass_id
local blevel category_id
local hetlevel category_id
local index dgpspell`cut'_wc
local yvar dgpspell`cut'

cap: drop int*

gen intpl_vi=pl_vi*`index'
gen intpl_nonvi=pl_nonvi*`index'
gen intshare=share_`level'*`index'
gen intbshare=bshare_`blevel'*`index'


local excontrol c.tchgprice`cut' c.tchgprice`cut'#pl_vi c.tchgprice`cut'#pl_nonvi 
areg `yvar' `excontrol' intpl_vi intpl_nonvi i.`hetlevel'#c.`index'  if nspell<14 , absorb(`abslevel') vce(cluster `cluslevel')
outreg2 using lrpt.tex,  keep(intpl_vi intpl_nonvi) append ctitle(wc)

local excontrol c.tchgprice`cut' c.tchgprice`cut'#pl_vi c.tchgprice`cut'#pl_nonvi  c.tchgprice`cut'#c.share_`level' c.tchgprice`cut'#c.bshare_`blevel'
areg `yvar' `excontrol' int* i.`hetlevel'#c.`index'  if nspell<14, absorb(`abslevel') vce(cluster `cluslevel')
outreg2 using lrpt.tex,  keep(intpl_vi intpl_nonvi intshare intbshare) append ctitle(wc)


