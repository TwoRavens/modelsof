**********************************************************************************************
**********************************************************************************************
****  STATA REPLICATION CODE - ANALYSIS                                                  *****
****  Title: "Reexamining the Effect of Mass Shootings on Public Support for Gun Control"*****
****  Authors: David J. Barney and Brian F. Schaffner                                    *****
****  Journal: British Journal of Political Science                                      *****
****  Version: April 2018  (Version 2)                                                   *****
**********************************************************************************************
**********************************************************************************************

* Install GLLAMM (if not already installed)
* This package is used for the multilevel replications of Newman and Hartman's Table 3
net from http://www.gllamm.org
net install gllamm, replace

*** IMPORTANT NOTE ***
* You must set your working directory to the folder containing all of the data used here
* To do so, uncomment the line below, and replace "Filepath" with the correct filepath
* cd "Filepath/BJPS Replication Materials/"


***************************************
** ANALYSIS 1                        **
** Replication of Newman and Hartman **
***************************************
use CCES_10_12_14_panel_2year_subset.dta, clear

** Table 1
*Model 1: Newman and Hartman's treatment indicator
eq cons: cons
eq f1: medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 murdcap08_01 gunstorespc10_01 pmccain_01 popden0711zip_01 totpop0711zip_01
gllamm guns12 guns10 treat10_12_2 educ10_01 income10i_01 age10 male partyid3_10 ideology10_01 black latino asian ownhouse10 children10 military10 militaryfam10 pray10_01 south if sameres==1, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)

*Model 2: Barney and Schaffner's treatment indicator
eq cons: cons
eq f1: medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 murdcap08_01 gunstorespc10_01 pmccain_01 popden0711zip_01 totpop0711zip_01
gllamm guns12 guns10 treat_100mi educ10_01 income10i_01 age10 male partyid3_10 ideology10_01 black latino asian ownhouse10 children10 military10 militaryfam10 pray10_01 south if sameres==1, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)

*Model 3: Barney and Schaffner's treatment indicator, previous-decade treatment indicator, and their interaction
eq cons: cons
eq f1: medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 murdcap08_01 gunstorespc10_01 pmccain_01 popden0711zip_01 totpop0711zip_01
gllamm guns12 guns10 treat_100mi pds_100mi treat_interaction educ10_01 income10i_01 age10 male partyid3_10 ideology10_01 black latino asian ownhouse10 children10 military10 militaryfam10 pray10_01 south if sameres==1, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)

*SI, Table 1
*N of treated and untreated in each model specification
tab treat10_12_2 if sameres==1
tab treat_100mi if sameres==1
tab pds_100mi if sameres==1

clear

*************************************
** ANALYSIS 2                      **
** Full 2010-2012 CCES Panel Study **
** Time-Series Regressions         **
*************************************
use final_longform_10_12_merged.dta, clear

*Specify time series
xtset caseid year, delta(2)

*Models 1-6 for Table 2
xtreg guns_01 i.year murder_pc_01 treat_10mi if no_move==1, fe
xtreg guns_01 i.year murder_pc_01 treat_25mi if no_move==1, fe
xtreg guns_01 i.year murder_pc_01 treat_50mi if no_move==1, fe
xtreg guns_01 i.year murder_pc_01 treat_75mi if no_move==1, fe
xtreg guns_01 i.year murder_pc_01 treat_100mi if no_move==1, fe
xtreg guns_01 i.year murder_pc_01 treated_dma if no_move==1, fe

*SI, Table 2
*N of treated and untreated in each model specification
tab treat_10mi if year==2012 & no_move==1
tab treat_25mi if year==2012 & no_move==1
tab treat_50mi if year==2012 & no_move==1
tab treat_75mi if year==2012 & no_move==1
tab treat_100mi if year==2012 & no_move==1
tab treated_dma if year==2012 & no_move==1

*SI, Table 4
*Models 1-6, treatment conditional upon exposure to shooting in previous decade
xtreg guns_01 i.year murder_pc_01 i.pds_10mi#c.treat_10mi if no_move==1, fe
xtreg guns_01 i.year murder_pc_01 i.pds_25mi#c.treat_25mi if no_move==1, fe
xtreg guns_01 i.year murder_pc_01 i.pds_50mi#c.treat_50mi if no_move==1, fe
xtreg guns_01 i.year murder_pc_01 i.pds_75mi#c.treat_75mi if no_move==1, fe
xtreg guns_01 i.year murder_pc_01 i.pds_100mi#c.treat_100mi if no_move==1, fe
xtreg guns_01 i.year murder_pc_01 i.pds_treated_dma#c.treated_dma if no_move==1, fe

