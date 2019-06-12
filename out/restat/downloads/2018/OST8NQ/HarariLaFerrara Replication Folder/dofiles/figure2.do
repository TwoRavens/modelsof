*===================================================================================================
* set up
*===================================================================================================
cap log close

global name = "figure2a"
local cdate : di %tdCCYY.NN.DD date(c(current_date),"DMY")
log using "${logs}/${name}_`cdate'.log", text replace

* Coefficients from table 2, column 5

local Y_lag 0.1210000
local W_Y 0.0229000
local GSmain_ext_SPEI4pg 0.0207
local L1_GSmain_ext_SPEI4pg -0.0367000
local L2_GSmain_ext_SPEI4pg -0.00925
local W_GSmain_ext_SPEI4pg -0.0042000
local W_L1_GSmain_ext_SPEI4pg 0.0064800
local W_L2_GSmain_ext_SPEI4pg 0.000522

use "${data}/geoconflict_main.dta", clear

* Take an arbitrary cell in the middle of the grid and its neighbors

*keep if ((lon<28.5 & lon> 20.5) & (lat>-6.5 & lat<4.5))
keep if (lat>=-6.5 & lat<2.5 & lon>19.5 & lon<29.5)

keep cell lat lon  _ID
quie duplicates drop
sum cell
local nobs `r(N)'

*** Weighting matrix, 180 km cutoff, linear

preserve
	spwmatrix gecon lat lon, wn(W_bin_180) wtype(bin)  db(0 180) connect
	clear
	svmat W_bin_180
	mkmat W_bin_180*, matrix(W_bin_180)
	local matrix W_bin_180
restore
	
* Set to 0 dep var and all regressors in t=0 and t=1
foreach q in ANY_EVENT_cell SPEI4pg L1_SPEI4pg L2_SPEI4pg GSmain_ext_SPEI4pg L1_GSmain_ext_SPEI4pg L2_GSmain_ext_SPEI4pg W_SPEI4pg W_L1_SPEI4pg	W_L2_SPEI4pg W_GSmain_ext_SPEI4pg W_L1_GSmain_ext_SPEI4pg W_L2_GSmain_ext_SPEI4pg {
gen `q'_0=0 
gen `q'_1=0
}

* Generate a shock GSmain_ext_SPEI4pg = -0.365 in t=2 in the central cell
gen shock=0
replace shock=1 if (lon ==24.5 & lat==-2.5)
gen GSmain_ext_SPEI4pg_2=0
replace GSmain_ext_SPEI4pg_2=-0.365 if shock==1

gen Y_lag=.
gen GSmain_ext_SPEI4pg=.
gen L1_GSmain_ext_SPEI4pg=.
gen L2_GSmain_ext_SPEI4pg=.

forvalues j=2(1)21 {

	local j_lag1=`j'-1
	local j_lag2=`j'-2
	local j_lead1=`j'+1

	********* what happens in t=j in own cell

	gen GSmain_ext_SPEI4pg_`j_lead1'=0 /* no more shocks */

	replace Y_lag=ANY_EVENT_cell_`j_lag1'
	replace GSmain_ext_SPEI4pg=GSmain_ext_SPEI4pg_`j'
	replace L1_GSmain_ext_SPEI4pg=GSmain_ext_SPEI4pg_`j_lag1'
	replace L2_GSmain_ext_SPEI4pg=GSmain_ext_SPEI4pg_`j_lag2'

	******* what happens in t=j in neighboring cells
	
	* generate spatial lags
	
	local var_to_lag GSmain_ext_SPEI4pg L1_GSmain_ext_SPEI4pg L2_GSmain_ext_SPEI4pg
	
	preserve
		sort cell 
		keep `var_to_lag' cell
		
		mkmat `var_to_lag', matrix(lags)
		matrix lag1_= `matrix' *  lags
		
		svmat lag1_
		local count=0
		foreach x of local var_to_lag {
			local count=`count'+1
			rename lag1_`count' W_`x' 
		}
		keep cell W_*
		sort cell 
		quietly compress
		sort cell
		save temp, replace
	restore
	
	* merge spatial lags to main dataset
	sort cell 
	merge 1:1 cell using temp
	tab _m
	drop _m
	quietly compress
	cap erase temp.dta

	foreach q in 1 2 3 4 5 6 7 8 9 10 11 12 13 {
		cap drop term`q'
	}
	
	******* what happens in t=j to autoregressive term
	
	gen term1=`Y_lag'*Y_lag
	gen term5=`GSmain_ext_SPEI4pg'*GSmain_ext_SPEI4pg
	gen term6=`L1_GSmain_ext_SPEI4pg'*L1_GSmain_ext_SPEI4pg
	gen term7=`L2_GSmain_ext_SPEI4pg'*L2_GSmain_ext_SPEI4pg
	gen term11=`W_GSmain_ext_SPEI4pg'*W_GSmain_ext_SPEI4pg
	gen term12=`W_L1_GSmain_ext_SPEI4pg'*W_L1_GSmain_ext_SPEI4pg
	gen term13=`W_L2_GSmain_ext_SPEI4pg'*W_L2_GSmain_ext_SPEI4pg
	cap drop Ytilde
	egen Ytilde= rowtotal(term1 term5 term6 term7 term11 term12 term13 )

	matrix I=I(`nobs')
	matrix I=I(`nobs')
	matrix IminusW=(I-`W_Y'*`matrix')
	matrix IminusW_inv=inv(IminusW)
	mkmat Ytilde, matrix(Ytilde)
	matrix Y2=IminusW_inv*  Ytilde
	svmat Y2
	rename Y21 Y2

	rename Y2 Y_pred_`j'
	cap gen ANY_EVENT_cell_`j'=Y_pred_`j'

}

keep cell lat lon *pred* shock _ID

******* merge spatial lags of predicted Y to main dataset

local var_to_lag "Y_pred_2 Y_pred_3 Y_pred_4 Y_pred_5 Y_pred_6 Y_pred_7 Y_pred_8 Y_pred_9 Y_pred_10 Y_pred_11"

preserve

	sort cell 
	keep `var_to_lag' cell 
	mkmat `var_to_lag', matrix(lags)
	matrix lag1_=`matrix'*  lags
	svmat lag1_

	local count=0
	foreach x of local var_to_lag {
	local count=`count'+1
	rename lag1_`count' W_`x' 
	}
	keep cell W_*
	sort cell 
	quietly compress
	tempfile temp 
save `temp', replace

restore

sort cell 
merge cell using `temp'
tab _m
drop _m
quietly compress
cap erase `temp'.dta

*===============================================================================
** Figure 2a
*===============================================================================

preserve

	keep if shock==1
	
	gen id=1
	reshape long Y_pred_ W_Y_pred_, i(i) j(t)
	replace W_Y_pred_=W_Y_pred_/7.4
				
	keep t Y_pred_ W_Y_pred_ 
	tsset t
	keep if t<=7
	
	gen year=t-2
	
	bys year: sum Y_pred_ W_Y_pred_ 

	twoway (line Y_pred_ year, lpattern(solid) lcolor(black) lwidth(medthick)) ///
	(line W_Y_pred_ year, lpattern(dash) lcolor(black) lwidth(medthick)), ///
	ylabel(-0.01 (0.005)0.015, grid) xlabel (0(1)5) xtitle("Years since shock") legend(label(1 "cell with shock") label(2 "neighboring cell"))
	graph export "${output}/Figure2a.pdf", replace 
	
	cap graph drop all
	
restore

*===============================================================================
** figure 2b
*===============================================================================

foreach i in 2 3 5 4 6 7 8 9 10 11 12 13 14{
	local  period=`i'-2
		spmap Y_pred_`i' using "${data}/intersect_coord" , id(_ID) fcolor(Blues) clmethod(custom) legend(size(medium)) clbreaks (-.008 0.00005 0.0001 0.00015 0.0003 0.0005 0.001 0.003 0.0075 0.10 ) title("t=`period'") name(year_`i'_2017,replace)
}

cap erase "${output}/Figure2b.pdf"

** combine years to show the changes 
grc1leg year_2_2017 year_3_2017 year_4_2017 year_6_2017 , name(figure2b) legendfrom(year_2_2017)  position(4)
graph export "${output}/Figure2b.pdf", replace name(figure2b)
graph drop _all 

cap log close
