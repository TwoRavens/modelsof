* Paper: "The Economics of Attribute-Based Regulation: Theory and Evidence from Fuel-Economy Standards"
* Authors: Koichiro Ito and James Sallee 
* This is the "readme.txt" file for the programs 

/*

[1] General instruction 

This "readme" file describes the process of the empirical work in the paper. It is also written as a Stata do file that executes all of other do files. That is, one can run this "readme" file in Stata to execute all of the programs to produce tables and figures for the paper. To run all programs, follow this step:

1. In setup.do file, specify the path to user's RESTAT_19156_Program_Data directory. 
2. Go to the main directry. That is, "cd /.../RESTAT_19156_Program_Data" 
3. Then, run this readme file. That is, "do readme.do"

One caution is that the programs that involve bootstrapping processes (file names with "bootstrap") takes hours to run. Other programs are fairly fast to run. 

[2] Directories 

RESTAT_19156_Program_Data: this is the main directory, which contains the following sub-directories. 

DataStata: Stata data files that are required to produce tables and graphs in the paper. The Stata do files are written for Stata version 14.1.  

Do: Stata do files. 

Paper: this directory is used for saving graphs and figures for the paper. After running the Stata programs, one can use the tex file in this folder to check tables and figures that are created by Stata. 

TableText: this directory is used for saving results. 

Temp: this directory is used for saving temporary files. 

*/

* [3] Programs 

*** Set up ******************************
clear
set more off, perm
set scheme s1color, perm
set matsize 10000

* Specify a user's main directory of ".../RESTAT_19156_Program_Data." 
global path "***User's path***/RESTAT_19156_Program_Data"  

* Define global variables for sub directories  
global temp "$path/Temp"
global figure "$path/Paper/graphs"
global table "$path/Paper/tables"
global data "$path/DataStata"

* Go to the main directory 
cd $path
******************************************

* 1) Users need to specify a path to a user's main directory of ".../RESTAT_19156_Program_Data."
* 2) If users want to execute each single do file, users need to run this do file before running any of the main program do files 

*** Log file ******************************
cap log close
log using TableText/logfile.log,replace

*** Figure 2 ******************************
do Do/do_create_regulation_schedule

* This program creates the figure. The original source of the data is publicly available and obtained from the Ministry of Land, Infrastructure, Transport and Tourism (MLIT)'s website. 

*** Figure 3 ******************************
do Do/do_histogram

* This program creates creates the figures. $data/histogram_regime0.dta include data on vehicles sold between 2001 to 2008 (under the old fuel-economy regulation) and $data/histogram_regime1 include data on vehicles sold between 2009 to 2011 (under the old fuel-economy regulation). The original source of the data is publicly available and obtained from the Ministry of Land, Infrastructure, Transport and Tourism (MLIT)'s website.  

*** Tables 1 and 2, and Figure 4 ******************************
do Do/do_bunching

* This program is the main estimation file for the bunching estimation. The estimation is separately run by regular passenger cars and kei cars, by regime 0 (old standard) and regime 1 (new standard), and by the two assumptions for the estimation procedure (uniform = 0 and = 1). 

* The first method (uniform ==0) assumes that bunched cars came uniformly from the immediate left weight category. The second method (uniform ==1) relaxes this assumption and estimates where (within the immediate left weight category) bunched cars came from, based on the empirical distribution of the data and the counterfactual distribution. 

* The iteration process in the middle of the program ensures the integration constraint---the number of observations are equivalent in the observed distribution and counterfactual distribution. 

* In the code, we make figures for Figure 4, to illustrate the observed distribution and estimated counterfactual distribution. 

do Do/do_bunching_bootstrap

* This program estiamtes bootstrapped standard errors. We use 100 bootstrapped samples. We checked that using more than 100 bootstrapped samples change the standard errors very little. NOTE THAT THIS PROGRAM TAKES TIME TO RUN (a few hours with a regular computer in 2017) because it runs for 100 bootstrapped samples.

do Do/do_bunching_make_table

* This program uses estimation results to create latex tables. 

*** Figure 5 ******************************

do Do/do_panel_arrow

* This program produces Figure 5, which shows panel variation of car weight and fuel economy in response to the subsidy incentive. 

*** Table 3 ******************************

do Do/do_mixlogit 

* This program produces Table 3, which shows the estimation results of the logit model and mixed logit (random-coefficient) logit model. The local variable `rc' defines the standard logit (rc=0), the mixed logit for columns 3 and 4 in the table (rc=1) and  the mixed logit for column 5 in the table (rc=2). Another local variable `compliance' specifies whether the model includes the controls for firm-level fuel economy regulation (compliance=1) for columns 2, 4, and 5 in the table or does not include such controls (compliance=0) for columns 1 and 3 in the table. We use nrep = 50 (number of simulations for Maximum Simulated Likelihood Estimation (MSLE) for our main results. We checked that using nrep>50 does not change the results.  

do Do/do_mixlogit_make_latex_table

* This program makes a latex table based on the estimation results. After running this program, a few minor edits have to be done in latex: 1) standard deviations has to be converted to absolute values, 2) and the text line of "Stadard deviation of random-coefficient" has to be inserted. 

*** Table 4, Figure 6, and Figure 7 ******************************

do Do/do_mixlogit_parameters 

* This program computes random coefficients for each observation, based on the estimation results of the mixed logit model. 

do Do/do_counterfactual 

* This program uses the estimation results of the logit and mixed logit models to conduct counterfactual simulations for the three policies described in the paper. To compare the counterfactual simulations across the three policies and across the logit and mixed logit models, the program forces all policies to produce the same improvement in fuel economy (the same reduction in fuel consumption). We start with the random-coefficient logit result (`rc'=1), save the equilibrium reduction in fuel consumption due to the policy, and force other policies to achieve this amount of reduction. 

* The first part of the program simulates the ABR. We start with the actual ABR policy schedule (in the old regime) and apply it to the random-coefficient logit estimates. This process produces the equilibrium reduction in fuel consumption due to the policy (we define it as `de_ABR_RCL'). Then, we use the random-coefficient logit estimates to simulate the counterfactual flat standard and efficient policy that produce the fuel economy reduction by `de_ABR_RCL'. We then simulate counterfactuals with logit estimates. To the simulations based on the random-coefficient logit and standard logit comparable, we shift the actual ABR schedule until the simulation with the logit estimate produce the reduction in fuel consumption by `de_ABR_RCL'.  

*** Obtain bootstrapped SE for Table 4 ******************************

do Do/do_mixlogit_bootstrap
do Do/do_mixlogit_parameters_bootstrap
do Do/do_counterfactual_bootstrap 

* This program estimates bootstrapped standard errors for the counterfactual analysis. We use 100 bootstrapped samples. We checked that using more than 100 bootstrapped samples change the standard errors very little. 
* NOTE THAT THIS PROGRAM TAKES TIME TO RUN (about 24 hours with a regular computer in 2017) because it runs for 100 bootstrapped samples.

do Do/do_counterfactual_make_latex_table

* This program produces the latex table based on the estimation results. 

do Do/do_counterfactual_histogram 

* This program makes Figure 6, which is the distribution of the marginal compliance costs. 

do Do/do_counterfactual_incidence 

* This program makes Figure 7, which is the distribution of the compliance burden across firms. 

*** Close log file ******************************
cap log close

*** END
