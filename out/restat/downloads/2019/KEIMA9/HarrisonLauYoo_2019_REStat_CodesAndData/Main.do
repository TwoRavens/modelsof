//================================================
// For all Stata users: Initialize Stata settings
//================================================
clear all
mata: mata clear 
macro drop _all
program drop _all
capture log close _all

set rmsg on
set more off
set scheme s1color
graph set window fontface "Garamond"

//============================================================
// For Stata MP users: Choose the number of processors to use
//============================================================
// Choose the number of processors
capture noi set processors 4

//==================================================
// FOR all Stata users: Choose the type of analysis
//==================================================
// Choose type of analysis by replacing TEXT in -global type = "TEXT"- with one of the following.
// 	CRRA:      Estimate EUT models with CRRA utility 
// 	CRRA1PRE:  Estimate RDU models with CRRA utility and 1-parameter Prelec PWF 
// 	TABLES:	   Produce tables of estimation results
//	GRAPHS:	   Generate graphs
global type = "CRRA"

//========================================================================
// NO FURTHER USER INPUT IS NEEDED: The program runs on its own hereafter
//========================================================================

// Generate folder to hold estimation results
capture mkdir Results
capture mkdir Tables
capture mkdir Tables\Fechner
capture mkdir Tables\Context
capture mkdir Graphs
capture mkdir Graphs\Fechner
capture mkdir Graphs\Context

// Load likelihood evaluators 
qui do Programs\MataFunctions_RA.do

// Load -MSLinit- command to initialise MSL estimation settings 
qui do Programs\MSLinit.do

// Load -MSLdisplayN-, -MSLdisplayY- and -MSLdisplayA- commands to carry out post-estimation analysis (N for no selection, Y for full selection, A for attrition only)
qui do Programs\MSLdisplayN.do
qui do Programs\MSLdisplayY.do
qui do Programs\MSLdisplayA.do

//---------------------------------
// Estimate EUT models 
//---------------------------------
if "${type}" == "CRRA" {
	//--------------------------------------------------------
	// Model specification for Tables C1 and C3, and Figure 1
	//--------------------------------------------------------	
	// Spec C1: EUT with CRRA + contextual utility + Observed heterogeneity w.r.t. order & stake treatments 
	log using Results\Analysis_RA_CRRA_context.log, text 
	set seed 987654321
	about
	creturn list
	do Programs\Analysis_RA_CRRA_context.do
	log close

	//-----------------------------------------------------------------------------------
	// Model specification for Table C5: 
	// (Note: Table C5 reports Spec C2_II. Spec C2 is used as starting values for C2_II)
	//-----------------------------------------------------------------------------------		
	// Spec C2: EUT with CRRA + contextual utility + Observed heterogeneity w.r.t. order, stake treatment, and recruitment fee
	log using Results\Analysis_RA_CRRA_context_CondOnFee.log, text 
	set seed 987654321
	about
	creturn list
	do Programs\Analysis_RA_CRRA_context_CondOnFee.do
	log close
	
	// Spec C2_II: EUT with CRRA + contextual utility + Observed heterogeneity w.r.t. order, stake treatment, and recruitment fee.
	//			   Now use recruitment fee in the second stage selection equation as well.
	log using Results\Analysis_RA_CRRA_context_CondOnFee2.log, text 
	set seed 987654321
	about
	creturn list
	do Programs\Analysis_RA_CRRA_context_CondOnFee2.do
	log close	

	//----------------------------------
	// Model specification for Table C7
	//----------------------------------	
	// Spec CA1: EUT with CRRA + contextual utility + Observed heterogeneity w.r.t. order & stake treatments
	//			 Assume exogenous selection into first experiment and correct for panel attrition
	log using Results\Analysis_RA_CRRA_context_AttOnly.log, text 
	set seed 987654321
	about
	creturn list
	do Programs\Analysis_RA_CRRA_context_AttOnly.do
	log close		
	
	//----------------------------------
	// Model specification for Table E1
	//----------------------------------	
	// Spec C3: EUT with CRRA + contextual utility  + Observed heterogeneity w.r.t. gender
	log using Results\Analysis_RA_CRRA_female_context.log, text 
	set seed 987654321
	about
	creturn list
	do Programs\Analysis_RA_CRRA_female_context.do
	log close				
	
	//---------------------------------------------------------
	// Model specification for Tables F1 and F3, and Figure F1
	//---------------------------------------------------------
	// Spec V1: EUT with CRRA + Fechner errors + Observed heterogeneity w.r.t. order & stake treatments 
	log using Results\Analysis_RA_CRRA.log, text 
	set seed 987654321
	about
	creturn list
	do Programs\Analysis_RA_CRRA.do
	log close

	//-----------------------------------
	// Model specification for Figure F6
	//-----------------------------------
	// Spec V3: EUT with CRRA + Fechner errors + Observed heterogeneity w.r.t. gender
	log using Results\Analysis_RA_CRRA_female.log, text 
	set seed 987654321
	about
	creturn list
	do Programs\Analysis_RA_CRRA_female.do
	log close		
}

