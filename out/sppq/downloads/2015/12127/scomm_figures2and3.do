//All non-default Stata12 packages installed:


[1] package st0158 from http://www.stata-journal.com/software/sj9-1
      SJ9-1 st0158.  A general-purpose method for two-group...

[2] package collin from http://www.ats.ucla.edu/stat/stata/ado/analysis
      collin. Collinearity Diagnostics

[3] package xtmrho from http://fmwww.bc.edu/repec/bocode/x
      'XTMRHO': module to calculate intra-class correlations after xtmixed

[4] package nbvargr from http://www.ats.ucla.edu/stat/stata/ado/analysis
      nbvargr.  Program to graph observed, poisson and negative binomial probabilities.

[5] package savesome from http://fmwww.bc.edu/repec/bocode/s
      'SAVESOME': module to save subset of data

[6] package sg64_1 from http://www.stata.com/stb/stb49
      STB-49 sg64_1.  Update to pwcorrs.

[7] package sg97_4 from http://www.stata-journal.com/software/sj12-1
      SJ12-1 sg97_4.  A new system for formatting estimation...

[8] package meansdplot from http://www.ats.ucla.edu/stat/stata/ado/analysis
      meansdplot.  Plot mean and stendard deviation for multiple groups.

[9] package st0094 from http://www.stata-journal.com/software/sj5-4
      SJ5-4 st0094.  Confidence intervals for predicted outcomes...

[10] package spost9_ado from http://www.indiana.edu/~jslsoc/stata
      spost9_ado | Stata 9-13 commands for the post-estimation interpretation

[11] package hilo from http://www.ats.ucla.edu/stat/stata/ado/analysis
      hilo.  Program to display highest and lowest values.

[12] package outreg2 from http://fmwww.bc.edu/repec/bocode/o
      'OUTREG2': module to arrange regression outputs into an illustrative table

[13] package st0185 from http://www.stata-journal.com/software/sj10-1
      SJ10-1 st0185.  Centering and reference groups for...

[14] package st0360 from http://www.stata-journal.com/software/sj14-4
      SJ14-4 st0360. The chi-Square goodness-of-fit...

[15] package st0319 from http://www.stata-journal.com/software/sj13-4
      SJ13-4 st0319. Testing for zero inflation in...

[16] package tabout from http://fmwww.bc.edu/RePEc/bocode/t
      'TABOUT': module to export publication quality cross-tabulations

[17] package fsum from http://fmwww.bc.edu/RePEc/bocode/f
      'FSUM': module to generate and format summary statistics

[18] package designplot from http://fmwww.bc.edu/repec/bocode/d
      'DESIGNPLOT': module to produce a graphical summary of response given one or more factors

[19] package coefplot from http://fmwww.bc.edu/repec/bocode/c
      'COEFPLOT': module to plot regression coefficients and other results

[20] package estout from http://fmwww.bc.edu/repec/bocode/e
      'ESTOUT': module to make regression tables
      
//recreate Figure 2

zinb total privatefacility igsalocalcontract buddiv5 conservatism hisp10 crime /*
*/ cen_pop2 fv_shgdp constructiongdp unemployment_rate_2011 /*
*/ g_participant_with_state borderstate dreamact per_favorsb1070 /*
*/ unauthorized, nolog robust inflate(privatefacility igsalocalcontract buddiv5 /*
*/ conservatism hisp10 crime cen_pop2 fv_shgdp constructiongdp /*
*/ unemployment_rate_2011 g_participant_with_state borderstate /*
*/ dreamact per_favorsb1070 unauthorized) exposure(yearsactivated) 

coefplot, drop(_cons privatefacility igsalocalcontract cen_pop2 fv_shgdp constructiongdp /*
*/ unemployment_rate_2011 g_participant_with_state borderstate dreamact per_favorsb1070 /*
*/ unauthorized) xline(0) label  ciopts(recast(rcap))

//recreate Figure 3

quietly zinb total privatefacility igsalocalcontract i.threebud##c.conservatism fb2010 change_hisp /*
*/ crime cen_pop2 fv_shgdp constructiongdp unemployment_rate_2011 ceninc2 g_participant_with_state /*
*/ borderstate dreamact per_favorsb1070 unauthorized, nolog robust inflate(privatefacility /*
*/ igsalocalcontract i.threebud##c.conservatism fb2010 change_hisp crime cen_pop2 fv_shgdp /*
*/ constructiongdp unemployment_rate_2011 ceninc2 g_participant_with_state borderstate dreamact /*
*/ per_favorsb1070 unauthorized) exposure(yearsactivated) 

 quietly margins threebud, at(conservatism=(7(10)97)) atmeans
 
 marginsplot, noci xdimension(at(conservatism)) plotdimension(threebud) ytitle(Expected Deportations) /*
 */ xtitle(Conservatism) scheme(s1mono) legend(order(1 "25th Percentile" 2 "50th Percentile" /*
 */ 3 "75th Percentile"))
 
