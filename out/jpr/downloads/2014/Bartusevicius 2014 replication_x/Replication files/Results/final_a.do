***********************************************************
* Replication do-file for Paper (2013), PART 1 (ANALYSIS) *
***********************************************************
clear all
set memory 100m
set more off

*Set file path*
cd "..."

use final_a, clear

**********************************************************************
*                              Main Results                          *
**********************************************************************


**********************************
*  Table I (summary statistics)  *
**********************************
sum popreb iginit eginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears if imp==0

**********************************
*    Table II (original data)    *
**********************************
logit popreb iginit lnpops epyears if imp == 0, robust
logit popreb eginit lnpops epyears if imp == 0, robust
logit popreb iginit eginit lnpops epyears if imp == 0, robust
logit popreb iginit eginit xpolt14 lnpops epyears if imp == 0, robust
logit popreb iginit eginit xpolt14 xpolt142 lnpops epyears if imp == 0, robust
logit popreb iginit eginit xpolt14 xpolt142 lngdp_pct lnpops epyears if imp == 0, robust
logit popreb iginit eginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears if imp == 0, robust
logit popreb iginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears if imp == 0, robust
logit popreb iginit iginit2 xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears if imp == 0, robust
logit popreb eginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears if imp == 0, robust
logit popreb eginit eginit2 xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears if imp == 0, robust

**********************************
*    Table III (imputed data)    *
**********************************
*data was declared as mi data by: mi import flong, m(imp) id(location year) imputed(iginit eginit xpolt14 xpolt142 gdp_pcgt lngdp_pct iginit2 eginit2) passive(epyears lnpops)*
mi estimate: logit popreb iginit lnpops epyears, robust
mi estimate: logit popreb eginit lnpops epyears, robust
mi estimate: logit popreb iginit eginit lnpops epyears, robust
mi estimate: logit popreb iginit eginit xpolt14 lnpops epyears, robust
mi estimate: logit popreb iginit eginit xpolt14 xpolt142 lnpops epyears, robust
mi estimate: logit popreb iginit eginit xpolt14 xpolt142 lngdp_pct lnpops epyears, robust
mi estimate: logit popreb iginit eginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears, robust
mi estimate: logit popreb iginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears, robust
mi estimate: logit popreb iginit iginit2 xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears, robust
mi estimate: logit popreb eginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears, robust
mi estimate: logit popreb eginit eginit2 xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears, robust





**********************************************************************
*                  Robustness tests (Online Appendix)                *
**********************************************************************


***********************************************************
*       Table IIa (including coups)(original data)        *
***********************************************************
logit popreb_c iginit lnpops epyears if imp == 0, robust
logit popreb_c eginit lnpops epyears if imp == 0, robust
logit popreb_c iginit eginit lnpops epyears if imp == 0, robust
logit popreb_c iginit eginit xpolt14 lnpops epyears if imp == 0, robust
logit popreb_c iginit eginit xpolt14 xpolt142 lnpops epyears if imp == 0, robust
logit popreb_c iginit eginit xpolt14 xpolt142 lngdp_pct lnpops epyears if imp == 0, robust
logit popreb_c iginit eginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears if imp == 0, robust
logit popreb_c iginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears if imp == 0, robust
logit popreb_c iginit iginit2 xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears if imp == 0, robust
logit popreb_c eginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears if imp == 0, robust
logit popreb_c eginit eginit2 xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears if imp == 0, robust

***********************************************************
*       Table IIb (including coups)(imputed data)         *
***********************************************************
mi estimate: logit popreb_c iginit lnpops epyears, robust
mi estimate: logit popreb_c eginit lnpops epyears, robust
mi estimate: logit popreb_c iginit eginit lnpops epyears, robust
mi estimate: logit popreb_c iginit eginit xpolt14 lnpops epyears, robust
mi estimate: logit popreb_c iginit eginit xpolt14 xpolt142 lnpops epyears, robust
mi estimate: logit popreb_c iginit eginit xpolt14 xpolt142 lngdp_pct lnpops epyears, robust
mi estimate: logit popreb_c iginit eginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears, robust
mi estimate: logit popreb_c iginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears, robust
mi estimate: logit popreb_c iginit iginit2 xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears, robust
mi estimate: logit popreb_c eginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears, robust
mi estimate: logit popreb_c eginit eginit2 xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears, robust

