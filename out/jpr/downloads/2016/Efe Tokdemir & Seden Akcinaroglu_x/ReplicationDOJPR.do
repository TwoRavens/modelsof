clear all
cd "/Users/efetokdemir/Desktop/ReplicationJPR/"
use "/Users/efetokdemir/Desktop/ReplicationDataJPR.dta"

lab var intposrep "Pos. Cons. Rep."
lab var intnegrep "Neg. Cons. Rep."
lab var coldwar "Cold War"
lab var peaksize "Peak size"
lab var nmbrtrr "Competition"
lab var p_polity2 "Polity"
lab var loggdp "GDP pc (log)"
lab var logpop "Population (log)"
lab var logmil "Mil. Personnel (log)"
lab var left "Leftist"
lab var nat "Ethno-Nationalist"
lab var rel "Religious"
lab var rebel "Rebel"
lab var broadgoal "Broad goal"
lab var international "Cross-Border op."

***Table3***
eststo m1: ologit peaksize intposrep p_polity2 loggdp logpop logmil left nat rel rebel broadgoal international, robust
eststo m2: ologit peaksize intnegrep p_polity2 loggdp logpop logmil left nat rel rebel broadgoal international, robust
eststo m3: logit reputation nmbrtrr rel nat left p_polity2 loggdp logpop logmil rebel broadgoal international, robust
eststo m4: ologit intposrep rebel rel nat left p_polity2 loggdp logpop logmil broadgoal international, robust
eststo m5: ologit outnegrep rebel rel nat left p_polity2 loggdp logpop logmil broadgoal international, robust
eststo m6: logit pgood rel p_polity2 loggdp logpop logmil rebel broadgoal international, robust
esttab m1 m2 m3 m4 m5 m6 using "Table3.tex", tex replace b(%10.3f) se scalars("r2_p Pseudo \$R^2\$" "ll Log likelihood" "chi2 $\chi^2$") label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) varlabels(_cons Constant)

***Table4***
stset age, failure(endedtype2)
eststo m7: stcox intposrep peaksize nmbrtrr p_polity2 loggdp logpop logmil left nat rel rebel broadgoal international
stcurve, survival at1(intposrep=0) at2(intposrep=3) range(0 30) saving(graphA, replace)
eststo m8: stcox intnegrep peaksize nmbrtrr p_polity2 loggdp logpop logmil left nat rel rebel broadgoal international
stcurve, survival at1(intnegrep=0) at2(intnegrep=3) range(0 30) saving(graphB, replace)
esttab m7 m8 using "Table4.tex", eform tex replace b(%10.3f) se scalars("r2_p Pseudo \$R^2\$" "ll Log likelihood" "chi2 $\chi^2$") label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) varlabels(_cons Constant)

***Figure1***
sort year
egen conspos=mean(intposrep), by(year)
egen consneg=mean(intnegrep), by(year)
egen audneg=mean(outnegrep), by(year)
line conspos consneg audneg year

***Table2***
factor pgood media politics ffund frec childrec civcauseffreal eductargexist, pcf
rotate, varimax
scree

***Figure2***
matrix C = (63,171,131,123 \ 81,132,211,111 \ 139,261,153,126 \ 436,289,125,89)
plotmatrix, m(C) split(0 50 100 150 200 250 300 350 400 450) c(gray) legend(pos(3) col(1))

