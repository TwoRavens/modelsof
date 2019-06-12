***************************************************
*                                                 *
* Civilian Defence Forces:                        *
*                                                 *
* The Logic of Violence in Irregular War          *                                                                                                                  *
*                                                 *
* Govinda Clayton and Andrew Thomson              *
*                                                 *
* This Version: June 30, 2015                     *
*                                                 *
* Address Correspondence to: g.clayton@kent.ac.uk *
*                                                 *
***************************************************



*Table II

use "/Users/Gov_Clayton/Dropbox/Research/Papers in Progress/ISQ resubmission/Resubmission Final/Resubmission_V2/Replication Data/ISQ_Replication_Country_Year_Data.dta"* Government Violence Table

nbreg new_gov_best Mil_SD1 lagnew_polity new_laggdp new_lnlagtpop lmtnest exclpop new_laggov_bestdum if rwanda94==0,  cl(id)
eststo gv1
nbreg new_gov_best Mil_SD1  lagnew_polity new_laggdp new_lnlagtpop lmtnest  Incomp informal_pgm semioffic_pgm maxage lnratio lntotbdeaths lnreb pko exclpop new_laggov_bestdum if rwanda94==0,  cl(id)
eststo gv2
esttab gv1 gv2 , varlabels(_cons Constant) stats(r2_a N, fmt(%9.4f %9.0g) labels("Adj. R2" "No. of Obs"))  title("Conflict Deaths") label se


*Table III

use "/Users/Gov_Clayton/Dropbox/Research/Papers in Progress/ISQ resubmission/Resubmission Final/Resubmission_V2/Replication Data/ISQ_Replication_Dyad_Year_Data.dta"* Rebel Violence Tabls

nbreg rebbest2010 Mil_SD1 lagpolityalt laggdpper lnlagtpop lmtnest exclpop lagrebdum2010, cl(dyad)
eststo rv1
nbreg rebbest2010 Mil_SD1 lagpolityalt laggdpper lnlagtpop lmtnest exclpop informal_pgm semioffic_pgm incomp age lnratio_scale lnbdbest lngov pko lagrebdum2010, cl(dyad)
eststo rv2 

esttab rv1 rv2, varlabels(_cons Constant) stats(r2_a N, fmt(%9.4f %9.0g) labels("Adj. R2" "No. of Obs"))  title("Conflict Deaths") label se


*Table IV

use "/Users/Gov_Clayton/Dropbox/Research/Papers in Progress/ISQ resubmission/Resubmission Final/Resubmission_V2/Replication Data/ISQ_Replication_Country_Year_Data.dta"
* Battledeaths Table

nbreg bdbest Mil_SD1 lagnew_polity new_laggdp new_lnlagtpop lmtnest exclpop,  cl(id)
eststo bd1
nbreg bdbest Mil_SD1 lagnew_polity new_laggdp new_lnlagtpop lmtnest exclpop informal_pgm semioffic_pgm Incomp maxage lnratio pko ,  cl(id)
eststo bd2
esttab bd1 bd2, varlabels(_cons Constant) stats(r2_a N, fmt(%9.4f %9.0g) labels("Adj. R2" "No. of Obs"))  title("Conflict Deaths") label se


 

* Predicted Probabilities discussed in the results section

*Government Violence 
use "/Users/Gov_Clayton/Dropbox/Research/Papers in Progress/ISQ resubmission/Resubmission Final/Resubmission_V2/Replication Data/ISQ_Replication_Country_Year_Data.dta"

estsimp nbreg new_gov_best Mil_SD1 informal_pgm semioffic_pgm lagnew_polity new_laggdp new_lnlagtpop lmtnest  Incomp maxage lnratio lntotbdeaths lnreb pko exclpop new_laggov_bestdum if rwanda94==0,  cl(id)
setx Mil_SD1 0 lagnew_polity mean new_laggdp mean new_lnlagtpop mean  lmtnest mean maxage mean lnratio mean lntotbdeaths mean lnreb mean pko 0 exclpop mean  new_laggov_bestdum 0 informal_pgm 0 semioffic_pgm 1
simqi
setx Mil_SD1 1 lagnew_polity mean new_laggdp mean new_lnlagtpop mean  lmtnest mean maxage mean lnratio mean lntotbdeaths mean lnreb mean pko 0 exclpop mean  new_laggov_bestdum 0 informal_pgm 0 semioffic_pgm 1
simqi
drop b1-b17


