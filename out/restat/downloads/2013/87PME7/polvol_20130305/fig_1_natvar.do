#delimit;
clear; *clear matrix;
drop _all;

set matsize 2000;
cd "$startdir/$outputtables";

use "$startdir/$outputdata\natcohortswconditionsno";

**marker for age 25;
sort C;
by C: egen firstobs=min(year);
expand 2 if year==firstobs;
sort C A year;
duplicates tag C A year, generate(expanded);
by C A year: replace expanded=0 if expanded[_n+1]==1;
gen deltaA=A-1 if expanded==1;
*some cohorts are observed at 25;
drop if deltaA==0 & expanded==1;
replace A=1 if expanded==1;
replace year=year-deltaA*5 if expanded==1;



gen month=1;
gen date=ym(year, month);


******merge in recbymonth;
sort date;
merge date using "$startdir/$outputdata\recbymonth.dta", sort uniqusing;
format date %tm;

sum varloginc if varloginc!=., detail;
local minobs `r(min)';
local maxobs `r(max)';

/* okay, so here's the problem.  I need a bargraph (measured on the RH scale) underneath a line graph (measured on the LH scale).
   STATA assigns scales and overlays in the same way, based on what graph is called up first.  varloginc runs between .32 and .77,
   so I rescale recbymonth to be .8 if it's 1 and .3 if it's 0 (otherwise Stata wants to show me a tiny bar for these obs.)
   Then I force Stata to scale both the LH and RH axes in the same way. This is done by invoking the bar graph first (so it's underneath)
   with options yaxis(1 2).  I do the same with xaxis because I have rec data from 1920 but varloginc data from 1930.
   I force STATA to run both scales from 1920-2005. */

if `minobs'>.3 & `maxobs'<.8{;
      replace recbymonth=.8 if recbymonth==1;
      replace recbymonth=.29 if recbymonth==0;
};
else{;
di "Varloginc outside of bounds";

};
set scheme s2mono;
twoway (bar recbymonth date if year<2006,  xaxis(1 2) yaxis(1 2) bstyle(ci))
	 (connected varloginc date if C==3 , msymbol(x) mcolor(black) lpattern(dot)  yaxis(2) xaxis(2) )
       (connected varloginc date if C==4 , msymbol(x) mcolor(black) lpattern(dot)  yaxis(2) xaxis(2) )
	 (connected varloginc date if C==5 , msymbol(x) mcolor(black) lpattern(dot)  yaxis(2) xaxis(2) )
       (connected varloginc date if C==6, msymbol(x) mcolor(black) lpattern(dot)  yaxis(2) xaxis(2) )
	 (connected varloginc date if C==7 , msymbol(x) mcolor(black) lpattern(dot)  yaxis(2) xaxis(2) )
   	 (connected varloginc date if C==8 , msymbol(x) mcolor(black) lpattern(dot)  yaxis(2) xaxis(2) )
 	 (connected varloginc date if C==9 , msymbol(x) mcolor(black) lpattern(dot)  yaxis(2) xaxis(2) )
       (connected varloginc date if C==10 , msymbol(x) mcolor(black) lpattern(dot)  yaxis(2) xaxis(2) )
       (connected varloginc date if C==11 , msymbol(x) mcolor(black) lpattern(dot)  yaxis(2) xaxis(2) )
       (connected varloginc date if C==12 , msymbol(x) mcolor(black) lpattern(dot)  yaxis(2) xaxis(2) )
       (connected varloginc date if C==13 , msymbol(x) mcolor(black) lpattern(dot)  yaxis(2) xaxis(2) )
       (connected varloginc date if C==14 , msymbol(x) mcolor(black) lpattern(dot)  yaxis(2) xaxis(2) )
       (connected varloginc date if C==15 , msymbol(x) mcolor(black) lpattern(dot)  yaxis(2) xaxis(2) )
       (connected varloginc date if C==16 , msymbol(x) mcolor(black) lpattern(dot)  yaxis(2) xaxis(2) )
       (connected varloginc date if C==17 , msymbol(x) mcolor(black) lpattern(dot)  yaxis(2) xaxis(2) )
       (connected varloginc date if C==18 , msymbol(x) mcolor(black) lpattern(dot)  yaxis(2) xaxis(2) )
       (connected varloginc date if C==19 , msymbol(x) mcolor(black) lpattern(dot)  yaxis(2) xaxis(2) )
       (connected varloginc date if C==20 , msymbol(x) mcolor(black) lpattern(dot)  yaxis(2) xaxis(2) )


	 (connected varloginc date if C==3 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mcolor(black) )
       (connected varloginc date if C==4 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mcolor(black) )
	 (connected varloginc date if C==5 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mcolor(black) )
       (connected varloginc date if C==6& expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mcolor(black) )
	 (connected varloginc date if C==7 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mcolor(black) )
   	 (connected varloginc date if C==8 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mcolor(black) )
 	 (connected varloginc date if C==9 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mcolor(black) )
       (connected varloginc date if C==10 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mcolor(black) )
       (connected varloginc date if C==11 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mcolor(black) )
       (connected varloginc date if C==12 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mcolor(black) )
       (connected varloginc date if C==13 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mcolor(black) )
       (connected varloginc date if C==14 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mcolor(black) )
       (connected varloginc date if C==15 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mcolor(black) )
       (connected varloginc date if C==16 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mcolor(black) )
       (connected varloginc date if C==17 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mcolor(black) )
       (connected varloginc date if C==18 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mcolor(black) )
       (connected varloginc date if C==19 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mcolor(black) )
       (connected varloginc date if C==20 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mcolor(black) )

	
        ,title("U.S. Cohorts Born 1891-1980")
        ytitle("Variance of Log Income", axis(1))
        xtitle("Year", axis(1))
        yscale(range(.3(.1).8) axis(1))
        xlabel(-480 "1920" -360 "1930" -240 "1940" -120 "1950" 0 "1960" 120 "1970" 240 "1980" 360 "1990" 480 "2000", axis(1))

        ytitle("", axis(2))
	  xtitle("", axis(2))
        ylabel(none, axis(2))
	  xlabel(none, axis(2))
        legend(off)
        graphregion(color(white))
       ;
