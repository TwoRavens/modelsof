*****NOTE:  FOR FILE TO FUNCTION PROPERLY, USER MUST SPECIFY FILE PATHS
*IN GLOBAL MACROS AT BEGINNING OF FILE



************************
*Macros


/*
*Paths for Data, Figures, and Tables
global data "[Directory Name]\Data"
global figures "[Directory Name]\Figures"
global tables "C:\Users\David\Dropbox\Articles-Mine\In Progress\JHR\R&R\Tables"
*/



*Examples of File Paths
global data "D:\Dropbox\Articles-Mine\In Progress\JCR\Data"
global output "D:\Dropbox\Articles-Mine\In Progress\JHR\R&R\Output"
global figures "D:\Dropbox\Articles-Mine\In Progress\JHR\R&R\Figures"
global tables "D:\Dropbox\Articles-Mine\In Progress\JHR\R&R\Tables"




*Run Continuously
set more off, permanently


*Read in Data
use "$data\mam14.dta", replace  



*******************************
*Recodes
*******************************


*Generate Municipal-Level Indices
egen crime_index_total = rowtotal(hom_tasa tasa_robo)
egen crime_index_mean = rowmean(hom_tasa tasa_robo)

*Generate Trust Indices
egen trust_justice = rowmean(trust_judges trust_police)
egen un = rowmean(sup_un trust_un)
*egen us = rowmean(sup_us trust_us)



************************************
*Descriptives
************************************

*Descriptives

*DV
sum trust_*

*IVs
sum robo asalto secuestro asesinato
tab totvict
sum crime_index_total

*Egotropic vs. Sociotropic Threats
reg threat_crime exp_soc
margins, over(exp_soc)

tab exp_soc threat_crime, exp row chi2

*Justice System
corr trust_judges trust_police

*IHROs and LHROs
corr trust_lhro trust_ihro




****************************************************************
*Models
****************************************************************

*W/ Victimization x Crime Rate Interaction
eststo A: xtmixed trust_lhro c.totvict##c.crime_index_total total c.threat_crime##exp_soc /// Victimization
	trust_justice trust_army trust_pres trust_pols trust_avg gov_sec /// Political Trust
	ib6.pid /// Party ID
	un trust_ihro /// International Supervision
	sex educ age i.Tipo i.Dominio || Municipio: totvict
estat ic



*Get Egotropic and Sociotropic Coefficients
margins, dydx(threat_crime) at(exp_soc=(0) trust_justice=(0))
margins, dydx(threat_crime) at(exp_soc=(1) trust_justice=(0))


*Slopes and Predicted Values for Victimization
est replay A
margins, dydx(totvict) at(crime_index_total=(0 2500)) post
test 1._at = 2._at

*(Figure 3)
*Testing for Differences of Slopes at Mun Crime Index = 0, 2500
est res A
margins, dydx(totvict) at(crime_index_total=(0 2500)) post
test 1._at = 2._at

*Calculate Crossover Point For Victimization at Municipal Crime (Trust_Justice at its Mean)
est res A

scalar x = -(_b[totvict]/_b[c.totvict#c.crime_index_total])
local x = -(_b[totvict]/_b[c.totvict#c.crime_index_total])
local xplus = `x'+100
local xminus = `x'-100
margins, dydx(totvict) at(crime_index_total=(`xminus' `x' `xplus'))


/*
preserve
collapse (mean) crime_index_total, by(Municipio)
gen y = 888
xtile x = crime_index_total, cutpoint(y)
tab x
restore
*/

gen y = x
xtile x = crime_index_total, cutpoint(y)
tab x
sum crime_index_total, d
drop x y



*Testing for Differences between Points (Figure 3)
est res A
margins, dydx(totvict) at(crime_index_total=(0 2500)) l(90) post
test 1._at = 2._at
lincom 1._at - 2._at
est res A
margins, at(totvict=(0(1)4) crime_index_total=(0 2500)) l(90) post
test 5._at = 6._at
lincom 5._at - 6._at
test 7._at = 8._at
lincom 7._at - 8._at
test 9._at = 10._at
lincom 9._at - 10._at
test 9._at = 1._at
lincom 9._at - 1._at
test 10._at = 2._at
lincom 10._at - 2._at
lincom (10._at - 9._at) - (2._at - 1._at)




**************************************
*Figures

*Figure 3
est res A
margins, at(totvict=(0(1)4) crime_index_total=(0 2500)) l(90) post
marginsplot, x(totvict) l(90) ///
	title("Figure 3. Effect of Victimization on Trust in LHROs" ///
	"(Low- vs. High-Crime Contexts)", ///
	just(left) pos(12) c(black) size(medsmall)) ///
	graphr(c(white) margin(r+2)) ///
	xsize(7) ///
	ysize(6) ///
	aspect(.7) ///
	plot1opts(lc(black) lw(medium) ms(i)) ///
	plot2opts(lc(gs10) lw(medium) lp(shortdash) ms(oh) mc(gs10)) ///
	ci1opts(lc(black) lw(medium)) ///
	ci2opts(lc(gs10) lw(medium)) ///
	ylab( , glc(gs13) glw(vvthin) angle(horizontal) format(%9.1f)) /// 
	ytitle("Trust in LHROs (0-3)", size(medsmall)) ///
	xtitle("Victimization Index" "(No. of Different Types of Crimes)", size(medsmall)) ///
	xsca(titlegap(5)) ///
	legend(col(1) order(3 "Low Crime (0)" 4 "High Crime (2,500)") symx(*.5) title("Municipal Crime Rate Index", size(small) c(black)))
graph export "$figures\Figure3\figure3.png", width(800) height(908) replace


	
**************************************
*Tables


*Table 2
tab exp_soc threat_crime, exp row chi2


*Table 3
esttab A using "$tables\Table3\table3.csv", replace cells("b(fmt(3)) _star p(fmt(3))") ///
keep(totvict crime_index_total threat_crime 1.exp_soc 1.exp_soc#c.threat_crime trust_justice trust_army trust_pres trust_pols trust_avg gov_sec ///
1.pid 2.pid 3.pid 4.pid 5.pid un trust_ihro sex educ age 2.Tipo 3.Tipo 2.Dominio2 3.Dominio2 c.totvict#c.crime_index_total total _cons) ///
s(N, l("N") fmt(a0)) ///
star(* 0.101 ** 0.051 *** 0.011)



*Table 3-short
esttab A using "$tables\Table3\table3-short.csv", replace cells("b(fmt(3)) _star p(fmt(3))") ///
keep(totvict crime_index_total threat_crime 1.exp_soc 1.exp_soc#c.threat_crime trust_justice total c.totvict#c.crime_index_total) ///
s(N, l("N") fmt(a0)) ///
star(* 0.101 ** 0.051 *** 0.011)

