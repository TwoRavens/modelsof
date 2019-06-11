
*robust are same as cluster(codev) as only one observation per village there

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust absorb(string)]
	tempvar touse newcluster
	gettoken testvars anything: anything, match(match)
	if ("`absorb'" ~= "") {
		`anything' `if' `in', cluster(`cluster') `robust' absorb(`absorb')
		}
	else {
		`anything' `if' `in', cluster(`cluster') `robust'
		}
	if ("`absorb'" == "`cluster'") local absorb = "`newcluster'"
	testparm `testvars'
	global k = r(df)
	gen `touse' = e(sample)
	mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); V = sqrt(diagonal(V)); BB = B[1,1..$k]',V[1..$k,1]; st_matrix("B",BB)
	mata ResF = J($reps,4,.); ResB = J($reps,$k,.); ResSE = J($reps,$k,.)
	set seed 1
	forvalues i = 1/$reps {
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		preserve
			bsample if `touse', cluster($cluster) idcluster(`newcluster')
			if ("`absorb'" ~= "" & "`cluster'" ~= "") {
				capture `anything', cluster(`newcluster') `robust' absorb(`absorb')
				}
			else if ("`absorb'" ~= "" & "`cluster'" == "") {
				capture `anything', `robust' absorb(`absorb')
				}
			else {
				capture `anything', cluster(`newcluster') `robust'
				}
			if (_rc == 0) {
			capture mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); B = B[1,1..$k]; V = V[1..$k,1..$k]
			capture testparm `testvars'
			if (_rc == 0 & r(df) == $k) {
				mata t = (B-BB[1..$k,1]')*invsym(V)*(B'-BB[1..$k,1])
				if (e(df_r) == .) mata ResF[`i',1..3] = `r(p)', chi2tail($k,t[1,1]), $k - `r(df)'
				if (e(df_r) ~= .) mata ResF[`i',1...] = `r(p)', Ftail($k,`e(df_r)',t[1,1]/$k), $k - `r(df)', `e(df_r)'
				mata ResB[`i',1...] = B; ResSE[`i',1...] = sqrt(diagonal(V))'
				}
				}
		restore
		}
	preserve
		quietly drop _all
		quietly set obs $reps
		quietly generate double ResF$i = .
		quietly generate double ResFF$i = .
		quietly generate double ResD$i = .
		quietly generate double ResDF$i = .
		global kk = $j + $k - 1
		forvalues i = $j/$kk {
			quietly generate double ResB`i' = .
			}
		forvalues i = $j/$kk {
			quietly generate double ResSE`i' = .
			}
		mata X = ResF, ResB, ResSE; st_store(.,.,X)
		quietly svmat double B
		quietly rename B2 SE$i
		capture rename B1 B$i
		save ip\BS$i, replace
		global i = $i + 1
		global j = $j + $k
	restore
end


*******************

global cluster = "codev"

use DatAKL1, clear

global i = 1
global j = 1
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


*****************************
*****************************

use DatAKL2, clear

*Table 8 
mycmd (abc) areg hotline abc cohort2009, absorb(avcode) robust
mycmd (abc) areg hotline abc cohort2009 if highlevel==1, absorb(avcode) robust
mycmd (abc) areg hotline abc cohort2009 if lowlevel==1, absorb(avcode) robust

*****************************
*****************************

use DatAKL3, clear

*Table 9
foreach outcome in cellphoneowner usecellphone makecall receivecall writesms receivesms anybip madetransferSMS receivedtransferSMS communicate_migrant celltalkrelativeniger celltalktradeniger whycell_ceremony whycell_help whycell_priceinfo {
	mycmd (abc) areg `outcome' abc, absorb(avcode) robust cluster(codev)
	}

use ip\BS1, clear
forvalues i = 2/40 {
	merge using ip\BS`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/40 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\BootstrapAKL, replace

