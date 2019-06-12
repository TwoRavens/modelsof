// Replication Code - Supplementary Material
// Bolleyer, Nicole and Ruth, Saskia
// Conceptualizing and Measuring Party Institutionalization in New Democracies
// Journal of Politics

********************************************************************************
*
* STATA 14 Code
*
* Data Sources: Democratic Accountability & Linkages Project (Kitschelt 2013)
*               Polity IV Data (Marschall, Jaggers, and Gurr 2013)
*               Latin American Regulation of Political Parties (Molenaar 2012)
*               www.rulers.org; www.ipu.org/parline/
*
********************************************************************************

use PILA_2017.dta, clear

// Descriptive Statistics - Table S1

sum routinization valueinf polar enpp subsid legisoff execoff group formation page

// Figure S1: Dimensions of Routinization: Local Offices (A1) and Local Intermediaries (A3)
scatter formal informal, ///
	xtitle("(Informal) Local Intermediaries") ///
	ytitle("(Formal) Local Offices") ///
	xscale(range(0 1)) xtick(0 (0.2) 1) xlabel(0 (0.2) 1) ///
	yscale(range(0 1)) ytick(0 (0.2) 1) ylabel(0 (0.2) 1) 

pwcorr formal informal, sig

// Figure S2: Party Expert Means of Party Identification (E4)
scatter  value_uncertain loyalty, ///
	xtitle("Party Identification (E4)") ///
	ytitle("Expert Uncertainty (Benoit and Laver 2006)") ///
	xscale(range(0.2 1)) xtick(0.2 (0.2) 1) xlabel(0.2 (0.2) 1) ///
	yscale(range(0 1)) ytick(0 (0.2) 1) ylabel(0 (0.2) 1) 

	
// Figure S3: Country Patterns
* ARG
twoway (scatter valueinf routinization if country!=10, mc(gs10) msiz(small)) ///
	(scatter valueinf routinization if country==10, mc(black) msiz(medium) ///
	mlabel(ptyid) mlabc(black) mlabsize(medlarge) mlabpos(3)) ///
	|| lfit valueinf routinization, legend(off) lp(solid) lc(black) ///
	title("Argentina") xtitle("Routinization") ytitle("Value Infusion") ///
	xline(.5, lp(shortdash) lc(gs8)) yline(.5, lp(shortdash) lc(gs8)) ///
	graphregion(color(white)) ///
	xscale(range(0 1)) xtick(0 (0.2) 1) xlabel(0 (0.2) 1) ///
	yscale(range(0 1)) ytick(0 (0.2) 1) ylabel(0 (0.2) 1, nogrid) 
graph save argPI.gph, replace

* BOL
twoway (scatter valueinf routinization if country!=11, mc(gs10) msiz(small)) ///
	(scatter valueinf routinization if country==11, mc(black) msiz(medium) ///
	mlabel(ptyid) mlabc(black) mlabsize(medlarge) mlabpos(3)) ///
	|| lfit valueinf routinization, legend(off) lp(solid) lc(black) ///
	title("Bolivia") xtitle("Routinization") ytitle("Value Infusion") ///
	xline(.5, lp(shortdash) lc(gs8)) yline(.5, lp(shortdash) lc(gs8)) ///
	graphregion(color(white)) ///
	xscale(range(0 1)) xtick(0 (0.2) 1) xlabel(0 (0.2) 1) ///
	yscale(range(0 1)) ytick(0 (0.2) 1) ylabel(0 (0.2) 1, nogrid) 
graph save bolPI.gph, replace

* BRA
twoway (scatter valueinf routinization if country!=12, mc(gs10) msiz(small)) ///
	(scatter valueinf routinization if country==12, mc(black) msiz(medium) ///
	mlabel(ptyid) mlabc(black) mlabsize(medlarge) mlabpos(9)) ///
	|| lfit valueinf routinization, legend(off) lp(solid) lc(black) ///
	title("Brazil") xtitle("Routinization") ytitle("Value Infusion") ///
	xline(.5, lp(shortdash) lc(gs8)) yline(.5, lp(shortdash) lc(gs8)) ///
	graphregion(color(white)) ///
	xscale(range(0 1)) xtick(0 (0.2) 1) xlabel(0 (0.2) 1) ///
	yscale(range(0 1)) ytick(0 (0.2) 1) ylabel(0 (0.2) 1, nogrid) 
graph save braPI.gph, replace
	
