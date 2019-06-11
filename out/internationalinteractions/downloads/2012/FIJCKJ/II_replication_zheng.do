/*Replication Data for "Credibility and Flexibility: Political Institutions, Governance, and Foreign Direct Investment"
Forthcoming in International Interactions
Yu Zheng
University of Connecticut
yu.zheng@uconn.edu
March 2011*/


//USE II_zheng2011_1.dta FOR THE FOLLOWING//

//Table 1: Veto Players, Democracy, and FDI//
/*model 1*/
xtpcse fdigdp lchecks lcheckssq lgdppc lpop growth fixcapgdp trade industrygdp if oecd==0, correlation(psar1) hetonly 
/*model 2*/
xtpcse fdigdp polconiii polconiiisq lgdppc lpop growth fixcapgdp trade industrygdp if oecd==0, correlation(psar1) hetonly 
/*model 3*/
xtpcse fdigdp polity2 polity2sq lgdppc lpop growth fixcapgdp trade industrygdp if oecd==0, correlation(psar1) hetonly 

//Table 2: Conditional Effect of Veto Players and Democracy on FDI//

/*model 1*/
xtpcse fdigdp lchecks regquality96 lchecksreg96 lgdppc lpop growth fixcapgdp trade industrygdp if oecd==0, correlation(psar1) hetonly 
/*model 2*/
xtpcse fdigdp polconiii regquality96 polconreg96 lgdppc lpop growth fixcapgdp trade industrygdp if oecd==0, correlation(psar1) hetonly 
/*model 3*/
xtpcse fdigdp polity2 regquality96 polityreg96 lgdppc lpop growth fixcapgdp trade industrygdp if oecd==0, correlation(psar1) hetonly 
/*model 4*/
xtpcse fdigdp lchecks shock_sdebt lchecks_sdebt lgdppc lpop growth fixcapgdp trade industrygdp if oecd==0, correlation(psar1) hetonly 
/*model 5*/
xtpcse fdigdp polconiii shock_sdebt polcon_sdebt lgdppc lpop growth fixcapgdp trade industrygdp if oecd==0, correlation(psar1) hetonly 
/*model 6*/
xtpcse fdigdp polity2 shock_sdebt polity2_sdebt lgdppc lpop growth fixcapgdp trade industrygdp if oecd==0, correlation(psar1) hetonly 

//Figure 1: Impact of Veto Players on FDI/GDP//

gen mlgdppc=lgdppc-r(mean)
gen mlpop=lpop-r(mean)
gen mgrowth=growth-r(mean)
gen mfixcapgdp=fixcapgdp-r(mean)
gen mtrade=trade-r(mean)
gen mindustrygdp=industry-r(mean)

xtpcse fdigdp lchecks lcheckssq mlgdppc mlpop mgrowth mfixcapgdp mtrade mindustrygdp if oecd==0, correlation(psar1) hetonly 
predict yhat
twoway (qfitci yhat lchecks if oecd==0 & checks<10, clwidth(medthick)), ytitle(FDI/GDP) xtitle(log Checks)

//Figure 2: Marginal Effects of Veto Players on FDI/GDP (conditioned upon regulatory quality)//

xtpcse fdigdp lchecks regquality96 lchecksreg96 lgdppc lpop growth fixcapgdp trade industrygdp if oecd==0, correlation(psar1) hetonly 

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

gen conb=b1+b3*regquality96
gen conse=sqrt(varb1+varb3*(regquality96^2)+2*covb1b3*regquality96) 

gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

twoway (line conb regquality96, clwidth(medium) clcolor(blue) clcolor(black)) (line upper regquality96, clpattern(dash) clwidth(thin) clcolor(black))/* 
*/(line lower regquality96, clpattern(dash) clwidth(thin) clcolor(black)), legend(off) yline(0) ytitle(Marginal Effect with 95% C.I.) /* 
*/xtitle(Regulatory Quality) 


//Figure 3: Marginal Effects of Veto Players on FDI/GDP (conditioned upon the vulnerability of external shocks)//

drop conb conse a upper lower

xtpcse fdigdp lchecks shock_sdebt lchecks_sdebt lgdppc lpop growth fixcapgdp trade industrygdp if oecd==0, correlation(psar1) hetonly 

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

gen conb=b1+b3*shock_sdebt
gen conse=sqrt(varb1+varb3*(shock_sdebt^2)+2*covb1b3*shock_sdebt) 

gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

twoway (line conb shock_sdebt, clwidth(medium) clcolor(blue) clcolor(black)) (line upper shock_sdebt, clpattern(dash) clwidth(thin) clcolor(black))/* 
*/(line lower shock_sdebt, clpattern(dash) clwidth(thin) clcolor(black)), legend(off) yline(0) ytitle(Marginal Effect with 95% C.I.) /* 
*/xtitle(Vulnerability to External Shocks) 



//USE II_zheng2011_2.dta FOR THE FOLLOWING//

//Table 3: Ordered Probit Results: Political Institutions and Tax Incentives//
/*model 1*/
oprobit fincentive_3c lchecks lgdppc lpop growth fixcapgdp trade industrygdp, r
/*model 2*/
oprobit nfincentive_3c lchecks lgdppc lpop growth fixcapgdp trade industrygdp, r

//Table 4: Effect of Change in Veto Players on Investment Incentives//
estsimp oprobit fincentive_3c lchecks lgdppc lpop growth fixcapgdp trade industrygdp, r table
setx mean
simqi fd(pr) changex(lchecks .85 1.45)

estsimp oprobit nfincentive_3c lchecks lgdppc lpop growth fixcapgdp trade industrygdp, r table
setx mean
simqi fd(pr) changex(lchecks .85 1.45)



