
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
* Do-File: map.do
************************************
************************************

*Loading data
use "$datapath\repmap.dta", clear

*FIGURE 1. Spatial variation in repression during Argentina's Dirty War, 1975–81
#delimit ;
spmap victimall using Data\areascoor.dta if victimall!=., id(id)
	clmethod(custom)
	clbreaks(0 0.9 5 25 125 800)
	fcolor(Reds)
	legtitle("Number of victims")
	legorder(hilo) 
	polygon(data(Data\argcoor.dta) osize(*1.15))
	legend(label(2 "0") label(3 "1-5") label(4 "6-25") label(5 "26-125") label(6 "126-726")
	symy(*1.5) symx(*1.5) size(*1.5) position(4) ring(0) bmargin(zero));
#delimit cr
graph export "$figurepath\figure1.pdf", as(pdf) replace

capture graph close

clear
