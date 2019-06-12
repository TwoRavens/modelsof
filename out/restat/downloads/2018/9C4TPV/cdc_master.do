*************************************************************
*************************************************************
** Working with the raw Multiple Cause of Death Data
*************************************************************
*************************************************************

clear
set more off

/* read in the data */
local read_in_data = 0
/* combine years of full data */
local combine_data = 0
/* Isolate drug poisoning deaths */
local drug_deaths =0
/* clean up covariates for predicting unclassified deaths */
local clean_vars = 0
/* create a time series dataset with types of deaths */
local make_ts_dataset = 0
/* create a panel dataset with types of deaths */
local make_panel_dataset = 0
/* create version of dataset used in panel analysis */
local analysis_maker = 0
/* predicting uncategorized deaths */
local predicting = 0

if `read_in_data' == 1 {
	do ./read_in_data.do
}
if `combine_data' == 1 {
	do ./combine_data.do
}
if `drug_deaths' == 1 {
	do ./drug_deaths.do
}
if `clean_vars' == 1 {
	do ./clean_vars.do
}
if `make_ts_dataset' == 1 {
	do ./make_ts_dataset.do
}
if `make_panel_dataset' == 1 {
	do ./make_panel_dataset.do
}
if `analysis_maker' == 1 {
	do ./analysis_maker.do
}
if `predicting' == 1 {
	do ./predicting.do
}

