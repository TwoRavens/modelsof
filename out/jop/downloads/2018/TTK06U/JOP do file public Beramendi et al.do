clear all
set more off 

*Software: Stata 14.1
*OS: Windows 

/*Update path to preferred working directory*/
cd ""

cap log close

log using "BDR_regressions", text replace

********************************************************************************

/*Regression analysis in manuscript*/

use "JOP data 5 yr avg Beramendi et al.dta", clear
sort ctyid year
xtset ctyid year

*****Table 1: Elite Competition and Overall Taxation, 1870-2010: Main Results

xi: xtreg taxgdp execrecruit_lag i.year, fe vce(cluster ctyid)	
	
xi: xtreg taxgdp execrecruit_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	regiontrend1-regiontrend6 taxgdp_lag i.year, fe vce(cluster ctyid)
	
xi: xtreg taxgdp polcontest_lag i.year, fe vce(cluster ctyid)
		
xi: xtreg taxgdp polcontest_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	regiontrend1-regiontrend6 taxgdp_lag i.year, fe vce(cluster ctyid)
		
*****Table 2: Elite Competition and Tax Progressivity, 1870-2010: Main Results

xi: xtreg directtaxshare execrecruit_lag i.year, fe vce(cluster ctyid)	
	
xi: xtreg directtaxshare execrecruit_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	regiontrend1-regiontrend6 directtaxshare_lag taxgdp_lag i.year, fe vce(cluster ctyid)
	
xi: xtreg directtaxshare polcontest_lag i.year, fe vce(cluster ctyid)		

xi: xtreg directtaxshare polcontest_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	regiontrend1-regiontrend6 directtaxshare_lag taxgdp_lag i.year, fe vce(cluster ctyid)

********************************************************************************

/*Regression analysis in online appendix (outcome variable: executive recruitment)*/

*****Table A2: Sectoral Importance and Intra-Elite Competition, 1870-2010

xi: xtreg execrecruit industemployshare_lag i.year regiontrend1-regiontrend6 ///
	execrecruit_lag, fe vce(cluster ctyid)
	
xi: xtreg execrecruit occupdiversity_lag regiontrend1-regiontrend6 execrecruit_lag ///
	i.year, fe vce(cluster ctyid)
	
xi: xtreg execrecruit agemployshare_lag regiontrend1-regiontrend6 execrecruit_lag ///
	i.year, fe vce(cluster ctyid)
	
xi: xtreg execrecruit aggdpshare_lag regiontrend1-regiontrend6 execrecruit_lag ///
	i.year, fe vce(cluster ctyid)
	
xi: xtreg polcontest industemployshare_lag regiontrend1-regiontrend6 polcontest_lag ///
	i.year, fe vce(cluster ctyid)
	
xi: xtreg polcontest occupdiversity_lag regiontrend1-regiontrend6 polcontest_lag ///
	i.year, fe vce(cluster ctyid)
	
xi: xtreg polcontest agemployshare_lag regiontrend1-regiontrend6 polcontest_lag ///
	i.year, fe vce(cluster ctyid)
	
xi: xtreg polcontest aggdpshare_lag regiontrend1-regiontrend6 polcontest_lag ///
	i.year, fe vce(cluster ctyid)

*****Table A3: Elite Competition and Fiscal Development, 1870-2010: Exclude Outlier Observations

xi: xtreg taxpars_nooutliers execrecruit_lag i.year, fe vce(cluster ctyid)

xi: xtreg taxfull_nooutliers execrecruit_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	regiontrend1-regiontrend6 taxfull_nooutliers_lag i.year, fe vce(cluster ctyid)

xi: xtreg directpars_nooutliers execrecruit_lag i.year, fe vce(cluster ctyid)

xi: xtreg directfull_nooutliers execrecruit_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	regiontrend1-regiontrend6 directfull_nooutliers_lag taxfull_nooutliers_lag i.year, fe vce(cluster ctyid)

*****Table A4: Elite Competition and Fiscal Development, 1870-2010: Yearly Data
clear all
use "JOP data yearly Beramendi et al.dta", clear
sort ctyid year
xtset ctyid year

xi: xtreg taxgdp execrecruit_lag i.year, fe vce(cluster ctyid)

xi: xtreg taxgdp execrecruit_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	regiontrend1-regiontrend6 taxgdp_lag i.year, fe vce(cluster ctyid)
	
xi: xtreg directtaxshare execrecruit_lag i.year, fe vce(cluster ctyid)

xi: xtreg directtaxshare execrecruit_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	regiontrend1-regiontrend6 directtaxshare_lag taxgdp_lag i.year, fe vce(cluster ctyid)

*****Table A5: Elite Competition and Overall Taxation, 1870-2010: 10-Year Averaged Data
clear all
use "JOP data 10 yr avg Beramendi et al.dta", clear
sort ctyid year
xtset ctyid year	

xi: xtreg taxgdp execrecruit_lag i.year, fe vce(cluster ctyid)

xi: xtreg taxgdp execrecruit_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	regiontrend1-regiontrend6 taxgdp_lag i.year, fe vce(cluster ctyid)
	
xi: xtreg directtaxshare execrecruit_lag i.year, fe vce(cluster ctyid)

xi: xtreg directtaxshare execrecruit_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	regiontrend1-regiontrend6 directtaxshare_lag taxgdp_lag i.year, fe vce(cluster ctyid)

