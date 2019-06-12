capture clear
capture log close
*set memory 400m
*set more off
*set matsize 4000
set 


cap cd "C:\Users\pmaarek\Dropbox\Institutions\democracy_and_economic_outcomes"

cap cd "C:\Users\paul\Dropbox\Institutions\democracy_and_economic_outcomes"

cap cd "/Users/dorschm/Dropbox/Research/Institutions/democracy_and_economic_outcomes"

********************************
**********selection de l'imputation médian
********************************


use "swiid6_1"


rename country cname

replace cname="Cape Verde" if cname=="Cabo Verde"
replace cname="Congo, Democratic Republic" if cname=="Congo, D.R."
replace cname="Cyprus (1975-)" if cname=="Cyprus"
replace cname="Cote d'Ivoire" if cname=="C√¥te D'Ivoire"
replace cname="Ethiopia (1993-)" if cname=="Ethiopia"
replace cname="France (1963-)" if cname=="France"
replace cname="Germany, West" if cname=="Germany" & year<1990
replace cname="Guinea-Bissau" if cname=="Guinea Bissau"
replace cname="Korea, South" if cname=="Korea"
replace cname="Laos" if cname=="Lao"
replace cname="Malaysia (1966-)" if cname=="Malaysia"
replace cname="Pakistan (-1970)" if cname=="Pakistan" & year<1971
replace cname="Pakistan (1971-)" if cname=="Pakistan" & year>1970
replace cname="USSR" if cname=="Soviet Union"
replace cname="St Kitts and Nevis" if cname=="Saint Kitts and Nevis"
replace cname="St Lucia" if cname=="Saint Lucia"
replace cname="St Vincent and the Grenadines" if cname=="Saint Vincent and the Grenadines"
replace cname="Sudan (-2011)" if cname=="Sudan" & year<2012
replace cname="Sudan (2012-)" if cname=="Sudan" & year>2011
replace cname="Vietnam" if cname=="Viet Nam"

*****calcul des series medianes pour le gini net

local X = 1

while `X' < 101 {

bys cname : egen _`X'_moy = mean(_`X'_gini_disp) 

local X = `X' + 1
}
*}

gen _101_moy=0

egen median = rowmedian( _1_moy _2_moy _3_moy _4_moy _5_moy _6_moy _7_moy _8_moy _9_moy _10_moy _11_moy _12_moy _13_moy _14_moy _15_moy _16_moy _17_moy _18_moy _19_moy _20_moy _21_moy _22_moy _23_moy _24_moy _25_moy _26_moy _27_moy _28_moy _29_moy _30_moy _31_moy _32_moy _33_moy _34_moy _35_moy _36_moy _37_moy _38_moy _39_moy _40_moy _41_moy _42_moy _43_moy _44_moy _45_moy _46_moy _47_moy _48_moy _49_moy _50_moy _51_moy _52_moy _53_moy _54_moy _55_moy _56_moy _57_moy _58_moy _59_moy _60_moy _61_moy _62_moy _63_moy _64_moy _65_moy _66_moy _67_moy _68_moy _69_moy _70_moy _71_moy _72_moy _73_moy _74_moy _75_moy _76_moy _77_moy _78_moy _79_moy _80_moy _81_moy _82_moy _83_moy _84_moy _85_moy _86_moy _87_moy _88_moy _89_moy _90_moy _91_moy _92_moy _93_moy _94_moy _95_moy _96_moy _97_moy _98_moy _99_moy _100_moy  _101_moy)

gen median_gini_disp = .



local X = 1

while `X' < 101 {

replace median_gini_disp = _`X'_gini_disp if median == _`X'_moy 

local X = `X' + 1
}
*}

*****clacul des series median pour le gini de marché


local X = 1

while `X' < 101 {

bys cname : egen _`X'_moymkt = mean(_`X'_gini_mkt) 

local X = `X' + 1
}
*}

gen _101_moymkt=0

egen medianmkt = rowmedian( _1_moymkt _2_moymkt _3_moymkt _4_moymkt _5_moymkt _6_moymkt _7_moymkt _8_moymkt _9_moymkt _10_moymkt _11_moymkt _12_moymkt _13_moymkt _14_moymkt _15_moymkt _16_moymkt _17_moymkt _18_moymkt _19_moymkt _20_moymkt _21_moymkt _22_moymkt _23_moymkt _24_moymkt _25_moymkt _26_moymkt _27_moymkt _28_moymkt _29_moymkt _30_moymkt _31_moymkt _32_moymkt _33_moymkt _34_moymkt _35_moymkt _36_moymkt _37_moymkt _38_moymkt _39_moymkt _40_moymkt _41_moymkt _42_moymkt _43_moymkt _44_moymkt _45_moymkt _46_moymkt _47_moymkt _48_moymkt _49_moymkt _50_moymkt _51_moymkt _52_moymkt _53_moymkt _54_moymkt _55_moymkt _56_moymkt _57_moymkt _58_moymkt _59_moymkt _60_moymkt _61_moymkt _62_moymkt _63_moymkt _64_moymkt _65_moymkt _66_moymkt _67_moymkt _68_moymkt _69_moymkt _70_moymkt _71_moymkt _72_moymkt _73_moymkt _74_moymkt _75_moymkt _76_moymkt _77_moymkt _78_moymkt _79_moymkt _80_moymkt _81_moymkt _82_moymkt _83_moymkt _84_moymkt _85_moymkt _86_moymkt _87_moymkt _88_moymkt _89_moymkt _90_moymkt _91_moymkt _92_moymkt _93_moymkt _94_moymkt _95_moymkt _96_moymkt _97_moymkt _98_moymkt _99_moymkt _100_moymkt  _101_moymkt)

gen median_gini_mkt = .



local X = 1

while `X' < 101 {

replace median_gini_mkt = _`X'_gini_mkt if medianmkt == _`X'_moymkt 

local X = `X' + 1
}
*}

rename median_gini_disp median_gini_disp2
rename median_gini_mkt median_gini_mkt2

gen median_gini_disp = median_gini_disp2*100
gen median_gini_mkt = median_gini_mkt2*100
 

keep cname year median_gini_disp median_gini_mkt



sort cname year

save "solt_61_median_2.dta", replace

*clear


**********************************
***********selection de l'observation médiane - plus simple
**********************************




