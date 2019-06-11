/*

odd = treatment group
block = treatment period (1 = pretreatment)
group = sample and non-sample groups.
vebli = veloblitz vs flash (== 1 is vebli, the firm where experiment took place, 0 is other firm)
tag = appears to be Monday through Friday

*/             

*****************************************************

*Preparing treatment vector
*Some confusion in data file:  fahrer 7 and 10 do not have "odd" (treatment) value in tables5to6 file.
*But, they are both listed as having received treatment at some point in that file (check maxhigh & high)
*This does not affect those regressions since odd is not used
*Their coding of high indicates odd was actually 0.
*In sum, their treatment is not coded (odd == .) but data file is consistent with treatment odd == 0

*In tables1to4, individual 7 has odd value, but individual 10 does not.
*In this table, individual 10 listed as always not treated, (i.e. neither odd 1 nor 0) even though indicated as treated in tables5to6.
*When I randomize treatment (using full treatment vector for all individuals involved in experiment)
*will set individual 10 as always not treated whatever their odd outcome in the randomization
*This is consistent with the coding error in the file

*There is also a coding error in tables5to6 with regard to whether high occurs for odd on a particular date 
*Will reproduce this coding error as well


use tables1to4, clear
keep if maxhigh == 1
collapse (mean) odd, by(fahrer) fast
sort fahrer odd
save a, replace

use tables5to6, clear
tab fahrer high if odd == .
*these observations are given treatment but not listed in treatment group
tab block high if odd == 0
tab block high if odd == 1
tab block high if odd == .
replace odd = 0 if odd == .
collapse (mean) odd, by(fahrer) fast
sort fahrer odd
merge fahrer odd using a
tab _m
list if _m < 3
sort fahrer odd
drop _m
sort fahrer odd
mkmat odd fahrer, matrix(Y)
*This is all individuals who received treatment


*******************************************

*Replication - following their code

use tables1to4,clear

*This is their code for Table 1 
 table odd block if maxhigh==1 & block==1 , c(mean totrev sd totrev mean shifts sd shifts N shifts) 
 table group block , c(mean totrev sd totrev mean shifts sd shifts N shifts) 

*This is their code for Table 2
 table odd block if maxhigh==1 & block==1 , c(mean totrev_fe sd totrev_fe) 
 table group block , c(mean totrev_fe sd totrev_fe N totrev) 

*In all cases I find it impossible to reproduce the standard errors reported in the tables (no code provided)
*For example, from table 1
reg totrev odd if maxhigh==1 & block==2
*Matches mean difference, but s.e. completely wrong
*Completely unclear what statistical procedure they are using to determine s.e. of differences
*For other tables they provide a statistical procedure

*Table 3 - rounding errors, large coefficient error column 3, column 6 multiple errors (although code for regression appears correct, R2 is exactly right, coefficients similar)
areg totrev high block2 block3 if maxhigh==1, absorb(fahrer) cluster(fahrer)
areg totrev high block2 block3 if vebli==1, absorb(fahrer) cluster(fahrer)
areg totrev high exp block2 block3, absorb(fahrer) cluster(fahrer) 
areg shifts high block2 block3 if maxhigh==1, absorb(fahrer) cluster(fahrer)
areg shifts high block2 block3 if vebli==1, absorb(fahrer) cluster(fahrer)
areg shifts high exp block2 block3, absorb(fahrer) cluster(fahrer)

svmat Y
save DatFG1, replace


**********************************
 
*Reproducing results - All following their code

use tables5to6, clear


*Table 5 - paper misreports as clustered on messenger, actually clustered on date (= datum)

areg lnum high lnten female if fixed==1 & maxhigh==1 & fahrer!=27 & tag!=0 & tag!=6 , absorb(datum) cluster(datum) 
areg lnum high lnten f2 - f38 if fixed==1 & maxhigh==1 & fahrer!=27 & tag!=0 & tag!=6 , absorb(datum) cluster(datum) 

*Table 6 - rounding errors (or slightly more), misreports R2, incorrectly indicates clustered on messengers when actually clustered on date

areg lnum high_la high_not lnten f2 - f38 if fixed==1 & maxhigh==1 & fahrer!=27 & tag!=0 & tag!=6 , absorb(datum) cluster(datum) 
areg lnum high_la1 high_la2 high_not0 lnten f2 - f38 if fixed==1 & maxhigh==1 & fahrer!=27 & tag!=0 & tag!=6 , absorb(datum) cluster(datum) 

*Actually none of the conditionals in the regressions matter, as satisfied for all observations

tab block high if odd == 0
tab block high if odd == 1
tab fahrer datum if block == 2 & odd == 1 & high == 0
*Systematic error in coding
egen t = group(datum)
tab fahrer t if block == 2 & odd == 1 & high == 0
tab high if t == 29, nolabel

foreach i in la la1 la2 not0 {
	egen `i' = max(high_`i'), by(fahrer)
	}

svmat Y
drop f1-f38
tab fahrer, gen(fdum)
drop fdum1
save DatFG2, replace


******************

use tables1to4, clear
sort fahrer
drop if fahrer == fahrer[_n-1]
keep fahrer
sort fahrer
generate N = _n
save Sample1, replace
*All of these individuals are used in regressions part 1

use tables5to6, clear
sort fahrer
drop if fahrer == fahrer[_n-1]
keep fahrer
sort fahrer
merge fahrer using Sample1
tab _m

capture erase a.dta
drop _all






