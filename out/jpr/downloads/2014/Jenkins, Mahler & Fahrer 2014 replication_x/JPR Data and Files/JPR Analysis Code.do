*JPR Do File
use "G:\Egypt Insurgency\data\EGYINS (JPR).dta", clear

tsset governorate year, yearly
gen secswp2=securitysweep*securitysweep
gen execution2= execution*execution
gen l1ndp_elect= l1.ndp_elect
gen l1secswp= l1.securitysweep
gen l1secswp2= l1.secswp2
gen l1neighbor= l1.neighbor
gen l1execution= l1.execution
gen l1execution2= l1.execution2
gen l1contrause= l1.contrause
gen l1childmort= l1.childmort
gen l1urban= l1.urban
gen l1unemp_youth= l1.unemp_youth
gen l1unemp_edu= l1.unemp_edu
gen l1safewater= l1.safewater
gen l1enrollgap= l1.enrollgap
gen l1femlabor= l1.femlabor

*Table 1- Descriptive Statistics
xtsum isl_atk ndp_elect securitysweep neighbor execution contrause childmort urban unemp_youth unemp_edu safewater enrollgap femlabor
tabstat isl_atk ndp_elect securitysweep neighbor execution contrause childmort urban unemp_youth unemp_edu safewater enrollgap femlabor, s(mean p50 sd min max) c(s)
sort year
by year: tabstat isl_atk ndp_elect securitysweep neighbor execution contrause childmort urban unemp_youth unemp_edu safewater enrollgap femlabor, s(mean) c(s)

*Table 2
zinb isl_atk l1ndp_elect l1secswp l1secswp2 l1neighbor l1execution l1execution2, inflate(l1contrause l1childmort l1urban) iterate (50) r
zinb isl_atk l1ndp_elect l1secswp l1secswp2 l1neighbor l1execution l1execution2, inflate(l1contrause l1childmort l1urban l1unemp_youth) iterate (50) r 
zinb isl_atk l1ndp_elect l1secswp l1secswp2 l1neighbor l1execution l1execution2, inflate(l1contrause l1childmort l1urban l1unemp_edu) iterate (50) r 
zinb isl_atk l1ndp_elect l1secswp l1secswp2 l1neighbor l1execution l1execution2, inflate(l1contrause l1childmort l1urban l1safewater) iterate (50) r 
zinb isl_atk l1ndp_elect l1secswp l1secswp2 l1neighbor l1execution l1execution2, inflate(l1contrause l1childmort l1urban l1enrollgap) iterate (50) r
zinb isl_atk l1ndp_elect l1secswp l1secswp2 l1neighbor l1execution l1execution2, inflate(l1contrause l1childmort l1urban l1femlabor) iterate (50) r 

*Table 3
zinb isl_atk l1ndp_elect l1secswp l1secswp2 l1neighbor l1execution l1execution2 l1contrause, inflate(l1contrause l1childmort l1urban) iterate (50) r
zinb isl_atk l1ndp_elect l1secswp l1secswp2 l1neighbor l1execution l1execution2 l1childmort, inflate(l1contrause l1childmort l1urban) iterate (50) r 
zinb isl_atk l1ndp_elect l1secswp l1secswp2 l1neighbor l1execution l1execution2 l1urban, inflate(l1contrause l1childmort l1urban) iterate (50) r 
zinb isl_atk l1ndp_elect l1secswp l1secswp2 l1neighbor l1execution l1execution2, inflate(l1contrause l1childmort l1urban l1ndp_elect) iterate (50) r 
*zinb isl_atk l1ndp_elect l1secswp l1secswp2 l1neighbor l1execution l1execution2, inflate(l1contrause l1childmort l1urban l1secswp l1secswp2) iterate (50) r 
*Does not converge
zinb isl_atk l1ndp_elect l1secswp l1secswp2 l1neighbor l1execution l1execution2, inflate(l1contrause l1childmort l1urban l1neighbor) iterate (50) r 
zinb isl_atk l1ndp_elect l1secswp l1secswp2 l1neighbor l1execution l1execution2, inflate(l1contrause l1childmort l1urban l1execution l1execution2) iterate (50) r 

