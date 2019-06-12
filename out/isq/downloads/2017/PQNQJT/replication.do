***************************************************** 
*  "Globalization, Factor Mobility, Partisanship,   *
*         and Compensaton Policies"                 *
*                                                   * 
*       - Wonjae Hwang & Hoon Lee-                  *
*          Sep. 10, 2012 (Stata 11)                 *                                                   *
***************************************************** 


** Replication **
set mem 500m

use "C:\replication(H&L).dta", clear

/*Table 1*/
* Model 1.1.
xtscc welgovfd welgovfd_1 welgov_1 impfd wdi_imp_1 expfd fdifd bondeqfd lgdppcfd wdi_gdpgr_1 neigh_wel_1, fe

* Model 1.2.
xtscc welgovfd welgovfd_1 welgov_1 impfd wdi_imp_1 expfd fdifd bondeqfd lgdppcfd wdi_gdpgr_1 pr2_1 gtm_parl_1 partyor_1 ud_1 neigh_wel_1, fe

* Model 1.3.
xtscc subgovfd subgovfd_1 subgov_1 impfd wdi_imp_1 expfd fdifd bondeqfd lgdppcfd wdi_gdpgr_1 neigh_subgov_1, fe

* Model 1.4. 
xtscc subgovfd subgovfd_1 subgov_1 impfd wdi_imp_1 expfd fdifd bondeqfd lgdppcfd wdi_gdpgr_1 pr2_1 gtm_parl_1 partyor_1 ud_1 neigh_subgov_1, fe

/*Table 2*/
reg3 (subgov = subgov_1 welgov wdi_ue impfd irpct_1 impfdfm wdi_imp_1 expfd fdifd bondeqfd pr2_1 gtm_parl_1 partyor_1 ud_1 neigh_subgov_1) /*
*/ (welgov = welgov_1 subgov wdi_ue impfd irpct_1 impfdfm wdi_imp_1 fdifd bondeqfd lgdppcfd pr2_1 gtm_parl_1 partyor_1 ud_1 neigh_wel_1) /* 
*/ (wdi_ue = wdi_ue_1 welgov subgov impfd irpct_1 impfdfm wdi_imp_1 fdifd wdi_gdpgr_1 pr2_1 gtm_parl_1 partyor_1 ud_1 neigh_unem_1) 

/*Table 3*/
** Model 3.1 
xtscc swratio  impfd irpct_1  impfdfm wdi_imp_1 expfd fdifd bondeqfd lgdppcfd wdi_gdpgr_1 wdi_ue_1 uefd pr2_1 gtm_parl_1 ud_1 partyor_1, fe lag(12)

* Model 3.2 
xtscc swratio  impfd irpct_1  impfdfm wdi_imp_1 expfd fdifd bondeqfd lgdppcfd wdi_gdpgr_1 wdi_ue_1 uefd pr2_1 gtm_parl_1 ud_1 partyor_1 left2impfdfm left2impfd left2fm, fe lag(12)



/*** Figure 2***/
version 8.0

xtscc swratio  impfd irpct_1  impfdfm wdi_imp_1 expfd fdifd bondeqfd lgdppcfd wdi_gdpgr_1 wdi_ue_1 uefd pr2_1 gtm_parl_1 ud_1 partyor_1, fe lag(12)

/**Generate the values of Z to calculate the marginal effect of X on Y**/
gen MV=_n-1

replace MV=. if _n>12

/**variance-covariance matrix**/
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

/**Calculate the marginal effect of X on Y for all MV values of Z**/
gen conb=b1+b3*MV if _n<12

/**Calculate the standard errors for the marginal effect of X on Y**/
gen conse=sqrt(varb1+varb3*(MV*MV)+2*covb1b3*MV) if _n<12

/**Generate upper and lower bounds of the confidence interval**/
gen a=1.96*conse

gen upper=conb+a

gen lower=conb-a

/**Graph the marginal effect of X on Y across Z**/
graph twoway line conb MV, clwidth(medium) clcolor(blue) clcolor(black)|| line upper MV, clpattern(dash) clwidth(thin) clcolor(black)|| line lower MV, clpattern(dash) clwidth(thin) clcolor(black)||, xtitle("Factor Mobility") ytitle("Subsidies/Welfare Ratio")




/*** Figure 4***/

drop MV conb conse a upper lower

version 8.0

xtscc swratio  impfd irpct_1  impfdfm wdi_imp_1 expfd fdifd bondeqfd lgdppcfd wdi_gdpgr_1 wdi_ue_1 uefd pr2_1 gtm_parl_1 ud_1 partyor_1 left2impfdfm left2impfd left2fm, fe lag(12)


