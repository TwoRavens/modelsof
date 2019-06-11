log using "log_replication_psrm_ppp_main.log", replace

*** Supplemental material for 
*** "Platforms, Portfolios, Policy: How Audience Costs Affect Social Welfare Policy in Multiparty Cabinets"
*** Despina Alexiadou, University of Strathclyde & Danial Hoepfner, University of Pittsburgh
******************************************************************************************************

**** Replication of Tables and Figures in Main Table, Section D of the Appendix & Data Appendix*******
******************************************************************************************************
***************************************************************
***************************************************************
******Generate Main IVs****************************************
* load data
use "PSRM_Alexiadou_ppp_stata13.dta", clear

******Left Pledge: 
****Coding the two main left pledge variables:
***Naive Left Pledge. We substract the left's pledge to cut benefits (CMP 505 category) from the left's pledge to expand benefits (CMP 504 category)
gen leftnetpledge= welfexpleft-welfnegleft
label variable leftnetpledge  "Net Pro-Welfare Pledge, SD Party"

***multiply the left pledge by left cabinet, to include only the cases where the left is in government.
gen left= gov_left>0
gen leftPledgex=leftnetpledge*left
label variable leftPledgex  "Naive Pro-Welfare Pledge, SD Party in Government"

***generate interaction of left pledge and left social affairs minister
gen leftPledgexSaffairs=leftPledgex*leftsaffairs

*****Net Left Pledge: creating the more sophisticated left pledge that account for finance's negative pledges
***the original data codes the negative pledges made by finance ministers of right and center-right parties to cut welfare benefits: rfinwelfneg
gen rfinwelfnegD=1 
replace rfinwelfnegD=0 if rfinwelfneg>0
replace rfinwelfnegD=. if rfinwelfneg==.

gen leftPledgexNet= leftPledgex*rfinwelfnegD
gen leftPledgexNetSaf=leftsaffairs*leftPledgexNet
label variable leftPledgexNet  "Pro-Welfare Pledge by SD Party in Government, net of Negative Finance Pledge"

***Cabinet weighted average pledge
gen cabnet= cabavexp-cabavcon
label variable cabnet  "Weighted Cabinet Average net Pro-welfare Pledge"

****Mini cabinet
gen innerleft=(leftsaffairs + leftlab + leftfin)/3
label variable innerleft  "Inner Cabinet: average left ministries"

gen leftPledgexinner=leftPledgex*innerleft
****Finance/Affairs average
gen leftfinsaf= (leftsaffairs + leftfin)/2
label variable leftfinsaf "Average S. Affairs & Finance left ministries"

gen leftPledgexSafFin= leftPledgex*leftfinsaf

***multiparty
****Minimum wining
gen multiparty= gov_type==2 | gov_type==3 | gov_type==5
gen multimaj= gov_type==2 | gov_type==3
gen nonoversized= gov_type==2 | gov_type==5
gen oversized= gov_type==3
gen cabNoleft=ce_cpsl-lsaffairsseats
replace cabNoleft=. if cabNoleft<0 | cabNoleft==0
gen exitpower=0
replace exitpower=1 if cabNoleft<50
replace exitpower=. if cabNoleft==.

gen minover= oversized*exitpower
gen newmulti= gov_type==2 | gov_type==5 | minover==1

foreach i of varlist leftsaffairs gov_left totgen realgdpgr unemp Coord christian  chrsaffairs  ChristianPledgex  ChrPledgexSaf leftPledgexSafFin leftfinsaf leftPledgexinner innerleft cabnet leftPledgexNetSaf leftPledgexNet leftPledgexSaffairs leftPledgex left leftnetpledge {
generate `i'1=l.`i'
}

