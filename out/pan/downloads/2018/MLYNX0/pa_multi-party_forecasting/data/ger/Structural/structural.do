*     ***************************************************************** * 
*     ***************************************************************** * 
*       File-Name:      structural.do                                   * 
*       Date:           March 6, 2017                                   * 
*       Author:         Gschwend                                        * 
*       Purpose:      	Check robustnes of strucural model              *
* 	    Input File:     ger_model_df.dta                                * 
*       Data Output:                                                    *              
*     ****************************************************************  * 
*     ****************************************************************  * 



version 14.2
set seed 123345
set more off

use ger_model_df.dta, clear

/*

model_out <- lm(swing ~ major + chancellor_party*unemp + gov*swing_l1*voteshare_l1 + parl + polls_200_230, data = ger_df_long)
model_out <- lm(swing ~ chancellor_party*election + gov*voteshare_l1 + polls_200_230, data = ger_df_long)
model_out <- lm(swing ~ chancellor_party + gov*voteshare_l1 + polls_200_230, data = ger_df_long)
model_out <- lm(swing ~ chancellor_party + voteshare_l1 + polls_200_230, data = ger_df_long)

*/


* theoretical motivated interactions

gen               govXunemp   = gov*unemp
gen               chancXunemp = chancellor_party*unemp
gen govXswing_l1Xvoteshare_l1 = gov*swing_l1*voteshare_l1
gen              govXswing_l1 = gov*swing_l1
gen     swing_l1Xvoteshare_l1 = swing_l1*voteshare_l1
gen          govXvoteshare_l1 = gov*voteshare_l1
 

gen chancellor_polls1 = chancellor_polls
replace chancellor_polls1=0 if chancellor_party==0


**************
* normal vote
**************

*generate normal vote variable for each relevant party
sort party year 
by party: gen votesharen = (voteshare[_n-1] + voteshare[_n-2] + voteshare[_n-3])/3 
by party: gen votesharen1 = (voteshare[_n-1])
replace votesharen = votesharen1 if votesharen ==.
recode votesharen .=0 if year>1949  // assume except of the first election that normal vote==0
drop votesharen1



gen lnelection = ln(election)
gen elecXvotesharen = election*votesharen
gen lnelecXvotesharen = lnelection*votesharen
gen elecXpoll = election*polls_200_230
gen lnelecXpoll = lnelection*polls_200_230


*******************************************
* term (Abnutzungseffekt von Regierungen)
*******************************************


gen party1=party
replace party1="cdu1" if year>1949 & year<=1969 & party=="cdu"
replace party1="spd1" if year>1969 & year<=1983 & party=="spd"
replace party1="cdu2" if year>1983 & year<=1998 & party=="cdu"
replace party1="spd2" if year>1998 & year<=2005 & party=="spd"
replace party1="cdu3" if year>2005              & party=="cdu"



sort party1 year 
by party1: gen term0 = _n if chancellor_party>0  & chancellor_party!=.

gen gov1 = gov
recode gov1 1=0 0=1
sort year gov1 chancellor_party term0
replace term0 = term0[_n+1] if chancellor_party==0 & gov==1
replace term0 = 0 if gov==0
drop gov1

gen sqrtterm = sqrt(term0) // non-linear transformation of marginal effect


gen term1 = term0   // only relevant for chancellor party
replace term1=0 if chancellor_party==0


/*
reg swing chancellor_party  voteshare_l1  polls_200_230  gov
reg swing chancellor_party  voteshare_l1  polls_200_230  term


reg swing chancellor_party  voteshare_l1  polls_200_230  gov
reg swing chancellor_party  voteshare_l1  polls_100_130 gov 

reg swing chancellor_party  votesharen  polls_200_230 gov
reg swing chancellor_party  votesharen  polls_100_130 gov



reg swing chancellor_party  unemp chancXunemp voteshare_l1  polls_200_230 parl

reg swing chancellor_party  unemp chancXunemp voteshare_l1  polls_200_230 parl gov swing_l1 ///
    govXswing_l1Xvoteshare_l1 govXswing_l1 swing_l1Xvoteshare_l1 govXvoteshare_l1 term
	
reg	swing  chancellor_party  voteshare_l1  polls_200_230
*/



reg voteshare chancellor_party  voteshare_l1  polls_200_230
reg voteshare chancellor_party  votesharen  polls_200_230


reg voteshare chancellor_party  voteshare_l1  polls_200_230 if voteshare_l1!=0
reg voteshare chancellor_party  votesharen  polls_200_230 if votesharen!=0




reg voteshare chancellor_party  voteshare_l1  polls_200_230
reg voteshare chancellor_party  voteshare_l1  polls_200_230 if voteshare_l1!=0

