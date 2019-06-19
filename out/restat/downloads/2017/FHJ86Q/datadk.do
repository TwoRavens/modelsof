clear
use datadk.dta, clear

*************************************
*************************************
   *TABLE 1 *Descriptive statistics*
*************************************
*************************************
 
summarize growthpc proxpc findev conc3 conc5 school M2 govc credrights corrup landlocked

*************************************
*************************************
   *TABLE 2 *Correlations Matrix*
*************************************
*************************************

pwcorr growthpc proxpc findev conc3 conc5 school M2 govc credrights corrup landlocked, sig

*************************************************************************************
*************************************************************************************
       *TABLE 3 *Results with OLS and IV-GMM (Lewbel, 2012)*
*************************************************************************************
*************************************************************************************

regress growthpc proxpc findev conc3 interpcconc3 interpcfindev, robust

regress growthpc proxpc findev conc3 interpcconc3 interpcfindev meancost_3, robust

ssc install ivreg2h

ivreg2h growthpc proxpc (findev conc3 interpcconc3 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s

ivreg2h growthpc proxpc meancost_3 (findev conc3 interpcconc3 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s

regress growthpc proxpc findev conc5 interpcconc5 interpcfindev, robust

regress growthpc proxpc findev conc5 interpcconc5 interpcfindev meancost_3, robust

ivreg2h growthpc proxpc (findev conc5 interpcconc5 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s

ivreg2h growthpc proxpc meancost_3 (findev conc5 interpcconc5 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s

*******************************************************************************************
*******************************************************************************************
       *TABLE 4 *Results with IV-GMM (Lewbel, 2012) using school and geography as controls*
*******************************************************************************************
*******************************************************************************************

ivreg2h growthpc proxpc school interpchk (findev conc3 interpcconc3 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s

ivreg2h growthpc proxpc meancost_3 school interpchk (findev conc3 interpcconc3 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s

ivreg2h growthpc proxpc school interpchk (findev conc5 interpcconc5 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s

ivreg2h growthpc proxpc meancost_3 school interpchk (findev conc5 interpcconc5 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s

ivreg2h growthpc proxpc interpcland  (findev conc3 interpcconc3 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s

ivreg2h growthpc proxpc meancost_3 interpcland (findev conc3 interpcconc3 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s

ivreg2h growthpc proxpc interpcland (findev conc5 interpcconc5 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
catho80 muslim80 protmg80 proxcatholic proxmuslim proxprotest), small robust gmm2s

ivreg2h growthpc proxpc meancost_3 landlocked interpcland (findev conc5 interpcconc5 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s


***************************************************************************************************
***************************************************************************************************
 *TABLE 5 *Results using IV-GMM (Lewbel, 2012) and controlling for creditor right and corruption*
***************************************************************************************************
***************************************************************************************************

ivreg2h growthpc proxpc credrights interpccredrights (findev conc3 interpcconc3 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s

ivreg2h growthpc proxpc meancost_3 credrights interpccredrights (findev conc3 interpcconc3 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s

ivreg2h growthpc proxpc credrights interpccredrights  (findev conc5 interpcconc5 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s

ivreg2h growthpc proxpc meancost_3 credrights interpccredrights (findev conc5 interpcconc5 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s

ivreg2h growthpc proxpc corrup interpccorrup (findev conc3 interpcconc3 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s

ivreg2h growthpc proxpc meancost_3 corrup interpccorrup (findev conc3 interpcconc3 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s

ivreg2h growthpc proxpc corrup interpccorrup (findev conc5 interpcconc5 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s

ivreg2h growthpc proxpc meancost_3 corrup interpccorrup (findev conc5 interpcconc5 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s

***************************************************************************************************
***************************************************************************************************
 *TABLE 6 *Results using IV-GMM (Lewbel, 2012) and controlling for government consump. and M2*
***************************************************************************************************
***************************************************************************************************

ivreg2h growthpc proxpc govc interpcgovc (findev conc3 interpcconc3 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s

ivreg2h growthpc proxpc meancost_3 govc interpcgovc (findev conc3 interpcconc3 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s

ivreg2h growthpc proxpc govc interpcgovc (findev conc5 interpcconc5 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s

ivreg2h growthpc proxpc meancost_3 govc interpcgovc  (findev conc5 interpcconc5 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s

ivreg2h growthpc proxpc  M2 interpcM2 (findev conc3 interpcconc3 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s

ivreg2h growthpc proxpc meancost_3 M2 interpcM2 (findev conc3 interpcconc3 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s

ivreg2h growthpc proxpc  M2 interpcM2 (findev conc5 interpcconc5 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s

ivreg2h growthpc proxpc meancost_3 M2 interpcM2 (findev conc5 interpcconc5 interpcfindev = legor_uk legor_fr legor_ge proxlegoruk proxlegorfr proxlegorge ///
cathos muslims protmgs proxcatholic proxmuslim proxprotest), small robust gmm2s
