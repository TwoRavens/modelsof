****************************************************************************************************************************
* Replication file: "Globalization and welfare Spending: how geography and electoral institutions condition compensation"
* Irene Menendez, March 2016
****************************************************************************************************************************

* Note: Variables for marginal effects for Figures 3 and 4 (in code_main analysis_tscs.do and rcode_overconf) are rescaled as % (because table coefficients are expressed as shares).
* The following code can be implemented without rescaling.

use data_tscs.dta
xtset cntry year

* Generate variables
*********************************************

* Dependent variables

* Log of generosity measures
gen lgenalmp=log(genalmp)
gen lgenben=log(genben)

* Lag of (log) generosity measures
gen lgenbenL1=L1.lgenben
gen lgenalmpL1=L1.lgenalmp

* Log of resource measures
gen lalmp=log(almp)
gen lbenefits=log(benefits)

* Lag of (log) resource measures
gen lbenefitsL1=L1.lbenefits
gen lalmpL1=L1.lalmp

* Independent variables

* Main interaction terms

gen conc_loser=nhhi2*mgdp
gen dm2_nhhi2=dm2*nhhi2
gen dm2_mgdp=dm2*mgdp
gen conc_l_dm2=nhhi2*mgdp*dm2

* Interaction terms for robustness 

* With trade volume
gen conc_trade=nhhi2*mx_gdp
gen dm2_trade=dm2*mx_gdp
gen conc_tr_dm2=nhhi2*mx_gdp*dm2

* With median district magnitude 
gen med_nhhi=medmag*nhhi2
gen med_mgdp=medmag*mgdp
gen conc_l_med=nhhi2*mgdp*medmag

* With Carey Hix 2011 measures (median and mean)
gen medch_mgdp=meddm_ch*mgdp
gen medch_nhhi2=meddm_ch*nhhi2
gen conc_l_medch=nhhi2*mgdp*meddm_ch

gen dmch_mgdp=dmch*mgdp
gen dmch_nhhi2=dmch*nhhi2
gen conc_l_dmch=nhhi2*mgdp*dmch

* Year dummies
gen year5=.
replace year5=1 if year==1980
replace year5=1 if year==1981
replace year5=1 if year==1982
replace year5=1 if year==1983
replace year5=1 if year==1984
replace year5=2 if year==1985
replace year5=2 if year==1986
replace year5=2 if year==1987
replace year5=2 if year==1988
replace year5=2 if year==1989
replace year5=3 if year==1990
replace year5=3 if year==1991
replace year5=3 if year==1992
replace year5=3 if year==1993
replace year5=3 if year==1994
replace year5=4 if year==1995
replace year5=4 if year==1996
replace year5=4 if year==1997
replace year5=4 if year==1998
replace year5=4 if year==1999
replace year5=0 if year==2000
replace year5=5 if year==2001
replace year5=5 if year==2002
replace year5=5 if year==2003
replace year5=5 if year==2004
replace year5=5 if year==2005
replace year5=6 if year==2006
replace year5=6 if year==2007
replace year5=6 if year==2008
replace year5=6 if year==2009
replace year5=6 if year==2010

* Figures A2-A11. Marginal effects for models in Table A3 
***********************************************************

* Figure A2. Marginal effect of imports on unemployment benefits (% GDP) for countries with low and high district magnitude, conditional on geographical concentration

xi:xtreg lbenefits c.mgdp##c.dm2##c.nhhi2 xgdp unemp capgdp pop15_64 lbenefitsL1, fe cluster(cntry)
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(1)) 
marginsplot, level(90) legend(off) title("Low Magnitude") ytitle(Marginal effect of imports on benefits (% GDP), size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))	
	
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(150)) //
marginsplot, level(90) legend(off) title("High Magnitude") ytitle(Marginal effect of imports on benefits (% GDP), size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))
	
* Figure A3. Marginal effect of imports on ALMP (% GDP) for countries with low and high district magnitude, conditional on geographical concentration

xi:xtreg lalmp c.mgdp##c.dm2##c.nhhi2 xgdp unemp capgdp pop15_64 lalmpL1, fe cluster(cntry)
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(1)) 
marginsplot, level(90) legend(off) title("Low Magnitude") ytitle(Marginal effect of imports on ALMP (% GDP), size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))
	
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(150)) //
marginsplot, level(90) legend(off) title("High Magnitude") ytitle(Marginal effect of imports on ALMP (% GDP), size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))	

* Figure A4. Marginal effect of trade volume on unemployment benefit generosity for countries with low and high district magnitude, conditional on geographical concentration 

