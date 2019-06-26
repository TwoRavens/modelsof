
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
* Do-File: figures.do
************************************
************************************

*Loading data
use "$datapath\repdata.dta", clear

*FIGURE 3. Distribution of area officers across army branches
#delimit ;
hist armybranch, freq discrete 
	 start(1) barwidth(0.4) 
	 color(black)
	 yscale(noline)
	 xscale(range(1 5.5) noline)
	 xlabel(1 "Infantry" 2 "Artillery" 3 "Cavalry" 4 "Engineering" 5 "Communications", labsize(small))
	 xtick(1(1)5)
	 xtitle("")
	 ylabel(0(20)100, labsize(small) angle(0) glcolor(gs10) glpattern(shortdash) glwidth(0.2) nogmin)
	 ytitle("Number of officers", size(small))
	 plotregion(lcolor(black))
	 graphregion(color(white));
#delimit cr
graph export "$figurepath\figure3.pdf", as(pdf) replace


*FIGURE 4. Relationship between officer age and time till first area command
#delimit ;
twoway (rspike waittime pred age, lcolor(gs8))
	   (scatter waittime age, msize(*.75) mcolor(white) mlcolor(black) mlalign(outside)) 
	   (lfit waittime age, lcolor(black) lwidth(0.5)),
	   yscale(noline)
	   xscale(noline)
	   ylabel(150(50)400, labsize(small) angle(0) glcolor(gs10) glpattern(shortdash) glwidth(0.2))
	   xlabel(35(2)55, labsize(small))
	   ytitle("Time between graduation and first area command (in months)", size(small))
	   xtitle("Age of officer (in years)", size(small))
	   plotregion(lcolor(black))
	   graphregion(color(white))
	   legend(order(2 "Officer" 1 "Favoritism") lcolor(white) cols(1) size(small) keygap(*0.5) symxsize(*0.55) position(5) ring(0) bmargin(0) col(1) row(5));
#delimit cr
graph export "$figurepath\figure4.pdf", as(pdf) replace


*Figure 5. Distribution of victim counts
#delimit ;
hist nvictims, freq bin(40)
	 lwidth(thin)
 	 ylabel(0(50)250, labsize(small) angle(0) nogrid)
	 xlabel(0(100)800, labsize(small))
	 yscale(noline)	 	 
	 xscale(noline titlegap(*+5))
	 ytitle("Frequency", size(small))
	 xtitle("Number of victims", size(small))
	 plotregion(lcolor(black))
	 graphregion(color(white))
	 scheme(s2mono);
#delimit cr
graph export "$figurepath\figure5.pdf", as(pdf) replace	
	

*FIGURE 6. Average number of victims by army branch
preserve 
collapse (mean) nvictimsmean=nvictims, by(armybranch)
drop if armybranch==.
gsort -nvictims
gen xaxis=_n
	
#delimit ;
twoway bar nvictimsmean xaxis,
	   barwidth(0.4) 
	   base(0)
	   lcolor(black) fcolor(black) fintensity(100)
	   yscale(noline)	 
	   xscale(range(0.5 5.5) noline)
	   xlabel(1 "Infantry" 2 "Communications" 3 "Artillery" 4 "Cavalry" 5 "Engineering", labsize(small))
	   xtick(1(1)5)
	   xtitle("")
	   ylabel(0(5)35, labsize(small) angle(0) glcolor(gs10) glpattern(shortdash) glwidth(0.2) nogmin)
	   ytitle("Average number of victims", size(small))
	   plotregion(lcolor(black) margin(b=0))
	   graphregion(color(white));
#delimit cr
graph export "$figurepath\figure6.pdf", as(pdf) replace
	
restore
	
capture graph close 
clear
