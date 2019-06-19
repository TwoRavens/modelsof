clear
cd "H:\Superstars\Submission RESTAT\"


********This file calculates comparative advantage over time using Balassa and evaluates the change due to the top firm************

***open comtrade and calculate RCA using our industries***
insheet using "8. Table 4\input\DataJobID-420768_420768_threecountries.CSV", clear
ren reporteriso3 country
rename productcode hs2
drop if hs2==27
sort country year hs2
ren tradevaluein1000usd value
sort hs2
g str industry=""
replace ind="Food" if hs2>=1 & hs2<=24
replace ind="Mineral" if hs2>=25 & hs2 <=27
replace ind="Chemicals" if hs2>=28 & hs2 <=38
replace ind="Plast Rub" if hs2>=39 & hs2 <=40
replace ind="Wood" if (hs2>=44 & hs2 <=46) 
replace ind="Paper" if (hs2>=47 & hs2 <=49) 
replace ind="Textiles" if (hs2>=50 & hs2 <=59) 
replace ind="Apparel" if (hs>=41 & hs2<=43)|(hs2>=60 & hs2 <=67)
replace ind="Glass" if hs2>=68 & hs2 <=70
replace ind="Prec. Met" if hs2==71
replace ind="Metals" if hs2>=72 & hs2 <=83
replace ind="Mach" if hs2==84 
replace ind="Elecmach" if  hs2==85
replace ind="Transport" if hs2>=86 & hs2 <=89
replace ind="Misc" if ind==""

collapse(sum) value, by(country year ind)
sort country year ind
****merge in share of top firm by industry over time*******
merge country year ind using "8. Table 4\input\topshare"
gen value_noSS=value*(1-topshare)
gen value_SS=value*topshare
sort ind
egen x=sum(value), by(country year)
egen xnoSS=sum(value_noSS), by(country year)
gen share=value/x
gen sharenoSS=value_noSS/(x-value_SS)
sort industry year
keep country ind year share sharenoSS
save "8. Table 4\shares", replace
keep if country=="All"
drop country sharenoSS
rename share world 
sort industry year
save "8. Table 4\wshares", replace

use "8. Table 4\shares", clear
drop if country=="All"
sort industry year
merge industry year using "8. Table 4\wshares"
gen bal_all=share/world
gen bal_noSS=sharenoSS/world
keep country year industry bal_all bal_noSS
**For NEW SS****
*****strict*****

reshape wide bal_all bal_noSS, i(country industry) j(year)

**For NEW SS****
*****finds reversals*****

gen gainca=0
gen ca=0
replace gainca=1 if (bal_all2000<1 & bal_all2010>1)
keep if gainca==1

reshape long bal_all bal_noSS, i(country industry) j(year)
***view data to verify reversals***

gen epi=0
replace epi=1 if year==2000 & country=="CRI" & industry=="Elecmach"
replace epi=1 if year==2005 & country=="CRI" & industry=="Elecmach"
replace epi=1 if year==2008 & country=="CRI" & industry=="Elecmach"
replace epi=1 if year==2000 & country=="CRI" & industry=="Misc"
replace epi=1 if year==2006 & country=="CRI" & industry=="Misc"
replace epi=1 if year==2008 & country=="CRI" & industry=="Misc"
replace epi=1 if year==2000 & country=="CRI" & industry=="Paper"
replace epi=1 if year==2008 & country=="CRI" & industry=="Paper"


replace epi=1 if year==2002 & country=="MAR" & industry=="Elecmach"
replace epi=1 if year==2005 & country=="MAR" & industry=="Elecmach"
replace epi=1 if year==2010 & country=="MAR" & industry=="Elecmach"
keep if epi==1
gen period=2
replace period=1 if year<2003
replace period=3 if year>2007
drop year
sort country industry period


drop epi ca gainca
rename bal_all bal_0
rename bal_noSS bal_1

reshape long bal_, i(country industry period) j(data)
gen ctyind=country+industry
drop country industry

reshape wide bal_, i(data period) j(ctyind) string

gen RCA="start" if period==1
replace RCA="reversal" if period==2
replace RCA="end" if period==3

gen sample="all" if data==0
replace sample ="noSS" if data==1

drop data 
rename bal_CRIElecmach CRI_Elecmach
rename bal_CRIMisc CRI_Misc
rename bal_CRIPaper CRI_Paper
rename bal_MARElecmach MAR_Elecmach
order sample period RCA CRI_Elecmach CRI_Misc CRI_Paper MAR_Elecmach

save "8. Table 4\T4a.dta", replace
************View data for top two sections of Table 4***************

***Bottom section is calculated from raw data, sector shares****
use "8. Table 4\input\topshare", clear
gen epi=0
replace epi=1 if year==2000 & country=="CRI" & industry=="Elecmach"
replace epi=1 if year==2005 & country=="CRI" & industry=="Elecmach"
replace epi=1 if year==2008 & country=="CRI" & industry=="Elecmach"
replace epi=1 if year==2000 & country=="CRI" & industry=="Misc"
replace epi=1 if year==2006 & country=="CRI" & industry=="Misc"
replace epi=1 if year==2008 & country=="CRI" & industry=="Misc"
replace epi=1 if year==2000 & country=="CRI" & industry=="Paper"
replace epi=1 if year==2008 & country=="CRI" & industry=="Paper"


replace epi=1 if year==2002 & country=="MAR" & industry=="Elecmach"
replace epi=1 if year==2005 & country=="MAR" & industry=="Elecmach"
replace epi=1 if year==2010 & country=="MAR" & industry=="Elecmach"
keep if epi==1
gen ctyind=country+industry

gen period=2
replace period=1 if year<2003
replace period=3 if year>2007
drop country industry year
reshape wide topshare, i(period) j(ctyind) string

gen RCA="share_start" if period==1
replace RCA="share_reversal" if period==2
replace RCA="share_end" if period==3

gen sample="top firm" 

drop epi
rename topshareCRIElecmach CRI_Elecmach
rename topshareCRIMisc CRI_Misc
rename topshareCRIPaper CRI_Paper
rename topshareMARElecmach MAR_Elecmach
order sample period RCA CRI_Elecmach CRI_Misc CRI_Paper MAR_Elecmach
append using "8. Table 4\T4a.dta"
sort sample period
save "8. Table 4\T4.dta", replace

erase "8. Table 4\wshares.dta"
erase "8. Table 4\shares.dta"
erase "8. Table 4\T4a.dta"
