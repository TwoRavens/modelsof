***************************
**Figure 1: World VAX ratio
***************************
use "./data/VAdataset.dta", clear
drop if ecode==icode
gen vaexports_noROW=vaexports if ecode~="ROW" & icode~="ROW"
gen exports_noROW=exports if ecode~="ROW" & icode~="ROW"
collapse (sum) exports vaexports exports_noROW vaexports_noROW, by(year)
gen vax=vaexports/exports
gen vax_noROW=vaexports_noROW/exports_noROW
#d ;
line vax vax_noROW year, 
	lpattern(solid longdash) lcolor(navy navy) xtitle(year) 
	legend(label(1 "with ROW") label(2 "without ROW") position(7) ring(0) col(1) region(color(none)))
	ylabel(,nogrid) xlabel(1970(5)2010) xtitle("")
	plotregion(style(none)) 
	graphregion(fcolor(white) lwidth(none) ilwidth(none) margin());
graph export "./figures_and_tables/world_vax.pdf", replace;	

#d cr
***********************************
**Figure 2: Sector-level VAX Ratios
***********************************
use "./data/VAdataset.dta", clear
drop if ecode==icode
collapse (sum) exports vaexports, by(year snum sname)
gen vax=vaexports/exports
forval num = 1/4 {
	line vax year if snum==`num', xtitle("") ytitle("") plotregion(style(none)) graphregion(fcolor(white) lwidth(none) ilwidth(none) margin())
	graph export "./figures_and_tables/world_vax_s`num'.pdf", replace
}

****************************************************
**Figure 3, Panel (a): Cumulative Changes by Country
****************************************************
use "./data/VAdataset.dta", clear
drop if ecode==icode
collapse (sum) exports vaexports, by(ecode enum year)
gen vax=vaexports/exports
drop exports vaexports
reshape wide vax, i(ecode enum) j(year)
gen diff2009=vax2009-vax1970
gen diff2008=vax2008-vax1970
drop if diff2009==. | ecode=="ROW"
keep enum ecode diff2008 diff2009
#d ;
graph bar diff2008, over(ecode, sort(diff2008) label(angle(90) labsize(small)))
	ylabel(-.3 (.05) .1) ytitle("Change from 1970 to 2008") plotregion(style(none)) 
	graphregion(fcolor(white) lwidth(none) ilwidth(none) margin());
graph export "./figures_and_tables/agg_vax_changes_by_country.pdf", replace;

#d cr
******************************************************************************
**Figure 3, Panel (b): Correlation of RGDP Growth and Changes in VAX Ratio
**Appendix Figure D1: Correlation of RGDP Growth and Within/Between Components
******************************************************************************

**Constant price, local currency GDP, downloaded from World Development Indicators
insheet using "./data/Download-GDPconstant-NCU-countries.csv", names clear
reshape long v, i(country currency indicatorname) j(year)
rename v value
replace year=year+1966
keep if indicatorname=="Total Value Added" | indicatorname=="Gross Domestic Product (GDP)"
replace indicatorname="RGDP" if indicatorname=="Gross Domestic Product (GDP)"
replace indicatorname="RVA" if indicatorname=="Total Value Added"

**Keep only countries we need
sort country
merge country using "./data/country_list.dta"
drop _merge
keep if keep==1
drop keep

**Merge on WB names
ren country un_country
sort un_country
merge un_country using "./data/WB_UN_names.dta"
drop if _merge==2
drop _merge
replace wb_countrycode="GBR" if un_country=="United Kingdom"
replace wb_countryname="United Kingdom" if un_country=="United Kingdom"

**Reshape and compute growth rates
keep wb_countrycode year value indicatorname
ren wb_countrycode ecode
reshape wide value, i(ecode year) j(indicatorname) string
sort ecode year
egen cnum=group(ecode)
tsset cnum year
gen lrvagrowth=log(valueRVA)-log(L.valueRVA)
gen lrgdpgrowth=log(valueRGDP)-log(L.valueRGDP)
keep ecode year l*
sort ecode year
save "./data/temp_growth", replace

**Use VAX data to compute between/within decomposition
use "./data/VAdataset.dta", clear
drop if ecode==icode
replace snum=1 if snum==2 | snum==4
replace snum=2 if snum==3
collapse (sum) exports vaexports, by(ecode enum ename year snum)
gen vax=vaexports/exports

by ecode year, sort: egen tx=total(exports)
gen xsh=exports/tx

egen group=group(ecode snum)
tsset group year

gen withinterm=(.5*xsh+.5*L.xsh)*(vax-L.vax)
gen betweenterm=(.5*vax+.5*L.vax)*(xsh-L.xsh)
gen vaxterm=xsh*vax
gen vaxtermL=L.xsh*L.vax
gen xsh_change=xsh-L.xsh
gen vax_change=vax-L.vax
drop exports vaexports tx

save "./data/temp", replace

keep ecode snum year withinterm betweenterm
reshape wide withinterm betweenterm, i(ecode year) j(snum)