/***Generate the values of Z to calculate the marginal effect of X on Y***/

gen MV=_n-1

replace MV=. if _n> 12

/***variance-covariance matrix***/
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

/***Calculate the marginal effect of X on Y for all MV values of Z***/
gen conb=b1+b3*MV if _n< 12

/***Calculate the standard errors for the marginal effect of X on Y***/
gen conse=sqrt(varb1+varb3*(MV*MV)+2*covb1b3*MV) if _n< 12

/***Generate upper and lower bounds of the confidence interval***/
gen a=1.96*conse

gen upper=conb+a

gen lower=conb-a


/***Graph the marginal effect of X on Y across Z***/

graph twoway line conb MV, clwidth(medium) clcolor(blue) clcolor(black)|| line upper MV, clpattern(dash) clwidth(thin) clcolor(black)|| line lower MV, clpattern(dash) clwidth(thin) clcolor(black)||, xtitle("Factor Mobility") ytitle("Subsidies/Welfare Ratio")



/*** Figure 3***/

drop MV conb conse a upper lower


/***Interaction Model (for left government) ***/
sort ccodecow year
gen rightpartyor_1 = partyor_1
recode rightpartyor_1 2=0 1=1 0=2
gen right2impfdfm = rightpartyor_1*impfd*irpct_1
gen right2impfd = rightpartyor_1*impfd
gen right2fm = rightpartyor_1*irpct_1


xtscc swratio impfd irpct_1 impfdfm wdi_imp_1 rightparty_1 right2impfdfm right2impfd right2fm expfd fdifd bondeqfd lgdppcfd wdi_gdpgr_1 wdi_ue_1 uefd pr2_1 gtm_parl_1 ud_1, fe lag(12)


/***Generate the values of Z to calculate the marginal effect of X on Y***/
gen MVa=_n-1

replace MVa=. if _n> 12

/***variance-covariance matrix***/
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

/***Calculate the marginal effect of X on Y for all MV values of Z***/
gen conba=b1+b3*MVa if _n< 12

/***Calculate the standard errors for the marginal effect of X on Y***/
gen consea=sqrt(varb1+varb3*(MVa*MVa)+2*covb1b3*MVa) if _n< 12

/***Generate upper and lower bounds of the confidence interval***/
gen aa=1.96*consea

gen uppera=conba+aa

gen lowera=conba-aa


/***Graph the marginal effect of X on Y across Z***/

graph twoway line conb MV, clwidth(medium) clcolor(blue) clcolor(black)|| line upper MV, clpattern(dash) clwidth(thin) clcolor(black)|| line lower MV, clpattern(dash) clwidth(thin) clcolor(black)||  line conba MVa, clwidth(medium) clcolor(blue) clcolor(black)|| line uppera MVa, clpattern(dash) clwidth(thin) clcolor(black)|| line lowera MVa, clpattern(dash) clwidth(thin) clcolor(black)||, xtitle("Factor Mobility") ytitle("Subsidies/Welfare Ratio")




/*** Figure 5***/
/*(The following commands are used to obtain predicted values for Figure 5. */
/* Using these values, however, we created Figure 5 in SigmaPlot program.) */  

version 8.0

xtscc swratio wdi_imp_1 impfd irpct_1  impfdfm execrlc_1 leftimpfdfm leftimpfd leftfm expfd fdifd bondeqfd lgdppcfd gdpgrfd wdi_ue_1 uefd pr2_1 gtm_parl_1 ud_1, fe lag(12)

predict yhat, xb

** right government**
* FM = 0

mfx, predict(xb) at(mean impfd=-11 irpct_1=0 impfdfm=0 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=-8 irpct_1=0 impfdfm=0 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=-5 irpct_1=0 impfdfm=0 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=-2 irpct_1=0 impfdfm=0 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=0  irpct_1=0 impfdfm=0 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=2 irpct_1=0 impfdfm=0 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1 )
mfx, predict(xb) at(mean impfd=5  irpct_1=0 impfdfm=0 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=8 irpct_1=0 impfdfm=0 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=11 irpct_1=0 impfdfm=0 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=14 irpct_1=0 impfdfm=0 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)


* FM=0.5

