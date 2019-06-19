// Figure 1. Investment change by investment type, triple diff
use "eseewithinfirm.dta", clear

tab category 
levelsof category 
forvalues yr =2004/2010 {
cap drop dummyyr
gen dummyyr=(year==`yr')
foreach cat in `r(levels)' {
cap drop dummycat
gen dummycat=(category=="`cat'")
gen yr`yr'Xcat`cat'Xdomfir=dummyyr*domfir*dummycat
gen yr`yr'Xcat`cat'=dummyyr*dummycat
cap drop cat`cat'Xdomfir
gen  cat`cat'Xdomfir=domfir*dummycat
}
}
cap drop *catadv*
xi: xtreg lnval yr*Xcat* yr*Xcat*Xdomfir cat*Xdomfir i.category , fe cluster(firmid)

parmest, norestore
forvalues yr=2004/2010 {
foreach cat in rd inv_fur inv_veh inv_it inv_mach rd {
drop if parm=="yr`yr'Xcat`cat'"
}
}
drop if estimate==0
drop if parm=="_cons"
drop if length(parm)<19
gen year=substr(parm, strpos(parm,"yr")+2,4)
destring year, replace
sort year
gen category=substr(parm,strpos(parm,"X")+4,length(parm)-17)
keep estimate min95 max95 category year
replace category="Furniture" if category=="inv_fur"
replace category="IT" if category=="inv_it"
replace category="Machinery" if category=="inv_mach"
replace category="Vehicles" if category=="inv_veh"
replace category="RD" if category=="rd"
drop if category==""
reshape wide estimate min95 max95, i(year) j(category) string
tsset year
set scheme s2color
tsline estimateIT estimateRD estimateVehicles estimateMachinery estimateFurniture, lcol(gs12 gs9 gs6 gs3 gs0) xtitle("Year") ytitle("Coefficients")
graph export "figure1.png", replace
