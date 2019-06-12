clear
clear mata
set memory 700m
set more off, perm

// Directories
local dirworking "../IntermediateFiles/"
local diroutput "../Output/"
local diroutputMat   "../../Matlab/Structural/data/"

use "`dirworking'master.dta", clear

local whereIstarted `c(pwd)'
cd "`diroutput'"

**************************************************
* Specify Sample Used
**************************************************

* NN: we use data starting in 1995
* (vs. 2000 for other tables)

***** Main Choice Of Sample *****
* For pre-crisis sample:
*drop if date>=mdy(01,01,2008)
*For full-sample less apex of crisis:
drop if date>=mdy(07,01,2008) & date<mdy(07,01,2009)

***** Specific Dates to Be Dropped *****
* 9/11 and market turmoil in following days
drop if date>=mdy(09,11,2001) & date<mdy(09,22,2001)
* If unscheduled FOMC days are to be dropped (from control sample)
*drop if unscheduled==1 | isconfcall == 1
* Lehman and AIG
drop if date==mdy(09,15,2008) | date==mdy(09,16,2008)

* Uncomment to drop unscheduled meetings:
replace FOMCused = 0 if unscheduled_all==1

**************************************************
* Export data to Matlab 
**************************************************
outsheet year month day FOMCused dffr1 dffr2 dedfutbeg2_m dedfutbeg3 dedfutbeg4 DNY1 ///
         using "`diroutputMat'dataForMatlabDaily_m.csv", comma replace

outsheet year month day FOMCused dffr1_tick_wide_scaled dffr2_tick_wide_scaled ///
         ded2_tick_wide ded3_tick_wide ded4_tick_wide DNY1 ///
         using "`diroutputMat'dataForMatlabTick_m.csv", comma replace

**************************************************
* Construct Path Factors
*
* path_m and path are the first principle component of
* dffr1 dffr2 dedfutbeg2_m dedfutbeg3 dedfutbeg4
* path_m is only on meeting dates
*
* path_orth_m and path_orth are constructed by first
* orthogonalizing dffr2 dedfutbeg2_m dedfutbeg3 dedfutbeg4
* with respect to dffr1 and then taking the first principle
* component of the resulting four series
* Again path_orth_m is only defined on meeting dates
*
* path_intra_m and path_intro are analogous to path_m and
* path except that they are constructed using intraday data
***************************************************

* 1. Daily path factor (i.e. first principle component of dffr1 dffr2 dedfutbeg2_m dedfutbeg3 dedfutbeg4 on FOMCused days)
pca  dffr1 dffr2 dedfutbeg2_m dedfutbeg3 dedfutbeg4 if FOMCused==1
predict path_m  if FOMCused==1, score
* Rescale path_m so as to yield 1 when DNY1 is regressed on it
reg DNY1 path_m if FOMCused==1,  r
mat scale = e(b)
replace path_m=path_m*scale[1,1]
*Extrapolate path factor to nonFOMC days
regress path_m dffr1 dffr2 dedfutbeg2_m dedfutbeg3 dedfutbeg4 if FOMCused==1, r
mat coeff = e(b)
gen path = coeff[1,1]*dffr1+coeff[1,2]*dffr2 +coeff[1,3]*dedfutbeg2_m +coeff[1,4]*dedfutbeg3 +coeff[1,5]*dedfutbeg4 +coeff[1,6]
* Daily path factor constructed as in GSS
* Orthogonalize dffr2 dedfutbeg2_m dedfutbeg3 dedfutbeg4 with respect to dffr1
foreach varb in dffr2 dedfutbeg2_m dedfutbeg3 dedfutbeg4 {
	reg `varb' dffr1 if FOMCused==1, r
	predict `varb'_inres if FOMCused==1, resid
}
* Calculate first principle component of resulting four series
pca  dffr2_inres dedfutbeg2_m_inres dedfutbeg3_inres dedfutbeg4_inres if FOMCused==1
predict path_orth_m  if FOMCused==1, score
* Rescale path_orth
reg DNY1 dffr1 path_orth_m if FOMCused==1,  r
mat scale = e(b)
replace path_orth_m=path_orth_m*scale[1,2]
*Extrapolation of the meeting-based path factor on the non-meeting dates
regress path_orth_m dffr1 dffr2 dedfutbeg2_m dedfutbeg3 dedfutbeg4 if FOMCused==1, r
mat coeff = e(b)
gen path_orth = coeff[1,1]*dffr1+coeff[1,2]*dffr2 +coeff[1,3]*dedfutbeg2_m +coeff[1,4]*dedfutbeg3 +coeff[1,5]*dedfutbeg4 +coeff[1,6]
*drop *_inres

