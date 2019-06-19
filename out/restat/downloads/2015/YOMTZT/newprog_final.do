*****more filtering
*note: Northern California corresponds to area 6

cd "DIRECTORY"


use temp6, clear


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


****PL and classification info
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
foreach j in subclass_id category_id group_id{
sort oparea `j' firstfive
by oparea `j' firstfive: egen totrev_`j'=total(nrev*counter)
by oparea `j': egen tot`j'=total(nrev*counter)
gen bshare_`j'=totrev_`j'/tot`j'
gen share_`j'=nrev/tot`j'
drop tot`j' totrev_`j'
}

*****dropping rare products? dropping irrelevant categories?
bysort category_id: egen upctot=total(counter)
bysort category_id: egen plupctot=total(counter*pl)


bysort category_id: gen catcounter=_n
bysort oparea upc_id: gen nummonths=_N

***first filter? drop categories with no pl products
drop if plupctot==0

***only use the products available in every month
keep if nummonths==41
drop nummonths


****Categories where PL are vertically integrated:
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

gen vi=0
replace vi=1 if category_id==405 | category_id==801 | category_id==820 | category_id==2135 | category_id==2835 | category_id==2970 | category_id==201 | category_id==202 | group_id==96 | category_id==3601 | category_id==3620 | category_id==3625 | category_id==3630 | category_id==4201 | category_id==4205


gen pl_nonvi=0
replace pl_nonvi=1 if pl==1 & vi==0

gen pl_vi=0
replace pl_vi=1 if pl==1 & vi==1


****creating unweighted price/cost indexes 

foreach j in subclass_id category_id group_id{
sort oparea `j' month
by oparea `j' month: egen gpindex_uw_`j'=mean(gprice)
by oparea `j' month: egen npindex_uw_`j'=mean(nprice)
by oparea `j' month: egen wcindex_uw_`j'=mean(wcost)
}




***Generate differences in log prices over 6 and 12 month horizons

local period 6
sort oparea upc_id month
by oparea upc_id: gen dgprice`period'=log(gprice)-log(gprice[_n-`period']) if month==month[_n-`period']+`period' & upc_id==upc_id[_n-`period'] & oparea==oparea[_n-`period']
by oparea upc_id: gen dnprice`period'=log(nprice)-log(nprice[_n-`period']) if month==month[_n-`period']+`period' & upc_id==upc_id[_n-`period'] & oparea==oparea[_n-`period']
by oparea upc_id: gen dwcost`period'=log(wcost)-log(wcost[_n-`period'])  if month==month[_n-`period']+`period' & upc_id==upc_id[_n-`period'] & oparea==oparea[_n-`period']


foreach j in subclass_id category_id group_id{
by oparea upc_id: gen dwindex`period'_uw_`j'=log(wcindex_uw_`j')-log(wcindex_uw_`j'[_n-`period']) if month==month[_n-`period']+`period' & upc_id==upc_id[_n-`period'] & oparea==oparea[_n-`period']
by oparea upc_id: gen dpindex`period'_uw_`j'=log(gpindex_uw_`j')-log(gpindex_uw_`j'[_n-`period']) if month==month[_n-`period']+`period' & upc_id==upc_id[_n-`period'] & oparea==oparea[_n-`period']


}


local period 12
sort oparea upc_id month
by oparea upc_id: gen dgprice`period'=log(gprice)-log(gprice[_n-`period']) if month==month[_n-`period']+`period' & upc_id==upc_id[_n-`period'] & oparea==oparea[_n-`period']
by oparea upc_id: gen dnprice`period'=log(nprice)-log(nprice[_n-`period']) if month==month[_n-`period']+`period' & upc_id==upc_id[_n-`period'] & oparea==oparea[_n-`period']
by oparea upc_id: gen dwcost`period'=log(wcost)-log(wcost[_n-`period'])  if month==month[_n-`period']+`period' & upc_id==upc_id[_n-`period'] & oparea==oparea[_n-`period']


