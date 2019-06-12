

use Dataset_Hiringexperiment.dta, clear

*** GENERATING VARIABLES ***
gen arbetsloshet=0
replace arbetsloshet=1 if scarce==1
replace arbetsloshet=1 if parbetslos==1
replace arbetsloshet=1 if nuarblos==1 | nuarblos==2 | nuarblos==3
gen arbetsloshetnu=0
replace arbetsloshetnu=1 if nuarblos==1 | nuarblos==2 | nuarblos==3
gen arbetsloshetforr=0
replace arbetsloshetforr=1 if scarce==1 | parbetslos==1
gen duration=12*scarce+12*parbetslos+3*nuarblos
gen duration2=duration/12

gen arblosnu_0=0
replace arblosnu_0=1 if nuarblos==0
gen arblosnu_3=0
replace arblosnu_3=1 if nuarblos==1
gen arblosnu_6=0
replace arblosnu_6=1 if nuarblos==2
gen arblosnu_9=0
replace arblosnu_9=1 if nuarblos==3

gen erfar1=0
replace erfar1=1 if erfar==1
gen erfar2=0
replace erfar2=1 if erfar==2
gen erfar3_5=0
replace erfar3_5=1 if erfar==3 | erfar==4 | erfar==5

*Characteristics of the job
*Gothenberg, rest of Sweden:  dgbg dlandet 
*occupation of the job:  ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon
*Other characteristics of resume (separately randomized):  min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis 

*TABLE 6 - All okay

dprobit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
dprobit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if dhighskill==0, cluster (id)
dprobit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if dhighskill==1, cluster (id)

*Drop occupation variables that are redundant and treatment variable (utlgymn) that is set to 0 for low skill occupations

probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dmaskin dfordon if dhighskill == 0, cluster (id)
probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dgym dred dsjuk if dhighskill == 1, cluster (id)

*TABLE 7 - All okay

dprobit callback arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
dprobit callback arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if dhighskill==0, cluster (id)
dprobit callback arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if dhighskill==1, cluster (id)
dprobit callback arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
dprobit callback arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if dhighskill==0, cluster (id)
dprobit callback arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if dhighskill==1, cluster (id)
dprobit callback arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
dprobit callback arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if dhighskill==0, cluster (id)
dprobit callback arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if dhighskill==1, cluster (id)
dprobit callback duration2 erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
dprobit callback duration2 erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if dhighskill==0, cluster (id)
dprobit callback duration2 erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if dhighskill==1, cluster (id)

probit callback arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
probit callback arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)
probit callback arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)
probit callback arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
probit callback arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)
probit callback arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)
probit callback arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
probit callback arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)
probit callback arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)
probit callback duration2 erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
probit callback duration2 erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)
probit callback duration2 erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)


*TABLE 8 - All okay

dprobit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if kvinna==0, cluster (id)
dprobit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if kvinna==1, cluster (id)
dprobit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if min==0, cluster (id)
dprobit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if min==1, cluster (id)

probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if kvinna==0, cluster (id)
probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if kvinna==1, cluster (id)
probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if min==0, cluster (id)
probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if min==1, cluster (id)


*TABLE 9 - All okay

*Panel A reproduces regressions of Table 6 and reports different coefficients 
dprobit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
dprobit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if dhighskill==0, cluster (id)
dprobit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if dhighskill==1, cluster (id)

probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if dhighskill==0, cluster (id)
probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if dhighskill==1, cluster (id)


*Panel B
dprobit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
dprobit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if dhighskill==0, cluster (id)
dprobit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if dhighskill==1, cluster (id)


probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)
probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)

save DatER, replace







