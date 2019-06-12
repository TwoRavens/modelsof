*-----------------------------------------*
*** DO-FILE TABLES APPENDIX ***
*-----------------------------------------*
  
/*
PAPER: 
"Endogenous taxation in ongoing internal conflict: The Case of Colombia"

AUTHORS:
-Rafael Ch (New York University)
-Jacob Shapiro (Princeton University)
-Abbey Steele (University of Amsterdam)
-Juan F. Vargas (Universidad del Rosario)

DO-FILE: 
-This do-file generates the descriptive statistics of the Appendix A: Tables 1A.
-Creates tables 2B, 3B and 4B. 
-It also generates the results of the Appendix C "Testing the Electoral and Economic Mechanisms": Tables C1, C2, C3 and C4
-Generates Table 2D. 
-Generates Tables G1 and G2 on cumulative attacks and social and economic outcomes. 

*/
***********************************


clear all
set maxvar 32500
set more off 
set varabbrev off

*Set working directory wherever the "Replication_material_R&R/DO_FILES" folder is:
cd "/Users/rafach/Dropbox/PRINCETON-COLOMBIA/RESEARCH/TAXATION/Dropbox/Taxation paper/Analysis/Replication_material_R&R/DO_FILES"

*-----------------------------------------------------------------------------*
*APPENDIX A: DATA
*-----------------------------------------------------------------------------*

****************************
*TABLE 1A. DESCRIPTIVE STATS OF ADDITIONAL VARIABLES*
****************************

use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

*Cumulative attacks
estpost sum guer1988_1996_pc para1988_1996_pc guer1997_2002_pc para1997_2002_pc guer2003_2006_pc para2003_2006_pc guer2007_2010_pc para2003_2010_pc
est store table1a_appendix

esttab using "../TABLES/table1a_appendix.tex", replace  cells("mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0)) count(fmt(0))") ///
label nonumber f  noobs alignment(S) booktabs nomtitles plain collabels(none) ///
coeflabel(guer1988_1996_pc "Guerrilla attacks per 100,000 inh. 1988-1996" para1988_1996_pc "Paramilitary attacks per 100,000 inh. 1988-1996" guer1997_2002_pc "Guerrilla attacks per 100,000 inh. 1997-2002" para1997_2002_pc "Paramilitary attacks per 100,000 inh. 1997-2002" guer2003_2006_pc "Guerrilla attacks per 100,000 inh. 2003-2006" para2003_2006_pc "Paramilitary attacks per 100,000 inh. 2003-2006" guer2007_2010_pc "Guerrilla attacks per 100,000 inh. 2007-2010" para2003_2010_pc "Paramilitary attacks per 100,000 inh. 2007-2010" )

*ROBUSTNESS CHECKS
*Vote share by political party coalition (Mayor elections)
estpost sum share_uribe_conservador97_00 share_uribe_conservador03_06 share_uribe_conservador07_10 share_uribe_conservador03_10 share_uribe_conservador11_12
est store table1b_appendix

esttab using "../TABLES/table1b_appendix.tex", replace  cells("mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0)) count(fmt(0))") ///
label nonumber f  noobs alignment(S) booktabs nomtitles plain collabels(none) ///
coeflabel(share_uribe_conservador97_00 "Uribe + Conservative party coalition 1997 and 2000 Mayor elections" share_uribe_conservador03_06 "Uribe + Conservative party coalition 2003 Mayor election" share_uribe_conservador07_10 "Uribe + Conservative party coalition 2007 Mayor election" share_uribe_conservador03_10 "Uribe + Conservative party coalition 2003 and 2007 Mayor elections" share_uribe_conservador11_12 "Uribe + Conservative party coalition 2011 Mayor election")

*Vote share by political party coalition (City council elections)
estpost sum share_cc_uribe_conservador97_00 share_cc_uribe_conservador03_10 share_cc_uribe_conservador11_12
est store table1c_appendix

esttab using "../TABLES/table1c_appendix.tex", replace  cells("mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0)) count(fmt(0))") ///
label nonumber f  noobs alignment(S) booktabs nomtitles plain collabels(none) ///
coeflabel(share_cc_uribe_conservador97_00 "Uribe + Conservative party coalition 1997 and 2000 City Council elections" share_cc_uribe_conservador03_06 "Uribe + Conservative party coalition 2003 City Council election" share_cc_uribe_conservador07_10 "Uribe + Conservative party coalition 2007 City Council election" share_cc_uribe_conservador03_10 "Uribe + Conservative party coalition 2003 and 2007 City Council elections" share_cc_uribe_conservador11_12 "Uribe + Conservative party coalition 2011 City Council election")


*CONTROLS:
*Vote share by political party (Mayor elections)
estpost sum left1994 trad1994 third1994 et1994 left2000 trad2000 third2000 et2000 left2007 trad2007 third2007 et2007 left2011 trad2011 third2011 et2011
est store table1d_appendix

esttab using "../TABLES/table1d_appendix.tex", replace  cells("mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0)) count(fmt(0))") ///
label nonumber f  noobs alignment(S) booktabs nomtitles plain collabels(none) ///
coeflabel(left1994 "Left-wing party 1994" trad1994 "Traditional party 1994" third1994 "Third (right-wing) party 1994" et1994 "Indigenous Afro-Colombian party 1994" left2000 "Left-wing party 2000" trad2000 "Traditional party 2000" third2000 "Third (right-wing) party 2000" et2000 "Indegenous Afro-Colombian party 2000" left2007 "Left-wing party 2007" trad2007 "Traditional party 2007" third2007 "Third (right-wing) party 2007" et2007 "Indigenous Afro-Colombian party 2007" left2011 "Left-wing party 2011" trad2011 "Traditional party 2011" third2011 "Third (right-wing) party 2011" et2011 "Indigenous Afro-Colombian party 2011")

*Population
estpost sum lpob1988_1996 lpob1997_2002 lpob2003_2006 lpob2007_2010 lpob2011_2013
est store table1e_appendix

esttab using "../TABLES/table1e_appendix.tex", replace  cells("mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0)) count(fmt(0))") ///
label nonumber f  noobs alignment(S) booktabs nomtitles plain collabels(none) ///
coeflabel(lpob1988_1996 "Log (mean) population 1988-1996" lpob1997_2002 "Log (mean) population 1997-2002" lpob2003_2006 "Log (mean) population 2003-2006" lpob2007_2010 "Log (mean) population 2007-2010" lpob2011_2013 "Log (mean) population 2011-2013" )

*Windfall
estpost sum regalias1988_1996_pc regalias1997_2002_pc regalias2003_2006_pc regalias2007_2010_pc transferencias1988_1996_pc transferencias1997_2002_pc transferencias2003_2006_pc transferencias2007_2010_pc
est store table1f_appendix

esttab using "../TABLES/table1f_appendix.tex", replace  cells("mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0)) count(fmt(0))") ///
label nonumber f  noobs alignment(S) booktabs nomtitles plain collabels(none) ///
coeflabel(regalias1988_1996_pc "Royalties per capita  1988-1996" regalias1997_2002_pc "Royalties per capita  1997-2002" regalias2003_2006_pc "Royalties per capita  2003-2006" regalias2007_2010_pc "Royalties per capita  2007-2010" transferencias1988_1996_pc "Transfers per capita 1988-1996" transferencias1997_2002_pc "Transfers per capita 1997-2002" transferencias2003_2006_pc "Transfers per capita 2003-2006" transferencias2007_2010_pc "Transfers per capita 2007-2010")


*Military bases: 
estpost sum mil_bases_1999_2002 mil_bases_2003_2006 mil_bases_2007_2009
est store table1g_appendix

esttab using "../TABLES/table1g_appendix.tex", replace  cells("mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0)) count(fmt(0))") ///
label nonumber f  noobs alignment(S) booktabs nomtitles plain collabels(none) ///
coeflabel(mil_bases_1999_2002 "Military bases 1999-2002" mil_bases_2003_2006 "Military bases 2003-2006" mil_bases_2007_2009 "Military bases 2007-2009")


*Peaceful municipalities:
estpost sum peaceful1988_1996 peaceful1997_2002 peaceful2003_2006 peaceful2007_2010
est store table1h_appendix

esttab using "../TABLES/table1h_appendix.tex", replace  cells("mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0)) count(fmt(0))") ///
label nonumber f  noobs alignment(S) booktabs nomtitles plain collabels(none) ///
coeflabel(peaceful1988_1996 "Peaceful Municipalities (no attacks) 1988-1996"   peaceful1997_2002 "Peaceful Municipalities (no attacks) 1997-2002" peaceful2003_2006 "Peaceful Municipalities (no attacks)2003-2006" peaceful2007_2010 "Peaceful Municipalities (no attacks)2007-2010")

