#delimit;
version 11.1;
set more off;
clear all;
  quietly log;
  local logon = r(status);
  if "`logon'" == "on" {; log close; };
log using montecarlo-figures-tables.log, text replace;


/*	*************************************************************************	*/
/*     	File Name:	montecarlo-figures-tables.do					*/
/*     	Date:   	May 15, 2015							*/
/*      Author: 	Frederick J. Boehmke						*/
/*      Purpose:	Combine the graphs from the different Monte Carlo runs to 	*/
/*			generate Figure 1 and Figure A2 in Boehmke, Chyzh, and Thies 	*/
/*			(PSRM 2016). Note that we do not set a seed, so you will not 	*/
/*			get identical results.						*/
/*	Input File:	graphs/montecarlo-seq-b_seq-bw.gph,				*/
/*			graphs/montecarlo-seq-b_distance-bw.gph,			*/
/*			graphs/montecarlo-sscore-b_sscore-bw.gph,			*/
/*			graphs/montecarlo-sscore-b_distance-bw.gph,			*/
/*			graphs/montecarlo-centrality-b_centrality-bw.gph,		*/
/*			graphs/montecarlo-centrality-b_distance-bw.gph,			*/
/*			graphs/montecarlo-seq-rmse_seq-bw.gph,				*/
/*			graphs/montecarlo-sscore-rmse_sscore-bw.gph,			*/
/*			graphs/montecarlo-centrality-rmse_centrality-bw.gph,		*/
/*			montecarlo-seq-collapsed.dta,					*/
/*			montecarlo-sscore-collapsed.dta,				*/
/*			montecarlo-centrality-collapsed.dta				*/
/*      Output File:	montecarlo-figures-tables.log					*/
/*			figure1.gph,							*/
/*			figureA2.gph,							*/
/*			tables/table(4-6)(a-c).tex					*/
/*	Requires:	grcleg.ado, listtab.ado						*/
/*	************************************************************************	*/
	
	
capture mkdir tables/;
capture mkdir graphs/;
	
	
	/*******************************************************/
	/* Combine the plots from the three different MC runs. */
	/*******************************************************/
	
		/* Uncomment this to install the grc1leg program. */
	
* net from http://www.stata.com/users/vwiggins;
* net install grc1leg;

		/* Average estimates and CI. */
		
grc1leg graphs/montecarlo-seq-b_seq-bw.gph
	graphs/montecarlo-sscore-b_sscore-bw.gph
	graphs/montecarlo-centrality-b_centr-bw.gph, scheme(s1mono)
	title(Coefficient on Score)
	imargin(small) 
	iscale(0.75)
	rows(1) cols(3)
	name(score, replace);
	
grc1leg graphs/montecarlo-seq-b_distance-bw.gph
	graphs/montecarlo-sscore-b_distance-bw.gph
	graphs/montecarlo-centrality-b_distance-bw.gph, scheme(s1mono)
	title(Coefficient on Distance)
	imargin(small) 
	iscale(0.75)
	rows(1) cols(3)
	name(distance, replace);

grc1leg score distance, scheme(s1mono)
	rows(2) cols(1)
	imargin(tiny)
	saving(figure1, replace);
	
		/* Root mean squared error. */
		
grc1leg graphs/montecarlo-seq-rmse_seq-bw.gph
	graphs/montecarlo-sscore-rmse_sscore-bw.gph
	graphs/montecarlo-centrality-rmse_centr-bw.gph, scheme(s1mono)
	imargin(tiny)
	iscale(0.75)
	rows(2) cols(1)
	xsize(8) ysize(7)
	saving(figureA2, replace);

	
	/*******************************************************/
	/* Create the tables of MC rseults for the appendix.   */
	/* Each table has 4 parts -- one for each variable.    */
	/*******************************************************/
	
		/* Uncomment this to install the listtab program. */
	
* ssc install listtab;

use montecarlo-centrality-collapsed, clear;
		
format %9.3f a0-g4_rmse;
		
  listtab rho b1 a1 g1 se_b1 se_a1 se_g1 sd_b1 sd_a1 sd_g1 b1_rmse a1_rmse g1_rmse 
	using tables/table4a.tex, replace rstyle(tabular) nolabel;
  
  listtab rho b2 a2 g2 se_b2 se_a2 se_g2 sd_b2 sd_a2 sd_g2 b2_rmse a2_rmse g2_rmse 
	using tables/table4b.tex, replace rstyle(tabular) nolabel;
  
  listtab rho b3 a3 g3 se_b3 se_a3 se_g3 sd_b3 sd_a3 sd_g3 b3_rmse a3_rmse g3_rmse 
	using tables/table4c.tex, replace rstyle(tabular) nolabel;

  listtab rho b4 a4 g4 se_b4 se_a4 se_g4 sd_b4 sd_a4 sd_g4 b4_rmse a4_rmse g4_rmse 
	using tables/table4d.tex, replace rstyle(tabular) nolabel;
  
  
use montecarlo-seq-collapsed, clear;
		
format %9.3f a0-g4_rmse;
		
  listtab rho b1 a1 g1 se_b1 se_a1 se_g1 sd_b1 sd_a1 sd_g1 b1_rmse a1_rmse g1_rmse 
	using tables/table5a.tex, replace rstyle(tabular) nolabel;
  
  listtab rho b2 a2 g2 se_b2 se_a2 se_g2 sd_b2 sd_a2 sd_g2 b2_rmse a2_rmse g2_rmse 
	using tables/table5b.tex, replace rstyle(tabular) nolabel;
  
  listtab rho b3 a3 g3 se_b3 se_a3 se_g3 sd_b3 sd_a3 sd_g3 b3_rmse a3_rmse g3_rmse 
	using tables/table5c.tex, replace rstyle(tabular) nolabel;

  listtab rho b4 a4 g4 se_b4 se_a4 se_g4 sd_b4 sd_a4 sd_g4 b4_rmse a4_rmse g4_rmse 
	using tables/table5d.tex, replace rstyle(tabular) nolabel;
  
  
use montecarlo-sscore-collapsed, clear;
		
format %9.3f a0-g4_rmse;
		
  listtab rho b1 a1 g1 se_b1 se_a1 se_g1 sd_b1 sd_a1 sd_g1 b1_rmse a1_rmse g1_rmse 
	using tables/table6a.tex, replace rstyle(tabular) nolabel;
  
  listtab rho b2 a2 g2 se_b2 se_a2 se_g2 sd_b2 sd_a2 sd_g2 b2_rmse a2_rmse g2_rmse 
	using tables/table6b.tex, replace rstyle(tabular) nolabel;
  
  listtab rho b3 a3 g3 se_b3 se_a3 se_g3 sd_b3 sd_a3 sd_g3 b3_rmse a3_rmse g3_rmse 
	using tables/table6c.tex, replace rstyle(tabular) nolabel;

  listtab rho b4 a4 g4 se_b4 se_a4 se_g4 sd_b4 sd_a4 sd_g4 b4_rmse a4_rmse g4_rmse 
	using tables/table6d.tex, replace rstyle(tabular) nolabel;
  
clear;
log close;
exit, STATA;
