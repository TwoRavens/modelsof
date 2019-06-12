***Tables and figures with a number followed by "a" appear in the online appendix***


***Ambivalence Codes***

gen demlikes = VCF0401
recode demlikes 9=.

gen demdislikes = VCF0402
recode demdislikes 9=.

gen ambivdemcand = ((demlikes+demdislikes)/2) - abs(demlikes-demdislikes)
gen ambivdemcand2 = (ambivdemcand+2.5)/7.5


gen replikes = VCF0405
recode replikes 9=.

gen repdislikes = VCF0406
recode repdislikes 9=.

gen ambivrepcand = ((replikes+repdislikes)/2) - abs(replikes-repdislikes)
gen ambivrepcand2 = (ambivrepcand+2.5)/7.5

***Emotion Codes***

gen angryD = VCF0358
recode angryD 1=1 2=0 8=0 9=.
gen afraidD = VCF0359
recode afraidD 1=1 2=0 8=0 9=.
gen hopeD = VCF0360
recode hopeD 1=1 2=0 8=0 9=.
gen prideD = VCF0361
recode prideD 1=1 2=0 8=0 9=.
gen enthusiasmD2 = hopeD + prideD


gen angryR = VCF0370
recode angryR 1=1 2=0 8=0 9=.
gen afraidR = VCF0371
recode afraidR 1=1 2=0 8=0 9=.
gen hopeR = VCF0372
recode hopeR 1=1 2=0 8=0 9=.
gen prideR = VCF0373
recode prideR 1=1 2=0 8=0 9=.
gen enthusiasmR2 = hopeR + prideR


***Dependent Variables***

gen demcandtherm = VCF0424
recode demcandtherm 98/99=.
gen demcandthermst2 = (abs((demcandtherm-50)))/50

gen repcandtherm = VCF0426
recode repcandtherm 98/99=.
gen repcandthermst2 = (abs((repcandtherm-50)))/50

gen demcand_neutral = VCF0424
recode demcand_neutral 0/49=0 50=1 51/97=0 98=1 99=.

gen repcand_neutral = VCF0426
recode repcand_neutral 0/49=0 50=1 51/97=0 98=1 99=.

gen abstention = VCF0703
recode abstention 0=. 1/2=1 3=0


***Controls***

gen income = VCF0114
recode income 0=.
gen income2 = (income-1)/4
gen income3 = income
recode income3 1/2=0 3=1 4/5=2


gen education = VCF0140a
recode education 8/9=.
gen education2 = (education-1)/6

gen age = VCF0101
recode age 0=. 96/99=96
gen age2 = (age-17)/79

gen pid = VCF0301
recode pid 0=. 9=.
gen pid1 = (pid-4)
gen pidst = abs(pid1)
gen pid2 = (pid-4)/3
gen pidst2 = abs(pid2)

gen interest_elec = VCF0310
recode interest_elec 0=. 1=0 2=.5 3=1 9=.

gen black = VCF0106a
recode black 0=. 1=0 3/7=0

gen hispanic = VCF0106a
recode hispanic 0=. 1/4=0 5=1 7=0

gen female = VCF0104
recode female 0=. 1=0 2=1


gen knowhouse2 = VCF0729
recode knowhouse2 0/1=0 2=1

gen knowideology_dem = VCF0503
recode knowideology_dem 0=0 1/4=1 5/8=0

gen knowideology_rep = VCF0504
recode knowideology_rep 0/3=0 4/7=1 8=0

gen knowledge = ((knowhouse + knowideology_dem + knowideology_rep)-1)/3

gen yr84 = VCF0004 
recode yr84 1900/1983=0 1984=1 1985/2008=0
gen yr88 = VCF0004
recode yr88 1900/1987=0 1988=1 1989/2008=0
gen yr92 = VCF0004 
recode yr92 1900/1991=0 1992=1 1993/2008=0
gen yr96 = VCF0004 
recode yr96 1900/1995=0 1996=1 1997/2008=0
gen yr00 = VCF0004 
recode yr00 1900/1999=0 2000=1 2001/2008=0
gen yr04 = VCF0004 
recode yr04 1900/2003=0 2004=1 2005/2008=0

***Labels***
label define enthlabel 0 "No Enthusiasm" 1 "Some Enthusiasm" 2 "High Enthusiasm", replace
label values enthusiasmD2 enthusiasmR2 enthlabel

label define fearlabel 0 "No Fear" 1 "Fear", replace
label values afraidD afraidR fearlabel

label define angerlabel 0 "No Anger" 1 "Anger", replace
label values angryD angryR angerlabel

label variable enthusiasmD2 "Enthusiasm (D)"
label variable enthusiasmR2 "Enthusiasm (R)"
label variable afraidD "Fear (D)"
label variable afraidR "Fear (R)"
label variable angryD "Anger (D)"
label variable angryR "Anger (R)"

label define inclabel 0 "Low Income" 1 "Middle Income" 2 "High Income", replace
label values income3 inclabel

***Figure 2: Emotions Histograms***

hist ambivdemcand2, freq fcolor(gray) lcolor(black) xtitle("Ambivalence Toward Democrat") subtitle(, fcolor(white) lcolor(white)) discrete by(enthusiasmD2, rows(1) note("") graphregion(color(white)) bgcolor(white)) saving(demhistE, replace)
hist ambivrepcand2, freq fcolor(gray) lcolor(black) xtitle("Ambivalence Toward Republican") subtitle(, fcolor(white) lcolor(white)) discrete by(enthusiasmR2, rows(1) note("") graphregion(color(white)) bgcolor(white)) saving(rephistE, replace)
hist ambivdemcand2, freq fcolor(gray) lcolor(black) xtitle("Ambivalence Toward Democrat") subtitle(, fcolor(white) lcolor(white)) discrete by(afraidD, rows(1) note("") graphregion(color(white)) bgcolor(white)) saving(demhistF, replace)
hist ambivrepcand2, freq fcolor(gray) lcolor(black) xtitle("Ambivalence Toward Republican")subtitle(, fcolor(white) lcolor(white)) discrete by(afraidR, rows(1) note("") graphregion(color(white)) bgcolor(white)) saving(rephistF, replace)
hist ambivdemcand2, freq fcolor(gray) lcolor(black) xtitle("Ambivalence Toward Democrat") subtitle(, fcolor(white) lcolor(white)) discrete by(angryD, rows(1) note("") graphregion(color(white)) bgcolor(white)) saving(demhistA, replace)
hist ambivrepcand2, freq fcolor(gray) lcolor(black) xtitle("Ambivalence Toward Republican")subtitle(, fcolor(white) lcolor(white)) discrete by(angryR, rows(1) note("") graphregion(color(white)) bgcolor(white)) saving(rephistA, replace)
gr combine demhistE.gph rephistE.gph, graphregion(color(white)) rows (2)

***Correlations referenced on p. 19 of manuscript***

ktau enthusiasmD2 ambivdemcand2
ktau enthusiasmR2 ambivrepcand2

***Figure 3A***

gr combine demhistF.gph rephistF.gph demhistA.gph rephistA.gph, graphregion(color(white)) rows (2)  



***Figure 3: Attitude Strength***

reg demcandthermst2 i.afraidD##c.ambivdemcand2 i.angryD##c.ambivdemcand2 i.enthusiasmD2##c.ambivdemcand2 pid2 pidst education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 [pweight = VCF0009]
margins enthusiasmD2, at (ambivdemcand2 = (0(.2)1) afraidD=0 angryD=0)
marginsplot, plot1opts(lpattern("dot") lcolor(black) mcolor(black)) ci1opts(lcolor(black)) plot2opts(lpattern("dash") lcolor(black) mcolor(black) msymbol(square)) ci2opts(lcolor(black)) plot3opts(lpattern("solid") lcolor(black) mcolor(black) msymbol(diamond)) ci3opts(lcolor(black)) ylabel(-.2(.2)1) legend(col(1) region(color(none))) title("Democratic Candidate") xtitle("Ambivalence", size(3)) ytitle("Attitude Strength", size(3)) graphregion(color(white)) bgcolor(white) saving(enthusiasmD, replace)
margins afraidD, at (ambivdemcand2 = (0(.2)1) enthusiasmD2=0 angryD=0)
marginsplot, ylabel(-.2(.2)1) legend(order(1 "No Fear" 2 "Fear") col(1) region(color(none))) title("Fear (D)") xtitle("Ambivalence", size(3)) ytitle("Attitude Strength", size(3)) graphregion(color(white)) bgcolor(white) saving(afraidD,replace)
margins angryD, at (ambivdemcand2 = (0(.2)1) enthusiasmD2=0 afraidD=0)
marginsplot, ylabel(-.2(.2)1) legend(order(1 "No Anger" 2 "Anger") col(1) region(color(none))) title("Anger (D)") xtitle("Ambivalence", size(3)) ytitle("Attitude Strength", size(3)) graphregion(color(white)) bgcolor(white) saving(angryD,replace)

reg repcandthermst2 i.afraidR##c.ambivrepcand2 i.angryR##c.ambivrepcand2 i.enthusiasmR2##c.ambivrepcand2 pid2 pidst education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 [pweight = VCF0009]
margins enthusiasmR2, at (ambivrepcand2 = (0(.2)1) afraidR=0 angryR=0)
marginsplot, plot1opts(lpattern("dot") lcolor(black) mcolor(black)) ci1opts(lcolor(black)) plot2opts(lpattern("dash") lcolor(black) mcolor(black) msymbol(square)) ci2opts(lcolor(black)) plot3opts(lpattern("solid") lcolor(black) mcolor(black) msymbol(diamond)) ci3opts(lcolor(black)) ylabel(-.2(.2)1) legend(col(1) region(color(none))) title("Republican Candidate") xtitle("Ambivalence", size(3)) ytitle("Attitude Strength", size(3)) graphregion(color(white)) bgcolor(white) saving(enthusiasmR, replace)
margins afraidR, at (ambivrepcand2 = (0(.2)1)  enthusiasmR2=0 angryR=0)
marginsplot, ylabel(-.2(.2)1) legend(order(1 "No Fear" 2 "Fear") col(1) region(color(none))) title("Fear (R)") xtitle("Ambivalence", size(3)) ytitle("Attitude Strength", size(3)) graphregion(color(white)) bgcolor(white) saving(afraidR,replace)
margins angryR, at (ambivrepcand2 = (0(.2)1) enthusiasmR2=0 afraidR=0)
marginsplot, ylabel(-.2(.2)1) legend(order(1 "No Anger" 2 "Anger") col(1) region(color(none))) title("Anger (R)") xtitle("Ambivalence", size(3)) ytitle("Attitude Strength", size(3)) graphregion(color(white)) bgcolor(white) saving(angryR,replace)

gr combine enthusiasmD.gph enthusiasmR.gph , rows(1) graphregion(color(white))

***Figure 4A***

gr combine afraidD.gph angryD.gph afraidR.gph angryR.gph , rows(2) graphregion(color(white))



***Figure 4: Non-Attitudes***

