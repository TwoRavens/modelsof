
cd "C:\Users\rhicks\Documents\Data\tariffs\trains\zipped\costarica"
insheet using costarica2005.txt , clear

*keep if partner=="000" 

tostring productcode, gen(hs02_8dig)

replace hs02_8dig = "0"+hs02_8dig if length(hs02_8dig)==9
replace hs02_8dig = substr(hs02_8dig,1,8)


preserve

cd "R:\Milner\Milner\CostaRica\Tariffs\"
insheet using cr-schedule.csv , comma clear

compress

drop in 6300/6307
*drop description
gen categ2 = category if length(category)==1
replace hs8 = "0"+hs8 if length(hs8)==7

replace hs8 = "02071392" if hs8=="02071399A"
replace hs8 = "02071393" if hs8=="02071399B"
replace hs8 = "02071399" if hs8=="02071399C"

replace hs8 = "02071492" if hs8=="02071499A"
replace hs8 = "02071493" if hs8=="02071499B"
replace hs8 = "02071499" if hs8=="02071499C"
rename hs8 hs02_8dig



replace hs02_8dig = substr(hs02_8dig,1,8) if length(hs02_8dig)~=8

*** APPLYING DR-CAFTA SCHEDULE TO BASE
** No change from current rate in categories E,F, H, or S

/* Categories: A: Eliminated on force
               B: Eliminated in 5 equal annual stages; duty-free in year 5
               C: Eliminated in 10 equal annual stages; duty-free in year 10
               D: Eliminated in 15 equal annual stages; duty-free in year 15
               F: Base rate for 1st ten years & then eliminated in 10 equal annual stage; duty free in year 20
               G: Continue to receive duty-free treatment
               M: 10 equal stages: 2% reduction of base in years 1 & 2; 8% reduction of base in yrs 3-6; 16% of base in yrs 7 on; duty free in yr 10
               N: Eliminated in 12 equal annual stages; duty-free in year 12
               S: Base rates yrs 1-5; 8% reduction of base in yrs 6-10; 12% reduction in yrs 11-15; duty-free in year 15
*/

compress
tempfile cafta

sort hs02_8dig
save `cafta' , replace

restore 

sort hs02_8dig
merge hs02_8dig using `cafta' , uniqmaster

replace category = "A" if hs02_8dig=="87083910" | hs02_8dig=="87083990" | hs02_8dig=="94060020"
replace categ2 = "A" if hs02_8dig=="87083910" | hs02_8dig=="87083990" | hs02_8dig=="94060020"

drop if hs02_8dig=="87083900" | hs02_8dig=="32091000"

replace _merge=3 if hs02_8dig=="87083910" | hs02_8dig=="87083990" | hs02_8dig=="94060020"

replace advalorem = base if hs02_8dig=="32091010" | hs02_8dig=="32091090" | hs02_8dig=="22089020" | hs02_8dig=="39233092"
replace _merge=3 if hs02_8dig=="32091010" | hs02_8dig=="32091090" | hs02_8dig=="22089020"  | hs02_8dig=="39233092"

drop _merge productcode productdesc partner name measurecode measurename nonadval affected descript 


gen hs02_6dig = substr(hs02_8dig,1,6)
duplicates tag hs02_6dig, gen(no_lines)
replace no_lines= no_lines+1

replace categ2 = "D" if catego=="D 1/"

gen cafta_adval = advalorem
replace cafta_adval = 0 if categ2=="A"
replace cafta_adval = 0 if categ2=="G"
replace cafta_adval = advalorem-(advalorem/5) if categ2=="B"
replace cafta_adval = advalorem-(advalorem/10) if categ2=="C"
replace cafta_adval = advalorem-(advalorem/15) if categ2=="D"
replace cafta_adval = advalorem-(advalorem*.02) if categ2=="M"
replace cafta_adval = advalorem-(advalorem/12) if categ2=="N"
replace cafta_adval = . if categ2==""


#delim ;
replace cafta_adval = 0 if categ2=="" & (regexm(catego,"paragraph 3") | regexm(catego,"paragraph 5") | regexm(catego,"paragraph 6") |
 regexm(catego,"paragraph 7") | regexm(catego,"paragraph 8") | regexm(catego,"paragraph 9") | regexm(catego,"paragraph 11") | 
 regexm(catego,"paragraph 12") | regexm(catego,"paragraph 13") | regexm(catego,"paragraph 14"));
#delim cr

replace cafta_adval = 77 if regexm(catego,"paragraph 4") & cafta_adval==.
replace cafta_adval = 25 if regexm(catego,"paragraph 10") & cafta_adval==.