*****Table A6: Elite Competition and Fiscal Development, 1870-2010: Error Correction Models 
clear all
use "JOP data 5 yr avg Beramendi et al.dta", clear
sort ctyid year5
tsset ctyid year5, delta(5)

xi:reg dtaxgdp taxgdp_lag execrecruit_lag dexecrecruit i.year i.ctyid, vce(cluster ctyid)

xi:reg dtaxgdp taxgdp_lag execrecruit_lag dexecrecruit lngdppc_lag dlngdppc leftgov_lag ///
	dleftgov warmobilization_lag dwarmobilization i.year i.ctyid regiontrend1-regiontrend6, vce(cluster ctyid)

xi:reg ddirecttaxshare directtaxshare_lag execrecruit_lag dexecrecruit i.year i.ctyid, vce(cluster ctyid)

xi:reg ddirecttaxshare directtaxshare_lag execrecruit_lag dexecrecruit lngdppc_lag dlngdppc leftgov_lag ///
	dleftgov warmobilization_lag dwarmobilization taxgdp_lag i.year i.ctyid regiontrend1-regiontrend6, vce(cluster ctyid)

*****Table A7: Elite Competition and Overall Taxation, 1870-2010: Matching 
clear all
use "JOP data yearly Beramendi et al.dta", clear
sort ctyid year
xtset ctyid year

/*Treated variable: war participation*/
teffects psmatch (taxgdp) (warparticipant leftgov lngdppc execrecruit, probit)
teffects psmatch (taxgdp) (warparticipant leftgov lngdppc execrecruit, probit), atet
psmatch2 warparticipant execrecruit lngdppc leftgov , out(taxgdp) noreplacement

reg taxgdp execrecruit_lag leftgov_lag warmobilization_lag lngdppc_lag regiontrend1-regiontrend6 ///
	i.year i.ctyid taxgdp_lag [fweight=_weight] , vce(cluster ctyid)

/*Treated variable: left government*/
teffects psmatch (taxgdp) (leftgov warmobilization lngdppc execrecruit, probit)
teffects psmatch (taxgdp) (leftgov warmobilization lngdppc execrecruit, probit), atet
psmatch2 leftgov execrecruit lngdppc warmobilization , out(taxgdp) noreplacement

reg taxgdp execrecruit_lag  lngdppc_lag warmobilization_lag leftgov_lag regiontrend1-regiontrend6 ///
	i.year i.ctyid taxgdp_lag [fweight=_weight] , vce(cluster ctyid)

/*Treated variable: GDP per capita (median)*/
gen abovemedian_gdppc=0
replace abovemedian_gdppc=1 if lngdppc>=8.506

teffects psmatch (taxgdp) (abovemedian_gdppc leftgov warmobilization execrecruit, probit)
teffects psmatch (taxgdp) (abovemedian_gdppc leftgov warmobilization execrecruit, probit), atet
psmatch2 abovemedian_gdppc execrecruit warmobilization leftgov , out(taxgdp) noreplacement

reg taxgdp execrecruit_lag leftgov_lag lngdppc_lag warmobilization_lag regiontrend1-regiontrend6 ///
	i.year i.ctyid taxgdp_lag [fweight=_weight], vce(cluster ctyid)

/*Treated variable: urbanization (median)*/
gen abovemedian_urban=0
replace abovemedian_urban=1 if urban>=44.1763

teffects psmatch (taxgdp) (abovemedian_urban leftgov warmobilization lngdppc execrecruit, probit)
teffects psmatch (taxgdp) (abovemedian_urban leftgov warmobilization lngdppc execrecruit, probit), atet
psmatch2 abovemedian_urban execrecruit warmobilization leftgov lngdppc , out(taxgdp) noreplacement

reg taxgdp execrecruit_lag leftgov_lag lngdppc_lag warmobilization_lag regiontrend1-regiontrend6 ///
	i.year i.ctyid taxgdp_lag [fweight=_weight], vce(cluster ctyid)

*****Table A8: Elite Competition and Tax Progressivity, 1870-2010: Matching 

/*Treated variable: war participation*/
teffects psmatch (directtaxshare) (warparticipant leftgov  lngdppc execrecruit, probit)
teffects psmatch (directtaxshare) (warparticipant leftgov  lngdppc execrecruit, probit), atet
psmatch2 warparticipant execrecruit lngdppc leftgov, out(directtaxshare) noreplacement

reg directtaxshare execrecruit_lag leftgov_lag warmobilization_lag lngdppc_lag regiontrend1-regiontrend6 ///
	i.year i.ctyid directtaxshare_lag taxgdp_lag [fweight=_weight], vce(cluster ctyid)

/*Treated variable: left government*/ 
teffects psmatch (directtaxshare) (leftgov warmobilization lngdppc execrecruit, probit)
teffects psmatch (directtaxshare) (leftgov warmobilization lngdppc execrecruit, probit), atet
psmatch2 leftgov execrecruit lngdppc warmobilization , out(directtaxshare) noreplacement

reg directtaxshare execrecruit_lag  lngdppc_lag warmobilization_lag leftgov_lag regiontrend1-regiontrend6 ///
	i.year i.ctyid directtaxshare_lag taxgdp_lag [fweight=_weight], vce(cluster ctyid)

/*Treated variable: GDP per capita (median)*/
teffects psmatch (directtaxshare) (abovemedian_gdppc leftgov warmobilization execrecruit, probit)
teffects psmatch (directtaxshare) (abovemedian_gdppc leftgov warmobilization execrecruit, probit), atet
psmatch2 abovemedian_gdppc execrecruit warmobilization leftgov , out(directtaxshare) noreplacement

