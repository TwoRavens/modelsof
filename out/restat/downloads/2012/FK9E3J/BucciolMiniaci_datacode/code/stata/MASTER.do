* MASTER.do FILE

* This do-file combines the Matlab data files to create the figures and tables shown in the paper

* Alessandro Bucciol (alessandro.bucciol@univr.it)
* University of Verona
* March 2010

********************************************************************



cd "D:\Research\Risk preference\code\stata"

* Use the command
do micro /* to convert the data in Stata format, and merge them in only one dataset */
do micro_confInt

do rtol_selfass /* Table 4 */
do reg_rtol /* Tables 5, 7, S1, S3, S5, S7, S9, S11 */



********************************************************************
* Use the lines below to get the empirical distribution,
* Use it in Matlab with the program 'empdistr.m'.

use "..\..\data\benchmark\micro.dta"
cumul rtol0 if rtol0!=. [fw = int(x42001)], generate(emprtol0)
cumul rtol1 if rtol1!=. [fw = int(x42001)], generate(emprtol1)
cumul rtol2 if rtol2!=. [fw = int(x42001)], generate(emprtol2)
cumul rtol3 if rtol3!=. [fw = int(x42001)], generate(emprtol3)
sort emprtol0
bro rtol0 emprtol0 x42001
sort emprtol2
bro rtol2 emprtol2 x42001
sort emprtol3
bro rtol3 emprtol3 x42001

cumul bias0_ if bias0_!=. [fw = int(x42001)], generate(empbias0)
cumul bias1_ if bias1_!=. [fw = int(x42001)], generate(empbias1)
cumul bias2_ if bias2_!=. [fw = int(x42001)], generate(empbias2)
cumul bias3_ if bias3_!=. [fw = int(x42001)], generate(empbias3)
sort empbias0
bro bias0_ empbias0 x42001
sort empbias2
bro bias2_ empbias2 x42001
sort empbias3
bro bias3_ empbias3 x42001


********************************************************************
* Measure correlation among estimates

use "..\..\data\benchmark\micro.dta"
pwcorr rtol0 rtol1 rtol2 rtol3 [fw = int(x42001)]
rename rtol0 rtol0_bench
rename rtol1 rtol1_bench
rename rtol2 rtol2_bench
rename rtol3 rtol3_bench

sort id
merge id using "..\..\data\robustness_10y\micro.dta"
merge id using "..\..\data\robustness_60obs\micro.dta"
merge id using "..\..\data\robustness_nom\micro.dta"
merge id using "..\..\data\robustness_realw\micro.dta"
merge id using "..\..\data\benchmark_no_otherrealestate\micro.dta"

pwcorr rtol0 rtol0_bench [fw = int(x42001)]
pwcorr rtol1 rtol1_bench [fw = int(x42001)]
pwcorr rtol2 rtol2_bench [fw = int(x42001)]
pwcorr rtol3 rtol3_bench [fw = int(x42001)]
