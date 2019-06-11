/**************************************************************

This do file generate Figure 1 of the paper


***************************************************************/



cd "\DATA\Dropbox\PoliticalEconomy\countries"

*shp2dta using world_adm0, data(world-d) coor(world-c) genid(id) genc(c)

use country, clear

replace country=country[_n-1] if country==""
replace iso=iso[_n-1] if iso==""
drop if year==""|year=="-"
replace cou=trim(coun)

replace cou="Congo" if iso=="CD"
replace cou="Iran" if iso=="IR"
replace cou="Russia" if cou=="Russian Federation"
replace cou="Syria" if cou=="Syrian Arab Republic"
replace cou="Vietnam" if cou=="Viet Nam"
replace cou="Taiwan" if iso=="TW"
replace cou="Laos" if iso=="LA"
replace cou="Ivory Coast" if cou=="Cote d'Ivoire"
replace cou="Moldova" if iso=="MD"
replace cou="Myanmar (Burma)" if cou=="Myanmar"
replace cou="Byelarus" if cou=="Belarus"

collapse  presidentialinvalidvotes parliamentaryinvalidvotes, by(country iso)
sort country
save temp, replace


use world-d, clear
ren NAME country
replace cou=trim(coun)

replace cou="Bahamas" if cou=="Bahamas, The"
replace cou="Gambia" if cou=="Gambia, The"
replace cou="Bahamas" if cou=="Bahamas, The"

sort country

merge country using temp
tab _m

keep if _m==3
drop _m

spmap parliamentaryinvalidvotes using "world-c", id(id) clnumber(9) clmethod(quantile)  ndsize(thick) 
graph export worldmap.pdf, replace