xi:xtreg lgenben c.mx_gdp##c.dm2##c.nhhi2 unemp capgdp pop15_64 lgenbenL1, fe cluster(cntry)
margins, dydx(mx_gdp) at (nhhi2=(0.004(0.04)0.38) dm2=(1)) 
marginsplot, level(90) legend(off) title("Low Magnitude") ytitle(Marginal effect of trade on benefit generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))
	
margins, dydx(mx_gdp) at (nhhi2=(0.004(0.04)0.38) dm2=(150)) //
marginsplot, level(90) legend(off) title("High Magnitude") ytitle(Marginal effect of trade on benefit generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))

* Figure A5. Marginal effect of trade volume on ALMP generosity for countries with low and high district magnitude, conditional on geographical concentration 

xi:xtreg lgenalmp c.mx_gdp##c.dm2##c.nhhi2 unemp capgdp pop15_64 lgenalmpL1, fe cluster(cntry)
margins, dydx(mx_gdp) at (nhhi2=(0.004(0.04)0.38) dm2=(1)) 
marginsplot, level(90) legend(off) title("Low Magnitude") ytitle(Marginal effect of trade on ALMP generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))
	
margins, dydx(mx_gdp) at (nhhi2=(0.004(0.04)0.38) dm2=(150)) //
marginsplot, level(90) legend(off) title("High Magnitude") ytitle(Marginal effect of trade on ALMP generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))
	
* Figure A6. Marginal effect of imports on benefit generosity, using Carey (2011) measure of mean district magnitude

xi:xtreg lgenben c.mgdp##c.dmch##c.nhhi2 xgdp unemp capgdp pop15_64 lgenbenL1, fe cluster(cntry)
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dmch=(1)) 
marginsplot, level(90) legend(off) title("Low Magnitude") ytitle(Marginal effect of imports on benefit generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))	

margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dmch=(150)) 
marginsplot, level(90) legend(off) title("High Magnitude") ytitle(Marginal effect of imports on benefit generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))	
	
* Figure A7. Marginal effect of imports on ALMP generosity, using Carey (2011) measure of mean district magnitude

xi:xtreg lgenalmp c.mgdp##c.dmch##c.nhhi2 xgdp unemp capgdp pop15_64 lgenalmpL1, fe cluster(cntry)
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dmch=(1)) 
marginsplot, level(90) legend(off) title("Low Magnitude") ytitle(Marginal effect of imports on ALMP generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))

margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dmch=(150)) 
marginsplot, level(90) legend(off) title("High Magnitude") ytitle(Marginal effect of imports on ALMP generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))	
		
* Figure A8. Marginal effect of imports on benefit generosity, using Carey (2011) measure of median district magnitude

xi:xtreg lgenben c.mgdp##c.meddm_ch##c.nhhi2 xgdp unemp capgdp pop15_64 lgenbenL1, fe cluster(cntry)
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) meddm_ch=(1)) 
marginsplot, level(90) legend(off) title("Low Magnitude") ytitle(Marginal effect of imports on benefit generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))

margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) meddm_ch=(150)) 
marginsplot, level(90) legend(off) title("High Magnitude") ytitle(Marginal effect of imports on benefit generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))	

* Figure A9. Marginal effect of imports on ALMP generosity, using Carey (2011) measure of median district magnitude 

xi:xtreg lgenalmp c.mgdp##c.meddm_ch##c.nhhi2 xgdp unemp capgdp pop15_64 lgenalmpL1, fe cluster(cntry)
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) meddm_ch=(1)) 
marginsplot, level(90) legend(off) title("Low Magnitude") ytitle(Marginal effect of imports on ALMP generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))

margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) meddm_ch=(150)) 
marginsplot, level(90) legend(off) title("High Magnitude") ytitle(Marginal effect of imports on ALMP generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))	
	
* Figure A10. Marginal effect of imports on benefit generosity, controlling for total population

xi:xtreg lgenben c.mgdp##c.dm2##c.nhhi2 xgdp unemp capgdp pop15_64 population lgenbenL1, fe cluster(cntry)
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(1)) // 
marginsplot, level(90) legend(off) title("Low Magnitude") ytitle(Marginal effect of imports on benefit generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))
	
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(150)) // 
marginsplot, level(90) legend(off) title("High Magnitude") ytitle(Marginal effect of imports on benefit generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))
	
* Figure A11. Marginal effect of imports on ALMP generosity, controlling for total population