label variable leftsaffairs1 "SD S. Affairs"
label variable gov_left1 "Left Cab. seats %"
label variable totgen1 "Generosity Lag"
label variable realgdpgr1 "Econ. Growth"
label variable unemp1 "Unemployment"
label variable Coord1 "WB Coordination"
label variable christian1 "Christ. Cab. seats %" 
label variable chrsaffairs1 "Chr. S. Affairs"
label variable ChristianPledgex1 "Chrs. Pledge"
label variable ChrPledgexSaf1 "Pledge*Chr.Affairs"
label variable leftPledgexSafFin1 "Left Pledge*SD. Aff/Fin"
label variable leftfinsaf1 "Ave. SD Affairs/Finance"
label variable leftPledgexinner1 "Left Pledge*Inner Cab"
label variable innerleft1 "SD Inner Cabinet"
label variable cabnet1 "Average Cabinet Pledge"
label variable leftPledgexNetSaf1 "Net Pledge*SD. Affairs"
label variable leftPledgexNet1 "Net Pledge"
label variable leftPledgexSaffairs1 "Left Pledge*SD Affairs"
label variable leftPledgex1 "Left Pledge"
label variable left1 "Left Cabinet"
label variable leftnetpledge1 "Left Electoral Pledge"
label variable count "Time Trend"
label variable leftPledgexNetSaf "Left Pro-welfare Pledge when SD. Affairs"

gen ccode2= ccode==2
gen ccode3= ccode==3
gen ccode8= ccode==8
gen ccode11= ccode==11
gen ccode12= ccode==12
gen ccode15= ccode==15
gen ccode17= ccode==17
gen ccode20= ccode==20

***********************************
**********************************
*********************************

***********************************************************
***********************************************************
*********Replication of Main Tables************************
***********************************************************

****Table 1**
***Testing H1a
xtreg totgen totgen1 realgdpgr1 gov_left1 cabnet1 leftPledgex1 leftsaffairs1 leftPledgexSaffairs1 if newmulti, fe robust
est sto t11
***Testing H1b
xtreg totgen totgen1 realgdpgr1 gov_left1 cabnet1 leftPledgex1 leftfinsaf1 leftPledgexSafFin1 if newmulti,  fe robust
est sto t12
***Testing the alternative Hypothesis that the weighted ideology of the inner cabinet matters most 
xtreg totgen totgen1 realgdpgr1 gov_left1 cabnet1 leftPledgex1 innerleft1 leftPledgexinner1 if newmulti, fe robust
est sto t13
***Testing H1c
xtreg totgen totgen1 realgdpgr1 gov_left1 cabnet1 leftPledgexNet1 leftsaffairs1 leftPledgexNetSaf1 if newmulti,  fe robust
est sto t14

esttab t11 t12 t13 t14, se ///
label order(totgen totgen1 realgdpgr1 gov_left1 cabnet1 leftPledgex1 leftsaffairs1 leftPledgexSaffairs1 leftfinsaf1 leftPledgexSafFin1 innerleft1 leftPledgexinner1 leftPledgexNet1 leftPledgexNetSaf1) ///
star(* 0.1 ** 0.05 *** 0.01) ///
nogaps numbers ///
r2


****Table 2***
xtreg totgen totgen1 realgdpgr1 gov_left1 cabnet1 leftPledgex1 leftsaffairs1 leftPledgexSaffairs1 count if  newmulti & case_Bstar_B_D_E, fe robust
est sto t21
xtreg totgen totgen1 realgdpgr1 gov_left1 cabnet1 leftPledgexNet1 leftsaffairs1 leftPledgexNetSaf1 count if newmulti & case_Bstar_B_D_E,  fe robust
est sto t22
xtreg totgen totgen1 realgdpgr1 gov_left1 cabnet1 leftPledgex1 leftsaffairs1 leftPledgexSaffairs1 count if  newmulti & case_C, fe robust
est sto t23
xtreg totgen totgen1 realgdpgr1 gov_left1 cabnet1 leftPledgexNet1 leftsaffairs1 leftPledgexNetSaf1 count if newmulti & case_C,  fe robust
est sto t24

esttab t21 t22 t23 t24 , se ///
label order(totgen totgen1 realgdpgr1 gov_left1 cabnet1 leftPledgex1 leftsaffairs1 leftPledgexSaffairs1 leftPledgexNet1 leftPledgexNetSaf1 count) ///
star(* 0.1 ** 0.05 *** 0.01) ///
nogaps numbers noomitted  ///
r2

******************************************************
*************Additional Tables in the online Appendix************
******************************************************

******************************************************
************Section D robustness**********************
******************************************************

