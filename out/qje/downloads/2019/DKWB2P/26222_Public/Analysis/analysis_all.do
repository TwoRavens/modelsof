/* This do-file generates all results in Costinot, Donaldson, Kyle and Williams (QJE, 2019)

All component do-files should be run in the order listed in this document, in order 
to create the results in the paper. 

Note: tab8ppml.do and EpsBootstrap.do, respectively, take ~45 and ~15 minutes 
to run, using an Intel I5, 4.2Ghz 4-core processor. 

Note: Be sure to specify the {path} noted in the directories section.  (Just replace the XX on line 29 with your home path.)
*/ 


clear all
set more off

/*
* install needed Stata commands
capture {
	ssc install reghdfe
	ssc install ppml
	ssc install listtex
	ssc install tuples
	ssc install labutil
	}
*/

************************** specify directories ********************************

global path "XX"

* a working directory where the intermediate analysis datasets are saved
global intersavedir			"${path}Data/Analysis/Intermediate/"
* a working directory where the final analysis datasets are saved
global finalsavedir			"${path}Data/Analysis/Final/"
* a directory with sales data
global rawdata2013 		"${path}Data/Raw/MIDAS_2000-2013/"
* a directory with diseases data
global gbd			"${path}Data/Raw/WHO_GBD/"
* a directory with population counts
global pop			"${path}Data/Raw/UScensus_population/"
* a directory with GDP per capita data
global gdpdir			"${path}Data/Raw/World_bank_GDP/"
* a directory with distances between countries data
global gravity 			"${path}Data/Raw/cepii/"
* a directory containing the NIH data
global nih 			"${path}Data/Raw/NIH_grants/"
* a directory containing the OECD Trade data
global oecd 			"${path}Data/Raw/OECD_trade/"
* a directory containing the OECD Pharma data
global oecd_pharma				"${path}Data/Raw/OECD_pharma/"
* a directory containing the MEPS data
global meps2012					"${path}Data/Raw/MEPS_2012/"
* a directory with atc-gbd crosswalk
global atc_gbd			"${path}Data/Raw/ATC_GBD/"
* corporation-origin country crosswalk
global crp_ctry			"${path}Data/Raw/crp_ctry_xwalk/"
* exchange rates
global exchange_rates 		"${path}Data/Raw/exchange_rates/"
* country crosswalk
global ctry_xwalk		"${path}Data/Raw/ctry_xwalk/"
* gbd to nih ic code crosswalk
global gbd_nih_xwalk		"${path}Data/Raw/gbd_nih_xwalk/"

* a directory with construction do files
global consdo_dir 			"${path}do-files/Construction/"
* a directory with construction log files
global conslog_dir 			"${path}do-files/Construction/Logs/"


* a directory with analysis do files
global do_dir 			"${path}do-files/Analysis/"
* a directory with analysis log files
global log_dir 			"${path}do-files/Logs/"

* a directory for the output files (figures, etc)
global output_dir 			"${path}do-files/Output/"

************************** tables *********************************************

* create misc numbers (throughout text) and figures
do "${do_dir}miscnumbers.do"
do "${do_dir}miscfigures.do"


* conduct validation (to MEPS data, in Appendix B) 
do "${do_dir}miscvalidation.do"


* make a table with top 10 countries in terms of sales
* Table 1
do "${do_dir}tab1.do"


* make a table with top 10 diseases in terms of sales
* Table 2
do "${do_dir}tab2.do"


* run baseline regressions
* Table 3
do "${do_dir}tab3.do"


* run sensivity analysis I
* Table 4
do "${do_dir}tab4.do"


* run sensivity analysis II
* Table 5
do "${do_dir}tab5.do"


* run sensivity analysis III
* Table 6
do "${do_dir}tab6.do"


* run sensivity analysis IV
* Table 7 & result in Footnote 35 and footnote 29 (using 2004 data)
do "${do_dir}tab7.do"
do "${do_dir}tab7_FN35.do"
do "${do_dir}2004_robustness_FN29.do"


* run extensive margin analysis
* Table 8
do "${do_dir}tab8.do"


* run extensive margin analysis (PPML)
* Table 8 PPML
do "${do_dir}tab8ppml.do"


* run demand elasticity estimates (and result in footnote 41)
* Table 9
do "${do_dir}tab9.do"
do "${do_dir}tab9_FN41.do"


* run supply elasticity estimates
* Table 10
do "${do_dir}tab10.do"


* compute elasticity estimates and bootstrapped confidence intervals from Section 6
do "${do_dir}EpsBootstrap.do"


* predict disease burden using demographic variation
* Table B1
do "${do_dir}tabB1.do"



