graph export fig1nat_bw.eps, as(eps) preview(off) replace;
!epstopdf fig1nat_bw.eps;
!erase fig1nat_bw.eps;

/*
set scheme s2color;
twoway (bar recbymonth date if year<2006,  xaxis(1 2) yaxis(1 2) bstyle(ci))
	 (connected varloginc date if C==3 , msymbol(x) mstyle(p1) lstyle(p1) lpattern(dot)  yaxis(2) xaxis(2) )
       (connected varloginc date if C==4 , msymbol(x) mstyle(p2) lstyle(p2) lpattern(dot)  yaxis(2) xaxis(2) )
	 (connected varloginc date if C==5 , msymbol(x) mstyle(p3) lstyle(p3) lpattern(dot)  yaxis(2) xaxis(2) )
       (connected varloginc date if C==6, msymbol(x) mstyle(p4) lstyle(p4) lpattern(dot)  yaxis(2) xaxis(2) )
	 (connected varloginc date if C==7 , msymbol(x) mstyle(p5) lstyle(p5) lpattern(dot)  yaxis(2) xaxis(2) )
   	 (connected varloginc date if C==8 , msymbol(x) mstyle(p6) lstyle(p6) lpattern(dot)  yaxis(2) xaxis(2) )
 	 (connected varloginc date if C==9 , msymbol(x) mstyle(p7) lstyle(p7) lpattern(dot)  yaxis(2) xaxis(2) )
       (connected varloginc date if C==10 , msymbol(x) mstyle(p8) lstyle(p8) lpattern(dot)  yaxis(2) xaxis(2) )
       (connected varloginc date if C==11 , msymbol(x) mstyle(p9) lstyle(p9) lpattern(dot)  yaxis(2) xaxis(2) )
       (connected varloginc date if C==12 , msymbol(x) mstyle(p10) lstyle(p10) lpattern(dot)  yaxis(2) xaxis(2) )
       (connected varloginc date if C==13 , msymbol(x) mstyle(p11) lstyle(p11) lpattern(dot)  yaxis(2) xaxis(2) )
       (connected varloginc date if C==14 , msymbol(x) mstyle(p12) lstyle(p12) lpattern(dot)  yaxis(2) xaxis(2) )
       (connected varloginc date if C==15 , msymbol(x) mstyle(p13) lstyle(p13) lpattern(dot)  yaxis(2) xaxis(2) )
       (connected varloginc date if C==16 , msymbol(x) mstyle(p14) lstyle(p14) lpattern(dot)  yaxis(2) xaxis(2) )
       (connected varloginc date if C==17 , msymbol(x) mstyle(p15) lstyle(p15) lpattern(dot)  yaxis(2) xaxis(2) )
       (connected varloginc date if C==18 , msymbol(x) mstyle(p1) lstyle(p1) lpattern(dot)  yaxis(2) xaxis(2) )
       (connected varloginc date if C==19 , msymbol(x) mstyle(p2) lstyle(p2) lpattern(dot)  yaxis(2) xaxis(2) )
       (connected varloginc date if C==20 , msymbol(x) mstyle(p3) lstyle(p3) lpattern(dot)  yaxis(2) xaxis(2) )


	 (connected varloginc date if C==3 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mstyle(p1) lstyle(p1) )
       (connected varloginc date if C==4 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mstyle(p2) lstyle(p2) )
	 (connected varloginc date if C==5 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mstyle(p3) lstyle(p3) )
       (connected varloginc date if C==6& expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mstyle(p4) lstyle(p4) )
	 (connected varloginc date if C==7 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mstyle(p5) lstyle(p5) )
   	 (connected varloginc date if C==8 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mstyle(p6) lstyle(p6) )
 	 (connected varloginc date if C==9 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mstyle(p7) lstyle(p7) )
       (connected varloginc date if C==10 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mstyle(p8) lstyle(p8) )
       (connected varloginc date if C==11 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mstyle(p9) lstyle(p9) )
       (connected varloginc date if C==12 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mstyle(p10) lstyle(p10) )
       (connected varloginc date if C==13 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mstyle(p11) lstyle(p11) )
       (connected varloginc date if C==14 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mstyle(p12) lstyle(p12) )
       (connected varloginc date if C==15 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mstyle(p13) lstyle(p13) )
       (connected varloginc date if C==16 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mstyle(p14) lstyle(p14) )
       (connected varloginc date if C==17 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mstyle(p15) lstyle(p15) )
       (connected varloginc date if C==18 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mstyle(p1) lstyle(p1) )
       (connected varloginc date if C==19 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mstyle(p2) lstyle(p2) )
       (connected varloginc date if C==20 & expanded==0,   yaxis(2) xaxis(2)  msymbol(circle) mstyle(p3) lstyle(p3) )

	
        ,title("Cross-Sectional Variance of Log Income")
        subtitle("U.S. Cohorts Born 1891-1980")
        note("Male household heads aged 25-59 appearing in the Census between 1950 and 2000 or 2005 ACS"
             "were divided into eighteen cohorts based on five-year birthyear bins. In each census year,"
             "the cross-sectional variance of log income is computed (see text for a discussion of zeros"
             "and bottom-coding). The x markers show when the cohort was 25 to 29 years old.  Gray bars"
             "indicate NBER recessions.")
        ytitle("Variance of Log Income", axis(1))
        xtitle("Year", axis(1))
        yscale(range(.3(.1).8) axis(1))
        xlabel(-480 "1920" -360 "1930" -240 "1940" -120 "1950" 0 "1960" 120 "1970" 240 "1980" 360 "1990" 480 "2000", axis(1))

        ytitle("", axis(2))
	  xtitle("", axis(2))
        ylabel(none, axis(2))
	  xlabel(none, axis(2))
        legend(off)

       ;
graph export fig1nat.eps, as(eps) preview(off) replace;
!epstopdf fig1nat.eps;
!erase fig1nat.eps;
