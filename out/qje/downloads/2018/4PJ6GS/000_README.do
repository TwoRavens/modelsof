/*=====================================================================================

 README.do: 
	
	Sets program parameters and executes all other do-files.
		   
		The program uses the following ado-files:
		- winsor
		- tabmiss
		- outreg2
		- ivreg2
		- reghdfe
		
	Lorenz Kueng, September 2017
		
=======================================================================================*/


********************************************************************************
********************************************************************************
*** Set program parameters
********************************************************************************
********************************************************************************

* Dropbox directory

	capture cd "E:/Dropbox"              // desktop
	capture cd "C:/Users/lku998/Dropbox" // laptop

	global dropbox = c(pwd)


* Home/Project directory

	capture cd "$dropbox/Research/Lorenz/AlaskaPermanentFund"
	capture cd "/oplcusers/kuengl2" // home directory on BLS server

	global homedir = c(pwd)
	
	cap n mkdir "log-files"
	cap n mkdir "results"
	cap n mkdir "results/figures"
	cap n mkdir "results/tables"


* Data directories

	global PFWdata = "..." // Personal Finace Website (PFW) data
	global CEdata  = "..." // Consumer Expenditure Survey (CE) data
	if "$homedir"=="/oplcusers/kuengl2"	{ // BLS server
	  global CEdata "/oplcusers/kuengl2/CE_publicuse"    
	}


* Point output to vetting folder when working at the BLS

	if "$homedir"=="/oplcusers/kuengl2" {
		global OutputLocation "$homedir/vetting/fromBLS/results/tables"
	}
	else {
		global OutputLocation "$homedir/results/tables"
	}


* Set Stata's parameters

			set matsize 800
	cap n:  set matsize 11000 // NOTE: At BLS, max matsize is 800 for Stata/IC (while for Stata/MP it's 11000)
	set emptycells drop

	version 12
	set seed 0123456789
	set more off, permanently
	clear all
	clear matrix
	clear mata
	set linesize 255

	cap adopath + "C:\ado" // ado file location
	cap adopath ++ "/oplcusers/kuengl2/do-files/ado" // ado file location on BLS server
	cap adopath ++ "/oplcusers/kuengl2/ado"          
	cap adopath ++ "/oplcusers/kuengl2/ado/personal" 
	cap adopath ++ "/oplcusers/kuengl2/ado/plus"     
	cap adopath ++ "/oplcusers/kuengl2/ado/stbplus"  

	local  date: display %td_CCYY_NN_DD date(c(current_date), "DMY")
	global date = subinstr(trim("`date'"), " " , "-", .) // to save files by date




********************************************************************************
********************************************************************************
*** Analysis 
********************************************************************************
********************************************************************************

cd "$homedir/do-files"


*---------------------------------------------------------
* Analysis of Google Searcch data
*---------------------------------------------------------

	do "GoogleTrends_Searches_for_APFD_2004-2017.do" 


*---------------------------------------------------------
* Plot PFD and expected PFD and save to merge with CE data
*---------------------------------------------------------

	do "PFD_01_payments.do"
	do "PFD_02_news_narrative.do"
	do "PFD_03_news_sni.do"
	do "PFD_04_independence_from_local_economy.do"

	
*---------------------------------------------------------
* Analysis using PFW data
*---------------------------------------------------------

	/* NOTE: This uses confidential data from a Personal Finance Website that cannot be shared
	
	do "PFW_01_LiquidAssets.do"
	do "PFW_02_TxnData.do"
	do "PFW_03a_SummaryStatistics_quarterly.do"
	do "PFW_03b_ACS-2010to14-household_income_distribution.do"
	do "PFW_03c_Impute-before-tax-income-in-PFW.do"
	do "PFW_04a_Dynamics_monthly_nonparametric.do"
	do "PFW_04b_Dynamics_monthly_parametric.do"
	do "PFW_06_PFW_vs_CEX_quarterly.do"
	do "PFW_07a_Heterogeneity_quarterly.do"
	do "PFW_07b_Heterogeneity_Size_vs_Liquidity_quarterly.do"
	do "PFW_08_AverageMarginalTaxRate_monthly.do"
	do "PFW_09_Robustness_quarterly.do"
	do "PFW_10_IncomeProcess.do"
	*/

*---------------------------------------------------------
* Analysis using CE data
*---------------------------------------------------------

	/* NOTE: This uses confidential data available at the BLS that cannot be shared
	
	do "CE_01_Alaskans_BLS.do"
	do "CE_02_BaselineData.do"
	do "CE_03_SummaryStatistics.do"
	do "CE_04_PaymentResponse_MPC.do"
	do "CE_05a_Hsieh_Data.do"
	do "CE_05b_Hsieh_Analysis.do"
	*/

*---------------------------------------------------------
* Analysis of Inattentive PIH Consumers (for Online Appendix)
*---------------------------------------------------------

	do "MPC_InattentionPIH.do"


