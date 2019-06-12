* *********************************************
*  Does Membership on the UNSC Influence      *
*         Voting in the UNGA?                 *
*        (Replication Do file)                * 
*                                             *
*    Hwang, W., Sanford, A., and Lee, J.      *
*                Sep, 2014                    *
*             (Stata 11.2 version)            *
***********************************************

set mem 500m

use "C:\II(data).dta", clear


* Table 1 (summary statistics)

sum ccode year yesnocoincP3 yesnocoincUS npunsc imfloan wbloan totalloan nptotal ln_USAid96 tau_lead demaut lnrgdpl lpop OIL depb if yesnocoincP3 !=. & yesnocoincUS !=. & npunsc !=. & totalloan !=. & nptotal !=. & ln_USAid96 !=. & tau_lead !=. & demaut !=. & lnrgdpl !=. & lpop !=. & OIL !=. & depb !=.


** Table 2

xtscc yesnocoincP3 npunsc ln_USAid96 totalloan tau_lead demaut lnrgdpl lpop OIL depb, fe lag(10)
xtscc yesnocoincP3 npunsc ln_USAid96 npusaid1 totalloan tau_lead demaut lnrgdpl lpop OIL depb, fe lag(10)
xtscc yesnocoincP3 npunsc totalloan nptotal ln_USAid96 tau_lead demaut lnrgdpl lpop OIL depb, fe lag(10)
xtscc yesnocoincP3 npunsc totalloan nptotal ln_USAid96 npusaid1  tau_lead demaut lnrgdpl lpop OIL depb, fe lag(10)


** Table 3

xtscc yesnocoincUS npunsc ln_USAid96 totalloan depb demaut lnrgdpl OIL lpop, fe lag(10)
xtscc yesnocoincUS npunsc ln_USAid96 npusaid1 totalloan depb demaut lnrgdpl OIL lpop, fe lag(10)
xtscc yesnocoincUS npunsc totalloan nptotal ln_USAid96 depb demaut lnrgdpl OIL lpop, fe lag(10)
xtscc yesnocoincUS npunsc totalloan nptotal ln_USAid96 npusaid1 depb demaut lnrgdpl OIL lpop, fe lag(10)


* Figure 1 (Vote Coincidence with the U.S.)

sort year
by year: egen avgnp1 = mean(yesnocoincUS) if npunsc ==1
sort year
by year: egen avgnp0 = mean(yesnocoincUS) if npunsc ==0

twoway (line avgnp1 year, sort) (line avgnp0 year, sort clpattern(dash) clcolor(blue)), xscale(range(1946 2006)) ytitle (Vote Coincidence (%)) xtitle(Year)


* Figure 2 (Vote Coincidence with P3)

sort year
by year: egen avgnp13 = mean(yesnocoincP3) if npunsc ==1
sort year
by year: egen avgnp03 = mean(yesnocoincP3) if npunsc ==0

twoway (line avgnp13 year, sort) (line avgnp03 year, sort), ytitle (Vote Coincidence (%)) xtitle(Year)

* Figure 3 (Vote Coincidence with the U.S.: 2 years before/after and during membership)

sort ccode year
gen np_2 = npunsc[_n-2]
gen tta2 = 1 if np_2 == 1 

recode tta2 .=0 if npunsc ==0
gen avgnpt2a = avgnp*100 if tta2 ==1

gen np2 = npunsc[_n+2]
gen ttb2 = 1 if np2 ==1
recode ttb2 .=0 if npunsc ==0

gen avgnpp = avgnp*100

twoway (line avgnpp year if npunsc ==1, sort) (line avgnpp year if tta2 ==1, sort clpattern(dash) clcolor(blue)) (line avgnpp year if ttb2 ==1, sort clpattern(dot) clwidth(thick) clcolor(orange)), xscale(range(1946 2006)) ytitle (Vote Coincidence (%)) xtitle(Year)


