

*Figure 1
bysort regione_num: sum m5s_share

*Descriptive Statistics: table 2
sum m5s_share F_rate imm_rate ideology log_voters delta_unemployment abstentiondif age_mean

*table 4
eststo: reg m5s_share F_rate imm_rate ideology log_voters regione1-regione20, vce(cluster regione_num)
eststo: reg m5s_share F_rate imm_rate ideology log_voters delta_unemployment regione1-regione20, vce(cluster regione_num)
eststo: reg m5s_share F_rate imm_rate ideology log_voters delta_unemployment abstentiondif regione1-regione20 , vce(cluster regione_num)
eststo: reg m5s_share F_rate imm_rate ideology log_voters delta_unemployment abstentiondif age_mean regione1-regione20, vce(cluster regione_num)
eststo: reg m5s_share F_rate imm_rate ideology log_voters delta_unemployment abstentiondif age_mean interaction1bis regione1-regione20, vce(cluster regione_num)
eststo: reg m5s_share F_rate imm_rate ideology log_voters delta_unemployment abstentiondif age_mean interaction2 regione1-regione20, vce(cluster regione_num)

esttab using Table1.rtf, ///
	label title (Empirical analysis) nonumbers mtitles ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6") ///
	starlevels(* 0.1 ** 0.05 *** 0.01) ///
	b(3) se(3) r2 ///  
	varlabels(_cons Constant) replace
	
eststo clear

	
	
*table A2
**model 1
eststo: xi: reg m5s_share F_rate imm_rate log_voters ideology i.province, vce(cluster province)
eststo: xtmixed m5s_share F_rate imm_rate ideology log_voters || regione_num:, mle variance 
eststo: reg m5s_share F_rate imm_rate ideology ideology2 log_voters regione1-regione20, vce(cluster regione_num)
eststo: reg m5s_share F_rate imm_rate ideologybis log_voters regione1-regione20, vce(cluster regione_num)

esttab using Model1.rtf, ///
	label title (Empirical analysis) nonumbers mtitles ("Model 1" "Model 2" "Model 3" "Model 4") ///
	starlevels(* 0.1 ** 0.05 *** 0.01) ///
	b(3) se(3) r2 ///  
	varlabels(_cons Constant) replace

eststo clear



*model 2
eststo: xi: reg m5s_share F_rate imm_rate log_voters ideology delta_unemployment i.province, vce(cluster province)
eststo: xtmixed m5s_share F_rate imm_rate ideology log_voters delta_unemployment || regione_num:, mle variance 
eststo: reg m5s_share F_rate imm_rate ideology ideology2 log_voters delta_unemployment regione1-regione20, vce(cluster regione_num)
eststo: reg m5s_share F_rate imm_rate ideologybis log_voters delta_unemployment regione1-regione20, vce(cluster regione_num)

esttab using Model2.rtf, ///
	label title (Empirical analysis) nonumbers mtitles ("Model 1" "Model 2" "Model 3" "Model 4") ///
	starlevels(* 0.1 ** 0.05 *** 0.01) ///
	b(3) se(3) r2 ///  
	varlabels(_cons Constant) replace

eststo clear



*model 3
eststo: xi: reg m5s_share F_rate imm_rate log_voters ideology delta_unemployment abs_rate_09 i.province, vce(cluster province)
eststo: xtmixed m5s_share F_rate imm_rate ideology log_voters delta_unemployment abs_rate_09 || regione_num:, mle variance 
eststo: reg m5s_share F_rate imm_rate ideology ideology2 log_voters delta_unemployment abs_rate_09 regione1-regione20, vce(cluster regione_num)
eststo: reg m5s_share F_rate imm_rate ideologybis log_voters delta_unemployment abs_rate_09 regione1-regione20, vce(cluster regione_num)
eststo: reg m5s_share F_rate imm_rate ideology log_voters delta_unemployment abs_rate_09 regione1-regione20, vce(cluster regione_num)

esttab using Model3.rtf, ///
	label title (Empirical analysis) nonumbers mtitles ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5") ///
	starlevels(* 0.1 ** 0.05 *** 0.01) ///
	b(3) se(3) r2 ///  
	varlabels(_cons Constant) replace

eststo clear