* Rebel Violence
use "/Users/Gov_Clayton/Dropbox/Research/Papers in Progress/ISQ resubmission/Resubmission Final/Resubmission_V2/Replication Data/ISQ_Replication_Dyad_Year_Data.dta"

estsimp nbreg rebbest2010 Mil_SD1 lagpolityalt laggdpper lnlagtpop lmtnest exclpop informal_pgm semioffic_pgm incomp age lnratio_scale lnbdbest lngov pko lagrebdum2010, cl(dyad)
setx Mil_SD1 0 lagpolityalt mean laggdpper mean lnlagtpop mean lmtnest mean exclpop mean incomp 2 age mean lnratio_scale mean lnbdbest mean lngov mean pko 0 lagrebdum2010 1 informal_pgm 1 semioffic_pgm 1
simqi
setx Mil_SD1 1 lagpolityalt mean laggdpper mean lnlagtpop mean lmtnest mean exclpop mean incomp 2 age mean lnratio_scale mean lnbdbest mean lngov mean pko 0 lagrebdum2010 1 informal_pgm 1  semioffic_pgm 1
simqi 


*Battledeaths
use "/Users/Gov_Clayton/Dropbox/Research/Papers in Progress/ISQ resubmission/Resubmission Final/Resubmission_V2/Replication Data/ISQ_Replication_Country_Year_Data.dta", clear

estsimp nbreg bdbest Mil_SD1 lagnew_polity new_laggdp new_lnlagtpop lmtnest  informal_pgm semioffic_pgm Incomp maxage lnratio exclpop pko ,  cl(id)
setx Mil_SD1 0 lagnew_polity mean new_laggdp mean new_lnlagtpop mean  lmtnest mean  Incomp 2 maxage mean lnratio mean  pko 0 exclpop mean informal_pgm 0 semioffic_pgm 1
simqi
setx Mil_SD1 1 lagnew_polity mean new_laggdp mean new_lnlagtpop mean  lmtnest mean Incomp 2 maxage mean lnratio mean  pko 0 exclpop mean informal_pgm 0 semioffic_pgm 1
simqi
drop b1-b14


********************Robustness Checks************************


******* Including Other Controls ********

use "/Users/Gov_Clayton/Dropbox/Research/Papers in Progress/ISQ resubmission/Resubmission Final/Resubmission_V2/Replication Data/ISQ_Replication_Country_Year_Data.dta", clear

*Government Violence

nbreg new_gov_best Mil_SD1 lagnew_polity new_laggdp new_lnlagtpop lmtnest  Incomp informal_pgm semioffic_pgm maxage lnratio lntotbdeaths lnreb pko exclpop new_laggov_bestdum multreb dist2demo dem_aidc_depen lntotarea ethfrac oil_prod32_09 if rwanda94==0,  cl(id)

*Conflict Intensity 

nbreg bdbest Mil_SD1 lagnew_polity new_laggdp new_lnlagtpop lmtnest Incomp informal_pgm semioffic_pgm  maxage lnratio  pko exclpop multreb dist2demo dem_aidc_depen lntotarea ethfrac oil_prod32_09 ,  cl(id)

* Rebel Violence

use "/Users/Gov_Clayton/Dropbox/Research/Papers in Progress/ISQ resubmission/Resubmission Final/Data_and_Do/Dyad_Year_Data.dta", clear

nbreg rebbest2010 Mil_SD1 lagpolityalt laggdpper lnlagtpop lmtnest exclpop informal_pgm semioffic_pgm incomp age lnratio_scale lnbdbest lngov pko lagrebdum2010 dem_aidc_depen oil_prod32_09 ethfrac lnarea multreb dist2demo, cl(dyad)


*******Temporal Checks********

use "/Users/Gov_Clayton/Dropbox/Research/Papers in Progress/ISQ resubmission/Resubmission Final/Resubmission_V2/Replication Data/ISQ_Replication_Country_Year_Data.dta"

***Government Violence

*(i) Violence in the Previous Year

nbreg new_gov_best Mil_SD1 lagnew_polity new_laggdp new_lnlagtpop lmtnest  Incomp informal_pgm semioffic_pgm maxage lnratio lntotbdeaths lnreb pko exclpop lag2d if rwanda94==0