reg directtaxshare execrecruit_lag leftgov_lag  warmobilization_lag lngdppc_lag regiontrend1-regiontrend6 ///
	i.year i.ctyid directtaxshare_lag taxgdp_lag [fweight=_weight], vce(cluster ctyid)

/*Treated variable: urbanization (median)*/
teffects psmatch (directtaxshare) (abovemedian_urban leftgov warmobilization lngdppc execrecruit, probit)
teffects psmatch (directtaxshare) (abovemedian_urban leftgov warmobilization lngdppc execrecruit, probit), atet
psmatch2 abovemedian_urban execrecruit warmobilization leftgov lngdppc , out(directtaxshare) noreplacement

reg directtaxshare execrecruit_lag leftgov_lag lngdppc_lag warmobilization_lag regiontrend1-regiontrend6 i.year ///
	i.ctyid directtaxshare_lag taxgdp_lag [fweight=_weight], vce(cluster ctyid)

*****Table A9: Elite Competition and Overall Taxation, 1870-2010: Additional Time-Varying Observables
clear all
use "JOP data 5 yr avg Beramendi et al.dta", clear
sort ctyid year
xtset ctyid year

xi: xtreg taxgdp execrecruit_lag landineq_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	regiontrend1-regiontrend6 taxgdp_lag i.year, fe vce(cluster ctyid)
	
xi: xtreg taxgdp execrecruit_lag lnexport_lag warmobilization_lag lngdppc_lag ///
	leftgov_lag regiontrend1-regiontrend6 taxgdp_lag i.year, fe vce(cluster ctyid)
	
xi: xtreg taxgdp execrecruit_lag resourcedep_lag warmobilization_lag lngdppc_lag ///
	leftgov_lag regiontrend1-regiontrend6 taxgdp_lag i.year, fe vce(cluster ctyid)
	
xi: xtreg taxgdp execrecruit_lag urbanization_lag warmobilization_lag lngdppc_lag ///
	leftgov_lag regiontrend1-regiontrend6 taxgdp_lag i.year, fe vce(cluster ctyid)
	
xi: xtreg taxgdp execrecruit_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	democracy_lag regiontrend1-regiontrend6 taxgdp_lag i.year, fe vce(cluster ctyid)
	
xi: xtreg taxgdp execrecruit_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	c.urbanization_lag##c.democracy_lag regiontrend1-regiontrend6 taxgdp_lag i.year, fe vce(cluster ctyid)

*****Table A10: Elite Competition and Tax Progressivity, 1870-2010: Additional Time-Varying Observables

xi: xtreg directtaxshare execrecruit_lag landineq_lag warmobilization_lag lngdppc_lag ///
	leftgov_lag regiontrend1-regiontrend6 directtaxshare_lag taxgdp_lag i.year, fe vce(cluster ctyid)

xi: xtreg directtaxshare execrecruit_lag lnexport_lag warmobilization_lag lngdppc_lag ///
	leftgov_lag regiontrend1-regiontrend6 directtaxshare_lag taxgdp_lag i.year, fe vce(cluster ctyid)

xi: xtreg directtaxshare execrecruit_lag resourcedep_lag warmobilization_lag lngdppc_lag ///
	leftgov_lag regiontrend1-regiontrend6 directtaxshare_lag taxgdp_lag i.year, fe vce(cluster ctyid)

xi: xtreg directtaxshare execrecruit_lag urbanization_lag warmobilization_lag lngdppc_lag ///
	leftgov_lag regiontrend1-regiontrend6 directtaxshare_lag taxgdp_lag i.year, fe vce(cluster ctyid)

xi: xtreg directtaxshare execrecruit_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	democracy_lag regiontrend1-regiontrend6 directtaxshare_lag taxgdp_lag i.year, fe vce(cluster ctyid)

xi: xtreg directtaxshare execrecruit_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	c.urbanization_lag##c.democracy_lag regiontrend1-regiontrend6 directtaxshare_lag taxgdp_lag i.year, fe vce(cluster ctyid)

*****Table A11: Elite Competition and Fiscal Development, 1870-2010: Social Identity

xi: xtreg taxgdp execrecruit_lag warmobilization_lag lngdppc_lag leftgov_lag ethnic ethnic_1880-ethnic_2010 ///
	regiontrend1-regiontrend6 taxgdp_lag i.year, fe vce(cluster ctyid)

xi: xtreg taxgdp execrecruit_lag warmobilization_lag lngdppc_lag leftgov_lag language language_1880-language_2010 ///
	regiontrend1-regiontrend6 taxgdp_lag i.year, fe vce(cluster ctyid)

xi: xtreg taxgdp execrecruit_lag warmobilization_lag lngdppc_lag leftgov_lag religion religion_1880-religion_2010 ///
	regiontrend1-regiontrend6 taxgdp_lag i.year, fe vce(cluster ctyid)

xi: xtreg directtaxshare execrecruit_lag warmobilization_lag lngdppc_lag leftgov_lag ethnic ethnic_1880-ethnic_2010 ///
	regiontrend1-regiontrend6 directtaxshare_lag taxgdp_lag i.year, fe vce(cluster ctyid)

xi: xtreg directtaxshare execrecruit_lag warmobilization_lag lngdppc_lag leftgov_lag language language_1880-language_2010 ///
	regiontrend1-regiontrend6 directtaxshare_lag taxgdp_lag i.year, fe vce(cluster ctyid)
	
