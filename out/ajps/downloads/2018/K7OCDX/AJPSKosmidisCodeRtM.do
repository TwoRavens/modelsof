


********************************************************************************
***************International Constraints and Electoral Decisions:****************
*************Does the Room to Maneuver Attenuate Economic Voting?***************
********************************************************************************
********************************************************************************
****************Replication Materials*******************************************
********************************************************************************

*cd "RTMKosmidisAJPSReplication"

*It is important to set up a working directory to save all the necessary files.
*It is advised that Stata code, Stata files and the R script are included in 
*the same folder.

use "AJPSKosmidisRtMdata.dta", clear


version 13

********************************************************************************
***********************************Figure 1*************************************
********************************************************************************


/*
Note: Figure 1 comprises of difference in means estimates conditional on 
treatment group. To calculate the point estimates I employ simple OLS regression 
with interaction terms.The marginal effects estimates and the 95% CIs as matrices
and then used from R to produce Figure1
 
 
Regression models 
*/





reg prospects i.rtm##i.eubinaryvote 
margins eubinaryvote, at(rtm=1 rtm=2) pwcompare  mcompare(bonferroni) post
matrix euvote=r(table_vs)
svmat euvote

reg prospects i.rtm##i.binaryvote 
margins binaryvote, at(rtm=1 rtm=2) pwcompare  mcompare(bonferroni)
matrix binaryvote=r(table_vs)
svmat binaryvote

reg prospects i.rtm##c.Age
margins, dydx(Age) at(rtm=1 rtm=2) pwcompare 
matrix age=r(table_vs)
svmat age

reg prospects i.rtm##i.Sex
margins Sex ,at(rtm=1 rtm=2) pwcompare
matrix sex=r(table_vs)
svmat sex

reg prospects i.rtm##c.EduLevel
margins ,dydx(EduLevel) at(rtm=1 rtm=2) pwcompare
matrix edu=r(table_vs)
svmat edu


reg prospects i.rtm##c.leftright
margins ,dydx(leftright) at(rtm=1 rtm=2) pwcompare
matrix leftright=r(table_vs)
svmat leftright

reg prospects i.rtm##c.demosat
margins ,dydx(demosat) at(rtm=1 rtm=2) pwcompare
matrix demosat=r(table_vs)
svmat demosat


reg prospects i.rtm##i.jobs
margins jobs, at(rtm=1 rtm=2) pwcompare mcompare(bonferroni)
matrix jobs=r(table_vs)
svmat jobs



reg prospects i.rtm##c.GreeceParticipationEU
margins ,dydx(GreeceParticipationEU) at(rtm=1 rtm=2) pwcompare 
matrix greu=r(table_vs)
svmat greu


reg prospects i.rtm##i.polknow 
margins i.polknow, at(rtm=1 rtm=2) pwcompare  mcompare(bonferroni)
matrix polknow=r(table_vs)
svmat polknow

gen descr=.

tostring descr, replace

replace descr = "" if descr == "."

replace descr = "b" in 1
replace descr = "se" in 2
replace descr = "t" in 3
replace descr = "pvalue" in 4
replace descr = "ll" in 5
replace descr = "ul" in 6
 replace descr = "df" in 7
 replace descr = "crit" in 8
 replace descr = "eform" in 9
 
 
  ssc install savesome
 ****savesome is also downloadable from here: https://ideas.repec.org/c/boc/bocode/s418401.html


savesome descr euvote1 euvote1 euvote2 euvote3 euvote4 euvote5 euvote6 ///
binaryvote1 binaryvote2 binaryvote3 binaryvote4 binaryvote5 binaryvote6 ///
age1 sex1 sex2 sex3 sex4 sex5 sex6 edu1 leftright1 demosat1 jobs1 jobs2 ///
jobs3 jobs4 jobs5 jobs6 jobs7 jobs8 jobs9 jobs10 jobs11 jobs12 jobs13 ///
jobs14 jobs15 jobs16 jobs17 jobs18 jobs19 jobs20 jobs21 jobs22 jobs23 ///
jobs24 jobs25 jobs26 jobs27 jobs28 jobs29 jobs30 jobs31 jobs32 jobs33 ///
jobs34 jobs35 jobs36 jobs37 jobs38 jobs39 jobs40 jobs41 jobs42 jobs43 ///
jobs44 jobs45 jobs46 jobs47 jobs48 jobs49 jobs50 jobs51 jobs52 jobs53 ///
jobs54 jobs55 jobs56 jobs57 jobs58 jobs59 jobs60 jobs61 jobs62 jobs63 ///
jobs64 jobs65 jobs66 greu1 polknow1 polknow2 polknow3 polknow4 ///
polknow5 polknow6 polknow7 polknow8 polknow9 polknow10 polknow11 polknow12 ///
 polknow13 polknow14 polknow15 using figure1stata2R.dta, replace
 
 use "figure1stata2R.dta",clear
 
 saveold "figure1stata2R.dta", replace
 
 