foreach j in subclass_id category_id group_id{
by oparea upc_id: gen dwindex`period'_uw_`j'=log(wcindex_uw_`j')-log(wcindex_uw_`j'[_n-`period']) if month==month[_n-`period']+`period' & upc_id==upc_id[_n-`period'] & oparea==oparea[_n-`period']
by oparea upc_id: gen dpindex`period'_uw_`j'=log(gpindex_uw_`j')-log(gpindex_uw_`j'[_n-`period']) if month==month[_n-`period']+`period' & upc_id==upc_id[_n-`period'] & oparea==oparea[_n-`period']

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



***differences in commodity prices over 6 and 12 month horizons
local period 12
sort oparea upc_id month
by oparea upc_id: gen dcom`period'=log(com)-log(com[_n-`period']) if month==month[_n-`period']+`period'

local period 6
by oparea upc_id: gen dcom`period'=log(com)-log(com[_n-`period']) if month==month[_n-`period']+`period'


****Commodity matched sample
gen comcat=0
replace comcat=1 if category_id==3601 | category_id==3610 | category_id==3615 
replace comcat=1 if category_id==801 
replace comcat=1 if group_id==96 
replace comcat=1 if category_id==2835 | category_id==2130 | category_id==2135 | category_id==501 | category_id==2970



***summary stats
bysort upc_id: gen upccounter=_n
replace upccounter=. if upccounter~=1


gen type=1
replace type=2 if pl_nonvi==1
replace type=3 if pl_vi==1

*calculate relative to national brands?
*within subclass?
foreach j in gprice wcost{
bysort upc_id: egen a`j'=mean(`j')
bysort type subclass: egen ma`j'=mean(a`j'*upccounter)
gen bma`j'=ma`j' if type==1
bysort subclass: egen basema`j'=min(bma`j')
gen rel`j'=ma`j'/basema`j'
}

bysort type subclass_id: egen ucount_s=total(upccounter)
bysort type category_id: egen ucount_cat=total(upccounter)

local list ucount* relgprice relwcost share_subclass_id bshare_category_id

bysort type: summ `list' if upccounter==1, detail
bysort type: summ `list' if comcat==1 & upccounter==1, detail

corr pl_vi pl_nonvi share_subclass_id share_category_id bshare_category_id if upccounter==1
corr pl_vi pl_nonvi share_subclass_id share_category_id bshare_category_id if upccounter==1 & comcat==1

*what other stats to post?
gen lnamkup=log(agprice/awcost)
gen lnpshare=log(share_subclass_id)
gen lnbshare=log(bshare_category_id)
gen lnacost=log(awcost)

*correlation of markups and shares
areg lnamkup lnpshare lnbshare if upccounter==1, absorb(category_id)
areg lnamkup lnpshare lnbshare if upccounter==1, absorb(subclass_id)

areg lnacost lnpshare lnbshare if upccounter==1, absorb(category_id)
areg lnacost lnpshare lnbshare if upccounter==1, absorb(subclass_id)






*milk, bread, tomatoes, soft drinks, 

foreach level in group_id category_id{
foreach j in gpindex_uw_`level' wcindex_uw_`level' gpindex_w_`level' wcindex_w_`level' npindex_w_`level' npindex_uw_`level' dairy meat sugar tomato corn wheat coffee{
cap: gen b`j'=`j' if month==1
cap bysort `level': egen base`j'=min(b`j')
cap: gen rb`j'=`j'/base`j'
}
}

local gp rbgpindex_uw
local wc rbwcindex_uw




*Figure 1