xi: xtreg directtaxshare execrecruit_lag warmobilization_lag lngdppc_lag leftgov_lag religion religion_1880-religion_2010 ///
	regiontrend1-regiontrend6 directtaxshare_lag taxgdp_lag i.year, fe vce(cluster ctyid)

*****Table A12: Granger-Style Causality Tests
clear all
use "JOP data yearly Beramendi et al.dta", clear
sort ctyid year
xtset ctyid year

/*Intra-elite competition "Granger causes" overall taxation?*/
xi: xtreg taxgdp  warmobilization taxgdp_lag l(2/3).taxgdp execrecruit_lag l(2/3).execrecruit ///
	lngdppc leftgov regiontrend1-regiontrend6 i.year, fe vce(cluster ctyid)
test execrecruit_lag l2.execrecruit l3.execrecruit

xi: xtreg taxgdp warmobilization taxgdp_lag l(2/5).taxgdp execrecruit_lag l(2/5).execrecruit ///
	lngdppc leftgov regiontrend1-regiontrend6 i.year, fe vce(cluster ctyid)
test execrecruit_lag l2.execrecruit l3.execrecruit l4.execrecruit execrecruit_lag

xi: xtreg taxgdp warmobilization taxgdp_lag l(2/10).taxgdp execrecruit_lag l(2/10).execrecruit ///
	lngdppc leftgov regiontrend1-regiontrend6 i.year, fe vce(cluster ctyid)
test execrecruit_lag l2.execrecruit l3.execrecruit l4.execrecruit execrecruit_lag ///
	l6.execrecruit l7.execrecruit l8.execrecruit l9.execrecruit execrecruit_lag

/*Intra-elite competition "Granger causes" tax progressivity?*/
xi: xtreg directtaxshare  warmobilization directtaxshare_lag l(2/3).directtaxshare execrecruit_lag ///
	l(2/3).execrecruit lngdppc leftgov taxgdp regiontrend1-regiontrend6 i.year, fe vce(cluster ctyid)
test execrecruit_lag l2.execrecruit l3.execrecruit

xi: xtreg directtaxshare warmobilization l(2/5).directtaxshare directtaxshare_lag execrecruit_lag ///
	l(2/5).execrecruit lngdppc leftgov taxgdp regiontrend1-regiontrend6 i.year, fe vce(cluster ctyid)
test execrecruit_lag l2.execrecruit l3.execrecruit l4.execrecruit execrecruit_lag

xi: xtreg directtaxshare warmobilization l(2/10).directtaxshare directtaxshare_lag execrecruit_lag ///
	l(2/10).execrecruit lngdppc leftgov taxgdp regiontrend1-regiontrend6 i.year, fe vce(cluster ctyid)
test execrecruit_lag l2.execrecruit l3.execrecruit l4.execrecruit execrecruit_lag ///
	l6.execrecruit l7.execrecruit l8.execrecruit l9.execrecruit execrecruit_lag

/*Overall taxation does not "Granger cause" intra-elite competition?*/
xi: xtreg execrecruit  warmobilization l(2/3).taxgdp taxgdp_lag execrecruit_lag l(2/3).execrecruit ///
	lngdppc leftgov regiontrend1-regiontrend6 i.year, fe vce(cluster ctyid)
test taxgdp_lag l2.taxgdp l3.taxgdp

xi: xtreg execrecruit warmobilization taxgdp_lag l(2/5).taxgdp execrecruit_lag l(2/5).execrecruit lngdppc ///
	leftgov regiontrend1-regiontrend6 i.year, fe vce(cluster ctyid)
test taxgdp_lag l2.taxgdp l3.taxgdp l4.taxgdp taxgdp_lag

xi: xtreg execrecruit warmobilization taxgdp_lag l(2/10).taxgdp execrecruit_lag l(2/10).execrecruit ///
	lngdppc leftgov regiontrend1-regiontrend6 i.year, fe vce(cluster ctyid)
test taxgdp_lag l2.taxgdp l3.taxgdp l4.taxgdp taxgdp_lag l6.taxgdp l7.taxgdp l8.taxgdp l9.taxgdp taxgdp_lag

/*Tax progressivity does not "Granger cause" intra-elite competition*/
xi: xtreg execrecruit  warmobilization directtaxshare_lag l(2/3).directtaxshare execrecruit_lag ///
	l(2/3).execrecruit lngdppc leftgov taxgdp regiontrend1-regiontrend6 i.year, fe vce(cluster ctyid)
test directtaxshare_lag l2.directtaxshare l3.directtaxshare

xi: xtreg execrecruit warmobilization directtaxshare_lag l(2/5).directtaxshare execrecruit_lag ///
	l(2/5).execrecruit lngdppc leftgov taxgdp regiontrend1-regiontrend6 i.year, fe vce(cluster ctyid)
test directtaxshare_lag l2.directtaxshare l3.directtaxshare l4.directtaxshare directtaxshare_lag

xi: xtreg execrecruit warmobilization directtaxshare_lag l(2/10).directtaxshare execrecruit_lag ///
	l(2/10).execrecruit lngdppc leftgov taxgdp regiontrend1-regiontrend6 i.year, fe vce(cluster ctyid)
test directtaxshare_lag l2.directtaxshare l3.directtaxshare l4.directtaxshare directtaxshare_lag ///
	l6.directtaxshare l7.directtaxshare l8.directtaxshare l9.directtaxshare directtaxshare_lag

