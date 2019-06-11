*** Data Analysis - Differential Effects of BITS
*** Author: Sarah Bauerle Danzman
*** Created: 5/19/2015
*** Modified 11/5/2015

/* This do file runs analysis for "The Differential Effects of Investment Treaties"
Please use bitinfrastructurenov2015.dta to analyze these data.
Each model is labeled by the table and model number from the paper 

Additionally, an explanation of how substantive effects were computed is provided at the end 
of the document. I used R to perform the calcuations, but any calcuator that has a exp()
function will be sufficent.*/

/* Variables Used:
iso3n - country code (iso numerical code)
year - year
lnfdi - natural log of FDI inflows (UNCTAD)
lnpriv - natural log of Private Participation in Infrastructure (WB PPI)
strong_bits - count of ratified BITs with strong arbitration provisions (Yackee 2008)
strong_bits2 - strong_bits squared
bitstodate_bit - count of all BITs to date (Graham 2015)
bits_graham_2 - all BITs to date squared
weakbits - count of BITs swithout strong arbitration provisions (Yackee 2008)
weakbits2 - weak bits squared
polconiii - Political Constraints (Henisz)
polity2 - the Polity 2 measure from the Polity IV project
lnpop - natural log of population (WDI)
lngdppc - natural log of gdp per capita (WDI)
gdpgr - gdp growth (WDI)
lntrade - natural log of imports+exports/GDP (WDI)
ptacum2 - cumulative preferential trade agreements (Buthe and Milner 2008)
ckaopen2010 - Capital Account Openness (Karcher and Steinberg)
lninfation - natural log of inflation (WDI)
savings - domestic savings/gdp (WDI)
worldbits_ni - cumulative number of strong BITs worldwide minus strong BITs in country i
lnworldfdi_ni - natural log of world FDI inflows in time t minus FDI inflows in country i
lnworldpriv_ni - natural log of world infrastructure privatization inflows in tiem t minus inflows in country i
world_bits_graham_ni - cumulative number of all BITs worldwide minus BITs in country i
world_weakbits_ni - cumulative number of weak BITs worldwide minus BITs in country i
maworldsbits_ni - 3 year moving world average of strong BITs in time t minus strong BITs in country i
avgregionsbit_ni - 3 year moving regional average of strong BITs in time t minus strong BITs in country i 
(for the regional referent group for country i)
maworldbits_graham_ni - 3 year moving world average of all BITs in time t minus all BITs in country i
maregionsbits_graham_ni - 3 year moving regional average of all BITs in time t minus all BITs in country i
(for the regional referent group for country i)
east_asia  - dummy for East Asia
europe - dummy for Europe
mena - dummy for Middle East/North Africa
south_asia - dummy for South Asia
ssa - dummy for Subsaharan Africa

Additionally, to run Driscoll Kraay regressions (xtscc), you cannot use lags. Therefore,
all variables are also converted to lags; this is denoted with an "l" in front of the respective
variable name. The xtscc may not come pre-installed on your Stata software. type "findit xtscc" to
install. */


**************************************
************ Table 1 *****************
**************************************
xtset iso3n year
*** FE (Model 1, Table 1)
xtreg lnfdi l.lnfdi l.strong_bits l.strong_bits2 l.polconiii l.polity2 ///
l.lnpop l.lngdppc l.gdpgr l.lntrade l.ptacum2 l.ckaopen2010 l.lninflation ///
l.savings l.worldsbits_ni l.lnworldfdi_ni, fe cluster(iso3n)
*** gls (Model 2, Table 1)
xtgls lnfdi l.strong_bits l.strong_bits2 l.polconiii l.polity2 ///
l.lnpop l.lngdppc l.gdpgr l.lntrade l.ptacum2 l.ckaopen2010 l.lninflation ///
l.savings l.worldsbits_ni l.lnworldfdi_ni i.iso3n, corr(psar1) force
*** FE (Model 3, Table 1)
xtreg lnpriv l.lnpriv l.strong_bits l.strong_bits2 l.polconiii l.polity2 ///
l.lnpop l.lngdppc l.gdpgr l.lntrade l.ptacum2 l.ckaopen2010 l.lninflation ///
l.savings l.worldsbits_ni l.lnworldpriv_ni, fe cluster(iso3n)
***** GLS
xtgls lnpriv l.strong_bits l.strong_bits2 l.polconiii l.polity2 ///
l.lnpop l.lngdppc l.gdpgr l.lntrade l.ptacum2 l.ckaopen2010 l.lninflation ///
l.savings l.worldsbits_ni l.lnworldpriv_ni i.iso3n, corr(psar1) force

