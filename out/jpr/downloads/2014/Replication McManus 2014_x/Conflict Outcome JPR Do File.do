
clear all

capture log close
 
set more off

log using "Conflict Outcome JPR Results.log", replace

use "Conflict Outcome JPR Data", clear


* Main models: Model 1 (short) and Model 2 (long)

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub, vce(robust)

margins, at( stat3w30d =(0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5 5.1 5.2 5.3 5.4 5.5 5.6 5.7 5.8 5.9 6 6.1 6.2 6.3 6.4 6.5 6.6 6.7 6.8 6.9 7 7.1 7.2 7.3 7.4 7.5 7.6 7.7 7.8 7.9 8 8.1 8.2 8.3 8.4 8.5 8.6 8.7 8.8 8.9 9 9.1 9.2 9.3 9.4 9.5 9.6 9.7 9.8 9.9 10 10.1 10.2 10.3 10.4 10.5 10.6 10.7 10.8 10.9 11 11.1 11.2 11.3 11.4 11.5 11.6 11.7 11.8 11.9 12 )) predict(outcome(3)) level(90)

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn, vce(robust)

est tab, p(%12.10g)

margins, at( stat3w30d =(0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5 5.1 5.2 5.3 5.4 5.5 5.6 5.7 5.8 5.9 6 6.1 6.2 6.3 6.4 6.5 6.6 6.7 6.8 6.9 7 7.1 7.2 7.3 7.4 7.5 7.6 7.7 7.8 7.9 8 8.1 8.2 8.3 8.4 8.5 8.6 8.7 8.8 8.9 9 9.1 9.2 9.3 9.4 9.5 9.6 9.7 9.8 9.9 10 10.1 10.2 10.3 10.4 10.5 10.6 10.7 10.8 10.9 11 11.1 11.2 11.3 11.4 11.5 11.6 11.7 11.8 11.9 12 )) predict(outcome(3)) level(90) noatlegend


* Addressing concerns regarding causality

//Matching

preserve

drop if year>2007

cem sideaa(.5) cincperc demb (.5) defensepact(.5) revterritory(.5) revregime(.5) pres(2.5 4.5 6.5 7.5 9.5 10.5), tr(statovermedian) showbreaks

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub [iweight=cem_weights], vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn [iweight=cem_weights], vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome statovermedian cincperc demb year_cen year_sq year_cub [iweight=cem_weights], vce(robust)