*****Table A13: Elite Competition and Fiscal Development, 1870-2010: Additional Fiscal Outcomes
clear all
use "JOP data 5 yr avg Beramendi et al.dta", clear
sort ctyid year
xtset ctyid year

xi: xtreg indirecttaxshare execrecruit_lag i.year, fe vce(cluster ctyid)
			
xi: xtreg indirecttaxshare execrecruit_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	regiontrend1-regiontrend6 taxgdp_lag indirecttaxshare_lag i.year, fe vce(cluster ctyid)

xi: xtreg taxbias execrecruit_lag i.year, fe vce(cluster ctyid)		
	
xi: xtreg taxbias execrecruit_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	regiontrend1-regiontrend6  taxbias_lag i.year, fe vce(cluster ctyid)

*****Table A14: Elite Competition and Public Goods Provision, 1870-1975: Public Expenditures in Europe
clear all
use "JOP data yearly Beramendi et al.dta", clear

xi: xtreg totalexpendgdp execrecruit_lag warmobilization_lag lngdppc_lag leftgov_lag i.year ///
	taxgdp_lag , fe vce(cluster ctyid)

xi: xtreg nondefenseexpendgdp execrecruit_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	taxgdp_lag i.year, fe vce(cluster ctyid)
	
xi: xtreg totalexpendgdp execrecruit_lag warmobilization_lag leftgov_lag lngdppc_lag i.year ///
	taxgdp_lag, fe vce(cluster ctyid)
	
xi: xtreg housingexpendgdp execrecruit_lag warmobilization_lag leftgov_lag lngdppc_lag i.year ///
	taxgdp_lag, fe vce(cluster ctyid)
	
********************************************************************************

/*Regression analysis in online appendix (outcome variable: political contestation)*/

*****Table A15: Elite Competition and Fiscal Development, 1870-2010: Exclude Outlier Observations
clear all
use "JOP data 5 yr avg Beramendi et al.dta", clear
sort ctyid year
xtset ctyid year

xi: xtreg taxpars_nooutliers polcontest_lag i.year, fe vce(cluster ctyid)

xi: xtreg taxfull_nooutliers polcontest_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	regiontrend1-regiontrend6 taxfull_nooutliers_lag i.year, fe vce(cluster ctyid)

xi: xtreg directpars_nooutliers polcontest_lag i.year, fe vce(cluster ctyid)

xi: xtreg directfull_nooutliers polcontest_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	regiontrend1-regiontrend6 directfull_nooutliers_lag taxfull_nooutliers_lag i.year, fe vce(cluster ctyid)

*****Table A16: Elite Competition and Fiscal Development, 1870-2010: Yearly Data
clear all
use "JOP data yearly Beramendi et al.dta", clear
sort ctyid year
xtset ctyid year

xi: xtreg taxgdp polcontest_lag i.year, fe vce(cluster ctyid)

xi: xtreg taxgdp polcontest_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	regiontrend1-regiontrend6 taxgdp_lag i.year, fe vce(cluster ctyid)
	
xi: xtreg directtaxshare polcontest_lag i.year, fe vce(cluster ctyid)

xi: xtreg directtaxshare polcontest_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	regiontrend1-regiontrend6 directtaxshare_lag taxgdp_lag i.year, fe vce(cluster ctyid)

*****Table A17: Elite Competition and Overall Taxation, 1870-2010: 10-Year Averaged Data
clear all
use "JOP data 10 yr avg Beramendi et al.dta", clear
sort ctyid year
xtset ctyid year	

xi: xtreg taxgdp polcontest_lag i.year, fe vce(cluster ctyid)

xi: xtreg taxgdp polcontest_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	regiontrend1-regiontrend6 taxgdp_lag i.year, fe vce(cluster ctyid)
	
xi: xtreg directtaxshare polcontest_lag i.year, fe vce(cluster ctyid)

xi: xtreg directtaxshare polcontest_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	regiontrend1-regiontrend6 directtaxshare_lag taxgdp_lag i.year, fe vce(cluster ctyid)

*****Table A18: Elite Competition and Fiscal Development, 1870-2010: Error Correction Models 
clear all
use "JOP data 5 yr avg Beramendi et al.dta", clear
sort ctyid year5
xtset ctyid year5

xi:reg dtaxgdp taxgdp_lag polcontest_lag dpolcontest i.year i.ctyid, vce(cluster ctyid)

xi:reg dtaxgdp taxgdp_lag polcontest_lag dpolcontest lngdppc_lag dlngdppc leftgov_lag ///
	dleftgov warmobilization_lag dwarmobilization i.year i.ctyid regiontrend1-regiontrend6, vce(cluster ctyid)

xi:reg ddirecttaxshare directtaxshare_lag polcontest_lag dpolcontest taxgdp_lag i.year i.ctyid, vce(cluster ctyid)

xi:reg ddirecttaxshare directtaxshare_lag polcontest_lag dpolcontest lngdppc_lag dlngdppc leftgov_lag ///
	dleftgov warmobilization_lag dwarmobilization taxgdp_lag i.year i.ctyid regiontrend1-regiontrend6, vce(cluster ctyid)

*****Table A19: Elite Competition and Overall Taxation, 1870-2010: Matching 
clear all
use "JOP data yearly Beramendi et al.dta", clear
sort ctyid year
xtset ctyid year

