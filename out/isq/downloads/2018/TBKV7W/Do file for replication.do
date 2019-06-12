
##For use with the count dataset

##Model 1.1
xtgee majorforce lowlppc cpi unemp dempres approval hegpower war, f(nbinomial) t(time) i(group) force robust corr(ar3)

##Model 1.2
xtgee majorforce lowlppc cpi  unemp dempres dempres_cpi lowlppc_cpi_dempres lowlppc_cpi lowlppc_dempres approval hegpower war, f(nbinomial) t(time) i(group) force robust corr(ar3)

##Generate Figure 2

matrix b=e(b) 
matrix V=e(V)

scalar bz=b[1,1] 
scalar bx=b[1,2]
scalar bxw=b[1,5]
scalar bxzw=b[1,6]
scalar bxz=b[1,7]

scalar varbz=V[1,1] 
scalar varbx=V[2,2]
scalar varbxw=V[5,5]
scalar varbxzw=V[6,6] 
scalar varbxz=V[7,7]

scalar covbxbxz=V[2,7]
scalar covbxbxw=V[2,5]
scalar covbxbxzw=V[2,6]
scalar covbxzbxw=V[7,5]
scalar covbxzbxzw=V[7,6]
scalar covbxwbxzw=V[5,6]

gen marg3=bx+(bxz*lowlppc) +(bxw*dempres) +(bxzw*lowlppc_dempres)

gen se3=sqrt(varbx+(varbxz*(lowlppc^2))+(varbxw*(dempres^2))+(varbxzw*(lowlppc^2)*(dempres^2))+(2*covbxbxz*lowlppc)+(2*covbxbxw*dempres)+(2*covbxbxzw*lowlppc*dempres)+(2*covbxzbxw*lowlppc*dempres)+(2*covbxzbxzw*(lowlppc^2)*dempres)+(2*covbxwbxzw*lowlppc*(dempres^2)))

gen upper3 = marg3+(se3*1.96)

gen lower3 = marg3-(se3*1.96)