margins, at(statovermedian =(0 1)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome statovermedian cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn [iweight=cem_weights], vce(robust)

margins, at(statovermedian =(0 1)) predict(outcome(3)) level(90) noatlegend

restore

//Controlling for salience

oprobit ordoutcome stat3w30d nythits cincperc demb year_cen year_sq year_cub, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d nythits cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend


* Addressing distribution concerns

//Dropping outliers iteratively

// Because of how the data is sorted, _n in the command line gives the number of top outliers to be dropped.

gsort - stat3w30d

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>1, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>2, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>3, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>4, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>5, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>6, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>7, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>8, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>9, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>10, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>11, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>12, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>13, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>14, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>15, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>16, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>17, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>18, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>19, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>20, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>21, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>22, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>23, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>1, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>2, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>3, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>4, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>5, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>6, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>7, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>8, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>9, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>10, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>11, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>12, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>13, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>14, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>15, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>16, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>17, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>18, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>19, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>20, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>21, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

//Calculating Cook's D and dropping the most influential observations

reg ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub

predict d1, cooksd

gsort -d1

list dymidnum ccodeb styear ordoutcome d1 if _n<21

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>1, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>2, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>3, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>4, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>5, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>6, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>7, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>8, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>9, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>10, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>11, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>12, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>13, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>13 & dispnum!=4273, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>14, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>15, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if _n>20, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

reg ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn

predict d2, cooksd

gsort -d2

list dymidnum ccodeb styear ordoutcome d2 if _n<21

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>1, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>2, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>3, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>4, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>5, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>6, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>7, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>8, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>9, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>10, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>11, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>12, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>13, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>14, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>15, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>16, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>17, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>18, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>19, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>20, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if _n>21, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend



//Using dummy variables for statements

oprobit ordoutcome statovermedian cincperc demb year_cen year_sq year_cub, vce(robust)

margins, at(statovermedian =(0 1)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome statovermedian cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn, vce(robust)

margins, at(statovermedian =(0 1)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome statover75p cincperc demb year_cen year_sq year_cub, vce(robust)

margins, at(statover75p =(0 1)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome statover75p cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn, vce(robust)

margins, at(statover75p =(0 1)) predict(outcome(3)) level(90) noatlegend

// Using the natural log of statements

oprobit ordoutcome stat3w30d_ln cincperc demb year_cen year_sq year_cub, vce(robust)

margins, at(stat3w30d_ln =(0 2.5)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d_ln cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn, vce(robust)

margins, at(stat3w30d_ln =(0 2.5)) predict(outcome(3)) level(90) noatlegend

// Using ranks

oprobit ordoutcome statrank cincperc demb year_cen year_sq year_cub, vce(robust)

margins, at(statrank =(1 173)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome statrank cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn, vce(robust)

margins, at(statrank =(1 173)) predict(outcome(3)) level(90) noatlegend

//See the bottom of the do file for calculating the marginal effect of each observation to see which are highest.


* Alernate ways of calculating statement score

// Alternate numbers of days before the MID starts when I begin collecting statements

// 10 days before

oprobit ordoutcome stat3w10d cincperc demb year_cen year_sq year_cub, vce(robust)

margins, at(stat3w10d =(0 13)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w10d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn, vce(robust)

margins, at(stat3w10d =(0 13)) predict(outcome(3)) level(90) noatlegend

// 20 days before

oprobit ordoutcome stat3w20d cincperc demb year_cen year_sq year_cub, vce(robust)

margins, at(stat3w20d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w20d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn, vce(robust)

margins, at(stat3w20d =(0 12)) predict(outcome(3)) level(90) noatlegend

// 40 days before

oprobit ordoutcome stat3w40d cincperc demb year_cen year_sq year_cub, vce(robust)

margins, at(stat3w40d =(0 11)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w40d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn, vce(robust)

margins, at(stat3w40d =(0 11)) predict(outcome(3)) level(90) noatlegend

// 60 days before

oprobit ordoutcome stat3w60d cincperc demb year_cen year_sq year_cub, vce(robust)

margins, at(stat3w60d =(0 11)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w60d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn, vce(robust)

margins, at(stat3w60d =(0 11)) predict(outcome(3)) level(90) noatlegend

//Alternate dictionaries

// All words weighted equally

oprobit ordoutcome stat1w30d cincperc demb year_cen year_sq year_cub, vce(robust)

margins, at(stat1w30d =(0 8)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat1w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn, vce(robust)

margins, at(stat1w30d =(0 8)) predict(outcome(3)) level(90) noatlegend

// Weights between 1 and 10

oprobit ordoutcome stat10w30d cincperc demb year_cen year_sq year_cub, vce(robust)

margins, at(stat10w30d =(0 35)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat10w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn, vce(robust)

margins, at(stat10w30d =(0 35)) predict(outcome(3)) level(90) noatlegend

//Dropping certain statement types.

oprobit ordoutcome statthreatdemref cincperc demb year_cen year_sq year_cub, vce(robust)

margins, at(statthreatdemref =(0 8)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome statthreatdemref cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn, vce(robust)

margins, at(statthreatdemref =(0 8)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome statthreat cincperc demb year_cen year_sq year_cub, vce(robust)

margins, at(statthreat =(0 1.2)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome statthreat cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn, vce(robust)

margins, at(statthreat =(0 1.2)) predict(outcome(3)) level(90) noatlegend

//Placebo tests

oprobit ordoutcome stat3w30d thecount cincperc demb year_cen year_sq year_cub, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d thecount cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d thatcount cincperc demb year_cen year_sq year_cub, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d thatcount cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend



* Tests dropping MIDs

//Retaining only one dyadic MID per overall MID. The dyad with the highest score is retained.  If there is a tie, it is broken based on random numbers assigned to each observation.

set seed 8413517

gen randomorder=runiform()

gsort -stat3w30d +randomorder

preserve

duplicates drop dispnum, force

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

restore

// Dropping overlapping dyadic MIDs.

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if overlap==0, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if overlap==0, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

// Dropping one-day MIDs

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if duration>1, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if duration>1, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

// Dropping dyadic MIDs in which neither side is revisionist

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if revterritory ==1 | revregime ==1 | revpolicy ==1 | revother==1, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d sideaa hostleva hostlevb sanctions_ties cincperc demb s3un4608i defensepact revterritory revregime rus nkr chn cub irq lib irn year_cen year_sq year_cub if revterritory ==1 | revregime ==1 | revpolicy ==1 | revother==1, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

//Dropping dyadic MIDs in which the outcome is "released"

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub if outcome!=7, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn if outcome!=7, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend



* Tests only mentioned in passing

//Linear time trend

oprobit ordoutcome stat3w30d cincperc demb year_cen, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

// Spline

preserve

mkspline yr = year_cen, cubic nknots(3)

oprobit ordoutcome stat3w30d cincperc demb yr*, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb yr* sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

restore

//Using presidential fixed effects, inserted as dummies.  Truman and Eisenhower combined form the omitted comparison category because ommitting Truman or Bush2 alone does not create a large enough comparison category.  Obama is also ommitted due to missing data.

oprobit ordoutcome stat3w30d cincperc demb kennedy johnson nixon ford carter reagan bush1 clinton bush2, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn kennedy johnson nixon ford carter reagan bush1 clinton bush2, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

//Dropping all temporal controls

oprobit ordoutcome stat3w30d cincperc demb, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

//Dropping cincperc to include more observations

oprobit ordoutcome stat3w30d demb year_cen year_sq year_cub, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

// Testing the proportional odds assumption. There are some variables in here that do not meet the proportional odds assumption, but it does not change the result of interest.

gologit2 ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub, autofit vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

gologit2 ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn, autofit vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

//Heckman ordered probit

use "Conflict Outcome JPR Data for Selection Test", clear

//This dataset only goes up to 2001 because EUGene can only calculate peace years up to that year.

heckoprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub, select(midinit= jointdem_st cincperc_st s3un4608i_st peaceyears peaceyears_sq peaceyears_cub) vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

heckoprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy, select(midinit= jointdem_st cincperc_st s3un4608i_st peaceyears peaceyears_sq peaceyears_cub) vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

use "Conflict Outcome JPR Data", clear

// Using regular standard errors 

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

// Using ologit model

ologit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

ologit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

//Using OLS with robust and regular standard errors

reg ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub, vce(robust)

reg ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn, vce(robust)

reg ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub

reg ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn

// Using different codings of outcome variable.  ordoutcome2 drops outcomes coded in the MID data as unclear or missing.

oprobit ordoutcome2 stat3w30d cincperc demb year_cen year_sq year_cub, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

oprobit ordoutcome2 stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn, vce(robust)

margins, at(stat3w30d =(0 12)) predict(outcome(3)) level(90) noatlegend

//Check for multicollinearity

collin stat3w30d cincperc demb year_cen year_sq year_cub

collin stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn


* Predicting the marginal effect for each dyadic MID using Model 1 in order to see which MIDs are highest.

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub, vce(robust)
* dymidnum== 2701
margins, dydx(stat3w30d) at (year_cen= -14 year_sq= 196 year_cub= -2744 stat3w30d= 0 cincperc= 0.9358472 demb= 0) predict(outcome(3))
* dymidnum== 2702
margins, dydx(stat3w30d) at (year_cen= -14 year_sq= 196 year_cub= -2744 stat3w30d= 0 cincperc= 0.9489417 demb= 0) predict(outcome(3))
* dymidnum== 2703
margins, dydx(stat3w30d) at (year_cen= -14 year_sq= 196 year_cub= -2744 stat3w30d= 1.429906 cincperc= 0.9588433 demb= 0) predict(outcome(3))
* dymidnum== 2704
margins, dydx(stat3w30d) at (year_cen= -14 year_sq= 196 year_cub= -2744 stat3w30d= 1.880952 cincperc= 0.5479898 demb= 0) predict(outcome(3))
* dymidnum== 5001
margins, dydx(stat3w30d) at (year_cen= -21 year_sq= 441 year_cub= -9261 stat3w30d= 0.2285714 cincperc= 0.603565 demb= 0) predict(outcome(3))
* dymidnum== 5002
margins, dydx(stat3w30d) at (year_cen= -21 year_sq= 441 year_cub= -9261 stat3w30d= 0.1214869 cincperc= 0.7485799 demb= 0) predict(outcome(3))
* dymidnum== 5101
margins, dydx(stat3w30d) at (year_cen= -23 year_sq= 529 year_cub= -12167 stat3w30d= 0.1224105 cincperc= 0.7635944 demb= 0) predict(outcome(3))
* dymidnum== 5102
margins, dydx(stat3w30d) at (year_cen= -23 year_sq= 529 year_cub= -12167 stat3w30d= 0.0414866 cincperc= 0.9900788 demb= 0) predict(outcome(3))
* dymidnum== 5301
margins, dydx(stat3w30d) at (year_cen= -19 year_sq= 361 year_cub= -6859 stat3w30d= 0 cincperc= 0.7264464 demb= 0) predict(outcome(3))
* dymidnum== 6101
margins, dydx(stat3w30d) at (year_cen= -13 year_sq= 169 year_cub= -2197 stat3w30d= 0.4584527 cincperc= 0.9828988 demb= 0) predict(outcome(3))
* dymidnum== 6102
margins, dydx(stat3w30d) at (year_cen= -13 year_sq= 169 year_cub= -2197 stat3w30d= 0.9885387 cincperc= 0.5434619 demb= 0) predict(outcome(3))
* dymidnum== 12501
margins, dydx(stat3w30d) at (year_cen= -17 year_sq= 289 year_cub= -4913 stat3w30d= 0.0227273 cincperc= 0.9924799 demb= 0) predict(outcome(3))
* dymidnum== 12502
margins, dydx(stat3w30d) at (year_cen= -17 year_sq= 289 year_cub= -4913 stat3w30d= 0.513089 cincperc= 0.5783337 demb= 0) predict(outcome(3))
* dymidnum== 12503
margins, dydx(stat3w30d) at (year_cen= -17 year_sq= 289 year_cub= -4913 stat3w30d= 0 cincperc= 0.9778062 demb= 0) predict(outcome(3))
* dymidnum== 17201
margins, dydx(stat3w30d) at (year_cen= -13 year_sq= 169 year_cub= -2197 stat3w30d= 0.1768293 cincperc= 0.6695303 demb= 0) predict(outcome(3))
* dymidnum== 17301
margins, dydx(stat3w30d) at (year_cen= -17 year_sq= 289 year_cub= -4913 stat3w30d= 0.3870968 cincperc= 0.5783337 demb= 0) predict(outcome(3))
* dymidnum== 17302
margins, dydx(stat3w30d) at (year_cen= -17 year_sq= 289 year_cub= -4913 stat3w30d= 0.6353591 cincperc= 0.6838089 demb= 0) predict(outcome(3))
* dymidnum== 20001
margins, dydx(stat3w30d) at (year_cen= -19 year_sq= 361 year_cub= -6859 stat3w30d= 0.5806451 cincperc= 0.6049386 demb= 0) predict(outcome(3))
* dymidnum== 20002
margins, dydx(stat3w30d) at (year_cen= -19 year_sq= 361 year_cub= -6859 stat3w30d= 0.6451613 cincperc= 0.980395 demb= 0) predict(outcome(3))
* dymidnum== 20801
margins, dydx(stat3w30d) at (year_cen= -22 year_sq= 484 year_cub= -10648 stat3w30d= 0.18 cincperc= 0.6425185 demb= 0) predict(outcome(3))
* dymidnum== 20802
margins, dydx(stat3w30d) at (year_cen= -22 year_sq= 484 year_cub= -10648 stat3w30d= 0.0192308 cincperc= 0.9664532 demb= 0) predict(outcome(3))
* dymidnum== 24601
margins, dydx(stat3w30d) at (year_cen= -15 year_sq= 225 year_cub= -3375 stat3w30d= 0.4192547 cincperc= 0.5563662 demb= 0) predict(outcome(3))
* dymidnum== 24602
margins, dydx(stat3w30d) at (year_cen= -15 year_sq= 225 year_cub= -3375 stat3w30d= 0.275 cincperc= 0.9915661 demb= 0) predict(outcome(3))
* dymidnum== 25101
margins, dydx(stat3w30d) at (year_cen= -10 year_sq= 100 year_cub= -1000 stat3w30d= 0.1612903 cincperc= 0.6492279 demb= 0) predict(outcome(3))
* dymidnum== 25301
margins, dydx(stat3w30d) at (year_cen= -15 year_sq= 225 year_cub= -3375 stat3w30d= 0.7522936 cincperc= 0.5563662 demb= 0) predict(outcome(3))
* dymidnum== 34501
margins, dydx(stat3w30d) at (year_cen= -8 year_sq= 64 year_cub= -512 stat3w30d= 0 cincperc= 0.5556993 demb= 0) predict(outcome(3))
* dymidnum== 34701
margins, dydx(stat3w30d) at (year_cen= -7 year_sq= 49 year_cub= -343 stat3w30d= 0.0630137 cincperc= 0.9743533 demb= 0) predict(outcome(3))
* dymidnum== 35001
margins, dydx(stat3w30d) at (year_cen= -6 year_sq= 36 year_cub= -216 stat3w30d= 0.0162602 cincperc= 0.9881925 demb= 0) predict(outcome(3))
* dymidnum== 35301
margins, dydx(stat3w30d) at (year_cen= -2 year_sq= 4 year_cub= -8 stat3w30d= 0.245283 cincperc= 0.4820844 demb= 0) predict(outcome(3))
* dymidnum== 35601
margins, dydx(stat3w30d) at (year_cen= 0 year_sq= 0 year_cub= 0 stat3w30d= 0.1764706 cincperc= 0.9942689 demb= 0) predict(outcome(3))
* dymidnum== 36201
margins, dydx(stat3w30d) at (year_cen= 1 year_sq= 1 year_cub= 1 stat3w30d= 0 cincperc= 0.9548209 demb= 0) predict(outcome(3))
* dymidnum== 60101
margins, dydx(stat3w30d) at (year_cen= -3 year_sq= 9 year_cub= -27 stat3w30d= 0 cincperc= 0.9844744 demb= 0) predict(outcome(3))
* dymidnum== 60201
margins, dydx(stat3w30d) at (year_cen= -3 year_sq= 9 year_cub= -27 stat3w30d= 0 cincperc= 0.994945 demb= 0) predict(outcome(3))
* dymidnum== 60701
margins, dydx(stat3w30d) at (year_cen= -18 year_sq= 324 year_cub= -5832 stat3w30d= 0.0294118 cincperc= 0.9798644 demb= 0) predict(outcome(3))
* dymidnum== 60702
margins, dydx(stat3w30d) at (year_cen= -18 year_sq= 324 year_cub= -5832 stat3w30d= 0.0125523 cincperc= 0.9949703 demb= 1) predict(outcome(3))
* dymidnum== 60703
margins, dydx(stat3w30d) at (year_cen= -18 year_sq= 324 year_cub= -5832 stat3w30d= 0.3891214 cincperc= 0.6039295 demb= 0) predict(outcome(3))
* dymidnum== 60801
margins, dydx(stat3w30d) at (year_cen= -16 year_sq= 256 year_cub= -4096 stat3w30d= 0.984556 cincperc= 0.5721744 demb= 0) predict(outcome(3))
* dymidnum== 61101
margins, dydx(stat3w30d) at (year_cen= -7 year_sq= 49 year_cub= -343 stat3w30d= 0.0962025 cincperc= 0.6613681 demb= 0) predict(outcome(3))
* dymidnum== 61102
margins, dydx(stat3w30d) at (year_cen= -11 year_sq= 121 year_cub= -1331 stat3w30d= 0.3429844 cincperc= 0.5478964 demb= 0) predict(outcome(3))
* dymidnum== 61103
margins, dydx(stat3w30d) at (year_cen= -7 year_sq= 49 year_cub= -343 stat3w30d= 0.9155529 cincperc= 0.9759957 demb= 0) predict(outcome(3))
* dymidnum== 63301
margins, dydx(stat3w30d) at (year_cen= -25 year_sq= 625 year_cub= -15625 stat3w30d= 0 cincperc= 0.7059219 demb= 0) predict(outcome(3))
* dymidnum== 100201
margins, dydx(stat3w30d) at (year_cen= -12 year_sq= 144 year_cub= -1728 stat3w30d= 0 cincperc= 0.997906 demb= 0) predict(outcome(3))
* dymidnum== 103901
margins, dydx(stat3w30d) at (year_cen= -5 year_sq= 25 year_cub= -125 stat3w30d= 0 cincperc= 0.5098097 demb= 0) predict(outcome(3))
* dymidnum== 103902
margins, dydx(stat3w30d) at (year_cen= -5 year_sq= 25 year_cub= -125 stat3w30d= 0 cincperc= 0.9919642 demb= 0) predict(outcome(3))
* dymidnum== 103903
margins, dydx(stat3w30d) at (year_cen= -5 year_sq= 25 year_cub= -125 stat3w30d= 0 cincperc= 0.9872485 demb= 0) predict(outcome(3))
* dymidnum== 110801
margins, dydx(stat3w30d) at (year_cen= -13 year_sq= 169 year_cub= -2197 stat3w30d= 0 cincperc= 0.970248 demb= 0) predict(outcome(3))
* dymidnum== 110802
margins, dydx(stat3w30d) at (year_cen= -13 year_sq= 169 year_cub= -2197 stat3w30d= 0 cincperc= 0.9987981 demb= 0) predict(outcome(3))
* dymidnum== 112401
margins, dydx(stat3w30d) at (year_cen= -17 year_sq= 289 year_cub= -4913 stat3w30d= 0 cincperc= 0.9980836 demb= 0) predict(outcome(3))
* dymidnum== 115801
margins, dydx(stat3w30d) at (year_cen= -4 year_sq= 16 year_cub= -64 stat3w30d= 0 cincperc= 0.9951827 demb= 0) predict(outcome(3))
* dymidnum== 119301
margins, dydx(stat3w30d) at (year_cen= -21 year_sq= 441 year_cub= -9261 stat3w30d= 0 cincperc= 0.9992658 demb= 0) predict(outcome(3))
* dymidnum== 121301
margins, dydx(stat3w30d) at (year_cen= -11 year_sq= 121 year_cub= -1331 stat3w30d= 0 cincperc= 0.9947348 demb= 0) predict(outcome(3))
* dymidnum== 121601
margins, dydx(stat3w30d) at (year_cen= -9 year_sq= 81 year_cub= -729 stat3w30d= 0.1131387 cincperc= 0.6555259 demb= 0) predict(outcome(3))
* dymidnum== 121602
margins, dydx(stat3w30d) at (year_cen= -9 year_sq= 81 year_cub= -729 stat3w30d= 0 cincperc= 0.9948136 demb= 0) predict(outcome(3))
* dymidnum== 121701
margins, dydx(stat3w30d) at (year_cen= -8 year_sq= 64 year_cub= -512 stat3w30d= 0 cincperc= 0.9949306 demb= 0) predict(outcome(3))
* dymidnum== 128601
margins, dydx(stat3w30d) at (year_cen= -24 year_sq= 576 year_cub= -13824 stat3w30d= 0 cincperc= 0.9842262 demb= 0) predict(outcome(3))
* dymidnum== 128602
margins, dydx(stat3w30d) at (year_cen= -24 year_sq= 576 year_cub= -13824 stat3w30d= 0 cincperc= 0.9904422 demb= 0) predict(outcome(3))
* dymidnum== 128603
margins, dydx(stat3w30d) at (year_cen= -24 year_sq= 576 year_cub= -13824 stat3w30d= 0 cincperc= 0.9790978 demb= 0) predict(outcome(3))
* dymidnum== 128604
margins, dydx(stat3w30d) at (year_cen= -24 year_sq= 576 year_cub= -13824 stat3w30d= 0.8577075 cincperc= 0.6485161 demb= 0) predict(outcome(3))
* dymidnum== 135301
margins, dydx(stat3w30d) at (year_cen= -13 year_sq= 169 year_cub= -2197 stat3w30d= 0.4883721 cincperc= 0.5434619 demb= 0) predict(outcome(3))
* dymidnum== 135302
margins, dydx(stat3w30d) at (year_cen= -12 year_sq= 144 year_cub= -1728 stat3w30d= 0.1886792 cincperc= 0.6600661 demb= 0) predict(outcome(3))
* dymidnum== 136301
margins, dydx(stat3w30d) at (year_cen= -14 year_sq= 196 year_cub= -2744 stat3w30d= 0.755102 cincperc= 0.5479898 demb= 0) predict(outcome(3))
* dymidnum== 136302
margins, dydx(stat3w30d) at (year_cen= -14 year_sq= 196 year_cub= -2744 stat3w30d= 0.0204082 cincperc= 0.6674777 demb= 0) predict(outcome(3))
* dymidnum== 136303
margins, dydx(stat3w30d) at (year_cen= -14 year_sq= 196 year_cub= -2744 stat3w30d= 0.15 cincperc= 0.9819949 demb= 0) predict(outcome(3))
* dymidnum== 137901
margins, dydx(stat3w30d) at (year_cen= -8 year_sq= 64 year_cub= -512 stat3w30d= 0.0357884 cincperc= 0.9762254 demb= 0) predict(outcome(3))
* dymidnum== 147201
margins, dydx(stat3w30d) at (year_cen= 0 year_sq= 0 year_cub= 0 stat3w30d= 0.0092166 cincperc= 0.9567155 demb= 0) predict(outcome(3))
* dymidnum== 170201
margins, dydx(stat3w30d) at (year_cen= -23 year_sq= 529 year_cub= -12167 stat3w30d= 0 cincperc= 0.9979203 demb= 0) predict(outcome(3))
* dymidnum== 170501
margins, dydx(stat3w30d) at (year_cen= -21 year_sq= 441 year_cub= -9261 stat3w30d= 0 cincperc= 0.997663 demb= 0) predict(outcome(3))
* dymidnum== 174201
margins, dydx(stat3w30d) at (year_cen= -16 year_sq= 256 year_cub= -4096 stat3w30d= 0 cincperc= 0.9925719 demb= 0) predict(outcome(3))
* dymidnum== 180101
margins, dydx(stat3w30d) at (year_cen= -14 year_sq= 196 year_cub= -2744 stat3w30d= 0 cincperc= 0.9975324 demb= 0) predict(outcome(3))
* dymidnum== 180301
margins, dydx(stat3w30d) at (year_cen= -12 year_sq= 144 year_cub= -1728 stat3w30d= 0 cincperc= 0.996546 demb= 0) predict(outcome(3))
* dymidnum== 180501
margins, dydx(stat3w30d) at (year_cen= -8 year_sq= 64 year_cub= -512 stat3w30d= 0 cincperc= 0.9965547 demb= 0) predict(outcome(3))
* dymidnum== 180601
margins, dydx(stat3w30d) at (year_cen= -7 year_sq= 49 year_cub= -343 stat3w30d= 0.0080483 cincperc= 0.9948668 demb= 0) predict(outcome(3))
* dymidnum== 200201
margins, dydx(stat3w30d) at (year_cen= -15 year_sq= 225 year_cub= -3375 stat3w30d= 0 cincperc= 0.6436611 demb= 0) predict(outcome(3))
* dymidnum== 203201
margins, dydx(stat3w30d) at (year_cen= -20 year_sq= 400 year_cub= -8000 stat3w30d= 0.0645161 cincperc= 0.7446828 demb= 0) predict(outcome(3))
* dymidnum== 203301
margins, dydx(stat3w30d) at (year_cen= -21 year_sq= 441 year_cub= -9261 stat3w30d= 0.6571429 cincperc= 0.7485799 demb= 0) predict(outcome(3))
* dymidnum== 203501
margins, dydx(stat3w30d) at (year_cen= -22 year_sq= 484 year_cub= -10648 stat3w30d= 0 cincperc= 0.7659119 demb= 0) predict(outcome(3))
* dymidnum== 204901
margins, dydx(stat3w30d) at (year_cen= -18 year_sq= 324 year_cub= -5832 stat3w30d= 0.09375 cincperc= 0.7192998 demb= 0) predict(outcome(3))
* dymidnum== 205201
margins, dydx(stat3w30d) at (year_cen= -24 year_sq= 576 year_cub= -13824 stat3w30d= 0.1032864 cincperc= 0.7550968 demb= 0) predict(outcome(3))
* dymidnum== 217601
margins, dydx(stat3w30d) at (year_cen= 8 year_sq= 64 year_cub= 512 stat3w30d= 0.0337423 cincperc= 0.9776064 demb= 1) predict(outcome(3))
* dymidnum== 218701
margins, dydx(stat3w30d) at (year_cen= -16 year_sq= 256 year_cub= -4096 stat3w30d= 0.019245 cincperc= 0.9761097 demb= 0) predict(outcome(3))
* dymidnum== 218801
margins, dydx(stat3w30d) at (year_cen= -13 year_sq= 169 year_cub= -2197 stat3w30d= 0 cincperc= 0.9756079 demb= 0) predict(outcome(3))
* dymidnum== 218901
margins, dydx(stat3w30d) at (year_cen= -12 year_sq= 144 year_cub= -1728 stat3w30d= 0.0109489 cincperc= 0.9771866 demb= 0) predict(outcome(3))
* dymidnum== 219201
margins, dydx(stat3w30d) at (year_cen= 2 year_sq= 4 year_cub= 8 stat3w30d= 0.0071942 cincperc= 0.9533319 demb= 0) predict(outcome(3))
* dymidnum== 219301
margins, dydx(stat3w30d) at (year_cen= 4 year_sq= 16 year_cub= 64 stat3w30d= 0.0217391 cincperc= 0.9455901 demb= 0) predict(outcome(3))
* dymidnum== 219501
margins, dydx(stat3w30d) at (year_cen= 8 year_sq= 64 year_cub= 512 stat3w30d= 0 cincperc= 0.9377402 demb= 0) predict(outcome(3))
* dymidnum== 219601
margins, dydx(stat3w30d) at (year_cen= 10 year_sq= 100 year_cub= 1000 stat3w30d= 0 cincperc= 0.937026 demb= 0) predict(outcome(3))
* dymidnum== 221501
margins, dydx(stat3w30d) at (year_cen= -17 year_sq= 289 year_cub= -4913 stat3w30d= 0.2439024 cincperc= 0.5783337 demb= 0) predict(outcome(3))
* dymidnum== 221601
margins, dydx(stat3w30d) at (year_cen= -17 year_sq= 289 year_cub= -4913 stat3w30d= 0.2258064 cincperc= 0.5783337 demb= 0) predict(outcome(3))
* dymidnum== 221701
margins, dydx(stat3w30d) at (year_cen= -14 year_sq= 196 year_cub= -2744 stat3w30d= 2.653333 cincperc= 0.5479898 demb= 0) predict(outcome(3))
* dymidnum== 221801
margins, dydx(stat3w30d) at (year_cen= -12 year_sq= 144 year_cub= -1728 stat3w30d= 1.451613 cincperc= 0.5483676 demb= 0) predict(outcome(3))
* dymidnum== 221901
margins, dydx(stat3w30d) at (year_cen= -13 year_sq= 169 year_cub= -2197 stat3w30d= 0.9103774 cincperc= 0.5434619 demb= 0) predict(outcome(3))
* dymidnum== 222001
margins, dydx(stat3w30d) at (year_cen= -11 year_sq= 121 year_cub= -1331 stat3w30d= 0.0777778 cincperc= 0.5478964 demb= 0) predict(outcome(3))
* dymidnum== 222101
margins, dydx(stat3w30d) at (year_cen= -5 year_sq= 25 year_cub= -125 stat3w30d= 0.8823529 cincperc= 0.5098097 demb= 0) predict(outcome(3))
* dymidnum== 222201
margins, dydx(stat3w30d) at (year_cen= 2 year_sq= 4 year_cub= 8 stat3w30d= 1.96875 cincperc= 0.4445501 demb= 0) predict(outcome(3))
* dymidnum== 222301
margins, dydx(stat3w30d) at (year_cen= 3 year_sq= 9 year_cub= 27 stat3w30d= 1.6 cincperc= 0.4450599 demb= 0) predict(outcome(3))
* dymidnum== 222401
margins, dydx(stat3w30d) at (year_cen= 4 year_sq= 16 year_cub= 64 stat3w30d= 0.65625 cincperc= 0.4455901 demb= 0) predict(outcome(3))
* dymidnum== 222501
margins, dydx(stat3w30d) at (year_cen= 4 year_sq= 16 year_cub= 64 stat3w30d= 0.7314815 cincperc= 0.9794126 demb= 0) predict(outcome(3))
* dymidnum== 222502
margins, dydx(stat3w30d) at (year_cen= 4 year_sq= 16 year_cub= 64 stat3w30d= 1.901786 cincperc= 0.4455901 demb= 0) predict(outcome(3))
* dymidnum== 222601
margins, dydx(stat3w30d) at (year_cen= 5 year_sq= 25 year_cub= 125 stat3w30d= 7.621622 cincperc= 0.4364956 demb= 0) predict(outcome(3))
* dymidnum== 222701
margins, dydx(stat3w30d) at (year_cen= 5 year_sq= 25 year_cub= 125 stat3w30d= 10.29032 cincperc= 0.4364956 demb= 0) predict(outcome(3))
* dymidnum== 222801
margins, dydx(stat3w30d) at (year_cen= 6 year_sq= 36 year_cub= 216 stat3w30d= 0.3939394 cincperc= 0.4441466 demb= 0) predict(outcome(3))
* dymidnum== 222901
margins, dydx(stat3w30d) at (year_cen= 7 year_sq= 49 year_cub= 343 stat3w30d= 1.469388 cincperc= 0.426029 demb= 0) predict(outcome(3))
* dymidnum== 223001
margins, dydx(stat3w30d) at (year_cen= 9 year_sq= 81 year_cub= 729 stat3w30d= 1.684211 cincperc= 0.4433683 demb= 0) predict(outcome(3))
* dymidnum== 223101
margins, dydx(stat3w30d) at (year_cen= 9 year_sq= 81 year_cub= 729 stat3w30d= 2.851675 cincperc= 0.4433683 demb= 0) predict(outcome(3))
* dymidnum== 223201
margins, dydx(stat3w30d) at (year_cen= 10 year_sq= 100 year_cub= 1000 stat3w30d= 1.752525 cincperc= 0.4387804 demb= 0) predict(outcome(3))
* dymidnum== 223301
margins, dydx(stat3w30d) at (year_cen= 11 year_sq= 121 year_cub= 1331 stat3w30d= 5.032258 cincperc= 0.4383736 demb= 0) predict(outcome(3))
* dymidnum== 224401
margins, dydx(stat3w30d) at (year_cen= -20 year_sq= 400 year_cub= -8000 stat3w30d= 0.0095785 cincperc= 0.9849293 demb= 0) predict(outcome(3))
* dymidnum== 233501
margins, dydx(stat3w30d) at (year_cen= 1 year_sq= 1 year_cub= 1 stat3w30d= 0.2972973 cincperc= 0.9779028 demb= 1) predict(outcome(3))
* dymidnum== 234701
margins, dydx(stat3w30d) at (year_cen= 9 year_sq= 81 year_cub= 729 stat3w30d= 0.9743888 cincperc= 0.9941519 demb= 0) predict(outcome(3))
* dymidnum== 235301
margins, dydx(stat3w30d) at (year_cen= 12 year_sq= 144 year_cub= 1728 stat3w30d= 2.046341 cincperc= 0.9942569 demb= 0) predict(outcome(3))
* dymidnum== 255901
margins, dydx(stat3w30d) at (year_cen= 10 year_sq= 100 year_cub= 1000 stat3w30d= 0 cincperc= 0.9374433 demb= 0) predict(outcome(3))
* dymidnum== 257801
margins, dydx(stat3w30d) at (year_cen= 11 year_sq= 121 year_cub= 1331 stat3w30d= 0.125 cincperc= 0.9388648 demb= 0) predict(outcome(3))
* dymidnum== 260801
margins, dydx(stat3w30d) at (year_cen= -9 year_sq= 81 year_cub= -729 stat3w30d= 0 cincperc= 0.9985061 demb= 0) predict(outcome(3))
* dymidnum== 273901
margins, dydx(stat3w30d) at (year_cen= 12 year_sq= 144 year_cub= 1728 stat3w30d= 0.09375 cincperc= 0.9257776 demb= 0) predict(outcome(3))
* dymidnum== 274001
margins, dydx(stat3w30d) at (year_cen= 12 year_sq= 144 year_cub= 1728 stat3w30d= 0.3935018 cincperc= 0.9346946 demb= 0) predict(outcome(3))
* dymidnum== 274101
margins, dydx(stat3w30d) at (year_cen= 12 year_sq= 144 year_cub= 1728 stat3w30d= 0.004386 cincperc= 0.997792 demb= 0) predict(outcome(3))
* dymidnum== 274201
margins, dydx(stat3w30d) at (year_cen= 12 year_sq= 144 year_cub= 1728 stat3w30d= 0.3225806 cincperc= 0.9749299 demb= 0) predict(outcome(3))
* dymidnum== 277401
margins, dydx(stat3w30d) at (year_cen= 13 year_sq= 169 year_cub= 2197 stat3w30d= 0.2258064 cincperc= 0.9246184 demb= 0) predict(outcome(3))
* dymidnum== 277501
margins, dydx(stat3w30d) at (year_cen= 14 year_sq= 196 year_cub= 2744 stat3w30d= 0 cincperc= 0.9882602 demb= 0) predict(outcome(3))
* dymidnum== 283401
margins, dydx(stat3w30d) at (year_cen= 13 year_sq= 169 year_cub= 2197 stat3w30d= 0.2258064 cincperc= 0.9228977 demb= 0) predict(outcome(3))
* dymidnum== 284301
margins, dydx(stat3w30d) at (year_cen= -19 year_sq= 361 year_cub= -6859 stat3w30d= 0 cincperc= 0.980395 demb= 0) predict(outcome(3))
* dymidnum== 284501
margins, dydx(stat3w30d) at (year_cen= -18 year_sq= 324 year_cub= -5832 stat3w30d= 0 cincperc= 0.9918408 demb= 0) predict(outcome(3))
* dymidnum== 284901
margins, dydx(stat3w30d) at (year_cen= -18 year_sq= 324 year_cub= -5832 stat3w30d= 0 cincperc= 0.9608352 demb= 0) predict(outcome(3))
* dymidnum== 285401
margins, dydx(stat3w30d) at (year_cen= -17 year_sq= 289 year_cub= -4913 stat3w30d= 0 cincperc= 0.9603318 demb= 0) predict(outcome(3))
* dymidnum== 285701
margins, dydx(stat3w30d) at (year_cen= -17 year_sq= 289 year_cub= -4913 stat3w30d= 0 cincperc= 0.9978776 demb= 0) predict(outcome(3))
* dymidnum== 286701
margins, dydx(stat3w30d) at (year_cen= -16 year_sq= 256 year_cub= -4096 stat3w30d= 0 cincperc= 0.9977275 demb= 0) predict(outcome(3))
* dymidnum== 287001
margins, dydx(stat3w30d) at (year_cen= -16 year_sq= 256 year_cub= -4096 stat3w30d= 0 cincperc= 0.9931251 demb= 1) predict(outcome(3))
* dymidnum== 287601
margins, dydx(stat3w30d) at (year_cen= -15 year_sq= 225 year_cub= -3375 stat3w30d= 0 cincperc= 0.9834244 demb= 1) predict(outcome(3))
* dymidnum== 289901
margins, dydx(stat3w30d) at (year_cen= -12 year_sq= 144 year_cub= -1728 stat3w30d= 1.516129 cincperc= 0.5483676 demb= 0) predict(outcome(3))
* dymidnum== 290101
margins, dydx(stat3w30d) at (year_cen= -11 year_sq= 121 year_cub= -1331 stat3w30d= 0.2580645 cincperc= 0.5478964 demb= 0) predict(outcome(3))
* dymidnum== 290601
margins, dydx(stat3w30d) at (year_cen= -11 year_sq= 121 year_cub= -1331 stat3w30d= 0 cincperc= 0.9711821 demb= 0) predict(outcome(3))
* dymidnum== 290901
margins, dydx(stat3w30d) at (year_cen= -11 year_sq= 121 year_cub= -1331 stat3w30d= 0.0958904 cincperc= 0.5478964 demb= 0) predict(outcome(3))
* dymidnum== 291001
margins, dydx(stat3w30d) at (year_cen= -10 year_sq= 100 year_cub= -1000 stat3w30d= 0.3548387 cincperc= 0.5505238 demb= 0) predict(outcome(3))
* dymidnum== 291601
margins, dydx(stat3w30d) at (year_cen= -10 year_sq= 100 year_cub= -1000 stat3w30d= 0 cincperc= 0.9745435 demb= 0) predict(outcome(3))
* dymidnum== 292101
margins, dydx(stat3w30d) at (year_cen= -9 year_sq= 81 year_cub= -729 stat3w30d= 0.0645161 cincperc= 0.5564729 demb= 0) predict(outcome(3))
* dymidnum== 292401
margins, dydx(stat3w30d) at (year_cen= -7 year_sq= 49 year_cub= -343 stat3w30d= 0 cincperc= 0.9697536 demb= 0) predict(outcome(3))
* dymidnum== 292801
margins, dydx(stat3w30d) at (year_cen= -7 year_sq= 49 year_cub= -343 stat3w30d= 0.6060606 cincperc= 0.5453855 demb= 0) predict(outcome(3))
* dymidnum== 292901
margins, dydx(stat3w30d) at (year_cen= -9 year_sq= 81 year_cub= -729 stat3w30d= 0.082716 cincperc= 0.6555259 demb= 0) predict(outcome(3))
* dymidnum== 293001
margins, dydx(stat3w30d) at (year_cen= -8 year_sq= 64 year_cub= -512 stat3w30d= 0.0526316 cincperc= 0.5556993 demb= 0) predict(outcome(3))
* dymidnum== 293101
margins, dydx(stat3w30d) at (year_cen= -8 year_sq= 64 year_cub= -512 stat3w30d= 0.0645161 cincperc= 0.5556993 demb= 0) predict(outcome(3))
* dymidnum== 293401
margins, dydx(stat3w30d) at (year_cen= -8 year_sq= 64 year_cub= -512 stat3w30d= 0.0784314 cincperc= 0.5556993 demb= 0) predict(outcome(3))
* dymidnum== 293601
margins, dydx(stat3w30d) at (year_cen= -6 year_sq= 36 year_cub= -216 stat3w30d= 0.0434783 cincperc= 0.6497554 demb= 0) predict(outcome(3))
* dymidnum== 294101
margins, dydx(stat3w30d) at (year_cen= -6 year_sq= 36 year_cub= -216 stat3w30d= 0.625 cincperc= 0.5382954 demb= 0) predict(outcome(3))
* dymidnum== 294102
margins, dydx(stat3w30d) at (year_cen= -6 year_sq= 36 year_cub= -216 stat3w30d= 0.3953488 cincperc= 0.9736338 demb= 0) predict(outcome(3))
* dymidnum== 294301
margins, dydx(stat3w30d) at (year_cen= -4 year_sq= 16 year_cub= -64 stat3w30d= 0 cincperc= 0.9869347 demb= 0) predict(outcome(3))
* dymidnum== 294601
margins, dydx(stat3w30d) at (year_cen= -4 year_sq= 16 year_cub= -64 stat3w30d= 0.0245399 cincperc= 0.9869347 demb= 0) predict(outcome(3))
* dymidnum== 294701
margins, dydx(stat3w30d) at (year_cen= -4 year_sq= 16 year_cub= -64 stat3w30d= 0.0508475 cincperc= 0.5991066 demb= 0) predict(outcome(3))
* dymidnum== 294801
margins, dydx(stat3w30d) at (year_cen= -3 year_sq= 9 year_cub= -27 stat3w30d= 0 cincperc= 0.5931975 demb= 0) predict(outcome(3))
* dymidnum== 294901
margins, dydx(stat3w30d) at (year_cen= -3 year_sq= 9 year_cub= -27 stat3w30d= 0.2222222 cincperc= 0.4864592 demb= 0) predict(outcome(3))
* dymidnum== 295001
margins, dydx(stat3w30d) at (year_cen= -2 year_sq= 4 year_cub= -8 stat3w30d= 0 cincperc= 0.9938164 demb= 0) predict(outcome(3))
* dymidnum== 295101
margins, dydx(stat3w30d) at (year_cen= -1 year_sq= 1 year_cub= -1 stat3w30d= 0 cincperc= 0.9862389 demb= 0) predict(outcome(3))
* dymidnum== 295201
margins, dydx(stat3w30d) at (year_cen= -1 year_sq= 1 year_cub= -1 stat3w30d= 0.0645161 cincperc= 0.9232441 demb= 1) predict(outcome(3))
* dymidnum== 295301
margins, dydx(stat3w30d) at (year_cen= 0 year_sq= 0 year_cub= 0 stat3w30d= 0.1290323 cincperc= 0.9195915 demb= 1) predict(outcome(3))
* dymidnum== 295401
margins, dydx(stat3w30d) at (year_cen= 0 year_sq= 0 year_cub= 0 stat3w30d= 0 cincperc= 0.9860195 demb= 0) predict(outcome(3))
* dymidnum== 295701
margins, dydx(stat3w30d) at (year_cen= 1 year_sq= 1 year_cub= 1 stat3w30d= 2.78125 cincperc= 0.9979656 demb= 0) predict(outcome(3))
* dymidnum== 295801
margins, dydx(stat3w30d) at (year_cen= 1 year_sq= 1 year_cub= 1 stat3w30d= 0.2580645 cincperc= 0.9838983 demb= 0) predict(outcome(3))
* dymidnum== 296001
margins, dydx(stat3w30d) at (year_cen= 1 year_sq= 1 year_cub= 1 stat3w30d= 0.0322581 cincperc= 0.9548209 demb= 0) predict(outcome(3))
* dymidnum== 296201
margins, dydx(stat3w30d) at (year_cen= 2 year_sq= 4 year_cub= 8 stat3w30d= 0.03125 cincperc= 0.9807217 demb= 0) predict(outcome(3))
* dymidnum== 296701
margins, dydx(stat3w30d) at (year_cen= 4 year_sq= 16 year_cub= 64 stat3w30d= 0 cincperc= 0.9774418 demb= 0) predict(outcome(3))
* dymidnum== 296801
margins, dydx(stat3w30d) at (year_cen= 4 year_sq= 16 year_cub= 64 stat3w30d= 0.0294118 cincperc= 0.9171979 demb= 1) predict(outcome(3))
* dymidnum== 297101
margins, dydx(stat3w30d) at (year_cen= 6 year_sq= 36 year_cub= 216 stat3w30d= 0 cincperc= 0.9427903 demb= 0) predict(outcome(3))
* dymidnum== 297201
margins, dydx(stat3w30d) at (year_cen= 6 year_sq= 36 year_cub= 216 stat3w30d= 0.0454545 cincperc= 0.9790441 demb= 0) predict(outcome(3))
* dymidnum== 297701
margins, dydx(stat3w30d) at (year_cen= 7 year_sq= 49 year_cub= 343 stat3w30d= 0.1935484 cincperc= 0.9956588 demb= 0) predict(outcome(3))
* dymidnum== 297801
margins, dydx(stat3w30d) at (year_cen= 7 year_sq= 49 year_cub= 343 stat3w30d= 0.0967742 cincperc= 0.9853611 demb= 0) predict(outcome(3))
* dymidnum== 297901
margins, dydx(stat3w30d) at (year_cen= 7 year_sq= 49 year_cub= 343 stat3w30d= 0 cincperc= 0.9370917 demb= 0) predict(outcome(3))
* dymidnum== 298101
margins, dydx(stat3w30d) at (year_cen= 8 year_sq= 64 year_cub= 512 stat3w30d= 0.0645161 cincperc= 0.9773921 demb= 0) predict(outcome(3))
* dymidnum== 298201
margins, dydx(stat3w30d) at (year_cen= 7 year_sq= 49 year_cub= 343 stat3w30d= 2.096774 cincperc= 0.426029 demb= 0) predict(outcome(3))
* dymidnum== 302001
margins, dydx(stat3w30d) at (year_cen= 5 year_sq= 25 year_cub= 125 stat3w30d= 2.252632 cincperc= 0.942982 demb= 0) predict(outcome(3))
* dymidnum== 302101
margins, dydx(stat3w30d) at (year_cen= 4 year_sq= 16 year_cub= 64 stat3w30d= 0 cincperc= 0.9843176 demb= 0) predict(outcome(3))
* dymidnum== 305101
margins, dydx(stat3w30d) at (year_cen= 9 year_sq= 81 year_cub= 729 stat3w30d= 0.1290323 cincperc= 0.9822266 demb= 0) predict(outcome(3))
* dymidnum== 305801
margins, dydx(stat3w30d) at (year_cen= 8 year_sq= 64 year_cub= 512 stat3w30d= 0.0789474 cincperc= 0.9773921 demb= 0) predict(outcome(3))
* dymidnum== 305802
margins, dydx(stat3w30d) at (year_cen= 8 year_sq= 64 year_cub= 512 stat3w30d= 0.5952381 cincperc= 0.9999242 demb= 0) predict(outcome(3))
* dymidnum== 306201
margins, dydx(stat3w30d) at (year_cen= 8 year_sq= 64 year_cub= 512 stat3w30d= 0.4586777 cincperc= 0.9700375 demb= 0) predict(outcome(3))
* dymidnum== 306501
margins, dydx(stat3w30d) at (year_cen= 8 year_sq= 64 year_cub= 512 stat3w30d= 0.075 cincperc= 0.9838408 demb= 0) predict(outcome(3))
* dymidnum== 307101
margins, dydx(stat3w30d) at (year_cen= 8 year_sq= 64 year_cub= 512 stat3w30d= 0.0165746 cincperc= 0.9283013 demb= 0) predict(outcome(3))
* dymidnum== 307201
margins, dydx(stat3w30d) at (year_cen= 8 year_sq= 64 year_cub= 512 stat3w30d= 0.1470588 cincperc= 0.9838408 demb= 0) predict(outcome(3))
* dymidnum== 308801
margins, dydx(stat3w30d) at (year_cen= 7 year_sq= 49 year_cub= 343 stat3w30d= 0 cincperc= 0.9853611 demb= 0) predict(outcome(3))
* dymidnum== 309801
margins, dydx(stat3w30d) at (year_cen= 6 year_sq= 36 year_cub= 216 stat3w30d= 0.0344828 cincperc= 0.9905521 demb= 0) predict(outcome(3))
* dymidnum== 309901
margins, dydx(stat3w30d) at (year_cen= 6 year_sq= 36 year_cub= 216 stat3w30d= 0.1470588 cincperc= 0.9905521 demb= 0) predict(outcome(3))
* dymidnum== 310501
margins, dydx(stat3w30d) at (year_cen= 5 year_sq= 25 year_cub= 125 stat3w30d= 0.3135593 cincperc= 0.9916193 demb= 1) predict(outcome(3))
* dymidnum== 320901
margins, dydx(stat3w30d) at (year_cen= -21 year_sq= 441 year_cub= -9261 stat3w30d= 0 cincperc= 0.9941041 demb= 1) predict(outcome(3))
* dymidnum== 322201
margins, dydx(stat3w30d) at (year_cen= -19 year_sq= 361 year_cub= -6859 stat3w30d= 0 cincperc= 0.9763142 demb= 0) predict(outcome(3))
* dymidnum== 324201
margins, dydx(stat3w30d) at (year_cen= -20 year_sq= 400 year_cub= -8000 stat3w30d= 0 cincperc= 0.9972839 demb= 0) predict(outcome(3))
* dymidnum== 324301
margins, dydx(stat3w30d) at (year_cen= -20 year_sq= 400 year_cub= -8000 stat3w30d= 0 cincperc= 0.9942563 demb= 0) predict(outcome(3))
* dymidnum== 324401
margins, dydx(stat3w30d) at (year_cen= -13 year_sq= 169 year_cub= -2197 stat3w30d= 0 cincperc= 0.9909053 demb= 0) predict(outcome(3))
* dymidnum== 336101
margins, dydx(stat3w30d) at (year_cen= -13 year_sq= 169 year_cub= -2197 stat3w30d= 0.4193548 cincperc= 0.5434619 demb= 0) predict(outcome(3))
* dymidnum== 336102
margins, dydx(stat3w30d) at (year_cen= -13 year_sq= 169 year_cub= -2197 stat3w30d= 0.0645161 cincperc= 0.6695303 demb= 0) predict(outcome(3))
* dymidnum== 336103
margins, dydx(stat3w30d) at (year_cen= -13 year_sq= 169 year_cub= -2197 stat3w30d= 0.0338983 cincperc= 0.9818648 demb= 0) predict(outcome(3))
* dymidnum== 354101
margins, dydx(stat3w30d) at (year_cen= 9 year_sq= 81 year_cub= 729 stat3w30d= 0.3137255 cincperc= 0.9186934 demb= 0) predict(outcome(3))
* dymidnum== 355001
margins, dydx(stat3w30d) at (year_cen= 17 year_sq= 289 year_cub= 4913 stat3w30d= 0.3548387 cincperc= 0.9779482 demb= 0) predict(outcome(3))
* dymidnum== 355101
margins, dydx(stat3w30d) at (year_cen= 19 year_sq= 361 year_cub= 6859 stat3w30d= 0.8477707 cincperc= 0.9833084 demb= 0) predict(outcome(3))
* dymidnum== 355201
margins, dydx(stat3w30d) at (year_cen= 18 year_sq= 324 year_cub= 5832 stat3w30d= 0.5504587 cincperc= 0.9617583 demb= 0) predict(outcome(3))
* dymidnum== 356801
margins, dydx(stat3w30d) at (year_cen= 18 year_sq= 324 year_cub= 5832 stat3w30d= 1.5 cincperc= 0.9617583 demb= 0) predict(outcome(3))
* dymidnum== 361301
margins, dydx(stat3w30d) at (year_cen= 7 year_sq= 49 year_cub= 343 stat3w30d= 0 cincperc= 0.9970616 demb= 0) predict(outcome(3))
* dymidnum== 362001
margins, dydx(stat3w30d) at (year_cen= 10 year_sq= 100 year_cub= 1000 stat3w30d= 0 cincperc= 0.9880429 demb= 0) predict(outcome(3))
* dymidnum== 362501
margins, dydx(stat3w30d) at (year_cen= 11 year_sq= 121 year_cub= 1331 stat3w30d= 0.1543624 cincperc= 0.9388648 demb= 0) predict(outcome(3))
* dymidnum== 363401
margins, dydx(stat3w30d) at (year_cen= 8 year_sq= 64 year_cub= 512 stat3w30d= 0.1320755 cincperc= 0.9838408 demb= 0) predict(outcome(3))
* dymidnum== 363601
margins, dydx(stat3w30d) at (year_cen= 11 year_sq= 121 year_cub= 1331 stat3w30d= 1.528455 cincperc= 0.9876705 demb= 0) predict(outcome(3))
* dymidnum== 363701
margins, dydx(stat3w30d) at (year_cen= 11 year_sq= 121 year_cub= 1331 stat3w30d= 1.032258 cincperc= 0.4383736 demb= 0) predict(outcome(3))
* dymidnum== 390001
margins, dydx(stat3w30d) at (year_cen= 14 year_sq= 196 year_cub= 2744 stat3w30d= 0.0645161 cincperc= 0.9221288 demb= 1) predict(outcome(3))
* dymidnum== 390101
margins, dydx(stat3w30d) at (year_cen= 14 year_sq= 196 year_cub= 2744 stat3w30d= 0.68 cincperc= 0.9979265 demb= 1) predict(outcome(3))
* dymidnum== 390301
margins, dydx(stat3w30d) at (year_cen= 14 year_sq= 196 year_cub= 2744 stat3w30d= 0 cincperc= 0.9295208 demb= 0) predict(outcome(3))
* dymidnum== 395001
margins, dydx(stat3w30d) at (year_cen= 15 year_sq= 225 year_cub= 3375 stat3w30d= 0.0794702 cincperc= 0.9778048 demb= 0) predict(outcome(3))
* dymidnum== 395701
margins, dydx(stat3w30d) at (year_cen= 15 year_sq= 225 year_cub= 3375 stat3w30d= 0.1308017 cincperc= 0.9922839 demb= 0) predict(outcome(3))
* dymidnum== 395702
margins, dydx(stat3w30d) at (year_cen= 15 year_sq= 225 year_cub= 3375 stat3w30d= 11.77075 cincperc= 0.9174381 demb= 0) predict(outcome(3))
* dymidnum== 397201
margins, dydx(stat3w30d) at (year_cen= 16 year_sq= 256 year_cub= 4096 stat3w30d= 0.1290323 cincperc= 0.916431 demb= 1) predict(outcome(3))
* dymidnum== 397301
margins, dydx(stat3w30d) at (year_cen= 16 year_sq= 256 year_cub= 4096 stat3w30d= 0.0967742 cincperc= 0.9286978 demb= 0) predict(outcome(3))
* dymidnum== 397401
margins, dydx(stat3w30d) at (year_cen= 16 year_sq= 256 year_cub= 4096 stat3w30d= 2.242236 cincperc= 0.9425649 demb= 0) predict(outcome(3))
* dymidnum== 401601
margins, dydx(stat3w30d) at (year_cen= 19 year_sq= 361 year_cub= 6859 stat3w30d= 1.803714 cincperc= 0.9969766 demb= 1) predict(outcome(3))
* dymidnum== 402101
margins, dydx(stat3w30d) at (year_cen= 18 year_sq= 324 year_cub= 5832 stat3w30d= 0.2115385 cincperc= 0.9209583 demb= 0) predict(outcome(3))
* dymidnum== 402201
margins, dydx(stat3w30d) at (year_cen= 19 year_sq= 361 year_cub= 6859 stat3w30d= 0.8117048 cincperc= 0.9252269 demb= 0) predict(outcome(3))
* dymidnum== 404601
margins, dydx(stat3w30d) at (year_cen= 19 year_sq= 361 year_cub= 6859 stat3w30d= 4.255814 cincperc= 0.9833084 demb= 0) predict(outcome(3))
* dymidnum== 406401
margins, dydx(stat3w30d) at (year_cen= 21 year_sq= 441 year_cub= 9261 stat3w30d= 0.0992366 cincperc= 0.4986025 demb= 0) predict(outcome(3))
* dymidnum== 406501
margins, dydx(stat3w30d) at (year_cen= 19 year_sq= 361 year_cub= 6859 stat3w30d= 0.02 cincperc= 0.5266865 demb= 0) predict(outcome(3))
* dymidnum== 408701
margins, dydx(stat3w30d) at (year_cen= 22 year_sq= 484 year_cub= 10648 stat3w30d= 0.1624185 cincperc= 0.9273375 demb= 0) predict(outcome(3))
* dymidnum== 408801
margins, dydx(stat3w30d) at (year_cen= 24 year_sq= 576 year_cub= 13824 stat3w30d= 1.255738 cincperc= 0.4867421 demb= 0) predict(outcome(3))
* dymidnum== 412501
margins, dydx(stat3w30d) at (year_cen= 24 year_sq= 576 year_cub= 13824 stat3w30d= 0.047619 cincperc= 0.9357262 demb= 0) predict(outcome(3))
* dymidnum== 413701
margins, dydx(stat3w30d) at (year_cen= 23 year_sq= 529 year_cub= 12167 stat3w30d= 3.414747 cincperc= 0.9845497 demb= 0) predict(outcome(3))
* dymidnum== 417401
margins, dydx(stat3w30d) at (year_cen= 22 year_sq= 484 year_cub= 10648 stat3w30d= 0.2883721 cincperc= 0.7212901 demb= 0) predict(outcome(3))
* dymidnum== 418301
margins, dydx(stat3w30d) at (year_cen= 22 year_sq= 484 year_cub= 10648 stat3w30d= 0.2352941 cincperc= 0.9233102 demb= 1) predict(outcome(3))
* dymidnum== 418601
margins, dydx(stat3w30d) at (year_cen= 25 year_sq= 625 year_cub= 15625 stat3w30d= 0.1643836 cincperc= 0.9862894 demb= 1) predict(outcome(3))
* dymidnum== 419001
margins, dydx(stat3w30d) at (year_cen= 21 year_sq= 441 year_cub= 9261 stat3w30d= 0.0333333 cincperc= 0.9712683 demb= 0) predict(outcome(3))
* dymidnum== 419601
margins, dydx(stat3w30d) at (year_cen= 21 year_sq= 441 year_cub= 9261 stat3w30d= 0.1612903 cincperc= 0.9888993 demb= 0) predict(outcome(3))
* dymidnum== 419701
margins, dydx(stat3w30d) at (year_cen= 25 year_sq= 625 year_cub= 15625 stat3w30d= 0.5454546 cincperc= 0.7426987 demb= 0) predict(outcome(3))
* dymidnum== 421301
margins, dydx(stat3w30d) at (year_cen= 25 year_sq= 625 year_cub= 15625 stat3w30d= 0.2521739 cincperc= 0.7426987 demb= 0) predict(outcome(3))
* dymidnum== 421601
margins, dydx(stat3w30d) at (year_cen= 22 year_sq= 484 year_cub= 10648 stat3w30d= 0 cincperc= 0.9177598 demb= 0) predict(outcome(3))
* dymidnum== 421701
margins, dydx(stat3w30d) at (year_cen= 23 year_sq= 529 year_cub= 12167 stat3w30d= 1.387097 cincperc= 0.9839257 demb= 0) predict(outcome(3))
* dymidnum== 421801
margins, dydx(stat3w30d) at (year_cen= 25 year_sq= 625 year_cub= 15625 stat3w30d= 0.0967742 cincperc= 0.9334546 demb= 0) predict(outcome(3))
* dymidnum== 422001
margins, dydx(stat3w30d) at (year_cen= 25 year_sq= 625 year_cub= 15625 stat3w30d= 0.5 cincperc= 0.7426987 demb= 0) predict(outcome(3))
* dymidnum== 422701
margins, dydx(stat3w30d) at (year_cen= 23 year_sq= 529 year_cub= 12167 stat3w30d= 1.387097 cincperc= 0.9916295 demb= 0) predict(outcome(3))
* dymidnum== 425401
margins, dydx(stat3w30d) at (year_cen= 23 year_sq= 529 year_cub= 12167 stat3w30d= 0.0165289 cincperc= 0.9987422 demb= 0) predict(outcome(3))
* dymidnum== 426101
margins, dydx(stat3w30d) at (year_cen= 25 year_sq= 625 year_cub= 15625 stat3w30d= 0 cincperc= 0.9693967 demb= 1) predict(outcome(3))
* dymidnum== 426901
margins, dydx(stat3w30d) at (year_cen= 20 year_sq= 400 year_cub= 8000 stat3w30d= 0.6831896 cincperc= 0.9584466 demb= 0) predict(outcome(3))
* dymidnum== 427001
margins, dydx(stat3w30d) at (year_cen= 19 year_sq= 361 year_cub= 6859 stat3w30d= 0.6129032 cincperc= 0.958767 demb= 0) predict(outcome(3))
* dymidnum== 427101
margins, dydx(stat3w30d) at (year_cen= 21 year_sq= 441 year_cub= 9261 stat3w30d= 1.536083 cincperc= 0.9576172 demb= 0) predict(outcome(3))
* dymidnum== 427301
margins, dydx(stat3w30d) at (year_cen= 25 year_sq= 625 year_cub= 15625 stat3w30d= 1.734981 cincperc= 0.9596501 demb= 0) predict(outcome(3))
* dymidnum== 428001
margins, dydx(stat3w30d) at (year_cen= 26 year_sq= 676 year_cub= 17576 stat3w30d= 0.7419355 cincperc= 0.4725055 demb= 0) predict(outcome(3))
* dymidnum== 428101
margins, dydx(stat3w30d) at (year_cen= 26 year_sq= 676 year_cub= 17576 stat3w30d= 0.4827586 cincperc= 0.4725055 demb= 0) predict(outcome(3))
* dymidnum== 428301
margins, dydx(stat3w30d) at (year_cen= 26 year_sq= 676 year_cub= 17576 stat3w30d= 5.032609 cincperc= 0.9915357 demb= 0) predict(outcome(3))
* dymidnum== 429801
margins, dydx(stat3w30d) at (year_cen= 25 year_sq= 625 year_cub= 15625 stat3w30d= 1.058824 cincperc= 0.9862894 demb= 1) predict(outcome(3))
* dymidnum== 429901
margins, dydx(stat3w30d) at (year_cen= 18 year_sq= 324 year_cub= 5832 stat3w30d= 0.969697 cincperc= 0.9617583 demb= 0) predict(outcome(3))
* dymidnum== 433601
margins, dydx(stat3w30d) at (year_cen= 26 year_sq= 676 year_cub= 17576 stat3w30d= 0.7741935 cincperc= 0.4725055 demb= 0) predict(outcome(3))
* dymidnum== 434201
margins, dydx(stat3w30d) at (year_cen= 24 year_sq= 576 year_cub= 13824 stat3w30d= 1.142857 cincperc= 0.7428356 demb= 0) predict(outcome(3))
* dymidnum== 434301
margins, dydx(stat3w30d) at (year_cen= 25 year_sq= 625 year_cub= 15625 stat3w30d= 0.0285714 cincperc= 0.9862894 demb= 1) predict(outcome(3))
* dymidnum== 437101
margins, dydx(stat3w30d) at (year_cen= 29 year_sq= 841 year_cub= 24389 stat3w30d= 0 cincperc= 0.9922591 demb= 0) predict(outcome(3))
* dymidnum== 445001
margins, dydx(stat3w30d) at (year_cen= 27 year_sq= 729 year_cub= 19683 stat3w30d= 0.0322581 cincperc= 0.4615541 demb= 0) predict(outcome(3))
* dymidnum== 445101
margins, dydx(stat3w30d) at (year_cen= 27 year_sq= 729 year_cub= 19683 stat3w30d= 0 cincperc= 0.9267441 demb= 0) predict(outcome(3))
* dymidnum== 445501
margins, dydx(stat3w30d) at (year_cen= 28 year_sq= 784 year_cub= 21952 stat3w30d= 0.2734694 cincperc= 0.9265575 demb= 0) predict(outcome(3))
* dymidnum== 446001
margins, dydx(stat3w30d) at (year_cen= 28 year_sq= 784 year_cub= 21952 stat3w30d= 0.0322581 cincperc= 0.9098551 demb= 0) predict(outcome(3))
* dymidnum== 446501
margins, dydx(stat3w30d) at (year_cen= 29 year_sq= 841 year_cub= 24389 stat3w30d= 0.8285714 cincperc= 0.9182267 demb= 0) predict(outcome(3))
* dymidnum== 451201
margins, dydx(stat3w30d) at (year_cen= 28 year_sq= 784 year_cub= 21952 stat3w30d= 0.5 cincperc= 0.9191019 demb= 0) predict(outcome(3))
* dymidnum== 451601
margins, dydx(stat3w30d) at (year_cen= 28 year_sq= 784 year_cub= 21952 stat3w30d= 0 cincperc= 0.9108425 demb= 1) predict(outcome(3))
* dymidnum== 451801
margins, dydx(stat3w30d) at (year_cen= 29 year_sq= 841 year_cub= 24389 stat3w30d= 0 cincperc= 0.9697707 demb= 0) predict(outcome(3))
* dymidnum== 451901
margins, dydx(stat3w30d) at (year_cen= 29 year_sq= 841 year_cub= 24389 stat3w30d= 1.677419 cincperc= 0.9198307 demb= 0) predict(outcome(3))
* dymidnum== 452401
margins, dydx(stat3w30d) at (year_cen= 29 year_sq= 841 year_cub= 24389 stat3w30d= 0.3554217 cincperc= 0.9198307 demb= 0) predict(outcome(3))
* dymidnum== 452701
margins, dydx(stat3w30d) at (year_cen= 30 year_sq= 900 year_cub= 27000 stat3w30d= 0.3235294 cincperc= 0.9708248 demb= 0) predict(outcome(3))
* dymidnum== 453501
margins, dydx(stat3w30d) at (year_cen= 32 year_sq= 1024 year_cub= 32768 stat3w30d= 1.527472 cincperc= 0.9135591 demb= 0) predict(outcome(3))
* dymidnum== 453801
margins, dydx(stat3w30d) at (year_cen= 32 year_sq= 1024 year_cub= 32768 stat3w30d= 1.8125 cincperc= 0.9135591 demb= 0) predict(outcome(3))
* dymidnum== 455201
margins, dydx(stat3w30d) at (year_cen= 29 year_sq= 841 year_cub= 24389 stat3w30d= 0.5016575 cincperc= 0.9138823 demb= 0) predict(outcome(3))
* dymidnum== 456801
margins, dydx(stat3w30d) at (year_cen= 30 year_sq= 900 year_cub= 27000 stat3w30d= 0.4516129 cincperc= 0.9159293 demb= 0) predict(outcome(3))
* dymidnum== 457101
margins, dydx(stat3w30d) at (year_cen= 30 year_sq= 900 year_cub= 27000 stat3w30d= 0.6710526 cincperc= 0.9159293 demb= 0) predict(outcome(3))
* dymidnum== 457701
margins, dydx(stat3w30d) at (year_cen= 32 year_sq= 1024 year_cub= 32768 stat3w30d= 0.2835821 cincperc= 0.9116742 demb= 0) predict(outcome(3))

* Predicting the marginal effect for each dyadic MID using Model 1 in order to see which MIDs are highest.

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn, vce(robust)
* dymidnum== 2701
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -14 year_sq= 196 year_cub= -2744 stat3w30d= 0 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9358472 demb= 0 defensepact= 0 s3un4608i= -0.3809524 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 2702
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -14 year_sq= 196 year_cub= -2744 stat3w30d= 0 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9489417 demb= 0 defensepact= 0 s3un4608i= -0.3592233 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 2703
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -14 year_sq= 196 year_cub= -2744 stat3w30d= 1.429906 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9588433 demb= 0 defensepact= 0 s3un4608i= -0.2513433 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 2704
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -14 year_sq= 196 year_cub= -2744 stat3w30d= 1.880952 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.5479898 demb= 0 defensepact= 0 s3un4608i= -0.3619048 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 5001
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -21 year_sq= 441 year_cub= -9261 stat3w30d= 0.2285714 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 1 revregime= 0 revpolicy= 0 cincperc= 0.603565 demb= 0 defensepact= 0 s3un4608i= -0.0967742 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 5002
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -21 year_sq= 441 year_cub= -9261 stat3w30d= 0.1214869 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 1 revregime= 0 revpolicy= 0 cincperc= 0.7485799 demb= 0 defensepact= 0 s3un4608i= -0.4028755 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 5101
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -23 year_sq= 529 year_cub= -12167 stat3w30d= 0.1224105 hostleva= 5 hostlevb= 5 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.7635944 demb= 0 defensepact= 0 s3un4608i= -0.4028755 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 5102
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -23 year_sq= 529 year_cub= -12167 stat3w30d= 0.0414866 hostleva= 5 hostlevb= 5 sanctions_ties= 1 revterritory= 1 revregime= 0 revpolicy= 0 cincperc= 0.9900788 demb= 0 defensepact= 0 s3un4608i= -0.6577495 rus= 0 nkr= 1 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 5301
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -19 year_sq= 361 year_cub= -6859 stat3w30d= 0 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.7264464 demb= 0 defensepact= 0 s3un4608i= -0.4028755 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 6101
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -13 year_sq= 169 year_cub= -2197 stat3w30d= 0.4584527 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.9828988 demb= 0 defensepact= 1 s3un4608i= -0.5 rus= 0 nkr= 0 chn= 0 cub= 1 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 6102
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -13 year_sq= 169 year_cub= -2197 stat3w30d= 0.9885387 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.5434619 demb= 0 defensepact= 0 s3un4608i= -0.4393939 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 12501
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -17 year_sq= 289 year_cub= -4913 stat3w30d= 0.0227273 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9924799 demb= 0 defensepact= 0 s3un4608i= 0.1612903 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 1 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 12502
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -17 year_sq= 289 year_cub= -4913 stat3w30d= 0.513089 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.5783337 demb= 0 defensepact= 0 s3un4608i= -0.1935484 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 12503
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -17 year_sq= 289 year_cub= -4913 stat3w30d= 0 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9778062 demb= 0 defensepact= 0 s3un4608i= 0.1290323 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 17201
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -13 year_sq= 169 year_cub= -2197 stat3w30d= 0.1768293 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.6695303 demb= 0 defensepact= 0 s3un4608i= -0.4028755 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 17301
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -17 year_sq= 289 year_cub= -4913 stat3w30d= 0.3870968 hostleva= 3 hostlevb= 2 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.5783337 demb= 0 defensepact= 0 s3un4608i= -0.1935484 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 17302
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -17 year_sq= 289 year_cub= -4913 stat3w30d= 0.6353591 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 1 revregime= 0 revpolicy= 0 cincperc= 0.6838089 demb= 0 defensepact= 0 s3un4608i= -0.4028755 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 20001
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -19 year_sq= 361 year_cub= -6859 stat3w30d= 0.5806451 hostleva= 3 hostlevb= 2 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.6049386 demb= 0 defensepact= 0 s3un4608i= -0.3061225 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 20002
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -19 year_sq= 361 year_cub= -6859 stat3w30d= 0.6451613 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.980395 demb= 0 defensepact= 0 s3un4608i= 0.244898 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 20801
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -22 year_sq= 484 year_cub= -10648 stat3w30d= 0.18 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.6425185 demb= 0 defensepact= 0 s3un4608i= -0.1923077 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 20802
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -22 year_sq= 484 year_cub= -10648 stat3w30d= 0.0192308 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9664532 demb= 0 defensepact= 0 s3un4608i= -0.1923077 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 24601
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -15 year_sq= 225 year_cub= -3375 stat3w30d= 0.4192547 hostleva= 3 hostlevb= 2 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.5563662 demb= 0 defensepact= 0 s3un4608i= -0.5 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 24602
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -15 year_sq= 225 year_cub= -3375 stat3w30d= 0.275 hostleva= 3 hostlevb= 4 sanctions_ties= 1 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.9915661 demb= 0 defensepact= 1 s3un4608i= -0.5 rus= 0 nkr= 0 chn= 0 cub= 1 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 25101
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -10 year_sq= 100 year_cub= -1000 stat3w30d= 0.1612903 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.6492279 demb= 0 defensepact= 0 s3un4608i= -0.4028755 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 25301
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -15 year_sq= 225 year_cub= -3375 stat3w30d= 0.7522936 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.5563662 demb= 0 defensepact= 0 s3un4608i= -0.5 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 34501
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -8 year_sq= 64 year_cub= -512 stat3w30d= 0 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.5556993 demb= 0 defensepact= 0 s3un4608i= -0.3272727 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 34701
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -7 year_sq= 49 year_cub= -343 stat3w30d= 0.0630137 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9743533 demb= 0 defensepact= 0 s3un4608i= -0.6577495 rus= 0 nkr= 1 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 35001
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -6 year_sq= 36 year_cub= -216 stat3w30d= 0.0162602 hostleva= 1 hostlevb= 4 sanctions_ties= 1 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9881925 demb= 0 defensepact= 1 s3un4608i= 0.047619 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 35301
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -2 year_sq= 4 year_cub= -8 stat3w30d= 0.245283 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.4820844 demb= 0 defensepact= 0 s3un4608i= 0.0106383 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 35601
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 0 year_sq= 0 year_cub= 0 stat3w30d= 0.1764706 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9942689 demb= 0 defensepact= 0 s3un4608i= -0.3913043 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 36201
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 1 year_sq= 1 year_cub= 1 stat3w30d= 0 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.9548209 demb= 0 defensepact= 0 s3un4608i= -0.6577495 rus= 0 nkr= 1 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 60101
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -3 year_sq= 9 year_cub= -27 stat3w30d= 0 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9844744 demb= 0 defensepact= 1 s3un4608i= 0.1698113 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 60201
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -3 year_sq= 9 year_cub= -27 stat3w30d= 0 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.994945 demb= 0 defensepact= 1 s3un4608i= 0.1954023 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 60701
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -18 year_sq= 324 year_cub= -5832 stat3w30d= 0.0294118 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9798644 demb= 0 defensepact= 0 s3un4608i= -0.0192308 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 60702
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -18 year_sq= 324 year_cub= -5832 stat3w30d= 0.0125523 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 1 revregime= 0 revpolicy= 0 cincperc= 0.9949703 demb= 1 defensepact= 0 s3un4608i= -0.0192308 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 60703
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -18 year_sq= 324 year_cub= -5832 stat3w30d= 0.3891214 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.6039295 demb= 0 defensepact= 0 s3un4608i= -0.2115385 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 60801
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -16 year_sq= 256 year_cub= -4096 stat3w30d= 0.984556 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 1 revregime= 0 revpolicy= 0 cincperc= 0.5721744 demb= 0 defensepact= 0 s3un4608i= -0.4285714 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 61101
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -7 year_sq= 49 year_cub= -343 stat3w30d= 0.0962025 hostleva= 4 hostlevb= 2 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.6613681 demb= 0 defensepact= 0 s3un4608i= -0.4028755 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 61102
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -11 year_sq= 121 year_cub= -1331 stat3w30d= 0.3429844 hostleva= 2 hostlevb= 2 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.5478964 demb= 0 defensepact= 0 s3un4608i= -0.2859195 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 61103
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -7 year_sq= 49 year_cub= -343 stat3w30d= 0.9155529 hostleva= 5 hostlevb= 5 sanctions_ties= 1 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.9759957 demb= 0 defensepact= 0 s3un4608i= -0.5474283 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 63301
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -25 year_sq= 625 year_cub= -15625 stat3w30d= 0 hostleva= 3 hostlevb= 4 sanctions_ties= 1 revterritory= 1 revregime= 0 revpolicy= 0 cincperc= 0.7059219 demb= 0 defensepact= 0 s3un4608i= -0.4028755 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 100201
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -12 year_sq= 144 year_cub= -1728 stat3w30d= 0 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.997906 demb= 0 defensepact= 1 s3un4608i= 0.3333333 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 103901
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -5 year_sq= 25 year_cub= -125 stat3w30d= 0 hostleva= 1 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.5098097 demb= 0 defensepact= 0 s3un4608i= -0.4328358 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 103902
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -5 year_sq= 25 year_cub= -125 stat3w30d= 0 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9919642 demb= 0 defensepact= 0 s3un4608i= -0.328125 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 103903
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -5 year_sq= 25 year_cub= -125 stat3w30d= 0 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9872485 demb= 0 defensepact= 0 s3un4608i= -0.3015873 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 1 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 110801
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -13 year_sq= 169 year_cub= -2197 stat3w30d= 0 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.970248 demb= 0 defensepact= 0 s3un4608i= -0.2615385 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 110802
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -13 year_sq= 169 year_cub= -2197 stat3w30d= 0 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9987981 demb= 0 defensepact= 0 s3un4608i= -0.0612245 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 112401
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -17 year_sq= 289 year_cub= -4913 stat3w30d= 0 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9980836 demb= 0 defensepact= 1 s3un4608i= 0.8709677 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 115801
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -4 year_sq= 16 year_cub= -64 stat3w30d= 0 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9951827 demb= 0 defensepact= 1 s3un4608i= 0.2666667 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 119301
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -21 year_sq= 441 year_cub= -9261 stat3w30d= 0 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.9992658 demb= 0 defensepact= 1 s3un4608i= 0.36 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 121301
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -11 year_sq= 121 year_cub= -1331 stat3w30d= 0 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9947348 demb= 0 defensepact= 0 s3un4608i= -0.2449088 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 121601
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -9 year_sq= 81 year_cub= -729 stat3w30d= 0.1131387 hostleva= 4 hostlevb= 2 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.6555259 demb= 0 defensepact= 0 s3un4608i= -0.4028755 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 121602
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -9 year_sq= 81 year_cub= -729 stat3w30d= 0 hostleva= 4 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9948136 demb= 0 defensepact= 0 s3un4608i= -0.3636364 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 121701
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -8 year_sq= 64 year_cub= -512 stat3w30d= 0 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9949306 demb= 0 defensepact= 0 s3un4608i= -0.3902439 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 128601
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -24 year_sq= 576 year_cub= -13824 stat3w30d= 0 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9842262 demb= 0 defensepact= 0 s3un4608i= -0.1765009 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 128602
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -24 year_sq= 576 year_cub= -13824 stat3w30d= 0 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9904422 demb= 0 defensepact= 0 s3un4608i= -0.1752734 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 128603
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -24 year_sq= 576 year_cub= -13824 stat3w30d= 0 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9790978 demb= 0 defensepact= 0 s3un4608i= -0.1610668 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 128604
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -24 year_sq= 576 year_cub= -13824 stat3w30d= 0.8577075 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.6485161 demb= 0 defensepact= 0 s3un4608i= -1 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 135301
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -13 year_sq= 169 year_cub= -2197 stat3w30d= 0.4883721 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.5434619 demb= 0 defensepact= 0 s3un4608i= -0.4393939 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 135302
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -12 year_sq= 144 year_cub= -1728 stat3w30d= 0.1886792 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.6600661 demb= 0 defensepact= 0 s3un4608i= -0.4028755 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 136301
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -14 year_sq= 196 year_cub= -2744 stat3w30d= 0.755102 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.5479898 demb= 0 defensepact= 0 s3un4608i= -0.3619048 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 136302
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -14 year_sq= 196 year_cub= -2744 stat3w30d= 0.0204082 hostleva= 3 hostlevb= 2 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.6674777 demb= 0 defensepact= 0 s3un4608i= -0.4028755 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 136303
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -14 year_sq= 196 year_cub= -2744 stat3w30d= 0.15 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.9819949 demb= 0 defensepact= 0 s3un4608i= -0.5474283 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 137901
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -8 year_sq= 64 year_cub= -512 stat3w30d= 0.0357884 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.9762254 demb= 0 defensepact= 0 s3un4608i= -0.6577495 rus= 0 nkr= 1 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 147201
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 0 year_sq= 0 year_cub= 0 stat3w30d= 0.0092166 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.9567155 demb= 0 defensepact= 0 s3un4608i= -0.6577495 rus= 0 nkr= 1 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 170201
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -23 year_sq= 529 year_cub= -12167 stat3w30d= 0 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9979203 demb= 0 defensepact= 1 s3un4608i= 0.3768116 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 170501
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -21 year_sq= 441 year_cub= -9261 stat3w30d= 0 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.997663 demb= 0 defensepact= 1 s3un4608i= 0.2 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 174201
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -16 year_sq= 256 year_cub= -4096 stat3w30d= 0 hostleva= 1 hostlevb= 2 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.9925719 demb= 0 defensepact= 1 s3un4608i= 0 rus= 0 nkr= 0 chn= 0 cub= 1 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 180101
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -14 year_sq= 196 year_cub= -2744 stat3w30d= 0 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9975324 demb= 0 defensepact= 1 s3un4608i= 0.6 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 180301
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -12 year_sq= 144 year_cub= -1728 stat3w30d= 0 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.996546 demb= 0 defensepact= 1 s3un4608i= 0.6071429 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 180501
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -8 year_sq= 64 year_cub= -512 stat3w30d= 0 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9965547 demb= 0 defensepact= 1 s3un4608i= 0.254902 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 180601
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -7 year_sq= 49 year_cub= -343 stat3w30d= 0.0080483 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9948668 demb= 0 defensepact= 0 s3un4608i= -0.3571429 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 200201
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -15 year_sq= 225 year_cub= -3375 stat3w30d= 0 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.6436611 demb= 0 defensepact= 0 s3un4608i= -0.4028755 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 203201
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -20 year_sq= 400 year_cub= -8000 stat3w30d= 0.0645161 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.7446828 demb= 0 defensepact= 0 s3un4608i= -0.4028755 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 203301
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -21 year_sq= 441 year_cub= -9261 stat3w30d= 0.6571429 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.7485799 demb= 0 defensepact= 0 s3un4608i= -0.4028755 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 203501
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -22 year_sq= 484 year_cub= -10648 stat3w30d= 0 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.7659119 demb= 0 defensepact= 0 s3un4608i= -0.4028755 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 204901
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -18 year_sq= 324 year_cub= -5832 stat3w30d= 0.09375 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 1 revregime= 0 revpolicy= 0 cincperc= 0.7192998 demb= 0 defensepact= 0 s3un4608i= -0.4028755 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 205201
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -24 year_sq= 576 year_cub= -13824 stat3w30d= 0.1032864 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 1 revregime= 0 revpolicy= 0 cincperc= 0.7550968 demb= 0 defensepact= 0 s3un4608i= -0.4028755 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 217601
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 8 year_sq= 64 year_cub= 512 stat3w30d= 0.0337423 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 1 revregime= 0 revpolicy= 0 cincperc= 0.9776064 demb= 1 defensepact= 1 s3un4608i= -0.261745 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 218701
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -16 year_sq= 256 year_cub= -4096 stat3w30d= 0.019245 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.9761097 demb= 0 defensepact= 0 s3un4608i= -0.6577495 rus= 0 nkr= 1 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 218801
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -13 year_sq= 169 year_cub= -2197 stat3w30d= 0 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.9756079 demb= 0 defensepact= 0 s3un4608i= -0.6577495 rus= 0 nkr= 1 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 218901
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -12 year_sq= 144 year_cub= -1728 stat3w30d= 0.0109489 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.9771866 demb= 0 defensepact= 0 s3un4608i= -0.6577495 rus= 0 nkr= 1 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 219201
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 2 year_sq= 4 year_cub= 8 stat3w30d= 0.0071942 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.9533319 demb= 0 defensepact= 0 s3un4608i= -0.6577495 rus= 0 nkr= 1 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 219301
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 4 year_sq= 16 year_cub= 64 stat3w30d= 0.0217391 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.9455901 demb= 0 defensepact= 0 s3un4608i= -0.6577495 rus= 0 nkr= 1 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 219501
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 8 year_sq= 64 year_cub= 512 stat3w30d= 0 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.9377402 demb= 0 defensepact= 0 s3un4608i= -0.6577495 rus= 0 nkr= 1 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 219601
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 10 year_sq= 100 year_cub= 1000 stat3w30d= 0 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.937026 demb= 0 defensepact= 0 s3un4608i= -0.6577495 rus= 0 nkr= 1 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 221501
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -17 year_sq= 289 year_cub= -4913 stat3w30d= 0.2439024 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.5783337 demb= 0 defensepact= 0 s3un4608i= -0.1935484 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 221601
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -17 year_sq= 289 year_cub= -4913 stat3w30d= 0.2258064 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.5783337 demb= 0 defensepact= 0 s3un4608i= -0.1935484 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 221701
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -14 year_sq= 196 year_cub= -2744 stat3w30d= 2.653333 hostleva= 1 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.5479898 demb= 0 defensepact= 0 s3un4608i= -0.3619048 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 221801
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -12 year_sq= 144 year_cub= -1728 stat3w30d= 1.451613 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.5483676 demb= 0 defensepact= 0 s3un4608i= -0.34375 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 221901
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -13 year_sq= 169 year_cub= -2197 stat3w30d= 0.9103774 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 1 revregime= 0 revpolicy= 0 cincperc= 0.5434619 demb= 0 defensepact= 0 s3un4608i= -0.4393939 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 222001
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -11 year_sq= 121 year_cub= -1331 stat3w30d= 0.0777778 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.5478964 demb= 0 defensepact= 0 s3un4608i= -0.2859195 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 222101
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -5 year_sq= 25 year_cub= -125 stat3w30d= 0.8823529 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.5098097 demb= 0 defensepact= 0 s3un4608i= -0.4328358 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 222201
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 2 year_sq= 4 year_cub= 8 stat3w30d= 1.96875 hostleva= 4 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.4445501 demb= 0 defensepact= 0 s3un4608i= 0 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 222301
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 3 year_sq= 9 year_cub= 27 stat3w30d= 1.6 hostleva= 3 hostlevb= 2 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.4450599 demb= 0 defensepact= 0 s3un4608i= -0.0576923 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 222401
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 4 year_sq= 16 year_cub= 64 stat3w30d= 0.65625 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.4455901 demb= 0 defensepact= 0 s3un4608i= -0.2123288 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 222501
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 4 year_sq= 16 year_cub= 64 stat3w30d= 0.7314815 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9794126 demb= 0 defensepact= 0 s3un4608i= -0.2689655 rus= 0 nkr= 0 chn= 0 cub= 1 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 222502
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 4 year_sq= 16 year_cub= 64 stat3w30d= 1.901786 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.4455901 demb= 0 defensepact= 0 s3un4608i= -0.2123288 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 222601
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 5 year_sq= 25 year_cub= 125 stat3w30d= 7.621622 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.4364956 demb= 0 defensepact= 0 s3un4608i= -0.3786408 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 222701
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 5 year_sq= 25 year_cub= 125 stat3w30d= 10.29032 hostleva= 2 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.4364956 demb= 0 defensepact= 0 s3un4608i= -0.3786408 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 222801
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 6 year_sq= 36 year_cub= 216 stat3w30d= 0.3939394 hostleva= 4 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.4441466 demb= 0 defensepact= 0 s3un4608i= -0.443609 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 222901
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 7 year_sq= 49 year_cub= 343 stat3w30d= 1.469388 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 1 revregime= 0 revpolicy= 0 cincperc= 0.426029 demb= 0 defensepact= 0 s3un4608i= -0.425 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 223001
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 9 year_sq= 81 year_cub= 729 stat3w30d= 1.684211 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.4433683 demb= 0 defensepact= 0 s3un4608i= -0.5231788 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 223101
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 9 year_sq= 81 year_cub= 729 stat3w30d= 2.851675 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.4433683 demb= 0 defensepact= 0 s3un4608i= -0.5231788 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 223201
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 10 year_sq= 100 year_cub= 1000 stat3w30d= 1.752525 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.4387804 demb= 0 defensepact= 0 s3un4608i= -0.4834437 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 223301
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 11 year_sq= 121 year_cub= 1331 stat3w30d= 5.032258 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.4383736 demb= 0 defensepact= 0 s3un4608i= -0.4666667 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 224401
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -20 year_sq= 400 year_cub= -8000 stat3w30d= 0.0095785 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 1 revregime= 0 revpolicy= 0 cincperc= 0.9849293 demb= 0 defensepact= 0 s3un4608i= -0.6577495 rus= 0 nkr= 1 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 233501
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 1 year_sq= 1 year_cub= 1 stat3w30d= 0.2972973 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9779028 demb= 1 defensepact= 0 s3un4608i= 0.5652174 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 234701
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 9 year_sq= 81 year_cub= 729 stat3w30d= 0.9743888 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9941519 demb= 0 defensepact= 1 s3un4608i= -0.5933333 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 235301
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 12 year_sq= 144 year_cub= 1728 stat3w30d= 2.046341 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9942569 demb= 0 defensepact= 1 s3un4608i= -0.5144928 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 255901
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 10 year_sq= 100 year_cub= 1000 stat3w30d= 0 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9374433 demb= 0 defensepact= 0 s3un4608i= -0.4966888 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 257801
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 11 year_sq= 121 year_cub= 1331 stat3w30d= 0.125 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9388648 demb= 0 defensepact= 0 s3un4608i= -0.556338 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 1) predict(outcome(3))
* dymidnum== 260801
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -9 year_sq= 81 year_cub= -729 stat3w30d= 0 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9985061 demb= 0 defensepact= 0 s3un4608i= -0.2037037 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 273901
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 12 year_sq= 144 year_cub= 1728 stat3w30d= 0.09375 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9257776 demb= 0 defensepact= 0 s3un4608i= -0.5072464 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 1 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 274001
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 12 year_sq= 144 year_cub= 1728 stat3w30d= 0.3935018 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9346946 demb= 0 defensepact= 0 s3un4608i= -0.556391 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 1) predict(outcome(3))
* dymidnum== 274101
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 12 year_sq= 144 year_cub= 1728 stat3w30d= 0.004386 hostleva= 3 hostlevb= 4 sanctions_ties= 1 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.997792 demb= 0 defensepact= 1 s3un4608i= -0.4264706 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 274201
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 12 year_sq= 144 year_cub= 1728 stat3w30d= 0.3225806 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.9749299 demb= 0 defensepact= 0 s3un4608i= -0.5693431 rus= 0 nkr= 0 chn= 0 cub= 1 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 277401
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 13 year_sq= 169 year_cub= 2197 stat3w30d= 0.2258064 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9246184 demb= 0 defensepact= 0 s3un4608i= -0.5639098 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 1 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 277501
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 14 year_sq= 196 year_cub= 2744 stat3w30d= 0 hostleva= 4 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9882602 demb= 0 defensepact= 0 s3un4608i= -0.5701754 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 1 irn= 0) predict(outcome(3))
* dymidnum== 283401
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 13 year_sq= 169 year_cub= 2197 stat3w30d= 0.2258064 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9228977 demb= 0 defensepact= 0 s3un4608i= -0.5846154 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 1) predict(outcome(3))
* dymidnum== 284301
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -19 year_sq= 361 year_cub= -6859 stat3w30d= 0 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.980395 demb= 0 defensepact= 0 s3un4608i= 0.244898 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 284501
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -18 year_sq= 324 year_cub= -5832 stat3w30d= 0 hostleva= 2 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9918408 demb= 0 defensepact= 1 s3un4608i= 0.7307692 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 284901
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -18 year_sq= 324 year_cub= -5832 stat3w30d= 0 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9608352 demb= 0 defensepact= 0 s3un4608i= -0.1923077 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 285401
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -17 year_sq= 289 year_cub= -4913 stat3w30d= 0 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9603318 demb= 0 defensepact= 0 s3un4608i= -0.2513433 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 285701
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -17 year_sq= 289 year_cub= -4913 stat3w30d= 0 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9978776 demb= 0 defensepact= 0 s3un4608i= -0.1935484 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 286701
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -16 year_sq= 256 year_cub= -4096 stat3w30d= 0 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9977275 demb= 0 defensepact= 1 s3un4608i= 0.7678571 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 287001
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -16 year_sq= 256 year_cub= -4096 stat3w30d= 0 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9931251 demb= 1 defensepact= 0 s3un4608i= -0.1457938 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 287601
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -15 year_sq= 225 year_cub= -3375 stat3w30d= 0 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9834244 demb= 1 defensepact= 0 s3un4608i= 0.5 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 289901
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -12 year_sq= 144 year_cub= -1728 stat3w30d= 1.516129 hostleva= 1 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.5483676 demb= 0 defensepact= 0 s3un4608i= -0.34375 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 290101
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -11 year_sq= 121 year_cub= -1331 stat3w30d= 0.2580645 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.5478964 demb= 0 defensepact= 0 s3un4608i= -0.2859195 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 290601
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -11 year_sq= 121 year_cub= -1331 stat3w30d= 0 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9711821 demb= 0 defensepact= 0 s3un4608i= -0.2204147 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 290901
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -11 year_sq= 121 year_cub= -1331 stat3w30d= 0.0958904 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.5478964 demb= 0 defensepact= 0 s3un4608i= -0.2859195 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 291001
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -10 year_sq= 100 year_cub= -1000 stat3w30d= 0.3548387 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.5505238 demb= 0 defensepact= 0 s3un4608i= -0.1904762 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 291601
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -10 year_sq= 100 year_cub= -1000 stat3w30d= 0 hostleva= 2 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9745435 demb= 0 defensepact= 0 s3un4608i= -0.6577495 rus= 0 nkr= 1 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 292101
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -9 year_sq= 81 year_cub= -729 stat3w30d= 0.0645161 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.5564729 demb= 0 defensepact= 0 s3un4608i= -0.2777778 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 292401
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -7 year_sq= 49 year_cub= -343 stat3w30d= 0 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9697536 demb= 0 defensepact= 0 s3un4608i= -0.2115385 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 292801
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -7 year_sq= 49 year_cub= -343 stat3w30d= 0.6060606 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.5453855 demb= 0 defensepact= 0 s3un4608i= -0.3846154 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 292901
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -9 year_sq= 81 year_cub= -729 stat3w30d= 0.082716 hostleva= 4 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.6555259 demb= 0 defensepact= 0 s3un4608i= -0.4028755 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 293001
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -8 year_sq= 64 year_cub= -512 stat3w30d= 0.0526316 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.5556993 demb= 0 defensepact= 0 s3un4608i= -0.3272727 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 293101
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -8 year_sq= 64 year_cub= -512 stat3w30d= 0.0645161 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.5556993 demb= 0 defensepact= 0 s3un4608i= -0.3272727 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 293401
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -8 year_sq= 64 year_cub= -512 stat3w30d= 0.0784314 hostleva= 4 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.5556993 demb= 0 defensepact= 0 s3un4608i= -0.3272727 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 293601
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -6 year_sq= 36 year_cub= -216 stat3w30d= 0.0434783 hostleva= 4 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.6497554 demb= 0 defensepact= 0 s3un4608i= -0.4028755 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 294101
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -6 year_sq= 36 year_cub= -216 stat3w30d= 0.625 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.5382954 demb= 0 defensepact= 0 s3un4608i= -0.1162791 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 294102
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -6 year_sq= 36 year_cub= -216 stat3w30d= 0.3953488 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9736338 demb= 0 defensepact= 0 s3un4608i= -0.6577495 rus= 0 nkr= 1 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 294301
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -4 year_sq= 16 year_cub= -64 stat3w30d= 0 hostleva= 2 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9869347 demb= 0 defensepact= 0 s3un4608i= 0.0243902 rus= 0 nkr= 0 chn= 0 cub= 1 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 294601
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -4 year_sq= 16 year_cub= -64 stat3w30d= 0.0245399 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9869347 demb= 0 defensepact= 0 s3un4608i= 0.0243902 rus= 0 nkr= 0 chn= 0 cub= 1 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 294701
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -4 year_sq= 16 year_cub= -64 stat3w30d= 0.0508475 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.5991066 demb= 0 defensepact= 0 s3un4608i= 0.02 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 294801
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -3 year_sq= 9 year_cub= -27 stat3w30d= 0 hostleva= 4 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.5931975 demb= 0 defensepact= 0 s3un4608i= -0.4028755 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 294901
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -3 year_sq= 9 year_cub= -27 stat3w30d= 0.2222222 hostleva= 4 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.4864592 demb= 0 defensepact= 0 s3un4608i= 0.1037736 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 295001
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -2 year_sq= 4 year_cub= -8 stat3w30d= 0 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9938164 demb= 0 defensepact= 0 s3un4608i= -0.0879121 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 1 irn= 0) predict(outcome(3))
* dymidnum== 295101
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -1 year_sq= 1 year_cub= -1 stat3w30d= 0 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9862389 demb= 0 defensepact= 0 s3un4608i= -0.04 rus= 0 nkr= 0 chn= 0 cub= 1 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 295201
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -1 year_sq= 1 year_cub= -1 stat3w30d= 0.0645161 hostleva= 4 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9232441 demb= 1 defensepact= 1 s3un4608i= 0.5263158 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 295301
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 0 year_sq= 0 year_cub= 0 stat3w30d= 0.1290323 hostleva= 4 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9195915 demb= 1 defensepact= 1 s3un4608i= 0.5142857 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 295401
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 0 year_sq= 0 year_cub= 0 stat3w30d= 0 hostleva= 4 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9860195 demb= 0 defensepact= 0 s3un4608i= -0.057971 rus= 0 nkr= 0 chn= 0 cub= 1 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 295701
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 1 year_sq= 1 year_cub= 1 stat3w30d= 2.78125 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9979656 demb= 0 defensepact= 1 s3un4608i= -0.1392405 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 295801
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 1 year_sq= 1 year_cub= 1 stat3w30d= 0.2580645 hostleva= 4 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9838983 demb= 0 defensepact= 0 s3un4608i= -0.175 rus= 0 nkr= 0 chn= 0 cub= 1 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 296001
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 1 year_sq= 1 year_cub= 1 stat3w30d= 0.0322581 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9548209 demb= 0 defensepact= 0 s3un4608i= -0.6577495 rus= 0 nkr= 1 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 296201
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 2 year_sq= 4 year_cub= 8 stat3w30d= 0.03125 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9807217 demb= 0 defensepact= 0 s3un4608i= 0.0631579 rus= 0 nkr= 0 chn= 0 cub= 1 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 296701
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 4 year_sq= 16 year_cub= 64 stat3w30d= 0 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9774418 demb= 0 defensepact= 1 s3un4608i= -0.0979021 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 296801
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 4 year_sq= 16 year_cub= 64 stat3w30d= 0.0294118 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9171979 demb= 1 defensepact= 1 s3un4608i= 0.6164383 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 297101
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 6 year_sq= 36 year_cub= 216 stat3w30d= 0 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9427903 demb= 0 defensepact= 0 s3un4608i= -0.6577495 rus= 0 nkr= 1 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 297201
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 6 year_sq= 36 year_cub= 216 stat3w30d= 0.0454545 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9790441 demb= 0 defensepact= 0 s3un4608i= -0.5 rus= 0 nkr= 0 chn= 0 cub= 1 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 297701
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 7 year_sq= 49 year_cub= 343 stat3w30d= 0.1935484 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.9956588 demb= 0 defensepact= 1 s3un4608i= -0.527027 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 297801
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 7 year_sq= 49 year_cub= 343 stat3w30d= 0.0967742 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9853611 demb= 0 defensepact= 0 s3un4608i= -0.5666667 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 1 irn= 0) predict(outcome(3))
* dymidnum== 297901
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 7 year_sq= 49 year_cub= 343 stat3w30d= 0 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9370917 demb= 0 defensepact= 0 s3un4608i= -0.6577495 rus= 0 nkr= 1 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 298101
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 8 year_sq= 64 year_cub= 512 stat3w30d= 0.0645161 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9773921 demb= 0 defensepact= 0 s3un4608i= -0.5337838 rus= 0 nkr= 0 chn= 0 cub= 1 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 298201
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 7 year_sq= 49 year_cub= 343 stat3w30d= 2.096774 hostleva= 1 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.426029 demb= 0 defensepact= 0 s3un4608i= -0.425 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 302001
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 5 year_sq= 25 year_cub= 125 stat3w30d= 2.252632 hostleva= 4 hostlevb= 4 sanctions_ties= 1 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.942982 demb= 0 defensepact= 0 s3un4608i= -0.2526316 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 1) predict(outcome(3))
* dymidnum== 302101
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 4 year_sq= 16 year_cub= 64 stat3w30d= 0 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9843176 demb= 0 defensepact= 0 s3un4608i= -0.234375 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 1 irn= 0) predict(outcome(3))
* dymidnum== 305101
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 9 year_sq= 81 year_cub= 729 stat3w30d= 0.1290323 hostleva= 2 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.9822266 demb= 0 defensepact= 0 s3un4608i= -0.6575342 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 1 irn= 0) predict(outcome(3))
* dymidnum== 305801
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 8 year_sq= 64 year_cub= 512 stat3w30d= 0.0789474 hostleva= 4 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.9773921 demb= 0 defensepact= 0 s3un4608i= -0.5337838 rus= 0 nkr= 0 chn= 0 cub= 1 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 305802
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 8 year_sq= 64 year_cub= 512 stat3w30d= 0.5952381 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.9999242 demb= 0 defensepact= 1 s3un4608i= -0.5 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 306201
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 8 year_sq= 64 year_cub= 512 stat3w30d= 0.4586777 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9700375 demb= 0 defensepact= 0 s3un4608i= -0.5608108 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 306501
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 8 year_sq= 64 year_cub= 512 stat3w30d= 0.075 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9838408 demb= 0 defensepact= 0 s3un4608i= -0.5673759 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 1 irn= 0) predict(outcome(3))
* dymidnum== 307101
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 8 year_sq= 64 year_cub= 512 stat3w30d= 0.0165746 hostleva= 4 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9283013 demb= 0 defensepact= 0 s3un4608i= -0.5323741 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 1) predict(outcome(3))
* dymidnum== 307201
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 8 year_sq= 64 year_cub= 512 stat3w30d= 0.1470588 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9838408 demb= 0 defensepact= 0 s3un4608i= -0.5673759 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 1 irn= 0) predict(outcome(3))
* dymidnum== 308801
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 7 year_sq= 49 year_cub= 343 stat3w30d= 0 hostleva= 1 hostlevb= 2 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9853611 demb= 0 defensepact= 0 s3un4608i= -0.5666667 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 1 irn= 0) predict(outcome(3))
* dymidnum== 309801
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 6 year_sq= 36 year_cub= 216 stat3w30d= 0.0344828 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.9905521 demb= 0 defensepact= 0 s3un4608i= -0.4754098 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 1 irn= 0) predict(outcome(3))
* dymidnum== 309901
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 6 year_sq= 36 year_cub= 216 stat3w30d= 0.1470588 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9905521 demb= 0 defensepact= 0 s3un4608i= -0.4754098 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 1 irn= 0) predict(outcome(3))
* dymidnum== 310501
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 5 year_sq= 25 year_cub= 125 stat3w30d= 0.3135593 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9916193 demb= 1 defensepact= 1 s3un4608i= -0.1165049 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 320901
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -21 year_sq= 441 year_cub= -9261 stat3w30d= 0 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9941041 demb= 1 defensepact= 0 s3un4608i= -0.1457938 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 322201
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -19 year_sq= 361 year_cub= -6859 stat3w30d= 0 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9763142 demb= 0 defensepact= 1 s3un4608i= 0.8979592 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 324201
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -20 year_sq= 400 year_cub= -8000 stat3w30d= 0 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9972839 demb= 0 defensepact= 1 s3un4608i= 0.5405405 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 324301
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -20 year_sq= 400 year_cub= -8000 stat3w30d= 0 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9942563 demb= 0 defensepact= 1 s3un4608i= 0.6216216 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 324401
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= -13 year_sq= 169 year_cub= -2197 stat3w30d= 0 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9909053 demb= 0 defensepact= 1 s3un4608i= 0.7333333 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 336101
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -13 year_sq= 169 year_cub= -2197 stat3w30d= 0.4193548 hostleva= 3 hostlevb= 2 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.5434619 demb= 0 defensepact= 0 s3un4608i= -0.4393939 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 336102
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -13 year_sq= 169 year_cub= -2197 stat3w30d= 0.0645161 hostleva= 3 hostlevb= 2 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.6695303 demb= 0 defensepact= 0 s3un4608i= -0.4028755 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 336103
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= -13 year_sq= 169 year_cub= -2197 stat3w30d= 0.0338983 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.9818648 demb= 0 defensepact= 0 s3un4608i= -0.5474283 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 354101
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 9 year_sq= 81 year_cub= 729 stat3w30d= 0.3137255 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9186934 demb= 0 defensepact= 0 s3un4608i= -0.5815603 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 1) predict(outcome(3))
* dymidnum== 355001
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 17 year_sq= 289 year_cub= 4913 stat3w30d= 0.3548387 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9779482 demb= 0 defensepact= 1 s3un4608i= -0.3378378 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 355101
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 19 year_sq= 361 year_cub= 6859 stat3w30d= 0.8477707 hostleva= 4 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9833084 demb= 0 defensepact= 0 s3un4608i= -0.1939428 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 355201
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 18 year_sq= 324 year_cub= 5832 stat3w30d= 0.5504587 hostleva= 4 hostlevb= 4 sanctions_ties= 1 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9617583 demb= 0 defensepact= 0 s3un4608i= -0.4912281 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 1 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 356801
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 18 year_sq= 324 year_cub= 5832 stat3w30d= 1.5 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 1 revregime= 0 revpolicy= 0 cincperc= 0.9617583 demb= 0 defensepact= 0 s3un4608i= -0.4912281 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 1 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 361301
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 7 year_sq= 49 year_cub= 343 stat3w30d= 0 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9970616 demb= 0 defensepact= 0 s3un4608i= -0.5686275 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 362001
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 10 year_sq= 100 year_cub= 1000 stat3w30d= 0 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 1 revregime= 0 revpolicy= 0 cincperc= 0.9880429 demb= 0 defensepact= 0 s3un4608i= -0.5664335 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 1 irn= 0) predict(outcome(3))
* dymidnum== 362501
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 11 year_sq= 121 year_cub= 1331 stat3w30d= 0.1543624 hostleva= 2 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9388648 demb= 0 defensepact= 0 s3un4608i= -0.556338 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 1) predict(outcome(3))
* dymidnum== 363401
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 8 year_sq= 64 year_cub= 512 stat3w30d= 0.1320755 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.9838408 demb= 0 defensepact= 0 s3un4608i= -0.5673759 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 1 irn= 0) predict(outcome(3))
* dymidnum== 363601
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 11 year_sq= 121 year_cub= 1331 stat3w30d= 1.528455 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9876705 demb= 0 defensepact= 0 s3un4608i= -0.6068966 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 1 irn= 0) predict(outcome(3))
* dymidnum== 363701
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 11 year_sq= 121 year_cub= 1331 stat3w30d= 1.032258 hostleva= 1 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.4383736 demb= 0 defensepact= 0 s3un4608i= -0.4666667 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 390001
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 14 year_sq= 196 year_cub= 2744 stat3w30d= 0.0645161 hostleva= 1 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9221288 demb= 1 defensepact= 1 s3un4608i= 0.0347826 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 390101
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 14 year_sq= 196 year_cub= 2744 stat3w30d= 0.68 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.9979265 demb= 1 defensepact= 1 s3un4608i= -0.5140187 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 390301
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 14 year_sq= 196 year_cub= 2744 stat3w30d= 0 hostleva= 2 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9295208 demb= 0 defensepact= 0 s3un4608i= -0.5714286 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 1) predict(outcome(3))
* dymidnum== 395001
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 15 year_sq= 225 year_cub= 3375 stat3w30d= 0.0794702 hostleva= 4 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9778048 demb= 0 defensepact= 0 s3un4608i= -0.5952381 rus= 0 nkr= 0 chn= 0 cub= 1 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 395701
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 15 year_sq= 225 year_cub= 3375 stat3w30d= 0.1308017 hostleva= 2 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9922839 demb= 0 defensepact= 0 s3un4608i= -0.5243902 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 395702
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 15 year_sq= 225 year_cub= 3375 stat3w30d= 11.77075 hostleva= 5 hostlevb= 5 sanctions_ties= 1 revterritory= 1 revregime= 0 revpolicy= 0 cincperc= 0.9174381 demb= 0 defensepact= 0 s3un4608i= -0.5595238 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 1 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 397201
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 16 year_sq= 256 year_cub= 4096 stat3w30d= 0.1290323 hostleva= 4 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.916431 demb= 1 defensepact= 1 s3un4608i= 0.1549296 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 397301
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 16 year_sq= 256 year_cub= 4096 stat3w30d= 0.0967742 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9286978 demb= 0 defensepact= 0 s3un4608i= -0.5606061 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 1) predict(outcome(3))
* dymidnum== 397401
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 16 year_sq= 256 year_cub= 4096 stat3w30d= 2.242236 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9425649 demb= 0 defensepact= 0 s3un4608i= -0.6197183 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 1 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 401601
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 19 year_sq= 361 year_cub= 6859 stat3w30d= 1.803714 hostleva= 4 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.9969766 demb= 1 defensepact= 1 s3un4608i= -0.1692308 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 402101
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 18 year_sq= 324 year_cub= 5832 stat3w30d= 0.2115385 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9209583 demb= 0 defensepact= 0 s3un4608i= -0.5762712 rus= 0 nkr= 1 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 402201
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 19 year_sq= 361 year_cub= 6859 stat3w30d= 0.8117048 hostleva= 3 hostlevb= 3 sanctions_ties= 1 revterritory= 1 revregime= 0 revpolicy= 0 cincperc= 0.9252269 demb= 0 defensepact= 0 s3un4608i= -0.4915254 rus= 0 nkr= 1 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 404601
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 19 year_sq= 361 year_cub= 6859 stat3w30d= 4.255814 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 1 revregime= 0 revpolicy= 0 cincperc= 0.9833084 demb= 0 defensepact= 0 s3un4608i= -0.1939428 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 406401
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 21 year_sq= 441 year_cub= 9261 stat3w30d= 0.0992366 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 1 revregime= 0 revpolicy= 0 cincperc= 0.4986025 demb= 0 defensepact= 0 s3un4608i= -0.3421053 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 406501
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 19 year_sq= 361 year_cub= 6859 stat3w30d= 0.02 hostleva= 1 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.5266865 demb= 0 defensepact= 0 s3un4608i= -0.3333333 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 408701
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 22 year_sq= 484 year_cub= 10648 stat3w30d= 0.1624185 hostleva= 3 hostlevb= 4 sanctions_ties= 0 revterritory= 1 revregime= 0 revpolicy= 0 cincperc= 0.9273375 demb= 0 defensepact= 0 s3un4608i= -0.6037736 rus= 0 nkr= 1 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 408801
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 24 year_sq= 576 year_cub= 13824 stat3w30d= 1.255738 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.4867421 demb= 0 defensepact= 0 s3un4608i= -0.4411765 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 412501
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 24 year_sq= 576 year_cub= 13824 stat3w30d= 0.047619 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9357262 demb= 0 defensepact= 0 s3un4608i= -0.6666667 rus= 0 nkr= 1 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 413701
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 23 year_sq= 529 year_cub= 12167 stat3w30d= 3.414747 hostleva= 4 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9845497 demb= 0 defensepact= 0 s3un4608i= -0.1939428 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 417401
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 22 year_sq= 484 year_cub= 10648 stat3w30d= 0.2883721 hostleva= 4 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.7212901 demb= 0 defensepact= 0 s3un4608i= -0.0285714 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 418301
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 22 year_sq= 484 year_cub= 10648 stat3w30d= 0.2352941 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9233102 demb= 1 defensepact= 1 s3un4608i= 0.1714286 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 418601
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 25 year_sq= 625 year_cub= 15625 stat3w30d= 0.1643836 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9862894 demb= 1 defensepact= 0 s3un4608i= -0.1875 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 419001
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 21 year_sq= 441 year_cub= 9261 stat3w30d= 0.0333333 hostleva= 2 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9712683 demb= 0 defensepact= 0 s3un4608i= -0.4444444 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 419601
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 21 year_sq= 441 year_cub= 9261 stat3w30d= 0.1612903 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9888993 demb= 0 defensepact= 0 s3un4608i= -0.4929577 rus= 0 nkr= 0 chn= 0 cub= 1 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 419701
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 25 year_sq= 625 year_cub= 15625 stat3w30d= 0.5454546 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.7426987 demb= 0 defensepact= 0 s3un4608i= -0.1818182 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 421301
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 25 year_sq= 625 year_cub= 15625 stat3w30d= 0.2521739 hostleva= 4 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.7426987 demb= 0 defensepact= 0 s3un4608i= -0.1818182 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 421601
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 22 year_sq= 484 year_cub= 10648 stat3w30d= 0 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9177598 demb= 0 defensepact= 0 s3un4608i= -0.3880597 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 1) predict(outcome(3))
* dymidnum== 421701
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 23 year_sq= 529 year_cub= 12167 stat3w30d= 1.387097 hostleva= 4 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9839257 demb= 0 defensepact= 0 s3un4608i= -0.4193548 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 421801
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 25 year_sq= 625 year_cub= 15625 stat3w30d= 0.0967742 hostleva= 1 hostlevb= 2 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9334546 demb= 0 defensepact= 0 s3un4608i= -0.6666667 rus= 0 nkr= 1 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 422001
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 25 year_sq= 625 year_cub= 15625 stat3w30d= 0.5 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.7426987 demb= 0 defensepact= 0 s3un4608i= -0.1818182 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 422701
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 23 year_sq= 529 year_cub= 12167 stat3w30d= 1.387097 hostleva= 4 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9916295 demb= 0 defensepact= 0 s3un4608i= -0.3333333 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 425401
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 23 year_sq= 529 year_cub= 12167 stat3w30d= 0.0165289 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9987422 demb= 0 defensepact= 0 s3un4608i= 0.0478465 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 426101
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 25 year_sq= 625 year_cub= 15625 stat3w30d= 0 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9693967 demb= 1 defensepact= 1 s3un4608i= -0.358209 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 426901
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 20 year_sq= 400 year_cub= 8000 stat3w30d= 0.6831896 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 1 revregime= 0 revpolicy= 0 cincperc= 0.9584466 demb= 0 defensepact= 0 s3un4608i= -0.1973089 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 1 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 427001
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 19 year_sq= 361 year_cub= 6859 stat3w30d= 0.6129032 hostleva= 4 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.958767 demb= 0 defensepact= 0 s3un4608i= -0.3606557 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 1 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 427101
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 21 year_sq= 441 year_cub= 9261 stat3w30d= 1.536083 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9576172 demb= 0 defensepact= 0 s3un4608i= -0.1973089 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 1 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 427301
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 25 year_sq= 625 year_cub= 15625 stat3w30d= 1.734981 hostleva= 5 hostlevb= 5 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9596501 demb= 0 defensepact= 0 s3un4608i= -0.1973089 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 1 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 428001
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 26 year_sq= 676 year_cub= 17576 stat3w30d= 0.7419355 hostleva= 3 hostlevb= 4 sanctions_ties= 1 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.4725055 demb= 0 defensepact= 0 s3un4608i= -0.5074627 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 428101
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 26 year_sq= 676 year_cub= 17576 stat3w30d= 0.4827586 hostleva= 3 hostlevb= 1 sanctions_ties= 1 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.4725055 demb= 0 defensepact= 0 s3un4608i= -0.5074627 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 428301
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 26 year_sq= 676 year_cub= 17576 stat3w30d= 5.032609 hostleva= 5 hostlevb= 5 sanctions_ties= 0 revterritory= 0 revregime= 1 revpolicy= 0 cincperc= 0.9915357 demb= 0 defensepact= 0 s3un4608i= -0.5526316 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 429801
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 25 year_sq= 625 year_cub= 15625 stat3w30d= 1.058824 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9862894 demb= 1 defensepact= 0 s3un4608i= -0.1875 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 429901
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 18 year_sq= 324 year_cub= 5832 stat3w30d= 0.969697 hostleva= 4 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9617583 demb= 0 defensepact= 0 s3un4608i= -0.4912281 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 1 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 433601
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 26 year_sq= 676 year_cub= 17576 stat3w30d= 0.7741935 hostleva= 1 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.4725055 demb= 0 defensepact= 0 s3un4608i= -0.5074627 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 434201
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 24 year_sq= 576 year_cub= 13824 stat3w30d= 1.142857 hostleva= 1 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.7428356 demb= 0 defensepact= 0 s3un4608i= -0.1323529 rus= 1 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 434301
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 25 year_sq= 625 year_cub= 15625 stat3w30d= 0.0285714 hostleva= 1 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9862894 demb= 1 defensepact= 0 s3un4608i= -0.1875 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 437101
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 29 year_sq= 841 year_cub= 24389 stat3w30d= 0 hostleva= 1 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9922591 demb= 0 defensepact= 0 s3un4608i= -0.5072464 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 445001
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 27 year_sq= 729 year_cub= 19683 stat3w30d= 0.0322581 hostleva= 1 hostlevb= 3 sanctions_ties= 0 revterritory= 1 revregime= 0 revpolicy= 0 cincperc= 0.4615541 demb= 0 defensepact= 0 s3un4608i= -0.5555556 rus= 0 nkr= 0 chn= 1 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 445101
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 27 year_sq= 729 year_cub= 19683 stat3w30d= 0 hostleva= 4 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9267441 demb= 0 defensepact= 0 s3un4608i= -0.703125 rus= 0 nkr= 1 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 445501
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 28 year_sq= 784 year_cub= 21952 stat3w30d= 0.2734694 hostleva= 3 hostlevb= 3 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9265575 demb= 0 defensepact= 0 s3un4608i= -0.6769231 rus= 0 nkr= 1 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 446001
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 28 year_sq= 784 year_cub= 21952 stat3w30d= 0.0322581 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9098551 demb= 0 defensepact= 0 s3un4608i= -0.6216216 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 446501
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 29 year_sq= 841 year_cub= 24389 stat3w30d= 0.8285714 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9182267 demb= 0 defensepact= 0 s3un4608i= -0.7741935 rus= 0 nkr= 1 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 451201
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 28 year_sq= 784 year_cub= 21952 stat3w30d= 0.5 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9191019 demb= 0 defensepact= 0 s3un4608i= -0.6338028 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 1) predict(outcome(3))
* dymidnum== 451601
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 28 year_sq= 784 year_cub= 21952 stat3w30d= 0 hostleva= 4 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9108425 demb= 1 defensepact= 1 s3un4608i= -0.2361111 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 451801
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 29 year_sq= 841 year_cub= 24389 stat3w30d= 0 hostleva= 4 hostlevb= 4 sanctions_ties= 1 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9697707 demb= 0 defensepact= 0 s3un4608i= -0.7285714 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 451901
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 29 year_sq= 841 year_cub= 24389 stat3w30d= 1.677419 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 0 cincperc= 0.9198307 demb= 0 defensepact= 0 s3un4608i= -0.7142857 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 1) predict(outcome(3))
* dymidnum== 452401
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 29 year_sq= 841 year_cub= 24389 stat3w30d= 0.3554217 hostleva= 3 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9198307 demb= 0 defensepact= 0 s3un4608i= -0.7142857 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 1) predict(outcome(3))
* dymidnum== 452701
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 30 year_sq= 900 year_cub= 27000 stat3w30d= 0.3235294 hostleva= 4 hostlevb= 4 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9708248 demb= 0 defensepact= 0 s3un4608i= -0.7464789 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 455201
margins, dydx(stat3w30d) at(sideaa= 0 year_cen= 29 year_sq= 841 year_cub= 24389 stat3w30d= 0.5016575 hostleva= 4 hostlevb= 4 sanctions_ties= 1 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9138823 demb= 0 defensepact= 1 s3un4608i= -0.6478873 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))
* dymidnum== 456801
margins, dydx(stat3w30d) at(sideaa= 1 year_cen= 30 year_sq= 900 year_cub= 27000 stat3w30d= 0.4516129 hostleva= 4 hostlevb= 1 sanctions_ties= 0 revterritory= 0 revregime= 0 revpolicy= 1 cincperc= 0.9159293 demb= 0 defensepact= 1 s3un4608i= -0.6478873 rus= 0 nkr= 0 chn= 0 cub= 0 irq= 0 lib= 0 irn= 0) predict(outcome(3))


* Average marginal effects for table in appendix

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub, vce(robust)

margins, dydx(stat3w30d) at((mean) _all) predict(outcome(3)) level(90)

margins, dydx(stat3w30d) at((median) _all) predict(outcome(3)) level(90)

margins, dydx(stat3w30d) at((median) _all (p75) stat3w30d) predict(outcome(3)) level(90)

margins, dydx(stat3w30d) predict(outcome(3)) level(90)

oprobit ordoutcome stat3w30d cincperc demb year_cen year_sq year_cub sideaa hostleva hostlevb sanctions_ties s3un4608i defensepact revterritory revregime revpolicy rus nkr chn cub irq lib irn, vce(robust)

margins, dydx(stat3w30d) at((mean) _all) predict(outcome(3)) level(90)

margins, dydx(stat3w30d) at((median) _all) predict(outcome(3)) level(90)

margins, dydx(stat3w30d) at((median) _all (p75) stat3w30d) predict(outcome(3)) level(90)

margins, dydx(stat3w30d) predict(outcome(3)) level(90)

log close
