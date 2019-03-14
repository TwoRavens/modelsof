



/*Use Completed Dataset*/
use "20171204_AJPS_MaleskyMosely_w_markups.dta", clear


/****************************************************************/

/*Figure 2*/
#delimit;
twoway (kdensity g13  if India==1  & export_potential==1, lwidth(thick) lcolor(gs5)) (kdensity g13 if India==0  & export_potential==1, lwidth(thick) lcolor(gs12) lpattern(dash)), 
ytitle("Kernal Density", size(medsmall) margin(medsmall)) xtitle("Predicted Adjustment/Operating Costs (%)", 
size(medsmall) margin(medsmall)) title("Continuous Operating Costs") legend(rows(2) size(vsmall) label(1 India) label(2 Europe) ring(0) position(1))
note("n=886; India 421; Europe 465",ring(0) size(small)) scheme(s1mono);
graph save "kdensity.gph", replace;

#delimit;
twoway (hist heap if India==1  & export_potential==1, percent fcolor(gs5) lwidth(thick)) 
(hist heap2 if India==0  & export_potential==1, percent fcolor(gs12) lwidth(thick)), 
xlab(1(1)4, valuelabel) ytitle("Share of Observations (%)", size(medsmall) margin(medsmall)) xtitle("Predicted Adjustment/Operating Costs (%)", 
size(medsmall) margin(medsmall)) title("Binned Operating Costs") legend(rows(2) size(vsmall) label(1 India) label(2 Europe) ring(0) position(1))
note("") scheme(s1mono);
graph save "kdensity_heap.gph", replace;

#delimit;
graph combine "kdensity.gph" "kdensity_heap.gph",  scheme(s1mono) imargin(small);
graph save "Figure2_money_b&w.gph", replace;
graph export "Figure2_money_b&w.pdf", as(pdf) replace;



/****************************************************************/

/*Table 2*/
#delimit;
set more off;
reg g13 India, cluster(strata);
outreg2 using "Table2", tdec(3) bdec(3) e(rmse N_clust)  2aster replace;
reg g13 India if export_potential==1, cluster(strata);
outreg2 using "Table2", tdec(3) bdec(3)  2aster e(rmse N_clust) ;
reg g13 India i.country_id if export_potential==1, cluster(strata);
outreg2 using "Table2", tdec(3) bdec(3)  2aster e(rmse N_clust) ;
reg g13 India i.country_id i.sector_id if export_potential==1, cluster(strata);
outreg2 using "Table2", tdec(3) bdec(3)  2aster e(rmse N_clust) ;
reg g13 India i.country_id i.sector_id i.pci_id if export_potential==1, cluster(strata);
outreg2 using "Table2", tdec(3) bdec(3)  2aster e(rmse N_clust);

reg heap India, cluster(strata);
outreg2 using "Table2", tdec(3) bdec(3)  2aster e(rmse N_clust) ;
reg heap India if export_potential==1, cluster(strata);
outreg2 using "Table2", tdec(3) bdec(3)  2aster e(rmse N_clust) ;
reg heap India i.country_id if export_potential==1, cluster(strata);
outreg2 using "Table2", tdec(3) bdec(3)  2aster e(rmse N_clust) ;
reg heap India i.country_id i.sector_id if export_potential==1, cluster(strata);
outreg2 using "Table2", tdec(3) bdec(3)  2aster e(rmse N_clust) ;
reg heap India i.country_id i.sector_id i.pci_id if export_potential==1, cluster(strata);
outreg2 using "Table2", tdec(3) bdec(3)  2aster e(rmse N_clust) excel;



/**************************************************************************APPENIDX D Wild SEs********************************************************************************/



/*All Firms in Exportable Sectors note("Red line shows p=.1; Dots on line show 90% CI with SEs calculated using Wild Cluster Bootstrap", size(tiny) ring(0) position(5))*/
#delimit;
set more off;
preserve;
keep if export_potential==1;
xi: reg g13 India India i.country_id i.sector_id i.pci_id, cluster(strata);
constraint 1 India=0;
#delimit;
boottest, seed(20160909) reps(1000) level(95) graphopt(scheme(s1mono) title("Continuous Operating Costs") xtitle("India Treatment - Europe Treatment", size(medsmall) margin(medsmall)) 
xline(0, lcolor(purple) lpattern(dash) lwidth(medthick)) ylab(0(.1)1, labsize(small)) yline(.1, lcolor(black) lpattern(shortdash) lwidth(thin))
ytitle("Rejection p-value from Wild Cluster Bootstrap SEs", size(small) margin(medsmall)) note("Wald F-Test=3.74, P-Value=.065", ring(0) position(5) size(vsmall)) 
 xlab(-2(.5)2)) ;
graph save "wild_se_export.gph", replace;
restore;



