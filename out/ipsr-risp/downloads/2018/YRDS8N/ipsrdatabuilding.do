##Procedure to calculate dispersion within gender subsets in the Italian parliamentary parties ## Data for Fig. 3


use "data set IPSR 2017 versione 5.dta", clear

collapse (median) dim1_co dim2_co dim3_co if gender==1 & women>0, by(legislatura parties)
. rename dim1_co mmed1
. rename dim2_co mmed2
. rename dim3_co mmed3

save "Mmedgp.dta", replace

use "data set IPSR 2017 versione 5.dta", clear

collapse (median) dim1_co dim2_co dim3_co if gender==2 &  women>0, by(legislatura parties)

. rename dim1_co fmed1
. rename dim2_co fmed2
. rename dim3_co fmed3

save "Fmedgp.dta", replace

save "medgp.dta"
use "medgp.dta", clear

merge m:m legislatura parties using "Mmedgp.dta"
drop _merge
save "medgp2.dta"

merge m:m legislatura parties using "data set IPSR 2017 versione 5.dta"

generate euclmmed = ((dim1_co-mmed1)^2+(dim2_co-mmed2)^2)^0.5 if legislatura !=10 & legislatura !=13 & legislatura != 15
generate euclfmed = ((dim1_co-fmed1)^2+(dim2_co-fmed2)^2)^0.5 if legislatura !=10 & legislatura !=13 & legislatura != 15

generate euclmmed3 = ((dim1_co-mmed1)^2+(dim2_co-mmed2)^2+(dim3_co-mmed3)^2)^0.5 if legislatura ==10 | legislatura ==13 | legislatura == 15
generate euclfmed3 = ((dim1_co-fmed1)^2+(dim2_co-fmed2)^2+(dim3_co-fmed3)^2)^0.5 if legislatura ==10 | legislatura ==13 | legislatura == 15

by legislatura, sort : summarize euclmmed euclfmed euclmmed3 euclfmed3

collapse (mean) euclmmed euclfmed euclmmed3 euclfmed3, by(legislatura)
recode  euclmmed(.=0)
recode  euclfmed(.=0)
recode  euclmmed3(.=0)
recode  euclfmed3(.=0)
generate EUCLMMED= (euclmmed+euclmmed3)
generate EUCLFMED= (euclfmed+euclfmed3)
graph hbar (asis) EUCLFMED EUCLMMED , over(legislatura)



##Procedure to calculate dispersion within gender subsets in the Italian Parliament ## Data for Fig. 2

use "Mmedgp.dta", clear
. collapse (median) mmed1 mmed2 mmed3, by(legislatura)
. rename  mmed1 mall1
. rename  mmed2 mall2
. rename  mmed3 mall3

save "mall.dta", replace

use "Fmedgp.dta", clear
. collapse (median) fmed1 fmed2 fmed3, by(legislatura)
. rename  fmed1 fall1
. rename  fmed2 fall2
. rename  fmed3 fall3
save "fall.dta", replace
save "all.dta", replace
merge m:m legislatura using "mall.dta"
drop _merge

merge m:m legislatura using "Mmedgp.dta"
drop _merge
merge m:m legislatura using "Fmedgp.dta"
drop _merge
save "medall.dta"

generate euclmmedall = ((mmed1-mall1)^2+(mmed2-mall2)^2)^0.5 if legislatura !=10 & legislatura !=13 & legislatura != 15
generate euclfmedall = ((fmed1-fall1)^2+(fmed2-fall2)^2)^0.5 if legislatura !=10 & legislatura !=13 & legislatura != 15

generate euclmmedall3 = ((mmed1-mall1)^2+(mmed2-mall2)^2+(mmed3-mall3)^2)^0.5 if legislatura ==10 | legislatura ==13 | legislatura == 15
generate euclfmedall3 = ((fmed1-fall1)^2+(fmed2-fall2)^2+(fmed3-fall3)^2)^0.5 if legislatura ==10 | legislatura ==13 | legislatura == 15

by legislatura, sort : summarize euclmmedall euclfmedall euclmmedall3 euclfmedall3

collapse (mean) euclmmedall euclfmedall euclmmedall3 euclfmedall3, by(legislatura)
recode  euclmmedall(.=0)
recode  euclfmedall(.=0)
recode  euclmmedall3(.=0)
recode  euclfmedall3(.=0)
generate EUCLMMEDALL= (euclmmedall+euclmmedall3)
generate EUCLFMEDALL= (euclfmedall+euclfmedall3)
graph hbar (asis) EUCLFMEDALL EUCLMMEDALL , over(legislatura)



##Procedure to create Party dispersion by gender## Data for fig. 4

use "data set IPSR 2017 versione 5.dta", clear

by legislatura gender, sort : summarize partydispersion


collapse (mean) partydispersion if gender==1, by(legislatura)
rename partydispersion malepartydisp
label variable malepartydisp ""

save "malepartydisp.dta"

use "data set IPSR 2017 versione 5.dta", clear

collapse (mean) partydispersion if gender==2, by(legislatura)
rename partydispersion femalepartydisp
label variable femalepartydisp ""

. save "femalepartydisp.dta"

. merge m:m legislatura using "malepartydisp.dta"

. graph hbar (asis)  femalepartydisp malepartydisp, over(legislatura



##Creation of partydispersion (you should delete the existing one)##


use "data set IPSR 2017 versione 5.dta", clear

. drop partydispersion

. save "data set IPSR 2017 versione 6.dta"

. collapse (median) dim1_co dim2_co dim3_, by(legislatura parties)

. rename dim1_co pmed1
. rename dim2_co pmed2
. rename dim3_co pmed3

merge m:m legislatura parties using "C:\Users\Francesco\Dropbox\FrancescoLicia\Ricerca preferenze cosponsorship\nuova versione paper\data set IPSR 2017.dta"

generate euclpmed = ((dim1_co-pmed1)^2+(dim2_co-pmed2)^2)^0.5 if legislatura !=10 & legislatura !=13 & legislatura != 15

generate euclpmed3 = ((dim1_co-pmed1)^2+(dim2_co-pmed2)^2+(dim3_co-pmed3)^2)^0.5 if legislatura ==10 | legislatura ==13 | legislatura == 15

recode euclpmed (0=1000) (.=0)
. recode euclpmed3 (0=1000) (.=0)
gen partydispersion = ( euclpmed+ euclpmed3)
recode partydispersion (1000=0)