nbreg new_gov_best Mil_SD1 lagnew_polity new_laggdp new_lnlagtpop lmtnest  Incomp informal_pgm semioffic_pgm maxage lnratio lntotbdeaths lnreb pko exclpop lag3d if rwanda94==0

nbreg new_gov_best Mil_SD1 lagnew_polity new_laggdp new_lnlagtpop lmtnest  Incomp informal_pgm semioffic_pgm maxage lnratio lntotbdeaths lnreb pko exclpop lag5d if rwanda94==0


*(ii) Number of deaths

nbreg new_gov_best Mil_SD1  lagnew_polity new_laggdp new_lnlagtpop lmtnest  Incomp informal_pgm semioffic_pgm maxage lnratio lntotbdeaths lnreb pko exclpop new_laggov_best if rwanda94==0

nbreg new_gov_best Mil_SD1  lagnew_polity new_laggdp new_lnlagtpop lmtnest  Incomp informal_pgm semioffic_pgm maxage lnratio lntotbdeaths lnreb pko exclpop lag2 if rwanda94==0

nbreg new_gov_best Mil_SD1  lagnew_polity new_laggdp new_lnlagtpop lmtnest  Incomp informal_pgm semioffic_pgm maxage lnratio lntotbdeaths lnreb pko exclpop lag3 if rwanda94==0

nbreg new_gov_best Mil_SD1  lagnew_polity new_laggdp new_lnlagtpop lmtnest  Incomp informal_pgm semioffic_pgm maxage lnratio lntotbdeaths lnreb pko exclpop lag5 if rwanda94==0


*(iii) Inclusion of year variable 

nbreg new_gov_best Mil_SD1  lagnew_polity new_laggdp new_lnlagtpop lmtnest  Incomp informal_pgm semioffic_pgm maxage lnratio lntotbdeaths lnreb pko exclpop year if rwanda94==0,  cl(id)


*(iv) Year Fixed Effects

xtnbreg new_gov_best Mil_SD1  lagnew_polity new_laggdp new_lnlagtpop lmtnest  Incomp informal_pgm semioffic_pgm maxage lnratio lntotbdeaths lnreb pko exclpop new_laggov_bestdum if rwanda94==0,  fe


*(v) Count of years since last fatality (and square and cubic terms)

nbreg new_gov_best Mil_SD1  lagnew_polity new_laggdp new_lnlagtpop lmtnest  Incomp informal_pgm semioffic_pgm maxage lnratio lntotbdeaths lnreb pko exclpop gvvioPY gvvioPY2 gvvioPY3 if rwanda94==0,  cl(id) 

*(vi) No temporal control

nbreg new_gov_best Mil_SD1  lagnew_polity new_laggdp new_lnlagtpop lmtnest  Incomp informal_pgm semioffic_pgm maxage lnratio lntotbdeaths lnreb pko exclpop  if rwanda94==0,cl(id)



***Rebel Violence

use "/Users/Gov_Clayton/Dropbox/Research/Papers in Progress/ISQ resubmission/Resubmission Final/Resubmission_V2/Replication Data/ISQ_Replication_Dyad_Year_Data.dta", clear

*(i) Violence in the Previous Year

nbreg rebbest2010 Mil_SD1  lagpolityalt laggdpper lnlagtpop lmtnest exclpop  incomp informal_pgm semioffic_pgm age lnratio_scale lnbdbest lngov pko lagrebdum2010, cl(dyad)

nbreg rebbest2010 Mil_SD1  lagpolityalt laggdpper lnlagtpop lmtnest exclpop  incomp informal_pgm semioffic_pgm age lnratio_scale lnbdbest lngov pko rlag2d, cl(dyad)

nbreg rebbest2010 Mil_SD1  lagpolityalt laggdpper lnlagtpop lmtnest exclpop  incomp informal_pgm semioffic_pgm age lnratio_scale lnbdbest lngov pko rlag3d, cl(dyad)

nbreg rebbest2010 Mil_SD1  lagpolityalt laggdpper lnlagtpop lmtnest exclpop  incomp informal_pgm semioffic_pgm age lnratio_scale lnbdbest lngov pko rlag5d, cl(dyad)


*(ii) Number of deaths

