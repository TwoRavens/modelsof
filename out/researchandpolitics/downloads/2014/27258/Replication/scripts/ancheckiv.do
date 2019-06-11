/***************************************************************************
File-Name:    ancheckiv.do                         
Date:         Jan 29th, 2009                                    
Author:       Fernando Martel                                 
Purpose:      Replicate the independendt variables in Ross(2006) using the 
              quinquennial and annual frequency data sets. My aim is to 
              check the various coding decisions that where made.

              The mnemonics are:
              Annual dataset does not contain demyrs, cannot replicate
              Polity         in annual dataset - "nonsovereign yrs filled in"
              Polity_1       in quinquennial dataset - the actual independent
                             variable
              logDEMYRS_1    in quinquennial dataset 
              autocracy_mod  Annual - MR modified ACLP var to fill in some 
                             nonsovereign states
              autocracy_new  Annual - ACLP update, autocracy=1
              democracy      Annual - ACLP measure (autocracy_mod reversed so
                             1=dem)
              transition_1   Quinquennial dataset


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
Previous file:pure_rep_master.do
Status:       Complete                                     
Machine:      IBM, X41 tablet running Windows XP spck 3                                
***************************************************************************/


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
Replicate the IV using the annual data
*************************************************************************/

*Select the relevant variables
keep id id1 year Polity

*All data missing before 1970.  Why?  We know data exists?
capture noisily assert Polity==. if year < 1970
su Polity if year<=1969

*Create indicator for five year blocks by country
egen time_block = seq(), from(1) to(`_N') block(5) by (id)



/*
Collapse
Note the default for collapse is to ignore missings, i.e. if only three data 
points are avialable in a quinquennia, then these are averaged and reported 
as the five year average. Compare, for example, AGO's GDP growth in the annual 
and quinquennial data.
*/

* Note collapse is back centered
collapse (min) year (mean) Polity, by(id id1 time_block) 

drop time_block
order id year
sort id year, stable
save Polity5y, replace

*Drop observations for quinquennia 1965 - all missing.  
*Replication data - 5 year panels.dta only starts in 1970
su Polity if year==1965
drop if year==1965

*Create lag of Polity as Polity_1b
xtset id1 year, delta(5) 
gen Polity_1b = L.Polity

*replication data - 5 year panels.dta does not have a "year" variable,
*only "period", so replicate it here, that way I can merge the data
egen period = seq(), from(1) to (`_N') by (id)

*Save as Polity5y.dta
sort id period, stable
save Polity5y, replace
clear

/*************************************************************************
Now merge with the quinquennial dataset: replication data - 5 year panels.dta
Copy it to local drive and sort it by merge variables
*************************************************************************/

copy "..\data_raw\Ross_Replication_Data\replication data - 5 year panels.dta" ///
     Ross5y.dta, replace
use Ross5y
sort id period, stable
save Ross5y, replace
clear

use Polity5y
merge id period using Ross5y
order id id1 year period Polity Polity_1 
keep id id1 year period Po* _merge
save Polity5y, replace


/*************************************************************************
Test 1 - Check periods and years are properly aligned and merge went well
*************************************************************************/

tab _merge				//Should all be 3s
reg year period 			//Should have coeffient of 5 exactly, no error



/*************************************************************************
Test 2 - Check values Polity_1 against Polity_1b are exactly identical
*************************************************************************/

su Polity_1 Polity_1b
* scatter Polity_1 Polity_1b if year>1970 // ignore 1970 bc annual data only 
                                        // start in 1970, so lag for 1970
                                        // is missing

* Different no. of obs. and different moments why?
capture noisily assert Polity_1 == Polity_1b
list id year Polity_1 Polity_1b if Polity_1 != Polity_1b
di "Measures are different"

* How big are the differences
gen diff = Polity_1 - Polity_1b
su diff if year > 1970



/*************************************************************************
Test 3 - Check lagged values
Contrary to what happened with logCMRwdi_1 Polity_1 seems to have been 
created before the sample was truncated in 1970, so it does not appear to
have been imputed systematically in 1970.  However, note that Polity in
the annual dataset is truncated at 1970.  Not sure then where data for 
the lag in 1970 (e.g. from 1965-69) came from.  Cannot replicate.
*************************************************************************/

capture noisily assert Polity_1 == Polity_1b
capture noisily assert Polity == Polity_1 if period==1
list id year Po* if year==1970
capture noisily assert Polity_1 == Polity_1b if year>1970


/*************************************************************************
Test 4 - Check Polity against imputed dataset
*************************************************************************/
clear
copy "..\data_raw\Ross_Replication_Data\mr1replication1.dta" ///
     imputed.dta, replace
use imputed
sort id period, stable
save imputed, replace
clear

use Polity5y
drop _merge
sort id period, stable
save Polity5y, replace
merge id period using imputed
order id id1 year period Polity Polity_1 
keep id id1 year period Po* _merge
save Polity5y, replace

* check merge
tab _merge
* we see that CYP was not included in the imputations
drop if _merge==1

* check that Polity_1 in Ross (2006) quinquennial dataset and PolityB_1 in
* his multiply imputed dataset are the same except for missing values
capture noisily assert PolityB_1 == Polity_1

* Turns out they are exactly identical => Polity was never imputed and
* was never included in the imputation model
* Indeed PolityB_1 from multiply imputed dataset has missing values
tabmiss PolityB_1


/*
Issue: Control and independent variables are not centered.  E.g. data for
1960 does not refer to 1958-1962 but rather to 1960-64, whereas averages are
centered in the middle of the quinquennia

Also cannot replicate Polity in quinquenial dataset.  

And Polity was never included in the imputation model.
*/




