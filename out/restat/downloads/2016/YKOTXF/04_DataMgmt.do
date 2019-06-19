
cap clear mata
clear
clear all
set more off
cap log close
set mem 6g
set matsize 5000

/*

Dofile: 04_DataMgmt.do 

Date: Dec. 10, 2016 
Aim: prepare the data for regressions

Inputs: 
- base_dmpt.dta (prepared in 03_) 
- hs1996ToIsicRev2.txt (correspondance) 
- DataJobID-351903_351903_france1999.csv (tarif data) 
- geo_cepii.dta (country labels)
- ER1999.dta  (ER data, IFS) 
- rta_FRA99.dta 
- ppp1999.dta 
- market_potential.dta (cepii - thierry mayer)
- sigma_hs4_imbsmejean.dta (elasticity Imbs & Mejean)
- gini.dta (Gini index, IFS) 
- contract_intensity_ISIC_1997.dta (Contract intensity, Nunn) 
- ladder_isic.dta (Quality ladder, Khandelwal)  
- remot (remotness, authors' computation) 

Output: base_for_reg.dta 

*/ 

cd $datapath

/** in this do file, we prepare the data for empirical analysis: we drop outliers, keep observations useful for our indentification strategy etc **/ 

***************************************
***   here we focus on export prices
***************************************


use base_dmpt, replace 

*** drop if do not have info on uv 
egen tot=sum(export) 
tab tot 
drop tot 
g luv=log(export/xqty) 
drop if luv==. 
egen tot=sum(export) 
tab tot 
drop tot 
replace tax99=tax98 if tax99==.
replace tax99=tax97 if tax99==.
replace tax99=tax96 if tax99==.
    
*** we drop obs. with a bad concordance between custom data and mondialisation (custom data are nc8 and mondia data are hs4 !!) 
g test=1 - exporths4/export_mondia 
sum test, d 
egen tot=sum(export) 
drop if test!=. & abs(test)>0.01
egen tot_=sum(export)
sum tot tot_  
drop test tot tot_ 
save desc_x, replace 


*** drop if firm has an affiliate or a headquarter according to LiFi but do not do intrafirm
drop if export==0
replace intra_x=0 if intra_x==. 
g type=0 
replace type=2 if intra_x>$lowerbound
replace related=related==1
tab type related
egen test=sum(export) 
egen test_=group(siren) 
drop if type==0 & related==1 
egen test2=sum(export) 
egen test_2=group(siren) 
sum test*
drop test*

*** we drop obs of indep firms according to LIFI that do intrafirm 
replace type=1 if intra_x>$upperbound
egen max=max(type), by(siren natact) 
egen test=sum(export) 
drop if natact=="0" & max>0
egen test2=sum(export) 
drop if natact=="2"
egen test3=sum(export) 

*** drop obs if type==2 ie. if the share of intrafirm export is >lowerbound & <lowerbound 

drop if type==2
egen test4=sum(export) 
sum test*
drop test*

*** we drop all obs if we don't have both intra and extra firm info for product-country pairs
egen tot=sum(export) 
tab tot 
egen test=group(nc8 iso2) 
sum test 
drop test
drop tot 
drop max
egen min=min(type), by(nc8 iso2) 
egen max=max(type), by(nc8 iso2) 

egen tot=sum(export) if min==1 & max==1
tab tot 
egen test=group(nc8 iso2) if min==1 & max==1
sum test 
drop test
drop tot
 egen test=sum(export) if type==1
 sum test 
 drop test 

keep if min==0 & max==1
egen tot=sum(export) 
tab tot 
drop tot 
egen test=group(nc8 iso2) 
sum test 
drop test

gen isoemu=0
local emu AU  BE FI  DE  GR  IR  IT  LU NL PT ES 
foreach i of local emu{
replace isoemu=1 if iso2=="`i'"
		}

*** variables 
foreach x in gdp pop distw {
gen l`x'=log(`x')
}


g taxgap=(tax99 - 33.3)/100 /*  gap with France */
g lgdpc=lgdp -lpop
g tax99_=log(1 -tax99/100)

g linvstatax=log(1 - tau_i)
g linveatr=log(1 - eatr)
g linvemtr=log(1 - emtr)


*g tax99_=tax99<33.3
foreach x in tax99_ ldistw lgdp lgdpc isoemu taxgap fsivalue secrecyscore linveatr linvemtr linvstatax{
gen inter_`x'=type*`x'
}

g dum_oecd=(oecd=="Y") | (oecd=="M")
g dum_tjn=tjn=="Y" 
g dum_imf=imf=="Y" 
g dum_hines=taxhaven==1
foreach x in oecd tjn imf hines{
gen interdum_`x'=type*dum_`x'
}



qui tab iso2, g(cty_) 
egen fp=group(siren nc8)
egen fpt=group(siren nc8 )
 
egen pays=group(iso2) 
drop inter_isoemu
*forvalues x=1/65 {
*gen intercty_`x'=type*cty_`x'
*} 

