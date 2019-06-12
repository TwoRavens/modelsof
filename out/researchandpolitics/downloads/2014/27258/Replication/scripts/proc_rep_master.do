clear 
version 10.1  // Stata version
set mem 500M
set maxvar 32767
set more off
capture log close 
set matsize 775 

// Create a log file
capture log close
log using ../logs/procedural_replication.log, replace

// Show STATA version and installed packages
version
ado



/*
==========================================================================
File-Name:    proc_rep_master.do                         
Date:         Sep 11, 2013
Author:       Fernando Martel Garcia
Purpose:      This master file calls up all the do files used to implement 
              a procedural replication of Ross (2006) as described in the 
              accompanying manuscript.  It includes all relevant statistical 
              and data analyses performed, even if not all results are 
              reported in the paper.  More details in the headers of the 
              .do files called from this file
              Random seed = 01200 for imputations and simulations. These 
              are the last 5 digits PLoS One assigned to my manuscript
Data Input:   - main_replication_data.dta
              - replication data - 5 year panels.dta
Output File:  procedural_replication.log 
Data Output:  none
Previous file:crmaster.do  //creates all the data used here
Status:       Complete
Machine:      Lenovo X201 tablet running Windows 7 64-bit spck 1
==========================================================================
*/


/*
==========================================================================
As noted in the manuscript a procedural replication tries to infer the 
scientific standard (Definition 7 in manuscript http://ssrn.com/abstract=2256286 ) used in the published 
article by first implementing a pure replication.

 

If the pure replication is succesful and the inferred scientific standard 
meets generally accepted scientific standars (e.g. is in accordance with 
procedures and methods in mainstream textbooks) conclude the study followed 
generally accepted procedures, and results can be replicated.

If the pure replication is succesful but the inferred standard is not at 
the level of generally accepted standards, or if the pure replication is 
unsuccesful, then substitue the generally accepted standard into the 
replication materials and perform a replication with the new procedures 
and (software) technologies.

In this specific application I use the insights from the previous pure 
replication to revise, when necessary, the procedures and technologies 
used in the four steps outlined in Eqs. 8--11 in manuscript:

STEP 1 - Generate the observed estimation data from the raw data and sampling 
         frame;
STEP 2 - Generate the observed likelihood (estimates) using the data in 
         Step 1;
STEP 3 - Generate the multiply imputed datasets from the incomplete data
         in Step 1;
STEP 4 - Generate the complete data likelihood using the data from Step 3.

This script calls other scripts to implement all possible steps, as 
failure to replicate in any step can compromise the ability to replicate 
subsequent steps.
==========================================================================
*/


/*
==========================================================================
STEP 0 - Set file path, create log file, provide software session info
==========================================================================
*/
clear

global path ///
C:\Users\Fernando\Documents\docs\research_projects\Replication\analysis
cd "$path"

/*
==========================================================================
STEP 1 - Replicate the estimation data from the raw data and sampling frame

Recreate Ross's (2006) quinquennial data from Ross's (2006) annual data 
correcting procedural errors & omissions identified in the pure replication,
including:
- Take account of proper birth and death of countries (unbalanced panel)
  but be careful with ACLP ctycode for ETH CYP DEU
- Wrong mnemonics for YUG (corrected in crmaster.do)
- Ignored annual data for CYP
- Center averages
- Take logs and lags after averaging
- Create quinquenial averages for the other dependent variables, not only
  logCMRwdi
- Do not truncate quinquenial data to 1970 before taking lag for 1970
- Do not manually impute lag of DV in 1970 using the actual value for 1970
- Have two versions of Polity, as cound not replicate quinquennial data
  from annual data
- Lag for HIV in 1970 missing even though Ross (2006) codes it as 0
==========================================================================
*/

do ../scripts/crmartel5y   // Recreate Ross's (2006) quinquennial data from 
                           // Ross's (2006) annual data correcting procedural 
                           // errors identified in previous steps 


/*
==========================================================================
STEP 2 - Replicate the observed likelihood (Eq. 10 in manuscript) using the
previously created dataset, and the generally accepted scientifc standard.

- Use the within estimator as opposed to the dummy FE estimator to get the 
appropriate R^2
==========================================================================
*/

do ../scripts/antable3martel   // Replicate Ross(2006) Table 3 results using 
                               // unimputed martel data

/*
==========================================================================
STEP 3 - Replicate the multiply imputed datasets from the incomplete data
replicated in Step 1, and using the generally accepted scientifc standard.

- Set random seed for imputation 
- Record software version
- Include Polity in imputation
==========================================================================
*/

do ../scripts/cramelia   // Prepare data set for imputation in R
// Run ../scripts/amelia.R which does multiple imputation in R


/*
==========================================================================
STEP 4 - Replicate the complete data likelihood using the data from Step 3
(see Eq. 8 in manuscript).

- Record software version and packages used; set seed
==========================================================================
*/

do ../scripts/crstack   // Stacks the five multiply imputed datasets
do ../scripts/antable4_5y    // Replicate Ross(2006) Table 4 results with 
                             // imputed data

/*
==========================================================================
Analysis and balance checks after imputing ross5y data using 
Ross's original population definition and dataset
==========================================================================
*/

do ../scripts/anpool   // check for poolability of Gulf States
do ../scripts/simulation   // check practical significance

exit
