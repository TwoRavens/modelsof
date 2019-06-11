clear all
use data4election_rates.dta
set scheme s2mono

gen aux=1
egen numero=sum(aux), by(TT year_bd)

* Registration Rates: Bandwidth of 1 day (180 bins)
gen tasa=(numero/total_nac)*100
collapse (mean) tasa, by(TT)

* Polynomial variables
gen TT2=TT*TT/100
gen TT3=TT*TT2/100
gen TT4=TT*TT3/100
gen D0=0
replace D0=1 if TT>0
gen D1=TT*D0
forval i=2(1)4{
gen D`i'=TT`i'*D0
}

reg tasa TT  TT2 TT3 TT4 D0 D1 D2 D3 D4
predict tasa_pred

twoway (scatter tasa TT if TT>=-90 & TT<=90, m(o) mc(dknavy)) ///
(scatter tasa_pred TT if TT>=-90 & TT<0, c(j) m(i) lw(medthick) lc(cranberry) lp(solid)) ///
(scatter tasa_pred TT if TT>0 & TT<=90, c(j) m(i) lw(medthick) lc(cranberry) lp(solid)),  ///
xline(0, lp(dash) lcolor(gs12)) legend(off) xlabel(-90(30)90) xtitle("Days relative to CD") ytitle("Registration Rates[%]") ///
ylabel(, nogrid) graphr(ic(white) c(white)) ylabel(, grid glcolor(gs12)) 

graph save fig1_disc.gph, replace
graph export fig1_disc.png, replace

