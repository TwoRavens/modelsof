clear
set more off
set mem 100m

*** this setup file uses MxFLS data from the 2005-06 round

*shell ren "iiia_mg1.dta" "iiia_mg1_2005.dta"
use iiia_mg1_2005, clear
recode mg30 (3=0)
recode mg31_1 (1 2 3=1) (4 5=0)
collapse (max) mg30 mg31_1, by(pid_link)
rename mg30 mig2005_p
rename mg31_1 docUS_p
sort pid_link
save mg2005, replace

*shell ren "iiia_mt1.dta" "iiia_mt1_2005.dta"
use iiia_mt1_2005, clear
recode mt19 (3=0)
recode mt20_1 (1 2 3=1) (4 5=0)
collapse (max) mt19 mt20_1, by(pid_link)
rename mt19 mig2005_t
rename mt20_1 docUS_t
sort pid_link
save mt2005, replace


