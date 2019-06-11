*tab 1 - model 1*
logit dv i.closgov2 left_right gov_perf S25_1r i.ole i.sle i.ecoatt2 ///
i.decvot rifcontr i.eu_support euro3 internet kwl_index s01 age edu1 ///
i.occup3, or vce(oim)
 fitstat
 lfit, group(10) table

*tab 1 - model 2*
logit dv i.closgov2 gov_perf S25_1r i.lrrad2 i.ole i.sle i.ecoatt2 ///
i.decvot rifcontr i.eu_support euro3 internet kwl_index s01 age edu1 ///
i.occup3, or vce(oim)
 fitstat
 lfit, group(10) table

*tab 1 - model 3*
logit dv i.closgov2 S25_1r c.gov_perf##i.lrrad2 i.ole i.sle i.ecoatt2 i.decvot rifcontr i.eu_support euro3 internet kwl_index s01 age edu1 i.occup3, or vce(oim)
 fitstat
 lfit, group(10) table

*tab 1 - model 3 - graph1*
logit dv i.closgov2 S25_1r c.gov_perf##i.lrrad2  i.ole i.sle i.ecoatt2 i.decvot rifcontr i.eu_support euro3 internet kwl_index s01 age edu1 i.occup3, or vce(oim)
margins, at (gov_perf=(0 (1) 10))
margins, dydx(lrrad2) at (gov_perf=(0 (1) 10)) vsquish post
marginsplot, level (95) yline(0)


************************robust check*

*tab 2 - model 1*
logit abstention i.closgov2 gov_perf S25_1r left_right i.ole i.sle i.ecoatt2 i.decvot rifcontr i.eu_support euro3 internet kwl_index s01 age edu1 i.occup3, or vce(oim)
 fitstat
 lfit, group(10) table

 *tab 2 - model 2*
logit abstention i.closgov2 gov_perf S25_1r i.lrrad2 i.ole i.sle i.ecoatt2 i.decvot rifcontr i.eu_support euro3 internet kwl_index s01 age edu1 i.occup3, or vce(oim)
 fitstat
 lfit, group(10) table

 *tab 2 - model 3*
logit abstention i.closgov2 gov_perf S25_1r c.gov_perf##i.lrrad2 i.ole i.sle i.ecoatt2 i.decvot rifcontr i.eu_support euro3 internet kwl_index s01 age edu1 i.occup3, or vce(oim)
 fitstat
 lfit, group(10) table



 
 
