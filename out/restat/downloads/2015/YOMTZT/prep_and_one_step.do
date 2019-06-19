*******IRI Symphony Data Cleaning***

cd "DIRECTORY"

import excel delivery_stores_yr11.xlsx
keep IRI_KEY Market_Name MskdName
duplicates drop IRI_KEY, force
save stores, replace

local catnum=1

foreach cat in yogurt spagsauc milk margbutr carbbev{


use `cat'_groc_old, clear

merge m:1 IRI_KEY using stores
drop if _merge==2
drop _merge


keep if Market_Name=="LOS ANGELES"

gen store_id=IRI_KEY
egen week=group(WEEK)

merge m:1 week using weekmonth
keep if _merge==3
drop _merge

*about 80% of observations are linkable to chains.
*assume the non-matched guys are "single" chains

tostring(IRI_KEY), gen(chainname)
replace chainname=MskdName if MskdName~=""

egen chain=group(chainname)
summ chain


**drop if month greater than 72 (year greater than 2006)
**this is to ensure comparability of private labels and all market shares
drop if month>72



*****Generate market share variables
egen tot_rev=total(DOLLARS)
bysort chain: egen chain_rev=total(DOLLARS)
gen chain_share=chain_rev/tot_rev


*define priate labels
gen pl=0
replace pl=1 if SY==88


*replace manufacturer ids with the chain_id for private labels
replace VEND=99999+chain if SY==88

*PL goods make up about 25% of goods
tab pl

*define unique products 
egen upc_id=group(SY GE VEND ITEM)

bysort chain upc_id: egen prod_rev=total(DOLLARS)
gen prod_share=prod_rev/chain_rev
bysort chain VEND: egen brand_rev=total(DOLLARS)
gen brand_share=brand_rev/chain_rev

bysort upc_id: egen man_prod_rev=total(DOLLARS)
gen man_prod_share=man_prod_rev/tot_rev
bysort VEND: egen man_brand_rev=total(DOLLARS)
gen man_brand_share=man_brand_rev/tot_rev


****Prices: average at the chain x month x product level
bysort chain month upc_id: egen price=total(DOLLARS)
bysort chain month upc_id: egen quant=total(UNITS)
replace price=price/quant


duplicates drop chain month upc_id, force




bysort chain: egen pl_tot=total(DOLLARS*pl)
bysort chain: egen nb_tot=total(DOLLARS*(1-pl))
replace pl_tot=0 if pl_tot==.
replace nb_tot=0 if nb_tot==.
gen pl_share=pl_tot/(pl_tot+nb_tot)


egen pl_tot_all=total(DOLLARS*pl)
egen nb_tot_all=total(DOLLARS*(1-pl))
gen pl_share_all=pl_tot_all/(pl_tot_all+nb_tot_all)
*pl_share_all: an alternative PL manufacturer share, under assumption that PL goods all manufacuted by one company


*****Estimation sample: 36 consecutive months?  

**id is the unique chain by upc identifier
egen id=group(upc_id chain)

tsset id month

**define maxrun as the number of consecutive months of a product-chain combination
gen run=.
by id: replace run = cond(L.run == ., 1, L.run + 1)
by id: egen maxrun = max(run)
tab maxrun


****Generate retail index, merge with commodity prices
**Unweighted, using all of the good-chain combinations that appear in every month
gen retailindex_sample=0
replace retailindex_sample=1 if maxrun==72
bysort month: egen rindex=total(retailindex_sample*price)
gen rindex_base=rindex if month==1
egen min_base=min(rindex_base)
replace rindex=rindex/min_base

**re-center commodity index at 1 as well in first month (Jan 2001)

ren VEND manuf

gen category="`cat'"
gen catnum=`catnum'

keep upc_id pl manuf chain month chain_share prod_share brand_share man_prod_share man_brand_share price rindex category catnum maxrun pl_share pl_share_all prod_rev


save `cat'_clean, replace
local catnum=`catnum'+1
}





***Appending the cleaned data files together

clear
save temp, emptyok replace

foreach j in yogurt spagsauc milk margbutr carbbev{
use `j'_clean
append using temp
save temp, replace
}




*********Estimation**********
use temp, clear


*match with commodities
foreach j in tomato dairy corn{
merge m:1 month using `j'_index
keep if _merge==3
drop _merge
}


gen com=dairy_index if category=="milk" | category=="yogurt" | category=="margbutr"
replace com=corn_index if category=="carbbev"
replace com=tomato_index if category=="spagsauc"




***Define sample as the commodity matched categories and the goods that appear in at least 36 consecutive months
gen sample=1 if category=="milk" | category=="carbbev" | category=="spagsauc" | category=="yogurt" | category=="margbutr"
replace sample=0 if maxrun<36
keep if sample==1

drop catnum
egen catnum=group(category)


**define categories for unique product-chain combinations
egen panelid=group(upc_id chain category)


tsset panelid month

replace price=log(price)
replace rindex=log(rindex)
replace com=log(com)

*12 month difference
gen dprice=price-L12.price
gen drindex=rindex-L12.rindex
gen dcom=com-L12.com


***generate interaction variables
foreach j in pl chain_share prod_share brand_share man_brand_share{
gen `j'_dcom=dcom*`j'
}


***alternate private label shares, under assumption that all PL have same manufacturer
gen man_brand_share_alt=man_brand_share
replace man_brand_share_alt=pl_share_all if pl==1