/*Treated variable: war participation*/
teffects psmatch (taxgdp) (warparticipant leftgov lngdppc polcontest, probit)
teffects psmatch (taxgdp) (warparticipant leftgov lngdppc polcontest, probit), atet
psmatch2 warparticipant polcontest lngdppc leftgov , out(taxgdp) noreplacement

reg taxgdp polcontest_lag leftgov_lag warmobilization_lag lngdppc_lag regiontrend1-regiontrend6 ///
	i.year i.ctyid taxgdp_lag [fweight=_weight] , vce(cluster ctyid)

/*Treated variable: left government*/
teffects psmatch (taxgdp) (leftgov warmobilization lngdppc polcontest, probit)
teffects psmatch (taxgdp) (leftgov warmobilization lngdppc polcontest, probit), atet
psmatch2 leftgov polcontest lngdppc warmobilization , out(taxgdp) noreplacement

reg taxgdp polcontest_lag  lngdppc_lag warmobilization_lag leftgov_lag regiontrend1-regiontrend6 ///
	i.year i.ctyid taxgdp_lag [fweight=_weight] , vce(cluster ctyid)

/*Treated variable: GDP per capita (median)*/
gen abovemedian_gdppc=0
replace abovemedian_gdppc=1 if lngdppc>=8.506

teffects psmatch (taxgdp) (abovemedian_gdppc leftgov warmobilization polcontest, probit)
teffects psmatch (taxgdp) (abovemedian_gdppc leftgov warmobilization polcontest, probit), atet
psmatch2 abovemedian_gdppc polcontest warmobilization leftgov , out(taxgdp) noreplacement

reg taxgdp polcontest_lag leftgov_lag lngdppc_lag warmobilization_lag regiontrend1-regiontrend6 ///
	i.year i.ctyid taxgdp_lag [fweight=_weight], vce(cluster ctyid)

/*Treated variable: urbanization (median)*/
gen abovemedian_urban=0
replace abovemedian_urban=1 if urban>=44.1763

teffects psmatch (taxgdp) (abovemedian_urban leftgov warmobilization lngdppc polcontest, probit)
teffects psmatch (taxgdp) (abovemedian_urban leftgov warmobilization lngdppc polcontest, probit), atet
psmatch2 abovemedian_urban polcontest warmobilization leftgov lngdppc , out(taxgdp) noreplacement

reg taxgdp polcontest_lag leftgov_lag lngdppc_lag warmobilization_lag regiontrend1-regiontrend6 ///
	i.year i.ctyid taxgdp_lag [fweight=_weight], vce(cluster ctyid)

*****Table A20: Elite Competition and Tax Progressivity, 1870-2010: Matching 

/*Treated variable: war participation*/
teffects psmatch (directtaxshare) (warparticipant leftgov  lngdppc polcontest, probit)
teffects psmatch (directtaxshare) (warparticipant leftgov  lngdppc polcontest, probit), atet
psmatch2 warparticipant polcontest lngdppc leftgov, out(directtaxshare) noreplacement

reg directtaxshare polcontest_lag leftgov_lag warmobilization_lag lngdppc_lag regiontrend1-regiontrend6 ///
	i.year i.ctyid directtaxshare_lag taxgdp_lag [fweight=_weight], vce(cluster ctyid)

/*Treated variable: left government*/
teffects psmatch (directtaxshare) (leftgov warmobilization lngdppc polcontest, probit)
teffects psmatch (directtaxshare) (leftgov warmobilization lngdppc polcontest, probit), atet
psmatch2 leftgov polcontest lngdppc warmobilization , out(directtaxshare) noreplacement

reg directtaxshare polcontest_lag  lngdppc_lag warmobilization_lag leftgov_lag regiontrend1-regiontrend6 ///
	i.year i.ctyid directtaxshare_lag taxgdp_lag [fweight=_weight], vce(cluster ctyid)

/*Treated variable: GDP per capita (median)*/
teffects psmatch (directtaxshare) (abovemedian_gdppc leftgov warmobilization polcontest, probit)
teffects psmatch (directtaxshare) (abovemedian_gdppc leftgov warmobilization polcontest, probit), atet
psmatch2 abovemedian_gdppc polcontest warmobilization leftgov , out(directtaxshare) noreplacement

reg directtaxshare polcontest_lag leftgov_lag  warmobilization_lag lngdppc_lag regiontrend1-regiontrend6 ///
	i.year i.ctyid directtaxshare_lag taxgdp_lag [fweight=_weight], vce(cluster ctyid)

/*Treated variable: urbanization (median)*/
teffects psmatch (directtaxshare) (abovemedian_urban leftgov warmobilization lngdppc polcontest, probit)
teffects psmatch (directtaxshare) (abovemedian_urban leftgov warmobilization lngdppc polcontest, probit), atet
psmatch2 abovemedian_urban polcontest warmobilization leftgov lngdppc , out(directtaxshare) noreplacement

reg directtaxshare polcontest_lag leftgov_lag lngdppc_lag warmobilization_lag regiontrend1-regiontrend6 i.year ///
	i.ctyid directtaxshare_lag taxgdp_lag [fweight=_weight], vce(cluster ctyid)

*****Table A21: Elite Competition and Overall Taxation, 1870-2010: Additional Time-Varying Observables
clear all
use "JOP data 5 yr avg Beramendi et al.dta", clear
sort ctyid year
xtset ctyid year

xi: xtreg taxgdp polcontest_lag landineq_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	regiontrend1-regiontrend6 taxgdp_lag i.year, fe vce(cluster ctyid)
	
