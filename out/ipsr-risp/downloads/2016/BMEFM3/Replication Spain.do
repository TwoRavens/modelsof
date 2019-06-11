



*Figure 1
bysort nombredecomunidad: sum podemosshare

*Descriptive Statistics (Table 1)
sum podemosshare uchange abstentiondif average femalerate foreignrate ideology logtotalcensoelectoral if podemosshare!=. & uchange!=. & abstentiondif!=. & averageage!=. & femalerate!=. & foreignrate!=. & ideology!=. & logtotalcensoelectoral!=.

eststo clear

gen ideology2=ideology*ideology

*Table 3
eststo: reg podemosshare comunidad1-comunidad19 femalerate foreignrate logtotalcensoelectoral ideology, vce(cluster nombredecomunidad)
eststo: reg podemosshare comunidad1-comunidad19 femalerate foreignrate logtotalcensoelectoral ideology uchange, vce(cluster nombredecomunidad)
eststo: reg podemosshare comunidad1-comunidad19 femalerate foreignrate logtotalcensoelectoral ideology uchange abstentiondif, vce(cluster nombredecomunidad)
eststo: reg podemosshare comunidad1-comunidad19 femalerate foreignrate logtotalcensoelectoral ideology uchange abstentiondif averageage, vce(cluster nombredecomunidad)
eststo: reg podemosshare comunidad1-comunidad19 femalerate foreignrate logtotalcensoelectoral ideology uchange abstentiondif averageage inter2bis, vce(cluster nombredecomunidad)
eststo: reg podemosshare comunidad1-comunidad19 femalerate foreignrate logtotalcensoelectoral ideology uchange abstentiondif averageage inter4, vce(cluster nombredecomunidad)

esttab using Table1.rtf, ///
	label title (Empirical analysis) nonumbers mtitles ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6") ///
	starlevels(* 0.1 ** 0.05 *** 0.01) ///
	b(3) se(3) r2 ///  
	varlabels(_cons Constant) replace
	
eststo clear

	
	
*Table A1	
**Model 1 (Model A-D)
eststo: xi: reg podemosshare i.cdigodeprovincia femalerate foreignrate logtotalcensoelectoral ideology, vce(cluster cdigodeprovincia)
eststo: xtmixed podemosshare femalerate foreignrate logtotalcensoelectoral ideology || nombredecomunidad:, mle variance 
eststo: reg podemosshare comunidad1-comunidad19 femalerate foreignrate logtotalcensoelectoral ideology ideology2, vce(cluster nombredecomunidad)
eststo: reg podemosshare comunidad1-comunidad19 femalerate foreignrate logtotalcensoelectoral ideologybis, vce(cluster nombredecomunidad)

esttab using Model1.rtf, ///
	label title (Empirical analysis) nonumbers mtitles ("Model 1" "Model 2" "Model 3" "Model 4") ///
	starlevels(* 0.1 ** 0.05 *** 0.01) ///
	b(3) se(3) r2 ///  
	varlabels(_cons Constant) replace

eststo clear

**Model 2 (Model A-D)
eststo: xi: reg podemosshare i.cdigodeprovincia femalerate foreignrate logtotalcensoelectoral ideology uchange, vce(cluster cdigodeprovincia)
eststo: xtmixed podemosshare femalerate foreignrate logtotalcensoelectoral ideology uchange || nombredecomunidad:, mle variance
eststo: reg podemosshare comunidad1-comunidad19 femalerate foreignrate logtotalcensoelectoral ideology ideology2 uchange, vce(cluster nombredecomunidad)
eststo: reg podemosshare comunidad1-comunidad19 femalerate foreignrate logtotalcensoelectoral ideologybis uchange, vce(cluster nombredecomunidad)

esttab using Model2.rtf, ///
	label title (Empirical analysis) nonumbers mtitles ("Model 1" "Model 2" "Model 3" "Model 4") ///
	starlevels(* 0.1 ** 0.05 *** 0.01) ///
	b(3) se(3) r2 ///  
	varlabels(_cons Constant) replace

eststo clear

**Model 3 (Model A-E)
eststo: xi: reg podemosshare i.cdigodeprovincia femalerate foreignrate logtotalcensoelectoral ideology uchange abstention09, vce(cluster cdigodeprovincia)
eststo: xtmixed podemosshare femalerate foreignrate logtotalcensoelectoral ideology uchange abstention09 || nombredecomunidad:, mle variance 
eststo: reg podemosshare comunidad1-comunidad19 femalerate foreignrate logtotalcensoelectoral ideology ideology2 uchange abstention09, vce(cluster nombredecomunidad)
eststo: reg podemosshare comunidad1-comunidad19 femalerate foreignrate logtotalcensoelectoral ideologybis uchange abstention09, vce(cluster nombredecomunidad)
eststo: reg podemosshare comunidad1-comunidad19 femalerate foreignrate logtotalcensoelectoral ideology uchange abstention09, vce(cluster nombredecomunidad)