*SI, Table 6
*Models 1-6, treatment conditional upon partisanship
xtreg guns_01 year murder_pc_01 c.treat_10mi#i.party2010 if no_move==1, fe
xtreg guns_01 year murder_pc_01 c.treat_25mi#i.party2010 if no_move==1, fe
xtreg guns_01 year murder_pc_01 c.treat_50mi#i.party2010 if no_move==1, fe
xtreg guns_01 year murder_pc_01 c.treat_75mi#i.party2010 if no_move==1, fe
xtreg guns_01 year murder_pc_01 c.treat_100mi#i.party2010 if no_move==1, fe
xtreg guns_01 year murder_pc_01 c.treated_dma#i.party2010 if no_move==1, fe

*SI, Table 8
*Models 1-3, treatment as (a) linear distance to shooting, (b) quadratic distance to shooting, and (c) natural log of distance to shooting,
*ISSUE - All of these continuous indicators are collinear?
xtreg guns_01 year murder_pc_01 linear_distance if no_move==1, fe
xtreg guns_01 year murder_pc_01 ln_distance if no_move==1, fe


clear

******************************************
** ANALYSIS 3                           **
** Full 2010-2012-2014 CCES Panel Study **
** Time-Series Regressions              **
******************************************
use final_longform_10_14_merged.dta, clear

*Specify time series
xtset caseid year, delta(2)

*Models 1-6 for Table 3
xtreg guns_01 i.year murder_pc_01 t_10mi if no_move_allwaves==1, fe
xtreg guns_01 i.year murder_pc_01 t_25mi if no_move_allwaves==1, fe
xtreg guns_01 i.year murder_pc_01 t_50mi if no_move_allwaves==1, fe
xtreg guns_01 i.year murder_pc_01 t_75mi if no_move_allwaves==1, fe
xtreg guns_01 i.year murder_pc_01 t_100mi if no_move_allwaves==1, fe
xtreg guns_01 i.year murder_pc_01 treated_dma if no_move_allwaves==1, fe

*SI, Table 3
*N of treated and untreated in each model specification & panel wave
tab t_10mi if year==2012 & no_move_allwaves==1
tab t_25mi if year==2012 & no_move_allwaves==1
tab t_50mi if year==2012 & no_move_allwaves==1
tab t_75mi if year==2012 & no_move_allwaves==1
tab t_100mi if year==2012 & no_move_allwaves==1
tab treated_dma if year==2012 & no_move_allwaves==1

tab t_10mi if year==2014 & no_move_allwaves==1
tab t_25mi if year==2014 & no_move_allwaves==1
tab t_50mi if year==2014 & no_move_allwaves==1
tab t_75mi if year==2014 & no_move_allwaves==1
tab t_100mi if year==2014 & no_move_allwaves==1
tab treated_dma if year==2014 & no_move_allwaves==1

*SI, Table 5
*Models 1-6, treatment conditional upon exposure to shooting in previous decade
xtreg guns_01 i.year murder_pc_01 i.pds_10mi#c.t_10mi if no_move_allwaves==1, fe
xtreg guns_01 i.year murder_pc_01 i.pds_25mi#c.t_25mi if no_move_allwaves==1, fe
xtreg guns_01 i.year murder_pc_01 i.pds_50mi#c.t_50mi if no_move_allwaves==1, fe
xtreg guns_01 i.year murder_pc_01 i.pds_75mi#c.t_75mi if no_move_allwaves==1, fe
xtreg guns_01 i.year murder_pc_01 i.pds_100mi#c.t_100mi if no_move_allwaves==1, fe
xtreg guns_01 i.year murder_pc_01 i.pds_treated_dma#c.treated_dma if no_move_allwaves==1, fe

*SI, Table 7
*Models 1-6, treatment conditional upon partisanship
xtreg guns_01 i.year murder_pc_01 c.t_10mi#i.party2010 if no_move_allwaves==1, fe
xtreg guns_01 i.year murder_pc_01 c.t_25mi#i.party2010 if no_move_allwaves==1, fe
xtreg guns_01 i.year murder_pc_01 c.t_50mi#i.party2010 if no_move_allwaves==1, fe
xtreg guns_01 i.year murder_pc_01 c.t_75mi#i.party2010 if no_move_allwaves==1, fe
xtreg guns_01 i.year murder_pc_01 c.t_100mi#i.party2010 if no_move_allwaves==1, fe
xtreg guns_01 i.year murder_pc_01 c.treated_dma#i.party2010 if no_move_allwaves==1, fe

clear

*SI, Table 9
*Models 1-3, treatment as (a) linear distance to shooting, (b) natural log of distance to shooting, and (c) quadratic distance to shooting
*Note that there are two distance terms for each, one corresponding to minimum distance in each wave
xtreg guns_01 i.year murder_pc_01 linear_distance if no_move==1, fe
xtreg guns_01 i.year murder_pc_01 ln_distance if no_move==1, fe

















































