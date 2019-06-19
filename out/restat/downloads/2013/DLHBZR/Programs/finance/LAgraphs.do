clear

set more 1
set mem 20m
set matsize 800

*Figures 1, 4, and 5
use ${DTA}\LAdata_finance

*don't have data on segregation for 1965 and 1975
foreach var in expbl_wh expwh_bl perblanywh {
	replace `var'=. if year==1965|year==1975
	}

gen anydeseg=(perblanywh>0)
replace anydeseg=. if perblanywh==.

tempfile temp
save `temp'

cap mkdir ${DTA}\statsby

foreach var in anydeseg expbl_wh expwh_bl pprevtot pprevst_psf pprevloc pprevfed_esea pprevnl_oth enrwh np_enrwh enrbl np_enrbl {
	clear
	use `temp'
	statsby, by(year) clear: sum `var'
	rename mean `var'
	keep year `var'
	sort year
	save ${DTA}\statsby\figs_`var', replace
	}

foreach var in anydeseg expbl_wh expwh_bl pprevtot pprevst_psf pprevloc pprevfed_esea pprevnl_oth enrwh np_enrwh enrbl np_enrbl {
	merge year using ${DTA}\statsby\figs_`var'
	drop _merge
	sort year
	}

*enrollment variables -- want total for figure 4
foreach var in enrwh np_enrwh enrbl np_enrbl {
	replace `var'=`var'*63/1000
	}

drop if year<1960

foreach var in anydeseg expbl_wh expwh_bl {
	replace `var'=0 if year==1960
	}

save ${DTA}/LAtrends_figs, replace
cap log close
log using ${LOG}/fin_graph_regs.log, text replace

#delimit ;

cd ${GRAPHS};

graph twoway connected anydeseg expbl_wh expwh_bl year if year <=1976&year>=1960, 
	scheme(s1mono) 
	xline(1965, lcolor(gray) lp(shortdash) lw(vthin)) 
	xline(1968, lcolor(gray) lp(shortdash) lw(vthin))  
	text(0.85 1964.8 "CRA/ESEA", place(w) orient(vertical) size(medium))
	text(0.5 1967.8 "Major C.O. Desegregation Begins", place(w) orient(vertical) size(medium))
	text(0.95 1973 "Share of Districts with", place(c) size(medium)) ///
	text(0.90 1973 "Any Desegregation", place(c) size(medium)) ///
	text(0.27 1973 "Black Exposure to Whites", place(c) size(medium)) ///
	text(0.52 1973 "White Exposure to Blacks", place(c) size(medium)) ///
	xline(1965, lcolor(gray) lpattern(shortdash)) 
	ylabel(,angle(horizontal)) ytitle("Fraction") yscale(range(0 1))
	xtitle("")  
	xsize(3.45) ysize(2.2)
	xlabel(1960 1965 1968 1970 1975)
	
	saving(LAsegtrends, replace) legend(off)   ;
	
graph export Figure1.wmf, replace;

graph twoway connected enrwh np_enrwh enrbl np_enrbl year if year <=1975&year>=1960, 
	scheme(s1mono) 
	xline(1965, lcolor(gray) lp(shortdash) lw(vthin)) 
	xline(1970, lcolor(gray) lp(shortdash) lw(vthin))  
	text(570 1967.5 "White Public", place(c) size(medium)) ///
	text(160 1967.5 "White Non-Public", place(c) size(medium)) ///
	text(370 1967.5 "Black Public", place(c) size(medium)) ///
	text(50 1967.5 "Black Non-Public", place(c) size(medium)) ///
	ylabel(,angle(horizontal)) ytitle("Thousands of Students") yscale(range(0 1))
	xtitle("")  
	xsize(3.45) ysize(2.2)
	xlabel(1960 1965 1970 1975)
	
	legend(off)   ;
	
graph export Figure4.wmf, replace;

graph twoway connected pprevtot pprevloc pprevst_psf pprevfed_esea pprevnl_oth year if year <=1975&year>=1960, 
	scheme(s1mono) 
	xline(1965, lcolor(gray) lp(shortdash) lw(vthin)) 
	xline(1970, lcolor(gray) lp(shortdash) lw(vthin))  
	text(4.5 1973 "Total", place(c) size(medium)) ///
	text(2.7 1973 "State Formula Aid", place(c) size(medium)) ///
	text(0.1 1973 "Federal ESEA", place(c) size(medium)) ///
	text(1.2 1967 "Local", place(c) size(medium)) ///
	text(0.65 1973.5 "Other Non-Local", place(c) size(medium)) ///
	ylabel(,angle(horizontal)) ytitle("Thousands of Dollars per Pupil (2007$)") yscale(range(0 1))
	xtitle("")  
	xsize(3.45) ysize(2.2)
	xlabel(1960 1965 1970 1975)
	
	legend(off)   ;
	
graph export Figure5.wmf, replace;


#delimit cr

*fig 2 change in wh exposure to blacks vs perblack 1961, change in dis vs perblack 1961;
clear
use ${DTA}\LAdata_finance

*generate change in white exposure from 1964 to 1970
gen x=expwh_bl if year==1970
gen y=expwh_bl if year==1964
egen x1=max(x), by(fipscnty)
egen y1=max(y), by(fipscnty)
gen chexpwhbl=x1-y1
drop x y x1 y1

#delimit ;

graph twoway scatter chexpwhbl fracbl if year==1961 
	||lfit fracbl fracbl if year==1961,
	scheme(s1mono) 
	range(0 .8)
	ylabel(0 .2 .4 .6 .8,angle(horizontal)) ytitle("Change in White Exposure to Blacks, 1964-1970") yscale(range())
	legend(off)
	xtitle("Black Share of Enrollment, 1961") xlabel(0 .2 .4 .6 .8)
	xsize(3.45) ysize(2.2);

	graph export Figure2.wmf, replace;

*student-teacher ratio graphs;
clear;
use ${DTA}\LAdata_finance;

reg stratwh fracbl if year==1961, robust;
local coeff=round(_b[fracbl],.01);
local se=round(_se[fracbl],.01);

*figure 3A;
graph twoway scatter stratwh fracbl if year==1961, 
	||lfit stratwh fracbl if year==1961, 
	scheme(s1mono) 
	title("A. White Student-Teacher Ratio", ring(1) position(12) margin(small) size(large))
	ylabel(15 20 25 30 35,angle(horizontal)) ytitle("Students per Teacher", size(large)) yscale(range(15 35)) 
	xtitle("Black Share of Enrollment", size(large))
	text(18 .1 "Coeff = `coeff'", orient(horizontal) size(large))
	text(16.5 .1 "S.E. = `se'", orient(horizontal) size(large))
	legend(off)
 saving(fig3a, replace) ;

reg stratbl fracbl if year==1961, robust;
local coeff=round(_b[fracbl],.01);
local se=round(_se[fracbl],.01);

*figure 3B;
graph twoway scatter stratbl fracbl if year==1961, 
	||lfit stratbl fracbl if year==1961, 
	scheme(s1mono) 
	title("B. Black Student-Teacher Ratio", ring(1) position(12) margin(small) size(large))
	ylabel(20 25 30 35 40,angle(horizontal)) ytitle("Students per Teacher", size(large)) yscale(range(20 40)) 
	xtitle("Black Share of Enrollment", size(large))
	text(23 .1 "Coeff = `coeff'", orient(horizontal) size(large))
	text(21.5 .1 "S.E. = `se'", orient(horizontal) size(large))
	legend(off)
 saving(fig3b, replace) ;

reg stratgapwhavg fracbl if year==1961, robust;
local coeff=round(_b[fracbl],.01);
* stata is giving a weird number -8.88000000001, so hard code below; 
local coeff=-8.88;
local se=round(_se[fracbl],.01);

*figure 3c;
graph twoway scatter stratgapwhavg fracbl if year==1961, 
	||lfit stratgapwhavg fracbl if year==1961, 
	scheme(s1mono) 
	title("C. Average Student Teacher Ratio - White Student Teacher Ratio", ring(1) position(12) margin(small) size(large))
	ylabel(-10 -5 0 5,angle(horizontal)) ytitle("Students per Teacher", size(large)) yscale(range(-10 5)) 
	xtitle("Black Share of Enrollment", size(large))
	text(-7.7 .1 "Coeff = -8.88", orient(horizontal) size(large))
	text(-8.9 .1 "S.E. = `se'", orient(horizontal) size(large))
legend(off)
 saving(fig3c, replace) ;

graph combine fig3a.gph fig3b.gph fig3c.gph, 
	scheme(s1mono) 
	xsize(3.45) ysize(2.2)
	altshrink;
graph export Figure3.wmf, replace;



