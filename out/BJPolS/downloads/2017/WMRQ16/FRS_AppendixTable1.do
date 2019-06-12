**** Appendix Table 1

use "levada2011.dta"

eststo clear
reg emppress monogorod1 male logage ordeduc logincome townsize region* if empstatus==1, robust
estpost margins, dydx(_all)
eststo margins1
reg emppress monogorod1 male logage ordeduc logincome townsize government stateenterprise if empstatus==1, robust
estpost margins, dydx(_all)
eststo margins2
reg emppress monogorod1 male logage ordeduc logincome townsize putinopponent turnout2007 if empstatus==1, robust
estpost margins, dydx(_all)
eststo margins3
reg emppress monogorod1 male logage ordeduc logincome townsize government stateenterprise putinopponent turnout2007 if empstatus==1, robust
estpost margins, dydx(_all)
eststo margins4
reg emppress monogorod1 male logage ordeduc logincome townsize government stateenterprise putinopponent turnout2007 region* if empstatus==1, robust
estpost margins, dydx(_all)
eststo margins5

esttab margins1 margins2 margins3 margins4 margins5 using "appendix_mon.tex", replace b(%9.3f) booktabs eqlabels(none) noconstant se margin label star(* 0.10 ** 0.05 *** 0.01) mtitles("Model""Model""Model""Model""Model""Model") indicate("Region Fixed Effects = region*") addnote ("Dependent Variable: Employer Pressure on Voters.") title("Employer Pressure on Voters - 2011 Parliamentary Elections")