*Displacements:
estpost sum rec_total1997_2002 rec_total2003_2006 rec_total2007_2010 exp_total1997_2002 exp_total2003_2006 exp_total2007_2010 desplazados1997_2002 desplazados2003_2006 desplazados2007_2010
est store table1i_appendix

esttab using "../TABLES/table1i_appendix.tex", replace  cells("mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0)) count(fmt(0))") ///
label nonumber f  noobs alignment(S) booktabs nomtitles plain collabels(none) ///
coeflabel(rec_total1997_2002 "Desplazados received 1997-2002" rec_total2003_2006 "Desplazados received 2003-2006" rec_total2007_2010 "Desplazados received 2007-2010" exp_total1997_2002 "Desplazados driven out 1997-2002" exp_total2003_2006 "Desplazados driven out 2003-2006" exp_total2007_2010 "Desplazados driven out 2007-2010" desplazados1997_2002 "Desplazados 1997-2002" desplazados2003_2006 "Desplazados 2003-2006" desplazados2007_2010 "Desplazados 2007-2010")

*Coca
estpost sum coca1993_1996 coca1997_2002 coca2003_2006 coca2007_2010 coca2003_2010
est store table1j_appendix

esttab using "../TABLES/table1j_appendix.tex", replace  cells("mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0)) count(fmt(0))") ///
label nonumber f  noobs alignment(S) booktabs nomtitles plain collabels(none) ///
coeflabel(coca1993_1996 "Cocaine production (cum. tons) 1993-1996" coca1997_2002 "Cocaine production (cum. tons) 1997-2002" coca2003_2006 "Cocaine production (cum. tons) 2003-2006" coca2007_2010 "Cocaine production (cum. tons) 2007-2010" coca2003_2010 "Cocaine production (cum. tons) 2003-2010" )

*Endowments
estpost sum endowments1997_2002 endowments2003_2006 endowments2007_2010 endowments2003_2010
est store table1k_appendix

esttab using "../TABLES/table1k_appendix.tex", replace  cells("mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0)) count(fmt(0))") ///
label nonumber f  noobs alignment(S) booktabs nomtitles plain collabels(none) ///
coeflabel(endowments1997_2002 "Endowments (additive index; cum. tons)\footnote{Includes gold, silver, platinum, nickel, emeralds and oil.} 1999-2002" endowments2003_2006 "Endowments (additive index; cum. tons) 2003-2006" endowments2007_2010 "Endowments (additive index; cum. tons) 2007-2010" endowments2003_2010 "Endowments (additive index; cum. tons) 2003-2010")

*Geography:
estpost sum areakm2 alt_mun discapital
est store table1l_appendix

esttab using "../TABLES/table1l_appendix.tex", replace  cells("mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0)) count(fmt(0))") ///
label nonumber f  noobs alignment(S) booktabs nomtitles plain collabels(none) ///
coeflabel(areakm2 "Municipal area" alt_mun "Elevation" discapital "Distance to the Department's capital")


*Cumulative attacks for marginal effects 
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lningreso_predial00_02_pc2==.

local controls3 regalias2003_2006_pc transferencias2003_2006_pc areakm2 alt_mun discapital left2003 trad2003 third2003 peaceful2003_2006 mil_bases_2003_2006 rec_total2003_2006 exp_total2003_2006 desplazados2003_2006 coca2003_2006 endowments2003_2006 

foreach i in lningreso_predial07_10_pc2 {
xi: reg `i' lnguer2003_2006_pc_2 lnpara2003_2006_pc_2 lningreso_predial00_02_pc2 `controls3' i.cod_depto, cluster(cod_depto)
keep if e(sample)

 }

estpost sum guer1988_1996_pc para1988_1996_pc guer1997_2002_pc para1997_2002_pc guer2003_2006_pc para2003_2006_pc guer2007_2010_pc para2003_2010_pc, detail
est store table1m_appendix

esttab using "../TABLES/table1m_appendix.tex", replace  cells("p50(fmt(2)) p90(fmt(2))") ///
label nonumber f  noobs alignment(S) booktabs nomtitles plain collabels(none) ///
coeflabel(guer1988_1996_pc "Guerrilla attacks per 100,000 inh. 1988-1996" para1988_1996_pc "Paramilitary attacks per 100,000 inh. 1988-1996" guer1997_2002_pc "Guerrilla attacks per 100,000 inh. 1997-2002" para1997_2002_pc "Paramilitary attacks per 100,000 inh. 1997-2002" guer2003_2006_pc "Guerrilla attacks per 100,000 inh. 2003-2006" para2003_2006_pc "Paramilitary attacks per 100,000 inh. 2003-2006" guer2007_2010_pc "Guerrilla attacks per 100,000 inh. 2007-2010" para2003_2010_pc "Paramilitary attacks per 100,000 inh. 2007-2010" )

*2003-2010:
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if won_uribe_conservador00_02 ==.

local controls5 regalias2003_2010_pc transferencias2003_2010_pc areakm2 alt_mun discapital left2003 trad2003 third2003 peaceful2003_2010 mil_bases_2003_2010 rec_total2003_2010 exp_total2003_2010 desplazados2003_2010 coca2003_2010 endowments2003_2010

foreach i in won_uribe_conservador11_12{
 xi: reg `i'  lnguer2003_2010_pc_2 lnpara2003_2010_pc_2 won_uribe_conservador00_02 `controls5' i.cod_depto, cluster(cod_depto)
keep if e(sample)

}

estpost sum guer2003_2010_pc para2003_2010_pc, detail
est store table1n_appendix

esttab using "../TABLES/table1n_appendix.tex", replace  cells("p50(fmt(2)) p90(fmt(2))") ///
label nonumber f  noobs alignment(S) booktabs nomtitles plain collabels(none) ///
coeflabel(guer2003_2010_pc "Guerrilla attacks per 100,000 inh. 2003-2010 \footnote{Using Table 6, panel A, third period specification sample.}" para2003_2010_pc "Paramilitary attacks per 100,000 inh. 2003-2010 \footnote{\emph{Same as last footnote.}}" )


*-----------------------------------------------------------------------------*
*APPENDIX B: ROBUSTNESS TO RESTRICTING ESTIMATES TO THE COMMON SAMPLE
*-----------------------------------------------------------------------------*

 
 use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lningreso_predial85_87_pc2==.
drop if  lningreso_predial93_96_pc2==.
drop if  lningreso_predial00_02_pc2==.
drop if  lningreso_predial03_06_pc2==.
 
drop if lningreso_predial97_02_pc2==.
drop if lningreso_predial03_06_pc2==.
drop if lningreso_predial07_10_pc2==.
drop if lningreso_predial11_13_pc2==.

drop if won_uribe_conservador94_96 ==.
drop if won_uribe_conservador00_02 ==.

drop if won_uribe_conservador97_99==.
drop if won_uribe_conservador03_07==.
drop if won_uribe_conservador11_12==.

drop if share_uribe_conservador94_96 ==.
drop if share_uribe_conservador00_02 ==.

drop if share_uribe_conservador97_99==.
drop if share_uribe_conservador03_07==.
drop if share_uribe_conservador11_12==.

drop if share_cc_uribe_conservador94_96 ==.
drop if share_cc_uribe_conservador00_02 ==.

drop if share_cc_uribe_conservador97_99==.
drop if share_cc_uribe_conservador03_07==.
drop if share_cc_uribe_conservador11_12==. 

drop if avaluo_rur_pcrur03_06==.
drop if rezago_catastral03_06==.
drop if numactualizaciones03_06==.
drop if informalidad03_06==.

*Cadastral update lag regression: the one with the lowest N size: 
local controls2 regalias1997_2002_pc transferencias1997_2002_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1997_2002 mil_bases_1999_2002 rec_total1997_2002 exp_total1997_2002 desplazados1997_2002 coca1997_2002 endowments1997_2002 

foreach i in rezago_catastral03_06  {  
quietly xi: reg `i' lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lningreso_predial93_96_pc2 `controls2'  i.cod_depto, cluster(cod_depto)

}

keep if e(sample)

*N= 680 observations

***************************************************************
*TABLE 2B. CUMULATIVE VIOLENCE AND LOG PROPERTY TAX PERFORMANCE* tax per capita 
***************************************************************

eststo clear 

 * [1997-2002]
 
local controls1 regalias1988_1996_pc transferencias1988_1996_pc areakm2 alt_mun discapital left1994 trad1994 third1994 peaceful1988_1996 rec_total1993_1996 exp_total1993_1996 desplazados1993_1996 coca1993_1996 

foreach i in lningreso_predial97_02_pc2 {
 eststo: quietly xi: reg `i'  lnguer1988_1996_pc_2 lnpara1988_1996_pc_2  `controls1'  i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged 

 eststo: quietly xi: reg `i' lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 lningreso_predial85_87_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark

 }



* [2003-2006]

local controls2 regalias1997_2002_pc transferencias1997_2002_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1997_2002 mil_bases_1999_2002 rec_total1997_2002 exp_total1997_2002 desplazados1997_2002 coca1997_2002 endowments1997_2002 

foreach i in lningreso_predial03_06_pc2 {
 eststo: quietly xi: reg `i'  lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 `controls2'  i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged 
 
 eststo: quietly xi: reg `i' lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lningreso_predial93_96_pc2 `controls2'  i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark

}