nbreg rebbest2010 Mil_SD1  lagpolityalt laggdpper lnlagtpop lmtnest exclpop  incomp informal_pgm semioffic_pgm age lnratio_scale lnbdbest lngov pko lagreb2010, cl(dyad)

nbreg rebbest2010 Mil_SD1  lagpolityalt laggdpper lnlagtpop lmtnest exclpop  incomp informal_pgm semioffic_pgm age lnratio_scale lnbdbest lngov pko rlag2, cl(dyad)

nbreg rebbest2010 Mil_SD1  lagpolityalt laggdpper lnlagtpop lmtnest exclpop  incomp informal_pgm semioffic_pgm age lnratio_scale lnbdbest lngov pko rlag3, cl(dyad)

nbreg rebbest2010 Mil_SD1  lagpolityalt laggdpper lnlagtpop lmtnest exclpop  incomp informal_pgm semioffic_pgm age lnratio_scale lnbdbest lngov pko rlag4, cl(dyad)

nbreg rebbest2010 Mil_SD1  lagpolityalt laggdpper lnlagtpop lmtnest exclpop  incomp informal_pgm semioffic_pgm age lnratio_scale lnbdbest lngov pko rlag5, cl(dyad)


*(iii) Inclusion of year variable 

nbreg rebbest2010 Mil_SD1  lagpolityalt laggdpper lnlagtpop lmtnest exclpop  incomp informal_pgm semioffic_pgm age lnratio_scale lnbdbest lngov pko year, cl(dyad)

*(iv) Year Fixed Effects

xtset year

xtnbreg rebbest2010 Mil_SD1  lagpolityalt laggdpper lnlagtpop lmtnest exclpop  incomp informal_pgm semioffic_pgm age lnratio_scale lnbdbest lngov pko lagrebdum2010, fe

*(v) Count of years since last fatality (and square and cubic terms)

nbreg rebbest2010 Mil_SD1  lagpolityalt laggdpper lnlagtpop lmtnest exclpop  incomp informal_pgm semioffic_pgm age lnratio_scale lnbdbest lngov pko rvvioPY rvvioPY2 rvvioPY3, cl(dyad)

*(vi) No temporal control

nbreg rebbest2010 Mil_SD1  lagpolityalt laggdpper lnlagtpop lmtnest exclpop  incomp informal_pgm semioffic_pgm age lnratio_scale lnbdbest lngov pko, cl(dyad)




***Conflict Intensity

use "/Users/Gov_Clayton/Dropbox/Research/Papers in Progress/ISQ resubmission/Resubmission Final/Data_and_Do/Country_Year_Data.dta", clear


*(i) Violence in the Previous Year

nbreg bdbest Mil_SD1 informal_pgm semioffic_pgm lagnew_polity new_laggdp new_lnlagtpop lmtnest Incomp maxage lnratio  pko exclpop ilag1,  cl(id)

nbreg bdbest Mil_SD1 informal_pgm semioffic_pgm lagnew_polity new_laggdp new_lnlagtpop lmtnest Incomp maxage lnratio  pko exclpop ilag2,  cl(id)

nbreg bdbest Mil_SD1 informal_pgm semioffic_pgm lagnew_polity new_laggdp new_lnlagtpop lmtnest Incomp maxage lnratio  pko exclpop ilag3,  cl(id)

nbreg bdbest Mil_SD1 informal_pgm semioffic_pgm lagnew_polity new_laggdp new_lnlagtpop lmtnest Incomp maxage lnratio  pko exclpop ilag5,  cl(id)


*(ii) Number of deaths

nbreg bdbest Mil_SD1 informal_pgm semioffic_pgm lagnew_polity new_laggdp new_lnlagtpop lmtnest Incomp maxage lnratio  pko exclpop lag2,  cl(id)

nbreg bdbest Mil_SD1 informal_pgm semioffic_pgm lagnew_polity new_laggdp new_lnlagtpop lmtnest Incomp maxage lnratio  pko exclpop lag3,  cl(id)

nbreg bdbest Mil_SD1 informal_pgm semioffic_pgm lagnew_polity new_laggdp new_lnlagtpop lmtnest Incomp maxage lnratio  pko exclpop lag5,  cl(id)



*(iii) Inclusion of year variable 

