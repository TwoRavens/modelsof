
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', cluster(`cluster')
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$i,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end

use DatER, clear

matrix F = J(25,4,.)
matrix B = J(467,2,.)

*Characteristics of the job
*Gothenberg, rest of Sweden:  dgbg dlandet 
*occupation of the job:  ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon
*Other characteristics of resume (separately randomized):  min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis 

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

*Rooth, Dan-Olof 2010, (IZA discussion paper) indicates methodology is to input occupation, gender/ethnicity combination, geographic location and layout into computer which then randomizes treatment
*This amounts to making these strata (in examining data file, for example, can see that trip to US is only put in for high skilled occupations)
*Layout is not a characteristic in the regressions and is not reported in the data set
*Correspondence with Rooth confirmed that layout did not affect other characteristics

*Gender/ethnicity is an aspect of treatment, each job in cities received all three combinations of these, and occupation and location are characteristics of the job/resume
*Treat the combination of occupation and location as strata.  Randomization is done within these strata (i.e. given that the resume is going to have a certain occupation, location, gender/ethnicity randomly distributed across resumes and the computer is then randomly selecting the other attributes)

egen Strata = group(ddata dred dsjuk dsvso dmano dgym dftg dbutik dmaskin dbygg dfordon dlokal drest dsthlm dgbg dlandet)


