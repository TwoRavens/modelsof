***********Two-step***********
cd "D:\pl data\rawdata"


***estimating pass-through separately for each of 9 divisions in a loop****

forvalues area=1(1)9{
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


*individual prices first, category pt


local period 12
sort oparea upc_id month
by oparea upc_id: gen dgprice`period'=log(gprice)-log(gprice[_n-`period']) if month==month[_n-`period']+`period' & upc_id==upc_id[_n-`period'] & oparea==oparea[_n-`period']
by oparea upc_id: gen dwcost`period'=log(wcost)-log(wcost[_n-`period'])  if month==month[_n-`period']+`period' & upc_id==upc_id[_n-`period'] & oparea==oparea[_n-`period']


foreach j in group_id{
by oparea upc_id: gen dwindex`period'_uw_`j'=log(wcindex_uw_`j')-log(wcindex_uw_`j'[_n-`period']) if month==month[_n-`period']+`period' & upc_id==upc_id[_n-`period'] & oparea==oparea[_n-`period']
}





****looking at select groups?
**which are groups with high pass-through?

merge m:1 month using com_single
drop _merge


****assign manually

gen com=dairy if category_id==3601 | category_id==3610 | category_id==3615 
replace com=wheat if group_id==96 
replace com=corn if category_id==801 
replace com=tomato if category_id==2835 | category_id==2130 | category_id==2135 | category_id==501 | category_id==2970


forvalues j=1(1)12{
gen com`j'=dairy`j' if category_id==3601 | category_id==3610 | category_id==3615 
replace com`j'=wheat`j' if group_id==96 
replace com`j'=corn`j' if category_id==801 
replace com`j'=tomato`j' if category_id==2835 | category_id==2130 | category_id==2135 | category_id==501 | category_id==2970
}


***looking at commodity prices
local period 12
sort oparea upc_id month
by oparea upc_id: gen dcom`period'=log(com)-log(com[_n-`period']) if month==month[_n-`period']+`period'


****Generate lags of single period indexes****
sort oparea upc_id month
gen dgp0=log(gprice)-log(gprice[_n-1]) if upc_id==upc_id[_n-1]
gen dwc0=log(wcost)-log(wcost[_n-1]) if upc_id==upc_id[_n-1]
gen dwindex0=log(wcindex_uw_group_id)-log(wcindex_uw_group_id[_n-1]) if upc_id==upc_id[_n-1]

gen com0=com

forvalues j=0(1)11{
local k=`j'+1
gen dc`j'=log(com`j')-log(com`k')
}

forvalues j=1(1)11{
gen dwindex`j'=dwindex0[_n-`j'] if upc_id==upc_id[_n-`j']
}

aorder




*****generate pass-through for each upc

**commodity pass-through
**group wcindex pass-through

egen upc=group(upc_id)
egen upcmax=max(upc)

gen ptgpcom=.
gen ptwccom=.
gen ptgpind=.

gen ptgpcomlag=.
gen ptwccomlag=.
gen ptgpindlag=.


local maxupc=upcmax[1]


forvalues j=1(1)`maxupc'{
*dis `j'
*rw
cap: reg dgprice12 dcom12 if upc==`j'
cap: replace ptgpcom=_b[dcom12] if upc==`j'
cap: reg dwcost12 dcom12 if upc==`j'
cap: replace ptwccom=_b[dcom12] if upc==`j'
cap: reg dgprice12 dwindex12_uw_group_id if upc==`j'
cap: replace ptgpind=_b[dwindex12_uw_group_id] if upc==`j'
*lagged
cap: reg dgp0 dc0-dc11 if upc==`j'
cap: replace ptgpcomlag=_b[dc0]+_b[dc1]+_b[dc2]+_b[dc3]+_b[dc4]+_b[dc5]+_b[dc6]+_b[dc7]+_b[dc8]+_b[dc9]+_b[dc10]+_b[dc11] if upc==`j' 
cap: reg dwc0 dc0-dc11 if upc==`j'
cap: replace ptwccomlag=_b[dc0]+_b[dc1]+_b[dc2]+_b[dc3]+_b[dc4]+_b[dc5]+_b[dc6]+_b[dc7]+_b[dc8]+_b[dc9]+_b[dc10]+_b[dc11] if upc==`j' 
cap: reg dgp0 dwindex0-dwindex11 if upc==`j'
cap: replace ptgpindlag=_b[dwindex0]+_b[dwindex1]+_b[dwindex2]+_b[dwindex3]+_b[dwindex4]+_b[dwindex5]+_b[dwindex6]+_b[dwindex7]+_b[dwindex8]+_b[dwindex9]+_b[dwindex10]+_b[dwindex11] if upc==`j' 
}


