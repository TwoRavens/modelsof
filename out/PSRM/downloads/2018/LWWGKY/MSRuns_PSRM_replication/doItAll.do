/*
	This file creates the published tables and figures Winter, Hughes, and Sanders, 
	"Online Coders, Open Codebooks: New Opportunities for Content Analysis of Political Communication"
	Political Science Research & Methods (forthcoming)

	This file creates all the tables and figures for the paper. It runs under Stata/SE or Stata/MP version 15.1

	All data are included here *except* the Wesleyan Media Project (WMP) Ad-coding data for 2010,
	which are subject to a data-use agreement.  The WMP data can be obtained from
	http://mediaproject.wesleyan.edu/dataaccess/ 

	The WMP file wmp-federal-2010-v1.3.dta should be put in the "rawData" subdirectory.
*/

// --------------------------------------------------------
// Initial setup and housekeeping
// --------------------------------------------------------
clear *

// Stata dependencies not provided in StataUtilities [from SSC]
// ssc install listtab
// ssc install kappaetc

// set MakeData to * to skip recreating datasets
global MakeData 

// set calculateReliability to '*' to skip the time-consuming calculation of reliability statistics
//		(only useful if re-running this code after calculating them once)
global calculateReliability 
if "$calculateReliability"=="" & `c(SE)'==1 {
	set maxvar 20000 	// reliability calculations involve WIIIIIIIDE reshape, so this speeds things up
}

// fontface used by XeLaTex and by Stata for graphs [any system TTF should work]
global FontFace Times New Roman

// This global has the path to the Wesleyan Media Project 2010 dataset for federal races.
// It is subject to a data-use agreement so is not provided as part of this replication archive.
// It can be obtained from: http://mediaproject.wesleyan.edu/dataaccess/data-access-2010/
global CMAGDataFile rawData/wmp-federal-2010-v1.3.dta

// set to 1 for old-style-numerals in figure (must have Adobe Pro font and Inkscape installed); 
// set to 0 for regular numerals
global useOldStyleNumerals 0
graph set window fontface "$FontFace"

// Add Stata utilities directory to adopath so Stata can find utility programs
adopath ++ "`c(pwd)'/StataUtilities"

// --------------------------------------------------------
// END of initial setup and housekeeping
// --------------------------------------------------------

// make sure (empty) subdirectories exist
foreach dir in auxds auxSyntax dataSets latexOutput latexOutput/plots {
	makedir `dir'
}

// graph scheme provided in StataUtilities/scheme-nwpsrm.scheme
set scheme nwpsrm

local loglist latexOutput/MsTables.tex latexOutput/MsFigures.tex latexOutput/MsAppendixTables.tex latexOutput/MsAppendixFigures.tex
foreach file in `loglist' {
	capture erase "`file'"
}

//master list of coding variables for analysis
global codevl flag mention1Fc mention1Oc ecAppeal etPositive etNegative emEnthusiasm emFear emAnger emDisgust em1Enthusiasm em1Fear em1Anger em1Disgust tFcComp tFcLeader tFcInteg tFcEmpathy tOcComp tOcLeader tOcInteg tOcEmpathy ideologyFc ideologyOc  

// --------------------------------------------------------
//  Construct datasets
// --------------------------------------------------------
$MakeData do makeData

// ------------------------------------------------------------------
// Table 1 (list of coding items)
copy rawLatexAndImages/codingTable.tex latexOutput/, replace

// ------------------------------------------------------------------
// Figure 1 (coding interface image)
copy rawLatexAndImages/codingInterface.pdf latexOutput/plots/codingInterface.pdf, replace
latexfigure plots/codingInterface.pdf, log("`:word 2 of `loglist''") append caption("Coding Interface") precaption width(6.25in)

// ------------------------------------------------------------------
// Tables 2 & 3 - reliability summaries; also appendix reliability detail tables
do T23_reliabilityTables `loglist'

// ------------------------------------------------------------------
// Figure 2 - item-level reliability 
do F2_reliabilityFigure `loglist'

// ------------------------------------------------------------------
// Table 4 - validity 
do T4_validityTable `loglist'										

// ------------------------------------------------------------------
// More appendix tables
do Tx_mseTable `loglist'					// MSE reliability 
do Tx_reliabilityCongerTable `loglist'		// Conger's Kappa reliability 
do Tx_metaGainSummary `loglist'		        // Aggregation gain 
do Tx_otherAppendixRuns `loglist'			// miscellaneous analyses
do Tx_flagFiguresForAppendix `loglist'

// ------------------------------------------------------------------
// Additional numbers that appear in the text
do additionalNumbersInText

cd latexOutput
// combine main-text tables and figures and texify
local texfiles codingTable.tex || MsTables.tex || MsFigures.tex
wraplatex MsTF.tex, replace addfiles(`texfiles') osn fface($FontFace) pagenumbers
dolatex MsTF.tex, replace 

// combine appendix tables and figures and texify
local texfiles MsAppendixTables.tex || MsAppendixFigures.tex
wraplatex MsTF_appx.tex, replace addfiles(`texfiles') osn appendix fface($FontFace) pagenumbers
dolatex MsTF_appx.tex, replace twolatex