*The figure1stata2R.dta is to be used within R to reproduce Figure 3!

use "AJPSKosmidisRtMdata.dta", clear

********************************************************************************
***********************************Table 2**************************************
********************************************************************************
reg manip i.rtm
reg manip i.rtm i.mgovsup i.prospects Sex Age i.EduLevel know


********************************************************************************
***********************************Table 3**************************************
********************************************************************************

*****Columns [1,2]
mlogit mgovsup c.prospects##i.rtm,r
*****Columns [3,4]
mlogit mgovsup c.prospects##i.rtm  Age Sex EduLevel,r
*****Columns [5,6]
mlogit mgovsup c.prospects##i.rtm  Age Sex EduLevel GreeceParticipationEU ,r


********************************************************************************
***********************************Figure 2*************************************
********************************************************************************
mlogit mgovsup c.prospects##i.rtm ,r
margins , dydx(c.prospects) at(rtm=0 rtm=1 rtm=2)  predict(outcome(1)) post
matrix fig2=r(table)
svmat  fig2


savesome fig21 fig22 fig23  using figure2stata2R.dta, replace

 use "figure2stata2R.dta",clear
 saveold "figure2stata2R.dta",replace
use "AJPSKosmidisRtMdata.dta", clear

********************************************************************************
***********************************Table 4**************************************
********************************************************************************

*****Columns [1,2,3]
mlogit multichoice i.prospects2##i.rtm  Age Sex EduLevel ,base(2)
*****Columns [4,5,6]
mlogit multichoice i.prospects2##i.rtm  Age Sex EduLevel GreeceParticipationEU  ,base(2)

 **************************************************
***********************************Figure 3*************************************
********************************************************************************  
  qui mlogit multichoice i.prospects2##i.rtm Age Sex EduLevel , base(2)

margins i.prospects2##rtm, atmeans  predict(outcome(1))pwcompare mcompare(bonferroni) post coefleg

matrix fig3cross=r(table_vs)
svmat  fig3cross
savesome fig3cross7 fig3cross8 fig3cross28 fig3cross29 fig3cross40 fig3cross41 using fig3crossR.dta,replace


 use "fig3crossR.dta",clear
 saveold "fig3crossR.dta",replace
use "AJPSKosmidisRtMdata.dta", clear


   
********************************************************************************
***********************************Figure 4*************************************
******************************************************************************** 
****model for left panel
 mlogit mgovsup c.prospects##i.rtm Age Sex EduLevel  i.june12vote,r
  margins , dydx(c.prospects) at(rtm=1 rtm=2 rtm=0) atmeans predict(outcome(1))
  matrix fig4a=r(table)
svmat  fig4a

savesome fig4a1 fig4a2 fig4a3  using figure4astata2R.dta, replace

 use "figure4astata2R.dta",clear
 saveold "figure4astata2R.dta",replace
use "AJPSKosmidisRtMdata.dta", clear

 ****model for right panel
 mlogit mgovsup c.prospects##i.rtm Age Sex EduLevel  i.euvote2014,r
  margins , dydx(c.prospects) at(rtm=1 rtm=2 rtm=0) atmeans predict(outcome(1))
  matrix fig4b=r(table)
svmat  fig4b

savesome fig4b1 fig4b2 fig4b3  using figure4bstata2R.dta, replace

 use "figure4bstata2R.dta",clear
 saveold "figure4bstata2R.dta",replace
use "AJPSKosmidisRtMdata.dta", clear




********************************************************************************
***********************************Table 5**************************************
********************************************************************************	
 
*****Columns [1,2]
mlogit mgovsup i.rtm Age Sex EduLevel , baseoutcome(0)

*****Columns [3,4]
mlogit mgovsup i.rtm Age Sex EduLevel i.prospects2, baseoutcome(0)

	
	
	
********************************************************************************
***********************************Appendix*************************************
********************************************************************************


********************************************************************************
***********************************Table A.1************************************
********************************************************************************

mlogit rtm i.Age3Cat i.Sex i.EduLevel leftright , baseoutcome(0)


********************************************************************************
***********************************Table A.2************************************
********************************************************************************

*Replication materials for the time series model can be found at the end of the file

********************************************************************************
***********************************Table A.3************************************
********************************************************************************

logit binaryvote prospects
  
  
 ********************************************************************************
***********************************Table A.3************************************
********************************************************************************
 net install  http://www.indiana.edu/~jslsoc/stata/spost13_ado/

logit binaryvote prospects

mchange, stats(ci)  dec(3) 

logit binaryvote i.prospects

