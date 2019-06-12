**************************************************************************************************
*** This do file creates the replication results for 
*** •	Exchange Rate Regime Choice with Multiple Key Currencies 							 	*/
*** Thomas Plümper (University of Essex)																		*/
*** Eric Neumayer (LSE)																			*/
*** 																							*/
*** Published in: International Studies Quarterly, 55 (4), 2011, pp. 1121-1142															*/
**************************************************************************************************
**************************************************************************************************
/* Note: 
You have to change "local DIR" to the directory you copy the original stata files contained 	*/
/* in the zip file and then run the do file. 													*/
**************************************************************************************************

version 10.1
drop _all
clear matrix
clear mata
set mem 800m
set mat 5000

capture net install outreg2, from(http://fmwww.bc.edu/RePEc/bocode/o)			/* checks whether outreg2 is installed 		*/

***********************************************************************************
local DIR = "C:\Research\GDP and Trade\Exchange rates\"  /*change relative path to the directory where the files are located */
cd "`DIR'"
***********************************************************************************

use "Article for ISQ (exchange rate).dta", clear

capture net install prchange, 			/* checks whether prchange is installed 		*/

* Table 3
** Peg at corr>.6 to 1999
xi: quietly mlogit peg_corr90 imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp_corr90  imp_dmarkarea_gdp_corr90 imp_poundarea_gdp_corr90 imp_dollararea_gdp_corr90 centr_bank_independence inflation_peg_dum_20_50  asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us     lngdpd  polity2 polity2_lngdpd   gdppc    nonpeg_spline1_corr90 nonpeg_spline2_corr90 nonpeg_spline3_corr90 peg_spline1_corr90 peg_spline2_corr90 peg_spline3_corr90 i.year if  keycurr==0 & year<1999, base(0) robust 
xi: mlogit peg imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp  imp_dmarkarea_gdp imp_poundarea_gdp imp_dollararea_gdp centr_bank_independence inflation_peg_dum_20_50  asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us     lngdpd  polity2 polity2_lngdpd   gdppc    nonpeg_spline1 nonpeg_spline2 nonpeg_spline3 peg_spline1 peg_spline2 peg_spline3 i.year if  e(sample), base(0) robust 

* Computing substantive effects
prchange imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp  imp_dmarkarea_gdp imp_poundarea_gdp imp_dollararea_gdp centr_bank_independence , rest(median) help

* Table 4
** Peg at corr>.6 after 1999
xi: mlogit pegeuro99   imp_euro99country_gdp  imp_us_gdp   imp_euro99area_gdp imp_dollararea_gdp centr_bank_independence inflation_peg_dum_20_50  asym_growth_euro asym_growth_us    lngdpd polity2 polity2_lngdpd    gdppc    nonpeg_spline1 nonpeg_spline2 nonpeg_spline3 peg_spline1 peg_spline2 peg_spline3 i.year if  keycurr==0 , base(0) robust 

* Table 5
** Sureg to 1999
xi: sureg (corrffranc imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp  imp_dmarkarea_gdp imp_poundarea_gdp imp_dollararea_gdp  inflation_peg_dum_20_50   centr_bank_independence     asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us lngdpd   gdppc    polity2 polity2_lngdpd   i.year) (corrdmark imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp  imp_dmarkarea_gdp imp_poundarea_gdp imp_dollararea_gdp  inflation_peg_dum_20_50   centr_bank_independence     asym_growth_fra asym_growth_deu asym_growth_uk  asym_growth_us lngdpd   gdppc    polity2 polity2_lngdpd    i.year) (corrpound imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp  imp_dmarkarea_gdp imp_poundarea_gdp imp_dollararea_gdp  inflation_peg_dum_20_50   centr_bank_independence     asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us lngdpd   gdppc    polity2 polity2_lngdpd    i.year) (corrdollar imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp  imp_dmarkarea_gdp imp_poundarea_gdp imp_dollararea_gdp  inflation_peg_dum_20_50   centr_bank_independence     asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us lngdpd   gdppc    polity2 polity2_lngdpd    i.year) if  keycurr==0 & year<1999,

* Table 6
** Sureg after 1999
xi: sureg (corrdmark imp_euro99country_gdp   imp_us_gdp   imp_euro99area_gdp imp_dollararea_gdp inflation_peg_dum_20_50   centr_bank_independence     asym_growth_euro  asym_growth_us lngdpd   gdppc    polity2 polity2_lngdpd   i.year) (corrdollar imp_euro99country_gdp  imp_us_gdp   imp_euro99area_gdp imp_dollararea_gdp inflation_peg_dum_20_50   centr_bank_independence     asym_growth_euro asym_growth_us lngdpd   gdppc    polity2 polity2_lngdpd   i.year) if  keycurr==0 & year>=1999, 


* ROBUSTNESS TESTS *
** Peg only at corr>.9 to 1999
xi: mlogit peg_corr90 imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp_corr90  imp_dmarkarea_gdp_corr90 imp_poundarea_gdp_corr90 imp_dollararea_gdp_corr90 centr_bank_independence inflation_peg_dum_20_50  asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us     lngdpd  polity2 polity2_lngdpd   gdppc    nonpeg_spline1_corr90 nonpeg_spline2_corr90 nonpeg_spline3_corr90 peg_spline1_corr90 peg_spline2_corr90 peg_spline3_corr90 i.year if  keycurr==0 & year<1999, base(0) robust 

* Peg only at corr>.9 after 1999
xi: mlogit pegeuro99_corr90   imp_euro99country_gdp  imp_us_gdp   imp_euro99area_gdp_corr90 imp_dollararea_gdp centr_bank_independence inflation_peg_dum_20_50  asym_growth_euro asym_growth_us    lngdpd polity2 polity2_lngdpd    gdppc    nonpeg_spline1_corr90 nonpeg_spline2_corr90 nonpeg_spline3_corr90 peg_spline1_corr90 peg_spline2_corr90 peg_spline3_corr90 i.year if  keycurr==0 , base(0) robust 

** Imports set to first year after peg
** Peg at corr>.6 to 1999
xi: quietly mlogit peg_corr90 imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp_corr90  imp_dmarkarea_gdp_corr90 imp_poundarea_gdp_corr90 imp_dollararea_gdp_corr90 centr_bank_independence inflation_peg_dum_20_50  asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us     lngdpd  polity2 polity2_lngdpd   gdppc    nonpeg_spline1_corr90 nonpeg_spline2_corr90 nonpeg_spline3_corr90 peg_spline1_corr90 peg_spline2_corr90 peg_spline3_corr90 i.year if  keycurr==0 & year<1999, base(0) robust 
xi: mlogit peg imp_fra_gdp_fixpostpeg imp_deu_gdp_fixpostpeg imp_uk_gdp_fixpostpeg imp_us_gdp_fixpostpeg  imp_francarea_gdp_fixpostpeg  imp_dmarkarea_gdp_fixpostpeg imp_poundarea_gdp_fixpostpeg imp_dollararea_gdp_fixpostpeg centr_bank_independence inflation_peg_dum_20_50  asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us     lngdpd  polity2 polity2_lngdpd   gdppc    nonpeg_spline1 nonpeg_spline2 nonpeg_spline3 peg_spline1 peg_spline2 peg_spline3 i.year if  e(sample), base(0) robust 

* Table 4
** Peg at corr>.6 after 1999
xi: mlogit pegeuro99   imp_euro99country_gdp_fixpostpeg  imp_us_gdp_fixpostpeg   imp_euro99area_gdp_fixpostpeg imp_dollararea_gdp_fixpostpeg centr_bank_independence inflation_peg_dum_20_50  asym_growth_euro asym_growth_us    lngdpd polity2 polity2_lngdpd    gdppc    nonpeg_spline1 nonpeg_spline2 nonpeg_spline3 peg_spline1 peg_spline2 peg_spline3 i.year if  keycurr==0 , base(0) robust 


** including general trade openness, capital account openness and reserves
* Table 3
** Peg at corr>.6 to 1999
xi: quietly mlogit peg_corr90 imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp_corr90  imp_dmarkarea_gdp_corr90 imp_poundarea_gdp_corr90 imp_dollararea_gdp_corr90 centr_bank_independence inflation_peg_dum_20_50  asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us     imp_total_gdp  kaopen reservesi  lngdpd  polity2 polity2_lngdpd   gdppc    nonpeg_spline1_corr90 nonpeg_spline2_corr90 nonpeg_spline3_corr90 peg_spline1_corr90 peg_spline2_corr90 peg_spline3_corr90 i.year if  keycurr==0 & year<1999, base(0) robust 
xi: mlogit peg imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp  imp_dmarkarea_gdp imp_poundarea_gdp imp_dollararea_gdp centr_bank_independence inflation_peg_dum_20_50  asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us     imp_total_gdp  kaopen reservesi  lngdpd  polity2 polity2_lngdpd   gdppc    nonpeg_spline1 nonpeg_spline2 nonpeg_spline3 peg_spline1 peg_spline2 peg_spline3 i.year if  e(sample), base(0) robust 

* Table 4
** Peg at corr>.6 after 1999
xi: mlogit pegeuro99   imp_euro99country_gdp  imp_us_gdp   imp_euro99area_gdp imp_dollararea_gdp centr_bank_independence inflation_peg_dum_20_50  asym_growth_euro asym_growth_us    imp_total_gdp  kaopen reservesi  lngdpd polity2 polity2_lngdpd    gdppc    nonpeg_spline1 nonpeg_spline2 nonpeg_spline3 peg_spline1 peg_spline2 peg_spline3 i.year if  keycurr==0 , base(0) robust 

* Table 5
** Sureg to 1999
xi: sureg (corrffranc imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp  imp_dmarkarea_gdp imp_poundarea_gdp imp_dollararea_gdp  inflation_peg_dum_20_50   centr_bank_independence     asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us imp_total_gdp  kaopen reservesi  lngdpd   gdppc    polity2 polity2_lngdpd   i.year) (corrdmark imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp  imp_dmarkarea_gdp imp_poundarea_gdp imp_dollararea_gdp  inflation_peg_dum_20_50   centr_bank_independence     asym_growth_fra asym_growth_deu asym_growth_uk  asym_growth_us imp_total_gdp  kaopen reservesi  lngdpd   gdppc    polity2 polity2_lngdpd    i.year) (corrpound imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp  imp_dmarkarea_gdp imp_poundarea_gdp imp_dollararea_gdp  inflation_peg_dum_20_50   centr_bank_independence     asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us imp_total_gdp  kaopen reservesi  lngdpd   gdppc    polity2 polity2_lngdpd    i.year) (corrdollar imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp  imp_dmarkarea_gdp imp_poundarea_gdp imp_dollararea_gdp  inflation_peg_dum_20_50   centr_bank_independence     asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us imp_total_gdp  kaopen reservesi  lngdpd   gdppc    polity2 polity2_lngdpd    i.year) if  keycurr==0 & year<1999,

* Table 6
** Sureg after 1999
xi: sureg (corrdmark imp_euro99country_gdp   imp_us_gdp   imp_euro99area_gdp imp_dollararea_gdp inflation_peg_dum_20_50   centr_bank_independence     asym_growth_euro  asym_growth_us imp_total_gdp  kaopen reservesi  lngdpd   gdppc    polity2 polity2_lngdpd   i.year) (corrdollar imp_euro99country_gdp  imp_us_gdp   imp_euro99area_gdp imp_dollararea_gdp inflation_peg_dum_20_50   centr_bank_independence     asym_growth_euro asym_growth_us imp_total_gdp  kaopen reservesi  lngdpd   gdppc    polity2 polity2_lngdpd   i.year) if  keycurr==0 & year>=1999, 


** Colonial dummy variables for FRA and UK plus other political factors
** Peg at corr>.6 to 1999
xi: quietly mlogit peg_corr90 imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp_corr90  imp_dmarkarea_gdp_corr90 imp_poundarea_gdp_corr90 imp_dollararea_gdp_corr90 centr_bank_independence inflation_peg_dum_20_50  asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us     lngdpd  polity2 polity2_lngdpd unvotinginter_fra unvotinginter_deu unvotinginter_uk unvotinginter_us atopally_fra atopally_deu atopally_uk atopally_us   gdppc    nonpeg_spline1_corr90 nonpeg_spline2_corr90 nonpeg_spline3_corr90 peg_spline1_corr90 peg_spline2_corr90 peg_spline3_corr90 i.year if  keycurr==0 & year<1999, base(0) robust 
xi: mlogit peg imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp  imp_dmarkarea_gdp imp_poundarea_gdp imp_dollararea_gdp centr_bank_independence inflation_peg_dum_20_50  asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us     lngdpd  polity2 polity2_lngdpd unvotinginter_fra unvotinginter_deu unvotinginter_uk unvotinginter_us atopally_fra atopally_deu atopally_uk atopally_us   gdppc    nonpeg_spline1 nonpeg_spline2 nonpeg_spline3 peg_spline1 peg_spline2 peg_spline3 i.year if  e(sample), base(0) robust 

* Table 4
** Peg at corr>.6 after 1999
xi: mlogit pegeuro99   imp_euro99country_gdp  imp_us_gdp   imp_euro99area_gdp imp_dollararea_gdp centr_bank_independence inflation_peg_dum_20_50  asym_growth_euro asym_growth_us    lngdpd polity2 polity2_lngdpd unvotinginter_fra unvotinginter_deu unvotinginter_uk unvotinginter_us atopally_fra atopally_deu atopally_uk atopally_us    gdppc    nonpeg_spline1 nonpeg_spline2 nonpeg_spline3 peg_spline1 peg_spline2 peg_spline3 i.year if  keycurr==0 , base(0) robust 

* Table 5
** Sureg to 1999
xi: sureg (corrffranc imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp  imp_dmarkarea_gdp imp_poundarea_gdp imp_dollararea_gdp  inflation_peg_dum_20_50   centr_bank_independence     asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us lngdpd   gdppc    polity2 polity2_lngdpd unvotinginter_fra unvotinginter_deu unvotinginter_uk unvotinginter_us atopally_fra atopally_deu atopally_uk atopally_us   i.year) (corrdmark imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp  imp_dmarkarea_gdp imp_poundarea_gdp imp_dollararea_gdp  inflation_peg_dum_20_50   centr_bank_independence     asym_growth_fra asym_growth_deu asym_growth_uk  asym_growth_us lngdpd   gdppc    polity2 polity2_lngdpd unvotinginter_fra unvotinginter_deu unvotinginter_uk unvotinginter_us atopally_fra atopally_deu atopally_uk atopally_us    i.year) (corrpound imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp  imp_dmarkarea_gdp imp_poundarea_gdp imp_dollararea_gdp  inflation_peg_dum_20_50   centr_bank_independence     asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us lngdpd   gdppc    polity2 polity2_lngdpd unvotinginter_fra unvotinginter_deu unvotinginter_uk unvotinginter_us atopally_fra atopally_deu atopally_uk atopally_us    i.year) (corrdollar imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp  imp_dmarkarea_gdp imp_poundarea_gdp imp_dollararea_gdp  inflation_peg_dum_20_50   centr_bank_independence     asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us lngdpd   gdppc    polity2 polity2_lngdpd unvotinginter_fra unvotinginter_deu unvotinginter_uk unvotinginter_us atopally_fra atopally_deu atopally_uk atopally_us    i.year) if  keycurr==0 & year<1999,

* Table 6
** Sureg after 1999
xi: sureg (corrdmark imp_euro99country_gdp   imp_us_gdp   imp_euro99area_gdp imp_dollararea_gdp inflation_peg_dum_20_50   centr_bank_independence     asym_growth_euro  asym_growth_us lngdpd   gdppc    polity2 polity2_lngdpd unvotinginter_fra unvotinginter_deu unvotinginter_uk unvotinginter_us atopally_fra atopally_deu atopally_uk atopally_us   i.year) (corrdollar imp_euro99country_gdp  imp_us_gdp   imp_euro99area_gdp imp_dollararea_gdp inflation_peg_dum_20_50   centr_bank_independence     asym_growth_euro asym_growth_us lngdpd   gdppc    polity2 polity2_lngdpd unvotinginter_fra unvotinginter_deu unvotinginter_uk unvotinginter_us atopally_fra atopally_deu atopally_uk atopally_us   i.year) if  keycurr==0 & year>=1999, 


** Regional dummy variables
** Peg at corr>.6 to 1999
xi: quietly mlogit peg_corr90 imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp_corr90  imp_dmarkarea_gdp_corr90 imp_poundarea_gdp_corr90 imp_dollararea_gdp_corr90 centr_bank_independence inflation_peg_dum_20_50  asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us     lngdpd  polity2 polity2_lngdpd reg_eap reg_eca reg_mena reg_sa reg_ssa reg_lac   gdppc    nonpeg_spline1_corr90 nonpeg_spline2_corr90 nonpeg_spline3_corr90 peg_spline1_corr90 peg_spline2_corr90 peg_spline3_corr90 i.year if  keycurr==0 & year<1999, base(0) robust 
xi: mlogit peg imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp  imp_dmarkarea_gdp imp_poundarea_gdp imp_dollararea_gdp centr_bank_independence inflation_peg_dum_20_50  asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us     lngdpd  polity2 polity2_lngdpd reg_eap reg_eca reg_mena reg_sa reg_ssa reg_lac   gdppc    nonpeg_spline1 nonpeg_spline2 nonpeg_spline3 peg_spline1 peg_spline2 peg_spline3 i.year if  e(sample), base(0) robust 

* Table 4
** Peg at corr>.6 after 1999
xi: mlogit pegeuro99   imp_euro99country_gdp  imp_us_gdp   imp_euro99area_gdp imp_dollararea_gdp centr_bank_independence inflation_peg_dum_20_50  asym_growth_euro asym_growth_us    lngdpd polity2 polity2_lngdpd reg_eap reg_eca reg_mena reg_sa reg_ssa reg_lac    gdppc    nonpeg_spline1 nonpeg_spline2 nonpeg_spline3 peg_spline1 peg_spline2 peg_spline3 i.year if  keycurr==0 , base(0) robust 

* Table 5
** Sureg to 1999
xi: sureg (corrffranc imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp  imp_dmarkarea_gdp imp_poundarea_gdp imp_dollararea_gdp  inflation_peg_dum_20_50   centr_bank_independence     asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us lngdpd   gdppc    polity2 polity2_lngdpd reg_eap reg_eca reg_mena reg_sa reg_ssa reg_lac   i.year) (corrdmark imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp  imp_dmarkarea_gdp imp_poundarea_gdp imp_dollararea_gdp  inflation_peg_dum_20_50   centr_bank_independence     asym_growth_fra asym_growth_deu asym_growth_uk  asym_growth_us lngdpd   gdppc    polity2 polity2_lngdpd reg_eap reg_eca reg_mena reg_sa reg_ssa reg_lac    i.year) (corrpound imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp  imp_dmarkarea_gdp imp_poundarea_gdp imp_dollararea_gdp  inflation_peg_dum_20_50   centr_bank_independence     asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us lngdpd   gdppc    polity2 polity2_lngdpd reg_eap reg_eca reg_mena reg_sa reg_ssa reg_lac    i.year) (corrdollar imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp  imp_dmarkarea_gdp imp_poundarea_gdp imp_dollararea_gdp  inflation_peg_dum_20_50   centr_bank_independence     asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us lngdpd   gdppc    polity2 polity2_lngdpd reg_eap reg_eca reg_mena reg_sa reg_ssa reg_lac    i.year) if  keycurr==0 & year<1999,

* Table 6
** Sureg after 1999
xi: sureg (corrdmark imp_euro99country_gdp   imp_us_gdp   imp_euro99area_gdp imp_dollararea_gdp inflation_peg_dum_20_50   centr_bank_independence     asym_growth_euro  asym_growth_us lngdpd   gdppc    polity2 polity2_lngdpd reg_eap reg_eca reg_mena reg_sa reg_ssa reg_lac   i.year) (corrdollar imp_euro99country_gdp  imp_us_gdp   imp_euro99area_gdp imp_dollararea_gdp inflation_peg_dum_20_50   centr_bank_independence     asym_growth_euro asym_growth_us lngdpd   gdppc    polity2 polity2_lngdpd reg_eap reg_eca reg_mena reg_sa reg_ssa reg_lac   i.year) if  keycurr==0 & year>=1999, 


** Adding the lagged dependent variable

* Table 3
** Peg at corr>.6 to 1999
xi: quietly mlogit peg_corr90 imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp_corr90  imp_dmarkarea_gdp_corr90 imp_poundarea_gdp_corr90 imp_dollararea_gdp_corr90 centr_bank_independence inflation_peg_dum_20_50  asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us     lngdpd  polity2 polity2_lngdpd   gdppc    nonpeg_spline1_corr90 nonpeg_spline2_corr90 nonpeg_spline3_corr90 peg_spline1_corr90 peg_spline2_corr90 peg_spline3_corr90 i.year if  keycurr==0 & year<1999, base(0) robust 
xi: mlogit peg lpeg imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp  imp_dmarkarea_gdp imp_poundarea_gdp imp_dollararea_gdp centr_bank_independence inflation_peg_dum_20_50  asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us     lngdpd  polity2 polity2_lngdpd   gdppc    nonpeg_spline1 nonpeg_spline2 nonpeg_spline3 peg_spline1 peg_spline2 peg_spline3 i.year if  e(sample), base(0) robust 

* Table 4
** Peg at corr>.6 after 1999
xi: mlogit pegeuro99 lpegeuro  imp_euro99country_gdp  imp_us_gdp   imp_euro99area_gdp imp_dollararea_gdp centr_bank_independence inflation_peg_dum_20_50  asym_growth_euro asym_growth_us    lngdpd polity2 polity2_lngdpd    gdppc    nonpeg_spline1 nonpeg_spline2 nonpeg_spline3 peg_spline1 peg_spline2 peg_spline3 i.year if  keycurr==0 , base(0) robust 


** DM and Franc together from 1974 onwards
xi: quietly mlogit peg_corr90 imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp_corr90  imp_dmarkarea_gdp_corr90 imp_poundarea_gdp_corr90 imp_dollararea_gdp_corr90 centr_bank_independence inflation_peg_dum_20_50  asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us     lngdpd  polity2 polity2_lngdpd   gdppc    nonpeg_spline1_corr90 nonpeg_spline2_corr90 nonpeg_spline3_corr90 peg_spline1_corr90 peg_spline2_corr90 peg_spline3_corr90 i.year if  keycurr==0 & year<1999, base(0) robust 
xi: mlogit pegdmfranc1974on imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp  imp_dmarkarea_gdp imp_poundarea_gdp imp_dollararea_gdp centr_bank_independence inflation_peg_dum_20_50  asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us     lngdpd  polity2 polity2_lngdpd   gdppc    nonpeg_spline1 nonpeg_spline2 nonpeg_spline3 peg_spline1 peg_spline2 peg_spline3 i.year if  e(sample), base(0) robust 


** Shambaug's peg variable
xi: mlogit  sham_peg imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp  imp_dmarkarea_gdp imp_poundarea_gdp imp_dollararea_gdp centr_bank_independence inflation_peg_dum_20_50  asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us     lngdpd  polity2 polity2_lngdpd   gdppc  sham_imp_francarea_gdp  sham_imp_dmarkarea_gdp sham_imp_poundarea_gdp sham_imp_dollararea_gdp  sham_nonpeg_spline1 sham_nonpeg_spline2 sham_nonpeg_spline3    sham_peg_spline1 sham_peg_spline2 sham_peg_spline3 , base(0) robust 

** Reinhard and Rogoff's peg variable
xi: mlogit  rr_peg imp_fra_gdp imp_deu_gdp imp_uk_gdp imp_us_gdp  imp_francarea_gdp  imp_dmarkarea_gdp imp_poundarea_gdp imp_dollararea_gdp centr_bank_independence inflation_peg_dum_20_50  asym_growth_fra asym_growth_deu asym_growth_uk asym_growth_us     lngdpd  polity2 polity2_lngdpd   gdppc  rr_imp_francarea_gdp  rr_imp_dmarkarea_gdp rr_imp_poundarea_gdp rr_imp_dollararea_gdp  rr_nonpeg_spline1 rr_nonpeg_spline2 rr_nonpeg_spline3    rr_peg_spline1 rr_peg_spline2 rr_peg_spline3 , base(0) robust 


** mprobit instead of mlogit, Note: does not become concave in estimations to 1999

* Table 4
** Peg at corr>.6 after 1999
xi: mprobit pegeuro99   imp_euro99country_gdp  imp_us_gdp   imp_euro99area_gdp imp_dollararea_gdp centr_bank_independence inflation_peg_dum_20_50  asym_growth_euro asym_growth_us    lngdpd polity2 polity2_lngdpd    gdppc    nonpeg_spline1 nonpeg_spline2 nonpeg_spline3 peg_spline1 peg_spline2 peg_spline3 i.year if  keycurr==0 , base(0) robust 

* Peg only at corr>.9 after 1999
xi: mprobit pegeuro99_corr90   imp_euro99country_gdp  imp_us_gdp   imp_euro99area_gdp_corr90 imp_dollararea_gdp centr_bank_independence inflation_peg_dum_20_50  asym_growth_euro asym_growth_us    lngdpd polity2 polity2_lngdpd    gdppc    nonpeg_spline1_corr90 nonpeg_spline2_corr90 nonpeg_spline3_corr90 peg_spline1_corr90 peg_spline2_corr90 peg_spline3_corr90 i.year if  keycurr==0 , base(0) robust 