replace cafta_adval = base-(base/10) if cafta_adval == . & substr(catego,1,1)=="C"
replace cafta_adval = base-(base/12) if cafta_adval == . & substr(catego,1,1)=="N"
replace cafta_adval = base-(base*.02) if cafta_adval == . & substr(catego,1,1)=="M"

preserve
use R:\Milner\Milner\CostaRica\Tariffs\trade\CR_trade1.dta , clear
keep if year==2005
keep if partnern=="United States"
drop partnername reportername 
tempfile trade
sort hs02_6dig
save `trade' , replace

restore

sort hs02_6dig
merge hs02_6dig using `trade' , uniqusing

drop _merge

gen imp6 = imp/no_lines
gen exp6 = exp/no_lines

gen rev_new = (cafta_adval)*imp6
egen sumimp_new = sum(imp6) if cafta_adval~=.
egen sumrev_new = sum(rev_new) 

gen eff_tariff = sumrev_new/sumimp_new

gen rev = (advalorem)*imp6
egen sumimp = sum(imp6) if advalorem~=.
egen sumrev = sum(rev)
gen wt_pretar = sumrev/sumimp

*** APPENDIX 1: CR Tariffs on US products
summ cafta_adval advalorem
summ wt_pretar eff_tariff if imp6~=.


*** TOP CR IMPORT INDUSTRIES FROM US:
*** 85 84 39 48 10 90 27 61 38

*preserve 
drop base category categ2 rev_new sumimp_new sumrev_new nomencode reporter_iso_n year rev sumimp sumrev
gen hs2 = substr(hs02_6dig,1,2)

* keep if hs2=="85" | hs2=="84" | hs2=="39" | hs2=="48" | hs2=="10" | hs2=="90" | hs2=="27" | hs2=="61" | hs2=="38"  | hs2=="62" 

preserve
keep if substr(hs2,1,1)=="7"
drop hs2
gen hs2 = "7"
collapse (mean) advalorem cafta_adval , by(hs2)
tempfile hs7
sort hs2
save `hs7' , replace
restore

sort hs2
by hs2: egen tot2 = total(imp6)
by hs2 : egen totexp = total(exp6)

gen rev = (advalorem*imp6)
bysort hs2 : egen sum_rev = sum(rev)
gen wt_tar = sum_rev/tot2

table hs2 , c(mean advalorem mean wt_tar mean cafta_adval)

collapse (mean) advalorem wt_tar cafta_adval tot2 totexp , by(hs2)

sort hs2

preserve
cd R:\Milner\Milner\CostaRica\CRTradeData

insheet using us_cr_h2.csv , comma clear

replace commoditycode = subinstr(commoditycode,"H2-","",.)

drop netweightkg-flag

reshape wide tradevalue , i(commoditycode period) j(tradeflow) str

renvars tradevalue* , presub("tradevalue" "")

gen exp_tot = .
gen imp_tot = .

qui summ Export if period==2004 & commoditycode=="TOTAL"
replace exp_tot = r(mean) if period==2004
qui summ Export if period==2005 & commoditycode=="TOTAL"
replace exp_tot = r(mean) if period==2005

qui summ Import if period==2004 & commoditycode=="TOTAL"
replace imp_tot = r(mean) if period==2004
qui summ Import if period==2005 & commoditycode=="TOTAL"
replace imp_tot = r(mean) if period==2005

keep if length(commoditycode)==2
keep if period==2005
gen imp_perc = Import/imp_tot
gen exp_perc = Export/exp_tot
rename commoditycode hs2
tempfile X
sort hs2
save `X'
restore
merge 1:1 hs2 using `X'
keep   hs2  commoditydescription imp_perc advalorem wt_tar cafta_adval exp_perc 
order hs2  commoditydescription imp_perc advalorem wt_tar cafta_adval exp_perc 

sort hs2
merge 1:1 hs2 using R:\Milner\Milner\CostaRica\Tariffs\ustar.dta /*created by us_cafta_final.do */
drop _merge

replace imp_perc=imp_perc*100
replace exp_perc=exp_perc*100

label var hs2 "2-digit HS code"
label var imp_perc "% of total imports from US"
label var advalorem "Average tariff on US imports in code"
label var wt_tar "Trade-weighted tariff"
label var cafta_adval "CAFTA-DR tariff"
label var exp_perc "% of total exports to US"
label var advalorem_us "Average tariff on exports to US in code"
label var wt_tar_us "Trade-weighted US tariff"
label var cafta_adval_us "CAFTA-DR tariff for US"
compress

save "c:\users\\`c(username)'\dropbox\TingleyCostaRica\ISQ\data\supplement\appendix1.dta" , replace