mchange, stats(ci)  dec(3) 

 ***If you are facing issues downling the SPOST commands, more information can be 
 *** found here:http://www.indiana.edu/~jslsoc/web_spost13/spost13_install.pdf



********************************************************************************
***********************************Table A.2************************************
********************************************************************************
use RTMAppendixTS.dta,clear

gen time= m(2005m1)+_n+1

format time %tm

tsset time

reg dvote c.delcons##il.impose honeymoon   il.house l.pasokcosts l.ndcosts 

margins , dydx(c.delcons) by(impose)
  
  matrix figA1=r(table)
svmat  figA1

savesome figA11 figA12 using figureA1stata2R.dta, replace

 use "figureA1stata2R.dta",clear
 saveold "figureA1stata2R.dta",replace

*The saved matrix can be imported in R to create the plot



********************************************************************************
***********************************FigureA.2************************************
********************************************************************************

/*The estimation and plot is based on the user written "rollreg" function.
This can be downloaded from this link:https://ideas.repec.org/c/boc/bocode/s444301.html
 To reproduce Figure A.2 in the online appendix first run the command below and then 
 rollreg produces  a plot of the rolling regression. Because the plotting function 
 does not allow for options the replication needs to take place by hand using Stata's 
 Graph editor. In the replication file there is a csv file with rolling coeefieint estimates that
 could be used for to reproduce the plot in other software.
 */
 
 
 use RTMAppendixTS.dta,clear
gen time= m(2005m1)+_n+1

format time %tm

tsset time


ssc install rollreg


rollreg dvote delcons  honeymoon impose  , add(24) stub(ajps) bw(1) 

gen ub= ajps_delcons+(1.96* ajps_se_delcons)
gen lb= ajps_delcons-(1.96* ajps_se_delcons)

twoway (tsline ajps_delcons  if tin(2007m8,2016m1),lwidth(thick) legend(off) ///
xtitle("") ytitle("Economic Voting") tlabel(, format(%tm_Mon_YY)) lcolor(black) ///
 lpattern(solid)) (tsline ub if  tin(2007m9,2016m1), lcolor(black) lpattern(shortdash_dot)) ///
(tsline lb if  tin(2007m9,2016m1), lcolor(black) lpattern(shortdash_dot)) ///
 , yline(0, lcolor(red)) tline(2010m5,  lwidth(thin) lcolor(gs9)) ///
 tline(2015m1, lcolor(gs12) lwidth(vthin) lpattern(dash))  ///
 tline(2012m6, lcolor(gs12)  lwidth(vthin) lpattern(dash)) ///
  tline(2007m09, lcolor(gs12) lwidth(vthin) lpattern(dash))    



********************************************************************************
***********************************FigureA.3************************************
********************************************************************************
***Code requires the combomarginsplot program downloadable after typing
*** 'net search combomarginsplot' on the command line

use "AJPSKosmidisRtMdata.dta", clear

***model 1
  mlogit mgovsup c.prospects##i.rtm
  
  margins , dydx(c.prospects) at(rtm=1 rtm=2 rtm=0) predict(outcome(1))  saving(file1, replace)
  
marginsplot, horizontal recast(scatter)

***model2

  mlogit mgovsup c.prospects##i.rtm Age Sex EduLevel 
  
  margins , dydx(c.prospects) at(rtm=1 rtm=2 rtm=0)  predict(outcome(1))  saving(file2, replace)
  
marginsplot, horizontal recast(scatter)

***model3
  mlogit mgovsup c.prospects##i.rtm Age Sex EduLevel i.GreeceParticipationEU
  
  margins , dydx(c.prospects) at(rtm=1 rtm=2 rtm=0)  predict(outcome(1))  saving(file3, replace)
  
marginsplot, horizontal recast(scatter)

***combine plots

combomarginsplot file1 file2 file3 , horizontal recast(scatter) file1opts(pstyle(p1)) ///
            file2opts(pstyle(p2)) lplot1(mfcolor(white)) ytitle("Experimental Conditions") ///
			title("") xtitle("Economic Voting")legend(region(lwidth(none)))  ///
			legend(order(1 "No Control"  2 "Demographic Controls" 3 "Demographic+EU Attitudes"))


********************************************************************************
***********************************FigureA.4************************************
********************************************************************************
recode manip (0 1 = 1 "imf")(2 3= 2)(4 5 6=3)(7 8=4)(9 10=5 "national government"), gen(manip2)


mlogit mgovsup c.prospects##i.manip2 
margins, dydx(prospects) at(manip2=(1(1)5)) predict(outcome(1)) 
marginsplot,ytitle("Economic Vote") xtitle("") plot1opts(lpattern("-") mcolor(black)) ///
 ci1opts(color(black) )    title("") xlabel(1 "IMF"  2 3 4  5 "National Government", angle(45))