nbreg bdbest Mil_SD1 informal_pgm semioffic_pgm lagnew_polity new_laggdp new_lnlagtpop lmtnest Incomp maxage lnratio  pko exclpop year,  cl(id)


*(iv) Year Fixed Effects

xtset year

xtnbreg bdbest Mil_SD1 lagnew_polity new_laggdp new_lnlagtpop lmtnest exclpop informal_pgm semioffic_pgm Incomp maxage lnratio pko , fe


*(v) Count of years since last reached fatality threshold (and splines)

nbreg bdbest Mil_SD1  lagnew_polity new_laggdp new_lnlagtpop lmtnest Incomp informal_pgm semioffic_pgm maxage lnratio  pko exclpop peaceyrs _spline1 _spline2 _spline3 ,  cl(id)



*******Remove most deadly conflict years********

* Government Violence 
use "/Users/Gov_Clayton/Dropbox/Research/Papers in Progress/ISQ resubmission/Resubmission Final/Resubmission_V2/Replication Data/ISQ_Replication_Country_Year_Data.dta"
drop if ccode ==625 & year ==2004
drop if ccode ==490 & year ==1997
drop if ccode ==517 & year ==1994
drop if ccode ==517 & year ==1997
drop if ccode ==700 & year ==1998
nbreg new_gov_best Mil_SD1   lagnew_polity new_laggdp new_lnlagtpop lmtnest  Incomp informal_pgm semioffic_pgm maxage lnratio lntotbdeaths lnreb pko exclpop new_laggov_bestdum if rwanda94==0,  cl(id)

*Rebel Violence
use "/Users/Gov_Clayton/Dropbox/Research/Papers in Progress/ISQ resubmission/Resubmission Final/Data_and_Do/Dyad_Year_Data.dta", clear
drop if ccode ==490 & year ==1996
drop if ccode ==490 & year ==1997
drop if ccode ==346 & year ==1992
drop if ccode ==346 & year ==1995
drop if ccode ==490 & year ==1998
nbreg rebbest2010 Mil_SD1 lagpolityalt laggdpper lnlagtpop lmtnest exclpop informal_pgm semioffic_pgm incomp age lnratio_scale lnbdbest lngov pko lagrebdum2010, cl(dyad)


*Conflict Intensity
use "/Users/Gov_Clayton/Dropbox/Research/Papers in Progress/ISQ resubmission/Resubmission Final/Resubmission_V2/Replication Data/ISQ_Replication_Country_Year_Data.dta"
drop if ccode ==484 & year ==1997
drop if ccode ==540 & year ==1993
drop if ccode ==530 & year ==1989
drop if ccode ==530 & year ==1990
nbreg bdbest Mil_SD1 lagnew_polity new_laggdp new_lnlagtpop lmtnest exclpop informal_pgm semioffic_pgm Incomp maxage lnratio pko ,  cl(id)


*****Unit Of Analysis - Conflict Year

*****Government Violence

* Did one-sided government violence happen in a conflict - Mean_CDF
use "/Users/Gov_Clayton/Dropbox/Research/Papers in Progress/ISQ resubmission/Resubmission Final/Resubmission_V2/Replication Data/ISQ_Replication_Country_Year_Data.dta", clear
collapse (sum) new_gov_best lntotbdeaths (mean) Mil_SD1 informal_pgm semioffic_pgm  lagnew_polity new_laggdp new_lnlagtpop lmtnest  Incomp lnratio lnreb pko exclpop (max) maxage, by (id)
gen govvio =  new_gov_best
recode govvio 1/999999=1
logit govvio Mil_SD1 lagnew_polity new_laggdp new_lnlagtpop lmtnest informal_pgm semioffic_pgm Incomp maxage lnratio lntotbdeaths lnreb pko exclpop,  cl(id)


* Did one-sided government violence happen in a conflict - CDF in every year
use "/Users/Gov_Clayton/Dropbox/Research/Papers in Progress/ISQ resubmission/Resubmission Final/Resubmission_V2/Replication Data/ISQ_Replication_Country_Year_Data.dta", clear
collapse (sum) new_gov_best lntotbdeaths (mean) Mil_SD1 informal_pgm semioffic_pgm   lagnew_polity new_laggdp new_lnlagtpop lmtnest  Incomp lnratio lnreb pko exclpop (max) maxage, by (id)
gen govvio =  new_gov_best
recode govvio 1/999999=1
recode Mil_SD1 0.01/0.999 = 0
recode informal_pgm 0.01/0.999 = 0
recode semioffic_pgm 0.01/0.999 = 0
logit govvio Mil_SD1 lagnew_polity new_laggdp new_lnlagtpop lmtnest informal_pgm semioffic_pgm Incomp maxage lnratio lntotbdeaths lnreb pko exclpop,  cl(id)


