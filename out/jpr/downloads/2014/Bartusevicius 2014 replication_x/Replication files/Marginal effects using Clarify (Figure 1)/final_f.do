**************************************************************************
*        Replication do-file for paper (2013); PART II (FIGURE 1)        *
**************************************************************************
* Requires installation of clarify*

clear all
set memory 100m
set more off

*Set file path*
cd "..."

use final_f, clear

preserve

********************************************
*  income Gini percentiles (original data) *
********************************************
quietly estsimp logit popreb iginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears if imp==0, robust
setx mean
setx iginit p5
setx
setx iginit p15
setx
setx iginit p25
setx
setx iginit p35
setx
setx iginit p45
setx
setx iginit p55
setx
setx iginit p65
setx
setx iginit p75
setx
setx iginit p85
setx
setx iginit p95
setx

*******************************************
*     Marginal effects (Model 1.8a)       *
*******************************************
setx iginit p5
simqi
setx iginit p10
simqi
setx iginit p15
simqi
setx iginit p20
simqi
setx iginit p25
simqi
setx iginit p30
simqi
setx iginit p35
simqi
setx iginit p40
simqi
setx iginit p45
simqi
setx iginit p50
simqi
setx iginit p55
simqi
setx iginit p60
simqi
setx iginit p65
simqi
setx iginit p70
simqi
setx iginit p75
simqi
setx iginit p80
simqi
setx iginit p85
simqi
setx iginit p90
simqi
setx iginit p95
simqi

restore
preserve

********************************************
*  income Gini percentiles (imputed data)  *
********************************************
quietly estsimp logit popreb iginit xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears, robust mi(imp1 imp2 imp3 imp4 imp5)
setx mean
setx iginit p5
setx
setx iginit p15
setx
setx iginit p25
setx
setx iginit p35
setx
setx iginit p45
setx
setx iginit p55
setx
setx iginit p65
setx
setx iginit p75
setx
setx iginit p85
setx
setx iginit p95
setx

*******************************************
*     Marginal effects (Model 2.8a)       *
*******************************************
setx iginit p5
simqi
setx iginit p10
simqi
setx iginit p15
simqi
setx iginit p20
simqi
setx iginit p25
simqi
setx iginit p30
simqi
setx iginit p35
simqi
setx iginit p40
simqi
setx iginit p45
simqi
setx iginit p50
simqi
setx iginit p55
simqi
setx iginit p60
simqi
setx iginit p65
simqi
setx iginit p70
simqi
setx iginit p75
simqi
setx iginit p80
simqi
setx iginit p85
simqi
setx iginit p90
simqi
setx iginit p95
simqi

restore
preserve

**********************************************
*  education Gini percentiles (original data)*
**********************************************
quietly estsimp logit popreb eginit eginit2 xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears if imp==0, robust
setx mean
setx eginit p5
setx
setx eginit p15
setx
setx eginit p25
setx
setx eginit p35
setx
setx eginit p45
setx
setx eginit p55
setx
setx eginit p65
setx
setx eginit p75
setx
setx eginit p85
setx
setx eginit p95
setx

*******************************************
*     Marginal effects (Model 1.9b)       *
*******************************************
setx eginit p5 eginit2 p5
simqi
setx eginit p10 eginit2 p10
simqi
setx eginit p15 eginit2 p15
simqi
setx eginit p20 eginit2 p20
simqi
setx eginit p25 eginit2 p25
simqi
setx eginit p30 eginit2 p30
simqi
setx eginit p35 eginit2 p35
simqi
setx eginit p40 eginit2 p40
simqi
setx eginit p45 eginit2 p45
simqi
setx eginit p50 eginit2 p50
simqi
setx eginit p55 eginit2 p55
simqi
setx eginit p60 eginit2 p60
simqi
setx eginit p65 eginit2 p65
simqi
setx eginit p70 eginit2 p70
simqi
setx eginit p75 eginit2 p75
simqi
setx eginit p80 eginit2 p80
simqi
setx eginit p85 eginit2 p85
simqi
setx eginit p90 eginit2 p90
simqi
setx eginit p95 eginit2 p95
simqi

restore
preserve

**********************************************
*  education Gini percentiles (imputed data) *
**********************************************
quietly estsimp logit popreb eginit eginit2 xpolt14 xpolt142 lngdp_pct gdp_pcgt lnpops epyears, robust mi(imp1 imp2 imp3 imp4 imp5)
setx mean
setx eginit p5
setx
setx eginit p15
setx
setx eginit p25
setx
setx eginit p35
setx
setx eginit p45
setx
setx eginit p55
setx
setx eginit p65
setx
setx eginit p75
setx
setx eginit p85
setx
setx eginit p95
setx

*******************************************
*     Marginal effects (Model 2.9b)       *
*******************************************
setx eginit p5 eginit2 p5
simqi
setx eginit p10 eginit2 p10
simqi
setx eginit p15 eginit2 p15
simqi
setx eginit p20 eginit2 p20
simqi
setx eginit p25 eginit2 p25
simqi
setx eginit p30 eginit2 p30
simqi
setx eginit p35 eginit2 p35
simqi
setx eginit p40 eginit2 p40
simqi
setx eginit p45 eginit2 p45
simqi
setx eginit p50 eginit2 p50
simqi
setx eginit p55 eginit2 p55
simqi
setx eginit p60 eginit2 p60
simqi
setx eginit p65 eginit2 p65
simqi
setx eginit p70 eginit2 p70
simqi
setx eginit p75 eginit2 p75
simqi
setx eginit p80 eginit2 p80
simqi
setx eginit p85 eginit2 p85
simqi
setx eginit p90 eginit2 p90
simqi
setx eginit p95 eginit2 p95
simqi

restore
