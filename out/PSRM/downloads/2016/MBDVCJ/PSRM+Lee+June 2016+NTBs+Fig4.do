


********************************************************************************
*Fig. 4. Political Characteristics of Industries and the Marginal Effects of Comparative Disadvantage on NTBs
********************************************************************************
*use "PSRM+Lee+sic87+ntbs+1990s+sum.dta", clear

*Interaction Terms
gen RDconBR_=RDcon_*BRdisadv
gen psg501BR_=psg50dcon1_*BRdisadv
gen h501BR_=h50con1_*BRdisadv

*Generate y=0 line
gen yline=0
graph set window fontface "Times New Roman"

********************************************************************************
*Fig. 4a. The marginal effect plot based on the results in Table 5 (Model 1)
********************************************************************************
reg ncov3 BRdisadv RDcon_ RDconBR_ geocon indcon size ltfc, vce(cluster sic)

sum grfd1con_ 
generate MV=(_n-1)/50
replace MV=. if _n>241
sum MV

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

gen conb=b1+b3*MV if _n<=241
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<=241
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

/*Fig. 4a. The Marginal Effect of Comparative Disadvantage on "NTB Coverage 
           Ratio" against Partisan Dominance (Average Presidential Vote)*/
graph twoway (histogram RDcon_, width(0.01) percent fcolor(gs11) lcolor(gs11) yaxis(2)) (line conb MV, sort lcolor(black) lwidth(medthin) lpattern(solid) yaxis(1)) (line upper MV, sort lcolor(black) lwidth(thin) lpattern(dash)) (line lower MV, sort lcolor(black) lwidth(thin) lpattern(dash)) (line yline MV, sort lcolor(black) lwidth(vthin)), xlabel(0 1 2 3 4 5, nogrid labsize(small)) ylabel(0.5 0 -1 -2 -3, axis(1) grid glwidth(thin) glcolor(gs14) labsize(small)) ylabel(0 5 10 15, axis(2) nogrid labsize(small)) yline(0, lcolor(black) lwidth(vthin) lpattern(solid)) xscale(lwidth(vthin) line) yscale(lwidth(vthin) line alt axis(1)) yscale(lwidth(vthin) line alt axis(2)) xtitle("Partisan Dominance (Average Presidential Vote)", margin(small) size(small)) ytitle("Marginal Effect of Comparative Disadvantage", margin(small) size(small)) ytitle(Percentage of Observations, axis(2) orientation(rvertical) margin(small) size(small)) title(Table 5 (Model 1), size(medsmall)) subtitle(Dep. Var: NTB Coverage Ratio, size(small)) legend(off order(1 "95% Confidence Interval") size(small)) plotregion(fcolor(none) lcolor(none) ifcolor(none) ilcolor(none)) scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white)) bgcolor(white)

********************************************************************************
*Fig. 4b. The marginal effect plot based on the results in Table 5 (Model 2)
********************************************************************************
reg ncov3 BRdisadv psg50dcon1_ psg501BR_ geocon indcon size ltfc, vce(cluster sic)

drop MV conb conse a upper lower
sum psg50dcon1_ 
generate MV=(_n-1)/80
replace MV=. if _n>257
sum MV

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

gen conb=b1+b3*MV if _n<=257
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<=257
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

/*Fig. 4b. The Marginal Effect of Comparative Disadvantage on "NTB Coverage 
          Ratio" against Partisan Dominance (Distance from 50-50)*/
graph twoway (histogram psg50dcon1_, width(0.03) percent fcolor(gs11) lcolor(gs11) yaxis(2)) (line conb MV, sort lcolor(black) lwidth(medthin) lpattern(solid) yaxis(1)) (line upper MV, sort lcolor(black) lwidth(thin) lpattern(dash)) (line lower MV, sort lcolor(black) lwidth(thin) lpattern(dash)) (line yline MV, sort lcolor(black) lwidth(vthin)), xlabel(0 1 2 3, nogrid labsize(small)) ylabel(0.5 0 -0.5 -1 -1.5 -2 -2.5, axis(1) grid glwidth(thin) glcolor(gs14) labsize(small)) ylabel(0 5 10 15, axis(2) nogrid labsize(small)) yline(0, lcolor(black) lwidth(vthin) lpattern(solid)) xscale(lwidth(vthin) line) yscale(lwidth(vthin) line alt axis(1)) yscale(lwidth(vthin) line alt axis(2)) xtitle(“Partisan Dominance (Distance from 50-50)”, margin(small) size(small)) ytitle(“Marginal Effect of Comparative Disadvantage”, margin(small) size(small)) ytitle(Percentage of Observations, axis(2) orientation(rvertical) margin(small) size(small)) title(Table 5 (Model 2), size(medsmall)) subtitle(Dep. Var: NTB Coverage Ratio, size(small)) legend(off order(1 "95% Confidence Interval") size(small)) plotregion(fcolor(none) lcolor(none) ifcolor(none) ilcolor(none)) scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white)) bgcolor(white)

