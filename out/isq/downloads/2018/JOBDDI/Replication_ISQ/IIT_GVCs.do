*     ***************************************************************** *;
*     ***************************************************************** *;
*       File-Name:      IIT_GVCs.do					                  	*;
*       Date:           09/05/2017                                      *;
*       Author:         Baccini, Dur, and Elsig                      	*;
*       Purpose:        Replication of "Intra-Industry Trade, 			*;
*						Global Value Chains, and Preferential Tariff    *;
*						Liberalization"									*;                                                                      
*       Input Files:    Dataset_Main.dta 								*;
*       Output Files:   ISQ_logfile                                     *;
*       Machine:        Office                                          *;
*       Program: 		Stata 14                                        *;
*     ****************************************************************  *;
*     ****************************************************************  *;

cd "\Replication_BacciniDurElsig"
use Dataset_main, clear
log using ISQ_logfile_new.log
set more off 


#######################################################################
################################### MAIN ANALYSES ##################
###############################################################

### Table 1: Main Results.

* First stage
*1
probit ZeroTariff IIT Intermediates IIT_Missing lnGDPpc_A lnGDPpc_B Imports Exports lnGDP_A lnGDP_B Regime WTO lnProductivity, cluster(hs6) r 
outreg2 using table1.xls, bdec(2) tdec(2)  addtext(Year FE, No, Country A FE, No, HS2-varying intercepts, No, HS2-varying slopes, No) keep(IIT Intermediates IIT_Missing lnGDPpc_A lnGDPpc_B Imports Exports lnGDP_A lnGDP_B Regime WTO lnProductivity) 
predict p1, xb
replace p1=-p1
generate phi = (1/sqrt(2*_pi))*exp(-(p1^2/2))
generate capphi = normal(p1)
generate invmills1 = phi/(1-capphi)
*2
xi: reg TimeToZero Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1 if ZeroTariff==0, cluster(hs6) r
outreg2 using table1.xls, bdec(2) tdec(2)  addtext(Year FE, No, Country A FE, No, HS2-varying intercepts, No, HS2-varying slopes, No) addstat(`e(r2_p)') keep(Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1) append
*3
xi: reg TimeToZero Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1 i.year if ZeroTariff==0, cluster(hs6) r
outreg2 using table1.xls, bdec(2) tdec(2)  addtext(Year FE, Yes, Country A FE, No, HS2-varying intercepts, No, HS2-varying slopes, No) addstat(`e(r2_p)') keep(Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1) append
*4
xi: reg TimeToZero Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1 i.country_id i.year if ZeroTariff==0, cluster(hs6) r
outreg2 using table1.xls, bdec(2) tdec(2)  addtext(Year FE, Yes, Country A FE, Yes, HS2-varying intercepts, No, HS2-varying slopes, No) addstat(`e(r2_p)') keep(Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1) append
*5
xi: xtmixed TimeToZero IIT Intermediates IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1 i.country_id i.year || hs2: if ZeroTariff==0  
outreg2 using table1.xls, bdec(2) tdec(2)  addtext(Year FE, Yes, Country A FE, Yes, HS2-varying intercepts, Yes, HS2-varying slopes, No) keep(Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1) append
*6
xi: xtmixed TimeToZero IIT Intermediates IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1 i.country_id i.year || hs2: IIT Intermediates if ZeroTariff==0, mle covariance(unstructured)
outreg2 using table1.xls, bdec(2) tdec(2)  addtext(Year FE, Yes, Country A FE, Yes, HS2-varying intercepts, No, HS2-varying slopes, Yes) keep(Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1) append


#### Estimates to replicate Figure 3 

forval i = 1/47 {
	capture noisily reg TimeToZero IIT Intermediates IIT_Missing tmin1 Exports Imports invmills1 i.year if ZeroTariff==0 & country_id==`i', cluster(hs6) r
	capture outreg2 using table2.xls, bdec(2) tdec(2)  append
	display `i'
}


#### Estimates to replicate Figure 4 

forval i = 1/21 {
	capture noisily reg TimeToZero IIT Intermediates IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1 i.year if ZeroTariff==0 & section==`i', cluster(hs6) r
	capture outreg2 using table3.xls, bdec(2) tdec(2)  append
	display `i'
}



#######################################################################
################################### APPENDIX ######################
###############################################################

### Table A2: Descriptive statistics 

sum TimeToZero IIT Differentiated Intermediates IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO ZeroTariff TariffCut lnProductivity


#### Table A3: Main models with differentiated goods

* First stage
drop p1 phi capphi invmills1
*1
probit ZeroTariff Differentiated IIT Intermediates IIT_Missing lnGDPpc_A lnGDPpc_B Imports Exports lnGDP_A lnGDP_B Regime WTO lnProductivity, cluster(hs6) r 
outreg2 using tableA3.xls, bdec(2) tdec(2)  addtext(Year FE, No, Country A FE, No, HS2-varying intercepts, No, HS2-varying slopes, No) keep(Differentiated IIT Intermediates IIT_Missing lnGDPpc_A lnGDPpc_B Imports Exports lnGDP_A lnGDP_B Regime WTO lnProductivity)
predict p1, xb
replace p1=-p1
generate phi = (1/sqrt(2*_pi))*exp(-(p1^2/2))
generate capphi = normal(p1)
generate invmills1 = phi/(1-capphi)
*2
xi: reg TimeToZero Differentiated Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1 if ZeroTariff==0, cluster(hs6) r
outreg2 using tableA3.xls, bdec(2) tdec(2)  addtext(Year FE, No, Country A FE, No, HS2-varying intercepts, No, HS2-varying slopes, No) addstat(`e(r2_p)') keep(Differentiated Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1) append
*3
xi: reg TimeToZero Differentiated Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1 i.year if ZeroTariff==0, cluster(hs6) r
outreg2 using tableA3.xls, bdec(2) tdec(2)  addtext(Year FE, Yes, Country A FE, No, HS2-varying intercepts, No, HS2-varying slopes, No) addstat(`e(r2_p)') keep(Differentiated Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1) append
*4
xi: reg TimeToZero Differentiated Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1 i.country_id i.year if ZeroTariff==0, cluster(hs6) r
outreg2 using tableA3.xls, bdec(2) tdec(2)  addtext(Year FE, Yes, Country A FE, Yes, HS2-varying intercepts, No, HS2-varying slopes, No) addstat(`e(r2_p)') keep(Differentiated Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1) append
*5
xi: xtmixed TimeToZero Differentiated IIT Intermediates IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1 i.year i.country_id || hs2: if ZeroTariff==0
outreg2 using tableA3.xls, bdec(2) tdec(2)  addtext(Year FE, Yes, Country A FE, Yes, HS2-varying intercepts, Yes, HS2-varying slopes, No) keep(Differentiated Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1) append
*6
xi: xtmixed TimeToZero Differentiated IIT Intermediates IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1 i.year i.country_id || hs2: Differentiated IIT Intermediates if ZeroTariff==0, mle covariance(unstructured)
outreg2 using tableA3.xls, bdec(2) tdec(2)  addtext(Year FE, Yes, Country A FE, Yes, HS2-varying intercepts, No, HS2-varying slopes, Yes) keep(Differentiated Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1) append


#### Table A4: The role of time

* First stage
drop p1 phi capphi invmills1
probit ZeroTariff Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B Imports Exports lnGDP_A lnGDP_B Regime WTO lnProductivity, cluster(hs6) r 
outreg2 using tableA4.xls, bdec(2) tdec(2)  addtext(Year FE, No, Country A FE, No, HS2-varying intercepts, No, HS2-varying slopes, No) keep(Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B Imports Exports lnGDP_A lnGDP_B Regime WTO lnProductivity)
predict p1, xb
replace p1=-p1
generate phi = (1/sqrt(2*_pi))*exp(-(p1^2/2))
generate capphi = normal(p1)
generate invmills1 = phi/(1-capphi)

xi: reg TimeToZero c.Intermediates##c.year c.IIT##c.year IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1 if ZeroTariff==0, cluster(hs6) r
outreg2 using tableA4.xls, bdec(2) tdec(2)  addtext(Year FE, No, Country A FE, No, HS2-varying intercepts, No, HS2-varying slopes, No) addstat(`e(r2_p)') keep(c.Intermediates##c.year c.IIT##c.year IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1) append
margins, dydx(Intermediates) at(year=(1995(1)2014))
marginsplot
graph save Graph "C:\Users\lbacci\Dropbox\Current_Projects\BADUEL\Tariff\Results_ISQ\Replication_BacciniDurElsig\FigureA6a.gph", replace
margins, dydx(IIT) at(year=(1995(3)2014))
marginsplot
graph save Graph "C:\Users\lbacci\Dropbox\Current_Projects\BADUEL\Tariff\Results_ISQ\Replication_BacciniDurElsig\FigureA6b.gph", replace

* First stage
drop p1 phi capphi invmills1
probit ZeroTariff Differentiated Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B Imports Exports lnGDP_A lnGDP_B Regime WTO lnProductivity, cluster(hs6) r 
outreg2 using tableA4.xls, bdec(2) tdec(2)  addtext(Year FE, No, Country A FE, No, HS2-varying intercepts, No, HS2-varying slopes, No) keep(Differentiated Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B Imports Exports lnGDP_A lnGDP_B Regime WTO lnProductivity) append
predict p1, xb
replace p1=-p1
generate phi = (1/sqrt(2*_pi))*exp(-(p1^2/2))
generate capphi = normal(p1)
generate invmills1 = phi/(1-capphi)

xi: reg TimeToZero c.Differentiated##c.year c.Intermediates##c.year c.IIT##c.year IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1 if ZeroTariff==0, cluster(hs6) r
outreg2 using tableA4.xls, bdec(2) tdec(2) addtext(Year FE, No, Country A FE, No, HS2-varying intercepts, No, HS2-varying slopes, No) addstat(`e(r2_p)') keep(c.Differentiated##c.year c.Intermediates##c.year c.IIT##c.year IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1) append


###### Table A5: Tariff cuts
* First stage
drop p1 phi capphi invmills1
*0
probit ZeroTariff IIT Intermediates IIT_Missing lnGDPpc_A lnGDPpc_B Imports Exports lnGDP_A lnGDP_B Regime WTO lnProductivity, cluster(hs6) r 
*outreg2 using tableA5.xls, bdec(2) tdec(2)  addtext(Year FE, No, Country A FE, No, HS2-varying intercepts, No, HS2-varying slopes, No)
predict p1, xb
replace p1=-p1
generate phi = (1/sqrt(2*_pi))*exp(-(p1^2/2))
generate capphi = normal(p1)
generate invmills1 = phi/(1-capphi)
*1
xi: reg TariffCut Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1 i.year if ZeroTariff==0, cluster(hs6) r
outreg2 using tableA5.xls, bdec(2) tdec(2)  addtext(Year FE, No, Country A FE, No, HS2-varying intercepts, No, HS2-varying slopes, No) addstat(`e(r2_p)') keep(Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1)
*2
xi: reg TariffCut Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1 i.year if ZeroTariff==0, cluster(hs6) r
outreg2 using tableA5.xls, bdec(2) tdec(2)  addtext(Year FE, Yes, Country A FE, No, HS2-varying intercepts, No, HS2-varying slopes, No) addstat(`e(r2_p)') keep(Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1) append
*3
xi: reg TariffCut Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1 i.country_id i.year if ZeroTariff==0, cluster(hs6) r
outreg2 using tableA5.xls, bdec(2) tdec(2)  addtext(Year FE, Yes, Country A FE, Yes, HS2-varying intercepts, No, HS2-varying slopes, No) addstat(`e(r2_p)') keep(Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1) append
*4
xi: xtmixed TariffCut IIT Intermediates IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1 i.country_id i.year || hs2: if ZeroTariff==0 
outreg2 using tableA5.xls, bdec(2) tdec(2)  addtext(Year FE, Yes, Country A FE, Yes, HS2-varying intercepts, Yes, HS2-varying slopes, No) keep(Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1) append
*5
xi: xtmixed TariffCut IIT Intermediates IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1 i.country_id i.year || hs2: IIT Intermediates if ZeroTariff==0, mle covariance(unstructured)
outreg2 using tableA5.xls, bdec(2) tdec(2)  addtext(Year FE, Yes, Country A FE, Yes, HS2-varying intercepts, No, HS2-varying slopes, Yes) keep(Intermediates IIT IIT_Missing lnGDPpc_A lnGDPpc_B lnGDP_A lnGDP_B tmin1 Exports Imports Regime WTO invmills1) append

log close
