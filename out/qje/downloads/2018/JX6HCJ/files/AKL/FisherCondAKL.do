
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) absorb(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" ~= "" & "`cluster'" ~= "") {
		`anything' `if' `in', cluster(`cluster') absorb(`absorb')
		}
	else if ("`absorb'" ~= "" & "`cluster'" == "") {
		`anything' `if' `in', `robust' absorb(`absorb')
		}
	else {
		`anything' `if' `in', cluster(`cluster')
		}
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$ii,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		foreach var in `testvars' {
			matrix B[$jj+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global ii = $ii + 1
global jj = $jj + $k
end

****************************************
****************************************

use DatAKL1, clear

matrix F = J(40,4,.)
matrix B = J(49,2,.)

global ii = 1
global jj = 1

*Table 3
foreach outcome in writezscore mathzscore {
	mycmd (abcpost) reg `outcome' abcpost abc post if (round==1|round==2|round==4), robust cluster(codev)
	mycmd (abcpost) reg `outcome' abcpost abc post cohort2009 female age dosso if (round==1|round==2|round==4), robust cluster(codev)
	mycmd (abcpost) areg `outcome' abcpost abc post cohort2009 female age if (round==1|round==2|round==4), absorb(avcode) robust cluster(codev)
	mycmd (abcpost) areg `outcome' abcpost post female age if (round==1|round==2|round==4), absorb(codev) robust cluster(codev)
	}

*Table 4 
foreach outcome in writezscore mathzscore {
	mycmd (abcpost abcregionpost) reg `outcome' abcpost abcregionpost abc regionabc region post regionpost cohort2009 female age if (round==1|round==2|round==4), robust cluster(codev)  
	mycmd (abcpost abcfemalepost) areg `outcome' abcpost abcfemalepost abc femaleabc female post femalepost cohort2009 age if (round==1|round==2|round==4), absorb(avcode) robust cluster(codev) 
	mycmd (abcpost abcyoungpost) areg `outcome' abcpost abcyoungpost abc youngabc young post youngpost cohort2009 female age if (round==1|round==2|round==4), absorb(avcode) robust cluster(codev)
	}

*Table 5
foreach outcome in writezsc mathzsc {
	mycmd (abcpost abcpost6m) areg `outcome' abcpost abcpost6m abc post post6m cohort2009 female age, absorb(avcode) robust cluster(codev)
	}

*Table 6
foreach outcome in teacherdaysy1 teacherdaysy1m34 percentattendy1 percentattendy1m34 percentattendy2 {
	mycmd (abc) areg `outcome' abc, absorb(avcode) robust cluster(codev)
	}

*Table 7
foreach outcome in percentattend34 {
	mycmd (abc highlevela) areg `outcome' abc highlevela highlevel cohort2009 female if time==2, absorb(avc) robust cluster(codev)
	}

gen Strata = .
forvalues i = 1/114 {
	local j = Y1[`i']
	quietly replace Strata = `j' if codevillage == Y3[`i']
	}

global i = 0

*Tables 3 - 5
forvalues j = 1/24 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}

*Table 6
foreach outcome in teacherdaysy1 teacherdaysy1m34 percentattendy1 percentattendy1m34 percentattendy2 {
	global i = $i + 1
	randcmdc ((abc) areg `outcome' abc, absorb(avcode) robust cluster(codev)), treatvars(abc) strata(Strata) groupvar(codevillage) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

*Table 7
forvalues j = 1/2 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}

******************************************

use DatAKL2, clear

*Table 8 
mycmd (abc) areg hotline abc cohort2009, absorb(avcode) robust
mycmd (abc) areg hotline abc cohort2009 if highlevel==1, absorb(avcode) robust
mycmd (abc) areg hotline abc cohort2009 if lowlevel==1, absorb(avcode) robust

*Reproducing systematic codeing error in this data file
global calc = "calc1(replace abc = 0 if codevillage == 7120)"

gen Strata = .
forvalues i = 1/114 {
	local j = Y1[`i']
	quietly replace Strata = `j' if codevillage == Y3[`i']
	}

*Table 8 

global i = $i + 1
randcmdc ((abc) areg hotline abc cohort2009, absorb(avcode) robust), treatvars(abc) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample $calc

global i = $i + 1
randcmdc ((abc) areg hotline abc cohort2009 if highlevel==1, absorb(avcode) robust), treatvars(abc) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample $calc

global i = $i + 1
randcmdc ((abc) areg hotline abc cohort2009 if lowlevel==1, absorb(avcode) robust), treatvars(abc) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample $calc


*******************************

use DatAKL3, clear

*Table 9
foreach outcome in cellphoneowner usecellphone makecall receivecall writesms receivesms anybip madetransferSMS receivedtransferSMS communicate_migrant celltalkrelativeniger celltalktradeniger whycell_ceremony whycell_help whycell_priceinfo {
	mycmd (abc) areg `outcome' abc, absorb(avcode) robust cluster(codev)
	}

gen Strata = .
forvalues i = 1/114 {
	local j = Y1[`i']
	quietly replace Strata = `j' if codevillage == Y3[`i']
	}

*Table 9
foreach outcome in cellphoneowner usecellphone makecall receivecall writesms receivesms anybip madetransferSMS receivedtransferSMS communicate_migrant celltalkrelativeniger celltalktradeniger whycell_ceremony whycell_help whycell_priceinfo {
	global i = $i + 1
	randcmdc ((abc) areg `outcome' abc, absorb(avcode) robust cluster(codev)), treatvars(abc) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

matrix T = J($i,2,.)
use ip\a1, clear
mkmat __* in 1/1, matrix(a)
drop __*
matrix T[1,1] = a
rename ResB ResB1
rename ResSE ResSE1
rename ResF ResF1
forvalues i = 2/$i {
	merge using ip\a`i'
	mkmat __* in 1/1, matrix(a)
	drop __* _m
	matrix T[`i',1] = a
	rename ResB ResB`i'
	rename ResSE ResSE`i'
	rename ResF ResF`i'
	}
svmat double F
svmat double B
svmat double T
gen N = _n
sort N
compress
aorder
save results\FisherCondAKL, replace


