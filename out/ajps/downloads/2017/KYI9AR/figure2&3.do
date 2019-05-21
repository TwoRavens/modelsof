#delimit;
	version 10.1;
	set more off;
	pause on;
	  quietly log;
	  local logon = r(status);
	  if "`logon'" == "on" {; log close; };
	log using figures2&3.log, text replace;


	/*****************************************************************************************************************************************/
	/*     	File Name:	figures2&3.do					                         															 */
	/*     	Date:   	September 14, 2017				                        															 */
	/*      Authors: 	Olga Chyzh and Elena Labzina			                            												 */
	/*      Purpose:	Produce Figures 2 and 3 for "Bankrolling Repression? Modeling Third-Party Influence on Protests and Repression"      */
	/*      Output Files:	fig2.eps, fig3subfig1.eps, fig3subfig2.eps 			               															 */
	/*****************************************************************************************************************************************/
clear;
/*Figure 2*/
/*Vary beta and y, while holding alpha and beta constant at differen values. Express y through*/
/*assuming alpha=.2, r=1.01*/

/*Fix value of y=0.5, r is referred to as x, beta is referred to as y*/
twoway  function y= -.5-x, range(0 1.5) lcolor(black) lpattern(solid) || scatteri -1.82 1.4 "{&beta}*= -y-r", msymbol(i) mlabpos(0) mlabangle(329) 		
		|| pci   -2  .25  -.75 .25, lcolor(black) lpattern(solid) || scatteri -1.1 .28 "r* =(1-y)/2", msymbol(i) mlabpos(0) mlabangle(270) 
		|| pci  -1.35 .85 .28 .85 , lcolor(red) lpattern(dash)  xlabel(0 (.25) 1.75) || scatteri 0 .89 "{&alpha}=(1-r)/(1+y)", msymbol(i) mlabpos(0) mlabangle(270)
					ytitle("Third-Party Reputation, {&beta}") ylabel(-2 (.5) .25) xtitle("Cost of Repression, r")
		    scheme(s1manual) 	leg(off)
		    text( -1.55 .035  "EQ1:", place(se))  text( -1.65 .001  "Removal", place(se))	 
			text( -1.55 .5  "EQ2:", place(se)) text( -1.65 .45  "Deterrence", place(se))	
			text( -.3 1.15 "EQ3:", place(se)) text( -.4 1 "Accommodation", place(se)) 
			text( -.3 .3  "No Pure Strategy", place(se)) text( -.4 .4 "Equilibrium", place(se))   title("{&alpha}=0.15, y=0.5");/*x here is r*/
 graph export fig2.eps, replace;
 
/*Figure 3*/
/*Subfigure 1*/
/*Vary r and y, while holding alpha and beta constant at differen values. Express y through r*/
/*assuming alpha=.2, beta<-r-y*/
twoway function y=1-2*x, range(0 0.5) ytitle("Cost of Removal from Office, y") xtitle("Cost of Repression, r") xlabel(0(.2)1) /*x here is r*/
ylabel(0(.2)1) lcolor(black) lpattern(solid) scheme(s1mono) leg(off) text(.3 .05  "EQ1: Removal", place(se)) 
|| function y=((1-x)/0.2)-1, range(0.6 0.8) lcolor(black) text(.82 .95  "EQ3:" "Accommodation", place(nw)) 
text(.5 .6  "EQ2:" "Deterrence", place(nw))  
|| scatteri .2 0.79  "y=(1-r)/{&alpha}-1", msymbol(i) mlabpos(0) mlabangle(287)
|| scatteri .1 0.48  "y=1-2r", msymbol(i) mlabpos(0) mlabangle(305) title("{&alpha}=0.2, {&beta}<-r-y");
 graph export fig3subfig1.eps, replace;

 /*Subfigure 2*/
/*We will fix the value of alpha=.6*/
twoway function y=((1-x)/0.6)-1,ytitle("Cost of Removal from Office, y") xtitle("Cost of Repression, r") xlabel(0(.2)1) /*x here is r*/
ylabel(0(.2)1) lcolor(black) lpattern(solid) scheme(s1mono) leg(off) range(0 .4) lcolor(black) 
 text(.22 0  "EQ1: Removal", place(se))  text(.5 .65  "EQ3:" "Accommodation", place(nw)) 
 || scatteri .15 0.33  "y=(1-r)/{&alpha}-1", msymbol(i) mlabpos(0) mlabangle(314)
  title("{&alpha}=0.6, {&beta}<-r-y"); 
 
 graph export fig3subfig2.eps, replace; 
 
 log close;