g sh=substr(nc8,1,4)
g hs2=substr(nc8,1,2) 
destring sh, replace 
sort sh 
merge sh using rauch 
drop if _m==2
drop _m 
save export_reg, replace 


***  NEW March 31, 2016 

** Prepare data for regressions 

*** merge with ISIC nomenclature 
insheet using hs1996ToIsicRev2.txt, clear
tostring h1code, replace 
replace h1code="0"+h1code if length(h1code)==5 
replace h1code="00"+h1code if length(h1code)==4 
rename h1code hs6 
sort hs6 
save isic, replace

*** Deal with tariff data 
insheet using DataJobID-351903_351903_france1999.csv, clear 
drop if tradeyear>2000 
keep reporter reportername product productname simpleaverage weightedaverage dutytype tradeyear
drop if simpleaverage==. 
egen rpd=group(reporter product dutytype)
duplicates drop rpd , force 

g yes=(simpleaverage!=. & dutytype=="PRF")
egen max=max(yes), by(reporter product) 
drop if max==1 & dutytype!="PRF"
drop yes max 

g yes=(simpleaverage!=. & dutytype=="AHS")
egen max=max(yes), by(reporter product) 
drop if max==1 & dutytype!="AHS"
drop yes max 

g yes=(simpleaverage!=. & dutytype=="MFN")
egen max=max(yes), by(reporter product) 
drop if max==1 & dutytype!="MFN"
drop yes max 

g yes=(simpleaverage!=. & dutytype=="BND")
egen max=max(yes), by(reporter product) 
drop if max==1 & dutytype!="BND"
drop yes max 

rename product hs6
tostring hs6, replace 
replace hs6="0"+hs6 if length(hs6)==5
sort hs6 
merge m:1 hs6 using isic 
drop if _m==2 
drop _m 

rename reporter cnum 
preserve 
use geo_cepii, clear 
sort cnum 
save, replace 
restore
sort cnum 
merge cnum using geo_cepii
replace iso3="USA" if cnum==840
replace iso3="CHE" if cnum==756
replace iso3="ZAF" if cnum==710
replace iso3="NOR" if cnum==578
replace iso3="IND" if cnum==356
replace iso3="TWN" if cnum==158

keep iso3 hs6  simpleaverage weightedaverage dutytype
duplicates drop hs6 iso3, force // drop missing 
sort hs6 iso3 
save tariff_fra_99, replace 

*** merge all 
use export_reg, clear 


egen tot=sum(export), by(siren) 
sum tot, d
gen med=r(p50)
gen p75=r(p75)

g big=tot>p75
g inter_tax_big=inter_tax99_*big 
g type_big=type*big 
g tax_big=big*tax99_ 

g hs6=substr(nc8,1,6)
sort hs6 iso3 
merge m:1 hs6 iso3 using tariff_fra_99  // new: m:1 
drop if _m==2
drop _m

replace simpleaverage=0 if EU15==1 & simpleaverage==. 
g tarif_alt=simpleaverage/100
g tarif=log(1 + simpleaverage/100) 
g inter_tarif_alt=tarif_alt*type 
g inter_tarif=tarif*type 



label var ldist        "Distance (log)"
label var lgdpc        "GDP cap (log)"
label var tax99_       "log(1 -\tau_{i})"
label var taxgap       "\tau_{i} - \tau_{fra} "
label var dum_hines      "Tax Haven"
label var type         "Intra-firm"
label var inter_ldist  "XX Distance (log)"
label var inter_lgdpc  "XX GDP cap (log)"
label var inter_tax99_ "XX log(1 -\tau_{i})"
label var inter_taxgap "XX (\tau_{i} - \tau_{fra}) "
label var interdum_hines "XX Tax Haven (IMF)"
label var inter_tarif "XX Tariff"
label var tarif "-$Tarif (log)"

label var inter_linveatr  "XX  Eff. Tax Rate"
label var inter_linvemtr  "XX  Eff. Tax Rate"

label var linveatr "Eff. Tax Rate"
label var linvemtr "Eff. Tax Rate"

g ape=substr(apedef,1,2) 
destring ape, replace 
tostring hs6, replace 
replace hs6="0"+hs6 if length(hs6)==5
sort hs6 
merge m:1 hs6 using isic 
drop if _m==2 
drop _m 

merge m:1 iso3 using ER1999 
drop if _m==2 
drop _m 

cap drop _m 
sort iso3 
merge m:1 iso3 using rta_FRA99 
keep if _m==3 
drop _m 

sort iso3 
merge m:1 iso3 using ppp1999 
keep if _m==3 
drop _m 

sort iso3 
merge m:1 iso3 using market_potential // thierry's data from cepii website 
drop _m

g inter_EU15=type*EU15  // interact with a dummy for EU15 
g inter_dler = type*dler1999 // interact with the change in exchang rate (1998-1999) 
g inter_rta=type*rta // interact if the country has a RTA with France 

