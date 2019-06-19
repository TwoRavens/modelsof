/*** Albouy (REStat, 2013), Figure 1 ***/

# delimit ;
version 11.2;
cd c:\data\political;

use spend_panel_restat, replace ;

gsort +year;

keep if fipsst==6 & year>=1952;
expand 2 if year==2004;

replace year=2005 if _n==54;

sort year;

g repsen = 1-demsen ;
g demhouse=year<1996;
g rephouse=year>=1996;

la var repsen "Republican Control";
la var demsen "Democratic Control";
la var rephouse "Republican Control";
la var demhouse "Democratic Control";

la var s_sh_m "Majority Share of Seats";
la var s_sh_d "Democrat Share of Seats";
la var h_sh_m "Majority Share of Seats";
la var h_sh_d "Democrat Share of Seats";


g year5 = year+.5 ;
g jump = 0 if year==1983;
replace jump = 1 if year==1984;

g mid =.5;

keep if year>=1970;

twoway (bar demsen repsen year5 if year<2005,
	color(gs14 gs10) 
	ylab(none) 
  )
(line s_sh_m  s_sh_d  mid year , 
	plotregion(margin(zero))
	xmtick(1970(1)2004) 
	xline(1983)
	ylab(0 .25 .5 .75 1, grid) 
	xti("Fiscal Year")
	graphregion(fcolor(white) icolor(white) color(white))
	xlab(1970 1982 1988 1996 2002 2004, grid alternate) 
	connect(stairstep stairstep stairstep stairstep)
/*	legend( order(1 2 3 4)) */
	xsize(6) ysize(2.5) 
	aspect(0.4)
	legend(off) 
	lwidth(medthick medthick) lpat(solid dash dot solid) 
	lcolor(black black black)
	bgcolor(red) 
	ti("Figure 1a: Partisan Control of the Senate", size(3.5)) 
	saving(gr2a, replace) 
	note(" " " ", size(2))
fysize(100)
	)
;

twoway (bar demhouse rephouse year5 if year<2005,
	color(gs14 gs10) 
	ylab(none) 
  )
(line h_sh_m h_sh_d mid year , 
	plotregion(margin(zero))
	xmtick(1970(1)2004) 
	xline(1983)
	ylab(0 .25 .5 .75 1, grid) 
	xti("Fiscal Year")
	graphregion(fcolor(white) icolor(white) color(white))
	xlab(1970 1982 1988 1996 2002 2004, grid alternate) 
	connect(stairstep stairstep stairstep stairstep)
	lcolor(black black black)
	aspect(0.4)
	legend( order(1 2 3 4) span size(2.5)  ) 
	xsize(6) ysize(5.5) 
	lwidth(medthick medthick) lpat(solid dash dot solid) bgcolor(red) 
	ti("Figure 1b: Partisan Control of the House", size(3.5)) 
	saving(gr2b, replace)
	
fysize(114) )
;


graph combine gr2a.gph gr2b.gph, 
graphregion(fcolor(white) icolor(white) color(white))
rows(2) iscale(1)	xsize(6.5) ysize(9) ycommon imargin(small) 
caption("The budget in a fiscal year is determined by the congress in session in the previous year. For example, the"
 		" "  "Congress elected in 1994 was in session in 1995 and 1996, and determined the budget in FY1996 and FY1997.", size(2.1) span);