esttab using Model3.rtf, ///
	label title (Empirical analysis) nonumbers mtitles ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5") ///
	starlevels(* 0.1 ** 0.05 *** 0.01) ///
	b(3) se(3) r2 ///  
	varlabels(_cons Constant) replace

eststo clear

**Model 4 (Model A-E)
eststo: xi: reg podemosshare i.cdigodeprovincia femalerate foreignrate logtotalcensoelectoral ideology uchange abstention09 averageage, vce(cluster cdigodeprovincia)
eststo: xtmixed podemosshare femalerate foreignrate logtotalcensoelectoral ideology uchange abstention09 averageage || nombredecomunidad:, mle variance 
eststo: reg podemosshare comunidad1-comunidad19 femalerate foreignrate logtotalcensoelectoral ideology ideology2 uchange abstention09 averageage, vce(cluster nombredecomunidad)
eststo: reg podemosshare comunidad1-comunidad19 femalerate foreignrate logtotalcensoelectoral ideologybis uchange abstention09 averageage, vce(cluster nombredecomunidad)
eststo: reg podemosshare comunidad1-comunidad19 femalerate foreignrate logtotalcensoelectoral ideology uchange abstention09 averageage, vce(cluster nombredecomunidad)

esttab using Model4.rtf, ///
	label title (Empirical analysis) nonumbers mtitles ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5") ///
	starlevels(* 0.1 ** 0.05 *** 0.01) ///
	b(3) se(3) r2 ///  
	varlabels(_cons Constant) replace

eststo clear

**Model 5 (Model A-E)
eststo: xi: reg podemosshare i.cdigodeprovincia femalerate foreignrate logtotalcensoelectoral ideology uchange abstention09 averageage inter2, vce(cluster cdigodeprovincia)
eststo: xtmixed podemosshare femalerate foreignrate logtotalcensoelectoral ideology uchange abstention09 averageage inter2 || nombredecomunidad:, mle variance
eststo: reg podemosshare comunidad1-comunidad19 femalerate foreignrate logtotalcensoelectoral ideology ideology2 uchange abstention09 averageage inter2, vce(cluster nombredecomunidad)
eststo: reg podemosshare comunidad1-comunidad19 femalerate foreignrate logtotalcensoelectoral ideologybis uchange abstention09 averageage inter2, vce(cluster nombredecomunidad)
eststo: reg podemosshare comunidad1-comunidad19 femalerate foreignrate logtotalcensoelectoral ideology uchange abstention09 averageage inter2, vce(cluster nombredecomunidad)

esttab using Model5.rtf, ///
	label title (Empirical analysis) nonumbers mtitles ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5") ///
	starlevels(* 0.1 ** 0.05 *** 0.01) ///
	b(3) se(3) r2 ///  
	varlabels(_cons Constant) replace

eststo clear

**Model 6 (Model A-E)
eststo: xi: reg podemosshare i.cdigodeprovincia femalerate foreignrate logtotalcensoelectoral ideology uchange abstention09 averageage inter4, vce(cluster cdigodeprovincia)
eststo: xtmixed podemosshare femalerate foreignrate logtotalcensoelectoral ideology uchange abstention09 averageage inter4 || nombredecomunidad:, mle variance
eststo: reg podemosshare comunidad1-comunidad19 femalerate foreignrate logtotalcensoelectoral ideology ideology2 uchange abstention09 averageage inter4, vce(cluster nombredecomunidad)
eststo: reg podemosshare comunidad1-comunidad19 femalerate foreignrate logtotalcensoelectoral ideologybis uchange abstention09 averageage inter4, vce(cluster nombredecomunidad)
eststo: reg podemosshare comunidad1-comunidad19 femalerate foreignrate logtotalcensoelectoral ideology uchange abstention09 averageage inter4, vce(cluster nombredecomunidad) 

esttab using Model6.rtf, ///
	label title (Empirical analysis) nonumbers mtitles ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5") ///
	starlevels(* 0.1 ** 0.05 *** 0.01) ///
	b(3) se(3) r2 ///  
	varlabels(_cons Constant) replace

eststo clear



