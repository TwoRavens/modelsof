*Name: Mitch Radtke and Hyeran Jo
*Project: Fighting the Hydra (Supplemental Part IV)
*Date last Modified: 12/01/2017


*Set system directory
sysdir set PLUS "E:\Stata12\ado\plus"
sysdir set PERSONAL "E:\Stata12\ado\personal"

*Opening up data

use "E:\Hyeran\Hydra\Data and Results\Case Studies\UNITA\unita_rats_week.dta", clear
cd "E:\Hyeran\Hydra\Data and Results\Case Studies\UNITA\"
*Time-setting data
tsset counter, delta(7)


*****Pre-offensive VAR*****

*Lag-order selection [2 lags]
varsoc battles losses if _n<=140


*Table A19: UNITA VAR Model 1 (Response: Battles, Impulse: Losses)

var battles losses if _n<=140, ex(civilwar) lags(1/2)


*Test for stability [Yes]
varstable


*Figure A8 (left): UNITA VAR (Response: Battles, Impulse: Losses)
irf create order1, step(10) set(myirf1)
irf graph oirf,  title("Pre-Offensive", color(black) size(medium large)) xlab(0 2 4 6 8 10) graphr(fcolor(white)) xtitle("Effect at Week (T)") ytitle("Response for Battles Series", height(7)) impulse(losses) response(battles) legend(label(2 "Impulse Response"))
graph save Graph "E:\Hyeran\Hydra\Data and Results\Case Studies\UNITA\VAR2.gph", replace

*****Post-offensive VAR*****

*Lag-order selection [2 lags]
varsoc battles losses if _n>140

*Stability [Yes]
varstable


*Table A19: UNITA VAR Model 2(Response: Battles, Impulse: Losses)

var battles losses if _n>140, lags(1/2)
est store v2

*Figure A8 (right): UNITA VAR (Response: Battles, Impulse: Losses)
irf graph oirf,  title("Offensive and After", color(black) size(medium large)) xlab(0 2 4 6 8 10) graphr(fcolor(white)) xtitle("Effect at Week (T)") ytitle("Response for Battles Series", height(7)) impulse(losses) response(battles) legend(label(2 "Impulse Response"))
graph save Graph "G:\Hyeran\Hydra\Data and Results\Case Studies\UNITA\VAR4.gph", replace


*Table A19
esttab v1 v2 using var.rtf, replace addnote("Vector autogressive models. Standard errors in parentheses") legend cells (b(star fmt(2)) se(par fmt(2))) starlevels(* 0.05 ** 0.01) nonumbers mlabels("Pre-Offensive" "Offensive and After") varwidth(30) collabels(" ")

*Figure A8
cd "E:\Hyeran\Hydra\Data and Results\Case Studies\UNITA\"
graph combine VAR2.gph VAR4.gph