//---------------------------------------------
// Estimate RDU models with 1-parameter Prelec 
//---------------------------------------------
if "${type}" == "CRRA1PRE" {
	//---------------------------------------------------------------------
	// Model specification for Tables C2 and C4, and Figures 2, 3, 4 and 5
	//---------------------------------------------------------------------	
	// Spec C1: RDU with CRRA1PRE + contextual utility + Observed heterogeneity w.r.t. order & stake treatments 
	log using Results\Analysis_RA_CRRA1PRE_context.log, text 
	set seed 987654321
	about
	creturn list
	do Programs\Analysis_RA_CRRA1PRE_context.do
	log close

	//-----------------------------------------------------------------------------------
	// Model specification for Table C6
	// (Note: Table C6 reports Spec C2_II. Spec C2 is used as starting values for C2_II)
	//-----------------------------------------------------------------------------------	
	// Spec C2: RDU with CRRA + contextual utility + Observed heterogeneity w.r.t. order, stake treatment, and recruitment fee	
	log using Results\Analysis_RA_CRRA1PRE_context_CondOnFee.log, text 
	set seed 987654321
	about
	creturn list
	do Programs\Analysis_RA_CRRA1PRE_context_CondOnFee.do
	log close	
	
	// Spec C2_II: RDU with CRRA + contextual utility + Observed heterogeneity w.r.t. order, stake treatment, and recruitment fee
	//			   Now use recruitment fee in the second stage selection equation as well.	
	log using Results\Analysis_RA_CRRA1PRE_context_CondOnFee2.log, text 
	set seed 987654321
	about
	creturn list
	do Programs\Analysis_RA_CRRA1PRE_context_CondOnFee2.do
	log close		
	
	//----------------------------------
	// Model specification for Table C8
	//----------------------------------
	// Spec CA1: RDU with CRRA1PRE + contextual utility + Observed heterogeneity w.r.t. order & stake treatments 
	//			 Assume exogenous selection into first experiment and correct for panel attrition	
	log using Results\Analysis_RA_CRRA1PRE_context_AttOnly.log, text 
	set seed 987654321
	about
	creturn list
	do Programs\Analysis_RA_CRRA1PRE_context_AttOnly.do
	log close		
	
	//------------------------------------------------
	// Model specification for Table E2 and Figure E1
	//------------------------------------------------
	// Spec C3: RDU with CRRA1PRE + contextual utility + Observed heterogeneity w.r.t. gender
	log using Results\Analysis_RA_CRRA1PRE_female_context.log, text 
	set seed 987654321
	about
	creturn list
	do Programs\Analysis_RA_CRRA1PRE_female_context.do
	log close			
	
	//-------------------------------------------------------------------------
	// Model specification for Tables F2 and F4, and Figures F2, F3, F4 and F5
	//-------------------------------------------------------------------------
	// Spec V1: RDU with CRRA1PRE + Fechner errors + Observed heterogeneity w.r.t. order & stake treatments 
	log using Results\Analysis_RA_CRRA1PRE.log, text 
	set seed 987654321
	about
	creturn list
	do Programs\Analysis_RA_CRRA1PRE.do
	log close

	//-----------------------------------
	// Model specification for Figure F6
	//-----------------------------------	
	// Spec V3: RDU with CRRA1PRE + Fechner errors + Observed heterogeneity w.r.t. gender
	log using Results\Analysis_RA_CRRA1PRE_female.log, text 
	set seed 987654321
	about
	creturn list
	do Programs\Analysis_RA_CRRA1PRE_female.do
	log close		
}

