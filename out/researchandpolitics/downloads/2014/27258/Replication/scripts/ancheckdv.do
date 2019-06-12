/*
**************************************************************************
File-Name:    ancheckdv.do                         
Date:         Jan 29th, 2009                                    
Author:       Fernando Martel                                 
Purpose:      Replicate the dependendt variable in Ross(2006) quinquenial 
              data set using the annual frequency data. My aim is to 
              check the various coding decisions that where made by 
              replicating the process: 
              annual data -> procedures -> quinquenial data
              
              ANNUAL DATA
              * Infant Mortatlity Rate mnemonics:
              IMRwdi, logIMRwdi
              infmort_unicef, logIMRunicef

              * Child Mortality Rates:
              U5MRwdi, logCMRwdi - actual variable in Ross's main analysis
              kidmort_unicef, logCMRunicef - Ross claims to be using this measure
              kidmort_who, logCMRwho

              QUINQUENIAL DATA
              * Infant Mortality Rate mnemonics:
              logIMRwdi_1    (quinquenial lag)
              logIMRunicef_1 (quinquenial lag)
              **(currrent data not in quinquennial dataset, only lag)**

  
              * Child Mortality Rates:
              logCMRwdi, logCMRwdi_1 - the actual dependent variable 
              **(data for unicef and who not in quinquennial dataset)**

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
**************************************************************************
*/


clear
global path ///
C:\Users\Fernando\Documents\docs\research_projects\Replication\analysis
cd "$path"

/*************************************************************************
Copy anual frequency data set main_replication_data.dta as check1.dta
*************************************************************************/

copy "..\data_raw\Ross_Replication_Data\main_replication_data.dta" ///
	".\Ross1y.dta", replace
use Ross1y


/*************************************************************************
Replicate the DV using the annual data
*************************************************************************/

*Select the relevant variables
keep id id1 year IMRwdi infmort_unicef U5MRwdi kidmort_unicef kidmort_who

*Index quinquennia 1965,70,..,2000
gen quinquennia = 1 if int(year/5)==year/5

*Select only quinquennia
keep if quinquennia == 1
drop quinquennia
order id id1 year

/*
Replication data - 5 year panels.dta only starts in 1970
Apparently the data was truncated in 1970 even though UNICEF
reports data for 39/169 (23 %) in 1965
*/
tabmiss if year==1965

* To check concordance with Ross5y I drop 1965
drop if year==1965

*Create natural logs
gen lnIMRwdi = ln(IMRwdi) 
gen lnIMRunicef = ln(infmort_unicef)
gen lnCMRwdi = ln(U5MRwdi)
gen lnCMRunicef = ln(kidmort_unicef)
gen lnCMRwho = ln(kidmort_who)

*replication data - 5 year panels.dta does not have a "year" variable,
*only "period", so replicate it here, that way I can merge the data
egen period = seq(), from(1) to (`_N') by (id)

*Save as Ross1y.dta
sort id period, stable
save Ross1y, replace
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
use Ross1y
merge id period using Ross5y, keep(logCMRwdi logCMRwdi_1 logIMRunicef_1 logIMRwdi_1 )
tab _merge
order id id1 year period logCMRwdi lnCMRwdi
save Ross1y, replace


/*************************************************************************
Test 1 - Check periods and years are properly aligned and merge went well
*************************************************************************/

tab _merge //Should all be 3s
reg year period //Should have coeffient of 5 exactly, no error



/*************************************************************************
Test 2 - Check  values kidmort_unicef U5MRwdi against logCMRwdi 
are exactly identycal

In the paper we are told the dependent variable is UNICEF's child 
mortality rate.  However, the QUINQUENNIAL data set contains averages 
of all data used in Table 3 except for UNICEF's child mortality rate.
However, it does contain CMR from WDI which is what the author actually used,
as shown below.  Unless there is a mislabelling problem, there is an 
inconsistency btw what is said in the paper and done in the estimations.
*************************************************************************/

su logCMRwdi lnCMRwdi  U5MRwdi  lnCMRunicef kidmort_unicef

* Different no. of obs. and different moments why?
* ------------------------------------------------

* no. obs lnCMRwdi & U5MRwdi different, ERI has CMR==0 in 1970!
tabmiss U5MRwdi lnCMRwdi 
list year  U5MRwdi lnCMRwdi if id=="ERI"

* no. obs logCMRwdi & lnCMRwdi different, lnU5MRwdi has data on Cyprus
* lnCMRwdi I created from annual data, logCMRwdi was creqated by Ross
* Somehow Ross (2006) dropped some data for CYP.
capture noisily assert logCMRwdi==lnCMRwdi 
list year id year logCMRwdi lnCMRwdi if logCMRwdi!=lnCMRwdi 


/*************************************************************************
Test 3 - Check lagged values
Turns out that logCMRwdi_1 has more observations than lnCMRwdi_1.
Why? For some reason the current and lagged values in Ross (2006) 
quinquennial dataset are the same. 
This is a form of imputation, should be made explicit.
*************************************************************************/

xtset id1 year, delta(5) 

* Compare Ross (2006) lagged logCMRwdi_1 in quinquennial dataset to the one
* I created from annual data lnCMRwdi_1 
gen lnCMRwdi_1 = L.lnCMRwdi
capture noisily assert lnCMRwdi_1==logCMRwdi_1

* Ross(2005) laged data has values for 1970 even though data was truncated 
* in 1970 before creating the lag. Also note Ross (2006) lacks data for CYP
list id year lnCMRwdi_1 logCMRwdi_1 if lnCMRwdi_1!=logCMRwdi_1

* Turns out lag in 1970 is exact same as actual data in 1970
capture noisily assert logCMRwdi==logCMRwdi_1 if year==1970

