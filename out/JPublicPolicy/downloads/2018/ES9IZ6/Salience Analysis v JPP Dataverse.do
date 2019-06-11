clear all
version 13
set more off, permanently
macro drop _all
cd "C:\Dropbox\@@@ Shared @@@\Becky Projects\Public Opinion and Global Warming\Work\Analysis - JPP"
*log using "temp log.smcl", replace
*capture log close

// *******************************************************************
//	File Name:	salience analysis for JOP_1.do
//	Date:   	Dec 16, 2013 - last modified September 16, 2018
//	Author: 	John Poe			
//	Purpose:	Updating dataset with new variables and cleaning existing
//	Contact: 	John Poe - jdpo223@g.uky.edu for issues
// *******************************************************************

********************************************************************************
*** Data Set 
***		This data has remained unchanged since the SPPQ submission
********************************************************************************
	use "salience_vJPP(6-29-2018)", replace

********************************************************************************
***	Macros and variable lists
***		This section is just scooping up variables for the variable lists later
***		It's pretty sloppy but oh well
********************************************************************************
	global y total_enact_fixed
	global basic citi_ideo gov_ideo_nom legprofess percap
	global controls sierraclub_means c.index_means_rescale opinion1c_mean
	global salience c.sierraclub internet c.index_rescale_demean c.opinion1c
	global newvars i.leg##i.govparty index_rescale_demean Dunemployment diffusion l_level_fixed
	global additional manufacturing mining EngOutput
	global newvars2 i.leg i.govparty_c percap Dunemployment diffusion l_level_fixed
	
********************************************************************************
*** Figure 1: Diagram of Theoretical Causal Mechanisms 
***		Made in Powerpoint
********************************************************************************

*** Just a diagram built in powerpoint

********************************************************************************
***	Figure 2: Total # of Enactments by Policy as of 2010
***		Becky's standard figure made in R
********************************************************************************

*** Graphic from paper built in R
use "data for figure 2- total enact by policy 2010 graph.dta"
graph dot (sum) enact, over(policy, sort(enact) descending) ylabel(15(5)40)
use "salience_vJPP(6-29-2018)", replace

********************************************************************************
*** Figure 3: Policy Enactments by State and Year
***		My windowpane plot of 49 states
********************************************************************************
twoway (line total_enact_fixed year) if state !="nebraska", 					///
		ytitle(, color(%0)) 													///
		xtitle(, color(%0)) 													///
		by(, note(, size(zero) 													///
		color(%0))) 															///
		by(state, cols(7))

********************************************************************************
*** Figure 4: Google Trends vs Lagged Google Trends
*** 	just a line plot made with the sol scheme
********************************************************************************

twoway (qfit $y L1.index_rescale) (qfit $y index_rescale), scheme(sj)

nbreg $y $basic $newvars $salience sierraclub_opinion1c_interaction, vce(cluster state)
twoway (qfit predictedoutcomes L1.index_rescale) (qfit predictedoutcomes index_rescale), scheme(sj)


