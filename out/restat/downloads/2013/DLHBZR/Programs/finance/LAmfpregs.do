clear
set more 1
set mem 20m
set matsize 800

clear
use ${DTA}\LAdata_finance

capture log close
log using ${LOG}\LAmfpregs, replace text

*control specifciations
*Control sets
global census "percapinc6 perplumb6 perinclt30006 lnpop6 perurban6"
*starting Expenditure
global fincont "initexp"

**psf from state rev table included per-educable payments: revst_psf (from state rev table)=totcost-totsupport+pereduc
*define total cost as sum of salaries, transportation salaries, salary adjustment and declining enrollment adjustment and per-adm allotment)
recode salary_adj .=0
recode adj_decl .=0
replace totcost=salaries+transport+salary_adj+adj_decl+admxothcost
*define total support as 5 mill const tax, and share of severance taxes and rent or lease of school property (exclude per-educable grant)
replace totsupport=const5mill+sevtax+rent
*define other adjustments as diff between rev recieved from PSF and amount reported in MFP table of previous year
gen adjoth=revst_psf-totcost+totsupport


*** description of minimum finance program
/** program costs is 
teacher salaries (teachsal)
supervisor salaries (supersal)
visiting teacher salaries (visitsal)
trasportation salaries (transsal)
(all salaries are salaries)
teacher salary adjustment
adm allocation (admxothcost)

total support is
per-educable payment from state (pereduc)
5 mill constitutional tax (const5mill)	
50% of severance tax (sevtax)
rent or lease of school property (rent)

adjustments
adjustment for declining enrollment (adj_decl) -- this is added to total cost for analysis
other adjustments -- other differences between amount required for equalization reported in MFP table and state psf table in next year
*/

*generate changes from 1965 to 1970 and 1965 to 1973

cap mkdir ${OUTREG}/MFP

foreach var in revst_psf totcost salaries transport admxothcost adj_decl salary_adj totsupport const5mill sevtax rent adjoth {
	capture drop pp`var'
	gen pp`var'=`var'/enroll

	gen x=pp`var' if year==1965
	gen y=pp`var' if year==1970
	egen x1=mean(x), by(fipscnty)
	egen y1=mean(y), by(fipscnty)
	gen chpp`var'1=y1-x1
	drop x x1 y y1

	gen x=pp`var' if year==1965
	gen y=pp`var' if year==1973
	egen x1=mean(x), by(fipscnty)
	egen y1=mean(y), by(fipscnty)
	gen chpp`var'2=y1-x1
	drop x x1 y y1

	}

local year=1961

*use specifciations 1 and 2 
cap gen one=1
qui reg one fracbl fracti $census $fincont if year==1961
est store spec0
foreach var in revst_psf totcost salaries transport admxothcost adj_decl salary_adj totsupport const5mill sevtax rent adjoth {

	local spec=1
	display "`year'"
	reg chpp`var'1 fracbl if year==`year'
	est store _`spec'`var'
	local spec=`spec'+1

	reg chpp`var'1 fracbl fracti1966 $census $fincont if year==`year'
	est store _`spec'`var'
	local spec=`spec'+1

	reg chpp`var'2 fracbl if year==`year'
	est store _`spec'`var'
	local spec=`spec'+1
	
	reg chpp`var'2 fracbl fracti1966 $census $fincont if year==`year'
	est store _`spec'`var'
	*local spec=`spec'+1
	
	est restore spec0	
	outreg2 [spec0] using ${OUTREG}/MFP/mfp`var', replace excel 
		forval i=1/`spec' {
			cap outreg2 [_`i'`var'] using ${OUTREG}/MFP/mfp`var', append excel 
			}	
	erase ${OUTREG}/MFP/mfp`var'.txt
	}


*create table with the coefficients in the right order
*change from 1965-1970 with no controls
outreg2 fracbl [_1revst_psf] using $OUTREG/MFP/mfp_change1965_1970_nocontrols, replace excel noaster
	foreach var in totcost salaries transport admxothcost adj_decl salary_adj totsupport const5mill sevtax rent adjoth {
		outreg2 fracbl [_1`var'] using $OUTREG/MFP/mfp_change1965_1970_nocontrols, append excel noaster
		}
	erase $OUTREG/MFP/mfp_change1965_1970_nocontrols.txt

*change from 1965-1970 with controls
outreg2 fracbl [_2revst_psf] using $OUTREG/MFP/mfp_change1965_1970_withcontrols, replace excel noaster
	foreach var in totcost salaries transport admxothcost adj_decl salary_adj totsupport const5mill sevtax rent adjoth {
		outreg2 fracbl [_2`var'] using $OUTREG/MFP/mfp_change1965_1970_withcontrols, append excel noaster
		}
	erase $OUTREG/MFP/mfp_change1965_1970_withcontrols.txt


*change from 1965-1973 with no controls
outreg2 fracbl [_3revst_psf] using $OUTREG/MFP/mfp_change1965_1973_nocontrols, replace excel noaster
	foreach var in totcost salaries transport admxothcost adj_decl salary_adj totsupport const5mill sevtax rent adjoth {
		outreg2 fracbl [_3`var'] using $OUTREG/MFP/mfp_change1965_1973_nocontrols, append excel noaster
		}
	erase $OUTREG/MFP/mfp_change1965_1973_nocontrols.txt

*change from 1965-1970 with controls
outreg2 fracbl [_4revst_psf] using $OUTREG/MFP/mfp_change1965_1973_withcontrols, replace excel noaster
	foreach var in totcost salaries transport admxothcost adj_decl salary_adj totsupport const5mill sevtax rent adjoth {
		outreg2 fracbl [_4`var'] using $OUTREG/MFP/mfp_change1965_1973_withcontrols, append excel noaster
		}
	erase $OUTREG/MFP/mfp_change1965_1973_withcontrols.txt

capture log close