* Did one-sided government violence happen in a conflict - CDF in conflict
use "/Users/Gov_Clayton/Dropbox/Research/Papers in Progress/ISQ resubmission/Resubmission Final/Resubmission_V2/Replication Data/ISQ_Replication_Country_Year_Data.dta", clear
collapse (sum) new_gov_best lntotbdeaths (mean) Mil_SD1 informal_pgm semioffic_pgm  lagnew_polity new_laggdp new_lnlagtpop lmtnest  Incomp lnratio lnreb pko exclpop (max) maxage, by (id)
gen govvio =  new_gov_best
recode govvio 1/999999=1
recode Mil_SD1 0.01/0.999 = 1
recode informal_pgm 0.01/0.999 = 1
recode semioffic_pgm 0.01/0.999 = 1
logit govvio Mil_SD1 lagnew_polity new_laggdp new_lnlagtpop lmtnest informal_pgm semioffic_pgm Incomp maxage lnratio lntotbdeaths lnreb pko exclpop,  cl(id)


*Rebel Violence 

*Did one-sided rebel violence happen in a conflict - Mean CDF
use "/Users/Gov_Clayton/Dropbox/Research/Papers in Progress/ISQ resubmission/Resubmission Final/Resubmission_V2/Replication Data/ISQ_Replication_Dyad_Year_Data.dta"
collapse (sum) rebbest2010 lnbdbest (mean)  Mil_SD1 informal_pgm semioffic_pgm lagpolityalt laggdpper lnlagtpop lmtnest exclpop Mil_Oth1 incomp lnratio_scale lngov pko (max)age ccode, by (dyadid)
gen rebvio =  rebbest2010
recode rebvio 1/999999=1
logit rebvio Mil_SD1 lagpolityalt laggdpper lnlagtpop lmtnest exclpop informal_pgm semioffic_pgm incomp age lnratio_scale lnbdbest lngov pko, cluster(ccode)


*Did one-sided rebel violence happen in a conflict _SD1 in all years.
use "/Users/Gov_Clayton/Dropbox/Research/Papers in Progress/ISQ resubmission/Resubmission Final/Resubmission_V2/Replication Data/ISQ_Replication_Dyad_Year_Data.dta", clear
collapse (sum) rebbest2010 lnbdbest (mean)  Mil_SD1 informal_pgm semioffic_pgm lagpolityalt laggdpper lnlagtpop lmtnest exclpop  incomp lnratio_scale lngov pko (max)age ccode, by (dyadid)
drop if  Mil_SD1 > 0.01 & Mil_SD1 <0.999
gen rebvio =  rebbest2010
recode rebvio 1/999999=1
logit rebvio Mil_SD1 lagpolityalt laggdpper lnlagtpop lmtnest exclpop informal_pgm semioffic_pgm incomp age lnratio_scale lnbdbest lngov pko, cluster(ccode)

*Did one-sided rebel violence happen in a conflict CDF in conflict . 
use "/Users/Gov_Clayton/Dropbox/Research/Papers in Progress/ISQ resubmission/Resubmission Final/Resubmission_V2/Replication Data/ISQ_Replication_Dyad_Year_Data.dta", clear
collapse (sum) rebbest2010 lnbdbest (mean)  Mil_SD1 lagpolityalt laggdpper lnlagtpop lmtnest exclpop informal_pgm semioffic_pgm incomp lnratio_scale lngov pko (max)age ccode, by (dyadid)
gen rebvio =  rebbest2010
recode rebvio 1/999999=1
recode Mil_SD1 0.01/0.999 = 1
recode informal_pgm 0.01/0.999 =1
recode semioffic_pgm 0.01/0.999 =1
logit rebvio Mil_SD1 lagpolityalt laggdpper lnlagtpop lmtnest exclpop informal_pgm semioffic_pgm incomp age lnratio_scale lnbdbest lngov pko, cluster(ccode)