**************************************
************ Table 2 *****************
**************************************
*** Model 5 (FDI, All BITs, FE)
xtreg lnfdi l.lnfdi l.bitstodate_bit l.bits_graham_2 l.polconiii ///
l.polity2 l.lnpop l.lngdppc l.gdpgr l.lntrade l.ptacum2 l.ckaopen2010 l.lninflation ///
l.savings l.world_bits_graham_ni l.lnworldfdi_ni, fe cluster(iso3n)
*** Model 6 (FDI, Weak BITs, FE) 
xtreg lnfdi l.lnfdi l.weakbits l.weakbits2 l.polconiii ///
l.polity2 l.lnpop l.lngdppc l.gdpgr l.lntrade l.ptacum2 l.ckaopen2010 l.lninflation ///
l.savings l.world_weakbits_ni l.lnworldfdi_ni, fe cluster(iso3n)
*** Model 7 (PRIV, All BITs, FE)
xtreg lnpriv l.lnpriv l.bitstodate_bit l.bits_graham_2 l.polconiii ///
l.polity2 l.lnpop l.lngdppc l.gdpgr l.lntrade l.ptacum2 l.ckaopen2010 l.lninflation ///
l.savings l.world_bits_graham_ni l.lnworldpriv_ni, fe cluster(iso3n)
*** Model 8 (PRIV, Weak BITs, FE)
xtreg lnpriv l.lnpriv l.weakbits l.weakbits2 l.polconiii ///
l.polity2 l.lnpop l.lngdppc l.gdpgr l.lntrade l.ptacum2 l.ckaopen2010 l.lninflation ///
l.savings l.world_weakbits_ni l.lnworldpriv_ni, fe cluster(iso3n)

****************************************
************ Table 3 *******************
****************************************

/* The following 8 models (models 9 through 16) are instrumental
variable regressions. The information I report in Table 3 are
the regression statistics that evaluate whether instruments are needed
for these data. As the following tests show, BITs are not 
endogenous to investment flows. The closest we come to concerns over endogeneity 
is in Model 9, when the p-values on the Wooldridge and Robust regression tests get 
relatively close to rejecting the null hypothesis of exogeneity (p-values around .15). */

/* The instruments used in each model are the three year moving average of all world bits
in all countries not i (maworldsbits_ni for strong bits and maworldbits_graham_ni for all bits)
and the three year moving average of the number of bits in i's region, not including i. 

The code used to create these measures is as follows (commented out because I already
created these measure for the purposes of the stata file):

***To create maworldbits_graham_ni****
sort year
by year: egen world_bits_graham=total(bitstodate_BIT)
gen world_bits_graham_ni=world_bits_graham-bitstodate_BIT
sort iso3n year
gen maworldbits_graham_ni=(F1.world_bits_graham_ni+world_bits_graham_ni+ L1.world_bits_graham_ni)/3

*** To create maregionsbits_graham_ni***
sort region_code year
by region_code year: egen regionsbits_graham=total(bitstodate_BIT)
sort iso3n year
gen regionsbits_graham_ni=regionsbits_graham-bitstodate_BIT
gen maregionsbits_graham_ni=(F1.regionsbits_graham_ni+regionsbits_graham_ni+ L1.regionsbits_graham_ni)/3

*** To create maworldsbits_ni***
sort year
by year: egen world_sbits=total(strong_bits)
gen world_sbits_ni=world_sbits-strong_bits
sort iso3n year
gen maworldsbits_ni=(F1.world_sbits_ni+world_sbits_ni+ L1.world_sbits_ni)/3

*** To create avgregionsbit_ni***
sort region_code year
by region_code year: egen regionsbits=total(strong_bits)
sort iso3n year
gen regionsbits_ni=regionsbits-strong_bits
gen avgregionsbit_ni=(F1.regionsbits_ni+regionsbits_ni+ L1.regionsbits_ni)/3
*/