*****Table 3A***
****Testing the main model across types of multiparty cabinets***
***Only coalitions that would fall if SD party leaves the coalition: the sample used in Tables 1 & 2
xtreg totgen totgen1 realgdpgr1 gov_left1 cabnet1 leftPledgexNet1 leftsaffairs1 leftPledgexNetSaf1 if newmulti, fe robust
est sto t3A1
***Only majority, minimum winning coalitions
xtreg totgen totgen1 realgdpgr1 gov_left1 cabnet1 leftPledgexNet1 leftsaffairs1 leftPledgexNetSaf1 if ar_tg==2, fe robust
est sto t3A2
***Only majority, minimum winning & minority coalitions
xtreg totgen  totgen1 realgdpgr1 gov_left1 cabnet1 leftPledgexNet1 leftsaffairs1 leftPledgexNetSaf1 if nonoversized, fe robust
est sto t3A3
***All multiparty coalitions including oversized coalitions which are excluded from the samples above
xtreg totgen  totgen1 realgdpgr1 gov_left1 cabnet1 leftPledgexNet1 leftsaffairs1 leftPledgexNetSaf1 if multiparty, fe robust
est sto t3A4

esttab t3A1 t3A2 t3A3 t3A4, se ///
label order(totgen totgen1 realgdpgr1 gov_left1 cabnet1 leftPledgexNet1 leftsaffairs1 leftPledgexNetSaf1) ///
star(* 0.1 ** 0.05 *** 0.01) ///
nogaps numbers noomitted  ///
r2

*****Table 4A***
***Adding the controls of unemployment and wage coordination to Table 1
xtreg totgen totgen1 realgdpgr1 unemp1 Coord1 gov_left1 cabnet1 leftPledgex1 leftsaffairs1 leftPledgexSaffairs1 if  newmulti, fe robust
est sto t4A1 
xtreg totgen totgen1 realgdpgr1 unemp1 Coord1 gov_left1 cabnet1 leftPledgex1 leftfinsaf1 leftPledgexSafFin1 if newmulti,  fe robust
est sto t4A2 
xtreg totgen totgen1 realgdpgr1 unemp1 Coord1 gov_left1 cabnet1 leftPledgex1 innerleft1 leftPledgexinner1 if newmulti, fe robust
est sto t4A3
xtreg totgen totgen1 realgdpgr1 unemp1 Coord1 gov_left1 cabnet1 leftPledgexNet1 leftsaffairs1 leftPledgexNetSaf1 if newmulti,  fe robust 
est sto t4A4

esttab t4A1 t4A2 t4A3 t4A4, se ///
label order(totgen totgen1 realgdpgr1 unemp1 Coord1 gov_left1 cabnet1 leftPledgex1 leftsaffairs1 leftPledgexSaffairs1 leftfinsaf1 leftPledgexSafFin1 innerleft1 leftPledgexinner1 leftPledgexNet1 leftPledgexNetSaf1) ///
star(* 0.1 ** 0.05 *** 0.01) ///
nogaps numbers noomitted  ///
r2

********Table 5A*****
***Testing the argument with Christian democratic pledges***
xtreg totgen totgen1 realgdpgr1 unemp1 Coord1 christian1 cabnet1  chrsaffairs1 ChristianPledgex1 ChrPledgexSaf1 if newmulti , fe robust
est sto t5A1  
xtreg totgen  totgen1 realgdpgr1 unemp1 Coord1 christian1 cabnet1  chrsaffairs1 ChristianPledgex1 ChrPledgexSaf1 if newmulti & case_Bstar_B_D_E, fe robust
est sto t5A2    
xtreg totgen  totgen1 realgdpgr1 unemp1 Coord1 christian1 cabnet1  chrsaffairs1 ChristianPledgex1 ChrPledgexSaf1 if newmulti &  case_C, fe robust
est sto t5A3 

esttab t5A1 t5A2 t5A3, se ///
label order(totgen totgen1 realgdpgr1 unemp1 Coord1 christian1 cabnet1 chrsaffairs1 ChristianPledgex1 ChrPledgexSaf1) ///
star(* 0.1 ** 0.05 *** 0.01) ///
nogaps numbers noomitted  ///
r2

******Table 6A****
****Predicting left pledges & the allocation of social affairs to the left to execute a control function estimation**

