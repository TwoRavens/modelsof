/*--------------------------------------------------------------------HC_main.do
Main control file for HCCI cleaning and analysis
	
Stuart Craig
Project origin 	20140327
Forked on 		20171209
Last updated 	20180816
*/

/*
---------------------------------------------

Setting environment variables

---------------------------------------------
*/

	// Directory pointers
	global rootdir "E:\users/Stuart\var_v2"
	global rdHC "${rootdir}/rawdata"
	global ddHC "${rootdir}/deriveddata"
	global scHC "${rootdir}/statacode"
	global  oHC "${rootdir}/output"
	global  tHC "${rootdir}/temp"
	
	// User written commands and color globals
	adopath + ${scHC}/ado
	environment_vars
	
	// Set output preferences
	set scheme isps_health, perm
	set more off, perm
	graph set window fontface "Times"

	
/*
---------------------------------------------

Data prep: This file assumes the construction
of raw enrollment, spending summary, and
episode files. The below files construct
risk adjusted spending measures, hospital-
level extracts, and episode-level files
with identified contract measures. 

---------------------------------------------
*/
	
	// Risk adjusted SPB data
	do ${scHC}/HC_raw_spbdata.do
	// Do it again restricting to 55-64 year olds
	do ${scHC}/HC_raw_spbdata_55plus.do
	
	// Create hospital-level extracts here
	do ${scHC}/HC_hdata.do
	
	// Create contract-identified files
	do ${scHC}/HC_cdata.do
	
/*
---------------------------------------------

Main Tables and Figures

---------------------------------------------
*/

// Tables:
	
	// Provider/Patient Characteristics (Table I)
	do ${scHC}/HC_rev_dstat_provpatchar.do
	
	// Price/Quantity Decomposition (Table II, and Appendix Tables V-VIII)
	do ${scHC}/HC_rev_pqdecomp.do
	
	// Price Variation Decomposition (Table III)
	do ${scHC}/HC_rev_dstat_pricedecomp.do
	
	// Cross Sectional Regressions (Table IV)
		// Panel A (and Appendix Tables X and XIV Panel A)
		do ${scHC}/HC_rev_crosssec_price.do
		// Panel B (and Appendix Table XI and XIV Panel B)
		do ${scHC}/HC_rev_crosssec_contract.do
		// Panel C (and Appendix Table XII)
		do ${scHC}/HC_rev_crosssec_medanchor.do
	
	// Merger Regressions (Table V)
	do ${scHC}/HC_rev_merger_main.do
	
// Figures: 

	// Summarize Prices/Charges/Medicare for All Procedures (Figure I)
	do ${scHC}/HC_rev_dfig_pricelevel.do

	// Maps (Figure II and Appendix Figures IV and V) 
	do ${scHC}/HC_rev_dfig_mapdata.do
	
	// National Variation Figure (Figure III and Appendix Figure VI)
	do ${scHC}/HC_rev_dfig_natvar.do
	
	// Within Market Figures (Figure IV)
	do ${scHC}/HC_rev_dfig_withinmkt.do
	
	// MRI Contract Illustration (Figure V)
	do ${scHC}/HC_rev_dfig_mricontracts.do
	
	// Vaginal Delivery Contracts (Figure VI)
	do ${scHC}/HC_rev_dfig_delvcontracts.do
	
	// Illustrate the Contract Types by Procedure (Figure VII)
	do ${scHC}/HC_rev_dfig_contractclass.do
	
	// Illustrate Medicare Bunching (Figure VIII)
	do ${scHC}/HC_rev_dfig_medbunching.do
	
	// Bivariate Correlations with Price (Figure IX and Appendix Figures XII and XIII)
	do ${scHC}/HC_rev_dfig_bivariatecorr.do
	
	// Merger Event Studies (Figure X)
	do ${scHC}/HC_rev_merger_eventstudy.do
	
/*
---------------------------------------------

Additional Appendix Work

---------------------------------------------
*/