********************************************************************************
*** Figure 5: Marginal Effect of Issue Salience on Policy Adoption
********************************************************************************
set scheme sol
gnbreg $y $basic $newvars sierraclub_graph index_rescale_graph opinion1c_graph, vce(cluster state)
	margins, at(sierraclub_graph=(0(5)100)) saving(file1, replace)
		marginsplot, recast(line) recastci(rscatter) xlabel(0(100)100) ylabel(, nogrid) ytitle("") title(Sierra Club Membership) xtitle("")
		graph save file1.gph, replace
	margins, at(index_rescale_graph=(0(5)100)) saving(file2, replace)
		marginsplot , recast(line) recastci(rscatter) xlabel(0(100)100) ylabel(, nogrid) ytitle("") title(Issue Attention: Google Trends) xtitle("")
		graph save file2.gph, replace
	margins, at(opinion1c_graph=(0(5)100)) saving(file3, replace)
		marginsplot, recast(line) recastci(rscatter) xlabel(0(100)100) ylabel(, nogrid) ytitle("") title(Issue Concern: Survey Questions) xtitle("")
		graph save file3.gph, replace
	gnbreg $y $basic $newvars opinion1c_graph green_graph, vce(cluster state)
		margins, at(green_graph=(0(5)100)) saving(file4, replace)
		marginsplot, recast(line) recastci(rscatter) xlabel(0(100)100) ylabel(, nogrid) ytitle("") title(Issue Attention and Sierra Club Membership) xtitle("")
		graph save file4.gph, replace
	gnbreg $y $basic $newvars2 $salience, vce(cluster state)	
		margins i.leg
		marginsplot, recast(line) recastci(rarea) xlabel(.2 "Republican" 1 "Split-Control" 1.8 "Democrat") ytitle("") title(Partisan Control of the Legislature) xtitle("")
		graph save file5.gph, replace
		margins i.govparty_c
		marginsplot, recast(line) recastci(rarea) xlabel(0 "Split-Control" .8 "Governor's Party in Power") ytitle("") title(Executive Control of the Legislature) xtitle("")
		graph save file6.gph, replace
	graph combine file2.gph file3.gph , ycommon xcommon altshrink cols(1) iscale(1) ysize(6) xsize(4) l1title(Predicted Policy Enactment) 
	graph combine file1.gph file4.gph , ycommon xcommon altshrink cols(1) iscale(1) ysize(6) xsize(4) l1title(Predicted Policy Enactment) 
	graph combine file5.gph file6.gph , ycommon altshrink cols(1) iscale(1) ysize(6) xsize(4) l1title(Predicted Policy Enactment)

	
********************************************************************************
*** Figure 6: The Marginal Effects of Sierra Club Membership on Policy Adoption
********************************************************************************
gnbreg $y $basic $newvars2 c.sierraclub internet c.index_rescale_demean c.opinion1, vce(cluster state)c

gnbreg $y $basic $newvars sierraclub_graph index_rescale_graph opinion1c_graph c.index_rescale_graph, vce(cluster state)

margins i.leg, at(opinion1c_graph=(0(5)100))
		marginsplot, recast(line) recastci(rarea) xlabel(.2 "Republican" 1 "Split-Control" 1.8 "Democrat") ytitle("") title(Partisan Control of the Legislature) xtitle("")
		graph save file5.gph, replace
		margins i.govparty_c, at(opinion1c_graph=(0(5)100))
		marginsplot, recast(line) recastci(rarea) xlabel(0 "Split-Control" .8 "Governor's Party in Power") ytitle("") title(Executive Control of the Legislature) xtitle("")
		graph save file6.gph, replace

********************************************************************************
*** Figure 7: Policy Enactments by State and Year, California, Utah and Vermont
********************************************************************************

twoway (line change_enact_fixed year if state=="california" | state=="utah" | state=="vermont"), by(state, cols(1))


********************************************************************************
*** Table 1: Policy Enactment 2004-2010
********************************************************************************
gnbreg $y $basic $newvars, vce(cluster state)
	outreg2 using table2_AJPSX.xls, excel label dec(3) 2aster replace
gnbreg $y $basic $newvars $salience, vce(cluster state)
	outreg2 using table2_AJPSX.xls, excel label dec(3) 2aster
gnbreg $y $basic $newvars $salience blue, vce(cluster state)
	outreg2 using table2_AJPSX.xls, excel label dec(3) 2aster
gnbreg $y $basic $newvars $salience index_opinion1c_interaction, vce(cluster state)
	outreg2 using table2_AJPSX.xls, excel label dec(3) 2aster
gnbreg $y $basic $newvars $salience sierraclub_opinion1c_interaction, vce(cluster state)
	outreg2 using table2_AJPSX.xls, excel label dec(3) 2aster
