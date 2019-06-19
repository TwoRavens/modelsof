/*This .do file produces the unadjusted and Bonferroni-adjusted p-values
 in Table 2 in Bitler, Gelbach, and Hoynes (2016) "Can Variation in Subgroups' 
 Average Treatment Effects Explain Treatment Effect Heterogeneity? Evidence 
 from a Social Experiment" */

*** Purpose of code: use CDF space to test
*** Per JG Praastgaard paper
*** Using within subgroup test, canning weighting
*** Test on our data from QTEs, use simulated Yi and y0 within subgroup
*** Permutation test
**  Real data steps 	1) estimate real data mean difference betahat
**			 within subgroups/qtrs
**	      		2) create simulated treatment (control + betahat) within subgroup
**			4) real data KS =
**			 max(|CDF real treatment - CDF simulated treatment|) within subgroup
**
** Permutation test steps 1) 2999 times, create permuted group,
**			    calculated permuted betahat within subgroups/qtrs
**			 2) create simulated treatment (control + betahat) within subgroup
**			 3) perm data KS = 
**			   max(|CDF fake treatment group - 
**				CDF fake simulated treatment|)
**				within subgroups
**			  
 
clear
clear matrix
set mem 6500m

use data-final.dta, clear
keep if quarter >=1 & quarter<=7
cap gen byte fullsample = 1

set seed 10203

local racevars "white black hisp othmsrac"
local edvars   "gtehsged nohsged misshsged"
local ykidvars "ykidlt6 ykidge6 missykidlt6"
local whvars   "anyadcpq7 noadcpq7"
local ehvars   "anyernpq7 noernpq7"
local mhvars   "martogapt marnvr missmarnvr"
local nkvars   "kidctlt2 kidctge2 misskidctgt2"
local allvars  "fullsample"
local pq7evars  "ernpq7hi ernpq7lo vernpq70"
local npqevars "npqern0 npqernlo npqernhi"

