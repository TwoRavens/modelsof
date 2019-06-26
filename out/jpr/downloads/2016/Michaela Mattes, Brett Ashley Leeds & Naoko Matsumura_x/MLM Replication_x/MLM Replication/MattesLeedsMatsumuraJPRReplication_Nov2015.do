*** This is the replication do-file for "Measuring Change in Source of Leader Support:  The CHISOLS Dataset" by Mattes, Leeds, and Matsumura. (Created on Nov. 3, 2015) 
*** The complete and most recent version of the CHISOLS data is available at www.chisols.org. 
clear
set more off

*** BASIC DESCRIPTIVES FOR CHISOLS STATE-YEAR DATA (Section 3 of the article)
use "MattesLeedsMatsumuraJPR1.dta",replace  
drop if  _m==1 /* This data set was created from merging CHISOLS and DPI2012. For basic descriptives, we keep observations in CHISOLS only*/

** Number of nonconsolidated regimes
tab noncon 

** Number of observations
sum ccode  

** Number of countries
by ccode, sort: gen num=_n==1 
count if num==1 

** Number of regime types
tab dem 

** Number of leader transitions
tab leadertrans 

** Number of SOLS changes
* NOTE: We treat minor SOLS changes in nondemocracies as SOLS changes.
* In doing so, we don't count the following three (four) nondemocratic minor SOLS changes.
* Belgium(211) in 1939: two minor SOLS changes are in nondemocratic period but there is also a major SOLS change. 
* Sudan(625) in 1989: minor SOLS change is in nondemocratic period but there is also a major SOLS change. 
* Fiji(950) in 2006: minor SOLS change is in nondemocratic period but there is also a major SOLS change. 
* We generate a new variable that codes nondemocratic minor SOLS changes that can be added to existing SOLS changes
gen solsminnondem=0
replace solsminnondem=1 if solsminchange==1 & dem==0
replace solsminnondem=0 if ccode==211 & year==1939
replace solsminnondem=0 if ccode==625 & year==1989
replace solsminnondem=0 if ccode==950 & year==2006
replace solschange= solschange + solsminnondem 
replace solschdum=1 if solsminnondem==1
tab solschdum if leadertrans==1

** Maximum mumber of leader transitions in a year
sum leadertransnum

** Maximum number of SOLS changes in a year
sum solschange

** Average number of leader transitions per year 
by ccode: egen leadertranstotalN= total(leadertransnum)
by ccode: egen yearstotal= count(year)
gen ldrtransavgN=leadertranstotalN/yearstotal
egen maxldrtransavgN= max(ldrtransavgN)
tab ccode if maxldrtransavgN==ldrtransavgN /* Swizerland(225) and Bosnia-Herzegovia(346) */
egen minldrtransavgN= min(ldrtransavgN)
tab ccode if minldrtransavgN==ldrtransavgN /* e.g., Oman(698) and Uzbekistan(704) */

** Average number of SOLS changes per year 
by ccode: egen solschtotalN=total(solschange)
gen solschavgN= solschtotalN/yearstotal
egen maxsolschavgN= max(solschavgN)
tab ccode if maxsolschavgN==solschavgN  /* France(220) */
sum maxsolschavgN if ccode==220
egen minsolschavgN= min(solschavgN) if ldrtransavg!=0
tab ccode if minsolschavgN==solschavgN  /* e.g., Bhutan(760) and Tanzania(510) */
	   
** Leader change and SOLS change by regime type
tab leadertrans if dem==1 
tab solschdum if dem==1 & leadertrans==1 
tab leadertrans if dem==0 
tab solschdum if dem==0 & leadertrans==1 

** Relationship between SOLS change and regime transitions (i.e., dem to nondem and vice versa) in all state-years
tab solschdum if regtrans==1 
tab solschdum if regtrans==1 & leadertrans==1
tab regtrans if solschdum==1 

** TABLE I: Overlap of SOLS changes and regime transitions in CHISOLS state-year data
** Differentiate SOLS change, leader transition, and no leader transition years
gen othleadtrans=leadertrans /* This is a dummy variable capturing a leader transition that is not accompanied by a SOLS change */
replace othleadtrans=0 if solschdum==1

gen leadtranstype=0
replace leadtranstype=1 if othleadtrans==1
replace leadtranstype=2 if solschdum==1
tab leadtranstype if regtrans==1   
tab leadtranstype if regtrans==0   
tab regtrans leadtranstype , col row chi2 V


*** BASIC DESCRIPTIVES FOR CHISOLS LEADER-LEVEL DATA (Section 3 the article)
use "MattesLeedsMatsumuraJPR2.dta",clear  

** Number of unique spells
sum ccode 

** Number of unique spells that CHISOLS has information on
sum ccode if year~=.

** Number of SOLS changes (NOTE: we treat minor SOLS changes in nondemocracies as SOLS changes)
replace solschange=1 if solsminchinit==1 & dem==0
replace solsminchinit=0 if dem==0
tab solschange 
tab solsminchinit if dem==1 

** Number of minor SOLS changes during leader tenures
gen solsminchdurdum=0
replace solsminchdurdum=1 if solsminchdur!=0
tab solsminchdurdum 
sum solsminchdur 

