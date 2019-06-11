


********************************************************************************
*Fig. 2. The Marginal Effects of Comparative Disadvantage on Nontariff Protection
********************************************************************************
*use "PSRM+Lee+sic87+ntbs+1990s+sum.dta", clear

*Interaction Term
gen grfd1BR_=grfd1con_*BRdisadv

********************************************************************************
*Fig. 2a. The Marginal effect of Comparative Disadvantage on "NTB Coverage Ratio"
********************************************************************************
*Table 3 (Model 2)
reg ncov3 BRdisadv grfd1con_ grfd1BR_ geocon indcon size ltfc_, vce (cluster sic)

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
generate MV=(_n-1)/50
replace MV=. if _n>218
sum MV

gen conb=b1+b3*MV if _n<=218

gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<=218

gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

gen yline=0
graph set window fontface "Times New Roman"

/*Fig. 2a. The Marginal Effect of of Comparative Disadvantage on "NTB Coverage 
           Ratio" against Partisan Dominance */
graph twoway (histogram grfd1con_, width(0.05) percent fcolor(gs11) lcolor(gs11) yaxis(2)) (line conb MV, sort lcolor(black) lwidth(medium) lpattern(solid) yaxis(1)) (line upper MV, sort lcolor(black) lwidth(thin) lpattern(dash)) (line lower MV, sort lcolor(black) lwidth(thin) lpattern(dash)) (line yline MV, sort lcolor(black) lwidth(vthin)), xlabel(0 1 2 3 4, nogrid labsize(medsmall)) ylabel(0.5 0 -0.5 -1 -1.5 -2 -2.5, axis(1) grid glwidth(thin) glcolor(gs14) labsize(medsmall)) ylabel(0 5 10 15 20, axis(2) nogrid labsize(medsmall)) yline(0, lcolor(black) lwidth(vthin) lpattern(solid)) xscale(lwidth(vthin) line) yscale(lwidth(vthin) line alt axis(1)) yscale(lwidth(vthin) line alt axis(2)) xtitle("Partisan Dominance", margin(small) size(medsmall)) ytitle("Marginal Effect of Comparative Disadvantage", margin(small) size(medsmall)) ytitle(Percentage of Observations, axis(2) orientation(rvertical) margin(small) size(medsmall)) title(Table 3 (Model 2), size(medium)) subtitle(Dep. Var: NTB Coverage Ratio, size(medsmall)) legend(off order(1 "95% Confidence Interval") size(small)) plotregion(fcolor(none) lcolor(none) ifcolor(none) ilcolor(none)) scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white)) bgcolor(white)

********************************************************************************
*Fig. 2b. The Marginal effect of Comparative Disadvantage on "NTB Frequency Ratio"
********************************************************************************
*Table 3 (Model 5)
reg nfq3 BRdisadv grfd1con_ grfd1BR_ geocon indcon size ltfc_, vce (cluster sic)

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

*Data Generation
drop MV conb conse a upper lower

sum grfd1con_ 
generate MV=(_n-1)/50
replace MV=. if _n>218
sum MV

gen conb=b1+b3*MV if _n<=218

gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<=218

gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

/*Fig. 2b. The Marginal Effect of of Comparative Disadvantage on "NTB Frequency 
           Ratio" against Partisan Dominance */
graph twoway (histogram grfd1con_, width(0.05) percent fcolor(gs11) lcolor(gs11) yaxis(2)) (line conb MV, sort lcolor(black) lwidth(medium) lpattern(solid) yaxis(1)) (line upper MV, sort lcolor(black) lwidth(thin) lpattern(dash)) (line lower MV, sort lcolor(black) lwidth(thin) lpattern(dash)) (line yline MV, sort lcolor(black) lwidth(vthin)), xlabel(0 1 2 3 4, nogrid labsize(medsmall)) ylabel(0.5 0 -0.5 -1 -1.5 -2 -2.5, axis(1) grid glwidth(thin) glcolor(gs14) labsize(medsmall)) ylabel(0 5 10 15 20, axis(2) nogrid labsize(medsmall)) yline(0, lcolor(black) lwidth(vthin) lpattern(solid)) xscale(lwidth(vthin) line) yscale(lwidth(vthin) line alt axis(1)) yscale(lwidth(vthin) line alt axis(2)) xtitle(“Partisan Dominance”, margin(small) size(medsmall)) ytitle(“Marginal Effect of Comparative Disadvantage”, margin(small) size(medsmall)) ytitle(Percentage of Observations, axis(2) orientation(rvertical) margin(small) size(medsmall)) title(Table 3 (Model 5), size(medium)) subtitle(Dep. Var: NTB Frequency Ratio, size(medsmall)) legend(off order(1 "95% Confidence Interval") size(small)) plotregion(fcolor(none) lcolor(none) ifcolor(none) ilcolor(none)) scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white)) bgcolor(white)

**THE END