* CHL
twoway (scatter valueinf routinization if country!=13, mc(gs10) msiz(small)) ///
	(scatter valueinf routinization if country==13, mc(black) msiz(medium) ///
	mlabel(ptyid) mlabc(black) mlabsize(medlarge) mlabpos(9)) ///
	|| lfit valueinf routinization, legend(off) lp(solid) lc(black) ///
	title("Chile") xtitle("Routinization") ytitle("Value Infusion") ///
	xline(.5, lp(shortdash) lc(gs8)) yline(.5, lp(shortdash) lc(gs8)) ///
	graphregion(color(white)) ///
	xscale(range(0 1)) xtick(0 (0.2) 1) xlabel(0 (0.2) 1) ///
	yscale(range(0 1)) ytick(0 (0.2) 1) ylabel(0 (0.2) 1, nogrid) 
graph save chlPI.gph, replace

* COL
twoway (scatter valueinf routinization if country!=14, mc(gs10) msiz(small)) ///
	(scatter valueinf routinization if country==14, mc(black) msiz(medium) ///
	mlabel(ptyid) mlabc(black) mlabsize(medlarge) mlabpos(9)) ///
	|| lfit valueinf routinization, legend(off) lp(solid) lc(black) ///
	title("Colombia") xtitle("Routinization") ytitle("Value Infusion") ///
	xline(.5, lp(shortdash) lc(gs8)) yline(.5, lp(shortdash) lc(gs8)) ///
	graphregion(color(white)) ///
	xscale(range(0 1)) xtick(0 (0.2) 1) xlabel(0 (0.2) 1) ///
	yscale(range(0 1)) ytick(0 (0.2) 1) ylabel(0 (0.2) 1, nogrid) 
graph save colPI.gph, replace

* CRI
twoway (scatter valueinf routinization if country!=15, mc(gs10) msiz(small)) ///
	(scatter valueinf routinization if country==15, mc(black) msiz(medium) ///
	mlabel(ptyid) mlabc(black) mlabsize(medlarge) mlabpos(3)) ///
	|| lfit valueinf routinization, legend(off) lp(solid) lc(black) ///
	title("Costa Rica") xtitle("Routinization") ytitle("Value Infusion") ///
	xline(.5, lp(shortdash) lc(gs8)) yline(.5, lp(shortdash) lc(gs8)) ///
	graphregion(color(white)) ///
	xscale(range(0 1)) xtick(0 (0.2) 1) xlabel(0 (0.2) 1) ///
	yscale(range(0 1)) ytick(0 (0.2) 1) ylabel(0 (0.2) 1, nogrid) 
graph save criPI.gph, replace

* ECU
twoway (scatter valueinf routinization if country!=16, mc(gs10) msiz(small)) ///
	(scatter valueinf routinization if country==16, mc(black) msiz(medium) ///
	mlabel(ptyid) mlabc(black) mlabsize(medlarge) mlabpos(9)) ///
	|| lfit valueinf routinization, legend(off) lp(solid) lc(black) ///
	title("Ecuador") xtitle("Routinization") ytitle("Value Infusion") ///
	xline(.5, lp(shortdash) lc(gs8)) yline(.5, lp(shortdash) lc(gs8)) ///
	graphregion(color(white)) ///
	xscale(range(0 1)) xtick(0 (0.2) 1) xlabel(0 (0.2) 1) ///
	yscale(range(0 1)) ytick(0 (0.2) 1) ylabel(0 (0.2) 1, nogrid) 
graph save ecuPI.gph, replace

* ELS
twoway (scatter valueinf routinization if country!=17, mc(gs10) msiz(small)) ///
	(scatter valueinf routinization if country==17, mc(black) msiz(medium) ///
	mlabel(ptyid) mlabc(black) mlabsize(medlarge) mlabpos(9)) ///
	|| lfit valueinf routinization, legend(off) lp(solid) lc(black) ///
	title("El Salvador") xtitle("Routinization") ytitle("Value Infusion") ///
	xline(.5, lp(shortdash) lc(gs8)) yline(.5, lp(shortdash) lc(gs8)) ///
	graphregion(color(white)) ///
	xscale(range(0 1)) xtick(0 (0.2) 1) xlabel(0 (0.2) 1) ///
	yscale(range(0 1)) ytick(0 (0.2) 1) ylabel(0 (0.2) 1, nogrid) 
graph save elsPI.gph, replace
	
