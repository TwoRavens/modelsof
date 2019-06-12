clear 
version 10.1  // Stata version
set mem 500M
set maxvar 32767
set more off
capture log close 
set matsize 775 

global path ///
C:\Users\Fernando\Documents\docs\research_projects\Replication\analysis
cd "$path"

// Create a log file
capture log close
log using ../logs/pure_replication.log, replace


/*
==========================================================================
File-Name:    pure_rep_master.do                         
Date:         Sep 10, 2013
Author:       Fernando Martel Garcia
Purpose:      This master file calls up all the do files used to implement 
              a pure replication of Ross (2006) as described in the 
              accompanying manuscript.  It includes all relevant statistical 
              and data analyses performed, even if not all results are 
              reported in the manuscript.  More details in the headers of 
              the .do files called from this file
Data Input:   - main_replication_data.dta
              - replication data - 5 year panels.dta
Output File:  pure_replication.log 
Data Output:  none
Previous file:crmaster.do  //creates all the data used here
Status:       Complete
Machine:      Lenovo X201 tablet running Windows 7 64-bit spck 1
==========================================================================
*/



/*
==========================================================================
As noted in the manuscript, a procedural replication begins with a pure
replication.  

A pure replication checks whether the published finding can be replicated 
by repeating the investigation “in exactly the same way”.  Often the 
explication given in an article are not sufficiently precise to replicate 
it's results.  

One objective of a pure repliction is to infer what exact procedures 
where used to produce the results, namely the scientific standard used in 
Ross (2006) (see Definitions in manuscript).

In this specific application a pure replication consists of 4 steps 
(Eqs. 8--11 in manuscript):

STEP 1 - Replicate the estimation data from the raw data and sampling 
         frame;
STEP 2 - Replicate the observed likelihood (estimates) using the replicated 
         data in Step 1, or, if step 1 could not be replicated, using the 
         observed data in the replication file;
STEP 3 - Replicate the multiply imputed datasets from the incomplete data
         replicated in Step 1, or, if step 1 could not be replicated, using
         the observed data in the replication file;
STEP 4 - Replicate the complete data likelihood using the data from Step 3.

This script calls other scripts to implement all possible steps, as 
failure to replicate in any step can compromise the ability to replicate 
subsequent steps.
==========================================================================
*/

/*
==========================================================================
STEP 1: Replicate the estimation data from the raw data and sampling frame.

Using the notation of Eq. 11 in the manuscript the objective of 
this step is to determine what is the sampling frame for the raw data (W), 
the software used (nu_4), and the procedures (f_4()) used to generate the 
estimation data (X_obs).  
- The raw data file is an annual dataset spanning the years 1965 to 2002 for 
169 entities.  
- The estimation data file is a file of quinquennial observations
and averages for the years 1970, 1975, ..., 1995, 2000 for 169 entities
==========================================================================
*/

* Check sampling frame
do ../scripts/anchecksp

* Check how how the observed data were created from the raw data
do ../scripts/ancheckdv  //Replicate dependent variable

do ../scripts/ancheckiv  //Replicate independent variable

do ../scripts/ancheckcv  //Replicate control variables


/*
==========================================================================
STEP 2 Replicate the observed likelihood (Eq. 10 in manuscript) using the 
replicated data in Step 1, or, if step 1 could not be replicated, using the 
observed data in the replication file (X_obs).

As noted in Step 1 the sampling frame is unclear, and the quinquennial 
data cannot be replicated using the annual data provided.  Hence, here I
replicte the observed likelihood using the quinquennial data provided by
Ross.
==========================================================================
*/

do ../scripts/antable3        //Replicate Ross(2006) Table 3 results using 
                                                         // unimputed data

/*
==========================================================================
STEP 3 - Replicate the multiply imputed datasets from the incomplete data
replicated in Step 1, or, if step 1 could not be replicated, using the 
observed data in the replication file (see Eq. 9 in manuscript).
==========================================================================
*/

* Not possible to perform this pure replication because:
   * Ross (2006) did not provide a random seed for the imputation, this 
   * means that even if I uded the exact same observed data, code, and 
   * software I would not get the same results.
   * Author did not make available the imputation code.
   * Author only made available the imputed datasets.
   * Imputed data set has more data than is available in the quinquennial
   * dataset.

* However some findings:
   * Polity has missing data in the multiply imputed datasets. Suggests
   * it was never included in the imputation model.
   * Author used Amelia I, not for panel data

do ../scripts/animputed            //Analyse imputed datasets sent by Ross


/*
==========================================================================
STEP 4 - Replicate the complete data likelihood using the data from Step 3,
or, if that step failed, using the multiply imputed datasets in the 
replication file (see Eq. 8 in manuscript).
==========================================================================
*/

* Although Ross provided the five multiply imputed datasets used in the 
* analysis, I do not have access to the software used to combine the five
* different estimates.  That was code provided by Kenneth Scheve, see 
* Ross (2006, p 866) footnote 11.  
* In terms of Eq. 8 in the manuscript I am missing the technology input (nu_1)
* and the specific function used to combine the estimates (f_1(.))

exit
