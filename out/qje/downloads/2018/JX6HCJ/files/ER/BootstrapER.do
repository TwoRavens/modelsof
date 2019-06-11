
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust]
	tempvar touse newcluster
	gettoken testvars anything: anything, match(match)
	`anything' `if' `in', cluster(`cluster') `robust'
	testparm `testvars'
	global k = r(df)
	gen `touse' = e(sample)
	mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); V = sqrt(diagonal(V)); BB = B[1,1..$k]',V[1..$k,1]; st_matrix("B",BB)
	mata ResF = J($reps,4,.); ResB = J($reps,$k,.); ResSE = J($reps,$k,.)
	set seed 1
	forvalues i = 1/$reps {
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		preserve
			if ("$cluster" ~= "") {
				bsample if `touse', cluster($cluster) idcluster(`newcluster')
				capture `anything', cluster(`newcluster') `robust'
				}
			else {
				bsample if `touse' 
				capture `anything', `robust'
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

global cluster = "id"

use DatER, clear

global i = 1
global j = 1

*TABLE 6
mycmd (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
mycmd (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dmaskin dfordon if dhighskill == 0, cluster (id)
mycmd (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dgym dred dsjuk if dhighskill == 1, cluster (id)

*TABLE 7 
mycmd (arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
mycmd (arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)
mycmd (arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)
mycmd (arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
mycmd (arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)
mycmd (arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)
mycmd (arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
mycmd (arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)
mycmd (arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)
mycmd (duration2 erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback duration2 erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
mycmd (duration2 erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis) probit callback duration2 erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)
mycmd (duration2 erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback duration2 erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)

*TABLE 8
mycmd (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if kvinna==0, cluster (id)
mycmd (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if kvinna==1, cluster (id)
mycmd (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if min==0, cluster (id)
mycmd (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if min==1, cluster (id)

*TABLE 9 
mycmd (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
mycmd (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)
mycmd (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)

use ip\BS1, clear
forvalues i = 2/22 {
	merge using ip\BS`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/22 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\BootstrapER, replace

use results\BootstrapER, clear
foreach var in ResF {
	forvalues i = 1/3 {
		local j = `i' + 22
		generate double `var'`j' = `var'`i'
		}
	}
foreach var in ResB ResSE {
	forvalues i = 1/62 {
		local j = `i' + 405
		generate double `var'`j' = `var'`i'
		}
	}
foreach var in B1 B2 {
	forvalues i = 1/62 {
		local j = `i' + 405
		quietly replace `var' = `var'[`i'] if _n == `j'
		}
	}
aorder
save results\BootstrapER, replace

