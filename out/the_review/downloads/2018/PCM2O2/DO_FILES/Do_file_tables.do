*-----------------------------------------*
*** DO-FILE TABLES ***
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
-This do-file generates the descriptive statistics and regression results: Table 1-4.

*/

************************************************************************************************************************

**** INSTALL RELEVANT ADO-FILES
*ssc install esta, replace

************************************************************************************************************************

clear all
set maxvar 32500 
set more off 
set varabbrev off

*Set working directory wherever the "Replication_material_R&R/DO_FILES" folder is:
cd "/Users/rafach/Dropbox/PRINCETON-COLOMBIA/RESEARCH/TAXATION/Dropbox/Taxation paper/Analysis/Replication_material_R&R/DO_FILES"

 
****************************
*TABLE 1. DESCRIPTIVE STATS*
****************************

use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

*Cumulative attacks
eststo clear 
estpost sum lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lnguer2003_2006_pc_2 lnpara2003_2006_pc_2 lnguer2007_2010_pc_2 lnpara2007_2010_pc_2 lnguer2003_2010_pc_2 lnpara2003_2010_pc_2
est store table1a

esttab using "../TABLES/table1a.tex", replace  cells("mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0)) count(fmt(0))") ///
label nonumber f  noobs alignment(S) booktabs nomtitles plain collabels(none) ///
coeflabel(lnguer1988_1996_pc_2 "Log guerrilla attacks per capita, 1988-1996" lnpara1988_1996_pc_2 "Log paramilitary attacks per capita, 1988-1996" lnguer1997_2002_pc_2 "Log guerrilla attacks per capita, 1997-2002" lnpara1997_2002_pc_2 "Log paramilitary attacks per capita, 1997-2002" lnguer2003_2006_pc_2 "Log guerrilla attacks per capita, 2003-2006" lnpara2003_2006_pc_2 "Log paramilitary attacks per capita, 2003-2006" lnguer2007_2010_pc_2 "Log guerrilla attacks per capita, 2007-2010" lnpara2007_2010_pc_2 "Log paramilitary attacks per capita, 2007-2010" lnguer2003_2010_pc_2 "Log guerrilla attacks per capita, 2003-2010" lnpara2003_2010_pc_2 "Log paramilitary attacks per capita, 2003-2010")


*Log of property tax revenue, at constant prices 2008 (thousand pesos)
eststo clear 

estpost sum lningreso_predial97_02_pc2 lningreso_predial03_06_pc2 lningreso_predial07_10_pc2 lningreso_predial11_13_pc2
est store table1b
esttab using "../TABLES/table1b.tex", replace  cells("mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0)) count(fmt(0))") ///
label nonumber f  noobs alignment(S) booktabs nomtitles plain collabels(none) ///
coeflabel(lningreso_predial97_02_pc2 "Log property tax revenues per capita 1997-2002" lningreso_predial03_06_pc2 "Log property tax revenues per capita 2003-2006" lningreso_predial07_10_pc2 "Log property tax revenues per capita 2007-2010" lningreso_predial11_13_pc2 "Log property tax revenues per capita 2011-2013" )

*Cadastral performance
eststo clear 

estpost sum  avaluo_rur_pcrur03_06 rezago_catastral03_06 numactualizaciones03_06
est store table1c
esttab using "../TABLES/table1c.tex", replace  cells("mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0)) count(fmt(0))") ///
label nonumber f  noobs alignment(S) booktabs nomtitles plain collabels(none) ///
coeflabel(avaluo_rur_pcrur03_06 "Per capita land value 2003-2006" rezago_catastral03_06 "Cadastral update lag 2003-2006" numactualizaciones03_06 "Num. cadastral updates 2003-2006" )

*Land ownership
eststo clear 

estpost sum  informalidad03_06
est store table1d
esttab using "../TABLES/table1d.tex", replace  cells("mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0)) count(fmt(0))") ///
label nonumber f  noobs alignment(S) booktabs nomtitles plain collabels(none) ///
coeflabel(informalidad03_06 "Land informality rate 2003-2006" )