*[2007-2010]

local controls3 regalias2003_2006_pc transferencias2003_2006_pc areakm2 alt_mun discapital left2003 trad2003 third2003 peaceful2003_2006 mil_bases_2003_2006 rec_total2003_2006 exp_total2003_2006 desplazados2003_2006 coca2003_2006 endowments2003_2006 

foreach i in lningreso_predial07_10_pc2 {
 eststo: quietly xi: reg `i'  lnguer2003_2006_pc_2 lnpara2003_2006_pc_2 `controls3' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged 
 
 eststo: quietly xi: reg `i' lnguer2003_2006_pc_2 lnpara2003_2006_pc_2 lningreso_predial00_02_pc2 `controls3' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
 }

*[2011-2013] - Falsification test


local controls4 regalias2007_2010_pc transferencias2007_2010_pc areakm2 alt_mun discapital left2007 trad2007 third2007 peaceful2007_2010 mil_bases_2007_2009 rec_total2007_2010 exp_total2007_2010 desplazados2007_2010 coca2007_2010 endowments2007_2010 

foreach i in lningreso_predial11_13_pc2 {
 eststo: quietly xi: reg `i'  lnguer2007_2010_pc_2 lnpara2007_2010_pc_2 `controls4' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged 
 
 eststo: quietly xi: reg `i' lnguer2007_2010_pc_2 lnpara2007_2010_pc_2 lningreso_predial03_06_pc2 `controls4' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
 }