reg voteshare chancellor_party  votesharen  polls_200_230
reg voteshare chancellor_party  votesharen  polls_200_230 if votesharen!=0



*** While effect of chancellor_party stays constant votesharen gets less important,
*** and polls get more important over time
foreach num of numlist  1969 1972 1976 1980 1983 1987 1990 1994 1998  {
  
  display "Year>`num'" 
  reg voteshare chancellor_party  votesharen  polls_200_230 if year >`num' 
  display "Year<=`num'" 
  reg voteshare chancellor_party  votesharen  polls_200_230 if year <=`num'
        }

* control for time trend; ln(election) seem to work better
reg voteshare chancellor_party  votesharen  polls_200_230 election elecXpoll elecXvotesharen
reg voteshare chancellor_party  votesharen  polls_200_230 lnelection lnelecXpoll lnelecXvotesharen


exit


xtset year
xtreg  voteshare chancellor_party  votesharen  polls_200_230 lnelection lnelecXpoll lnelecXvotesharen
xtreg  voteshare chancellor_party  votesharen  polls_200_230 

reg  voteshare chancellor_party  votesharen  polls_200_230 
reg voteshare chancellor_party  voteshare_l1  polls_200_230


* How much is due to chance?
reg voteshare chancellor_party  votesharen  polls_200_230
gen test = e(sample)

generate w4 = rnormal()
generate w5 = rnormal()
generate w6 = rnormal()

reg voteshare chancellor_party  w4  polls_200_230 if test
reg voteshare w5  votesharen  w6 if test
reg voteshare w5  w4  w6 if test





foreach num of numlist 1953 1957 1961 1965 1969 1972 1976 1980 1983 1987 1990 1994 1998 2002 2005 2009 2013 {
  display "without `num'"               
  reg voteshare chancellor_party  votesharen  polls_200_230 lnelection lnelecXpoll lnelecXvotesharen if year !=`num'
        }




exit

foreach num of numlist 1953 1957 1961 1965 1969 1972 1976 1980 1983 1987 1990 1994 1998 2002 2005 2009 2013 {
  display "without `num'"               
  reg voteshare chancellor_party  votesharen  polls_200_230 if year !=`num'
        }





*Stability of coefficients

global tflist ""
global modseq=0
foreach num of numlist 1953 1957 1961 1965 1969 1972 1976 1980 1983 1987 1990 1994 1998 2002 2005 2009 2013 {
	global modseq=$modseq+1
      tempfile tf$modseq
      parmby "reg voteshare chancellor_party  votesharen  polls_200_230 if year !=`num'", label command format(estimate min95 max95 %8.2f p %8.1e) idn($modseq) saving(`tf$modseq',replace) flist(tflist)
      }
dsconcat $tflist
sort  parmseq idnum

gen est1 = estimate 
gen est2 = estimate 
gen est3 = estimate + .5
replace est1 = . if parmseq!=1
replace est2 = . if parmseq!=2
replace est3 = . if parmseq!=3

gen min1 = min95
gen min2 = min95
gen min3 = min95 + .5
replace min1 = . if parmseq!=1
replace min2 = . if parmseq!=2
replace min3 = . if parmseq!=3
 
gen max1 = max95
gen max2 = max95
gen max3 = max95 + .5
replace max1 = . if parmseq!=1
replace max2 = . if parmseq!=2
replace max3 = . if parmseq!=3


compress
save stability, replace



#delimit (;)

twoway (scatter idnum est1,  mcolor(black) ) ( rspike min1 max1 idnum,  lwidth(vthin) lcolor(black) horizontal) ||
       (scatter idnum est2,  mcolor(black) ) ( rspike min2 max2 idnum,  lwidth(vthin) lcolor(black) horizontal) ||
       (scatter idnum est3,  mcolor(black) ) ( rspike min3 max3 idnum,  lwidth(vthin) lcolor(black) horizontal),
 ytitle("") xtitle("") 
 xscale( nofextend)
 ylabel(1 "1953" 2 "1957" 3 "1961" 4 "1965" 5 "1969" 6 "1972" 7 "1976" 8 "1980" 9 "1983" 10 "1987" 11 "1990" 12 "1994" 13 "1998" 14 "2002" 15 "2005" 16 "2009" 17 "2013",  nogextend labsize(vsmall) angle(horizontal) nogrid )  
 xline(4.5, lp(shortdash)lwidth(thin)lcolor(black)  )
 xline(.32, lp(shortdash)lwidth(thin)lcolor(black)  )
 xline(1.07, lp(shortdash)lwidth(thin)lcolor(black)  )
 title(Stability of Estimates in Synthetic Out-Of-sample Predictions, size(medium)) 
 legend(off) 
 graphregion(fcolor(white) lcolor(black))
 saving(synth.gph, replace)
;
#delimit cr

graph export synth.pdf, replace





exit


