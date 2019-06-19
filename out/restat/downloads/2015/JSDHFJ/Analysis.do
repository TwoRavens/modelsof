*******************************************************************************
***
*** Descriptive tables and estiamtion for the paper
***
*** SALES, QUANTITY SURCHARGE AND CONSUMER INATTENTION 
***
*** Review of Economics and Statistics
***
*******************************************************************************


*******************************************************************************
*** DESCRIPTIVE TABLES                                                      ***
*******************************************************************************

use FinalData, clear
capture log close
log using Analysis, replace

*******************************************************************************
*** Table 2 - Descriptives
*******************************************************************************

table manucode, c(sum PackProm m TotPackProms med TotPackProms max TotPackProms) row
table manucode, c(m TimeOnProm med TimeOnProm m PromDisc med PromDisc) format(%9.1f) row


*******************************************************************************
*** Table 3 - Taxonomy of QS and promotions
*******************************************************************************

* First drop product-weeks with NumSizes>2

drop if NumSizes==3
drop NumSizes
egen byte NumSizes = count(pack), by(week prodid)
gen S = (SizeRank==2)
gen L = (SizeRank==1)

* Frequency of quantity discounts and surcharges 

tab QS AtLeastOneProm if NumSizes>1 & SizeRank==1, col


*******************************************************************************
*** Table 4 - Ratios of promotion week sales to "regular" sales
*******************************************************************************

xtset packid week
sort packid week

gen nonpromsales = sales if WeekProdProms==0 
egen PackRegSales = median(nonpromsales), by(packid)
gen DQmed = sales/PackRegSales
drop nonpromsales PackRegSales
egen SizeRatio2 = max(SizeRatio), by(prodid week)


* Condition for keeping clean QS events
global cleanQS "(QS==1 & WeekProdProms==1 & SizeRatio2==.5 & lam_scondonl > .99)"

tabstat DQ DQmed if L & $cleanQS, s(n med) /* QS */
bysort quality: tabstat DQ DQmed if L & $cleanQS, s(n med) /* QS */


*******************************************************************************
*** Figure 2 - Normalized sales paths of small and large size around a QS
*******************************************************************************

sort packid week
gen srm1 = L1.sales/sales if QS==1  
gen srm2 = L2.sales/sales if QS==1
gen srm3 = L3.sales/sales if QS==1
gen srp3 = F3.sales/sales if QS==1
gen srp2 = F2.sales/sales if QS==1
gen srp1 = F1.sales/sales if QS==1

table InvSizeRank, c(med srm3 med srm2 med srm1)
table InvSizeRank, c(med srp1 med srp2 med srp3)
table InvSizeRank, c(n srm3 n srm2 n srm1)
table InvSizeRank, c(n srp1 n srp2 n srp3)

/* Table output is saved in Figure2.dta, which is used below to make graph */

preserve

use Figure2, clear
label var period "Time relative to QS period (period 0)"
twoway connected small large period, yt("Sales relative to period 0") scheme(s1mono) ///
		lcolor(black red) mcolor(black red) xlabel(-3(1)3) yline(.2(.2)1,lstyle(major_grid))
window manage close graph		

restore

drop srm* srp* 

*****************************************************************************
*** ESTIMATION
*****************************************************************************


*****************************************************************************
*** Setup
*****************************************************************************

xtset packid week
sort packid week

gen S_QS = S * QS
gen L_QS = L * QS
recode PromDisc .=0

* Define products with sufficient observations to support inference 

global prodnames  "101 102 110 114 115 117 119 120 128 135 136 138 142 143"
global prodnames  "114 115 117 120 135 136 142 143"
global prodnamesc "114,115,117,120,135,136,142,143"

* Keep periods with clean substitution
* Keep 8 products, Large size only
keep if inlist(prodid,$prodnamesc) & L
drop if lam_scondonl < .99
drop if WeekProdProms > 1
drop if PackProm == 1

************************************
*** PRODUCT-SPECIFIC REGRESSIONS ***
************************************

*** OLS

foreach prod of global prodnames {
	disp ""
	disp ""
	disp "Product ID: " `prod'
	disp ""
	reg sales L L_QS if prodid==`prod', noconst robust
	nlcom alpha : 1 + _b[L_QS] / _b[L]
	disp "Test of H0: alpha=1" 
	testnl  1 + _b[L_QS] / _b[L] = 1
	}

