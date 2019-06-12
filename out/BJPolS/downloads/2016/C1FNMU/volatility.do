version 13.0
log using "C:\matt\working_papers\bjps_replication\first_draft\replication\volatility.log", replace
#delimit ;

*     ***************************************************************** *;
*     ***************************************************************** *;
*       File-Name:      volatility.do                                   *;
*       Date:           December 15, 2014                               *;
*       Author:         MRG/CC                                          *;
*       Purpose:      	Take bjps_powell_tucker_dataset.dta and         *;
*                       replicate results in Table 1.                   *;
* 	    Input File:     bjps_powell_tucker_dataset.dta                  *;
*       Output File:    volatility.log                                  *;
*       Data Output:    bjps_powell_tucker_dataset2.dta                 *;             
*       Previous file:  bjps_powell_tucker_dataset.dta                  *;
*       Machine:        laptop                 				            *;
*     ****************************************************************  *;
*     ****************************************************************  *;

*     ****************************************************************  *;
*       Load data. Data set downloaded from www.eleanorneffpowell.com   *;
*       on December 15, 2014.                                           *;
*     ****************************************************************  *;

use "C:\matt\working_papers\bjps_replication\first_draft\replication\bjps_powell_tucker_dataset.dta", clear;

*     ****************************************************************  *;
*     ****************************************************************  *;
*       Verify Powell and Tucker results.  These are Columns 1 and 2    *;
*       in Table 1.  These results correspond to Powell and Tucker's    *;
*       preferred model (Model 4) in their Tables 3 and 5.              *;
*     ****************************************************************  *;
*     ****************************************************************  *;

*     ****************************************************************  *;
*       Limit data to their sample of 89 elections.                     *;
*     ****************************************************************  *;

keep if EEIndicator == 1; 

*     ****************************************************************  *;
*       Create indicator for all countries except Bosnia-Herzegovina    *;
*     ****************************************************************  *;

gen id = 1;
replace id = 0 if Country == "Bosnia-Herzegovina";

*     ****************************************************************  *;
*       Powell helped us verify the results in Models 4 in Tables 3 and *;
*       5 (March 26, 2014, via email).  Note that it is necessary to    *;
*       include mis_weighted_mag to verify the results exactly. As      *;
*       explained in footnote 34 of their article, they do not include  *;
*       the coefficient for this variable in their tables.  To match    *;
*       what they did, we follow their specification and do not report  *;
*       the coefficient on this variable either.                        *;
*     ****************************************************************  *;

*     ****************************************************************  *;
*       Results in column 1: Electoral volatility (Type B volatility)   *;
*     ****************************************************************  *;
 
reg TypeBVol GDPChange1989 GDPChangeE1E2 Enp1 lg_weighted_mag presys mixsys pr 
            EthFrac Time Time2 mis_weighted_mag, cluster(Country);

*     ****************************************************************  *;
*       Results in column 2: Replacement volatility (Type A volatility) *;
*     ****************************************************************  *;

reg TypeAVol GDPChange1989 GDPChangeE1E2 Enp1 lg_weighted_mag presys mixsys pr 
            EthFrac Time Time2 mis_weighted_mag, cluster(Country);
            
*     ****************************************************************  *;
*       Verification complete.                                          *;
*     ****************************************************************  *;

*     ****************************************************************  *;
*     ****************************************************************  *;
*       Drop observations from Bosnia-Herzegovina. These are Columns 3  *;
*       and 4 in Table 1.                                               *;
*     ****************************************************************  *;
*     ****************************************************************  *;

*     ****************************************************************  *;
*       Results in column 3: Electoral volatility (Type B volatility)   *;
*     ****************************************************************  *;

reg TypeBVol GDPChange1989 GDPChangeE1E2 Enp1 lg_weighted_mag presys mixsys pr 
            EthFrac Time Time2 mis_weighted_mag if id == 1, cluster(Country);

*     ****************************************************************  *;
*       Results in column 4: Replacement volatility (Type A volatility) *;
*     ****************************************************************  *;

reg TypeAVol GDPChange1989 GDPChangeE1E2 Enp1 lg_weighted_mag presys mixsys pr 
            EthFrac Time Time2 mis_weighted_mag if id == 1, cluster(Country);
            
*     ****************************************************************  *;
*     ****************************************************************  *;
*       Correct the three observations for Bosnia-Herzegovina. These    *;
*       are Columns 5 and 6 in Table 1.                                 *;
*     ****************************************************************  *;
*     ****************************************************************  *;

*     ****************************************************************  *;
*       Note that the codebook indicates that the original              *;
*       GDPChange1989 variable data comes from Pop-Eleches 2010.  The   *;
*       actual article indicates that the data comes from Pacek,        *;
*       Pop-Eleches, and Tucker 2009.                                   *;
*     ****************************************************************  *;

*     ****************************************************************  *; 
*       Create new GDPChange1989_corrected variable with the correct    *;
*       values for Bosnia-Herzegovina. Correct data for this variable   *;
*       come from the EBRD's Transition Report 2012, p. 103.  See       *;
*     www.ebrd.com/downloads/research/transition/assessments/bosnia.pdf *;
*     ****************************************************************  *;

gen GDPChange1989_corrected=GDPChange1989;

replace GDPChange1989_corrected = 0.55882353 if Country == "Bosnia-Herzegovina" & Year2==2000;
replace GDPChange1989_corrected = 0.60784314 if Country == "Bosnia-Herzegovina" & Year2==2002;
replace GDPChange1989_corrected = 0.74019608 if Country == "Bosnia-Herzegovina" & Year2==2006;

list Country Year2 GDPChange1989 GDPChange1989_corrected if Country == "Bosnia-Herzegovina";

*     ****************************************************************  *;
*       Results in column 5: Electoral volatility (Type B volatility)   *;
*     ****************************************************************  *;
 
reg TypeBVol GDPChange1989_corrected GDPChangeE1E2 Enp1 lg_weighted_mag presys mixsys pr 
            EthFrac Time Time2 mis_weighted_mag, cluster(Country);

*     ****************************************************************  *;
*       Results in column 6: Replacement volatility (Type A volatility) *;
*     ****************************************************************  *;

reg TypeAVol GDPChange1989_corrected GDPChangeE1E2 Enp1 lg_weighted_mag presys mixsys pr 
            EthFrac Time Time2 mis_weighted_mag, cluster(Country);
            
*     ****************************************************************  *;
*       Save the dataset with the corrected values for                  *;
*       Bosnia-Herzegovina.                                             *;
*     ****************************************************************  *;

save "C:\matt\working_papers\bjps_replication\first_draft\replication\bjps_powell_tucker_dataset2.dta", replace;

*     ****************************************************************  *;
*       We report some other results at various points in the paper.    *;
*     ****************************************************************  *;

sum GDPChange1989;
sum GDPChange1989 if Country == "Bosnia-Herzegovina";
sum GDPChange1989 if Country != "Bosnia-Herzegovina";

gsort -GDPChange1989;

list Country year GDPChange1989 in 1/4;

*     ****************************************************************  *;
*       Replication complete                                            *;
*     ****************************************************************  *;

log close;
clear;








            
           
