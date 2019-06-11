/*
	Project: The growing importance of social skills in the labor market (2017)
	Author: David Deming
	Date Created: May 2017
	
	Description: Master do file that runs all programs for the project,
		including data cleaning and results
*/


version 14
clear all
set more off


**** Define macros ****

global topdir "YOURFILEPATH/Deming_2017_SocialSkills_Replication"
local dodir "${topdir}/Do"

local rawdir "${topdir}/Data/census-acs/raw"
local cleandir "${topdir}/Data/census-acs/clean"
local collapdir "${topdir}/Data/census-acs/collapsed" 
local occdir "${topdir}/Data/census-acs/xwalk_occ"
local inddir "${topdir}/Data/census-acs/xwalk_ind"

local onetdir "${topdir}/Data/onet"
local txtdir "${topdir}/Data/onet/text_files"
local dotdir "${topdir}/Data/dot"

local nlsydir "${topdir}/Data/nlsy"
local import79dir "${topdir}/Data/nlsy/import/nlsy79"
local import97dir "${topdir}/Data/nlsy/import/nlsy97"
local name79 "socskills_nlsy79_final"			/* Name of NLSY79 extract */
local name97 "socskills_nlsy97_final"			/* Name of NLSY97 extract */
local afqtadj "${topdir}/Data/nlsy/altonjietal2012"

local figdir "${topdir}/Results/figures"
local tabdir "${topdir}/Results/tables"


**** Run do files ****

* O*NET: Import O*NET data and create composites
do "`dodir'/1-onet_import.do"

* Census-ACS: Clean and prepare the Census and ACS data for analysis
*	NOTE: Raw Census-ACS files are omitted from replication package
*	due to large file size, so this section of the code cannot be run
*	without first downloading the data and reading it into Stata.
*	See README file for instructions on obtaining Census-ACS data
*	from the IPUMS USA website.
*do "`dodir'/2-census_acs_cleaning.do"

* Census-ACS: Run Census-ACS analysis to 
* 	NOTE: Creates Figures 1, 3, 4, 5, A1, A2, A3, A4; Tables A1, A5, A6
do "`dodir'/3-census_acs_analysis.do"

* NLSY: Cleans NLSY79 and NLSY97 data and runs the analysis 
*	NOTE: Creates Tables 1, 2, 3, 4, 5, A2, A3, A4
do "`dodir'/4-nlsy.do"