destring price_level_ratio, g(ppp) dpcomma
g lppp=log(ppp)
g inter_lppp=lppp*type

sort iso3 
merge m:1 iso3 using gini 
drop if _m==2 
drop _m 

drop if nc8==""
tostring hs4, replace 
replace hs4="0" + hs4 if length(hs4)==3 
sort hs4 
merge m:1 hs4 using sigma_hs4_imbsmejean
drop if _m==2 
drop _m 

g lgini=log(gini)
g inter_lgini=lgini*type 

g inter_lfmp=lfmp_hm*type 

g lsigma=log(sigma) 
g inter_dum_lsigma=type*dum_hines*lsigma

tostring i2code, replace 
g industry_code=substr(i2code,1,3)
sort industry_code 
merge m:1 industry_code using contract_intensity_ISIC_1997
drop if _m==2 
drop _m 
rename industry_code isic_rev2 
destring isic_rev2, replace 
sort isic_rev2 
merge m:1 isic_rev2 using ladder_isic
drop _m 
g inter_dum_frac_lib_diff=type*dum_hines*frac_lib_diff
label var inter_dum_frac_lib_diff "type*dum_hines*frac_lib_diff"

g inter_dum_frac_lnot_homog=type*dum_hines*frac_lib_not_homog
label var inter_dum_frac_lnot_homog "type*dum_hines*frac_lib_not_homog"

g inter_dum_lladder=type*dum_hines*log(ladder)
label var inter_dum_lladder "type*dum_hines*log(ladder)"

g inter_linvemtr_frac_lib_diff=type*linvemtr*frac_lib_diff
label var inter_linvemtr_frac_lib_diff "type*linvemtr*frac_lib_diff"

g inter_linvemtr_frac_lnot_homog=type*linvemtr*frac_lib_not_homog
label var inter_linvemtr_frac_lnot_homog "type*linvemtr*frac_lib_not_homog"

g inter_linvemtr_lladder=type*linvemtr*log(ladder)
label var inter_linvemtr_lladder "type*linvemtr*log(ladder)"

cap drop fpt 

sort iso3 
merge m:1 iso3 using remot // remotness computed from CEPII, gravity dataset 
keep if _m==3
drop _m 
egen c=group(pays) 
// pays is the iso2 code of the destination country 

egen fpt=group(siren nc8 type) 
// type is a dummy equal to one if the flow is intra-firm, siren is the firm id, nc8 is the 8-digit product category 


reg luv linveatr linvemtr
keep if e(sample) // allows us to work from the same sample (same number of observations) with the two different tax ratess

cap drop cty_*
qui tab pays, g(cty_)

label var siren "firm identifier" 
label var nc8 "CN8 product category"
label var iso2 "iso2 code, destination"
label var hs4 "HS 4-digit"
label var natact "0:domestic, 1: French MNE, 2: foreign affiliate (LIFI)"
label var paystg "Country of ownership (LIFI)"
label var w "homogenous good (Rauch 199)"
label var r "referenced price (Rauch 199)"
label var n  "differentiated product (Rauch 1999)"
label var luv "log(unit value) - French Customs"
label var isoemu "Belongs to the EMU"
label var gdp "gdp (World Bank)"
label var lgdp "log(gdp)"
label var pop "population (World Bank)"
label var lpop "log(pop)"
label var dum_tjn "tax haven (TJN)"
label var dum_oecd "tax haven (OECD)"
label var dum_imf "tax haven (IMF)"
label var big "Large MNEs (>p75)"
label var gdpcap "GDP per capita (World Bank)"
label var gini "Gini index (World Bank)"
label var sigma "Elasticity of subsitution (Imbs & Méjean)"
label var year "Year"
label var iso3 "iso3 country code, destination"
label var cname "Country name, destination"
label var inter_lgdp "XX log(GDP)"
label var EU15 "Belongs to EU15"
label var isic_rev2 "3-digit ISIC industry (rev2)"
label var hs2 "2-digit HS nomneclature"
label var hs6 "6-digit HS nomenclature"
label var tarif "tariff on French exports"
label var tarif_alt "log(1 + tariff on French exports)"
label var inter_tarif_alt "XX tariff_alt"
label var ape "Main sector of activity APE nomenc"
label var lgini "log(gini)"
label var inter_lgini "XXlog(gini)"
label var lsigma "log(sigma)"
label var inter_dum_lsigma "typeXdum_hines*log(sigma)"

label var inter_lgini "type*taxhaven*log(gini)"

drop inter_EU15 multiplier lfmp* lgcap  inter_tax_big type_big tax_big med inter_fsi inter_secrecy inter_linvstat interdum_oecd interdum_tjn interdum_imf import mqty musup xusup exporths4 effetgr liber n16gr tax99 tax98 tax97 tax96 tau_i related min max linvstatax sh tot p75 inter_dler gdp_eur avgyrs lrmp* lpp inter_lppp inter_rta miss inter_lfmp 

save base_for_reg, replace 

