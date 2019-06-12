
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	if ("`absorb'" == "") `anything' `if' `in', cluster(`cluster') `robust'
	if ("`absorb'" ~= "" & "`cluster'" ~= "") `anything' `if' `in', cluster(`cluster') `robust' absorb(`absorb')
	if ("`absorb'" ~= "" & "`cluster'" == "") `anything' `if' `in', `robust' absorb(`absorb')
	testparm `testvars'
	global k = r(df)
	unab testvars: `testvars'
	mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); V = sqrt(diagonal(V)); BB = B[1,1..$k]',V[1..$k,1]; st_matrix("B",BB)
preserve
	keep if e(sample)
	if ("$cluster" ~= "") egen M = group($cluster)
	if ("$cluster" == "") gen M = _n
	quietly sum M
	global N = r(max)
	mata ResB = J($N,$k,.); ResSE = J($N,$k,.); ResF = J($N,3,.)
	forvalues i = 1/$N {
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		if ("`absorb'" == "") quietly `anything' if M ~= `i', cluster(`cluster') `robust'
		if ("`absorb'" ~= "" & "`cluster'" ~= "") quietly `anything' if M ~= `i', cluster(`cluster') `robust' absorb(`absorb')
		if ("`absorb'" ~= "" & "`cluster'" == "") quietly `anything' if M ~= `i', `robust' absorb(`absorb')
		matrix BB = J($k,2,.)
		local c = 1
		foreach var in `testvars' {
			capture matrix BB[`c',1] = _b[`var'], _se[`var']
			local c = `c' + 1
			}
		matrix F = J(1,3,.)
		capture testparm `testvars'
		if (_rc == 0) matrix F = r(p), r(drop), e(df_r)
		mata BB = st_matrix("BB"); F = st_matrix("F"); ResB[`i',1..$k] = BB[1..$k,1]'; ResSE[`i',1..$k] = BB[1..$k,2]'; ResF[`i',1..3] = F
		}
	quietly drop _all
	quietly set obs $N
	global kk = $j + $k - 1
	forvalues i = $j/$kk {
		quietly generate double ResB`i' = .
		}
	forvalues i = $j/$kk {
		quietly generate double ResSE`i' = .
		}
	quietly generate double ResF$i = .
	quietly generate double ResD$i = .
	quietly generate double ResDF$i = .
	mata X = ResB, ResSE, ResF; st_store(.,.,X)
	quietly svmat double B
	quietly rename B2 SE$i
	capture rename B1 B$i
	save ip\JK$i, replace
restore
	global i = $i + 1
	global j = $j + $k
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

use ip\JK1, clear
forvalues i = 2/40 {
	merge using ip\JK`i'
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
save results\JackKnifeAKL, replace