probit demcand_neutral i.afraidD##c.ambivdemcand2 i.angryD##c.ambivdemcand2 i.enthusiasmD2##c.ambivdemcand2 pid2 pidst education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 [pweight = VCF0009]
margins enthusiasmD2, at (ambivdemcand2 = (0(.2)1) afraidD=0 angryD=0)
marginsplot, plot1opts(lpattern("dot") lcolor(black) mcolor(black)) ci1opts(lcolor(black)) plot2opts(lpattern("dash") lcolor(black) mcolor(black) msymbol(square)) ci2opts(lcolor(black)) plot3opts(lpattern("solid") lcolor(black) mcolor(black) msymbol(diamond)) ci3opts(lcolor(black)) ylabel(0(.2)1) legend(col(1) region(color(none))) title("Democratic Candidate") xtitle("Ambivalence", size(3)) graphregion(color(white)) bgcolor(white) ytitle("Pr(Non-Attitude)", size(3)) saving(enthusiasmD, replace)
margins afraidD, at (ambivdemcand2 = (0(.2)1) enthusiasmD2=0 angryD=0)
marginsplot, ylabel(0(.2)1) legend(order(1 "No Fear" 2 "Fear") col(1) region(color(none))) title("Fear (D)") xtitle("Ambivalence", size(3)) ytitle("Pr(Non-Attitude)", size(3)) graphregion(color(white)) bgcolor(white) saving(afraidD,replace)
margins angryD, at (ambivdemcand2 = (0(.2)1) enthusiasmD2=0 afraidD=0)
marginsplot, ylabel(0(.2)1) legend(order(1 "No Anger" 2 "Anger") col(1) region(color(none))) title("Anger (D)") xtitle("Ambivalence", size(3)) ytitle("Pr(Non-Attitude)", size(3)) graphregion(color(white)) bgcolor(white) saving(angryD,replace)


probit repcand_neutral i.afraidR##c.ambivrepcand2 i.angryR##c.ambivrepcand2 i.enthusiasmR2##c.ambivrepcand2 pid2 pidst education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 [pweight = VCF0009]
margins enthusiasmR2, at (ambivrepcand2 = (0(.2)1) afraidR=0 angryR=0)
marginsplot, plot1opts(lpattern("dot") lcolor(black) mcolor(black)) ci1opts(lcolor(black)) plot2opts(lpattern("dash") lcolor(black) mcolor(black) msymbol(square)) ci2opts(lcolor(black)) plot3opts(lpattern("solid") lcolor(black) mcolor(black) msymbol(diamond)) ci3opts(lcolor(black)) ylabel(0(.2)1) legend(col(1) region(color(none))) title("Republican Candidate") xtitle("Ambivalence", size(3)) ytitle("Pr(Non-Attitude)", size(3)) graphregion(color(white)) bgcolor(white) saving(enthusiasmR, replace)
margins afraidR, at (ambivrepcand2 = (0(.2)1) enthusiasmR2=0 angryR=0)
marginsplot, ylabel(0(.2)1) legend(order(1 "No Fear" 2 "Fear") col(1) region(color(none))) title("Fear (R)") xtitle("Ambivalence", size(3)) ytitle("Pr(Non-Attitude)", size(3)) graphregion(color(white)) bgcolor(white) saving(afraidR,replace)
margins angryR, at (ambivrepcand2 = (0(.2)1) enthusiasmR2=0 afraidR=0)
marginsplot, ylabel(0(.2)1) legend(order(1 "No Anger" 2 "Anger") col(1) region(color(none))) title("Anger (R)") xtitle("Ambivalence", size(3)) ytitle("Pr(Non-Attitude)", size(3)) graphregion(color(white)) bgcolor(white) saving(angryR,replace)

gr combine enthusiasmD.gph enthusiasmR.gph, rows(1) graphregion(color(white))

***Figure 5A***

gr combine afraidD.gph angryD.gph afraidR.gph angryR.gph, rows(2) graphregion(color(white))



***Figure 5: Abstention***

probit abstention i.afraidD##c.ambivdemcand2 i.angryD##c.ambivdemcand2 i.enthusiasmD2##c.ambivdemcand2 i.afraidR##c.ambivrepcand2 i.angryR##c.ambivrepcand2 i.enthusiasmR2##c.ambivrepcand2 income3 pid2 pidst education2 knowledge interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 [pweight = VCF0009]

margins enthusiasmD2, at(ambivdemcand2 = (0(.2)1) afraidD=0 angryD=0 enthusiasmR=0 afraidR=0 angryR=0)
marginsplot, plot1opts(lpattern("dot") lcolor(black) mcolor(black)) ci1opts(lcolor(black)) plot2opts(lpattern("dash") lcolor(black) mcolor(black) msymbol(square)) ci2opts(lcolor(black)) plot3opts(lpattern("solid") lcolor(black) mcolor(black) msymbol(diamond)) ci3opts(lcolor(black)) legend(col(1) region(color(none))) title("Democratic Candidate") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2).6, axis(1) labsize(4)) graphregion(color(white)) bgcolor(white) saving(enthusiasmD, replace)
margins enthusiasmR2, at(ambivrepcand2 = (0(.2)1) afraidR=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0)
marginsplot, plot1opts(lpattern("dot") lcolor(black) mcolor(black)) ci1opts(lcolor(black)) plot2opts(lpattern("dash") lcolor(black) mcolor(black) msymbol(square)) ci2opts(lcolor(black)) plot3opts(lpattern("solid") lcolor(black) mcolor(black) msymbol(diamond)) ci3opts(lcolor(black)) legend(col(1) region(color(none))) title("Republican Candidate") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2).6, axis(1) labsize(4)) graphregion(color(white)) bgcolor(white) saving(enthusiasmR, replace)

margins, at (ambivdemcand2 = (0(.2)1) afraidD=0 angryD=0 enthusiasmR2=0 afraidR=0 angryR=0) dydx(enthusiasmD2) 
marginsplot, plot( , label("Some Enthusiasm" "High Enthusiasm ")) legend(col(1) region(color(none))) plot1opts(lpattern("dash") lcolor(black) mcolor(black) msymbol(square)) ci1opts(lcolor(black)) plot2opts(lpattern("solid") lcolor(black) mcolor(black) msymbol(diamond)) ci2opts(lcolor(black)) title("Democratic Candidates") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Marginal Effect", size(4)) ylabel(-.4(.2).2, axis(1) labsize(4)) yline(0) graphregion(color(white)) bgcolor(white) saving(enthusiasmD2, replace)
margins, at (ambivrepcand2 = (0(.2)1) afraidR=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0) dydx(enthusiasmR2) 
marginsplot, plot( , label("Some Enthusiasm" "High Enthusiasm ")) legend(col(1) region(color(none))) plot1opts(lpattern("dash") lcolor(black) mcolor(black) msymbol(square)) ci1opts(lcolor(black)) plot2opts(lpattern("solid") lcolor(black) mcolor(black) msymbol(diamond)) ci2opts(lcolor(black)) legend(col(1) region(color(none))) title("Republican Candidates") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Marginal Effect", size(4)) ylabel(-.4(.2).2, axis(1) labsize(4)) yline(0) graphregion(color(white)) bgcolor(white) saving(enthusiasmR2, replace)

margins afraidD, at(ambivdemcand2 = (0(.2)1) enthusiasmD2=0 angryD=0 enthusiasmR=0 afraidR=0 angryR=0)
marginsplot, legend(order(1 "No Fear" 2 "Fear") col(1) region(color(none))) title("Fear (D)") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2).6, axis(1) labsize(4)) graphregion(color(white)) bgcolor(white) saving(afraidD,replace)
margins angryD, at(ambivdemcand2 = (0(.2)1) enthusiasmD2=0 afraidD=0 enthusiasmR=0 afraidR=0 angryR=0)
marginsplot, legend(order(1 "No Anger" 2 "Anger") col(1) region(color(none))) title("Anger (D)") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2).6, axis(1) labsize(4)) graphregion(color(white)) bgcolor(white) saving(angryD,replace)
margins afraidR, at(ambivrepcand2 = (0(.2)1) enthusiasmR2=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0)
marginsplot, legend(order(1 "No Fear" 2 "Fear") col(1) region(color(none))) title("Fear (R)") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2).6, axis(1) labsize(4)) graphregion(color(white)) bgcolor(white) saving(afraidR,replace)
margins angryR, at(ambivrepcand2 = (0(.2)1) enthusiasmR2=0 afraidR=0 enthusiasmD2=0 afraidD=0 angryD=0)
marginsplot, legend(order(1 "No Anger" 2 "Anger") col(1) region(color(none))) title("Anger (R)") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2).6, axis(1) labsize(4)) graphregion(color(white)) bgcolor(white) saving(angryR,replace)
 
margins, at (ambivdemcand2 = (0(.2)1) enthusiasmD=0 angryD=0 enthusiasmR2=0 afraidR=0 angryR=0) dydx(afraidD) 
marginsplot,  legend(off) title("Fear (D)") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Marginal Effect", size(4)) ylabel(-.4(.2).2, axis(1) labsize(4)) yline(0) graphregion(color(white)) bgcolor(white) saving(afraidD2, replace)
margins, at (ambivdemcand2 = (0(.2)1) enthusiasmD=0 afraidD=0 enthusiasmR2=0 afraidR=0 angryR=0) dydx(angryD) 
marginsplot,  legend(off) title("Anger (D)") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Marginal Effect", size(4)) ylabel(-.4(.2).2, axis(1) labsize(4)) yline(0) graphregion(color(white)) bgcolor(white) saving(angryD2, replace)
margins, at (ambivrepcand2 = (0(.2)1) enthusiasmR=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0) dydx(afraidR) 
marginsplot,  legend(off) title("Fear (R)") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Marginal Effect", size(4)) ylabel(-.4(.2).2, axis(1) labsize(4)) yline(0) graphregion(color(white)) bgcolor(white) saving(afraidR2, replace)
margins, at (ambivrepcand2 = (0(.2)1) enthusiasmR=0 afraidR=0 enthusiasmD2=0 afraidD=0 angryD=0) dydx(angryR) 
marginsplot,  legend(off) title("Anger (R)") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Marginal Effect", size(4)) ylabel(-.4(.2).2, axis(1) labsize(4)) yline(0) graphregion(color(white)) bgcolor(white) saving(angryR2, replace)

gr combine enthusiasmD.gph enthusiasmR.gph, rows(1) graphregion(color(white)) 
gr combine enthusiasmD2.gph enthusiasmR2.gph, rows(1) graphregion(color(white))

***Figure 6A*** 

gr combine afraidD.gph angryD.gph afraidR.gph angryR.gph, rows(2) graphregion(color(white))

***Figure 7A*** 

gr combine afraidD2.gph angryD2.gph afraidR2.gph angryR2.gph, rows(2) graphregion(color(white))



***Figure 6: Abstention by Income***

probit abstention i.income3##i.afraidD##c.ambivdemcand2 i.income3##i.angryD##c.ambivdemcand2 i.income3##i.enthusiasmD2##c.ambivdemcand2 i.income3##i.afraidR##c.ambivrepcand2 i.income3##i.angryR##c.ambivrepcand2 i.income3##i.enthusiasmR2##c.ambivrepcand2 pid2 pidst education2 knowledge interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 [pweight = VCF0009]
margins enthusiasmD2, over(income3) at (ambivdemcand2 = (0(.2)1) afraidD=0 angryD=0 enthusiasmR2=0 afraidR=0 angryR=0)
marginsplot, plot1opts(lpattern("dot") lcolor(black) mcolor(black)) ci1opts(lcolor(black)) plot2opts(lpattern("dash") lcolor(black) mcolor(black) msymbol(square)) ci2opts(lcolor(black)) plot3opts(lpattern("solid") lcolor(black) mcolor(black) msymbol(diamond)) ci3opts(lcolor(black))  legend(col(3) region(color(none))) by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop(graphregion(color(white)) title("Democratic Candidates") rows(1)) title("") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2)1, axis(1) labsize(4)) subtitle(, fcol(none) nobox)
margins, dydx(enthusiasmD2) at(ambivdemcand2=(0(.2)1) afraidD=0 angryD=0 enthusiasmR2=0 afraidR=0 angryR=0) over(income3)
marginsplot, by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) plot( , label("Some Enthusiasm" "High Enthusiasm ")) plot1opts(lpattern("dash") lcolor(black) mcolor(black) msymbol(square)) ci1opts(lcolor(black)) plot2opts(lpattern("solid") lcolor(black) mcolor(black) msymbol(diamond)) ci2opts(lcolor(black))  byop(graphregion(color(white)) title("Democratic Candidates") rows(1)) legend(region(color(none))) title("") xtitle("Ambivalence") ytitle("Marginal Effect", size(4)) ylabel(-.5(.25).5, axis(1) labsize(4)) yline(0) subtitle(, fcol(none) nobox)

