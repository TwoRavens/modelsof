/*
dofiles for Commander and Svejnar "Business Environment, Export, Ownership and Firm Performance"

* Running this "beeps_master" do file should produce all tables for which no further data is required in addition to the data in the data folder (tables
	A3 and A4 are produced by table_3.do and table4.do respectively)
* To use the dofiles a general directory has to be specified in global dir, with subdirectories "data" (for the raw data), "dofiles" (for the dofiles),
	"tables" (for the output) and "logs" (for the logfiles).
* The principal source of Data is the BEEPS survey from the EBRD (raw data provided in cleaned1999.dta, cleaned2002.dta and cleaned2005.dta;
	1999 data is not used for the paper). The paper also uses additional economic data from the EBRD as well as from the World Bank (Doing Business database)
	Bureau van Dijk's Amadeus database and the World Development indicators. Where possible, the data is included. If that was not possible due to copyright
	restrictions, the relevant do file contains a note on where to find the data and on how it was prepared for use in the paper.
* All do files were run on Stata release 10.1. The do files make use of ivreg2 (Baum, Schaffer and Stillman, 2007), version 2.2.08, 15 October 2007 and outreg2 (Wada, 2009), version 2.1.3,
	21 October 2009.
* The Instrumental Variables / GMM estimates also use two additional ado files. "tests.ado" generates a file with the test-statistics reported in the lower
	part of the tables, including the J-test (J, J-pvalue), the Durbin-Wu-Hausman test (H, H-pvalue) and the first stage F-statistics. for the J-test,
	tests.ado makes a degrees of freedom adjustment. The matrix of excluded instruments includes interactions between region and skill ratio and region and
	the skill-ratio-age interaction. Stata "counts" this as six instruments while for any given firm, four of the instruments are always zero (e.g. a firm
	in the CIS region has a zero skill-ratio for the CEB and SEE regions). Rather than using the degrees of freedom counted by Stata, tests.ado uses the
	number of degrees of freedom provided in the command line to calculated the p-value of the J-statistic. tests.ado also calls a second ado file,
	"robust_hausman.ado". This file implements a regression-based version of the Durbin-Wu-Hausman test for endogeneity (see e.g. Wooldridge, 2002) while
	allowing for heterogeneity of and clustering in the standard errors.

*/

clear
cap log close
set more off
set mem 300m
set seed 123456789


global dir     = "XXX"
global data    = "data"
global dofiles = "dofiles"
global tables  = "tables"
global logs  = "logs"

cd "$dir"


/* data */

do $dofiles/data.recoding.do
/* recodes data from different waves of the BEEPS survey and gives variables consistent names (numbering of questions varies across surveys) */
do $dofiles/data.merging.do
/* merges additional (country level) data into the file; the data are drawn from the EBRD transition indicators, economic indicators and structural
	change indicators */
do $dofiles/data.panel.do
/* identifies the firms that are part of the panel surveyed both in 2002 and 2005 */
do $dofiles/data.final_data.do
/* creates the final set of variables to be used in the analyses */

/* tables */

do $dofiles/table_1.do
do $dofiles/table_2.do
do $dofiles/table_3.do
do $dofiles/table_4.do
do $dofiles/table_5.do
do $dofiles/table_6.do
do $dofiles/table_7.do
do $dofiles/table_8.do
do $dofiles/table_9.do

do $dofiles/table_A1.do
do $dofiles/table_A2.do
do $dofiles/table_A5.do
do $dofiles/table_A6.do
do $dofiles/table_A7.do
do $dofiles/table_A8.do

