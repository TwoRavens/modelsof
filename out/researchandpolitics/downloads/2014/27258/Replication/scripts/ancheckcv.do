/*
**************************************************************************
File-Name:    ancheckcv.do                         
Date:         Jan 29th, 2009                                    
Author:       Fernando Martel                                 
Purpose:      Replicate the control variables in Ross(2006) using the 
              quinquennial and annual frequency data sets. My aim is to 
              check the various coding decisions that where made.

              Quinquennial data:
              logGDPcap_1   Lag of log GDP per capita
              logHIV_1      Log of HIV prevalence rate, UNAIDS/CIA data, 
                            extrapolated back from 2001
              logDen_1      Log of population density, data from WDI 2004
              GDPgrowth_1   Lag GDP growth
              
              Annual data:
              rgdpch        GDP pr capita, chain series; plus values 
                            for 1970&2000 from short dataset
              HIV           not in annual dataset, cannot replicate.
              density       Population density (people per sq km)--
              GDPgrowth     GDP growth (annual %)

              The datasets:
              quinquennial: replication data - 5 year panels.dta
              annual:       main_replication_data.dta  

Data Input:   - main_replication_data.dta
              Received from author via e-mail Feb 25th 2007.  
              Contains ANNUAL data used in the paper, except for HIV data 
              and democratic years.
              Data spans 1965 to 2000
              - replication data - 5 year panels.dta
              Received from author via e-mail Aug 18th 2008.  
              Data spans 1970 to 2000

Output File:  None
Data Output:  None                                   
Previous file:Pure_rep_master.do
Status:       Complete                                     
Machine:      IBM, X41 tablet running Windows XP spck 3                                
**************************************************************************
*/

clear
global path ///
C:\Users\Fernando\Documents\docs\research_projects\Replication\analysis
cd "$path"


/*************************************************************************
Copy anual frequency data set main_replication_data.dta as Ross1y.dta
*************************************************************************/

copy "..\data_raw\Ross_Replication_Data\main_replication_data.dta" ///
	".\Ross1y.dta", replace
use Ross1y


/*************************************************************************
Replicate the control vars using the annual data
*************************************************************************/

* Select the relevant variables
keep id id1 year rgdpch density GDPgrowth
rename GDPgrowth GDPgrowthb

*There are no observations for density in annual data prior*; 
*to 1970.  
capture noisily assert density == . if year<1970

* Create indicator for five year blocks by country
* NOTE AVERAGE FOR 1970 WILL BE AVERAGE OF 1970-74 -- NOT CENTERED
egen time_block = seq(), from(1) to(`_N') block(5) by (id)

* Take logs
* Regressions in Table 3 uses the natural logs of all variables save GDP
* growth.  It appears logs were taken before collapsing data, i.e.
* Take logs -> collapse -> create lag

local varlist1 "rgdpch density"
foreach x of local varlist1 {
 di"`x'"
	gen ln`x' = ln(`x')
}
order id id1 year
save check1, replace

*Collapse to quinquenial
/*
Note the default for collapse is to ignore missings, i.e. if only three data 
points are avialable in a quinquennia, then these are averaged and reported 
as the five year average. Compare, for example, AGO's GDP growth in the annual 
and quinquennial data.
*/
collapse (min) year (mean) rgdpch density GDPgrowthb ln*, ///
     by(id id1 time_block)
drop time_block
order id year
sort id year, stable
save check1, replace

*Create lag
xtset id1 year, delta(5) 
local varlist GDPgrowthb rgdpch density lnrgdpch lndensity
foreach x of local varlist {
	gen `x'_1 = L.`x'
}
order id id1 year
save check1, replace

*replication data - 5 year panels.dta does not have a "year" variable,*;
*only "period", so replicate it here, that way I can merge the data*;
egen period = seq(), from(0) to (`_N') by (id)

*Save as check1.dta
sort id period, stable
save check1, replace
clear

/*************************************************************************
Now merge with the quinquennial dataset: replication data - 5 year panels.dta
Copy it to local drive and sort it by merge variables
*************************************************************************/

copy "..\data_raw\Ross_Replication_Data\replication data - 5 year panels.dta" /// 
     actual.dta, replace
use actual
sort id period, stable
save actual, replace
clear
use check1
merge id period using actual, keep(logGDPcap_1 logDen_1 GDPgrowth_1)
order id id1 year period
save check1, replace


/*************************************************************************
Test 1 - Check periods and years are properly aligned and merge went well
*************************************************************************/
reg year period          //Should have coeffient of one exactly, no error


/*************************************************************************
Test 2 - Check lagged values
Check whether lagged values where created before the sample was truncated 
in 1970 or after.  So far I created it before so we could observe a diff.
If created after, the lagged value in 1970 should be missing
*************************************************************************/
tab _merge                //Should all be 3s except observations for 1965 
su year if _merge==1

* It appears annual data was truncated in 1970 before collapsing, so all
* data for covariates (though not polity, smallstate, or transition)
capture noisily assert _merge != 1 if year != 1965
su lndensity  lnrgdpch GDPgrowthb if year == 1965
su logDen_1 logGDPcap_1 GDPgrowth_1 if year == 1970
su lndensity_1  lnrgdpch_1 GDPgrowthb_1 if year == 1970

*Quinquennial data set essentially throws out all 1970 lagged control 
*variable data!

* Replication data - 5 year panels.dta *;
* only starts in 1970 (Why drop one whole set of observations for 1965?)*;
drop if year==1965

/*************************************************************************
Test 3 - Check  values are exactly identical
*************************************************************************/

* Due to truncation lag values in 1970 missing from Ross (2006)
su lnrgdpch_1 logGDPcap_1  lndensity_1 logDen_1  GDPgrowthb_1 GDPgrowth_1 if year == 1970
su lnrgdpch_1 logGDPcap_1  lndensity_1 logDen_1  GDPgrowthb_1 GDPgrowth_1 if year > 1970

* Different no. of obs. and different moments for GDP per capita, why? 
* CYPRUS
* Cyprus has annual data but all quinquennial data bar Polity is missing
* in Ross(2006)
su lnrgdpch_1 logGDPcap_1  lndensity_1 logDen_1  GDPgrowthb_1 GDPgrowth_1 if year > 1970 & id !="CYP"
list id year lnrgdpch_1 logGDPcap_1 if id=="CYP"
capture noisily assert lnrgdpch_1 == logGDPcap_1 if id!="CYP" & year > 1970


*Different no. of obs. and different moments for GDP growth, why? CYPRUS and*;
*small diffs in GBR, GRC, IRL, THA
su GDPgrowthb_1 GDPgrowth_1 if year > 1970 & id !="CYP"
list id year GDPgrowthb_1 GDPgrowth_1 if id!="CYP" & year > 1970 & GDPgrowthb_1 != GDPgrowth_1 


/*
Issue: Control and independent variables are not centered.  E.g. data for
1960 does not refer to 1958-1962 but rather to 1960-64, whereas DVs are
centered in the middle of the quinquennia
*/

