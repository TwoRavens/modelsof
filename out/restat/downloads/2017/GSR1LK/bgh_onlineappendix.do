/*This file creates the tables in the online appendix of Bitler, Gelbach, and 
Hoynes (2016) "Can Variation in Subgroups' Average Treatment Effects Explain 
Treatment Effect Heterogeneity? Evidence from a Social Experiment" */

use data-final.dta, clear

********************************************************************************
**  Appendix Figure 1: Quantile-specific subgroup shares in the control group **
***       Using education and earnings prior to RA to define subgroups       ***
********************************************************************************	
* Appendix figure 1a: Group share in bin/average group share
graphsharecdfsumsto ernq e if quarter>=1 & quarter<=7, vars(gtehsged nohsged) ///
	path(graphs) namegraph(appendixfig1a) titl(Education) legnd1(HS grad.) legnd2(HS DO)

* Appendix figure 1b: Earnings 7Q pre-RA
graphsharecdfsumsto ernq e if quarter>=1 & quarter<=7, vars(ernpq7hi ernpq7lo noernpq7) ///
	path(graphs) namegraph(appendixfig1b) titl(Earnings 7th Q pre-RA) ///
	legnd1(High) legnd2(Low) legnd3(Zero)

********************************************************************************
**Appendix Figure 2: Subgroup share in bin relative to average subgroup share **
********************************************************************************	
* Appendix figure 2a: Age of youngest child
graphsharecdfsumsto ernq e if quarter>=1 & quarter<=7, vars(ykidge6 ykidlt6) ///
	path(graphs)  namegraph(appendixfig2a) titl(Age of youngest child) legnd1(> 5) legnd2(<=5)
	
* Appendix figure 2b: Marital status
graphsharecdfsumsto ernq e if quarter>=1 & quarter<=7, vars(martogapt marnvr) ///
	path(graphs)  namegraph(appendixfig2b) titl(Marital status) legnd1(Ever marr.) ///
	legnd2(Never marr.)
	
* Appendix figure 2c: Pre-RA quarters with earnings
graphsharecdfsumsto ernq e if quarter>=1 & quarter<=7, vars(npqernhi npqernlo npqern0) ///
	path(graphs)  namegraph(appendixfig2c) titl(# pre-RA Q with earnings) legnd1(High) ///
	legnd2(Low) legnd3(Zero)
	
* Appendix figure 2d: Any welfare 7Q pre-RA
graphsharecdfsumsto ernq e if quarter>=1 & quarter<=7, vars(noadcpq7 anyadcpq7) ///
	path(graphs)  namegraph(appendixfig2d) titl(Any welfare 7th Q pre-RA) legnd1(No) legnd2(Yes)	
	
********************************************************************************
**********Appendix Figure 3: Conditional QTE Within Various Subgroups***********
********************************************************************************	
* Appendix figure 3a: Age of youngest child
graphsubqte ernq e if quarter>=1 & quarter<=7, vars(ykidge6 ykidlt6) path(graphs)  ///
	namegraph(appendixfig3a) titl(Age of youngest child) legnd1(> 5) legnd2(<=5)

*Appendix figure 3b: Marital status	
graphsubqte ernq e if quarter>=1 & quarter<=7, vars(martogapt marnvr) path(graphs)  ///
	namegraph(appendixfig3b) titl(Marital status) legnd1(Ever marr.) legnd2(Never marr.)
	
*Appendix figure 3c: Pre-RA quarters with earnings
graphsubqte ernq e if quarter>=1 & quarter<=7, vars(npqernhi npqernlo npqern0) ///
	path(graphs)  namegraph(appendixfig3c) titl(# pre-RA Q with earnings) ///
	legnd1(High) legnd2(Low) legnd3(Zero)
	
*Appendix figure 3d: Any welfare 7Q pre-RA	
graphsubqte ernq e if quarter>=1 & quarter<=7, vars(noadcpq7 anyadcpq7) path(graphs)  ///
	namegraph(appendixfig3d) titl(Any welfare 7th Q pre-RA) legnd1(No) legnd2(Yes)

********************************************************************************
**  Appendix Figure 4: Actual and Simulated QTE With Participation Adjustment **
**********************       and Time-Varying Means       **********************
********************************************************************************
/*Note: These graphs must be created after running "bgh_fig2and3.do", which
produces the actual and simulated earnings. */

use graphs/results-graphs-synthetic-real, clear

* Appendix figure 4a: Age of youngest child
scatter qtehatnz qte_t_z_wz quantile if quantile <= 98 & qte_t_z_wz <. ///
	& subgroup=="ykid" , sort connect(l l) lcolor(blue green) plotregion(style(none)) ///
	graphregion(fcolor(white) lstyle(none) ilstyle(none) lcolor(white) ilcolor(white)) ///
	legend(region(lstyle(none)) lcolor(white) label(1 "Actual") label(2 "Simulated")) ///
	lpattern(l - ) msymbol(i i i) saving(graphs/appendixfig4a, replace) ///
	title("")  xlab(10 20 30 40 50 60 70 80 90) ylab(-800 -400 0 400 800 , ///
	angle(horizontal)) yline(0) 
	
	graph export graphs/appendixfig4a.ps, replace
	graph export graphs/appendixfig4a.eps, replace
	   !perl -pi -e 's/w setlinewidth/w 3 mul setlinewidth/' graphs/appendixfig4a.ps
	   !perl -pi -e 's/w setlinewidth/w 3 mul setlinewidth/' graphs/appendixfig4a.eps
	   !ps2pdf graphs/appendixfig4a.ps graphs/appendixfig4a.pdf
	   
* Appendix figure 4b: Marital history
scatter qtehatnz qte_t_z_wz quantile if quantile <= 98 & qte_t_z_wz <. ///
	& subgroup=="mh" , sort connect(l l) lcolor(blue green) plotregion(style(none)) ///
	graphregion(fcolor(white) lstyle(none) ilstyle(none) lcolor(white) ilcolor(white)) ///
	legend(region(lstyle(none)) lcolor(white) label(1 "Actual") label(2 "Simulated")) ///
	lpattern(l - ) msymbol(i i i) saving(graphs/appendixfig4b, replace) ///
	title("")  xlab(10 20 30 40 50 60 70 80 90) ylab(-800 -400 0 400 800 , ///
	angle(horizontal)) yline(0) 
	
	graph export graphs/appendixfig4b.ps, replace
	graph export graphs/appendixfig4b.eps, replace
	   !perl -pi -e 's/w setlinewidth/w 3 mul setlinewidth/' graphs/appendixfig4b.ps
	   !perl -pi -e 's/w setlinewidth/w 3 mul setlinewidth/' graphs/appendixfig4b.eps
	   !ps2pdf graphs/appendixfig4b.ps graphs/appendixfig4b.pdf
	





