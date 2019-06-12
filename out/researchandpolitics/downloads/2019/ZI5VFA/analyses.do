*analyses for manuscript. 

********************************************************************************
*use "CANES_sorting.dta"
********************************************************************************

*Figure 1
mean perceivedpolar, over(year)
mean self_inparty, over(year)
mean self_outparty, over(year)
histogram perceivedpolar, percent bin(12) saving(pp)
histogram self_inparty, percent bin(7) saving(ip)
histogram self_outparty, percent bin(7) saving(op)
gr combine pp.gph ip.gph op.gph

*Figure 2 
mean self_outparty if pid3==0 & year>1979, over(year)
est store op1
mean self_outparty if pid3==2 & year>1979, over(year)
est store op2
coefplot op1 op2, vertical

*Table 1
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth _88-_08 [pweight=vcf0010z]

*Figure 3
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year==1980
margins, dydx(self_outparty) post
est store op80
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year==1984
margins, dydx(self_outparty) post
est store op84
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year==1988
margins, dydx(self_outparty) post
est store op88
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year==1990
margins, dydx(self_outparty) post
est store op90
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year==1992
margins, dydx(self_outparty) post
est store op92
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year==1996
margins, dydx(self_outparty) post
est store op96
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year==1998
margins, dydx(self_outparty) post
est store op98
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year==2000
margins, dydx(self_outparty) post
est store op00
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year==2004
margins, dydx(self_outparty) post
est store op04
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year==2008
margins, dydx(self_outparty) post
est store op08
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year==2012
margins, dydx(self_outparty) post
est store op12
*appended in 2016
reg levendusky self_inparty self_outparty interest knowledge educ religiosity male income age white black oldsouth  [pweight=V160102] if year==2016
margins, dydx(self_outparty) post
est store op16

coefplot (op80, mcolor(black) msymbol(D) mfcolor(white) ciopts(lcolor(black) lwidth(*3)) offset(-4)) (op84, mcolor(black) msymbol(D) mfcolor(white) ciopts(lcolor(black) lwidth(*3)) offset(-3)) (op88, mcolor(black) msymbol(D) mfcolor(white) ciopts(lcolor(black) lwidth(*3)) offset(-2)) (op92, mcolor(black) msymbol(D) mfcolor(white) ciopts(lcolor(black) lwidth(*3)) offset(-1)) (op96, mcolor(black) msymbol(D) mfcolor(white) ciopts(lcolor(black) lwidth(*3)) offset(0)) (op00, mcolor(black) msymbol(D) mfcolor(white) ciopts(lcolor(black) lwidth(*3)) offset(1)) (op04, mcolor(black) msymbol(D) mfcolor(white) ciopts(lcolor(black) lwidth(*3)) offset(2)) (op08, mcolor(black) msymbol(D) mfcolor(white) ciopts(lcolor(black) lwidth(*3)) offset(3)) (op12, mcolor(black) msymbol(D) mfcolor(white) ciopts(lcolor(black) lwidth(*3)) offset(4)) (op16, mcolor(black) msymbol(D) mfcolor(white) ciopts(lcolor(black) lwidth(*3)) offset(5)),vertical plotregion(fcolor(gray*.1)) msize(medium) ci(95) aspect(2.5) ylabel(0 .1 .2 .3 .4 .5 .6) legend(off) title("Out-party dissimilarity") xlabel (-4 " " -3 "80" -2 "84" -1 "88" 0 "92" 1 "96" 2 "00" 3 "04" 4 "08" 5 "12" 6 "16" 7 " ") xline( -3 -2 -1 0 1 2 3 4 5 6 , lcolor(white) lwidth(thin) lpattern(solid))

reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year==1980
margins, dydx(self_inparty) post
est store in80
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year==1984
margins, dydx(self_inparty) post
est store in84
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year==1988
margins, dydx(self_inparty) post
est store in88
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year==1990
margins, dydx(self_inparty) post
est store in90
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year==1992
margins, dydx(self_inparty) post
est store in92
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year==1996
margins, dydx(self_inparty) post
est store in96
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year==1998
margins, dydx(self_inparty) post
est store in98
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year==2000
margins, dydx(self_inparty) post
est store in00
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year==2004
margins, dydx(self_inparty) post
est store in04
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year==2008
margins, dydx(self_inparty) post
est store in08
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year==2012
margins, dydx(self_inparty) post
est store in12
*appended in 2016
reg levendusky self_inparty self_outparty interest knowledge educ religiosity male income age white black oldsouth  [pweight=V160102] if year==2016
margins, dydx(self_inparty) post
est store in16

