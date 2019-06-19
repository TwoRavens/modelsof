* this do file generates the results in Table 3 and Figure 1 from Siminski (2013) 'Employment Effects of Army Service and Veterans’ Compensation: Evidence from the Australian Vietnam-Era Conscription Lotteries' The Review of Economics and Statistics 95(1): 87–97


*************************************************************************************************************************************************************
******************************************************* Table 3 Upper Panel Dependent variable: Employed in 2006 ********************************************

**************** DATA PREPARATION
* the (main) second stage database is a frequency weighted file of men (at 2006) in each combination of birth cohort, ballot outcome (binary) and employment - after excluding all immigrants who arrived after the age of 20
use second_stage_employ_census, clear

* merge on predicted values from 1st stage
merge m:1 cohort ballot using predicted_1st_stage
drop _merge

* generate birth cohort dummies 
tabulate cohort, gen(c)

* interact pvet with age-elgibility for service pension
g pvetser = pvet * max(c1, c2, c3)

* include a crude proxy of combat intensity (proportion of Vietnam Army Servicemen who died in Vietbam by birth cohort) - these were calculated from restricted access Nominal Roll data
g pdeath = 0			
replace pdeath = 	0.017513135	 if c1 == 1
replace pdeath = 	0.010702341	 if c2 == 1
replace pdeath = 	0.012887636	 if c3 == 1 
replace pdeath = 	0.017453799	 if c4 == 1 
replace pdeath = 	0.007643735	 if c5 == 1 
replace pdeath = 	0.014577259	 if c6 == 1 
replace pdeath = 	0.011739594	 if c7 == 1 
replace pdeath = 	0.010647737	 if c8 == 1 
replace pdeath = 	0.006105539	 if c9 == 1 
replace pdeath = 	0.005003574	 if c10 == 1 
replace pdeath = 	0.004703669	 if c11 == 1 
replace pdeath = 	0.011976048	 if c12 == 1 
replace pdeath = 	0.004219409	 if c13 == 1 
replace pdeath = 	0.003246753	 if c14 == 1 
replace pdeath = 	0	 		 if c15 == 1 
replace pdeath = 	0	 		 if c16 == 1 

*rescale to have a mean of zero and a range of 1
sum pdeath [fw=fweight]
replace pdeath = (pdeath - r(mean)) / (r(max) - r(min))