**Merge VAX and Growth data
sort ecode year
merge ecode year using "./data/temp_growth"
keep if _merge==3
drop if year==1970
erase "./data/temp_growth.dta"

**Collapse and take averages
gen marker=1
drop if year==2009 /*excluding trade collapse*/
collapse (mean) withinterm1 withinterm2 (mean) betweenterm1 betweenterm2 (mean)  lrvagrowth lrgdpgrowth (sum) obs=marker, by(ecode)
gen within=withinterm1+withinterm2
gen between=betweenterm1+betweenterm2
gen vaxch=within+between

**Figure 3, Panel (b)
#d ;
sum obs;
local max=r(max);
twoway (scatter vaxch lrvagrowth if obs==`max', msymbol(i) mlabel(ecode) mlabsize(small) mlabposition(0) mlabcolor(navy))
	(scatter vaxch lrvagrowth if obs~=`max', msymbo(i) mlabel(ecode) mlabsize(small) mlabposition(0) mlabcolor(navy) mlabangle(vertical)) 
	(lfit vaxch lrvagrowth, lcolor(maroon)), 
	leg(off) xtitle("Ave. Annual Growth in Real GDP") ytitle("Ave. Annual Change")
	ylabel(-.01 (.002) .002)
	plotregion(style(none)) graphregion(fcolor(white) lwidth(none) ilwidth(none) margin());
graph export "./figures_and_tables/vax_gdp_growth.pdf", replace;

**Appendix Figure D1;
twoway (scatter between lrvagrowth if obs==`max', msymbol(i) mlabel(ecode) mlabsize(small) mlabposition(0) mlabcolor(navy)) 
	(scatter between lrvagrowth if obs~=`max', msymbo(i) mlabel(ecode) mlabsize(small) mlabposition(0) mlabcolor(navy) mlabangle(vertical))
	(lfit between lrvagrowth, lcolor(maroon)),
	leg(off) xtitle("Ave. Annual Growth in Real GDP Growth") ytitle("Ave. Annual Change") title("Between Term", color(black))
	plotregion(style(none)) graphregion(fcolor(white) lwidth(none) ilwidth(none) margin());
graph export "./figures_and_tables/between_growth.pdf", replace;
twoway (scatter within lrvagrowth if obs==`max', msymbol(i) mlabel(ecode) mlabsize(small) mlabposition(0) mlabcolor(navy)) 
	(scatter within lrvagrowth if obs~=`max', msymbo(i) mlabel(ecode) mlabsize(small) mlabposition(0) mlabcolor(navy) mlabangle(vertical))
	(lfit within lrvagrowth, lcolor(maroon)),
	leg(off) xtitle("Ave. Annual Growth in Real GDP Growth") ytitle("Ave. Annual Change") title("Within Term", color(black))
	plotregion(style(none)) graphregion(fcolor(white) lwidth(none) ilwidth(none) margin());	
graph export "./figures_and_tables/within_growth.pdf", replace;

#d cr
*************************************
**Appendix Table D1: World VAX ratios
*************************************
use "./data/VAdataset.dta", clear
drop if ecode==icode
collapse (sum) exports vaexports, by(year snum sname)
by year, sort: egen total=total(exports)
gen share=exports/total
gen vax=vaexports/exports
drop total sname vaexports exports
reshape wide vax share, i(year) j(snum)
order year vax1 share1 vax2 share2 vax3 share3 vax4 share4
sort year
gen world_vax_ratio= vax1* share1+ vax2* share2+ vax3* share3+ vax4* share4
format %9.2f vax1 share1 vax2 share2 vax3 share3 vax4 share4 world_vax_ratio
outsheet using "./figures_and_tables/world_vax_table.txt", replace

****************************************************************
**Appendix Table D2: Cumulative between/within changes for table
****************************************************************
use "./data/temp", clear
keep ecode ename snum year withinterm betweenterm xsh_change vax_change
reshape wide withinterm betweenterm xsh_change vax_change, i(ecode ename year) j(snum)
by ecode, sort: egen minyear=min(year)
by ecode, sort: egen maxyear=max(year)

gen marker=1
collapse (sum) withinterm1 withinterm2 (sum) betweenterm1 betweenterm2 (sum) xsh_change2 vax_change1 vax_change2 (sum) obs=marker (median) minyear maxyear, by(ecode ename)
gen within=withinterm1+withinterm2
gen between=betweenterm1+betweenterm2
gen vaxch=within+between

tostring minyear, replace
tostring maxyear, replace
gen dash="-"
gen range=minyear+dash+maxyear

drop if ecode=="ROW" /*drop ROW from the table*/
keep ename ecode range vaxch vax_change1 vax_change2 xsh_change2 within between

order ename ecode range vaxch vax_change1 vax_change2 xsh_change2 within between 
format %9.2f vaxch vax_change1 vax_change2 xsh_change2 within between 
sort ename
outsheet using "./figures_and_tables/sector_vax_decomposition.txt", replace

erase "./data/temp.dta"

