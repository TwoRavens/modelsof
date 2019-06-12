


********************************************************************************
/*Fig. 3. Political Characteristics of Industries and the Marginal Effects of 
          Comparative Disadvantage on Tariffs*/
********************************************************************************
*use "PSRM+Lee+sic87+tariffs+1989-1998+sum.dta", clear

xtset sic year

*Interaction Terms
gen RDconBR_=RDcon_*BRdisadv
gen psg501BR_=psg50dcon1_*BRdisadv
gen h501BR_=h50con1_*BRdisadv

********************************************************************************
*Fig. 3a. The Marginal Effect Plot for Comparative Disadvantage, Table 4 (Model 1)
********************************************************************************
*Table 4 (Model 1)
xtpcse tfc_ BRdisadv RDcon_ RDconBR_ geocon indcon size ltfc_ i.dy1, pairwise corr(psar1)

matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1] 
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb2=V[2,2] 
scalar varb3=V[3,3]
scalar covb1b3=V[1,3] 
scalar covb2b3=V[2,3]
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3

*Data generation
sum grfd1con_ 
generate MV=(_n-1)/100
replace MV=. if _n>892
sum MV

gen conb=b1+b3*MV if _n<=892
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<=892
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

gen yline=0
graph set window fontface "Times New Roman"

/*Fig. 3a. The Marginal Effect of Comparative Disadvantage on "Tariffs on Total 
           Imports" against Partisan Dominance (Average Presidential Vote)*/
graph twoway (histogram RDcon_, width(0.013) percent fcolor(gs11) lcolor(gs11) yaxis(2)) (line conb MV, sort lcolor(black) lwidth(medthin) lpattern(solid) yaxis(1)) (line upper MV, sort lcolor(black) lwidth(vthin) lpattern(dash)) (line lower MV, sort lcolor(black) lwidth(vthin) lpattern(dash)) (line yline MV, sort lcolor(black) lwidth(vthin)), xlabel(0 1 2 3 4 5 6 7 8 9, nogrid labsize(small)) ylabel(0.1 0 -0.1 -0.2, axis(1) grid glwidth(thin) glcolor(gs14) labsize(small)) ylabel(0 5 10 15, axis(2) nogrid labsize(small)) yline(0, lcolor(black) lwidth(vthin) lpattern(solid)) xscale(lwidth(vthin) line) yscale(lwidth(vthin) line alt axis(1)) yscale(lwidth(vthin) line alt axis(2)) xtitle("Partisan Dominance (Average Presidential Vote)", margin(small) size(small)) ytitle("Marginal Effect of Comparative Disadvantage", margin(small) size(small)) ytitle(Percentage of Observations, axis(2) orientation(rvertical) margin(small) size(small)) title(Table 4 (Model 1), size(medsmall)) subtitle(Dep. Var: Tariffs on Total Imports, size(small)) legend(off order(1 "95% Confidence Interval") size(small)) plotregion(fcolor(none) lcolor(none) ifcolor(none) ilcolor(none)) scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

********************************************************************************
*Fig. 3b. The Marginal Effect Plot for Comparative Disadvantage, Table 4 (Model 2)
********************************************************************************
*Table 4 (Model 2)
xtpcse tfc_ BRdisadv psg50dcon1_ psg501BR_ geocon indcon size ltfc_ i.dy1, pairwise corr(psar1) 

matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1] 
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb2=V[2,2] 
scalar varb3=V[3,3]
scalar covb1b3=V[1,3] 
scalar covb2b3=V[2,3]
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3

*Data generation
drop MV conb conse a upper lower
sum psg50dcon1_ 
generate MV=(_n-1)/100
replace MV=. if _n>581
sum MV

gen conb=b1+b3*MV if _n<=581
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<=581
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

/*Fig. 3b. The Marginal Effect of Comparative Disadvantage on "Tariffs on Total 
           Imports" against Partisan Dominance (Distance from 50-50)*/
graph twoway (histogram psg50dcon1_, width(0.03) percent fcolor(gs11) lcolor(gs11) yaxis(2)) (line conb MV, sort lcolor(black) lwidth(medthin) lpattern(solid) yaxis(1)) (line upper MV, sort lcolor(black) lwidth(vthin) lpattern(dash)) (line lower MV, sort lcolor(black) lwidth(vthin) lpattern(dash)) (line yline MV, sort lcolor(black) lwidth(vthin)), xlabel(0 1 2 3 4 5 6, nogrid labsize(small)) ylabel(0.1 0.05 0 -0.05 -0.1, axis(1) grid glwidth(thin) glcolor(gs14) labsize(small)) ylabel(0 5 10 15, axis(2) nogrid labsize(small)) yline(0, lcolor(black) lwidth(vthin) lpattern(solid)) xscale(lwidth(vthin) line) yscale(lwidth(vthin) line alt axis(1)) yscale(lwidth(vthin) line alt axis(2)) xtitle(“Partisan Dominance (Distance from 50-50)”, margin(small) size(small)) ytitle(“Marginal Effect of Comparative Disadvantage”, margin(small) size(small)) ytitle(Percentage of Observations, axis(2) orientation(rvertical) margin(small) size(small)) title(Table 4 (Model 2), size(medsmall)) subtitle(Dep. Var: Tariffs on Total Imports, size(small)) legend(off order(1 "95% Confidence Interval") size(small)) plotregion(fcolor(none) lcolor(none) ifcolor(none) ilcolor(none)) scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