margins enthusiasmR2, over(income3) at (ambivrepcand2 = (0(.2)1) afraidR=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0)
marginsplot, plot1opts(lpattern("dot") lcolor(black) mcolor(black)) ci1opts(lcolor(black)) plot2opts(lpattern("dash") lcolor(black) mcolor(black) msymbol(square)) ci2opts(lcolor(black)) plot3opts(lpattern("solid") lcolor(black) mcolor(black) msymbol(diamond)) ci3opts(lcolor(black)) legend(col(3) region(color(none))) by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop(graphregion(color(white)) bgcolor(white) title("Republican Candidates") rows(1)) title("") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2)1, axis(1) labsize(4)) subtitle(, fcol(none) nobox)
margins, dydx(enthusiasmR2) at(ambivrepcand2=(0(.2)1) afraidR=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0) over(income3)
marginsplot, by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) plot( , label("Some Enthusiasm" "High Enthusiasm ")) plot1opts(lpattern("dash") lcolor(black) mcolor(black) msymbol(square)) ci1opts(lcolor(black)) plot2opts(lpattern("solid") lcolor(black) mcolor(black) msymbol(diamond)) ci2opts(lcolor(black))  byop( graphregion(color(white)) title("Republican Candidates") rows(1)) legend(region(color(none))) title("") xtitle("Ambivalence") ytitle("Marginal Effect", size(4)) ylabel(-.5(.25).5, axis(1) labsize(4)) yline(0) subtitle(, fcol(none) nobox)

***Figure 8A***

margins afraidD, over(income3) at (ambivdemcand2 = (0(.2)1) enthusiasmD2=0 angryD=0 enthusiasmR2=0 afraidR=0 angryR=0)
marginsplot, legend(order(1 "No Fear" 2 "Fear") col(1) region(color(none))) by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop(graphregion(color(white)) title("Democratic Candidates") rows(1)) title("") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2)1, axis(1) labsize(4)) subtitle(, fcol(none) nobox)
margins afraidR, over(income3) at (ambivrepcand2 = (0(.2)1) enthusiasmR2=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0)
marginsplot, legend(order(1 "No Fear" 2 "Fear") col(3) region(color(none))) by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop(graphregion(color(white)) bgcolor(white) title("Republican Candidates") rows(1)) title("") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2)1, axis(1) labsize(4)) subtitle(, fcol(none) nobox)

margins angryD, over(income3) at (ambivdemcand2 = (0(.2)1) enthusiasmD2=0 afraidD=0 enthusiasmR2=0 afraidR=0 angryR=0)
marginsplot, legend(order(1 "No Anger" 2 "Anger") col(1) region(color(none))) by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop(graphregion(color(white)) title("Democratic Candidates") rows(1)) title("") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2)1, axis(1) labsize(4)) subtitle(, fcol(none) nobox)
margins angryR, over(income3) at (ambivrepcand2 = (0(.2)1) enthusiasmR2=0 afraidR=0 enthusiasmD2=0 afraidD=0 angryD=0)
marginsplot, legend(order(1 "No Anger" 2 "Anger") col(3) region(color(none))) by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop(graphregion(color(white)) bgcolor(white) title("Republican Candidates") rows(1)) title("") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2)1, axis(1) labsize(4)) subtitle(, fcol(none) nobox)

***Figure 9A***

margins, dydx(afraidD) at(ambivdemcand2=(0(.2)1) enthusiasmD2=0 angryD=0 enthusiasmR2=0 afraidR=0 angryR=0) over(income3)
marginsplot, by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop(graphregion(color(white)) title("Democratic Candidates") rows(1)) legend(order(1 "Fear") region(color(none))) title("") xtitle("Ambivalence") ytitle("Marginal Effect", size(4)) ylabel(-.5(.25).5, axis(1) labsize(4)) yline(0) subtitle(, fcol(none) nobox)
margins, dydx(afraidR) at(ambivrepcand2=(0(.2)1) enthusiasmR2=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0) over(income3)
marginsplot, by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop( graphregion(color(white)) title("Republican Candidates") rows(1)) legend(order(1 "Fear")region(color(none))) title("") xtitle("Ambivalence") ytitle("Marginal Effect", size(4)) ylabel(-.5(.25).5, axis(1) labsize(4)) yline(0) subtitle(, fcol(none) nobox)

margins, dydx(angryD) at(ambivdemcand2=(0(.2)1) enthusiasmD2=0 afraidD=0 enthusiasmR2=0 afraidR=0 angryR=0) over(income3)
marginsplot, by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop(graphregion(color(white)) title("Democratic Candidates") rows(1)) legend(order(1 "Anger") region(color(none))) title("") xtitle("Ambivalence") ytitle("Marginal Effect", size(4)) ylabel(-.5(.25).5, axis(1) labsize(4)) yline(0) subtitle(, fcol(none) nobox)
margins, dydx(angryR) at(ambivrepcand2=(0(.2)1) enthusiasmR2=0 afraidR=0 enthusiasmD2=0 afraidD=0 angryD=0) over(income3)
marginsplot, by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop( graphregion(color(white)) title("Republican Candidates") rows(1)) legend(order(1 "Anger")region(color(none))) title("") xtitle("Ambivalence") ytitle("Marginal Effect", size(4)) ylabel(-.5(.25).5, axis(1) labsize(4)) yline(0) subtitle(, fcol(none) nobox)


***Table 9a***

gen demlikes_open =.
recode demlikes_open .=1 if VCF0476b ==11 | VCF0477b==11 | VCF0478b==11 | VCF0479b==11 | VCF0480b==11
recode demlikes_open .=2 if VCF0476b ==12 | VCF0477b==12 | VCF0478b==12 | VCF0479b==12 | VCF0480b==12
recode demlikes_open .=3 if VCF0476b ==21 | VCF0477b==21 | VCF0478b==21 | VCF0479b==21 | VCF0480b==21
recode demlikes_open .=4 if VCF0476b ==22 | VCF0477b==22 | VCF0478b==22 | VCF0479b==22 | VCF0480b==22
recode demlikes_open .=5 if VCF0476b ==23 | VCF0477b==23 | VCF0478b==23 | VCF0479b==23 | VCF0480b==23
recode demlikes_open .=6 if VCF0476b ==24 | VCF0477b==24 | VCF0478b==24 | VCF0479b==24 | VCF0480b==24
recode demlikes_open .=7 if VCF0476b ==31 | VCF0477b==31 | VCF0478b==31 | VCF0479b==31 | VCF0480b==31
recode demlikes_open .=8 if VCF0476b ==32 | VCF0477b==32 | VCF0478b==32 | VCF0479b==32 | VCF0480b==32
recode demlikes_open .=9 if VCF0476b ==33 | VCF0477b==33 | VCF0478b==33 | VCF0479b==33 | VCF0480b==33
recode demlikes_open .=10 if VCF0476b ==34 | VCF0477b==34 | VCF0478b==34 | VCF0479b==34 | VCF0480b==34
recode demlikes_open .=11 if VCF0476b ==35 | VCF0477b==35 | VCF0478b==35 | VCF0479b==35 | VCF0480b==35
recode demlikes_open .=12 if VCF0476b ==40 | VCF0477b==40 | VCF0478b==40 | VCF0479b==40 | VCF0480b==40

gen demdislikes_open =.
recode demdislikes_open .=1 if VCF0482b ==11 | VCF0483b==11 | VCF0484b==11 | VCF0485b==11 | VCF0486b==11
recode demdislikes_open .=2 if VCF0482b ==12 | VCF0483b==12 | VCF0484b==12 | VCF0485b==12 | VCF0486b==12
recode demdislikes_open .=3 if VCF0482b ==21 | VCF0483b==21 | VCF0484b==21 | VCF0485b==21 | VCF0486b==21
recode demdislikes_open .=4 if VCF0482b ==22 | VCF0483b==22 | VCF0484b==22 | VCF0485b==22 | VCF0486b==22
recode demdislikes_open .=5 if VCF0482b ==23 | VCF0483b==23 | VCF0484b==23 | VCF0485b==23 | VCF0486b==23
recode demdislikes_open .=6 if VCF0482b ==24 | VCF0483b==24 | VCF0484b==24 | VCF0485b==24 | VCF0486b==24
recode demdislikes_open .=7 if VCF0482b ==31 | VCF0483b==31 | VCF0484b==31 | VCF0485b==31 | VCF0486b==31
recode demdislikes_open .=8 if VCF0482b ==32 | VCF0483b==32 | VCF0484b==32 | VCF0485b==32 | VCF0486b==32
recode demdislikes_open .=9 if VCF0482b ==33 | VCF0483b==33 | VCF0484b==33 | VCF0485b==33 | VCF0486b==33
recode demdislikes_open .=10 if VCF0482b ==34 | VCF0483b==34 | VCF0484b==34 | VCF0485b==34 | VCF0486b==34
recode demdislikes_open .=11 if VCF0482b ==35 | VCF0483b==35 | VCF0484b==35 | VCF0485b==35 | VCF0486b==35
recode demdislikes_open .=12 if VCF0482b ==40 | VCF0483b==40 | VCF0484b==40 | VCF0485b==40 | VCF0486b==40

gen replikes_open =.
recode replikes_open .=1 if VCF0488b ==11 | VCF0489b==11 | VCF0490b==11 | VCF0491b==11 | VCF0492b==11
recode replikes_open .=2 if VCF0488b ==12 | VCF0489b==12 | VCF0490b==12 | VCF0491b==12 | VCF0492b==12
recode replikes_open .=3 if VCF0488b ==21 | VCF0489b==21 | VCF0490b==21 | VCF0491b==21 | VCF0492b==21
recode replikes_open .=4 if VCF0488b ==22 | VCF0489b==22 | VCF0490b==22 | VCF0491b==22 | VCF0492b==22
recode replikes_open .=5 if VCF0488b ==23 | VCF0489b==23 | VCF0490b==23 | VCF0491b==23 | VCF0492b==23
recode replikes_open .=6 if VCF0488b ==24 | VCF0489b==24 | VCF0490b==24 | VCF0491b==24 | VCF0492b==24
recode replikes_open .=7 if VCF0488b ==31 | VCF0489b==31 | VCF0490b==31 | VCF0491b==31 | VCF0492b==31
recode replikes_open .=8 if VCF0488b ==32 | VCF0489b==32 | VCF0490b==32 | VCF0491b==32 | VCF0492b==32
recode replikes_open .=9 if VCF0488b ==33 | VCF0489b==33 | VCF0490b==33 | VCF0491b==33 | VCF0492b==33
recode replikes_open .=10 if VCF0488b ==34 | VCF0489b==34 | VCF0490b==34 | VCF0491b==34 | VCF0492b==34
recode replikes_open .=11 if VCF0488b ==35 | VCF0489b==35 | VCF0490b==35 | VCF0491b==35 | VCF0492b==35
recode replikes_open .=12 if VCF0488b ==40 | VCF0489b==40 | VCF0490b==40 | VCF0491b==40 | VCF0492b==40