twoway (line marg3 lowlppc if dempres==1, sort clcolor(black)) (line upper3 lowlppc if dempres==1, sort clpattern(dash) clcolor(black))/* 
*/(line lower3 lowlppc if dempres==1, sort clpattern(dash) clcolor(black)), legend(off) yline(0) ytitle(Marginal Effect of CPI with 95% C.I.) /* 
*/xtitle(President's Party Power) subtitle(Democratic President)

graph save figure1.gph, replace

twoway (line marg3 lowlppc if dempres==0, sort clcolor(black)) (line upper3 lowlppc if dempres==0, sort clpattern(dash) clcolor(black))/* 
*/(line lower3 lowlppc if dempres==0, sort clpattern(dash) clcolor(black)), legend(off) yline(0)  ytitle(Marginal Effect of CPI with 95% C.I.)/* 
*/xtitle(President's Party Power) subtitle(Republican President)

graph save figure2.gph, replace

graph combine figure1.gph figure2.gph

##Model 1.3

xtgee majorforce lowlppc  unemp cpi dempres dempres_unemp lowlppc_unemp_dempres lowlppc_unemp lowlppc_dempres approval hegpower war, f(nbinomial) t(time) i(group) force robust corr(ar3)

##Generate Figure 3

matrix b=e(b) 
matrix V=e(V)

scalar bz=b[1,1] 
scalar bx=b[1,2]
scalar bxw=b[1,5]
scalar bxzw=b[1,6]
scalar bxz=b[1,7]

scalar varbz=V[1,1] 
scalar varbx=V[2,2]
scalar varbxw=V[5,5]
scalar varbxzw=V[6,6] 
scalar varbxz=V[7,7]

scalar covbxbxz=V[2,7]
scalar covbxbxw=V[2,5]
scalar covbxbxzw=V[2,6]
scalar covbxzbxw=V[7,5]
scalar covbxzbxzw=V[7,6]
scalar covbxwbxzw=V[5,6]

gen marg3=bx+(bxz*lowlppc) +(bxw*dempres) +(bxzw*lowlppc_dempres)

gen se3=sqrt(varbx+(varbxz*(lowlppc^2))+(varbxw*(dempres^2))+(varbxzw*(lowlppc^2)*(dempres^2))+(2*covbxbxz*lowlppc)+(2*covbxbxw*dempres)+(2*covbxbxzw*lowlppc*dempres)+(2*covbxzbxw*lowlppc*dempres)+(2*covbxzbxzw*(lowlppc^2)*dempres)+(2*covbxwbxzw*lowlppc*(dempres^2)))

gen upper3 = marg3+(se3*1.96)

gen lower3 = marg3-(se3*1.96)

twoway (line marg3 lowlppc if dempres==1, sort clcolor(black)) (line upper3 lowlppc if dempres==1, sort clpattern(dash) clcolor(black))/* 
*/(line lower3 lowlppc if dempres==1, sort clpattern(dash) clcolor(black)), legend(off) yline(0) ytitle(Marginal Effect of Unemployment with 95% C.I.) /* 
*/xtitle(President's Party Power) subtitle(Democratic President)

graph save figure1.gph, replace

twoway (line marg3 lowlppc if dempres==0, sort clcolor(black)) (line upper3 lowlppc if dempres==0, sort clpattern(dash) clcolor(black))/* 
*/(line lower3 lowlppc if dempres==0, sort clpattern(dash) clcolor(black)), legend(off) yline(0) ytitle(Marginal Effect of Unemployment with 95% C.I.) /* 
*/xtitle(President's Party Power) subtitle(Republican President)

graph save figure2.gph, replace

graph combine figure1.gph figure2.gph

##For use in the dyadic dataset

##Model 2.1
xtgee cwinit lowlppc infl unemp dempres approval caprat polity2 contig2 tau_glob, f(binomial) l(logit) t(year) i(ccode2) force robust corr(ar1), if ccode1==2 

##Model 2.2
xtgee cwinit lowlppc infl  unemp dempres dempres_infl lowlppc_infl_dempres lowlppc_infl lowlppc_dempres approval caprat polity2 contig2 tau_glob, f(binomial) l(logit) t(year) i(ccode2) force robust corr(ar1), if ccode1==2 

##Generate Figure 4
matrix b=e(b) 
matrix V=e(V)

scalar bz=b[1,1] 
scalar bx=b[1,2]
scalar bxw=b[1,5]
scalar bxzw=b[1,6]
scalar bxz=b[1,7]

scalar varbz=V[1,1] 
scalar varbx=V[2,2]
scalar varbxw=V[5,5]
scalar varbxzw=V[6,6] 
scalar varbxz=V[7,7]

scalar covbxbxz=V[2,7]
scalar covbxbxw=V[2,5]
scalar covbxbxzw=V[2,6]
scalar covbxzbxw=V[7,5]
scalar covbxzbxzw=V[7,6]
scalar covbxwbxzw=V[5,6]

gen marg3=bx+(bxz*lowlppc) +(bxw*dempres) +(bxzw*lowlppc_dempres)

gen se3=sqrt(varbx+(varbxz*(lowlppc^2))+(varbxw*(dempres^2))+(varbxzw*(lowlppc^2)*(dempres^2))+(2*covbxbxz*lowlppc)+(2*covbxbxw*dempres)+(2*covbxbxzw*lowlppc*dempres)+(2*covbxzbxw*lowlppc*dempres)+(2*covbxzbxzw*(lowlppc^2)*dempres)+(2*covbxwbxzw*lowlppc*(dempres^2)))

gen upper3 = marg3+(se3*1.96)

gen lower3 = marg3-(se3*1.96)

twoway (line marg3 lowlppc if dempres==1, sort clcolor(black)) (line upper3 lowlppc if dempres==1, sort clpattern(dash) clcolor(black))/* 
*/(line lower3 lowlppc if dempres==1, sort clpattern(dash) clcolor(black)), legend(off) yline(0) ytitle(Marginal Effect of CPI with 95% C.I.) /* 
*/xtitle(President's Party Power) subtitle(Democratic President)

graph save figure1.gph, replace

twoway (line marg3 lowlppc if dempres==0, sort clcolor(black)) (line upper3 lowlppc if dempres==0, sort clpattern(dash) clcolor(black))/* 
*/(line lower3 lowlppc if dempres==0, sort clpattern(dash) clcolor(black)), legend(off) yline(0)  ytitle(Marginal Effect of CPI with 95% C.I.)/* 
*/xtitle(President's Party Power) subtitle(Republican President)

graph save figure2.gph, replace

graph combine figure1.gph figure2.gph

##model 2.3
xtgee cwinit lowlppc unemp infl dempres dempres_unemp lowlppc_unemp_dempres lowlppc_unemp lowlppc_dempres approval caprat polity2 contig2 tau_glob, f(binomial) l(logit) t(year) i(ccode2) force robust corr(ar1), if ccode1==2 

##Generate figure 5
matrix b=e(b) 
matrix V=e(V)

scalar bz=b[1,1] 
scalar bx=b[1,2]
scalar bxw=b[1,5]
scalar bxzw=b[1,6]
scalar bxz=b[1,7]

scalar varbz=V[1,1] 
scalar varbx=V[2,2]
scalar varbxw=V[5,5]
scalar varbxzw=V[6,6] 
scalar varbxz=V[7,7]

scalar covbxbxz=V[2,7]
scalar covbxbxw=V[2,5]
scalar covbxbxzw=V[2,6]
scalar covbxzbxw=V[7,5]
scalar covbxzbxzw=V[7,6]
scalar covbxwbxzw=V[5,6]

gen marg3=bx+(bxz*lowlppc) +(bxw*dempres) +(bxzw*lowlppc_dempres)

gen se3=sqrt(varbx+(varbxz*(lowlppc^2))+(varbxw*(dempres^2))+(varbxzw*(lowlppc^2)*(dempres^2))+(2*covbxbxz*lowlppc)+(2*covbxbxw*dempres)+(2*covbxbxzw*lowlppc*dempres)+(2*covbxzbxw*lowlppc*dempres)+(2*covbxzbxzw*(lowlppc^2)*dempres)+(2*covbxwbxzw*lowlppc*(dempres^2)))

gen upper3 = marg3+(se3*1.96)

gen lower3 = marg3-(se3*1.96)

twoway (line marg3 lowlppc if dempres==1, sort clcolor(black)) (line upper3 lowlppc if dempres==1, sort clpattern(dash) clcolor(black))/* 
*/(line lower3 lowlppc if dempres==1, sort clpattern(dash) clcolor(black)), legend(off) yline(0) ytitle(Marginal Effect of Unemployment with 95% C.I.) /* 
*/xtitle(President's Party Power) subtitle(Democratic President)

graph save figure1.gph, replace

twoway (line marg3 lowlppc if dempres==0, sort clcolor(black)) (line upper3 lowlppc if dempres==0, sort clpattern(dash) clcolor(black))/* 
*/(line lower3 lowlppc if dempres==0, sort clpattern(dash) clcolor(black)), legend(off) yline(0) ytitle(Marginal Effect of Unemployment with 95% C.I.) /* 
*/xtitle(President's Party Power) subtitle(Republican President)

graph save figure2.gph, replace

graph combine figure1.gph figure2.gph