***Table 6**
****Predicting left pledge at elections**
xtreg leftnetpledge Lagleftnetpledge rightnetpledge centernetpledge realgdpgr unemp Coord , fe
est sto t6A1  
*****Predicting when the left controls social affairs***
probit leftsaffairs saffairsrile  cabnet gov_left realgdpgr unemp Coord if year>1969 & newmulti , cluster(ccode)
est sto t6A2 

esttab t6A1 t6A2, se ///
label order(leftnetpledge Lagleftnetpledge rightnetpledge centernetpledge realgdpgr unemp Coord leftsaffairs saffairsrile  cabnet gov_left) ///
star(* 0.1 ** 0.05 *** 0.01) ///
nogaps numbers noomitted  ///
r2

esttab t6A1 t6A2, se ///
label order(leftnetpledge Lagleftnetpledge rightnetpledge centernetpledge realgdpgr unemp Coord leftsaffairs saffairsrile  cabnet gov_left) ///
star(* 0.1 ** 0.05 *** 0.01) ///
nogaps numbers noomitted  ///
r2


***Control Functions**

****Control Functions***


xtreg leftnetpledge Lagleftnetpledge rightnetpledge centernetpledge realgdpgr unemp Coord , fe
predict eAll, e 
gen eAll1=l.eAll
***creating the inverse mills ratio after probit

probit leftsaffairs saffairsrile  cabnet gov_left realgdpgr unemp Coord if year>1969 & newmulti , cluster(ccode)
predict xbAll, xb
gen pdfxbAll= normalden(xbAll)
gen cdfxbAll=normprob(xbAll)
gen imfAll=pdfxbAll/cdfxbAll    /* gets the inverse mills ratio*/
gen imfAll1=l.imfAll

****generating interaction term***
gen lnetpledgeSAffairs=leftnetpledge*leftsaffairs
gen lnetpledgeSAffairs1=l.lnetpledgeSAffairs

***Table 7A***
***Estimating the conditional effect of left Pledge and portfolio control by the left in a control function estimator**
****This model differs from Model 1 in Table 1 in that the left pledge includes all pledges made by the left, whether they are in governmennt or not. 
xtreg totgen totgen1 eAll1 imfAll1  realgdpgr1 cabnet1 leftsaffairs1 leftnetpledge1 lnetpledgeSAffairs1 if newmulti, fe robust
est sto t7A1

esttab t7A1, se ///
label order(totgen totgen1 eAll1	 imfAll1  realgdpgr1 cabnet1 leftsaffairs1 leftnetpledge1 lnetpledgeSAffairs1) ///
star(* 0.1 ** 0.05 *** 0.01) ///
nogaps numbers noomitted  ///
r2



************************************************
*****Summary Statistics****

*****Table 10A*****
***Created manually***

****Table 11A****
tabstat ccode2 ccode3 ccode8 ccode11 ccode12 ccode15 ccode17 ccode20 if year>1969 , stat(sum) by(case)

****Table 12A***
sum totgen realgdpgr unemp Coord gov_left cabnet leftPledgex leftPledgexNet leftsaffairs leftfinsaf innerleft christian chrsaffairs ChristianPledgex  if  newmulti

**********Table 13A****
tabstat leftPledgex leftnetpledge leftpm  leftsaffairs gov_left if  newmulti, by(case)

tabstat  leftPledgex leftnetpledge leftpm  leftsaffairs gov_left if newmulti & leftpm==1, by(case)

**********Table 14A************************
sum leftsaffairs leftfin if year>1969 & newmulti & gov_left>0 

sum leftsaffairs if year>1969 & newmulti & leftfin==1 

sum leftPledgexNet cabnet if year>1969 & newmulti & gov_left>0

sum leftPledgexNet cabnet if leftPledgexNet>cabnet & year>1969 & newmulti & gov_left>0

sum leftPledgexNet cabnet if leftPledgexNet<=cabnet & year>1969 & newmulti & gov_left>0

