
***********************************
***********************************
* REPLICATION
*
* IDEOLOGY AND STATE TERROR
* How officer beliefs shaped repression during Argentina’s ‘Dirty War’
*
* JOURNAL OF PEACE RESEARCH
*
* Author: Adam Scharpf (University of Mannheim)		   
* 	
* Date: Feb 2018		
*
* Do-File: timefigure.do
************************************
************************************

*Loading data
use "$datapath\reptimeline.dta", clear


*FIGURE 2. Temporal dynamics of repression during the Dirty War
	#delimit ;
	twoway (line ndisappearsum monthcount, lcolor(gs6) lpattern(shortdash))
		   (line nexecutsum monthcount, lcolor(gs8) lpattern(shortdash_dot))
		   (line nvictimsum monthcount, lcolor(black)),
		   xline(11,lcolor(gs5) lwidth(thin)) 		//1975m11: National plan
		   xline(15,lcolor(gs5) lwidth(thin))		//1976m3:  Coup
		   xline(37,lcolor(gs5) lwidth(thin))		//1978m1:  End of Plan
		   xline(69,lcolor(gs5) lwidth(thin))		//1980m9:  Viola announced as president		   
		   ttext(420 10.5 "Start of Plan", placement(w) size(vsmall) color(black))
		   ttext(420 15.5 "Coup", placement(e) size(vsmall) color(black)) 
		   ttext(420 37.5 "End of Plan", placement(e) size(vsmall) color(black)) 
		   ttext(420 69.5 "Viola announced", placement(e) size(vsmall) color(black))		
		   ytitle("Number of victims", size(small))
		   xtitle("")
		   ylabel(0(100)400, nogmin glpattern(shortdash) glcolor(gs13) glwidth(0.2) labsize(small) angle(horizontal))
		   yline(0, lcolor(gs13) lwidth(0.2))
		   ytick(0(50)400, tlength(*.5))
		   xlabel(7 "1975" 19 "1976" 31 "1977" 43 "1978" 55 "1979" 67 "1980" 79 "1981" 
		   91 "1982", noticks labsize(small))
		   xtick(1(12)97, tlength(*1.75))
		   yscale(range(0 425) titlegap(*+5) noline)
		   xscale(noline)
		   legend(order(3 "Disapp. + Execut." 1 "Disappearences" 2 "Executions")  position(2) ring(0) bmargin(0) col(1) row(5) 
		   size(vsmall) keygap(*0.5) symxsize(*0.5) symysize(*0.5) region(lcolor(black)))
		   ysize(1) xsize(1.75)
		   plotregion(lcolor(black))
		   graphregion(color(white));
	#delimit cr
	graph export "$figurepath\figure2.pdf", as(pdf) replace

capture graph close
clear	
	