* 2. Intraday path factor
pca  dffr1_tick_wide_scaled dffr2_tick_wide_scaled ded2_tick_wide ded3_tick_wide ded4_tick_wide if FOMCused==1
predict path_intra_wide_m if FOMCused==1, score
* Rescale path_intra_wide_m so as to yield 1 when DNY1 is regressed on it
reg DNY1 path_intra_wide_m if FOMCused==1,  r
mat scale = e(b)
replace path_intra_wide_m=path_intra_wide_m*scale[1,1]
*Extrapolate intraday path factor to nonFOMC days
regress path_intra_wide_m dffr1_tick_wide_scaled dffr2_tick_wide_scaled ded2_tick_wide ded3_tick_wide ded4_tick_wide if FOMCused==1, r
mat coeff = e(b)
gen path_intra_wide = coeff[1,1]*dffr1_tick_wide_scaled+coeff[1,2]*dffr2_tick_wide_scaled +coeff[1,3]*ded2_tick_wide +coeff[1,4]*ded3_tick_wide +coeff[1,5]*ded4_tick_wide +coeff[1,6]

gen dffr1_intra_wide = dffr1_tick_wide_scaled



***************************************************
* Construct Monthly Shock
***************************************************

keep date_daily FOMC unscheduled isconfcall FOMCused path_m path path_intra_wide_m path_intra_wide

gen year=year(date_daily)
gen month=month(date_daily)
gen day=day(date_daily)

*Check that shock is always zero if FOMCused = 0
summ path_intra_wide_m if FOMCused==0

*Construct montly shock as the sum of the shocks (path factor on FOMC date) in the month
foreach var in path_m path_intra_wide_m {
	bysort year month: egen mshock_`var' = sum(`var')
}

*BlueChip survey is submitted in the first several business days of each month. A conservative construction of monthly shock is the sum of the shock in a month except the first week.
gen week1=1 if day==1 | day==2 | day==3 | day==4 | day==5 | day==6 | day==7
foreach var in path_m path_intra_wide_m{
	bysort year month: egen w1_mshock_`var' = sum(`var') if week1==1
	bysort year month: replace w1_mshock_`var' = w1_mshock_`var'[1]
	gen con_mshock_`var' = mshock_`var' - w1_mshock_`var'
}


keep year month mshock_path_m mshock_path_intra_wide_m con_mshock_path_m con_mshock_path_intra_wide_m

*Convert dataset into monthly dataset
collapse mshock_path_m mshock_path_intra_wide_m ///
con_mshock_path_m con_mshock_path_intra_wide_m, ///
by (year month)

sort year month

save `dirworking'MonthlyShock.dta, replace



**********************************************************
* Merge with BlueChip Data (and print BC data for Matlab)
**********************************************************x

use "`dirworking'BlueChip_reg.dta", clear
sort year month
outsheet year month DRealGDP_* using "`diroutputMat'dataForMatlabBlueChipGDPDaily.csv", comma replace
outsheet year month DRealGDP_* using "`diroutputMat'dataForMatlabBlueChipGDPTick.csv", comma replace


merge year month using `dirworking'MonthlyShock.dta
drop _merge

save "`dirworking'BlueChip_monthlyshock", replace

use "`dirworking'BlueChip_monthlyshock", clear

**************************************************
* Specify Sample Used
**************************************************
gen YM = ym(year,month)
drop if YM>ym(2008,07) & YM<=ym(2009,07) // Since we use a "lagged" shock, this ensures that we
                                         // drop all shocks between 2008jul and 2009jun

*BlueChip survey is submitted in the first few business days of each month, so the shock in the previous month is relevant.
foreach shock in mshock_path_m mshock_path_intra_wide_m con_mshock_path_m con_mshock_path_intra_wide_m {
	gen L`shock'=`shock'[_n-1]
}

* for loop can loop over following variables: mshock_path_m mshock_path_intra_wide_m con_mshock_path_m con_mshock_path_intra_wide_m

foreach shock in con_mshock_path_intra_wide_m {
	reg Dtbond_L1q L`shock' if L`shock' != 0, r
	outreg2 using OLS_`shock', excel replace stats(coef, se) dec(2) label noaster
	foreach bc in Dtbond_0q Dtbond_F1q Dtbond_F2q Dtbond_F3q Dtbond_F4q Dtbond_F5q Dtbond_F6q Dtbond_F7q{
	reg `bc' L`shock' if L`shock' != 0, r
	outreg2 using OLS_`shock', excel append stats(coef, se) dec(2) label noaster
	}
	foreach bc in Dtbill Drtbillcpi Drtbillpce Drtbillpgdp DRealGDP DPPI DPCE DNetExport DIP DGDPPriceIndex DDisposablePersonalIncome DCPI DCivilianUnemploymentRate DChangeInPrivateInventory{
		foreach quarter in L1q 0q F1q F2q F3q F4q F5q F6q F7q{
			reg `bc'_`quarter' L`shock' if L`shock' != 0, r
			outreg2 using OLS_`shock', excel append stats(coef, se) dec(2) label noaster
		}
	}
}