*Table A3
eststo: reg ciudadanosshare comunidad1-comunidad19 femalerate foreignrate ideology logtotalcensoelectoral, vce(cluster nombredecomunidad)
eststo: reg ciudadanosshare comunidad1-comunidad19 femalerate foreignrate ideology logtotalcensoelectoral uchange, vce(cluster nombredecomunidad)
eststo: reg ciudadanosshare comunidad1-comunidad19 femalerate foreignrate ideology logtotalcensoelectoral uchange abstention09, vce(cluster nombredecomunidad)
eststo: reg ciudadanosshare comunidad1-comunidad19 femalerate foreignrate ideology logtotalcensoelectoral uchange abstention09 averageage, vce(cluster nombredecomunidad)
eststo: reg ciudadanosshare comunidad1-comunidad19 femalerate foreignrate ideology logtotalcensoelectoral uchange abstention09 averageage inter2, vce(cluster nombredecomunidad)
eststo: reg ciudadanosshare comunidad1-comunidad19 femalerate foreignrate ideology logtotalcensoelectoral uchange abstention09 averageage inter4, vce(cluster nombredecomunidad)

esttab using TableCiudadanos.rtf, ///
	label title (Empirical analysis) nonumbers mtitles ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6") ///
	starlevels(* 0.1 ** 0.05 *** 0.01) ///
	b(3) se(3) r2 ///  
	varlabels(_cons Constant) replace

eststo clear



*Table A4
eststo: reg newshare comunidad1-comunidad19 femalerate foreignrate ideology logtotalcensoelectoral, vce(cluster nombredecomunidad)
eststo: reg newshare comunidad1-comunidad19 femalerate foreignrate ideology logtotalcensoelectoral uchange, vce(cluster nombredecomunidad)
eststo: reg newshare comunidad1-comunidad19 femalerate foreignrate ideology logtotalcensoelectoral uchange abstention09, vce(cluster nombredecomunidad)
eststo: reg newshare comunidad1-comunidad19 femalerate foreignrate ideology logtotalcensoelectoral uchange abstention09 averageage, vce(cluster nombredecomunidad)
eststo: reg newshare comunidad1-comunidad19 femalerate foreignrate ideology logtotalcensoelectoral uchange abstention09 averageage inter2, vce(cluster nombredecomunidad)
eststo: reg newshare comunidad1-comunidad19 femalerate foreignrate ideology logtotalcensoelectoral uchange abstention09 averageage inter4, vce(cluster nombredecomunidad)

esttab using TableNew.rtf, ///
	label title (Empirical analysis) nonumbers mtitles ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6") ///
	starlevels(* 0.1 ** 0.05 *** 0.01) ///
	b(3) se(3) r2 ///  
	varlabels(_cons Constant) replace



**Interactions (Figure 3)
***H-4
#delimit;

set obs 10000;

reg podemosshare uchange abstentiondif inter2bis comunidad1-comunidad19 femalerate foreignrate ideology logtotalcensoelectoral averageage, vce(cluster nombredecomunidad);

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

replace  MVZ=. if _n>6001;

gen conbx=b1+b3*MVZ if _n<6001;

gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) if _n<6001;

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

graph twoway hist abstentiondif if abstentiondif>=-30 & abstentiondif<=30, width(0.5) percent color(gs14) yaxis(2)
	    ||   line conbx   MVZ, clpattern(solid) clwidth(medium) clcolor(black) yaxis(1)
        ||   line upperx  MVZ, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line lowerx  MVZ, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line yline  MVZ,  clwidth(thin) clcolor(black) clpattern(solid)
	    ||   ,
             xlabel(-30 -20 -10 0 10 20 30, nogrid labsize(2))
		     ylabel(-0.2 -0.1 0 .1 .2 .3, axis(1) nogrid labsize(2) )
		     ylabel(0 1 2 3 4, axis(2) nogrid labsize(2))
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

		
		
***H-5
#delimit;

set obs 10000;

reg podemosshare uchange averageage inter4 comunidad1-comunidad19 femalerate foreignrate ideology logtotalcensoelectoral abstentiondif, vce(cluster nombredecomunidad);

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

gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) if _n<4001;

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

graph twoway hist averageage if average>=30 & averageage<=70, width(0.5) percent color(gs14) yaxis(2)
	    ||   line conbx   MVZ, clpattern(solid) clwidth(medium) clcolor(black) yaxis(1)
        ||   line upperx  MVZ, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line lowerx  MVZ, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line yline  MVZ,  clwidth(thin) clcolor(black) clpattern(solid)
	    ||   ,
             xlabel(30 40 50 60 70, nogrid labsize(2))
		     ylabel(-0.2 -0.1 0 .1 .2 .3, axis(1) nogrid labsize(2) )
		     ylabel(0 1 2 3 4, axis(2) nogrid labsize(2))
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

drop MVZ-yline;
		