xi: xtreg taxgdp polcontest_lag lnexport_lag warmobilization_lag lngdppc_lag ///
	leftgov_lag regiontrend1-regiontrend6 taxgdp_lag i.year, fe vce(cluster ctyid)
	
xi: xtreg taxgdp polcontest_lag resourcedep_lag warmobilization_lag lngdppc_lag ///
	leftgov_lag regiontrend1-regiontrend6 taxgdp_lag i.year, fe vce(cluster ctyid)
	
xi: xtreg taxgdp polcontest_lag urbanization_lag warmobilization_lag lngdppc_lag ///
	leftgov_lag regiontrend1-regiontrend6 taxgdp_lag i.year, fe vce(cluster ctyid)
	
xi: xtreg taxgdp polcontest_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	democracy_lag regiontrend1-regiontrend6 taxgdp_lag i.year, fe vce(cluster ctyid)
	
xi: xtreg taxgdp polcontest_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	c.urbanization_lag##c.democracy_lag regiontrend1-regiontrend6 taxgdp_lag i.year, fe vce(cluster ctyid)

*****Table A22: Elite Competition and Tax Progressivity, 1870-2010: Additional Time-Varying Observables

xi: xtreg directtaxshare polcontest_lag landineq_lag warmobilization_lag lngdppc_lag ///
	leftgov_lag regiontrend1-regiontrend6 directtaxshare_lag taxgdp_lag i.year, fe vce(cluster ctyid)

xi: xtreg directtaxshare polcontest_lag lnexport_lag warmobilization_lag lngdppc_lag ///
	leftgov_lag regiontrend1-regiontrend6 directtaxshare_lag taxgdp_lag i.year, fe vce(cluster ctyid)

xi: xtreg directtaxshare polcontest_lag resourcedep_lag warmobilization_lag lngdppc_lag ///
	leftgov_lag regiontrend1-regiontrend6 directtaxshare_lag taxgdp_lag i.year, fe vce(cluster ctyid)

xi: xtreg directtaxshare polcontest_lag urbanization_lag warmobilization_lag lngdppc_lag ///
	leftgov_lag regiontrend1-regiontrend6 directtaxshare_lag taxgdp_lag i.year, fe vce(cluster ctyid)

xi: xtreg directtaxshare polcontest_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	democracy_lag regiontrend1-regiontrend6 directtaxshare_lag taxgdp_lag i.year, fe vce(cluster ctyid)

xi: xtreg directtaxshare polcontest_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	c.urbanization_lag##c.democracy_lag regiontrend1-regiontrend6 directtaxshare_lag taxgdp_lag i.year, fe vce(cluster ctyid)

*****Table A23: Elite Competition and Fiscal Development, 1870-2010: Social Identity

xi: xtreg taxgdp polcontest_lag warmobilization_lag lngdppc_lag leftgov_lag ethnic ethnic_1880-ethnic_2010 ///
	regiontrend1-regiontrend6 taxgdp_lag i.year, fe vce(cluster ctyid)

xi: xtreg taxgdp polcontest_lag warmobilization_lag lngdppc_lag leftgov_lag language language_1880-language_2010 ///
	regiontrend1-regiontrend6 taxgdp_lag i.year, fe vce(cluster ctyid)

xi: xtreg taxgdp polcontest_lag warmobilization_lag lngdppc_lag leftgov_lag religion religion_1880-religion_2010 ///
	regiontrend1-regiontrend6 taxgdp_lag i.year, fe vce(cluster ctyid)

xi: xtreg directtaxshare polcontest_lag warmobilization_lag lngdppc_lag leftgov_lag ethnic ethnic_1880-ethnic_2010 ///
	regiontrend1-regiontrend6 directtaxshare_lag taxgdp_lag i.year, fe vce(cluster ctyid)

xi: xtreg directtaxshare polcontest_lag warmobilization_lag lngdppc_lag leftgov_lag language language_1880-language_2010 ///
	regiontrend1-regiontrend6 directtaxshare_lag taxgdp_lag i.year, fe vce(cluster ctyid)

xi: xtreg directtaxshare polcontest_lag warmobilization_lag lngdppc_lag leftgov_lag religion religion_1880-religion_2010 ///
	regiontrend1-regiontrend6 directtaxshare_lag taxgdp_lag i.year, fe vce(cluster ctyid)

*****Table A24: Granger-Style Causality Tests
clear all
use "JOP data yearly Beramendi et al.dta", clear
sort ctyid year
xtset ctyid year

/*Intra-elite competition "Granger causes" overall taxation?*/
xi: xtreg taxgdp  warmobilization l(2/3).taxgdp polcontest_lag taxgdp_lag l(2/3).polcontest ///
	lngdppc leftgov regiontrend1-regiontrend6 i.year, fe vce(cluster ctyid)
test polcontest_lag l2.polcontest l3.polcontest

xi: xtreg taxgdp warmobilization l(2/5).taxgdp polcontest_lag taxgdp_lag l(2/5)polcontest ///
	lngdppc leftgov regiontrend1-regiontrend6 i.year, fe vce(cluster ctyid)
test polcontest_lag l2.polcontest l3.polcontest l4.polcontest polcontest_lag

xi: xtreg taxgdp warmobilization l(2/10).taxgdp polcontest_lag taxgdp_lag l(2/10)polcontest ///
	lngdppc leftgov regiontrend1-regiontrend6 i.year, fe vce(cluster ctyid)
test polcontest_lag l2.polcontest l3.polcontest l4.polcontest polcontest_lag ///
	l6.polcontest l7.polcontest l8.polcontest l9.polcontest polcontest_lag

