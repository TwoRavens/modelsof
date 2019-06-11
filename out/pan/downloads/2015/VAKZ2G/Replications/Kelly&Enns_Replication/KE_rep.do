* Grant and Lebo Replication - Kelly & Enns 2010

cd "dir:"
use "dir/KE_rep.dta", clear

************
* Table E7 *
************

*Column 1*
reg d.mood l.mood d.policy l.policy d.unemployment l.unemployment d.inflation l.inflation
*Column 2*
reg d.mood l.mood d.policy l.policy d.gini l.gini
*Column 3*
reg d.mood l.mood d.policy l.policy d.gini l.gini d.unemployment l.unemployment d.inflation l.inflation
*Column 4*
regress d.welfare l.welfare d.policy l.policy d.gini l.gini

************
* Table E8 *
************
*Column 1*
prais d.mood_lowinc l.mood_lowinc d.policy l.policy d.gini l.gini
*Column 2*
prais d.mood_highinc l.mood_highinc d.policy l.policy d.gini l.gini
*Column 3*
prais d.mood_lowinc l.mood_lowinc d.policy l.policy d.gini l.gini d.unemployment l.unemployment d.inflation l.inflation
*Column 4*
prais d.mood_highinc l.mood_highinc d.policy l.policy d.gini l.gini d.unemployment l.unemployment d.inflation l.inflation


************
* Table E9 *
************

dfuller mood, reg
arfima d.mood
dfuller welfare, reg
arfima d.welfare
dfuller mood_lowinc, reg
arfima d.mood_low
dfuller mood_highinc, reg
arfima d.mood_high


************
* Table E10 *
************

* see KE_MC_TBLE10.do

************
* Table E11 *
************

* see KE_MC_TBLE11.do

************
* Table E12 *
************

* see KE_MC_TBLE12.do

************
* Table E13 *
************
* Column 1
 reg d.mood l.mood d.beef l.beef d.tornadodeath l.tornadodeath d.acre10k l.acre10k
* Column 2
 reg d.mood l.mood d.beef l.beef d.coal l.coal
* Column 3
 reg d.mood l.mood d.beef l.beef d.coal l.coal d.acre10k l.acre10k d.tornadodeath l.tornadodeath
* Column 4
 reg d.welfare l.welfare d.beef l.beef d.coal l.coal
 
************
* Table E14 *
************
* Column 1
 reg d.mood_lowinc l.mood_lowinc d.beef l.beef d.coal l.coal
* Column 2
 reg d.mood_highinc l.mood_highinc d.beef l.beef d.coal l.coal
* Column 3
 reg d.mood_lowinc l.mood_lowinc d.beef l.beef d.coal l.coal d.acre10k l.acre10k d.tornadodeath l.tornadodeath
* Column 4
 reg d.mood_highinc l.mood_highinc d.beef l.beef d.coal l.coal d.acre10k l.acre10k d.tornadodeath l.tornadodeath
 
 
************
* Table E15 *
************
arfima d.mood
predict dmoodf, fdiff
arfima d.welfare
predict dwelf, fdiff
arfima d.mood_lowinc
predict dmoodlowf, fdiff
arfima d.mood_highinc
predict dmoodhighf, fdiff
arfima d.policy
predict dpolicyf, fdiff
arfima d.gini
predict dginif, fdiff
arfima d.unemployment
predict dunemf, fdiff
arfima d.inflation
predict dinf, fdiff


*********************
* Table E16 and E17 *
*********************
* Fractional Differencing and FECM

* Create Individual ECMs * 
* TABLE 1 *
reg mood policy
predict res11, r
reg mood gini
predict res12, r
reg welfare policy
predict res13, r
reg welfare gini
predict res14, r

* TABLE 2 * 
reg mood_lowinc policy
predict res21, r
reg mood_lowinc gini
predict res22, r
reg mood_highinc policy
predict res23, r
reg mood_highinc gini
predict res24, r

* Create Combination ECMs *
* TABLE 1 *
reg mood policy gini
predict resfull1, r
reg welfare policy gini
predict resfull2, r

* TABLE 2 * 
reg mood_lowinc policy gini
predict resfull3, r
reg mood_highinc policy gini
predict resfull4, r

* Fractionally Difference Residuals
arfima d.res11
predict dres11f, fdiff
arfima d.res12
predict dres12f, fdiff
arfima d.res13
predict dres13f, fdiff
arfima d.res14
predict dres14f, fdiff

arfima d.res21
predict dres21f, fdiff
arfima d.res22
predict dres22f, fdiff
arfima d.res23
predict dres23f, fdiff
arfima d.res24
predict dres24f, fdiff

arfima d.resfull1
predict dresfull1f, fdiff
arfima d.resfull2
predict dresfull2f, fdiff

arfima d.resfull3
predict dresfull3f, fdiff
arfima d.resfull4
predict dresfull4f, fdiff


** TABLE E16 **
**** Table 1 - Individual FECMs ****
* Model 1 
reg dmoodf dpolicyf dunemf dinf l.dres11f
* Model 2
reg dmoodf dpolicyf dginif l.dres12f
* Model 3
reg dmoodf dpolicyf dginif dunemf dinf l.dres11f
reg dmoodf dpolicyf dginif dunemf dinf l.dres12f
* Model 4
reg dwel dpolicyf dginif l.dres13f
reg dwel dpolicyf dginif l.dres14f

**** Table 1 - Groups FECMs ****
* Model 1 
reg dmoodf dpolicyf dunemf dinf l.dres11f
* Model 2
reg dmoodf dpolicyf dginif l.dresfull1f
* Model 3
reg dmoodf dpolicyf dginif dunemf dinf l.dresfull1f
* Model 4
reg dwelf dpolicyf dginif l.dresfull2f

** TABLE E17 **
**** Table 2 - FECM ****
* Model 1
reg dmoodlowf dpolicyf dginif l.dres21f
reg dmoodlowf dpolicyf dginif l.dres22f
* Model 2
reg dmoodhighf dpolicyf dginif l.dres23f
reg dmoodhighf dpolicyf dginif l.dres24f
* Model 3
reg dmoodlowf dpolicyf dginif dunemf dinf l.dres21f
reg dmoodlowf dpolicyf dginif dunemf dinf l.dres22f
* Model 4
reg dmoodhighf dpolicyf dginif dunemf dinf l.dres23f
reg dmoodhighf dpolicyf dginif dunemf dinf l.dres24f

**** Table 2 - Groups FECMs ****
* Model 1
reg dmoodlowf dpolicyf dginif l.dresfull3f
* Model 2
reg dmoodhighf dpolicyf dginif l.dresfull4f
* Model 3
reg dmoodlowf dpolicyf dginif dunemf dinf l.dresfull3f
* Model 4
reg dmoodhighf dpolicyf dginif dunemf dinf l.dresfull4f


* Differenced Models (Not in Paper Supplement)
*Table 1, Column 1*
regress d.mood d.policy d.unemployment d.inflation
*Table 1, Column 2*
regress d.mood d.policy d.gini
*Table 1, Column 3*
regress d.mood d.policy d.gini d.unemployment d.inflation
*Table 1, Column 4*
regress d.welfare d.policy d.gini
 

