*This file creates all tables in the published version in ReStat. 

clear
cd "Q:\Oxcarre\bnt\hj_rest"

capture log close
log using hj_rest.log, replace

clear
clear mata
clear matrix

set matsize 10000
set maxvar 20000
set more off

use hj_rest.dta, clear 



*---------------------------------------------
*table 3:

eststo clear
foreach lag in "" "l." "l2." "l3." {
eststo: areg lu `lag'Dst l.lexportvalp l.lGDPcurrCAP lPOP CPIX i.cs if WBr!="HI", absorb(pt) cluster(cst)
}

foreach lag in "" "l." "l2." "l3." {
eststo: areg lu `lag'Dst l.lexportvalp l.lGDPcurrCAP lPOP CPIX i.cs if WBr=="HI", absorb(pt) cluster(cst)
}

esttab using hj_rest.rtf, replace label nogap cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0g %9.2f) labels(Observations "R-sq")) title(Table 3) drop(*.cs*) 



*----------------------------------------
*table 4:

eststo clear
foreach lag in "" "l." "l2." "l3." {
eststo: areg lu `lag'lDstage l.lexportvalp l.lGDPcurrCAP lPOP CPIX i.cs if WBr!="HI", absorb(pt) cluster(cst)
}

foreach lag in "" "l." "l2." "l3." {
eststo: areg lu `lag'lDstage l.lexportvalp l.lGDPcurrCAP lPOP CPIX i.cs if WBr=="HI", absorb(pt) cluster(cst)
}

esttab using hj_rest.rtf, append label nogap cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0g %9.2f) labels(Observations "R-sq")) title(Table 4) drop(*.cs*) 



*-----------------------------------------
*table 5:

eststo clear
foreach y in "_1" "_12" "_123" "_1234" {
eststo: areg lu Dst Dststyr`y' l.lexportvalp l.lGDPcurrCAP lPOP CPIX i.cs if WBr!="HI", absorb(pt) cluster(cst)
test Dst=Dststyr`y'
estadd scalar test_F=r(F)
estadd scalar test_p=r(p)
}

foreach y in "_1" "_12" "_123" "_1234" {
eststo: areg lu Dst Dststyr`y' l.lexportvalp l.lGDPcurrCAP lPOP CPIX i.cs if WBr=="HI", absorb(pt) cluster(cst)
test Dst=Dststyr`y'
estadd scalar test_F=r(F)
estadd scalar test_p=r(p)
}

esttab using hj_rest.rtf, append label nogap cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) stats(N r2 test_F test_p, fmt(%9.0g %9.2f) labels(Observations "R-sq")) title(Table 5) drop(*.cs*)  


*------------------------------------
*table 6:

eststo clear
foreach lag in "" "l." "l2." "l3." {
eststo: areg lu `lag'Dst l.ligr_fix_cap_formb l.lexportvalp l.lGDPcurrCAP lPOP CPIX i.cs if WBr!="HI", absorb(pt) cluster(cst)
}

foreach lag in "" "l." "l2." "l3." {
eststo: areg lu `lag'Dst l.ligr_fix_cap_formb l.lexportvalp l.lGDPcurrCAP lPOP CPIX i.cs if WBr=="HI", absorb(pt) cluster(cst)
}

esttab using hj_rest.rtf, append label nogap cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0g %9.2f) labels(Observations "R-sq")) title(Table 6) drop(*.cs*) 


*
*----------------------------------------
*table 7:

eststo clear
foreach lag in "" "l." {
eststo: areg lu `lag'Dst `lag'Dst_x_Drlib_n l.lexportvalp l.lGDPcurrCAP lPOP CPIX i.cs if WBr!="HI", absorb(pt) cluster(cst)
eststo: areg lu `lag'Dst `lag'Dst_x_s3 l.lexportvalp l.lGDPcurrCAP lPOP CPIX i.cs if WBr!="HI", absorb(pt) cluster(cst)
}

