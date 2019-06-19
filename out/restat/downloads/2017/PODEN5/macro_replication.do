
set maxvar 15000
set matsize 11000

use county_data_merged_repvars.dta, clear

set more off, permanently 

/* Table 3. bankruptcy and job losses
controls for county and year fixed effects and county-specific time trends */

reghdfe totrat1000  djobrat [aw = meanlpolywgt], absorb(county year i.county#c.year) cluster(county)
outreg2 using countyratregs_trends_rep_111517, append bdec(3)

reghdfe ch7rat1000  djobrat [aw = meanlpolywgt], absorb(county year i.county#c.year) cluster(county)
outreg2 using countyratregs_trends_rep_111517, append bdec(3)

reghdfe ch13rat1000  djobrat [aw = meanlpolywgt], absorb(county year i.county#c.year) cluster(county)
outreg2 using countyratregs_trends_rep_111517, append bdec(3)

reghdfe totrat1000  dmanurat dnonmanurat [aw = meanlpolywgt], absorb(county year i.county#c.year) cluster(county)
outreg2 using countyratregs_trends_rep_111517, append bdec(3)

reghdfe totrat1000  (djobrat = djobrat_bartik) [aw = meanlpolywgt], absorb(county year i.county#c.year) cluster(county)
outreg2 using countyratregs_trends_iv_rep_111517, replace bdec(3)
    
reghdfe ch7rat1000  (djobrat = djobrat_bartik) [aw = meanlpolywgt], absorb(county year i.county#c.year) cluster(county)    
outreg2 using countyratregs_trends_iv_rep_111517, append bdec(3)

reghdfe ch13rat1000 (djobrat = djobrat_bartik) [aw = meanlpolywgt], absorb(county year i.county#c.year) cluster(county)
outreg2 using countyratregs_trends_iv_rep_111517, append bdec(3)

/* Table 4. heterogeneity 
controls for county and year fixed effects */

reghdfe totrat1000 djobrat djobrat_high_uerate   [aw = meanlpolywgt], absorb(county year) cluster(county)
outreg2 using countyratregs_trends_heterog_fe_111517, replace bdec(3)
reghdfe totrat1000 djobrat djobrat_above_med_hs  [aw = meanlpolywgt], absorb(county year) cluster(county)
outreg2 using countyratregs_trends_heterog_fe_111517, append bdec(3)
reghdfe totrat1000 djobrat djobrat_above_med_col [aw = meanlpolywgt], absorb(county year) cluster(county)
outreg2 using countyratregs_trends_heterog_fe_111517, append bdec(3)
reghdfe totrat1000 djobrat djobrat_above_med_blk [aw = meanlpolywgt], absorb(county year) cluster(county)
outreg2 using countyratregs_trends_heterog_fe_111517, append bdec(3)
reghdfe totrat1000 djobrat djobrat_above_med_age [aw = meanlpolywgt], absorb(county year) cluster(county)
outreg2 using countyratregs_trends_heterog_fe_111517, append bdec(3)
reghdfe totrat1000 djobrat djobrat_above_med_pop [aw = meanlpolywgt], absorb(county year) cluster(county)
outreg2 using countyratregs_trends_heterog_fe_111517, append bdec(3)
reghdfe totrat1000 djobrat djobrat_above_med_inc [aw = meanlpolywgt], absorb(county year) cluster(county)
outreg2 using countyratregs_trends_heterog_fe_111517, append bdec(3)

/* Table 5. mass layoffs 
controls for county and year fixed effects and county-specific time-trends */

reghdfe totrat1000  mlrat [aw = meanlpolywgt], absorb(county year i.county#c.year) cluster(county)
outreg2 using countyratregs_trends_ml_rep_111517, append bdec(3)
reghdfe ch7rat1000  mlrat [aw = meanlpolywgt], absorb(county year i.county#c.year) cluster(county)
outreg2 using countyratregs_trends_ml_rep_111517, append bdec(3)
reghdfe ch13rat1000 mlrat [aw = meanlpolywgt], absorb(county year i.county#c.year) cluster(county)
outreg2 using countyratregs_trends_ml_rep_111517, append bdec(3)