********************************************************************************
*Fig. 3c. The Marginal Effect Plot for Comparative Disadvantage, Table 4 (Model 3)
********************************************************************************
*Table 4 (Model 3)
xtpcse tfc_ BRdisadv h50con1_ h501BR_ geocon indcon size ltfc_ i.dy1, pairwise corr(psar1) 

matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1] 
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb2=V[2,2] 
scalar varb3=V[3,3]
scalar covb1b3=V[1,3] 
scalar covb2b3=V[2,3]
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3

*Data generation
drop MV conb conse a upper lower
sum h50con1_ 
generate MV=(_n-1)/100
replace MV=. if _n>1401
sum MV

gen conb=b1+b3*MV if _n<=1401
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<=1401
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

/*Fig 3c. The Marginal Effect of Comparative Disadvantage on "Tariffs on Total 
          Imports" against Partisan Dominance (House Marginality)*/
graph twoway (histogram h50con1_, width(0.04) percent fcolor(gs11) lcolor(gs11) yaxis(2)) (line conb MV, sort lcolor(black) lwidth(medthin) lpattern(solid) yaxis(1)) (line upper MV, sort lcolor(black) lwidth(vthin) lpattern(dash)) (line lower MV, sort lcolor(black) lwidth(vthin) lpattern(dash)) (line yline MV, sort lcolor(black) lwidth(vthin)), xlabel(0 2 4 6 8 10 12 14, nogrid labsize(small)) ylabel(0.1 0.05 0 -0.05 -0.1, axis(1) grid glwidth(thin) glcolor(gs14) labsize(small)) ylabel(0 4 8 12, axis(2) nogrid labsize(small)) yline(0, lcolor(black) lwidth(vthin) lpattern(solid)) xscale(lwidth(vthin) line) yscale(lwidth(vthin) line alt axis(1)) yscale(lwidth(vthin) line alt axis(2)) xtitle(“Partisan Dominance (House Marginality)”, margin(small) size(small)) ytitle(“Marginal Effect of Comparative Disadvantage”, margin(small) size(small)) ytitle(Percentage of Observations, axis(2) orientation(rvertical) margin(small) size(small)) title(Table 4 (Model 3), size(medsmall)) subtitle(Dep. Var: Tariffs on Total Imports, size(small)) legend(off order(1 "95% Confidence Interval") size(small)) plotregion(fcolor(none) lcolor(none) ifcolor(none) ilcolor(none)) scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

********************************************************************************
*Fig. 3d. The Marginal Effect Plot for Comparative Disadvantage, Table 4 (Model 4)
********************************************************************************
*Table 4 (Model 4)
xtpcse tfd_ BRdisadv RDcon_ RDconBR_ geocon indcon size ltfd_ i.dy1, pairwise corr(psar1) 

matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1] 
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb2=V[2,2] 
scalar varb3=V[3,3]
scalar covb1b3=V[1,3] 
scalar covb2b3=V[2,3]
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3

*Data generation
drop MV conb conse a upper lower
sum grfd1con_ 
generate MV=(_n-1)/100
replace MV=. if _n>892
sum MV

gen conb=b1+b3*MV if _n<=892
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<=892
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

/*Fig. 3d. The Marginal Effect of Comparative Disadvantage on "Tariffs on Dutiable 
           Imports" against Partisan Dominance (Average Presidential Vote)*/
graph twoway (histogram RDcon_, width(0.013) percent fcolor(gs11) lcolor(gs11) yaxis(2)) (line conb MV, sort lcolor(black) lwidth(medthin) lpattern(solid) yaxis(1)) (line upper MV, sort lcolor(black) lwidth(vthin) lpattern(dash)) (line lower MV, sort lcolor(black) lwidth(vthin) lpattern(dash)) (line yline MV, sort lcolor(black) lwidth(vthin)), xlabel(0 1 2 3 4 5 6 7 8 9, nogrid labsize(small)) ylabel(0.1 0 -0.1 -0.2 -0.3 -0.4, axis(1) grid glwidth(thin) glcolor(gs14) labsize(small)) ylabel(0 5 10 15, axis(2) nogrid labsize(small)) yline(0, lcolor(black) lwidth(vthin) lpattern(solid)) xscale(lwidth(vthin) line) yscale(lwidth(vthin) line alt axis(1)) yscale(lwidth(vthin) line alt axis(2)) xtitle(“Partisan Dominance (Average Presidential Vote)”, margin(small) size(small)) ytitle(“Marginal Effect of Comparative Disadvantage”, margin(small) size(small)) ytitle(Percentage of Observations, axis(2) orientation(rvertical) margin(small) size(small)) title(Table 4 (Model 4), size(medsmall)) subtitle(Dep. Var: Tariffs on Dutiable Imports, size(small)) legend(off order(1 "95% Confidence Interval") size(small)) plotregion(fcolor(none) lcolor(none) ifcolor(none) ilcolor(none)) scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