*Social outcomes
eststo clear 

estpost sum  tasa_escolaridad_secund03_06 sum_matematica03_06
est store table1e
esttab using "../TABLES/table1e.tex", replace  cells("mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0)) count(fmt(0))") ///
label nonumber f  noobs alignment(S) booktabs nomtitles plain collabels(none) ///
coeflabel(tasa_escolaridad_secund03_06 "Secondary enrollment rate 2003-2006" sum_matematica03_06 "Quality of education (average math score) 2003-2006")

*Economic activity 
eststo clear 

estpost sum  lnlight1997_2002_pc2 lnlight2003_2006_pc2 lnlight2007_2010_pc2 lnlight2011_2013_pc2
est store table1f
esttab using "../TABLES/table1f.tex", replace  cells("mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0)) count(fmt(0))") ///
label nonumber f  noobs alignment(S) booktabs nomtitles plain collabels(none) ///
coeflabel(lnlight1997_2002_pc2 "Log luminosity per capita 1997-2002" lnlight2003_2006_pc2 "Log luminosity per capita 2003-2006" lnlight2007_2010_pc2 "Log luminosity per capita 2007-2010"  lnlight2011_2013_pc2 "Log luminosity per capita 2011-2013")

*Electoral outcomes
eststo clear 

estpost sum  won_uribe_conservador97_99 won_uribe_conservador00_02 won_uribe_conservador97_00 won_uribe_conservador03_06 won_uribe_conservador07_10 won_uribe_conservador03_07 won_uribe_conservador11_12
est store table1g
esttab using "../TABLES/table1g.tex", replace  cells("mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0)) count(fmt(0))") ///
label nonumber f  noobs alignment(S) booktabs nomtitles plain collabels(none) ///
coeflabel(won_uribe_conservador97_99 "Uribe + Conservative party coalition 1997 Mayor election" won_uribe_conservador00_02 "Uribe + Conservative party coalition 2000 Mayor election" won_uribe_conservador97_00 "Uribe + Conservative party coalition 1997 and 2000 Mayor elections" won_uribe_conservador03_06 "Uribe + Conservative party coalition 2003 Mayor election" won_uribe_conservador07_10 "Uribe + Conservative party coalition 2007 Mayor election" won_uribe_conservador03_07 "Uribe + Conservative party coalition 2003 and 2007 Mayor elections" won_uribe_conservador11_12 "Uribe + Conservative party coalition 2011 Mayor election")



***************************************************************
*TABLE 2. CUMULATIVE VIOLENCE AND LOG PROPERTY TAX PERFORMANCE* 
***************************************************************

eststo clear 

 * [1997-2002]
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
 drop if lningreso_predial85_87_pc2==.
 
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
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lningreso_predial93_96_pc2==.

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

*download dataset again:
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lningreso_predial00_02_pc2==.

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

*download dataset again:
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lningreso_predial03_06_pc2==.

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


