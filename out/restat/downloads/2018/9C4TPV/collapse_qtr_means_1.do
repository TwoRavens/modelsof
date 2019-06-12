clear
use nsduh_compiled.dta
gen qtr_wgt=ANALWT_C/4
rename QUARTER quarter
sort year quarter
collapse (mean) heroin_30 pain_30 [aw=qtr_wgt], by(year quarter)
outsheet using qtr_means_heroin_pain.csv, comma replace