duplicates drop upc_id, force
keep upc_id pt* oparea pl_vi pl_nonvi group_id category_id class_id subclass_id subsubclass_id bshare_* share_* gprice nprice wcost
save pttwo_temp`area', replace

}







*****analyzing first-stage estimates

use pttwo_temp1, clear
forvalues j=2(1)9{
append using pttwo_temp`j'
}

foreach j in ptgpind ptgpindlag ptgpcom ptwccom ptgpcomlag ptwccomlag{
bysort upc_id: egen avg`j'=median(`j')
}

summ ptgpind ptgpindlag ptgpcom ptwccom ptgpcomlag ptwccomlag, detail


***drop the 10% tails
foreach j in ptgpind ptgpindlag ptgpcom ptwccom ptgpcomlag ptwccomlag{
replace `j'=. if `j'==0
egen `j'upper=pctile(`j'), p(90)
egen `j'lower=pctile(`j'), p(10)
gen in`j'=0
replace in`j'=1 if `j'>`j'lower & `j'<`j'upper
}





******Table 5***********

****Subclass fixed effects (columns 1-4)


local group subclass_id
local share share_`group'

foreach j in ptgpind{
local restrict if oparea==6 & in`j'==1
areg `j' pl_vi pl_nonvi i.oparea `restrict', absorb(`group') vce(cluster upc_id)
outreg2 using robust1.tex,  keep(pl_vi pl_nonvi) replace ctitle(sclass)
areg `j' pl_vi pl_nonvi i.oparea `share' `restrict', absorb(`group') vce(cluster upc_id) 
outreg2 using robust1.tex,  keep(pl_vi pl_nonvi `share') append ctitle(sclass)
}



foreach j in ptgpcomlag ptgpcom ptwccomlag ptwccom{
bysort subsubclass_id: egen ms`j'=median(`j')
}

summ m*, detail

gen gcat=0
replace gcat=1 if category_id==3601 | category_id==3610 | category_id==3615 
replace gcat=1 if category_id==801 
replace gcat=1 if group_id==96 
replace gcat=1 if category_id==2835 | category_id==2130 | category_id==2135 | category_id==501 | category_id==2970

local group subclass_id
local share share_`group'
local bshare bshare_`group'



foreach j in ptgpcom{
local restrict if gcat==1 & oparea==6 & in`j'==1

areg `j' pl_vi pl_nonvi i.oparea `restrict', absorb(`group') vce(cluster upc_id)
outreg2 using robust1.tex,  keep(pl_vi pl_nonvi) append ctitle(com sclass)
areg `j' pl_vi pl_nonvi i.oparea `share' `bshare' `restrict', absorb(`group') vce(cluster upc_id)
outreg2 using robust1.tex,  keep(pl_vi pl_nonvi `share' `bshare') append ctitle(com sclass)
}



**Lagged first-stage pass-through (columns 5-6)

cap: drop gcat
gen gcat=0
replace gcat=1 if category_id==3601 | category_id==3610 | category_id==3615 
replace gcat=1 if category_id==801 
replace gcat=1 if group_id==96 
replace gcat=1 if category_id==2835 | category_id==2130 | category_id==2135 | category_id==501 | category_id==2970

local group category_id
local share share_subclass_id
local bshare bshare_category_id


foreach j in ptwccomlag{
local restrict if oparea==6 & gcat==1 & in`j'==1
areg `j' pl_vi pl_nonvi i.oparea `restrict', absorb(`group') vce(cluster upc_id)
outreg2 using robust1.tex,  keep(pl_vi pl_nonvi) append ctitle(lag)
areg `j' pl_vi pl_nonvi i.oparea `share' `bshare' `restrict', absorb(`group') vce(cluster upc_id)
outreg2 using robust1.tex,  keep(pl_vi pl_nonvi `share' `bshare') append ctitle(lag)
}

***Pooling across areas, with upc fixed effects (column 7)

local group upc_id
local share share_subclass_id
local bshare bshare_category_id
foreach j in ptgpcom {
local restrict if gcat==1 & in`j'==1
areg `j' i.oparea `bshare' `share' `restrict', absorb(`group') vce(robust)
outreg2 using robust1.tex,  keep(`bshare' `share') append ctitle(`j')
}