xi:xtreg lgenalmp c.mgdp##c.dm2##c.nhhi2 xgdp unemp capgdp pop15_64 population lgenalmpL1, fe cluster(cntry)
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(1)) // 
marginsplot, level(90) legend(off) title("Low Magnitude") ytitle(Marginal effect of imports on ALMP generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))
	
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(150)) // 
marginsplot, level(90) legend(off) title("High Magnitude") ytitle(Marginal effect of imports on ALMP generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))
	
	
* Figures A12-A21. Marginal effects for models in Table A4
***********************************************************

* Figure A12. Marginal effect of imports on benefit generosity, controlling for employment in industry

xi:xtreg lgenben c.mgdp##c.dm2##c.nhhi2 xgdp unemp capgdp pop15_64 empmanuf lgenbenL1, fe cluster(cntry)
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(1)) // 
marginsplot, level(90) legend(off) title("Low Magnitude") ytitle(Marginal effect of imports on benefit generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))
	
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(150)) // 
marginsplot, level(90) legend(off) title("High Magnitude") ytitle(Marginal effect of imports on benefit generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white)) 

* Figure A13. Marginal effect of imports on ALMP generosity, controlling for employment in industry

xi:xtreg lgenalmp c.mgdp##c.dm2##c.nhhi2 xgdp unemp capgdp pop15_64 empmanuf lgenalmpL1, fe cluster(cntry)
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(1)) // 
marginsplot, level(90) legend(off) title("Low Magnitude") ytitle(Marginal effect of imports on ALMP generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))
	
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(150)) // 
marginsplot, level(90) legend(off) title("High Magnitude") ytitle(Marginal effect of imports on ALMP generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white)) 	
	
* Figure A14. Marginal effect of imports on benefit generosity, controlling for growth rate in GVA

xi:xtreg lgenben c.mgdp##c.dm2##c.nhhi2 xgdp unemp capgdp pop15_64 growthgva lgenbenL1, fe cluster(cntry)
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(1)) // 
marginsplot, level(90) legend(off) title("Low Magnitude") ytitle(Marginal effect of imports on benefit generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))
	
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(150)) // 
marginsplot, level(90) legend(off) title("High Magnitude") ytitle(Marginal effect of imports on benefit generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))

* Figure A15. Marginal effect of imports on ALMP generosity, controlling for growth rate in GVA

xi:xtreg lgenalmp c.mgdp##c.dm2##c.nhhi2 xgdp unemp capgdp pop15_64 growthgva lgenalmpL1, fe cluster(cntry)
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(1)) // 
marginsplot, level(90) legend(off) title("Low Magnitude") ytitle(Marginal effect of imports on ALMP generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))
	
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(150)) // 
marginsplot, level(90) legend(off) title("High Magnitude") ytitle(Marginal effect of imports on ALMP generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))
	
* Figure A16. Marginal effect of imports on benefit generosity, controlling for population density 

xi:xtreg lgenben c.mgdp##c.dm2##c.nhhi2 xgdp unemp capgdp pop15_64 popdensity lgenbenL1, fe cluster(cntry)
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(1)) // 
marginsplot, level(90) legend(off) title("Low Magnitude") ytitle(Marginal effect of imports on benefit generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white)) 
	
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(150)) // 
marginsplot, level(90) legend(off) title("High Magnitude") ytitle(Marginal effect of imports on benefit generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))

* Figure A17. Marginal effect of imports on ALMP generosity, controlling for population density 

xi:xtreg lgenalmp c.mgdp##c.dm2##c.nhhi2 xgdp unemp capgdp pop15_64 popdensity lgenalmpL1, fe cluster(cntry)
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(1)) // 
marginsplot, level(90) legend(off) title("Low Magnitude") ytitle(Marginal effect of imports on ALMP generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white)) 
	
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(150)) // 
marginsplot, level(90) legend(off) title("High Magnitude") ytitle(Marginal effect of imports on ALMP generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white)) 
	
* Figure A18. Marginal effect of imports on benefit generosity, controlling for ENPP

xi:xtreg lgenben c.mgdp##c.dm2##c.nhhi2 xgdp unemp capgdp pop15_64 enpp lgenbenL1, fe cluster(cntry)
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(1)) // 
marginsplot, level(90) legend(off) title("Low Magnitude") ytitle(Marginal effect of imports on benefit generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))
	
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(150)) // 
marginsplot, level(90) legend(off) title("High Magnitude") ytitle(Marginal effect of imports on benefit generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))

* Figure A19. Marginal effect of imports on ALMP generosity, controlling for ENPP

