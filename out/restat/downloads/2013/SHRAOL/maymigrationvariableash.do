/*Computing temporary and permanent migrant numbers after 5 quarters (check whether there is an Ashenfelter's dip). Migrants are those who migrate five quarters later, non-migrants are those who do not migrate: missing values for those who migrate in between*/
clear
capture log close
set matsize 800
set memory 900m
log using maymigrationvariableash.log, replace
use may403m, clear
drop _merge
sort personid
merge personid using may404m, keep(binmigr404p binmigr404t) unique nokeep
gen binmigrt4 = binmigr404t if binmigr403t == 0 & binmigr403p == 0
gen binmigrp4 = binmigr404p if binmigr403t == 0 & binmigr403p == 0
/*Create a dummy for individuals available after a year*/
gen fiveint = 1 if _merge==3
drop _merge
sort personid
merge personid using may304m, keep(binmigr304p binmigr304t) unique nokeep
gen binmigrt3 = binmigr304t if binmigr403t == 0 & binmigr403p == 0
gen binmigrp3 = binmigr304p if binmigr403t == 0 & binmigr403p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may204m, keep(binmigr204p binmigr204t) unique nokeep
gen binmigrt2 = binmigr204t if binmigr403t == 0 & binmigr403p == 0
gen binmigrp2 = binmigr204p if binmigr403t == 0 & binmigr403p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may104m, keep(binmigr104p binmigr104t) unique nokeep
replace fiveint = 0 if _merge==1
drop _merge
replace binmigrt4 = . if binmigr304t == 1
replace binmigrt4 = . if binmigr304p == 1
replace binmigrt4 = . if binmigr204t == 1
replace binmigrt4 = . if binmigr204p == 1
replace binmigrt4 = . if binmigr104t == 1
replace binmigrt4 = . if binmigr104p == 1
replace binmigrt3 = . if binmigr204t == 1
replace binmigrt3 = . if binmigr204p == 1
replace binmigrt3 = . if binmigr104t == 1
replace binmigrt3 = . if binmigr104p == 1
replace binmigrt2 = . if binmigr104t == 1
replace binmigrt2 = . if binmigr104p == 1
replace binmigrp4 = . if binmigr304t == 1
replace binmigrp4 = . if binmigr304p == 1
replace binmigrp4 = . if binmigr204t == 1
replace binmigrp4 = . if binmigr204p == 1
replace binmigrp4 = . if binmigr104t == 1
replace binmigrp4 = . if binmigr104p == 1
replace binmigrp3 = . if binmigr204t == 1
replace binmigrp3 = . if binmigr204p == 1
replace binmigrp3 = . if binmigr104t == 1
replace binmigrp3 = . if binmigr104p == 1
replace binmigrp2 = . if binmigr104t == 1
replace binmigrp2 = . if binmigr104p == 1
sort personid
save mayash403m, replace
use may303m, clear
drop _merge
sort personid
merge personid using may304m, keep(binmigr304p binmigr304t) unique nokeep
gen binmigrt4 = binmigr304t if binmigr303t == 0 & binmigr303p == 0
gen binmigrp4 = binmigr304p if binmigr303t == 0 & binmigr303p == 0
gen fiveint = 1 if _merge==3
drop _merge
sort personid
merge personid using may204m, keep(binmigr204p binmigr204t) unique nokeep
gen binmigrt3 = binmigr204t if binmigr303t == 0 & binmigr303p == 0
gen binmigrp3 = binmigr204p if binmigr303t == 0 & binmigr303p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may104m, keep(binmigr104p binmigr104t) unique nokeep
gen binmigrt2 = binmigr104t if binmigr303t == 0 & binmigr303p == 0
gen binmigrp2 = binmigr104p if binmigr303t == 0 & binmigr303p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may403m, keep(binmigr403p binmigr403t) unique nokeep
replace fiveint = 0 if _merge==1
drop _merge
replace binmigrt4 = . if binmigr204t == 1
replace binmigrt4 = . if binmigr204p == 1
replace binmigrt4 = . if binmigr104t == 1
replace binmigrt4 = . if binmigr104p == 1
replace binmigrt4 = . if binmigr403t == 1
replace binmigrt4 = . if binmigr403p == 1
replace binmigrt3 = . if binmigr104t == 1
replace binmigrt3 = . if binmigr104p == 1
replace binmigrt3 = . if binmigr403t == 1
replace binmigrt3 = . if binmigr403p == 1
replace binmigrt2 = . if binmigr403t == 1
replace binmigrt2 = . if binmigr403p == 1
replace binmigrp4 = . if binmigr204t == 1
replace binmigrp4 = . if binmigr204p == 1
replace binmigrp4 = . if binmigr104t == 1
replace binmigrp4 = . if binmigr104p == 1
replace binmigrp4 = . if binmigr403t == 1
replace binmigrp4 = . if binmigr403p == 1
replace binmigrp3 = . if binmigr104t == 1
replace binmigrp3 = . if binmigr104p == 1
replace binmigrp3 = . if binmigr403t == 1
replace binmigrp3 = . if binmigr403p == 1
replace binmigrp2 = . if binmigr403t == 1
replace binmigrp2 = . if binmigr403p == 1
sort personid
save mayash303m, replace
use may203m, clear
drop _merge
sort personid
merge personid using may204m, keep(binmigr204p binmigr204t) unique nokeep
gen binmigrt4 = binmigr204t if binmigr203t == 0 & binmigr203p == 0
gen binmigrp4 = binmigr204p if binmigr203t == 0 & binmigr203p == 0
gen fiveint = 1 if _merge==3
drop _merge
sort personid
merge personid using may104m, keep(binmigr104p binmigr104t) unique nokeep
gen binmigrt3 = binmigr104t if binmigr203t == 0 & binmigr203p == 0
gen binmigrp3 = binmigr104p if binmigr203t == 0 & binmigr203p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may403m, keep(binmigr403p binmigr403t) unique nokeep
gen binmigrt2 = binmigr403t if binmigr203t == 0 & binmigr203p == 0
gen binmigrp2 = binmigr403p if binmigr203t == 0 & binmigr203p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may303m, keep(binmigr303p binmigr303t) unique nokeep
replace fiveint = 0 if _merge==1
drop _merge
replace binmigrt4 = . if binmigr104t == 1
replace binmigrt4 = . if binmigr104p == 1
replace binmigrt4 = . if binmigr403t == 1
replace binmigrt4 = . if binmigr403p == 1
replace binmigrt4 = . if binmigr303t == 1
replace binmigrt4 = . if binmigr303p == 1
replace binmigrt3 = . if binmigr403t == 1
replace binmigrt3 = . if binmigr403p == 1
replace binmigrt3 = . if binmigr303t == 1
replace binmigrt3 = . if binmigr303p == 1
replace binmigrt2 = . if binmigr303t == 1
replace binmigrt2 = . if binmigr303p == 1
replace binmigrp4 = . if binmigr104t == 1
replace binmigrp4 = . if binmigr104p == 1
replace binmigrp4 = . if binmigr403t == 1
replace binmigrp4 = . if binmigr403p == 1
replace binmigrp4 = . if binmigr303t == 1
replace binmigrp4 = . if binmigr303p == 1
replace binmigrp3 = . if binmigr403t == 1
replace binmigrp3 = . if binmigr403p == 1
replace binmigrp3 = . if binmigr303t == 1
replace binmigrp3 = . if binmigr303p == 1
replace binmigrp2 = . if binmigr303t == 1
replace binmigrp2 = . if binmigr303p == 1
sort personid
save mayash203m, replace
use may103m, clear
drop _merge
sort personid
merge personid using may104m, keep(binmigr104p binmigr104t) unique nokeep
gen binmigrt4 = binmigr104t if binmigr103t == 0 & binmigr103p == 0
gen binmigrp4 = binmigr104p if binmigr103t == 0 & binmigr103p == 0
gen fiveint = 1 if _merge==3
drop _merge
sort personid
merge personid using may403m, keep(binmigr403p binmigr403t) unique nokeep
gen binmigrt3 = binmigr403t if binmigr103t == 0 & binmigr103p == 0
gen binmigrp3 = binmigr403p if binmigr103t == 0 & binmigr103p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may303m, keep(binmigr303p binmigr303t) unique nokeep
gen binmigrt2 = binmigr303t if binmigr103t == 0 & binmigr103p == 0
gen binmigrp2 = binmigr303p if binmigr103t == 0 & binmigr103p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may203m, keep(binmigr203p binmigr203t) unique nokeep
replace fiveint = 0 if _merge==1
drop _merge
replace binmigrt4 = . if binmigr403t == 1
replace binmigrt4 = . if binmigr403p == 1
replace binmigrt4 = . if binmigr303t == 1
replace binmigrt4 = . if binmigr303p == 1
replace binmigrt4 = . if binmigr203t == 1
replace binmigrt4 = . if binmigr203p == 1
replace binmigrt3 = . if binmigr303t == 1
replace binmigrt3 = . if binmigr303p == 1
replace binmigrt3 = . if binmigr203t == 1
replace binmigrt3 = . if binmigr203p == 1
replace binmigrt2 = . if binmigr203t == 1
replace binmigrt2 = . if binmigr203p == 1
replace binmigrp4 = . if binmigr403t == 1
replace binmigrp4 = . if binmigr403p == 1
replace binmigrp4 = . if binmigr303t == 1
replace binmigrp4 = . if binmigr303p == 1
replace binmigrp4 = . if binmigr203t == 1
replace binmigrp4 = . if binmigr203p == 1
replace binmigrp3 = . if binmigr303t == 1
replace binmigrp3 = . if binmigr303p == 1
replace binmigrp3 = . if binmigr203t == 1
replace binmigrp3 = . if binmigr203p == 1
replace binmigrp2 = . if binmigr203t == 1
replace binmigrp2 = . if binmigr203p == 1
sort personid
save mayash103m, replace
use may402m, clear
drop _merge
sort personid
merge personid using may403m, keep(binmigr403p binmigr403t) unique nokeep
gen binmigrt4 = binmigr403t if binmigr402t == 0 & binmigr402p == 0
gen binmigrp4 = binmigr403p if binmigr402t == 0 & binmigr402p == 0
gen fiveint = 1 if _merge==3
drop _merge
sort personid
merge personid using may303m, keep(binmigr303p binmigr303t) unique nokeep
gen binmigrt3 = binmigr303t if binmigr402t == 0 & binmigr402p == 0
gen binmigrp3 = binmigr303p if binmigr402t == 0 & binmigr402p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may203m, keep(binmigr203p binmigr203t) unique nokeep
gen binmigrt2 = binmigr203t if binmigr402t == 0 & binmigr402p == 0
gen binmigrp2 = binmigr203p if binmigr402t == 0 & binmigr402p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may103m, keep(binmigr103p binmigr103t) unique nokeep
replace fiveint = 0 if _merge==1
drop _merge
replace binmigrt4 = . if binmigr303t == 1
replace binmigrt4 = . if binmigr303p == 1
replace binmigrt4 = . if binmigr203t == 1
replace binmigrt4 = . if binmigr203p == 1
replace binmigrt4 = . if binmigr103t == 1
replace binmigrt4 = . if binmigr103p == 1
replace binmigrt3 = . if binmigr203t == 1
replace binmigrt3 = . if binmigr203p == 1
replace binmigrt3 = . if binmigr103t == 1
replace binmigrt3 = . if binmigr103p == 1
replace binmigrt2 = . if binmigr103t == 1
replace binmigrt2 = . if binmigr103p == 1
replace binmigrp4 = . if binmigr303t == 1
replace binmigrp4 = . if binmigr303p == 1
replace binmigrp4 = . if binmigr203t == 1
replace binmigrp4 = . if binmigr203p == 1
replace binmigrp4 = . if binmigr103t == 1
replace binmigrp4 = . if binmigr103p == 1
replace binmigrp3 = . if binmigr203t == 1
replace binmigrp3 = . if binmigr203p == 1
replace binmigrp3 = . if binmigr103t == 1
replace binmigrp3 = . if binmigr103p == 1
replace binmigrp2 = . if binmigr103t == 1
replace binmigrp2 = . if binmigr103p == 1
sort personid
save mayash402m, replace
use may302m, clear
drop _merge
sort personid
merge personid using may303m, keep(binmigr303p binmigr303t) unique nokeep
gen binmigrt4 = binmigr303t if binmigr302t == 0 & binmigr302p == 0
gen binmigrp4 = binmigr303p if binmigr302t == 0 & binmigr302p == 0
gen fiveint = 1 if _merge==3
drop _merge
sort personid
merge personid using may203m, keep(binmigr203p binmigr203t) unique nokeep
gen binmigrt3 = binmigr203t if binmigr302t == 0 & binmigr302p == 0
gen binmigrp3 = binmigr203p if binmigr302t == 0 & binmigr302p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may103m, keep(binmigr103p binmigr103t) unique nokeep
gen binmigrt2 = binmigr103t if binmigr302t == 0 & binmigr302p == 0
gen binmigrp2 = binmigr103p if binmigr302t == 0 & binmigr302p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may402m, keep(binmigr402p binmigr402t) unique nokeep
replace fiveint = 0 if _merge==1
drop _merge
replace binmigrt4 = . if binmigr203t == 1
replace binmigrt4 = . if binmigr203p == 1
replace binmigrt4 = . if binmigr103t == 1
replace binmigrt4 = . if binmigr103p == 1
replace binmigrt4 = . if binmigr402t == 1
replace binmigrt4 = . if binmigr402p == 1
replace binmigrt3 = . if binmigr103t == 1
replace binmigrt3 = . if binmigr103p == 1
replace binmigrt3 = . if binmigr402t == 1
replace binmigrt3 = . if binmigr402p == 1
replace binmigrt2 = . if binmigr402t == 1
replace binmigrt2 = . if binmigr402p == 1
replace binmigrp4 = . if binmigr203t == 1
replace binmigrp4 = . if binmigr203p == 1
replace binmigrp4 = . if binmigr103t == 1
replace binmigrp4 = . if binmigr103p == 1
replace binmigrp4 = . if binmigr402t == 1
replace binmigrp4 = . if binmigr402p == 1
replace binmigrp3 = . if binmigr103t == 1
replace binmigrp3 = . if binmigr103p == 1
replace binmigrp3 = . if binmigr402t == 1
replace binmigrp3 = . if binmigr402p == 1
replace binmigrp2 = . if binmigr402t == 1
replace binmigrp2 = . if binmigr402p == 1
sort personid
save mayash302m, replace
use may202m, clear
drop _merge
sort personid
merge personid using may203m, keep(binmigr203p binmigr203t) unique nokeep
gen binmigrt4 = binmigr203t if binmigr202t == 0 & binmigr202p == 0
gen binmigrp4 = binmigr203p if binmigr202t == 0 & binmigr202p == 0
gen fiveint = 1 if _merge==3
drop _merge
sort personid
merge personid using may103m, keep(binmigr103p binmigr103t) unique nokeep
gen binmigrt3 = binmigr103t if binmigr202t == 0 & binmigr202p == 0
gen binmigrp3 = binmigr103p if binmigr202t == 0 & binmigr202p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may402m, keep(binmigr402p binmigr402t) unique nokeep
gen binmigrt2 = binmigr402t if binmigr202t == 0 & binmigr202p == 0
gen binmigrp2 = binmigr402p if binmigr202t == 0 & binmigr202p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may302m, keep(binmigr302p binmigr302t) unique nokeep
replace fiveint = 0 if _merge==1
drop _merge
replace binmigrt4 = . if binmigr103t == 1
replace binmigrt4 = . if binmigr103p == 1
replace binmigrt4 = . if binmigr402t == 1
replace binmigrt4 = . if binmigr402p == 1
replace binmigrt4 = . if binmigr302t == 1
replace binmigrt4 = . if binmigr302p == 1
replace binmigrt3 = . if binmigr402t == 1
replace binmigrt3 = . if binmigr402p == 1
replace binmigrt3 = . if binmigr302t == 1
replace binmigrt3 = . if binmigr302p == 1
replace binmigrt2 = . if binmigr302t == 1
replace binmigrt2 = . if binmigr302p == 1
replace binmigrp4 = . if binmigr103t == 1
replace binmigrp4 = . if binmigr103p == 1
replace binmigrp4 = . if binmigr402t == 1
replace binmigrp4 = . if binmigr402p == 1
replace binmigrp4 = . if binmigr302t == 1
replace binmigrp4 = . if binmigr302p == 1
replace binmigrp3 = . if binmigr402t == 1
replace binmigrp3 = . if binmigr402p == 1
replace binmigrp3 = . if binmigr302t == 1
replace binmigrp3 = . if binmigr302p == 1
replace binmigrp2 = . if binmigr302t == 1
replace binmigrp2 = . if binmigr302p == 1
sort personid
save mayash202m, replace
use may102m, clear
drop _merge
sort personid
merge personid using may103m, keep(binmigr103p binmigr103t) unique nokeep
gen binmigrt4 = binmigr103t if binmigr102t == 0 & binmigr102p == 0
gen binmigrp4 = binmigr103p if binmigr102t == 0 & binmigr102p == 0
gen fiveint = 1 if _merge==3
drop _merge
sort personid
merge personid using may402m, keep(binmigr402p binmigr402t) unique nokeep
gen binmigrt3 = binmigr402t if binmigr102t == 0 & binmigr102p == 0
gen binmigrp3 = binmigr402p if binmigr102t == 0 & binmigr102p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may302m, keep(binmigr302p binmigr302t) unique nokeep
gen binmigrt2 = binmigr302t if binmigr102t == 0 & binmigr102p == 0
gen binmigrp2 = binmigr302p if binmigr102t == 0 & binmigr102p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may202m, keep(binmigr202p binmigr202t) unique nokeep
replace fiveint = 0 if _merge==1
drop _merge
replace binmigrt4 = . if binmigr402t == 1
replace binmigrt4 = . if binmigr402p == 1
replace binmigrt4 = . if binmigr302t == 1
replace binmigrt4 = . if binmigr302p == 1
replace binmigrt4 = . if binmigr202t == 1
replace binmigrt4 = . if binmigr202p == 1
replace binmigrt3 = . if binmigr302t == 1
replace binmigrt3 = . if binmigr302p == 1
replace binmigrt3 = . if binmigr202t == 1
replace binmigrt3 = . if binmigr202p == 1
replace binmigrt2 = . if binmigr202t == 1
replace binmigrt2 = . if binmigr202p == 1
replace binmigrp4 = . if binmigr402t == 1
replace binmigrp4 = . if binmigr402p == 1
replace binmigrp4 = . if binmigr302t == 1
replace binmigrp4 = . if binmigr302p == 1
replace binmigrp4 = . if binmigr202t == 1
replace binmigrp4 = . if binmigr202p == 1
replace binmigrp3 = . if binmigr302t == 1
replace binmigrp3 = . if binmigr302p == 1
replace binmigrp3 = . if binmigr202t == 1
replace binmigrp3 = . if binmigr202p == 1
replace binmigrp2 = . if binmigr202t == 1
replace binmigrp2 = . if binmigr202p == 1
sort personid
save mayash102m, replace
use may401m, clear
drop _merge
sort personid
merge personid using may402m, keep(binmigr402p binmigr402t) unique nokeep
gen binmigrt4 = binmigr402t if binmigr401t == 0 & binmigr401p == 0
gen binmigrp4 = binmigr402p if binmigr401t == 0 & binmigr401p == 0
gen fiveint = 1 if _merge==3
drop _merge
sort personid
merge personid using may302m, keep(binmigr302p binmigr302t) unique nokeep
gen binmigrt3 = binmigr302t if binmigr401t == 0 & binmigr401p == 0
gen binmigrp3 = binmigr302p if binmigr401t == 0 & binmigr401p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may202m, keep(binmigr202p binmigr202t) unique nokeep
gen binmigrt2 = binmigr202t if binmigr401t == 0 & binmigr401p == 0
gen binmigrp2 = binmigr202p if binmigr401t == 0 & binmigr401p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may102m, keep(binmigr102p binmigr102t) unique nokeep
replace fiveint = 0 if _merge==1
drop _merge
replace binmigrt4 = . if binmigr302t == 1
replace binmigrt4 = . if binmigr302p == 1
replace binmigrt4 = . if binmigr202t == 1
replace binmigrt4 = . if binmigr202p == 1
replace binmigrt4 = . if binmigr102t == 1
replace binmigrt4 = . if binmigr102p == 1
replace binmigrt3 = . if binmigr202t == 1
replace binmigrt3 = . if binmigr202p == 1
replace binmigrt3 = . if binmigr102t == 1
replace binmigrt3 = . if binmigr102p == 1
replace binmigrt2 = . if binmigr102t == 1
replace binmigrt2 = . if binmigr102p == 1
replace binmigrp4 = . if binmigr302t == 1
replace binmigrp4 = . if binmigr302p == 1
replace binmigrp4 = . if binmigr202t == 1
replace binmigrp4 = . if binmigr202p == 1
replace binmigrp4 = . if binmigr102t == 1
replace binmigrp4 = . if binmigr102p == 1
replace binmigrp3 = . if binmigr202t == 1
replace binmigrp3 = . if binmigr202p == 1
replace binmigrp3 = . if binmigr102t == 1
replace binmigrp3 = . if binmigr102p == 1
replace binmigrp2 = . if binmigr102t == 1
replace binmigrp2 = . if binmigr102p == 1
sort personid
save mayash401m, replace
use may301m, clear
drop _merge
sort personid
merge personid using may302m, keep(binmigr302p binmigr302t) unique nokeep
gen binmigrt4 = binmigr302t if binmigr301t == 0 & binmigr301p == 0
gen binmigrp4 = binmigr302p if binmigr301t == 0 & binmigr301p == 0
gen fiveint = 1 if _merge==3
drop _merge
sort personid
merge personid using may202m, keep(binmigr202p binmigr202t) unique nokeep
gen binmigrt3 = binmigr202t if binmigr301t == 0 & binmigr301p == 0
gen binmigrp3 = binmigr202p if binmigr301t == 0 & binmigr301p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may102m, keep(binmigr102p binmigr102t) unique nokeep
gen binmigrt2 = binmigr102t if binmigr301t == 0 & binmigr301p == 0
gen binmigrp2 = binmigr102p if binmigr301t == 0 & binmigr301p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may401m, keep(binmigr401p binmigr401t) unique nokeep
replace fiveint = 0 if _merge==1
drop _merge
replace binmigrt4 = . if binmigr202t == 1
replace binmigrt4 = . if binmigr202p == 1
replace binmigrt4 = . if binmigr102t == 1
replace binmigrt4 = . if binmigr102p == 1
replace binmigrt4 = . if binmigr401t == 1
replace binmigrt4 = . if binmigr401p == 1
replace binmigrt3 = . if binmigr102t == 1
replace binmigrt3 = . if binmigr102p == 1
replace binmigrt3 = . if binmigr401t == 1
replace binmigrt3 = . if binmigr401p == 1
replace binmigrt2 = . if binmigr401t == 1
replace binmigrt2 = . if binmigr401p == 1
replace binmigrp4 = . if binmigr202t == 1
replace binmigrp4 = . if binmigr202p == 1
replace binmigrp4 = . if binmigr102t == 1
replace binmigrp4 = . if binmigr102p == 1
replace binmigrp4 = . if binmigr401t == 1
replace binmigrp4 = . if binmigr401p == 1
replace binmigrp3 = . if binmigr102t == 1
replace binmigrp3 = . if binmigr102p == 1
replace binmigrp3 = . if binmigr401t == 1
replace binmigrp3 = . if binmigr401p == 1
replace binmigrp2 = . if binmigr401t == 1
replace binmigrp2 = . if binmigr401p == 1
sort personid
save mayash301m, replace
use may201m, clear
drop _merge
sort personid
merge personid using may202m, keep(binmigr202p binmigr202t) unique nokeep
gen binmigrt4 = binmigr202t if binmigr201t == 0 & binmigr201p == 0
gen binmigrp4 = binmigr202p if binmigr201t == 0 & binmigr201p == 0
gen fiveint = 1 if _merge==3
drop _merge
sort personid
merge personid using may102m, keep(binmigr102p binmigr102t) unique nokeep
gen binmigrt3 = binmigr102t if binmigr201t == 0 & binmigr201p == 0
gen binmigrp3 = binmigr102p if binmigr201t == 0 & binmigr201p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may401m, keep(binmigr401p binmigr401t) unique nokeep
gen binmigrt2 = binmigr401t if binmigr201t == 0 & binmigr201p == 0
gen binmigrp2 = binmigr401p if binmigr201t == 0 & binmigr201p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may301m, keep(binmigr301p binmigr301t) unique nokeep
replace fiveint = 0 if _merge==1
drop _merge
replace binmigrt4 = . if binmigr102t == 1
replace binmigrt4 = . if binmigr102p == 1
replace binmigrt4 = . if binmigr401t == 1
replace binmigrt4 = . if binmigr401p == 1
replace binmigrt4 = . if binmigr301t == 1
replace binmigrt4 = . if binmigr301p == 1
replace binmigrt3 = . if binmigr401t == 1
replace binmigrt3 = . if binmigr401p == 1
replace binmigrt3 = . if binmigr301t == 1
replace binmigrt3 = . if binmigr301p == 1
replace binmigrt2 = . if binmigr301t == 1
replace binmigrt2 = . if binmigr301p == 1
replace binmigrp4 = . if binmigr102t == 1
replace binmigrp4 = . if binmigr102p == 1
replace binmigrp4 = . if binmigr401t == 1
replace binmigrp4 = . if binmigr401p == 1
replace binmigrp4 = . if binmigr301t == 1
replace binmigrp4 = . if binmigr301p == 1
replace binmigrp3 = . if binmigr401t == 1
replace binmigrp3 = . if binmigr401p == 1
replace binmigrp3 = . if binmigr301t == 1
replace binmigrp3 = . if binmigr301p == 1
replace binmigrp2 = . if binmigr301t == 1
replace binmigrp2 = . if binmigr301p == 1
sort personid
save mayash201m, replace
use may101m, clear
drop _merge
sort personid
merge personid using may102m, keep(binmigr102p binmigr102t) unique nokeep
gen binmigrt4 = binmigr102t if binmigr101t == 0 & binmigr101p == 0
gen binmigrp4 = binmigr102p if binmigr101t == 0 & binmigr101p == 0
gen fiveint = 1 if _merge==3
drop _merge
sort personid
merge personid using may401m, keep(binmigr401p binmigr401t) unique nokeep
gen binmigrt3 = binmigr401t if binmigr101t == 0 & binmigr101p == 0
gen binmigrp3 = binmigr401p if binmigr101t == 0 & binmigr101p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may301m, keep(binmigr301p binmigr301t) unique nokeep
gen binmigrt2 = binmigr301t if binmigr101t == 0 & binmigr101p == 0
gen binmigrp2 = binmigr301p if binmigr101t == 0 & binmigr101p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may201m, keep(binmigr201p binmigr201t) unique nokeep
replace fiveint = 0 if _merge==1
drop _merge
replace binmigrt4 = . if binmigr401t == 1
replace binmigrt4 = . if binmigr401p == 1
replace binmigrt4 = . if binmigr301t == 1
replace binmigrt4 = . if binmigr301p == 1
replace binmigrt4 = . if binmigr201t == 1
replace binmigrt4 = . if binmigr201p == 1
replace binmigrt3 = . if binmigr301t == 1
replace binmigrt3 = . if binmigr301p == 1
replace binmigrt3 = . if binmigr201t == 1
replace binmigrt3 = . if binmigr201p == 1
replace binmigrt2 = . if binmigr201t == 1
replace binmigrt2 = . if binmigr201p == 1
replace binmigrp4 = . if binmigr401t == 1
replace binmigrp4 = . if binmigr401p == 1
replace binmigrp4 = . if binmigr301t == 1
replace binmigrp4 = . if binmigr301p == 1
replace binmigrp4 = . if binmigr201t == 1
replace binmigrp4 = . if binmigr201p == 1
replace binmigrp3 = . if binmigr301t == 1
replace binmigrp3 = . if binmigr301p == 1
replace binmigrp3 = . if binmigr201t == 1
replace binmigrp3 = . if binmigr201p == 1
replace binmigrp2 = . if binmigr201t == 1
replace binmigrp2 = . if binmigr201p == 1
sort personid
save mayash101m, replace
use may400m, clear
drop _merge
sort personid
merge personid using may401m, keep(binmigr401p binmigr401t) unique nokeep
gen binmigrt4 = binmigr401t if binmigr400t == 0 & binmigr400p == 0
gen binmigrp4 = binmigr401p if binmigr400t == 0 & binmigr400p == 0
gen fiveint = 1 if _merge==3
drop _merge
sort personid
merge personid using may301m, keep(binmigr301p binmigr301t) unique nokeep
gen binmigrt3 = binmigr301t if binmigr400t == 0 & binmigr400p == 0
gen binmigrp3 = binmigr301p if binmigr400t == 0 & binmigr400p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may201m, keep(binmigr201p binmigr201t) unique nokeep
gen binmigrt2 = binmigr201t if binmigr400t == 0 & binmigr400p == 0
gen binmigrp2 = binmigr201p if binmigr400t == 0 & binmigr400p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may101m, keep(binmigr101p binmigr101t) unique nokeep
replace fiveint = 0 if _merge==1
drop _merge
replace binmigrt4 = . if binmigr301t == 1
replace binmigrt4 = . if binmigr301p == 1
replace binmigrt4 = . if binmigr201t == 1
replace binmigrt4 = . if binmigr201p == 1
replace binmigrt4 = . if binmigr101t == 1
replace binmigrt4 = . if binmigr101p == 1
replace binmigrt3 = . if binmigr201t == 1
replace binmigrt3 = . if binmigr201p == 1
replace binmigrt3 = . if binmigr101t == 1
replace binmigrt3 = . if binmigr101p == 1
replace binmigrt2 = . if binmigr101t == 1
replace binmigrt2 = . if binmigr101p == 1
replace binmigrp4 = . if binmigr301t == 1
replace binmigrp4 = . if binmigr301p == 1
replace binmigrp4 = . if binmigr201t == 1
replace binmigrp4 = . if binmigr201p == 1
replace binmigrp4 = . if binmigr101t == 1
replace binmigrp4 = . if binmigr101p == 1
replace binmigrp3 = . if binmigr201t == 1
replace binmigrp3 = . if binmigr201p == 1
replace binmigrp3 = . if binmigr101t == 1
replace binmigrp3 = . if binmigr101p == 1
replace binmigrp2 = . if binmigr101t == 1
replace binmigrp2 = . if binmigr101p == 1
sort personid
save mayash400m, replace
use may300m, clear
drop _merge
sort personid
merge personid using may301m, keep(binmigr301p binmigr301t) unique nokeep
gen binmigrt4 = binmigr301t if binmigr300t == 0 & binmigr300p == 0
gen binmigrp4 = binmigr301p if binmigr300t == 0 & binmigr300p == 0
gen fiveint = 1 if _merge==3
drop _merge
sort personid
merge personid using may201m, keep(binmigr201p binmigr201t) unique nokeep
gen binmigrt3 = binmigr201t if binmigr300t == 0 & binmigr300p == 0
gen binmigrp3 = binmigr201p if binmigr300t == 0 & binmigr300p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may101m, keep(binmigr101p binmigr101t) unique nokeep
gen binmigrt2 = binmigr101t if binmigr300t == 0 & binmigr300p == 0
gen binmigrp2 = binmigr101p if binmigr300t == 0 & binmigr300p == 0
replace fiveint = 0 if _merge==1
drop _merge
sort personid
merge personid using may400m, keep(binmigr400p binmigr400t) unique nokeep
replace fiveint = 0 if _merge==1
drop _merge
replace binmigrt4 = . if binmigr201t == 1
replace binmigrt4 = . if binmigr201p == 1
replace binmigrt4 = . if binmigr101t == 1
replace binmigrt4 = . if binmigr101p == 1
replace binmigrt4 = . if binmigr400t == 1
replace binmigrt4 = . if binmigr400p == 1
replace binmigrt3 = . if binmigr101t == 1
replace binmigrt3 = . if binmigr101p == 1
replace binmigrt3 = . if binmigr400t == 1
replace binmigrt3 = . if binmigr400p == 1
replace binmigrt2 = . if binmigr400t == 1
replace binmigrt2 = . if binmigr400p == 1
replace binmigrp4 = . if binmigr201t == 1
replace binmigrp4 = . if binmigr201p == 1
replace binmigrp4 = . if binmigr101t == 1
replace binmigrp4 = . if binmigr101p == 1
replace binmigrp4 = . if binmigr400t == 1
replace binmigrp4 = . if binmigr400p == 1
replace binmigrp3 = . if binmigr101t == 1
replace binmigrp3 = . if binmigr101p == 1
replace binmigrp3 = . if binmigr400t == 1
replace binmigrp3 = . if binmigr400p == 1
replace binmigrp2 = . if binmigr400t == 1
replace binmigrp2 = . if binmigr400p == 1
sort personid
save mayash300m, replace
