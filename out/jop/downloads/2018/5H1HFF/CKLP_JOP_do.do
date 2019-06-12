
*****************************************
*****************************************

* Do File for CKLP_JOP
* By Stephane Lavertu
* September 8, 2018

*** Set File Path Here ***
global PATH "C:\Users\stephane.lavertu\Desktop\JOP\" 

use "${PATH}\CKLP_JOP.dta", clear
set matsize 2400


*************************************************
* Table of Contents:							*
*	I. 	Create variables for analysis			*
*	II.	Validate Catalist Vote Counts			*
*	III.	Descriptive Figures (1&2)			*
* 	IV.	Descriptive Table (Table 1)				*
*	V.	Main Regressions (Tables 2-8)			*
*	VI.	Appendix A-D Tables						*
*************************************************



************************************
* I. Create variables for analysis *
************************************

* Identify election sample (Only want districts with at least some votes)
gen tempelectsamp=1 if totalvotes!=.
bysort dirn: egen SBsamp=mean(tempelectsamp)
drop tempelectsamp

* Indicators for odd/even yrs
gen odd = mod(year,2)
gen even = odd==0

* Logged SB election DVs
gen lnvote_cnt = log(elect_totalvotes)
gen logvotesperseat = log(votesperseat)
gen logvotespercand = log(votespercand)

* District student characteristics
xtset leaid year
replace fle=(L.fle + F.fle)/2 if year==2007 //no fle info for 2007, take avg of surrounding years
gen blackpct=bla/stucount
gen flepct=fle/stucount

* Voter Demographics
gen blackshare=cat_black_cnt/cat_voter_cnt
gen lowincshare=cat_under40K_cnt/cat_voter_cnt
gen teachshare=cat_teacher_cnt/cat_voter_cnt
gen homeshare=cat_owner_cnt/cat_voter_cnt
gen libshare=cat_liberal_cnt/cat_voter_cnt
sum blackshare lowincshare teachshare homeshare libshare youngshare childshare

* Log mobilization/demobilization data
gen ln_notTbutTm1 = log(notTbutTm1)
gen ln_TnotTm1 = log(TnotTm1)
gen ln_TnotTm2 = log(TnotTm2)
gen ln_notTbutTm2 = log(notTbutTm2)
gen ln_NewVoterCnt=log(NewTotalVoters)

* Voters who voted this election and two years prior
gen TandTm2 = NewTotalVoters-TnotTm2 //remove voters not voting 2 years ago
gen ln_TandTm2= log(TandTm2)
sum ln_NewVoterCnt ln_notTbutTm1 ln_notTbutTm2 ln_TnotTm1 ln_TnotTm2

* Levy Elections
gen pass=.
replace pass=1 if Result=="Passed"
replace pass=0 if Result=="Failed"
gen levy=.
replace levy=0 if year>=2003 & year<=2011
replace levy=1 if pass!=.
gen voters=VoteFor+VoteAgainst
gen lnvoters=log(voters)

* Turnout
gen turnoutCat2= NewTotalVoters/(totalpop- pop5_17)
gen turnoutCat= NewTotalVoters/(totalpop)
gen turnoutSB2= votesperseat/(totalpop- pop5_17)
gen turnoutSB= votesperseat/(totalpop)
gen ln_turnoutCat2=log(turnoutCat2)


* Identify high and low achieving/poverty/minority districts

bysort dirn: egen avgFLE=mean(flepct)
sum avgFLE if SBsamp==1,d
local medFLE = r(p50)
di "`medFLE'"
gen highFLE=.
replace highFLE=0 if avgFLE < `medFLE'
replace highFLE=1 if inrange(avgFLE,`medFLE',.)==1

bysort dirn: egen avgPI=mean(perfind)
sum avgPI if SBsamp==1,d
local medPI = r(p50)
di "`medPI'"
gen highPI=.
replace highPI=0 if avgPI < `medPI'
replace highPI=1 if inrange(avgPI,`medPI',.)==1

bysort dirn: egen avgBlack=mean(blackpct)
sum avgBlack if SBsamp==1,d
local medBlack = r(p50)
di "`medBlack'"
gen highBlack=.
replace highBlack=0 if avgBlack < `medBlack'
replace highBlack=1 if inrange(avgBlack,`medBlack',.)==1

bysort highFLE: sum Charters enroll if year==2011 & SBsamp==1
bysort highPI: sum Charters enroll if year==2011 & SBsamp==1
bysort highBlack: sum Charters enroll if year==2011 & SBsamp==1


* Charter + TPS students
gen totalstu=stupaychart+stucount
gen totalstu2=stupaychart+ADM
gen ln_totalstu=log(totalstu)
gen ln_totalstu2=log(totalstu)

* District enrollment 
gen ln_stucount=log(stucount)

* Total population
gen ln_totalpop=log(totalpop)
gen ln_childpop=log(pop5_17)
sum ln_totalpop ln_childpop

* Create lead/lags (necessary for early years)
xtset dirn electyr
gen FCharters=F.Charters
gen LCharters=L.Charters
replace LCharters=0 if LCharters==. & year==1999 & Charters==0



************************************
* II. Validate Catalist Vote Counts*
************************************

* Compare levy vote totals with Catalist vote counts
gen levy_tlcnt=VoteAgainst + VoteFor
gen cat_tlcnt= cat_voter_cnt
gen diff_levycat=levy_tlcnt-cat_tlcnt if missing(levy_tlcnt,cat_tlcnt)==0
gen diffpct_levycat= diff_levycat/ cat_tlcnt
correlate levy_tlcnt cat_tlcnt
bysort year: correlate levy_tlcnt cat_tlcnt
correlate levy_tlcnt cat_tlcnt if year>2002 & year<2011
sum diffpct_levycat if year>2002 & year<2011, detail

*Results: 
*	25th to 75th percentile is -0.046 to 0.049
*	median is -0.0005697
*	correlation is 0.9829




************************************
* III. Descriptive Figures 1 & 2   *
************************************

* Figure 1a
egen meancntALL = mean(stupaychart), by(electyr)
egen meancntSB = mean(stupaychart) if SBsamp==1, by(electyr)
line meancntALL meancntSB electyr 

* Figure 1b
egen meanpctALL = mean(Charters), by(electyr)
egen meanpctSB = mean(Charters) if SBsamp==1, by(electyr)
line meanpctALL meanpctSB electyr 

* Charter Entry (high vs. low) (as measured in 2011)
gen Charters2011=Charters if electyr==2011
bysort dirn: egen Char2011=mean(Charters2011)

sum Char2011 if SBsamp==1,d
local topChar = r(p75)
di "`topChar'"
gen highchar=.
replace highchar=0 if Char2011 < `topChar'
replace highchar=1 if inrange(Char2011,`topChar',.)==1