* GTM
twoway (scatter valueinf routinization if country!=18, mc(gs10) msiz(small)) ///
	(scatter valueinf routinization if country==18, mc(black) msiz(medium) ///
	mlabel(ptyid) mlabc(black) mlabsize(medlarge) mlabpos(3)) ///
	|| lfit valueinf routinization, legend(off) lp(solid) lc(black) ///
	title("Guatemala") xtitle("Routinization") ytitle("Value Infusion") ///
	xline(.5, lp(shortdash) lc(gs8)) yline(.5, lp(shortdash) lc(gs8)) ///
	graphregion(color(white)) ///
	xscale(range(0 1)) xtick(0 (0.2) 1) xlabel(0 (0.2) 1) ///
	yscale(range(0 1)) ytick(0 (0.2) 1) ylabel(0 (0.2) 1, nogrid) 
graph save gtmPI.gph, replace

* HND
twoway (scatter valueinf routinization if country!=19, mc(gs10) msiz(small)) ///
	(scatter valueinf routinization if country==19, mc(black) msiz(medium) ///
	mlabel(ptyid) mlabc(black) mlabsize(medlarge) mlabpos(3)) ///
	|| lfit valueinf routinization, legend(off) lp(solid) lc(black) ///
	title("Honduras") xtitle("Routinization") ytitle("Value Infusion") ///
	xline(.5, lp(shortdash) lc(gs8)) yline(.5, lp(shortdash) lc(gs8)) ///
	graphregion(color(white)) ///
	xscale(range(0 1)) xtick(0 (0.2) 1) xlabel(0 (0.2) 1) ///
	yscale(range(0 1)) ytick(0 (0.2) 1) ylabel(0 (0.2) 1, nogrid) 
graph save hndPI.gph, replace

* MEX
twoway (scatter valueinf routinization if country!=20, mc(gs10) msiz(small)) ///
	(scatter valueinf routinization if country==20, mc(black) msiz(medium) ///
	mlabel(ptyid) mlabc(black) mlabsize(medlarge) mlabpos(9)) ///
	|| lfit valueinf routinization, legend(off) lp(solid) lc(black) ///
	title("Mexico") xtitle("Routinization") ytitle("Value Infusion") ///
	xline(.5, lp(shortdash) lc(gs8)) yline(.5, lp(shortdash) lc(gs8)) ///
	graphregion(color(white)) ///
	xscale(range(0 1)) xtick(0 (0.2) 1) xlabel(0 (0.2) 1) ///
	yscale(range(0 1)) ytick(0 (0.2) 1) ylabel(0 (0.2) 1, nogrid) 
graph save mexPI.gph, replace

* NIC
twoway (scatter valueinf routinization if country!=21, mc(gs10) msiz(small)) ///
	(scatter valueinf routinization if country==21, mc(black) msiz(medium) ///
	mlabel(ptyid) mlabc(black) mlabsize(medlarge) mlabpos(9)) ///
	|| lfit valueinf routinization, legend(off) lp(solid) lc(black) ///
	title("Nicaragua") xtitle("Routinization") ytitle("Value Infusion") ///
	xline(.5, lp(shortdash) lc(gs8)) yline(.5, lp(shortdash) lc(gs8)) ///
	graphregion(color(white)) ///
	xscale(range(0 1)) xtick(0 (0.2) 1) xlabel(0 (0.2) 1) ///
	yscale(range(0 1)) ytick(0 (0.2) 1) ylabel(0 (0.2) 1, nogrid) 
graph save nicPI.gph, replace

* PAN
twoway (scatter valueinf routinization if country!=22, mc(gs10) msiz(small)) ///
	(scatter valueinf routinization if country==22, mc(black) msiz(medium) ///
	mlabel(ptyid) mlabc(black) mlabsize(medlarge) mlabpos(9)) ///
	|| lfit valueinf routinization, legend(off) lp(solid) lc(black) ///
	title("Panama") xtitle("Routinization") ytitle("Value Infusion") ///
	xline(.5, lp(shortdash) lc(gs8)) yline(.5, lp(shortdash) lc(gs8)) ///
	graphregion(color(white)) ///
	xscale(range(0 1)) xtick(0 (0.2) 1) xlabel(0 (0.2) 1) ///
	yscale(range(0 1)) ytick(0 (0.2) 1) ylabel(0 (0.2) 1, nogrid) 
graph save panPI.gph, replace