esttab using "../TABLES/table2_appendix.tex", replace f b(%9.4f) se(%9.4f) se  star(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
 s(N r2 controls fixed lagged, fmt(0 3) label("Observations" "R-squared" "Controls$^a$" "Depto. FE" "Pre-period tax revenue$^b$")) ///
keep(lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lnguer2003_2006_pc_2 lnpara2003_2006_pc_2 lnguer2007_2010_pc_2 lnpara2007_2010_pc_2) ///
mgroups(1997-2002 2003-2006 2007-2010 2011-2013, pattern(1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
coeflabel(lnguer1988_1996_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{1988-1996}\end{tabular}" lnpara1988_1996_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{1988-1996}\end{tabular}" lnguer1997_2002_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{1997-2002}\end{tabular}" lnpara1997_2002_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{1997-2002}\end{tabular}" lnguer2003_2006_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{2003-2006}\end{tabular}" lnpara2003_2006_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{2003-2006}\end{tabular}" lnguer2007_2010_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{2007-2010}\end{tabular}" lnpara2007_2010_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{2007-2010}\end{tabular}") ///
collabels(none) nonotes booktabs nomtitles nolines

******************************************************************************************************
*TABLE 3B. MECHANISMS II: CUMULATIVE VIOLENCE PER CAPITA (1997-2002) AND POTENTIAL MECHANISMS (2003-2006)*
******************************************************************************************************

eststo clear 

local controls2 regalias1997_2002_pc transferencias1997_2002_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1997_2002 mil_bases_1999_2002 rec_total1997_2002 exp_total1997_2002 desplazados1997_2002 coca1997_2002 endowments1997_2002 
*coffee evercoca

foreach i in avaluo_rur_pcrur03_06 rezago_catastral03_06 numactualizaciones03_06 informalidad03_06{
  eststo: quietly xi: reg `i'  lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 `controls2'  i.cod_depto, cluster(cod_depto)
  estadd local fixed \checkmark
  estadd local controls \checkmark
  estadd local lagged 
 
  eststo: quietly xi: reg `i' lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lningreso_predial93_96_pc2 `controls2'  i.cod_depto, cluster(cod_depto)
  estadd local fixed \checkmark
  estadd local controls \checkmark
  estadd local lagged  \checkmark

}

esttab using "../TABLES/table3_appendix.tex", replace f b(%9.4f) se(%9.4f) se  star(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
s(N r2 controls fixed lagged, fmt(0 3) label("Observations" "R-squared" "Controls$^a$" "Depto. FE" "Pre-period tax revenue$^b$")) ///
keep(lnguer1997_2002_pc_2 lnpara1997_2002_pc_2) ///
mgroups("\emph{Per capita land value}" "\emph{Cadastral update lag}" "\emph{\# cadastral updates}" "\emph{Land informality rate}", pattern(1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
coeflabel(lnguer1997_2002_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{1997-2002}\end{tabular}" lnpara1997_2002_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{1997-2002}\end{tabular}" ) ///
collabels(none) nonotes booktabs nomtitles nonumber nolines



******************************************************************************************************
*TABLE 4B. MECHANISMS I: DIRECT CAPTURE, CUMULATIVE VIOLENCE AND ELECTORAL OUTCOMES*
******************************************************************************************************
******************
*PANEL A*
******************
eststo clear 

*Election 1997 and 2000 Mayor election (falsification) 

local controls1 regalias1988_1996_pc transferencias1988_1996_pc areakm2 alt_mun discapital left1994 trad1994 third1994 peaceful1988_1996 rec_total1993_1996 exp_total1993_1996 desplazados1993_1996 coca1993_1996 

foreach i in won_uribe_conservador97_00 {
 eststo: quietly xi: reg `i'   lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 `controls1' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged 
 
 eststo: quietly xi: reg `i'  lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 won_uribe_conservador94_96 `controls1'  i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged \checkmark

}


*Election 2003 + 2007 

local controls2 regalias1997_2002_pc transferencias1997_2002_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1997_2002 mil_bases_1999_2002 rec_total1997_2002 exp_total1997_2002 desplazados1997_2002 coca1997_2002 endowments1997_2002 

foreach i in won_uribe_conservador03_07 {
 eststo: quietly xi: reg `i'   lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 `controls2' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged 

 eststo: quietly xi: reg `i'  lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 won_uribe_conservador94_96 `controls2' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged \checkmark
}

*Election 2011 

local controls5 regalias2003_2010_pc transferencias2003_2010_pc areakm2 alt_mun discapital left2003 trad2003 third2003 peaceful2003_2010 mil_bases_2003_2010 rec_total2003_2010 exp_total2003_2010 desplazados2003_2010 coca2003_2010 endowments2003_2010

foreach i in won_uribe_conservador11_12{
 eststo:  quietly xi: reg `i'   lnguer2003_2010_pc_2 lnpara2003_2010_pc_2 `controls5' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged 
 
 eststo: quietly xi: reg `i'  lnguer2003_2010_pc_2 lnpara2003_2010_pc_2 won_uribe_conservador00_02 `controls5' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged \checkmark
}

esttab using "../TABLES/table4_panelA_appendix.tex", replace f  b(%9.4f) se(%9.4f) se  star(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
 s(N r2 controls fixed lagged, fmt(0 3) label("Observations" "R-squared" "Controls$^b$" "Depto. FE" "Pre-period DV$^c$")) ///
keep(lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lnguer2003_2010_pc_2 lnpara2003_2010_pc_2) ///
mgroups("1997 and 2000 Elections" "2003 and 2007 Elections" "2011 Election", pattern(1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
coeflabel(lnguer1988_1996_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{1988-1996}\end{tabular}" lnpara1988_1996_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{1988-1996}\end{tabular}" lnguer1997_2002_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{1997-2002}\end{tabular}" lnpara1997_2002_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{1997-2002}\end{tabular}"  lnguer2003_2010_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{2003-2010}\end{tabular}" lnpara2003_2010_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{2003-2010}\end{tabular}") ///
collabels(none) nonotes booktabs nomtitles nolines

******************
*PANEL B*
******************
eststo clear 

*Election 1997 and 2000, Mayor Election (falsification) 
drop if share_uribe_conservador94_96 ==.

local controls1 regalias1988_1996_pc transferencias1988_1996_pc areakm2 alt_mun discapital left1994 trad1994 third1994 peaceful1988_1996 rec_total1993_1996 exp_total1993_1996 desplazados1993_1996 coca1993_1996 

foreach i in share_uribe_conservador97_00 {
 eststo: quietly xi: reg `i'   lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 `controls1' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged 
 
 eststo: quietly xi: reg `i'  lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 share_uribe_conservador94_96 `controls1'  i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged \checkmark

}


*Election 2003 and 2007, Mayor Election  

drop if share_uribe_conservador94_96 ==.

local controls2 regalias1997_2002_pc transferencias1997_2002_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1997_2002 mil_bases_1999_2002 rec_total1997_2002 exp_total1997_2002 desplazados1997_2002 coca1997_2002 endowments1997_2002 

foreach i in share_uribe_conservador03_07 {
 eststo: quietly xi: reg `i'   lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 `controls2' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged 

 eststo: quietly xi: reg `i'  lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 share_uribe_conservador94_96 `controls2' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged \checkmark
}

*Election 2011, Mayor Election

drop if share_uribe_conservador00_02 ==.

local controls5 regalias2003_2010_pc transferencias2003_2010_pc areakm2 alt_mun discapital left2003 trad2003 third2003 peaceful2003_2010 mil_bases_2003_2010 rec_total2003_2010 exp_total2003_2010 desplazados2003_2010 coca2003_2010 endowments2003_2010

foreach i in share_uribe_conservador11_12{
 eststo:  quietly xi: reg `i'   lnguer2003_2010_pc_2 lnpara2003_2010_pc_2 `controls5' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged 
 
 eststo: quietly xi: reg `i'  lnguer2003_2010_pc_2 lnpara2003_2010_pc_2 share_uribe_conservador00_02 `controls5' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged \checkmark
}

esttab using "../TABLES/table4_panelB_appendix.tex", replace f  b(%9.4f) se(%9.4f) se star(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
 s(N r2 controls fixed lagged, fmt(0 3) label("Observations" "R-squared" "Controls$^b$" "Depto. FE" "Pre-period DV$^c$")) ///
keep(lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lnguer2003_2010_pc_2 lnpara2003_2010_pc_2) ///
mgroups("1997 and 2000 Elections" "2003 and 2007 Elections" "2011 Election", pattern(1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
coeflabel(lnguer1988_1996_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{1988-1996}\end{tabular}" lnpara1988_1996_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{1988-1996}\end{tabular}" lnguer1997_2002_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{1997-2002}\end{tabular}" lnpara1997_2002_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{1997-2002}\end{tabular}"  lnguer2003_2010_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{2003-2010}\end{tabular}" lnpara2003_2010_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{2003-2010}\end{tabular}") ///
collabels(none) nonotes booktabs nomtitles nolines

******************
*PANEL C*
******************

eststo clear 

*Election 1997 and 2000, City Council (falsification) 
drop if share_cc_uribe_conservador94_96 ==.

local controls1 regalias1988_1996_pc transferencias1988_1996_pc areakm2 alt_mun discapital left1994 trad1994 third1994 peaceful1988_1996 rec_total1993_1996 exp_total1993_1996 desplazados1993_1996 coca1993_1996 

foreach i in share_cc_uribe_conservador97_00 {
 eststo: quietly xi: reg `i'   lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 `controls1' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged 
 
 eststo: quietly xi: reg `i'  lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 share_cc_uribe_conservador94_96 `controls1'  i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged \checkmark

}


*Election 2003 + 2007, City Council
drop if share_cc_uribe_conservador94_96 ==.

local controls2 regalias1997_2002_pc transferencias1997_2002_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1997_2002 mil_bases_1999_2002 rec_total1997_2002 exp_total1997_2002 desplazados1997_2002 coca1997_2002 endowments1997_2002 

foreach i in share_cc_uribe_conservador03_07 {
 eststo: quietly xi: reg `i'   lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 `controls2' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged 

 eststo: quietly xi: reg `i'  lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 share_cc_uribe_conservador94_96 `controls2' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged \checkmark
}

*Election 2011, City Council
drop if share_cc_uribe_conservador00_02 ==.

local controls5 regalias2003_2010_pc transferencias2003_2010_pc areakm2 alt_mun discapital left2003 trad2003 third2003 peaceful2003_2010 mil_bases_2003_2010 rec_total2003_2010 exp_total2003_2010 desplazados2003_2010 coca2003_2010 endowments2003_2010

foreach i in share_uribe_conservador11_12{
 eststo:  quietly xi: reg `i'   lnguer2003_2010_pc_2 lnpara2003_2010_pc_2 `controls5' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged 
 
 eststo: quietly xi: reg `i'  lnguer2003_2010_pc_2 lnpara2003_2010_pc_2 share_cc_uribe_conservador11_12 `controls5' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged \checkmark
}

esttab using "../TABLES/table4_panelC_appendix.tex", replace f  b(%9.4f) se(%9.4f) se star(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
 s(N r2 controls fixed lagged, fmt(0 3) label("Observations" "R-squared" "Controls$^b$" "Depto. FE" "Pre-period DV$^c$")) ///
keep(lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lnguer2003_2010_pc_2 lnpara2003_2010_pc_2) ///
mgroups("1997 and 2000 Elections" "2003 and 2007 Elections" "2011 Election", pattern(1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
coeflabel(lnguer1988_1996_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{1988-1996}\end{tabular}" lnpara1988_1996_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{1988-1996}\end{tabular}" lnguer1997_2002_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{1997-2002}\end{tabular}" lnpara1997_2002_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{1997-2002}\end{tabular}"  lnguer2003_2010_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{2003-2010}\end{tabular}" lnpara2003_2010_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{2003-2010}\end{tabular}") ///
collabels(none) nonotes booktabs nomtitles nolines

*-----------------------------------------------------------------------------*
*APPENDIX C: TESTING THE ELECTORAL AND ECONOMIC MECHANISMS
*-----------------------------------------------------------------------------*

*****************++++***********************
*TABLE C1. POST-TREATMENT CONTROL: ELECTIONS
*****************++++***********************

eststo clear 

 * [1997-2002]
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial85_87_pc2==.
 
local controls1 regalias1988_1996_pc transferencias1988_1996_pc areakm2 alt_mun discapital left1994 trad1994 third1994 peaceful1988_1996 rec_total1993_1996 exp_total1993_1996 desplazados1993_1996 coca1993_1996 

foreach i in lningreso_predial97_02_pc2 {

 quietly xi: reg `i' lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 lningreso_predial85_87_pc2  `controls1'  i.cod_depto won_uribe_conservador97_99, cluster(cod_depto)
keep if e(sample)

 eststo: quietly xi: reg `i' lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 lningreso_predial85_87_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
 estadd local post  

 eststo: quietly xi: reg `i' lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 lningreso_predial85_87_pc2  `controls1'  i.cod_depto won_uribe_conservador97_99, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
 estadd local post  \checkmark
 }



* [2003-2006]
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lningreso_predial93_96_pc2==.

local controls2 regalias1997_2002_pc transferencias1997_2002_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1997_2002 mil_bases_1999_2002 rec_total1997_2002 exp_total1997_2002 desplazados1997_2002 coca1997_2002 endowments1997_2002 

foreach i in lningreso_predial03_06_pc2 {
 
 quietly xi: reg `i' lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lningreso_predial93_96_pc2 `controls2'  i.cod_depto won_uribe_conservador03_06, cluster(cod_depto)
keep if e(sample)
 
 eststo: quietly xi: reg `i' lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lningreso_predial93_96_pc2 `controls2'  i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
 estadd local post  

  
 eststo: quietly xi: reg `i' lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lningreso_predial93_96_pc2 `controls2'  i.cod_depto won_uribe_conservador03_06, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
 estadd local post  \checkmark

}

*[2007-2010]

*download dataset again:
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lningreso_predial00_02_pc2==.

local controls3 regalias2003_2006_pc transferencias2003_2006_pc areakm2 alt_mun discapital left2003 trad2003 third2003 peaceful2003_2006 mil_bases_2003_2006 rec_total2003_2006 exp_total2003_2006 desplazados2003_2006 coca2003_2006 endowments2003_2006 


foreach i in lningreso_predial07_10_pc2 {
 
  quietly xi: reg `i' lnguer2003_2006_pc_2 lnpara2003_2006_pc_2 lningreso_predial00_02_pc2 `controls3' i.cod_depto won_uribe_conservador07_10, cluster(cod_depto)
keep if e(sample)

 eststo: quietly xi: reg `i' lnguer2003_2006_pc_2 lnpara2003_2006_pc_2 lningreso_predial00_02_pc2 `controls3' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
 estadd local post  

 eststo: quietly xi: reg `i' lnguer2003_2006_pc_2 lnpara2003_2006_pc_2 lningreso_predial00_02_pc2 `controls3' i.cod_depto won_uribe_conservador07_10, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
  estadd local post  \checkmark

 }

*[2011-2013] - Falsification test

*download dataset again:
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lningreso_predial03_06_pc2==.

local controls4 regalias2007_2010_pc transferencias2007_2010_pc areakm2 alt_mun discapital left2007 trad2007 third2007 peaceful2007_2010 mil_bases_2007_2009 rec_total2007_2010 exp_total2007_2010 desplazados2007_2010 coca2007_2010 endowments2007_2010 

foreach i in lningreso_predial11_13_pc2 {

quietly xi: reg `i' lnguer2007_2010_pc_2 lnpara2007_2010_pc_2 lningreso_predial03_06_pc2 `controls4' i.cod_depto won_uribe_conservador11_12, cluster(cod_depto)
keep if e(sample)

 eststo: quietly xi: reg `i' lnguer2007_2010_pc_2 lnpara2007_2010_pc_2 lningreso_predial03_06_pc2 `controls4' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
 estadd local post  

 eststo: quietly xi: reg `i' lnguer2007_2010_pc_2 lnpara2007_2010_pc_2 lningreso_predial03_06_pc2 `controls4' i.cod_depto won_uribe_conservador11_12, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
 estadd local post  \checkmark

 }


esttab using "../TABLES/tableC1_appendix.tex", replace f b(%9.4f) se(%9.4f) se star(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
 s(N r2 controls fixed lagged post, fmt(0 3) label("Observations" "R-squared" "Controls$^a$" "Depto. FE" "Pre-period tax revenue$^b$" "Post-treatment$^c$")) ///
keep(lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lnguer2003_2006_pc_2 lnpara2003_2006_pc_2 lnguer2007_2010_pc_2 lnpara2007_2010_pc_2) ///
mgroups(1997-2002 2003-2006 2007-2010 2011-2013, pattern(1 0 1 0 1 0 1 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
coeflabel(lnguer1988_1996_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{1988-1996}\end{tabular}" lnpara1988_1996_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{1988-1996}\end{tabular}" lnguer1997_2002_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{1997-2002}\end{tabular}" lnpara1997_2002_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{1997-2002}\end{tabular}" lnguer2003_2006_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{2003-2006}\end{tabular}" lnpara2003_2006_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{2003-2006}\end{tabular}" lnguer2007_2010_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{2007-2010}\end{tabular}" lnpara2007_2010_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{2007-2010}\end{tabular}") ///
collabels(none) nonotes booktabs nomtitles nolines

/**********************************************************
*TABLE C.2. CAUSAL MEDIATION ANALYSIS, ELECTORAL OUTCOMES*
**********************************************************


*-----------------------------------------
*1985-1996 Treatment on 1997-2002 Outcome 
*-----------------------------------------
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if lningreso_predial85_87_pc2 ==.
drop if won_uribe_conservador94_96 ==.

gen M= won_uribe_conservador97_99
gen T1= lnguer1988_1996_pc_2
gen T2= lnpara1988_1996_pc_2
gen Y= lningreso_predial97_02_pc2
gen x1= won_uribe_conservador94_96
gen x2= lningreso_predial85_87_pc2

tabulate cod_depto, generate(coddepto_)

local controls lpob1988_1996 regalias1988_1996_pc transferencias1988_1996_pc areakm2 alt_mun discapital left1994 trad1994 third1994 peaceful1988_1996 rec_total1993_1996 exp_total1993_1996 desplazados1993_1996
sum `controls'
keep M T1 T2 Y x1 x2 cod_depto coddepto_1-coddepto_28 `controls'

*Mediation analysis:
medeff (regress M T1-T2 x1 x2 `controls') (regress Y T1-T2 M x1 x2 `controls'), treat(T1-T2) mediate(M) sims(500) vce(cluster cod_depto)

*Sensitivity analysis: 
local controls lpob1988_1996 regalias1988_1996_pc transferencias1988_1996_pc areakm2 alt_mun discapital left1994 trad1994 third1994 peaceful1988_1996 rec_total1993_1996 exp_total1993_1996 desplazados1993_1996
sum `controls'
medsens (regress M T1 T2 x1 x2 `controls') (regress Y T1 T2 M x1 x2 `controls'), treat(T1) mediate(M) sims(500) 


*-----------------------------------------
*1997-2002 Treatment on 2003-2006 Outcome
*-----------------------------------------

use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lningreso_predial93_96_pc2==.
drop if won_uribe_conservador94_96 ==.

gen M= won_uribe_conservador03_06
gen T1= lnguer1997_2002_pc_2
gen T2= lnpara1997_2002_pc_2
gen Y= lningreso_predial03_06_pc2
gen x1= won_uribe_conservador94_96
gen x2= lningreso_predial93_96_pc2

tabulate cod_depto, generate(coddepto_)

local controls lpob1997_2002 regalias1997_2002_pc transferencias1997_2002_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1997_2002 mil_bases_1999_2002 rec_total1997_2002 exp_total1997_2002 desplazados1997_2002
sum `controls'
keep M T1 T2 Y x1 x2 cod_depto coddepto_1-coddepto_33 `controls'

*Mediation analysis:
medeff (regress M T1-T2 x1 x2 `controls') (regress Y T1-T2 M x1 x2 `controls'), treat(T1-T2) mediate(M) sims(1000) vce(cluster cod_depto)

*Sensitivity analysis: 
local controls lpob1997_2002 regalias1997_2002_pc transferencias1997_2002_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1997_2002 mil_bases_1999_2002 rec_total1997_2002 exp_total1997_2002 desplazados1997_2002
sum `controls'
medsens (regress M T1 T2 x1 x2 `controls') (regress Y T1 T2 M x1 x2 `controls'), treat(T1) mediate(M) sims(1000) 

*-----------------------------------------
*2003-2006 Treatment on 2007-2010 Outcome
*-----------------------------------------
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lningreso_predial00_02_pc2 ==.
drop if won_uribe_conservador00_02 ==.

gen M= won_uribe_conservador07_10
gen T1= lnguer2003_2006_pc_2
gen T2= lnpara2003_2006_pc_2
gen Y= lningreso_predial07_10_pc2
gen x1= won_uribe_conservador00_02
gen x2= lningreso_predial00_02_pc2


tabulate cod_depto, generate(coddepto_)
local controls lpob2003_2006 regalias2003_2006_pc transferencias2003_2006_pc areakm2 alt_mun discapital left2003 trad2003 third2003 peaceful2003_2006 mil_bases_2003_2006 rec_total2003_2006 exp_total2003_2006 desplazados2003_2006
sum `controls'
keep M T1 T2 Y x1 x2 cod_depto coddepto_1-coddepto_33 `controls'

*Mediation analysis:
medeff (regress M T1-T2 x1 x2 `controls') (regress Y T1-T2 M x1 x2 `controls'), treat(T1-T2) mediate(M) sims(500) vce(cluster cod_depto)

*Sensitivity analysis: 
local controls lpob2003_2006 regalias2003_2006_pc transferencias2003_2006_pc areakm2 alt_mun discapital left2003 trad2003 third2003 peaceful2003_2006 mil_bases_2003_2006 rec_total2003_2006 exp_total2003_2006 desplazados2003_2006
sum `controls'
medsens (regress M T1 T2 x1 x2 `controls') (regress Y T1 T2 M x1 x2 `controls'), treat(T1) mediate(M) sims(500) 


*Both periods
*-----------------------------------------
*1997-2002 Treatment on 2003-2010 Outcome
*----------------------------------------- 

use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lningreso_predial93_96_pc2==.
drop if won_uribe_conservador94_96 ==.

gen M= won_uribe_conservador03_07
gen T1= lnguer1997_2002_pc_2
gen T2= lnpara1997_2002_pc_2
gen Y= lningreso_predial03_10
gen x1= won_uribe_conservador94_96
gen x2= lningreso_predial93_96_pc2

tabulate cod_depto, generate(coddepto_)

local controls lpob1997_2002 regalias1997_2002_pc transferencias1997_2002_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1997_2002 mil_bases_1999_2002 rec_total1997_2002 exp_total1997_2002 desplazados1997_2002
sum `controls'
keep M T1 T2 Y x1 x2 cod_depto coddepto_1-coddepto_33 `controls'

*Mediation analysis:
medeff (regress M T1-T2 x1 x2 `controls') (regress Y T1-T2 M x1 x2 `controls'), treat(T1-T2) mediate(M) sims(1000) vce(cluster cod_depto)

*Sensitivity analysis: 
local controls lpob1997_2002 regalias1997_2002_pc transferencias1997_2002_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1997_2002 mil_bases_1999_2002 rec_total1997_2002 exp_total1997_2002 desplazados1997_2002
sum `controls'
medsens (regress M T1 T2 x1 x2 `controls') (regress Y T1 T2 M x1 x2 `controls'), treat(T1) mediate(M) sims(1000) 

*-----------------------------------------
*2007-2010 Treatment on 2011-2013 Outcome
*-----------------------------------------

use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lningreso_predial03_06_pc2==.
drop if won_uribe_conservador00_02 ==.

gen M= won_uribe_conservador11_12
gen T1= lnguer2007_2010_pc_2
gen T2= lnpara2007_2010_pc_2
gen Y=lningreso_predial11_13_pc2
gen x1= won_uribe_conservador03_06
gen x2= lningreso_predial03_06_pc2

tabulate cod_depto, generate(coddepto_)

local controls lpob2007_2010 regalias2007_2010_pc transferencias2007_2010_pc areakm2 alt_mun discapital left2007 trad2007 third2007 peaceful2007_2010 mil_bases_2007_2009 rec_total2007_2010 exp_total2007_2010 desplazados2007_2010
sum `controls'
keep M T1 T2 Y x1 x2 cod_depto coddepto_1-coddepto_33 `controls'

*Mediation analysis:
medeff (regress M T1-T2 x1 x2 `controls') (regress Y T1-T2 M x1 x2 `controls'), treat(T1-T2) mediate(M) sims(1000) vce(cluster cod_depto)

*Sensitivity analysis: 
local controls lpob2007_2010 regalias2007_2010_pc transferencias2007_2010_pc areakm2 alt_mun discapital left2007 trad2007 third2007 peaceful2007_2010 mil_bases_2007_2009 rec_total2007_2010 exp_total2007_2010 desplazados2007_2010
sum `controls'
medsens (regress M T1 T2 x1 x2 `controls') (regress Y T1 T2 M x1 x2 `controls'), treat(T1) mediate(M) sims(1000) 


*/

*****************++++***********************
*TABLE C3. POST-TREATMENT CONTROL: ECONOMIC ACTIVITY
*****************++++***********************

eststo clear 

 * [1997-2002]
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial85_87_pc2==.
 
local controls1 regalias1988_1996_pc transferencias1988_1996_pc areakm2 alt_mun discapital left1994 trad1994 third1994 peaceful1988_1996 rec_total1993_1996 exp_total1993_1996 desplazados1993_1996 coca1993_1996 

foreach i in lningreso_predial97_02_pc2 {

 quietly xi: reg `i' lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 lningreso_predial85_87_pc2  `controls1'  i.cod_depto lnlight1997_2002_pc2, cluster(cod_depto)
keep if e(sample)

 eststo: quietly xi: reg `i' lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 lningreso_predial85_87_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
 estadd local post  

 eststo: quietly xi: reg `i' lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 lningreso_predial85_87_pc2  `controls1'  i.cod_depto lnlight1997_2002_pc2, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
 estadd local post  \checkmark


 }



* [2003-2006]
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lningreso_predial93_96_pc2==.

local controls2 regalias1997_2002_pc transferencias1997_2002_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1997_2002 mil_bases_1999_2002 rec_total1997_2002 exp_total1997_2002 desplazados1997_2002 coca1997_2002 endowments1997_2002 

foreach i in lningreso_predial03_06_pc2 {
 
 quietly xi: reg `i' lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lningreso_predial93_96_pc2 `controls2'  i.cod_depto lnlight2003_2006_pc2, cluster(cod_depto)
keep if e(sample)
 
 eststo: quietly xi: reg `i' lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lningreso_predial93_96_pc2 `controls2'  i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
 estadd local post  

  
 eststo: quietly xi: reg `i' lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lningreso_predial93_96_pc2 `controls2'  i.cod_depto lnlight2003_2006_pc2, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
 estadd local post  \checkmark

}

*[2007-2010]

*download dataset again:
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lningreso_predial00_02_pc2==.

local controls3 regalias2003_2006_pc transferencias2003_2006_pc areakm2 alt_mun discapital left2003 trad2003 third2003 peaceful2003_2006 mil_bases_2003_2006 rec_total2003_2006 exp_total2003_2006 desplazados2003_2006 coca2003_2006 endowments2003_2006 

foreach i in lningreso_predial07_10_pc2 {
 
  quietly xi: reg `i' lnguer2003_2006_pc_2 lnpara2003_2006_pc_2 lningreso_predial00_02_pc2 `controls3' i.cod_depto lnlight2007_2010_pc2, cluster(cod_depto)
keep if e(sample)

 eststo: quietly xi: reg `i' lnguer2003_2006_pc_2 lnpara2003_2006_pc_2 lningreso_predial00_02_pc2 `controls3' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
  estadd local post 

 eststo: quietly xi: reg `i' lnguer2003_2006_pc_2 lnpara2003_2006_pc_2 lningreso_predial00_02_pc2 `controls3' i.cod_depto lnlight2007_2010_pc2, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
  estadd local post  \checkmark
 }

*[2011-2013] - Falsification test

*download dataset again:
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lningreso_predial03_06_pc2==.

local controls4 regalias2007_2010_pc transferencias2007_2010_pc areakm2 alt_mun discapital left2007 trad2007 third2007 peaceful2007_2010 mil_bases_2007_2009 rec_total2007_2010 exp_total2007_2010 desplazados2007_2010 coca2007_2010 endowments2007_2010 

foreach i in lningreso_predial11_13_pc2 {

quietly xi: reg `i' lnguer2007_2010_pc_2 lnpara2007_2010_pc_2 lningreso_predial03_06_pc2 `controls4' i.cod_depto lnlight2011_2013_pc2, cluster(cod_depto)
keep if e(sample)

 eststo: quietly xi: reg `i' lnguer2007_2010_pc_2 lnpara2007_2010_pc_2 lningreso_predial03_06_pc2 `controls4' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
 estadd local post  

 eststo: quietly xi: reg `i' lnguer2007_2010_pc_2 lnpara2007_2010_pc_2 lningreso_predial03_06_pc2 `controls4' i.cod_depto lnlight2011_2013_pc2, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
 estadd local post  \checkmark

 }


esttab using "../TABLES/tableC3_appendix.tex", replace f b(%9.4f) se(%9.4f) se star(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
 s(N r2 controls fixed lagged post, fmt(0 3) label("Observations" "R-squared" "Controls$^a$" "Depto. FE" "Pre-period tax revenue$^b$" "Post-treatment$^c$ ")) ///
keep(lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lnguer2003_2006_pc_2 lnpara2003_2006_pc_2 lnguer2007_2010_pc_2 lnpara2007_2010_pc_2) ///
mgroups(1997-2002 2003-2006 2007-2010 2011-2013, pattern(1 0 1 0 1 0  1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
coeflabel(lnguer1988_1996_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{1988-1996}\end{tabular}" lnpara1988_1996_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{1988-1996}\end{tabular}" lnguer1997_2002_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{1997-2002}\end{tabular}" lnpara1997_2002_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{1997-2002}\end{tabular}" lnguer2003_2006_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{2003-2006}\end{tabular}" lnpara2003_2006_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{2003-2006}\end{tabular}" lnguer2007_2010_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{2007-2010}\end{tabular}" lnpara2007_2010_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{2007-2010}\end{tabular}") ///
collabels(none) nonotes booktabs nomtitles nolines

/*********************************************************
*TABLE C.4. CAUSAL MEDIATION ANALYSIS, ECONOMIC ACTIVITY*
*********************************************************

*-----------------------------------------
*1985-1996 Treatment on 1997-2002 Outcome
*-----------------------------------------
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if lningreso_predial85_87_pc2 ==.
drop if lnlight92_pc ==.


gen M= lnlight1997_2002_pc2
gen T1= lnguer1988_1996_pc_2
gen T2= lnpara1988_1996_pc_2
gen Y= lningreso_predial97_02_pc2
gen x1= lnlight92_pc
gen x2= lningreso_predial85_87_pc2

tabulate cod_depto, generate(coddepto_)

local controls regalias1988_1996_pc transferencias1988_1996_pc areakm2 alt_mun discapital left1994 trad1994 third1994 peaceful1988_1996 rec_total1993_1996 exp_total1993_1996 desplazados1993_1996 coca1993_1996
sum `controls'
keep M T1 T2 Y x1 x2 cod_depto coddepto_1-coddepto_28 `controls'

*Mediation analysis:
medeff (regress M T1-T2 x1 x2 `controls') (regress Y T1-T2 M x1 x2 `controls'), treat(T1-T2) mediate(M) sims(500) vce(cluster cod_depto)

*Sensitivity analysis: 
local controls regalias1988_1996_pc transferencias1988_1996_pc areakm2 alt_mun discapital left1994 trad1994 third1994 peaceful1988_1996 rec_total1993_1996 exp_total1993_1996 desplazados1993_1996 coca1993_1996
sum `controls'
medsens (regress M T1 T2 x1 x2 `controls') (regress Y T1 T2 M x1 x2 `controls'), treat(T1) mediate(M) sims(500) 



*-----------------------------------------
*1997-2002 Treatment on 2003-2006 Outcome: expect an almost zero ACME
*-----------------------------------------

use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lningreso_predial93_96_pc2==.
drop if lnlight1992_1996_pc2 ==.

gen M= lnlight2003_2006_pc2
gen T1= lnguer1997_2002_pc_2
gen T2= lnpara1997_2002_pc_2
gen Y= lningreso_predial03_06_pc2
gen x1= lnlight1992_1996_pc2
gen x2= lningreso_predial93_96_pc2

tabulate cod_depto, generate(coddepto_)

local controls regalias1997_2002_pc transferencias1997_2002_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1997_2002 mil_bases_1999_2002 rec_total1997_2002 exp_total1997_2002 desplazados1997_2002 coca1997_2002
sum `controls'
keep M T1 T2 Y x1 x2 cod_depto coddepto_1-coddepto_33 `controls'

*Mediation analysis:
medeff (regress M T1-T2 x1 x2 `controls') (regress Y T1-T2 M x1 x2 `controls'), treat(T1-T2) mediate(M) sims(1000) vce(cluster cod_depto)

*Sensitivity analysis: 
local controls regalias1997_2002_pc transferencias1997_2002_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1997_2002 mil_bases_1999_2002 rec_total1997_2002 exp_total1997_2002 desplazados1997_2002 coca1997_2002
sum `controls'
medsens (regress M T1 T2 x1 x2 `controls') (regress Y T1 T2 M x1 x2 `controls'), treat(T1) mediate(M) sims(1000) 

*-----------------------------------------
*2003-2006 Treatment on 2007-2010 Outcome : expect a positive ACME 
*-----------------------------------------

use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lningreso_predial00_02_pc2 ==.
drop if lnlight2000_2002_pc2 ==.

gen M= lnlight2007_2010_pc2
gen T1= lnguer2003_2006_pc_2
gen T2= lnpara2003_2006_pc_2
gen Y= lningreso_predial07_10_pc2
gen x1= lnlight2000_2002_pc2
gen x2= lningreso_predial00_02_pc2

tabulate cod_depto, generate(coddepto_)
local controls regalias2003_2006_pc transferencias2003_2006_pc areakm2 alt_mun discapital left2003 trad2003 third2003 peaceful2003_2006 mil_bases_2003_2006 rec_total2003_2006 exp_total2003_2006 desplazados2003_2006 coca2003_2006
sum `controls'
keep M T1 T2 Y x1 x2 cod_depto coddepto_1-coddepto_33 `controls'

*Mediation analysis:
medeff (regress M T1-T2 x1 x2 `controls') (regress Y T1-T2 M x1 x2 `controls'), treat(T1-T2) mediate(M) sims(1000) vce(cluster cod_depto)

*Sensitivity analysis: 
local controls regalias2003_2006_pc transferencias2003_2006_pc areakm2 alt_mun discapital left2003 trad2003 third2003 peaceful2003_2006 mil_bases_2003_2006 rec_total2003_2006 exp_total2003_2006 desplazados2003_2006 coca2003_2006
sum `controls'
medsens (regress M T1 T2 x1 x2 `controls') (regress Y T1 T2 M x1 x2 `controls'), treat(T1) mediate(M) sims(1000) 


*-----------------------------------------
*2007-2010 Treatment on 2011-2013 Outcome: expect a positive ACME
*-----------------------------------------

use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lningreso_predial03_06_pc2==.
drop if lnlight2003_2006_pc2 ==.

gen M= lnlight2011_2013_pc2
gen T1= lnguer2007_2010_pc_2
gen T2= lnpara2007_2010_pc_2
gen Y=lningreso_predial11_13_pc2
gen x1= lnlight2003_2006_pc2
gen x2= lningreso_predial03_06_pc2

tabulate cod_depto, generate(coddepto_)

local controls regalias2007_2010_pc transferencias2007_2010_pc areakm2 alt_mun discapital left2007 trad2007 third2007 peaceful2007_2010 mil_bases_2007_2009 rec_total2007_2010 exp_total2007_2010 desplazados2007_2010 coca2007_2010
sum `controls'
keep M T1 T2 Y x1 x2 cod_depto coddepto_1-coddepto_33 `controls'

*Mediation analysis:
medeff (regress M T1-T2 x1 x2 `controls') (regress Y T1-T2 M x1 x2 `controls'), treat(T1-T2) mediate(M) sims(1000) vce(cluster cod_depto)

*Sensitivity analysis: 
local controls regalias2007_2010_pc transferencias2007_2010_pc areakm2 alt_mun discapital left2007 trad2007 third2007 peaceful2007_2010 mil_bases_2007_2009 rec_total2007_2010 exp_total2007_2010 desplazados2007_2010 coca2007_2010
sum `controls'
medsens (regress M T1 T2 x1 x2 `controls') (regress Y T1 T2 M x1 x2 `controls'), treat(T2) mediate(M) sims(1000) 

*/

*-----------------------------------------------------------------------------*
*APPENDIX D: EFFECT OF CUMULATIVE PAST VIOLENCE ON TAX PERFORMANCE, DROPPING OUT MUNS WITH ONE-SIDED VIOLENCE
*-----------------------------------------------------------------------------*

/* 
-We carry out two robustness checks of our armed group presence measure, cumulative attacks per capita by non-state 
armed group:

(1) Show the correlation of cumulative guerrilla violence per capita with the Zonas Veredales de Desmovilización (as well as
the correlation with the municipalities with high priority for state-building, i.e. zonas within PDETs [Programa de 
Desarrollo con Enfoque Territorial], and the correlation of cumulative paramilitary violence per capita with Zonas de 
Desmovilización paramilitar.
(2) Subsett out municipalities with only one-sided violence. 

*/

use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

***************************************************************************************
*Armed group presence measure: correlation between cum guerrilla violence and Zonas Veredales de Desmovilización
***************************************************************************************
pwcorr guer2007_2010_pc zona_veredal, sig /*significant*/
pwcorr para2007_2010_pc zona_veredal, sig /*significant but small*/

***************************************************************************************
*Armed group presence measure: correlation between cum guerrilla violence and PDETs (Plan de Desarrollo Territorial)
***************************************************************************************
pwcorr guer2007_2010_pc pdet, sig /*significant*/
pwcorr para2007_2010_pc pdet, sig /*significant but small*/

***************************************************************************************
*Armed group presence measure: correlation between cum para violence and Zonas de Desmovilización
***************************************************************************************
pwcorr guer1997_2002_pc demobilization, sig /*non significant*/
pwcorr para1997_2002_pc demobilization, sig /*significant*/


***************************************************************
/*TABLE 2D. CUMULATIVE VIOLENCE AND LOG PROPERTY TAX PERFORMANCE, SUBSETTING OUT MUNICIPALITIES WITH NO CONTESTATION 
AND/OR ONE-SIDED CONTESTATION*/
***************************************************************

eststo clear 

 * [1997-2002]
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial85_87_pc2==.
 
local controls1 regalias1988_1996_pc transferencias1988_1996_pc areakm2 alt_mun discapital left1994 trad1994 third1994 peaceful1988_1996 rec_total1993_1996 exp_total1993_1996 desplazados1993_1996 coca1993_1996 

foreach i in lningreso_predial97_02_pc2 {
 
 drop if peaceful_2_1988_1996==1

 eststo: quietly xi: reg `i'  lnguer1988_1996_pc_2 lnpara1988_1996_pc_2  `controls1'  i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged
 estadd local onesided  \checkmark

 eststo: quietly xi: reg `i' lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 lningreso_predial85_87_pc2  `controls1'  i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
 estadd local onesided \checkmark

 }



* [2003-2006]
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lningreso_predial93_96_pc2==.

local controls2 regalias1997_2002_pc transferencias1997_2002_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1997_2002 mil_bases_1999_2002 rec_total1997_2002 exp_total1997_2002 desplazados1997_2002 coca1997_2002 endowments1997_2002 

foreach i in lningreso_predial03_06_pc2 {

 drop if peaceful_2_1997_2002==1

 eststo: quietly xi: reg `i'  lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 `controls2'  i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged 
 estadd local onesided \checkmark
 
 eststo: quietly xi: reg `i' lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lningreso_predial93_96_pc2 `controls2'  i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
 estadd local onesided \checkmark

}



*[2007-2010]

*download dataset again:
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lningreso_predial00_02_pc2==.

local controls3 regalias2003_2006_pc transferencias2003_2006_pc areakm2 alt_mun discapital left2003 trad2003 third2003 peaceful2003_2006 mil_bases_2003_2006 rec_total2003_2006 exp_total2003_2006 desplazados2003_2006 coca2003_2006 endowments2003_2006 

foreach i in lningreso_predial07_10_pc2 {

drop if peaceful_2_2003_2006 ==1

 eststo: quietly xi: reg `i'  lnguer2003_2006_pc_2 lnpara2003_2006_pc_2 `controls3' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged 
 estadd local onesided \checkmark
 
 eststo: quietly xi: reg `i' lnguer2003_2006_pc_2 lnpara2003_2006_pc_2 lningreso_predial00_02_pc2 `controls3' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
 estadd local onesided  \checkmark
 
 }

*[2011-2013] - Falsification test

*download dataset again:
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lningreso_predial03_06_pc2==.

local controls4 regalias2007_2010_pc transferencias2007_2010_pc areakm2 alt_mun discapital left2007 trad2007 third2007 peaceful2007_2010 mil_bases_2007_2009 rec_total2007_2010 exp_total2007_2010 desplazados2007_2010 coca2007_2010 endowments2007_2010 

foreach i in lningreso_predial11_13_pc2 {

drop if peaceful_2_2007_2010 ==1

 eststo: quietly xi: reg `i'  lnguer2007_2010_pc_2 lnpara2007_2010_pc_2 `controls4' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged 
 estadd local onesided  \checkmark
 
 eststo: quietly xi: reg `i' lnguer2007_2010_pc_2 lnpara2007_2010_pc_2 lningreso_predial03_06_pc2 `controls4' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
 estadd local onesided  \checkmark
 
 
 }


esttab using "../TABLES/table2_appendixD.tex", replace f b(%9.4f) se(%9.4f) se  star(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
 s(N r2 controls fixed lagged  onesided, fmt(0 3) label("Observations" "R-squared" "Controls$^a$" "Depto. FE" "Pre-period tax revenue$^b$" "\begin{tabular}[c]{@{}l@{}}Drop if one-sided \\ violence only \end{tabular}")) ///
keep(lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lnguer2003_2006_pc_2 lnpara2003_2006_pc_2 lnguer2007_2010_pc_2 lnpara2007_2010_pc_2) ///
mgroups(1997-2002 2003-2006 2007-2010 2011-2013, pattern(1 0 1 0 1 0 1 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
coeflabel(lnguer1988_1996_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{1988-1996}\end{tabular}" lnpara1988_1996_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{1988-1996}\end{tabular}" lnguer1997_2002_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{1997-2002}\end{tabular}" lnpara1997_2002_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{1997-2002}\end{tabular}" lnguer2003_2006_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{2003-2006}\end{tabular}" lnpara2003_2006_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{2003-2006}\end{tabular}" lnguer2007_2010_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{2007-2010}\end{tabular}" lnpara2007_2010_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{2007-2010}\end{tabular}") ///
collabels(none) nonotes booktabs nomtitles nolines

*-----------------------------------------------------------------------------*
*APPENDIX E: MOVING-WINDOW ANALYSIS
*-----------------------------------------------------------------------------*
/* NOTES:
-See Figures do file. 
*/

*-----------------------------------------------------------------------------*
*APPENDIX F: MULTIPLE-TESTING CORRECTION
*-----------------------------------------------------------------------------*

/* NOTES:
-Three corrections where performed: the Holm correction; the Bejamini-Hochberg procedure, and the Bonferroni correction (a more conservative approach).
-Please see file "multiple_testing_corrections.R" for the procedure and estimations.
*/

*-----------------------------------------------------------------------------*
*APPENDIX G: WHY THIS MATTERS: CUM. ATTACKS ON SOCIAL AND ECONOMIC OUTCOMES 
*-----------------------------------------------------------------------------*

**********************************************************************************************
*TABLE G1. CONSEQUENCES: CUMULATIVE VIOLENCE (1997-2002) AND SOCIAL OUTCOMES (2003-2006)*
**********************************************************************************************

eststo clear 

use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

 drop if lningreso_predial93_96_pc2 ==.

local controls2 regalias1997_2002_pc transferencias1997_2002_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1997_2002 mil_bases_1999_2002 rec_total1997_2002 exp_total1997_2002 desplazados1997_2002 coca1997_2002 endowments1997_2002 

foreach i in tasa_escolaridad_secund03_06{
 eststo: quietly xi: reg `i'  lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 `controls2'  i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged 
 
 
 eststo: quietly xi: reg `i' lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lningreso_predial93_96_pc2 `controls2'  i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark

}

local controls2 regalias1997_2002_pc transferencias1997_2002_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1997_2002 mil_bases_1999_2002 rec_total1997_2002 exp_total1997_2002 desplazados1997_2002 coca1997_2002 endowments1997_2002 

foreach i in sum_matematica03_06{ 
 eststo: quietly xi: reg `i'  lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 `controls2'  i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged 
 
 eststo: quietly xi: reg `i' lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lningreso_predial93_96_pc2 `controls2'  i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
}

esttab using "../TABLES/tableG1_appendix.tex", replace f b(%9.4f) se(%9.4f) se  star(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
s(N r2 controls fixed lagged, fmt(0 3) label("Observations" "R-squared" "Controls$^a$" "Depto. FE" "Pre-period DV$^b$")) ///
keep(lnguer1997_2002_pc_2 lnpara1997_2002_pc_2) ///
mgroups("\emph{Secondary enrollment}" "\emph{Quality of edu. (math test)}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
coeflabel(lnguer1997_2002_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{1997-2002}\end{tabular}" lnpara1997_2002_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{1997-2002}\end{tabular}" ) ///
collabels(none) nonotes booktabs nomtitles nonumber nolines

 
***************************************************************
*TABLE G2. CONSEQUENCES: CUMULATIVE VIOLENCE AND ECONOMIC ACTIVITY  *
***************************************************************
eststo clear 

 * [1997-2002]
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lnlight92_pc ==.
 
local controls1 regalias1988_1996_pc transferencias1988_1996_pc areakm2 alt_mun discapital left1994 trad1994 third1994 peaceful1988_1996 rec_total1993_1996 exp_total1993_1996 desplazados1993_1996 coca1993_1996 

foreach i in lnlight1997_2002_pc2 {
 eststo: quietly xi: reg `i'  lnguer1988_1996_pc_2 lnpara1988_1996_pc_2  `controls1'  i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged 

 eststo: quietly xi: reg `i' lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 lnlight92_pc  `controls1'  i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
 }


* [2003-2006]
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lnlight1992_1996_pc2 ==.

local controls2 regalias1997_2002_pc transferencias1997_2002_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1997_2002 mil_bases_1999_2002 rec_total1997_2002 exp_total1997_2002 desplazados1997_2002 coca1997_2002 endowments1997_2002 

foreach i in lnlight2003_2006_pc2 {
 eststo: quietly xi: reg `i'  lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 `controls2'  i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged 
 
 eststo: quietly xi: reg `i' lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lnlight1992_1996_pc2 `controls2'  i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark

}

*[2007-2010]

*download dataset again:
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lnlight2000_2002_pc2 ==.

local controls3 regalias2003_2006_pc transferencias2003_2006_pc areakm2 alt_mun discapital left2003 trad2003 third2003 peaceful2003_2006 mil_bases_2003_2006 rec_total2003_2006 exp_total2003_2006 desplazados2003_2006 coca2003_2006 endowments2003_2006 

foreach i in lnlight2007_2010_pc2 {
 eststo: quietly xi: reg `i'  lnguer2003_2006_pc_2 lnpara2003_2006_pc_2 `controls3' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged 
 
 eststo: quietly xi: reg `i' lnguer2003_2006_pc_2 lnpara2003_2006_pc_2 lnlight2000_2002_pc2 `controls3' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
 }

*[2011-2013] - Falsification test

*download dataset again:
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lnlight2003_2006_pc2 ==.

local controls4 regalias2007_2010_pc transferencias2007_2010_pc areakm2 alt_mun discapital left2007 trad2007 third2007 peaceful2007_2010 mil_bases_2007_2009 rec_total2007_2010 exp_total2007_2010 desplazados2007_2010 coca2007_2010 endowments2007_2010 

foreach i in lnlight2011_2013_pc2 {
 eststo: quietly xi: reg `i'  lnguer2007_2010_pc_2 lnpara2007_2010_pc_2 `controls4' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged 
 
 eststo: quietly xi: reg `i' lnguer2007_2010_pc_2 lnpara2007_2010_pc_2 lnlight2003_2006_pc2 `controls4' i.cod_depto, cluster(cod_depto)
 estadd local fixed \checkmark
 estadd local controls \checkmark
 estadd local lagged  \checkmark
 }


esttab using "../TABLES/tableG2_appendix.tex", replace f b(%9.4f) se(%9.4f) se  star(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
 s(N r2 controls fixed lagged, fmt(0 3) label("Observations" "R-squared" "Controls$^a$" "Depto. FE" "Pre-period DV$^b$")) ///
keep(lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lnguer2003_2006_pc_2 lnpara2003_2006_pc_2 lnguer2007_2010_pc_2 lnpara2007_2010_pc_2) ///
mgroups(1997-2002 2003-2006 2007-2010 2011-2013, pattern(1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
coeflabel(lnguer1988_1996_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{1988-1996}\end{tabular}" lnpara1988_1996_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{1988-1996}\end{tabular}" lnguer1997_2002_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{1997-2002}\end{tabular}" lnpara1997_2002_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{1997-2002}\end{tabular}" lnguer2003_2006_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{2003-2006}\end{tabular}" lnpara2003_2006_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{2003-2006}\end{tabular}" lnguer2007_2010_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{2007-2010}\end{tabular}" lnpara2007_2010_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{2007-2010}\end{tabular}") ///
collabels(none) nonotes booktabs nomtitles nolines



***************** END ***********************