gen man_brand_share_dcom_alt=dcom*man_brand_share_alt




**interaction variables that allow pass-through to vary by chain
egen maxchain=max(chain)
local maxchain=maxchain[1]
forvalues j=1(1)`maxchain'{
gen ch_dcom`j'=0
replace ch_dcom`j'=dcom if chain==`j'
}

**allow for pass-through to vary by category 
forvalues j=1(1)5{
gen dcom`j'=0
replace dcom`j'=dcom if catnum==`j'
}





***Pooled estimation****


***pooled commodities
local alt man_brand_share_alt man_brand_share_dcom_alt
local cost com
local prod prod_share_d`cost' prod_share 

**Main results
reg dprice d`cost'* pl pl_d`cost' i.month i.chain i.catnum if sample==1, vce(cluster upc_id)
outreg2 using multi.tex,  keep(pl_d`cost') replace ctitle()

**within-store product and brand shares
reg dprice d`cost'* i.month i.chain i.catnum pl pl_d`cost' brand_share brand_share_d`cost' `prod' if sample==1, vce(cluster upc_id)
outreg2 using multi.tex,  keep(pl_d`cost' `prod' brand_share_d`cost') append ctitle()

**retailer market power
reg dprice d`cost'* i.month i.chain i.catnum pl pl_d`cost' chain_share chain_share_d`cost' if sample==1, vce(cluster upc_id)
outreg2 using multi.tex,  keep(pl_d`cost' chain_share_d`cost') append ctitle()

***manufacturer share, two imputation methods for private labels
reg dprice d`cost'* i.month i.chain i.catnum pl pl_d`cost' `alt' if sample==1, vce(cluster upc_id)
outreg2 using multi.tex,  keep(pl_d`cost' man_brand_share_dcom_alt) append ctitle()
local alt man_brand_share man_brand_share_dcom
reg dprice d`cost'* i.month i.chain i.catnum pl pl_d`cost' `alt' if sample==1, vce(cluster upc_id)
outreg2 using multi.tex,  keep(pl_d`cost' man_brand_share_dcom) append ctitle()

***All variables
local alt man_brand_share_alt man_brand_share_dcom_alt
reg dprice d`cost'* i.month i.chain i.catnum pl pl_d`cost' `prod' brand_share brand_share_d`cost' chain_share chain_share_d`cost' `alt' if sample==1, vce(cluster  upc_id)
outreg2 using multi.tex,  keep(pl_d`cost' `prod' brand_share_d`cost' chain_share_d`cost'  man_brand_share_dcom_alt) append ctitle()

*Large stores only
reg dprice d`cost'* i.month i.chain i.catnum pl pl_d`cost' `prod' brand_share brand_share_d`cost' chain_share chain_share_d`cost' `alt' if sample==1 & chain_share>0.1, vce(cluster  upc_id) 
outreg2 using multi.tex,  keep(pl_d`cost' `prod' brand_share_d`cost' chain_share_d`cost'  man_brand_share_dcom_alt) append ctitle()





***Graphs
cap: drop catcounter


bysort catnum month: gen catcounter=_n

replace category="Soft drinks - Corn" if category=="carbbev"
replace category="Milk - Dairy" if category=="milk"
replace category="Yogurt - Dairy" if category=="yogurt"
replace category="Butter - Dairy" if category=="margbutr"
replace category="Pasta Sauce - Tomato" if category=="spagsauc"

set scheme s1mono


***Web Appendix Figure 1
twoway (tsline drindex if catcounter==1, lpattern(dash) lcolor(black) ytitle("12 month % change") xtitle("Month (Jan 2001=1)") legend(order(1 "Retail price index (left scale)" 2 "Commodity index (right scale)")) by(category)) (tsline dcom if catcounter==1, yaxis(2) lpattern(solid) lcolor(black))
graph export multi_com.png, replace




**Figure 2: correlation of product and manufacturer shares

bysort panelid: egen meanprod_share=mean(prod_share)
bysort panelid: egen meanbrand_share=mean(brand_share)

bysort panelid: gen pancounter=_n
bysort panelid2: gen pan2counter=_n


cap: drop man*counter
bysort manuf category chain: gen man2counter=_n
bysort manuf category: gen mancounter=_n

corr prod_share man_prod_share if pan2counter==1 & pl==0
corr brand_share man_brand_share if man2counter==1 & pl==0

corr prod_share man_prod_share if pan2counter==1
corr brand_share man_brand_share if man2counter==1


twoway (scatter prod_share man_prod_share if pan2counter==1 & pl==0, xtitle(Product share in LA) ytitle(Product share within chain))
graph save prod_scatter, replace
twoway (scatter brand_share man_brand_share if man2counter==1 & pl==0, xtitle(Brand share in LA) ytitle(Brand share within chain))
graph save brand_scatter, replace

graph combine prod_scatter.gph brand_scatter.gph
graph export share_scatter.png, replace




**Summary Stats for estimating sample (Table 1)
**average price ratio of PL to national brand goods
bysort panelid2: egen mprice=mean(exp(price))
replace mprice=. if pan2counter~=1

bysort pl category chain: egen meanprice=mean(mprice)
gen meanprice_pl=meanprice if pl==1
bysort category chain: egen avgprice_pl=min(meanprice_pl)
gen pratio=avgprice_pl/meanprice if pl==0


tab pl if pan2counter==1
bysort pl: summ prod_share brand_share man_brand_share man_brand_share_alt chain_share pratio if pan2counter==1