/*Intra-elite competition "Granger causes" tax progressivity?*/
xi: xtreg directtaxshare  warmobilization polcontest_lag directtaxshare_lag l(2/3).directtaxshare ///
	l(2/3).polcontest lngdppc leftgov taxgdp regiontrend1-regiontrend6 i.year, fe vce(cluster ctyid)
test polcontest_lag l2.polcontest l3.polcontest

xi: xtreg directtaxshare warmobilization polcontest_lag directtaxshare_lag l(2/5).directtaxshare ///
	l(2/5)polcontest lngdppc leftgov taxgdp regiontrend1-regiontrend6 i.year, fe vce(cluster ctyid)
test polcontest_lag l2.polcontest l3.polcontest l4.polcontest polcontest_lag

xi: xtreg directtaxshare warmobilization polcontest_lag directtaxshare_lag l(2/10).directtaxshare ///
	l(2/10)polcontest lngdppc leftgov taxgdp regiontrend1-regiontrend6 i.year, fe vce(cluster ctyid)
test polcontest_lag l2.polcontest l3.polcontest l4.polcontest polcontest_lag ///
	l6.polcontest l7.polcontest l8.polcontest l9.polcontest polcontest_lag

/*Overall taxation does not "Granger cause" intra-elite competition?*/
xi: xtreg polcontest  warmobilization polcontest_lag taxgdp_lag l(2/3).taxgdp l(2/3)polcontest ///
	lngdppc leftgov regiontrend1-regiontrend6 i.year, fe vce(cluster ctyid)
test taxgdp_lag l2.taxgdp l3.taxgdp

xi: xtreg polcontest warmobilization polcontest_lag taxgdp_lag l(2/5).taxgdp l(2/5).polcontest ///
	lngdppc leftgov regiontrend1-regiontrend6 i.year, fe vce(cluster ctyid)
test taxgdp_lag l2.taxgdp l3.taxgdp l4.taxgdp taxgdp_lag

xi: xtreg polcontest warmobilization  polcontest_lag taxgdp_lag l(2/10).taxgdp l(2/10).polcontest ///
	lngdppc leftgov regiontrend1-regiontrend6 i.year, fe vce(cluster ctyid)
test taxgdp_lag l2.taxgdp l3.taxgdp l4.taxgdp taxgdp_lag l6.taxgdp l7.taxgdp l8.taxgdp l9.taxgdp taxgdp_lag

/*Tax progressivity does not "Granger cause" intra-elite competition*/
xi: xtreg polcontest  warmobilization polcontest_lag directtaxshare_lag l(2/3).directtaxshare ///
	l(2/3)polcontest lngdppc leftgov taxgdp regiontrend1-regiontrend6 i.year, fe vce(cluster ctyid)
test directtaxshare_lag l2.directtaxshare l3.directtaxshare

xi: xtreg polcontest warmobilization polcontest_lag directtaxshare_lag l(2/5).directtaxshare ///
	l(2/5).polcontest lngdppc leftgov taxgdp regiontrend1-regiontrend6 i.year, fe vce(cluster ctyid)
test directtaxshare_lag l2.directtaxshare l3.directtaxshare l4.directtaxshare directtaxshare_lag

xi: xtreg polcontest warmobilization polcontest_lag directtaxshare_lag l(2/10).directtaxshare ///
	l(2/10).polcontest lngdppc leftgov taxgdp regiontrend1-regiontrend6 i.year, fe vce(cluster ctyid)
test directtaxshare_lag l2.directtaxshare l3.directtaxshare l4.directtaxshare directtaxshare_lag ///
	l6.directtaxshare l7.directtaxshare l8.directtaxshare l9.directtaxshare directtaxshare_lag

*****Table A25: Elite Competition and Fiscal Development, 1870-2010: Additional Fiscal Outcomes
clear all
use "JOP data 5 yr avg Beramendi et al.dta", clear
sort ctyid year
xtset ctyid year

xi: xtreg indirecttaxshare polcontest_lag i.year, fe vce(cluster ctyid)
			
xi: xtreg indirecttaxshare polcontest_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	regiontrend1-regiontrend6 taxgdp_lag indirecttaxshare_lag i.year, fe vce(cluster ctyid)

xi: xtreg taxbias polcontest_lag i.year, fe vce(cluster ctyid)		
	
xi: xtreg taxbias polcontest_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	regiontrend1-regiontrend6  taxbias_lag i.year, fe vce(cluster ctyid)

*****Table A26: Elite Competition and Public Goods Provision, 1870-1975: Public Expenditures in Europe
clear all
use "JOP data yearly Beramendi et al.dta", clear

xi: xtreg totalexpendgdp polcontest_lag warmobilization_lag lngdppc_lag leftgov_lag i.year ///
	taxgdp_lag , fe vce(cluster ctyid)

xi: xtreg nondefenseexpendgdp polcontest_lag warmobilization_lag lngdppc_lag leftgov_lag ///
	taxgdp_lag i.year, fe vce(cluster ctyid)

xi: xtreg totalexpendgdp polcontest_lag warmobilization_lag leftgov_lag lngdppc_lag i.year ///
	taxgdp_lag, fe vce(cluster ctyid)

xi: xtreg housingexpendgdp polcontest_lag warmobilization_lag leftgov_lag lngdppc_lag i.year ///
	taxgdp_lag, fe vce(cluster ctyid)

log close
clear all