* PAR
twoway (scatter valueinf routinization if country!=23, mc(gs10) msiz(small)) ///
	(scatter valueinf routinization if country==23, mc(black) msiz(medium) ///
	mlabel(ptyid) mlabc(black) mlabsize(medlarge) mlabpos(9)) ///
	|| lfit valueinf routinization, legend(off) lp(solid) lc(black) ///
	title("Paraguay") xtitle("Routinization") ytitle("Value Infusion") ///
	xline(.5, lp(shortdash) lc(gs8)) yline(.5, lp(shortdash) lc(gs8)) ///
	graphregion(color(white)) ///
	xscale(range(0 1)) xtick(0 (0.2) 1) xlabel(0 (0.2) 1) ///
	yscale(range(0 1)) ytick(0 (0.2) 1) ylabel(0 (0.2) 1, nogrid) 
graph save parPI.gph, replace

* PER
twoway (scatter valueinf routinization if country!=24, mc(gs10) msiz(small)) ///
	(scatter valueinf routinization if country==24, mc(black) msiz(medium) ///
	mlabel(ptyid) mlabc(black) mlabsize(medlarge) mlabpos(9)) ///
	|| lfit valueinf routinization, legend(off) lp(solid) lc(black) ///
	title("Peru") xtitle("Routinization") ytitle("Value Infusion") ///
	xline(.5, lp(shortdash) lc(gs8)) yline(.5, lp(shortdash) lc(gs8)) ///
	graphregion(color(white)) ///
	xscale(range(0 1)) xtick(0 (0.2) 1) xlabel(0 (0.2) 1) ///
	yscale(range(0 1)) ytick(0 (0.2) 1) ylabel(0 (0.2) 1, nogrid) 
graph save perPI.gph, replace

* RDO
twoway (scatter valueinf routinization if country!=25, mc(gs10) msiz(small)) ///
	(scatter valueinf routinization if country==25, mc(black) msiz(medium) ///
	mlabel(ptyid) mlabc(black) mlabsize(medlarge) mlabpos(9)) ///
	|| lfit valueinf routinization, legend(off) lp(solid) lc(black) ///
	title("Dominican Republic") xtitle("Routinization") ytitle("Value Infusion") ///
	xline(.5, lp(shortdash) lc(gs8)) yline(.5, lp(shortdash) lc(gs8)) ///
	graphregion(color(white)) ///
	xscale(range(0 1)) xtick(0 (0.2) 1) xlabel(0 (0.2) 1) ///
	yscale(range(0 1)) ytick(0 (0.2) 1) ylabel(0 (0.2) 1, nogrid) 
graph save rdoPI.gph, replace

* URY
twoway (scatter valueinf routinization if country!=26, mc(gs10) msiz(small)) ///
	(scatter valueinf routinization if country==26, mc(black) msiz(medium) ///
	mlabel(ptyid) mlabc(black) mlabsize(medlarge) mlabpos(9)) ///
	|| lfit valueinf routinization, legend(off) lp(solid) lc(black) ///
	title("Uruguay") xtitle("Routinization") ytitle("Value Infusion") ///
	xline(.5, lp(shortdash) lc(gs8)) yline(.5, lp(shortdash) lc(gs8)) ///
	graphregion(color(white)) ///
	xscale(range(0 1)) xtick(0 (0.2) 1) xlabel(0 (0.2) 1) ///
	yscale(range(0 1)) ytick(0 (0.2) 1) ylabel(0 (0.2) 1, nogrid) 
graph save uryPI.gph, replace

* VEN
twoway (scatter valueinf routinization if country!=27, mc(gs10) msiz(small)) ///
	(scatter valueinf routinization if country==27, mc(black) msiz(medium) ///
	mlabel(ptyid) mlabc(black) mlabsize(medlarge) mlabpos(3)) ///
	|| lfit valueinf routinization, legend(off) lp(solid) lc(black) ///
	title("Venezuela") xtitle("Routinization") ytitle("Value Infusion") ///
	xline(.5, lp(shortdash) lc(gs8)) yline(.5, lp(shortdash) lc(gs8)) ///
	graphregion(color(white)) ///
	xscale(range(0 1)) xtick(0 (0.2) 1) xlabel(0 (0.2) 1) ///
	yscale(range(0 1)) ytick(0 (0.2) 1) ylabel(0 (0.2) 1, nogrid) 
graph save venPI.gph, replace