egen race = group(`racevars')
egen ed   = group(`edvars')
egen ykid = group(`ykidvars')
egen eh = group(`ehvars')
egen wh = group(`whvars')
egen mh = group(`mhvars')
egen nk = group(`nkvars')
egen all = group(`allvars')
egen pq7e = group(`pq7evars')
egen npqe = group(`npqevars')

global list "pq7e npqe ed wh ykid mh"
global sglist "$list"
forvalues i=1/7 {
	local iplus1 = `i'+1
	local var1 : word `i' of $list

	forvalues j=`iplus1'/7 {
		local var2 : word `j' of $list
		*di "var1 var2 = '`var1' `var2''"
		egen `var1'_`var2' = group(``var1'vars' ``var2'vars')
		global sglist "$sglist `var1'_`var2'"
	}
}

**** Add in all at front
global sglist "all $sglist race"
qui di "$sglist"

*************************************************************
**** Next chunk of code to collapse really small cells    ***
*************************************************************
**** Pool missing one and missing the other kids all together
capture tab mh_nk
capture recode mh_nk (2=1) (3=1) (4=2) (5=3) (6=4) (7=5)
capture tab mh_nk

**** missmarnvr most likely missing ykid too
*** combine all with missmarnvr==1 (some of missykid)
capture tab ykid_mh
capture recode ykid_mh (2=1) (3=2) (4=3) (5=1) (6=4) (7=5)
capture tab ykid_mh

**** Fix small cells for ed_mh
**** collapse all missings
capture tab ed_mh
capture recode ed_mh (2=1) (3=1) (4=1) (7=1) (5=2) (6=3) (8=4) (9=5)
capture tab ed_mh

**** Fix small cells for npqe_ykid
**** collapse all missings for ykid
capture tab npqe_ykid
capture recode npqe_ykid (4=1) (7=1) (5=4) (6=5) (8=6) (9=7)
capture tab npqe_ykid

**** Fix small cells for wpq7lev_ed
*** cells 2 5 7
*** 2 is pwagpq7hi and nohsged 9 people
*** 5 is pwagpq7lo and nohsged 18 people
*** 7 is pwagpq70 and misshsged 5 people
*** combine the pwagepq7 and nohsged 2 and 5 with other nohsged 8
*** combine misshsged and pwagpq70 7 with missgsged & pwagpq7lo 4
capture tab wpq7lev_ed
capture recode wpq7lev_ed (5=2) (8=2) (7=4) (6=5) (9=6) 
capture tab wpq7lev_ed

**** Fix small cells for wpq7lev_mh
*** cells 1 4 7 missing married, and low, med hi
*** 1 is low and missing, 4 is med and misisng, 7 is hi and missing
*** collapse 4 and 7 (missing hi with missing medium)
capture tab wpq7lev_mh
capture recode wpq7lev_mh (7=4) (8=7) (9=8)
cap tab wpq7lev_mh

*************************************************************
**** End of code to collapse really small cells           ***
*************************************************************
** Show sglist
de $sglist

** Tab cells
for any $sglist: tab X if quarter == 1

**** Create a small data set to pull in
*** only keep data and quarters we need
keep $sglist ernq quarter e
keep if quarter>=1 & quarter<=7
save data-real-all-with-sg-pgard-resample, replace

******************************************************************************
*** Start of loop, runs once to get data and do testing for each subgroup  ***
*** First does real data and then "permutation" of fake data then testing   ***
******************************************************************************
* took out wpq7levm $sqlist
foreach varname in all pq7e npqe ed wh ykid mh race pq7e_npqe pq7e_ed pq7e_wh pq7e_ykid ///
	pq7e_mh npqe_ed npqe_wh npqe_ykid npqe_mh ed_mh ed_wh ed_ykid wh_mh wh_ykid ykid_mh {

	di ""
	di "Starting loop for varname `varname'"
	di ""

	/* start of quietly loop */
	qui {

	* Pull in ** positive ** values
	use data-real-all-with-sg-pgard-resample if ernq>0, clear

	** Create quarter by subgroup variable
	egen sgvar = group(`varname' quarter)

	** Create dummies for quarter by group below in regressions
	tab sgvar, gen(sgvardm)

	* Tab sgvar to get number of subgroups and quarters
	tab sgvar

	** Save local numsg is number of subgroups and quarters
	local numsg = _result(2)
	** Check value of number of subgroups 
	di "numsg `numsg'"

	** Only keep stuff we need
	** `varname' is name of subgroups
	keep `varname' quarter sgvar* ernq e

	** Betahat is going to contain mean subgroup by qtr treatment control difference
	gen double betahat = .

	*** Run regressions by subgroup and qtr to get mean effect by subgroup and qtr
	forvalues s = 1 / `numsg' {
		*** OlS to get conditional mean difference
		reg ernq e if sgvar == `s' & ernq > 0 
		* Save betahats for later for each subgroup and qtr
		replace betahat = _b[e] if sgvar == `s' & ernq > 0 
		} /* end of numsg loop */	

	** Create real data variables for simulated and true treatment group values

	* The simulated treatment variable is earnings plus treatment-control 
	*  mean difference for control group
	gen double yisim = ernq + betahat if e == 0 & ernq > 0 

	* The true treatment group variable is earnings for treatment group
	gen double yitrue = ernq if e == 1 & ernq > 0 

	*** Check means are the same for yisim, yitrue 
	** for first subgroup/quarter group
	** Control group yisim
	*di "Should be same means within first subgroup/quarter"
	*noi su yisim ernq if e == 0 & ernq > 0 & sgvar==1 
	*** Treatment group yitrue
	*noi su yitrue ernq if e == 1 & ernq > 0 & sgvar==1 

	*** This is real data calculation, so realdata dummy is 1, bsrep is 0
	gen realdata=1
	gen bsrep=0

	** Save real data results
	** keep only what we need
	keep if ernq > 0
	keep yisim yitrue e realdata bsrep `varname' quarter sgvar
	save results/nobs-test-ourdata-pgard-resample-`varname', replace

	noi di "About to start permutations"
	*** do 2999 times
	* cabp is number of bsreps
	local capb = 2999

	** start of permutation loop
	forvalues bsrep= 1/`capb' {

		*  Pull in ** positive ** values 
		use data-real-all-with-sg-pgard-resample if ernq>0 , clear
		
		** Create quarters by group variable
		egen sgvar = group(`varname' quarter)		

		** Create dummies for quarter by group below in regressions
		tab sgvar, gen(sgvardm)

		* Tab sgvar to get number of subgroups and quarters
		tab sgvar

		** Save local numsg is number of subgroups and quarters
		local numsg = _result(2)

		** Only keep what we need
		**     `varname' is name of subgroups
		keep `varname' quarter sgvar* ernq e
 
		** Betahat is going to contain mean subgroup by qtr treatment control difference
		** FROM PERMUTED DATA
		gen double betahat = .

		* Figure out number of control obs to use in setting up "fake" treatment
		su e if ernq > 0 & e == 0
		local ncont = r(N)
		di "ncont is `ncont'"
		* Create "fake" treatment>
		gen double rnd = uniform()
		* Sort random number generator
		sort rnd
		** Rename real e so can check 
		rename e ereal
		** Drop non zero obs here *** DROP SO WE PERMUTE
		** ONLY POSITIVE EARNINGS 
		drop if ernq==0
		gen e = _n> `ncont'
		* Check e is defined, same number of obs as real e
		*di "tab e ereal"
		tab e ereal
		tab e 
		tab ereal

		*** Run regressions by subgroup and qtr to get mean effect by subgroup and qtr
		forvalues s = 1 / `numsg' {
			*** OlS to get conditional mean difference
			reg ernq e if sgvar == `s' & ernq > 0 
			* Save betahats for later for each subgroup and qtr
			replace betahat = _b[e] if sgvar == `s' & ernq > 0 
			} /* end of numsg loop */	

		** Create permutation data variables for simulated and true treatment group values

		* The simulated treatment variable is earnings plus treatment-control 
		*  mean difference for control group
		gen double yisim = ernq + betahat if e == 0 & ernq > 0 

		* The true treatment group variable is earnings for treatment group
		gen double yitrue = ernq if e == 1 & ernq > 0 

		** this is one of permutation calculations so realdata dummy is 0, bsrep is bsrep
		gen realdata=0
		gen bsrep=`bsrep'

		pause off

		** Save permutation data results
		** Keep only stuff we need
		keep yisim yitrue e realdata bsrep `varname' quarter sgvar 
		if `bsrep' == 1 {
			save results/bs-test-ourdata-pgard-resample-`varname', replace
			}
		else {
			append using results/bs-test-ourdata-pgard-resample-`varname'
			save results/bs-test-ourdata-pgard-resample-`varname', replace
			}
		} /* end of bootstrap loop */
	} /* end of quietly loop */

	*** Put real and permutation data together
	use results/nobs-test-ourdata-pgard-resample-`varname', clear
	append using results/bs-test-ourdata-pgard-resample-`varname'

	*** NOTE bsg is just combination of bsrep and realdata group
	*** no by T/C group status, are just doing KS of real and sim data
	egen bsg = group(realdata bsrep)
	* su bsg

	sort realdata bsrep
	save results/results-test-permutations-pgard-resample-`varname', replace

	**************************
	***** KS tests         ***
	***** UNROUNDED        ***
	***** Within Subgroup/quarter  ***
	**************************

	/* start of another quietly loop */
	qui {

	*** remind self how many subgroups
	su sgvar
	local numsg = r(max)
	di "`numsg'"
	*** loop through values of SGVAR for this subgroup/quarter
	/* start of sgvarval loop */
	forvalues sgvarval = 1/`numsg' { 

	*** number of observations	
	*** defined at top	
	*** number of BSREPS B	
	*** defined in bsrep in loop above	
	
	use results/results-test-permutations-pgard-resample-`varname' if sgvar == `sgvarval', clear	
	
	* Count bsreps done to check didn't die, shouldn't be a problem here
	su bsrep	
	local bsnum = r(max)	
	di "bsnum is `bsnum'"	
	* If empty draw, then skip 	
	if "`bsnum'" ==  "." {	
		di "skipping out of loop for sgvar value `sgvarval'"	
		exit	
		}
	
	** Create a combined variable so we can get differences in CDFs 
	**	at all values of y in either treatment or control group
	**	within subgroups
	** Will use to fill in values of CDFs for yisim at Y values in yitrue 
	**	and vice verse

	** yicombined need only have unique values of earnings within subgroups
	gen tmpcombined = yitrue if e == 1
	replace tmpcombined=yisim if e == 0	
	** Get unique values of yitrue and yisim within bsg by treatment group indicator
	egen groupcombined = group(tmpcombined bsg e)
	** Tag first value of groupcombined to use for CDF comparison
	egen tagcombined = tag(groupcombined)
	** Generate yicombined, defined for unique ys in yitrue/yisim
	gen double  yicombined = yitrue if yitrue < . & tagcombined ==1
	replace yicombined = yisim if yisim < . & tagcombined ==1

	* Get cumulative distributions, use equal option for ties for yitrue and yisim
	** Sort within bsg (realdata/bsrep)	
	bysort bsg: cumul yitrue , gen(cyitrue) equal	
	bysort bsg: cumul yisim , gen(cyisim) equal	

	** Keep only unique values
	keep if yicombined < .

	* Sort by bsg and then value of y so can fill in CDF of yitrue where no 
	* 	yitrue values exist in real yitrue distribution 
	** and vice verse	
	sort bsg yicombined	
	* Define _n as id within bsg, will use this to carry over values of 
	*	cyitrue/cyisim where they aren't defined
	by bsg: gen id = _n	

	*** Set up tsset to be bsg group by id	
	tsset bsg id	

	*** Fill in value for cyitrue/cyisim, if missing, is the last lowest CDF value for this group
        replace cyisim = L.cyisim if cyisim  ==  .	
        replace cyitrue = L.cyitrue if cyitrue  ==  . 	

	*** If no lagged value replace with 0, as no yitrue/yisim in this bsg group yet
	*** had a value less than this	
	*** Check first is earliest obs
	su id if cyisim  ==  0
	su id if cyitrue  ==  0
	replace cyisim = 0 if cyisim == .	
	replace cyitrue = 0 if cyitrue == .	

	* Define discrepancy to be difference in cdfs
	capture drop discrep	
	gen double discrep = cyisim-cyitrue	
	su discrep	
	gen double absdiscrep=abs(discrep)	
	* Get it defined everywhere, by bsg group
	egen ks = max(absdiscrep), by(bsg)	
	*pause	

	** List for several bsg groups to check	
	tab bsg if bsg<10, su(ks)	

	** sort KS
	sort ks	

	** Only need to keep 1 ob per bsg/sgvarvalue
	keep if id == 1	
	
	* Do reporting before save	
	* Not real data
	gen notrealdata=1-realdata	
	
	* To get critical value sort by notrealdata ks 	
	* (so first ob is realdata and rest are sorted by ks)	
	sort notrealdata ks 	
	*pause	
	* Set size of tests	 if 1 at a time
	local size1 = 0.01	
	local size2 = 0.02	
	local size3 = 0.05	
	local size4 = 0.10	
	local size5 = 0.15	
	
	* Set orderstat1	
	local orderstat1_index = ceil(int((1-`size1') * (`bsnum' + 1)))	
	di "`orderstat1_index' is orderstat1"	

	* Set orderstat2	
	local orderstat2_index = ceil(int((1-`size2') * (`bsnum' + 1)))	
	*di "`orderstat2_index' is orderstat2"	

	* Set orderstat3	
	local orderstat3_index = ceil(int((1-`size3') * (`bsnum' + 1)))	
	*di "`orderstat3_index' is orderstat3"	

	* Set orderstat4	
	local orderstat4_index = ceil(int((1-`size4') * (`bsnum' + 1)))	
	*di "`orderstat4_index' is orderstat4"	

	* Set orderstat5	
	local orderstat5_index = ceil(int((1-`size5') * (`bsnum' + 1)))	
	*di "`orderstat5_index' is orderstat5"	

	* We reject if actual data S > S_[orderstat + 1] (b/c first observation is realdata)	
	if ks[1] > ks[`orderstat1_index'+1] {	
		local not1 ""	
		local not2 ""	
		local not3 ""	
		local not4 ""	
		local not5 ""	
		}	
	else if ks[1] > ks[`orderstat2_index'+1] {	
		local not1 "not"	
		local not2 ""	
		local not3 ""	
		local not4 ""	
		local not5 ""	
		}	
	else if ks[1] > ks[`orderstat3_index'+1] {	
		local not1 "not"	
		local not2 "not"	
		local not3 ""	
		local not4 ""	
		local not5 ""	
		}	
	else if ks[1] > ks[`orderstat4_index'+1] {	
		local not1 "not"	
		local not2 "not"	
		local not3 "not"	
		local not4 ""	
		local not5 ""	
		}	
	else if ks[1] > ks[`orderstat5_index'+1] {	
		local not1 "not"	
		local not2 "not"	
		local not3 "not"	
		local not4 "not"	
		local not5 ""	
		}	
	else if ks[1]<=ks[`orderstat5_index'+1] {	
		local not1 "not"	
		local not2 "not"	
		local not3 "not"	
		local not4 "not"	
		local not5 "not"	
		}	

	di 	
	di "Test for `varname' for subgroup value `sgvarval'"
	di "Test for null control plus mean = treatment"	
	di "Result of test is to ``not1'' reject null hypothesis at size `size1'"	
	di "Result of test is to ``not2'' reject null hypothesis at size `size2'"	
	di "Result of test is to ``not3'' reject null hypothesis at size `size3'"	
	di "Result of test is to ``not4'' reject null hypothesis at size `size4'"	
	di "Result of test is to ``not5'' reject null hypothesis at size `size5'"	
	di	
	di "Real-data KS statistic is " round(ks[1], .0001)	
	di "Critical value 1 is " round(ks[`orderstat1_index'], .0001)	
	di "Critical value 2 is " round(ks[`orderstat2_index'], .0001)	
	di "Critical value 3 is " round(ks[`orderstat3_index'], .0001)
	di "Critical value 4 is " round(ks[`orderstat4_index'], .0001)	
	di "Critical value 5 is " round(ks[`orderstat5_index'], .0001)	
	di "Number of bsreps is `bsnum'"	
	di ""	

	* Create values of critical values to save	
	tempvar tmp1 tmp2 tmp3 tmp4 tmp5	
	gen `tmp1' = ks[`orderstat1_index']	
	egen crit1 = max(`tmp1')			
	gen size1 = `size1'	
 	gen `tmp2' = ks[`orderstat2_index']	
	egen crit2 = max(`tmp2')			
	gen size2 = `size2'	
	gen `tmp3' = ks[`orderstat3_index']	
	egen crit3 = max(`tmp3')			
	gen size3 = `size3'	
	gen `tmp4' = ks[`orderstat4_index']	
	egen crit4 = max(`tmp4')			
	gen size4 = `size4'	
	gen `tmp5' = ks[`orderstat5_index']	
	egen crit5 = max(`tmp5')			
	gen size5 = `size5'	

	* Get out p-value	
	sort ks	
	capture drop tmp tmp2	
	gen tmp = _n if realdata == 1	
	egen tmp2=max(tmp)	
	gen pvalue= 1-tmp2/(`bsnum'+1)	
	*pause
	di "P-value is  :"  round(pvalue,.00001)	

	* Now keep only realdata observations so can save for later	
	keep if id == 1 & realdata == 1	

	keep realdata ks crit* size* pvalue sgvar
	**keep value of sgvar
	gen sgvarvalue = `sgvarval'
	gen bonf5percent = .05/`numsg'
	gen bonf1percent = .01/`numsg'
	
	label variable sgvarvalue "value of subgroup variable"
	label variable bonf5percent "Bonferroni 5\% adjusted p-value, divide by `numsg'"
	label variable bonf1percent "Bonferroni 1\% adjusted p-value, divide by `numsg'"

	if `sgvarval'==1 {
	   save results/sgnullsubsample-test-ourdata-pgard-resample`varname', replace	
	   }
	else    {
	   append using  results/sgnullsubsample-test-ourdata-pgard-resample`varname'
	   save  results/sgnullsubsample-test-ourdata-pgard-resample`varname', replace	
	   }

	   } /* end of sgvarval loop */

	   }
	   /* end of quietly loop */


	   di "P-values and adjusted crit values for subgroup `varname' and quarter are as follows"
	   list bonf* pvalue* sgvarvalue

	} /* end of foreach loop */

******************************************************************************
*** Take results of pgard test within subgroups
*** Report info for table
******************************************************************************
** order in table
foreach varname in all ed ykid mh pq7e npqe wh race ed_ykid ed_mh pq7e_ed npqe_ed ed_wh ykid_mh  ///
	pq7e_ykid  npqe_ykid wh_ykid  pq7e_mh npqe_mh  wh_mh  pq7e_npqe  pq7e_wh npqe_wh  {
	di " ------------------"
	di " "
	di " "

	qui use  results/sgnullsubsample-test-ourdata-pgard-resample`varname', clear
	qui tab sgvar
	local numsg = _result(2)

	*** Smallest p value UNADJUSTED
	egen unadjminp = min(pvalue)

	*** Smallest p value UNADJUSTED
	*** 0 is <=1/3000
	gen unadjminpalt=unadjminp
	replace unadjminpalt=1/3000 if unadjminp==0

	*** p value UNADJUSTED
	*** 0 is really <=1/3000
	gen unadjpvalalt = pvalue
	replace unadjpvalalt = 1/3000 if pvalue==0

	*** P value adjusted
	*** multiply by numsg
	gen adjpvalalt = min(unadjpvalalt* `numsg',1)

	*** Min value adjusted
	*** multiply by numsg
	gen adjminpvalalt = min(unadjminpalt* `numsg',1)

	qui gen reject1 = adjpvalalt<.01

	qui gen reject5 = adjpvalalt<.05

	qui gen reject10 = adjpvalalt<.1

	qui gen unadjreject5 = unadjpvalalt<.05
	qui egen numunadjrej5 = sum(unadjreject5)

	egen numrej10 = sum(reject10)
	egen numrej5 = sum(reject5)
	egen numrej1 = sum(reject1)

	di "Group is `varname', number of tests is `numsg'"
	di "n adj 1\% rej,  n adj 5\% rej, unadj min pval, unadj min p alt"
	list numrej1  numrej5 unadjminp unadjminpalt if _n==1	
	di "n adj 10% rej, adjusted min p"
	list numrej10 adjminpvalalt if _n==1
	di "su unadjusted pvalues and adjusted pvals"
	su unadjpvalalt adjpvalalt
	di "number unadjusted rejecting at 5\% level is"
	di numunadjrej5
	di "0 pval corresponds to"
	di (1/3000)*`numsg'
*	pause
	} /* end of foreach loop */	
	