// Tables:

	// Total Spending Table (Appendix Table I)
	do ${scHC}/HC_rev_dstat_rawcounts.do
	
	// Sample Comparison with AHA (Appendix Table II)
	do ${scHC}/HC_rev_dstat_ahacompare.do
	
	// Correlation of Prices Across Procedures (Appendix Table IV)
	do ${scHC}/HC_rev_dstat_pricecorr.do
	
	// Prices in Top 25 Most Populated HRRs (Appendix Table IX)
	do ${scHC}/HC_rev_dstat_top25hrr.do
	
	// Cross-sectional Price Regressions with Alt. Price Measures (Appendix Tables XIII and XXI)
	do ${scHC}/HC_rev_crosssec_price_altmeasures.do
	do ${scHC}/HC_rev_crosssec_price_levels.do
	
	// Cross-sectional Price Regressions with Physician Payments (Appendix Table XV)
	do ${scHC}/HC_rev_crosssec_price_plusphy.do
	
	// Cross-sectional Regressions with Alternate Measures of Concentration
		// Price (Appendix Table XVI)
		do ${scHC}/HC_rev_crosssec_price_comp.do
		// Contract Form (Appendix Table XVII)
		do ${scHC}/HC_rev_crosssec_contract_comp.do
		// Medicare Link (Appendix Table XVIII)
		do ${scHC}/HC_rev_crosssec_medanchor_comp.do
	
	// Cross-sectional Price Regressions with Quality Measure Controls (Appendix Table XIX)
	do ${scHC}/HC_rev_crosssec_quality.do
		
	// Cross-sectional Regressions with Alternate Samples (Appendix Table XX)
		// Price (Columns 1 and 2)
		do ${scHC}/HC_rev_crosssec_price_altsample.do
		// Contract (Columns 3 and 4)
		do ${scHC}/HC_rev_crosssec_contract_altsample.do
		// Medicare Link (Columns 5 and 6)
		do ${scHC}/HC_rev_crosssec_medanchor_altsample.do
	
	// Transactions/Targets/Acquirer Counts by Distance (Appendix Table XXII)
	do ${scHC}/HC_rev_merger_counts.do
	
	// Characteristics of Merging/Non-Merging Hospitals (Appendix Table XXIII)
	do ${scHC}/HC_rev_merger_dstatmeans.do
	
	// Robustness of Merger Specifications (Appendix Table XXIV)
		// Log-linear/Targets vs. Acquirers/Baseline (Panels A, B, H)
		do ${scHC}/HC_rev_merger_altspec.do
		// Matching (Panels C-F)
		do ${scHC}/HC_rev_merger_match.do
		// Count Restrictions (Panel G)
		do ${scHC}/HC_rev_merger_countrestrict.do

	// BCBS Robustness (Appendix Tables XXV-XXX)
	do ${scHC}/HC_rev_bcbsrobust_all.do
	
// Figures:
	
	// Merger Counts by Year (Appendix Figure I)
	do ${scHC}/HC_rev_dfig_mergercount.do
	
	// Correlation Between Price and Charge (Appendix Figure III)
	do ${scHC}/HC_rev_dfig_chargecompare.do
	
	// Contract Classification Rates and Minimum Count Restrictions (Appendix Figure VIII)
	do ${scHC}/HC_rev_dfig_contractrest.do
	
	// Percent of Hospital Paid as Share of Charges (Appendix Figure IX)
	do ${scHC}/HC_rev_dfig_hospptcdist.do
	
	// Price-to-Charge Bunching (Appendix Figure X)
	do ${scHC}/HC_rev_dfig_ptcbunching.do
	
	// Bivariate Correlations of Concentration (Appendix Figure XI)
	do ${scHC}/HC_rev_dfig_compcorr.do
	
	// Merger Coefficient by Distance (Appendix Figure XIV)
	do ${scHC}/HC_rev_merger_everymile.do
	
	
exit