***Calculating short and long-run effects of left pledges
xtreg totgen totgen1 realgdpgr1 gov_left1 cabnet1 leftPledgexNet1 leftsaffairs1 leftPledgexNetSaf1 if newmulti,  fe robust
****average cabinet pledge: 6.6
lincom leftsaffairs1 + leftPledgexNetSaf1*6.6
**Short run effect is 0.18
**Calculating long-run (diving the short-run coefficient 0.18 by 0.06 (1-0.94=0.06) equals 3. 
**Since welfare generosity ranges from 22.3 to 45.8 giving us a 23.5 units range, the total effect is 3*100/23.5=12.7
****average left pledge
lincom leftsaffairs1 + leftPledgexNetSaf1*9
**short run effect is 0.44
**long run effect is 0.44/0.06=7.3 with a total effect calculated as above: 73/23.5=31
***********************************************
***********************************************


*******************
*****Figures*****
**************************

gen leftPledgexNetSample = leftPledgexNet if newmulti

****Model 4 of Table1***
***Testing H1C****
xtreg totgen totgen1 realgdpgr1 gov_left1 cabnet1 leftPledgexNet1 leftsaffairs1 leftPledgexNetSaf1 if  newmulti,  fe robust


egen minMVlist = min(leftPledgexNetSample) 
scalar minMV=minMVlist[1]
drop minMVlist

egen maxMVlist = max(leftPledgexNetSample)
scalar maxMV=maxMVlist[1]
drop maxMVlist

generate MV=  minMV+ ((_n-1)*((maxMV-minMV)/_N))


matrix B=e(b) 
matrix V=e(V)

 
scalar i1 = colnumb(B,"leftsaffairs1")
scalar i2 = colnumb(B,"leftPledgexNet1")
scalar i3 = colnumb(B,"leftPledgexNetSaf1")
 
scalar b1=B[1,i1] 
scalar b2=B[1,i2]
scalar b3=B[1,i3]

scalar varb1=V[i1,i1] 
scalar varb2=V[i2,i2] 
scalar varb3=V[i3,i3]

scalar covb1b3=V[i1,i3] 
scalar covb2b3=V[i2,i3]

scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3

gen conb=b1+b3*MV

gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV)


*generate upper and lower bounds of the confidence interval
*specify the confidence interval

gen a=1.99*conse
gen upper=conb+a
gen lower=conb-a
**************************************************************
hist leftPledgexNetSample
gen zerol=0            
  # delimit;
