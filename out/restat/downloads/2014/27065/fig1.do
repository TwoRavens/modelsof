use "firm-level.dta", clear
drop if year<=1981|year>=2006

gen R=sales*price
egen TS =sum(sales)                 , by(year)
egen TSb=sum(sales) if firm~="OTHER", by(year)
egen TR =sum(R)                     , by(year)
egen HHI =sum((sales/TS )^2)                 , by(year)
egen HHIb=sum((sales/TSb)^2) if firm~="OTHER", by(year)
egen HHIc=sum((R/TR)^2)                      , by(year)

egen Tpat = sum(pat_app)                   , by(year)
egen Tpatb= sum(pat_app) if firm~="OTHER"  , by(year)
egen Mpat =mean(pat_app/R)                 , by(year)
egen Mpatb=mean(pat_app/R) if firm~="OTHER", by(year)

replace Mpat=Mpat*1000000

for num 2/3: gen HHIX=HHI^X \ gen HHIbX=HHIb^X \ gen HHIcX=HHIc^X \ gen RX=R^X 
regress Mpat HHI  HHI2  /* HHI3 */
predict PMpat
regress Mpat HHIb HHIb2 HHIb3
predict PMpatb
regress Mpat HHIc HHIc2 HHIc3
predict PMpatc
regress Tpat HHI HHI2 HHI3
predict PTpat
regress Tpat HHIb HHIb2 HHIb3
predict PTpatb
label var Mpat  "Mean patent applications per sales (mil. $)"
label var PMpat "Fitted values "
twoway  (scatter Mpat  HHI, mcolor(navy)) (line PMpat HHI, sort lcolor(maroon) lpattern(dash)), nodraw xlabel(0.1 0.11 0.12) xscale(range(0.093 0.127)) xtitle("Herfindahl Index (of market share)", margin(small))  t1title("(a) Market-level") scheme(s1color) name(Mpat, replace)
*twoway (scatter Mpatb HHIb) (line PMpatb HHIb, sort)
*twoway (scatter Mpat  HHIc) (line PMpatc HHIc, sort)
*twoway (scatter Tpat  HHI)  (line PTpat  HHI,  sort)
*twoway (scatter Tpatb HHIb) (line PTpatb HHIb, sort)

regress pat_app R R2 R3
predict P1
xtreg pat_app R R2 R3, i(year) fe
predict P2
label var pat_app "Patent applications"
label var P2      "Fitted values"
replace R=R/1000000
twoway (scatter pat_app R, mcolor(navy)) (line P2 R, sort lcolor(maroon) lpattern(dash)), nodraw xlabel(0 50 100 150) xscale(range(0 175)) ylabel(0 500 1000) yscale(range(0 1300)) xtitle("Firm-level sales (mil. $)", margin(small))  t1title("(b) Firm-level") scheme(s1color) name(pat, replace)

graph combine Mpat pat, cols(1) xsize(2.6)