*** Model 9 (FDI, 2sls, strong bits)
ivregress 2sls lnfdi l.lnfdi l.lnpriv l.polconiii l.polity2 l.lnpop l.lngdppc ///
l.gdpgr l.lntrade l.ptacum2 l.ckaopen2010 l.lninflation l.savings ///
l.lnworldfdi i.iso3n i.year (l.strong_bits=l.avgregionsbit_ni l.maworldsbits_ni), vce(robust)
estat endogenous 
/* Robust score chi2(1)            =  2.01853  (p = 0.1554)
Robust regression F(1,2317)     =   1.8909  (p = 0.1692) */  
estat first /* F=46252.4 */
estat overid /* TScore chi2(1) =  3.22828  (p = 0.0724) */

*** Model 10 (FDI, gmm, strong bits)
ivregress gmm lnfdi l.lnfdi l.lnpriv l.polconiii l.polity2 l.lnpop l.lngdppc ///
l.gdpgr l.lntrade l.ptacum2 l.ckaopen2010 l.lninflation l.savings ///
l.lnworldfdi i.iso3n i.year (l.strong_bits=l.avgregionsbit_ni l.maworldsbits_ni), vce(robust)
estat endogenous /* GMM C statistic chi2(1) =  1.76938  (p = 0.1835) */
estat first /* F statistic = 46252.4 */
estat overid /*  Hansen's J chi2(1) = 3.22829 (p = 0.0724) */

*** Model 11 (FDI, 2sls, all bits)
ivregress 2sls lnfdi l.lnpriv l.lnfdi l.polconiii l.polity2 l.lnpop l.lngdppc l.gdpgr l.lntrade ///
l.ptacum2 l.ckaopen2010 l.lninflation l.savings l.lnworldfdi i.year i.iso3n ///
(l.bitstodate_bit=l.maregionsbits_graham_ni l.maworldbits_graham_ni), vce(robust)
estat endogenous
/* Robust score chi2(1)            =  .520936  (p = 0.4704)
  Robust regression F(1,2244)     =  .484502  (p = 0.4865) */
estat first /* F statistic = 77107.1 */
estat overid /* Score chi2(1) =  1.17724  (p = 0.2779) */

*** Model 12 (FDI, gmm, all bits)
ivregress gmm lnfdi l.lnpriv l.lnfdi l.polconiii l.polity2 l.lnpop l.lngdppc l.gdpgr l.lntrade ///
l.ptacum2 l.ckaopen2010 l.lninflation l.savings l.lnworldfdi i.year i.iso3n ///
(l.bitstodate_bit=l.maregionsbits_graham_ni l.maworldbits_graham_ni), vce(robust)
estat endogenous /* GMM C statistic chi2(1) =  .478831  (p = 0.4890) */
estat first /* F=  77107.1 */
estat overid /* Hansen's J chi2(1) = 1.17724 (p = 0.2779) */