****MATCHING**************


*THIS IS RUN IN R

# Matching Data in R 

#Government Violence and Conflict Intensity 
library(foreign) 
# loads the 'foreign' library which reads other-format data. if you don't have it installed, the command install.packages() will open up some dialogue boxes to get it
matchdataV2 = read.dta("~/Desktop/Gov_Matching_Preprocessed.dta") 
# read.dta() reads in the data for you; the rest of the path (enclosed in " ") will depend on where the data live on your computer

# check it worked:
dim(matchdataV2) # tell me the dimensions
names(matchdataV2) # tell me the column names
summary(matchdataV2$year) # summarise the variable 'year' --- etc

#Nearest Neighbour full model
neart_V2<- matchit(Mil_SD1 ~ informal_pgm + semioffic_pgm + lagnew_polityalt + new_laggdp + new_lnlagtpop + lmtnest + Incomp + maxage+ lnratio + lntotbdeaths + lnreb + pko+ exclpop +new_laggov_bestdum , data = matchdataV2,      method = "nearest" )
summary(neart_V2, standardize = TRUE)
nnt_V3 <- match.data(neart_V2)
write.dta(nnt_V3, file = "Gov_Matched_Postprocessing.dta")


*Back in STATA
use "/Users/Gov_Clayton/Desktop/Gov_Matched_Postprocessing.dta", clear
nbreg new_gov_best Mil_SD1  lagnew_polity new_laggdp new_lnlagtpop lmtnest  Incomp maxage lnratio lntotbdeaths lnreb pko exclpop new_laggov_bestdum if rwanda94==0,  cl(id)
nbreg bdbest Mil_SD1 lagnew_polity new_laggdp new_lnlagtpop lmtnest exclpop  Incomp maxage lnratio pko ,  cl(id)


# Rebel Matching 

library(foreign) 
# loads the 'foreign' library which reads other-format data. if you don't have it installed, the command install.packages() will open up some dialogue boxes to get it
match_reb_data = read.dta("~/Desktop/Reb_Matched_Preprocessing.dta") 
# read.dta() reads in the data for you; the rest of the path (enclosed in " ") will depend on where the data live on your computer

# check it worked:
dim(match_reb_data) # tell me the dimensions
names(match_reb_data) # tell me the column names
summary(match_reb_data) # summarise the variable 'year' --- etc

#Nearest Neighbour full model
nearreb<- matchit(Mil_SD1 ~ informal_pgm + semioffic_pgm + lagpolityalt + laggdpper + lnlagtpop + lmtnest + exclpop + incomp + age + lnratio_scale + lnbdbest + lngov + pko + lagrebdum2010, data = match_reb_data,      method = "nearest" )
summary(nearreb, standardize = TRUE)
nearrebo <- match.data(nearreb)
write.dta(nearrebo, file = "Reb_Matched_Postprocessing.dta")

*Back in STATA
use "/Users/Gov_Clayton/Dropbox/Research/Papers in Progress/ISQ resubmission/Resubmission Final/Resubmission_V2/Replication Data/Reb_Matched_Postprocessing.dta", clear
nbreg rebbest2010 Mil_SD1 lagpolityalt laggdpper lnlagtpop lmtnest exclpop incomp age lnratio_scale lnbdbest lngov pko lagrebdum2010, cl(dyad)

*** Graphs 

 use "/Users/Gov_Clayton/Dropbox/Graph_Data.dta"


*Generate a time variable with appropriate day/month/year format
gen newdate=date(date, "DMY")
format newdate %td

*Generate bar charts using the twoway function
*Reference lines must be inserted manually at x=01sep2006

*US & Coalition forces killed in Anbar
twoway (bar coalition newdate, fcolor(gs10) fintensity(80%) lcolor(black) lwidth(vvvthin) vertical barwidth(20)), ytitle("Incidents With at Least One Civilian Death" "Perpetrated by US-Led Coalition Forces in Anbar Province")

*Anti-government/occupation forces killed in Anbar
twoway (bar antigov newdate, fcolor(gs10) fintensity(80%) lcolor(black) lwidth(vvvthin) vertical barwidth(20)), ytitle("Incidents With at Least One Civilian Death" "Perpetrated by US-Led Coalition Forces in Anbar Province")