xi:xtreg lgenalmp c.mgdp##c.dm2##c.nhhi2 xgdp unemp capgdp pop15_64 enpp lgenalmpL1, fe cluster(cntry)
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(1)) // 
marginsplot, level(90) legend(off) title("Low Magnitude") ytitle(Marginal effect of imports on ALMP generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white)) 
	
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(150)) // 
marginsplot, level(90) legend(off) title("High Magnitude") ytitle(Marginal effect of imports on ALMP generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))
	
* Figure A20. Marginal effect of imports on benefit generosity, controlling for federalism

xi:xtreg lgenben c.mgdp##c.dm2##c.nhhi2 xgdp unemp capgdp pop15_64 fed lgenbenL1, fe cluster(cntry)
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(1)) // 
marginsplot, level(90) legend(off) title("Low Magnitude") ytitle(Marginal effect of imports on benefit generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))
	
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(150)) // 
marginsplot, level(90) legend(off) title("High Magnitude") ytitle(Marginal effect of imports on benefit generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))	

* Figure A21. Marginal effect of imports on ALMP generosity, controlling for federalism

xi:xtreg lgenalmp c.mgdp##c.dm2##c.nhhi2 xgdp unemp capgdp pop15_64 fed lgenalmpL1, fe cluster(cntry)
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(1)) // 
marginsplot, level(90) legend(off) title("Low Magnitude") ytitle(Marginal effect of imports on ALMP generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))
	
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(150)) // 
marginsplot, level(90) legend(off) title("High Magnitude") ytitle(Marginal effect of imports on ALMP generosity, size(medium) margin(small)) ///
	xtitle(Geographical Concentration, size(medium)) ///
	ylabel(, nogrid labsize(small)) yticks(none) yline(0) ///
	graphregion(color(white) lcolor(white))
	
	
* Figures A22 and A23. Marginal effects for models in Table 4 (using historical concentration)
***********************************************************************************************

* The following code computes the marginal effects of imports using historical concentration which, since time-invariant and absorbed by the fixed effects, cannot be computed with the margins command.
* The calculation of the marginal effects is based on Matt Golder's code, available at: http://mattgolder.com/interactions#code.

* Generating measure of historical concentration and interactions

bysort cntry: tab nhhi2 if year==1980
gen c1980=.
replace c1980=.0509377 if cntry==1 // Austria
replace c1980=.0421745 if cntry==2 // Belgium
replace c1980=.0272722 if cntry==3 // Denmark
replace c1980=.2092475 if cntry==4 // Finland
replace c1980=.0385286 if cntry==5 // France
replace c1980=.0218823 if cntry==6 // Germany
replace c1980=.3729935 if cntry==7 // Greece
replace c1980=.0577897 if cntry==8 // Ireland
replace c1980=.0821019 if cntry==9 // Italy
replace c1980=.0435707 if cntry==10 // Netherlands
replace c1980=.161852  if cntry==11 // Portugal
replace c1980=.0673945 if cntry==12 // Spain
replace c1980=.030667  if cntry==13 // Sweden 
replace c1980=.008401  if cntry==14 // UK

gen conc80loser=c1980*mgdp
gen conc80dm2=c1980*dm2
gen conc80dm2los=c1980*dm2*mgdp

* For (log) unemployment benefit generosity

xi:xtreg lgenben mgdp c1980 dm2 conc80loser dm2_mgdp conc80dm2 conc80dm2los xgdp capgdp unemp pop15_64 lgenbenL1 i.year5, fe cluster(cntry)

matrix b=e(b)

matrix V=e(V)
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar b4=b[1,4]
scalar b5=b[1,5]
scalar b6=b[1,6]
scalar b7=b[1,7]

scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]
scalar varb4=V[4,4]
scalar varb5=V[5,5]
scalar varb6=V[6,6]
scalar varb7=V[7,7]

scalar covb1b4=V[1,4]
scalar covb1b5=V[1,5]
scalar covb1b7=V[1,7]
scalar covb4b5=V[4,5]
scalar covb4b7=V[4,7]
scalar covb5b7=V[5,7]

scalar list b1 b2 b3 b4 b5 b6 b7 varb1 varb2 varb3 varb4 varb5 varb6 varb7 covb1b4 covb1b5 covb1b7 covb4b5 covb4b7 covb5b7

* Calculate data necessary for marginal effect plot

generate z1=((_n-1)/100)

* Determine the last value of z1 (nhhi2) for which want to calculate the marginal effect of Imports. 

replace z1=. if _n>39

* When district magnitude takes low values

gen conbx_le=(b1+b5*1)+ (b4+b7*1)*z1 if _n<39

