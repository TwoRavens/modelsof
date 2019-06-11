clear all
use data4election_rates.dta
set scheme s2mono

*Election: Municipal 2008
keep if  year_bd==1990

gen aux=1
egen numero=sum(aux), by(TT year_bd)

* Registration Rates: Bandwidth of 1 day (180 bins)
gen tasa=(numero/total_nac)*100

twoway (scatter tasa TT if TT>=-100 & TT<120, m(o) mc(dknavy)), ///
xline(0, lpattern(dash) lcolor(gs12)) xline(90, lpattern(dash) lcolor(gs12)) legend(off) xtitle("") ///
xlabel(90 "10/26" 60 "09/26" 30 "08/26"  0 "07/26" -30 "06/26" -60 "05/26" -90 "04/26") xtitle("Dates") ///
ylabel(, nogrid) ytitle("Registrations per day [%]") graphr(ic(white) c(white)) ylabel(, grid glcolor(gs12)) 

graph save fig0_disc.gph, replace
graph export fig0_disc.png, replace