/*All Firms in Exportable Sectors note("Red line shows p=.1; Dots on line show 90% CI with SEs calculated using Wild Cluster Bootstrap", size(tiny) ring(0) position(5))*/
#delimit;
preserve;
keep if export_potential==1;
xi: reg heap India i.country_id i.sector_id i.pci_id, cluster(strata);
constraint 1 India==0;
#delimit;
boottest, seed(20160909) level(95) reps(1000) graphopt(scheme(s1mono) title("Binned Operating Costs") xtitle("India Treatment - Europe Treatment", size(medsmall) margin(medsmall)) 
xline(0, lcolor(purple) lpattern(dash) lwidth(medthick)) ylab(0(.1)1, labsize(small)) yline(.1, lcolor(black) lpattern(shortdash) lwidth(thin))
ytitle("Rejection p-value from Wild Cluster Bootstrap SEs", size(small) margin(medsmall)) note("Wald F-Test=6.83, P-Value=.01", ring(0) position(5) size(vsmall))
 xlab(-.5(.1).5)) ;
graph save "wild_se_heap.gph", replace;
restore;

#delimit;
graph combine "wild_se_export.gph" "wild_se_heap.gph",  scheme(s1mono) imargin(small) title("Firms in Exporting Sectors");
graph save "wild_exportable.gph", replace;


/*All Firms note("Red line shows p=.1; Dots on line show 90% CI with SEs calculated using Wild Cluster Bootstrap", size(tiny) ring(0) position(5))*/
#delimit;
set more off;
preserve;
xi: reg g13 India India i.country_id i.sector_id i.pci_id, cluster(strata);
constraint 1 India=0;
#delimit;
boottest, seed(20160909) reps(1000) level(95) graphopt(scheme(s1mono) title("Continuous Operating Costs") xtitle("India Treatment - Europe Treatment", size(medsmall) margin(medsmall)) 
xline(0, lcolor(purple) lpattern(dash) lwidth(medthick)) ylab(0(.1)1, labsize(small)) yline(.1, lcolor(black) lpattern(shortdash) lwidth(thin))
ytitle("Rejection p-value from Wild Cluster Bootstrap SEs", size(small) margin(medsmall)) note("Wald F-Test=3.74, P-Value=.063", ring(0) position(5) size(vsmall)) 
 xlab(-2(.5)2)) ;
graph save "wild_se_export.gph", replace;
restore;



/*All Firms note("Red line shows p=.1; Dots on line show 90% CI with SEs calculated using Wild Cluster Bootstrap", size(tiny) ring(0) position(5))*/
#delimit;
preserve;
xi: reg heap India i.country_id i.sector_id i.pci_id, cluster(strata);
constraint 1 India==0;
#delimit;
boottest, seed(20160909) level(95) reps(1000) graphopt(scheme(s1mono) title("Binned Operating Costs") xtitle("India Treatment - Europe Treatment", size(medsmall) margin(medsmall)) 
xline(0, lcolor(purple) lpattern(dash) lwidth(medthick)) ylab(0(.1)1, labsize(small)) yline(.1, lcolor(black) lpattern(shortdash) lwidth(thin))
ytitle("Rejection p-value from Wild Cluster Bootstrap SEs", size(small) margin(medsmall)) note("Wald F-Test=7.63, P-Value=.005", ring(0) position(5) size(vsmall))
 xlab(-.5(.1).5)) ;
graph save "wild_se_heap.gph", replace;
restore;

graph combine "wild_se_export.gph" "wild_se_heap.gph",  scheme(s1mono) imargin(small) title("All Firms");
graph save "wild_all.gph", replace;


#delimit;
graph combine "wild_exportable.gph" "wild_all.gph", rows(2) scheme(s1mono) imargin(small);
graph save "AppendixD_heap.gph", replace;
graph export "AppendixD_heap.pdf", as(pdf) replace;







/************************************************Appendix D******************************************************************************************************/

/*Approaches to Standard Errors*/
#delimit; 
set more off;
reg g13 India i.country_id i.sector_id i.pci_id;
outreg2 using "AppendixE_Panel1", tdec(3) bdec(3) e(rmse N_clust) addtext("Classic SEs") 2aster replace;
reg g13 India i.country_id i.sector_id i.pci_id if export_potential==1;
outreg2 using "AppendixE_Panel1", tdec(3) bdec(3) e(rmse N_clust) addtext("Classic SEs") 2aster;
reg g13 India i.country_id i.sector_id i.pci_id, robust;
outreg2 using "AppendixE_Panel1", tdec(3) bdec(3) e(rmse N_clust) addtext("Robust SEs") 2aster;
reg g13 India i.country_id i.sector_id i.pci_id if export_potential==1, robust;
outreg2 using "AppendixE_Panel1", tdec(3) bdec(3) e(rmse N_clust) addtext("Robust SEs") 2aster;
reg g13 India i.country_id i.sector_id i.pci_id, cluster(pci_id);
outreg2 using "AppendixE_Panel1", tdec(3) bdec(3) e(rmse N_clust) addtext("Cluster Province") 2aster;
reg g13 India i.country_id i.sector_id i.pci_id if export_potential==1, cluster(pci_id);
outreg2 using "AppendixE_Panel1", tdec(3) bdec(3) e(rmse N_clust) addtext("Cluster Province") 2aster;
reg g13 India i.country_id i.sector_id i.pci_id, cluster(strata);
outreg2 using "AppendixE_Panel1", tdec(3) bdec(3) e(rmse N_clust) addtext("Cluster Strata") 2aster;
reg g13 India i.country_id i.sector_id i.pci_id if export_potential==1, cluster(strata);
outreg2 using "AppendixE_Panel1", tdec(3) bdec(3) e(rmse N_clust) addtext("Cluster Strata") 2aster;

