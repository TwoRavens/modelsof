


********************************************************************************
********************************************************************************
**
** Create tables from "Some Simple Tests of Rational Voting and Agenda-Setting"
** Sean Corcoran, Thomas Romer, and Howard Rosenthal
**
** Last update: July 30, 2014
**
********************************************************************************
********************************************************************************

** NOTE TO USER: this program must be run in its entirety to correctly replicate
** the results reported in the paper.

* The data used in this paper come from the Oregon Summary of School District
* Financial Elections publications for 1980, 1981, 1982 and 1983. The unit of 
* observation is a school district, election, and year. Only regular districts
* are included in the data (Educational Service Districts, or ESDs, are dropped)
* and only regular financial elections are retained (in this period, A ballot,
* B ballot, or combination). The variable election_type indicates the type of
* budget election. 

cd "C:\Users\sc129\Dropbox\_PROJECTS\Oregon A&B\Results\Replication files"
use "CRR_Simple_Tests_2014.dta"
sort ncesid year edate
tabulate year election_type,miss

* shows the number of unique school districts per year:
preserve
duplicates drop ncesid year,force
table year
restore

* some manual adjustments
*   Brookings Harbor 1981 and 1982 - first election (B only) pertained to prior yr
replace year=1980 if ncesid==4102310 & election_number==1 & year==1981 & amount==619278
replace year=1981 if ncesid==4102310 & election_number==4 & year==1982 & amount==462531
*   Sherman UH1 1981 - of two A elections, one should be a B
replace election_type="B ballot" if ncesid==4111250 & election_number==1 & year==1981 & amount==62138
*   Tygh Valley 1981 - of two A elections, one should be a B
replace election_type="B ballot" if ncesid==4112510 & election_number==1 & year==1981 & amount==30000


********************************************************************************
* Create indicators of election type, counts of elections by district-year, and
* other needed variables
********************************************************************************

gen A = election_type=="A ballot"
gen B = election_type=="B ballot"
gen C = election_type=="Combination"

egen countA = sum(A), by(ncesid year)
egen countB = sum(B), by(ncesid year)
egen countC = sum(C), by(ncesid year)

egen countAdate = sum(A), by(ncesid year edate)
egen countBdate = sum(B), by(ncesid year edate)
egen countCdate = sum(C), by(ncesid year edate)

label var A "=1 if election is A ballot"
label var B "=1 if election is B ballot"
label var C "=1 if election is Combination"

label var countA "count of A ballots this year"
label var countB "count of B ballots this year"
label var countC "count of Combination this year"

label var countAdate "count of A ballots this election day"
label var countBdate "count of B ballots this election day"
label var countCdate "count of Combination this election day"

gen simAB = countAdate>0 & countBdate>0
egen temp1 = tag(ncesid year edate simAB) if simAB==1
egen countABsim = sum(temp1), by(ncesid year)
drop temp1

label var simAB "=1 if simultaneous A&B held this election day"
label var countABsim "count of simultaneous A&B ballots this election day"

gen pctno = (votes_no/(votes_yes + votes_no))*100
label var pctno "percent voting no"

* compute the difference in A & B votes when held on same date
* note: if there are multiple Bs on the same date, take the lowest vote no
gen temp1 = pctno if simAB==1 & B==1
gen temp2 = pctno if simAB==1 & A==1
egen pctnoB1 = min(temp1), by(ncesid edate)
egen pctnoA1 = max(temp2), by(ncesid edate)
drop temp*

gen temp1 = pctno if simAB==1 & countBdate==1 & B==1
gen temp2 = pctno if simAB==1 & countBdate==1 & A==1
egen pctnoB2 = max(temp1), by(ncesid edate)
egen pctnoA2 = max(temp2), by(ncesid edate)
drop temp*

gen chg1 = pctnoB1 - pctnoA1
gen chg2 = pctnoB2 - pctnoA2
label var chg1 "change in % voting no on B vs A"
label var chg2 "change in % voting no on B vs A (only one B election held)"


***********
* Table 1 *
***********

* keep only one observation per district per year
preserve
duplicates drop ncesid year, force

* districts that held any type of A, B, or Combination election
table year if countA>0 | countB>0 | countC>0

* held at least one A & B election and no Combination
table year if (countA>0 & countB>0) & countC==0

* held A elections only
table year if countA>0 & countB==0 & countC==0

* held B elections only
table year if countA==0 & countB>0 & countC==0

* held mix of A & B elections and a Combination
table year if (countA>0 | countB>0) & countC>0

* held Combination elections only
table year if countA==0 & countB==0 & countC>0
restore


***********
* Table 2 *
***********

* keep only one observation per district per year
preserve
duplicates drop ncesid year, force

* Row 1: unique districts holding simultaneous A & B elections
table year if countABsim>0

* Row 2: unique districts holding combination elections
table year if countC>0
restore

* keep only one observation per district-election-year
preserve
duplicates drop ncesid edate, force

* Row 3: district-elections with A & B on the same day
table year if simAB>0

* Row 4: district-elections with A & single B on the same day
table year if simAB>0 & countBdate==1
restore