sum Char2011 if SBsamp==1,d
local bottomChar = r(p25)
di "`bottomChar'"
gen lowchar=.
replace lowchar=1 if Char2011 < `bottomChar'


* Percent difference in total votes cast
gen ln_SBVotes=lnvote_cnt
gen temp_SBVotes_99=ln_SBVotes if electyr==1999
bysort dirn: egen ln_SBvotes_99=mean(temp_SBVotes_99)
gen ln_diffSBVotes_99=ln_SBVotes-ln_SBvotes_99
egen meanlnSBVotesDiff_highchar = mean(ln_diffSBVotes_99) if highchar==1 & odd==1, by(electyr)
egen meanlnSBVotesDiff_lowchar = mean(ln_diffSBVotes_99) if lowchar==1 & odd==1, by(electyr)
sort electyr

* Percent difference in votes cast per seat, scaled by adult population
gen ln_turnoutSB2=log(turnoutSB2)
gen temp_turnSB2_99=turnoutSB2 if electyr==1999
bysort dirn: egen turnSB2_99=mean(temp_turnSB2_99)
gen ln_turnSB2_99=log(turnSB2_99)
gen ln_diffturnSB2_99=ln_turnoutSB2-ln_turnSB2_99
egen meanlnSBturnDiff_highchar = mean(ln_diffturnSB2_99) if highchar==1 & odd==1, by(electyr)
egen meanlnSBturnDiff_lowchar = mean(ln_diffturnSB2_99) if lowchar==1 & odd==1, by(electyr)
sort electyr

* Figure 2
line meanlnSBVotesDiff_highchar meanlnSBVotesDiff_lowchar electyr if year>=1999
line meanlnSBturnDiff_highchar meanlnSBturnDiff_lowchar electyr if year>=1999



************************************
* IV. Descriptive Table (Table 1)  *
************************************

* Table 1. Descriptives of SB Data (number of districts, votes, etc. in odd years for SB sample)
gen AEorAW=0
replace AEorAW=1 if acadE_L1==1 | acadW_L1==1
bysort dirn: egen everAEAW=max(AEorAW)
label variable votesperseat "Votes cast per school board seat"
label variable turnoutSB2 "Votes cast divided by adult population"
label variable cat_tlcnt "Voter counts"
label variable turnoutCat2 "Voter counts divided by adult population"
label variable notTbutTm2 "Non-voters who voted two years prior"
label variable TandTm2 "Voters who voted two years prior"
label variable stucount "Students in traditional public schools"
label variable stupaychart "Students who transferred to charter schools"
label variable Charters "Charters (percent charter transfers)"
label variable everAEAW "District ever received two lowest ratings"
sum votesperseat turnoutSB2 cat_tlcnt turnoutCat2 notTbutTm2 TandTm2 stucount stupaychart Charters everAEAW if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & votesperseat!=0
sutex2 votesperseat turnoutSB2 cat_tlcnt turnoutCat2 notTbutTm2 TandTm2 stucount stupaychart Charters everAEAW if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & votesperseat!=0, varlabels caption(Summary Statistics for School Board Sample -- Odd Years) min saving("${PATH}\Table1.tex") replace



*****************************************
* V.	Main Regressions (Tables 2-8)	*
*****************************************

* Table 2. Votes Cast in School Board Elections -- 1999-2011 
quietly xtreg ln_SBVotes Charters cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m1
estadd local Ratings "No"
estadd local Candidates "No"
estadd local Trends "No"
estadd local Districts "265"
quietly xtreg ln_SBVotes Charters i.rating_L1 i.rating_L2 candper cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m2
estadd local Ratings "Yes"
estadd local Candidates "Yes"
estadd local Trends "No"
estadd local Districts "264"
quietly xtreg ln_SBVotes Charters i.rating_L1 i.rating_L2 candper i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m3
estadd local Ratings "Yes"
estadd local Candidates "Yes"
estadd local Trends "Yes"
estadd local Districts "264"
quietly xtreg logvotesperseat Charters cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m4
estadd local Ratings "No"
estadd local Candidates "No"
estadd local Trends "No"
estadd local Districts "264"
quietly xtreg logvotesperseat Charters i.rating_L1 i.rating_L2 candper cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m5
estadd local Ratings "Yes"
estadd local Candidates "Yes"
estadd local Trends "No"
estadd local Districts "264"
quietly xtreg logvotesperseat Charters i.rating_L1 i.rating_L2 candper i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m6
estadd local Ratings "Yes"
estadd local Candidates "Yes"
estadd local Trends "Yes"
estadd local Districts "264"
esttab m1 m2 m3 m4 m5 m6, replace title(Table 2. Votes Cast in School Board Elections -- 1999-2011) mlabels("ln(Votes)" "ln(Votes)" "ln(Votes)" "ln(V/Seat)" "ln(V/Seat)" "ln(V/Seat)") se keep(Charters) scalars("Ratings Ratings" "Candidates Candidates" "Trends Trends" "Districts Districts") b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variable is the log of total votes cast for school board (columns 1-3) or votes cast per open school board seat (columns 4-6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
esttab m1 m2 m3 m4 m5 m6 using "${PATH}\Table2.tex", replace title(Table 2. Votes Cast in School Board Elections -- 1999-2011) mlabels("ln(Votes)" "ln(Votes)" "ln(Votes)" "ln(V/Seat)" "ln(V/Seat)" "ln(V/Seat)") se keep(Charters) scalars("Ratings Ratings" "Candidates Candidates" "Trends Trends" "Districts Districts") b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variable is the log of total votes cast for school board (columns 1-3) or votes cast per open school board seat (columns 4-6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
estimates clear


* Table 3. Votes Cast in School Board Elections -- 1999-2011 
xtset dirn electyr
quietly xtreg logvotesperseat Charters FCharters LCharters cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m1
estadd local Ratings "No"
estadd local Candidates "No"
estadd local Trends "No"
estadd local Districts "233"
quietly xtreg logvotesperseat Charters FCharters LCharters i.rating_L1 i.rating_L2 candper cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m2
estadd local Ratings "Yes"
estadd local Candidates "Yes"
estadd local Trends "No"
estadd local Districts "233"
quietly xtreg logvotesperseat Charters FCharters LCharters i.rating_L1 i.rating_L2 candper cy_* i.leaid#c.year if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m3
estadd local Ratings "Yes"
estadd local Candidates "Yes"
estadd local Trends "Yes"
estadd local Districts "233"
quietly xtreg ln_turnoutSB2 Charters FCharters LCharters cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m4
estadd local Ratings "No"
estadd local Candidates "No"
estadd local Trends "No"
estadd local Districts "233"
quietly xtreg ln_turnoutSB2 Charters FCharters LCharters i.rating_L1 i.rating_L2 candper cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m5
estadd local Ratings "Yes"
estadd local Candidates "Yes"
estadd local Trends "No"
estadd local Districts "233"
quietly xtreg ln_turnoutSB2 Charters FCharters LCharters i.rating_L1 i.rating_L2 candper cy_* i.leaid#c.year if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m6
estadd local Ratings "Yes"
estadd local Candidates "Yes"
estadd local Trends "Yes"
estadd local Districts "233"
esttab m1 m2 m3 m4 m5 m6, replace title(Table 3. Votes Cast in School Board Elections -- 1999-2011) mlabels("ln(V/Seat)" "ln(V/Seat)" "ln(V/Seat)" "ln(VS/Pop)" "ln(VS/Pop)" "ln(VS/Pop)") se keep(Charters L* F*) scalars("Ratings Ratings" "Candidates Candidates" "Trends Trends" "Districts Districts") b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variable is the log of votes cast per open school board seat (columns 1-3) and  log of votes cast per open school board seat scaled by Census population estimates (columns 4-6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
esttab m1 m2 m3 m4 m5 m6 using "${PATH}\Table3.tex", replace title(Table 3. Votes Cast in School Board Elections -- 1999-2011) mlabels("ln(V/Seat)" "ln(V/Seat)" "ln(V/Seat)" "ln(VS/Pop)" "ln(VS/Pop)" "ln(VS/Pop)") se keep(Charters L* F*) scalars("Ratings Ratings" "Candidates Candidates" "Trends Trends" "Districts Districts") b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variable is the log of votes cast per open school board seat (columns 1-3) and  log of votes cast per open school board seat scaled by Census population estimates (columns 4-6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
estimates clear


* Table 4. Voter Counts -- 2001-2011
xtset dirn electyr
quietly xtreg ln_NewVoterCnt Charters cy_* if year>=2001 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m1
estadd local Ratings "No"
estadd local Candidates "No"
estadd local Trends "No"
estadd local Districts "247"
quietly xtreg ln_NewVoterCnt Charters i.rating_L1 i.rating_L2 candper i.leaid#c.year cy_* if year>=2001 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m2
estadd local Ratings "Yes"
estadd local Candidates "Yes"
estadd local Trends "Yes"
estadd local Districts "246"
quietly xtreg ln_NewVoterCnt Charters FCharters LCharters  i.rating_L1 i.rating_L2 candper cy_* if year>=2001 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m3
estadd local Ratings "Yes"
estadd local Candidates "Yes"
estadd local Trends "No"
estadd local Districts "219"
quietly xtreg ln_turnoutCat2 Charters cy_* if year>=2001 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m4
estadd local Ratings "No"
estadd local Candidates "No"
estadd local Trends "No"
estadd local Districts "247"
quietly xtreg ln_turnoutCat2 Charters i.rating_L1 i.rating_L2 candper i.leaid#c.year cy_* if year>=2001 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m5
estadd local Ratings "Yes"
estadd local Candidates "Yes"
estadd local Trends "Yes"
estadd local Districts "246"
quietly xtreg ln_turnoutCat2 Charters FCharters LCharters  i.rating_L1 i.rating_L2 candper cy_* if year>=2001 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m6
estadd local Ratings "Yes"
estadd local Candidates "Yes"
estadd local Trends "No"
estadd local Districts "219"
esttab m1 m2 m3 m4 m5 m6, replace title(Table 4. Voter Turnout in Odd-year Elections -- 2001-2011) mlabels("ln(Voters)" "ln(Voters)" "ln(Voters)" "ln(Vtrs/Pop)" "ln(Vtrs/Pop)" "ln(Vtrs/Pop)") se keep(Charters L* F*) scalars("Ratings Ratings" "Candidates Candidates" "Trends Trends" "Districts Districts") b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variable is the log of the total number of voters in odd-year elections (columns 1-3) and the log of odd-year voter counts scaled by population (columns 4-6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
esttab m1 m2 m3 m4 m5 m6 using "${PATH}\Table4.tex", replace title(Table 4. Voter Turnout in Odd-year Elections -- 2001-2011) mlabels("ln(Voters)" "ln(Voters)" "ln(Voters)" "ln(Vtrs/Pop)" "ln(Vtrs/Pop)" "ln(Vtrs/Pop)") se keep(Charters L* F*) scalars("Ratings Ratings" "Candidates Candidates" "Trends Trends" "Districts Districts") b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variable is the log of the total number of voters in odd-year elections (columns 1-3) and the log of odd-year voter counts scaled by population (columns 4-6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
estimates clear


* Table 5. Odd-year Voter Turnout -- 2003-2011
xtset dirn electyr
quietly xtreg ln_NewVoterCnt Charters i.rating_L1 i.rating_L2 candper i.leaid#c.year cy_* if year>=2003 & year<=2011 & SBsamp==1 & odd==1, fe vce(cluster leaid)
eststo m1
estadd local Ratings "Yes"
estadd local Candidates "Yes"
estadd local Trends "Yes"
estadd local Districts "246"
quietly xtreg ln_NewVoterCnt Charters FCharters LCharters cy_* if year>=2003 & year<=2011 & SBsamp==1 & odd==1, fe vce(cluster leaid)
eststo m2
estadd local Ratings "No"
estadd local Candidates "No"
estadd local Trends "No"
estadd local Districts "247"
quietly xtreg ln_TnotTm2 Charters i.rating_L1 i.rating_L2 candper i.leaid#c.year cy_* if year>=2003 & year<=2011 & SBsamp==1 & odd==1, fe vce(cluster leaid)
eststo m3
estadd local Ratings "Yes"
estadd local Candidates "Yes"
estadd local Trends "Yes"
estadd local Districts "246"
quietly xtreg ln_TnotTm2 Charters FCharters LCharters cy_* if year>=2003 & year<=2011 & SBsamp==1 & odd==1, fe vce(cluster leaid)
eststo m4
estadd local Ratings "No"
estadd local Candidates "No"
estadd local Trends "No"
estadd local Districts "247"
quietly xtreg ln_TandTm2 Charters i.rating_L1 i.rating_L2 candper i.leaid#c.year cy_* if year>=2003 & year<=2011 & SBsamp==1 & odd==1, fe vce(cluster leaid)
eststo m5
estadd local Ratings "Yes"
estadd local Candidates "Yes"
estadd local Trends "Yes"
estadd local Districts "246"
quietly xtreg ln_TandTm2 Charters FCharters LCharters cy_* if year>=2003 & year<=2011 & SBsamp==1 & odd==1, fe vce(cluster leaid)
eststo m6
estadd local Ratings "No"
estadd local Candidates "No"
estadd local Trends "No"
estadd local Districts "247"
esttab m1 m2 m3 m4 m5 m6, replace title(Table 5. Voter Turnout in Odd-year Elections -- 2003-2011) mlabels("ln(Voters)" "ln(Voters)" "ln(New)" "ln(New)" "ln(Repeat)" "ln(Repeat)") se keep(Charters L* F*) scalars("Ratings Ratings" "Candidates Candidates" "Trends Trends" "Districts Districts") b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variable is the log of the total number of voters in odd-year elections (columns 1-2), the logged count of ``new'' voters who did not vote in the prior odd-year election (columns 3-4), or the logged count of ``repeat'' voters who voted in the prior odd-year election (columns 5-6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
esttab m1 m2 m3 m4 m5 m6 using "${PATH}\Table5.tex", replace title(Table 5. Voter Turnout in Odd-year Elections -- 2003-2011) mlabels("ln(Voters)" "ln(Voters)" "ln(New)" "ln(New)" "ln(Repeat)" "ln(Repeat)") se keep(Charters L* F*) scalars("Ratings Ratings" "Candidates Candidates" "Trends Trends" "Districts Districts") b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variable is the log of the total number of voters in odd-year elections (columns 1-2), the logged count of ``new'' voters who did not vote in the prior odd-year election (columns 3-4), or the logged count of ``repeat'' voters who voted in the prior odd-year election (columns 5-6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
estimates clear


* Table 6: DDD, Voter Sample, 2005-2011
gen int_oddchar=odd*Charters
xtset dirn year
quietly xtreg ln_NewVoterCnt int_oddchar Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=2005 & year<=2011 & SBsamp==1, fe vce(cluster leaid)
eststo m1
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Districts "247"
quietly xtreg ln_TnotTm2 int_oddchar Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=2005 & year<=2011 & SBsamp==1, fe vce(cluster leaid)
eststo m2
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Districts "247"
quietly xtreg ln_TandTm2 int_oddchar Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=2005 & year<=2011 & SBsamp==1, fe vce(cluster leaid)
eststo m3
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Districts "247"
quietly xtreg ln_turnoutCat2 int_oddchar Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=2005 & year<=2011 & SBsamp==1, fe vce(cluster leaid)
eststo m4
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Districts "247"
quietly xtreg ln_turnoutCat2 int_oddchar F.int_oddchar L.int_oddchar Charters F.Charters L.Charters i.rating_L1 i.rating_L2 cy_* if year>=2005 & year<=2011 & SBsamp==1, fe vce(cluster leaid)
eststo m5
estadd local Ratings "Yes"
estadd local Trends "No"
estadd local Districts "247"
esttab m1 m2 m3 m4 m5, replace title(Table 6. DDD Estimates of Turnout -- 2005-2011) mlabels("ln(Voters)" "ln(New)" "ln(Repeat)" "ln(V/Pop)" "ln(V/Pop)") se keep(int_oddchar Charters int* L.i* F.i*) scalars("Ratings Ratings" "Trends Trends" "Districts Districts") b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variable is the logged count of voter counts from the Catalist voter file (column 1), the logged count of voters who did not vote two years prior (column 2), the logged count of voters who voted two years prior (column 3), and the logged count of voters scaled by Census population estimates (columns 4-5). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
esttab m1 m2 m3 m4 m5 using "${PATH}\Table6.tex", replace title(Table 6. DDD Estimates of Turnout -- 2005-2011) mlabels("ln(Voters)" "ln(New)" "ln(Repeat)" "ln(V/Pop)" "ln(V/Pop)") se keep(int_oddchar Charters int* L.i* F.i*) scalars("Ratings Ratings" "Trends Trends" "Districts Districts") b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variable is the logged count of voter counts from the Catalist voter file (column 1), the logged count of voters who did not vote two years prior (column 2), the logged count of voters who voted two years prior (column 3), and the logged count of voters scaled by Census population estimates (columns 4-5). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
estimates clear


* Table 7: Table 7. Mechanism Check: Whether a Tax Levy is on the Ballot (2005-2011)
gen int_ioclev=int_oddchar*levy
gen int_charlev=Charters*levy
xtset dirn year
quietly xtreg ln_NewVoterCnt int_oddchar Charters levy int_ioclev int_charlev i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=2005 & year<=2011 & SBsamp==1, fe vce(cluster leaid)
eststo m1
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Districts "247"
quietly xtreg ln_TnotTm2 int_oddchar Charters levy int_ioclev int_charlev i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=2005 & year<=2011 & SBsamp==1, fe vce(cluster leaid)
eststo m2
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Districts "247"
quietly xtreg ln_TandTm2 int_oddchar Charters levy int_ioclev int_charlev i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=2005 & year<=2011 & SBsamp==1, fe vce(cluster leaid)
eststo m3
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Districts "247"
quietly xtreg ln_turnoutCat2 int_oddchar Charters levy int_ioclev int_charlev i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=2005 & year<=2011 & SBsamp==1, fe vce(cluster leaid)
eststo m4
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Districts "247"
xtset dirn year
quietly xtreg ln_turnoutCat2 int_oddchar F.int_oddchar L.int_oddchar Charters levy int_ioclev int_charlev F.Charters L.Charters i.rating_L1 i.rating_L2  cy_* if year>=2005 & year<=2011 & SBsamp==1, fe vce(cluster leaid)
eststo m5
estadd local Ratings "Yes"
estadd local Trends "No"
estadd local Districts "247"
esttab m1 m2 m3 m4 m5, replace title(Table 7. Mechanism Check: Whether a Tax Levy is on the Ballot -- 2005-2011) mlabels("ln(Voters)" "ln(New)" "ln(Repeat)" "ln(V/Pop)" "ln(V/Pop)") se keep(int_oddchar Charters levy int* L.i* F.i*) scalars("Ratings Ratings" "Trends Trends" "Districts Districts") b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variable is the logged count of voter counts from the Catalist voter file (column 1), the logged count of voters who did not vote two years prior (column 2), the logged count of voters who voted two years prior (column 3), and the logged count of voters scaled by Census population estimates (columns 4-5). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
esttab m1 m2 m3 m4 m5 using "${PATH}\Table7.tex", replace title(Table 7. Mechanism Check: Whether a Tax Levy is on the Ballot -- 2005-2011) mlabels("ln(Voters)" "ln(New)" "ln(Repeat)" "ln(V/Pop)" "ln(V/Pop)") se keep(int_oddchar Charters levy int* L.i* F.i*) scalars("Ratings Ratings" "Trends Trends" "Districts Districts") b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variable is the logged count of voter counts from the Catalist voter file (column 1), the logged count of voters who did not vote two years prior (column 2), the logged count of voters who voted two years prior (column 3), and the logged count of voters scaled by Census population estimates (columns 4-5). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
estimates clear


* Table 8. Share of Voters (Liberal, Low-income, Black, Teachers, Parents, Under40 1999-2011) -- Low-achieving districts
quietly xtreg libshare Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highPI==0, fe vce(cluster leaid)
eststo m1
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Districts "123"
quietly xtreg lowincshare Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highPI==0, fe vce(cluster leaid)
eststo m2
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Districts "123"
quietly xtreg blackshare Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highPI==0, fe vce(cluster leaid)
eststo m3
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Districts "123"
quietly xtreg teachshare Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highPI==0, fe vce(cluster leaid)
eststo m4
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Districts "123"
quietly xtreg childshare Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highPI==0, fe vce(cluster leaid)
eststo m5
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Districts "123"
quietly xtreg youngshare Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highPI==0, fe vce(cluster leaid)
eststo m6
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Districts "123"
esttab m1 m2 m3 m4 m5 m6, replace title(Table 8. Odd-year Voter Characteristics for Districts with Low-Achieving Students) mlabels("Liberal" "LowIncome" "Black" "Teacher" "Parent" "Under40") se keep(Charters) scalars("Ratings Ratings" "Trends Trends" "Districts Districts") b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variable is the share of voters who are liberal (column 1), low income (column 2), black (column 3), teachers (column 4), parents (column 5), and under the age of 40 (column 6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
esttab m1 m2 m3 m4 m5 m6 using "${PATH}\Table8.tex", replace title(Table 8. Odd-year Voter Characteristics for Districts with Low-Achieving Students) mlabels("Liberal" "LowIncome" "Black" "Teacher" "Parent" "Under40") se keep(Charters) scalars("Ratings Ratings" "Trends Trends" "Districts Districts") b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variable is the share of voters who are liberal (column 1), low income (column 2), black (column 3), teachers (column 4), parents (column 5), and under the age of 40 (column 6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
estimates clear




*****************************
* VI.	Appendix A-D Tables *
*****************************

***APPENDIX A: Checking Trends

* Table A1. Odd-Year Validity Checks - 1999-2011
quietly xtreg ln_childpop Charters cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m1
estadd local Ratings "No"
estadd local Trends "No"
estadd local Candidates "No"
estadd local Districts "265"
quietly xtreg ln_childpop Charters candper i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m2
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Candidates "Yes"
estadd local Districts "264"
quietly xtreg ln_totalpop Charters cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m3
estadd local Ratings "No"
estadd local Trends "No"
estadd local Candidates "No"
estadd local Districts "265"
quietly xtreg ln_totalpop Charters candper i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m4
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Candidates "Yes"
estadd local Districts "264"
quietly xtreg ln_stucount Charters cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m5
estadd local Ratings "No"
estadd local Trends "No"
estadd local Candidates "No"
estadd local Districts "265"
quietly xtreg ln_stucount Charters candper i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m6
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Candidates "Yes"
estadd local Districts "264"
esttab m1 m2 m3 m4 m5 m6, replace title(Table A1. Odd-year Validity Checks -- 1999-2011) mlabels("ln(ChildPop)" "ln(ChildPop)" "ln(Pop)" "ln(Pop)" "ln(TPSenroll)" "ln(TPSenroll)") se keep(Charters) scalars("Ratings Ratings" "Trends Trends" "Candidates Candidates" "Districts Districts") b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variables are logged counts of school-age children within district boundaries (columns 1-2), logged population within district boundaries (columns 3-4), or logged counts of students in traditional public schools (columns 5-6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
esttab m1 m2 m3 m4 m5 m6 using "${PATH}\TableA1.tex", replace title(Table A1. Odd-year Validity Checks -- 1999-2011) mlabels("ln(ChildPop)" "ln(ChildPop)" "ln(Pop)" "ln(Pop)" "ln(TPSenroll)" "ln(TPSenroll)") se keep(Charters) scalars("Ratings Ratings" "Trends Trends" "Candidates Candidates" "Districts Districts") b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variables are logged counts of school-age children within district boundaries (columns 1-2), logged population within district boundaries (columns 3-4), or logged counts of students in traditional public schools (columns 5-6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
estimates clear


* Table A2. Odd-Year Validity Checks - 1999-2005
quietly xtreg ln_childpop Charters cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m1
estadd local Ratings "No"
estadd local Trends "No"
estadd local Candidates "No"
quietly xtreg ln_childpop Charters candper i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2005 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m2
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Candidates "Yes"
quietly xtreg ln_totalpop Charters cy_* if year>=1999 & year<=2005 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m3
estadd local Ratings "No"
estadd local Trends "No"
estadd local Candidates "No"
quietly xtreg ln_totalpop Charters candper i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2005 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m4
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Candidates "Yes"
quietly xtreg ln_stucount Charters cy_* if year>=1999 & year<=2005 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m5
estadd local Ratings "No"
estadd local Trends "No"
estadd local Candidates "No"
quietly xtreg ln_stucount Charters candper i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2005 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m6
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Candidates "Yes"
esttab m1 m2 m3 m4 m5 m6, replace title(Table A2. Odd-year Validity Checks -- 1999-2005) mlabels("ln(ChildPop)" "ln(ChildPop)" "ln(Pop)" "ln(Pop)" "ln(TPSenroll)" "ln(TPSenroll)") se keep(Charters) scalars("Ratings Ratings" "Trends Trends" "Candidates Candidates" ) b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variables are logged counts of school-age children within district boundaries (columns 1-2), logged population within district boundaries (columns 3-4), or logged counts of students in traditional public schools (columns 5-6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
esttab m1 m2 m3 m4 m5 m6 using "${PATH}\TableA2.tex", replace title(Table A2. Odd-year Validity Checks -- 1999-2005) mlabels("ln(ChildPop)" "ln(ChildPop)" "ln(Pop)" "ln(Pop)" "ln(TPSenroll)" "ln(TPSenroll)") se keep(Charters) scalars("Ratings Ratings" "Trends Trends" "Candidates Candidates" ) b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variables are logged counts of school-age children within district boundaries (columns 1-2), logged population within district boundaries (columns 3-4), or logged counts of students in traditional public schools (columns 5-6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
estimates clear


* Table A3. Odd-Year Validity Checks - 2005-2011
quietly xtreg ln_childpop Charters cy_* if year>=2005 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m1
estadd local Ratings "No"
estadd local Trends "No"
estadd local Candidates "No"
quietly xtreg ln_childpop Charters candper i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=2005 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m2
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Candidates "Yes"
quietly xtreg ln_totalpop Charters cy_* if year>=2005 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m3
estadd local Ratings "No"
estadd local Trends "No"
estadd local Candidates "No"
quietly xtreg ln_totalpop Charters candper i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=2005 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m4
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Candidates "Yes"
quietly xtreg ln_stucount Charters cy_* if year>=2005 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m5
estadd local Ratings "No"
estadd local Trends "No"
estadd local Candidates "No"
quietly xtreg ln_stucount Charters candper i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=2005 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m6
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Candidates "Yes"
esttab m1 m2 m3 m4 m5 m6, replace title(Table A3. Odd-year Validity Checks -- 2005-2011) mlabels("ln(ChildPop)" "ln(ChildPop)" "ln(Pop)" "ln(Pop)" "ln(TPSenroll)" "ln(TPSenroll)") se keep(Charters) scalars("Ratings Ratings" "Trends Trends" "Candidates Candidates" ) b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variables are logged counts of school-age children within district boundaries (columns 1-2), logged population within district boundaries (columns 3-4), or logged counts of students in traditional public schools (columns 5-6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
esttab m1 m2 m3 m4 m5 m6 using "${PATH}\TableA3.tex", replace title(Table A3. Odd-year Validity Checks -- 2005-2011) mlabels("ln(ChildPop)" "ln(ChildPop)" "ln(Pop)" "ln(Pop)" "ln(TPSenroll)" "ln(TPSenroll)") se keep(Charters) scalars("Ratings Ratings" "Trends Trends" "Candidates Candidates" ) b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variables are logged counts of school-age children within district boundaries (columns 1-2), logged population within district boundaries (columns 3-4), or logged counts of students in traditional public schools (columns 5-6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
estimates clear


* Table A4. even-Year Validity Checks - 1999-2011
quietly xtreg ln_childpop Charters cy_* if year>=1999 & year<=2011 & even==1 & SBsamp==1, fe vce(cluster leaid)
eststo m1
estadd local Ratings "No"
estadd local Trends "No"
estadd local Candidates "No"
quietly xtreg ln_childpop Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & even==1 & SBsamp==1, fe vce(cluster leaid)
eststo m2
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Candidates "No"
quietly xtreg ln_totalpop Charters cy_* if year>=1999 & year<=2011 & even==1 & SBsamp==1, fe vce(cluster leaid)
eststo m3
estadd local Ratings "No"
estadd local Trends "No"
estadd local Candidates "No"
quietly xtreg ln_totalpop Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & even==1 & SBsamp==1, fe vce(cluster leaid)
eststo m4
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Candidates "No"
quietly xtreg ln_stucount Charters cy_* if year>=1999 & year<=2011 & even==1 & SBsamp==1, fe vce(cluster leaid)
eststo m5
estadd local Ratings "No"
estadd local Trends "No"
estadd local Candidates "No"
quietly xtreg ln_stucount Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & even==1 & SBsamp==1, fe vce(cluster leaid)
eststo m6
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Candidates "No"
esttab m1 m2 m3 m4 m5 m6, replace title(Table A4. even-year Validity Checks -- 1999-2011) mlabels("ln(ChildPop)" "ln(ChildPop)" "ln(Pop)" "ln(Pop)" "ln(TPSenroll)" "ln(TPSenroll)") se keep(Charters) scalars("Ratings Ratings" "Trends Trends" "Candidates Candidates" ) b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variables are logged counts of school-age children within district boundaries (columns 1-2), logged population within district boundaries (columns 3-4), or logged counts of students in traditional public schools (columns 5-6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
esttab m1 m2 m3 m4 m5 m6 using "${PATH}\TableA4.tex", replace title(Table A4. even-year Validity Checks -- 1999-2011) mlabels("ln(ChildPop)" "ln(ChildPop)" "ln(Pop)" "ln(Pop)" "ln(TPSenroll)" "ln(TPSenroll)") se keep(Charters) scalars("Ratings Ratings" "Trends Trends" "Candidates Candidates" ) b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variables are logged counts of school-age children within district boundaries (columns 1-2), logged population within district boundaries (columns 3-4), or logged counts of students in traditional public schools (columns 5-6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
estimates clear


* Table A5. even-Year Validity Checks - 1999-2005
quietly xtreg ln_childpop Charters cy_* if year>=1999 & year<=2011 & even==1 & SBsamp==1, fe vce(cluster leaid)
eststo m1
estadd local Ratings "No"
estadd local Trends "No"
estadd local Candidates "No"
quietly xtreg ln_childpop Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2005 & even==1 & SBsamp==1, fe vce(cluster leaid)
eststo m2
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Candidates "No"
quietly xtreg ln_totalpop Charters cy_* if year>=1999 & year<=2005 & even==1 & SBsamp==1, fe vce(cluster leaid)
eststo m3
estadd local Ratings "No"
estadd local Trends "No"
estadd local Candidates "No"
quietly xtreg ln_totalpop Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2005 & even==1 & SBsamp==1, fe vce(cluster leaid)
eststo m4
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Candidates "No"
quietly xtreg ln_stucount Charters cy_* if year>=1999 & year<=2005 & even==1 & SBsamp==1, fe vce(cluster leaid)
eststo m5
estadd local Ratings "No"
estadd local Trends "No"
estadd local Candidates "No"
quietly xtreg ln_stucount Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2005 & even==1 & SBsamp==1, fe vce(cluster leaid)
eststo m6
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Candidates "No"
esttab m1 m2 m3 m4 m5 m6, replace title(Table A5. even-year Validity Checks -- 1999-2005) mlabels("ln(ChildPop)" "ln(ChildPop)" "ln(Pop)" "ln(Pop)" "ln(TPSenroll)" "ln(TPSenroll)") se keep(Charters) scalars("Ratings Ratings" "Trends Trends" "Candidates Candidates" ) b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variables are logged counts of school-age children within district boundaries (columns 1-2), logged population within district boundaries (columns 3-4), or logged counts of students in traditional public schools (columns 5-6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
esttab m1 m2 m3 m4 m5 m6 using "${PATH}\TableA5.tex", replace title(Table A5. even-year Validity Checks -- 1999-2005) mlabels("ln(ChildPop)" "ln(ChildPop)" "ln(Pop)" "ln(Pop)" "ln(TPSenroll)" "ln(TPSenroll)") se keep(Charters) scalars("Ratings Ratings" "Trends Trends" "Candidates Candidates" ) b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variables are logged counts of school-age children within district boundaries (columns 1-2), logged population within district boundaries (columns 3-4), or logged counts of students in traditional public schools (columns 5-6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
estimates clear


* Table A6. even-Year Validity Checks - 2005-2011
quietly xtreg ln_childpop Charters cy_* if year>=2005 & year<=2011 & even==1 & SBsamp==1, fe vce(cluster leaid)
eststo m1
estadd local Ratings "No"
estadd local Trends "No"
estadd local Candidates "No"
quietly xtreg ln_childpop Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=2005 & year<=2011 & even==1 & SBsamp==1, fe vce(cluster leaid)
eststo m2
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Candidates "No"
quietly xtreg ln_totalpop Charters cy_* if year>=2005 & year<=2011 & even==1 & SBsamp==1, fe vce(cluster leaid)
eststo m3
estadd local Ratings "No"
estadd local Trends "No"
estadd local Candidates "No"
quietly xtreg ln_totalpop Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=2005 & year<=2011 & even==1 & SBsamp==1, fe vce(cluster leaid)
eststo m4
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Candidates "No"
quietly xtreg ln_stucount Charters cy_* if year>=2005 & year<=2011 & even==1 & SBsamp==1, fe vce(cluster leaid)
eststo m5
estadd local Ratings "No"
estadd local Trends "No"
estadd local Candidates "No"
quietly xtreg ln_stucount Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=2005 & year<=2011 & even==1 & SBsamp==1, fe vce(cluster leaid)
eststo m6
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Candidates "No"
esttab m1 m2 m3 m4 m5 m6, replace title(Table A6. even-year Validity Checks -- 2005-2011) mlabels("ln(ChildPop)" "ln(ChildPop)" "ln(Pop)" "ln(Pop)" "ln(TPSenroll)" "ln(TPSenroll)") se keep(Charters) scalars("Ratings Ratings" "Trends Trends" "Candidates Candidates" ) b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variables are logged counts of school-age children within district boundaries (columns 1-2), logged population within district boundaries (columns 3-4), or logged counts of students in traditional public schools (columns 5-6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
esttab m1 m2 m3 m4 m5 m6 using "${PATH}\TableA6.tex", replace title(Table A6. even-year Validity Checks -- 2005-2011) mlabels("ln(ChildPop)" "ln(ChildPop)" "ln(Pop)" "ln(Pop)" "ln(TPSenroll)" "ln(TPSenroll)") se keep(Charters) scalars("Ratings Ratings" "Trends Trends" "Candidates Candidates" ) b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variables are logged counts of school-age children within district boundaries (columns 1-2), logged population within district boundaries (columns 3-4), or logged counts of students in traditional public schools (columns 5-6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
estimates clear


***APPENDIX B: Election Outcomes and Voter Characteristics

* Table B1. School Board Election Outcomes -- 1999-2011 
quietly xtreg candper Charters cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m1
estadd local Ratings "No"
estadd local Trends "No"
quietly xtreg candper Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m2
estadd local Ratings "Yes"
estadd local Trends "Yes"
quietly xtreg incvoteshr Charters cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m3
estadd local Ratings "No"
estadd local Trends "No"
quietly xtreg incvoteshr Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m4
estadd local Ratings "Yes"
estadd local Trends "Yes"
quietly xtreg fracexprtrn Charters cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m5
estadd local Ratings "No"
estadd local Trends "No"
quietly xtreg fracexprtrn Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m6
estadd local Ratings "Yes"
estadd local Trends "Yes"
esttab m1 m2 m3 m4 m5 m6, replace title(Table B1. Odd-year Election Outcomes -- 1999-2011) mlabels("CandPer" "CandPer" "VoteShare" "VoteShare" "Return" "Return") se keep(Charters) scalars("Ratings Ratings" "Trends Trends" ) b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variables are counts of candidates per seat (columns 1-2), the vote share of incumbents running for re-election (columns 3-4), and the fraction of board members with expiring terms who return (columns 5-6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
esttab m1 m2 m3 m4 m5 m6 using "${PATH}\TableB1.tex", replace title(Table B1. Odd-year Election Outcomes -- 1999-2011) mlabels("CandPer" "CandPer" "VoteShare" "VoteShare" "Return" "Return") se keep(Charters) scalars("Ratings Ratings" "Trends Trends" ) b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variables are counts of candidates per seat (columns 1-2), the vote share of incumbents running for re-election (columns 3-4), and the fraction of board members with expiring terms who return (columns 5-6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
estimates clear


* Table B2. Share of Voters (Liberal, Low-income, Black, Teachers, 1999-2011)
quietly xtreg libshare Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m1
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Sample "Voter"
estadd local Years "99-11"
estadd local Elections "OddYr"
quietly xtreg lowincshare Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m2
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Sample "Voter"
estadd local Years "99-11"
estadd local Elections "OddYr"
quietly xtreg blackshare Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m3
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Sample "Voter"
estadd local Years "99-11"
estadd local Elections "OddYr"
quietly xtreg teachshare Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m4
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Sample "Voter"
estadd local Years "99-11"
estadd local Elections "OddYr"
quietly xtreg childshare Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m5
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Sample "Voter"
estadd local Years "99-11"
estadd local Elections "OddYr"
quietly xtreg youngshare Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1, fe vce(cluster leaid)
eststo m6
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Sample "Voter"
estadd local Years "99-11"
estadd local Elections "OddYr"
esttab m1 m2 m3 m4 m5 m6, replace title(Table B2. Odd-year Voter Characteristics) mlabels("Liberal" "LowIncome" "Black" "Teacher" "Parent" "Under40") se keep(Charters) scalars("Ratings Ratings" "Trends Trends" ) b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variable is the share of liberal votes (column 1), low income voters (column 2), black voters (column 3), voters who are teachers (column 4), voters who are parents (column 5), and voters under the age of 40 (column 6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
esttab m1 m2 m3 m4 m5 m6 using "${PATH}\TableB2.tex", replace title(Table B2. Odd-year Voter Characteristics) mlabels("Liberal" "LowIncome" "Black" "Teacher" "Parent" "Under40") se keep(Charters) scalars("Ratings Ratings" "Trends Trends" ) b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variable is the share of liberal votes (column 1), low income voters (column 2), black voters (column 3), voters who are teachers (column 4), voters who are parents (column 5), and voters under the age of 40 (column 6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
estimates clear



*** APPENDIX C: Effect Heterogeneity

*Table C1: Effect Heterogeneity -- School Board Votes
sum avgPI avgFLE avgBlack if year>=1999 & year<=2011 & odd==1 & SBsamp==1, detail
quietly xtreg logvotesperseat Charters i.rating_L1 i.rating_L2 cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highPI==0 & avgPI!=., fe vce(cluster leaid)
eststo m1
estadd local Subset "LowAchieve"
estadd local Ratings "Yes"
estadd local Trends "No"
quietly xtreg logvotesperseat Charters i.rating_L1 i.rating_L2  cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highPI==1 & avgPI!=., fe vce(cluster leaid)
eststo m2
estadd local Subset "HighAchieve"
estadd local Ratings "Yes"
estadd local Trends "No"
quietly xtreg logvotesperseat Charters i.rating_L1 i.rating_L2  cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highFLE==1 & avgFLE!=., fe vce(cluster leaid)
eststo m3
estadd local Subset "HighPoverty"
estadd local Ratings "Yes"
estadd local Trends "No"
quietly xtreg logvotesperseat Charters i.rating_L1 i.rating_L2  cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highFLE==0 & avgFLE!=., fe vce(cluster leaid)
eststo m4
estadd local Subset "LowPoverty"
estadd local Ratings "Yes"
estadd local Trends "No"
quietly xtreg logvotesperseat Charters i.rating_L1 i.rating_L2  cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highBlack==1 & avgBlack!=., fe vce(cluster leaid)
eststo m5
estadd local Subset "HighBlack"
estadd local Ratings "Yes"
estadd local Trends "No"
quietly xtreg logvotesperseat Charters i.rating_L1 i.rating_L2  cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highBlack==0 & avgBlack!=., fe vce(cluster leaid)
eststo m6
estadd local Subset "LowBlack"
estadd local Ratings "Yes"
estadd local Trends "No"
esttab m1 m2 m3 m4 m5 m6, replace title(Table C1. Effect Heterogeneity: Votes Cast in School Board Elections, 1999-2011) mlabels("ln(V/Seat)" "ln(V/Seat)" "ln(V/Seat)" "ln(V/Seat)" "ln(V/Seat)" "ln(V/Seat)") se keep(Charters) scalars("Subset Subset" "Ratings Ratings" "Trends Trends" ) b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variable is the log of total votes cast per open school board seat. Each pair of columns identifies districts that are above or below the median on the district performance index (median = 0.9387), in terms of the proportion of students who qualify for free or reduced price lunch (median = .1536925), and in terms of the proportion of kids who are Black (median = .0126087). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
esttab m1 m2 m3 m4 m5 m6 using "${PATH}\TableC1.tex", replace title(Table C1. Effect Heterogeneity: Votes Cast in School Board Elections, 1999-2011) mlabels("ln(V/Seat)" "ln(V/Seat)" "ln(V/Seat)" "ln(V/Seat)" "ln(V/Seat)" "ln(V/Seat)") se keep(Charters) scalars("Subset Subset" "Ratings Ratings" "Trends Trends" ) b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variable is the log of total votes cast per open school board seat. Each pair of columns identifies districts that are above or below the median on the district performance index (median = 0.9387), in terms of the proportion of students who qualify for free or reduced price lunch (median = .1536925), and in terms of the proportion of kids who are Black (median = .0126087). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
estimates clear


*Table C2: Effect Heterogeneity -- School Board Votes
sum avgPI avgFLE avgBlack if year>=1999 & year<=2011 & odd==1 & SBsamp==1, detail
quietly xtreg logvotesperseat Charters i.rating_L1 i.rating_L2 candper i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highPI==0 & avgPI!=., fe vce(cluster leaid)
eststo m1
estadd local Subset "LowAchieve"
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Candidates "Yes"
quietly xtreg logvotesperseat Charters i.rating_L1 i.rating_L2 candper i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highPI==1 & avgPI!=., fe vce(cluster leaid)
eststo m2
estadd local Subset "HighAchieve"
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Candidates "Yes"
quietly xtreg logvotesperseat Charters i.rating_L1 i.rating_L2 candper i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highFLE==1 & avgFLE!=., fe vce(cluster leaid)
eststo m3
estadd local Subset "HighPoverty"
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Candidates "Yes"
quietly xtreg logvotesperseat Charters i.rating_L1 i.rating_L2 candper i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highFLE==0 & avgFLE!=., fe vce(cluster leaid)
eststo m4
estadd local Subset "LowPoverty"
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Candidates "Yes"
quietly xtreg logvotesperseat Charters i.rating_L1 i.rating_L2 candper i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highBlack==1 & avgBlack!=., fe vce(cluster leaid)
eststo m5
estadd local Subset "HighBlack"
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Candidates "Yes"
quietly xtreg logvotesperseat Charters i.rating_L1 i.rating_L2 candper i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highBlack==0 & avgBlack!=., fe vce(cluster leaid)
eststo m6
estadd local Subset "LowBlack"
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Candidates "Yes"
esttab m1 m2 m3 m4 m5 m6, replace title(Table C2. Effect Heterogeneity: Votes Cast in School Board Elections, 1999-2011) mlabels("ln(V/Seat)" "ln(V/Seat)" "ln(V/Seat)" "ln(V/Seat)" "ln(V/Seat)" "ln(V/Seat)") se keep(Charters) scalars("Subset Subset" "Ratings Ratings" "Trends Trends" "Candidates Candidates") b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variable is the log of total votes cast per open school board seat. Each pair of columns identifies districts that are above or below the median on the district performance index (median = 0.9387), in terms of the proportion of students who qualify for free or reduced price lunch (median = .1536925), and in terms of the proportion of kids who are Black (median = .0126087). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
esttab m1 m2 m3 m4 m5 m6 using "${PATH}\TableC2.tex", replace title(Table C2. Effect Heterogeneity: Votes Cast in School Board Elections, 1999-2011) mlabels("ln(V/Seat)" "ln(V/Seat)" "ln(V/Seat)" "ln(V/Seat)" "ln(V/Seat)" "ln(V/Seat)") se keep(Charters) scalars("Subset Subset" "Ratings Ratings" "Trends Trends" "Candidates Candidates") b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variable is the log of total votes cast per open school board seat. Each pair of columns identifies districts that are above or below the median on the district performance index (median = 0.9387), in terms of the proportion of students who qualify for free or reduced price lunch (median = .1536925), and in terms of the proportion of kids who are Black (median = .0126087). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
estimates clear

*Table C3: Effect Heterogeneity -- Turnout
quietly xtreg ln_turnoutCat2 Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highPI==0 & avgPI!=., fe vce(cluster leaid)
eststo m1
estadd local Subset "LowAchieve"
estadd local Ratings "Yes"
estadd local Trends "Yes"
quietly xtreg ln_turnoutCat2 Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highPI==1 & avgPI!=., fe vce(cluster leaid)
eststo m2
estadd local Subset "HighAchieve"
estadd local Ratings "Yes"
estadd local Trends "Yes"
quietly xtreg ln_turnoutCat2 Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highFLE==1 & avgFLE!=., fe vce(cluster leaid)
eststo m3
estadd local Subset "HighPoverty"
estadd local Ratings "Yes"
estadd local Trends "Yes"
quietly xtreg ln_turnoutCat2 Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highFLE==0 & avgFLE!=., fe vce(cluster leaid)
eststo m4
estadd local Subset "LowPoverty"
estadd local Ratings "Yes"
estadd local Trends "Yes"
quietly xtreg ln_turnoutCat2 Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highBlack==1 & avgBlack!=., fe vce(cluster leaid)
eststo m5
estadd local Subset "HighBlack"
estadd local Ratings "Yes"
estadd local Trends "Yes"
quietly xtreg ln_turnoutCat2 Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highBlack==0 & avgBlack!=., fe vce(cluster leaid)
eststo m6
estadd local Subset "LowBlack"
estadd local Ratings "Yes"
estadd local Trends "Yes"
esttab m1 m2 m3 m4 m5 m6, replace title(Table C3. Effect Heterogeneity: Voter Turnout in Odd-year Elections, 2001-2011) mlabels("ln(Voters)" "ln(Voters)" "ln(Voters)" "ln(Voters)" "ln(Voters)" "ln(Voters)") se keep(Charters) scalars("Subset Subset" "Ratings Ratings" "Trends Trends") b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variable is the log of total voters scaled by the adult population. Each pair of columns identifies districts that are above or below the median on the district performance index (median = 0.9387), in terms of the proportion of students who qualify for free or reduced price lunch (median = .1536925), and in terms of the proportion of kids who are Black (median = .0126087). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
esttab m1 m2 m3 m4 m5 m6 using "${PATH}\TableC3.tex", replace title(Table C3. Effect Heterogeneity: Voter Turnout in Odd-year Elections, 2001-2011) mlabels("ln(Voters)" "ln(Voters)" "ln(Voters)" "ln(Voters)" "ln(Voters)" "ln(Voters)") se keep(Charters) scalars("Subset Subset" "Ratings Ratings" "Trends Trends") b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variable is the log of total voters scaled by the adult population. Each pair of columns identifies districts that are above or below the median on the district performance index (median = 0.9387), in terms of the proportion of students who qualify for free or reduced price lunch (median = .1536925), and in terms of the proportion of kids who are Black (median = .0126087). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
estimates clear

* Table C4. School Board Election Outcomes -- 1999-2011 (low-achieving)
quietly xtreg candper Charters cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highPI==0, fe vce(cluster leaid)
eststo m1
estadd local Ratings "No"
estadd local Trends "No"
quietly xtreg candper Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highPI==0, fe vce(cluster leaid)
eststo m2
estadd local Ratings "Yes"
estadd local Trends "Yes"
quietly xtreg incvoteshr Charters cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highPI==0, fe vce(cluster leaid)
eststo m3
estadd local Ratings "No"
estadd local Trends "No"
quietly xtreg incvoteshr Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highPI==0, fe vce(cluster leaid)
eststo m4
estadd local Ratings "Yes"
estadd local Trends "Yes"
quietly xtreg fracexprtrn Charters cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highPI==0, fe vce(cluster leaid)
eststo m5
estadd local Ratings "No"
estadd local Trends "No"
quietly xtreg fracexprtrn Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=1999 & year<=2011 & odd==1 & SBsamp==1 & highPI==0, fe vce(cluster leaid)
eststo m6
estadd local Ratings "Yes"
estadd local Trends "Yes"
esttab m1 m2 m3 m4 m5 m6, replace title(Table C4. Odd-year Election Outcomes for Districts with Low-Achieving Students) mlabels("CandPer" "CandPer" "VoteShare" "VoteShare" "Return" "Return") se keep(Charters) scalars("Ratings Ratings" "Trends Trends") b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variables are counts of candidates per seat (columns 1-2), the vote share of incumbents running for re-election (columns 3-4), and the fraction of incumbents who return to the board the following year (columns 5-6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
esttab m1 m2 m3 m4 m5 m6 using "${PATH}\TableC4.tex", replace title(Table C4. Odd-year Election Outcomes for Districts with Low-Achieving Students) mlabels("CandPer" "CandPer" "VoteShare" "VoteShare" "Return" "Return") se keep(Charters) scalars("Ratings Ratings" "Trends Trends") b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variables are counts of candidates per seat (columns 1-2), the vote share of incumbents running for re-election (columns 3-4), and the fraction of incumbents who return to the board the following year (columns 5-6). All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
estimates clear


*** APPENDIX D: Additional Analyses
xtset dirn year
*Table D1: Check the even-year "repeat voter" result 
*	NOTE: It appears to be noise
quietly xtreg ln_TandTm2 Charters F.Charters L.Charters i.rating_L1 i.rating_L2 cy_* if year>=2005 & year<=2011 & SBsamp==1 & odd==0, fe vce(cluster leaid)
eststo m1
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Years "Even"
quietly xtreg ln_TandTm2 Charters F.Charters L.Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=2005 & year<=2011 & SBsamp==1 & odd==0, fe vce(cluster leaid)
eststo m2
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Years "Even"
quietly xtreg ln_TandTm2 int_oddchar F.int_oddchar L.int_oddchar Charters F.Charters L.Charters i.rating_L1 i.rating_L2 i.leaid#c.year cy_* if year>=2005 & year<=2011 & SBsamp==1, fe vce(cluster leaid)
eststo m3
estadd local Ratings "Yes"
estadd local Trends "Yes"
estadd local Years "All"
esttab m1 m2 m3, replace title(Table D1. Repeat Voters in Even Years) mlabels("ln(Repeat)" "ln(Repeat)" "ln(Repeat)") se keep(int_oddchar Charters int* L* F*) scalars("Ratings Ratings" "Trends Trends" "Years Years") b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variable is the number of voters who also voted in the previous election. All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
esttab m1 m2 m3 using "${PATH}\TableD1.tex", replace title(Table D1. Repeat Voters in Even Years) mlabels("ln(Repeat)" "ln(Repeat)" "ln(Repeat)") se keep(int_oddchar Charters int* L* F*) scalars("Ratings Ratings" "Trends Trends" "Years Years") b(a2) star(* 0.10 ** 0.05 *** 0.01) note("Note: The dependent variable is the number of voters who also voted in the previous election. All models include commuting-zone-by-year and district fixed effects. Standard errors clustered by district are in parentheses below the coefficient estimates.") compress
estimates clear
