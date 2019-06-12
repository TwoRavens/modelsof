


use "20171204_AJPS_MaleskyMosely_w_markups.dta", clear

/************************Figure 8******************************/

#delimit;
generate sector_test=1 if sector_plus=="C14";
replace sector_test=0 if sector_plus=="C22";
generate interaction_indiasector=India*sector_test;

#delimit;
label variable India "Treatment";
label values India India;
label define India 0 "Europe" 1"India";

#delimit;
label variable sector_test "identifiable";
label values sector_test sector_test;
label define sector_test 0 "Rubber/Plastic" 1"Wearing Apparel";


#delimit;
graph bar (mean) g13 if sector_test==1, scheme(s1mono) over(India) bar(1, lcolor(gs5) fcolor(gs5)) blabel(bar, size(medium) 
format(%2.1g)) title("Wearing Apparel (n=64)") ytitle("", size(medium) margin(medium)) ylab(0(1)9) note("Wald F-test=4.27; p=.069", size(small) ring(0) position(2));
graph save "hist_sector_India.gph", replace;

#delimit;
graph bar (mean) g13 if sector_test==0, scheme(s1mono) over(India) bar(1, fcolor(gs12)) blabel(bar, size(medium) 
format(%2.1g)) title("Rubber and Plastic (n=70)") ytitle("", size(medium) margin(medium)) ylab(0(1)9) note("Wald F-test=.93; p=.32", size(small) ring(0) position(2));
graph save "hist_sector_Europe.gph", replace;

graph combine "hist_sector_India.gph" "hist_sector_Europe.gph", xcommon ycommon imargin(tiny) scheme(s1mono)
subtitle("Average Change in Operation Costs (%)", position(9) orientation(vertical) size(medsmall) margin(medsmall)) ;
graph save "Figure6_pair_b&w.gph", replace;
graph export "Figure6_pair_b&w.pdf", as(pdf) replace;

/*********************Appendix J********************************/
#delimit;
reg g13 i.India if sector_test==1, robust;
outreg2 using "AppendixJ", tdec(3) bdec(3) e(rmse N_clust) 2aster replace;
reg g13 i.India if sector_test==0, robust;
outreg2 using "AppendixJ", tdec(3) bdec(3) e(rmse N_clust) 2aster;
reg g13 i.India##i.sector_test, robust;
outreg2 using "AppendixJ", tdec(3) bdec(3) e(rmse N_clust) 2aster ;
reg g13 i.India##i.sector_test  age hundred MNC MandA labor profitable exporter,  robust;
outreg2 using "AppendixJ", tdec(3) bdec(3) e(rmse N_clust) 2aster;

#delimit;
reg heap i.India if sector_test==1, robust;
outreg2 using "AppendixJ", tdec(3) bdec(3) e(rmse N_clust) 2aster;
reg heap i.India if sector_test==0, robust;
outreg2 using "AppendixJ", tdec(3) bdec(3) e(rmse N_clust) 2aster;
reg heap i.India##i.sector_test, robust;
outreg2 using "AppendixJ", tdec(3) bdec(3) e(rmse N_clust) 2aster ;
reg heap i.India##i.sector_test  age hundred MNC MandA labor profitable exporter,  robust;
outreg2 using "AppendixJ", tdec(3) bdec(3) e(rmse N_clust) 2aster excel;