coefplot (in80, mcolor(black) msymbol(O)  ciopts(lcolor(black) lwidth(*3)) offset(-4)) (in84, mcolor(black) msymbol(O)  ciopts(lcolor(black) lwidth(*3)) offset(-3)) (in88, mcolor(black) msymbol(O)  ciopts(lcolor(black) lwidth(*3)) offset(-2)) (in92, mcolor(black) msymbol(O)  ciopts(lcolor(black) lwidth(*3)) offset(-1)) (in96, mcolor(black) msymbol(O)  ciopts(lcolor(black) lwidth(*3)) offset(0)) (in00, mcolor(black) msymbol(O)  ciopts(lcolor(black) lwidth(*3)) offset(1)) (in04, mcolor(black) msymbol(O)  ciopts(lcolor(black) lwidth(*3)) offset(2)) (in08, mcolor(black) msymbol(O)  ciopts(lcolor(black) lwidth(*3)) offset(3)) (in12, mcolor(black) msymbol(O)  ciopts(lcolor(black) lwidth(*3)) offset(4)) (in16, mcolor(black) msymbol(O)  ciopts(lcolor(black) lwidth(*3)) offset(5)),vertical plotregion(fcolor(gray*.1)) msize(medium) ci(95) aspect(2.5) ylabel(0 .1 .2 .3 .4 .5 .6) legend(off) title("In-party similarity") xlabel (-4 " " -3 "80" -2 "84" -1 "88" 0 "92" 1 "96" 2 "00" 3 "04" 4 "08" 5 "12" 6 "16" 7 " ") xline( -3 -2 -1 0 1 2 3 4 5 6 , lcolor(white) lwidth(thin) lpattern(solid))

*Figure 4
reg levendusky self_inparty pid3##c.self_outparty interest know education religiosity01 male income age white black oldsouth _88-_08 [pweight=vcf0010z]
margins pid3 if pid3==2, dydx(self_outparty) post
est store outpartyR

reg levendusky self_inparty pid3##c.self_outparty interest know education religiosity01 male income age white black oldsouth _88-_08 [pweight=vcf0010z]
margins pid3 if pid3==0, dydx(self_outparty) post
est store outpartyD

reg levendusky pid3##c.self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth _88-_08 [pweight=vcf0010z]
margins pid3 if pid3==2, dydx(self_inparty) post
est store inpartyR

reg levendusky pid3##c.self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth _88-_08 [pweight=vcf0010z]
margins pid3 if pid3==0, dydx(self_inparty) post
est store inpartyD

reg levendusky pid3##c.perceivedpolar interest know education religiosity01 male income age white black oldsouth _88-_08 [pweight=vcf0010z]
margins pid3 if pid3==2, dydx(perceivedpolar) post
est store ppR

reg levendusky pid3##c.perceivedpolar interest know education religiosity01 male income age white black oldsouth _88-_08 [pweight=vcf0010z]
margins pid3 if pid3==0, dydx(perceivedpolar) post
est store ppD

coefplot (inpartyD, mcolor(blue) msymbol(D) mfcolor(white) ciopts(lcolor(blue) lwidth(*3)) offset(.0)) (inpartyR, lcolor(red) mcolor(red) ciopts(lcolor(red) lwidth(*3))), vertical plotregion(fcolor(gray*.1)) msize(medium) ci(95) aspect(2.5) ylabel(0 .1 .2 .3 .4 .5) legend(off) title("In-party similarity") xlabel(1 "Dem" 2 "Rep") xline(1 2, lcolor(white) lwidth(thin) lpattern(solid))
graph save Graph "E:\cues\final - me inparty.gph", replace
coefplot (outpartyD, mcolor(blue) msymbol(D) mfcolor(white) ciopts(lcolor(blue) lwidth(*3)) offset(.0)) (outpartyR, lcolor(red) mcolor(red) ciopts(lcolor(red) lwidth(*3))), vertical plotregion(fcolor(gray*.1)) msize(medium) ci(95) aspect(2.5) ylabel(0 .1 .2 .3 .4 .5) legend(off) title("Out-party dissimilarity") xlabel(1 "Dem" 2 "Rep") xline(1 2, lcolor(white) lwidth(thin) lpattern(solid))
graph save Graph "E:\cues\final - me outparty.gph", replace
coefplot (ppD, mcolor(blue) msymbol(D) mfcolor(white) ciopts(lcolor(blue) lwidth(*3)) offset(.0)) (ppR, lcolor(red) mcolor(red) ciopts(lcolor(red) lwidth(*3))), vertical plotregion(fcolor(gray*.1)) msize(medium) ci(95) aspect(2.5) ylabel(0 .1 .2 .3 .4 .5) legend(off) title("Perceived polarization") xlabel(1 "Dem" 2 "Rep") xline(1 2, lcolor(white) lwidth(thin) lpattern(solid))
graph save Graph "E:\cues\final - me perceived polar.gph", replace