** Figure 4 (marginal effects)

xtscc yesnocoincP3 npunsc totalloan nptotal ln_USAid96 tau_lead demaut lnrgdpl lpop OIL depb, fe lag(10)

matrix b=e(b) 
matrix V=e(V)

scalar b1=b[1,1] 
scalar b3=b[1,3]

scalar varb1=V[1,1] 
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]

gen marg3=b1+(b3*totalloan) 

gen se3=sqrt(varb1+((totalloan^2)*varb3)+(2*totalloan*covb1b3))

gen upper3 = marg3+(se3*1.96)
gen upper31 = marg3 + (se3*1.645)

gen lower3 = marg3-(se3*1.96)
gen lower31 = marg - (se3*1.645)


twoway (line marg3 totalloan, sort clcolor(black)) (line upper3 totalloan, sort clpattern(dot) clcolor(black))/* 
*/(line upper31 totalloan, sort clpattern(dash) clcolor(black))/* 
*/(line lower3 totalloan, sort clpattern(dot) clcolor(black)) (line lower31 totalloan, sort clpattern(dash) clcolor(black)), legend(off) yline(0) yscale(range(-4 6)) ytitle(Marginal Effect with 95(90)% C.I.) /* 
*/xscale(range(0 18)) xtitle(Loans (IMF, WB)) 

drop marg3 se3 upper3 lower3 upper31 lower31


** Figure 5 (marginal effects)

xtscc yesnocoincUS npunsc totalloan nptotal ln_USAid96 demaut lnrgdpl lpop OIL depb, fe lag(10)

matrix b=e(b) 
matrix V=e(V)

scalar b1=b[1,1] 
scalar b3=b[1,3]

scalar varb1=V[1,1] 
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]

gen marg3=b1+(b3*totalloan) 

gen se3=sqrt(varb1+((totalloan^2)*varb3)+(2*totalloan*covb1b3))

gen upper3 = marg3+(se3*1.96)
gen upper31 = marg3 + (se3*1.645)

gen lower3 = marg3-(se3*1.96)
gen lower31 = marg - (se3*1.645)


twoway (line marg3 totalloan, sort clcolor(black)) (line upper3 totalloan, sort clpattern(dot) clcolor(black))/* 
*/(line upper31 totalloan, sort clpattern(dash) clcolor(black))/* 
*/(line lower3 totalloan, sort clpattern(dot) clcolor(black)) (line lower31 totalloan, sort clpattern(dash) clcolor(black)), legend(off) yline(0) yscale(range(-4 6)) ytitle(Marginal Effect with 95(90)% C.I.) /* 
*/xscale(range(0 18)) xtitle(Loans (IMF, WB)) 



*** Robustness Tests
** With existing loan programs

* Table 2
xtscc yesnocoincP3 ExistingLoan npunsc ln_USAid96 npusaid1 totalloan tau_lead demaut lnrgdpl lpop OIL depb, fe lag(10)
xtscc yesnocoincP3 ExistingLoan npunsc totalloan nptotal ln_USAid96 tau_lead demaut lnrgdpl lpop OIL depb, fe lag(10)
xtscc yesnocoincP3 ExistingLoan npunsc totalloan nptotal ln_USAid96 npusaid1  tau_lead demaut lnrgdpl lpop OIL depb, fe lag(10)

* Table 3
xtscc yesnocoincUS ExistingLoan npunsc ln_USAid96 npusaid1 totalloan depb demaut lnrgdpl OIL lpop, fe lag(10)
xtscc yesnocoincUS ExistingLoan npunsc totalloan nptotal ln_USAid96 depb demaut lnrgdpl OIL lpop, fe lag(10)
xtscc yesnocoincUS ExistingLoan npunsc totalloan nptotal ln_USAid96 npusaid1 depb demaut lnrgdpl OIL lpop, fe lag(10)