graph twoway hist leftPledgexNetSample, yscale(alt range(-.14 `=r(max)')) fcolor(gs15) lwidth(vvthin)
		  || line conb MV, clpattern(solid) clwidth(thin) yaxis(2) yscale(alt axis(2)) 
          || line upper MV, clpattern(solid) clwidth(thin) yaxis(2) yscale(alt axis(2))
          || line lower MV, clpattern(solid) clwidth(thin) yaxis(2) yscale(alt axis(2))
		  || line zerol MV,  lcolor(black) yaxis(2)
		  ||,
             xscale(noline)
             yscale(noline)
             legend(off)
             title("Marginal effect of welfare commitment when SD control social affairs", size(2.5))
             subtitle("Dependent variable: Total welfare generosity", size(2.5))
             xtitle("Index of Net Welfare Commitment", size(2.5))
             ytitle("Density", size (2.5) axis(2)) 
             ytitle("Marginal Effect of Pro-Welfare Pledge", size (2.5) axis(1)) 
			 note("Graph based on equation four, table one" "Confidence intervals at the 99% level", size(2))
             xsca(titlegap(2))
             ysca(titlegap(4))
             scheme(s2mono)
             graphregion(fcolor(white))
             graphregion(margin(r=28));
 # delimit cr            exit; 

graph export Graph1_ppp.tif, replace width(4800)
graph export Graph1_ppp.pdf, replace 

 drop lower upper a conse conb MV zerol

 ****Additional Graphs for the Online Appendix***
 ****Figure 3A****
 ****Equation1 of Table 1***
 

gen leftPledgexSample=leftPledgex if  newmulti

xtreg totgen totgen1 realgdpgr1 gov_left1 cabnet1 leftPledgex1 leftsaffairs1 leftPledgexSaffairs1 if   newmulti, fe robust


egen minMVlist = min(leftPledgexSample) 
scalar minMV=minMVlist[1]
drop minMVlist

egen maxMVlist = max(leftPledgexSample)
scalar maxMV=maxMVlist[1]
drop maxMVlist

generate MV=  minMV+ ((_n-1)*((maxMV-minMV)/_N))


matrix B=e(b) 
matrix V=e(V)

 
scalar i1 = colnumb(B,"leftsaffairs1")
scalar i2 = colnumb(B,"leftPledgex1")
scalar i3 = colnumb(B,"leftPledgexSaffairs1")
 
scalar b1=B[1,i1] 
scalar b2=B[1,i2]
scalar b3=B[1,i3]

scalar varb1=V[i1,i1] 
scalar varb2=V[i2,i2] 
scalar varb3=V[i3,i3]

scalar covb1b3=V[i1,i3] 
scalar covb2b3=V[i2,i3]

scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3

gen conb=b1+b3*MV

gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV)


*generate upper and lower bounds of the confidence interval
*specify the confidence interval

gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a
**************************************************************
hist leftPledgexSample
gen zerol=0            
  # delimit;
graph twoway hist leftPledgexSample, yscale(alt range(-0.15 `=r(max)')) fcolor(gs15) lwidth(vvthin)
		  || line conb MV, clpattern(solid) clwidth(thin) yaxis(2) yscale(alt axis(2)) 
          || line upper MV, clpattern(solid) clwidth(thin) yaxis(2) yscale(alt axis(2))
          || line lower MV, clpattern(solid) clwidth(thin) yaxis(2) yscale(alt axis(2))
		  || line zerol MV,  lcolor(black) yaxis(2)
		  ||,
             xscale(noline)
             yscale(noline)
             legend(off)
             title("Marginal effect of the left's welfare commitment when SD control social affairs", size(2.5))
             subtitle("Dependent variable: Total welfare generosity", size(2.5))
             xtitle("Index of Left Welfare Commitment", size(2.5))
             ytitle("Density", size (2.5) axis(2)) 
             ytitle("Marginal Effect of Pro-Welfare Pledge", size (2.5) axis(1)) 
			 note("Graph based on equation one, table one" "Confidence intervals at the 95% level", size(2))
             xsca(titlegap(2))
             ysca(titlegap(4))
             scheme(s2mono)
             graphregion(fcolor(white))
             graphregion(margin(r=28));
 # delimit cr            exit; 

graph export Graph3A_ppp.tif, replace width(4800)
graph export Graph3A_ppp.pdf, replace 

 drop lower upper a conse conb MV zerol

 *********Figure 4A**************
 *****Testing H1b: Equation 2 of Table 1****

xtreg totgen totgen1 realgdpgr1 gov_left1 cabnet1 leftPledgex1 leftfinsaf1 leftPledgexSafFin1 if  newmulti,  fe robust

egen minMVlist = min(leftPledgexSample) 
scalar minMV=minMVlist[1]
drop minMVlist

egen maxMVlist = max(leftPledgexSample)
scalar maxMV=maxMVlist[1]
drop maxMVlist

generate MV=  minMV+ ((_n-1)*((maxMV-minMV)/_N))


matrix B=e(b) 
matrix V=e(V)

 
scalar i1 = colnumb(B,"leftfinsaf1")
scalar i2 = colnumb(B,"leftPledgex1")
scalar i3 = colnumb(B,"leftPledgexSafFin1")
 
scalar b1=B[1,i1] 
scalar b2=B[1,i2]
scalar b3=B[1,i3]

scalar varb1=V[i1,i1] 
scalar varb2=V[i2,i2] 
scalar varb3=V[i3,i3]

scalar covb1b3=V[i1,i3] 
scalar covb2b3=V[i2,i3]

scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3

gen conb=b1+b3*MV

gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV)


*generate upper and lower bounds of the confidence interval
*specify the confidence interval

gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a
**************************************************************
hist leftPledgexSample
gen zerol=0            
  # delimit;
graph twoway hist leftPledgexSample, yscale(alt range(-0.1 `=r(max)')) fcolor(gs15) lwidth(vvthin)
		  || line conb MV, clpattern(solid) clwidth(thin) yaxis(2) yscale(alt axis(2)) 
          || line upper MV, clpattern(solid) clwidth(thin) yaxis(2) yscale(alt axis(2))
          || line lower MV, clpattern(solid) clwidth(thin) yaxis(2) yscale(alt axis(2))
		  || line zerol MV,  lcolor(black) yaxis(2)
		  ||,
             xscale(noline) 
             yscale(noline)
             legend(off)
             title("Marginal effect of the left's welfare commitment when SD control S. Affairs & Finance", size(2.5))
             subtitle("Dependent variable: Total welfare generosity", size(2.5))
             xtitle("Index of Left Welfare Commitment", size(2.5))
             ytitle("Density", size (2.5) axis(2)) 
             ytitle("Marginal Effect of Pro-Welfare Pledge", size (2.5) axis(1)) 
			 note("Graph based on equation two, table one" "Confidence intervals at the 95% level", size(2))
             xsca(titlegap(2))
             ysca(titlegap(4))
             scheme(s2mono)
             graphregion(fcolor(white))
             graphregion(margin(r=28));
 # delimit cr            exit; 
 
graph export Graph4A_ppp.tif, replace width(4800)
graph export Graph4A_ppp.pdf, replace 

 drop lower upper a conse conb MV zerol

 ******Other figures, descriptives***
 *****Figure 5A***

histogram rfinwelfneg if year>1969 & gov_left>0, percent subtitle("Negative Pledges by Right Parties that controlled Finance when in coalition with SD parties", size(3)) ///
             scheme(s2mono) ///
             graphregion(fcolor(white)) 			 
graph save Graph5A_ppp, replace
graph export Graph5A_ppp.tif, replace width(4800)
graph export Graph5A_ppp.pdf, replace 


 *****Figure 6A****
 
histogram leftPledgexNetSaf if  year>1969 , percent subtitle("Pro-welfare Pledges by SD Parties that controlled S. Affairs", size(3)) ///
             scheme(s2mono) ///
             graphregion(fcolor(white)) 			 
graph save Graph6A_ppp, replace
graph export Graph6A_ppp.tif, replace width(4800)
graph export Graph6A_ppp.pdf, replace

 *****Figure 7A***
tsline welfexpleft welfexpright welfexpcenter if ccode==2 & year>1969, lpattern("solid" "dash" "_._.") lcolor("black" "gs5" "gs12" ) title("Austria", size(small)) legend(label(1 "SPO") label(2 "OVP") label(3 "FPO")) ///
             scheme(s2mono) ///
             graphregion(fcolor(white))
graph save austria, replace

tsline welfexpleft welfexpright welfexpcenter if ccode==11 & year>1969, lpattern("solid" "dash" "_._.") lcolor("black" "gs5" "gs12" ) title("Ireland", size(small)) legend(label(1 "Labour") label(2 "Fine Gael") label(3 "Fianna Fail")) ///
             scheme(s2mono) ///
             graphregion(fcolor(white))
graph save ireland, replace

graph combine austria.gph ireland.gph, title("Pro-welfare commitments in Austria and Ireland over time", size(medsmall)) rows(2) ///
             graphregion(fcolor(white))
graph save Graph7A_ppp, replace
graph export Graph7A_ppp.tif, replace width(4800)
graph export Graph7A_ppp.pdf, replace 


 ****Figure 8A***
tsline welfexpleft welfexpright welfexpcenter if ccode==8 & year>1969, lpattern("solid" "dash" "_._.") lcolor("black" "gs5" "gs12" ) title("Germany", size(small)) legend(label(1 "SPD") label(2 "CDU/CSU") label(3 "FDP")) ///
             scheme(s2mono) ///
             graphregion(fcolor(white)) 
graph save germany, replace

tsline welfexpleft welfexpright welfexpcenter if ccode==15 & year>1969, lpattern("solid" "dash" "shortdash_dot") lcolor("black" "black" "gs5" ) title("Netherlands", size(small)) legend(label(1 "SPD") label(2 "CDU/CSU") label(3 "FDP")) ///
             scheme(s2mono) ///
             graphregion(fcolor(white)) 
graph save netherlands, replace

graph combine germany.gph netherlands.gph, title("Pro-welfare commitments in Germany and the Netherlands over time", size(medsmall)) rows(2) ///
             graphregion(fcolor(white))
graph save Graph8A_ppp, replace
graph export Graph8A_ppp.tif, replace width(4800)

log close