*model 4
eststo: xi: reg m5s_share F_rate imm_rate log_voters ideology delta_unemployment abs_rate_09 age_mean i.province, vce(cluster province)
eststo: xtmixed m5s_share F_rate imm_rate ideology log_voters delta_unemployment abs_rate_09 age_mean || regione_num:, mle variance 
eststo: reg m5s_share F_rate imm_rate ideology ideology2 log_voters delta_unemployment abs_rate_09 age_mean regione1-regione20, vce(cluster regione_num)
eststo: reg m5s_share F_rate imm_rate ideologybis log_voters delta_unemployment abs_rate_09 age_mean regione1-regione20, vce(cluster regione_num)
eststo: reg m5s_share F_rate imm_rate ideology log_voters delta_unemployment age_mean abs_rate_09 regione1-regione20, vce(cluster regione_num)

esttab using Model4.rtf, ///
	label title (Empirical analysis) nonumbers mtitles ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5") ///
	starlevels(* 0.1 ** 0.05 *** 0.01) ///
	b(3) se(3) r2 ///  
	varlabels(_cons Constant) replace

eststo clear



*model 5
eststo: xi: reg m5s_share F_rate imm_rate log_voters ideology delta_unemployment abs_rate_09 age_mean interaction1 i.province, vce(cluster province)
eststo: xtmixed m5s_share F_rate imm_rate ideology log_voters delta_unemployment abs_rate_09 age_mean interaction1 || regione_num:, mle variance 
eststo: reg m5s_share F_rate imm_rate ideology ideology2 log_voters delta_unemployment abs_rate_09 age_mean interaction1 regione1-regione20, vce(cluster regione_num)
eststo: reg m5s_share F_rate imm_rate ideologybis log_voters delta_unemployment abs_rate_09 age_mean interaction1 regione1-regione20, vce(cluster regione_num)
eststo: reg m5s_share F_rate imm_rate ideology log_voters delta_unemployment age_mean interaction1 abs_rate_09 regione1-regione20, vce(cluster regione_num)

esttab using Model5.rtf, ///
	label title (Empirical analysis) nonumbers mtitles ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5") ///
	starlevels(* 0.1 ** 0.05 *** 0.01) ///
	b(3) se(3) r2 ///  
	varlabels(_cons Constant) replace

eststo clear



*model 6
eststo: xi: reg m5s_share F_rate imm_rate log_voters ideology delta_unemployment abs_rate_09 age_mean interaction2 i.province, vce(cluster province)
eststo: xtmixed m5s_share F_rate imm_rate ideology log_voters delta_unemployment abs_rate_09 age_mean interaction2 || regione_num:, mle variance 
eststo: reg m5s_share F_rate imm_rate ideology ideology2 log_voters delta_unemployment abs_rate_09 age_mean interaction2 regione1-regione20, vce(cluster regione_num)
eststo: reg m5s_share F_rate imm_rate ideologybis log_voters delta_unemployment abs_rate_09 age_mean interaction2 regione1-regione20, vce(cluster regione_num)
eststo: reg m5s_share F_rate imm_rate ideology log_voters delta_unemployment age_mean interaction2 abs_rate_09 regione1-regione20, vce(cluster regione_num)

esttab using Model6.rtf, ///
	label title (Empirical analysis) nonumbers mtitles ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5") ///
	starlevels(* 0.1 ** 0.05 *** 0.01) ///
	b(3) se(3) r2 ///  
	varlabels(_cons Constant) replace

eststo clear

	
	
estat vif

*estat hettest

*ovtest



*----------------------------------------------------------------------------

*graph
eststo clear

**Interactions (Figure 2)
***H-4
#delimit ;

set obs 10000;

reg m5s_share delta_unemployment abstentiondif interaction1bis F_rate imm_rate ideology log_voters age_mean regione1-regione20, vce(cluster regione_num);

matrix b=e(b);
matrix V=e(V);

scalar b1=b[1,1];
scalar b3=b[1,3];

scalar varb1=V[1,1];
scalar varb3=V[3,3];

scalar covb1b3=V[1,3];

scalar list b1 b3 varb1 varb3 covb1b3;

*     ****************************************************************  *;
*       Calculate data necessary for top marginal effect plot.          *;
*     ****************************************************************  *;

generate MVZ=((_n-3000)/100);

replace  MVZ=. if _n>8001;

gen conbx=b1+b3*MVZ if _n<8001;

gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) if _n<8001;

gen ax=1.96*consx;

gen upperx=conbx+ax;

gen lowerx=conbx-ax;

*     ****************************************************************  *;
*       Construct stuff to produce the rug plot.  Need to create an     *;
*       offset position for the pipe marker, which will depend on       *;
*       where the histogram sits on the y-axis. This will requie some   *;
*       trial and error.                                                *;
*     ****************************************************************  *;