***** Model 13 (PRIV, 2sls, strong bits)
ivregress 2sls lnpriv l.lnpriv l.lnfdi l.polconiii l.polity2 l.lnpop l.lngdppc l.gdpgr l.lntrade ///
l.ptacum2 l.ckaopen2010 l.lninflation l.savings l.lnworldpriv i.iso3n i.year ///
(l.strong_bits=l.maregionsbit_ni l.maworldsbits_ni), vce(robust)
estat endogenous 
/* Robust Durbin (score) chi2(1)          =  .224268  (p = 0.6348)
  Robust Wu-Hausman F(1,2323)            =  .210344  (p = 0.6454)*/
estat first /*    F = 46962.8 */
estat over  /* Score chi2(1) =  .945419  (p = 0.3309) */

***** Model 14 (Priv, gmm, strong bits)
ivregress gmm lnpriv l.lnpriv l.lnfdi l.polconiii l.polity2 l.lnpop l.lngdppc l.gdpgr l.lntrade ///
l.ptacum2 l.ckaopen2010 l.lninflation l.savings l.lnworldpriv i.iso3n i.year ///
(l.strong_bits=l.maregionsbit_ni l.maworldsbits_ni), vce(robust)
estat endogenous /* GMM C statistic chi2(1) =  .164553  (p = 0.6850) */
estat first /*    F = 46962.8 */
estat over  /* Score chi2(1) =  .945419  (p = 0.3309) */

******* Model 15 (Priv, 2sls, weak bits)
ivregress 2sls lnpriv l.lnpriv l.lnfdi l.polconiii l.polity2 l.lnpop l.lngdppc l.gdpgr l.lntrade ///
l.ptacum2 l.ckaopen2010 l.lninflation l.savings l.lnworldpriv i.year i.iso3n ///
(l.bitstodate_bit=l.maregionsbits_graham_ni l.maworldbits_graham_ni), vce(robust)
estat endogenous 
/* Robust score chi2(1)            =  .041697  (p = 0.8382)
  Robust regression F(1,2250)     =  .039022  (p = 0.8434) */
estat first /* F = 77358.5 */
estat over /*  Score chi2(1)          =  3.65661  (p = 0.0558) */

***** Model 16 (PRIV, gmm, weak bits) 
ivregress gmm lnpriv l.lnpriv l.lnfdi l.polconiii l.polity2 l.lnpop l.lngdppc l.gdpgr l.lntrade ///
l.ptacum2 l.ckaopen2010 l.lninflation l.savings l.lnworldpriv i.year i.iso3n ///
(l.bitstodate_bit=l.maregionsbits_graham_ni l.maworldbits_graham_ni), vce(robust)
estat endogenous /* GMM C statistic chi2(1) =   .10011  (p = 0.7804) */
estat first /*   F =  77358.5   */
estat overid /* Hansen's J chi2(1) =  3.6566 (p = 0.0558) */

**************************************
***** Descriptive Statistic **********
****** (Tables 6&7 - Appendix) *******
**************************************
sum lnfdi lnpriv strong_bits polconiii polity lnpop gdpgr lngdppc ///
lntrade ptacum2 ckaopen2010 lninflation savings worldsbits lnworldfdi lnworldpriv

corr lnfdi lnpriv strong_bits polconiii polity lnpop lngdppc gdpgr ///
lntrade ptacum2 ckaopen lninflation savings 