** Number of interim leaders
tab interim 
tab regtrans if interim==1 

** Number of leader transitions where we used the pre-designated successor rule
tab predes 
tab solschange if predes==1 


*** CHISOLS VS. ARCHIGOS COMPARISON (Section 5 of manuscript)
** Contrast irregular entry and SOLS change (NOTE: we consider foreign imposition as irregular entry)
gen entry2=entry
recode entry2 (2=1)
tab solschange if entry2==1   
tab entry2 solschange if dem==1, col 
tab entry2 solschange if dem==0, col 

** TABLE II: Comparison of Archigos and CHISOLS, 1919-2004
** Contrast irregular entry and solschange 
tab entry2 solschange, row  chi2 V 
** Contrast irregular entry and solschange by regime type
tab entry2 solschange if dem==1, row  chi2 V 
tab entry2 solschange if dem==0, row  chi2 V 


*** CHISOLS VS. DPI COMPARISON (Section 5 the article)
* Since DPI2012 does not include leader names and dates of entry, we conduct this comparison based on the following assumptions:  
* First, we assume that DPI2012 and CHISOLS code the same leader(s) and entry date(s) in a given year as long as both data sets agree on the role of the chief executive (e.g., President).  
* Second, we assume that the entry of a new executive corresponds to the start of a new executive party orientation. 
* Third, if there are two or more leaders in a given year, we assume DPI2012 codes the party orientation of the first leader unless there is a January leader transition, in which case we assume DPI codes the party orientation of the leader who comes to power in January.  
* Fourth, if DPI2012 does not code a left-right party orientation or the observation is missing, we code 'no information'.
use "MattesLeedsMatsumuraJPR1.dta",replace  /* open state-year data */

* NOTE: We treat minor SOLS changes in nondemocracies as major SOLS changes (see above)
gen solsminnondem=0
replace solsminnondem=1 if solsminchange==1 & dem==0
replace solsminnondem=0 if ccode==211 & year==1939
replace solsminnondem=0 if ccode==625 & year==1989
replace solsminnondem=0 if ccode==950 & year==2006
replace solschange= solschange + solsminnondem 
replace solschdum=1 if solsminnondem==1

* The following commands change the data to make CHISOLS comparable to DPI2012.
* For leader/SOLS changes that occured in January, we use leader/SOLS changes in the previous year. 
* This is because DPI codes the executive ideology of a leader who came to power in Jan. (not a leader who left power in Jan.).  
* For example, DPI codes "right" for G.W. Bush in 1992 and "left" for Clinton in 1993. G.W. Bush was in power until Jan. 21, 1993. 
* Accordingly, this shift is coded in 1992. However, CHISOLS codes the SOLS change and lists the leader as "Bush G., Clinton" in 1993.
sort ccode year   
replace solschmo1=1 if solschmo1==. & solschmo2==1 /* fix if the 2nd (3rd ...) leader transtion is a SOLS change and occurs in Jan. */   
bysort ccode: replace solschdum = 1 if solschmo1[_n+1]==1 & solschange~=.
bysort ccode: replace solschdum = 0 if solschmo1==1 & solschange~=.
bysort ccode: replace solschdum = 1 if solsminchmo1[_n+1]==1 & solsminchange~=. & dem==0
bysort ccode: replace solschdum = 0 if solsminchmo1==1 & solsminchange~=. & dem==0       

replace solschdum = 1 if ccode==370 & year==1994 /* deal with cases that have both a January SOLS change and a non-January SOLS change in a given year. */ 
replace solschdum = 1 if ccode==372 & year==1992 
                                  					 
** Cases in which DPI has no info or is missing in L-R shift (NOTE: we drop obs in 2008 since CHISOLS doesn't have leader/sols change that occurs Jan. in 2009.(p.14) 
tab execrlc2 if year<=2008 & year>=1975
dis (547+2127)/6052 
tab execrlc2 dem if year<=2008 & year>=1975
dis (45+1654)/((45+1654) + (56+360)) 		   

** Cases in which DPI has no info or is missing in L-R shift and CHISOLS codes SOLS change
tab econ_shift dem  if solschdum==1 & _m==3 & (year<2008 & year>=1975)  
dis 63/101 
			   
** Association between SOLS change and DPI's economic ideology shift for cases in which DPI has L-R info 
tab econ_shift solschdum  if _m==3 & (year<2008 & year>=1975) & (econ_shift==0|econ_shift==1), row colum chi2 V 

**Association between SOLS change and DPI's non-economic ideology shift
gen othershifts = 0 
replace othershifts = 1 if nat_shift==1
replace othershifts = 1 if rural_shift==1
replace othershifts = 1 if reg_shift==1
replace othershifts = 1 if rel_shift==1  
tab othershifts if econ_shift==0 & solschdum==1 & _m==3 & (year<2008 & year>=1975)  
			
*** TABLE III: Comparison of DPI and CHISOLS, 1975-2007
** Association between SOLS change and DPI's economic ideology shift  
tab econ_shift solschdum if _m==3 & (year<2008 & year>=1975) , row 
 