mfx, predict(xb) at(mean impfd=-11 irpct_1=0.5 impfdfm=-5.5 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=-8 irpct_1=0.5 impfdfm=-4 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1 )
mfx, predict(xb) at(mean impfd=-5 irpct_1=0.5 impfdfm=-2.5 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=-2 irpct_1=0.5 impfdfm=-1 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=0  irpct_1=0.5 impfdfm=0 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=2 irpct_1=0.5 impfdfm=1 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=5  irpct_1=0.5 impfdfm=2.5 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=8 irpct_1=0.5 impfdfm=4 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=11 irpct_1=0.5 impfdfm=5.5 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=14 irpct_1=0.5 impfdfm=7 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)

* FM= 2

mfx, predict(xb) at(mean impfd=-11 irpct_1=2 impfdfm=-22 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=-8 irpct_1=2 impfdfm=-16 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=-5 irpct_1=2 impfdfm=-10 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=-2 irpct_1=2 impfdfm=-4 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=0  irpct_1=2 impfdfm=0 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1 )
mfx, predict(xb) at(mean impfd=2 irpct_1=2 impfdfm=4 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=5  irpct_1=2 impfdfm=10 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=8 irpct_1=2 impfdfm=16 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=11 irpct_1=2 impfdfm=22 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1 )
mfx, predict(xb) at(mean impfd=14 irpct_1=2 impfdfm=28 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)

* FM= 4

mfx, predict(xb) at(mean impfd=-11 irpct_1=4 impfdfm=-44 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=-8 irpct_1=4 impfdfm=-32 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1 )
mfx, predict(xb) at(mean impfd=-5 irpct_1=4 impfdfm=-20 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1 )
mfx, predict(xb) at(mean impfd=-2 irpct_1=4 impfdfm=-8 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=0  irpct_1=4 impfdfm=0 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=2 irpct_1=4 impfdfm=8 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1 )
mfx, predict(xb) at(mean impfd=5  irpct_1=4 impfdfm=20 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=8 irpct_1=4 impfdfm=32 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1 )
mfx, predict(xb) at(mean impfd=11 irpct_1=4 impfdfm=44 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=14 irpct_1=4 impfdfm=56 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)

* FM= 6

mfx, predict(xb) at(mean impfd=-11 irpct_1=6 impfdfm=-66 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=-8 irpct_1=6 impfdfm=-48 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=-5 irpct_1=6 impfdfm=-30 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=-2 irpct_1=6 impfdfm=-12 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=0  irpct_1=6 impfdfm=0 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1 )
mfx, predict(xb) at(mean impfd=2 irpct_1=6 impfdfm=12 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=5  irpct_1=6 impfdfm=30 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=8 irpct_1=6 impfdfm=48 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=11 irpct_1=6 impfdfm=66 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=14 irpct_1=6 impfdfm=84 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1 )


* High factor mobility (fm=8)

mfx, predict(xb) at(mean impfd=-11 irpct_1=8 impfdfm=-88 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=-8 irpct_1=8 impfdfm=-64 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=-5 irpct_1=8 impfdfm=-40 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=-2 irpct_1=8 impfdfm=-16 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=0  irpct_1=8 impfdfm=0 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=2 irpct_1=8 impfdfm=16 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=5  irpct_1=8 impfdfm=40 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=8 irpct_1=8 impfdfm=64 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=11 irpct_1=8 impfdfm=88 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=14 irpct_1=8 impfdfm=112 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1 )

* High factor mobility (fm=9)

mfx, predict(xb) at(mean impfd=-11 irpct_1=9 impfdfm=-99 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=-8 irpct_1=9 impfdfm=-72 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=-5 irpct_1=9 impfdfm=-45 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=-2 irpct_1=9 impfdfm=-18 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=0  irpct_1=9 impfdfm=0 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=2 irpct_1=9 impfdfm=18 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=5  irpct_1=9 impfdfm=45 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=8 irpct_1=9 impfdfm=72 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=11 irpct_1=9 impfdfm=99 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=14 irpct_1=9 impfdfm=126 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)

* FM = 10

mfx, predict(xb) at(mean impfd=-11 irpct_1=10 impfdfm=-110 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=-8 irpct_1=10 impfdfm=-80 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=-5 irpct_1=10 impfdfm=-50 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=-2 irpct_1=10 impfdfm=-20 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=0  irpct_1=10 impfdfm=0 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=2 irpct_1=10 impfdfm=20 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=5  irpct_1=10 impfdfm=50 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=8 irpct_1=10 impfdfm=80 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=11 irpct_1=10 impfdfm=110 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)
mfx, predict(xb) at(mean impfd=14 irpct_1=10 impfdfm=140 execrlc_1=0 leftimpfdfm=0 leftimpfd=0 leftfm=0 pr2_1=1)