*****************************************
**** Table 8 (Appendix) *****************
*****************************************
***** Model 17 (RE, Regional dummies - FDI)
xtreg lnfdi l.lnfdi l.strong_bits l.strong_bits2 l.polconiii l.polity2 ///
l.lnpop l.lngdppc l.gdpgr l.lntrade l.ptacum2 l.ckaopen2010 l.lninflation ///
l.savings l.worldsbits_ni l.lnworldfdi_ni east_asia europe mena ///
south_asia ssa, re
***** Model 18 (Driscoll Kraay - FDI )
xtscc lnfdi llnfdi lsbits lsbits2 lpolconiii lpolity2 llnpop llngdppc lgdpgr llntrade ///
lptacum2 lckaopen2010 llninflation lsavings lworldsbits_ni llnworldfdi_ni, fe
***** Model 19 (Country and Year Fixed Effects - FDI )
xtreg lnfdi l.lnfdi l.strong_bits l.strong_bits2 l.polconiii l.polity2 l.lnpop l.lngdppc ///
l.gdpgr l.lntrade l.ptacum2 l.ckaopen2010 l.lninflation l.savings l.worldsbits_ni ///
l.lnworldfdi_ni i.year, fe cluster(iso3n)
***** Model 20 (RE, Regional dummies - Priv)
xtreg lnpriv l.lnpriv l.strong_bits l.strong_bits2 l.polconiii l.polity2 ///
l.lnpop l.lngdppc l.gdpgr l.lntrade l.ptacum2 l.ckaopen2010 l.lninflation ///
l.savings l.worldsbits_ni l.lnworldpriv_ni east_asia europe mena ///
south_asia ssa, re
***** Model 21 (Driscoll Kraay - Priv)
xtscc lnpriv llnpriv lsbits lsbits2 lpolconiii lpolity2 llnpop llngdppc lgdpgr llntrade ///
lptacum2 lckaopen2010 llninflation lsavings lworldsbits_ni llnworldpriv_ni, fe
***** Model 22 (Country and year fixed effects - priv)
xtreg lnpriv l.lnpriv l.strong_bits l.strong_bits2 l.polconiii l.polity2 ///
l.lnpop l.lngdppc l.gdpgr l.lntrade l.ptacum2 l.ckaopen2010 l.lninflation ///
l.savings l.worldsbits_ni l.lnworldpriv_ni i.year, fe cluster(iso3n)

*****************************
**** Table 9 (Appendix) *****
******************************
*** Model 23 (FE - FDI)
xtreg lnfdi l.lnfdi l.lnpriv l.strong_bits l.strong_bits2 l.polconiii l.polity2 ///
l.lnpop l.lngdppc l.gdpgr l.lntrade l.ptacum2 l.ckaopen2010 l.lninflation l.savings ///
l.worldsbits_ni l.lnworldfdi_ni, fe cluster(iso3n)
*** Model 24 (GLS - FDI)
xtgls lnfdi l.lnpriv l.strong_bits l.strong_bits2 l.polconiii l.polity2 ///
l.lnpop l.lngdppc l.gdpgr l.lntrade l.ptacum2 l.ckaopen2010 l.lninflation ///
l.savings l.worldsbits_ni l.lnworldfdi_ni i.iso3n, corr(psar1) force
*** Model 25 (FE - Priv)
xtreg lnpriv l.lnfdi l.lnpriv l.strong_bits l.strong_bits2 l.polconiii l.polity2 ///
l.lnpop l.lngdppc l.gdpgr l.lntrade l.ptacum2 l.ckaopen2010 l.lninflation l.savings ///
l.worldsbits_ni l.lnworldpriv_ni, fe cluster(iso3n)
*** Model 26 (GLS - Priv)
xtgls lnpriv l.lnfdi l.strong_bits l.strong_bits2 l.polconiii l.polity2 ///
l.lnpop l.lngdppc l.gdpgr l.lntrade l.ptacum2 l.ckaopen2010 l.lninflation ///
l.savings l.worldsbits_ni l.lnworldpriv_ni i.iso3n, corr(psar1) force



