
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', 
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string) robust ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', 
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end


****************************************
****************************************

global b = 405

use DatER, clear

matrix B = J($b,1,.)

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

egen M = group(id)
sum M
global reps = r(max)

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if M == `c'

global j = 1

*TABLE 6
mycmd1 (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
mycmd1 (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dmaskin dfordon if dhighskill == 0, cluster (id)
mycmd1 (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dgym dred dsjuk if dhighskill == 1, cluster (id)

*TABLE 7 
mycmd1 (arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
mycmd1 (arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)
mycmd1 (arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)
mycmd1 (arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
mycmd1 (arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)
mycmd1 (arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)
mycmd1 (arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
mycmd1 (arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)
mycmd1 (arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)
mycmd1 (duration2 erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback duration2 erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
mycmd1 (duration2 erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis) probit callback duration2 erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)
mycmd1 (duration2 erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback duration2 erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)

*TABLE 8
mycmd1 (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if kvinna==0, cluster (id)
mycmd1 (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if kvinna==1, cluster (id)
mycmd1 (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if min==0, cluster (id)
mycmd1 (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if min==1, cluster (id)

*TABLE 9 
mycmd1 (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
mycmd1 (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)
mycmd1 (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 1/$b {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
svmat double B
gen N = _n
save results\OJackknifeER, replace

*repeat regressions
foreach var in ResB {
	forvalues i = 1/62 {
		local j = `i' + 405
		generate double `var'`j' = `var'`i'
		}
	}
foreach var in B1 {
	forvalues i = 1/62 {
		local j = `i' + 405
		quietly replace `var' = `var'[`i'] if _n == `j'
		}
	}
aorder
save results\OJackknifeER, replace