*gr combine "location"\final - me perceived polar.gph "location"\final - me inparty.gph "location"\final - me outparty.gph"

********************************************************************************
*USE: 9296ANES_PANEL.dta for table 2/figure 5
********************************************************************************
*Table 2
reg sort96 sort92 outparty92 inparty92 knowledge96-education [pweight=V960003]
reg sort96 sort92 pid3##c.outparty92 inparty92 knowledge96-education [pweight=V960003]
reg outparty96 sort92 outparty92 inparty92 knowledge96-education [pweight=V960003]

*Figure 5
reg sort96 sort92 pid3##c.outparty92 inparty92 knowledge96-education [pweight=V960003]
margins if pid3==0, dydx(outparty92) post
est store d92
reg sort96 sort92 pid3##c.outparty92 inparty92 knowledge96-education [pweight=V960003]
margins if pid3==2, dydx(outparty92) post
est store r92

coefplot (d92, mcolor(blue) msymbol(D) mfcolor(white) ciopts(lcolor(blue) lwidth(*3)) offset(-1)) (r92, mcolor(red) msymbol(O) ciopts(lcolor(red) lwidth(*3)) offset(1)),vertical plotregion(fcolor(gray*.1)) msize(medium) ci(95) aspect(2.5) ylabel(-.6 -.5 -.4 -.3 -.2 -.1 0 .1 .2 .3 .4 .5 .6) legend(off) title("Out-party dissimilarity") yline(0) xlabel (-1 "dem" 1 "rep") xline(-1 1 , lcolor(white) lwidth(thin) lpattern(solid))

********************************************************************************
********************************************************************************
* appendix
********************************************************************************
********************************************************************************

*use data file: CANES_sorting.dta

*Table A1
*summary stats
sum levendusky perceivedpolar self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth if religiosity01!=. & year>1979 & levendusky!=. & self_inparty!=.

*Figure A1
*distribution of sorting
histogram levendusky, bin(10) percent fcolor(emerald*.6) aspect(1)

*Table A2 
*full model output w dummies
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth _88-_08 [pweight=vcf0010z]

*Table A3 / Figure 3
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year== 1980
outreg, se bdec(2) starloc(1) replace
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year== 1984 
outreg, se bdec(2) starloc(1) merge
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year== 1988
outreg, se bdec(2) starloc(1) merge
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year== 1992
outreg, se bdec(2) starloc(1) merge
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year== 1996 
outreg, se bdec(2) starloc(1) merge
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year== 2000
outreg, se bdec(2) starloc(1) merge
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year== 2004
outreg, se bdec(2) starloc(1) merge
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year== 2008
outreg, se bdec(2) starloc(1) merge
reg levendusky self_inparty self_outparty interest know education religiosity01 male income age white black oldsouth [pweight=vcf0010z] if year== 2012
outreg, se bdec(2) starloc(1) merge
*appended in 2016 data from 2016 ANES TS
reg levendusky self_inparty self_outparty interest knowledge educ religiosity male income age white black oldsouth [pweight=V160102] if year== 2016
outreg, se bdec(2) starloc(1) merge

*Table A5
reg levendusky self_incandself_outcand interest know education religiosity01 male income age white black oldsouth _88-_08 [pweight=vcf0010z]

*Table A4 - USE: 9296ANES_PANEL.dta
reg sort96 sort92 outparty92 pid3##c.inparty92 knowledge96-education [pweight=V960003]
reg outparty96 pid3##c.sort92 outparty92 inparty92 knowledge96-education [pweight=V960003]