//---------------------------------------------
// Generate tables of estimation results 
//---------------------------------------------
if "${type}" == "TABLES" {
	// Initialize post-estimation results production by loading the estimation sample
	do Programs\Tables_RA_Init.do
	
	//--------------------------------------
	// Produce results for Tables C1 and C3
	//--------------------------------------	
	// Tables for EUT C1: CRRA + contextual utility + Observed heterogeneity w.r.t. order & stake treatments 
	do Programs\Tables_RA_CRRA_context.do

	//--------------------------------------
	// Produce results for Tables C2 and C4
	//--------------------------------------		
	// Tables for RDU C1: CRRA1PRE + contextual utility + Observed heterogeneity w.r.t. order & stake treatments
	do Programs\Tables_RA_CRRA1PRE_context.do
		
	//------------------------------
	// Produce results for Table C5
	//------------------------------
	// Tables for EUT C2_II: CRRA + contextual utility + Observed heterogeneity w.r.t. order & stake treatments and show-up fee
	do Programs\Tables_RA_CRRA_context_CondOnFee2.do
	
	//------------------------------
	// Produce results for Table C6
	//------------------------------	
	// Tables for RDU C2_II: CRRA1PRE + contextual utility + Observed heterogeneity w.r.t. order & stake treatments and show-up fee
	do Programs\Tables_RA_CRRA1PRE_context_CondOnFee2.do		

	//------------------------------
	// Produce results for Table C7 
	//------------------------------			
	// Tables for EUT CA1: EUT C1 but only correct for attrition bias  
	do Programs\Tables_RA_CRRA_context_AttOnly.do
	
	//------------------------------
	// Produce results for Table C8 
	//------------------------------	
	// Tables for RDU CA1: RDU C1 but only correct for attrition bias  
	do Programs\Tables_RA_CRRA1PRE_context_AttOnly.do		
	
	//------------------------------
	// Produce results for Table E1 
	//------------------------------	
	// Tables for EUT C3: CRRA + contextual utility + Observed heterogeneity w.r.t. gender
	do Programs\Tables_RA_CRRA_female_context.do

	//------------------------------
	// Produce results for Table E2
	//------------------------------	
	// Tables for RDU C3: CRRA1PRE + contextual utility + Observed heterogeneity w.r.t. gender
	do Programs\Tables_RA_CRRA1PRE_female_context.do

	//--------------------------------------
	// Produce results for Tables F1 and F3
	//--------------------------------------
	// Tables for EUT V1: CRRA + Fechner errors + Observed heterogeneity w.r.t. order & stake treatments 
	do Programs\Tables_RA_CRRA.do

	//--------------------------------------
	// Produce results for Tables F2 and F4
	//--------------------------------------	
	// Tables for RDU V1: CRRA1PRE + Fechner errors + Observed heterogeneity w.r.t. order & stake treatments
	do Programs\Tables_RA_CRRA1PRE.do	
}

//---------------------------------------------
// Generate graphs
//---------------------------------------------
if "${type}" == "GRAPHS" {
	// Graphs for models with Fechner errors
	do Programs\Graphs_RA_All.do
	
	// Graphs for models with contextual utility
	do Programs\Graphs_RA_All_context.do
}

exit