reg g13 India i.country_id i.sector_id i.pci_id, cluster(strata2);
outreg2 using "AppendixE_Panel1", tdec(3) bdec(3) e(rmse N_clust) addtext("Cluster Province/Country") 2aster;
reg g13 India i.country_id i.sector_id i.pci_id if export_potential==1, cluster(strata2);
outreg2 using "AppendixE_Panel1", tdec(3) bdec(3) e(rmse N_clust) addtext("Cluster Province/Country") 2aster excel;


#delimit; 
set more off;
reg heap India i.country_id i.sector_id i.pci_id;
outreg2 using "AppendixE_Panel2", tdec(3) bdec(3) e(rmse N_clust) addtext("Classic SEs") 2aster replace;
reg heap India i.country_id i.sector_id i.pci_id if export_potential==1;
outreg2 using "AppendixE_Panel2", tdec(3) bdec(3) e(rmse N_clust) addtext("Classic SEs") 2aster;
reg heap India i.country_id i.sector_id i.pci_id, robust;
outreg2 using "AppendixE_Panel2", tdec(3) bdec(3) e(rmse N_clust) addtext("Robust SEs") 2aster;
reg heap India i.country_id i.sector_id i.pci_id if export_potential==1, robust;
outreg2 using "AppendixE_Panel2", tdec(3) bdec(3) e(rmse N_clust) addtext("Robust SEs") 2aster;
reg heap India i.country_id i.sector_id i.pci_id, cluster(pci_id);
outreg2 using "AppendixE_Panel2", tdec(3) bdec(3) e(rmse N_clust) addtext("Cluster Province") 2aster;
reg heap India i.country_id i.sector_id i.pci_id if export_potential==1, cluster(pci_id);
outreg2 using "AppendixE_Panel2", tdec(3) bdec(3) e(rmse N_clust) addtext("Cluster Province") 2aster;
reg heap India i.country_id i.sector_id i.pci_id, cluster(strata);
outreg2 using "AppendixE_Panel2", tdec(3) bdec(3) e(rmse N_clust) addtext("Cluster Strata") 2aster;
reg heap India i.country_id i.sector_id i.pci_id if export_potential==1, cluster(strata);
outreg2 using "AppendixE_Panel2", tdec(3) bdec(3) e(rmse N_clust) addtext("Cluster Strata") 2aster;
reg heap India i.country_id i.sector_id i.pci_id, cluster(strata2);
outreg2 using "AppendixE_Panel2", tdec(3) bdec(3) e(rmse N_clust) addtext("Cluster Province/Country") 2aster;
reg heap India i.country_id i.sector_id i.pci_id if export_potential==1, cluster(strata2);
outreg2 using "AppendixE_Panel2", tdec(3) bdec(3) e(rmse N_clust) addtext("Cluster Province/Country") 2aster excel;


/************************************Appendix F**************************************/

/*Drop firms from or already doing business in India or Europe*/

#delimit;
preserve;
keep if export_potential==1 & indian==0 & European==0 & destination_India==0 & destination_Europe==0;
set more off;
reg g13 India, cluster(strata);
outreg2 using "AppendixF", tdec(3) bdec(3) e(rmse N_clust) 2aster replace;
reg g13 India if export_potential==1, cluster(strata);
outreg2 using "AppendixF", tdec(3) bdec(3) e(rmse N_clust) 2aster;
reg g13 India i.country_id if export_potential==1, cluster(strata);
outreg2 using "AppendixF", tdec(3) bdec(3) e(rmse N_clust) 2aster ;
reg g13 India i.country_id i.sector_id if export_potential==1, cluster(strata);
outreg2 using "AppendixF", tdec(3) bdec(3) e(rmse N_clust) 2aster;
reg g13 India i.country_id i.sector_id i.pci_id if export_potential==1, cluster(strata);
outreg2 using "AppendixF", tdec(3) bdec(3) e(rmse N_clust) 2aster;

reg heap India, cluster(strata);
outreg2 using "AppendixF", tdec(3) bdec(3) e(rmse N_clust) 2aster;
reg heap India if export_potential==1, cluster(strata);
outreg2 using "AppendixF", tdec(3) bdec(3) e(rmse N_clust) 2aster;
reg heap India i.country_id if export_potential==1, cluster(strata);
outreg2 using "AppendixF", tdec(3) bdec(3) e(rmse N_clust) 2aster;
reg heap India i.country_id i.sector_id if export_potential==1, cluster(strata);
outreg2 using"AppendixF", tdec(3) bdec(3) e(rmse N_clust) 2aster;
reg heap India i.country_id i.sector_id i.pci_id if export_potential==1, cluster(strata);
outreg2 using "AppendixF", tdec(3) bdec(3) e(rmse N_clust) 2aster excel;






