gen repdislikes_open =.
recode repdislikes_open .=1 if VCF0494b ==11 | VCF0495b==11 | VCF0496b==11 | VCF0497b==11 | VCF0498b==11
recode repdislikes_open .=2 if VCF0494b ==12 | VCF0495b==12 | VCF0496b==12 | VCF0497b==12 | VCF0498b==12
recode repdislikes_open .=3 if VCF0494b ==21 | VCF0495b==21 | VCF0496b==21 | VCF0497b==21 | VCF0498b==21
recode repdislikes_open .=4 if VCF0494b ==22 | VCF0495b==22 | VCF0496b==22 | VCF0497b==22 | VCF0498b==22
recode repdislikes_open .=5 if VCF0494b ==23 | VCF0495b==23 | VCF0496b==23 | VCF0497b==23 | VCF0498b==23
recode repdislikes_open .=6 if VCF0494b ==24 | VCF0495b==24 | VCF0496b==24 | VCF0497b==24 | VCF0498b==24
recode repdislikes_open .=7 if VCF0494b ==31 | VCF0495b==31 | VCF0496b==31 | VCF0497b==31 | VCF0498b==31
recode repdislikes_open .=8 if VCF0494b ==32 | VCF0495b==32 | VCF0496b==32 | VCF0497b==32 | VCF0498b==32
recode repdislikes_open .=9 if VCF0494b ==33 | VCF0495b==33 | VCF0496b==33 | VCF0497b==33 | VCF0498b==33
recode repdislikes_open .=10 if VCF0494b ==34 | VCF0495b==34 | VCF0496b==34 | VCF0497b==34 | VCF0498b==34
recode repdislikes_open .=11 if VCF0494b ==35 | VCF0495b==35 | VCF0496b==35 | VCF0497b==35 | VCF0498b==35
recode repdislikes_open .=12 if VCF0494b ==40 | VCF0495b==40 | VCF0496b==40 | VCF0497b==40 | VCF0498b==40

gen demlikes_open2 = demlikes_open
recode demlikes_open2 1/2=3 3/6=1 7/8=3 9/10=2 11/12=3 

gen demdislikes_open2 = demdislikes_open
recode demdislikes_open2 1/2=3 3/6=1 7/8=3 9/10=2 11/12=3 


gen replikes_open2 = replikes_open
recode replikes_open2 1/2=3 3/6=1 7/8=3 9/10=2 11/12=3 

gen repdislikes_open2 = repdislikes_open
recode repdislikes_open2 1/2=3 3/6=1 7/8=3 9/10=2 11/12=3 

gen year = VCF0004

gen likes_open =.
recode likes_open .=1 if demlikes_open2 ==1 | replikes_open2==1
recode likes_open .=2 if demlikes_open2 ==2 | replikes_open2==2
recode likes_open .=3 if demlikes_open2 ==3 | replikes_open2==3
tab likes_open if year >1979 & year<2005

gen dislikes_open =.
recode dislikes_open .=1 if demdislikes_open2 ==1 | repdislikes_open2==1
recode dislikes_open .=2 if demdislikes_open2 ==2 | repdislikes_open2==2
recode dislikes_open .=3 if demdislikes_open2 ==3 | repdislikes_open2==3
tab dislikes_open if year >1979 & year<2005



***Figure 1a***