******************************
**** Table 10 (Appendix) *****
******************************
*** Model 27 (FDI, Checks, Dem)
xtreg lnfdi l.lnfdi l.lnpriv l.strong_bits l.strong_bits2 l.checks l.dem l.lnpop l.lngdppc l.gdpgr l.lntrade ///
l.ptacum2 l.ckaopen2010 l.lninflation l.savings l.worldsbits l.lnworldfdi, fe cluster(iso3n)
*** Model 28 (Priv, Check, Dem)
xtreg lnpriv l.lnpriv l.lnfdi l.strong_bits l.strong_bits2 l.checks l.dem l.lnpop l.lngdppc l.gdpgr l.lntrade ///
l.ptacum2 l.ckaopen2010 l.lninflation l.savings l.worldsbits l.lnworldpriv, fe cluster(iso3n)
*** Model 29 (Priv, exclude Argentina, Brazil, India)
xtreg lnpriv l.lnpriv l.strong_bits l.strong_bits2 l.polconiii l.polity2 l.lnpop l.lngdppc l.gdpgr l.lntrade ///
l.ptacum2 l.ckaopen2010 l.lninflation l.savings l.worldsbits l.lnworldpriv if iso3n!=76 & iso3n!=32 & iso3n!=356, fe cluster(iso3n)
*** Model 30 (FDI, Tertiary, Resource Rents)
xtreg lnfdi l.lnfdi l.strong_bits l.strong_bits2 l.polconiii l.polity2 l.lnpop l.lngdppc l.gdpgr l.lntrade ///
l.ptacum2 l.ckaopen2010 l.lntert l.natresource_rents_wb l.lninflation l.savings l.worldsbits l.lnworldfdi, fe cluster(iso3n)
*** Model 31 (Priv, Tertiary, Resource Rents) 
xtreg lnpriv l.lnpriv l.strong_bits l.strong_bits2 l.polconiii l.polity2 l.lnpop l.lngdppc l.gdpgr l.lntrade ///
l.ptacum2 l.ckaopen2010 l.lntert l.natresource_rents_wb l.lninflation l.savings l.worldsbits l.lnworldpriv, fe cluster(iso3n)

******************************
**** Table 11 (Appendix) *****
******************************
*** Model 32 (FDI, All Bits, RE with regional dummies)
xtreg lnfdi l.lnfdi l.lnpriv l.bitstodate_bit l.bits_graham_2 l.polconiii l.polity2 ///
l.lnpop l.lngdppc l.gdpgr l.lntrade l.ptacum2 l.ckaopen2010 l.lninflation l.savings ///
l.world_bits_graham_ni l.lnworldfdi_ni east_asia europe mena ///
south_asia ssa, re
*** Model 33 (FDI, All BITs, Driscoll Kraay)
xtscc lnfdi llnfdi llnpriv lbitstodate_bit lbits_graham_2 lpolconiii lpolity2 ///
llnpop llngdppc lgdpgr llntrade lptacum2 lckaopen2010 llninflation lsavings ///
lworld_bits_graham_ni llnworldfdi_ni, fe
*** Model 34 (Priv, All BITs, RE with regional dummies)
xtreg lnpriv l.lnfdi l.lnpriv l.bitstodate_bit l.bits_graham_2 l.polconiii l.polity2 ///
l.lnpop l.lngdppc l.gdpgr l.lntrade l.ptacum2 l.ckaopen2010 l.lninflation l.savings ///
l.world_bits_graham_ni l.lnworldpriv_ni east_asia europe mena ///
south_asia ssa, re
*** Model 35 (Priv, All BITs, Driscoll Kraay)
xtscc lnpriv llnfdi llnpriv lbitstodate_bit lbits_graham_2 lpolconiii lpolity2 ///
llnpop llngdppc lgdpgr llntrade lptacum2 lckaopen2010 llninflation lsavings ///
lworld_bits_graham_ni llnworldpriv_ni, fe
*** Model 36 (FDI, Weak BITs, RE with regional dummies) 
xtreg lnfdi l.lnfdi l.lnpriv l.weakbits l.weakbits2 l.polconiii l.polity2 ///
l.lnpop l.lngdppc l.gdpgr l.lntrade l.ptacum2 l.ckaopen2010 l.lninflation l.savings ///
l.world_weakbits_ni l.lnworldfdi_ni east_asia europe mena ///
south_asia ssa, re
*** Model 37 (FDI, Weak BITs, Driscoll Kraay)
xtscc lnfdi llnfdi llnpriv lweakbits lweakbits2 lpolconiii lpolity2 ///
llnpop llngdppc lgdpgr llntrade lptacum2 lckaopen2010 llninflation lsavings ///
lworld_weakbits_ni llnworldfdi_ni, fe
*** Model 38 (PRIV, Weak BITS, Re with regional dummies)
xtreg lnpriv l.lnfdi l.lnpriv l.weakbits l.weakbits2 l.polconiii l.polity2 ///
l.lnpop l.lngdppc l.gdpgr l.lntrade l.ptacum2 l.ckaopen2010 l.lninflation l.savings ///
l.world_weakbits_ni l.lnworldpriv_ni east_asia europe mena ///
south_asia ssa, re
*** Model 39 (Priv, Weak BITs, Driscoll Kraay)
xtscc lnpriv llnfdi llnpriv lweakbits lweakbits2 lpolconiii lpolity2 ///
llnpop llngdppc lgdpgr llntrade lptacum2 lckaopen2010 llninflation lsavings ///
lworld_weakbits_ni llnworldpriv_ni, fe