esttab using "../TABLES/table2.tex", replace f b(%9.4f) se(%9.4f) se  star(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
 s(N r2 controls fixed lagged, fmt(0 3) label("Observations" "R-squared" "Controls$^a$" "Depto. FE" "Pre-period tax revenue$^b$")) ///
keep(lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lnguer2003_2006_pc_2 lnpara2003_2006_pc_2 lnguer2007_2010_pc_2 lnpara2007_2010_pc_2) ///
mgroups(1997-2002 2003-2006 2007-2010 2011-2013, pattern(1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
coeflabel(lnguer1988_1996_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{1988-1996}\end{tabular}" lnpara1988_1996_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{1988-1996}\end{tabular}" lnguer1997_2002_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{1997-2002}\end{tabular}" lnpara1997_2002_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{1997-2002}\end{tabular}" lnguer2003_2006_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{2003-2006}\end{tabular}" lnpara2003_2006_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{2003-2006}\end{tabular}" lnguer2007_2010_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{2007-2010}\end{tabular}" lnpara2007_2010_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{2007-2010}\end{tabular}") ///
collabels(none) nonotes booktabs nomtitles nolines

******************************************************************************************************
*TABLE 3. MECHANISMS II: CUMULATIVE VIOLENCE PER CAPITA (1997-2002) AND POTENTIAL MECHANISMS (2003-2006)*
******************************************************************************************************


use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if  lningreso_predial93_96_pc2 ==.

eststo clear 

local controls2 regalias1997_2002_pc transferencias1997_2002_pc areakm2 alt_mun discapital left2000 trad2000 third2000 peaceful1997_2002 mil_bases_1999_2002 rec_total1997_2002 exp_total1997_2002 desplazados1997_2002 coca1997_2002 endowments1997_2002 

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

esttab using "../TABLES/table3.tex", replace f b(%9.4f) se(%9.4f) se  star(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
s(N r2 controls fixed lagged, fmt(0 3) label("Observations" "R-squared" "Controls$^a$" "Depto. FE" "Pre-period tax revenue$^b$")) ///
keep(lnguer1997_2002_pc_2 lnpara1997_2002_pc_2) ///
mgroups("\emph{Per capita land value}" "\emph{Cadastral update lag}" "\emph{\# cadastral updates}" "\emph{Land informality rate}", pattern(1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
coeflabel(lnguer1997_2002_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{1997-2002}\end{tabular}" lnpara1997_2002_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{1997-2002}\end{tabular}" ) ///
collabels(none) nonotes booktabs nomtitles nonumber nolines


******************************************************************************************************
*TABLE 4. MECHANISMS I: DIRECT CAPTURE, CUMULATIVE VIOLENCE AND ELECTORAL OUTCOMES*
******************************************************************************************************

******************
*PANEL A*
******************


eststo clear 

*Mayor Elections, 1997 and 2000 (falsification) 
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
drop if won_uribe_conservador94_96 ==.

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


*Mayor Elections, 2003 and 2007

use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if won_uribe_conservador94_96 ==.

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

*Mayor Election, 2011 

use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

drop if won_uribe_conservador00_02 ==.

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

esttab using "../TABLES/table4_panelA.tex", replace f  b(%9.4f) se(%9.4f) se  star(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
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
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
drop if share_uribe_conservador94_96 ==.

local controls1 regalias1988_1996_pc transferencias1988_1996_pc areakm2 alt_mun discapital left1994 trad1994 third1994 peaceful1988_1996 rec_total1993_1996 exp_total1993_1996 desplazados1993_1996 coca1993_1996 
*coffee evercoca

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

use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

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

use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

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

esttab using "../TABLES/table4_panelB.tex", replace f  b(%9.4f) se(%9.4f) se star(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
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
use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear
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

use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

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

use "../DATA/ENDOGENOUS_TAXATION_V2.dta", clear

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

esttab using "../TABLES/table4_panelC.tex", replace f  b(%9.4f) se(%9.4f) se star(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
 s(N r2 controls fixed lagged, fmt(0 3) label("Observations" "R-squared" "Controls$^b$" "Depto. FE" "Pre-period DV$^c$")) ///
keep(lnguer1988_1996_pc_2 lnpara1988_1996_pc_2 lnguer1997_2002_pc_2 lnpara1997_2002_pc_2 lnguer2003_2010_pc_2 lnpara2003_2010_pc_2) ///
mgroups("1997 and 2000 Elections" "2003 and 2007 Elections" "2011 Election", pattern(1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
coeflabel(lnguer1988_1996_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{1988-1996}\end{tabular}" lnpara1988_1996_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{1988-1996}\end{tabular}" lnguer1997_2002_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{1997-2002}\end{tabular}" lnpara1997_2002_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{1997-2002}\end{tabular}"  lnguer2003_2010_pc_2 "\begin{tabular}[c]{@{}l@{}}Log guerrilla attacks\\ per capita \underline{2003-2010}\end{tabular}" lnpara2003_2010_pc_2 "\begin{tabular}[c]{@{}l@{}}Log paramilitary attacks\\ per capita \underline{2003-2010}\end{tabular}") ///
collabels(none) nonotes booktabs nomtitles nolines



***************** END ***********************



