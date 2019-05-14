#delimit;
cap cd "C:\Users\ejm5\Dropbox\PartipationCompliance\AER-QJE-The Moon\Replication";
use "Data\20181106_RCT_Clean.dta", clear;
set more off;
drop if success !=1;


/*Heterogenous Effect by Size -- Appendix N*/

#delimit;
/*Consolidate Size Categories*/
set more off;
generate size2=1 if  r1_emp<=2;
replace size2=2 if  r1_emp>2 & r1_emp<=4;
replace size2=3 if  r1_emp>4 & r1_emp<=5;
generate size2_plus=size2+.25;


#delimit;
label variable size2 "Consolidated Size of Firm";
label values size2 size2;
label define size2 1 "<10 Employees" 2 "10-200 Employees" 3 ">200 Employees";


#delimit;
set more off;
areg access i.treatment1##i.size2 i.treatment2##i.size2 hanoi female, cluster(fe_provcatsector) absorb(r1_catsector);
outreg2 using "Tables\TableN1", tdec(3) bdec(3) e(N_clust rmse) replace;
areg access i.treatment1##i.size2 i.treatment2##i.size2 hanoi female i.enumerator, cluster(fe_provcatsector) absorb(r1_catsector);
outreg2 using "Tables\TableN1", tdec(3) bdec(3) e(N_clust rmse);
areg subjective_mean i.treatment1##i.size2 i.treatment2##i.size2 hanoi female, cluster(fe_provcatsector) absorb(r1_catsector);
outreg2 using "Tables\TableN1", tdec(3) bdec(3) e(N_clust rmse);
areg subjective_mean i.treatment1##i.size2 i.treatment2##i.size2 hanoi female i.enumerator, cluster(fe_provcatsector) absorb(r1_catsector);
outreg2 using "Tables\TableN1", tdec(3) bdec(3) e(N_clust rmse) excel;



#delimit;
set more off;
areg access i.treatment1##i.size2 i.treatment2##i.size2 hanoi female, cluster(fe_provcatsector) absorb(r1_catsector);

margins, dydx(treatment2)  by(size2);

#delimit;
marginsplot, ciopts(lwidth(thick) lpattern(dash)) plotopts( msize(medlarge) msymbol(diamond) mcolor(gs14)) level(95) 
	yline(0, lpattern(shortdash) lcolor(maroon) lwidth(medium)) ylab(, labsize(small))
	xtitle("")
	title("Marginal Effect of Size on Prediction", size(medlarge) margin(medsmall))
	ytitle("Avg. Marginal Effect w/90 CIs", size(medium) margin(medium))
	xlab(1(1)3)
	ylab(-.6(.1).2)  scheme(s1mono);
graph save mfx.gph, replace;	
	
#delimit;
	twoway (hist size2 if treatment2==0, discrete freq bcolor(gs4) barwidth(.5)) (hist size2_plus if treatment2==1, freq discrete
	bcolor(gs14) barwidth(.5)), legend(rows(2) label(1 "Placebo/Treatment1") label(2 "Treatment2") 
	size(small) ring(0) position(1)) xlabel(1(1)3, valuelabel) xtitle(, size(medium) margin(medium))
	ylab(, labsize(small))
	title("Frequency of Observations at Each Size Level", size(medlarge) margin(medsmall))
	ytitle("Number", size(medium) margin(medium))  scheme(s1mono);
graph save hist.gph, replace;	
	

#delimit;
graph combine mfx.gph hist.gph, xcommon imargin(tiny) rows(2) title("Access to Factory", size(medium))  scheme(s1mono);
graph save Figure_Accessparticipation_mfx.gph, replace;






/*****************Overall Index********************/

#delimit;
areg subjective_mean i.treatment1##i.size2 i.treatment2##i.size2 hanoi female, cluster(fe_provcatsector) absorb(r1_catsector);

margins, dydx(treatment2)  by(size2);

#delimit;
marginsplot, ciopts(lwidth(thick) lpattern(dash)) plotopts( msize(medlarge) msymbol(diamond) mcolor(gs14)) level(95) 
	yline(0, lpattern(shortdash) lcolor(maroon) lwidth(medium)) ylab(, labsize(small))
	xtitle("")
	title("Marginal Effect of Size on Prediction", size(medlarge) margin(medsmall))
	ytitle("Avg. Marginal Effect w/90 CIs", size(medium) margin(medium))
	xlab(1(1)3)
	ylab(-.6(.1).2)  scheme(s1mono);
graph save mfx.gph, replace;	
	
#delimit;
	twoway (hist size2 if treatment2==0 & access==1, discrete freq bcolor(gs4) barwidth(.5)) (hist size2_plus if treatment2==1 & access==1, freq discrete
	bcolor(gs14) barwidth(.5)), legend(rows(2) label(1 "Placebo/Treatment1") label(2 "Treatment2") 
	size(small) ring(0) position(1)) xlabel(1(1)3, valuelabel) xtitle(, size(medium) margin(medium))
	ylab(, labsize(small))
	title("Frequency of Observations at Each Size Level", size(medlarge) margin(medsmall))
	ytitle("Number", size(medium) margin(medium))  scheme(s1mono);
graph save hist.gph, replace;	
	

#delimit;
graph combine mfx.gph hist.gph, xcommon imargin(tiny) rows(2) title("Total Compliance", size(medlarge))  scheme(s1mono);
graph save Figure_Total_participation_mfx.gph, replace;



#delimit;
graph combine Figure_Accessparticipation_mfx.gph Figure_Total_participation_mfx.gph, xcommon imargin(tiny) cols(2) scheme(s1mono);
graph save "Figures\FigureN2_HetSize.gph", replace;
graph export "Figures\FigureN2_HetSize.pdf", as(pdf) replace;
