clear all
cd "H:\Superstars\Submission RESTAT\"

use "4. Figure 4\input\CYH2.dta", clear
rename c country
rename h2 hs2
rename y year
g value=A1*A6i
destring hs2, replace
keep if year>=2006 & year<=2008
keep country hs2 year value
g str industry=""
replace ind="Fo" if hs2>=1 & hs2<=24
replace ind="Mi" if hs2>=25 & hs2 <=27
replace ind="Ch" if hs2>=28 & hs2 <=38
replace ind="Pl" if hs2>=39 & hs2 <=40
replace ind="Wo" if (hs2>=44 & hs2 <=46) 
replace ind="Pa" if (hs2>=47 & hs2 <=49) 
replace ind="Te" if (hs2>=50 & hs2 <=59) 
replace ind="Ap" if (hs>=41 & hs2<=43)|(hs2>=60 & hs2 <=67)
replace ind="Gl" if hs2>=68 & hs2 <=70
replace ind="PM" if hs2==71
replace ind="Me" if hs2>=72 & hs2 <=83
replace ind="Ma" if hs2==84 
replace ind="El" if  hs2==85
replace ind="Tr" if hs2>=86 & hs2 <=89
replace ind="Mis" if ind==""
collapse (sum) value, by(country year indust)
egen tot=sum(value), by(country year)
g sh=value/tot
drop value tot
collapse (mean) sh, by(country indust)
reshape wide sh, i(country) str j(industry)
sort country
save "4. Figure 4\input\industry_share1.dta", replace
****plots at the CY level for top 1 and top 10 exporters
use "1. Figure 1\input\SSvaluesbytype.dta", clear
g shareSSnr1=sumSSnr1/total
g shareSSnr2=sumSSnr2/total
g shareSSnr5=sumSSnr5/total
g shareSSnr10=sumSSnr10/total
keep country year share*
sort country year 
merge n:1 country year using "4. Figure 4\input\gdps4merge.dta"
drop if _m==2
drop _m
g lngdp=ln(gdp_ppp_cons)
g lngdppc=ln(gdppc_ppp_cons)
collapse (mean) shareSSnr1 shareSSnr2 shareSSnr5 shareSSnr10 lngdp lngdppc, by(country)
*purging sectors
merge 1:1 country using "4. Figure 4\input\industry_share1"
keep if _merge==3
drop _
replace shEl=0 if shEl==.
replace shMa=0 if shMa==.
replace shTr=0 if shTr==.

reg shareSSnr1 lngdp shAp shCh shEl shFo shGl shMa shMe shMi shMis shPM shPa shPl shTe shTr shWo
predict resid, residuals
twoway (scatter resid lngdppc, mlabel(c) mlabsize (small) title(Share of Top Exporter - lnGDPpc) ytitle(Share Top 1) xtitle(Ln GDPpc) legend(off) mcolor(dknavy) mlabcolor(dknavy) ) || lfit  resid lngdppc
drop resid
graph save Graph "4. Figure 4\F4_TOP1_C&I.gph", replace
reg shareSSnr2 lngdp shAp shCh shEl shFo shGl shMa shMe shMi shMis shPM shPa shPl shTe shTr shWo
predict resid, residuals
twoway (scatter resid lngdppc, mlabel(c) mlabsize (small) title(Share of Top 2 Exporters - lnGDPpc) ytitle(Share Top 2) xtitle(Ln GDPpc) legend(off) mcolor(dknavy) mlabcolor(dknavy) ) || lfit  resid lngdppc
drop resid
graph save Graph "4. Figure 4\F4_TOP2_C&I.gph", replace
reg shareSSnr5 lngdp shAp shCh shEl shFo shGl shMa shMe shMi shMis shPM shPa shPl shTe shTr shWo
predict resid, residuals
twoway (scatter resid lngdppc, mlabel(c) mlabsize (small) title(Share of Top 5 Exporters - lnGDPpc) ytitle(Share Top 5) xtitle(Ln GDPpc) legend(off) mcolor(dknavy) mlabcolor(dknavy) ) || lfit  resid lngdppc
drop resid
graph save Graph "4. Figure 4\F4_TOP5_C&I.gph", replace
reg shareSSnr1 lngdp 
predict resid, residuals
twoway (scatter resid lngdppc, mlabel(c) mlabsize (small) title(Share of Top Exporter - lnGDPpc) ytitle(Share Top 1) xtitle(Ln GDPpc) legend(off) mcolor(dknavy) mlabcolor(dknavy) ) || lfit  resid lngdppc
drop resid
graph save Graph "4. Figure 4\F4_TOP1_C.gph", replace
reg shareSSnr2 lngdp 
predict resid, residuals
twoway (scatter resid lngdppc, mlabel(c) mlabsize (small) title(Share of Top 2 Exporters - lnGDPpc) ytitle(Share Top 2) xtitle(Ln GDPpc) legend(off) mcolor(dknavy) mlabcolor(dknavy) ) || lfit  resid lngdppc
drop resid
graph save Graph "4. Figure 4\F4_TOP2_C.gph", replace
reg shareSSnr5 lngdp 
predict resid, residuals
twoway (scatter resid lngdppc, mlabel(c) mlabsize (small) title(Share of Top 5 Exporters - lnGDPpc) ytitle(Share Top 5) xtitle(Ln GDPpc) legend(off) mcolor(dknavy) mlabcolor(dknavy) ) || lfit  resid lngdppc
drop resid
graph save Graph "4. Figure 4\F4_TOP5_C.gph", replace

erase "4. Figure 4\input\industry_share1.dta"