global i = 0
*Table 6
foreach var in arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis {
	global i = $i + 1
	if ("`var'" ~= "min" & "`var'" ~= "kvinna") {
		local a = "Strata arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis"
		}
	else {
		local a = "id min kvinna"
		}
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(`a')
	randcmdc ((`var') probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis {
	global i = $i + 1
	if ("`var'" ~= "min" & "`var'" ~= "kvinna") {
		local a = "Strata arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis"
		}
	else {
		local a = "id min kvinna"
		}
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(`a')
	randcmdc ((`var') probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dmaskin dfordon if dhighskill == 0, cluster (id)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis {
	global i = $i + 1
	if ("`var'" ~= "min" & "`var'" ~= "kvinna") {
		local a = "Strata arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis"
		}
	else {
		local a = "id min kvinna"
		}
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(`a')
	randcmdc ((`var') probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dgym dred dsjuk if dhighskill == 1, cluster (id)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

*TABLE 7 
foreach var in arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis {
	global i = $i + 1
	if ("`var'" ~= "min" & "`var'" ~= "kvinna") {
		local a = "Strata arbetsloshet erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis"
		}
	else {
		local a = "id min kvinna"
		}
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(`a')
	randcmdc ((`var') probit callback arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis {
	global i = $i + 1
	if ("`var'" ~= "min" & "`var'" ~= "kvinna") {
		local a = "Strata arbetsloshet erfar antlarbetsg doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis"
		}
	else {
		local a = "id min kvinna"
		}
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(`a')
	randcmdc ((`var') probit callback arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis {
	global i = $i + 1
	if ("`var'" ~= "min" & "`var'" ~= "kvinna") {
		local a = "Strata arbetsloshet erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis"
		}
	else {
		local a = "id min kvinna"
		}
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(`a')
	randcmdc ((`var') probit callback arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis {
	global i = $i + 1
	if ("`var'" ~= "min" & "`var'" ~= "kvinna") {
		local a = "Strata arbetsloshetnu erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis"
		}
	else {
		local a = "id min kvinna"
		}
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(`a')
	randcmdc ((`var') probit callback arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis {
	global i = $i + 1
	if ("`var'" ~= "min" & "`var'" ~= "kvinna") {
		local a = "Strata arbetsloshetnu erfar antlarbetsg doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis"
		}
	else {
		local a = "id min kvinna"
		}
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(`a')
	randcmdc ((`var') probit callback arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis {
	global i = $i + 1
	if ("`var'" ~= "min" & "`var'" ~= "kvinna") {
		local a = "Strata arbetsloshetnu erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis"
		}
	else {
		local a = "id min kvinna"
		}
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(`a')
	randcmdc ((`var') probit callback arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis {
	global i = $i + 1
	if ("`var'" ~= "min" & "`var'" ~= "kvinna") {
		local a = "Strata arbetsloshetforr erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis"
		}
	else {
		local a = "id min kvinna"
		}
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(`a')
	randcmdc ((`var') probit callback arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis {
	global i = $i + 1
	if ("`var'" ~= "min" & "`var'" ~= "kvinna") {
		local a = "Strata arbetsloshetforr erfar antlarbetsg doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis"
		}
	else {
		local a = "id min kvinna"
		}
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(`a')
	randcmdc ((`var') probit callback arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis {
	global i = $i + 1
	if ("`var'" ~= "min" & "`var'" ~= "kvinna") {
		local a = "Strata arbetsloshetforr erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis"
		}
	else {
		local a = "id min kvinna"
		}
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(`a')
	randcmdc ((`var') probit callback arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in duration2 erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis {
	global i = $i + 1
	if ("`var'" ~= "min" & "`var'" ~= "kvinna") {
		local a = "Strata duration2 erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis"
		}
	else {
		local a = "id min kvinna"
		}
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(`a')
	randcmdc ((`var') probit callback duration2 erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in duration2 erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis {
	global i = $i + 1
	if ("`var'" ~= "min" & "`var'" ~= "kvinna") {
		local a = "Strata duration2 erfar antlarbetsg doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis"
		}
	else {
		local a = "id min kvinna"
		}
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(`a')
	randcmdc ((`var') probit callback duration2 erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in duration2 erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis {
	global i = $i + 1
	if ("`var'" ~= "min" & "`var'" ~= "kvinna") {
		local a = "Strata duration2 erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis"
		}
	else {
		local a = "id min kvinna"
		}
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(`a')
	randcmdc ((`var') probit callback duration2 erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

*TABLE 8
foreach var in arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis {
	global i = $i + 1
	if ("`var'" ~= "min" & "`var'" ~= "kvinna") {
		local a = "Strata arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis"
		}
	else {
		local a = "id min kvinna"
		}
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(`a')
	randcmdc ((`var') probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if kvinna==0, cluster (id)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis {
	global i = $i + 1
	if ("`var'" ~= "min" & "`var'" ~= "kvinna") {
		local a = "Strata arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis"
		}
	else {
		local a = "id min kvinna"
		}
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(`a')
	randcmdc ((`var') probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if kvinna==1, cluster (id)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis {
	global i = $i + 1
	if ("`var'" ~= "min" & "`var'" ~= "kvinna") {
		local a = "Strata arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis"
		}
	else {
		local a = "id min kvinna"
		}
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(`a')
	randcmdc ((`var') probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if min==0, cluster (id)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis {
	global i = $i + 1
	if ("`var'" ~= "min" & "`var'" ~= "kvinna") {
		local a = "Strata arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis"
		}
	else {
		local a = "id min kvinna"
		}
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(`a')
	randcmdc ((`var') probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if min==1, cluster (id)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

*TABLE 9 
foreach var in arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis {
	global i = $i + 1
	if ("`var'" ~= "min" & "`var'" ~= "kvinna") {
		local a = "Strata arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis"
		}
	else {
		local a = "id min kvinna"
		}
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(`a')
	randcmdc ((`var') probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis {
	global i = $i + 1
	if ("`var'" ~= "min" & "`var'" ~= "kvinna") {
		local a = "Strata arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis"
		}
	else {
		local a = "id min kvinna"
		}
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(`a')
	randcmdc ((`var') probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis {
	global i = $i + 1
	if ("`var'" ~= "min" & "`var'" ~= "kvinna") {
		local a = "Strata arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis"
		}
	else {
		local a = "id min kvinna"
		}
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(`a')
	randcmdc ((`var') probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
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
save results\FisherCondER, replace


use results\FisherCondER, clear
foreach var in ResB ResSE ResF {
	forvalues i = 1/62 {
		local j = `i' + 405
		generate double `var'`j' = `var'`i'
		}
	}
foreach var in F1 F2 F3 F4 {
	forvalues i = 1/3 {
		local j = `i' + 22
		quietly replace `var' = `var'[`i'] if _n == `j'
		}
	}
foreach var in B1 B2 T1 T2 {
	forvalues i = 1/62 {
		local j = `i' + 405
		quietly replace `var' = `var'[`i'] if _n == `j'
		}
	}
save results\FisherCondER, replace





