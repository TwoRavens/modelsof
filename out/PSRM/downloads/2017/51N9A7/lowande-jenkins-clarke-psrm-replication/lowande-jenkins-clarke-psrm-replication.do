* Replication code for "Presidential Particularism and U.S. Trade Politics"
* Kenneth Lowande, Jeffery Jenkins, Andrew Clarke
* Note: Please report all errors to the authors.

cd "T:" /*Be sure to correct the file directory.*/
pwd
log using "replication.log", replace

***********

use pres-tariff-mod1.dta, clear

* Table 1:
quietly {
logit direction1ifprotectionist i.pres_yr i.midterm_yr i.div c.unemp2 i.war i.pres, vce(robust)
	estimates store a
logit direction1ifprotectionist i.pres_yr i.midterm_yr i.div c.unemp2 i.war i.d_1935 i.d_1975 i.pres, vce(robust)
	estimates store b
logit direction1ifprotectionist i.pres_yr##i.d_1935 i.pres_yr##i.d_1975 i.midterm_yr i.div c.unemp2 i.war i.pres, vce(robust)
	estimates store c
	} 
* log-pseudolikelihood
estout a b c, cells(b(star fmt(3)) se(par fmt(2))) ///
   legend label varlabels(_cons constant) starlevels(* 0.1 ** 0.05 *** 0.01) ///
   stats(ll N, fmt(2 2 2))
* pseudo-r2
esttab a b c, cells(b(star fmt(3)) se(par fmt(2))) ///
   legend label varlabels(_cons constant) starlevels(* 0.1 ** 0.05 *** 0.01) ///
   pr2 
	
* Figure 1:
estimates restore c
margins, dydx(pres_yr) at(d_1935=0) saving(me1, replace)
margins, dydx(pres_yr) at(d_1935=1) saving(me2, replace)
margins, dydx(pres_yr) at(d_1975=1) saving(me3, replace)
combomarginsplot me1 me2 me3,  horizontal unique recast(scatter) legend(rows(1)) yscale(reverse)

***********

* Table 2:
use pres-tariff-mod2.dta, clear
	*Column 1
logit StateProtected i.PresElecYear##(i.HostileState i.SwingState) c.FedGrantsLog, vce(cluster state_id)
	*Column 2
logit StateProtected i.PresElecYear##(i.HostileState i.SwingState) i.MidtermElecYear##c.HouseCoPartVuln i.SenCoPartVuln##i.SenateElecYear c.FedGrantsLog, vce(cluster state_id)

* Figure 2:
	*Swing State Interaction from Column 2
margins, dydx(SwingState) at(PresElecYear=(0(1)1))
marginsplot, horizontal unique recast(scatter) legend(rows(1)) yscale(reverse)
graph save Graph "swing_dydx.gph", replace
	*Hostile State Interaction from Column 2
margins, dydx(HostileState) at(PresElecYear=(0(1)1))
marginsplot, horizontal unique recast(scatter) legend(rows(1)) yscale(reverse)
graph save Graph "hostile_dydx.gph", replace
	*Combine the graphs
gr combine "hostile_dydx" "swing_dydx", col(1) iscale(1) xcommon ycommon l1title(Presidential Election Year) b1title(Marginal Change in Pr(State Protected by Unilateral Directive))





/*		APPENDIX MATERIALS		*/
use pres-tariff-mod1.dta, clear

*Table A1: Descriptive Statistics
sum direction1ifprotectionist pres_yr midterm_yr div unemp2

*Figure A1
logit direction1ifprotectionist i.pres_yr i.midterm_yr i.div c.unemp2 i.war i.pres, vce(robust)
margins, dydx(pres_yr midterm_yr div unemp2 war)
marginsplot, horizontal unique recast(scatter) legend(rows(1)) yscale(reverse) xline(0) xlabel(-.8(.2).8) title("") ytitle("") xtitle("Marginal Effect on Pr(Order is Protectionist)")
graph save Graph "FigureA1.gph", replace
***********

use pres-tariff-mod2.dta, clear

*Table A2: Descriptive Statistics
sum StateProtected PresElecYear HostileState SwingState MidtermElecYear SenateElecYear SenCoPartVuln HouseCoPartVuln FedGrantsLog

*Figure A2
logit StateProtected i.PresElecYear##(i.HostileState i.SwingState) i.MidtermElecYear##c.HouseCoPartVuln i.SenCoPartVuln##i.SenateElecYear c.FedGrantsLog, vce(cluster state_id)
margins, predict() at(PresElecYear=(0(1)1) SwingState==1)
marginsplot, horizontal unique recast(scatter) legend(rows(1)) yscale(reverse) xline(0) title(Swing States) xlabel(0(.1)1) xtitle("") ytitle("")
graph save Graph "a2swing.gph", replace
logit StateProtected i.PresElecYear##(i.HostileState i.SwingState) i.MidtermElecYear##c.HouseCoPartVuln i.SenCoPartVuln##i.SenateElecYear c.FedGrantsLog, vce(cluster state_id)
margins, predict() at(PresElecYear=(0(1)1) HostileState=1)
marginsplot, horizontal unique recast(scatter) legend(rows(1)) yscale(reverse) xline(0) title(Hostile States) xlabel(0(.1)1) xtitle("") ytitle("")
graph save Graph "a2hostile.gph", replace
gr combine "a2hostile.gph" "a2swing",   col(1) iscale(1) xcommon ycommon l1title(Presidential Election Year) b1title(Predicted Pr(State Protected by Unilateral Directive))
graph save Graph "FigureA2.gph", replace

log close