********************************************************************************
*Fig. 4c. The marginal effect plot based on the results in Table 5 (Model 3)
********************************************************************************
reg ncov3 BRdisadv h50con1_ h501BR_ geocon indcon size ltfc, vce(cluster sic)

drop MV conb conse a upper lower
sum h50con1_ 
generate MV=(_n-1)/40
replace MV=. if _n>305
sum MV

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

gen conb=b1+b3*MV if _n<=305
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<=305
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

/*Fig 4c. The Marginal Effect of Comparative Disadvantage on "NTB Coverage 
          Ratio" against Partisan Dominance (House Marginality)*/
graph twoway (histogram h50con1_, width(0.04) percent fcolor(gs11) lcolor(gs11) yaxis(2)) (line conb MV, sort lcolor(black) lwidth(medthin) lpattern(solid) yaxis(1)) (line upper MV, sort lcolor(black) lwidth(thin) lpattern(dash)) (line lower MV, sort lcolor(black) lwidth(thin) lpattern(dash)) (line yline MV, sort lcolor(black) lwidth(vthin)), xlabel(0 1 2 3 4 5 6 7, nogrid labsize(small)) ylabel(0.5 0 -1 -2 -3 -4 -5, axis(1) grid glwidth(thin) glcolor(gs14) labsize(small)) ylabel(0 4 8 12, axis(2) nogrid labsize(small)) yline(0, lcolor(black) lwidth(vthin) lpattern(solid)) xscale(lwidth(vthin) line) yscale(lwidth(vthin) line alt axis(1)) yscale(lwidth(vthin) line alt axis(2)) xtitle(“Partisan Dominance (House Marginality)”, margin(small) size(small)) ytitle(“Marginal Effect of Comparative Disadvantage”, margin(small) size(small)) ytitle(Percentage of Observations, axis(2) orientation(rvertical) margin(small) size(small)) title(Table 5 (Model 3), size(medsmall)) subtitle(Dep. Var: NTB Coverage Ratio, size(small)) legend(off order(1 "95% Confidence Interval") size(small)) plotregion(fcolor(none) lcolor(none) ifcolor(none) ilcolor(none)) scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white)) bgcolor(white)

********************************************************************************
*Fig. 4d. The marginal effect plot based on the results in Table 5 (Model 4)
********************************************************************************
reg nfq3 BRdisadv RDcon_ RDconBR_ geocon indcon size ltfc_, vce(cluster sic)

drop MV conb conse a upper lower
sum grfd1con_ 
generate MV=(_n-1)/50
replace MV=. if _n>241
sum MV

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

gen conb=b1+b3*MV if _n<=241
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<=241
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

/*Fig. 4d. The Marginal Effect of Comparative Disadvantage on "NTB Frequency
           Ratio" against Partisan Dominance (Average Presidential Vote)*/
graph twoway (histogram RDcon_, width(0.01) percent fcolor(gs11) lcolor(gs11) yaxis(2)) (line conb MV, sort lcolor(black) lwidth(medthin) lpattern(solid) yaxis(1)) (line upper MV, sort lcolor(black) lwidth(thin) lpattern(dash)) (line lower MV, sort lcolor(black) lwidth(thin) lpattern(dash)) (line yline MV, sort lcolor(black) lwidth(vthin)), xlabel(0 1 2 3 4 5, nogrid labsize(small)) ylabel(0.5 0 -1 -2 -3, axis(1) grid glwidth(thin) glcolor(gs14) labsize(small)) ylabel(0 5 10 15, axis(2) nogrid labsize(small)) yline(0, lcolor(black) lwidth(vthin) lpattern(solid)) xscale(lwidth(vthin) line) yscale(lwidth(vthin) line alt axis(1)) yscale(lwidth(vthin) line alt axis(2)) xtitle("Partisan Dominance (Average Presidential Vote)", margin(small) size(small)) ytitle("Marginal Effect of Comparative Disadvantage", margin(small) size(small)) ytitle(Percentage of Observations, axis(2) orientation(rvertical) margin(small) size(small)) title(Table 5 (Model 4), size(medsmall)) subtitle(Dep. Var: NTB Frequency Ratio, size(small)) legend(off order(1 "95% Confidence Interval") size(small)) plotregion(fcolor(none) lcolor(none) ifcolor(none) ilcolor(none)) scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white)) bgcolor(white)