***********************************************************
*Table IIIa (excluding sectarian conflicts)(original data)*
***********************************************************
logit popreb_r iginit lnpops epyears if imp == 0, robust
logit popreb_r eginit lnpops epyears if imp == 0, robust
logit popreb_r iginit eginit lnpops epyears if imp == 0, robust
logit popreb_r iginit eginit xpolt14 lnpops epyears if imp == 0, robust
logit popreb_r iginit eginit xpolt14 xpolt142 lnpops epyears if imp == 0, robust
logit popreb_r iginit eginit xpolt14 xpolt142 lngdp_pct lnpops epyears if imp == 0, robust
logit popreb_r iginit eginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears if imp == 0, robust
logit popreb_r iginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears if imp == 0, robust
logit popreb_r iginit iginit2 xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears if imp == 0, robust
logit popreb_r eginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears if imp == 0, robust
logit popreb_r eginit eginit2 xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears if imp == 0, robust

***********************************************************
*Table IIIb (excluding sectarian conflicts)(imputed data) *
***********************************************************
mi estimate: logit popreb_r iginit lnpops epyears, robust
mi estimate: logit popreb_r eginit lnpops epyears, robust
mi estimate: logit popreb_r iginit eginit lnpops epyears, robust
mi estimate: logit popreb_r iginit eginit xpolt14 lnpops epyears, robust
mi estimate: logit popreb_r iginit eginit xpolt14 xpolt142 lnpops epyears, robust
mi estimate: logit popreb_r iginit eginit xpolt14 xpolt142 lngdp_pct lnpops epyears, robust
mi estimate: logit popreb_r iginit eginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears, robust
mi estimate: logit popreb_r iginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears, robust
mi estimate: logit popreb_r iginit iginit2 xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears, robust
mi estimate: logit popreb_r eginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears, robust
mi estimate: logit popreb_r eginit eginit2 xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears, robust

***************************************************************************
*Table IVa (excluding conflicts with limited participation)(original data)*
***************************************************************************
logit popreb_a iginit lnpops epyears if imp == 0, robust
logit popreb_a eginit lnpops epyears if imp == 0, robust
logit popreb_a iginit eginit lnpops epyears if imp == 0, robust
logit popreb_a iginit eginit xpolt14 lnpops epyears if imp == 0, robust
logit popreb_a iginit eginit xpolt14 xpolt142 lnpops epyears if imp == 0, robust
logit popreb_a iginit eginit xpolt14 xpolt142 lngdp_pct lnpops epyears if imp == 0, robust
logit popreb_a iginit eginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears if imp == 0, robust
logit popreb_a iginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears if imp == 0, robust
logit popreb_a iginit iginit2 xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears if imp == 0, robust
logit popreb_a eginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears if imp == 0, robust
logit popreb_a eginit eginit2 xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears if imp == 0, robust

***************************************************************************
*Table IVb (excluding conflicts with limited participation)(imputed data) *
***************************************************************************
mi estimate: logit popreb_a iginit lnpops epyears, robust
mi estimate: logit popreb_a eginit lnpops epyears, robust
mi estimate: logit popreb_a iginit eginit lnpops epyears, robust
mi estimate: logit popreb_a iginit eginit xpolt14 lnpops epyears, robust
mi estimate: logit popreb_a iginit eginit xpolt14 xpolt142 lnpops epyears, robust
mi estimate: logit popreb_a iginit eginit xpolt14 xpolt142 lngdp_pct lnpops epyears, robust
mi estimate: logit popreb_a iginit eginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears, robust
mi estimate: logit popreb_a iginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears, robust
mi estimate: logit popreb_a iginit iginit2 xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears, robust
mi estimate: logit popreb_a eginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears, robust
mi estimate: logit popreb_a eginit eginit2 xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears, robust