*     ****************************************************************  *;
*       Construct variable to produce y=0 line.                         *;
*     ****************************************************************  *;

gen yline=0;

*     ****************************************************************  *;
*     ****************************************************************  *;
*       Produce marginal effect plot for X.                             *;
*     ****************************************************************  *;
*     ****************************************************************  *;

graph twoway hist abstentiondif if abstentiondif>=-30 & abstentiondif<=50, width(0.5) percent color(gs14) yaxis(2)
	    ||   line conbx   MVZ, clpattern(solid) clwidth(medium) clcolor(black) yaxis(1)
        ||   line upperx  MVZ, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line lowerx  MVZ, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line yline  MVZ,  clwidth(thin) clcolor(black) clpattern(solid)
	    ||   ,
             xlabel(-30 -20 -10 0 10 20 30 40 50, nogrid labsize(2))
		     ylabel(-2 -1 0 1 2, axis(1) nogrid labsize(2) )
		     ylabel(0 1 2 3 4 5 6 7, axis(2) nogrid labsize(2))
	         yscale(noline alt)
		     yscale(noline alt axis(2))	
             xscale(noline)
             legend(off)
             xtitle("Abstention Rate Change 2009-2004 EP Elections" , size(2.5))
             ytitle("Marginal Effect of Unemployment Rate Increase" , axis(1) size(2.5))
             ytitle("Percentage of Observations" , axis(2) size(2.5))			 
             xsca(titlegap(2))
             ysca(titlegap(2))
			 scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white)) name(graph1, replace);
			 
drop MVZ-yline;
*----------------------------------------------------------------------------
  *ylabel(0 .2 .4 .6 .8 1 1.2 1.4 1.6 1.8 2, axis(2) nogrid labsize(2))
  
  #delimit ;

set obs 10000;

reg m5s_share delta_unemployment age_mean interaction2 F_rate imm_rate ideology log_voters abstentiondif regione1-regione20, vce(cluster regione_num);

matrix b=e(b);
matrix V=e(V);

scalar b1=b[1,1];
scalar b3=b[1,3];

scalar varb1=V[1,1];
scalar varb3=V[3,3];

scalar covb1b3=V[1,3];

scalar list b1 b3 varb1 varb3 covb1b3;

*     ****************************************************************  *;
*       Calculate data necessary for top marginal effect plot.          *;
*     ****************************************************************  *;

generate MVZ=((_n+3000)/100);

replace  MVZ=. if _n>4001;

gen conbx=b1+b3*MVZ if _n<4001;

gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) if _n<5001;

gen ax=1.96*consx;

gen upperx=conbx+ax;

gen lowerx=conbx-ax;

*     ****************************************************************  *;
*       Construct stuff to produce the rug plot.  Need to create an     *;
*       offset position for the pipe marker, which will depend on       *;
*       where the histogram sits on the y-axis. This will requie some   *;
*       trial and error.                                                *;
*     ****************************************************************  *;



*     ****************************************************************  *;
*       Construct variable to produce y=0 line.                         *;
*     ****************************************************************  *;

gen yline=0;

*     ****************************************************************  *;
*     ****************************************************************  *;
*       Produce marginal effect plot for X.                             *;
*     ****************************************************************  *;
*     ****************************************************************  *;

graph twoway hist age_mean if age_mean>=30 & age_mean<=70, width(0.5) percent color(gs14) yaxis(2)
	    ||   line conbx   MVZ, clpattern(solid) clwidth(medium) clcolor(black) yaxis(1)
        ||   line upperx  MVZ, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line lowerx  MVZ, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line yline  MVZ,  clwidth(thin) clcolor(black) clpattern(solid)
	    ||   ,
             xlabel(30 40 50 60 70, nogrid labsize(2))
		     ylabel(-2 -1 0 1 2, axis(1) nogrid labsize(2) )
		     ylabel(0 1 2 3 4 5 6 7, axis(2) nogrid labsize(2))
	         yscale(noline alt)
		     yscale(noline alt axis(2))	
             xscale(noline)
             legend(off)
             xtitle("Average Age" , size(2.5))
             ytitle("Marginal Effect of Unemployment Rate Increase" , axis(1) size(2.5))
             ytitle("Percentage of Observations" , axis(2) size(2.5))			 
             xsca(titlegap(2))
             ysca(titlegap(2))
			 scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white)) name(graph2, replace);
			 graph combine graph1 graph2, iscale(*.7) imargin(small) scheme(s2mono) graphregion(fcolor(white));  

			 