********************************************************************************
*Fig. 3e. The Marginal Effect Plot for Comparative Disadvantage, Table 4 (Model 5)
********************************************************************************
*Table 4 (Model 5)
xtpcse tfd_ BRdisadv psg50dcon1_ psg501BR_ geocon indcon size ltfd_ i.dy1, pairwise corr(psar1) 

matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1] 
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb2=V[2,2] 
scalar varb3=V[3,3]
scalar covb1b3=V[1,3] 
scalar covb2b3=V[2,3]
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3

*Data generation
drop MV conb conse a upper lower
sum psg50dcon1_ 
generate MV=(_n-1)/100
replace MV=. if _n>581
sum MV

gen conb=b1+b3*MV if _n<=581
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<=581
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

/*Fig. 3e. The Marginal Effect of Comparative Disadvantage on "Tariffs on Dutiable 
           Imports" against Partisan Dominance (Distance from 50-50)*/
graph twoway (histogram psg50dcon1_, width(0.03) percent fcolor(gs11) lcolor(gs11) yaxis(2)) (line conb MV, sort lcolor(black) lwidth(medthin) lpattern(solid) yaxis(1)) (line upper MV, sort lcolor(black) lwidth(vthin) lpattern(dash)) (line lower MV, sort lcolor(black) lwidth(vthin) lpattern(dash)) (line yline MV, sort lcolor(black) lwidth(vthin)), xlabel(0 1 2 3 4 5 6, nogrid labsize(small)) ylabel(0.1 0.05 0 -0.05 -0.1 -0.15, axis(1) grid glwidth(thin) glcolor(gs14) labsize(small)) ylabel(0 5 10 15, axis(2) nogrid labsize(small)) yline(0, lcolor(black) lwidth(vthin) lpattern(solid)) xscale(lwidth(vthin) line) yscale(lwidth(vthin) line alt axis(1)) yscale(lwidth(vthin) line alt axis(2)) xtitle("Partisan Dominance (Distance from 50-50)", margin(small) size(small)) ytitle("Marginal Effect of Comparative Disadvantage", margin(small) size(small)) ytitle(Percentage of Observations, axis(2) orientation(rvertical) margin(small) size(small)) title(Table 4 (Model 5), size(medsmall)) subtitle(Dep. Var: Tariffs on Dutiable Imports, size(small)) legend(off order(1 "95% Confidence Interval") size(small)) plotregion(fcolor(none) lcolor(none) ifcolor(none) ilcolor(none)) scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

********************************************************************************
*Fig. 3f. The Marginal Effect Plot for Comparative Disadvantage, Table 4 (Model 6)
********************************************************************************
*Table 4 (Model 6)
xtpcse tfd_ BRdisadv h50con1_ h501BR_ geocon indcon size ltfd_ i.dy1, pairwise corr(psar1) 

matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1] 
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb2=V[2,2] 
scalar varb3=V[3,3]
scalar covb1b3=V[1,3] 
scalar covb2b3=V[2,3]
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3

*Data generation
drop MV conb conse a upper lower
sum h50con1_ 
generate MV=(_n-1)/100
replace MV=. if _n>1401
sum MV

gen conb=b1+b3*MV if _n<=1401
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<=1401
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

/*Fig. 3f. The Marginal Effect of Comparative Disadvantage on "Tariffs on Dutiable 
           Imports" against Partisan Dominance (House Marginality)*/
graph twoway (histogram h50con1_, width(0.04) percent fcolor(gs11) lcolor(gs11) yaxis(2)) (line conb MV, sort lcolor(black) lwidth(medthin) lpattern(solid) yaxis(1)) (line upper MV, sort lcolor(black) lwidth(vthin) lpattern(dash)) (line lower MV, sort lcolor(black) lwidth(vthin) lpattern(dash)) (line yline MV, sort lcolor(black) lwidth(vthin)), xlabel(0 2 4 6 8 10 12 14, nogrid labsize(small)) ylabel(0.1 0 -0.1 -0.2 -0.3, axis(1) grid glwidth(thin) glcolor(gs14) labsize(small)) ylabel(0 4 8 12, axis(2) nogrid labsize(small)) yline(0, lcolor(black) lwidth(vthin) lpattern(solid)) xscale(lwidth(vthin) line) yscale(lwidth(vthin) line alt axis(1)) yscale(lwidth(vthin) line alt axis(2)) xtitle(“Partisan Dominance (House Marginality)”, margin(small) size(small)) ytitle(“Marginal Effect of Comparative Disadvantage”, margin(small) size(small)) ytitle(Percentage of Observations, axis(2) orientation(rvertical) margin(small) size(small)) title(Table 4 (Model 6), size(medsmall)) subtitle(Dep. Var: Tariffs on Dutiable Imports, size(small)) legend(off order(1 "95% Confidence Interval") size(small)) plotregion(fcolor(none) lcolor(none) ifcolor(none) ilcolor(none)) scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

**THE END