********* Determining Substantive Effects *******
/* BIT effect on infrastructure flows. Need to exponentiation coefficients from the 
respective models and then multiply by std deviation to report substantive effect of
a one standard deviation increase in independent variable:
1. Model 3 - BIT .1448, BIT^2 -0.0099: exp(.1148)= 1.121649 or about 12%; exp(-0.0099)=.9901488 or about -1%.
An average country has 3.5 BITs, which means Model 3 predicts it has 3.5*12.165-(1*3.5) = 39.007% increase in
infrastructre investment.
A country one std deviation above the mean has 7.8 BITs (or 4.3 more BITs than the average country), which means
Model 3 predicts it has 4.3*12.165-(1*4.3)= 48% more infrastructure investment than a country with average number
of BITs
2. Model 4 - BIT .2708, BIT^2 -.0154: exp (.2708)= 1.311 or 31.1%; exp(-.0154)= .985 or about -1.5%
An average country has 3.5 BITs, which means Model 4 predicts it has 3.5*31.1-(1.5*3.5)=103.6% increase in
infrastructure investment.
A country one std deviation above the mean has 4.3 more BITs than the average country, which means Model 4
predicts it has 4.3*31.1-(1.5*4.3)=127.3% increase in infrastructure investment. */

/* POLCON effect: 
Model 3: exp(.5341)=1.70 or  70%, std is .2102 so 70*.2101=14.7 or 15% (effect of a 1 std dev increase in POLCON)
Model 4: exp(.6149)=1.85 or  85% std is .2102 os 85*.2102= 17.867 or 18% (effec of a 1 std dev increase in POLCON on PRIV)
*/

/* ALL BIT Effect:
Model 7: exp(.0575)=1.059 or 5.9%, std is 12.93 (can find this by command sum bitstodate_bit).
BIT^2: exp(-0.0007)=0.9993002 or -0.1%.
A country one std dev above the mean is predicted to increase infrastructure investment (5.9*12.93)-(-.1*12.93)=75%
GLS Model (this model was not reported in the appendix, but can be check with the following code:
xtgls lnpriv l.lnpriv l.bitstodate_bit l.bits_graham_2 l.polconiii ///
l.polity2 l.lnpop l.lngdppc l.gdpgr l.lntrade l.ptacum2 l.ckaopen2010 l.lninflation ///
l.savings l.world_bits_graham_ni l.lnworldpriv_ni, corr(psar1) force)

exp(.0291) = 1.0295 or 3% and BIT^2: exp(-0.0004)=.9996 or 0
A country one std dev above the mean is predicted to increase infrastructure investment 3*12.93 or 38.79%

To figure out the effect between the average country (10 BITS) and a country with no BITs, do the same thing 
substituting 10 for 12.93:
(5.9*10)-(-.1*10)=58%
(3*10)= 30%

