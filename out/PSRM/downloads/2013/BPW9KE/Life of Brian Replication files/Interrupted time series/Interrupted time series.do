/***********************************************************
************************************************************
** Alexander Baturo and Slava Mikhaylov (2013). "Life of Brian Revisited: Assessing Informational and Non-Informational Leadership Tools." Political Science Research and Methods, 2013, 1(1): 139-157.
** Replication files
************************************************************
**  Interrupted time series estimation
************************************************************
************************************************************/



/*** Splines  ***/ 

use splines, clear

/*Putin address and Putin announcement*/
mkspline break1 18737 break2 18894 break3 = speechdate

/*rescaling for presentability in the table without many decimals as 100days */
gen Beforeaddress = break1/100
gen Postaddress =break2/100
gen Postannouncement =break3/100

reg score Beforeaddress Postaddress Postannouncement

est store spline
predict double yhat

* Table 1
estout spline, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))  style(tex) legend label varlabels(_cons Constant) stats(N r2_a rmse, fmt(0 2 3) label(N AdjustedR-squared RMSE)) starlevels(+ 0.10 ** 0.05 *** 0.001) modelwidth(4) 

*Figure 2

twoway (line yhat speechdate, lcolor(lime)) (scatter score speechdate, mcolor(blue) msymbol(circle_hollow)), ytitle(Raw wordscores) xtitle(Date) xline(18737 18894) xlabel(18604 18737 18894 19108) legend(off) scheme(s1mono) graphregion(margin(large)) 

graph export Figure2.pdf, replace 




/***  Interrupted time series    ***/ 


encode reg, gen(reg2)
xtset reg2 speechdate

* necessary for the time effect to work through properly
tsfill, full 

/* Putin address*/
gen address=0 if tin(,19apr2011)
recode address .=1 if tin(20apr2011,)


/* Putin Announcement*/
gen announcement=0 if tin(,23sep2011)
recode announcement .=1 if tin(24sep2011,)


/*Post-address*/
sort reg2 speechdate
by reg2: egen Addressannouncement=seq() if tin(20apr2011,)
recode Addressannouncement .=0


/*Post announcement*/
sort reg2 speechdate
by reg2: egen Afterannouncement=seq() if tin(24sep2011,)
recode Afterannouncement .=0



/*Time*/
sort reg2 speechdate
by reg2: egen time = seq()

/*rescaling for presentability in the table without many decimals as 100days */

gen time2=time/100
gen address2=address/100
gen Addressannouncement2=Addressannouncement/100
gen announcement2=announcement/100 
gen Afterannouncement2=Afterannouncement/100

reg score time2 address2 Addressannouncement2 announcement2 Afterannouncement2


est store daily 


/*monthly*/


gen month=month(speechdate)
gen year2=year(speechdate)
gen ym=ym(year2,month)
format ym %tm
collapse score, by(ym)

tsset ym
tsfill

ipolate score ym, gen(new_score)


/* Putin address*/
gen address2=0 if tin(,2011m4)
recode address2 .=1 if tin(2011m5,)


/* Putin Announcement*/
gen announcement2=0 if tin(,2011m9)
recode announcement2 .=1 if tin(2011m10,)


/*Post address*/
egen Addressannouncement2=seq() if tin(2011m5,)
recode Addressannouncement2 .=0


/*Post announcement*/
egen Afterannouncement2 =seq() if tin(2011m10,)
recode Afterannouncement2 .=0

/*Time*/
gen time2 = _n


reg new_score time2 address2 Addressannouncement2 announcement2 Afterannouncement2
 
est store monthly

* Supplementary materials Table 1
estout daily monthly, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))  style(tex) legend label varlabels(_cons Constant) stats(N r2_a rmse, fmt(0 2 3) label(N AdjustedR-squared RMSE)) starlevels(+ 0.10 ** 0.05 *** 0.001) modelwidth(4) 

