
use "20171204_AJPS_MaleskyMosely_w_markups.dta", clear
set more off

/*Which sectors*/
tabstat export_potential, by(sector_plus)


/*****************************************Figure 3***********************************************/

#delimit;
generate case=1 if sector_plus=="C14"|sector_plus=="C22";
replace case=0 if case==.;
lab var case "Cases Used in Figure 6";

generate overlap=1 if sector_id==6|sector_id==7|sector_id==3|sector_id==14|sector_id==12|sector_id==4;


#delimit;
twoway(scatter   share_intermediate ln_delta_markup if export_potential==1 & overlap !=1, 
	msize(vsmall) mlabel(sector_id) mlabsize(vsmall) mcolor(black) mlabcolor(navy) msymbol(diamond)   mlabposition(9))
	(scatter   share_intermediate ln_delta_markup if export_potential==1 & overlap ==1, 
	msize(vsmall) mlabel(sector_id) mlabsize(vsmall) mcolor(black) mlabcolor(navy)  mlabposition(3))	
(scatter share ln_delta if case==1, mcolor(gs7) msize(ehuge) msymbol(circle_hollow)), 
ytitle("Share of Intermediate to Total Trade Flows (%)", size(medsmall) margin(medium)) 
xtitle("Difference in Markups between (Europe-India,ln)", 
size(medsmall) margin(medium)) xline(1.25, lcolor(gs10) lwidth(medthick) lpattern(dash)) 
yline(.53, lcolor(gs10) lwidth(medthick) lpattern(dash)) scheme(s1mono) legend(off)
note("Dashed lines depict mean values of the axes.", size(small));
graph save "Figure3_Scatter_b&w.gph", replace;
graph export "Figure3_Scatteb&w.pdf", as(pdf) replace;
graph export "Figure3_Scatteb&w.tif", as(tif) replace;



/******************************************Appendix H********************************************/
/*Correlations between approaches to Markups*/

#delimit;
pwcorr ln_delta_markup markup_eu2 markup_india PCI_markup, star(5);
mkcorr ln_delta_markup markup_eu2 markup_india PCI_markup, label log("AppendixH") sig replace;

/*****************************************Figure 4***********************************************/

#delimit;
interflex g13 India ln_delta_markup age hundred MNC MandA labor profitable exporter  if export_potential==1,
fe(pci_id country_id) vce(cluster) cluster(strata2) dlabel("'India'") xlabel("Difference in Markups (ln)") ylabel("Operating Costs");
graph save "Figure4_hetmark.gph", replace;
graph export "Figure4_hetmark.pdf", as(pdf) replace;

/*****************************************Figure 5***********************************************/
#delimit;
interflex g13 India share_intermediate age hundred MNC MandA labor profitable exporter  if export_potential==1, 
fe(pci_id country_id) vce(cluster) cluster(strata2) dlabel("'India'") xlabel("Share of Intermediates") ylabel("Operating Costs"); 
graph save "Figure5_hetshare.gph", replace;
graph export "Figure5_hetshare.pdf", as(pdf) replace;


/****************************************APPENDIX G************************************************/
#delimit;
set more off;
areg g13 i.India##c.ln_delta_markup i.pci_id if export_potential==1, absorb(country_id) cluster(strata2);
outreg2 using "AppendixG1", tdec(3) bdec(3) e(rmse N_clust) 2aster  replace ;
areg g13 i.India##c.ln_delta_markup age hundred MNC MandA labor profitable exporter i.pci_id if export_potential==1, absorb(country_id) cluster(strata2);
outreg2 using "AppendixG1", tdec(3) bdec(3) e(rmse N_clust) 2aster;
areg g13 i.India##c.share_intermediate i.pci_id if export_potential==1, absorb(country_id) cluster(strata2);
outreg2 using "AppendixG1", tdec(3) bdec(3) e(rmse N_clust) 2aster;
areg g13 i.India##c.share_intermediate age hundred MNC MandA labor profitable exporter i.pci_id if export_potential==1, absorb(country_id) cluster(strata2);
outreg2 using "AppendixG1", tdec(3) bdec(3) e(rmse N_clust) 2aster;
areg g13 i.India##c.ln_delta_markup i.India##c.share_intermediate  i.pci_id if export_potential==1, absorb(country_id) cluster(strata2);
outreg2 using "AppendixG1", tdec(3) bdec(3) e(rmse N_clust) 2aster;
areg g13 i.India##c.ln_delta_markup i.India##c.share_intermediate age hundred MNC MandA labor profitable exporter i.pci_id if export_potential==1, absorb(country_id) cluster(strata2);
outreg2 using "AppendixG1", tdec(3) bdec(3) e(rmse N_clust) 2aster;
areg g13 i.India##c.PCI_markup age hundred MNC MandA labor profitable exporter i.pci_id if export_potential==1, absorb(country_id) cluster(strata2);
outreg2 using "AppendixG1", tdec(3) bdec(3) e(rmse N_clust) 2aster;
areg g13 i.India##c.PCI_markup i.India##c.share_intermediate age hundred MNC MandA labor profitable exporter i.pci_id if export_potential==1, absorb(country_id) cluster(strata2);
outreg2 using "AppendixG1", tdec(3) bdec(3) e(rmse N_clust) 2aster excel;

areg heap i.India##c.ln_delta_markup i.pci_id if export_potential==1, absorb(country_id) cluster(strata2);
outreg2 using "AppendixG2", tdec(3) bdec(3) e(rmse N_clust) 2aster replace;
areg heap i.India##c.ln_delta_markup age hundred MNC MandA labor profitable exporter i.pci_id if export_potential==1, absorb(country_id) cluster(strata2);
outreg2 using "AppendixG2", tdec(3) bdec(3) e(rmse N_clust) 2aster;
areg heap i.India##c.share_intermediate i.pci_id if export_potential==1, absorb(country_id) cluster(strata2);
outreg2 using "AppendixG2", tdec(3) bdec(3) e(rmse N_clust) 2aster;
areg heap i.India##c.share_intermediate age hundred MNC MandA labor profitable exporter i.pci_id if export_potential==1, absorb(country_id) cluster(strata2);
outreg2 using "AppendixG2", tdec(3) bdec(3) e(rmse N_clust) 2aster;
areg heap i.India##c.ln_delta_markup i.India##c.share_intermediate i.pci_id if export_potential==1, absorb(country_id) cluster(strata2);
outreg2 using "AppendixG2", tdec(3) bdec(3) e(rmse N_clust) 2aster;
areg heap i.India##c.ln_delta_markup i.India##c.share_intermediate age hundred MNC MandA labor profitable exporter i.pci_id if export_potential==1, absorb(country_id) cluster(strata2);
outreg2 using "AppendixG2", tdec(3) bdec(3) e(rmse N_clust) 2aster;
areg heap i.India##c.PCI_markup age hundred MNC MandA labor profitable exporter i.pci_id if export_potential==1, absorb(country_id) cluster(strata2);
outreg2 using "AppendixG2", tdec(3) bdec(3) e(rmse N_clust) 2aster;
areg heap i.India##c.PCI_markup i.India##c.share_intermediate age hundred MNC MandA labor profitable exporter i.pci_id if export_potential==1, absorb(country_id) cluster(strata2);
outreg2 using "AppendixG2", tdec(3) bdec(3) e(rmse N_clust) excel;














