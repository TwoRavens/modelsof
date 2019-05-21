* Minister Turnover, Critical Events, and the Electoral Calendar in Presidential Democracies
* Marcelo Camerlo and Anibal Perez-Linan
* Journal of Politics
* January 15, 2015

use "MT_Dataset"

******* TABLE 1 *******

**** MODEL I 
stset exit if  portfolio>1,  origin(begin) failure (dest==2) id (idmin) 
xi: stcox  protests scandals calendar reelegible minority coalition egrowth inflation i.port_area1 first_minister cum_exits polity2, /*schoenfeld(sch*) scaledsch(sca*)*/ shared (country)
estimates store mI
*PHTEST
estat phtest, detail

**** MODEL II
stset exit if  portfolio>1,  origin(begin) failure (dest==2) id (idmin) 
xi: stcox  protests scandals calendar reelegible  protests_calendar scandals_calendar calendar_reelegible protests_reelegible scandals_reelegible protests_calendar_reel scandals_calendar_reel minority coalition egrowth inflation i.port_area1 first_minister cum_exits polity2,  /*schoenfeld(sch*) scaledsch(sca*)*/  shared (country)
estimates store mII
*PHTEST
estat phtest, detail

****** MODEL III
stset exit if  portfolio>1 & reelegible ==1,  origin(begin) failure (dest==2) id (idmin) 
xi: stcox  protests scandals calendar protests_calendar scandals_calendar minority coalition egrowth inflation i.port_area1 first_minister cum_exits polity2, /* schoenfeld(sch*) scaledsch(sca*) */ shared (country)
estimates store mIII 
*/ *PHTEST */ 
estat phtest, detail

/* TABLE 2, RE-ELIGIBLE */ 
lincom protests+protests_calendar*1 , hr
lincom protests+protests_calendar*.36, hr         
lincom protests+protests_calendar*0, hr          

lincom scandals+scandals_calendar*1, hr
lincom scandals+scandals_calendar*.51, hr
lincom scandals+scandals_calendar*0, hr

***
* Figure 2.1: Protests, marginal effects for calendar
grinter protests, inter(protests_calendar) const02(calendar) clevel (95) yline(0) nom xscale(reverse)
graph save Graph "Graph21.gph", replace
* Figure 2.2: Scandals, marginal effects for calendar
grinter scandals, inter(scandals_calendar) const02(calendar) clevel (95) yline(0) nom xscale(reverse)
graph save Graph "Graph22.gph", replace

****** MODEL IV
stset exit if  portfolio>1 & reelegible ==0,  origin(begin) failure (dest==2) id (idmin) 
xi: stcox  protests scandals calendar protests_calendar scandals_calendar minority coalition egrowth inflation i.port_area1 first_minister cum_exits polity2, /* schoenfeld(sch*) scaledsch(sca*) */ shared (country)
estimates store mIV

/* PHTEST */
estat phtest, detail

/* TABLE 2, NON RE-ELIGIBLE */ 
lincom protests+protests_calendar*1, hr
lincom protests+protests_calendar*.68, hr
lincom protests+protests_calendar*.0, hr

lincom scandals+scandals_calendar*1, hr
lincom scandals+scandals_calendar*.75, hr
lincom scandals+scandals_calendar*0, hr

***
*Figure 2.3: Protests, marginal effects for calendar
grinter protests, inter(protests_calendar) const02(calendar) clevel (95) yline(0) nom xscale(reverse)
graph save Graph "Graph23.gph", replace
* Figure 2.4: Scandals, marginal effects for calendar
grinter scandals, inter(scandals_calendar) const02(calendar) clevel (95) yline(0) nom xscale(reverse)
graph save Graph "Graph24.gph", replace

xml_tab mI mII mIII mIV, save("Table2.xls") hr ///
        stats(N) sheet("Table21") stars(* 0.05 ** 0.01) format((S2100) (N2202)) replace   


*******************************************************************************************
********************************  ON-LINE APPENDIX ****************************************
*******************************************************************************************

***** TABLE A1. DESCRIPTIVE STATISTICS ******
* Protests
sum ( protests ) if portfolio !=1 & reelegible==1
sum ( protests ) if portfolio !=1 & reelegible==0
sum ( protests ) if portfolio !=1
* Scandals
sum ( scandals ) if portfolio !=1 & reelegible==1
sum ( scandals ) if portfolio !=1 & reelegible==0
sum ( scandals ) if portfolio !=1
* Calendar
sum ( calendar ) if portfolio !=1 & reelegible==1
sum ( calendar ) if portfolio !=1 & reelegible==0
sum ( calendar ) if portfolio !=1
* Minority
sum ( minority ) if portfolio !=1 & reelegible==1
sum ( minority ) if portfolio !=1 & reelegible==0
sum ( minority ) if portfolio !=1
* Coalition
sum ( coalition ) if portfolio !=1 & reelegible==1
sum ( coalition ) if portfolio !=1 & reelegible==0
sum ( coalition ) if portfolio !=1
* Growth
sum ( egrowth ) if portfolio !=1 & reelegible==1
sum ( egrowth ) if portfolio !=1 & reelegible==0
sum ( egrowth ) if portfolio !=1
* Inflation
sum ( inflation ) if portfolio !=1 & reelegible==1
sum ( inflation ) if portfolio !=1 & reelegible==0
sum ( inflation ) if portfolio !=1
* Portfolio Areas
tab port_area1 if portfolio !=1 & reelegible==1
tab port_area1 if portfolio !=1 & reelegible==0
tab port_area1 if portfolio !=1
* First Minister
sum ( first_minister ) if portfolio !=1 & reelegible==1
sum ( first_minister ) if portfolio !=1 & reelegible==0
sum ( first_minister ) if portfolio !=1
* Cumulative Exits
sum ( cum_exits ) if portfolio !=1 & reelegible==1
sum ( cum_exits ) if portfolio !=1 & reelegible==0
sum ( cum_exits ) if portfolio !=1
* Polity
sum ( polity2 ) if portfolio !=1 & reelegible==1
sum ( polity2 ) if portfolio !=1 & reelegible==0
sum ( polity2 ) if portfolio !=1
* Strikes
sum ( strikes ) if portfolio !=1 & reelegible==1
sum ( strikes ) if portfolio !=1 & reelegible==0
sum ( strikes ) if portfolio !=1
* Free Speech
sum ( SPEECH ) if portfolio !=1 & reelegible==1
sum ( SPEECH ) if portfolio !=1 & reelegible==0
sum ( SPEECH ) if portfolio !=1