** The Cold War effects
gen coldwar = .
recode coldwar .=1 if year < 1991
recode coldwar .=0 if year > 1990

* Table 3
xtscc yesnocoincUS npunsc ln_USAid96 npusaid1 totalloan depb demaut lnrgdpl OIL lpop if coldwar==1, fe lag(10)
xtscc yesnocoincUS npunsc totalloan nptotal ln_USAid96 depb demaut lnrgdpl OIL lpop if coldwar==1, fe lag(10)
xtscc yesnocoincUS npunsc totalloan nptotal ln_USAid96 npusaid1 depb demaut lnrgdpl OIL lpop if coldwar==1, fe lag(10)

xtscc yesnocoincUS npunsc ln_USAid96 npusaid1 totalloan depb demaut lnrgdpl OIL lpop if coldwar==0, fe lag(9)
xtscc yesnocoincUS npunsc totalloan nptotal ln_USAid96 depb demaut lnrgdpl OIL lpop if coldwar==0, fe lag(9)
xtscc yesnocoincUS npunsc totalloan nptotal ln_USAid96 npusaid1 depb demaut lnrgdpl OIL lpop if coldwar==0, fe lag(9)

* Table 2
xtscc yesnocoincP3 npunsc ln_USAid96 npusaid1 totalloan tau_lead demaut lnrgdpl lpop OIL depb if coldwar==1, fe lag(10) 
xtscc yesnocoincP3 npunsc totalloan nptotal ln_USAid96 tau_lead demaut lnrgdpl lpop OIL depb if coldwar==1, fe lag(10) 
xtscc yesnocoincP3 npunsc ln_USAid96 npusaid1 totalloan nptotal tau_lead demaut lnrgdpl lpop OIL depb if coldwar==1, fe lag(10)

xtscc yesnocoincP3 npunsc ln_USAid96 npusaid1 totalloan tau_lead demaut lnrgdpl lpop OIL depb if coldwar==0, fe lag(9) 
xtscc yesnocoincP3 npunsc totalloan nptotal ln_USAid96 tau_lead demaut lnrgdpl lpop OIL depb if coldwar==0, fe lag(9) 
xtscc yesnocoincP3 npunsc ln_USAid96 npusaid1 totalloan nptotal tau_lead demaut lnrgdpl lpop OIL depb if coldwar==0, fe lag(9)


** Even-time specification

* Table 2
xtscc yesnocoincP3 T_1 T0 T1 T2 T3 T4 ln_USAid96 totalloan tau_lead demaut lnrgdpl lpop OIL depb, fe lag(10)
xtscc yesnocoincP3 T_1 T0 T3 T4 npunsc ln_USAid96 npusaid1 totalloan tau_lead demaut lnrgdpl lpop OIL depb, fe lag(10)
xtscc yesnocoincP3 T_1 T0 T3 T4 npunsc totalloan nptotal ln_USAid96 tau_lead demaut lnrgdpl lpop OIL depb, fe lag(10)
xtscc yesnocoincP3 T_1 T0 T3 T4 npunsc ln_USAid96 npusaid1 totalloan nptotal tau_lead demaut lnrgdpl lpop OIL depb, fe lag(10)

* Table 3
xtscc yesnocoincUS T_1 T0 T1 T2 T3 T4 ln_USAid96 totalloan depb demaut lnrgdpl OIL lpop, fe lag(10)
xtscc yesnocoincUS T_1 T0 T3 T4 npunsc ln_USAid96 npusaid1 totalloan depb demaut lnrgdpl OIL lpop, fe lag(10)
xtscc yesnocoincUS T_1 T0 T3 T4 npunsc totalloan nptotal ln_USAid96 depb demaut lnrgdpl OIL lpop, fe lag(10)
xtscc yesnocoincUS T_1 T0 T3 T4 npunsc totalloan nptotal ln_USAid96 npusaid1 depb demaut lnrgdpl OIL lpop, fe lag(10)