foreach lag in "" "l." {
eststo: areg lu `lag'Dst `lag'Dst_x_Drlib_n l.lexportvalp l.lGDPcurrCAP lPOP CPIX i.cs if WBr=="HI", absorb(pt) cluster(cst)
eststo: areg lu `lag'Dst `lag'Dst_x_s3 l.lexportvalp l.lGDPcurrCAP lPOP CPIX i.cs if WBr=="HI", absorb(pt) cluster(cst)
}

esttab using hj_rest.rtf, append label nogap cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0g %9.2f) labels(Observations "R-sq")) title(Table 7) drop(*.cs*) 



*-----------------------------------------
*Table 8

eststo clear
eststo: areg lu Dst Dst_x_icttr2 icttr2 l.lexportvalp l.lGDPcurrCAP lPOP CPIX i.cs if WBr!="HI", absorb(pt) cluster(cst)
eststo: areg lu l.Dst Dst_lag_x_icttr2 icttr2 l.lexportvalp l.lGDPcurrCAP lPOP CPIX i.cs if WBr!="HI", absorb(pt) cluster(cst)

eststo: areg lu Dst Dst_x_icttr2 icttr2 l.lexportvalp l.lGDPcurrCAP lPOP CPIX i.cs if WBr=="HI", absorb(pt) cluster(cst)
eststo: areg lu l.Dst Dst_lag_x_icttr2 icttr2 l.lexportvalp l.lGDPcurrCAP lPOP CPIX i.cs if WBr=="HI", absorb(pt) cluster(cst)

esttab using hj_rest.rtf, append label nogap cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0g %9.2f) labels(Observations "R-sq")) title(Table 8) drop(*.cs*) 



*-----------------------------------------
*Table 9

eststo clear
foreach lag in "" "l." "l2." "l3." {
eststo: areg rflu `lag'Dst l.lexportvalp l.lGDPcurrCAP lPOP CPIX i.cs if WBr!="HI", absorb(pt) cluster(cst)
}

foreach lag in "" "l." "l2." "l3." {
eststo: areg rflu `lag'Dst l.lexportvalp l.lGDPcurrCAP lPOP CPIX i.cs if WBr=="HI", absorb(pt) cluster(cst)
}

esttab using hj_rest.rtf, append label nogap cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0g %9.2f) labels(Observations "R-sq")) title(Table 9) drop(*.cs*) 
*-------------------------------------




*----------------------------------------
*Table 4 with "Length of targeting 2":
*A comment on the length of targeting, table 4: Our variable of interest in this paper, Sector targeted, is an indicator variable taking the value of 1 if a sector in country c in year t was targeted by the country’s investment promotion agency. In one specification, presented in table 4, we also investigated the effect of the length of sector targeting; the number of years a country-sector had been targeted in year t. In year t, this variable is defined as the sum of our indicator variable over the period (s, t), where s is the first year we observe the indicator variable. In table 4 we defined the length of sector targeting within our sample. Since unit values for all SITC4 products are not observed in all countries in all years, we have an unbalanced panel. Defining the length of sector targeting within our sample implies that the length of sector targeting depends on whether we observe a particular country-product-year and that the length of sector targeting can take different values within the same country-sector in year t. As an alternative approach, we have re-run the regressions in table 4 with a variable "length of sector targeting 2" being the same across all products, counted from the first country-sector-year for which we observe the indicator variable. The results are presented below and confirm our findings in table 4. 

eststo clear
foreach lag in "" "l." "l2." "l3." {
eststo: areg lu `lag'liDstnewage l.lexportvalp l.lGDPcurrCAP lPOP CPIX i.cs if WBr!="HI", absorb(pt) cluster(cst)
}

foreach lag in "" "l." "l2." "l3." {
eststo: areg lu `lag'liDstnewage l.lexportvalp l.lGDPcurrCAP lPOP CPIX i.cs if WBr=="HI", absorb(pt) cluster(cst)
}

esttab using hj_rest.rtf, append label nogap cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0g %9.2f) labels(Observations "R-sq")) title(Table 4) drop(*.cs*) 


capture log close