********************************************************************************
*Fig. 4e. The marginal effect plot based on the results in Table 5 (Model 5)
********************************************************************************
reg nfq3 BRdisadv psg50dcon1_ psg501BR_ geocon indcon size ltfc_, vce(cluster sic)

drop MV conb conse a upper lower
sum psg50dcon1_ 
generate MV=(_n-1)/80
replace MV=. if _n>257
sum MV

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

gen conb=b1+b3*MV if _n<=257
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<=257
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

/*Fig. 4e. The Marginal Effect of Comparative Disadvantage on "NTB Frequency 
          Ratio" against Partisan Dominance (Distance from 50-50)*/
graph twoway (histogram psg50dcon1_, width(0.03) percent fcolor(gs11) lcolor(gs11) yaxis(2)) (line conb MV, sort lcolor(black) lwidth(medthin) lpattern(solid) yaxis(1)) (line upper MV, sort lcolor(black) lwidth(thin) lpattern(dash)) (line lower MV, sort lcolor(black) lwidth(thin) lpattern(dash)) (line yline MV, sort lcolor(black) lwidth(vthin)), xlabel(0 1 2 3, nogrid labsize(small)) ylabel(0.5 0 -0.5 -1 -1.5 -2 -2.5, axis(1) grid glwidth(thin) glcolor(gs14) labsize(small)) ylabel(0 5 10 15, axis(2) nogrid labsize(small)) yline(0, lcolor(black) lwidth(vthin) lpattern(solid)) xscale(lwidth(vthin) line) yscale(lwidth(vthin) line alt axis(1)) yscale(lwidth(vthin) line alt axis(2)) xtitle(“Partisan Dominance (Distance from 50-50)”, margin(small) size(small)) ytitle(“Marginal Effect of Comparative Disadvantage”, margin(small) size(small)) ytitle(Percentage of Observations, axis(2) orientation(rvertical) margin(small) size(small)) title(Table 5 (Model 5), size(medsmall)) subtitle(Dep. Var: NTB Frequency Ratio, size(small)) legend(off order(1 "95% Confidence Interval") size(small)) plotregion(fcolor(none) lcolor(none) ifcolor(none) ilcolor(none)) scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white)) bgcolor(white)

********************************************************************************
*Fig. 4f. The marginal effect plot based on the results in Table 5 (Model 6)
********************************************************************************
reg nfq3 BRdisadv h50con1_ h501BR_ geocon indcon size ltfc_, vce(cluster sic)

drop MV conb conse a upper lower
sum h50con1_ 
generate MV=(_n-1)/40
replace MV=. if _n>305
sum MV

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

gen conb=b1+b3*MV if _n<=305
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<=305
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

/*Fig 4f. The Marginal Effect of Comparative Disadvantage on "NTB Frequency 
          Ratio" against Partisan Dominance (House Marginality)*/
graph twoway (histogram h50con1_, width(0.04) percent fcolor(gs11) lcolor(gs11) yaxis(2)) (line conb MV, sort lcolor(black) lwidth(medthin) lpattern(solid) yaxis(1)) (line upper MV, sort lcolor(black) lwidth(thin) lpattern(dash)) (line lower MV, sort lcolor(black) lwidth(thin) lpattern(dash)) (line yline MV, sort lcolor(black) lwidth(vthin)), xlabel(0 1 2 3 4 5 6 7, nogrid labsize(small)) ylabel(0.5 0 -1 -2 -3 -4 -5, axis(1) grid glwidth(thin) glcolor(gs14) labsize(small)) ylabel(0 4 8 12, axis(2) nogrid labsize(small)) yline(0, lcolor(black) lwidth(vthin) lpattern(solid)) xscale(lwidth(vthin) line) yscale(lwidth(vthin) line alt axis(1)) yscale(lwidth(vthin) line alt axis(2)) xtitle(“Partisan Dominance (House Marginality)”, margin(small) size(small)) ytitle(“Marginal Effect of Comparative Disadvantage”, margin(small) size(small)) ytitle(Percentage of Observations, axis(2) orientation(rvertical) margin(small) size(small)) title(Table 5 (Model 6), size(medsmall)) subtitle(Dep. Var: NTB Frequency Ratio, size(small)) legend(off order(1 "95% Confidence Interval") size(small)) plotregion(fcolor(none) lcolor(none) ifcolor(none) ilcolor(none)) scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white)) bgcolor(white)


**THE END