hist ambivdemcand2 if year ==1980, discrete ylabel(0(1)4) fcolor(gray) lcolor(black) xtitle("Ambivalence") subtitle(Carter '80, fcolor(white) lcolor(white)) graphregion(color(white)) bgcolor(white) saving(demhist80, replace)
hist ambivrepcand2 if year ==1980, discrete ylabel(0(1)4) fcolor(gray) lcolor(black) xtitle("Ambivalence") subtitle(Reagan '80, fcolor(white) lcolor(white)) graphregion(color(white)) bgcolor(white) saving(rephist80, replace)

hist ambivdemcand2 if year ==1984, discrete ylabel(0(1)4) fcolor(gray) lcolor(black) xtitle("Ambivalence") subtitle(Mondale '84, fcolor(white) lcolor(white)) graphregion(color(white)) bgcolor(white) saving(demhist84, replace)
hist ambivrepcand2 if year ==1984, discrete ylabel(0(1)4) fcolor(gray) lcolor(black) xtitle("Ambivalence") subtitle(Reagan '84, fcolor(white) lcolor(white)) graphregion(color(white)) bgcolor(white) saving(rephist84, replace)

hist ambivdemcand2 if year ==1988, discrete ylabel(0(1)4) fcolor(gray) lcolor(black) xtitle("Ambivalence") subtitle(Dukakis '88, fcolor(white) lcolor(white)) graphregion(color(white)) bgcolor(white) saving(demhist88, replace)
hist ambivrepcand2 if year ==1988, discrete ylabel(0(1)4) fcolor(gray) lcolor(black) xtitle("Ambivalence") subtitle(Bush '88, fcolor(white) lcolor(white)) graphregion(color(white)) bgcolor(white) saving(rephist88, replace)

hist ambivdemcand2 if year ==1992, discrete ylabel(0(1)4) fcolor(gray) lcolor(black) xtitle("Ambivalence") subtitle(Clinton '92, fcolor(white) lcolor(white)) graphregion(color(white)) bgcolor(white) saving(demhist92, replace)
hist ambivrepcand2 if year ==1992, discrete ylabel(0(1)4) fcolor(gray) lcolor(black) xtitle("Ambivalence") subtitle(Bush '92, fcolor(white) lcolor(white)) graphregion(color(white)) bgcolor(white) saving(rephist92, replace)

hist ambivdemcand2 if year ==1996, discrete ylabel(0(1)4) fcolor(gray) lcolor(black) xtitle("Ambivalence") subtitle(Clinton '96, fcolor(white) lcolor(white)) graphregion(color(white)) bgcolor(white) saving(demhist96, replace)
hist ambivrepcand2 if year ==1996, discrete ylabel(0(1)4) fcolor(gray) lcolor(black) xtitle("Ambivalence") subtitle(Dole '96, fcolor(white) lcolor(white)) graphregion(color(white)) bgcolor(white) saving(rephist96, replace)

hist ambivdemcand2 if year ==2000, discrete ylabel(0(1)4) fcolor(gray) lcolor(black) xtitle("Ambivalence") subtitle(Gore '00, fcolor(white) lcolor(white)) graphregion(color(white)) bgcolor(white) saving(demhist00, replace)
hist ambivrepcand2 if year ==2000, discrete ylabel(0(1)4) fcolor(gray) lcolor(black) xtitle("Ambivalence") subtitle(Bush '00, fcolor(white) lcolor(white)) graphregion(color(white)) bgcolor(white) saving(rephist00, replace)

hist ambivdemcand2 if year ==2004, discrete ylabel(0(1)4) fcolor(gray) lcolor(black) xtitle("Ambivalence") subtitle(Kerry '04, fcolor(white) lcolor(white)) graphregion(color(white)) bgcolor(white) saving(demhist04, replace)
hist ambivrepcand2 if year ==2004, discrete ylabel(0(1)4) fcolor(gray) lcolor(black) xtitle("Ambivalence") subtitle(Bush '04, fcolor(white) lcolor(white)) graphregion(color(white)) bgcolor(white) saving(rephist04, replace)

gr combine demhist80.gph rephist80.gph demhist84.gph rephist84.gph demhist88.gph rephist88.gph demhist92.gph rephist92.gph demhist96.gph rephist96.gph demhist00.gph rephist00.gph demhist04.gph rephist04.gph, graphregion(color(white)) rows (3) 



***Figure 2a***

hist ambivdemcand2, freq fcolor(gray) lcolor(black) xtitle("Ambivalence Toward Democrat") subtitle(, fcolor(white) lcolor(white)) discrete by(income3, rows(1) note("") graphregion(color(white)) bgcolor(white)) saving(demhistInc, replace)
hist ambivrepcand2, freq fcolor(gray) lcolor(black) xtitle("Ambivalence Toward Republican") subtitle(, fcolor(white) lcolor(white)) discrete by(income3, rows(1) note("") graphregion(color(white)) bgcolor(white)) saving(rephistInc, replace)
gr combine demhistInc.gph rephistInc.gph, graphregion(color(white)) rows (2)



***Figure 3a***

hist ambivdemcand2, freq fcolor(gray) lcolor(black) xtitle("Ambivalence Toward Democrat") subtitle(, fcolor(white) lcolor(white)) discrete by(afraidD, rows(1) note("") graphregion(color(white)) bgcolor(white)) saving(demhistF, replace)
hist ambivrepcand2, freq fcolor(gray) lcolor(black) xtitle("Ambivalence Toward Republican")subtitle(, fcolor(white) lcolor(white)) discrete by(afraidR, rows(1) note("") graphregion(color(white)) bgcolor(white)) saving(rephistF, replace)
hist ambivdemcand2, freq fcolor(gray) lcolor(black) xtitle("Ambivalence Toward Democrat") subtitle(, fcolor(white) lcolor(white)) discrete by(angryD, rows(1) note("") graphregion(color(white)) bgcolor(white)) saving(demhistA, replace)
hist ambivrepcand2, freq fcolor(gray) lcolor(black) xtitle("Ambivalence Toward Republican")subtitle(, fcolor(white) lcolor(white)) discrete by(angryR, rows(1) note("") graphregion(color(white)) bgcolor(white)) saving(rephistA, replace)
gr combine demhistF.gph rephistF.gph demhistA.gph rephistA.gph, graphregion(color(white)) rows (2)  


***See Code Above for Figures 4a-9a***

***Table 10A***

reg demcandthermst2 i.enthusiasmD2##c.ambivdemcand2 i.afraidD##c.ambivdemcand2 i.angryD##c.ambivdemcand2 pid2 pidst education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 [pweight = VCF0009]
reg repcandthermst2 i.enthusiasmR2##c.ambivrepcand2 i.afraidR##c.ambivrepcand2 i.angryR##c.ambivrepcand2 pid2 pidst education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 [pweight = VCF0009]

probit demcand_neutral i.enthusiasmD2##c.ambivdemcand2 i.afraidD##c.ambivdemcand2 i.angryD##c.ambivdemcand2 pid2 pidst education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 [pweight = VCF0009]
probit repcand_neutral i.enthusiasmR2##c.ambivrepcand2 i.afraidR##c.ambivrepcand2 i.angryR##c.ambivrepcand2 pid2 pidst education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 [pweight = VCF0009]



***Table 11A***

probit abstention i.enthusiasmD2##c.ambivdemcand2 i.afraidD##c.ambivdemcand2 i.angryD##c.ambivdemcand2 i.enthusiasmR2##c.ambivrepcand2 i.afraidR##c.ambivrepcand2 i.angryR##c.ambivrepcand2 income3 pid2 pidst education2 knowledge interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 [pweight = VCF0009]
probit abstention i.enthusiasmD2##c.ambivdemcand2 i.afraidD##c.ambivdemcand2 i.angryD##c.ambivdemcand2 i.enthusiasmR2##c.ambivrepcand2 i.afraidR##c.ambivrepcand2 i.angryR##c.ambivrepcand2 income3 pid2 pidst education2 knowledge interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 if income3==0 [pweight = VCF0009]
probit abstention i.enthusiasmD2##c.ambivdemcand2 i.afraidD##c.ambivdemcand2 i.angryD##c.ambivdemcand2 i.enthusiasmR2##c.ambivrepcand2 i.afraidR##c.ambivrepcand2 i.angryR##c.ambivrepcand2 income3 pid2 pidst education2 knowledge interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 if income3==1 [pweight = VCF0009]
probit abstention i.enthusiasmD2##c.ambivdemcand2 i.afraidD##c.ambivdemcand2 i.angryD##c.ambivdemcand2 i.enthusiasmR2##c.ambivrepcand2 i.afraidR##c.ambivrepcand2 i.angryR##c.ambivrepcand2 income3 pid2 pidst education2 knowledge interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 if income3==2 [pweight = VCF0009]



***Table 12A***

reg demcandthermst2 i.enthusiasmD2##c.ambivdemcand2 i.afraidD##c.ambivdemcand2 i.angryD##c.ambivdemcand2 pid2 pidst education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 [pweight = VCF0009]
estat vif
reg repcandthermst2 i.enthusiasmR2##c.ambivrepcand2 i.afraidR##c.ambivrepcand2 i.angryR##c.ambivrepcand2 pid2 pidst education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 [pweight = VCF0009]
estat vif



***Table 13A***

gen enthusiasmD = enthusiasmD2/2
gen enthusiasmR = enthusiasmR2/2
gen enthusiasmD_ambivdemcand2 = enthusiasmD*ambivdemcand2
gen afraidD_ambivdemcand2 = afraidD*ambivdemcand2
gen angryD_ambivdemcand2 = angryD*ambivdemcand2
gen enthusiasmR_ambivrepcand2 = enthusiasmR*ambivrepcand2
gen afraidR_ambivrepcand2 = afraidR*ambivrepcand2
gen angryR_ambivrepcand2 = angryR*ambivrepcand2

reg demcandthermst2 ambivdemcand2 afraidD afraidD_ambivdemcand2 angryD angryD_ambivdemcand2 enthusiasmD enthusiasmD_ambivdemcand2 pid2 pidst education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 [pweight = VCF0009]
reg repcandthermst2 ambivrepcand2 afraidR afraidR_ambivrepcand2 angryR angryR_ambivrepcand2 enthusiasmR enthusiasmR_ambivrepcand2 pid2 pidst education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 [pweight = VCF0009]

probit demcand_neutral ambivdemcand2 afraidD afraidD_ambivdemcand2 angryD angryD_ambivdemcand2 enthusiasmD enthusiasmD_ambivdemcand2 pid2 pidst education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 [pweight = VCF0009]
probit repcand_neutral ambivrepcand2 afraidR afraidR_ambivrepcand2 angryR angryR_ambivrepcand2 enthusiasmR enthusiasmR_ambivrepcand2 pid2 pidst education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 [pweight = VCF0009]


***Table 14A***

probit abstention ambivdemcand2 afraidD afraidD_ambivdemcand2 angryD angryD_ambivdemcand2 enthusiasmD enthusiasmD_ambivdemcand2 ambivrepcand2 afraidR afraidR_ambivrepcand2 angryR angryR_ambivrepcand2 enthusiasmR enthusiasmR_ambivrepcand2 income3 pid2 pidst education2 knowledge interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 [pweight = VCF0009]

probit abstention ambivdemcand2 afraidD afraidD_ambivdemcand2 angryD angryD_ambivdemcand2 enthusiasmD enthusiasmD_ambivdemcand2 ambivrepcand2 afraidR afraidR_ambivrepcand2 angryR angryR_ambivrepcand2 enthusiasmR enthusiasmR_ambivrepcand2 pid2 pidst education2 knowledge interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 if income3==0 [pweight = VCF0009]
probit abstention ambivdemcand2 afraidD afraidD_ambivdemcand2 angryD angryD_ambivdemcand2 enthusiasmD enthusiasmD_ambivdemcand2 ambivrepcand2 afraidR afraidR_ambivrepcand2 angryR angryR_ambivrepcand2 enthusiasmR enthusiasmR_ambivrepcand2 pid2 pidst education2 knowledge interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 if income3==1 [pweight = VCF0009]
probit abstention ambivdemcand2 afraidD afraidD_ambivdemcand2 angryD angryD_ambivdemcand2 enthusiasmD enthusiasmD_ambivdemcand2 ambivrepcand2 afraidR afraidR_ambivrepcand2 angryR angryR_ambivrepcand2 enthusiasmR enthusiasmR_ambivrepcand2 pid2 pidst education2 knowledge interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 if income3==2 [pweight = VCF0009]



***Robustness Checks 1: Figure 10A-14A***

***Attitude Strength*** 

reg demcandthermst2 i.afraidD##c.ambivdemcand2 i.angryD##c.ambivdemcand2 i.enthusiasmD2##c.ambivdemcand2 pid2 pidst education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 if ambivdemcand2<.5 [pweight = VCF0009]
margins enthusiasmD2, at (ambivdemcand2 = (0(.2)1) afraidD=0 angryD=0)
marginsplot, ylabel(-.2(.2)1) legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm") col(1) region(color(none))) title("Democratic Candidate") xtitle("Ambivalence", size(3)) ytitle("Attitude Strength", size(3)) graphregion(color(white)) bgcolor(white) saving(enthusiasmD, replace)

reg repcandthermst2 i.afraidR##c.ambivrepcand2 i.angryR##c.ambivrepcand2 i.enthusiasmR2##c.ambivrepcand2 pid2 pidst education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 if ambivrepcand2<.5 [pweight = VCF0009]
margins enthusiasmR2, at (ambivrepcand2 = (0(.2)1) afraidR=0 angryR=0)
marginsplot, ylabel(-.2(.2)1) legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm") col(1) region(color(none))) title("Republican Candidate") xtitle("Ambivalence", size(3)) ytitle("Attitude Strength", size(3)) graphregion(color(white)) bgcolor(white) saving(enthusiasmR, replace)

gr combine enthusiasmD.gph enthusiasmR.gph, rows(1) graphregion(color(white))

***Non-Attitudes***

probit demcand_neutral i.afraidD##c.ambivdemcand2 i.angryD##c.ambivdemcand2 i.enthusiasmD2##c.ambivdemcand2 pid2 pidst education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 if ambivdemcand2<.5 [pweight = VCF0009]
margins enthusiasmD2, at (ambivdemcand2 = (0(.2)1) afraidD=0 angryD=0)
marginsplot, ylabel(0(.2)1)  legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm") col(1) region(color(none))) title("Democratic Candidate") xtitle("Ambivalence", size(3)) graphregion(color(white)) bgcolor(white) ytitle("Pr(Non-Attitude)", size(3)) saving(enthusiasmD, replace)

probit repcand_neutral i.afraidR##c.ambivrepcand2 i.angryR##c.ambivrepcand2 i.enthusiasmR2##c.ambivrepcand2 pid2 pidst education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 if ambivrepcand2<.5 [pweight = VCF0009]
margins enthusiasmR2, at (ambivrepcand2 = (0(.2)1) afraidR=0 angryR=0)
marginsplot, ylabel(0(.2)1) legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm") col(1) region(color(none))) title("Republican Candidate") xtitle("Ambivalence", size(3)) ytitle("Pr(Non-Attitude)", size(3)) graphregion(color(white)) bgcolor(white) saving(enthusiasmR, replace)

gr combine enthusiasmD.gph enthusiasmR.gph, rows(1) graphregion(color(white))

***Abstention****

probit abstention i.afraidD##c.ambivdemcand2 i.angryD##c.ambivdemcand2 i.enthusiasmD2##c.ambivdemcand2 i.afraidR##c.ambivrepcand2 i.angryR##c.ambivrepcand2 i.enthusiasmR2##c.ambivrepcand2 income3 pid2 pidst education2 knowledge interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 if ambivdemcand2<.5 & ambivrepcand2<.5 [pweight = VCF0009]
margins enthusiasmD2, at(ambivdemcand2 = (0(.2)1) afraidD=0 angryD=0 enthusiasmR=0 afraidR=0 angryR=0)
marginsplot, legend(order(1 "No Enthus" 2 "Some Enthus" 3 "High Enthus") col(1) region(color(none))) title("Democratic Candidate") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2).6, axis(1) labsize(4)) graphregion(color(white)) bgcolor(white) saving(enthusiasmD, replace)
margins enthusiasmR2, at(ambivrepcand2 = (0(.2)1) afraidR=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0)
marginsplot, legend(order(1 "No Enthus" 2 "Some Enthus" 3 "High Enthus") col(1) region(color(none))) title("Republican Candidate") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2).6, axis(1) labsize(4)) graphregion(color(white)) bgcolor(white) saving(enthusiasmR, replace)

gr combine enthusiasmD.gph enthusiasmR.gph, rows(1) graphregion(color(white))

margins, at (ambivdemcand2 = (0(.2)1) afraidD=0 angryD=0 enthusiasmR2=0 afraidR=0 angryR=0) dydx(enthusiasmD2) 
marginsplot, legend(off) title("Democratic Candidates") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Marginal Effect", size(4)) ylabel(-.4(.2).2, axis(1) labsize(4)) yline(0) graphregion(color(white)) bgcolor(white) saving(enthusiasmD2, replace)
margins, at (ambivrepcand2 = (0(.2)1) afraidR=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0) dydx(enthusiasmR2) 
marginsplot, legend(off) title("Democratic Candidates") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Marginal Effect", size(4)) ylabel(-.4(.2).2, axis(1) labsize(4)) yline(0) graphregion(color(white)) bgcolor(white) saving(enthusiasmR2, replace)

gr combine enthusiasmD2.gph enthusiasmR2.gph, rows(1) graphregion(color(white))


***Absention(by Income)***

probit abstention i.income3##i.afraidD##c.ambivdemcand2 i.income3##i.angryD##c.ambivdemcand2 i.income3##i.enthusiasmD2##c.ambivdemcand2 i.income3##i.afraidR##c.ambivrepcand2 i.income3##i.angryR##c.ambivrepcand2 i.income3##i.enthusiasmR2##c.ambivrepcand2 pid2 pidst education2 knowledge interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 if ambivdemcand2<.5 & ambivrepcand2<.5 [pweight = VCF0009]
margins enthusiasmD2, over(income3) at (ambivdemcand2 = (0(.2)1) afraidD=0 angryD=0 enthusiasmR2=0 afraidR=0 angryR=0)
marginsplot, legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm ") col(3) region(color(none))) by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop(graphregion(color(white)) title("Democratic Candidates") rows(1)) title("") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2)1, axis(1) labsize(4)) subtitle(, fcol(none) nobox)
margins, dydx(enthusiasmD2) at(ambivdemcand2=(0(.2)1) afraidD=0 angryD=0 enthusiasmR2=0 afraidR=0 angryR=0) over(income3)
marginsplot, by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop(graphregion(color(white)) title("Democratic Candidates") rows(1)) legend(order(1 "Some Enthusiasm" 2 "High Enthusiasm ") region(color(none))) title("") xtitle("Ambivalence") ytitle("Marginal Effect", size(4)) ylabel(-1(.25).5, axis(1) labsize(4)) yline(0) subtitle(, fcol(none) nobox)

margins enthusiasmR2, over(income3) at (ambivrepcand2 = (0(.2)1) afraidR=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0)
marginsplot, legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm") col(3) region(color(none))) by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop(graphregion(color(white)) bgcolor(white) title("Republican Candidates") rows(1)) title("") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2)1, axis(1) labsize(4)) subtitle(, fcol(none) nobox)
margins, dydx(enthusiasmR2) at(ambivrepcand2=(0(.2)1) afraidR=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0) over(income3)
marginsplot, by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop( graphregion(color(white)) bgcolor(white) title("Republican Candidates") rows(1)) legend(order(1 "Some Enthusiasm" 2 "High Enthusiasm ")region(color(none))) title("") xtitle("Ambivalence") ytitle("Marginal Effect", size(4)) ylabel(-1(.25).5, axis(1) labsize(4)) yline(0) subtitle(, fcol(none) nobox)



***Robustness Check 2: Figures 15A-19A***


***Attitude Strength***

reg demcandthermst2 i.afraidD##c.ambivdemcand2 i.angryD##c.ambivdemcand2 i.enthusiasmD2##c.ambivdemcand2 i.pidst##c.ambivdemcand2 pid2 education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 [pweight = VCF0009]
margins enthusiasmD2, at (ambivdemcand2 = (0(.2) 1) afraidD=0 angryD=0)
marginsplot, ylabel(-.2(.2)1) legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm") col(1) region(color(none))) title("Democratic Candidate") xtitle("Ambivalence", size(3)) ytitle("Attitude Strength", size(3)) graphregion(color(white)) bgcolor(white) saving(enthusiasmD, replace)

reg repcandthermst2 i.afraidR##c.ambivrepcand2 i.angryR##c.ambivrepcand2 i.enthusiasmR2##c.ambivrepcand2 i.pidst##c.ambivrepcand2 pid2 education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04  [pweight = VCF0009]
margins enthusiasmR2, at (ambivrepcand2 = (0(.2) 1) afraidR=0 angryR=0)
marginsplot, ylabel(-.2(.2)1) legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm") col(1) region(color(none))) title("Republican Candidate") xtitle("Ambivalence", size(3)) ytitle("Attitude Strength", size(3)) graphregion(color(white)) bgcolor(white) saving(enthusiasmR, replace)

gr combine enthusiasmD.gph enthusiasmR.gph, rows(1) graphregion(color(white))


***Non-Attitudes***

probit demcand_neutral i.afraidD##c.ambivdemcand2 i.angryD##c.ambivdemcand2 i.enthusiasmD2##c.ambivdemcand2 i.pidst##c.ambivdemcand2 pid2 education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04  [pweight = VCF0009]
margins enthusiasmD2, at (ambivdemcand2 = (0(.2)1) afraidD=0 angryD=0)
marginsplot, ylabel(0(.2)1)  legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm") col(1) region(color(none))) title("Democratic Candidate") xtitle("Ambivalence", size(3)) graphregion(color(white)) bgcolor(white) ytitle("Pr(Non-Attitude)", size(3)) saving(enthusiasmD, replace)

probit repcand_neutral i.afraidR##c.ambivrepcand2 i.angryR##c.ambivrepcand2 i.enthusiasmR2##c.ambivrepcand2 i.pidst##c.ambivrepcand2 pid2 education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 [pweight = VCF0009]
margins enthusiasmR2, at (ambivrepcand2 = (0(.2)1) afraidR=0 angryR=0)
marginsplot, ylabel(0(.2)1) legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm") col(1) region(color(none))) title("Republican Candidate") xtitle("Ambivalence", size(3)) ytitle("Pr(Non-Attitude)", size(3)) graphregion(color(white)) bgcolor(white) saving(enthusiasmR, replace)

gr combine enthusiasmD.gph enthusiasmR.gph, rows(1) graphregion(color(white))

***Abstention***

probit abstention i.afraidD##c.ambivdemcand2 i.angryD##c.ambivdemcand2 i.enthusiasmD2##c.ambivdemcand2 i.afraidR##c.ambivrepcand2 i.angryR##c.ambivrepcand2 i.enthusiasmR2##c.ambivrepcand2 i.pidst##c.ambivdemcand2 i.pidst##c.ambivrepcand2 income3 pid2 education2 knowledge interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04  [pweight = VCF0009]
margins enthusiasmD2, at(ambivdemcand2 = (0(.2)1) afraidD=0 angryD=0 enthusiasmR=0 afraidR=0 angryR=0)
marginsplot, legend(order(1 "No Enthus" 2 "Some Enthus" 3 "High Enthus") col(1) region(color(none))) title("Democratic Candidate") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2).6, axis(1) labsize(4)) graphregion(color(white)) bgcolor(white) saving(enthusiasmD, replace)
margins enthusiasmR2, at(ambivrepcand2 = (0(.2)1) afraidR=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0)
marginsplot, legend(order(1 "No Enthus" 2 "Some Enthus" 3 "High Enthus") col(1) region(color(none))) title("Republican Candidate") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2).6, axis(1) labsize(4)) graphregion(color(white)) bgcolor(white) saving(enthusiasmR, replace)

gr combine enthusiasmD.gph enthusiasmR.gph, rows(1) graphregion(color(white))

margins, at (ambivdemcand2 = (0(.2)1) afraidD=0 angryD=0 enthusiasmR2=0 afraidR=0 angryR=0) dydx(enthusiasmD2) 
marginsplot, legend(off) title("Democratic Candidates") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Marginal Effect", size(4)) ylabel(-.4(.2).2, axis(1) labsize(4)) yline(0) graphregion(color(white)) bgcolor(white) saving(enthusiasmD2, replace)
margins, at (ambivrepcand2 = (0(.2)1) afraidR=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0) dydx(enthusiasmR2) 
marginsplot, legend(off) title("Democratic Candidates") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Marginal Effect", size(4)) ylabel(-.4(.2).2, axis(1) labsize(4)) yline(0) graphregion(color(white)) bgcolor(white) saving(enthusiasmR2, replace)

gr combine enthusiasmD2.gph enthusiasmR2.gph, rows(1) graphregion(color(white))



***Abstention (by Income)***

probit abstention i.income3##i.afraidD##c.ambivdemcand2 i.income3##i.angryD##c.ambivdemcand2 i.income3##i.enthusiasmD2##c.ambivdemcand2 i.income3##i.afraidR##c.ambivrepcand2 i.income3##i.angryR##c.ambivrepcand2 i.income3##i.enthusiasmR2##c.ambivrepcand2 i.pidst##c.ambivdemcand2 i.pidst##c.ambivrepcand2 pid2 education2 knowledge interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 [pweight = VCF0009]
margins enthusiasmD2, over(income3) at (ambivdemcand2 = (0(.2)1) afraidD=0 angryD=0 enthusiasmR2=0 afraidR=0 angryR=0)
marginsplot, legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm ") col(3) region(color(none))) by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop(graphregion(color(white)) title("Democratic Candidates") rows(1)) title("") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2)1, axis(1) labsize(4)) subtitle(, fcol(none) nobox)
margins, dydx(enthusiasmD2) at(ambivdemcand2=(0(.2)1) afraidD=0 angryD=0 enthusiasmR2=0 afraidR=0 angryR=0) over(income3)
marginsplot, by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop(graphregion(color(white)) title("Democratic Candidates") rows(1)) legend(order(1 "Some Enthusiasm" 2 "High Enthusiasm ") region(color(none))) title("") xtitle("Ambivalence") ytitle("Marginal Effect", size(4)) ylabel(-1(.25).5, axis(1) labsize(4)) yline(0) subtitle(, fcol(none) nobox)

margins enthusiasmR2, over(income3) at (ambivrepcand2 = (0(.2)1) afraidR=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0)
marginsplot, legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm") col(3) region(color(none))) by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop(graphregion(color(white)) bgcolor(white) title("Republican Candidates") rows(1)) title("") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2)1, axis(1) labsize(4)) subtitle(, fcol(none) nobox)
margins, dydx(enthusiasmR2) at(ambivrepcand2=(0(.2)1) afraidR=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0) over(income3)
marginsplot, by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop( graphregion(color(white)) bgcolor(white) title("Republican Candidates") rows(1)) legend(order(1 "Some Enthusiasm" 2 "High Enthusiasm ")region(color(none))) title("") xtitle("Ambivalence") ytitle("Marginal Effect", size(4)) ylabel(-1(.25).5, axis(1) labsize(4)) yline(0) subtitle(, fcol(none) nobox)



***Robustness Check 3: Figures 20A & 21A***

***Abstention(by Education)***

gen education3 = education
recode education3 1/2=0 3/5=1 6/7=2

probit abstention i.education3##i.afraidD##c.ambivdemcand2 i.education3##i.angryD##c.ambivdemcand2 i.education3##i.enthusiasmD2##c.ambivdemcand2 i.education3##i.afraidR##c.ambivrepcand2 i.education3##i.angryR##c.ambivrepcand2 i.education3##i.enthusiasmR2##c.ambivrepcand2 pid2 pidst income2 knowledge interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 [pweight = VCF0009]
margins enthusiasmD2, over(education3) at (ambivdemcand2 = (0(.2)1) afraidD=0 angryD=0 enthusiasmR2=0 afraidR=0 angryR=0)
marginsplot, legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm ") col(3) region(color(none))) by(education3, elabel(1 "Low Education" 2 "Middle Education" 3 "High Education")) byop(graphregion(color(white)) title("Democratic Candidates") rows(1)) title("") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2)1, axis(1) labsize(4)) subtitle(, fcol(none) nobox)
margins, dydx(enthusiasmD2) at(ambivdemcand2=(0(.2)1) afraidD=0 angryD=0 enthusiasmR2=0 afraidR=0 angryR=0) over(education3)
marginsplot, by(education3, elabel(1 "Low Education" 2 "Middle Education" 3 "High Education")) byop(graphregion(color(white)) title("Democratic Candidates") rows(1)) legend(order(1 "Some Enthusiasm" 2 "High Enthusiasm ") region(color(none))) title("") xtitle("Ambivalence") ytitle("Marginal Effect", size(4)) ylabel(-1(.25).5, axis(1) labsize(4)) yline(0) subtitle(, fcol(none) nobox)

margins enthusiasmR2, over(education3) at (ambivrepcand2 = (0(.2)1) afraidR=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0)
marginsplot, legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm") col(3) region(color(none))) by(education3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop(graphregion(color(white)) bgcolor(white) title("Republican Candidates") rows(1)) title("") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2)1, axis(1) labsize(4)) subtitle(, fcol(none) nobox)
margins, dydx(enthusiasmR2) at(ambivrepcand2=(0(.2)1) afraidR=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0) over(education3)
marginsplot, by(education3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop( graphregion(color(white)) bgcolor(white) title("Republican Candidates") rows(1)) legend(order(1 "Some Enthusiasm" 2 "High Enthusiasm ")region(color(none))) title("") xtitle("Ambivalence") ytitle("Marginal Effect", size(4)) ylabel(-1(.25).5, axis(1) labsize(4)) yline(0) subtitle(, fcol(none) nobox)



***Robustness Check 4: Figure 22A & 23A***

gen abstain_valid = .
recode abstain_valid .=1 if VCF9151 ==5
recode abstain_valid .=0 if VCF9155 ==1


probit abstain_valid i.income3##i.afraidD##c.ambivdemcand2 i.income3##i.angryD##c.ambivdemcand2 i.income3##i.enthusiasmD2##c.ambivdemcand2 i.income3##i.afraidR##c.ambivrepcand2 i.income3##i.angryR##c.ambivrepcand2 i.income3##i.enthusiasmR2##c.ambivrepcand2 pid2 pidst education2 knowledge interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 [pweight = VCF0009]
margins enthusiasmD2, over(income3) at (ambivdemcand2 = (0(.2)1) afraidD=0 angryD=0 enthusiasmR2=0 afraidR=0 angryR=0)
marginsplot, legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm ") col(3) region(color(none))) by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop(graphregion(color(white)) title("Democratic Candidates") rows(1)) title("") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2)1, axis(1) labsize(4)) subtitle(, fcol(none) nobox)
margins, dydx(enthusiasmD2) at(ambivdemcand2=(0(.2)1) afraidD=0 angryD=0 enthusiasmR2=0 afraidR=0 angryR=0) over(income3)
marginsplot, by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop(graphregion(color(white)) title("Democratic Candidates") rows(1)) legend(order(1 "Some Enthusiasm" 2 "High Enthusiasm ") region(color(none))) title("") xtitle("Ambivalence") ytitle("Marginal Effect", size(4)) ylabel(-1(.25).5, axis(1) labsize(4)) yline(0) subtitle(, fcol(none) nobox)

margins enthusiasmR2, over(income3) at (ambivrepcand2 = (0(.2)1) afraidR=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0)
marginsplot, legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm") col(3) region(color(none))) by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop(graphregion(color(white)) bgcolor(white) title("Republican Candidates") rows(1)) title("") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2)1, axis(1) labsize(4)) subtitle(, fcol(none) nobox)
margins, dydx(enthusiasmR2) at(ambivrepcand2=(0(.2)1) afraidR=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0) over(income3)
marginsplot, by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop( graphregion(color(white)) bgcolor(white) title("Republican Candidates") rows(1)) legend(order(1 "Some Enthusiasm" 2 "High Enthusiasm ")region(color(none))) title("") xtitle("Ambivalence") ytitle("Marginal Effect", size(4)) ylabel(-1(.25).5, axis(1) labsize(4)) yline(0) subtitle(, fcol(none) nobox)



***Robustness Check 5: Figures 24A-28A & Figures 29A-33A***

***Candidate Traits Only***

gen character2 = .
recode character2 .= 1 if demlikes_open == 3 | replikes_open == 3 | demdislikes_open == 3 | repdislikes_open == 3 | demlikes_open == 4 | replikes_open == 4 | demdislikes_open == 4 | repdislikes_open == 4| demlikes_open == 5 | replikes_open == 5 | demdislikes_open == 5 | repdislikes_open == 5 & demlikes_open != 1 & replikes_open != 1 & demdislikes_open != 1 & repdislikes_open != 1 & demlikes_open != 2 & replikes_open != 2 & demdislikes_open != 2 & repdislikes_open != 2 &  demlikes_open != 6 & replikes_open != 6 & demdislikes_open != 6 & repdislikes_open != 6 & demlikes_open != 7 & replikes_open != 7 & demdislikes_open != 7 & repdislikes_open != 7 & demlikes_open != 8 & replikes_open != 8 & demdislikes_open != 8 & repdislikes_open != 8 & demlikes_open != 9 & replikes_open != 9 & demdislikes_open != 9 & repdislikes_open != 9 & demlikes_open != 10 & replikes_open != 10 & demdislikes_open != 10 & repdislikes_open != 10 & demlikes_open != 11 & replikes_open != 11 & demdislikes_open != 11 & repdislikes_open != 11 & demlikes_open != 12 & replikes_open != 12 & demdislikes_open != 12 & repdislikes_open != 12

gen characterDEM2 = .
recode characterDEM2 .= 1 if demlikes_open == 3 | demdislikes_open == 3 | demlikes_open == 4 | demdislikes_open == 4 | demlikes_open == 5 | demdislikes_open == 5 & demlikes_open != 1 & demdislikes_open != 1 & demlikes_open != 2 & demdislikes_open != 2 & demlikes_open != 6 & demdislikes_open != 6 & demlikes_open != 7 & demdislikes_open != 7 & demlikes_open != 8 & demdislikes_open != 8 & demlikes_open != 9 & demdislikes_open != 9 & demlikes_open != 10 & demdislikes_open != 10 & demlikes_open != 11 & demdislikes_open != 11 & demlikes_open != 12 & demdislikes_open != 12

gen characterREP2 = .
recode characterREP2 .= 1 if replikes_open == 3 | repdislikes_open == 3 | replikes_open == 4 | repdislikes_open == 4| replikes_open == 5 | repdislikes_open == 5 & replikes_open != 1 & repdislikes_open != 1 & replikes_open != 2 & repdislikes_open != 2 & replikes_open != 6 & repdislikes_open != 6 & replikes_open != 7 & repdislikes_open != 7 & replikes_open != 8 & repdislikes_open != 8 & replikes_open != 9 & repdislikes_open != 9 & replikes_open != 10 & repdislikes_open != 10 & replikes_open != 11 & repdislikes_open != 11 & replikes_open != 12 & repdislikes_open != 12


***Attitude Strength*** 

reg demcandthermst2 i.afraidD##c.ambivdemcand2 i.angryD##c.ambivdemcand2 i.enthusiasmD2##c.ambivdemcand2 pid2 pidst education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 if characterDEM2 ==1 [pweight = VCF0009]
margins enthusiasmD2, at (ambivdemcand2 = (0(.2) 1) afraidD=0 angryD=0)
marginsplot, ylabel(-.2(.2)1) legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm") col(1) region(color(none))) title("Democratic Candidate") xtitle("Ambivalence", size(3)) ytitle("Attitude Strength", size(3)) graphregion(color(white)) bgcolor(white) saving(enthusiasmD, replace)

reg repcandthermst2 i.afraidR##c.ambivrepcand2 i.angryR##c.ambivrepcand2 i.enthusiasmR2##c.ambivrepcand2 pid2 pidst education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 if characterREP2 ==1  [pweight = VCF0009]
margins enthusiasmR2, at (ambivrepcand2 = (0(.2) 1) afraidR=0 angryR=0)
marginsplot, ylabel(-.2(.2)1) legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm") col(1) region(color(none))) title("Republican Candidate") xtitle("Ambivalence", size(3)) ytitle("Attitude Strength", size(3)) graphregion(color(white)) bgcolor(white) saving(enthusiasmR, replace)

gr combine enthusiasmD.gph enthusiasmR.gph, rows(1) graphregion(color(white))

***Non-Attitudes***

probit demcand_neutral i.afraidD##c.ambivdemcand2 i.angryD##c.ambivdemcand2 i.enthusiasmD2##c.ambivdemcand2 pid2 pidst education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 if characterDEM2 ==1  [pweight = VCF0009]
margins enthusiasmD2, at (ambivdemcand2 = (0(.2)1) afraidD=0 angryD=0)
marginsplot, ylabel(0(.2)1)  legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm") col(1) region(color(none))) title("Democratic Candidate") xtitle("Ambivalence", size(3)) graphregion(color(white)) bgcolor(white) ytitle("Pr(Non-Attitude)", size(3)) saving(enthusiasmD, replace)

probit repcand_neutral i.afraidR##c.ambivrepcand2 i.angryR##c.ambivrepcand2 i.enthusiasmR2##c.ambivrepcand2 pid2 pidst education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 if characterREP2 ==1  [pweight = VCF0009]
margins enthusiasmR2, at (ambivrepcand2 = (0(.2)1) afraidR=0 angryR=0)
marginsplot, ylabel(0(.2)1) legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm") col(1) region(color(none))) title("Republican Candidate") xtitle("Ambivalence", size(3)) ytitle("Pr(Non-Attitude)", size(3)) graphregion(color(white)) bgcolor(white) saving(enthusiasmR, replace)

gr combine enthusiasmD.gph enthusiasmR.gph, rows(1) graphregion(color(white))

***Abstention***

probit abstention i.afraidD##c.ambivdemcand2 i.angryD##c.ambivdemcand2 i.enthusiasmD2##c.ambivdemcand2 i.afraidR##c.ambivrepcand2 i.angryR##c.ambivrepcand2 i.enthusiasmR2##c.ambivrepcand2 income3 pid2 pidst education2 knowledge interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 if character2 ==1  [pweight = VCF0009]
margins enthusiasmD2, at(ambivdemcand2 = (0(.2)1) afraidD=0 angryD=0 enthusiasmR=0 afraidR=0 angryR=0)
marginsplot, legend(order(1 "No Enthus" 2 "Some Enthus" 3 "High Enthus") col(1) region(color(none))) title("Democratic Candidate") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2).6, axis(1) labsize(4)) graphregion(color(white)) bgcolor(white) saving(enthusiasmD, replace)
margins enthusiasmR2, at(ambivrepcand2 = (0(.2)1) afraidR=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0)
marginsplot, legend(order(1 "No Enthus" 2 "Some Enthus" 3 "High Enthus") col(1) region(color(none))) title("Republican Candidate") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2).6, axis(1) labsize(4)) graphregion(color(white)) bgcolor(white) saving(enthusiasmR, replace)

gr combine enthusiasmD.gph enthusiasmR.gph, rows(1) graphregion(color(white))

margins, at (ambivdemcand2 = (0(.2)1) afraidD=0 angryD=0 enthusiasmR2=0 afraidR=0 angryR=0) dydx(enthusiasmD2) 
marginsplot, legend(off) title("Democratic Candidates") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Marginal Effect", size(4)) ylabel(-.4(.2).2, axis(1) labsize(4)) yline(0) graphregion(color(white)) bgcolor(white) saving(enthusiasmD2, replace)
margins, at (ambivrepcand2 = (0(.2)1) afraidR=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0) dydx(enthusiasmR2) 
marginsplot, legend(off) title("Democratic Candidates") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Marginal Effect", size(4)) ylabel(-.4(.2).2, axis(1) labsize(4)) yline(0) graphregion(color(white)) bgcolor(white) saving(enthusiasmR2, replace)

gr combine enthusiasmD2.gph enthusiasmR2.gph, rows(1) graphregion(color(white))


***Abstention(by Income)***

probit abstention i.income3##i.afraidD##c.ambivdemcand2 i.income3##i.angryD##c.ambivdemcand2 i.income3##i.enthusiasmD2##c.ambivdemcand2 i.income3##i.afraidR##c.ambivrepcand2 i.income3##i.angryR##c.ambivrepcand2 i.income3##i.enthusiasmR2##c.ambivrepcand2 pid2 pidst education2 knowledge interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 if character2 ==1 [pweight = VCF0009]
margins enthusiasmD2, over(income3) at (ambivdemcand2 = (0(.2)1) afraidD=0 angryD=0 enthusiasmR2=0 afraidR=0 angryR=0)
marginsplot, legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm ") col(3) region(color(none))) by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop(graphregion(color(white)) title("Democratic Candidates") rows(1)) title("") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2)1, axis(1) labsize(4)) subtitle(, fcol(none) nobox)
margins, dydx(enthusiasmD2) at(ambivdemcand2=(0(.2)1) afraidD=0 angryD=0 enthusiasmR2=0 afraidR=0 angryR=0) over(income3)
marginsplot, by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop(graphregion(color(white)) title("Democratic Candidates") rows(1)) legend(order(1 "Some Enthusiasm" 2 "High Enthusiasm ") region(color(none))) title("") xtitle("Ambivalence") ytitle("Marginal Effect", size(4)) ylabel(-1(.25).5, axis(1) labsize(4)) yline(0) subtitle(, fcol(none) nobox)

margins enthusiasmR2, over(income3) at (ambivrepcand2 = (0(.2)1) afraidR=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0)
marginsplot, legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm") col(3) region(color(none))) by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop(graphregion(color(white)) bgcolor(white) title("Republican Candidates") rows(1)) title("") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2)1, axis(1) labsize(4)) subtitle(, fcol(none) nobox)
margins, dydx(enthusiasmR2) at(ambivrepcand2=(0(.2)1) afraidR=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0) over(income3)
marginsplot, by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop( graphregion(color(white)) bgcolor(white) title("Republican Candidates") rows(1)) legend(order(1 "Some Enthusiasm" 2 "High Enthusiasm ")region(color(none))) title("") xtitle("Ambivalence") ytitle("Marginal Effect", size(4)) ylabel(-1(.25).5, axis(1) labsize(4)) yline(0) subtitle(, fcol(none) nobox)



***Policy Issues Only***

gen policy2 = .
recode policy2 .= 1 if demlikes_open == 9 | replikes_open == 9 | demdislikes_open == 9 | repdislikes_open == 9 | demlikes_open == 10 | replikes_open == 10 | demdislikes_open == 10 | repdislikes_open != 10 & demlikes_open != 1 & replikes_open != 1 & demdislikes_open != 1 & repdislikes_open != 1 & demlikes_open != 2 & replikes_open != 2 & demdislikes_open != 2 & repdislikes_open != 2 & demlikes_open != 3 & replikes_open != 3 & demdislikes_open != 3 & repdislikes_open != 3 & demlikes_open != 4 & replikes_open != 4 & demdislikes_open != 4 & repdislikes_open != 4 & demlikes_open != 5 & replikes_open != 5 & demdislikes_open != 5 & repdislikes_open != 5 &  demlikes_open != 6 & replikes_open != 6 & demdislikes_open != 6 & repdislikes_open != 6 & demlikes_open != 7 & replikes_open != 7 & demdislikes_open != 7 & repdislikes_open != 7 & demlikes_open != 8 & replikes_open != 8 & demdislikes_open != 8 & repdislikes_open != 8 & demlikes_open != 11 & replikes_open != 11 & demdislikes_open != 11 & repdislikes_open != 11 & demlikes_open != 12 & replikes_open != 12 & demdislikes_open != 12 & repdislikes_open != 12

gen policyDEM2 = .
recode policyDEM2 .= 1 if demlikes_open == 9 | demdislikes_open == 9 | demlikes_open == 10 | demdislikes_open == 10 & demlikes_open != 1 & demdislikes_open != 1 & demlikes_open != 2 & demdislikes_open != 2 & demlikes_open != 3 & demdislikes_open != 3 & demlikes_open != 4 & demdislikes_open != 4 & demlikes_open != 5 & demdislikes_open != 5 & demlikes_open != 6 & demdislikes_open != 6 & demlikes_open != 7 & demdislikes_open != 7 & demlikes_open != 8 & demdislikes_open != 8 & demlikes_open != 11 & demdislikes_open != 11 & demlikes_open != 12 & demdislikes_open != 12

gen policyREP2 = .
recode policyREP2 .= 1 if replikes_open == 9 | repdislikes_open == 9 | replikes_open == 10 | repdislikes_open == 10 & replikes_open != 1 & repdislikes_open != 1 & replikes_open != 2 & repdislikes_open != 2 & replikes_open != 3 & repdislikes_open != 3 & replikes_open != 4 & repdislikes_open != 4 & replikes_open != 5 & repdislikes_open != 5 & replikes_open != 6 & repdislikes_open != 6 & replikes_open != 7 & repdislikes_open != 7 & replikes_open != 8 & repdislikes_open != 8 & replikes_open != 11 & repdislikes_open != 11 & replikes_open != 12 & repdislikes_open != 12


***Attitude Strength*** 

reg demcandthermst2 i.afraidD##c.ambivdemcand2 i.angryD##c.ambivdemcand2 i.enthusiasmD2##c.ambivdemcand2 pid2 pidst education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 if policyDEM2 ==1 [pweight = VCF0009]
margins enthusiasmD2, at (ambivdemcand2 = (0(.2) 1) afraidD=0 angryD=0)
marginsplot, ylabel(-.2(.2)1) legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm") col(1) region(color(none))) title("Democratic Candidate") xtitle("Ambivalence", size(3)) ytitle("Attitude Strength", size(3)) graphregion(color(white)) bgcolor(white) saving(enthusiasmD, replace)

reg repcandthermst2 i.afraidR##c.ambivrepcand2 i.angryR##c.ambivrepcand2 i.enthusiasmR2##c.ambivrepcand2 pid2 pidst education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 if policyREP2 ==1  [pweight = VCF0009]
margins enthusiasmR2, at (ambivrepcand2 = (0(.2) 1) afraidR=0 angryR=0)
marginsplot, ylabel(-.2(.2)1) legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm") col(1) region(color(none))) title("Republican Candidate") xtitle("Ambivalence", size(3)) ytitle("Attitude Strength", size(3)) graphregion(color(white)) bgcolor(white) saving(enthusiasmR, replace)

gr combine enthusiasmD.gph enthusiasmR.gph, rows(1) graphregion(color(white))

***Non-Attitudes***

probit demcand_neutral i.afraidD##c.ambivdemcand2 i.angryD##c.ambivdemcand2 i.enthusiasmD2##c.ambivdemcand2 pid2 pidst education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 if policyDEM2 ==1  [pweight = VCF0009]
margins enthusiasmD2, at (ambivdemcand2 = (0(.2)1) afraidD=0 angryD=0)
marginsplot, ylabel(0(.2)1)  legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm") col(1) region(color(none))) title("Democratic Candidate") xtitle("Ambivalence", size(3)) graphregion(color(white)) bgcolor(white) ytitle("Pr(Non-Attitude)", size(3)) saving(enthusiasmD, replace)

probit repcand_neutral i.afraidR##c.ambivrepcand2 i.angryR##c.ambivrepcand2 i.enthusiasmR2##c.ambivrepcand2 pid2 pidst education2 knowledge income2 interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 if policyREP2 ==1  [pweight = VCF0009]
margins enthusiasmR2, at (ambivrepcand2 = (0(.2)1) afraidR=0 angryR=0)
marginsplot, ylabel(0(.2)1) legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm") col(1) region(color(none))) title("Republican Candidate") xtitle("Ambivalence", size(3)) ytitle("Pr(Non-Attitude)", size(3)) graphregion(color(white)) bgcolor(white) saving(enthusiasmR, replace)

gr combine enthusiasmD.gph enthusiasmR.gph, rows(1) graphregion(color(white))

***Abstention***

probit abstention i.afraidD##c.ambivdemcand2 i.angryD##c.ambivdemcand2 i.enthusiasmD2##c.ambivdemcand2 i.afraidR##c.ambivrepcand2 i.angryR##c.ambivrepcand2 i.enthusiasmR2##c.ambivrepcand2 income3 pid2 pidst education2 knowledge interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 if policy2 ==1  [pweight = VCF0009]
margins enthusiasmD2, at(ambivdemcand2 = (0(.2)1) afraidD=0 angryD=0 enthusiasmR=0 afraidR=0 angryR=0)
marginsplot, legend(order(1 "No Enthus" 2 "Some Enthus" 3 "High Enthus") col(1) region(color(none))) title("Democratic Candidate") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2).6, axis(1) labsize(4)) graphregion(color(white)) bgcolor(white) saving(enthusiasmD, replace)
margins enthusiasmR2, at(ambivrepcand2 = (0(.2)1) afraidR=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0)
marginsplot, legend(order(1 "No Enthus" 2 "Some Enthus" 3 "High Enthus") col(1) region(color(none))) title("Republican Candidate") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2).6, axis(1) labsize(4)) graphregion(color(white)) bgcolor(white) saving(enthusiasmR, replace)

