clear
set more off
**Aaron Flaaen

/* Source Data for this file
Source Data:
1. jpn_data.txt: Japan METI Indices of Industrial Activity: (www.meti.go.jp/english/statistics/tyo/zenkatu/result-2.html#historical)
2. imp.txt: U.S. Census Bureau Foreign Trade (htps://usatrade.census.gov)
3. usdurable.txt, usmanuf.txt: FRB G17 Release: (https://www.federalreserve.gov/releases/g17/download.htm)

**Figures created in make_figs_1_to_3.m

**********************************/



cd "dir"

**------------------------------------------------------------------
**Step 1. Japan Data Adjustments
**-------------------------------------------------------------------

insheet using jpn_data.txt, tab clear
gen year = 2004
replace year = 2005 if _n>12 & _n<25
replace year = 2006 if _n>24 & _n<37
replace year = 2007 if _n>36 & _n<49
replace year = 2008 if _n>48 & _n<61
replace year = 2009 if _n>60 & _n<73
replace year = 2010 if _n>72 & _n<85
replace year = 2011 if _n>84 & _n<97
replace year = 2012 if _n>96 & _n<109
replace year = 2013 if _n>=109

gen month = _n
forvalues j = 1(1)12 {
	replace month = `j' if (var-`j')/12==1
	replace month = `j' if (var-`j')/12==2
	replace month = `j' if (var-`j')/12==3
	replace month = `j' if (var-`j')/12==4
	replace month = `j' if (var-`j')/12==5
	replace month = `j' if (var-`j')/12==6
	replace month = `j' if (var-`j')/12==7
	replace month = `j' if (var-`j')/12==8
	replace month = `j' if (var-`j')/12==9
	replace month = `j' if (var-`j')/12==10
	replace month = `j' if (var-`j')/12==11
	replace month = `j' if (var-`j')/12==12
}
gen ljpnprod = log(jpnprod)
tsfilter hp hpljpnprod = ljpnprod, smooth(14400)
	

outsheet using jpn_data_hp.txt, nonames replace


**------------------------------------------------------------------
**Step 2. Import Data Adjustments
**-------------------------------------------------------------------

insheet using imp.txt, tab names clear
rename v8 defl_wor
rename v9 defl_wor_excl_oil
rename v10 defl_jpn
gen year = reverse(substr(reverse(date),1,4))
gen month = substr(date,1,1)
replace month = substr(date,1,2) if substr(date,3,1)=="/"
destring year month, replace
gen monthvar = ym(year,month)
tsset monthvar, monthly

gen rjpn_imp_sa = jpn_imp_sa / (defl_jpn/100)
gen rwor_imp_sa = wor_imp_sa / (defl_wor_excl_oil/100)
gen rnjpn_imp_sa = rwor_imp_sa - rjpn_imp_sa

gen ljimp_sa = log(jpn_imp_sa)
gen lnjpn_sa = log(njpn_imp_sa)

gen lrjimp_sa = log(rjpn_imp_sa)
gen lrnjpn_sa = log(rnjpn_imp_sa)


tsfilter hp hpljimp_sa = ljimp_sa, smooth(14400)
tsfilter hp hplnjpn_sa=lnjpn_sa, smooth(14400)

tsfilter hp hplrjimp_sa = lrjimp_sa, smooth(14400)
tsfilter hp hplrnjpn_sa=lrnjpn_sa, smooth(14400)

drop date
preserve
drop defl_* hplr* lr* rjpn_* rwor* rnjpn_*
outsheet using "usimp_data.txt", nonames replace

restore
drop if year<2006
outsheet using "usrimp_data.txt", nonames replace


**------------------------------------------------------------------
**Step 3. US Industrial Production Data Adjustments
**-------------------------------------------------------------------

insheet using usdurable.txt, tab names clear
reshape long m, i(year) j(new)
rename m durable
rename new month
gen mvar = ym(year,month)
sort year month mvar
save temp_durable.dta, replace

insheet using usmanuf.txt, tab names clear
reshape long m, i(year) j(new)
rename m manuf
rename new month
gen mvar = ym(year,month)
sort year month mvar
merge year month mvar using temp_durable.dta
drop _m

tsset mvar, monthly
gen ldurable = log(durable)
gen lmanuf = log(manuf)

tsfilter hp hpldurable = ldurable, smooth(14400)
tsfilter hp hpldurable_alt = ldurable, smooth(129600)
tsfilter hp hplmanuf = lmanuf, smooth(14400)
tsfilter hp hplmanuf_alt = lmanuf, smooth(129600)

outsheet using "usagg_data.txt", nonames replace
erase temp_durable.dta