* Row 5: district-elections with A & B on the same day and the
* (lowest) percent voting NO on B is >= the percent voting NO on A
* First keep only one observation per district-election-year
preserve
duplicates drop ncesid edate, force
table year if simAB>0 & (pctnoB1>=pctnoA1) & pctnoB1~=.

* Row 6: district-elections with A & single B on the same day
* and the percent voting NO on B is >= the percent voting NO on A
table year if simAB>0 & countBdate==1 & (pctnoB2>=pctnoA2) & pctnoB2~=.

* Row 9: average increase in percent voting NO if increase >0
tabstat chg1 if chg1>0, by(year) stat(mean n)
tabstat chg2 if chg2>0, by(year) stat(mean n)

* FN 12 - districts with no change between A and B vote
list ncesid taxing_district year votes_yes votes_no if (pctnoB1==pctnoA1) & pctnoA1~=.,noobs
restore

* FN 14 - tests for differences in proportions
prtesti 213 77 174 23, count  /* 1980 vs. 1982 */
prtesti 213 77 167 32, count  /* 1980 vs. 1983 */
prtesti 181 115 174 23, count /* 1981 vs. 1982 */
prtesti 181 115 167 32, count /* 1981 vs. 1983 */


***********
* Table 3 *
***********

* keep only districts that had an election in 1981 OR 1982
preserve
gen temp1 = (countA>0 | countB>0 | countC>0) if year==1981
gen temp2 = (countA>0 | countB>0 | countC>0) if year==1982
egen temp3 = max(temp1), by(ncesid)
egen temp4 = max(temp2), by(ncesid)
keep if temp3==1 | temp4==1

* keep only first election observation
sort ncesid year edate election_type
duplicates drop ncesid year, force

* retain information about first election in 1982
gen temp5 = election_type if year==1982
gen temp6 = simAB if year==1982
egen election_type82 = mode(temp5), by(ncesid)
egen simAB82 = max(temp6), by(ncesid)

* keep only district observations in 1981
keep if year==1981

* Total column for 1981
tabulate election_type simAB , miss

* 1982 election type by first election type in 1981
tabulate election_type82 simAB82 if A==1 & simAB==1, miss cell
tabulate election_type82 simAB82 if A==1 & simAB~=1, miss cell
tabulate election_type82 simAB82 if B==1 & simAB~=1, miss cell
tabulate election_type82 simAB82 if election_type=="", miss cell
restore


***********
* Table 4 *
***********

* keep only elections in 1982 or 1983, and only instances of combination
* elections or simultaneous A & B elections (where there was only one of each)
preserve
keep if year==1982 | year==1983
keep if C==1 | (A==1 & simAB==1 & countAdate==1 & countBdate==1)
sort ncesid year edate
by ncesid year: gen eleccount=_n

* enrollment categories
gen enrlcat = 1 if adm>=2000 & adm~=.
replace enrlcat = 2 if adm>=200 & adm<2000 
replace enrlcat = 3 if adm<200
replace enrlcat = 4 if adm==.
tabulate enrlcat, miss

* count of combination elections by enrollment category
table enrlcat year if C==1,row

* count of A&B split (simultaneous) elections by enrollment category
table enrlcat year if A==1 & simAB==1,row

* do the same by attempt #
sort eleccount
by eleccount: table enrlcat year if C==1, row
by eleccount: table enrlcat year if A==1 & simAB==1, row

*gsort year eleccount -adm ncesid edate 
*list year adm ncesid edate election_type eleccount A B simAB C, sep(0) noobs

restore


***********
* Table 5 *
***********

* keep only one observation per district per year
preserve
duplicates drop ncesid year, force

* Row 1: unique districts holding simultaneous A & B elections
table year if countABsim>0
restore

* retain B votes when simultaneous A & B election is held
* keep only one observation per district-election-year
preserve
gen votes = votes_yes + votes_no
gen temp1 = votes if simAB==1 & B==1
egen votesB = max(temp1), by(ncesid edate)

gsort ncesid edate -A
duplicates drop ncesid edate, force

* Row 2: district-elections with A & B on the same day
table year if simAB>0

* Rows 3-5: count of elections by # voting on B vs. # voting on A
table year if votes > votesB & simAB==1 & A==1
table year if votes == votesB & simAB==1 & A==1
table year if votes < votesB & simAB==1 & A==1

* Row 6: district-elections with A & single B on the same day
table year if simAB>0 & countBdate==1

* Rows 7-9: count of elections by # voting on B vs. # voting on A
table year if votes > votesB & simAB==1 & A==1 & countBdate==1
table year if votes == votesB & simAB==1 & A==1 & countBdate==1
table year if votes < votesB & simAB==1 & A==1 & countBdate==1
restore

* Row 10: binomial tests

bitesti 84 59 0.5
bitesti 156 100 0.5
bitesti 21 17 0.5
bitesti 37 27 0.5

* Probit model: relating choice of Combination to district size
* keep only one observation per district-election-year, and only
* districts that had an A, B, or Combination election
preserve
sort year ncesid edate
duplicates drop ncesid year, force
keep if simAB==1 | countCdate==1
probit C adm if year==1982
probit C adm if year==1983