***** TABLE A2. 2SRI MODEL FOR REELIGIBLE PRESIDENTS ******

* Protests (REELIGIBLE)
xi:logit protests calendar minority coalition egrowth inflation i.port_area1 first_minister cum_exits polity2 strikes if portfolio>1 & reelegible ==1, or
estimates store s1PmIIIcf
predict cf_pr, res

* Scandals (REELIGIBLE)
xi:logit scandals calendar minority coalition egrowth inflation i.port_area1 first_minister cum_exits polity2 SPEECH  if portfolio>1 & reelegible ==1, or
estimates store s1SmIIIcf
predict cf_sr, res

**** III-1 (MODEL III with Control Functions)
stset exit if  portfolio>1 & reelegible ==1,  origin(begin) failure (dest==2) id (idmin) 
xi: stcox  protests scandals calendar protests_calendar scandals_calendar minority coalition egrowth inflation i.port_area1 first_minister cum_exits polity2 cf_pr cf_sr, shared (country)
estimates store mIIIcf

/* TABLE A4, Left Panel */ 
lincom protests+protests_calendar*1, hr
lincom protests+protests_calendar*.34, hr       
lincom protests+protests_calendar*.0, hr
lincom scandals+scandals_calendar*1, hr
lincom scandals+scandals_calendar*0, hr

* Figure A1: Protests, marginal effects for calendar
grinter protests, inter(protests_calendar) const02(calendar) clevel (95) yline(0) nom xscale(reverse)
graph save Graph "GraphA1-1.gph", replace
* Figure A1: Scandals, marginal effects for calendar
grinter scandals, inter(scandals_calendar) const02(calendar) clevel (95) yline(0) nom xscale(reverse)
graph save Graph "GraphA1-2.gph", replace

xml_tab s1PmIIIcf s1SmIIIcf mIIIcf, save("Appendix.xls") hr ///
        stats(N) sheet("Table A2") stars(* 0.05 ** 0.01) format((S2100) (N2202)) replace ///
		keep(protests scandals calendar protests_calendar scandals_calendar minority coalition egrowth inflation 1.port_area1 2.port_area1 _Iport_area_1 _Iport_area_2 first_minister cum_exits polity2 ///
		     strikes SPEECH cf_pr cf_sr)

			 
***** TABLE A3. 2SRI MODEL FOR NON-REELIGIBLE PRESIDENTS ******

* Protests (NON-REELIGIBLE)
xi:logit protests calendar minority coalition egrowth inflation i.port_area1 first_minister cum_exits polity2 strikes if portfolio>1 & reelegible ==0, or
estimates store s1PmIVcf
predict cf_pn, res
* Scandals (NON-REELIGIBLE)
xi:logit scandals calendar minority coalition egrowth inflation i.port_area1 first_minister cum_exits polity2 SPEECH if portfolio>1 & reelegible ==0, or
estimates store s1SmIVcf
predict cf_sn, res

**** IV-1 (MODEL IV with Control Functions)
stset exit if  portfolio>1 & reelegible ==0,  origin(begin) failure (dest==2) id (idmin) 
xi: stcox  protests scandals calendar protests_calendar scandals_calendar minority coalition egrowth inflation i.port_area1 first_minister cum_exits polity2 cf_pn cf_sn, shared (country)
estimates store mIVcf


/* TABLE A4, Right Panel */ 
lincom protests+protests_calendar*1, hr
lincom protests+protests_calendar*.0, hr
lincom scandals+scandals_calendar*1, hr
lincom scandals+scandals_calendar*.86, hr		
lincom scandals+scandals_calendar*0, hr

*Figure A1: Protests, marginal effects for calendar
grinter protests, inter(protests_calendar) const02(calendar) clevel (95) yline(0) nom xscale(reverse)
graph save Graph "GraphA1-3.gph", replace
*Figure A1: Scandals, marginal effects for calendar
grinter scandals, inter(scandals_calendar) const02(calendar) clevel (95) yline(0) nom xscale(reverse)
graph save Graph "GraphA1-4.gph", replace

xml_tab s1PmIVcf s1SmIVcf mIVcf, save("Appendix.xls") hr ///
        stats(N) sheet("Table A3") stars(* 0.05 ** 0.01) format((S2100) (N2202)) append ///
		keep(protests scandals calendar protests_calendar scandals_calendar minority coalition egrowth inflation 1.port_area1 2.port_area1 _Iport_area_1 _Iport_area_2 first_minister cum_exits polity2 ///
		     strikes SPEECH cf_pn cf_sn)  

 
		
