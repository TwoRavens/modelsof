set more off

use finalISQtransmit.dta

stset timetotransmit, id(agreement) failure(transmitfailure)

label var ACS "Arms Control"
label var COMM "Commercial"
label var HR "Human Rights"
label var IL "Int'l Law"
label var approveyear "Approval"
label var prezpctmajbth "President % Control"
label var conservsen "Conservative Senator"
label var Dprez "Democratic President"
label var sfrchair "SFR Chair"
label var noavailtransmit "Treaties Available"
label var secondterm "Second Presidential Term"
label var lameduck "Lame Duck"
label var reelect "Re-Election"
label var nolameelect "Non-presidential Election Year"
label var prezpctmajsen "President % Control (Sen)"


*Model 1.1
streg ACS COMM IL HR approveyear prezpctmajbth conservsen Dprez sfrchair noavailtransmit, d(weib) nohr cluster(agreement)

*Model 1.2
streg ACS COMM IL HR approveyear conservsen Dprez sfrchair noavailtransmit nolameelect prezpctmajbth, d(weib) nohr cluster(agreement)

*Appendix Fig A.1
sts graph

*Table A2 - column 1
streg ACS COMM IL HR approveyear prezpctmajsen conservsen Dprez sfrchair noavailtransmit, d(weib) nohr cluster(agreement)

*Table A2 - column 2
streg ACS COMM IL HR approveyear prezpctmajbth conservsen Dprez sfrchair noavailtransmit secondterm, d(weib) nohr cluster(agreement)

*Table A2 - column 3
streg ACS COMM IL HR approveyear prezpctmajbth conservsen Dprez sfrchair noavailtransmit lameduck reelect, d(weib) nohr cluster(agreement)

test lameduck=reelect


**RATIFICATION MODELS**

use finalISQratif.dta, clear

stset transtorattime, id(agreement) failure(ratfailure)


*label vars
label var ACS "Arms Control"
label var COMM "Commercial"
label var HR "Human Rights"
label var IL "Int'l Law"
label var approveyear "Approval"
label var prezpctmajbth "President % Control"
label var conservsen "Conservative Senator"
label var Dprez "Democratic President"
label var sfrchair "SFR Chair"
label var secondterm "Second Presidential Term"
label var yhat "Y hat from first model"
label var lameduck "Lame Duck"
label var reelect "Re-Election"
label var prezpctmajsen "President % Control (Sen)"
label var lameelect "Presidential Election Year"
label var nolameelect "Non-presidential Election Year"
label var ratavail "Treaties Available"
label var implement "Implementation"
label var noreelect "No Election or no sitting Prez"


*Figure A2

sts graph

*Model 2.1
streg ACS COMM IL HR prezpctmajbth conservsen Dprez sfrchair ratavail nolameelect implement, d(weib) nohr cluster(agreement)

*Model 2.2

gen implement_pct = prezpctmajbth*implement
label var implement_pct "Implement X Prez. % Control"

streg ACS COMM IL HR prezpctmajbth conservsen Dprez sfrchair ratavail nolameelect implement implement_pct, d(weib) nohr cluster(agreement)

test implement prezpctmajbth implement_pct

*Model 2.3

gen lame_pct = prezpctmajbth*nolameelect
label var lame_pct "Election X Prez. % Support"

streg ACS COMM IL HR prezpctmajbth conservsen Dprez sfrchair ratavail nolameelect implement lame_pct, d(weib) nohr cluster(agreement)

test prezpctmajbth nolameelect lame_pct

*Table A3 - column 1
streg ACS COMM IL HR prezpctmajsen conservsen Dprez sfrchair ratavail nolameelect implement, d(weib) nohr cluster(agreement)

*Table A3 - column 2
streg ACS COMM IL HR prezpctmajbth conservsen Dprez sfrchair ratavail nolameelect implement yhat, d(weib) nohr cluster(agreement)

*Table A3 - column 3
streg ACS COMM IL HR prezpctmajbth conservsen Dprez sfrchair ratavail nolameelect implement secondterm, d(weib) nohr cluster(agreement)

*Table A3 - column 4
streg ACS COMM IL HR prezpctmajbth conservsen Dprez sfrchair ratavail lameduck noreelect implement, d(weib) nohr cluster(agreement)

test lameduck = noreelect

*Table A4 - column 1
gen nolame_pctS = prezpctmajsen*nolameelect
label var nolame_pctS "Election x Prez % Sup (Sen)"

streg ACS COMM IL HR prezpctmajsen conservsen Dprez sfrchair ratavail nolameelect implement nolame_pctS, d(weib) nohr cluster(agreement)
test prezpctmajsen nolameelect nolame_pctS

*Table A4 - column 2
gen implement_pctS = implement*prezpctmajsen
label var implement_pctS "Implement x Prez % Sup (Sen)"

streg ACS COMM IL HR prezpctmajsen conservsen Dprez sfrchair ratavail nolameelect implement implement_pctS, d(weib) nohr cluster(agreement)

test prezpctmajsen implement implement_pctS

*CREATE FIGURES 3-4 

set more off
use finalISQratif.dta, clear
stset transtorattime, id(agreement) failure(ratfailure)
streg ACS COMM IL HR conservsen Dprez sfrchair ratavail lameelect i.implement##c.prezpctmajbth, d(weib) nohr cluster(agreement)
margins, dydx(implement) at(prezpctmajbth=(.35(.05).6)) vsquish level(90)
marginsplot, yline(0) title("Marginal Effect of Implement") ytitle("Effect on Median Advice and Consent Time")

set more off
use finalISQratif.dta, clear
stset transtorattime, id(agreement) failure(ratfailure)
streg ACS COMM IL HR conservsen Dprez sfrchair ratavail implement i.nolameelect##c.prezpctmajbth, d(weib) nohr cluster(agreement)
margins, dydx(nolameelect) at(prezpctmajbth=(.35(.05).6)) vsquish level(90)
marginsplot, yline(0) title("Marginal Effect of Non-Prez. Election") ytitle("Effect on Median Advice and Consent Time")

*CREATE FIGURES A3-A4
set more off
use finalISQratif.dta, clear
stset transtorattime, id(agreement) failure(ratfailure)
streg ACS COMM IL HR conservsen Dprez sfrchair ratavail lameelect i.implement##c.prezpctmajbth, d(weib) nohr cluster(agreement)
margins, dydx(prezpctmajbth) at(implement=(0 1)) vsquish level(90)
marginsplot, yline(0) title("Marginal Effect of Prez % Control") ytitle("Effect on Median Advice and Consent Time")

set more off
use finalISQratif.dta, clear
stset transtorattime, id(agreement) failure(ratfailure)
streg ACS COMM IL HR conservsen Dprez sfrchair ratavail implement i.lameelect##c.prezpctmajbth, d(weib) nohr cluster(agreement)
margins, dydx(prezpctmajbth) at(lameelect=(0 1)) vsquish level(90)
marginsplot, yline(0) title("Marginal Effect of Prez % Control") ytitle("Effect on Median Advice and Consent Time")