graph combine argPI.gph bolPI.gph braPI.gph chlPI.gph colPI.gph criPI.gph ///
	rdoPI.gph ecuPI.gph elsPI.gph gtmPI.gph hndPI.gph mexPI.gph ///
	nicPI.gph panPI.gph parPI.gph perPI.gph uryPI.gph venPI.gph, row(3) col(6)
 
* Figure S4: Parties with Executive Dominance (>20 and >10 consecutive years in office)

scatter valueinf routinization if ptyid== 1001 | ptyid==2001 | ptyid==2301, ///
	mc(red) msiz(vsmall) mlabel(ptyid) mlabc(red) mlabsize(vsmall) mlabpos(9) || ///
	scatter valueinf routinization if ptyid==1401 | ptyid==1701 | ptyid==2102 | ///
	ptyid==2502 | ptyid==2701, mc(black) msiz(vsmall) mlabel(ptyid) ///
	mlabc(black) mlabsize(vsmall) mlabpos(9) ///
	legend(off) xtitle("Routinization") ytitle("Value Infusion") ///
	xline(.5, lp(dash) lc(gs10)) yline(.5, lp(dash) lc(gs10)) mlabel(ptyid) ///
	xscale(range(0 1)) xtick(0 (0.2) 1) xlabel(0 (0.2) 1) ///
	yscale(range(0 1)) ytick(0 (0.2) 1) ylabel(0 (0.2) 1) mlabpos(9)

	
// Table S4 - Multilevel Models
global x1 polar enpp subsid legisoff execoff formation group page

xtmixed routinization || country:, var reml
est sto rout_base
estat ic
estat icc
xtmixed routinization $x1 || country:, var reml
est sto rout_mix1
estat ic
estat icc

xtmixed valueinf || country:, var reml
est sto value_base
estat ic
estat icc
xtmixed valueinf $x1 || country:, var reml
est sto value_mix1
estat ic
estat icc	

* Tabel S4
esttab rout_base rout_mix1 value_base value_mix1 using table_s4.rtf, replace nogaps nodepvars ///
	compress se stats(N ll bic) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) b(2)
	
// Table S5 - State Funding Control & Single-Party Dominance & Government Experience
global x2 polar enpp subsid legisoff execoff group formation page dependency
global x3 polar enpp subsid legisoff execoff group formation page coalition
global x4 polar enpp subsid legisoff execoff dependency group formation page dominant	


* ROUTINIZATION
reg routinization $x2, cluster(country)
est sto rout_2
reg routinization $x3, cluster(country)
est sto rout_3
reg routinization $x4, cluster(country)
est sto rout_4

* VALUE INFUSION	
reg valueinf $x2, cluster(country)
est sto value_2
reg valueinf $x3, cluster(country)
est sto value_3
reg valueinf $x4, cluster(country)
est sto value_4

esttab rout_* value_* using table_s5.rtf, replace nogaps nodepvars ///
	compress se stats(N r2_a F) star(* 0.05 ** 0.01 *** 0.001) b(2)


// Table S5 & S6 - Endogeneity Checks H4 and H5
* Dependent Variable: Presidential Office (t2)
global x5 incumbent_t2 seatshare_t1	polar enpp

logit president_t2 routinization_t1 $x5 if seatshare_t2!=., cluster(country)
est sto endo_pres1
logit president_t2 valueinf_t1 $x5 if seatshare_t2!=., cluster(country)
est sto endo_pres2
logit president_t2 partyinst_t1 $x5 if seatshare_t2!=., cluster(country)
est sto endo_pres3

* Dependent Variable: Legislative Office (t2)
reg seatshare_t2 routinization_t1 $x5, cluster(country)
est sto endo_leg1
reg seatshare_t2 valueinf_t1 $x5
est sto endo_leg2
reg seatshare_t2 partyinst_t1 $x5, cluster(country)
est sto endo_leg3

esttab endo_* using table_s6.rtf, replace nogaps nodepvars ///
	compress se stats(N r2_a F) star(* 0.05 ** 0.01 *** 0.001) b(2)


// Table S7 - Makro Control Variables

reg routinization $x1 gdppc regime volat, cluster(country)
est sto rout_macro
reg valueinf $x1 gdppc regime volat, cluster(country)
est sto value_macro

esttab rout_macro value_macro using table_s7.rtf, replace nogaps nodepvars ///
	compress se stats(N r2_a F) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) b(2)
