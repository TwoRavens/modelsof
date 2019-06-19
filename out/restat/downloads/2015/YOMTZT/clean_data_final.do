****Starting from scratch: generating prices and costs, selecting products



****This organizes US stores into operating areas, dropping the Hawaii and Alaskan stores***

clear
cd "DIRECTORY"

use lu_store, clear
drop if corporation_id==20
drop if store_state_id=="AK"
drop if store_state_id=="HI"
tab division_nm
tab rog_cd
tab rog_id
tab op_area_id

drop if op_area_id==0 | op_area_id==24 | op_area_id==58
tab op_area_id
egen oparea=group(op_area_id)
keep store_id oparea
summ oparea
save oparea, replace



****9 operating areas here, within each area generate average monthly prices****
forvalues k=1(1)9{

clear
save temp`k', replace emptyok

forvalues j=2004(1)2007{
*this drops products with "in-store" assigned UPC codes or with weighed quantities or zero/negative units or revenues
use store_id upc_id promo_week_id avt_cost gross_amt net_amt item_qty meas_qty if upc_id>100000000 & meas_qty==0 & item_qty>0 & item_qty~=. & gross_amt>0 & gross_amt~=. using upc_us_all_`j', clear

merge m:1 store_id using oparea
keep if _merge==3 & oparea==`k'
drop _merge meas_qty

append using temp`k'
save temp`k', replace
}


**convert from weeks to months, assigning month=1 to January 2004
gen week_id=promo_week_id-200400 if promo_week_id>200400 & promo_week_id<200501
replace week_id=promo_week_id-200500+52 if promo_week_id>200500 & promo_week_id<200601
replace week_id=promo_week_id-200600+104 if promo_week_id>200600 & promo_week_id<200701
replace week_id=promo_week_id-200700+156 if promo_week_id>200700 & promo_week_id<200723

gen month=.
replace month=1 if week_id>=1 & week_id<=4
replace month=2 if week_id>=5 & week_id<=9
replace month=3 if week_id>=10 & week_id<=13
replace month=4 if week_id>=14 & week_id<=17
replace month=5 if week_id>=18 & week_id<=22
replace month=6 if week_id>=23 & week_id<=26
replace month=7 if week_id>=27 & week_id<=30
replace month=8 if week_id>=31 & week_id<=35
replace month=9 if week_id>=36 & week_id<=39
replace month=10 if week_id>=40 & week_id<=44
replace month=11 if week_id>=45 & week_id<=48
replace month=12 if week_id>=49 & week_id<=52
replace month=13 if week_id>=53 & week_id<=57
replace month=14 if week_id>=58 & week_id<=61
replace month=15 if week_id>=62 & week_id<=65
replace month=16 if week_id>=66 & week_id<=69
replace month=17 if week_id>=70 & week_id<=74
replace month=18 if week_id>=75 & week_id<=78
replace month=19 if week_id>=79 & week_id<=83
replace month=20 if week_id>=84 & week_id<=87
replace month=21 if week_id>=88 & week_id<=91
replace month=22 if week_id>=92 & week_id<=96
replace month=23 if week_id>=97 & week_id<=100
replace month=24 if week_id>=101 & week_id<=104
replace month=25 if week_id>=105 & week_id<=109
replace month=26 if week_id>=110 & week_id<=113
replace month=27 if week_id>=114 & week_id<=117
replace month=28 if week_id>=118 & week_id<=122
replace month=29 if week_id>=123 & week_id<=126
replace month=30 if week_id>=127 & week_id<=130
replace month=31 if week_id>=131 & week_id<=135
replace month=32 if week_id>=136 & week_id<=139
replace month=33 if week_id>=140 & week_id<=143
replace month=34 if week_id>=144 & week_id<=148
replace month=35 if week_id>=149 & week_id<=152
replace month=36 if week_id>=153 & week_id<=156
replace month=37 if week_id>=157 & week_id<=160
replace month=38 if week_id>=161 & week_id<=164
replace month=39 if week_id>=165 & week_id<=168
replace month=40 if week_id>=169 & week_id<=173
replace month=41 if week_id>=174 & week_id<=178



sort upc_id month
by upc_id: egen grev=total(gross_amt)
by upc_id: egen nrev=total(net_amt)


***monthly average price/cost within each operating area
by upc_id month: egen gprice=total(gross_amt)
by upc_id month: egen nprice=total(net_amt)
by upc_id month: egen wcost=total(avt_cost*item_qty)


by upc_id month: egen qty=total(item_qty)
replace gprice=gprice/qty
replace nprice=nprice/qty
replace wcost=wcost/qty

duplicates drop upc_id month, force

drop qty gross_amt net_amt item_qty avt_cost store_id *week_id

save temp`k', replace

}

***This generates a smaller dataset with classificaiton variables to be merged later***

use lu_upc, clear
keep if corporation_id==1
keep upc_id subclass_id category_id group_id
save classify_upc_all, replace




