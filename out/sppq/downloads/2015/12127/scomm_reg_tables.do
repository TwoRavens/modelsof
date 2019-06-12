//List of all non-default packages installed on Stata12:

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

//recreate table 2 Model 2.1 and store results

reg total13 per_favorsb1070 dreamact conservatism borderstate hisp10 unauthorized fv_shgdp /*
*/ constructiongdp unemployment_rate_2011 censuspop crime g_participant_with_state daysactive

quietly fitstat, saving(21)

//Breusch-Pagan test 
estat hettest

//Shapiro-Wilkes test
predict e, resid
swilk e

//recreate table 2 Model 2.2 

zinb total13 per_favorsb1070 dreamact conservatism borderstate hisp10 unauthorized fv_shgdp /*
*/ constructiongdp unemployment_rate_2011 censuspop crime g_participant_with_state, nolog /*
*/ exposure(daysactive) inflate(per_favorsb1070 dreamact conservatism borderstate hisp10 /*
*/ unauthorized fv_shgdp constructiongdp unemployment_rate_2011 censuspop crime g_participant_with_state)

//to compare AIC & BIC statistics of models 2.1 and 2.2
fitstat, using(21) force

//recreate table 3 Model 3.1 and save results to compare AIC/BIC

zinb total privatefacility igsalocalcontract buddiv5 conservatism hisp10 crime /*
*/ cen_pop2 fv_shgdp constructiongdp unemployment_rate_2011 /*
*/ g_participant_with_state borderstate dreamact per_favorsb1070 /*
*/ unauthorized, nolog robust inflate(privatefacility igsalocalcontract buddiv5 /*
*/ conservatism hisp10 crime cen_pop2 fv_shgdp constructiongdp /*
*/ unemployment_rate_2011 g_participant_with_state borderstate /*
*/ dreamact per_favorsb1070 unauthorized) exposure(yearsactivated) 

quietly fitstat, saving(31)

//recreate table 3 Model 3.2 

zinb total privatefacility igsalocalcontract buddiv5 conservatism fb2010 /*
*/ change_hisp crime cen_pop2 fv_shgdp constructiongdp unemployment_rate_2011 /*
*/ ceninc2 g_participant_with_state borderstate dreamact per_favorsb1070  /*
*/ unauthorized, nolog robust inflate(privatefacility igsalocalcontract buddiv5 /*
*/ conservatism fb2010 change_hisp crime cen_pop2 fv_shgdp constructiongdp /*
*/ unemployment_rate_2011 ceninc2 g_participant_with_state borderstate /*
*/ dreamact per_favorsb1070 unauthorized) exposure(yearsactivated) 

//to compare AIC & BIC statistics of models 3.1 and 3.2
fitstat, using(31)

//recreate table 4 Model 4.1 and save results to compare AIC/BIC

zinb total privatefacility igsalocalcontract c.cenbuddiv5##c.cen_con hisp10 /*
*/ crime cen_pop2 fv_shgdp constructiongdp unemployment_rate_2011 g_participant_with_state /*
*/ borderstate dreamact per_favorsb1070 unauthorized, nolog robust exposure(yearsactivated) /*
*/ inflate(privatefacility igsalocalcontract c.cenbuddiv5##c.cen_con hisp10 /*
*/ crime cen_pop2 fv_shgdp constructiongdp unemployment_rate_2011 g_participant_with_state /*
*/ borderstate dreamact per_favorsb1070 unauthorized) 

quietly fitstat, saving(41)


//recreate table 4 Model 4.2 

zinb total privatefacility igsalocalcontract c.cenbuddiv5##c.cen_con fb2010 change_hisp /*
*/ crime cen_pop2 fv_shgdp constructiongdp unemployment_rate_2011 ceninc2 g_participant_with_state /*
*/ borderstate dreamact per_favorsb1070 unauthorized, nolog robust exposure(yearsactivated) /*
*/ inflate(privatefacility igsalocalcontract c.cenbuddiv5##c.cen_con fb2010 change_hisp /*
*/ crime cen_pop2 fv_shgdp constructiongdp unemployment_rate_2011 ceninc2 g_participant_with_state /*
*/ borderstate dreamact per_favorsb1070 unauthorized) 

//to compare AIC & BIC statistics of models 4.1 and 4.2
fitstat, using(41)


//Vuong Test for Model 3.1:
//Note: Vuong test function cannot be used with constraints such as vce(robust), 
//so coefficients and errors may vary slightly from robust models above. 
 
zinb total privatefacility igsalocalcontract buddiv5 conservatism hisp10 crime /*
*/ cen_pop2 fv_shgdp constructiongdp unemployment_rate_2011 /*
*/ g_participant_with_state borderstate dreamact per_favorsb1070 /*
*/ unauthorized, nolog inflate(privatefacility igsalocalcontract buddiv5 /*
*/ conservatism hisp10 crime cen_pop2 fv_shgdp constructiongdp /*
*/ unemployment_rate_2011 g_participant_with_state borderstate /*
*/ dreamact per_favorsb1070 unauthorized) exposure(yearsactivated) vuong


//Vuong Test for Model 3.2:

zinb total privatefacility igsalocalcontract buddiv5 conservatism fb2010 /*
*/ change_hisp crime cen_pop2 fv_shgdp constructiongdp unemployment_rate_2011 /*
*/ ceninc2 g_participant_with_state borderstate dreamact per_favorsb1070  /*
*/ unauthorized, nolog inflate(privatefacility igsalocalcontract buddiv5 /*
*/ conservatism fb2010 change_hisp crime cen_pop2 fv_shgdp constructiongdp /*
*/ unemployment_rate_2011 ceninc2 g_participant_with_state borderstate /*
*/ dreamact per_favorsb1070 unauthorized) exposure(yearsactivated) vuong

//Vuong Test for Model 4.1:

zinb total privatefacility igsalocalcontract c.cenbuddiv5##c.cen_con hisp10 /*
*/ crime cen_pop2 fv_shgdp constructiongdp unemployment_rate_2011 g_participant_with_state /*
*/ borderstate dreamact per_favorsb1070 unauthorized, nolog exposure(yearsactivated) /*
*/ inflate(privatefacility igsalocalcontract c.cenbuddiv5##c.cen_con hisp10 /*
*/ crime cen_pop2 fv_shgdp constructiongdp unemployment_rate_2011 g_participant_with_state /*
*/ borderstate dreamact per_favorsb1070 unauthorized) vuong


//Vuong Test for Model 4.2:
zinb total privatefacility igsalocalcontract c.cenbuddiv5##c.cen_con fb2010 change_hisp /*
*/ crime cen_pop2 fv_shgdp constructiongdp unemployment_rate_2011 ceninc2 g_participant_with_state /*
*/ borderstate dreamact per_favorsb1070 unauthorized, nolog exposure(yearsactivated) /*
*/ inflate(privatefacility igsalocalcontract c.cenbuddiv5##c.cen_con fb2010 change_hisp /*
*/ crime cen_pop2 fv_shgdp constructiongdp unemployment_rate_2011 ceninc2 g_participant_with_state /*
*/ borderstate dreamact per_favorsb1070 unauthorized) vuong

