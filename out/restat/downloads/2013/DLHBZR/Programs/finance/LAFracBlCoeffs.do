clear
local date="2008-10-14"
set more 1
set mem 20m
set matsize 800

clear
use ${DTA}\LAdata_finance
capture log close
log using ${LOG}\LAFracBlCoeffs, replace text

keep if year>=1955&year<=1975

gen x=fracbl if year==1961
egen fracbl61=max(x), by(fipscnty)

local trends "lnenrwh fracprivwh pprevtot pprevloc pprevst_psf pprevfed_esea ppexpcurr strat"

global census "percapinc6 perplumb6 perinclt30006 lnpop6 perurban6"

foreach var in `trends'  {
	statsby _b _se, by(year) saving(${DTA}\statsby\fracbl_coeff`var', replace): reg `var' fracbl61 fracti ${census}
	}

foreach var in `trends' {
	clear
	use ${DTA}\statsby\fracbl_coeff`var'
	gen x=_b_fracbl if year==1965
	egen y=max(x)
	replace _b_fracbl=_b_fracbl-y
	drop x y
	gen upper=_b_fracbl+1.96*_se_fracbl
	gen lower=_b_fracbl-1.96*_se_fracbl
	if "`var'"=="pprevfed_esea" {
		replace upper=. if year<1965
		replace lower=. if year<1965
		}
	
	save, replace
}	

*replace variables to missing for revfed_esea before 1965
use ${DTA}\statsby\fracbl_coeffpprevfed_esea
replace _b_fracbl=. if year<1965
replace _se_fracbl=. if year<1965
save, replace

*Graphs by outcome variable
#delimit ;

cd ${GRAPHS};

*Enrollment variables;
*ln white enrollment
clear;
use ${DTA}\statsby\fracbl_coefflnenrwh;
graph twoway connected _b_fracbl upper lower year, 
	scheme(s1mono) 
	msymbol(diamond none none) mcolor(black gray gray) lpattern(solid dash dash) lcolor(black black black) lwidth(thick medthick medthick)
	xline(1965, lcolor(gray) lpattern(shortdash)) xline(1970, lcolor(gray) lpattern(shortdash))  
	title("A. Natural Log of White Public Enrollment", ring(1) position(12) margin(small) size(large))
	ytitle("Log Points", size(large)) yscale(range())
	xtitle("")  
	xlabel(1955 1960 1965 1970 1975)
	legend(off)  saving(fracbl_lnenrwh.gph, replace);	
	*graph export fracbl1961_lnenrwh.wmf, replace;

use ${DTA}\statsby\fracbl_coefffracprivwh;
graph twoway connected _b_fracbl upper lower year, 
	scheme(s1mono) 
	msymbol(diamond none none) mcolor(black gray gray) lpattern(solid dash dash) lcolor(black black black) lwidth(thick medthick medthick)
	xline(1965, lcolor(gray) lpattern(shortdash)) xline(1970, lcolor(gray) lpattern(shortdash))  
	title("B. Share of White Enrollment in Private Schools", ring(1) position(12) margin(small) size(large))
	ytitle("Percentage Points", size(large)) yscale(range())
	xtitle("")  
	xlabel(1955 1960 1965 1970 1975)
	legend(off) saving(fracbl_fracprivwh.gph, replace);	
	*graph export fracbl1961_fracprivwh.wmf, replace;

*combine graphs;
graph combine fracbl_lnenrwh.gph fracbl_fracprivwh.gph, 
	scheme(s1mono) 
	xsize(3.5) ysize(1.25)	
	altshrink;
graph export Figure6trends_enrollment.wmf, replace;

*Revenue Variables;
cap program drop revgr;
program define revgr;
	local var "`1'";
	local title "`2'";
	local ytitle "`3'";

use ${DTA}\statsby\fracbl_coeff`var';
graph twoway connected _b_fracbl upper lower year, 
	scheme(s1mono) 
	msymbol(diamond none none) mcolor(black gray gray) lpattern(solid dash dash) lcolor(black black black) lwidth(thick medthick medthick)
	xline(1965, lcolor(gray) lpattern(shortdash)) xline(1970, lcolor(gray) lpattern(shortdash))  
	title("`title'", ring(1) position(12) margin(small) size(large))
	ylabel(-1 0 1 2 3,angle(horizontal)) ytitle("`ytitle'", size(large)) yscale(range(-1,3))
	xtitle("")  
	xlabel(1955 1960 1965 1970 1975)
	legend(off)  saving(fracbl_`var'.gph, replace);	
	*graph export fracbl1961_`var'.wmf, replace;
end;

revgr "pprevtot" "A. Total Revenue Per Pupil" "Thousands of Dollars (2007$)";
revgr "pprevst_psf" "B. State Formula Aid Per Pupil" "Thousands of Dollars (2007$)";
revgr "pprevloc" "C. Local Revenue Per Pupil" "Thousands of Dollars (2007$)";
revgr "pprevfed_esea" "D. Federal ESEA Revenue Per Pupil" "Thousands of Dollars (2007$)";

graph combine fracbl_pprevtot.gph fracbl_pprevst_psf.gph fracbl_pprevloc.gph fracbl_pprevfed_esea.gph, 
	scheme(s1mono) 
	xsize(3.45) ysize(2.2)
	altshrink;
graph export Figure7trends_revenue.wmf, replace;

*Educational inputs variables;
*ppexpcurr;
clear;
use ${DTA}\statsby\fracbl_coeffppexpcurr;
graph twoway connected _b_fracbl upper lower year, 
	scheme(s1mono) 
	msymbol(diamond none none) mcolor(black gray gray) lpattern(solid dash dash) lcolor(black black black) lwidth(thick medthick medthick)
	xline(1965, lcolor(gray) lpattern(shortdash)) xline(1970, lcolor(gray) lpattern(shortdash))  
	title("A. Current Expenditure Per Pupil", ring(1) position(12) margin(small) size(large))
	ylabel(,angle(horizontal)) ytitle("Thousands of Dollars (2007$)", size(large)) yscale(range())
	xtitle("")  
	xlabel(1955 1960 1965 1970 1975)
	legend(off)  saving(fracbl_ppexpcurr.gph, replace);	
	*graph export fracbl1961_ppexpcurr.wmf, replace;

use ${DTA}\statsby\fracbl_coeffstrat;
graph twoway connected _b_fracbl upper lower year, 
	scheme(s1mono) 
	msymbol(diamond none none) mcolor(black gray gray) lpattern(solid dash dash) lcolor(black black black) lwidth(thick medthick medthick)
	xline(1965, lcolor(gray) lpattern(shortdash)) xline(1970, lcolor(gray) lpattern(shortdash))  
	title("B. Student-Teacher Ratio", ring(1) position(12) margin(small) size(large))
	ylabel(,angle(horizontal)) ytitle("Student per Teacher", size(large)) yscale(range())
	xtitle("")  
	xlabel(1955 1960 1965 1970 1975)
	legend(off) saving(fracbl_strat.gph, replace);	
	*graph export fracbl1961_strat.wmf, replace;

*combine graphs;
graph combine fracbl_ppexpcurr.gph fracbl_strat.gph, 
	scheme(s1mono) 
	xsize(3.5) ysize(1.25)	
	altshrink;
graph export Figure8trends_inputs.wmf, replace;

*capture log close