*Robustness table (Table 6 with different time periods)
*Full sample
foreach shock in con_mshock_path_intra_wide_m {
	reg DRealGDP_0q L`shock' if L`shock' != 0, r
	outreg2 using GDPregs_`shock'_fullsamp, excel replace stats(coef, se) dec(2) label noaster
	
	foreach bc in DRealGDP {
		foreach quarter in F1q F2q F3q F4q F5q F6q F7q{
			reg `bc'_`quarter' L`shock' if L`shock' != 0, r
			outreg2 using GDPregs_`shock'_fullsamp, excel append stats(coef, se) dec(2) label noaster
		}
	}
}

*Pre-Crisis
foreach shock in con_mshock_path_intra_wide_m {
	reg DRealGDP_0q L`shock' if L`shock' != 0 & year>=2000 &  year<=2007, r
	outreg2 using GDPregs_`shock'_2000m1-2007m12, excel replace stats(coef, se) dec(2) label noaster
	
	foreach bc in DRealGDP {
		foreach quarter in F1q F2q F3q F4q F5q F6q F7q{
			reg `bc'_`quarter' L`shock' if L`shock' != 0 & year>=2000 &  year<=2007, r
			outreg2 using GDPregs_`shock'_2000m1-2007m12, excel append stats(coef, se) dec(2) label noaster
		}
	}
}

*Pre-2000
foreach shock in con_mshock_path_intra_wide_m {
	reg DRealGDP_0q L`shock' if L`shock' != 0 & year<2000, r
	outreg2 using GDPregs_`shock'_1995m1-1999m12, excel replace stats(coef, se) dec(2) label noaster
	
	foreach bc in DRealGDP {
		foreach quarter in F1q F2q F3q F4q F5q F6q F7q{
capture:	reg `bc'_`quarter' L`shock' if L`shock' != 0 & year < 2000, r
			outreg2 using GDPregs_`shock'_1995m1-1999m12, excel append stats(coef, se) dec(2) label noaster
		}
	}
}

*Post-2000
foreach shock in con_mshock_path_intra_wide_m {
	reg DRealGDP_0q L`shock' if L`shock' != 0 & year>=2000, r
	outreg2 using GDPregs_`shock'_2000m1-2014m4, excel replace stats(coef, se) dec(2) label noaster
	
	foreach bc in DRealGDP {
		foreach quarter in F1q F2q F3q F4q F5q F6q F7q{
capture:		reg `bc'_`quarter' L`shock' if L`shock' != 0 & year >= 2000, r
			outreg2 using GDPregs_`shock'_2000m1-2014m4, excel append stats(coef, se) dec(2) label noaster
		}
	}
}


*Different time periods for "summary statistic" of GDP growth expectations
gen DRealGDP_Summary = (DRealGDP_F1q  + DRealGDP_F2q + DRealGDP_F3q )/3
reg DRealGDP_Summary Lcon_mshock_path_intra_wide_m if Lcon_mshock_path_intra_wide_m != 0, r

label var DRealGDP_Summary fullsample
outreg2 using GDPsummregs, excel replace stats(coef, se) dec(2) label noaster addnote(Dependent variable is (DRealGDP_F1q  + DRealGDP_F2q + DRealGDP_F3q )/3 )
reg DRealGDP_Summary Lcon_mshock_path_intra_wide_m if year>=2000 &  year<=2007 & Lcon_mshock_path_intra_wide_m != 0, r
label var DRealGDP_Summary "2000m1-2007m12"
outreg2 using GDPsummregs, excel append stats(coef, se) dec(2) label noaster 
reg DRealGDP_Summary Lcon_mshock_path_intra_wide_m if year<2000 & Lcon_mshock_path_intra_wide_m != 0, r
label var DRealGDP_Summary "1995m1-1999m12"
outreg2 using GDPsummregs, excel append stats(coef, se) dec(2) label noaster
reg DRealGDP_Summary Lcon_mshock_path_intra_wide_m if year>=2000 & Lcon_mshock_path_intra_wide_m != 0, r
label var DRealGDP_Summary "2000m1-2014m4"
outreg2 using GDPsummregs, excel append stats(coef, se) dec(2) label noaster

*Scatter Plot of this Summary Measure
*Note that less than 50 or 20 points are created below
binscatter DRealGDP_Summary Lcon_mshock_path_intra_wide_m  if Lcon_mshock_path_intra_wide_m != 0, nquantiles(50) savedata(binscatter50_DRealGDP_Summary) replace reportreg
binscatter DRealGDP_Summary Lcon_mshock_path_intra_wide_m if Lcon_mshock_path_intra_wide_m != 0, nquantiles(20) savedata(binscatter20_DRealGDP_Summary) replace

*Summary Statistics for Shocks and Survey data changes
tab year if DRealGDP_Summary ~=. & Lcon_mshock_path_intra_wide_m ~=.
 summ DRealGDP_Summary Lcon_mshock_path_intra_wide_m
gen time = year + month/12
 line DRealGDP_Summary Lcon_mshock_path_intra_wide_m time

cd "`whereIstarted'"