*** Nonlinear LS

foreach prod of global prodnames {
	disp ""
	disp ""
	disp "Product ID: " `prod'
	disp ""
	nl (sales = {th0L} * (1 - L_QS + {alpha}*L_QS)) if prodid==`prod' & L, robust
	disp "Test of H0: alpha=1" 
	test _b[/alpha]=1
	}




**************************
*** POOLED REGRESSIONS ***
**************************

* Single alpha, sales fixed effect
nl (sales = {theta14} * (1 - L_QS + {alpha}*L_QS)*(prodid==114)  ///
          + {theta15} * (1 - L_QS + {alpha}*L_QS)*(prodid==115)  ///
          + {theta17} * (1 - L_QS + {alpha}*L_QS)*(prodid==117)  ///
          + {theta20} * (1 - L_QS + {alpha}*L_QS)*(prodid==120)  ///
          + {theta35} * (1 - L_QS + {alpha}*L_QS)*(prodid==135)  ///
          + {theta36} * (1 - L_QS + {alpha}*L_QS)*(prodid==136)  ///
          + {theta42} * (1 - L_QS + {alpha}*L_QS)*(prodid==142)  ///
          + {theta43} * (1 - L_QS + {alpha}*L_QS)*(prodid==143)) ///
		  if inlist(prodid,$prodnamesc) & L, robust

* alpha for premium and value
nl (sales = {theta14} * (1 - L_QS + ({alpha_v}*(1-premium) + {alpha_p}*premium)*L_QS)*(prodid==114)  ///
          + {theta15} * (1 - L_QS + ({alpha_v}*(1-premium) + {alpha_p}*premium)*L_QS)*(prodid==115)  ///
          + {theta17} * (1 - L_QS + ({alpha_v}*(1-premium) + {alpha_p}*premium)*L_QS)*(prodid==117)  ///
          + {theta20} * (1 - L_QS + ({alpha_v}*(1-premium) + {alpha_p}*premium)*L_QS)*(prodid==120)  ///
          + {theta35} * (1 - L_QS + ({alpha_v}*(1-premium) + {alpha_p}*premium)*L_QS)*(prodid==135)  ///
          + {theta36} * (1 - L_QS + ({alpha_v}*(1-premium) + {alpha_p}*premium)*L_QS)*(prodid==136)  ///
          + {theta42} * (1 - L_QS + ({alpha_v}*(1-premium) + {alpha_p}*premium)*L_QS)*(prodid==142)  ///
          + {theta43} * (1 - L_QS + ({alpha_v}*(1-premium) + {alpha_p}*premium)*L_QS)*(prodid==143)) ///
		  if inlist(prodid,$prodnamesc) & L, robust initial(alpha_v .55 alpha_p .65)
test _b[/alpha_v] = _b[/alpha_p]


nl (sales = {th0L14} * (L - L_QS + ({alpha}+{b_prem}*premium)*L_QS)*(prodid==114)  ///
          + {th0L15} * (L - L_QS + ({alpha}+{b_prem}*premium)*L_QS)*(prodid==115)  ///
          + {th0L17} * (L - L_QS + ({alpha}+{b_prem}*premium)*L_QS)*(prodid==117)  ///
          + {th0L20} * (L - L_QS + ({alpha}+{b_prem}*premium)*L_QS)*(prodid==120)  ///
          + {th0L35} * (L - L_QS + ({alpha}+{b_prem}*premium)*L_QS)*(prodid==135)  ///
          + {th0L36} * (L - L_QS + ({alpha}+{b_prem}*premium)*L_QS)*(prodid==136)  ///
          + {th0L42} * (L - L_QS + ({alpha}+{b_prem}*premium)*L_QS)*(prodid==142)  ///
          + {th0L43} * (L - L_QS + ({alpha}+{b_prem}*premium)*L_QS)*(prodid==143)) ///
	     	if inlist(prodid,$prodnamesc) & L, robust



log close
exit

*******************************************************************
*******************************************************************
*******************************************************************
*******************************************************************