gr combine enthusiasmD.gph enthusiasmR.gph, rows(1) graphregion(color(white))

margins, at (ambivdemcand2 = (0(.2)1) afraidD=0 angryD=0 enthusiasmR2=0 afraidR=0 angryR=0) dydx(enthusiasmD2) 
marginsplot, legend(off) title("Democratic Candidates") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Marginal Effect", size(4)) ylabel(-.4(.2).2, axis(1) labsize(4)) yline(0) graphregion(color(white)) bgcolor(white) saving(enthusiasmD2, replace)
margins, at (ambivrepcand2 = (0(.2)1) afraidR=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0) dydx(enthusiasmR2) 
marginsplot, legend(off) title("Democratic Candidates") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Marginal Effect", size(4)) ylabel(-.4(.2).2, axis(1) labsize(4)) yline(0) graphregion(color(white)) bgcolor(white) saving(enthusiasmR2, replace)

gr combine enthusiasmD2.gph enthusiasmR2.gph, rows(1) graphregion(color(white))


***Abstention(by Income)***

probit abstention i.income3##i.afraidD##c.ambivdemcand2 i.income3##i.angryD##c.ambivdemcand2 i.income3##i.enthusiasmD2##c.ambivdemcand2 i.income3##i.afraidR##c.ambivrepcand2 i.income3##i.angryR##c.ambivrepcand2 i.income3##i.enthusiasmR2##c.ambivrepcand2 pid2 pidst education2 knowledge interest_elec female age2 black hispanic yr84 yr88 yr92 yr96 yr00 yr04 if policy2 ==1 [pweight = VCF0009]
margins enthusiasmD2, over(income3) at (ambivdemcand2 = (0(.2)1) afraidD=0 angryD=0 enthusiasmR2=0 afraidR=0 angryR=0)
marginsplot, legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm ") col(3) region(color(none))) by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop(graphregion(color(white)) title("Democratic Candidates") rows(1)) title("") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2)1, axis(1) labsize(4)) subtitle(, fcol(none) nobox)
margins, dydx(enthusiasmD2) at(ambivdemcand2=(0(.2)1) afraidD=0 angryD=0 enthusiasmR2=0 afraidR=0 angryR=0) over(income3)
marginsplot, by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop(graphregion(color(white)) title("Democratic Candidates") rows(1)) legend(order(1 "Some Enthusiasm" 2 "High Enthusiasm ") region(color(none))) title("") xtitle("Ambivalence") ytitle("Marginal Effect", size(4)) ylabel(-1(.25).5, axis(1) labsize(4)) yline(0) subtitle(, fcol(none) nobox)

margins enthusiasmR2, over(income3) at (ambivrepcand2 = (0(.2)1) afraidR=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0)
marginsplot, legend(order(1 "No Enthusiasm" 2 "Some Enthusiasm" 3 "High Enthusiasm") col(3) region(color(none))) by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop(graphregion(color(white)) bgcolor(white) title("Republican Candidates") rows(1)) title("") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Pr(Abstention)", size(4)) ylabel(0(.2)1, axis(1) labsize(4)) subtitle(, fcol(none) nobox)
margins, dydx(enthusiasmR2) at(ambivrepcand2=(0(.2)1) afraidR=0 angryR=0 enthusiasmD2=0 afraidD=0 angryD=0) over(income3)
marginsplot, by(income3, elabel(1 "Low Income" 2 "Middle Income" 3 "High Income")) byop( graphregion(color(white)) bgcolor(white) title("Republican Candidates") rows(1)) legend(order(1 "Some Enthusiasm" 2 "High Enthusiasm ")region(color(none))) title("") xtitle("Ambivalence") ytitle("Marginal Effect", size(4)) ylabel(-1(.25).5, axis(1) labsize(4)) yline(0) subtitle(, fcol(none) nobox)