* Compute the standard error for marginal effect 

gen consx_le=sqrt(varb1 + varb4*z1^2 + varb5*1^2 + varb7*z1^2*1^2 + 2*covb1b4*z1 + 2*covb1b5*1 + 2*covb1b7*z1*1 + 2*covb4b5*z1*1 + 2*covb4b7*1*z1^2 + 2*covb5b7*1^2*z1) if _n<39

gen ax_le=1.96*consx_le

gen upperx_le=conbx_le+ax_le
gen lowerx_le=conbx_le-ax_le

* When district magnitude takes high values

gen conbx_he=(b1+b5*150)+ (b4+b7*150)*z1 if _n<39

gen consx_he=sqrt(varb1 + varb4*z1^2 + varb5*150^2 + varb7*z1^2*150^2 + 2*covb1b4*z1 + 2*covb1b5*150 + 2*covb1b7*z1*150 + 2*covb4b5*z1*150 + 2*covb4b7*150*z1^2 + 2*covb5b7*150^2*z1) if _n<39

gen ax_he=1.96*consx_he
gen upperx_he=conbx_he+ax_he
gen lowerx_he=conbx_he-ax_he

* Produce marginal effect plot for mgdp 

graph twoway (rarea upperx_le lowerx_le z1, color(gs12) lcolor(gs12)) ///
       (line conbx_le z1) ///
       (rarea upperx_he lowerx_he z1, color(gs14) lcolor(gs14)) ///
       (line conbx_he z1), ///
	   legend(order(2 "Low Magnitude" 4 "High Magnitude")) ///
       xtitle("Concentration 1980") ytitle("Marginal effect of imports on benefit generosity") scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

	   
* For (log) ALMP generosity	   

xi:xtreg lgenalmp mgdp c1980 dm2 conc80loser dm2_mgdp conc80dm2 conc80dm2los xgdp capgdp unemp pop15_64 lgenalmpL1 i.year5, fe cluster(cntry) 

matrix b=e(b)

matrix V=e(V)
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar b4=b[1,4]
scalar b5=b[1,5]
scalar b6=b[1,6]
scalar b7=b[1,7]

scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]
scalar varb4=V[4,4]
scalar varb5=V[5,5]
scalar varb6=V[6,6]
scalar varb7=V[7,7]

scalar covb1b4=V[1,4]
scalar covb1b5=V[1,5]
scalar covb1b7=V[1,7]
scalar covb4b5=V[4,5]
scalar covb4b7=V[4,7]
scalar covb5b7=V[5,7]

scalar list b1 b2 b3 b4 b5 b6 b7 varb1 varb2 varb3 varb4 varb5 varb6 varb7 covb1b4 covb1b5 covb1b7 covb4b5 covb4b7 covb5b7

generate z2=((_n-1)/100)

replace z2=. if _n>39

gen conbx_le2=(b1+b5*1)+ (b4+b7*1)*z2 if _n<39

gen consx_le2=sqrt(varb1 + varb4*z2^2 + varb5*1^2 + varb7*z2^2*1^2 + 2*covb1b4*z2 + 2*covb1b5*1 + 2*covb1b7*z2*1 + 2*covb4b5*z2*1 + 2*covb4b7*1*z2^2 + 2*covb5b7*1^2*z2) if _n<39

gen ax_le2=1.96 * consx_le2
gen upperx_le2=conbx_le2 + ax_le2
gen lowerx_le2=conbx_le2 - ax_le2

gen conbx_he2=(b1+b5*150)+ (b4+b7*150)*z2 if _n<39

gen consx_he2=sqrt(varb1 + varb4*z2^2 + varb5*150^2 + varb7*z2^2*150^2 + 2*covb1b4*z2 + 2*covb1b5*150 + 2*covb1b7*z2*150 + 2*covb4b5*z2*150 + 2*covb4b7*150*z2^2 + 2*covb5b7*150^2*z2) if _n<39

gen ax_he2=1.96 * consx_he2
gen upperx_he2=conbx_he2 + ax_he2
gen lowerx_he2=conbx_he2 - ax_he2
	  	   
graph twoway (rarea upperx_he2 lowerx_he2 z2, color(gs14) lcolor(gs14)) ///
       (line conbx_he2 z2) ///
       (rarea upperx_le2 lowerx_le2 z2, color(gs12) lcolor(gs12)) ///
       (line conbx_le2 z2), ///
	   legend(order(2 "High Magnitude" 4 "Low Magnitude")) ///
       xtitle("Concentration 1980") ytitle("Marginal effect of imports on ALMP generosity") scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
	   