*could do by category. or by group?
set scheme s1mono
twoway (line dcom12 month if category_id==3601, sort xtitle(Month (Jan 2004=1)) ytitle(12 month % change) title(Milk-Dairy) legend(order(1 "Commodity" 2 "Retail" 3 "Wholesale"))) (line dpindex12_uw_category_id month if category_id==3601, sort lpattern(dash) lcolor(black) yaxis(2)) (line dwindex12_uw_category_id month if category_id==3601, sort lpattern(dot) lcolor(black) yaxis(2))
graph save milk2, replace
twoway (line dcom12 month if group_id==96,  sort xtitle(Month (Jan 2004=1)) ytitle(12 month % change) title(Wheat-Bread) legend(order(1 "Commodity" 2 "Retail" 3 "Wholesale"))) (line dpindex12_uw_group_id month if group_id==96, sort lpattern(dash) lcolor(black) yaxis(2)) (line dwindex12_uw_group_id month if group_id==96, sort lpattern(dot) lcolor(black) yaxis(2))
graph save wheat2, replace
twoway (line dcom12 month if category_id==801, sort xtitle(Month (Jan 2004=1)) ytitle(12 month % change) title(Corn-Soft drinks) legend(order(1 "Commodity" 2 "Retail" 3 "Wholesale"))) (line dpindex12_uw_category_id month if category_id==801, sort lpattern(dash) lcolor(black) yaxis(2)) (line dwindex12_uw_category_id month if category_id==801, sort lpattern(dot) lcolor(black) yaxis(2))
graph save corn2, replace
twoway (line dcom12 month if category_id==2130, sort xtitle(Month (Jan 2004=1)) ytitle(12 month % change) title(Tomato-Paste/Sauce/Puree) legend(order(1 "Commodity" 2 "Retail" 3 "Wholesale"))) (line dpindex12_uw_category_id month if category_id==2135, sort lpattern(dash) lcolor(black) yaxis(2)) (line dwindex12_uw_category_id month if category_id==2135, sort lpattern(dot) lcolor(black) yaxis(2))
graph save tomato2, replace

graph combine milk2.gph corn2.gph wheat2.gph tomato2.gph, altshrink
graph export com_pt2.png, replace



bysort category_id month: gen catmonthcounter=_n



***Table 2****

***Group by group results***
***Table 2 Panel A***

local period 12

local level subclass_id
local blevel category_id
local hetlevel category_id
local index dcom`period'
local yvar dgprice`period'
local yvar2 dpindex`period'_uw_`hetlevel'
cap: drop int*
gen intpl_vi=pl_vi*`index'
gen intpl_nonvi=pl_nonvi*`index'
gen intshare=share_`level'*`index'
gen intbshare=bshare_`blevel'*`index'

local restrict if category_id==3601 | category_id==3610 | category_id==3615 