* interact with the endogenous Vietnam veteran status variable
g pd1 = pdeath*pvet
tempfile temp
save `temp'

**************** Generate Results
* Column (1)
quietly reg emp parm2 c2-c16 [fw=fweight], robust
est store emp1

* Column (2)
quietly reg emp pvet2 c2-c16 [fw=fweight], robust
est store emp2

* Column (3)
quietly reg emp parm c2-c16 [fw=fweight], robust
est store emp3

* Column (4)
quietly reg emp pvet c2-c16 [fw=fweight], robust
est store emp4

* Column (5)
quietly reg emp parm pvet c2-c16 [fw=fweight], robust
est store emp5

* Column (6)
quietly reg emp parm pvet pvetser c2-c16 [fw=fweight], robust
est store emp6

* Column (7)
quietly reg emp parm pvet pvetser pd1 c2-c16 [fw=fweight], robust
est store emp7

** Now, to perform the OVERID tests (see Angrist & Pischke p143-4 & equation 4.1.16) - need to use grouped data - ie need one (frequency weighted) record for each cohort-ballot outcome combination:
g dummy = 1
collapse (mean) parm pvet emp pvetser pd1 c2-c16 (sum) fweight = dummy [fw=fweight], by(cohort ballot)

* OVERID test for column (3)
reg emp parm c2-c16 [fw=fweight]
display e(rss)
* The test statistic is 32.18 distributed as chi squared with with degrees of freedom equal to the degree of overidentification - in this case d.o.f = 15
* p =0.006

* OVERID test for column (4)
reg emp pvet c2-c16 [fw=fweight]
display e(rss)
* The test statistic is 3.362 distributed as chi squared with with d.o.f = 15
* p =0.999

* OVERID test for column (5)
reg emp parm pvet c2-c16 [fw=fweight]
display e(rss)
* The test statistic is 3.354 distributed as chi squared with with d.o.f = 14
* p = 0.998

* OVERID test for column (6)
reg emp parm pvet pvetser c2-c16 [fw=fweight]
display e(rss)
* The test statistic is 1.783 distributed as chi squared with with d.o.f = 13
* p = 0.9999

* OVERID test for column (7)
reg emp parm pvet pvetser pd1 c2-c16 [fw=fweight]
display e(rss)
* The test statistic is 1.720 distributed as chi squared with with d.o.f = 12
* p = 0.9997




******************************************************************************************************************************************************************************
******************************************************* Lower Panel Dependent variable: Disability Pension (Special Rate) in 2006 ********************************************


**************** DATA PREPARATION
* this second stage database is a frequency weighted file of men (with different weights representing counts at various points in time) in each combination of birth cohort, ballot outcome (binary) and receipt of disability pension (special rate) at 2006  - after excluding all immigrants who arrived after the age of 20
use second_stage_dis_pension, clear

* merge on predicted values from 1st stage
merge m:1 cohort ballot using predicted_1st_stage
drop _merge

* generate birth cohort dummies 
tabulate cohort, gen(c)

* interact pvet with age-elgibility for service pension
g pvetser = pvet * max(c1, c2, c3)

* include a crude proxy of combat intensity (propoprtion of Vietnam Army Servicemen who died in Vietbam by birth cohort) - these were calculated from restricted access Nominal Roll data
g pdeath = 0			
replace pdeath = 	0.017513135	 if c1 == 1
replace pdeath = 	0.010702341	 if c2 == 1
replace pdeath = 	0.012887636	 if c3 == 1 
replace pdeath = 	0.017453799	 if c4 == 1 
replace pdeath = 	0.007643735	 if c5 == 1 
replace pdeath = 	0.014577259	 if c6 == 1 
replace pdeath = 	0.011739594	 if c7 == 1 
replace pdeath = 	0.010647737	 if c8 == 1 
replace pdeath = 	0.006105539	 if c9 == 1 
replace pdeath = 	0.005003574	 if c10 == 1 
replace pdeath = 	0.004703669	 if c11 == 1 
replace pdeath = 	0.011976048	 if c12 == 1 
replace pdeath = 	0.004219409	 if c13 == 1 
replace pdeath = 	0.003246753	 if c14 == 1 
replace pdeath = 	0	 		 if c15 == 1 
replace pdeath = 	0	 		 if c16 == 1 

*rescale to have a mean of zero and a range of 1
sum pdeath [fw=fwt06]
replace pdeath = (pdeath - r(mean)) / (r(max) - r(min))

* interact with the endogenous Vietnam veteran status variable
g pd1 = pdeath*pvet

**************** Generate Results
* Column (1)
quietly reg dpsr parm2 c2-c16 [fw=fwt06], robust
est store dis1

* Column (2)
quietly reg dpsr pvet2 c2-c16 [fw=fwt06], robust
est store dis2

* Column (3)
quietly reg dpsr parm c2-c16 [fw=fwt06], robust
est store dis3

* Column (4)
quietly reg dpsr pvet c2-c16 [fw=fwt06], robust
est store dis4

* Column (5)
quietly reg dpsr parm pvet c2-c16 [fw=fwt06], robust
est store dis5

* Column (6)
quietly reg dpsr parm pvet pvetser c2-c16 [fw=fwt06], robust
est store dis6

* Column (7)
quietly reg dpsr parm pvet pvetser pd1 c2-c16 [fw=fwt06], robust
est store dis7


** Now, to perform the OVERID tests (see Angrist & Pischke p143-4 & equation 4.1.16) - need to use grouped data - ie need one (frequency weighted) record for each cohort-ballot outcome combination:
g dummy = 1
collapse (mean) parm pvet dpsr pvetser pd1 c2-c16 (sum) fwt06 = dummy [fw=fwt06], by(cohort ballot)

* OVERID test for column (3)
reg dpsr parm c2-c16 [fw=fwt06]
display e(rss)
* The test statistic is 67.24 distributed as chi squared with with degrees of freedom equal to the degree of overidentification - in this case d.o.f = 15
* p < 0.001

* OVERID test for column (4)
reg dpsr pvet c2-c16 [fw=fwt06]
display e(rss)
* The test statistic is 1.86 distributed as chi squared with with d.o.f = 15
* p > 0.999

* OVERID test for column (5)
reg dpsr parm pvet c2-c16 [fw=fwt06]
display e(rss)
* The test statistic is 1.84 distributed as chi squared with with d.o.f = 14
* p > 0.999

* OVERID test for column (6)
reg dpsr parm pvet pvetser c2-c16 [fw=fwt06]
display e(rss)
* The test statistic is 1.61 distributed as chi squared with with d.o.f = 13
* p > 0.9999

* OVERID test for column (7)
reg dpsr parm pvet pvetser pd1 c2-c16 [fw=fwt06]
display e(rss)
* The test statistic is 0.69 distributed as chi squared with with d.o.f = 12
* p > 0.999

esttab emp* using Table3.rtf, b(%8.4f) se(%8.4f) parentheses  scalar(N) mtitles compress replace keep(parm2 pvet2 parm pvet pvetser pd1)
esttab dis* using Table3.rtf, b(%8.4f) se(%8.4f) parentheses  scalar(N) mtitles compress append keep(parm2 pvet2 parm pvet pvetser pd1)

********************************************************************************************************************************************
***************************************************** ESTIMATES FOR FIGURE 1 ***************************************************************

use `temp', clear
forvalues bcohort = 1/15 {
	reg emp parm [fw=fweight] if c`bcohort' == 1, robust
}
forvalues bcohort = 1/11 {
	reg emp pvet [fw=fweight] if c`bcohort' == 1, robust
}