reg `yvar2' `index' if category_id==3601 & catmonthcounter==1
outreg2 using compt.tex,  keep(`index') replace ctitle(Milk)
areg `yvar' `index' i.`hetlevel'#c.`index' intpl_vi intpl_nonvi `restrict', absorb(upc_id) vce(cluster upc_id)
outreg2 using compt.tex,  keep(`index' intpl_vi intpl_nonvi) append ctitle()
areg `yvar' `index' i.`hetlevel'#c.`index' int* share_`level' bshare_`blevel' `restrict', absorb(upc_id) vce(cluster upc_id)
outreg2 using compt.tex,  keep(`index' intpl_vi intpl_nonvi intshare intbshare) append ctitle()


reg `yvar2' `index' if (category_id==2835) & catmonthcounter==1
outreg2 using compta.tex,  keep(`index') append ctitle(Tomato)
local restrict if category_id==2835 | category_id==2130 | category_id==2135 | category_id==501 | category_id==2970
areg `yvar' `index' i.`hetlevel'#c.`index' intpl_vi intpl_nonvi `restrict', absorb(upc_id) vce(cluster upc_id)
outreg2 using compta.tex,  keep(`index' intpl_vi intpl_nonvi) append ctitle()
areg `yvar' `index' i.`hetlevel'#c.`index' int* share_`level' bshare_`blevel' `restrict', absorb(upc_id) vce(cluster upc_id)
outreg2 using compta.tex,  keep(`index' intpl_vi intpl_nonvi intshare intbshare) append ctitle()





****Pooled commodities
***Table 2: Panel B***

local period 12

local level category_id
local blevel category_id
local hetlevel category_id
local index dcom`period'
local yvar2 dwindex`period'_uw_`hetlevel'
cap: drop int*
gen intpl_vi=pl_vi*`index'
gen intpl_nonvi=pl_nonvi*`index'
gen intshare=share_`level'*`index'
gen intbshare=bshare_`blevel'*`index'



local restrict if comcat==1


local yvar dgprice`period'
areg `yvar' `index' i.`hetlevel'#c.`index' intpl_vi intpl_nonvi `restrict', absorb(upc_id) vce(cluster upc_id)
outreg2 using comptb.tex,  keep(intpl_vi intpl_nonvi) replace ctitle(`yvar')
areg `yvar' `index' i.`hetlevel'#c.`index' int* share_`level' bshare_`blevel' `restrict', absorb(upc_id) vce(cluster upc_id)
outreg2 using comptb.tex,  keep(intpl_vi intpl_nonvi intshare intbshare) append ctitle(`yvar')

local yvar dnprice`period'
areg `yvar' `index' i.`hetlevel'#c.`index' intpl_vi intpl_nonvi `restrict', absorb(upc_id) vce(cluster upc_id)
outreg2 using comptb.tex,  keep(intpl_vi intpl_nonvi) append ctitle(`yvar')
areg `yvar' `index' i.`hetlevel'#c.`index' int* share_`level' bshare_`blevel' `restrict', absorb(upc_id) vce(cluster upc_id)
outreg2 using comptb.tex,  keep(intpl_vi intpl_nonvi intshare intbshare) append ctitle(`yvar')

local yvar dwcost`period'
areg `yvar' `index' i.`hetlevel'#c.`index' intpl_vi intpl_nonvi `restrict', absorb(upc_id) vce(cluster upc_id)
outreg2 using comptb.tex,  keep(intpl_vi intpl_nonvi) append ctitle(`yvar')
areg `yvar' `index' i.`hetlevel'#c.`index' int* share_`level' bshare_`blevel' `restrict', absorb(upc_id) vce(cluster upc_id)
outreg2 using comptb.tex,  keep(intpl_vi intpl_nonvi intshare intbshare) append ctitle(`yvar')





*****Table 3****
*****wcindex to retail/wholesale prices [NEW]*****************
***look at wc index pass-through to price indexes and individual prices

bysort group_id month: gen gcounter=_n


local period 12
local level subclass_id
local hetlevel category_id
local index dwindex`period'_uw_group_id


cap: drop int*

gen intpl_vi=pl_vi*`index'
gen intpl_nonvi=pl_nonvi*`index'
gen intshare=share_`level'*`index'


local yvar dgprice`period'
areg `yvar' `index' intpl_vi intpl_nonvi, absorb(upc_id) vce(cluster upc_id)
outreg2 using windex.tex,  keep(`index' intpl_vi intpl_nonvi) replace ctitle(12)
areg `yvar' `index' int*, absorb(upc_id) vce(cluster upc_id)
outreg2 using windex.tex,  keep(`index' intpl_vi intpl_nonvi intshare) append ctitle(12)
areg `yvar' int* i.`hetlevel'#c.`index' , absorb(upc_id) vce(cluster upc_id)
outreg2 using windex.tex,  keep(`index' intpl_vi intpl_nonvi intshare) append ctitle(12)



local period 6
local level subclass_id
local hetlevel category_id
local index dwindex`period'_uw_group_id


cap: drop int*

gen intpl_vi=pl_vi*`index'
gen intpl_nonvi=pl_nonvi*`index'
gen intshare=share_`level'*`index'


local yvar dgprice`period'
areg `yvar' `index' intpl_vi intpl_nonvi, absorb(upc_id) vce(cluster upc_id)
outreg2 using windex.tex,  keep(`index' intpl_vi intpl_nonvi) append ctitle(6)
areg `yvar' `index' int*, absorb(upc_id) vce(cluster upc_id)
outreg2 using windex.tex,  keep(`index' intpl_vi intpl_nonvi intshare) append ctitle(6)
areg `yvar' int* i.`hetlevel'#c.`index' , absorb(upc_id) vce(cluster upc_id)
outreg2 using windex.tex,  keep(`index' intpl_vi intpl_nonvi intshare) append ctitle(6)






local period 12
local level subclass_id
local hetlevel category_id
local index dwindex`period'_uw_group_id


cap: drop int*

gen intpl_vi=pl_vi*`index'
gen intpl_nonvi=pl_nonvi*`index'
gen intshare=share_`level'*`index'
local yvar dnprice`period'
areg `yvar' `index' int*, absorb(upc_id) vce(cluster upc_id)
outreg2 using windex.tex,  keep(`index' intpl_vi intpl_nonvi intshare) append ctitle(np12)





**** Table 4 *****
*************wholesale to retail pt *****


set matsize 10000

local period 12
local level subclass_id
local blevel category_id
local hetlevel category_id
local index dwcost`period'
local yvar dgprice`period'
local controls 


cap: drop int*

gen intpl_vi=pl_vi*`index'
gen intpl_nonvi=pl_nonvi*`index'
gen intshare=share_`level'*`index'
gen intbshare=bshare_`blevel'*`index'




areg `yvar' `index' intpl_vi intpl_nonvi `controls', absorb(upc_id) vce(cluster upc_id)
outreg2 using gpwc.tex,  keep(`index' intpl_vi intpl_nonvi) replace ctitle(12)
areg `yvar' `index' int* `controls', absorb(upc_id) vce(cluster upc_id)
outreg2 using gpwc.tex,  keep(`index' intpl_vi intpl_nonvi intshare intbshare) append ctitle(12)
areg `yvar' int* i.`hetlevel'#c.`index' , absorb(upc_id) vce(cluster upc_id)
outreg2 using gpwc.tex,  keep(`index' intpl_vi intpl_nonvi intshare intbshare) append ctitle(12)



local period 6
local index dwcost`period'
local yvar dgprice`period'
cap: drop int*

gen intpl_vi=pl_vi*`index'
gen intpl_nonvi=pl_nonvi*`index'
gen intshare=share_`level'*`index'
gen intbshare=bshare_`blevel'*`index'

areg `yvar' `index' intpl_vi intpl_nonvi `controls', absorb(upc_id) vce(cluster upc_id)
outreg2 using gpwc.tex,  keep(`index' intpl_vi intpl_nonvi) append ctitle(6)
areg `yvar' `index' int* `controls', absorb(upc_id) vce(cluster upc_id)
outreg2 using gpwc.tex,  keep(`index' intpl_vi intpl_nonvi intshare intbshare) append ctitle(6)
areg `yvar' int* i.`hetlevel'#c.`index' , absorb(upc_id) vce(cluster upc_id)
outreg2 using gpwc.tex,  keep(intpl_vi intpl_nonvi intshare intbshare) append ctitle(6)




local period 12
local level subclass_id
local blevel category_id
local hetlevel category_id
local index dwcost`period'
local yvar dnprice`period'
local controls 


cap: drop int*

gen intpl_vi=pl_vi*`index'
gen intpl_nonvi=pl_nonvi*`index'
gen intshare=share_`level'*`index'
gen intbshare=bshare_`blevel'*`index'


areg `yvar' `index' int* `controls', absorb(upc_id) vce(cluster upc_id)
outreg2 using gpwc.tex,  keep(`index' intpl_vi intpl_nonvi intshare intbshare) append ctitle(np12)




